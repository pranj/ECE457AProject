
function [costs] = run_ga(CostData)
    costs = zeros(5, 4);
    
    NumIterations = 150;
    PopulationSize = 5;
    CrossoverProbability = 0.6;
    MutationProbability = 0.05;
    
    NumReceivers = 5;
    NumPoints = 51;
    
    params = [NumIterations PopulationSize CrossoverProbability MutationProbability];
    change = [70 8 0.07 0.17];
    
    NumOfRuns = 10;
    for i = 1:4
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    ga(CostData, NumIterations, PopulationSize, ...
                        CrossoverProbability, MutationProbability, ...
                        NumPoints, NumReceivers);
                total = total + cost;
            end
            costs(k, i) = total/NumOfRuns;
            params(i) = params(i) + change(i);
        end
        [~, idx] = min(costs(:, i));
        params(i) = params(i) - (6-idx)*change(i);
    end
    disp(params);
end