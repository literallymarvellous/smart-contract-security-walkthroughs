### Level 1 Fallback Walkthrough

The goal of this level is to claim ownership of the contract and reduce its balance to 0

#### Solution

Solution invloves callling the receive() function, which has 2 requirements msg.value > 0 and conttibutions > 0. So make a conribution > 0 first, then send ETH to the contract calling the receive() function, then call withdraw().

soluiton is addded at test/ethernaut
