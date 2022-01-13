// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "../pets/interfaces/IPets.sol";
import "../utils/PetUtils.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract FightBase is Ownable {
    uint256 public MAX_RANK_DIFF = 1;

    address public Pets;

    mapping(uint256 => uint256) public energyPerFight;

    mapping(uint256 => uint256) public expPerFight;

    mapping(uint256 => uint256) public rankLevel;

    constructor(address pets) {
        Pets = pets;
    }

    modifier enoughEnergy(uint256 tokenId, uint256 fightType) {
        require(
            IPets(Pets).getEnergy(tokenId) >= energyPerFight[fightType],
            "Not enough energy"
        );
        _;
    }

    function setExpPerFight(uint256 fightType, uint256 exp) external onlyOwner {
        expPerFight[fightType] = exp;
    }

    function setEnergyPerFight(uint256 fightType, uint256 energy)
        external
        onlyOwner
    {
        energyPerFight[fightType] = energy;
    }

    function changePetsContract(address pets) external onlyOwner {
        Pets = pets;
    }

    function _getAttackLow(uint256 petId)
        internal
        view
        returns (uint256 attackLow)
    {
        (, attackLow) = IPets(Pets).getAttack(petId);
    }

    function _getAttackHigh(uint256 petId)
        internal
        view
        returns (uint256 attackHigh)
    {
        (attackHigh, ) = IPets(Pets).getAttack(petId);
    }

    function _getHP(uint256 petId) internal view returns (uint256 hp) {
        hp = IPets(Pets).getHP(petId);
    }

    function _checkRank(uint256 petAId, uint256 petBId) internal view {
        uint256 rankA = IPets(Pets).getRankLevel(petAId);
        uint256 rankB = IPets(Pets).getRankLevel(petBId);

        uint256 rankDiff = rankA >= rankB ? (rankA - rankB) : (rankB - rankA);

        require(rankDiff <= MAX_RANK_DIFF, "Rank not match");
    }

    function _getFightOrder(uint256 petAId, uint256 petBId)
        internal
        view
        returns (uint256 order)
    {
        uint256 hpA = _getHP(petAId);
        uint256 hpB = _getHP(petBId);

        // 0: A first 1: B first
        order = PetUtils.randInt(2, hpA + hpB);
    }
}
