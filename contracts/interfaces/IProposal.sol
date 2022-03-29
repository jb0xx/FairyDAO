//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface Proposal {
    function vote(bool direction) public onlyMembers returns (uint power);

    // function _setDescription(IPFS Hash?) internal onlyAuthor {
    // }
}