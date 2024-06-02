// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @title IEventChainContract
 * @dev Interface for EventChainContract that manages ticket minting, validation, metadata updates,
 * maximum resale price settings, and burning expired tickets.
 */
interface IEventChainContract {

    /**
     * @dev Mints a new ticket and assigns it to the specified address.
     * @param to The address to which the ticket will be minted.
     * @param uri The URI for the ticket metadata.
     * @param eventDetails Details of the event associated with the ticket.
     * @param originalPrice The original price of the ticket.
     * @param expirationDate The expiration date of the ticket.
     */
    function safeMint(address to, string memory uri, string memory eventDetails, uint256 originalPrice, uint256 expirationDate) external;

    /**
     * @dev Validates a ticket, marking it as used.
     * @param tokenId The ID of the ticket to validate.
     */
    function validateTicket(uint256 tokenId) external;

    /**
     * @dev Retrieves the ownership history of a ticket.
     * @param tokenId The ID of the ticket to query.
     * @return An array of addresses representing the ownership history of the ticket.
     */
    function getTicketHistory(uint256 tokenId) external view returns (address[] memory);

    /**
     * @dev Retrieves the status of a ticket, indicating whether it has been used and if it is still valid.
     * @param tokenId The ID of the ticket to query.
     * @return isUsed A boolean indicating whether the ticket has been used.
     * @return isValid A boolean indicating whether the ticket is still valid.
     */
    function getTicketStatus(uint256 tokenId) external view returns (bool isUsed, bool isValid);

    /**
     * @dev Updates the metadata of a ticket.
     * @param tokenId The ID of the ticket to update.
     * @param newEventDetails The updated details of the event associated with the ticket.
     * @param newURI The updated URI for the ticket metadata.
     */
    function updateTicketMetadata(uint256 tokenId, string memory newEventDetails, string memory newURI) external;

    /**
     * @dev Sets the maximum resale price for a ticket.
     * @param tokenId The ID of the ticket for which to set the maximum resale price.
     * @param maxPrice The maximum resale price to set.
     */
    function setMaxResalePrice(uint256 tokenId, uint256 maxPrice) external;

    /**
     * @dev Burns an expired ticket, removing it from circulation.
     * @param tokenId The ID of the ticket to burn.
     */
    function burnExpiredTickets(uint256 tokenId) external;

    /**
     * @dev Emitted when a ticket is minted.
     * @param tokenId The ID of the minted ticket.
     * @param owner The address to which the ticket is minted.
     * @param eventDetails Details of the event associated with the ticket.
     * @param originalPrice The original price of the ticket.
     * @param expirationDate The expiration date of the ticket.
     */
    event TicketMinted(uint256 indexed tokenId, address indexed owner, string eventDetails, uint256 originalPrice, uint256 expirationDate);

    /**
     * @dev Emitted when a ticket is transferred from one address to another.
     * @param tokenId The ID of the transferred ticket.
     * @param from The address from which the ticket is transferred.
     * @param to The address to which the ticket is transferred.
     */
    event TicketTransferred(uint256 indexed tokenId, address indexed from, address indexed to);

    /**
     * @dev Emitted when a ticket is validated.
     * @param tokenId The ID of the validated ticket.
     * @param validator The address of the entity that validates the ticket.
     */
    event TicketValidated(uint256 indexed tokenId, address indexed validator);

    /**
     * @dev Emitted when a ticket expires and is burned.
     * @param tokenId The ID of the expired ticket.
     */
    event TicketExpired(uint256 indexed tokenId);

    /**
     * @dev Emitted when the metadata of a ticket is updated.
     * @param tokenId The ID of the ticket whose metadata is updated.
     * @param newEventDetails The updated details of the event associated with the ticket.
     * @param newURI The updated URI for the ticket metadata.
     */
    event TicketMetadataUpdated(uint256 indexed tokenId, string newEventDetails, string newURI);

    /**
     * @dev Emitted when the maximum resale price of a ticket is set.
     * @param tokenId The ID of the ticket for which the maximum resale price is set.
     * @param maxPrice The maximum resale price that is set.
     */
    event TicketMaxResalePriceSet(uint256 indexed tokenId, uint256 maxPrice);
}