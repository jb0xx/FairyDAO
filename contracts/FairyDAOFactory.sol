
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import {FairyDAO} from "./FairyDAO.sol";
import {DataTypes} from "./lens/DataTypes.sol";

/// @title The FairyDAOFactory allows users to create a FairyDAO
contract FairyDAOFactory {
    address immutable HUB; // Q: do we need this?

    constructor(address hub) {
        HUB = hub; 
    }

    function newFairyDAO(
        string memory _name,
        // IPFS memory _description,
        address memory _token,
        address memory _hub,
        uint memory _expNumerator,
        uint memory _expDenominator
    ) public returns (address) {
        // create this DAO as a user in the lens hub
        FairyDAO instance = new FairyDAO(
            _name,
            _hub,
            _token,
            _expNumerator,
            _expDenominator
        );
        address(instance)

        DataTypes.CreateProfileData memory profile;
        profile.to = address(this);
        profile.handle = _twitterProfile;
        profile.followModule = address(0);
        MockProfileCreationProxy(MOCK_PROFILE_CREATION_PROXY)
            .proxyCreateProfile(profile);
        uint256 profileId = ILensHub(LENS_HUB).getProfileIdByHandle(
            _twitterProfile
        );
        // We may need to 'initialize' DAO after creating it,
        // so we can create a Lens profile here and pass in the
        // profile ID as well as set the FollowNFT
        // 
        return address(instance);

    }
}