// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../pets/interfaces/IPets.sol";
import "../pets/PetsProperties.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../utils/PetUtils.sol";

/**
 * @notice Fighting between pets will be included in this contract.

 */

contract FightCore {
    using Strings for uint256;

    uint256 public expPerFight;

    uint256 public energyPerFight;

    address public Pets;

    mapping(uint256 => bool) allFightTypes;

    constructor(address pets) {
        Pets = pets;

        allFightTypes[1] = true;
        allFightTypes[2] = true;
    }

    modifier enoughEnergy(uint256 tokenId) {
        require(
            IPets(Pets).getEnergy(tokenId) >= energyPerFight,
            "Not enough energy"
        );
        _;
    }

    function pvpFight(uint256 petAId, uint256 petBId)
        external
        enoughEnergy(petAId)
        enoughEnergy(petBId)
        returns (
            uint256 order,
            uint256 winner,
            uint256 loser,
            string memory attackDetails
        )
    {
        uint256 HPA = IPets(Pets).getHP(petAId);
        uint256 HPB = IPets(Pets).getHP(petBId);

        (uint256 attackLowA, uint256 attackHighA) = IPets(Pets).getAttack(
            petAId
        );

        (uint256 attackLowB, uint256 attackHighB) = IPets(Pets).getAttack(
            petBId
        );

        // 0: A first 1: B first
        order = PetUtils.randInt(2, HPA + HPB);

        attackDetails = string(
            abi.encodePacked(HPA.toString(), "-", HPB.toString())
        );

        // initial seed to randomize the real attack value
        uint256 attackFromA;
        uint256 attackFromB;

        do {
            // randomize harm for per attack
            attackFromA =
                PetUtils.randInt(
                    attackHighA - attackLowA,
                    HPA * block.timestamp
                ) +
                attackLowA;

            attackFromB =
                PetUtils.randInt(
                    attackHighB - attackLowB,
                    HPB * block.difficulty
                ) +
                attackLowB;

            HPA = PetUtils.safeSub(HPA, attackFromB);
            HPB = PetUtils.safeSub(HPB, attackFromA);

            // append the attack details to string variable
            attackDetails = string(
                abi.encodePacked(attackDetails, "-", attackFromA.toString())
            );
            attackDetails = string(
                abi.encodePacked(attackDetails, "-", attackFromB.toString())
            );
        } while (HPA > 0 && HPB > 0);

        if (order == 0) {
            winner = HPB == 0 ? petAId : petBId;
            loser = HPB == 0 ? petBId : petAId;
        } else {
            winner = HPA == 0 ? petBId : petAId;
            loser = HPA == 0 ? petAId : petBId;
        }

        IPets(Pets).finishFight(winner, loser, expPerFight, energyPerFight);
    }

    function pveFight(uint256 petAId, uint256 difficulty)
        external
        enoughEnergy(petAId)
    {}
}
