// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IEventChainContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EventChainEventManagerContract is Ownable, IEventChainEventManagerContract {
    using Counters for Counters.Counter;
    Counters.Counter private _eventIdCounter;

    struct Event {
        string name;
        string location;
        string date;
        uint256 ticketPrice;
        address organizer;
    }

    mapping(uint256 => Event) private events;
    IEventChainContract private eventChainContract;

    constructor(address eventChainContractAddress) {
        eventChainContract = IEventChainContract(eventChainContractAddress);
    }

    function createEvent(string memory name, string memory location, string memory date, uint256 ticketPrice) public override {
        uint256 eventId = _eventIdCounter.current();
        _eventIdCounter.increment();
        
        events[eventId] = Event({
            name: name,
            location: location,
            date: date,
            ticketPrice: ticketPrice,
            organizer: msg.sender
        });

        emit EventCreated(eventId, name, location, date, ticketPrice, msg.sender);
    }

    function getEventDetails(uint256 eventId) public view override returns (Event memory) {
        require(eventId < _eventIdCounter.current(), "Event does not exist");
        return events[eventId];
    }

    function mintTicket(uint256 eventId, address to, string memory uri) public override {
        require(eventId < _eventIdCounter.current(), "Event does not exist");
        require(events[eventId].organizer == msg.sender, "Only the event organizer can mint tickets");

        eventChainContract.safeMint(to, uri, events[eventId].name, events[eventId].ticketPrice, block.timestamp + 1 weeks); // Example: Ticket expires in 1 week
    }
}