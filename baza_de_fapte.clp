; (deffacts
;     (pozitie <nivel> <X> <Y>)
;     (inamic <nivel> <X> <Y>)
;     (lava <nivel> <X> <Y>)
;     (player <nivel> <X> <Y>)
; )

(deffacts fapte
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
    ;(goto 1 3 3)
	(iesire 1 5 5)
)

; (defglobal ?*len* 3)

;REGULI CARE DAU SUBSCOPURI IN FUCNTIE DE NIVELUL LA CARE SE AFLA PLAYER-UL

(defrule goal-intrare (declare (salience 10))

    (player ?nivel_player ?x ?y_player)
    
    (intrare ?nivel_intrare ?x_intrare ?y_intrare)
    
    (diamant 3 ?x_diamant ?y_diamant)
    
    (not (goto ?nivel ? ? ))
    
    =>
    (if (eq ?nivel_player ?nivel_intrare)
        then
        (assert (goto ?nivel_intrare  ?x_intrare ?y_intrare))
    else    
        (if (eq ?nivel_player 3)
            then
            (assert (goto 3 ?x_intrare ?y_intrare))
        )
    )
)

; (if (and (eq ?nivel 1) (eq ?nivel_player ?nivel))
        ; then
        ; (assert (goto ?nivel  ?x_intrare ?y_intrare))
    ; else    
        ; (if (and (eq ?nivel 2) (eq ?nivel_player ?nivel))
            ; then
            ; (assert (goto ?nivel  ?x_intrare ?y_intrare))
        ; else 
            ; (if (eq ?nivel_player 3)
                ; then
                ; (assert (goto ?nivel ?x_diamant ?y_diamant))
            ; )
        ; )
    ; )

(defrule goal-iesire (declare (salience 10))

    (player ?nivel_player ? ?)
    
    (iesire ?nivel_iesire ?x_iesire ?y_iesire)
    
    (not (diamant 3 ? ?))
    
    (not (goto ?nivel_iesire ? ? ))

    =>
    (if (eq ?nivel_player ?nivel_iesire)
        then
        (assert (goto ?nivel_iesire ?x_iesire ?y_iesire))
    else    
        (printout out "EROARE LA GOAL IESIRE" crlf)
    )
)

; (if (and (eq ?nivel 3) (eq ?nivel_player ?nivel))
        ; then
        ; (assert (goto ?nivel  ?x_iesire ?y_iesire))
    ; else    
        ; (if (and (eq ?nivel 2) (eq ?nivel_player ?nivel))
            ; then
            ; (assert (goto ?nivel  ?x_iesire ?y_iesire))
        ; else 
            ; (if (and (eq ?nivel 1) (eq ?nivel_player ?nivel))
                ; then
                ; (assert (goto ?nivel  ?x_iesire ?y_iesire))
            ; )
        ; )
    ; )
 
; REGULI CARE FAC PLAYERUL SA INTRE/IASA SI SA RIDICE DIAMANTUL


; REGULI PENTRU MISCARE
; ComputeMove ca sa calculeze pe ce bloc sa se miste

(defrule ComputeMove
    (goto ? ?xObj ?yObj)
    (player ? ?x ?y)
	(not (destination-reached 1))
	(not (move $?))
    =>
    (if (and (< ?x ?xObj) (eq ?y ?yObj))
        then (assert (move (+ ?x 1) ?y))
    else (if (or (> ?x ?xObj) (eq ?y ?yObj))
        then (assert (move (- ?x 1) ?y))
    else (if (or (eq ?x ?xObj) (> ?y ?yObj))
        then (assert (move ?x (- ?y 1)))
    else (if (or (eq ?x ?xObj) (< ?y ?yObj))
        then (assert (move ?x (+ ?y 1)))))))
		
)

; Move pentru miscare

(defrule Move
    ?player <- (player ?lvl ?xP ?yP)
	?adr <- (move ?dx ?dy)
	(not (destination-reached 1))
    =>
    (retract ?player ?adr)
    (assert (player ?lvl ?dx ?dy))
)

; Destination-reached pentru a verifica daca a ajuns la destinatie

(defrule Destination-reached
	(declare (salience 10))
	(player ? ?x ?y)
	(goto ? ?xDest ?yDest)
	(test (and (eq ?x ?xDest) (eq ?y ?yDest)))
	=>
	(assert (destination-reached 1))
)

; ]
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

