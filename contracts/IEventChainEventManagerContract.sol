// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @title IEventChainEventManagerContract
 * @dev Interface for EventChainEventManagerContract that manages event creation, ticket minting, and event transfer.
 */
interface IEventChainEventManagerContract {

    /**
     * @dev Creates a new event with the specified details.
     * @param name The name of the event.
     * @param location The location of the event.
     * @param date The date of the event.
     * @param ticketPrice The price of the tickets for the event.
     */
    function createEvent(string memory name, string memory location, string memory date, uint256 ticketPrice) external;

    /**
     * @dev Retrieves the details of a specific event.
     * @param eventId The ID of the event to query.
     * @return An Event struct containing the details of the event.
     */
    function getEventDetails(uint256 eventId) external view returns (Event memory);

    /**
     * @dev Mints a ticket for the specified event and assigns it to the specified address.
     * @param eventId The ID of the event for which to mint the ticket.
     * @param to The address to which the ticket will be minted.
     * @param uri The URI for the ticket metadata.
     */
    function mintTicket(uint256 eventId, address to, string memory uri) external;

    /**
     * @dev Transfers ownership of an event to another organizer.
     * @param eventId The ID of the event to transfer.
     * @param to The address of the new organizer.
     */
    function transferEvent(uint256 eventId, address to) external;

    /**
     * @dev Emitted when a new event is created.
     * @param eventId The ID of the created event.
     * @param name The name of the event.
     * @param location The location of the event.
     * @param date The date of the event.
     * @param ticketPrice The price of the tickets for the event.
     * @param organizer The address of the organizer of the event.
     */
    event EventCreated(uint256 indexed eventId, string name, string location, string date, uint256 ticketPrice, address organizer);

    /**
     * @dev Emitted when an event is transferred to a new organizer.
     * @param eventId The ID of the transferred event.
     * @param fromOrganizer The address of the previous organizer.
     * @param toOrganizer The address of the new organizer.
     */
    event EventTransferred(uint256 indexed eventId, address indexed fromOrganizer, address indexed toOrganizer);


    struct Event {
        string name;
        string location;
        string date;
        uint256 ticketPrice;
        address organizer;
    }
}