// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IEventChainContract.sol";

contract EventChainContract is ERC721, ERC721URIStorage, ERC721Burnable, Ownable, IEventChainContract {

    uint256 private _tokenIdCounter;

    struct Ticket {
        string eventDetails;
        uint256 originalPrice;
        uint256 expirationDate;
        address[] ownershipHistory;
        bool isUsed;
    }

    mapping(uint256 => Ticket) private tickets;
    mapping(uint256 => uint256) public maxResalePrice;

    constructor(address initialOwner)
        ERC721("EventChainTickets", "ECT")
        Ownable(initialOwner)
    {}

    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice, uint256 expirationDate) public override {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _tokenIdCounter += 1;

        address[] memory emptyHistory = new address[](0);
        tickets[tokenId] = Ticket({
            eventDetails: eventDetails,
            originalPrice: originalPrice,
            expirationDate: expirationDate,
            ownershipHistory: emptyHistory,
            isUsed: false
        });

        tickets[tokenId].ownershipHistory.push(to);

        emit TicketMinted(tokenId, to, eventDetails, originalPrice, expirationDate);
    }

    function validateTicket(uint256 tokenId) public override {
        _requireOwned(tokenId);
        require(!tickets[tokenId].isUsed, "Ticket already used");
        require(_isTicketValid(tokenId), "Ticket has expired");
        tickets[tokenId].isUsed = true;
        emit TicketValidated(tokenId, msg.sender);
    }

    function getTicketHistory(uint256 tokenId) public view override returns (address[] memory) {
        _requireOwned(tokenId);
        return tickets[tokenId].ownershipHistory;
    }

    function getTicketStatus(uint256 tokenId) public view override returns (bool isUsed, bool isValid) {
        _requireOwned(tokenId);
        isUsed = tickets[tokenId].isUsed;
        isValid = _isTicketValid(tokenId);
    }

    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) public override onlyOwner {
        _requireOwned(tokenId);
        tickets[tokenId].eventDetails = newEventDetails;
        _setTokenURI(tokenId, newURI);
        emit TicketMetadataUpdated(tokenId, newEventDetails, newURI);
    }

    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) public override onlyOwner {
        _requireOwned(tokenId);
        maxResalePrice[tokenId] = maxPrice;
        emit TicketMaxResalePriceSet(tokenId, maxPrice);
    }

    function burnExpiredTickets(uint256 tokenId) public override onlyOwner {
        _requireOwned(tokenId);
        require(!_isTicketValid(tokenId), "Ticket is still valid");
        _burn(tokenId);
        emit TicketExpired(tokenId);
    }

    function transferWithHistoryUpdate(address from, address to, uint256 tokenId) public override onlyOwner {
         _requireOwned(tokenId);
        require(from != address(0) && to != address(0), "Invalid address");
        require(from == ownerOf(tokenId), "Not the token owner");

        if (from != address(0) && to != address(0)) {
            tickets[tokenId].ownershipHistory.push(to);
        }

        _transfer(from, to, tokenId);

        emit TicketTransferred(tokenId, from, to);
    }

    function _isTicketValid(uint256 tokenId) internal view returns (bool) {
        return (block.timestamp <= tickets[tokenId].expirationDate && !tickets[tokenId].isUsed);
    }

    // The following functions are overrides required by Solidity.

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
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
