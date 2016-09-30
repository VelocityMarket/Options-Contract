// pricegeth.sol 0.8.0
// PriceGeth - Price API on Ethereum Blockchain
// Velocity.technology - Shayan Eskandari (shayan at bitaccess.co)
// https://github.com/VelocityMarket/pricegeth

pragma solidity ^0.4.0;

contract Pricegeth {

  uint public lastBlock;
  uint40 public firstBlock;

  //returns (USDBTC, BTCETH, BTCETC, BTCDOGE)
  function getPrices(uint blockNumber) constant returns (uint, uint, uint, uint);

  //returns (BlockNumber, timestamp) right before (<1s) the queried timestamp
  //prices can be queried using getPrices(BlockNumber) afterwards
  function queryTimestamp(uint40 timestamp) constant returns(uint, uint);

  // these functions returns (PRICE, Timestamp, Blocknumber)
  function USDBTC(uint blockNumber) constant returns (uint, uint, uint);
  function BTCETH(uint blockNumber) constant returns (uint, uint, uint);
  function BTCETC(uint blockNumber) constant returns (uint, uint, uint);
  function BTCDOGE(uint blockNumber) constant returns (uint, uint, uint);
}
