// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./interfaces/IPetsProperties.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

/**

 * @dev Pets Properties:
 *          -- Base Info
 *          
 *          -- Weapon Info
 *
 *
 *
 */

abstract contract PetsProperties is IPetsProperties, Ownable {
    address public Fight;
    address public BlindBox;

    /**
     * @notice Strings are used for showing
     */
    string[] private weapons = ["Knife", "Sword"];

    string[] private clothes = ["Armor", "Sackcloth"];

    string[] private shoes = ["Nike", "LiNing"];

    // level => exp
    mapping(uint256 => uint256) levelExp;

    // level => base attribute
    mapping(uint256 => BaseInfo) levelAttribute;

    // tokenId => Pets info
    mapping(uint256 => PetInfo) pets;

    modifier onlyFightContract() {
        require(_msgSender() == Fight, "Only fight contract");
        _;
    }

    modifier onlyBlindBoxContract() {
        require(_msgSender() == BlindBox, "Only blindbox contract");
        _;
    }

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

    function useEnergy(uint256 tokenId, uint256 energyUsed)
        external
        onlyFightContract
    {
        require(energyUsed <= getEnergy(tokenId), "Energy not sufficient");
        pets[tokenId].base.energy -= energyUsed;
    }

    //**************//
    //**   Exp    **//
    //**************//

    function gainExperience(uint256 tokenId, uint256 newExp)
        external
        onlyFightContract
    {
        uint256 currentLevel = pets[tokenId].base.experience;

        pets[tokenId].base.experience += newExp;

        if (pets[tokenId].base.experience >= levelExp[currentLevel])
            _upgradeLevel(tokenId);
    }

    function _upgradeLevel(uint256 tokenId) internal {
        pets[tokenId].level += 1;
    }

    //**************//
    //**  Level   **//
    //**************//

    function setLevelExp(uint256 level, uint256 exp) external onlyOwner {
        levelExp[level] = exp;
    }

    //**************//
    //**  Weapon  **//
    //**************//

    function getNewWeapon(
        uint256 tokenId,
        uint256 kind,
        uint256 level
    ) external onlyBlindBoxContract {
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

    function _clearPetProperty(uint256 tokenId) internal {
        delete pets[tokenId];
    }
}
