
function [costs] = run_ga(CostData)
    costs = zeros(5, 2);
    
    NumIterations = 200;
    PopulationSize = 20;
    CrossoverProbability = 0.75;
    MutationProbability = 0.65;
    
    NumReceivers = 5;
    NumPoints = 51;
    
    params = [MutationProbability CrossoverProbability];
    change = [0.05 0.04];
    
    NumOfRuns = 2;
    for i = 1:2
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