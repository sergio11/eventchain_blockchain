import { expect } from "chai";
import { ethers } from "hardhat";

describe("NftTickets", function () {
  it("Test contract", async function () {
    const ContractFactory = await ethers.getContractFactory("NftTickets");

    const instance = await ContractFactory.deploy();
    await instance.deployed();

    expect(await instance.name()).to.equal("NftTickets");
  });
});
