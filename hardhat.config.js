require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
module.exports = {
  etherscan: {
    apiKey: "36FJWRQTW9RAG43VJ3U1XKW5NBD8K148Z8",
  },
  mocha: {
    timeout: 20000,
  },
  networks: {
    hardhat: {},
    bsc: {
      accounts: [
        "939a4a0bf80bb0a22f8f006a16ca57f127379d9707ab30414dab5f339a48d133",
      ],
      url: "https://endpoints.omniatech.io/v1/bsc/testnet/public",
    },
  },
  paths: {
    sources: "./contracts",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.18",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
