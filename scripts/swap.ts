import { ethers } from "hardhat";

async function main() {
  
  const [deployer] = await ethers.getSigners();
  console.log(`Address deploying the contract --> ${deployer.address}`);

  const vaultAmount = ethers.utils.parseEther("1");

  const swap = await ethers.getContractFactory("swapContract");
  const swapVault = await swap.deploy();

  await swapVault.deployed();

  console.log("Vault of 1 ETH deployed to:", swapVault.address);

  let result = await swapVault.createVault(
        "0xD89d0C24c44440e1c960403a53Fc73e947c1e9D5"
  )

  let response = (await result.wait());

 console.log("factory cloned successfully", response);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
