function [initTemp] = calculate_init_temp(costs, initialProb)
    numPoints = size(costs, 1);
    sortedCosts = sort(reshape(triu(costs, 1), 1, numPoints*numPoints), 'descend');
    sortedCosts(sortedCosts == 0) = [];
    
    % the max change in objective function is the removal of a point B
    % from a sub-path A-X-B and insertion into sub-path D-E. A-X and
    % X-C is a part of the set of 3 smallest path costs and A-C is part of 
    % the set of 3 largest path costs. D-E is part of the 3 smallest path
    % costs and D-X and X-E is part of the 3 largest path costs

    maxChange = sum(sortedCosts(1:3)) - sum(sortedCosts(end:end-3));
    initTemp = -1 * maxChange/log(initialProb); 
end