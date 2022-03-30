//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ILensHub} from "./lens/ILensHub.sol";
import {IFairyDAO} from "./interfaces/IFairyDAO.sol";
import {IProposal} from "./interfaces/IProposal.sol";
import {ProposalFactory} from "./ProposalFactory.sol";

// FairyDAO is a DAO that integrates with the Lens Hub.
// It offloads membership verification and engagement tracking to the Hub.
// Members are expected to put their money where their mouth is. Therefore,
// all Proposals must be published with an initial stake, which is translated
// to vote power according to the VotingCurve determined during instantiation.
contract FairyDAO is IFairyDAO, ProposalFactory {
    using SafeERC20 for IERC20;

    // address funds committed/locked for voting on the DAO
    struct Funds { 
        uint128 committed;
        uint128 locked;
    }

    // default voting curve parameters
    // TODO: add min stake and minProposerStake
    struct VotingCurve {
        a uint8;   // numerator of the exponent
        b uint8;   // denominator of the exponent
    }

    string name;
    // TODO: implement IPFS description; (lens probs has clues)
    uint minCommitment;     // minimum commitment required of members to join this DAO, represented in the ERC20's decimal notation
    uint minProposerStake;  // minimum initial stake require to author a Proposal
    mapping(address => Funds) addressFunds;
    mapping(uint => address) proposals;
    VotingCurve curve;

    address immutable TOKEN;
    address immutable HUB;
    address immutable FOLLOW_NFT;


    // checks whether the caller is following the DAO on the Lens Hub 
    modifier onlyMember() {
        require(_isMember(msg.sender));
        _;
    }

    constructor(
        string memory _name,
        address memory _token,
        address memory _hub,
        address memory _profileID, // Q: do we need this or can we get from hub?
        uint memory _expNumerator,
        uint memory _expDenominator,
    ) {
        require(a < 10 && b < 10, "invalid params: a < 10, b < 10");
        curve = VotingCurve(_expNumerator, _expDenominator);
        name = _name;
        TOKEN = _token;
        HUB = _hub;
        FOLLOW_NFT = ILensHub(HUB).getFollowNFT(_profileID);
    }

    // Creates a new Proposal on behalf of the caller and posts to Hub.
    // Casts the initial vote with the user's staked balance.
    function createProposal(
        string memory _title, 
        uint memory _stake
    ) public onlyMember {
        require(stake <= _addressBalance(msg.sender) - _addressLockedBalance(msg.sender), "stake exceeds available balance");
        require(stake >= minProposerStake, "stake fails to meet minimum");
        address proposal = _newProposal(a, b, _title, msg.sender, address(this));

        // publish this proposal as a Post on the Lens Hub
        // have the caller vote yes on the proposal 
        IProposal(proposal).vote(true, stake);
        // Collect vote NFT
    }

    // checks whether the given address holds the DAO's FollowNFT
    function _isMember(address memory _user) internal view returns (bool) {
        return IERC721(FOLLOW_NFT).balanceOf(address(_user)) > 0;
    }

    // gets the balance of commmited funds to the contract
    function _balance() internal view returns (uint256) {
        return IERC20(TOKEN).balanceOf(address(this));
    }

    // gets the committed balance of the specified address 
    function _addressBalance(
        address memory _hodler
    ) internal view returns (uint) {
        return addressFunds[_hodler].committed;
    }

    // gets the locked balance of the specified address
    function _addressLockedBalance(
        address memory _hodler
    ) internal view returns (uint) {
        return addressFunds[_hodler].locked;
    }
}