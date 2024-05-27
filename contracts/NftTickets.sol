// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact dreamsoftware92@gmail.com
contract NftTickets is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Ticket {
        string eventDetails;
        uint256 originalPrice;
        address[] ownershipHistory;
        bool isUsed;
    }

    mapping(uint256 => Ticket) private tickets;
    mapping(uint256 => uint256) public maxResalePrice;

    event TicketMinted(uint256 indexed tokenId, address indexed owner, string eventDetails, uint256 originalPrice);
    event TicketTransferred(uint256 indexed tokenId, address indexed from, address indexed to);
    event TicketValidated(uint256 indexed tokenId, address indexed validator);
    event TicketMetadataUpdated(uint256 indexed tokenId, string newEventDetails, string newURI);
    event TicketMaxResalePriceSet(uint256 indexed tokenId, uint256 maxPrice);

    constructor() ERC721("NftTickets", "TIC") {}

    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        tickets[tokenId] = Ticket({
            eventDetails: eventDetails,
            originalPrice: originalPrice,
            ownershipHistory: new address ,
            isUsed: false
        });

        tickets[tokenId].ownershipHistory.push(to);

        emit TicketMinted(tokenId, to, eventDetails, originalPrice);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);

        if (from != address(0) && to != address(0)) {
            require(maxResalePrice[tokenId] == 0 || msg.value <= maxResalePrice[tokenId], "Resale price exceeds limit");
            tickets[tokenId].ownershipHistory.push(to);
            emit TicketTransferred(tokenId, from, to);
        }
    }

    function validateTicket(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(!tickets[tokenId].isUsed, "Ticket already used");
        tickets[tokenId].isUsed = true;
        emit TicketValidated(tokenId, msg.sender);
    }

    function getTicketHistory(uint256 tokenId) public view returns (address[] memory) {
        require(_exists(tokenId), "Token does not exist");
        return tickets[tokenId].ownershipHistory;
    }

    function getTicketStatus(uint256 tokenId) public view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return tickets[tokenId].isUsed;
    }

    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        tickets[tokenId].eventDetails = newEventDetails;
        _setTokenURI(tokenId, newURI);
        emit TicketMetadataUpdated(tokenId, newEventDetails, newURI);
    }

    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        maxResalePrice[tokenId] = maxPrice;
        emit TicketMaxResalePriceSet(tokenId, maxPrice);
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
