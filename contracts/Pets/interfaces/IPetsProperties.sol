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

    struct PetInfo {
        uint256 level;
        BaseInfo base;
        Weapon[] weapons; // All weapons currently holding
    }
}
