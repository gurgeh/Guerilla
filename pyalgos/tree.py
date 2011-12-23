"""
Tree search:

If structure is possibly a graph, results can be cached. What if cache is too large for memory?
Sometimes it can be immediately proven that tree is not a graph, thus no caching necessary.

Visit could be delayed and tried in som better order, if expensive.
Visit could be a fuzzy concept (perhaps optimizing), where you could choose how "long" you want
to visit a node.

Paths can be sorted.

A queue of nodes can be used for best-first. What if too many nodes?
Best first is probably its own algorithm.

How do I make the system hardwire a few decisions?
 This is key. You cannot rethink your life every millisecond.
 The decisions hold until some simple criterion, defined by the decision itself, changes (for example time).

How do I stop several parallell kinds of almost the same tree search?
 Even if I don't run parallell processors this is also essential. There needs to be a quick estimate of how "coupled"
 two tasks are.

How do proofs about different nodes share information?

Where do I add proof and optimization hooks?

Are there any parameters?
"""

#tree search is a form of discrete optimization, where allowed states need to be found

def DepthFirst(fs): #fs fulfills protocol FormalState (visit, finished, getNodes, score, transform)
    fs.visit()
    if fs.finished(): return fs
    nodes = fs.getNodes()

    bestscore = fs.score()
    bestfs = fs
    for path in paths:
        score, newfs = Search(fs.transform(path))
        if score > bestscore:
            bestscore = score
            bestfs = newfs
    return bestscore, bestfs




"""
Optimization:

GA can be tweaked to other kinds of optimization with parameters. How define parameters?

GA could be more general, if BOA-type modelling was added.
BOA is probably its own algorithm

Implementation of solutionPool

Where do I add proof hooks?

How do decision trees, linear optimization, analytical optimization, Bagging and Boosting fit in to this?
"""

#optimization, when state space is known and random is implemented
#non-deterministic, destructive update
def GA(task, solutionPool):
    if not solutionPool:
        solutionPool.add(task.random())
    else:
        action = either(randomize, mutate, crossover) #parameters. possibly fitness dependent
        if action == randomize:
            solutionPool.maybeAdd(task.random()) #maybeAdd may look at similarity or goodness
        elif action == mutate:
            picked = solutionPool.pick()
            solutionPool.maybeAdd(picked.mutate(), picked) #maybe just replace picked
        elif action == crossover:
            pick1 = solutionPool.pick()
            pick2 = solutionPool.pick()
            solutionPool.maybeAdd(pick1.combine(pick2), pick1, pick2)
    
    Optimize(task, solutionPool)
            

#a concrete task involving (tree search and/or optimizations) and proofs that limit the search space

#proofs
"""
I also need an algorithm/algorithms for enumerating search space from proofs that limit search space.
"""

#statistics (?)


#solve questions that have arisen
"""
I think decision points might be a better name than, or complement to, tasks.

Most important questions so far seems to be
1) how not to decide anew on which algorithms to try in each step of a tree or optimization
   This might apply to decisions in general. Maybe the algorithms should show decision points,
   where some sort of decision can be taken?
   At each decision point, there is always the meta-decision whether to short circuit the decision and try the same
   thing (or along some other pattern) several times.
   
2) how not to run almost the same algorithm in a parallell try
   I need a quick estimate of "coupling" between different (task + algorithm).

3) how to share information, for example between proofs
   Also, where do proofs enter the picture in code above?



4a) How do you prove stuff? (about a search problem in particular)
   Proving stuff will eventually amount to new search problems, but what are the allowed transformations for a FormalState?
   Antag att vi bara pratar om "puzzles" först. Antag också att dessa har regler för hur lösningen ska se ut och eventuellt vilka transformationer som får lov att göras på ett state för att komma dit.

   Antag att man ska ta reda på om något begynnelsedrag forcerar vinst i tic-tac-toe, då behöver man av symmetriskäl bara titta på tre stycken. Hur visar man det? I just det fallet har det med symmetrisk spelplan och rotationer och speglingar att göra. Generellt så handlar det mer om att visa att två states är ekvivalenta. Det förenklar om man bara har några fördefinierade "teorier" om vilka ekvivalenser/symmetrier som finns och när de kan finnas. Men det förtråkar också.

   I Zebraproblemet har man en rad constraints som var och en kan användas för att minska sökrymden, t.ex genom backtrackande sök. Om folk bodde i en cirkel så hade man återigen haft symmetrier som sade att det inte spelar någon roll hur lösningen är translaterad. I andra problem kan man ha symmetrier som säger att det inte spelar någon roll i vilken ordning "symbolerna" står. Det normala måste ändå vara att man har ett antal hypoteser som reglerna hjälper att filtrera i.

   I Towers of Hanoi så är det inte symmetriskt till vilken ruta man gör sitt första drag, men man behöver ändå bara testa en av dem och sedan bara göra en enkel transformation (byta plats på 2 och 3 i alla source och targets) på alla dragen om man råkar hamna på fel.

   På ett sätt kan man se det som att man skapar ett nytt problem (med mindre sökrymd) vars lösning kan transformeras till en lösning på originalproblemet. Detta är ett sätt att uttrycka det som jag gillar! Det ger bl.a ett enkelt sätt för det man bevisar att användas. I vissa fall är det nya problemet samma problem med nya regler som förbjuder vissa drag. I början så har jag nog ett antal kända sätt att testa nya problem, ev. tillsammans med en GP eller något som testar allt möjligt lustigt. Detta funkar generellt för alla sorters uppgifter.

   
4a1) OK, so you have a theory that another problem is equivalent to this. How do you prove that?


   
4b) How do you use proven stuff to visit less nodes or avoid certain regions in continuous optimization?
    The solution in 4a, where the problem is transformed to another problem, seems best.

4c) How do you know what would be fruitful to prove?
    Is there some interaction with the search algorithms?

Minor stuff:
1) how general should the algorithms be?
   This might solve itself when I set other details.

"""


#tie together (datastructures, etc)

#Scheduler
