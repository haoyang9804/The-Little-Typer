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

(claim double
    (-> Nat Nat))

(define double
    (lambda (n)
        (iter-Nat n
            0
            (+ 2))))


(claim even
    (-> Nat U))

(define even
    (lambda (n)
        (Sigma ((half Nat))
            (= Nat n (double half)))))

(even 10)

(claim even-10-proof
    (even 10))

(define even-10-proof
    (cons 5 (same 10)))

even-10-proof

(claim double_k_is_even
    (Pi ((k Nat))
        (even (double k))))

(define double_k_is_even
    (lambda (k)
        (cons k (same (double k)))))

double_k_is_even

(claim two-greater-than-every-even-number-is-even
    (Pi ((n Nat))
        (-> (even n)
            (even (+ 2 n)))))

(claim mot-two-greater-than-every-even-number-is-even
    (-> Nat Nat U))

(define mot-two-greater-than-every-even-number-is-even
    (lambda (n k)
        (= Nat (+ 2 n) (+ 2 k))))

(define two-greater-than-every-even-number-is-even
    (lambda (n pre)
        (cons 
            (add1 (car pre)) 
                (replace (cdr pre)
                    (mot-two-greater-than-every-even-number-is-even n)
                    (same (+ 2 n))))))

(two-greater-than-every-even-number-is-even 10 (cons 5 (same 10)))

(claim Odd
    (-> Nat U))

(define Odd
    (lambda (n)
        (Sigma ((haf Nat))
            (= Nat n (add1 (double haf))))))

(claim one-is-odd
    (Odd 1))

(define one-is-odd
    (cons 0 (same 1)))

(claim mot-add1-even->odd
    (-> Nat Nat U))

(define mot-add1-even->odd
    (lambda (n k)
        (= Nat (add1 n) (add1 k))))

(claim add1-even->odd
    (Pi ((n Nat))
        (-> (even n)
            (Odd (add1 n)))))

(define add1-even->odd
    (lambda (n)
        (lambda (pre)
            (cons (car pre)
            (replace (cdr pre)
                (mot-add1-even->odd n)
                (same (add1 n)))))))

(add1-even->odd 12 (cons 6 (same 12)))

(claim mot-add1-odd->even
    (-> Nat Nat U))

(define mot-add1-odd->even
    (lambda (n k)
        (= Nat (add1 n) (add1 k))))

(claim add1-odd->even
    (Pi ((n Nat))
        (-> (Odd n)
            (even (add1 n)))))

(define add1-odd->even
    (lambda (n)
        (lambda (pre)
            (cons (add1 (car pre))
                (replace (cdr pre)
                    (mot-add1-odd->even n)
                    (same (add1 n)))))))

(add1-odd->even 13 (cons 6 (same 13)))

(claim even-or-odd
    (Pi ((n Nat))
        (Either (even n) (Odd n))))

(claim mot-even-or-odd
    (-> Nat U))

(define mot-even-or-odd
    (lambda (k)
        (Either (even k) (Odd k))))

(claim step-even-or-odd
    (Pi ((n-1 Nat))
        (-> (mot-even-or-odd n-1)
            (mot-even-or-odd (add1 n-1)))))

(define step-even-or-odd
    (lambda (n-1)
        (lambda (e-or-o_n-1)
            (ind-Either e-or-o_n-1
                (lambda (e-or-o_n-1)
                    (mot-even-or-odd (add1 n-1)))
                    (lambda (e_n-1)
                        (right 
                            (add1-even->odd n-1 e_n-1)))
                            (lambda (o_n-1)
                                (left (add1-odd->even n-1 o_n-1)))))))
(define even-or-odd
    (lambda (n)
        (ind-Nat n
            mot-even-or-odd
            (left (cons 0 (same 0)))
            step-even-or-odd)))

(even-or-odd 2)