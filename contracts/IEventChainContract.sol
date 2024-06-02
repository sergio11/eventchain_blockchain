// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IEventChain {

    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice, uint256 expirationDate) external;
    function validateTicket(uint256 tokenId) external;
    function getTicketHistory(uint256 tokenId) external view returns (address[] memory);
    function getTicketStatus(uint256 tokenId) external view returns (bool isUsed, bool isValid);
    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) external;
    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) external;
    function burnExpiredTickets(uint256 tokenId) external;

    event TicketMinted(uint256 indexed tokenId, address indexed owner, string eventDetails, uint256 originalPrice, uint256 expirationDate);
    event TicketTransferred(uint256 indexed tokenId, address indexed from, address indexed to);
    event TicketValidated(uint256 indexed tokenId, address indexed validator);
    event TicketExpired(uint256 indexed tokenId);
    event TicketMetadataUpdated(uint256 indexed tokenId, string newEventDetails, string newURI);
    event TicketMaxResalePriceSet(uint256 indexed tokenId, uint256 maxPrice);
}