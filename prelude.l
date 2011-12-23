;todo:
; solve basics of how lists should be analyzed!


 (cross (lambda (a b)
	  (let ((subcross (lambda (x y n)
	    (if (>= x y) (eq? n 0)
	      (subcross (+ x 10) (+ y 7) (- n 1))))))
	    (subcross a b 5))))

"""
1) fråga lambda (a b) när true
2) fråga subcross (a b 5) när true
3) fråga if när true, som frågar (>= x y) när true och när false
4) (>= x y) frågar not <, som i sin tur frågar (< x y) och vidare till (> y x)
5) > y x säger att när y är sann men inte x så är den sann och när y är '() så är den falsk
6) om båda är sanna så uppstår rekursion
...
Det enda rimliga sättet att lösa detta är att notera korrelation med tal och analysera på det i stället.
Men vad händer sedan?
Genom att följa rekursionen till fem så får man fram ett enkelt linjärt samband.
Men detta är lite fusk. Antag att n är okänd och att du vill ha en allmän formel för när subcross är sann.

Då kommer du istället till rekursionen med kunskapen om att
x < y
och argumenten (x + 10) (y + 7) (n - 1)
att detta är exakt rätt generalisering kan man komma fram till antingen 1) genom att testa de kortaste generaliseringarna som uttrycker det man hitills observerat (blackbox-tekniken), eller 2) att argumenten innehåller information om att uppdateringarna inte var beroende på några variabler som kan förändras.

Teknik 1 förvillar mig lite genom att jag inte är riktigt säker på hur man kan se att man inte har generaliserat 'för långt' utan att det man har är en exakt sanning. Det borde dock gå.

Teknik 2 förvillar mig med att uppdateringarna ju faktiskt var beroende på att x < y. Om man tar med det beroendet så har man ju bara reproducerat koden på ett nytt format. Kanske är detta vad man måste göra.

Antag att man först har samlat upp alla möjliga rekursionsingångar och sedan ska svara på en fråga (vad är villkoren för att du ger true? delat på tre case: alltid, möjligen, aldrig). Det kan ju finnas flera sätt att försöka besvara på den frågan. Kanske är detta en AGI-punkt? Man kan t.ex försöka visa saker om hur variablerna beter sig eller applicera någon sorts constraint solver.

"""


; fix neg
; div
; modulo
; filter
; rational numbers

;fold
;update
;get
;cardef

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

