(module problems mzscheme 
(define (id n) n)

(define (one n) (equal? n 1))

(define (nil xs) (equal? xs '()))

(define (just-a-list xs) (equal? xs '(5 (1009 7) (()))))

(define (list-size xs) (equal? (length xs) 1000))

(define (var-list-size n xs) (equal? (length xs) n))

 #| Hur analyserar man då ett scheme-program?
Flödesanalys är en bra början för alla(?) program.
Det kommer ge möjliga utvärden och hur de beror på invärden.
Sedan kan man använda en separat modul för att analysera resultatet
och eventuellt ställa nya frågor till flödesanalyseraren och säga vad man måste
ge för input för att nå en viss output.

Flödesanalyseraren funkar som flödesanalyseraren i mitt språk, fast det vore bra om
den kunde kommunicera lite fram och tillbaka mellan delar av program - t.ex
"vilken typ av restriktioner är jag senare i programmet intresserad av att den här loopen
ska uppfylla?" För att veta vilka generaliseringar man ska testa vid rekursion.

Det vore också bra om det redan här fanns spår av den tids- och prioritetshantering som AGI:n
ska byggas på.

Annars är flödesanalysen lätt:
  skuggvariabler skickas genom koden och sanna satser ackumuleras
  if satser som inte kan avgöras statiskt ger två alternativa uppsättningar sanna satser (om dessa representeras funktionellt så kan båda världarna länka till samma föräldrar för att spara minne)
  rekursion baseras på utvidgning och generalisering.
    Tre öppna problem infinner sig.
      1) Vilka generaliseringar är intressanta att göra? Detta kan skötas grovt i ett första pass och sedan bättre i påföljande pass, men då måste ändå senare delar av programmet kunna ge ifrån sig åsikter om vilka finare generaliseringar som är intressanta.
      2) Med de sanna satser man känner till, hur kan if-satser avgöras? Eller - alternativt. Hur kan motsägelsefulla världar ellimineras?
      3) Hur mycket tid ska läggas på att försöka lösa 1 och 2 i olika situationer?

    Jag tror att den enklaste vägen är upprepade pass över samma kod, med mer information om vad som är intressant att veta för varje gång. Generaliseringsanalysen borde ge information både om vilka generaliseringar som inte stämde och vilka som gjorde det, så att man senare i koden kan märka att det finns anledning att fördjupa sig.

    Ouppklarat än så länge:
      -hur - konkret - märker analysen att den vill ha finare generalisering?
      -Kan rekursionsanalysen "upptäcka" att det finns intressanta saker att upptäcka (precis som en människa kan,
       utan att egentligen veta vad det ska vara bra till senare)
      -Hur bedöms vad som ska läggas tid på (se även mina AGI-tankar)
      -Exakt var i detta finns kopplingspunkterna till AGI?
      -Hur skickas information om att man vill ha mer analys "bakåt" i systemet? Om slutanalysen upptäcker att
       den inte kan styra utresultatet till exakt vad den vill ha, så borde den kunna analysera koden "baklänges",
       eller skicka information bakåt, för att se var mer analys behövs.
     
    Jag tänker mig att ett testproblem för generalisering är en loop som kollar när två variabler korsar varandra, där man skickar in xoffset, xstep och ystep. Den kan uppenbarligen reduceras till en enkel division, men har inte en uppenbar generalisering om man inte ser helhetsproblemet.

    Om rekursion behandlas lazy, så att svaret på rekursionen blir en analys-thunk så kan rekursionen analyseras när konkreta frågor senare uppstår. På det sättet vänds analysen bak och fram på det sättet som jag har funderat på att göra. Efter närmare eftertanke tror jag inte vi gör så.

    Om alla olösta frågor drog igång en egen liten "tråd" så kunde de sedan uppdatera kunskap när de kom på något. En rekursion är till sin natur oftast en olöst fråga (eller är det återigen branchen i rekursionen som är olöst?). Jag får komma på något bättre senare, men vi börjar med att alla trådar behandlas lika (ev. prioriteras de ned när de kört en stund och de kanske borde kunna säga "stop. nu kan jag inte komma på något mer". Hur propageras sedan denna kunskap? Kanske algoritmerna helt enkelt kan vara beredda på att det dyker upp ny kunskap då och då. Om ett resultat/returvärde representeras av ett kunskapsobjekt (snarare än de som råkar vara definierade som variabler) så kan även analyser senare i programflödet lägga till konkreta frågor till kobjekten.

    Ett kunskapsobjekt vet 1) vad som bevisats om det och dess relationer till andra objekt och 2) vad som visats vara omöjligt att veta. T.ex om a och b är okända inputs, så kan vi inte veta om a > b är sant eller någonting om a eller b, förrän i branchar där påverkade kunskapsobjekt ärver från sina föräldrar, men har lagt till ett constraint. Saker som bevisas om ett ärvt kunskapobjekt borde rimligen vara sånt som använder sig av det nya constraintet, så att andra, mer generella, saker kan visas längre upp. När något "intressant" (t.ex som efterfrågats av någon annan, eller som uppfyller något sorts intressanthetskriterium) visas så kan man ju enkelt se hur högt upp variablera kan vara för att bevisningen fortfarande ska hålla. Om en motsägelse bevisas i en "värld" så dör alla dess trådar och undertrådar.

    Om jag bara nu löser exakt hur rekursionen ska fungera (kanske jag redan gjort, får bara skriva ned det i så fall) så borde jag ha tillräckligt till en bloggpost och sedan en första implementation.

   Saker som med gott samvete kan lämnas till senare:
     1) Exakt var knyts AGI in i detta? (jag antar att det är i bevisningarna)
     2) Hur ska tid allokeras till de olika trådarna (antar att AGI dyker upp här också, men att det också finns goda heuristiker)
     3) Kan en tråd (får hitta ett bättre namn kanske) själv förstå vilken sorts resultat som är vackra och potentiellt intressanta för andra, redan innan den får konkreta frågor?
     4) Kan kunskapen från en körning generaliseras?
     5) Kan/behöver resonemang inom en körning återanvändas som killer-moves? (förhoppningsvis inte, om man bevisar saker på så generell nivå som möjligt, se ovan)
     6) Hur ska bevisningsalgoritmerna komma fram till vilka relationer som hade hjälpt om andra trådar kunde bevisa?

    Analys av rekursionen blir lurigare när funktionen kan anropa sig själv från mer än ett ställe (inte längre tail recursion) och ev. ännu lurigare vid mutual recursion och superlurig när funktionen tar in ett (eller en lista med) argument som den anropar och ett av dem visar sig vara den själv. Jag funderar först på "vanlig" rekursion och sedan på fallet med inskickad funktion.

    När en funktion nås för andra gången i en analys så har vi en rekursion. Hur ser vi skillnad på detta och att funktionen anropas från flera håll (eftersom analysen nu har blivit något mer parallell)?

    När en funktion anropas så kontrolleras om den har "under analys"-flagga satt. Om den har det så är vi i en rekursion och inparametrarna registreras i en lista som redan innehåller originalparametrarna. När funktionen sedan är färdiganalyserad så noteras det att funktionen var rekursiv och svaret på den sätts om okänd. En tråd dras sedan igång som försöker förbättra kunskap om svaret genom att vidga och generalisera. För att veta hur den ska generalisera så behöver den feedback från senare i programmet.

    Detta är i princip induktionsbevis av vad folk frågar av funktionen. 1) Stämmer det för första värdet? 2) Om det är sant för ingångsvärdet, är det då alltid sant för utgångsvärdet?

    Nu är jag nästan färdig för bloggpost. Sista saken jag vill lösa:
      Hur uppstår frågorna?
        Frågorna kommer av:
        1) att kunskapsgrenar försöker visa att de är omöjliga. Lite mindre intressant, men ändock användbart är om de försöker bevisa att de är möjliga, så att man kan skilja på vad man vet är möjligt och vad man inte kunnat avgöra är möjligt. Detta gör ju bl.a att man kan sluta försöka visa att de är omöjliga. Intressant är också att bevisa att det inte går att veta, för att sluta försöka. Teknikerna för att göra detta går från enkla (jag vet inget om a, alltså kan jag inte visa något om a om det inte är något som är sant/falskt oavsett a) till luriga diagonaliseringsbevis.
        2) Att man ställer frågor på hela programmet eller funktionen externt (under vilka kriterier returnerar den true? kan den excepta? etc)
        3) Ev. har alla trådar några saker som de automatiskt försöker visa förutom att de är möjliga (t.ex typ på returvärde, om de kan excepta, faktisk beräkning av svaret när man vet tillräckligt om parametrarna, om det finns förenklingsmöjligheter enligt nedan, etc)

      Hur upptäcks (eller frågas om) förenklande/optimerande transformationer av rekursiva funktioner?
        Detta hjälper ju både analyser och optimering.
        Jag tror att det är en separat sorts analys som automatiskt görs av alla rekursiva funktioner, enligt punkt 3 ovan. Denna analys känner till ett antal förenklingar och definitioner. Antingen frågar den om alla, eller så kan den på något sätt göra en initial filtrering.

