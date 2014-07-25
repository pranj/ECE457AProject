% This function outputs the cost of each receiver and the total cost

function [totalCost, cost] = calculate_cost(solution, costs, depotCosts)
[num_receivers, num_points] = size(solution);
cost = zeros(1, num_receivers);

for receiver = 1:num_receivers
    % Calculate cost of a single tour 
    % Find sum of cost of adjacent 
    for i = 1:num_points
        if solution(receiver, i + 1) == 0
            break
        else
            from = solution(receiver, i);
            to = solution(receiver, i + 1);
            if i == 1
                cost(receiver) = cost(receiver) ...
                    + depotCosts(from);
            end
            
            cost(receiver) = cost(receiver) + costs(from, to);
        end
    end
end

totalCost = sum(cost);
end
