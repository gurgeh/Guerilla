(
 (id (lambda (n) 
       n))

 (one (lambda (n)
	(= n 1)))

 (nil (lambda (xs) 
	(eq? xs '())))

 (just-a-list (lambda (xs)
		(eq? xs '(5 (1009 7) (())))))

 (list-size (lambda (xs)
	      (= (len xs) 1000)))

 (var-list-size (lambda (n xs)
		  (eq? (len xs) n)))

 (inequalities (lambda (n)
		 (and (< n 1000000000) (> n 900000000))))

 (cross (lambda (x y n)
	  (if (>= x y) (eq? n 0)
	    (cross (+ x 10) (+ y 7) (- n 1)))))

;basic mathematical rules (law of distribution, power laws, associativity, reflectivity, commutativity)

;more list handling (patterns in list)

;functions (functions in arguments, list of functions, properties of functions)

;unsolvable puzzles (object is to understand that they are unsolvable)

;"real" puzzles (Towers of Hanoi, extended ToH, something simpler)

;problems where the answer is a function (need eval)

 )