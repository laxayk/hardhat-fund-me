// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function GetPrice() internal view returns (uint256) {
    AggregatorV3Interface priceFeed = AggregatorV3Interface(
      0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    );
    (, int256 price, , , ) = priceFeed.latestRoundData();
    return uint256(price * 1e10);
  }

  function GetVersion() internal view returns (uint256) {
    AggregatorV3Interface priceFeed = AggregatorV3Interface(
      0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    );
    return priceFeed.version();
  }

  function GetConversionRate(uint256 _etherAmount)
    internal
    view
    returns (uint256)
  {
    uint256 ethPrice = GetPrice();
    uint256 ethAmountInUsd = (ethPrice * _etherAmount) / 1e18;
    return ethAmountInUsd;
  }
}
