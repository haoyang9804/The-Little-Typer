#lang pie

(claim tmp_vector
 (Vec Nat 5))
(define tmp_vector
 (vec:: 10
   (vec:: 2
     (vec:: 3
       (vec:: 4
         (vec:: 15 vecnil))))))


(claim base-last
    (Pi ((E U))
        (-> (Vec E (add1 zero))
            E)))

(define base-last
    (lambda (E)
        (lambda (v)
            (head v))))

(claim mot-last
    (-> U Nat U))

(define mot-last
    (lambda (E l)
        (-> (Vec E (add1 l))
            E)))

(claim step-last
    (Pi ((E U)
            (l-1 Nat))
                (-> 
                    (-> (Vec E (add1 l-1))
                        E)
                        (-> (Vec E (add1 (add1 l-1)))
                            E))))

(define step-last
    (lambda (E l-1)
        (lambda (answer_l-1)
            (lambda (vec_l)
                (answer_l-1 (tail vec_l))))))

(claim last
    (Pi ((E U)
        (l-1 Nat))
        (-> (Vec E (add1 l-1))
            E)))

(define last
    (lambda (E l-1)
        (ind-Nat l-1
            (mot-last E)
            (base-last E)
            (step-last E))))

(last Nat 4 tmp_vector)


(claim same3
    (= Nat 3 3))

(define same3
    (same 3))
