// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "./Interfaces/IGatekeeper.sol";
import "./Interfaces/IRentedKey.sol";

contract Rentalplace {
    address public gatekeeper;
    IGatekeeper.DropIdTokenIdPair[] public listedItems;

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
    }
}
