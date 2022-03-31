// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./Variables.sol";

contract CustomModifiers is Variables {
    modifier OnlyOwner() {
        require(
            isOwner[msg.sender],
            "You are not authorised to call this function"
        );
        _;
    }

    modifier isNotApproved(uint256 transactionId) {
        require(
            !approved[transactionId][msg.sender],
            "You have already approved this transaction"
        );
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        require(transactionExist[transactionId], "Transaction does not exist");
        _;
    }

    modifier isNotExecuted(uint256 transactionId) {
        Transaction memory transaction = transactions[transactionId];
        require(
            !transaction.executed,
            "This transaction has already been executed"
        );
        _;
    }
}
