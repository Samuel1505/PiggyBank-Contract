# PiggyBank Smart Contract

## Overview
The **PiggyBank** smart contract allows users to create their own savings accounts with a lock duration. Users can deposit supported ERC20 tokens (USDT, USDC, DAI) and withdraw them after the lock period. Early withdrawals incur a penalty fee. A **PiggyBankFactory** contract is provided to deploy individual **PiggyBank** contracts for users.

## Features
- Users can create their own PiggyBank contracts with a specific purpose and lock duration.
- Supports deposits in **USDT, USDC, and DAI**.
- Users can withdraw funds after the lock duration without penalties.
- Early withdrawals incur a **15% penalty fee**, which is transferred to the factory contract's deployer.
- Tracks balances for each supported token.
- Provides time left until funds can be withdrawn without penalty.

## Contracts
### 1. PiggyBankFactory.sol
This contract is responsible for creating new **PiggyBank** contracts for users.

#### Functions
- `createPiggyBank(string memory _purpose, uint256 _duration)`: Deploys a new **PiggyBank** contract.
- `getUserPiggyBanks(address user)`: Returns the list of PiggyBanks created by a user.

### 2. PiggyBank.sol
This contract manages deposits, withdrawals, and enforces penalties for early withdrawals.

#### Constructor
- `PiggyBank(address _owner, string memory _purpose, uint256 _duration)`: Initializes the contract with the owner, purpose, and duration of the lock period.

#### State Variables
- `owner`: Address of the user who owns the PiggyBank.
- `developer`: Address of the factory contract deployer (receives penalty fees).
- `savingPurpose`: Description of the savings goal.
- `durationEnd`: Timestamp when the lock period ends.
- `PENALTY_FEE`: 15% penalty fee for early withdrawals.
- `balances`: Mapping of token addresses to their deposited balances.

#### Functions
- `deposit(address token, uint256 amount)`: Allows the owner to deposit supported ERC20 tokens.
- `withdraw(address token)`: Allows the owner to withdraw funds. If withdrawn before `durationEnd`, a 15% penalty is applied.
- `isSupportedToken(address token)`: Checks if a token is supported (USDT, USDC, DAI).
- `getBalance(address token)`: Returns the balance of a specific token in the PiggyBank.
- `getTimeLeft()`: Returns the remaining time before funds can be withdrawn without a penalty.

## Deployment
1. Deploy `PiggyBankFactory` contract.
2. Users call `createPiggyBank()` to create their own savings contracts.
3. Users deposit supported tokens using `deposit()`.
4. After the lock period, users can withdraw funds via `withdraw()`.

## Events
- `PiggyBankCreated(address indexed piggyBank, address owner, string purpose)`: Emitted when a new PiggyBank is created.
- `Deposited(address indexed token, uint256 amount)`: Emitted when a deposit is made.
- `Withdrawn(address indexed token, uint256 amount, bool withPenalty)`: Emitted when a withdrawal occurs, indicating if a penalty was applied.

## Security Considerations
- Users must approve the PiggyBank contract to spend their tokens before depositing.
- The contract ensures only the owner can deposit and withdraw funds.
- The contract prevents multiple withdrawals.
- The penalty fee discourages early withdrawals.

## License
This project is licensed under the **MIT License**.

