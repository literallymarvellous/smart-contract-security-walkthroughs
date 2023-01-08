// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_18/MagicNumber.sol";

contract MagicNumberTest is Test {
    MagicNum number;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        number = new MagicNum();
    }

    function testAttack() public {
        address solver = deploy();
        (bool success, bytes memory result) = solver.call(abi.encodeWithSignature("whatIsTheMeaningOfLife()", ""));
        uint256 num = 42;
        assertEq(uint256(bytes32(result)), num);
    }

    function deploy() public returns (address deployed) {
        bytes memory initCode = hex"69602a60005260206000f3600052600a6016f3";
        assembly {
            deployed := create2(0, add(initCode, 32), mload(initCode), 1)
        }
    }
}
