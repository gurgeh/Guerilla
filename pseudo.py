def HanoiProblem(solution):
    state = [[10,9,8,7,6,5,4,3,2,1], [], []]
    for source,target in solution:
        if source == target: return False
        if source < 0 or source > 2: return False
        if target < 0 or target > 2: return False
        if len(state[target]) == 0: return False
        if state[target] > state[source]
            
    

#---------

@poly("Optimize")
def GeneticAlgorithm(random_solution):
    pop = [random_solution() for _ in POPSIZE]
    while notdone: #who decides when done?
        _NextPop(pop)

@poly("NextPop")
def Tournament():
    #pick X
    #calc fitness
    #sort, throw away Y, replace with offsprings from weighted parent list
    pass

#Tournament for fitness function that takes multiple genes

#Tournament where most similar is replaced

#Roulette

#GP on top

#--------------



#sorting

#n-best

#maps, sets

#prove

#statistics
