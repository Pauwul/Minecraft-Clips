(deffacts joc
    (player 1 1 1)
    
    (intrare 1 3 3)
    (intrare 2 3 3)
    
    (iesire 3 1 1)
    (iesire 2 1 1)
    (iesire 1 1 1)
    
	(destination-reached 1)
	
)

; Regula pentru (destination-reached 1)

(defrule destination-reached (declare (salience 11))
(player ?nivel ?x ?y)
?adr <- (goto ?nivel ?x ?y)
=>
(assert (destination-reached 1))
(retract ?adr)
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
    
    (not (goto ?nivel_iesire ? ? ))
	(not (destination-reached 1))

    =>
    (if (eq ?nivel_player ?nivel_iesire)
        then
        (assert (goto ?nivel_iesire ?x_iesire ?y_iesire))
    )
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
