// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/ethernaut/level_26/DoubleEntryPoint.sol";
import "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract DoubleEntryPointTest is Test {
    DoubleEntryPoint dbpoint;
    CryptoVault vault;
    DetectionBot bot;
    Forta forta;
    LegacyToken token;
    ERC20Mock erc20mock;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        vault = new CryptoVault(alice);
        token = new LegacyToken();
        // erc20mock = new ERC20Mock("FakeToken1", "FTK1", alice, 10000);

        bot = new DetectionBot(address(vault));

        forta = new Forta();
        vm.prank(alice);
        forta.setDetectionBot(address(bot));
        dbpoint = new DoubleEntryPoint(address(token), address(vault), address(forta), alice);

        vault.setUnderlying(address(dbpoint));
        token.delegateToNewContract(dbpoint);
    }

    function testBot() public {
        address tokenAddress = dbpoint.delegatedFrom();
        vm.expectRevert("Alert has been triggered, reverting");
        vault.sweepToken(IERC20(tokenAddress));
    }
}

contract DetectionBot is IDetectionBot {
    address private vault;

    constructor(address _vault) public {
        vault = _vault;
    }

    function handleTransaction(address user, bytes calldata /* msgData */ ) external override {
        address to;
        uint256 value;
        address origSender;
        // decode msgData params
        assembly {
            to := calldataload(0x68)
            value := calldataload(0x88)
            origSender := calldataload(0xa8)
        }
        if (origSender == vault) {
            Forta(msg.sender).raiseAlert(user);
        }
    }
}
