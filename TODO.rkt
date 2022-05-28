#lang pie
(claim peas
    TODO)

(claim peas-2
    (Pi ((n Nat))
        TODO))

(claim peas-3
    (Pi ((n Nat))
            (Vec Atom n)))

(define peas-3
    TODO)

(claim peas-4
    (Pi ((n Nat))
        (Vec Atom n)))

(define peas-4
    (lambda (n)
        (ind-Nat n
            (lambda (k)
                (Vec Atom k))
                    TODO
                        TODO)))