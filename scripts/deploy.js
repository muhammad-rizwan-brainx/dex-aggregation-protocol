const { ethers } = require("hardhat");
/** This is a function used to deploy contract */
const hre = require("hardhat");

async function main() {
  const AggregationProtocol = await hre.ethers.getContractFactory(
    "AggregationProtocol"
  );
  const _AggregationProtocol = await AggregationProtocol.deploy();
  console.log("AggregationProtocol deployed to:", _AggregationProtocol.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
