// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IPetsProperties.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IPets is IPetsProperties, IERC721 {
    function getAttack(uint256 tokenId)
        external
        view
        returns (uint256 attackLow, uint256 attackHigh);

    function getPetInfo(uint256 tokenId) external view returns (PetInfo memory);

    function updatePetInfo(PetInfo memory) external;

    function getHP(uint256 tokenId) external view returns (uint256 HP);

    function getEnergy(uint256 tokenId) external view returns (uint256 engergy);

    function getFightingForce(uint256 tokenId)
        external
        view
        returns (uint256 force);

    function getRankLevel(uint256 tokenId)
        external
        view
        returns (uint256 rankLevel);

    function finishFight(
        uint256 winnerTokenId,
        uint256 loserTokenId,
        uint256 expGained,
        uint256 energyUsed
    ) external;
}
