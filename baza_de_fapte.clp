; (deffacts
;     (pozitie <nivel> <X> <Y>)
;     (inamic <nivel> <X> <Y>)
;     (lava <nivel> <X> <Y>)
;     (player <nivel> <X> <Y>)
; )

(deffacts 
    (pozitie 1 1 1)
    (pozitie 1 1 2)
    (pozitie 1 1 3)
    (pozitie 1 2 1)
    (pozitie 1 2 2)
    (pozitie 1 2 3)
    (pozitie 1 3 1)
    (pozitie 1 3 2)
    (pozitie 1 3 3)    
    (inamic 1 2 2)
    (lava 1 2 3)
    (player 1 1 1)
    (goto 1 3 3)

    (move-diag 0 0)
)

(defglobal ?*len* 3)


; move diagonally
(defrule ComputeDiag
    (declare (salience 10))
    (goto 1 ?xObj ?yObj)
    (player 1 ?x ?y)
    (test (neq(?x ?xObj)))
    (test (neq(?y ?yObj)))
    ?adr <- (move-diag ? ?dx ?dy)
    (test (< ?dx ?*len*))
    (test (< ?dy ?*len*))
    =>
    (retract ?adr)
    (assert (move-diag (+ ?x 1) (+ ?y 1))
)

(defrule MoveDiag
    (declare (salience 11))
    (move-diag ?lvl ?x ?y)
    ?adr <-(player ?lvl ?xP ?yP)
    (test (neq(?xP ?x)))
    (test (neq(?yP ?y)))
    (test (< ?xP ?*len*))
    (test (< ?yP ?*len*))
    =>
    (retract ?adr)
    (assert (player ?x ?y))
)



; (defrule ComputeDirection
;     (declare (salience 10))
;     (goto 1 ?xObj ?yObj)
;     (player 1 ?x ?y)
;     (test (neq(?x ?xObj)))
;     =>
;     (retract ?adrDx)
;     (retract ?adrDy)
;     (assert (move-diag (+ ?x 1) )
; )
; move to the right ( x + 1 )

