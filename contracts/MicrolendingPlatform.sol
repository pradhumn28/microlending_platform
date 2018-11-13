pragma solidity ^0.4.21;
import "./MicrolendingEndVC.sol";


contract MicrolendingPlatform is MicrolendingEndVC {
  mapping(address => string) membersKYC;

  event MemberRegisteredOnPlatform(address _membersAddress, string _name);
  event MemberVerified(address _membersAddress, string _name);

  function memberRegistrationPlatform(string _name) public returns(bool) {
    MicrolendingPlatformDetails.membersDetails memory _membersdetails = MicrolendingPlatformDetails.membersDetails(
      msg.sender,
      _name,
      false);
    members_Details[msg.sender] = _membersdetails;
    emit MemberRegisteredOnPlatform(msg.sender, _name);
    return true;
  }

  function membersVerification(string _kyc) public payable returns(bool) {
    _checkmembersVerification();
    membersKYC[msg.sender] = _kyc;
    members_Details[msg.sender].verifiedmember = true;
    emit MemberVerified(msg.sender, members_Details[msg.sender].name);
    return true;
  }

  function _checkmembersVerification() private view returns(bool) {
    if (msg.value != 0.5 ether || members_Details[msg.sender].memberAddress == address(0) ) {
      revert();
    }
  }

  function _checkmemberDetails(address _membersAddress) internal view returns(bool) {
    require (members_Details[_membersAddress].verifiedmember);
    return true;
  }
}
