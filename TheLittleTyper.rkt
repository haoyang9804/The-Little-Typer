#lang pie

(claim tmp_vector
 (Vec Nat 5))
(define tmp_vector
 (vec:: 10
   (vec:: 2
     (vec:: 3
       (vec:: 4
         (vec:: 5 vecnil))))))

; (claim length_list
;   (Pi ((E U))
;     (-> (List E)
;         Nat)))

; (define length_list
;   (lambda (E l)
;     (rec-List l
;       0
;       (lambda (e l_ almost)
;         (add1 almost)))))

; (claim tmp_list
;   (List Nat))

; (define tmp_list
;   (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 nil))))))

; (length_list Nat
;   tmp_list)


; (claim +
;   (-> Nat Nat
;       Nat))
; (define +
;   (lambda (x y)
;     (rec-Nat x
;       y
;       (lambda (x-1 almost)
;        (add1 almost))))) 

; (+ 10 12)

; (claim sum_list
;   (-> (List Nat)
;       Nat))
; (define sum_list
;   (lambda (l)
;     (rec-List l
;       0
;       (lambda (e e::l almost)
;         (+ e almost)))))

; (sum_list tmp_list)


; (claim append
;   (Pi ((E U)
;        )
;     (-> (List E) (List E)
;         (List E))))
; (define append
;   (lambda (typeE)
;     (lambda (list1 list2)
;       (rec-List list1
;         list2
;         (lambda (e list1\e almost)
;           (:: e almost))))))

; (append Nat tmp_list tmp_list)


; (claim snoc (Π ((E U)) (-> (List E) E (List E))))
; (define snoc
;   (λ(E xs e)
;     (rec-List xs
;       (:: e nil)
;       (λ(e es result)
;         (:: e result)
;         )
;       )
;     )
; )

; (snoc Nat tmp_list 6)

; (claim concat
;   (Pi ((E U))
;   (->
;   (List E)
;   (List E)
;   (List E))))
; (define concat
;   (lambda (E)
;     (lambda (list1 list2)
;       (rec-List list2
;         list1
;         (lambda (e list2\e almost)
;           (snoc E almost e))))))
; (concat Nat tmp_list tmp_list)

; (claim first
;   (Pi ((E U)
;          (l Nat))
;        (-> (Vec E (add1 l))
;            E)))

; (define first
;   (lambda (E l)
;     (lambda (v)
;       (head v))))



;(claim try
;  (-> U U))
;(define try
;  (lambda (E)
;  (-> E E)))
;(try Atom)

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

;(first Nat 4 tmp_vector)
;
; (claim mot-peas
;  (-> Nat
;      U))
; (define mot-peas
;  (lambda (k)
;    (Vec Atom k)))

; (claim step-peas
;  (Pi ((l-1 Nat))
;    (-> (mot-peas l-1)
;        (mot-peas (add1 l-1)))))
; (define step-peas
;  (lambda (l-1)
;    (lambda (res_l-1)
;      (vec:: 'pea res_l-1))))
; (claim peas
;  (Pi ((num Nat))
;      (Vec Atom num)))
; (define peas
;  (lambda (num)
;    (ind-Nat num
;      mot-peas
;      (the (Vec Atom 0) vecnil)
;      step-peas)))
; (peas 3)


