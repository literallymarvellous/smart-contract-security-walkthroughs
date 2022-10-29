// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level7/Switch.sol";

contract SwitchTest is Test {
    Switch public switchContract;

    function setUp() public {
        switchContract = new Switch();
    }

    // using address directly
    function testAttack() public {
        address alice = vm.addr(1);

        // generate hash to be signed.
        bytes32 addressHash = keccak256(abi.encodePacked(alice));
        bytes32 hash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", addressHash)
        );

        // sign the message hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        vm.prank(alice);
        switchContract.changeOwnership(v, r, s);

        assertEq(switchContract.owner(), alice);
    }
}
