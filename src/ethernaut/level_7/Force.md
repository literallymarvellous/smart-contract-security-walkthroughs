### Level 7 Force Walkthrough

The goal of this level is to make the balance of the contract greater than zero.

#### Solution

Solution invloves using selfdestruct. It is a low level instruction that removes the code and storage associated with a contract address from the blockchain and sends remaining ether to a target address. This should be used with caution.

### Security info

- Access Control should used with functions that make use of it.
- Emit event when selfdestruct is called
- Be cautious doing balance accounting with address(this).balance since it can be manipulated with selfdestruct.

soluiton is addded at test/ethernaut/Force.t.sol
