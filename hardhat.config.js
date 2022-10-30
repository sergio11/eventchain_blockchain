require("@nomicfoundation/hardhat-toolbox");
const secret = require("./.secret.json")


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${secret.projectId}`,
      accounts: [secret.accountPrivateKey]
    }
  }
};
