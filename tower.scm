;#lang r5rs
(module tower mzscheme
	(require srfi/1)

	(define (makeMove move state)
	  (letrec ((source (car move))
		   (target (car (cdr move)))
		   (recMake (lambda(tower pos disc)
			      (if (null? tower) '()
				  (cons (if (eqv? pos source)
					    (cdr (car tower))
					    (if (eqv? pos target) 
						(cons disc (car tower))
						(car tower)))
					(recMake (cdr tower)
						 (+ pos 1)
						 disc))))))
	    (recMake state 0 (car (list-ref state source)))))
		       
	(define (makeMoves state moves)
	  (fold makeMove state moves)))