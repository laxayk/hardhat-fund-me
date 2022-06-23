// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotAuthorized();

contract FundMe {
  using PriceConverter for uint256;

  uint256 public constant MINIMUM_FUND = 50 * 1e18;
  address[] public fundersList;
  address public immutable i_owner;
  mapping(address => uint256) public addreddToAmountFeed;

  constructor() {
    i_owner = msg.sender;
  }

  function Fund() public payable {
    require(
      msg.value.GetConversionRate() >= MINIMUM_FUND,
      "Didn't send enough"
    );
    fundersList.push(msg.sender);
    addreddToAmountFeed[msg.sender] += msg.value;
  }

  function Withdraw() public onlyOwner {
    for (uint256 i = 0; i < fundersList.length; i++) {
      addreddToAmountFeed[fundersList[i]] = 0;
    }
    fundersList = new address[](0);

    // //Transfer
    // payable(msg.sender).transfer(address(this).balance);
    // //Send
    // bool isSuccess = payable(msg.sender).send(address(this).balance);
    // require(isSuccess, "send Failed");
    //Call
    (bool callSuccess, ) = payable(msg.sender).call{
      value: address(this).balance
    }("");
    require(callSuccess, "call Failed");
  }

  receive() external payable {
    Fund();
  }

  fallback() external payable {
    Fund();
  }

  modifier onlyOwner() {
    if (msg.sender != i_owner) {
      revert NotAuthorized();
    }
    _;
  }
}
