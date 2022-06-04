#lang pie

(claim tmp_list
  (List Nat))

(define tmp_list
  (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 nil))))))

(claim maybe
    (-> U U))

(define maybe
    (lambda (E)
        (Either E Trivial)))

(claim nothing
    (Pi ((E U))
        (maybe E)))

(define nothing
    (lambda (E)
        (right sole)))

(claim just
    (Pi ((E U))
        (-> E
            (maybe E))))

(define just
    (lambda (E)
        (lambda (e)
            (left e))))

(claim step-maybe-head
    (Pi ((E U))
        (-> E (List E)
            (maybe E)
            (maybe E))))

(define step-maybe-head
    (lambda (E e es last)
        (just E e)))

(claim maybe-head
    (Pi ((E U))
        (-> (List E)
            (maybe E))))

(define maybe-head
    (lambda (E es)
        (rec-List es
            (nothing E)
            (step-maybe-head E))))

(maybe-head Nat tmp_list)
(maybe-head Nat nil)

(claim step-maybe-tail
    (Pi ((E U))
        (-> E (List E) (maybe (List E))
            (maybe (List E)))))

(define step-maybe-tail
    (lambda (E e es almost)
        (just (List E) es)))

(claim maybe-tail
    (Pi ((E U))
        (-> (List E)
            (maybe (List E)))))

(define maybe-tail
    (lambda (E es)
        (rec-List es
            (nothing (List E))
            (step-maybe-tail E))))
    

(maybe-tail Nat tmp_list)
(maybe-tail Nat nil)

(claim step-maybe-ref
    (Pi ((E U))
        (-> 
            Nat
            (-> (List E)
                (maybe E))
            (-> (List E)
                (maybe E)))))

(define step-maybe-ref
    (lambda (E n)
        (lambda (almost)
            (lambda (es)
                (ind-Either (maybe-tail E es)
                    (lambda (maybe-ins)
                        (maybe E))
                    (lambda (not-empty)
                        (almost not-empty))
                    (lambda (empty)
                        (nothing E)))))))

(claim maybe-ref
    (Pi ((E U))
        (-> Nat
            (List E)
            (maybe E))))

(define maybe-ref
    (lambda (E n)
        (rec-Nat n
            (maybe-head E)
            (step-maybe-ref E))))

(maybe-ref Nat 5 tmp_list)
(maybe-ref Nat 4 tmp_list)