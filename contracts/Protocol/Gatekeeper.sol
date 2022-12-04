// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./SoulBoundKey.sol";
import "./Interfaces/ISoulBoundKey.sol";
import "./RentedKey.sol";
import "./Interfaces/IRentedKey.sol";

contract Gatekeeper {
    address public admin;

    uint256 public globalId = 0;

    struct NormalGate {
        uint256 id;
        address owner;
        string name;
        mapping(address => bool) whitelistedAccounts;
    }
    mapping(uint256 => NormalGate) public idToNormalGate;

    address public soulBoundKeyTemplate;
    mapping(uint256 => address) public idToSoulBoundKey;

    address public rentedKeyTemplate;
    mapping(uint256 => address) public idToRentedKey;

    // USER DATA
    struct DropIdTokenIdPair {
        uint256 dropId;
        uint256 tokenId;
    }
    mapping(address => DropIdTokenIdPair[]) public userTokens;
    mapping(address => DropIdTokenIdPair[]) public tenants;
    mapping(address => uint256) public userSbkDropLength;
    mapping(address => uint256[]) public userSbkDrops;
    mapping(address => uint256) public userRkDropLength;
    mapping(address => uint256[]) public userRkDrops;
    mapping(address => uint256) public userNftLength;

    constructor() public {
        admin = msg.sender;
    }

    function setTemplates(
        address _soulBoundKeyTemplate,
        address _rentedKeyTemplate
    ) external {
        soulBoundKeyTemplate = _soulBoundKeyTemplate;
        rentedKeyTemplate = _rentedKeyTemplate;
    }

    function createNormalGate(string memory _name, address _owner) public {
        NormalGate storage newGate = idToNormalGate[globalId];
        newGate.id = globalId;
        newGate.owner = _owner;
        newGate.name = _name;
        // idToNormalGate[globalId] = newGate;
        globalId = globalId + 1;
    }

    function whitelistUsingNormalKey(uint256 _id) public {
        idToNormalGate[_id].whitelistedAccounts[msg.sender] = true;
    }

    function fetchWhitelistedContracts(uint256 _id) public view returns (bool) {
        return idToNormalGate[_id].whitelistedAccounts[msg.sender];
    }

    function createSoulBoundGate(
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol
    ) public returns (address) {
        address newSoulBoundKey = address(
            new SoulBoundKey(globalId, _totalKeys, _name, _symbol)
        );
        ISoulBoundKey(newSoulBoundKey).setGatekeeperAddress(address(this));
        idToSoulBoundKey[globalId] = newSoulBoundKey;
        userSbkDrops[msg.sender].push(globalId);
        userSbkDropLength[msg.sender] += 1;
        globalId = globalId + 1;
        return newSoulBoundKey;
    }

    function createRentedGate(
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol
    ) public returns (address) {
        address newRentedKey = address(
            new RentedKey(globalId, _totalKeys, _name, _symbol)
        );
        IRentedKey(newRentedKey).setGatekeeperAddress(address(this));
        idToRentedKey[globalId] = newRentedKey;
        userRkDrops[msg.sender].push(globalId);
        userSbkDropLength[msg.sender] += 1;
        globalId = globalId + 1;
        return newRentedKey;
    }

    function updateTenantData(
        uint256 _gateId,
        uint256 _tokenId,
        address tenant
    ) external {
        require(msg.sender == idToRentedKey[_gateId]);
        tenants[tenant].push(DropIdTokenIdPair(_gateId, _tokenId));
    }

    function updateUserData(
        uint256 _gateId,
        uint256 _tokenId,
        address _user
    ) external {
        require(
            msg.sender == idToRentedKey[_gateId] ||
                msg.sender == idToSoulBoundKey[_gateId]
        );
        userTokens[_user].push(DropIdTokenIdPair(_gateId, _tokenId));
        userNftLength[_user] += 1;
    }

    function fetchKeyAddress(uint256 _tokenId) external returns (address) {
        return idToRentedKey[_tokenId];
    }
}
