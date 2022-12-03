// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Interfaces/IGatekeeper.sol";

contract SoulBoundKey is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address public gateKeeperAddress;

    uint256 public totalKeys;
    uint256 public globalKey;

    constructor(uint256 _globalKey, uint256 _totalKeys)
        ERC721("SoulBoundKey", "SBK")
    {
        globalKey = _globalKey;
        totalKeys = _totalKeys;
    }

    function setGatekeeperAddress(address _gatekeeperAddress) public {
        require(gateKeeperAddress == address(0));
        gateKeeperAddress = _gatekeeperAddress;
    }

    function safeMint(address to) public {
        if (totalKeys != 0) {
            uint256 current = _tokenIdCounter.current();
            require(current < totalKeys, "Total Limit Exceeded");
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        IGatekeeper(gateKeeperAddress).updateUserData(globalKey, tokenId, to);
        totalKeys += 1;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        require(from == address(0), "Err: token transfer is BLOCKED");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
