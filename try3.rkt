#lang pie

(claim tmp_vector
    (Vec Nat 5))

(define tmp_vector
    (vec:: 10
        (vec:: 2
            (vec:: 3
                (vec:: 4
                    (vec:: 25 vecnil))))))

(claim tmp_list
  (List Nat))

(define tmp_list
  (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 nil))))))

(claim Maybe
    (-> U U))

(define Maybe
    (lambda (X)
        (Either X Trivial)))

(claim nothing
    (Pi ((E U))
        (Maybe E)))

(define nothing
    (lambda (E)
        (right sole)))

(claim just
    (Pi ((E U))
        (-> E
            (Maybe E))))

(define just
    (lambda (E e)
        (left e)))

(claim maybe-head
    (Pi ((E U))
        (-> (List E)
            (Maybe E))))

(define maybe-head
    (lambda (E es)
        (rec-List es
            (nothing E)
            (lambda (e es head_last)
                (just E e)))))

(maybe-head Nat tmp_list)

(claim maybe-tail
    (Pi ((E U))
        (-> (List E)
            (Maybe (List E)))))

(define maybe-tail
    (lambda (E)
        (lambda (es)
            (rec-List es
                (nothing (List E))
                (lambda (e es tail_last)
                    (just (List E) es))))))

(maybe-tail Nat tmp_list)

(claim step-list-ref
    (Pi ((E U))
        (-> Nat
            (-> (List E)
                (Maybe E))
            (-> (List E)
                (Maybe E)))))

(define step-list-ref
    (lambda (E)
        (lambda (n-1 list-ref_n-1)
            (lambda (es)
                (ind-Either (maybe-tail E es)
                    (lambda (maybe_last)
                        (Maybe E))
                    (lambda (not_empty)
                        (list-ref_n-1 not_empty))
                    (lambda (empty)
                        (nothing E)))))))

(claim maybe-ref
    (Pi ((E U))
        (-> Nat (List E)
            (Maybe E))))

(define maybe-ref
    (lambda (E id)
        (rec-Nat id
            (maybe-head E)
                (step-list-ref E))))

(maybe-ref Nat 4 tmp_list)
(maybe-ref Nat 5 tmp_list)

(claim Fin
    (-> Nat
        U))

(define Fin
    (lambda (n)
        (iter-Nat n
            Absurd
            Maybe)))

(Fin 2)


(claim fzero
    (Pi ((n Nat))
        (Fin (add1 n))))

(define fzero
    (lambda (n)
        (nothing (Fin n))))

(fzero 2)

(claim fadd1
    (Pi ((n Nat))
        (-> (Fin n)
            (Fin (add1 n)))))

(define fadd1
    (lambda (n)
        (lambda (i-1)
            (just (Fin n) i-1))))

(fadd1 2 (fadd1 1 (fzero 0)))

(claim base-vec-ref
    (Pi ((E U))
        (-> (Fin 0) (Vec E 0)
            E)))

(define base-vec-ref
    (lambda (E)
        (lambda (no-value-ever es)
            (ind-Absurd no-value-ever E))))

(claim step-vec-ref
    (Pi ((E U)
        (l-1 Nat))
            (-> (-> (Fin l-1)
                    (Vec E l-1)
                    E)
                (-> (Fin (add1 l-1))
                    (Vec E (add1 l-1))
                    E))))

(define step-vec-ref
    (lambda (E l-1)
        (lambda (vec-ref_l-1)
            (lambda (i es)
                (ind-Either i
                    (lambda (i)
                        E)
                    (lambda (i-1)
                        (vec-ref_l-1
                            i-1 (tail es)))
                    (lambda (triv)
                        (head es)))))))

(claim vec-ref
    (Pi ((E U)
        (l Nat))
            (-> (Fin l) (Vec E l)
                E)))

(define vec-ref
    (lambda (E l)
        (ind-Nat l
            (lambda (k)
                (-> (Fin k) (Vec E k) E))
            (base-vec-ref E)
            (step-vec-ref E))))

(vec-ref Nat 5 (fadd1 4 (fadd1 3 (fzero 2))) tmp_vector)

(claim =consequence
    (-> Nat Nat U))

(define =consequence
    (lambda (n j)
        (which-Nat n
            (which-Nat j
                Trivial
                (lambda (j-1)
                    Absurd))
            (lambda (n-1)
                (which-Nat j
                Absurd
                (lambda (j-1)
                    (= Nat n-1 j-1)))))))

(=consequence 0 0)
