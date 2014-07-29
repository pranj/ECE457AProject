function [costs] = run_aco(Costs)

    costs = zeros(5, 4);
    NumIterations = 35;
    NumPoints = 51;
    NumReceivers = 5;
    NumAnts = 2;
    NumInitialPheromone = 0.5;
    Alpha = 1;
    Beta = 1;
    EvapRate = 0.1;
    Ro = 0.1;
    
    params = [NumAnts NumInitialPheromone EvapRate Ro];
    change = [2 0.9 0.16 0.16];
    
    NumOfRuns = 3;
    for i = 1:4
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    ant_colony_optimization(Costs, NumIterations, NumPoints,...
                        NumReceivers, params(1), params(2), Alpha, Beta,...
                        params(3), params(4));
                total = total + cost;
            end
            costs(k, i) = total/5;
            params(i) = params(i) + change(i);
        end
        [~, idx] = min(costs(:, i));
        params(i) = params(i) - (5-idx)*change(i);
    end
end

