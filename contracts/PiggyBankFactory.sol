// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./PiggyBank.sol";

contract PiggyBankFactory {
    event PiggyBankCreated(address indexed piggyBank, address owner, string purpose);

    mapping(address => address[]) public userPiggyBanks;

    // Create PiggyBank using new keyword
    function createPiggyBank(string memory _purpose, uint256 _duration) external returns (address) {
        PiggyBank newPiggy = new PiggyBank(msg.sender, _purpose, _duration);
        userPiggyBanks[msg.sender].push(address(newPiggy));
        
        emit PiggyBankCreated(address(newPiggy), msg.sender, _purpose);
        return address(newPiggy);
    }


    function getUserPiggyBanks(address user) external view returns (address[] memory) {
        return userPiggyBanks[user];
    }
}