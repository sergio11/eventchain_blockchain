const { expect } = require("chai");

describe("EventChainContract", function () {

  async function deployContractFixture() {
    const [owner, addr1, addr2, addr3] = await ethers.getSigners()
    // Get the ContractFactory and Signers here.
    const ContractFactory = await ethers.getContractFactory("EventChainContract")
    const instance = await ContractFactory.deploy(owner.address)
    return { ContractFactory, instance, owner, addr1, addr2, addr3 }
  }

  // Test to verify that the contract owner is set correctly
  it("Should set the right owner", async function () {
    const { instance, owner } = await deployContractFixture();
    expect(await instance.owner()).to.equal(owner.address);
  });

  // Test to verify minting a ticket and checking ownership history
  it("Should mint a ticket", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await expect(instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000))
      .to.emit(instance, 'TicketMinted')
      .withArgs(0, addr1.address, "eventDetails", 100, 1893456000);

    const history = await instance.getTicketHistory(0);
    expect(history).to.deep.equal([addr1.address]);
  });

  // Test to verify validating a ticket
  it("Should validate a ticket", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    await expect(instance.validateTicket(0))
      .to.emit(instance, 'TicketValidated')
      .withArgs(0, owner.address);

    const status = await instance.getTicketStatus(0);
    expect(status[0]).to.be.true;  // isUsed
  });

  // Test to verify validation of an already used ticket fails
  it("Should fail to validate an already used ticket", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    await instance.validateTicket(0);
    let errorMessage = null;
    try {
      await instance.validateTicket(0);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("Ticket already used");
  });

  // Test to verify validation of an expired ticket fails
  it("Should fail to validate an expired ticket", async function () {
    const { instance, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 0); // expired ticket
    let errorMessage = null;
    try {
      await instance.validateTicket(0);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("Ticket has expired");
  });

  // Test to verify updating ticket metadata
  it("Should update ticket metadata", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    await expect(instance.updateTicketMetadata(0, "newEventDetails", "newURI"))
      .to.emit(instance, 'TicketMetadataUpdated')
      .withArgs(0, "newEventDetails", "newURI");

    const tokenURI = await instance.tokenURI(0);
    expect(tokenURI).to.equal("newURI");
  });

  // Test to verify that non-owner cannot update ticket metadata
  it("Should not allow non-owner to update ticket metadata", async function () {
    const { instance, addr1, addr2 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    let errorMessage = null;
    try {
      await instance.connect(addr2).updateTicketMetadata(0, "newEventDetails", "newURI");
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("OwnableUnauthorizedAccount");
  });

  // Test to verify setting max resale price
  it("Should set max resale price", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    await expect(instance.setMaxResalePrice(0, 200))
      .to.emit(instance, 'TicketMaxResalePriceSet')
      .withArgs(0, 200);

    const maxPrice = await instance.maxResalePrice(0);
    expect(maxPrice).to.equal(200);
  });

  // Test to verify that non-owner cannot set max resale price
  it("Should not allow non-owner to set max resale price", async function () {
    const { instance, addr1, addr2 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    let errorMessage = null;
    try {
      await instance.connect(addr2).setMaxResalePrice(0, 200);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("OwnableUnauthorizedAccount");
  });

  // Test to verify burning expired tickets
  it("Should burn expired tickets", async function () {
    const { instance, owner, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 0); // expired ticket
    await expect(instance.burnExpiredTickets(0))
      .to.emit(instance, 'TicketExpired')
      .withArgs(0);
    let errorMessage = null;
    try {
      await instance.ownerOf(0);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("ERC721NonexistentToken(0)");
  });

  // Test to verify that valid tickets cannot be burned
  it("Should not allow burning of valid tickets", async function () {
    const { instance, addr1 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000); // valid ticket
    let errorMessage = null;
    try {
      await instance.burnExpiredTickets(0);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("Ticket is still valid");
  });

  // Test to verify transfer of ticket with history update
  it("Should transfer ticket with history update", async function () {
    const { instance, owner, addr1, addr2 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    await instance.transferWithHistoryUpdate(addr1.address, addr2.address, 0);

    const history = await instance.getTicketHistory(0);
    expect(history).to.deep.equal([addr1.address, addr2.address]);

    expect(await instance.ownerOf(0)).to.equal(addr2.address);
  });

  // Test to verify that non-owner cannot transfer ticket
  it("Should not allow non-owner to transfer ticket", async function () {
    const { instance, addr1, addr2, addr3 } = await deployContractFixture();
    await instance.safeMint(addr1.address, "uri", "eventDetails", 100, 1893456000);
    let errorMessage = null;
    try {
      await instance.connect(addr2).transferWithHistoryUpdate(addr1.address, addr3.address, 0);
    } catch (error) {
      errorMessage = error.message;
    }
    expect(errorMessage).to.contain("OwnableUnauthorizedAccount");
  });
});