// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./Modifiers.sol";

contract MultisigWallet is CustomerModifiers {
    constructor(address[] memory _addresses, uint256 _required) {
        require(_addresses.length >= 3, "Number of owners is not complete");
        require(
            _required == _addresses.length - 1,
            "Length of address - 1 must be equal to required"
        );
        required == _required;

        for (uint256 i; i < _addresses.length; i++) {
            owners.push(_addresses[i]);
            isOwner[_addresses[i]] = true;
        }
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submit(address _to, uint256 _amount) external payable OnlyOwner {
        require(address(this).balance >= _amount, "Oops! Insufficient funds");
        transactionCount++;
        transactions[transactionCount] = Transaction(_to, _amount, 0, false);
        transactionExist[transactionCount] = true;
        emit Submit(msg.sender, transactionCount);
    }

    function approve(uint256 transactionId)
        external
        OnlyOwner
        transactionExists(transactionId)
        isNotApproved(transactionId)
        isNotExecuted(transactionId)
    {
        approved[transactionId][msg.sender] = true;
        Transaction storage transaction = transactions[transactionId];
        transaction.confirmations++;
        emit Approval(msg.sender, transactionId);
    }

    function execute(uint256 transactionId)
        external
        OnlyOwner
        transactionExists(transactionId)
        isNotExecuted(transactionId)
    {
        Transaction storage transaction = transactions[transactionId];
        require(
            transaction.amount <= address(this).balance,
            "Insufficient funds"
        );
        require(
            transaction.confirmations >= required,
            "Transaction not fully approved"
        );
        transaction.executed = true;
        (bool success, ) = transaction.receiverAddress.call{
            value: transaction.amount
        }("");
        require(success, "Transaction successful");
        emit Sent(transaction.receiverAddress, transaction.amount);
    }

    function getBalance() external view OnlyOwner returns (uint256 balance) {
        balance = address(this).balance;
    }
}
