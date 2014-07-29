function [costs] = run_pso(CostData)
    costs = zeros(5, 3);
    
    InertiaWeight = 0.5
    CognitiveAccel = 0.5
    NumParticle = 100
    SocialAccel = 0.5
    
    NumIterations = 50;
    NumReceivers = 5;
    NumPoints = 51;
    
    params = [InertiaWeight CognitiveAccel SocialAccel];
    change = [0.25 0.25 0.25];
    
    NumOfRuns = 4;
    for i = 1:3
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    new_pso(CostData, NumIterations, NumParticle, ...
                    NumPoints, NumReceivers, InertiaWeight, ...
                    CognitiveAccel, SocialAccel);
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