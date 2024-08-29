// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Main reason of this project is calling between two smart contracts and convert tokens

contract FirstCoin {
//mapping account => balance for the first coin
mapping (address => uint256)  balanceOfOne;
// total supply for the first coin 
uint256 totalSupply;
// mapping  account => allowed account to withdraw from the past account => allowed amount to withdraw  
mapping (address => mapping(address => uint256)) allowance;

// function that allows to mint any amounts of tokens for enybody

function mint(uint256 amount) public {
    balanceOfOne[msg.sender] += amount;
    totalSupply += amount;
}

// simple transfer that allows to transfer firstCoins between two accounts
// uses helpTransfer to not repeat the code below
function transfer(address _to, uint256 amount) external returns(bool){
   return helpTransfer(msg.sender, _to, amount);
}

// function that approves to someone spend allowed amount of FirstCoins
function approve(address spender, uint256 amount) external returns(bool) {
    
    allowance[msg.sender][spender] = amount;
    return true;
}

// function that allows to allowed account to transfer allowed ammount of firstCoins 
function transferFrom(address _from, address _to, uint256 amount) external returns(bool){
    if(msg.sender != _from) {
        require(allowance[_from][msg.sender] == amount,"insufficient funds");
        allowance[_from][msg.sender] -= amount;
    }

    return helpTransfer(_from, _to, amount);
}

// main transfer function that has all the requirements and has to be internal to not let anybody to transfer firstcoins 
function helpTransfer(address _from, address _to, uint256 amount) internal returns (bool){
     require(amount <= balanceOfOne[_from], "insufficient funds");
    require(_to != address(0),"Cannot send to zero address");
    balanceOfOne[_from] -= amount;
    balanceOfOne[_to] += amount;

    return true;
}

// simple view function that checks the balance
function checkBalance() public view returns(uint256) {
    return balanceOfOne[msg.sender];
}
// function trade allows to convert SecondCoins to FirstCoins
function trade(address source,uint256 amount) public returns(bool) {
    (bool ok,bytes memory result) = source.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",msg.sender, address(this), amount));
    require(ok,"transaction failed");
    balanceOfOne[msg.sender] += amount;
    totalSupply += amount;

    return abi.decode(result, (bool));
}

}
// Exactly the same code down below but for SecondCoin
contract SecondCoin {
 mapping(address => uint256) public balanceOfTwo;
 mapping (address => mapping(address => uint256)) allowance;
 uint256 totalSupply;
 
function trade(address source,uint256 amount) public returns(bool) {
    (bool ok, bytes memory result) = source.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this),amount));
    require(ok, "transaction failed");
    balanceOfTwo[msg.sender] += amount;
    totalSupply += amount;
    return abi.decode(result, (bool));
}

function transfer(address _to, uint256 amount) external returns(bool) {
    return helpTransfer(msg.sender, _to, amount);
}

function approve(address spender, uint256 amount) external returns(bool) {
    allowance[msg.sender][spender] += amount;

    return true;
}

function transferFrom(address _from, address _to, uint256 amount) external returns(bool) {
    if(msg.sender != _from) {
        require(allowance[_from][msg.sender] == amount, "insufficient funds");
        allowance[_from][msg.sender] -= amount;
    }

    return helpTransfer(_from, _to, amount);
}

function helpTransfer(address _from, address _to, uint256 amount) internal returns (bool){
    require(balanceOfTwo[_from] >= amount, "insufficient funds");
    require(_to != address(0), "Cannot send to zero address");
    balanceOfTwo[_from] -= amount;
    balanceOfTwo[_to] += amount;

    return true;
}

 function checkBalance() public view returns(uint256) {
    return balanceOfTwo[msg.sender];
 }

}