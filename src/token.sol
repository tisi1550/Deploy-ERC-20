// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
        totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_balances[msg.sender] >= _value, "Insufficient balance");
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        uint256 allowance_ = _allowances[_from][msg.sender];
        require(_balances[_from] >= _value, "Insufficient balance");
        require(allowance_ >= _value, "Allowance exceeded");
        _balances[_to] += _value;
        _balances[_from] -= _value;
        _allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(address _recipient, uint256 _value) public returns (bool) {
        _balances[_recipient] += _value;
        totalSupply += _value;
        emit Transfer(address(0), _recipient, _value);
        return true;
    }
}
