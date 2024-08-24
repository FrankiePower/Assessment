Create A Crowdfunding Smart Contract
Develop a Solidity smart contract that allows users to create and participate in crowdfunding campaigns. Each campaign should have a specific duration, after which the funds collected should be automatically transferred to the campaign's benefactor.

Requirements:

Campaign Structure:

Each campaign should have the following properties:
title (string): The name of the campaign.
description (string): A brief description of the campaign.
benefactor (address): The address of the person or organization that will receive the funds.
goal (uint): The fundraising goal (in wei).
deadline (uint): The Unix timestamp when the campaign ends.
amountRaised (uint): The total amount of funds raised so far.
Functions:

Create Campaign:

The smart contract should allow any user to create a new campaign by specifying the title, description, benefactor, goal, and duration (in seconds).
The contract should calculate the deadline based on the duration provided.
Donate to Campaign:

Users should be able to donate to any campaign of their choice by specifying the campaign ID.
The donation amount should be added to the amountRaised of the selected campaign.
The donation should only be accepted if the campaign's deadline has not passed.
End Campaign:

Once the deadline of a campaign is reached, the smart contract should automatically transfer the funds raised to the benefactor.
The contract should not allow any more donations after the campaign ends.
If the amountRaised is less than the goal, the contract should still transfer the funds to the benefactor.
Events:

Emit relevant events such as CampaignCreated, DonationReceived, and CampaignEnded to track the activities within the contract.
Contract Ownership (Optional, Bonus Points):

Implement an ownership mechanism where only the contract owner can withdraw any leftover funds from the contract (e.g., if gas fees cause leftover funds after campaign payouts).
Constraints:

Ensure proper validation for campaign creation (e.g., the goal should be greater than zero).
Implement safeguards to prevent re-entrancy attacks.
Make sure that only the benefactor receives the funds once the campaign ends.
Submission:

Submit a GitHub repository link or GitHub gist link containing a Solidity file (Crowdfunding.sol) with the following:

The complete smart contract code.
Comments explaining the logic behind each function.
Evaluation Criteria:

Correctness: The smart contract should meet all the requirements.
Security: The contract should handle potential vulnerabilities like re-entrancy.
Code Quality: The code should be clean, well-commented, and follow Solidity best practices like naming convention.
Bonus Points: For implementing additional features such as contract ownership, refund mechanisms, etc.
