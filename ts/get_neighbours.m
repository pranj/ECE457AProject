function [neighbours, method] = get_neighbours(solution)
numRcvr = sum(solution == 0) + 1;

numPoints = size(solution, 2) - (numRcvr - 1);
numNeighbours = nchoosek(numPoints, 2) + numPoints*(numPoints + numRcvr - 2);
neighbourhood = zeros(numNeighbours, size(solution, 2) + 3);

neighbourIdx = 1;
for i = 1:numPoints
    for j = i+1:numPoints
        neighbourhood(neighbourIdx, 1:end-3) = swap(solution, i, j);
        neighbourhood(neighbourIdx, end-2:end) = [0 i j];
        neighbourIdx = neighbourIdx + 1;
    end
end

for i = 1:numPoints
    for j = 1:numPoints
        neighbourhood(neighbourIdx, 1:end-3) = add_remove(solution, i, j);
        neighbourhood(neighbourIdx, end-2:end) = [1 i j];
        neighbourIdx = neighbourIdx + 1;
    end
end

neighbourhood = unique(neighbourhood, 'rows');
neighbours = neighbourhood(:, 1:end-3);
method = neighbourhood(:, end-2:end);

end