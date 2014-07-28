function [GlobalBestSolution, GlobalBestCost] = simulated_annealing( ...
                    Costs, Alpha, NumReceivers, InitialTemperature, IterationsPerTemperature, FinalTemperature, ...
                    InitialSoln)
NumPoints = size(Costs, 1);
SolutionSize = NumPoints + NumReceivers - 1;

GlobalBestCost = Inf;
GlobalBestSolution = zeros(1, SolutionSize);

CurrentSoln = InitialSoln;
CurrentSolnCost = calculate_cost(CurrentSoln, Costs, Costs(end, :));

CurrentTemperature = InitialTemperature;
LastTemperatureUpdate = 0;

iteration = 1;
while CurrentTemperature > FinalTemperature
    Neighbour = random_neighbour(CurrentSoln);
    while ~any(Neighbour)
        Neighbour = random_neighbour(CurrentSoln);
    end
        
    NeighbourCost = calculate_cost(Neighbour, Costs, Costs(end, :));
    CostDifference = NeighbourCost - CurrentSolnCost;

    if CostDifference < 0
        CurrentSoln = Neighbour;
        CurrentSolnCost = NeighbourCost;
    else
        AcceptanceProb = exp( -1 * CostDifference / CurrentTemperature );
        r = rand(1, 1);
        if r < AcceptanceProb
            CurrentSoln = Neighbour;
            CurrentSolnCost = NeighbourCost;
        end
    end

    if CurrentSolnCost < GlobalBestCost
        GlobalBestCost = CurrentSolnCost;
        GlobalBestSolution = CurrentSoln;
    end

    IterationsSinceLastUpdate = iteration - LastTemperatureUpdate;
    if IterationsSinceLastUpdate >= IterationsPerTemperature
        NumberOfUpdates = iteration / IterationsPerTemperature;
        CurrentTemperature = InitialTemperature * (Alpha ^ NumberOfUpdates);
        LastTemperatureUpdate = iteration;
    end

    iteration = iteration + 1;
end