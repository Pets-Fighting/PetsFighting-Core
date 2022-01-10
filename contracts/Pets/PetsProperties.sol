// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./interfaces/IPetsProperties.sol";

/**

 * @dev Pets Properties:
 *          -- Base Info
 *          
 *          -- Weapon Info
 *
 *
 *
 */

abstract contract PetsProperties is IPetsProperties {
    /**
     * @notice Strings are used for showing
     */
    string[] private weapons = ["Knife", "Sword"];

    string[] private clothes = ["Armor", "Sackcloth"];

    // level => exp
    mapping(uint256 => uint256) levelExp;

    // level => base attribute
    mapping(uint256 => BaseInfo) levelAttribute;

    // tokenId => Pets info
    mapping(uint256 => PetInfo) pets;

    function getPetInfo(uint256 tokenId)
        external
        view
        returns (PetInfo memory)
    {
        return pets[tokenId];
    }

    //**************//
    //**  Energy  **//
    //**************//

    function getEnergy(uint256 tokenId) public view returns (uint256 energy) {
        energy = pets[tokenId].base.energy;
    }

    function useEnergy(uint256 tokenId, uint256 energyUsed) external {
        require(energyUsed <= getEnergy(tokenId), "Energy not sufficient");
        pets[tokenId].base.energy -= energyUsed;
    }

    //**************//
    //**   Exp    **//
    //**************//

    function gainExperience(uint256 tokenId, uint256 newExp) external {
        uint256 currentLevel = pets[tokenId].base.experience;

        pets[tokenId].base.experience += newExp;

        if (pets[tokenId].base.experience >= levelExp[currentLevel])
            _upgradeLevel(tokenId);
    }

    function _upgradeLevel(uint256 tokenId) internal {
        pets[tokenId].level += 1;
    }

    //**************//
    //**  Weapon  **//
    //**************//

    function getNewWeapon(
        uint256 tokenId,
        uint256 kind,
        uint256 level
    ) external {
        Weapon memory newWeapon = Weapon({
            weaponKind: WeaponKind(kind),
            weaponLevel: level
        });

        pets[tokenId].weapons.push(newWeapon);
    }

    //**************//
    //**  Attack  **//
    //**************//

    function getAttack(uint256 tokenId)
        external
        view
        returns (uint256, uint256)
    {
        return (pets[tokenId].base.attackLow, pets[tokenId].base.attackHigh);
    }
}
