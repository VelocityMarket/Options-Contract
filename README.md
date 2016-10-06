
## What is Velocity?
A distributed protocol project, Velocity aims to provide the ability to hedge risk on asset prices. This includes investors looking to speculate on future prices and market makers looking to profit from their liquidity. This is done using digital asset derivatives.

Unlike traditional derivatives that require a third party, Velocity utilizes smart contracts. By automating the settlement and clearing process, this reduces risk and eventually will lower cost.

# Options-Contract
To begin with, Velocity will start with an implementation of a simple collared option contract. In the future, we plan to add a variety of derivatives based on market dynamics.

This is used to offset the risk of an option contract by creating a “collar” above and below the original strike price. This limits the risk (and profit) to an option’s expiring price, reducing volatility for investors. Read more about this implementation in the [Velocity whitepaper](http://velocity.technology/doc/velocity_whitepaper.pdf).



### Latest Contract Address
Testnet Morden: [0x8FB92504bBa6FA57c176f67C01D9bcB05e9beB3E](https://testnet.etherscan.io/address/0x8FB92504bBa6FA57c176f67C01D9bcB05e9beB3E)

-------------------------


# Clients
## Online UI
UI designed to talk to the smart contract and visualize the price from [PriceGeth](https://github.com/VelocityMarket/pricegeth). This web-based interface uses [Metamask](metamask.io) chrome extension integration for easier use. You can also use your own way of connecting an Ethereum testnet RPC server to the browser (e.g Geth, web3 provider javascript injection, and probably CORS sharing).

[Velocity Demo](https://demo.velocity.technology/)

![Velocity UI Demo](https://pbs.twimg.com/media/CuCQoQjVIAA6Y6M.jpg)


## [Web3.js](https://github.com/ethereum/web3.js/) Client

##### Initiate the contract instance
```
var Web3 = require('web3');

var optionsABI = [{"constant":false,"inputs":[],"name":"immediateRefund","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"goLong","outputs":[{"name":"","type":"uint256"}],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"newMargin","type":"uint256"}],"name":"changeMargin","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"LockedBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"Margin","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newLOT","type":"uint256"}],"name":"changeLOT","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lastOptionId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newExpiryBlock","type":"uint256"}],"name":"changeBlocksToExpire","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"AllOptions","outputs":[{"name":"Short","type":"address"},{"name":"Long","type":"address"},{"name":"amount","type":"uint256"},{"name":"StartedAtBlock","type":"uint256"},{"name":"closed","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"blockNumber","type":"uint256"}],"name":"getPrices","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PriceGethAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"goShort","outputs":[{"name":"","type":"uint256"}],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"amount","type":"uint256"}],"name":"priceUnitFix","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"amount","type":"uint256"}],"name":"applyLOT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"findOptionId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"optionId","type":"uint256"}],"name":"exercise","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"fundMe","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"BlocksToExpire","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"LOT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"exercise","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"blockNumber","type":"uint256"}],"name":"getBTCETH","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"Error","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"LogMe","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"}],"name":"ShortOption","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"}],"name":"LongOption","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"optionPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtStart","type":"uint256"},{"indexed":false,"name":"ExpiredAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtExpire","type":"uint256"},{"indexed":false,"name":"Long","type":"address"},{"indexed":false,"name":"Short","type":"address"},{"indexed":false,"name":"TotalAmount","type":"uint256"},{"indexed":false,"name":"PriceDiff","type":"int256"}],"name":"settleLog","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"optionId","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtStart","type":"uint256"},{"indexed":false,"name":"ExpiredAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtExpire","type":"uint256"},{"indexed":false,"name":"Long","type":"address"},{"indexed":false,"name":"Short","type":"address"},{"indexed":false,"name":"TotalAmount","type":"uint256"}],"name":"debugPriceGeth","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"balance","type":"uint256"},{"indexed":false,"name":"lockedBalance","type":"uint256"}],"name":"debugBalance","type":"event"}]


if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

function initContract(contractAbi, contractAddress) {
  var MyContract = web3.eth.contract(contractAbi);
  var contractInstance = MyContract.at(contractAddress);
  var event = contractInstance.allEvents()
  console.log("listening for events on ", contractAddress)
  event.watch(function(error, result){ //This is where events can trigger changes in UI
    if (!error)
      console.log(result);
  });
  return contractInstance
}


OptionsContract = initContract(optionsABI, '0x8FB92504bBa6FA57c176f67C01D9bcB05e9beB3E')

```

##### Go short on the (next) block time
```
function goShort(contractInstance, margin){
  //go short with margin (which should be 0.00001 ETH * 1000 = 0.1 ETH -> 100000000000000000)
  contractInstance.goShort.sendTransaction({from: web3.eth.defaultAccount, value: margin, gas: 400000}, function(err, result){
  if (err){
    console.log(err);
    return err;
  }
  console.log("goShort: ", result);
  return result;
  // result is just transaction details, goShort details will be posted as an event !
  });
}

goShort(OptionsContract, 100000000000000000)
```

##### Go Long on the (next) block time
```
function goLong(contractInstance, margin){
  //go long with margin * LOT (which should be 0.00001 ETH * 1000 = 0.1 ETH -> 100000000000000000)
  contractInstance.goLong.sendTransaction({from: web3.eth.defaultAccount, value: margin, gas: 400000}, function(err, result){
  if (err){
    console.log(err);
    return err;
  }
  console.log("goLong: ", result);
  return result;
  // result is just transaction details, goLong details will be posted as an event !
  });
}

goLong(OptionsContract, 100000000000000000)
```

##### Settle (exercise) the last options called by web3.eth.defaultAccount
```
function exercise(contractInstance) {
  contractInstance.exercise.sendTransaction({from: web3.eth.defaultAccount, gas: 400000}, function(err, result){
  if (err){
    console.log(err);
    return err;
  }
  console.log("exercise: ", result);
  });
}
```

## [Web3.py](https://github.com/pipermerriam/web3.py) Client

##### Initiate the contract instance
```
from web3 import Web3, RPCProvider
import json

abi = '[{"constant":false,"inputs":[],"name":"immediateRefund","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"goLong","outputs":[{"name":"","type":"uint256"}],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"newMargin","type":"uint256"}],"name":"changeMargin","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"LockedBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"Margin","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newLOT","type":"uint256"}],"name":"changeLOT","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lastOptionId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newExpiryBlock","type":"uint256"}],"name":"changeBlocksToExpire","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"AllOptions","outputs":[{"name":"Short","type":"address"},{"name":"Long","type":"address"},{"name":"amount","type":"uint256"},{"name":"StartedAtBlock","type":"uint256"},{"name":"closed","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"blockNumber","type":"uint256"}],"name":"getPrices","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PriceGethAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"goShort","outputs":[{"name":"","type":"uint256"}],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"amount","type":"uint256"}],"name":"priceUnitFix","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"amount","type":"uint256"}],"name":"applyLOT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"findOptionId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"optionId","type":"uint256"}],"name":"exercise","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"fundMe","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"BlocksToExpire","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"LOT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"exercise","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"blockNumber","type":"uint256"}],"name":"getBTCETH","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"Error","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"LogMe","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"}],"name":"ShortOption","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"}],"name":"LongOption","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"optionPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"OptionId","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtStart","type":"uint256"},{"indexed":false,"name":"ExpiredAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtExpire","type":"uint256"},{"indexed":false,"name":"Long","type":"address"},{"indexed":false,"name":"Short","type":"address"},{"indexed":false,"name":"TotalAmount","type":"uint256"},{"indexed":false,"name":"PriceDiff","type":"int256"}],"name":"settleLog","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"optionId","type":"uint256"},{"indexed":false,"name":"StartedAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtStart","type":"uint256"},{"indexed":false,"name":"ExpiredAtBlock","type":"uint256"},{"indexed":false,"name":"PriceAtExpire","type":"uint256"},{"indexed":false,"name":"Long","type":"address"},{"indexed":false,"name":"Short","type":"address"},{"indexed":false,"name":"TotalAmount","type":"uint256"}],"name":"debugPriceGeth","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"balance","type":"uint256"},{"indexed":false,"name":"lockedBalance","type":"uint256"}],"name":"debugBalance","type":"event"}]'
abi_json = json.loads(abi)
def init_contract(abi_json, contract_address):

    this_contract = web3rpc.eth.contract(abi_json, address=contract_address)
    log.info("Contract at %s" % contract_address)
    return this_contract


this_contract = init_contract("0x8FB92504bBa6FA57c176f67C01D9bcB05e9beB3E")

```

##### Go short on the (next) block time
```
def goShort(this_contract, margin):
    send_transaction = this_contract.transact({"value":margin, "gas": 4000000}).goShort()
    log.info("goShort: %s" %send_transaction)

goShort(this_contract, margin = 100000000000000000)
```

##### Go Long on the (next) block time
```
def goShort(this_contract, margin):
    send_transaction = this_contract.transact({"value":margin, "gas": 4000000}).goLong()
    log.info("goLong: %s" %send_transaction)

goLong(this_contract, margin = 100000000000000000)
```

##### Settle (exercise) the last options called by web3.eth.defaultAccount
```
def exercise(this_contract, optionId= None):
    if optionId is not None:
        send_transaction = this_contract.transact({"gas": 4000000}).exercise(optionId)
    else:
        send_transaction = this_contract.transact({"gas": 4000000}).exercise()

    log.info("exercise : %s" %(send_transaction))

exercise(this_contract)

```
The way exercise function works is that it looks for the `msg.sender` to see if there's any unsettled options and will settle the first one it finds. There's also the possibility to pass OptionId to the function to settle a specific option.

## Do you want to know more?
- Check out our website [velocity.technology](http://velocity.technology)
- Join our [Slack Channel](http://velocity-slack.herokuapp.com/)
- Check out our [blog](http://blog.velocity.technology/)
