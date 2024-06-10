# 🎫 EventChain: Revolutionizing Ticketing with Blockchain Technology
Welcome to EventChain! This project leverages the power of blockchain to solve persistent issues in the event ticketing industry such as counterfeit tickets, ticket scalping, and lack of transparency. With EventChain, we aim to create a secure, transparent, and tamper-proof ticketing solution.

* 🌟 Key Features
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

### EventChainContract
The **EventChainContract** is a critical component of the EventChain ticketing system, responsible for managing the lifecycle of event tickets on the blockchain network.

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

#### Key Functions

* **safeMint:** Mints a new ticket.
* **validateTicket:** Validates a ticket at the event.
* **getTicketHistory:** Retrieves the ownership history of a ticket.
* **getTicketStatus:** Checks if a ticket is used and still valid.
* **updateTicketMetadata:** Updates the metadata of a ticket.
* **setMaxResalePrice:** Sets a maximum resale price for a ticket.
* **burnExpiredTickets:** Burns tickets that have expired.

### EventChainEventManagerContract

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

#### Key Functions
* **setEventChainAddress:** Sets the address of the EventChainContract.
* **createEvent:** Creates a new event.
* **getEventDetails:** Retrieves the details of an event.
* **mintTicket:** Mints a new ticket for an event.
* **transferEvent:** Transfers the event to another organizer.

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




