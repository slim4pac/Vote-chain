Vote-Chain Smart Contract

Overview  
**Vote-Chain** is a decentralized voting smart contract built on the **Stacks blockchain**. It provides a transparent, tamper-proof, and trustless mechanism for communities, DAOs, and projects to conduct elections or decision-making processes without relying on centralized authorities.

---

Features
- Create new proposals with unique identifiers.  
- Cast votes securely linked to blockchain principals.  
- Enforce **one-vote-per-principal** to ensure fairness.  
- Retrieve proposal details and final voting results.  
- Immutable, transparent record of all votes.  

---

Functions

Public Functions
- `create-proposal (title (string-ascii 100))`  
  Create a new proposal with a title. Returns the proposal ID.  

- `vote (proposal-id uint) (choice bool)`  
  Cast a vote (`true` for yes, `false` for no) on a given proposal.  

Read-Only Functions
- `get-proposal (proposal-id uint)`  
  Retrieve details of a specific proposal.  

- `get-votes (proposal-id uint)`  
  Get the total number of votes and breakdown for a proposal.  

---

Project Structure


---

Deployment & Testing

Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed for local development.  
- Stacks blockchain development environment.  

Run Tests
```sh
clarinet test
