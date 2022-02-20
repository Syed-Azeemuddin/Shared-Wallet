// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Allowance is Ownable {

    using SafeMath for uint;

    event AllowanceChanged(address indexed _forWho, address indexed _byWho, uint _oldAmount, uint _newAmount);
    mapping(address => uint) public allowance;

    function setAllowance(address payable _who, uint _amount) public onlyOwner{  //add funds for an account
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount){
        require(msg.sender == owner() || allowance[msg.sender] >= _amount,"You are not allowed");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount){
        emit AllowanceChanged(_who, msg.sender, allowance[_who],allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub( _amount);
    }
}