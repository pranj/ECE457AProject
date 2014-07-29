% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

% WARNING PLEASE CHECK FOR 0 WHEN CALLING THIS FUNCTION
% RANDOM_ADD_REMOVE CAN RETURN 0 IF ADJACENT POINTS ARE CALLED
% Use while ~any(random_add_remove...)

function [nextSolution] = random_add_remove(solution)
solSize = size(solution, 2);

removeIdx = randi(solSize);
while ~solution(removeIdx)
    removeIdx = randi(solSize);
end

removePoint = solution(removeIdx);
insertIdx = randi(size(solution, 2) - 1);

nextSolution = add_remove(solution, removePoint, insertIdx);

end
