// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./mToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Staking is Ownable {
    using SafeMath for uint256;
    mToken public token;

    constructor(mToken _token) {
        token = _token;
    }

    //Address of the people staking
    address[] public stakers;

    //Staking balance
    mapping(address => uint256) public stakingBalance;
    //Reward balance
    mapping(address => uint256) public rewardBalance;

    // Using this function
    function isStaking(address _stakingAddress)
        internal
        view
        returns (bool, uint256)
    {
        for (uint256 i = 0; i < stakers.length; i++) {
            if (stakers[i] == _stakingAddress) return (true, i);
        }
        return (false, 0);
    }

    // Add the address to the stakers array
    function addStakeHolder(address _addr) private {
        (bool checkAddr, ) = isStaking(_addr);
        if (!checkAddr) stakers.push(_addr);
    }

    //Create staking
    function createStake(uint256 _stake) public {
        token.transferFrom(msg.sender, address(this), _stake);
        if (stakingBalance[msg.sender] == 0) addStakeHolder(msg.sender);
        stakingBalance[msg.sender] += _stake;
    }

    // Remove staker
    function removeStakeHolder(address _addr) private {
        (bool checkB, uint256 i) = isStaking(_addr);
        if (checkB) stakers[i] = stakers[stakers.length - 1];
        stakers.pop();
    }

    //Send rewards to the users
    function issueReward() public onlyOwner {
        for (uint256 i = 0; i < stakers.length; i++) {
            uint256 reward = stakingBalance[msg.sender] / 100;
            rewardBalance[msg.sender] += reward;
        }
    }

    function removeStake(uint256 _amount) public {
        uint256 bal = stakingBalance[msg.sender];
         //Update the balance
        stakingBalance[msg.sender] -= _amount;
        token.transfer(msg.sender, bal);
        if (stakingBalance[msg.sender] == 0) removeStakeHolder(msg.sender);
    }

    // Get the total amount of stake
    function getTotalStake() public view returns (uint256) {
        uint256 totalStake = 0;
        for (uint256 i = 0; i < stakers.length; i++) {
            totalStake.add(stakingBalance[stakers[i]]);
        }
        return totalStake;
    }

    //Function to withdraw reward
    function withdrawReward() public {
        uint256 reward = rewardBalance[msg.sender];
        rewardBalance[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }
}
