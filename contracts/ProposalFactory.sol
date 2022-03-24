
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;


/// @title The ProposalFactory allows for the creation of Proposals for a DAO
contract ProposalFactory {
    address immutable HUB;

    constructor(address hub) {
        HUB = hub;
    }

    // Emit details about the new Proposal
    event Publish(
        address proposal,
        address author,
        uint256 blockNumber,
    );

    function _newProposal(
        string memory _title,
        IPFS memory _description,
        address memory _author,
        address memory _DAO,
        address memory _token,
    ) internal returns (address) {
        // TODO: get IPFS hash after storing description on IPFS
        Proposal instance = new Proposal(
            _title,
            _description,
            _author,
            _DAO,
            _token,
        );
        emit Publish(
            address(instance),
            _author,
            block.number
        );
        return address(instance);
    }
}