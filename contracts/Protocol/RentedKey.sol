// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RentedKey is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 totalKeys;
    uint256 globalKey;

    address public tenantAddress;
    address public lessorAddress;

    uint256 deadline;

    constructor(
        uint256 _globalKey,
        uint256 _totalKeys,
        string memory _name,
        string memory _symbol,
        address _lessorAddress
    ) ERC721(_name, _symbol) {
        globalKey = _globalKey;
        totalKeys = _totalKeys;
        lessorAddress = _lessorAddress;
    }

    modifier onlyLessor() {
        require(msg.sender == lessorAddress, "Only Lessor");
        _;
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        if (totalKeys != 0) {
            uint256 current = _tokenIdCounter.current();
            require(current < totalKeys, "Total Limit Exceeded");
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
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

    function rent(address _tenant, uint256 _interval) external onlyLessor {
        require(tenantAddress == address(0));
        tenantAddress = _tenant;
        deadline = block.timestamp + _interval;
    }

    function terminateRental() external onlyLessor {
        tenantAddress = address(0);
    }
}
