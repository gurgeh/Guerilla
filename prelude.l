;todo:
; solve basics of how lists should be analyzed!

; fix neg
; div
; modulo
; filter
; fold
; rational numbers
(
 (eq? (lambda (x y)
	(if x
	    (if y (and (eq? (car x) (car y)))
	      (eq? (cdr x) (cdr y)))
	  #f)
	(if y #f #t)))

 (= (lambda (x y)
      (eq? (len x) (len y))))

 (len (lambda (xs)
	(if xs (cons '() (len (cdr xs)))
	  '())))

 (> (lambda (x y)
      (if x 
	  (if y
	      (> (cdr x) (cdr y))
	    #t)
	#f)))

 (< (lambda (x y)
      (> y x)))

 (<= (lambda (x y)
       (not (> x y))))

 (>= (lambda (x y)
       (not (< x y))))

 (not (lambda (x)
	(if x #f #t)))

 (or (lambda (x y)
       (if x x
	 (if y y
	   #f))))

 (and (lambda (x y)
	(if x
	    (if y y #f)
	  #f)))

 ;fix for neg numbers
 (++ (lambda (x)
     (cons '() x)))
 
 (-- (lambda (x)
       (cdr x)))

 (+ (lambda (x y)
      (if x (++ (+ (-- x) y))
	y)))

 (- (lambda (x y)
      (if y (- (-- x) (-- y))
	x)))

 (* (lambda (x y)
      (if y 
	  (if (eq? y 1) x
	    (+ x (* x (-- y))))
	0)))
;fix until here

 (pos? (lambda (x)
	 (if x 
	     (if (car x)
		 #f
	       #t)
	   #t)))
 
 (makepos (lambda (x) ;could be refactored to use set x 0 0
	    (if x (cons 0 (cdr x))
	      '())))

 (makeneg (lambda (x)
	    (if x (cons 1 (cdr x))
	      '())))

 (negate (lambda (x)
	   (if (pos? x) 
	       (makeneg x)
	     (makepos x))))

 (map (lambda (f xs)
	(if xs (cons (f (car x)) 
		     (map f (cdr x)))
	  '())))

 )

