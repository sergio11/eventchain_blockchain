// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IEventChainEventManager {

    function createEvent(string memory name, string memory location, string memory date, uint256 ticketPrice) external;
    function getEventDetails(uint256 eventId) external view returns (Event memory);
    function mintTicket(uint256 eventId, address to, string memory uri) external;

    event EventCreated(uint256 indexed eventId, string name, string location, string date, uint256 ticketPrice, address organizer);
}