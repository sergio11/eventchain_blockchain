// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IEventChainContract.sol";

/**
 * @title EventChainContract
 * @dev A contract to manage event tickets as non-fungible tokens (NFTs) using the ERC721 standard.
 *      This contract allows for minting, transferring, and validating event tickets, and provides
 *      mechanisms to track ownership history and set maximum resale prices.
 */
contract EventChainContract is ERC721, ERC721URIStorage, ERC721Burnable, Ownable, IEventChainContract {

    uint256 private _tokenIdCounter;

    struct Ticket {
        string eventDetails;
        uint256 originalPrice;
        uint256 expirationDate;
        address[] ownershipHistory;
        bool isUsed;
    }

    mapping(uint256 => Ticket) private tickets;  // Mapping from token ID to ticket details
    mapping(uint256 => uint256) public maxResalePrice;  // Mapping from token ID to maximum resale price

    /**
     * @dev Initializes the contract by setting a `initialOwner` and token name and symbol.
     * @param initialOwner The address of the initial owner of the contract.
     */
    constructor(address initialOwner)
        ERC721("EventChainTickets", "ECT")
        Ownable(initialOwner)
    {}

    /**
     * @dev Safely mints a new ticket and assigns it to `to`.
     * @param to The address of the recipient.
     * @param uri The URI of the ticket metadata.
     * @param eventDetails The details of the event.
     * @param originalPrice The original price of the ticket.
     * @param expirationDate The expiration date of the ticket.
     */
    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice, uint256 expirationDate) public override {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter += 1;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
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

    /**
     * @dev Validates the ticket by marking it as used.
     * @param tokenId The ID of the ticket to be validated.
     */
    function validateTicket(uint256 tokenId) public override {
        _requireOwned(tokenId);
        require(!tickets[tokenId].isUsed, "Ticket already used");
        require(_isTicketValid(tokenId), "Ticket has expired");
        tickets[tokenId].isUsed = true;
        emit TicketValidated(tokenId, msg.sender);
    }

    /**
     * @dev Returns the ownership history of a ticket.
     * @param tokenId The ID of the ticket.
     * @return An array of addresses representing the ownership history.
     */
    function getTicketHistory(uint256 tokenId) public view override returns (address[] memory) {
        _requireOwned(tokenId);
        return tickets[tokenId].ownershipHistory;
    }

    /**
     * @dev Returns the status of a ticket.
     * @param tokenId The ID of the ticket.
     * @return isUsed Whether the ticket has been used.
     * @return isValid Whether the ticket is still valid.
     */
    function getTicketStatus(uint256 tokenId) public view override returns (bool isUsed, bool isValid) {
        _requireOwned(tokenId);
        isUsed = tickets[tokenId].isUsed;
        isValid = _isTicketValid(tokenId);
    }

    /**
     * @dev Updates the metadata of a ticket.
     * @param tokenId The ID of the ticket to be updated.
     * @param newEventDetails The new event details.
     * @param newURI The new metadata URI.
     */
    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) public override onlyOwner {
        _requireOwned(tokenId);
        tickets[tokenId].eventDetails = newEventDetails;
        _setTokenURI(tokenId, newURI);
        emit TicketMetadataUpdated(tokenId, newEventDetails, newURI);
    }

    /**
     * @dev Sets the maximum resale price for a ticket.
     * @param tokenId The ID of the ticket.
     * @param maxPrice The maximum resale price.
     */
    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) public override onlyOwner {
        _requireOwned(tokenId);
        maxResalePrice[tokenId] = maxPrice;
        emit TicketMaxResalePriceSet(tokenId, maxPrice);
    }

    /**
     * @dev Burns tickets that have expired.
     * @param tokenId The ID of the ticket to be burned.
     */
    function burnExpiredTickets(uint256 tokenId) public override onlyOwner {
        _requireOwned(tokenId);
        require(!_isTicketValid(tokenId), "Ticket is still valid");
        _burn(tokenId);
        emit TicketExpired(tokenId);
    }

    /**
     * @dev Transfers a ticket and updates its ownership history.
     * @param from The address transferring the ticket.
     * @param to The address receiving the ticket.
     * @param tokenId The ID of the ticket to be transferred.
     */
    function transferWithHistoryUpdate(address from, address to, uint256 tokenId) public override onlyOwner {
         _requireOwned(tokenId);
        require(from != address(0) && to != address(0), "Invalid address");
        require(from == ownerOf(tokenId), "Not the token owner");

        tickets[tokenId].ownershipHistory.push(to);
        _transfer(from, to, tokenId);
        emit TicketTransferred(tokenId, from, to);
    }

    /**
     * @dev Internal function to check if a ticket is still valid.
     * @param tokenId The ID of the ticket.
     * @return True if the ticket is valid, false otherwise.
     */
    function _isTicketValid(uint256 tokenId) internal view returns (bool) {
        return (block.timestamp <= tickets[tokenId].expirationDate && !tickets[tokenId].isUsed);
    }

    // The following functions are overrides required by Solidity.

    /**
     * @dev Returns the token URI of a ticket.
     * @param tokenId The ID of the ticket.
     * @return The token URI.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Checks if the contract supports a specific interface.
     * @param interfaceId The interface ID.
     * @return True if the interface is supported, false otherwise.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
