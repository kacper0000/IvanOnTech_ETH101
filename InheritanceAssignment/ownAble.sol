//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

contract ownAble {

    address payable public owner;    
    modifier onlyOwner{
        require(owner == msg.sender);
        _;
    }
    
    constructor(){
        owner = msg.sender;
    }
}
