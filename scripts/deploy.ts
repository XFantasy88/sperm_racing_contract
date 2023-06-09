import { ethers } from "hardhat";

async function main() {
  const Race = await ethers.getContractFactory("Racing");
  const race = await Race.deploy("0x9be79A8AA81e367C3D8E9573ff4c57D473b809F5");

  await race.deployed();

  console.log("Race Game Address: ", race.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
