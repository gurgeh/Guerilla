(
   (makeMove (lambda (move state)
	       (let ((sourcei (car move))
		     (targeti (cdr move))
		     (sourcesize (car (get state sourcei)))
		     (targetsize (cardef (get state targeti) 0)))
		 (if (< targetsize sourcesize)
		     (update (update state sourcei cdr)
			     targeti
			     (lambda (x) (cons sourcesize x)))
		   state))))
		       
   (makeMoves (lambda (state moves)
		(fold makeMove state moves)))

   (startPos '((range 1 9) () ()))

   (tower (lambda (moves)
	    (eq? (makeMoves startPos moves) (reverse startPos))))
)