// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Counters.sol";

contract ProposalContract {
    address owner;

    using Counters for Counters.Counter;
    Counters.Counter private _counter;

    struct Proposal {
        string title;
        string description; 
        uint256 approve; // Number of approve votes
        uint256 reject;
        uint256 pass;
        uint256 totalVoteToEnd; // Limit of voting. When the proposal reaches
        // this limit, proposal ends.
        bool currentState; // The proposal passes or fails
        bool isActive; // Can vote or cannot vote
    }
    mapping(uint256 => Proposal) proposalHistory; // Recordings of previous proposals

    address[] private votedAddresses;

    constructor() {
        owner = msg.sender;
        votedAddresses.push(msg.sender);
    }

       modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier active() {
        require(proposalHistory[_counter.current()].isActive == true, "The proposal is not active");
        _;
    }

    modifier newVoter(address _address) {
        require(!isVoted(_address), "Address has not voted yet");
        _;
    }

    function create (string memory _title, string calldata _description, uint256 _totalVoteToEnd) external onlyOwner {
        _counter.increment();
        proposalHistory[_counter.current()] = Proposal(_title, _description, 0, 0, 0, _totalVoteToEnd, false, true);
    }

    function setOwner (address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function vote (uint8 choice) external active newVoter(msg.sender) {
        Proposal storage proposal = proposalHistory[_counter.current()];
        uint256 totalVote = proposal.approve + proposal.reject + proposal.pass;

        votedAddresses.push(msg.sender);

        if (choice == 1) {
            proposal.approve += 1;
            proposal.currentState = calculateCurrentState();
        } else if (choice == 2) {
            proposal.reject += 1;
            proposal.currentState = calculateCurrentState();
        } else if (choice == 0) {
            proposal.pass += 1;
            proposal.currentState = calculateCurrentState();
        }

        if ((proposal.totalVoteToEnd - totalVote == 1) && (choice == 1 || choice == 2 || choice == 3)) {
            proposal.isActive = false;
            votedAddresses = [owner];
        }
    }

    function calculateCurrentState() private view returns(bool) {
        Proposal storage proposal = proposalHistory[_counter.current()];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass;

        if (proposal.pass % 2 == 1) {
            pass = (proposal.pass + 1) / 2  ;
        } else if (proposal.pass % 2 == 0) {
            pass = proposal.pass / 2;
        }

        if (approve > reject + pass) {
            return true;
        } else return false;
    }
}