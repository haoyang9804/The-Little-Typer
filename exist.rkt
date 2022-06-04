#lang pie

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