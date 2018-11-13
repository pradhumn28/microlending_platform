pragma solidity ^0.4.21;
import "./MicrolendingStartVc.sol";


contract MicrolendingJoinVC is MicrolendingStartVc {
  mapping(string => address[]) vcMembers;
  mapping(string => mapping(address => MicrolendingPlatformDetails.investorDetail)) vcInvestorDetail;

  event vcMemberAddRequest(string _vcName, address _membersAddress, uint _amount);
  event vcMemberAddRequestAccepted(string _vcName, address _membersAddress);

  modifier lastJoinDateVC(string _vcName) {
    require(vc_Details[_vcName].lastJoinDate > now);
    _;
  }

  function joinVCRequest(
    string _vcName,
    uint24 _amount
    ) public lastJoinDateVC(_vcName) returns(bool) {
      checkVCstateON(_vcName);
      _checkmemberDetails(msg.sender);
      _checkAmountRequirement(_vcName, _amount);
      vcInvestorDetail[_vcName][msg.sender].investAmount = _amount;
      vcInvestorDetail[_vcName][msg.sender].investmentApproved = false;
      emit vcMemberAddRequest(_vcName, msg.sender, _amount);
      return true;
  }

  function joinVCAccept(
    string _vcName,
    address _membersAddress
    ) public onlyAdmin(_vcName) returns(bool) {
      _checkjoinVCAccept(_vcName, _membersAddress);
      vcInvestorDetail[_vcName][msg.sender].investmentApproved = true;
      vcMembers[_vcName].push(_membersAddress);
      vcAccount_Details[_vcName].totalMembers++;
      vcAccount_Details[_vcName].totalAmountVC += vcInvestorDetail[_vcName][msg.sender].investAmount;
      vcAccount_Details[_vcName].totalAmountremaining =vcAccount_Details[_vcName].totalAmountVC;
      emit vcMemberAddRequestAccepted(_vcName, _membersAddress);
      return true;
  }

  function getVCsMembers(string _vcName) public view returns(address[]) {
    return vcMembers[_vcName];
  }

  function getplatformMemberDetail(address _membersAddress) public view returns(string _name , bool _verified) {
    _name = members_Details[_membersAddress].name;
    _verified = members_Details[_membersAddress].verifiedmember;
  }

  function _checkAmountRequirement(string _vcName, uint24 _amount) private view returns(bool) {
    require(vc_Details[_vcName].minimumAmount < _amount);
    require(vc_Details[_vcName].maximumAmount > _amount);
    return true;
  }

  function _checkjoinVCAccept(string _vcName, address _membersAddress) private view returns(bool) {
    require(vcInvestorDetail[_vcName][_membersAddress].investAmount > 0);
    require(vcInvestorDetail[_vcName][_membersAddress].investmentApproved == false);
    checkVCstateON(_vcName);
    _checkmemberDetails(_membersAddress);
    return true;
  }
}
