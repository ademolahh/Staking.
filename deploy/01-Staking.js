const { getNamedAccounts, deployments, ethers } = require("hardhat");
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const token =await ethers.getContract("Token")
  const rewardtoken =await ethers.getContract("RewardToken")

  const args = [token.address, rewardtoken.address]

  log("Deploying......");
  const staking = await deploy("Staking", {
    from: deployer,
    args:args,
    log: true,
  });
  log(`Staking contract successfully deployed to ${staking.address}`);
}
module.exports.tags = ["all", "stake"]