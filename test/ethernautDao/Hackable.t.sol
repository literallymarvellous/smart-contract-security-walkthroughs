// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level6/Hackable.sol";

contract HackableTest is Test {
    Hackable public hackable;

    function setUp() public {
        hackable = new Hackable(45, 100);
    }

    function testAttack() public {
        console2.log("block", block.number);

        // set block number to ....45 ie. 145, 104794072745, 24673045
        vm.roll(145);

        hackable.cantCallMe();

        // assert its solved
        assert(hackable.done());
    }
}
