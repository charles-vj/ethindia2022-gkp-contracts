// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Interfaces/IGatekeeper.sol";

contract RentedKey is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address public gateKeeperAddress;

    uint256 public totalKeys;
    uint256 public globalKey;

    // TODO : Squash 3 mappings into one mapping with struct
    mapping(uint256 => address) public tenants;
    mapping(uint256 => address) public lessors;
    mapping(uint256 => uint256) public deadlines;

    uint256 public deadline;

    constructor(
        uint256 _globalKey,
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol,
        address _lessorAddress
    ) ERC721(_name, _symbol) {
        globalKey = _globalKey;
        totalKeys = _totalKeys;
    }

    function setGatekeeperAddress(address _gatekeeperAddress) public {
        require(gateKeeperAddress == address(0));
        gateKeeperAddress = _gatekeeperAddress;
    }

    modifier onlyLessor(uint256 _tokenId) {
        require(msg.sender == lessors[_tokenId], "Only Lessor");
        _;
    }

    function safeMint(address to, string memory uri) public {
        if (totalKeys != 0) {
            uint256 current = _tokenIdCounter.current();
            require(current < totalKeys, "Total Limit Exceeded");
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        lessors[tokenId] = to;
        IGatekeeper(gateKeeperAddress).updateUserData(globalKey, tokenId, to);
        totalKeys += 1;
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function rent(
        address _tenant,
        uint256 _tokenId,
        uint256 _interval
    ) external {
        require(tenants[_tokenId] == address(0) || block.timestamp > deadline);
        tenants[_tokenId] = _tenant;
        deadlines[_tokenId] = block.timestamp + _interval;
    }

    function terminateRental(uint256 _tokenId) external onlyLessor(_tokenId) {
        require(tenants[_tokenId] != address(0));
        tenants[_tokenId] = address(0);
        deadlines[_tokenId] = block.timestamp;
    }

    // function list() external onlyLessor {

    // }

    function fetchLessor(uint256 _tokenId) external returns (address) {
        return lessors[_tokenId];
    }
}
