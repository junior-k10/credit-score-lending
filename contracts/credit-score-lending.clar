;; Title: CreditScore Lending Protocol

;; Summary:
;; A decentralized lending protocol on Stacks that uses on-chain credit scoring
;; to determine loan eligibility, collateral requirements, and interest rates.

;; Description:
;; This smart contract implements a credit-based lending system where users build
;; reputation through successful loan repayments. Higher credit scores unlock better
;; loan terms including lower collateral requirements and reduced interest rates.
;; The system incentivizes responsible borrowing while providing a secure lending
;; environment backed by appropriate collateral.

;; Constants

;; Contract administration
(define-constant CONTRACT-OWNER tx-sender)

;; Error codes
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-BALANCE (err u2))
(define-constant ERR-INVALID-AMOUNT (err u3))
(define-constant ERR-LOAN-NOT-FOUND (err u4))
(define-constant ERR-LOAN-DEFAULTED (err u5))
(define-constant ERR-INSUFFICIENT-SCORE (err u6))
(define-constant ERR-ACTIVE-LOAN (err u7))
(define-constant ERR-NOT-DUE (err u8))
(define-constant ERR-INVALID-DURATION (err u9))
(define-constant ERR-INVALID-LOAN-ID (err u10))

;; Credit score thresholds
(define-constant MIN-SCORE u50) ;; Minimum possible credit score
(define-constant MAX-SCORE u100) ;; Maximum possible credit score
(define-constant MIN-LOAN-SCORE u70) ;; Minimum score required for loan eligibility

;; Data Maps

;; Stores user credit profiles
(define-map UserScores
  { user: principal }
  {
    score: uint,
    total-borrowed: uint,
    total-repaid: uint,
    loans-taken: uint,
    loans-repaid: uint,
    last-update: uint,
  }
)

;; Stores individual loan data
(define-map Loans
  { loan-id: uint }
  {
    borrower: principal,
    amount: uint,
    collateral: uint,
    due-height: uint,
    interest-rate: uint,
    is-active: bool,
    is-defaulted: bool,
    repaid-amount: uint,
  }
)

;; Maps users to their active loans
(define-map UserLoans
  { user: principal }
  { active-loans: (list 20 uint) }
)

;; Variables

;; Auto-incrementing loan ID counter
(define-data-var next-loan-id uint u0)

;; Tracks total STX locked as collateral
(define-data-var total-stx-locked uint u0)

;; Public Functions

;; Initialize a new user's credit score
;; This must be called before a user can request any loans
(define-public (initialize-score)
  (let ((sender tx-sender))
    (asserts! (is-none (map-get? UserScores { user: sender })) ERR-UNAUTHORIZED)
    (ok (map-set UserScores { user: sender } {
      score: MIN-SCORE,
      total-borrowed: u0,
      total-repaid: u0,
      loans-taken: u0,
      loans-repaid: u0,
      last-update: stacks-block-height,
    }))
  )
)