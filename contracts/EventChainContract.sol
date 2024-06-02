// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./IEventChainContract.sol";

contract EventChainContract is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, IEventChainContract {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Ticket {
        string eventDetails;
        uint256 originalPrice;
        uint256 expirationDate;
        address[] ownershipHistory;
        bool isUsed;
    }

    mapping(uint256 => Ticket) private tickets;
    mapping(uint256 => uint256) public maxResalePrice;

    constructor() ERC721("EventChainTickets", "ECT") {}

    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice, uint256 expirationDate) public override onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        tickets[tokenId] = Ticket({
            eventDetails: eventDetails,
            originalPrice: originalPrice,
            expirationDate: expirationDate,
            ownershipHistory: new address[],
            isUsed: false
        });

        tickets[tokenId].ownershipHistory.push(to);

        emit TicketMinted(tokenId, to, eventDetails, originalPrice, expirationDate);
    }

    function validateTicket(uint256 tokenId) public override onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(!tickets[tokenId].isUsed, "Ticket already used");
        require(_isTicketValid(tokenId), "Ticket has expired");
        tickets[tokenId].isUsed = true;
        emit TicketValidated(tokenId, msg.sender);
    }

    function getTicketHistory(uint256 tokenId) public view override returns (address[] memory) {
        require(_exists(tokenId), "Token does not exist");
        return tickets[tokenId].ownershipHistory;
    }

    function getTicketStatus(uint256 tokenId) public view override returns (bool isUsed, bool isValid) {
        require(_exists(tokenId), "Token does not exist");
        isUsed = tickets[tokenId].isUsed;
        isValid = _isTicketValid(tokenId);
    }

    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) public override onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        tickets[tokenId].eventDetails = newEventDetails;
        _setTokenURI(tokenId, newURI);
        emit TicketMetadataUpdated(tokenId, newEventDetails, newURI);
    }

    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) public override onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        maxResalePrice[tokenId] = maxPrice;
        emit TicketMaxResalePriceSet(tokenId, maxPrice);
    }

    function burnExpiredTickets(uint256 tokenId) public override onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(!_isTicketValid(tokenId), "Ticket is still valid");
        _burn(tokenId);
        emit TicketExpired(tokenId);
    }

    function _isTicketValid(uint256 tokenId) internal view returns (bool) {
        return (block.timestamp <= tickets[tokenId].expirationDate && !tickets[tokenId].isUsed);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);

        require(_isTicketValid(tokenId), "Ticket has expired or been used");

        if (from != address(0) && to != address(0)) {
            tickets[tokenId].ownershipHistory.push(to);
            emit TicketTransferred(tokenId, from, to);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
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
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
