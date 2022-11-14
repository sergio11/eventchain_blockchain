import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const secret = require('./.secret.json');

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
      },
    },
  },
  networks: {
    hardhat: {},
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${secret.projectId}`,
      accounts: [secret.accountPrivateKey]
    }
  }
};

export default config;
