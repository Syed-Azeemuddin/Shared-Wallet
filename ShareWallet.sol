// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./AllowanceforWallet.sol";


contract SimpleWallet is Ownable, Allowance{
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
        
    function withDrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        require(_amount <= address(this).balance,"Cannot withdraw more than Contract funds");
        if(msg.sender != owner()){
            reduceAllowance(msg.sender,_amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public override onlyOwner{
        revert("Can't renounce ownership here");
    }
    
    receive() external payable{
        emit MoneyReceived(msg.sender,msg.value);
    }

    
}