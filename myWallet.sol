// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyWallet {
    //Events
    event Deposit(address _addr, uint256 amount);
    event Send(address _addr, uint256 amount);
    event Withdraw(address _addr, uint256 amount);

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint256) public balanceReceived;

    // Modifiers
    modifier hasEnough(address _addr, uint256 _amount) {
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
    function sendMoney(address _receiver, uint256 _amount)
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
    function withdrawMoney(uint256 _amount) external hasEnough(owner, _amount) {
        balanceReceived[owner] -= _amount;
        address payable _to = payable(owner);
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Ether not sent");
        emit Withdraw(owner, _amount);
    }

    // Get contract balance address
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Get balance with specific address
    function getBalance(address _addr) external view returns (uint256) {
        return balanceReceived[_addr];
    }
}
