// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "./library/Lib.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

error InsufficientBalance();

interface IRewardToken is IERC20 {
    function mint(address addr, uint256 amount) external;
}

contract Staking is Ownable {
    using Lib for uint256;
    IERC20 public token;
    IRewardToken public reward;
    uint256 public constant DURATION = 60 * 60 * 24;

    // uint256 public constant AMOUNT_IN_WEI = 10**18;

    constructor(address _token, address _reward) {
        token = IERC20(_token);
        reward = IRewardToken(_reward);
    }

    struct StakeHolder {
        uint256 tokenBalance;
        uint256 rewardBalance;
        uint256 lastTimeStamp;
    }

    mapping(address => StakeHolder) private _staker;

    function accumulateReward(address account, uint256 tokenBalance) internal {
        StakeHolder storage staker = _staker[account];
        uint256 rewardRate = tokenBalance / 100;
        staker.rewardBalance += staker.lastTimeStamp.calculate(
            rewardRate,
            DURATION
        );
        staker.lastTimeStamp = block.timestamp;
    }

    //Create staking
    function createStake(uint256 amount) external {
        StakeHolder storage staker = _staker[msg.sender];
        if (amount > token.balanceOf(msg.sender)) revert InsufficientBalance();
        token.transferFrom(msg.sender, address(this), amount);
        staker.tokenBalance += amount;
        console.log("Token Balance upon creating stake:", staker.tokenBalance);
        accumulateReward(msg.sender, staker.tokenBalance);
    }

    //Send rewards to the users
    function claimReward() public {
        StakeHolder storage staker = _staker[msg.sender];
        accumulateReward(msg.sender, staker.tokenBalance);
        uint256 stakerReward = staker.rewardBalance;
        if (stakerReward == 0) revert InsufficientBalance();
        staker.rewardBalance = 0;
        console.log("Amount of reward claimed:", stakerReward);
        reward.mint(msg.sender, stakerReward);
    }

    function removeStake(uint256 _amount) public {
        StakeHolder storage staker = _staker[msg.sender];
        if (_amount > staker.tokenBalance) revert InsufficientBalance();
        uint256 tokenBalance = staker.tokenBalance;
        staker.tokenBalance -= _amount;
        accumulateReward(msg.sender, tokenBalance);
        if (staker.tokenBalance == 0) {
            staker.lastTimeStamp = 0;
        }
        token.transfer(msg.sender, _amount);
        console.log("Balance left after removing stake:", staker.tokenBalance);
        console.log("Reward balance is:", staker.rewardBalance);
    }

    function getRewardBalance(address account) external view returns (uint256) {
        return _staker[account].rewardBalance;
    }

    function getTokenBalance(address account) external view returns (uint256) {
        return _staker[account].tokenBalance;
    }
}
