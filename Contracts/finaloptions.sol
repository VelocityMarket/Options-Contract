
// Velocity.technology - Shayan Eskandari (shayan at bitaccess.co)
// this version the smart contract should be funded using fundMe()
// Options Demo 0.8.2

pragma solidity ^0.4.0;

import "pricegeth.sol";
//import "github.com/VelocityMarket/pricegeth/contracts/pricegeth.sol";

contract finalOptions {

  struct Options {
    address Short;
    address Long;
    uint amount;
    uint StartedAtBlock;
    bool closed;
  }

  struct PriceDetails {
    uint blockStarted;
    uint blockExpired;
    uint priceAtBlockStarted;
    uint priceAtBlockExpired;
    int pricediff;
    uint priceDiffLOT;
  }

  mapping (uint => Options) public AllOptions;

  address private Owner;
  uint public Margin;
  address public PriceGethAddress;
  uint public BlocksToExpire;
  uint public lastOptionId;
  uint public LockedBalance;
  uint public LOT;

  //constructor
  function finalOptions(){
    Owner = msg.sender;
    PriceGethAddress = 0x0731729bb6624343958d05be7b1d9257a8e802e7;
    Margin = 10000000000000;//0.00001 eth
    BlocksToExpire = 5;
    LockedBalance = 0;
    LOT = 10000;
  }

  //modifiers
  modifier isOwner() { if (msg.sender != Owner) throw; _ ;}
  modifier hasEnoughFunds(uint amount) {
    if ((this.balance - LockedBalance >= (2 * amount))) { //balance has the incoming transaction value too
      _ ;} else {
      Error("Insufficient funds for new options");
      immediateRefund();}
  }
  modifier checkMargin(uint amount) {
    if (amount == (applyLOT(Margin)))
    { _ ;} else {
        Error("Invalid Margin!");
        immediateRefund();}
    }
  modifier isExpired(uint optionId) {
    if (AllOptions[optionId].StartedAtBlock + BlocksToExpire < block.number) {
      Error("Option not yet expired"); // does not do anything because of throw
      throw;}
       _ ;}

  modifier isOpen(uint optionId) {if (AllOptions[optionId].closed) throw; _ ;}

  //events
  event Error(string message);
  event LogMe(string message);
  event ShortOption(uint OptionId, address addr, uint amount, uint StartedAtBlock);
  event LongOption(uint OptionId, address addr, uint amount, uint StartedAtBlock);

  event optionPaid(uint OptionId, address addr, uint amount);
  event settleLog(uint OptionId, uint StartedAtBlock, uint PriceAtStart, uint ExpiredAtBlock, uint PriceAtExpire, address Long, address Short, uint TotalAmount, int PriceDiff);
  event debugPriceGeth(uint optionId, uint StartedAtBlock, uint PriceAtStart, uint ExpiredAtBlock, uint PriceAtExpire, address Long, address Short, uint TotalAmount);
  event debugBalance(uint balance, uint lockedBalance);

  //=================== pricegeth stuff =============================

    //get price at blockNumber's time
    //returns (USDBTC, BTCETH, BTCETC, BTCDOGE)
  function getPrices(uint blockNumber) constant returns(uint, uint, uint, uint){
      return Pricegeth(PriceGethAddress).getPrices(blockNumber);
    }

    //returns (PRICE, Timestamp, Blocknumber)
  function getBTCETH(uint blockNumber) constant returns(uint, uint, uint){
    return Pricegeth(PriceGethAddress).BTCETH(blockNumber);
  }
  //=================== / pricegeth stuff =============================

  function newOption(address addr, uint amount, bool long) private returns (uint id){
    Options memory tempOption;
    if (long) {
      tempOption.Long = addr;
      tempOption.Short = this;
    } else {
      tempOption.Short = addr;
      tempOption.Long = this;
    }
    tempOption.amount = amount;
    tempOption.closed = false;
    tempOption.StartedAtBlock = block.number; //sets starting block here

    //storage
    lastOptionId += 1;
    AllOptions[lastOptionId] = tempOption;
    LockedBalance += amount;

    return lastOptionId;
  }

  // goLong and goShort functions are simillar
  // they make a new option in AllOptions array and set up proper variables
  // this could be checked on UI using events Log and LogOption
  // it returns the optionId, which here would be lastOptionId
  function goLong() public hasEnoughFunds(msg.value) checkMargin(msg.value) payable returns(uint){
    lastOptionId = newOption(msg.sender, msg.value, true);
    //LogMe("new options with goLong initiated");
    LongOption(lastOptionId, msg.sender, msg.value, block.number);
    return lastOptionId;
  }

  function goShort() public hasEnoughFunds(msg.value) checkMargin(msg.value) payable returns(uint){
    lastOptionId = newOption(msg.sender, msg.value, false);
    //debugBalance(this.balance, LockedBalance);
    //LogMe("new options with goShort initiated");
    ShortOption(lastOptionId, msg.sender, msg.value, block.number);
    return lastOptionId;
  }


  //free function to search through AllOptions to find the option for msg.sender address
  function findOptionId(address addr) constant returns(uint){
    for (uint i = 1; i <= lastOptionId; i++) {
      if (((AllOptions[i].Long == addr) || (AllOptions[i].Short == addr)) && (!AllOptions[i].closed)){
        return i;
      }
    }
  }

  function applyLOT(uint amount) constant returns(uint){
    return (amount * LOT);
  }

  function priceUnitFix(uint amount) constant returns(uint){
    return (amount * 100000000);
  }

  function exercise() public {
    exercise(findOptionId(msg.sender));
  }

  function exercise(uint optionId) public isOpen(optionId) returns(bool) {
    //LogMe("exercise called");
    PriceDetails memory pricesToCheck;
    (pricesToCheck.priceAtBlockStarted, ,pricesToCheck.blockStarted) = getBTCETH(AllOptions[optionId].StartedAtBlock);
    (pricesToCheck.priceAtBlockExpired, ,pricesToCheck.blockExpired) = getBTCETH(AllOptions[optionId].StartedAtBlock + BlocksToExpire);
    //catch if any of the price gets from pricegeth is returning 0 (null) // this will prevent unexpire options to execute !
    if ((pricesToCheck.priceAtBlockStarted == 0) || (pricesToCheck.priceAtBlockExpired == 0)) {
      Error("Price has not been published by pricegeth yet, try again after a few blocks");
      debugPriceGeth(optionId, AllOptions[optionId].StartedAtBlock, pricesToCheck.priceAtBlockStarted, (AllOptions[optionId].StartedAtBlock + BlocksToExpire), pricesToCheck.priceAtBlockExpired, AllOptions[optionId].Long, AllOptions[optionId].Short, AllOptions[optionId].amount);
      return false;
    }

    pricesToCheck.priceAtBlockStarted = priceUnitFix(pricesToCheck.priceAtBlockStarted);
    pricesToCheck.priceAtBlockExpired = priceUnitFix(pricesToCheck.priceAtBlockExpired);

    // multiplier on priceDiff is because of how pricegeth works.
    //pricegeth multiplies the prices by 10^10 to make sure the end result is an integer and not float
    // margin here is 0.0001 ETH = 10^14
    // this multiplier can be assumed that the LOT here is  10000
    pricesToCheck.pricediff = int(pricesToCheck.priceAtBlockExpired - pricesToCheck.priceAtBlockStarted);
    pricesToCheck.priceDiffLOT = applyLOT(uint(pricesToCheck.pricediff));

    settleLog(optionId, pricesToCheck.blockStarted, pricesToCheck.priceAtBlockStarted, pricesToCheck.blockExpired, pricesToCheck.priceAtBlockExpired, AllOptions[optionId].Long, AllOptions[optionId].Short, AllOptions[optionId].amount, pricesToCheck.pricediff);
    AllOptions[optionId].closed = true; //flag the option as closed, doing this before payouts to prevent any kind of attack on same instance of the contarct
    LockedBalance -= AllOptions[optionId].amount; //release locked amount

    // Payout calculation
    // payAndHandle would ignore to pay if the payment is to this contract
    if (pricesToCheck.pricediff == 0) {
      //pay the same amount as invested
      return (payAndHandle(optionId, AllOptions[optionId].Long, AllOptions[optionId].amount) && payAndHandle(optionId, AllOptions[optionId].Short, AllOptions[optionId].amount));
    }

    if (pricesToCheck.pricediff >= (int(Margin))) { // diff >= (margin) -> Pay Long
        //pay long
        return payAndHandle(optionId, AllOptions[optionId].Long, 2 * AllOptions[optionId].amount);
    }

    if (pricesToCheck.pricediff <= (0 - (int(Margin)))) { // diff <= -(margin) -> Pay Short
      //pay short
      return payAndHandle(optionId, AllOptions[optionId].Short, 2 * AllOptions[optionId].amount);
    }

    if ((0 < pricesToCheck.pricediff) && (pricesToCheck.pricediff < (int(Margin)))) { // 0 < diff <  margin
      return (payAndHandle(optionId, AllOptions[optionId].Long, (AllOptions[optionId].amount + pricesToCheck.priceDiffLOT)) && payAndHandle(optionId, AllOptions[optionId].Short, (AllOptions[optionId].amount - pricesToCheck.priceDiffLOT)));
    }

    if ((pricesToCheck.pricediff < 0) && ((0 - (int(Margin)) < pricesToCheck.pricediff))) { // -(margin) < diff < 0
      return (payAndHandle(optionId, AllOptions[optionId].Long, (AllOptions[optionId].amount - (0 - pricesToCheck.priceDiffLOT)))  && payAndHandle(optionId, AllOptions[optionId].Short, (AllOptions[optionId].amount + (0 - pricesToCheck.priceDiffLOT))));

    }
  }

    function payAndHandle(uint optionId, address addr, uint amount) private returns (bool success) {
      if (addr == address(this)) {
        // skip payment if the payment is back to original contract, but triggers optionPaid event
        optionPaid(optionId, addr, amount); //event for successful payment
        return true;
      }
      if (addr.send(amount)) {
            optionPaid(optionId, addr, amount); //event for successful payment
      } else { throw;}
      return true;
    }


// ========================== Staging ====================================
    //TODO: remove these function for production!
    // just for testing purposes, the ability for the owner to change the main variables!
    function changeMargin(uint newMargin) public isOwner() {
      Margin = newMargin;
    }
    function changeLOT(uint newLOT) public isOwner() {
      LOT = newLOT;
    }
    function changeBlocksToExpire(uint newExpiryBlock) public isOwner() {
      BlocksToExpire = newExpiryBlock;
    }
  // ========================== / Staging ====================================


  //refund full value of incoming transaction
  function immediateRefund() payable returns (bool){
    if (msg.sender.send(msg.value)) {
      LogMe("incoming transaction refunded!");
      return true;
    } else { throw;}
  }


  //fund me function
  function fundMe() public payable {
    LogMe("main contract funded");
  }

  //rejector
  function() {  }


}
