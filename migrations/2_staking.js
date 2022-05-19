const mToken = artifacts.require("mToken");
const Staking = artifacts.require("Staking");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(mToken, "1000000000000000000000000"); //1 million token
  const mtoken = await mToken.deployed()
  await deployer.deploy(Staking, mtoken.address)
  const staking = await Staking.deployed()

  //Transfer 200k token to the bank
  await mtoken.transfer(staking.address, "200000000000000000000000", {from: accounts[0]})
};
