// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract swapContract {
    // ************State variables**************

    // Totalsupply of Token
    uint256 public linkToken = 10000;
    uint256 public W3BToken = 10000;
    uint256 public decimal = 1e6;
    uint256 public circulatingSupply;

    address owner;

    // Transaction details to submit for the swap
    struct TransactionDetail {
        address to;
        address from;
        uint256 amount;
        uint256 deadline;
    }

    // mapping to check account balance
    mapping(address => uint256) public _balance;

    // mapping to access Transaction details
    mapping(uint256 => TransactionDetail) public swapBalance;

    // mapping to allow spending
    mapping(address => mapping(address => uint256)) public allowed;

    // owner creating the contract
    constructor() {
        owner == msg.sender;
    }

    // return the totalsupply of W3BToken
    function _totalW3BToken() public view returns (uint256) {
        return W3BToken;
    }

    // return the totalsupply of linkToken
    function _totaLinkToken() public view returns (uint256) {
        return linkToken;
    }

    // return decial value of the Tokens
    function _decimal() public view returns (uint256) {
        return decimal;
    }

    // function to allow spending
    function _allowance(address _owner, address spender)
        public
        view
        returns (uint256 allowance)
    {
        require(_owner != address(0), "Not owner");
        allowance = allowed[owner][spender];
    }

    // return the price of linkToken
    function priceLinkToken(uint256 amount)
        external
        returns (uint256 linkPrice)
    {
        circulatingSupply += amount;
        require(circulatingSupply >= W3BToken, "totalSupply Exceeded");

        linkPrice = circulatingSupply * decimal;
    }

    // return the price of W3BToken
    function priceW3BToken(uint256 amount) public returns (uint256 W3BPrice) {
        circulatingSupply += amount;
        require(circulatingSupply >= linkToken, "totalSupply Exceeded");

        W3BPrice = circulatingSupply * decimal * 40;
    }

    // Approval function
    function _approval(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Sending to Address zero");
        allowed[msg.sender][spender] = amount;
        // emit approval(msg.sender, spender, amount);
        return true;
    }

    // transferFrom function returns the amount to swap
    function transferFrom(
        address from,
        address _to,
        uint256 amount
    ) public returns (uint256 swapAmount) {
        require(_to != address(0), "Sending to address zero");
        uint256 spendAllowance = _allowance(from, _to);
        require(amount >= spendAllowance, "Insufficient Fund");
        spendAllowance -= amount;
        _balance[msg.sender] -= amount;
        swapAmount = _balance[_to] += amount;
    }

    // calculate the exchange rate of the Tokens
    function exchange(uint256 _linkToken) public returns (uint256 swapToken) {
        uint256 W3BValue = priceW3BToken(_linkToken);
        swapToken = W3BValue;
    }

    // Swap Function of the Tokens
    function _swap(
        uint256 _AmountOut,
        uint256 _amountInMax,
        address _to,
        address _from,
        uint256 _deadline
    ) external returns (TransactionDetail memory swapValue) {
        require(_to != address(0), "Invalid address");
        require(_from != address(0), "Invalid address");
        require(_deadline > block.timestamp, "Not yet Time");
        transferFrom(msg.sender, address(this), _amountInMax);
        _approval(address(this), _amountInMax);
        require(_AmountOut <= _amountInMax, "Transaction revert");

        uint256 value = exchange(_amountInMax);
        uint256 _amountOut = value * _amountInMax;

        swapValue = swapBalance[_amountInMax];
        swapValue.to = _to;
        swapValue.from = _from;
        swapValue.amount = _amountOut;
        swapValue.deadline = _deadline;
    }
}
