% This function outputs the total cost of the solution

function [totalCost] = calculate_cost(solution, costs, depotCosts)

currentCost = 0;
totalCost = 0;

for i = 1:size(solution, 2)
    if solution(i) == 0
        totalCost = totalCost + currentCost;
        currentCost = 0;
    elseif i == 1 || solution(i-1) == 0;
        currentCost = currentCost + depotCosts(solution(i));
    else
        from = solution(i-1);
        to = solution(i);
        currentCost = currentCost + costs(from, to);
    end
    
end
