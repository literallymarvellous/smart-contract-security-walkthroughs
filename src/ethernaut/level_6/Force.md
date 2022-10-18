### Level & Force Walkthrough

The goal of this level is to make the balance of the contract greater than zero.

#### Solution

Solution invloves using selfdestruct. It is a low level instruction that removes the code and storage associated with a contract address from the blockchain and sends remaining ether to a target address. This should be used with caution. Access Control should used with functions that make use of it.

soluiton is addded at test/ethernaut/Force.t.sol
