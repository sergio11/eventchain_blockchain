# 🎫 EventChain: Revolutionizing Ticketing with Blockchain Technology
Welcome to EventChain! This project leverages the power of blockchain to solve persistent issues in the event ticketing industry such as counterfeit tickets, ticket scalping, and lack of transparency. With EventChain, we aim to create a secure, transparent, and tamper-proof ticketing solution.

<p align="center">
  <img src="https://img.shields.io/badge/Solidity-2E8B57?style=for-the-badge&logo=solidity&logoColor=white" />
  <img src="https://img.shields.io/badge/Alchemy-039BE5?style=for-the-badge&logo=alchemy&logoColor=white" />
  <img src="https://img.shields.io/badge/Remix IDE-3e5f8a?style=for-the-badge&logo=remix&logoColor=white" />
  <img src="https://img.shields.io/badge/Hardhat-E6522C?style=for-the-badge&logo=hardhat&logoColor=white" />
  <img src="https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white" />
  <img src="https://img.shields.io/badge/Smart%20Contracts-8B0000?style=for-the-badge&logo=Ethereum&logoColor=white" />
</p>


## 🌟 Key Features
* 🔒 Secure and Tamper-Proof Tickets: Utilizes non-fungible tokens (NFTs) on the Ethereum blockchain to represent tickets, ensuring they cannot be duplicated or counterfeited.
* 🕵️ Transparent Ownership and Traceability: Every transfer of a ticket is recorded on the blockchain, creating an immutable and auditable ownership history.
* ⏰ Expiration Control and Event Management: Organizers can set expiration dates for tickets, preventing their misuse after the event.
* 💸 Resale Regulation: Allows setting a maximum resale price for tickets to combat scalping.

## 🛠️ Installation
First, clone the repository:

```bash
git clone https://github.com/sergio11/eventchain_blockchain.git
cd eventchain_blockchain
```

Install the necessary dependencies:

```bash
npm install
```

## 💼 Smart Contracts

### 🎟️ EventChainContract
The **EventChainContract** is a cornerstone of the EventChain ticketing ecosystem. It is designed to manage the entire lifecycle of event tickets on the blockchain. This contract leverages the robustness of **Ethereum's ERC721** standard to ensure each ticket is unique, secure, and traceable. Key functionalities include minting new tickets, validating ticket authenticity, updating ticket metadata, and handling resale regulations, all while maintaining an immutable record of ownership history. This ensures a transparent, tamper-proof, and fair ticketing process for both event organizers and attendees.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IEventChainContract.sol";

contract EventChainContract is ERC721, ERC721URIStorage, ERC721Burnable, Ownable, IEventChainContract {
    // Contract implementation
}

```

#### 🔑 Key Functions
* **safeMint:** 🎟️ Mints a new ticket with specified details such as event information, original price, and expiration date. This function ensures the creation of a unique non-fungible token (NFT) representing the ticket on the blockchain.
* **validateTicket:** 🎫 Validates a ticket at the event by marking it as used, preventing multiple uses. This function verifies if the ticket is still within its validity period.
* **getTicketHistory:** 📜 Retrieves the ownership history of a ticket, providing transparency and traceability of ownership changes over time. This history is recorded on the blockchain and is immutable.
* **getTicketStatus:** 🕵️‍♂️ Checks if a ticket is used and still valid, indicating whether it has been used before and if it is still within its validity period.
* **updateTicketMetadata:** 🔄 Updates the metadata of a ticket, allowing modifications to event details associated with the ticket, such as event name, location, or date.
* **setMaxResalePrice:** 💰 Sets a maximum resale price for a ticket, helping organizers regulate ticket resale and prevent scalping.
* **burnExpiredTickets:** 🔥 Burns tickets that have expired, removing them from the system to free up resources and ensure efficient management of ticket inventory.

### 🎟️ EventChainEventManagerContract
The **EventChainEventManagerContract** is the backbone of the EventChain ecosystem, enabling seamless event management, ticket minting, and event transfer functionalities. It empowers organizers to create, manage, and transfer events securely and transparently on the blockchain, ensuring a smooth and reliable ticketing process from start to finish.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IEventChainContract.sol";
import "./IEventChainEventManagerContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventChainEventManagerContract is Ownable, IEventChainEventManagerContract {
    // Contract implementation
}

```

#### 🔑 Key Functions
* **setEventChainAddress:** 🎟️ Sets the address of the EventChainContract, enabling communication between the EventChainEventManagerContract and the EventChainContract.
* **createEvent:** 📅 Creates a new event with specified details such as name, location, date, and ticket price. This function allows event organizers to set up events on the platform.
* **getEventDetails:** 📋 Retrieves the details of a specific event, providing information such as event name, location, date, and ticket price.
* **mintTicket:** 💳 Mints a new ticket for a specific event, allowing event organizers to issue tickets to attendees.
* **transferEvent:** 🔄 Transfers the ownership of an event to another organizer, enabling event management by different entities over time.

## 🚀 Usage

### 📜 Deploying Contracts
To deploy the smart contracts, use **Hardhat Ignition**:

```shell
npx hardhat ignition deploy ignition/modules/EventChain.js --network amoy   
```

```shell
√ Confirm deploy to network amoy (80002)? ... yes
Hardhat Ignition 🚀

Deploying [ EventChain ]

Batch #1
  Executed EventChain#EventChainContract

Batch #2
  Executed EventChain#EventChainEventManagerContract

[ EventChain ] successfully deployed 🚀

Deployed Addresses

EventChain#EventChainContract - 0xd4bC2d72a3f04ad194130ADcC35E9592a2a1761B
EventChain#EventChainEventManagerContract - 0xbaCAfEeEA7F14dE0cD8A1462C0136E429b323345
```

## 🔗 Interacting with Contracts

## 🧪 Testing
To run the tests, use the following command:

tests ensure comprehensive coverage of all smart contract functionalities, validating ticket creation, transfer, and validation mechanisms.




