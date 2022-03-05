// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyWallet {

    struct Payment {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }


address public owner;
constructor(){
        owner = msg.sender;
    }

    mapping(address => Balance) public balanceReceived;

     modifier onlyOwner(){
        _;
        require(owner == msg.sender, "Only owner can call this function");
        _;
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function sendMoney() external onlyOwner payable {
        balanceReceived[msg.sender].totalBalance += msg.value;

        Payment memory payment = Payment(msg.value, block.timestamp);
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
        
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender].totalBalance, "not enough funds");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
        

    }

    function withdrawAllMoney(address payable _to) public {
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
}
