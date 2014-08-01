% This function outputs the total cost of the solution

function [totalCost] = calculate_cost(solution, costs, depotCosts)

totalCost = 0;

for i = 1:size(solution, 2)
    if solution(i) <= 0
        continue
    elseif i == 1 || solution(i - 1) <= 0;
        totalCost = totalCost + depotCosts(solution(i));
    else
        from = solution(i - 1);
        to = solution(i);
        totalCost = totalCost + costs(from, to);
    end
end
