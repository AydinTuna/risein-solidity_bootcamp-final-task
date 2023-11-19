// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Counters.sol";

contract ProposalContract {
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

    function create (string memory _title, string calldata _description, uint256 _totalVoteToEnd) external {
        _counter.increment();
        proposalHistory[_counter.current()] = Proposal(_title, _description, 0, 0, 0, _totalVoteToEnd, false, true);
    }
}