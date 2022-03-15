// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

contract SIOToken is IERC20 {
    string public name = "SandieIphieOkafor";
    string public symbol = "SIO";
    uint256 public decimals = 18;
    uint256 public override totalSupply = 500000000000;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) approved;

    function transfer(address _to, uint256 _amount)
        public
        override
        returns (bool)
    {
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256)
    {
        uint256 _amount = approved[_owner][_spender];
        return _amount;
    }

    function approve(address _spender, uint256 _amount)
        public
        override
        returns (bool)
    {
        require(
            balanceOf[msg.sender] >= _amount,
            "You do not have sufficient balalnce"
        );
        approved[msg.sender][_spender] += _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        require(approved[_from][msg.sender] >= _amount, "Amount not approved");
        approved[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
}
