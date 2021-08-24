// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;
pragma abicoder v2;

contract MultiSignWallet {
    address[] public owners;
    mapping(address => uint) balance;
    
    uint Approvlimit;
    struct Transfer{
        uint id;
        uint amount;
        address payable receiver;
        uint approvalsNeed;
        bool sent;
    }
    
    Transfer[] transferRequests;
    mapping(address => mapping(uint => bool)) approvals;
    
    event transferRequeststDone(uint id, uint amount, address initiator, address indexed requestedTo);
    event approvalDone(uint id, uint approvalsNeed, address approver);
    event transferDone(uint id, uint amount,address lastApprover, address senTo);
    //make sure only owner - addresse in owners array will call a certain function
    modifier onlyOwners{
        bool addressallowed = false;
        uint len = owners.length;
        //check if msg.sender is an owner.
        for(uint i=0; i<len; i++){
            if (msg.sender == owners[i]) addressallowed = true;
        }
        require(addressallowed = true, "You are not an owner of this wallet");
        _;
    }
    
    modifier differentOwners{
        uint len = owners.length;
        bool ownersNotSame = true;
        for(uint i=0; i<len; i++){
            for(uint j=i+1; j<len; j++){
                if (owners[i] == owners[j]) ownersNotSame = false;
            }
        }
        require(ownersNotSame = true);
        _;
    }
    
    constructor(address[] memory _owners) differentOwners {
        uint len = owners.length;
        bool ownersNotSame = true;
        for(uint i=0; i<len; i++){
            for(uint j=i+1; j<len; j++){
                if (owners[i] == owners[j]) ownersNotSame = false;
            }
        }
        require(ownersNotSame = true);
        if(_owners.length = 1) Approvlimit = 1;
        else  Approvlimit = _owners.length;
        owners = _owners;
    }
    function deposit() public payable {
    }
    function getYourBalance() public view returns(uint) {
        return msg.sender.balance;
    }
    function getContractsBalance() public view returns(uint) {
        return address(this).balance;
    }
    function getOwners() public view returns(address[] memory) {
        return owners;
    }
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        require(address(this).balance >= _amount, "Balance not sufficient");
        transferRequests.push(Transfer(transferRequests.length, _amount, _receiver, Approvlimit, false));
    }
    function approve(uint _id) public onlyOwners {
        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvalsNeed--;
        emit approvalDone(_id, transferRequests[_id].approvalsNeed, msg.sender);
        if(transferRequests[_id].approvalsNeed == 0){
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
            emit transferDone(_id, transferRequests[_id].amount, msg.sender, transferRequests[_id].receiver);
            //address(this).balance -= _amount; 
        }
    }
    function getTransferRequests() public view returns(Transfer[] memory){
        return transferRequests;
    }
}
