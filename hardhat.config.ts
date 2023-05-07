import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    testnet: {
      chainId: 97,
      accounts: [process.env.PRIVATE_KEY ?? ""],
      url: "https://data-seed-prebsc-2-s2.binance.org:8545",
      timeout: 60000000000,
    },
    bsc: {
      chainId: 56,
      accounts: [process.env.PRIVATE_KEY ?? ""],
      url: "https://bsc-dataseed.binance.org/",
      timeout: 600000000000,
    },
  },
  etherscan: {
    apiKey: {
      bscTestnet: process.env.BSC_API_KEY ?? "",
      goerli: process.env.GOERLI_API_KEY ?? "",
    },
  },
};

export default config;
