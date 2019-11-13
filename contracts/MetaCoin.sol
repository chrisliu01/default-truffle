pragma solidity >=0.4.21 <0.6.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
  mapping (address => uint) balances;

  event Transfer(string method, address indexed _from, address indexed _to, uint256 _value, uint256 value_from, uint256 value_to);

  constructor() public {
    balances[tx.origin] = 10000;
  }

  function deposit(uint256 amount)  public payable{
    require(msg.value == amount);
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }

  function withdraw(uint256 amount) public payable{
    require(msg.value == amount);
    require(address(this).balance>amount);
    msg.sender.transfer(msg.value);
  }

  function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
    if (balances[msg.sender] < amount) return false;
    emit Transfer("before:", msg.sender, receiver, amount, balances[msg.sender], balances[receiver]);
    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit Transfer("after:", msg.sender, receiver, amount, balances[msg.sender], balances[receiver]);
    return true;
  }

  function sendEth(address payable receiver, uint amount) public payable returns(bool sufficient) {
    emit Transfer("before sendEth:", msg.sender, receiver, amount, balances[msg.sender], balances[receiver]);
    receiver.transfer(amount);
    emit Transfer("after afterEth:", msg.sender, receiver, amount, balances[msg.sender], balances[receiver]);
    return true;
  }

  function getBalanceInEth(address addr) public view returns(uint){
    return ConvertLib.convert(getBalance(addr),2);
  }

  function getBalance(address addr) public view returns(uint) {
    return balances[addr];
  }
}
