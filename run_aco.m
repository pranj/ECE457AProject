function [costs] = run_aco(CostData)

    costs = zeros(5, 4);
    NumIterations = 50;
    NumPoints = 51;
    NumReceivers = 5;
    NumAnts = 3;
    NumInitialPheromone = 0.01;
    Alpha = 1;
    Beta = 1;
    EvapRate = 0.1;
    Ro = 0.75;
    
    params = [NumAnts NumInitialPheromone EvapRate Ro];
    change = [3 0.05 0.05 0.045];
    
    NumOfRuns = 10;
    for i = 1:4
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    ant_colony_optimization(CostData, NumIterations, NumPoints,...
                        NumReceivers, params(1), params(2), Alpha, Beta,...
                        params(3), params(4));
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

