% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

function [nextSolution] = random_add_remove(solution)

limit = max(solution);

removedPoint = randi(limit);
removeIdx = find(solution == removedPoint);
insertIdx = randi(size(solution, 2));

if removeIdx > insertIdx
    solution(insertIdx + 1:removeIdx) = solution(insertIdx:removeIdx - 1);
    solution(insertIdx) = removedPoint;
else
    solution(removeIdx:insertIdx - 1) = solution(removeIdx + 1:insertIdx);
    solution(insertIdx) = removedPoint;
end

nextSolution = solution;

end
