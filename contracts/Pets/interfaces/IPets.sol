// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IPetsProperties.sol";

interface IPets is IPetsProperties {
    function getAttack(uint256 tokenId)
        external
        view
        returns (uint256 attackLow, uint256 attackHigh);

    function getPetInfo(uint256 tokenId) external view returns (PetInfo memory);

    function updatePetInfo(PetInfo memory) external;

    function getHP(uint256 tokenId) external view returns (uint256 HP);

    function gainExperience(uint256 tokenId, uint256 newExp) external;
}
