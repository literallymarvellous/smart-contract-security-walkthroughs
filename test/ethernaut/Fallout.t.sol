// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_2/Fallout.sol";

contract FalloutTest is Test {
    Fallout public fallout;
    address alice;

    function setUp() public {
        fallout = new Fallout();
    }

    function testAttack() public {
        // function naming error
        fallout.Fal1out();

        assertEq(fallout.owner(), address(this));
    }
}
