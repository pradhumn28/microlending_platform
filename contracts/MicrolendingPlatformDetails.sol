pragma solidity ^0.4.21;


library MicrolendingPlatformDetails {
  struct vcDetails {
    uint8 interest;
    uint16 minimumAmount;
    uint24 maximumAmount;
    string vcName;
    address vcAdmin;
    uint StartDate;
    uint lastJoinDate;
    uint EndDate;
  }

  struct vcDateDetails {
    uint lastloanDepositeDate;
    uint lastreimbursementTime;
  }

  struct membersDetails {
    address memberAddress;
    string name;
    bool verifiedmember;
  }

  struct vcAccountDetails {
    uint8 totalMembers;
    uint32 totalAmountVC;
    uint32 totalAmountremaining;
  }

  struct investorDetail {
    uint24 investAmount;
    bool investmentApproved;
  }

  struct loanBorrowerDetail {
    uint24 loanAmount;
    uint24 dueAmount;
    string mortgageCertificate;
    bool loanAprroved;
  }
}
