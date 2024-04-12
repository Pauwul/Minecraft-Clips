; (deffacts
;     (pozitie <nivel> <X> <Y>)
;     (inamic <nivel> <X> <Y>)
;     (lava <nivel> <X> <Y>)
;     (player <nivel> <X> <Y>)
; )

(deffacts fapte
	(grid 5)
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
    (player 1 5 5)
	(obstacol 1 2 1)
    ;(goto 1 3 3)
    
	(diamant 3 3 3)
    (intrare 1 3 3)
    (intrare 2 3 3)
    
    (iesire 3 1 1)
    (iesire 2 1 1)
    (iesire 1 1 1)
    
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

(defrule ComputeMoveRight
	(grid ?dim)
    (goto ? ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    (player ? ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (obstacol ? =(+ ?x 1) ?y))
	(not (> =(+ ?x 1) ?dim)) 
    =>
    (if (< ?x ?xObj)
        then (assert (move (+ ?x 1) ?y)))
)

(defrule ComputeMoveLeft
	(grid ?dim)
    (goto ? ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))    
	(player ? ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (obstacol ? =(- ?x 1) ?y))
	(not (< =(- ?x 1) =(- ?dim ?dim)))
    =>
    (if (> ?x ?xObj)
        then (assert (move (- ?x 1) ?y)))
)

(defrule ComputeMoveUp
	(grid ?dim)
    (goto ? ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))    
	(player ? ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (obstacol ? ?x =(- ?y 1)))
	(not (> =(+ ?y 1) ?dim))
    =>
    (if (> ?y ?yObj)
        then (assert (move ?x (- ?y 1))))
)

(defrule ComputeMoveDown
	(grid ?dim)
    (goto ? ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))    
	(player ? ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (obstacol ? ?x =(+ ?y 1)))
	(not (< =(- ?y 1) =(- ?dim ?dim)))
    =>
    (if (< ?y ?yObj)
        then (assert (move ?x (+ ?y 1))))
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

(defrule GameOver
	(declare (salience -1000))
	=>
	(printout t "you lost" crlf)
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


; REGULI CARE FAC PLAYERUL SA INTRE/IASA SI SA RIDICE DIAMANTUL

(defrule terminare-joc 
	?adr1 <- (player 1 ?x_player ?y_player)
    (iesire 1 ?x_iesire ?y_iesire)
	(destination-reached 1)
	=>
	(if (and (eq ?y_player ?y_iesire 1) (eq ?x_player ?x_iesire 1))
	then
		(printout t "YOU WON!")
	)
)
(defrule intrare (declare (salience 9))
	
    ?adr1 <- (player ?nivel_player ?x_player ?y_player)
    (intrare ?nivel_intrare ?x_intrare ?y_intrare)
    (iesire ?next_level ?x_iesire ?y_iesire&:
								(eq ?next_level (+ ?nivel_intrare 1)))
    (diamant 3 ?x_diamant ?y_diamant)
    ?adr2 <- (destination-reached 1)
    =>
    (if (and (eq ?nivel_player ?nivel_intrare) (eq ?x_player ?x_intrare) (eq ?y_player ?y_intrare))
        then
			(retract ?adr1 ?adr2)
			(assert (player (+ ?nivel_player 1) ?x_iesire ?y_iesire))
    )
)

(defrule iesire (declare (salience 9))
	
    ?adr1 <- (player ?nivel_player ?x_player ?y_player)
	(iesire ?nivel_iesire ?x_iesire ?y_iesire)
    (intrare ?prev_level ?x_intrare ?y_intrare&:
								(eq ?prev_level (- ?nivel_iesire 1)))
    (not (diamant ? ? ?))
    ?adr2 <- (destination-reached 1)
    =>
	
    (if (and (eq ?nivel_player ?nivel_iesire) (eq ?x_player ?x_iesire) (eq ?y_player ?y_iesire))
        then
			(retract ?adr1 ?adr2)
			(assert (player (- ?nivel_player 1) ?x_intrare ?y_intrare))
    )
)

(defrule minare (declare (salience 9))
	
    (player ?nivel_player ?x_player ?y_player)
    ?adr1 <- (diamant ?nivel_diamant ?x_diamant ?y_diamant)
    ?adr2 <- (destination-reached 1)
    =>
    (if (eq ?nivel_player ?nivel_diamant)
        then
			(retract ?adr1 ?adr2)
			(assert (diamant-minat 1))
    )
)