const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const secret = require('../../.secret.json');

module.exports = buildModule("EventChain", (m) => {
  const eventChainContract = m.contract("EventChainContract", [secret.ownerKey]);
  const eventChainEventManagerContract = m.contract("EventChainEventManagerContract", [secret.ownerKey, eventChainContract]);
  return { eventChainContract, eventChainEventManagerContract };
});