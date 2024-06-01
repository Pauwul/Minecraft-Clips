; (deffacts
;     (pozitie <nivel> <X> <Y>)
;     (inamic <nivel> <X> <Y>)
;     (lava <nivel> <X> <Y>)
;     (player <nivel> <X> <Y>)
; )

(deffacts fapte
	(grid 5)

    (player 1 1 1)
	
    (intrare 1 5 5)
    (intrare 2 5 5)
    (diamant 3 5 5)
	
    (iesire 3 1 1)
    (iesire 2 1 1)
    (iesire 1 1 1)

    (lava 1 3 1)
    (lava 1 4 1)
    (lava 1 4 2)
    (lava 2 1 5)
    (lava 2 1 4)
    (lava 2 2 5)
    (lava 3 5 4)
    (lava 3 4 4)
    (lava 3 4 3)
    (lava 3 1 5)
    (lava 3 2 4)
    (inamic 1 2 2)
)

;REGULI CARE DAU SUBSCOPURI IN FUCNTIE DE NIVELUL LA CARE SE AFLA PLAYER-UL

(defrule goal-intrare (declare (salience 10))

    (player ?nivel_player ?x ?y_player)
    
    (intrare ?nivel_intrare ?x_intrare ?y_intrare)
    
    (diamant 3 ?x_diamant ?y_diamant)
    
    (not (destination-reached 1))

    
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

(defrule goal-iesire (declare (salience 10))

    (player ?nivel_player ? ?)
    
    (iesire ?nivel_iesire ?x_iesire ?y_iesire)
    
    (not (diamant 3 ? ?))
    (not (destination-reached 1))
    (not (goto ?nivel_iesire ? ? ))

    =>
    (if (eq ?nivel_player ?nivel_iesire)
        then
        (assert (goto ?nivel_iesire ?x_iesire ?y_iesire))
    )
)

; REGULI CARE FAC PLAYERUL SA INTRE/IASA SI SA RIDICE DIAMANTUL
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

; REGULI PENTRU MISCARE
; ComputeMove ca sa calculeze pe ce bloc sa se miste

(defrule ComputeMoveRight
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    (player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl =(+ ?x 1) ?y))
	(test (<= (+ ?x 1) ?dim))
	(test (< ?x ?xObj))
    =>
	(assert (move (+ ?x 1) ?y))
)

(defrule ComputeMoveLeft
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl =(- ?x 1) ?y))
	(test (> (- ?x 1) (- ?dim ?dim)))
	(test (> ?x ?xObj))
    =>
	(assert (move (- ?x 1) ?y))
)

(defrule ComputeMoveUp
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl ?x =(+ ?y 1)))
	(test (<= (+ ?y 1) ?dim))
	(test (< ?y ?yObj))
    =>
	(assert (move ?x (+ ?y 1)))
)

(defrule ComputeMoveDown
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl ?x =(- ?y 1)))
	(test (> (- ?y 1) (- ?dim ?dim)))
	(test (> ?y ?yObj))
    =>
	(assert (move ?x (- ?y 1)))
)

(defrule ComputeMoveRightEmergency
	(declare (salience -500))
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    (player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl =(+ ?x 1) ?y))
	(test (<= (+ ?x 1) ?dim))
    =>
	(assert (move (+ ?x 1) ?y))
)

(defrule ComputeMoveLeftEmergency
	(declare (salience -500))
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl =(- ?x 1) ?y))
	(test (> (- ?x 1) (- ?dim ?dim)))
    =>
	(assert (move (- ?x 1) ?y))
)

(defrule ComputeMoveUpEmergency
	(declare (salience -500))
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl ?x =(+ ?y 1)))
	(test (<= (+ ?y 1) ?dim))
    =>
	(assert (move ?x (+ ?y 1)))
)

