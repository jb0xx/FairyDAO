//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract FairyDAO {
	string name;
    
    address owner; // update this to be a Lens Profile NFT
    

    event ProposalPublished(address proposal);

	constructor(string memory _name, address token) {

    }

    function createProposal() public {

    }

	function vote(bool) public returns (uint pow) {

    }
}