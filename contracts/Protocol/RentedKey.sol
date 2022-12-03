// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Interfaces/IGatekeeper.sol";

contract RentedKey is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address public gateKeeperAddress;

    uint256 public totalKeys;
    uint256 public globalKey;

    // TODO : Squash 3 mappings into one mapping with struct
    mapping(uint256 => address) public tenants;
    mapping(uint256 => address) public lessors;
    mapping(uint256 => uint256) public deadlines;

    constructor(
        uint256 _globalKey,
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        globalKey = _globalKey;
        totalKeys = _totalKeys;
    }

    modifier onlyLessor(uint256 _tokenId) {
        require(msg.sender == lessors[_tokenId], "Only Lessor");
        _;
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
        lessors[tokenId] = to;
        IGatekeeper(gateKeeperAddress).updateUserData(globalKey, tokenId, to);
    }

    function rent(
        address _tenant,
        uint256 _tokenId,
        uint256 _interval
    ) external {
        require(
            tenants[_tokenId] == address(0) ||
                block.timestamp > deadlines[_tokenId]
        );
        tenants[_tokenId] = _tenant;
        deadlines[_tokenId] = block.timestamp + _interval;
    }

    function terminateRental(uint256 _tokenId) external onlyLessor(_tokenId) {
        require(tenants[_tokenId] != address(0));
        tenants[_tokenId] = address(0);
        deadlines[_tokenId] = block.timestamp;
    }

    function fetchLessor(uint256 _tokenId) external returns (address) {
        return lessors[_tokenId];
    }
}
