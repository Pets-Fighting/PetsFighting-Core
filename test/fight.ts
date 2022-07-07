import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, ContractReceipt, ContractTransaction } from "ethers";
import { parseUnits } from "ethers/lib/utils";
import { ethers } from "hardhat";
import {
  Crystal,
  Crystal__factory,
  Pets,
  Pets__factory,
  PVPFight,
  PVPFight__factory,
} from "../typechain";

describe("Fight", function () {
  let dev_account: SignerWithAddress,
    player1: SignerWithAddress,
    player2: SignerWithAddress;
  let Crystal: Crystal__factory, crystal: Crystal;
  let Pets: Pets__factory, pets: Pets;

  let PVPFight: PVPFight__factory, pvpFight: PVPFight;

  const PET_PRICE = parseUnits("0.02");

  beforeEach(async () => {
    [dev_account, player1, player2] = await ethers.getSigners();

    Crystal = await ethers.getContractFactory("Crystal");
    crystal = await Crystal.deploy();

    Pets = await ethers.getContractFactory("Pets");
    pets = await Pets.deploy("PetsFighting", "PET", "");
    await pets.deployed();

    await pets.setLevelExp(1, 100);
    await pets.setLevelExp(2, 500);

    PVPFight = await ethers.getContractFactory("PVPFight");
    pvpFight = await PVPFight.deploy(pets.address, crystal.address);

    await pvpFight.deployed();

    await pvpFight.setEnergyPerFight(2, 10);
    await pvpFight.setExpPerFight(2, 100);

    await pets.setFightContract(pvpFight.address);
  });

  describe("Mint Pets", () => {
    beforeEach(async () => {
      await pets.mintPet(0, { value: PET_PRICE });
    });
    it("should be able to mint a pet", async () => {
      expect(await pets.balanceOf(dev_account.address)).to.equal(1);
    });

    it("should not be able to mint more than 1 pet", async () => {
      await expect(pets.mintPet(0, { value: PET_PRICE })).to.be.revertedWith(
        "Only 1 pet"
      );
    });

    it("should have the correct base type", async () => {
      expect(await pets.getBaseType(0)).to.equal("Panguin");
    });

    it("should be able to burn a pet", async () => {
      const petId = await pets.userPet(dev_account.address);
      await expect(pets.burn(petId))
        .to.emit(pets, "Transfer")
        .withArgs(dev_account.address, ethers.constants.AddressZero, petId);
    });
  });

  describe("Match Fight", () => {
    const type = 2;
    let tokenIdA: BigNumber, tokenIdB: BigNumber;
    let expPerFight: BigNumber;

    beforeEach(async () => {
      // Mint pets for two players
      await pets.connect(player1).mintPet(0, { value: PET_PRICE });
      await pets.connect(player2).mintPet(1, { value: PET_PRICE });

      tokenIdA = await pets.userPet(player1.address);
      tokenIdB = await pets.userPet(player2.address);

      console.log("token id a", tokenIdA);
      console.log("token id b", tokenIdB);

      expPerFight = await pvpFight.expPerFight(type);
      console.log("exp per fight", expPerFight);
    });

    it("should be able to have a pvpfight", async () => {
      const tx: ContractTransaction = await pvpFight.matchFight(
        tokenIdA,
        tokenIdB
      );

      const receipt: ContractReceipt = await tx.wait();

      expect(receipt.events![0].event).to.equal("PVPFightFinished");
      expect(receipt.events![0].args!.fightType).to.equal(type);

      const winnerPlace: number = receipt.events![0].args!.winner.toNumber();
      const fightDetails: string = receipt.events![0].args!.details;

      console.log("fighting details:", fightDetails);
      console.log("winner Id:", winnerPlace);

      const winnerTokenId = winnerPlace == 0 ? tokenIdA : tokenIdB;

      expect((await pets.getPetInfo(winnerTokenId)).base.experience).to.equal(
        expPerFight
      );
    });

    it("should have enough energy to start a match fight", async () => {
      // 200 is out of the max energy
      await pvpFight.setEnergyPerFight(2, 200);

      await expect(pvpFight.matchFight(tokenIdA, tokenIdB)).to.be.revertedWith(
        "Not enough energy"
      );
    });
  });
});
