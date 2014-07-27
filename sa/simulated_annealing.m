function [GlobalBestCost] = simulated_annealing( ...
                    Costs, Alpha, NumPoints, NumReceivers, InitialTemperature, IterationsPerTemperature, FinalTemperature)
SolutionSize = NumPoints + NumReceivers - 1;

GlobalBestCost = Inf;
GlobalBestSolution = zeros(1, SolutionSize);

CurrentSoln = [4 3 0 2 1];%gen_initial_solution(NumPoints, NumReceivers);
CurrentSolnCost = calculate_cost(CurrentSoln, Costs, Costs(end, :));

CurrentTemperature = InitialTemperature;
LastTemperatureUpdate = 0;

iteration = 1;
while CurrentTemperature > FinalTemperature
    Neighbour = random_swap(CurrentSoln);
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

    iteration += 1;
end