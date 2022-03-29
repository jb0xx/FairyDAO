//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ILensHub} from "./lens/ILensHub.sol";
import {IProposal} from "./interfaces/IProposal.sol";
import {ProposalFactory} from "./ProposalFactory.sol";

// FairyDAO is a DAO that integrates with the Lens Hub.
// It offloads membership verification and engagement tracking to the Hub.
// Additionally, it makes use of FuzzyMath in its Proposals to allow for
// sublinear mapping of token balance to vote-weight.
contract FairyDAO is ProposalFactory {
    using SafeERC20 for IERC20;

    string Name;
    // TODO: implement IPFS description; (lens probs has clues)
    mapping (uint, address) proposals;

    address immutable TOKEN;
    address immutable HUB;
    address immutable FOLLOW_NFT;

    struct votingCurve {
        a uint8;   // numerator of the exponent
        b uint8;   // denominator of the exponent
    }

    // checks whether the caller is following the DAO on the Lens Hub 
    modifier onlyMember() {
        require(_isMember(msg.sender));
        _;
    }

    constructor(
        string memory _name,
        address memory _token,
        address memory _hub,
    ) {
        name = _name;
        TOKEN = _token;
        HUB = _hub;
        FOLLOW_NFT = ILensHub(HUB).getFollowNFT(_profileID);
    }


    // Creates a new proposal on behalf of the Caller
    // casts the initial vote with the user's balance as Yes
    function createProposal(uint256 stake, ) public {
        // check whether it's a valid stake amount
        
        // create the proposal, get address
        address proposal = _newProposal(msg.sender, title, description, address(this));
        
        // publish this proposal as a Post on the Lens Hub

        // have the caller vote yes on the proposal and Collect
        IProposal(proposal).vote(true, stake);
    }


    // gets the voting power of the caller
    function getVotePower() pure returns (uint256) {
        uint256 balance = _balance(msg.sender);
        // determine vote power from balance
        // should we use FollowNFT.getPowerByBlockNumber()?
    }  

    // sets the address of the DAO's voting token (do we need this?)
    function _setToken(address memory _tokenAddress) internal {
        TOKEN = _tokenAddress;
    }

    // checks whether the given address holds the DAO's FollowNFT
    function _isMember(address memory _user) internal view returns (bool) {
        // can we use ERC721 to check whether the caller has a FollowNFT?
    }

    // gets the balance of the contract
    function _balance() internal view returns (uint256) {
        return IERC20(_feesCurrency).balanceOf(msg.sender);
    }

}