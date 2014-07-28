function [neighbours, method] = get_neighbours(solution)
numRcvr = sum(solution == 0) + 1;

numPoints = size(solution, 2) - (numRcvr - 1);
numNeighbours = nchoosek(numPoints, 2) + numPoints*(numPoints + numRcvr - 2);
neighbourhood = zeros(numNeighbours, size(solution, 2) + 3);

neighbourIdx = 1;
for x = 1:numPoints
    for y = x+1:numPoints
        neighbourhood(neighbourIdx, 1:end-3) = swap(solution, x, y);
        neighbourhood(neighbourIdx, end-2:end) = [0 x y];
        neighbourIdx = neighbourIdx + 1;
    end
end

for x = 1:numPoints
    for y = 1:numPoints
        toAdd = add_remove(solution, x, y);
        if any(toAdd)
            neighbourhood(neighbourIdx, 1:end-3) = toAdd;
            neighbourhood(neighbourIdx, end-2:end) = [1 x y];
            neighbourIdx = neighbourIdx + 1;
        end
    end
end

neighbourhood = unique(neighbourhood, 'rows');
neighbours = neighbourhood(:, 1:end-3);
neighbours( ~any(neighbours, 2), :) = [];
method = neighbourhood(:, end-2:end);

end