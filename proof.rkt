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

(claim incr
    (-> Nat Nat))

(define incr
    (lambda (n)
        (iter-Nat n
            1
            (+ 1))))

(claim incr=add1
    (Pi ((n Nat))
        (= Nat (incr n) (add1 n))))

(claim base-incr=add1
    (= Nat (incr 0) (add1 0)))

(define base-incr=add1
    (same (add1 0)))

(claim mot-incr=add1
    (-> Nat U))

(define mot-incr=add1
    (lambda (n)
        (= Nat (incr n) (add1 n))))

; (claim step-incr=add1
;     (Pi ((n Nat))
;         (-> (mot-incr=add1 n)
;             (mot-incr=add1 (add1 n)))))

; (define step-incr=add1
;     (lambda (l+1)
;         (lambda (almost-func)
;             (almost-func ))))

(claim step-incr=add1
    (Pi ((n-1 Nat))
        (-> (= Nat
                (incr n-1)
                (add1 n-1))
            (= Nat
                (add1
                    (incr n-1))
                (add1
                    (add1 n-1))))))

(define step-incr=add1
    (lambda (n-1)
        (lambda (incr=add1_n-1)
            (cong incr=add1_n-1 (+ 1)))))

(define incr=add1
    (lambda (n)
        (ind-Nat n
            mot-incr=add1
            base-incr=add1
            step-incr=add1)))

(incr=add1 0)

(claim step-incr=add1-2
    (Pi ((n-1 Nat))
        (-> (= Nat
                (incr n-1)
                (add1 n-1))
            (= Nat
                (add1
                    (incr n-1))
                (add1
                    (add1 n-1))))))

; (claim target-incr=add1-2
;     (Pi ((n Nat))
;         ()))

(claim mot-step-incr=add1-2
    (-> Nat Nat
        U))

(define mot-step-incr=add1-2
    (lambda (n-1 k)
        (= Nat
            (add1
                (incr n-1))
            (add1
                k))))

(define step-incr=add1-2
    (lambda (n-1)
        (lambda (incr=add1-2_n-1)
            (replace incr=add1-2_n-1
                (mot-step-incr=add1-2 n-1)
                (same (add1 (incr n-1)))))))

(claim incr=add1-2
    (Pi ((n Nat))
        (= Nat (incr n) (add1 n))))

(define incr=add1-2
    (lambda (n)
        (ind-Nat n
            mot-incr=add1
            base-incr=add1
            step-incr=add1-2)))

(incr=add1-2 20)

(claim double
    (-> Nat Nat))

(define double
    (lambda (n)
        (iter-Nat n
            0
            (+ 2))))

(claim twice
    (-> Nat Nat))

(define twice
    (lambda (n)
        (+ n n)))

(claim double=twice
    (Pi ((n Nat))
        (= Nat (double n) (twice n))))

(claim mot-double=twice
    (-> Nat U))

(define mot-double=twice
    (lambda (n)
        (= Nat (double n) (twice n))))

(claim base-double=twice
    (= Nat (double 0) (twice 0)))

(define base-double=twice
    (same 0))



(claim add1+=+add1
    (Pi ((n Nat)
            (m Nat))
                (= Nat (add1 (+ n m)) (+ n (add1 m)))))

(claim base-add1+=+add1
    (Pi ((m Nat))
        (= Nat (add1 m) (add1 m))))

(define base-add1+=+add1
    (lambda (m)
        (same (add1 m))))

(claim mot-add1+=+add1
    (-> Nat Nat U))

(define mot-add1+=+add1
    (lambda (m n)
        (= Nat (add1 (+ n m)) (+ n (add1 m)))))

(mot-add1+=+add1 1 2)

(claim step-add1+=+add1
    (Pi ((m Nat)
        (n-1 Nat))
        (-> (mot-add1+=+add1 m n-1)
            (mot-add1+=+add1 m (add1 n-1)))))

(define step-add1+=+add1
    (lambda (n-1 m)
        (lambda (almost_same)
            (cong almost_same (+ 1)))))

(define add1+=+add1
    (lambda (n m)
        (ind-Nat n
            (mot-add1+=+add1 m)
            (base-add1+=+add1 m) 
            (step-add1+=+add1 m))))
            
