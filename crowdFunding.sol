// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Crowdfunding {

    // Struct for the campaign
    struct Campaign {
        string title;
        string description;
        address benefactor;
        uint goal;
        uint deadline;        
        uint amountRaised;
        bool complete;
    }

    // State variables
    address public manager;
    uint public minimumContribution; // Minimum amount to Contribute set by the manager.
    uint public campaignCount;
    mapping(uint => Campaign) public approvedCampaigns;

    // Events
    event CampaignCreated(uint campaignId, string title, string description, address benefactor, uint goal, uint deadline);
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId, uint amountRaised, bool success);

    modifier onlyAdmin() {
        require(msg.sender == manager, "Not the Manager");
        _;
    }

    // Modifier to check if the campaign exists
    modifier campaignExists(uint campaignId) {
        require(campaignId < campaignCount, "Campaign does not exist");
        _;
    }

    // Modifier to check if the campaign is active
    modifier campaignActive(uint campaignId) {
        require(block.timestamp < approvedCampaigns[campaignId].deadline, "Campaign has ended");
        _;
    }

    // Modifier to check if the campaign has ended
    modifier campaignEnded(uint campaignId) {
        require(block.timestamp >= approvedCampaigns[campaignId].deadline, "Campaign is still active");
        require(!approvedCampaigns[campaignId].complete, "Campaign has already ended");
        _;
    }

  constructor (uint minimum, address _manager) {
        manager = _manager;
        minimumContribution = minimum;
    }

    
     // Function to create a new campaign
    function createCampaign(string memory title, string memory description, address benefactor, uint goal, uint duration) public {
        require(goal > 0, "Goal must be greater than zero");
        require(benefactor != address(0), "Invalid benefactor address");

        campaignCount++;
        uint deadline = block.timestamp + duration;

        approvedCampaigns[campaignCount - 1] = Campaign({
            title: title,
            description: description,
            benefactor: benefactor,
            goal: goal,
            deadline: deadline,
            amountRaised: 0,
            complete: false
        });

        emit CampaignCreated(campaignCount - 1, title, description, benefactor, goal, deadline);
    }

    // Function to donate to a campaign
    function donate(uint campaignId) public payable campaignExists(campaignId) campaignActive(campaignId) {
        Campaign storage campaign = approvedCampaigns[campaignId];
        require(msg.value >= minimumContribution, "Donation must be greater than or equal to the minimum contribution");

        campaign.amountRaised += msg.value;
        emit DonationReceived(campaignId, msg.sender, msg.value);
    }

    // Function to end a campaign and transfer funds
    function endCampaign(uint campaignId) public campaignExists(campaignId) campaignEnded(campaignId) {
        Campaign storage campaign = approvedCampaigns[campaignId];
        require(msg.sender == campaign.benefactor || msg.sender == manager, "Not authorized to end campaign");

        campaign.complete = true;
        bool success = payable(campaign.benefactor).send(campaign.amountRaised);
        emit CampaignEnded(campaignId, campaign.amountRaised, success);
    }

    // Function to withdraw leftover funds by the contract owner
    function withdraw() public onlyAdmin {
        uint balance = address(this).balance;
        require(balance > 0, "No funds available");
        payable(manager).transfer(balance);
    }
}
