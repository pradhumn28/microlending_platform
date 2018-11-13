pragma solidity ^0.4.21;
import "./MicrolendingJoinVC.sol";


contract MicrolendingBorrowloan is MicrolendingJoinVC {
  mapping(string => mapping(address => MicrolendingPlatformDetails.vcDateDetails)) vcMemberLoanDateDetail;
  mapping(string => mapping(address => MicrolendingPlatformDetails.loanBorrowerDetail)) vcLoanBorrowerDetail;
  mapping(string => address[]) vcloanBorrowers;

  event vcMemberLoanRequest(string _vcName, address _membersAddress, uint _amount);
  event vcMemberLoanRequestAccepted(string _vcName, address _membersAddress);

  modifier AfterlastjoinDate(string _vcName) {
    checkVCstateON(_vcName);
    require(vc_Details[_vcName].lastJoinDate < now);
    if(vcAccount_Details[_vcName].totalMembers < 3) {
      vc_state[_vcName] = VCstate.paused;
      emit VCpaused(_vcName);
      revert();
    }
    _;
  }
  modifier beforelastreimbursementTime(string _vcName) {
    require(vcMemberLoanDateDetail[_vcName][msg.sender].lastreimbursementTime - 3 minutes > now);
    _;
  }

  function loanApprovalRequest(
    string _vcName,
    uint24 _borrowAmount,
    string _mortgageCertificate
    ) public AfterlastjoinDate(_vcName) beforelastreimbursementTime(_vcName) returns(bool) {
      _checkmemberDetails(msg.sender);
      _checkBorrowloanAmount(_vcName, _borrowAmount);
      MicrolendingPlatformDetails.loanBorrowerDetail memory _loanBorrowerDetail = MicrolendingPlatformDetails.loanBorrowerDetail(
        _borrowAmount,
        _borrowAmount,
        _mortgageCertificate,
        false);
      vcLoanBorrowerDetail[_vcName][msg.sender] = _loanBorrowerDetail;
      emit vcMemberLoanRequest(_vcName, msg.sender, _borrowAmount);
      return true;
}

  function loanRequestAccepted(string _vcName,address _memberAddress) public onlyAdmin(_vcName) returns(bool) {
    _checkloanRequestAccepted(_vcName,_memberAddress);
    vcLoanBorrowerDetail[_vcName][_memberAddress].loanAprroved = true;
    vcAccount_Details[_vcName].totalAmountremaining -= vcLoanBorrowerDetail[_vcName][_memberAddress].loanAmount;
    vcloanBorrowers[_vcName].push(_memberAddress);
    vcMemberLoanDateDetail[_vcName][_memberAddress].lastloanDepositeDate = now + 3 minutes;
    vcMemberLoanDateDetail[_vcName][_memberAddress].lastreimbursementTime = vcMemberLoanDateDetail[_vcName][_memberAddress].lastloanDepositeDate +  1 minutes;
    vcLoanBorrowerDetail[_vcName][_memberAddress].dueAmount = calculateDueAmount(vcLoanBorrowerDetail[_vcName][_memberAddress].loanAmount);
    emit vcMemberLoanRequestAccepted(_vcName, _memberAddress);
    return true;
  }

  function calculateDueAmount(uint24 _amount) internal pure returns(uint24) {
    return (_amount + (_amount/10));
  }

  function _checkBorrowloanAmount(string _vcName, uint _amount) private view returns(bool) {
    require(vcAccount_Details[_vcName].totalAmountremaining - _amount >= 0);
    return true;
  }

  function getVCsloanBorrower(string _vcName) public view returns(address[]) {
    return vcloanBorrowers[_vcName];
  }

  function _checkloanRequestAccepted(string _vcName, address _memberAddress) private view returns(bool) {
    require(vcLoanBorrowerDetail[_vcName][_memberAddress].loanAmount > 0);
    require(vcLoanBorrowerDetail[_vcName][_memberAddress].loanAprroved == false);
    checkVCstateON(_vcName);
    _checkmemberDetails(msg.sender);
    return true;
  }
}
