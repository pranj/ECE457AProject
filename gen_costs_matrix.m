function [costs] = gen_costs_matrix(numPoints, maxDistance)
graph = triu(randi(maxDistance, numPoints));
graph = triu(graph, 1) + triu(graph, 1)';
depotCosts = randi(maxDistance, 1, numPoints);

costs = [graph depotCosts'];
end