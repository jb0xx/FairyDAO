//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface Proposal {
    // Casts a vote by the caller with the given direction and stake.
    // As the Proposal Contract is token-agnostic, all stakes are interpreted
    // as whole token values. Any pre-processing to account for ERC20 amounts
    // must occur at the DAO level. This includes checking available balances.
    function vote(
        bool memory _direction,
        uint memory _stake
    ) public onlyMember notVotedfunction;

    // gets the total funds locked for voting on this proposal
    function totalStaked() public view returns (uint256);


    // function _setDescription(IPFS Hash?) internal onlyAuthor {
    // }
}