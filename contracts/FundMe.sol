// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// anyone want to fund the contract
//only the owner can withdraw the amount
// for funds the minimum amnount is required in the usd
import "contracts/PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConvertor for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
        // single equal setting the msg.sender in owner variable
    }

    function fund() public payable {
        // want to set min imum value in usd
        // 1. How do we send ETH to this contract?
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

        // va denote pannuthu and then 1e18 vandhu oru 1 ETH
        // 1 * 10 ** 18
        //this 'require' keyword is a checker
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner,"Sender is not the Owner!");
        // double equals denote checking the variable that it has

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
        // actually withdraw the funds

        //transfer

        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);
        // send
        //   bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //   require(sendSuccess,"Send Failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call Failed");
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner,"Sender is not Owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // what happens if someone sends this contract EtH without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
