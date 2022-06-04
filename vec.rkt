#lang pie

(claim tmp_list
  (List Nat))

(define tmp_list
  (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 nil))))))

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

(claim mot-vec-append
    (Pi ((l Nat)
        (E U)
        (n Nat))
            (-> (Vec E n)
                U)))


; In the definition of `mot-vec-append`, if we change the order of `n` and `l`,
; we will encounter a compilation crash because (+ l (add1 n)) could not be
; translated into a form where add1 is at the top, therefore it's not a
; justifiable form for representing the length of a Vec.
(define mot-vec-append
    (lambda (l E n)
        (lambda (vec)
            (Vec E (+ n l)))))


(claim step-vec-append
    (Pi ((E U)
        (l Nat)
        (k Nat)
        (e E)
        (es (Vec E k)))
            (-> (mot-vec-append l E k es)
                (mot-vec-append l E (add1 k) (vec:: e es)))))

(define step-vec-append
    (lambda (E l k e es)
        (lambda (almost)
            (vec:: e almost))))

(claim vec-append
    (Pi ((E U)
        (l1 Nat)
        (l2 Nat))
            (-> (Vec E l1)
                (Vec E l2)
                (Vec E (+ l1 l2)))))

(define vec-append
    (lambda (E l1 l2)
        (lambda (vec1 vec2)
            (ind-Vec l1 vec1
                (mot-vec-append l2 E)
                vec2
                (step-vec-append E l2)))))

(vec-append Nat 5 5 tmp_vector tmp_vector)

(claim step-length
    (Pi ((E U))
        (-> E (List E) Nat Nat)))

(define step-length
    (lambda (E e es n)
        (add1 n)))

(claim length-list
    (Pi ((E U))
            (-> (List E)
                Nat)))

(define length-list
    (lambda (E es)
        (rec-List es
            0
            (step-length E))))

(length-list Nat tmp_list)

(claim mot-list->vec
    (Pi ((E U))
        (-> (List E) U)))

(define mot-list->vec
    (lambda (E es)
        (Vec E (length-list E es))))

(claim step-list->vec
    (Pi ((E U)
        (e E)
        (es (List E)))
            (-> (mot-list->vec E es)
                (mot-list->vec E (:: e es)))))

(define step-list->vec
    (lambda (E e es)
        (lambda (almost)
            (vec:: e almost))))

(claim list->vec
    (Pi ((E U)
        (es (List E)))
            (Vec E (length-list E es))))

(define list->vec
    (lambda (E es)
        (ind-List es
            (mot-list->vec E)
            (the (Vec E 0) vecnil)
            (step-list->vec E))))

(list->vec Nat tmp_list)

(claim mot-vec->list
    (Pi ((E U)
        (l Nat))
        (-> (Vec E l)
            U)))

(define mot-vec->list
    (lambda (E l vec)
        (List E)))

(claim base-vec->list
    (Pi ((E U))
        (List E)))

(define base-vec->list
    (lambda (E)
        nil))

(claim step-vec->list
    (Pi ((E U)
        (l Nat)
        (e E)
        (es (Vec E l)))
            (-> (mot-vec->list E l es)
                (mot-vec->list E (add1 l) (vec:: e es)))))

(define step-vec->list
    (lambda (E L e es)
        (lambda (almost)
            (:: e almost))))

(claim vec->list
    (Pi ((E U)
        (l Nat))
            (-> (Vec E l)
                (List E))))

(define vec->list
    (lambda (E l)
        (lambda (vec)
            (ind-Vec l vec
                (mot-vec->list E)
                (base-vec->list E)
                (step-vec->list E)))))

(vec->list Nat 5 tmp_vector)
