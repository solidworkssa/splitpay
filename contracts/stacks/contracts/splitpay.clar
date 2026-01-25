;; SplitPay - Payment distribution

(define-data-var payment-counter uint u0)

(define-map payments uint {
    payer: principal,
    recipient1: principal,
    recipient2: principal,
    amount1: uint,
    amount2: uint,
    distributed: bool
})

(define-constant ERR-INVALID (err u100))

(define-public (create-payment (r1 principal) (r2 principal) (a1 uint) (a2 uint))
    (let (
        (payment-id (var-get payment-counter))
        (total (+ a1 a2)))
        (try! (stx-transfer? total tx-sender (as-contract tx-sender)))
        (try! (as-contract (stx-transfer? a1 tx-sender r1)))
        (try! (as-contract (stx-transfer? a2 tx-sender r2)))
        (map-set payments payment-id {
            payer: tx-sender,
            recipient1: r1,
            recipient2: r2,
            amount1: a1,
            amount2: a2,
            distributed: true
        })
        (var-set payment-counter (+ payment-id u1))
        (ok payment-id)))

(define-read-only (get-payment (payment-id uint))
    (ok (map-get? payments payment-id)))
