const { getNamedAccounts, deployments } = require("hardhat");
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying......");
  const token = await deploy("Token", {
    from: deployer,
    args: [],
    log: true,
  });
  log(`Token successfully deployed to ${token.address}`);

  const rewardtoken = await deploy("RewardToken", {
    from: deployer,
    args: [],
    log: true,
  });

  log(`Reward token successfully deployed to ${rewardtoken.address}`);
};

module.exports.tags = ["all", "token"];
