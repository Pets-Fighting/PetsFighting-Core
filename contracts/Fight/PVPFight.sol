// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./FightBase.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PVPFight is FightBase {
    using Strings for uint256;

    event PVPFightFinished(
        uint256 tokenIdA,
        uint256 tokenIdB,
        uint256 fightType,
        uint256 winner,
        string details
    );

    constructor(address pets) FightBase(pets) {}

    // Type == 2: Match Fighting
    function matchFight(uint256 petAId, uint256 petBId)
        external
        enoughEnergy(petAId, 2)
        enoughEnergy(petBId, 2)
    {
        uint256 order = _getFightOrder(petAId, petBId);

        (uint256 winner, string memory details) = pvpFight(
            petAId,
            petBId,
            order
        );

        uint256 newExp = expPerFight[2];
        uint256 energyUsed = energyPerFight[2];

        uint256 winnerId = winner == 0 ? petAId : petBId;
        uint256 loserId = winner == 0 ? petBId : petAId;

        IPets(Pets).finishFight(winnerId, loserId, newExp, energyUsed);

        emit PVPFightFinished(petAId, petBId, 2, winner, details);
    }

    // Type == 3: Rank Fighting
    function rankFight(uint256 petAId, uint256 petBId) external {
        _checkRank(petAId, petBId);
        uint256 order = _getFightOrder(petAId, petBId);

        (uint256 winner, string memory details) = pvpFight(
            petAId,
            petBId,
            order
        );
        emit PVPFightFinished(petAId, petBId, 3, winner, details);
    }

    // Type == 4: Round Fighting
    function roundFight() external {}

    // Type == 5: Death Fighting
    function deathFight() external {}

    function pvpFight(
        uint256 petAId,
        uint256 petBId,
        uint256 order
    ) public view returns (uint256 winner, string memory fightingDetails) {
        (uint256 attackLowA, uint256 attackHighA) = IPets(Pets).getAttack(
            petAId
        );

        (uint256 attackLowB, uint256 attackHighB) = IPets(Pets).getAttack(
            petBId
        );

        uint256 HPA = _getHP(petAId);
        uint256 HPB = _getHP(petBId);

        fightingDetails = string(
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
                _getAttackLow(petAId);

            attackFromB =
                PetUtils.randInt(
                    attackHighB - attackLowB,
                    HPB * block.difficulty
                ) +
                _getAttackLow(petBId);

            HPA = PetUtils.safeSub(HPA, attackFromB);
            HPB = PetUtils.safeSub(HPB, attackFromA);

            // append the attack details to string variable
            fightingDetails = string(
                abi.encodePacked(fightingDetails, "-", attackFromA.toString())
            );
            fightingDetails = string(
                abi.encodePacked(fightingDetails, "-", attackFromB.toString())
            );
        } while (HPA > 0 && HPB > 0);

        if (order == 0) {
            winner = HPB == 0 ? 0 : 1;
        } else {
            winner = HPA == 0 ? 0 : 1;
        }
    }
}
