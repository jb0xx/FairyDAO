//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IFairyDAO} from "./interfaces/IFairyDAO.sol";


contract Proposal {
    string title;
    // TODO: implement IPFS description;
    immutable address AUTHOR;
    immutable address DAO;

    // We could consolidate these two mappings into a struct to save space
    // since vote weight is bounded by uint32.
    // Also, we need some way of locking funds upon voting, so users can't
    // just vote and transfer their funds to another user
    mapping (address, bool) votes;
    mapping (address, uint256) voteWeights;
    
    modifier onlyAuthor() {
        require(msg.sender == AUTHOR);
        _;
    }
    
    modifier onlyMembers() {
        hostDAO._validateAddressIsWhitelisted(msg.sender);
        _;
    }

    constructor(
        string memory _title,
        // IPFS memory _description,
        address memory _author,
        address memory _DAO,
    ) {
        // TODO: set Author (lens user) from address (or is it hub and id?)
        // TODO: logic to update description
        title = _title;
        hostDAO = DAO(_DAOAddress);
        token = ERC20(_tokenAddress);
    }

    function vote(bool direction) public returns (uint power) onlyMembers {
    }

    // function _setDescription(IPFS Hash?) internal onlyAuthor {
    // }
}