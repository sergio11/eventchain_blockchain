// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IEventChainContract.sol";
import "./IEventChainEventManagerContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title EventChainEventManagerContract
 * @dev This contract manages the creation and organization of events. It allows event organizers
 *      to create events, mint tickets, and transfer event ownership. The contract is owned by an 
 *      owner who can set the address of the associated EventChainContract.
 */
contract EventChainEventManagerContract is Ownable, IEventChainEventManagerContract {

    uint256 private _eventIdCounter; // Counter to keep track of event IDs

    mapping(uint256 => Event) private events; // Mapping from event ID to event details
    address _eventChainContractAddress; // Address of the associated EventChainContract

    /**
     * @dev Initializes the contract by setting a `initialOwner`.
     * @param initialOwner The address of the initial owner of the contract.
     */
    constructor(address initialOwner, address eventChainContractAddress)
        Ownable(initialOwner)
    {
        _eventChainContractAddress = eventChainContractAddress;
    }

    /**
     * @dev Sets the address of the EventChainContract.
     * @param eventChainContractAddress The address of the EventChainContract.
     */
    function setEventChainAddress(address eventChainContractAddress) external onlyOwner() {
        _eventChainContractAddress = eventChainContractAddress;
    }

    /**
     * @dev Creates a new event.
     * @param name The name of the event.
     * @param location The location of the event.
     * @param date The date of the event.
     * @param ticketPrice The price of a ticket for the event.
     */
    function createEvent(string memory name, string memory location, string memory date, uint256 ticketPrice) public override {
        uint256 eventId = _eventIdCounter;
        _eventIdCounter += 1;
        events[eventId] = Event({
            name: name,
            location: location,
            date: date,
            ticketPrice: ticketPrice,
            organizer: msg.sender
        });
       
        emit EventCreated(eventId, name, location, date, ticketPrice, msg.sender);
    }

    /**
     * @dev Returns the details of an event.
     * @param eventId The ID of the event.
     * @return The event details.
     */
    function getEventDetails(uint256 eventId) public view override returns (Event memory) {
        require(eventId < _eventIdCounter, "Event does not exist");
        return events[eventId];
    }

    /**
     * @dev Mints a ticket for an event.
     * @param eventId The ID of the event.
     * @param to The address of the recipient.
     * @param uri The URI of the ticket metadata.
     */
    function mintTicket(uint256 eventId, address to, string memory uri) public override {
        require(eventId < _eventIdCounter, "Event does not exist");
        require(events[eventId].organizer == msg.sender, "Only the event organizer can mint tickets");
        require(_eventChainContractAddress != address(0), "Event chain contract address is not set");
        require(address(this).balance == 0, "Cannot mint ticket with pending transactions");

        IEventChainContract eventChainContract = IEventChainContract(_eventChainContractAddress);
        eventChainContract.safeMint(to, uri, events[eventId].name, events[eventId].ticketPrice, block.timestamp + 1 weeks); // Ticket expires in 1 week
    }

    /**
     * @dev Transfers the ownership of an event.
     * @param eventId The ID of the event.
     * @param to The address of the new owner.
     */
    function transferEvent(uint256 eventId, address to) external onlyOwner {
        Event storage currentEvent = events[eventId];
        require(currentEvent.organizer == msg.sender, "Only the event organizer can transfer the event");

        currentEvent.organizer = to;
        emit EventTransferred(eventId, msg.sender, to);
    }
}