pragma solidity ^0.4.21;
import "./MicrolendingDeposite.sol";


contract MicrolendingEndVC is MicrolendingDeposite {

  mapping(string => mapping(address => uint)) vcMemberAccountBalance;

  function endVC(string _vcName) public onlyAdmin(_vcName) returns(bool) {
    if(checkVCstateON(_vcName) || checkVCstatePaused(_vcName)){
      _calculateAccountBalance(_vcName);
      vc_state[_vcName] = VCstate.end;
      emit VCEnded(_vcName);
      return true;
    }
  }

  function _calculateAccountBalance(string _vcName) private returns(bool) {
    for(uint i = 0; i < vcMembers[_vcName].length; i++) {
      vcMemberAccountBalance[_vcName][vcMembers[_vcName][i]] = (vcAccount_Details[_vcName].totalAmountremaining * vcInvestorDetail[_vcName][vcMembers[_vcName][i]].investAmount)/vcAccount_Details[_vcName].totalAmountVC;
    }
    return true;
  }

  function getVCmemberAccountBalance(string _vcName) public view returns(uint) {
    return vcMemberAccountBalance[_vcName][msg.sender];
  }
}
