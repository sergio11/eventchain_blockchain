const { expect } = require("chai");

describe("EventChainContract", function () {

  async function deployContractFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners()
    // Get the ContractFactory and Signers here.
    const ContractFactory = await ethers.getContractFactory("EventChainContract")
    const instance = await ContractFactory.deploy(owner.address)
    return { ContractFactory, instance, owner, addr1, addr2 }
  }

  it("Should set the right owner", async function () {
    const { instance, owner } = await deployContractFixture()
    expect(await instance.owner()).to.equal(owner.address)
  });
});