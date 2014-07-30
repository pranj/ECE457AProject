ECE457AProject
==============

ECE457A Project - GNSS Surveying

Generate random symmetric matrix and depot to point costs:

    graph = triu(randi(MAX_DISTANCE, num_points));
    graph = triu(graph, 1) + triu(graph, 1)';
    depotCosts = randi(MAX_DISTANCE, 1 num_points);

- Generating cost matrix from sample datasets

    Costs = get_costs('berlin52.tsp');

- Generating an intial solution

    NumPoints = 51;
    InitialSol = gen_initial_solution(NumPoints, NumReceivers);

- Running TS

    [Solution, Cost] = tabu_search(Costs, TabuLength, NumReceivers, ...
        MaxIterationsWithoutChange, InitialSol);
    [Solution, Cost] = adaptive_ts(Costs, NumReceivers, MaxIterationsWithoutChange, ...
        InitialSol);

- Running SA

    [Solution, Cost] = simulated_annealing(Costs, InitialSol, Alpha, ...
        InitialProbability, FinalTemperature, IterationsPerTemperature);
    [Solution, Cost] = adaptive_sa(Costs, InitialSol, Alpha, MaxNoChange);

- Running GA

    [Solution, Cost] = ga(Costs, NumIterations, PopulationSize, CrossoverProbability, ...
        MutationProbability, NumPoints, NumReceivers);

- Running PSO

    [Solution, Cost] = particle_swarm_optimization(Costs, NumIterations, ...
        NumParticles, NumPoints, NumReceivers, InertiaWeight, CognitiveAccel, ...
        SocialAccel, MaxVelocity);

- Running ACO

    [Solution, Cost] = ant_colony_optimization(Costs, MaxIterationsWithoutChange, ...
        NumPoints, NumReceivers, NumAnts, InitialPheromone, Alpha, Beta, ...
        EvaporationRate, Ro);
