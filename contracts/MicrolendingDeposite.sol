pragma solidity ^0.4.21;
import "./MicrolendingBorrowloan.sol";


contract MicrolendingDeposite is MicrolendingBorrowloan {
  event MoneyDeposited(string _vcName,address _memberAddress, uint24 _amountDeposite,uint24 _dueAmount);
  event RiembursementTimeUpdate(string _vcName,address _memberAddress,uint24 _dueAmount);

  mapping(string => mapping(address => bool)) riembursementUpdate;

  modifier riembursementTime(string _vcName) {
    if(vcMemberLoanDateDetail[_vcName][msg.sender].lastloanDepositeDate < now)
    if(riembursementUpdate[_vcName][msg.sender])
    {
      vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount = calculateDueAmount(vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount);
      riembursementUpdate[_vcName][msg.sender] = true;
    }
    require(vcMemberLoanDateDetail[_vcName][msg.sender].lastreimbursementTime > now);
    _;
  }

  function Deposite(string _vcName , uint24 _AmountDeposite) public returns(bool) {
    _checkDeposite(_vcName , _AmountDeposite);
    vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount -= _AmountDeposite ;
    vcAccount_Details[_vcName].totalAmountremaining += _AmountDeposite;
    emit MoneyDeposited(_vcName, msg.sender, _AmountDeposite,  vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount );
    return true;
  }

  function _checkDeposite(string _vcName , uint24 _AmountDeposite) private view returns(bool) {
    checkVCstateON(_vcName);
    require(vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount > 0);
    require(vcLoanBorrowerDetail[_vcName][msg.sender].dueAmount - _AmountDeposite >= 0);
    return true;
  }
}
