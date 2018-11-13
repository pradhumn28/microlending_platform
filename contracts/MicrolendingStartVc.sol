pragma solidity ^0.4.21;
import "./MicrolendingPlatformDetails.sol";

contract MicrolendingStartVc {
  uint public vcCounter = 0;

  mapping(string => VCstate) vc_state;
  mapping(uint => string) VCnames;
  mapping(string => MicrolendingPlatformDetails.vcAccountDetails)vcAccount_Details;
  mapping(string => MicrolendingPlatformDetails.vcDetails)vc_Details;
  mapping(address => MicrolendingPlatformDetails.membersDetails)members_Details;

  enum VCstate {on , paused, end }

  event VCstarted(string _vcName,address _vcAdmin);
  event VCrestarted(string _vcName,address _vcAdmin);
  event VCpaused(string _vcName);
  event VCEnded(string _vcName);

  modifier onlyAdmin(string _vcName) {
    require(vc_Details[_vcName].vcAdmin == msg.sender);
    _;
  }

  function startVC(
    string _vcName,
    uint16 _minimumAmount,
    uint24 _maximumAmount,
    uint8 _interest
    ) public returns(bool) {
      _checkmemberDetails(msg.sender);
      _checkVCsExistence;
      MicrolendingPlatformDetails.vcAccountDetails memory _vcAccountDetails = MicrolendingPlatformDetails.vcAccountDetails(0,0,0);
      MicrolendingPlatformDetails.vcDetails memory _vcdetails = MicrolendingPlatformDetails.vcDetails(
        _interest,
        _minimumAmount,
        _maximumAmount,
        _vcName,
        msg.sender,
        now,
        now + 3 minutes,
        now + 10 minutes);
      vc_Details[_vcName] = _vcdetails;
      vcAccount_Details[_vcName] = _vcAccountDetails;
      vcCounter++;
      VCnames[vcCounter] = _vcName;
      vc_state[_vcName] = VCstate.on;
      emit VCstarted(_vcName,msg.sender);
      return true;
  }

  function restartVC(string _vcName) public onlyAdmin(_vcName) returns(bool) {
    checkVCstatePaused(_vcName);
    vc_Details[_vcName].StartDate = now;
    vc_Details[_vcName].lastJoinDate = now + 3 minutes;
    vc_Details[_vcName].EndDate = now + 10 minutes;
    vc_state[_vcName] = VCstate.on;
    emit VCrestarted(_vcName,msg.sender);
    return true;
  }

  function getVCsDetails(string _vcName) public view returns(string vcName,
  uint16 minimumAmount,
  uint24 maximumAmount,
  uint8 interest,
  address vcAdmin,
  uint32 totalAmount,
  uint8 totalmembers) {
    return(
      vc_Details[_vcName].vcName,
      vc_Details[_vcName].minimumAmount,
      vc_Details[_vcName].maximumAmount,
      vc_Details[_vcName].interest,
      vc_Details[_vcName].vcAdmin,
      vcAccount_Details[_vcName].totalAmountVC,
      vcAccount_Details[_vcName].totalMembers
    );
  }

  function getcurrentVCs(uint index) public view returns(string) {
    return VCnames[index];
  }

  function _checkmemberDetails(address _membersAddress) internal view returns(bool);


  function _checkVCsExistence(string _vcName) private view returns(bool) {
    require(vc_Details[_vcName].vcAdmin == address(0));
    return true;
  }

  function checkVCstateON(string _vcName) internal view returns(bool) {
    require (vc_state[_vcName] == VCstate.on);
    return true;
  }

  function checkVCstatePaused(string _vcName) internal view returns(bool) {
    require (vc_state[_vcName] == VCstate.paused);
    return true;
  }

  function checkVCstateEnd(string _vcName) internal view returns(bool) {
    require (vc_state[_vcName] == VCstate.end);
    return true;
  }
}
