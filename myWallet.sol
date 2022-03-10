// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyWallet {
    //Events
    event Deposit(address _addr, uint amount);
    event Send(address _addr, uint amount);
    event Withdraw(address _addr, uint amount);

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint) public balanceReceived;

    // Modifiers
    modifier hasEnough(address _addr, uint _amount) {
        require(balanceReceived[_addr] >= _amount, "Insufficient funds");
        _;
    }

    modifier onlyOwner() {
        _;
        require(owner == msg.sender, "Only owner can call this function");
        _;
    }

    //Receive ether
    receive() external payable {
        balanceReceived[owner] += msg.value;
        emit Deposit(owner, msg.value);
    }

    //Send money
    function sendMoney(address _receiver, uint _amount)
        external
        payable
        onlyOwner
        hasEnough(owner, _amount)
    {
        balanceReceived[_receiver] += _amount;
        balanceReceived[owner] -= _amount;
        emit Send(_receiver, _amount);
    }

    // Withdraw money
    function withdrawMoney(uint _amount) external hasEnough(owner, _amount) {
        balanceReceived[owner] -= _amount;
        address payable _to = payable(owner);
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Ether not sent");
        emit Withdraw(owner, _amount);
    }

    // Get contract balance address
    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }

    // Get balance with specific address
    function getBalance(address _addr) external view returns (uint) {
        return balanceReceived[_addr];
    }
}
