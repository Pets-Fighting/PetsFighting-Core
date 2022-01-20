import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import {
  Crystal,
  Crystal__factory,
  FightCore,
  FightCore__factory,
  Pets,
  Pets__factory,
} from "../typechain";

describe("Fight", function () {
  let dev_account: SignerWithAddress;
  let FightCore: FightCore__factory, core: FightCore;
  let Crystal: Crystal__factory, crystal: Crystal;
  let Pets: Pets__factory, pets: Pets;

  beforeEach(async () => {
    [dev_account] = await ethers.getSigners();

    Crystal = await ethers.getContractFactory("Crystal");
    crystal = await Crystal.deploy();

    Pets = await ethers.getContractFactory("Pets");
    pets = await Pets.deploy("PetsFighting", "PET", "");

    FightCore = await ethers.getContractFactory("FightCore");
    core = await FightCore.deploy(pets.address);

    await core.deployed();
  });

  describe("Mint Pets", () => {
    beforeEach(async () => {
      await pets.mintPet(dev_account.address, 0);
    });
    it("should be able to mint a pet", async () => {
      expect(await pets.balanceOf(dev_account.address)).to.equal(1);
    });

    it("should not be able to mint more than 1 pet", async () => {
      await expect(pets.mintPet(dev_account.address, 0)).to.be.revertedWith(
        "Only 1 pet"
      );
    });

    it("should have the correct base type", async () => {
      expect(await pets.getBaseType(0)).to.equal("Turtle");
    });

    it("should be able to burn a pet", async () => {
      const petId = await pets.tokenOfOwnerByIndex(dev_account.address, 0);
      await expect(pets.burn(petId))
        .to.emit(pets, "Transfer")
        .withArgs(dev_account.address, ethers.constants.AddressZero, petId);
    });
  });
});
