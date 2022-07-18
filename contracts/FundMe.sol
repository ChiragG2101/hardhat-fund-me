// SPDX-License-Identifier: MIT
//Pragma
pragma solidity ^0.8.0;

//Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

//Error Codes
error FundMe__NotOwner();

//Interfaces, Libraries, Contracts

/** @title A contract for crownd funding
 * @author Chirag Gupta
 * @notice This contract is to demo a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
    //Type Declarations
    using PriceConverter for uint256;

    //State Variables
    uint256 public constant MINIMUM_USD = 20 * 10**18;
    address[] private s_funders;
    address private immutable i_owner;
    mapping(address => uint256) private s_addressToAmountFunded;
    AggregatorV3Interface private s_priceFeed;

    //  Modifiers
    modifier onlyOwner() {
        // require(msg.sender == i_owner , "Sender is not owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    //Functions Order:
    //// Constructor
    //// Receieve
    //// Fallback
    //// External
    //// Public
    //// Internal
    //// Private
    //// View/Pure

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    /** 
     * @notice This function funds this contract
     * @dev This implements price feeds as our library
     */
    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD

        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,"Didn't send enough!" ); // msg.value will have 18 decimal places
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender); // msg.sender gives the address of the sender of the message
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            // starting index,ending index, step amount
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        //reset the array
        s_funders = new address[](0);

        //withdraw the funds

        //transfer
        payable(msg.sender).transfer(
            address(
                this /* whole contract */
            ).balance
        ); //transfer returns error
        /* msg.sender is address
        payable(msg.sender) is payable address */
        // send
        bool sendSuccess = payable(msg.sender).send(address(this).balance); // send returns boolean
        require(sendSuccess, "Send failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }(""); //call returns bool and a bytes object
        require(callSuccess, "call failed");
    }
    function cheaperWithdraw() public payable onlyOwner{
        address[] memory funders = s_funders;
        // mappings can't be in memory; 
        for(uint256 funderIndex=0; funderIndex < funders.length;funderIndex++){
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);

    }

    // View/Pure

    function getOwner() public view returns (address){
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address){
        return s_funders[index];
    } 

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256){
        return s_addressToAmountFunded[fundingAddress];
    }
    function getPriceFeed() public view returns (AggregatorV3Interface){
        return s_priceFeed;
    }
}
