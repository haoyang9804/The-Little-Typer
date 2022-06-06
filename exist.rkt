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

(claim tmp_vector
    (Vec Nat 5))

(define tmp_vector
    (vec:: 10
        (vec:: 2
            (vec:: 3
                (vec:: 4
                    (vec:: 25 vecnil))))))

(claim short_vector
    (Vec Nat 1))

(define short_vector
    (vec:: 10 vecnil))

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

(claim =consequence-same
    (Pi ((n Nat))
        (=consequence n n)))

(define =consequence-same
    (lambda (n)
        (ind-Nat n
            (lambda (k)
                (=consequence k k))
            sole
            (lambda (n-1 =consequnce_n-1)
                (same n-1)))))

(claim use-Nat=
    (Pi ((n Nat)
        (j Nat))
            (-> (= Nat n j)
                (=consequence n j))))

(define use-Nat=
    (lambda (n j)
        (lambda (n=j)
            (replace n=j
                (lambda (k)
                    (=consequence n k))
                (=consequence-same n)))))

(claim zero-not-add1
    (Pi ((n Nat))
        (-> (= Nat 0 (add1 n))
            Absurd)))

(define zero-not-add1
    (lambda (n)
        (use-Nat= 0 (add1 n))))

(claim donut-absurdity
    (-> (= Nat 0 6)
        (= Atom 'powdered 'glazed)))

(define donut-absurdity
    (lambda (0=6)
        (ind-Absurd (zero-not-add1 5 0=6)
            (= Atom 'powdered 'glazed))))

(claim mot-front
    (Pi ((E U)
        (k Nat))
            (-> (Vec E k)
                U)))

(define mot-front
    (lambda (E k es)
        (Pi ((j Nat))
            (-> (= Nat k (add1 j))
                E))))

(claim step-front
    (Pi ((E U)
        (k Nat)
        (e E)
        (es (Vec E k)))
            (-> (mot-front E k es)
                (mot-front E (add1 k) (vec:: e es)))))

(define step-front
    (lambda (E k e es)
        (lambda (step-front_es)
            (lambda (j eq)
                e))))

(claim front
    (Pi ((E U)
        (n Nat))
            (-> (Vec E (add1 n))
                E)))

(define front
    (lambda (E n)
        (lambda (vec)
            ((ind-Vec (add1 n) vec
                (mot-front E)
                (lambda (j eq)
                    (ind-Absurd
                        (zero-not-add1 j eq)
                        E))
                (step-front E))
                n (same (add1 n)))
                )))

(front Nat 4 tmp_vector)
(front Nat 0 short_vector)


; (claim mot-sub1
;     (-> Nat U))

; (define mot-sub1
;     (lambda (l)
;         (-> (Fin l)
;             Nat)))

; (claim base-sub1
;     (-> (Fin 0) Nat))

; (define base-sub1
;     (lambda (fin0)
;         (ind-Absurd fin0
;             Nat)))

; (claim step-sub1
;     (Pi ((n Nat))
;         (-> 
;             (-> (Fin n) Nat)
;             (-> (Fin (add1 n)) Nat))))

; (define step-sub1
;     (lambda (n)
;         (lambda (sub1_n)
;             (lambda (fin_add1_n)
;                 (ind-Either fin_add1_n
;                     (lambda (either) Nat)
;                     (lambda (l)
;                         (add1 (fin_add1_n l)))
;                     (lambda (r)
;                         ))))))

; (claim sub1
;     (-> Nat U))

; (define sub1
;     (lambda (l)
;         (ind-Nat l
;             mot-sub1
;             base-sub1
;             )))



; (claim mot-drop-last
;     (Pi ((E U)
;         (l Nat))
;             (-> (Vec E (add1 l)
;                 U))))

; (define mot-drop-last
;     (lambda (E l vec)
;         (Pi ((j Nat))
;             (-> (= Nat l (add1 j))
;                 (Vec E l)))))

; (claim step-drop-last
;     (Pi ((E U)
;         (l Nat)
;         (e E)
;         (es (Vec E l)))
;             (-> 
;                 (mot-drop-last E l es)
;                 (mot-drop-last E (add1 l) (vec:: e es)))))

; (define step-drop-last
;     (lambda (E l e es drop-last_l)
;         (vec:: e (drop-last_l ))))

; (claim drop-last
;     (Pi ((E U)
;         (l Nat))
;             (-> (Vec E (add1 l))
;                 (Vec E l))))

; (define drop-last
;     (lambda (E l)
;         (lambda (vec)
;             (ind-Vec (add1 l) vec
;                 (mot-drop-last E)
;                 (lambda (j eq)
;                     (ind-Absurd
;                         (zero-not-add1 j eq)
;                         E))
;                 ))))

(claim pem-not-false
    (Pi ((X U))
        (-> (-> (Either X
                    (-> X Absurd))
                Absurd)
            Absurd)))

(define pem-not-false
    (lambda (X)
        (lambda (perm-false)
            (perm-false
                (right 
                    (lambda (x)
                        (perm-false (left x))))))))

; Dec is an abbreviation for "decidable"
(claim Dec
    (-> U U))

(define Dec
    (lambda (X)
        (Either X (-> X Absurd))))

(claim pem
    (Pi ((X U))
        (Dec X)))

(claim zero?
    (Pi ((j Nat))
        (Dec (= Nat 0 j))))

(define zero?
    (lambda (j)
        (ind-Nat j
            (lambda (k)
                (Dec (= Nat 0 k)))
            (left (same 0))
            (lambda (j-1 Dec_j-1)
                (right (zero-not-add1 j-1))))))

(claim sub1=
    (Pi ((n Nat)
        (j Nat))
            (-> (= Nat (add1 n) (add1 j))
                (= Nat n j))))

(define sub1=
    (lambda (n j)
        (use-Nat= (add1 n) (add1 j))))

(claim add1-not-zero
    (Pi ((n Nat))
        (-> (= Nat (add1 n) zero)
            Absurd)))

(define add1-not-zero
    (lambda (n)
        (use-Nat= (add1 n) zero)))

(claim dec-add1
    (Pi ((n-1 Nat)
        (j-1 Nat))
            (-> (Dec (= Nat n-1 j-1))
                (Dec (= Nat (add1 n-1) (add1 j-1))))))

(define dec-add1
    (lambda (n-1 j-1 eq-or-not)
        (ind-Either eq-or-not
            (lambda (target)
                (Dec (= Nat (add1 n-1) (add1 j-1))))
            (lambda (yes)
                (left (cong yes (+ 1))))
            (lambda (no)
                (right 
                    (lambda (n=j)
                        (no
                            (sub1= n-1 j-1
                                n=j))))))))

(claim mot-nat=?
    (-> Nat U))

(define mot-nat=?
    (lambda (k)
        (Pi ((j Nat))
            (Dec (= Nat k j)))))

(claim step-nat=?
    (Pi ((n-1 Nat))
        (-> (mot-nat=? n-1)
            (mot-nat=? (add1 n-1)))))

(define step-nat=?
    (lambda (n-1)
        (lambda (nat=?_n-1)
            (lambda (j)
                (ind-Nat j
                    (lambda (k)
                        (Dec (= Nat (add1 n-1) k)))
                    (right
                        (add1-not-zero n-1))
                    (lambda (j-1 nat=?_n-1)
                        (dec-add1= n-1 j-1
                            (nat=?_n-1))))))))

(claim nat=?
    (Pi ((n Nat)
        (j Nat))
            (Dec (= Nat n j))))

(define nat=?
    (lambda (n j)
        ((ind-Nat n
            mot-nat=?
            zero?
            step-nat=?))
            j))