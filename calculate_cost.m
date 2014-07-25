% This function outputs the cost of each receiver and the total cost

function [totalCost, cost] = calculate_cost(solution, costs, depotCosts)
[numReceivers, numPoints] = size(solution);
cost = zeros(1, numReceivers);

for receiver = 1:numReceivers
    % Calculate cost of a single tour
    % Find sum of cost of adjacent
    for i = 1:numPoints
        src = solution(receiver, i);
        if i == 1
            cost(receiver) = depotCosts(src);
        end
        if i < numPoints
            if solution(receiver, i + 1) == 0
                break
            end
            to = solution(receiver, i + 1);
            cost(receiver) = cost(receiver) + costs(src, to);
        end
    end
end

totalCost = sum(cost);
end
