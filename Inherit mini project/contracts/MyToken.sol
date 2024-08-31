// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//This is really mini-project that allows to mint MT's to Store address that can sell tokens for ethers
// 1 ether can be converted to 10 MT
// Openzeppelin.../ERC20.sol is the parent contract of MyToken smart-contract
// in constructor which is a bit lower Store address mints 1000 MT's and then Store smart contract can sell 10 tokens for 1 ether
// Main idea of this project is to learn how to inherit smart contract and how to get benefits from it

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Mytoken is ERC20 {
    
    constructor(address _Vendor) ERC20("MyTok", "MT") {
        _mint(_Vendor, 1000 * (10**decimals()));
        
    }
    
}

contract Shop is Mytoken(address(this)) {
    
    uint256 constant  pricePerEth = 10;
    function checkl() public payable returns(uint256) {
        return msg.value;
    }
    function buyTokens() public payable {
        require(balanceOf(address(this)) >= msg.value, "wrong amount");
        _transfer(address(this), msg.sender, msg.value * pricePerEth);
    }
}
// Have done with that project for 1 hour