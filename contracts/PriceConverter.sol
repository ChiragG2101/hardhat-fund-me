// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256) {
        //ABI
        // Address of chain link contract to get price from 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e  (Rinkeby) 
        (, int price,,,) = priceFeed.latestRoundData();
        // Eth in terms of USD

        return uint (price * 1e10);  // typecasting to uint bcoz msg.value will be uint  //  1e10 is done as msg.value is of 18 decimal places and latestRoundData returns value in 8 decimal places
    }


    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns(uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
         
    }
}