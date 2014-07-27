% This function generates a random neighbour from the current solution.
% There is a 50% chance that the neighbour is generated with a swap operation
% and a 50% chance that the neighbour is generated an add/remove operation

function [neighbour] = random_neighbour(solution)

r = rand(1, 1);

if r < 0.5
    neighbour = random_swap(solution);
else
    neighbour = random_add_remove(solution);
end