// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
import "./ownAble.sol";
import "./destroyable.sol";
contract BankETH is ownAble, Destroy {
    
    mapping(address=>uint) balance;
    
    event depositDone(uint amount, address indexed depositedTo);
    event transferMade(address from, address to, uint amounTransered);
    

    function deposit() public payable returns(uint){
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    function getBalance() public view returns(uint){
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public returns(uint){
        //require(amount <= balance[msg.sender]);
        msg.sender.transfer(amount);
        //balance[msg.sender] -= amount;
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public{
        //some important checks
        require(msg.sender != recipient);
        require(balance[msg.sender] >= amount);
        
        uint balanceBeforeTransfer = balance[msg.sender];
        _transfer(msg.sender, recipient, amount);
        
        //some other contract logic;
        assert(balanceBeforeTransfer == balance[msg.sender] + amount);
        emit transferMade(msg.sender, recipient, amount);
    }
    
    function _transfer(address from, address to, uint amount) private{
        balance[from] -= amount;
        balance[to] += amount;
    }
}
