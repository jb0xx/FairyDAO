//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ILensHub} from "./interfaces/ILensHub.sol";
import {ProposalFactory} "./ProposalFactory.sol";
import {Proposal} "./Proposal.sol";

// FairyDAO is a DAO that integrates with the Lens Hub.
// It offloads membership verification and engagement tracking to the Hub.
// Additionally, it makes use of FuzzyMath in its Proposals to allow for
// sublinear mapping of token balance to vote-weight.
interface IFairyDAO {
    // Creates a new proposal on behalf of the Caller
    // casts the initial vote with the user's balance as Yes
    function createProposal(string title, ) public;

    // gets the voting power of the caller
    function getVotePower() pure returns (uint256);

    // sets the address of the DAO's voting token (do we need this?)
    function _setToken(address memory _tokenAddress) internal;

    // checks whether the given address holds the DAO's FollowNFT
    function _isMember(address memory _user) internal view returns (bool);

    // gets the balance of the contract
    function _balance() internal view returns (uint256);

    // TODO:
    //  function for determining DAO controlled balance of user
    //  function for determining balance of user locked in Proposal votes
    // 
}