(add1+=+add1 10 12)


(claim mot-step-double-twice
    (-> Nat Nat U))

(define mot-step-double-twice
    (lambda (n-1 m)
        (= Nat (add1 (add1 (double n-1))) (add1 m))))


; (mot-double=twice n-1):= (= Nat (double (add1 n-1)) (twice (add1 n-1)))
; What I want: (= Nat (add1 (add1 (double n-1))) (+ (add1 n-1) (add1 n-1)) )
; (= Nat (add1 (add1 (double n-1))) (add1 (+ n-1 (add1 n-1))) )

; what I want: (add1 (+ n-1 (add1 n-1))) -> (add1 (add1 (+ n-1 n-1)))
; solved by `add1+=+add1`


; double=twice_n-1: (= Nat (double n-1) (+ n-1 n-1))
; add1+=+add1: (= Nat (add1 (+ n m)) (+ n (add1 m)))


(claim step-double=twice
    (Pi ((n-1 Nat))
        (-> 
            (mot-double=twice n-1)
            (mot-double=twice (add1 n-1)))))

(define step-double=twice
    (lambda (n-1)
        (lambda (double=twice_n-1)
            (replace (add1+=+add1 n-1 n-1)
                (mot-step-double-twice n-1)
                (cong double=twice_n-1 (+ 2))))))

(define double=twice
    (lambda (n)
        (ind-Nat n
            mot-double=twice
            base-double=twice
            step-double=twice)))

(double=twice 234)


; (mot-twice-vec T) is the actual motive, where T is any type.
(claim mot-double-vec
    (-> U Nat U))

(define mot-double-vec
    (lambda (T n)
        (-> (Vec T n)
            (Vec T (double n)))))

(claim step-double-vec
    (Pi ((T U)
        (l-1 Nat))
            (->
                (-> (Vec T l-1)
                    (Vec T (double l-1)))
                (-> (Vec T (add1 l-1))
                    (Vec T (double (add1 l-1)))))))

(define step-double-vec
    (lambda (T l-1)
        (lambda (almost_step)
            (lambda (vec_l)
                (vec:: (head vec_l)
                    (vec:: (head vec_l)
                        (almost_step (tail vec_l))))))))

(claim base-double-vec
    (Pi ((T U))
        (-> (Vec T 0)
            (Vec T (double 0)))))

(define base-double-vec
    (lambda (T)
        (lambda (almost)
            vecnil)))

(claim double-vec
    (Pi ((T U)
        (l Nat))
            (-> (Vec T l)
                (Vec T (double l)))))

(define double-vec
    (lambda (T l)
        (ind-Nat l
            (mot-double-vec T)
            (base-double-vec T)
            (step-double-vec T))))

(claim tmp_vector
    (Vec Nat 5))

(define tmp_vector
    (vec:: 10
        (vec:: 2
            (vec:: 3
                (vec:: 4
                    (vec:: 25 vecnil))))))

(double-vec Nat 5 tmp_vector)


(claim twice-Vec
    (Pi ((E U)
        (l Nat))
            (-> (Vec E l)
                (Vec E (twice l)))))

(define twice-Vec
    (lambda (E l)
        (lambda (vec)
            (replace (symm (symm (double=twice l)))
                (lambda (k)
                    (Vec E k))
                (double-vec E l vec)))))

(twice-Vec Nat 5 tmp_vector)





(claim mot-the-n-th-element-of-Vec
    (E))

(define mot-the-n-th-element-of-Vec
    (lambda (nth E l)
        ()))

(claim base-the-n-th-element-of-Vec
    (Pi ((E U)
        (l Nat))
            (-> (Vec E l)
                (E))))

(define base-the-n-th-element-of-Vec
    (lambda (E l)
        (lambda (vec)
            (head vec))))



(claim the-n-th-element-of-Vec 
    (Pi ((E U)
        (l Nat))
            (-> (Vec E l)
                E)))

(define the-n-th-element-of-Vec
    (lambda (E l)
        (lambda (vec)
            (ind-Nat l
                ))))