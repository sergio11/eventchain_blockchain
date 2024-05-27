# 🎟️ EventChain: Your Ticket to a Secure and Transparent Future

Welcome to **EventChain**, a revolutionary ticketing system leveraging blockchain technology to ensure security, transparency, and trust in event ticketing. EventChain allows event organizers to issue non-fungible tokens (NFTs) as tickets, providing a tamper-proof solution that prevents fraud, enhances traceability, and ensures tickets are always valid and secure.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Smart Contracts](#smart-contracts)
  - [EventManager Contract](#eventmanager-contract)
  - [NftTickets Contract](#nfttickets-contract)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

EventChain is designed to address common issues in traditional ticketing systems, such as counterfeit tickets, ticket scalping, and lack of transparency. By utilizing NFTs on the Ethereum blockchain, EventChain provides a decentralized, secure, and verifiable way to manage tickets for various events including concerts, theater, and cinema.

## Features

- **Secure Ticketing**: Each ticket is minted as an NFT, ensuring uniqueness and preventing counterfeiting.
- **Transparent Ownership**: Track the ownership history of each ticket on the blockchain.
- **Expiration Control**: Set expiration dates for tickets to ensure they can only be used within a valid timeframe.
- **Event Management**: Organizers can create events and manage ticket issuance through the EventManager contract.
- **Resale Control**: Set maximum resale prices to prevent ticket scalping and protect consumers.
- **Auditable Events**: Emit events for actions like minting, transferring, validating, and burning tickets to enable full transparency.

## Smart Contracts

### EventManager Contract

The `EventManager` contract is responsible for creating and managing events. It interacts with the `NftTickets` contract to mint tickets for specific events.

#### Key Functions

- **createEvent**: Create a new event with details such as name, location, date, and ticket price.
- **getEventDetails**: Retrieve details of a specific event.
- **mintTicket**: Mint a new ticket for a specified event.

### NftTickets Contract

The `NftTickets` contract is an ERC721 compliant contract that handles the minting, transferring, validating, and burning of tickets.

#### Key Functions

- **safeMint**: Mint a new ticket with details such as event information, original price, and expiration date.
- **validateTicket**: Mark a ticket as used, ensuring it cannot be reused.
- **getTicketHistory**: Retrieve the ownership history of a ticket.
- **getTicketStatus**: Check if a ticket is used and if it is still valid.
- **updateTicketMetadata**: Update the metadata of a ticket.
- **setMaxResalePrice**: Set a maximum resale price for a ticket.
- **burnExpiredTickets**: Burn tickets that have expired to free up resources.

## Installation

To set up the project locally, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/EventChain.git
   cd EventChain
Install dependencies:

bash
Copiar código
npm install
Compile the smart contracts:

bash
Copiar código
npx hardhat compile
Deploy the contracts:

bash
Copiar código
npx hardhat run scripts/deploy.js --network <network>
Usage
Once the contracts are deployed, you can interact with them using a web3-enabled application or directly through scripts.

Create an Event:

javascript
Copiar código
const eventManager = new ethers.Contract(eventManagerAddress, EventManagerABI, signer);
await eventManager.createEvent("Concert", "Madison Square Garden", "2024-06-30", ethers.utils.parseEther("0.1"));
Mint a Ticket:

javascript
Copiar código
await eventManager.mintTicket(eventId, userAddress, ticketURI);
Validate a Ticket:

javascript
Copiar código
const nftTickets = new ethers.Contract(nftTicketsAddress, NftTicketsABI, signer);
await nftTickets.validateTicket(ticketId);
Burn an Expired Ticket:

javascript
Copiar código
await nftTickets.burnExpiredTickets(ticketId);
Contributing
We welcome contributions from the community! Please fork the repository and submit pull requests for any improvements or bug fixes.

Fork the repository.
Create a new branch: git checkout -b feature-branch-name.
Make your changes and commit them: git commit -m 'Add some feature'.
Push to the branch: git push origin feature-branch-name.
Open a pull request.
License
This project is licensed under the MIT License. See the LICENSE file for details.

Thank you for choosing EventChain! Together, let's build a more secure and transparent future for event ticketing. If you have any questions or need further assistance, feel free to open an issue or contact us at dreamsoftware92@gmail.com.