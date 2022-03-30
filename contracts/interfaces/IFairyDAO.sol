//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ILensHub} from "./interfaces/ILensHub.sol";
import {ProposalFactory} "./ProposalFactory.sol";
import {Proposal} "./Proposal.sol";

// FairyDAO is a DAO that integrates with the Lens Hub.
// It offloads membership verification and engagement tracking to the Hub.
// Members are expected to put their money where their mouth is. Therefore,
// all Proposals must be published with an initial stake, which is translated
// to vote power according to the VotingCurve determined during instantiation.
interface IFairyDAO {
    // Creates a new proposal on behalf of the Caller
    // casts the initial vote with the user's balance as Yes
    function createProposal(string title, ) public;

    function createProposalWithStake(
        string memory _title, 
        uint memory _stake
    ) public;

    // gets the voting power of the caller
    function getVotePower() pure returns (uint256);

    // checks whether the given address holds the DAO's FollowNFT
    function _isMember(address memory _user) internal view returns (bool);

    // gets the balance of the contract
    function _balance() internal view returns (uint256);

    // gets the committed balance of the specified address 
    function _addressBalance(address memory _hodler) internal view returns (uint);
    
    // gets the locked balance of the specified address
    function _addressLockedBalance(address memory _hodler) internal view returns (uint);
}