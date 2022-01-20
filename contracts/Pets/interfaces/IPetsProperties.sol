// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IPetsProperties {
    enum WeaponKind {
        knife,
        sword
    }

    struct Weapon {
        WeaponKind weaponKind;
        uint256 weaponLevel;
    }

    struct BaseInfo {
        uint256 experience;
        // How many activities you can do
        uint256 energy;
        uint256 maxHP;
        uint256 maxMP;
        uint256 maxWeaponLevel;
        // Attack
        uint256 attackLow;
        uint256 attackHigh;
    }

    struct RankInfo {
        uint256 rankScore;
        uint256 rankLevel;
    }

    struct PetInfo {
        uint256 level;
        RankInfo rank;
        BaseInfo base;
        Weapon[] weapons; // All weapons currently holding
    }

    function getPetInfo(uint256 tokenId) external view returns (PetInfo memory);

    function finishFight(
        uint256 winner,
        uint256 loser,
        uint256 expGained,
        uint256 energyUsed
    ) external;

    //**************//
    //**  Energy  **//
    //**************//

    function getEnergy(uint256 tokenId) external view returns (uint256 energy);

    //**************//
    //**  Level   **//
    //**************//

    function setLevelExp(uint256 level, uint256 exp) external;

    //**************//
    //**  Weapon  **//
    //**************//

    function getNewWeapon(
        uint256 tokenId,
        uint256 kind,
        uint256 level
    ) external;

    //**************//
    //**  Attack  **//
    //**************//

    function getAttack(uint256 tokenId)
        external
        view
        returns (uint256 attackLow, uint256 attackHigh);

    //**************//
    //**  Force   **//
    //**************//

    function getFightingForce(uint256 tokenId)
        external
        view
        returns (uint256 force);

    //**************//
    //**   Rank   **//
    //**************//

    function getRankLevel(uint256 tokenId)
        external
        view
        returns (uint256 rankLevel);

    function gainRankScore(uint256 tokenId, uint256 score) external;
}
