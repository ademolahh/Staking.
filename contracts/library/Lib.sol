// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
library Lib {
    function calculate(
        uint256 timestamp,
        uint256 rewardRate,
        uint256 duration
    ) internal view returns (uint256) {
        if (timestamp == 0) return 0;
        return ((block.timestamp - timestamp) * rewardRate) / duration;
    }
}
