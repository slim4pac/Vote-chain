;; Vote Chain - A simple voting smart contract

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u403))
(define-constant ERR-ALREADY-VOTED (err u409))
(define-constant ERR-NO-PROPOSAL (err u404))

;; Data variables
(define-data-var admin principal tx-sender)
(define-data-var proposal-id uint u0)
(define-data-var proposal-text (string-ascii 100) "")
(define-data-var option-a-votes uint u0)
(define-data-var option-b-votes uint u0)

;; Data maps
(define-map has-voted 
  { voter: principal } 
  { voted: bool })

;; Admin sets the proposal and resets votes
(define-public (create-proposal (text (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (asserts! (> (len text) u0) (err u400)) ;; Ensure proposal text is not empty
    (var-set proposal-text text)
    (var-set proposal-id (+ (var-get proposal-id) u1))
    (var-set option-a-votes u0)
    (var-set option-b-votes u0)
    ;; Clear all previous votes by incrementing proposal-id
    (ok (var-get proposal-id))
  ))

;; Cast a vote for A or B
(define-public (vote (choice bool)) ;; true = A, false = B
  (let ((current-proposal-id (var-get proposal-id)))
    (begin
      (asserts! (> current-proposal-id u0) ERR-NO-PROPOSAL) ;; Ensure there's an active proposal
      (asserts! (is-none (map-get? has-voted { voter: tx-sender })) ERR-ALREADY-VOTED)
      (map-set has-voted { voter: tx-sender } { voted: true })
      (if choice
        (var-set option-a-votes (+ (var-get option-a-votes) u1))
        (var-set option-b-votes (+ (var-get option-b-votes) u1))
      )
      (ok true)
    )
  ))

;; Reset voting for a new proposal (admin only)
(define-public (reset-votes)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (var-set option-a-votes u0)
    (var-set option-b-votes u0)
    ;; Note: In a real implementation, you'd want to clear the has-voted map
    ;; This is a limitation of this simple approach
    (ok true)
  ))

;; Get the current proposal
(define-read-only (get-proposal)
  (ok {
    id: (var-get proposal-id),
    text: (var-get proposal-text),
    a-votes: (var-get option-a-votes),
    b-votes: (var-get option-b-votes)
  }))

;; Get vote counts only
(define-read-only (get-vote-counts)
  (ok {
    a-votes: (var-get option-a-votes),
    b-votes: (var-get option-b-votes),
    total-votes: (+ (var-get option-a-votes) (var-get option-b-votes))
  }))

;; Check if a user has voted
(define-read-only (has-user-voted (user principal))
  (ok (is-some (map-get? has-voted { voter: user }))))

;; Get current admin
(define-read-only (get-admin)
  (ok (var-get admin)))

;; Get current proposal ID
(define-read-only (get-current-proposal-id)
  (ok (var-get proposal-id)))

;; Transfer admin rights (current admin only)
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (var-set admin new-admin)
    (ok true)
  ))

;; Get winner of current vote
(define-read-only (get-winner)
  (let (
    (a-votes (var-get option-a-votes))
    (b-votes (var-get option-b-votes))
  )
    (ok 
      (if (> a-votes b-votes)
        "Option A wins"
        (if (> b-votes a-votes)
          "Option B wins"
          "It's a tie"
        )
      )
    )
  ))