function [currentTemp] = calculate_init_temp(costs, initialSol)
    currentTemp = 10E20;
    currentSolution = initialSol;
    currentCost = calculate_cost(currentSolution, costs, costs(end, :));
    
    totalWorst = 0;
    totalWorstSelected = 0;
    
    
    while (totalWorstSelected/totalWorst > 0.55 || totalWorst == 0)
        nextSolution = random_neighbour(currentSolution);
        nextCost = calculate_cost(nextSolution, costs, costs(end, :));
        
        costDiff = nextCost - currentCost;
        
        if costDiff < 0
           currentSolution = nextSolution;
           currentCost = nextCost;
        else
            totalWorst = totalWorst + 1;
            acceptanceRate = exp(-1 * costDiff / currentTemp);
            r = rand(1, 1);
            if r < acceptanceRate
                totalWorstSelected = totalWorstSelected + 1;
                currentSolution = nextSolution;
                currentCost = nextCost;
                currentTemp = currentTemp / 2;
            end
        end 
    end
end