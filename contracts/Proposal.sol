//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Proposal {
    string title;
    IPFS description;
    immutable address author; // how best to convert/represent this as a lens profile?
    FairyDAO hostDAO;
    ERC20 token;   

    // We could consolidate these two mappings into a struct to save space
    // since vote weight is bounded by uint32.
    // Also, we need some way of locking funds upon voting, so users can't
    // just vote and transfer their funds to another user
    mapping (address, bool) votes;
    mapping (address, uint256) voteWeights;
    
    modifier onlyAuthor() {
        _validateCallerIsAuthor();
        _;
    }
    
    modifier onlyWhitelisted() {
        hostDAO._validateAddressIsWhitelisted(msg.sender);
        _;
    }

    constructor(
        string memory _title,
        address memory _tokenAddress,
        IPFS memory _description,
        address memory _authorAddress,
        address memory _DAOAddress,
        address memory _tokenAddress,
    ) {
        // TODO: set Author (lens user) from address (or is it hub and id?)
        // TODO: logic to update description
        title = _title;
        hostDAO = DAO(_DAOAddress);
        token = ERC20(_tokenAddress);
    }

    function vote(bool direction) public returns (uint power) onlyWhitelisted {
    }

    function setDescription(IPFS Hash?) onlyAuthor {
    }
}