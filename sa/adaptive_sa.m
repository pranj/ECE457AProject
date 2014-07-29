function [GlobalBestSolution, GlobalBestCost] = adaptive_sa( ...
                    Costs, InitialSoln, Alpha, maxNoChange)
                
InitialTemperature = calculate_init_temp(Costs, 0.8);
IterationsPerTemperature = 5;
GlobalBestCost = calculate_cost(InitialSoln, Costs, Costs(end, :));
GlobalBestSolution = InitialSoln;

CurrentSoln = InitialSoln;
CurrentSolnCost = calculate_cost(CurrentSoln, Costs, Costs(end, :));

CurrentTemperature = InitialTemperature;
LastTemperatureUpdate = 0;

plot_points = zeros(50, 1);

iterNoChange = 0;
iteration = 1;
while iterNoChange <= maxNoChange
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
        iterNoChange = 0;
    else
        iterNoChange = iterNoChange + 1;
    end
    
    plot_points(iteration) = GlobalBestCost;
    plot(plot_points)
    drawnow
    
    IterationsSinceLastUpdate = iteration - LastTemperatureUpdate;
    if IterationsSinceLastUpdate >= IterationsPerTemperature
        if iterNoChange < maxNoChange / 2
            IterationsPerTemperature = IterationsPerTemperature + 1;
        else
            IterationsPerTemperature = IterationsPerTemperature - 1;
        end
        NumberOfUpdates = iteration / IterationsPerTemperature;
        CurrentTemperature = InitialTemperature * (Alpha ^ NumberOfUpdates);
        LastTemperatureUpdate = iteration;
    end

    iteration = iteration + 1;
end