(defrule ComputeMoveDownEmergency
	(declare (salience -500))
	(grid ?dim)
    (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
	(player ?lvl ?x ?y)
    (not (destination-reached 1))
    (not (move $?))
	(not (lava ?lvl ?x =(- ?y 1)))
	(test (> (- ?y 1) (- ?dim ?dim)))
    =>
	(assert (move ?x (- ?y 1)))
)

; (defrule ComputeMoveUpRight
	; (grid ?dim)
    ; (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    ; (player ?lvl ?x ?y)
    ; (not (destination-reached 1))
    ; (not (move $?))
	; (not (lava ?lvl =(+ ?x 1) =(+ ?y 1)))
	; (not (and (> =(+ ?x 1) ?dim) (> =(+ ?y 1) ?dim)))
    ; =>
    ; (if (< ?x ?xObj)
        ; then (assert (move (+ ?x 1) (+ ?y 1))))
; )

; (defrule ComputeMoveRightDown
	; (grid ?dim)
    ; (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    ; (player ?lvl ?x ?y)
    ; (not (destination-reached 1))
    ; (not (move $?))
	; (not (lava ?lvl =(+ ?x 1) =(- ?y 1)))
	; (not (and (> =(+ ?x 1) ?dim) (> =(- ?y 1) ?dim)))
    ; =>
    ; (if (< ?x ?xObj)
        ; then (assert (move (+ ?x 1) =(- ?y 1))))
; )

; (defrule ComputeMoveLeftUp
	; (grid ?dim)
    ; (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    ; (player ?lvl ?x ?y)
    ; (not (destination-reached 1))
    ; (not (move $?))
	; (not (lava ?lvl =(- ?x 1) =(+ ?y 1)))
	; (not (and (> =(- ?x 1) ?dim) (> =(+ ?y 1) ?dim)))
    ; =>
    ; (if (> ?y ?yObj)
        ; then (assert (move (- ?x 1) =(+ ?y 1))))
; )

; (defrule ComputeMoveLeftDown
	; (grid ?dim)
    ; (goto ?lvl ?xObj&:(<= ?xObj ?dim) ?yObj&:(<= ?yObj ?dim))
    ; (player ?lvl ?x ?y)
    ; (not (destination-reached 1))
    ; (not (move $?))
	; (not (lava ?lvl =(- ?x 1) =(- ?y 1)))
	; (not (and (> =(- ?x 1) ?dim) (> =(- ?y 1) ?dim)))
    ; =>
    ; (if (< ?y ?yObj)
        ; then (assert (move (- ?x 1) =(- ?y 1))))
; )

; Move pentru miscare

(defrule Move
    ?player <- (player ?lvl ?xP ?yP)
	?adr <- (move ?dx ?dy)
	(not (destination-reached 1))
    =>
    (retract ?player ?adr)
    (assert (player ?lvl ?dx ?dy))
)

(defrule MoveAndKill
	(declare (salience 10))
    ?player <- (player ?lvl ?xP ?yP)
	?adr <- (move ?dx ?dy)
	?enemy <- (inamic ?lvl ?dx ?dy)
	(not (destination-reached 1))
    =>
    (retract ?player ?adr ?enemy)
    (assert (player ?lvl ?dx ?dy))
)

; Destination-reached pentru a verifica daca a ajuns la destinatie

(defrule Destination-reached
	(declare (salience 10))
	(player ? ?x ?y)
	?adr1 <- (goto ? ?xDest ?yDest)
	(test (and (eq ?x ?xDest) (eq ?y ?yDest)))
	=>
	(assert (destination-reached 1))
    (retract ?adr1)
)


; REGULI PENTRU TERMINAREA JOCULUI WIN/LOSE

(defrule terminare-joc 
	?adr1 <- (player 1 ?x_player ?y_player)
    (iesire 1 ?x_iesire ?y_iesire)
	(destination-reached 1)
	=>
	(if (and (eq ?y_player ?y_iesire 1) (eq ?x_player ?x_iesire 1))
	then
		(printout t "YOU WON!" crlf)
		(assert (you-won))
	)
)

(defrule GameOver
	(declare (salience -1000))
	(not (you-won))
	=>
	(printout t "you lost" crlf)
	(assert (you-lost))
)

(defrule Strategy
	(declare (salience 1000))
	(not (StrategySet))
	=>
	(set-strategy random)
	(assert (StrategySet))
)

