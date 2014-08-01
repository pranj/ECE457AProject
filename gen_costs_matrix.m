function [costs] = gen_costs_matrix(numPoints, maxDistance)
costs = triu(randi(maxDistance, numPoints));
costs = triu(costs, 1) + triu(costs, 1)';
costs(logical(eye(size(costs)))) = Inf;
end