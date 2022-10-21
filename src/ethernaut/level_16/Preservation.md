### Level 16 Preservation Walkthrough

This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

### Solution

Manipulating the use of delegatecall in the contract.

What is delegatecall?
Delegatecall is a low level function similar to call that executes a function in another contract with the storage variables of calling contract.

If Contract A makes a delegatecall to Contract B, the code is executed in the context of the calling Contract A, i.e. msg.sender and msg.value point to that of the calling Contract A. So any storage variable changes affects the storage of Contract A not B.

Check test/ethernaut for soluiton contract.

### security info

- Contracts using Delegatecall should be tested virgously.
- Avoid storage collosions with the calling contract and the target contract of the delegatecall.
