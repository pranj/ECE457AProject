% This functions generates another solution by performing a random swap 
% between any two points

function [nextSolution] = swap(solution, point1, point2)

tmp = solution(point1);
solution(point1) = solution(point2);
solution(point2) = tmp;

nextSolution = solution;

end
