// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "./Interfaces/IGatekeeper.sol";
import "./Interfaces/IRentedKey.sol";

contract Rentalplace {
    address public gatekeeper;
    IGatekeeper.DropIdTokenIdPair[] public listedItems;

    struct Listing {
        // The ID of the listing
        uint256 id;
        // The address of the seller
        address seller;
    }

    mapping(uint256 => Listing) listings;
    uint256 nextId = 0;

    modifier onlyRentedKey(uint256 _globalId) {
        require(
            msg.sender == IGatekeeper(gatekeeper).fetchKeyAddress(_globalId)
        );
        _;
    }

    constructor(address _gatekeeper) {
        gatekeeper = _gatekeeper;
    }

    function listItem(IGatekeeper.DropIdTokenIdPair memory _pair)
        public
        onlyRentedKey(_pair.dropId)
    {
        address rentedKeyAddress = IGatekeeper(gatekeeper).fetchKeyAddress(
            _pair.dropId
        );
        require(
            tx.origin == IRentedKey(rentedKeyAddress).fetchLessor(_pair.tokenId)
        );
        listedItems.push(_pair);
        listings[nextId] = Listing(nextId, tx.origin);
    }

    function rent(IGatekeeper.DropIdTokenIdPair memory _pair, uint256 _interval)
        public
    {
        address rentedKeyAddress = IGatekeeper(gatekeeper).fetchKeyAddress(
            _pair.dropId
        );
        IRentedKey(rentedKeyAddress).rent(msg.sender, _pair.tokenId, _interval);

        for (uint256 i = 0; i < listedItems.length; i++) {}
    }
}
