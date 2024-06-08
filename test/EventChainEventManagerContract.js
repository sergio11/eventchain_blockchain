const { expect } = require("chai");

describe("EventChainEventManagerContract", function () {

  async function deployContractFixture() {
    const [owner, addr1, addr2, addr3] = await ethers.getSigners()
    // Get the ContractFactory and Signers here.
    const eventChainContractFactory = await ethers.getContractFactory("EventChainContract")
    const eventChainContract = await eventChainContractFactory.deploy(owner.address)
    const ContractFactory = await ethers.getContractFactory("EventChainEventManagerContract")
    const instance = await ContractFactory.deploy(owner.address)
    await instance.setEventChainAddress(eventChainContract)
    return { ContractFactory, instance, eventChainContract,  owner, addr1, addr2, addr3 }
  }

 // Test to verify that the contract owner is set correctly
  it("Should set the right owner", async function () {
    const { instance, owner } = await deployContractFixture()
    expect(await instance.owner()).to.equal(owner.address)
  });

  it("Should set the event chain address", async function () {
    const { instance, owner, eventChainContract } = await deployContractFixture()
    expect(instance._eventChainContractAddress).to.equal(eventChainContract.address)
  });

  // Test to verify creating an event
  it("Should create an event", async function () {
    const { instance, owner, addr1 } = await deployContractFixture()
    await instance.createEvent("Event Name", "Location", "2024-12-31", 10)
    const event = await instance.getEventDetails(0)
    expect(event.name).to.equal("Event Name")
    expect(event.location).to.equal("Location")
    expect(event.date).to.equal("2024-12-31")
    expect(event.ticketPrice).to.equal(10)
    expect(event.organizer).to.equal(owner.address)
  });

  // Test to verify minting a ticket
  it("Should mint a ticket", async function () {
    const { instance, owner, addr1, eventChainContract } = await deployContractFixture()
    await instance.createEvent("Event Name", "Location", "2024-12-31", 20)
    await instance.mintTicket(0, addr1.address, "URI")
    const ticketStatus = await eventChainContract.getTicketStatus(0)
    expect(ticketStatus.isUsed).to.be.false
    expect(ticketStatus.isValid).to.be.true
  });

  // Test to verify transferring an event
  it("Should transfer an event", async function () {
    const { instance, owner, addr1, addr2 } = await deployContractFixture()
    await instance.createEvent("Event Name", "Location", "2024-12-31", 10)
    await instance.transferEvent(0, addr1.address)
    const event = await instance.getEventDetails(0)
    expect(event.organizer).to.equal(addr1.address)
  });

  // Test to verify that non-owner cannot transfer an event
  it("Should not allow non-owner to transfer an event", async function () {
    const { instance, owner, addr1, addr2, addr3 } = await deployContractFixture()
    await instance.createEvent("Event Name", "Location", "2024-12-31", 10)
    let errorMessage = null;
    try {
      await instance.connect(addr2).transferEvent(0, addr1.address);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("OwnableUnauthorizedAccount");
    const event = await instance.getEventDetails(0)
    expect(event.organizer).to.equal(owner.address)
  });

  // Test to verify that minting a ticket for non-existent event fails
  it("Should not allow minting a ticket for non-existent event", async function () {
    const { instance, owner, addr1 } = await deployContractFixture()
    await expect(instance.mintTicket(0, addr1.address, "URI")).to.be.revertedWith("Event does not exist")
  });

  // Test to verify that minting a ticket by non-organizer fails
  it("Should not allow minting a ticket by non-organizer", async function () {
    const { instance, owner, addr1, addr2 } = await deployContractFixture()
    await instance.createEvent("Event Name", "Location", "2024-12-31", 10)
    await expect(instance.connect(addr2).mintTicket(0, addr1.address, "URI")).to.be.revertedWith("Only the event organizer can mint tickets")
  });

  // Test to verify that accessing non-existent event details fails
  it("Should not allow accessing non-existent event details", async function () {
    const { instance, owner, addr1 } = await deployContractFixture()
    await expect(instance.getEventDetails(0)).to.be.revertedWith("Event does not exist")
  });
});