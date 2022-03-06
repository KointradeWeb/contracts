// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "./IERC20.sol";

interface IMultipleRewards {


    // rewarder type
    enum RewarderType {notdefined, sharedistribution, boost, partnership}  // 0, 1, 2, 3

    function onASNTReward(
        uint256 pid,
        address user,
        uint256 newLpAmount
    ) external;

    function pendingTokens(uint256 pid, address user)
        external
        view
        returns (uint256 pending);

    function rewardToken() external view returns (IERC20);

    function poolRewardsPerSec(uint256 _pid) external view returns (uint256);

    function getPoolInfo(uint256 _pid) external view 
    returns (uint256 allocPoint,
            uint256 lastRewardTime,
            uint256 accTokenPerShare,
            uint256 rewardStartTime,
            uint256 rewardEndTime,
            RewarderType rewarderType);

}