Analyseraren kan utföra
"proof by deduction", alltså ren applikation av axiom, teorem och definitioner.
"proof by induction", analys av rekursiva funktioner
"proof by contradiction", när något försöker bevisas försöker vi alltid bevisa motsatsen samtidigt, men detta är inte riktigt samma sak som att vi dessutom antar att motsatsen är sann för att se om det leder till motsägelser.
"proof by construction", vi kan visa att en if-sats kan ta en gren genom att helt enkelt konstruera värden på de relevanta variablerna som upfyller alla kriterier. Vi kan också på slutet av en analys specifikt be att få värden på de relevanta variablerna som uppfyller alla kriterier.
"proof by exhaustion". Vi kan gå igenom alla möjliga fall. Speciellt när man pratar booleans, men t.ex också ett ändligt antal heltal.

   När det ändå går så bra kanske jag också skulle fundera på
   1) exakt vad som blir egna trådar
      Alla uttryck blir egna trådar. Förmodligen inte med en gång, utan som en konsekvens av att superuttrycken frågar saker. T.ex vad de
      ger tillbaka för värde, kan de excepta, etc.
   2) vilka frågor som de ställer till sina underexpressions/variabler
      jag har ett antal frågor som jag kan ställa och i slutändan vet alla primitiva funktioner vad de behöver för svar av sina argument för att kunna svara på en sådan fråga.
   3) hur väntar trådarna på svar?
      trådar låser när de väntar på svar, men en nod som får en fråga kan spawna iväg flera trådar. En tråd är egentligen inte en nod, utan ett uppdrag från en nod.
   4) vilken del av kunskapsträdet som får frågan
      Är det alla noder (eller alla löv) som får försöka samtidigt och sedan kolla om resultatet håller längre upp i trädet? Känns slösaktigt.
      Får roten försöka och sedan successivt undernoder om roten inte hittar något? Om alla undernoder hittar något så är det samma som att roten hittar något, men om några hittar och några säger "nej", så kan ju den som ställde frågan i alla fall säga att i denna del av trädet är detta sant. Det hela kan egentligen optimeras med att subnoder som inte tillför något nytt i relation till frågan genast frågar sina subnoder. För att detta ska fungera krävs att man har en komplett graf över vilka satser som hänger samman.
   5) antag att en fråga besvaras av någon annan än den spawnade tråden. Vad händer då?
      tråden som väntar på svar väntar inte på att frågan den drog igång ska bli färdig, utan istället på att viss kunskap ska dyka upp eller rafineras i kunskapsträdet. Tråden som blev i gång-dragen har också en hook på om kunskapen den ska visa dyker upp. Den kan då termineras.

