import { ethers } from "hardhat";

async function main() {

  const eventChainContractFactory = await ethers.getContractFactory("EventChainContract")
  const eventChainEventManagerContractFactory = await ethers.getContractFactory("EventChainEventManagerContract")
  const eventChainContract = await eventChainContractFactory.deploy()
  const eventChainEventManagerContract = await eventChainEventManagerContractFactory.deploy()
  await eventChainEventManagerContract.setEventChainAddress(eventChainContract.address)
  
  console.log(`EventChain contract deployed to ${eventChainContract.address}`);
  console.log(`EventChainEventManager contract deployed to ${eventChainEventManagerContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
