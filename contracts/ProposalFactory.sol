
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;


/// @title The ProposalFactory allows for the creation of Proposals for a DAO
contract ProposalFactory {
    // Emit details about the new Proposal
    event Publish(
        address proposal,
        address author,
        uint256 blockNumber,
    );

    function _newProposal(
        address memory _author,
        string memory _title,
        // IPFS memory _description,
        address memory _DAO,
        uint memory _expNumerator,
        uint memory _expDenominator
    ) internal returns (address) {
        // TODO: get IPFS hash after storing description on IPFS
        Proposal instance = new Proposal(
            _author,
            _title,
            // _description,
            _DAO,
            _expNumerator,
            _expDenominator
        );
        emit Publish(
            address(instance),
            _author,
            block.number
        );
        return address(instance);
    }
}