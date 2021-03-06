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

    // address public petsContract;

    /**
     * @notice Strings are used for showing
     */
    string[] private weapons = ["Knife", "Sword"];

    string[] private clothes = ["Armor", "Sackcloth"];

    string[] private shoes = ["Nike", "LiNing"];

    // level => exp
    uint256 public maxLevel;
    mapping(uint256 => uint256) levelExp;

    // level => base attribute
    mapping(uint256 => BaseInfo) levelAttribute;

    uint256 public maxRankLevel;
    mapping(uint256 => uint256) rankScore;
    string[] private ranks = [
        "Bronze",
        "Silver",
        "Gold",
        "Platium",
        "Diamond",
        "Master"
    ];

    // tokenId => Pets info
    mapping(uint256 => PetInfo) pets;

    event LevelUpgrade(uint256 tokenId, uint256 newLevel);
    event RankLevelUpgrade(uint256 tokenId, uint256 newRankLevel);

    modifier onlyFightContract() {
        require(_msgSender() == Fight, "Only fight contract");
        _;
    }

    modifier onlyBlindBoxContract() {
        require(_msgSender() == BlindBox, "Only blindbox contract");
        _;
    }

    function setFightContract(address fightContract) external onlyOwner {
        Fight = fightContract;
    }

    /**
     * @notice Set the pets contract, only by the owner
     */
    // function setPetsContract(address _petsContract) external onlyOwner {
    //     petsContract = _petsContract;
    // }

    function _initNewPet(uint256 tokenId) internal {
        PetInfo storage newPet = pets[tokenId];

        newPet.base.energy = 100;
        newPet.base.maxHP = 1000;
        newPet.base.maxMP = 100;
        newPet.base.attackHigh = 30;
        newPet.base.attackLow = 20;
    }

    function getPetInfo(uint256 tokenId)
        external
        view
        returns (PetInfo memory)
    {
        return pets[tokenId];
    }

    function finishFight(
        uint256 winner,
        uint256 loser,
        uint256 expGained,
        uint256 energyUsed
    ) external onlyFightContract {
        _gainExperience(winner, expGained);
        useEnergy(winner, energyUsed);
        useEnergy(loser, energyUsed);
    }

    //**************//
    //**  Energy  **//
    //**************//

    function getEnergy(uint256 tokenId) public view returns (uint256 energy) {
        energy = pets[tokenId].base.energy;
    }

    function useEnergy(uint256 tokenId, uint256 energyUsed) internal {
        require(energyUsed <= getEnergy(tokenId), "Energy not sufficient");
        pets[tokenId].base.energy -= energyUsed;
    }

    //**************//
    //**   Exp    **//
    //**************//

    function _gainExperience(uint256 tokenId, uint256 newExp) internal {
        uint256 currentLevel = pets[tokenId].base.experience;

        pets[tokenId].base.experience += newExp;

        if (
            currentLevel < maxLevel &&
            pets[tokenId].base.experience >= levelExp[currentLevel]
        ) _upgradeLevel(tokenId, currentLevel + 1);
    }

    function _upgradeLevel(uint256 tokenId, uint256 newLevel) internal {
        pets[tokenId].level += 1;
        emit LevelUpgrade(tokenId, newLevel);
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
        returns (uint256 attackLow, uint256 attackHigh)
    {
        return (pets[tokenId].base.attackLow, pets[tokenId].base.attackHigh);
    }

    function _clearPetProperty(uint256 tokenId) internal {
        delete pets[tokenId];
    }

    //**************//
    //**  Force   **//
    //**************//

    function getFightingForce(uint256 tokenId)
        external
        view
        returns (uint256 force)
    {
        PetInfo memory pet = pets[tokenId];
        force = pet.level * pet.base.attackHigh;
    }

    //**************//
    //**   Rank   **//
    //**************//

    function getRankLevel(uint256 tokenId)
        external
        view
        returns (uint256 rankLevel)
    {
        rankLevel = pets[tokenId].rank.rankLevel;
    }

    function gainRankScore(uint256 tokenId, uint256 score) external {
        uint256 currentRankLevel = pets[tokenId].rank.rankLevel;

        pets[tokenId].rank.rankScore += score;

        if (
            currentRankLevel < maxRankLevel &&
            pets[tokenId].rank.rankScore >= rankScore[currentRankLevel]
        ) _upgradeLevel(tokenId, currentRankLevel + 1);
    }

    function _upgradeRankLevel(uint256 tokenId, uint256 newRankLevel) internal {
        pets[tokenId].rank.rankLevel += 1;
        emit RankLevelUpgrade(tokenId, newRankLevel);
    }

    //**************//
    //**    HP    **//
    //**************//
    function getHP(uint256 tokenId) external view returns (uint256 hp) {
        return pets[tokenId].base.maxHP;
    }
}
