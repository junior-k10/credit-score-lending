# 📊 CreditScore Lending Protocol

**CreditScore Lending Protocol** is a decentralized lending system built on the Stacks blockchain. It introduces on-chain credit scoring to determine a user's loan eligibility, collateral requirements, and interest rates. By incentivizing responsible borrowing and loan repayment, the protocol fosters a trust-based lending environment with dynamic, score-based loan terms.

---

## 🌐 Overview

The protocol allows users to:

* Initialize a credit profile
* Request loans based on their credit score
* Repay loans partially or fully
* Improve their credit score with successful repayments
* Be penalized for defaults, reducing future loan benefits

Smart contract logic ensures transparency, automatic score updates, and collateral handling in a decentralized way.

---

## ⚙️ Features

* **Credit-Based Lending**: Credit scores range from 50 to 100, with a minimum of 70 required to borrow.
* **Dynamic Loan Terms**: Lower scores require higher collateral and pay higher interest.
* **On-Chain Credit Scoring**: Users build their score by repaying loans; defaults reduce the score.
* **Collateralized Loans**: Loans are backed by STX collateral transferred to the contract.
* **Loan Management**: Supports multiple active loans per user (up to 5).
* **Admin Controls**: Only the contract owner can mark loans as defaulted after due date.

---

## 🏛️ Contract Architecture

```plaintext
┌────────────────────────────┐
│      User (Borrower)       │
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────┐
│  initialize-score (public) │  ← One-time credit profile setup
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────┐
│     request-loan (public)  │  ← Validate credit, lock collateral, disburse STX
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────┐
│      repay-loan (public)   │  ← Repay partially or fully; return collateral on success
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────┐
│  update-credit-score (priv)│  ← Adjust score after repayment or default
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────┐
│ mark-loan-defaulted (admin)│  ← Admin marks overdue loans
└────────────────────────────┘
```

### Data Maps

* `UserScores`: Tracks user credit info and history.
* `Loans`: Stores loan-specific data.
* `UserLoans`: Maps users to their active loans.

### Contract State

* `next-loan-id`: Auto-increments with new loans.
* `total-stx-locked`: STX held as collateral across loans.

---

## 🧮 Credit Score Rules

* **Initial Score**: 50
* **Score Increase**: +2 per successful loan
* **Score Decrease**: −10 per default
* **Range**: 50 (min) to 100 (max)

---

## 💰 Loan Terms Calculation

* **Collateral Requirement**:

  ```
  required = amount * (100 - (score * 0.5)) / 100
  ```

* **Interest Rate**:

  ```
  interest = 10 - (score * 0.05)
  ```

Higher scores reduce required collateral and lower interest rates, making borrowing more affordable.

---

## 📘 Key Public Functions

| Function              | Description                     |
| --------------------- | ------------------------------- |
| `initialize-score`    | Initializes a user profile      |
| `request-loan`        | Requests a new loan             |
| `repay-loan`          | Repays a loan (partial/full)    |
| `mark-loan-defaulted` | Admin-only: Marks overdue loans |

---

## 🔒 Access Control

* Only the contract owner (deployer) can:

  * Mark loans as defaulted
  * Potentially extend with future admin functionality

---

## 🔍 Read-Only Functions

* `get-user-score`: View credit profile and stats
* `get-loan`: Fetch loan details by ID
* `get-user-active-loans`: List current active loans for a user

---

## 📦 Deployment Notes

* Built for the [Stacks](https://www.stacks.co) blockchain using Clarity
* Contract owner is defined at deployment via `tx-sender`

---

## 🧪 Future Enhancements

* Automated loan defaulting via cron jobs / off-chain monitoring
* NFT-based credit badges or verifiable credentials
* DAO integration for decentralized governance
* Cross-protocol credit score portability
