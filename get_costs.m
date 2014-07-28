% Input: file containing tsp coordinates
% Output: An adjacency matrix containing the costs between each point
function [Costs]=get_costs(infile)
    [Dimension,Nodes,~,~] = GetTSPData(infile);
    n = Dimension;
    Costs = Inf(n,n);
    
    for i = 1:n
        for j = i+1:n
            Dist = sqrt((Nodes(i, 2) - Nodes(j, 2))^2 + ...
                (Nodes(i, 3) - Nodes(j, 3))^2);
            Costs(i, j) = Dist;
            Costs(j, i) = Dist;
        end
    end
end