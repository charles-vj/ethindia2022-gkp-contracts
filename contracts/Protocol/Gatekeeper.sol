// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./SoulBoundKey.sol";

contract Gatekeeper {
    address public admin;

    uint256 normalKeyCount = 0;
    struct NormalGate {
        uint256 id;
        address owner;
        string name;
        mapping(address => bool) whitelistedAccounts;
    }
    mapping(uint256 => NormalGate) idToNormalGate;

    uint256 soulBoundGateCount = 0;
    address soulBoundKeyTemplate;
    mapping(uint256 => address) idToSoulBoundKey;

    uint256 rentedGateCount = 0;
    address rentedKeyTemplate;
    mapping(uint256 => address) idToRentedGate;

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
        NormalGate storage newGate = idToNormalGate[normalKeyCount];
        newGate.id = normalKeyCount;
        newGate.owner = _owner;
        newGate.name = _name;
        // idToNormalGate[normalKeyCount] = newGate;
        normalKeyCount = normalKeyCount + 1;
    }

    function whitelistUsingNormalKey(uint256 _id) public {
        idToNormalGate[_id].whitelistedAccounts[msg.sender] = true;
    }

    function createSoulBoundGate(uint256 _totalKeys) public {
        address newSoulBoundKey = address(
            new SoulBoundKey(soulBoundGateCount, _totalKeys)
        );
        soulBoundGateCount = soulBoundGateCount + 1;
    }

    function updateTenantData(
        uint256 _gateId,
        uint256 _tokenId,
        address tenant
    ) {}
}
