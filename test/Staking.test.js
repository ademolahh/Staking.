const { deployments, ethers, network } = require("hardhat");
const { expect } = require("chai");

describe("Staking", () => {
  let token, rewardtoken, staking;
  beforeEach(async () => {
    await deployments.fixture(["all"]);
    token = await ethers.getContract("Token");
    rewardtoken = await ethers.getContract("RewardToken");
    staking = await ethers.getContract("Staking");
    rewardtoken.setControlAddress(staking.address, true);
    token.transfer(staker.address, eth("1000"));
  });
  before(async () => {
    accounts = await ethers.getSigners();
    owner = accounts[0];
    staker = accounts[1];
  });
  const eth = (n) => {
    return ethers.utils.parseEther(n);
  };
  describe("staking ", () => {
    it("create stake", async () => {
      await expect(
        staking.createStake(eth("111111111111111"))
      ).to.be.revertedWith("InsufficientBalance()");
      await token.approve(staking.address, eth("200"));
      await staking.createStake(eth("100"));
      await staking.createStake(eth("100"));
      expect(await staking.getTokenBalance(owner.address)).to.equal(eth("200"));
    });
    it("remove stake and claim", async () => {
      await token.approve(staking.address, eth("100"));
      await staking.createStake(eth("100"));
      await expect(staking.removeStake(eth("101"))).to.be.revertedWith(
        "InsufficientBalance()"
      );
      await network.provider.send("evm_increaseTime", [86400]);
      await network.provider.request({ method: "evm_mine", params: [] });
      await staking.removeStake(eth("10"));
      await staking.removeStake(eth("90"));
      await staking.claimReward();
    });
    it("claim and remove stake", async () => {
      await token.approve(staking.address, eth("100"));
      await staking.createStake(eth("100"));
      await expect(staking.removeStake(eth("101"))).to.be.revertedWith(
        "InsufficientBalance()"
      );
      await network.provider.send("evm_increaseTime", [86400]);
      await network.provider.request({ method: "evm_mine", params: [] });
      await staking.claimReward();
      await staking.removeStake(eth("100"));
    });
  });
});
