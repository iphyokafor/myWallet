// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Variables {
    uint256 public required;
    uint256 public transactionCount;
    address[] public owners;

    struct Transaction {
        address receiverAddress;
        uint256 amount;
        uint256 confirmations;
        bool executed;
    }

    mapping(address => bool) public isOwner;
    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => bool) public transactionExist;
    mapping(uint256 => mapping(address => bool)) public approved;

    event Submit(address submitter, uint256 transactionId);
    event Deposit(address sender, uint256 amount, uint256 balance);
    event Execute(address executer, uint256 transactionId);
    event Approval(address approver, uint256 transactionId);
    event Sent(address receiver, uint256 transactionId);
}
