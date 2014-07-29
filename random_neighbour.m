% This function generates a random neighbour from the current solution.
% There is a 50% chance that the neighbour is generated with a swap operation
% and a 50% chance that the neighbour is generated an add/remove operation

% WARNING PLEASE CHECK FOR 0 WHEN CALLING THIS FUNCTION
% RANDOM_ADD_REMOVE CAN RETURN 0 IF ADJACENT POINTS ARE CALLED
% Use while ~any(random_neighbour...)

function [neighbour] = random_neighbour(solution)

r = rand(1, 1);

if r < 0.5
    neighbour = random_swap(solution);
else
    neighbour = random_add_remove(solution);
end