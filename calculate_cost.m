% This function outputs the cost of each receiver and the total cost

function [totalCost, cost] = calculate_cost(solution, costs, depotCosts)
[numReceivers, numPoints] = size(solution);
cost = zeros(1, numReceivers);

for receiver = 1:numReceivers
    % Calculate cost of a single tour
    % Find sum of cost of adjacent
    for i = 1:numPoints
        current = solution(receiver, i);
        if current == 0
            break
        end


        if i == 1
            cost(receiver) = depotCosts(current);
        else
            previous = solution(receiver, i - 1);
            cost(receiver) = cost(receiver) + costs(previous, current);
        end
    end
end

totalCost = sum(cost);
end
