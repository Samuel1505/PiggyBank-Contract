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

    // Create PiggyBank using CREATE2
    function createPiggyBankWithCreate2(
        string memory _purpose,
        uint256 _duration,
        bytes32 _salt
    ) external returns (address) {
        address predictedAddress = getPiggyBankAddress(_purpose, _duration, _salt);
        
        PiggyBank newPiggy = new PiggyBank{salt: _salt}(msg.sender, _purpose, _duration);
        require(address(newPiggy) == predictedAddress, "Deployment failed");
        
        userPiggyBanks[msg.sender].push(address(newPiggy));
        emit PiggyBankCreated(address(newPiggy), msg.sender, _purpose);
        return address(newPiggy);
    }

    // Predict the address of a PiggyBank before deployment
    function getPiggyBankAddress(
        string memory _purpose,
        uint256 _duration,
        bytes32 _salt
    ) public view returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(PiggyBank).creationCode,
            abi.encode(msg.sender, _purpose, _duration)
        );
        
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );
        
        return address(uint160(uint256(hash)));
    }

    function getUserPiggyBanks(address user) external view returns (address[] memory) {
        return userPiggyBanks[user];
    }
}