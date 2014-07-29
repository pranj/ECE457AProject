function [BestSolutionSoFar, BestCostSoFar, Debug] = ga(Costs, NumIterations, PopulationSize, CrossoverProbablity, ...
                 MutationProbablity, NumPoints, NumReceivers)
    SolutionSize = NumPoints + NumReceivers - 1;
    DepotCosts = Costs(end, :);
    Debug = zeros(NumIterations, 1);

    Population = zeros(PopulationSize, SolutionSize);
    for idx = 1:PopulationSize
        Population(idx, :) = gen_initial_solution(NumPoints, NumReceivers);
    end

    BestCostSoFar = Inf;
    BestSolutionSoFar = zeros(1, SolutionSize);

    for iteration = 1:NumIterations
        [PopulationBestSoln, PopulationBestCost] = best_soln_in_population(Population, Costs, DepotCosts);
	Debug(iteration) = PopulationBestCost;

	% only draw every 5 iterations
	if mod(iteration, 5) == 0
		plot(Debug)
		drawnow
	end
        
        CrossoverOffspring = crossover(Population, 1:PopulationSize, CrossoverProbablity);
        MutationOffspring = mutation(Population, MutationProbablity);
	if PopulationBestCost < BestCostSoFar
            BestCostSoFar = PopulationBestCost;
            BestSolutionSoFar = PopulationBestSoln;
        end
        Everyone = [Population; CrossoverOffspring; MutationOffspring];
	Population = selection2(Everyone, PopulationSize, Costs, DepotCosts);
    end
end

function [Offspring] = crossover(Population, PotentialParents, CrossoverProbablity)
    SolutionSize = size(Population, 2);
    PotentialPairings = nchoosek(PotentialParents, 2);
    CrossoverProbabilities = rand(size(PotentialPairings, 1), 1);
    ParentIndices = find(CrossoverProbabilities < CrossoverProbablity);
    NumActualParents = size(ParentIndices, 1);

    NumOffspring = 2 * NumActualParents;
    Offspring = zeros(NumOffspring, SolutionSize);
    for parentIdx = 1:NumActualParents
        Parent1 = Population(PotentialPairings(ParentIndices(parentIdx), 1), :);
        Parent2 = Population(PotentialPairings(ParentIndices(parentIdx), 2), :);
        [Offspring1, Offspring2] = order1_crossover(Parent1, Parent2);
        Offspring(parentIdx * 2, :) = Offspring1;
        Offspring((parentIdx * 2) - 1, :) = Offspring2;
    end
end

function [Offspring] = mutation(Population, MutationProbablity)
    [PopulationSize, SolutionSize] = size(Population);
    MutationProbabilites = rand(PopulationSize, 1);
    ChosenIndices = find(MutationProbabilites < MutationProbablity);
    NumChosen = size(ChosenIndices, 1);

    Offspring = zeros(NumChosen, SolutionSize);
    for idx = 1:NumChosen
        Parent = Population(ChosenIndices(idx), :);
        Offspring(idx, :) = mutate(Parent);
    end
end

function [NewPopulation] = selection(Everyone, PopulationSize, Costs, DepotCosts)
    [EveryoneSize, SolutionSize] = size(Everyone);
    Fitness = zeros(EveryoneSize, 2);
    for idx = 1:EveryoneSize
        Cost = calculate_cost(Everyone(idx, :), Costs, DepotCosts);
        Fitness(idx, :) = [Cost idx];
    end
    Fitness = sortrows(Fitness, 1);
    TotalWeight = sum(Fitness(:, 1));
    Fitness(:, 1) = Fitness(:, 1) / TotalWeight;

    Fitness(:, 1) = cumsum(Fitness(:, 1));
    NewPopulation = zeros(PopulationSize, SolutionSize);

    for idx = 1:PopulationSize
        r = rand(1, 1);
        for k = 1:EveryoneSize
            SelectionProb = Fitness(k, 1);
            ChromosomeIndex = Fitness(k, 2);
            if r < SelectionProb
                NewPopulation(idx, :) = Everyone(ChromosomeIndex, :);
                break;
            end
        end
    end
end

function [NewPopulation] = selection2(Everyone, PopulationSize, Costs, DepotCosts)
    [EveryoneSize, SolutionSize] = size(Everyone);
    Fitness = zeros(EveryoneSize, 2);
    for idx = 1:EveryoneSize
        Cost = calculate_cost(Everyone(idx, :), Costs, DepotCosts);
        Fitness(idx, :) = [Cost idx];
    end
    Fitness = sortrows(Fitness, 1);
    NewPopulation = zeros(PopulationSize, SolutionSize);
    for idx = 1:PopulationSize
        NewPopulation(idx, :) = Everyone(Fitness(idx, 2), :);
    end
end

function [MinSoln, MinCost] = best_soln_in_population(Population, Costs, DepotCosts)
    [PopulationSize, SolutionSize] = size(Population);
    MinCost = Inf;
    MinSoln = zeros(1, SolutionSize);
    for idx = 1:PopulationSize
        Cost = calculate_cost(Population(idx, :), Costs, DepotCosts);
        if Cost < MinCost
            MinCost = Cost;
            MinSoln = Population(idx, :);
        end
    end
end

