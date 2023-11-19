// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
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
}