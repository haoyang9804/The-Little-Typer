#lang pie

(claim +
  (-> Nat Nat
      Nat))
(define +
  (lambda (x y)
    (rec-Nat x
      y
      (lambda (x-1 almost)
       (add1 almost))))) 

; (claim try1
;     (-> Nat Nat))

; (define try1
;     (lambda (n)
;         (which-Nat n
;             1
;             (+ 1))))

; (try1 2)

(claim resultof=
    (-> Nat Nat U))

(define resultof=
    (lambda (n m)
        (iter-Nat n
            (which-Nat m
                Trivial
                (lambda (m-1)
                    Absurd))
            ()))

;=====

; (claim 0-not-add1
;     (Pi ((n Nat))
;         (-> (= Nat 0 (add1 n))
;             Absurd)))

; (define 0-not-add1
;     (lambda (n)
;         (lambda (0-equals-add1)
;             )))

; ;=====

; (claim mot-sub1
;     (-> Nat U))

; (define mot-sub1
;     (lambda (n)
;         (Pi ((j Nat))
;             (-> (= Nat n (add1 j))
;                 Nat))))

; (claim base-sub1
;     (Pi ((j Nat))
;         (-> (= Nat 0 (add1 j))
;             Nat)))

; (define base-sub1
;     )

; (claim step-sub1
;     ())

; (claim sub1
;     (-> Nat Nat))

; (deinfe sub1
;     (lambda (n)
;         (ind-Nat n
;             )))