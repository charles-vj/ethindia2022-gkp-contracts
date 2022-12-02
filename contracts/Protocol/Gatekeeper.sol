// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

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

    address soulBoundKeyTemplate;
    address rentedKeyTemplate;

    constructor() public {
        admin = msg.sender;
    }

    function createNormalGate(string memory _name, address _owner) {
        NormalGate newGate = new NormalGate;
        newGate.id = normalKeyCount;
        newGate.owner = _owner;
        newGate.name = _name;
        idToNormalGate[normalKeyCount] = newGate;
        normalKeyCount = normalKeyCount + 1;
    }
}
