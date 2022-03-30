//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IFairyDAO} from "./interfaces/IFairyDAO.sol";

// Proposal is a token-agnostic vote and vote
contract Proposal {
    // voting curve parameters for this proposal
    struct VotingCurve {
        a uint8;   // numerator of the exponent
        b uint8;   // denominator of the exponent
    }

    struct VoteDetails {
        bool direction;
        uint128 stake;
        uint32 weight; // could technically cache these conversions on a mapping
        bool voted;    // tracks whether an address has voted
    }

    immutable address DAO;
    immutable address PROPOSER;
    string title;
    // TODO: implement IPFS description;
    mapping(address => VotingDetails) votingDetails;
    uint totalStaked;
    VotingCurve curve;

    modifier onlyProposer() {
        require(msg.sender == PROPOSER);
        _;
    }
    
    modifier onlyMember() {
        require(IFairyDAO(DAO)._isMember(msg.sender));
        _;
    }

    modifier notVoted() {
        require(!votingDetails[msg.sender].voted);
        _;
    }

    constructor(
        address memory _proposer,
        string memory _title,
        // IPFS memory _description,
        address memory _DAO,
        uint memory _expNumerator,
        uint memory _expDenominator
    ) {
        // TODO: logic to set description
        DAO = _DAO;
        PROPOSER = _proposer;
        title = _title;
        curve = VotingCurve(_expNumerator, _expDenominator);
    }

    // Casts a vote by the caller with the given direction and stake.
    // As the Proposal Contract is token-agnostic, all stakes are interpreted
    // as whole token values. Any pre-processing to account for ERC20 amounts
    // must occur at the DAO level. This includes checking available balances.
    function vote(
        bool memory _direction,
        uint memory _stake
    ) public onlyMember notVoted {
        // TODO: check whether the user has the specified stake available in DAO commitments
        votingDetails[msg.sender].direction = _direction;
        votingDetails[msg.sender].stake = _stake;
        // TODO: calculate vote weight using FuzzyMath and set vote weight
        totalStaked += _stake;
        votingDetails[msg.sender].voted = true;
    }

    // gets the voting power based on stake
    function getVotePower(uint memory _stake) pure returns (uint256) {
        uint256 balance = _addressBalance(msg.sender);
        // determine vote power from balance
        // NOTE: FollowNFT.getPowerByBlockNumber() is an option
    }

    // gets the total funds locked for voting on this proposal
    function totalStaked() public view returns (uint256) {
        return totalStaked;
    }

    // function _setDescription(IPFS Hash?) internal onlyProposer {
    // }
}