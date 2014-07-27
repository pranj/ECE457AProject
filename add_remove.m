% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

%TODO only remove and add into another route
function [nextSolution] = add_remove(solution, removedPoint, insertIdx)
removeIdx = find(solution == removedPoint);
if removeIdx > insertIdx
    solution(insertIdx + 1:removeIdx) = solution(insertIdx:removeIdx - 1);
    solution(insertIdx) = removedPoint;
else
    solution(removeIdx:insertIdx - 1) = solution(removeIdx + 1:insertIdx);
    solution(insertIdx) = removedPoint;
end

nextSolution = solution;

end
