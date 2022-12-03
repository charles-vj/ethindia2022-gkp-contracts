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

    function createSoulBoundGate(
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol
    ) public {
        address newSoulBoundKey = address(
            new SoulBoundKey(globalId, _totalKeys, _name, _symbol)
        );
        ISoulBoundKey(newSoulBoundKey).setGatekeeperAddress(address(this));
        idToSoulBoundKey[globalId] = newSoulBoundKey;
        globalId = globalId + 1;
    }

    function createRentedGate(
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol
    ) public {
        address newRentedKey = address(
            new RentedKey(globalId, _totalKeys, _name, _symbol)
        );
        IRentedKey(newRentedKey).setGatekeeperAddress(address(this));
        idToRentedKey[globalId] = newRentedKey;
        globalId = globalId + 1;
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
    }

    function fetchKeyAddress(uint256 _tokenId) external returns (address) {
        return idToRentedKey[_tokenId];
    }
}
