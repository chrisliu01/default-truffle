/**
What is ERC20?
Put simply, the ERC20 standard defines a set of functions to be implemented by all ERC20 tokens so as to allow integration with other contracts, wallets, or marketplaces. This set of functions is rather short and basic.

function totalSupply() public view returns (uint256);
function balanceOf(address tokenOwner) public view returns (uint);
function allowance(address tokenOwner, address spender)
public view returns (uint);
function transfer(address to, uint tokens) public returns (bool);
function approve(address spender, uint tokens)  public returns (bool);
function transferFrom(address from, address to, uint tokens) public returns (bool);

**/

/**

ERC20 functions allow an external user, say a crypto-wallet app, to find out a user’s balance and transfer funds from one user to another with proper authorization.

The smart contract defines two specifically defined events:

event Approval(address indexed tokenOwner, address indexed spender,
 uint tokens);
event Transfer(address indexed from, address indexed to,
 uint tokens);

**/


/**

In addition to standard ERC20 functions, many ERC20 tokens also feature additional fields and some have become a de-facto part of the ERC20 standard, if not in writing then in practice. Here are a few examples of such fields.

string public constant name;
string public constant symbol;
uint8 public constant decimals;

**/

/**

Here are a few points regarding ERC20 and Solidity nomenclature:

A public function can be accessed outside of the contract itself
view basically means constant, i.e. the contract’s internal state will not be changed by the function
An event is Solidity’s way of allowing clients e.g. your application frontend to be notified on specific occurrences within the contract

**/


pragma solidity >=0.4.21 <0.6.0;

/**

SafeMath Solidity Library
SafeMath is a Solidity library aimed at dealing with one way hackers have been known to break contracts: integer overflow attack. In such an attack, the hacker forces the contract to use incorrect numeric values by passing parameters that will take the relevant integers past their maximal values.

**/
library SafeMath {// Only relevant functions
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256)   {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract myEC20Token {

  /**
First, we need to define two mapping objects. This is the Solidity notion for an associative or key/value array:
**/

  mapping(address => uint256) balances;
  mapping(address => mapping(address => uint256)) allowed;

  /**
  Next, let us add the following statement introducing the library to the Solidity compiler:
  **/
  using SafeMath for uint256;


  /**

Setting the Number of ICO Tokens
How do we set the number of ICO tokens? Well, there are a number of ways of setting the maximal number of ICO tokens and this matter might be worth a lengthy discussion by itself.

For the needs of our ECR20 tutorial, we shall use the simplest approach: Set the total amount of tokens at contract creation time and initially assign all of them to the “contract owner” i.e. the account that deployed the smart contract:

**/
  uint256 totalSupply_;
  constructor(uint256 total) public {
    totalSupply_ = total;
    balances[msg.sender] = _totalSupply;
  }

  /**

This function will return the number of all tokens allocated by this contract regardless of owner.

**/

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**

get tokens of owner
**/
  function balanceOf(address tokenOwner) public view returns (uint) {
    return balances[tokenOwner];
  }


  /**

  transfer token from one to another
  **/
  function transfer(address receiver,
    uint numTokens) public returns (bool) {
    require(numTokens <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(numTokens);
    balances[receiver] = balances[receiver].add(numTokens);
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
  }


  /**

  approve function of token owner
  **/
  function approve(address delegate,
    uint numTokens) public returns (bool) {
    allowed[msg.sender][delegate] = numTokens;
    emit Approval(msg.sender, delegate, numTokens);
    return true;
  }

  /**
  get how many tokens allowed to withdraw
  **/
  function allowance(address owner,
    address delegate) public view returns (uint) {
    return allowed[owner][delegate];
  }

  /**
  transfer tokens by delegate
  **/
  function transferFrom(address owner, address buyer,
    uint numTokens) public returns (bool) {
    require(numTokens <= balances[owner]);
    require(numTokens <= allowed[owner][msg.sender]);
    balances[owner] = balances[owner].sub(numTokens);
    allowed[owner][msg.sender] = allowed[from][msg.sender].sub(numTokens);
    balances[buyer] = balances[buyer].add(numTokens);
    Transfer(owner, buyer, numTokens);
    return true;
  }
}
