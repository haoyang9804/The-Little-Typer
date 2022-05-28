#lang pie

(claim +
    (-> Nat Nat Nat))

(claim step-+
    (-> Nat Nat))

(define step-+
    (lambda (m)
        (add1 m)))

(define +
    (lambda (n m)
        (iter-Nat n
            m
            step-+)))

(+ 12 10)

(claim +1=add1
    (Pi ((n Nat))
        (= Nat (+ 1 n) (add1 n))))

(define +1=add1
    (lambda (n)
        (same (add1 n))))

(+1=add1 13)