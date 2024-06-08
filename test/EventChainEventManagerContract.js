const { expect } = require("chai");

describe("EventChainEventManagerContract", function () {

  async function deployContractFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners()
    // Get the ContractFactory and Signers here.
    const eventChainContractFactory = await ethers.getContractFactory("EventChainContract")
    const eventChainContract = await eventChainContractFactory.deploy(owner.address)
    const ContractFactory = await ethers.getContractFactory("EventChainEventManagerContract")
    const instance = await ContractFactory.deploy(owner.address)
    instance.setEventChainAddress(eventChainContract.address)
    return { ContractFactory, instance, owner, addr1, addr2 }
  }

  it("Should set the right owner", async function () {
    const { instance, owner } = await deployContractFixture()
    expect(await instance.owner()).to.equal(owner.address)
  });
});