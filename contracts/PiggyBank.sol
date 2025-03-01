// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PiggyBank {
    
    // state variables
    address public immutable owner;
    address public immutable developer;
    string public savingPurpose;
    uint256 public immutable durationEnd;
    uint256 public constant PENALTY_FEE = 15; // 15% penalty fee
    bool public isWithdrawn;

    // supported tokens
    IERC20 public constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 public constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    mapping(address => uint256) public balances; // token address => balance

    event Deposited(address indexed token, uint256 amount);
    event Withdrawn(address indexed token, uint256 amount, bool withPenalty);

    constructor(address _owner, string memory _purpose, uint256 _duration) {
        owner = _owner;
        developer = msg.sender; // Factory will be the developer
        savingPurpose = _purpose;
        durationEnd = block.timestamp + _duration;
        isWithdrawn = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notWithdrawn() {
        require(!isWithdrawn, "Funds already withdrawn");
        _;
    }

    function deposit(address token, uint256 amount) external onlyOwner notWithdrawn {
        require(isSupportedToken(token), "Unsupported token");
        require(amount > 0, "Amount must be greater than 0");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[token] += amount;

        emit Deposited(token, amount);
    }

    function withdraw(address token) external onlyOwner {
        require(balances[token] > 0, "No balance to withdraw");
        require(isSupportedToken(token), "Unsupported token");

        uint256 amount = balances[token];
        balances[token] = 0;

        if (block.timestamp < durationEnd) {
            // Early withdrawal with penalty
            uint256 penalty = (amount * PENALTY_FEE) / 100;
            uint256 amountAfterPenalty = amount - penalty;

            IERC20(token).transfer(owner, amountAfterPenalty);
            IERC20(token).transfer(developer, penalty);
            
            isWithdrawn = true;
            emit Withdrawn(token, amount, true);
        } else {
            // Normal withdrawal after duration
            IERC20(token).transfer(owner, amount);
            
            isWithdrawn = true;
            emit Withdrawn(token, amount, false);
        }
    }

    function isSupportedToken(address token) public pure returns (bool) {
        return token == address(USDT) || 
               token == address(USDC) || 
               token == address(DAI);
    }

    function getBalance(address token) external view returns (uint256) {
        return balances[token];
    }

    function getTimeLeft() external view returns (uint256) {
        if (block.timestamp >= durationEnd) return 0;
        return durationEnd - block.timestamp;
    }
}