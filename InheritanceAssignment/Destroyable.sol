// SPDX-License-Identifier: MIT
import "./ownAble.sol";
pragma solidity >0.6.0;
contract Destroy is ownAble{
 function close() public onlyOwner { 
  selfdestruct(owner); 
 }
}