Relationer mellan kunskapsobjekt sitter på båda objekten.

Hur analyserar jag listor?
  axiomen (och rekursion) håller reda på information kring längden på en skugglista (ett skuggobjekt som råkar vara en lista)
  innehållet har man exakt kunskap om, så länge den läggs till utan rekursion. När den läggs till med rekursion så kan frågor ställas av senare delar till rekursionstråden, som den kan svara på. Det kan bli många indirections när t.ex ett objekt mappats över flera gånger, eller + använts; detta måste fungera någorlunda snabbt och smidigt.

Hur kommer Analyseraren att ta fram generella teorem om t.ex prelude?
  För att vara praktiskt måste generella slutsatser och teorem kunna sparas mellan körningar, eller åtminstone under samma körning. Dessa teorem är som allra viktigast när de rör prelude och annat som senare kommer användas i andra analyser, men de bör även kunna röra funktioner som definierats i det aktuella problemet. Underfrågor:
  Hur kan en tråd leta efter generella resultat?
    man kan ha en lista med standardsaker som är intressant att veta om en funktion och som skulle kunna vara sanna. Den listan kan utökas när man hittar saker som gäller för andra funktioner.
  Hur vet en tråd att den visat något värt att spara om en funktion?
    kanske alla (generella?) resultat som någon bett om är värda att spara. Kanske om argumenten är någorlunda lätt uttryckta. Kanske kan resultat på specifika argument försöka generaliseras? <- Detta tror jag är huvudpoängen. Generalisera saker som visats för specifika argument. Överhuvudtaget är detta en öppen uppgift för en AGI. Analyseraren måste skilja på saker som kan lösas exakt och öppna problem där man bör använda sig av AGI-kopplingar. AGI:n kan ju sedan bara känna till ett sätt att lösa det hela, men det måste ändå vara på det sättet.

 |#

;boolean logic

(define (inequalities n) (and (< n 1000000000) (> n 900000000)))

;simple usage of all built-in functions and syntax

;some basic math
;basic list manipulation and understanding

;branching

;calling another function

;function declaration with function

;recursion

(define (cross x xstep y ystep n)
  (if (>= x y) (equal? n 0)
      (cross (+ x xstep) xstep (+ y ystep) ystep (- n 1))))

(lambda (x y)
  (let (reccross (lambda (x y n)
		   (if (>= x y) (== n 0)
		       (reccross (+ x 10) (+ y 7) (- n 1)))))
    (reccross x y 5)))

;functions in arguments and calling lists of functions

;;build and analyze prelude

;proofs

;problems that can't be solved, where the object is to discover this

;simple problems tailored for different approaches
; GA
; linear programming
; GP(?)
; brute force tree search


;Towers of Hanoi

;Euler problems(?)

;Problems where the answer is a function

;;Future
; Problems where the correctness function would take too long to run (calculate the millionth prime)
;  and the goal is to reach the answer in another way than running the naive correctness function and then
;  prove the answer correct rather than test it.
; Infinite (tail) recursion on wrong input
; Problems where you need to be vareful about RAM usage
; New basic types (strings, objects, continuations, exceptions)
; The proofs, themselves, are programs (sequences of statements in the proof language) and could thus be subject to analysis. Looking for a specific program sounds like a generalisation of looking for a specific proof. Maybe they could share code. Also proofs generally have no recursion or loops. Perhaps they would be more powerful if they did.
)