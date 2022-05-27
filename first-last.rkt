#lang pie

(claim tmp_vector
 (Vec Nat 5))
(define tmp_vector
 (vec:: 10
   (vec:: 2
     (vec:: 3
       (vec:: 4
         (vec:: 25 vecnil))))))

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
      (-> (mot-last E l-1)
        (mot-last E (add1 l-1)))))

(define step-last
  (lambda (E l-1)
    (lambda (last_l-1) ;last_l-1 is a (-> (Vec E add1 l-1) E)
      (lambda (es) ;es is a (Vec E (add1 (add1 l-1)))
        (last_l-1 (tail es))))))

(claim last
  (Pi ((E U)
        (l Nat))
      (-> (Vec E (add1 l))
        E)))

(define last
  (lambda (E l)
    (ind-Nat l
      (mot-last E)
      (base-last E)
      (step-last E)
      )))

(last Nat 4 tmp_vector)

(claim first
  (Pi ((E U)
         (l Nat))
       (-> (Vec E (add1 l))
           E)))

(define first
  (lambda (E l)
    (lambda (v)
      (head v))))

(first Nat 4 tmp_vector)


(claim base-drop-last
  (Pi ((E U))
    (-> (Vec E (add1 zero))
      (Vec E zero))))

(define base-drop-last
  (lambda (E)
    (lambda (v)
      (the (Vec E 0) vecnil))))

(claim mot-drop-last
  (-> U Nat U))

(define mot-drop-last
  (lambda 
    (E l-1)
        (-> (Vec E (add1 l-1))
          (Vec E l-1))))

(claim step-drop-last
  (Pi 
    ((E U)
      (l Nat))
        (-> 
          (-> (Vec E (add1 l))
            (Vec E l))
              (-> (Vec E (add1 (add1 l)))
                (Vec E (add1 l))))))

(define step-drop-last
  (lambda
    (E l)
      (lambda (answer_l-1)
        (lambda (vec_l)
          (vec:: (head vec_l) (answer_l-1 (tail vec_l)))))))

(claim drop-last
  (Pi ((E U)
        (l-1 Nat))
          (-> (Vec E (add1 l-1))
            (Vec E l-1))))

(define drop-last
  (lambda (E l)
    (ind-Nat l
      (mot-drop-last E)
      (base-drop-last E)
      (step-drop-last E))))

(drop-last Nat 4 tmp_vector)