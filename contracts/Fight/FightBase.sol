// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "../pets/interfaces/IPets.sol";
import "../utils/PetUtils.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract FightBase is Ownable {
    address public Pets;

    mapping(uint256 => uint256) public energyPerFight;

    mapping(uint256 => uint256) public expPerFight;

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
}
