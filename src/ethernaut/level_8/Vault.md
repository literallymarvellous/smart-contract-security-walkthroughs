### Level 8 Vault Walkthrough

The goal of this level is to Unlock the vault to pass the level!

#### Solution

Using the value stored at storage slot 2 ie `bytes32 private passowrd`.

Firstly, no data stored on the blockchain is private, all data on a smart contract can be read. The keyword private specifies the visibility of a state variable and function when read from contracts.

Accessing storage data can be done with either etherjs or web3js, both have functions for these.

Check test/ethernaut for soluiton contract.
