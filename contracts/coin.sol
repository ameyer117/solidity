// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // Allow access from other contracts
    address public minter;
    mapping (address => uint) public balances;

    // Allow clients to react to changes
    event Sent(address from, address to, uint amount);

    // Constructor code is only run when the contract is created
    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Allows you to provide information about why a transaction failed.
    error InsufficientBalance(uint requested, uint available);
    
    // Sends an amount of existing coins
    function send(address receiver, uint amount) public {
        if(amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}