function [costs] = run_aco(Costs)
    costs          =  zeros(5, 4);
    NumIterations  =  35;
    NumPoints      =  51;
    NumReceivers   =  5;
    pop            =  20;
    pCross         =  0.1;
    pMut           =  0.1;
    params         =  [pop pCross pMut];
    change         =  [5 0.1 0.1];

    NumOfRuns = 3;
    for i = 1:3
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    ga(Costs, NumIterations, params(1),...
		        params(2), params(3), NumPoints, NumReceivers);
                total = total + cost;
            end
            costs(k, i) = total/5;
            params(i) = params(i) + change(i);
        end
        [~, idx] = min(costs(:, i));
        params(i) = params(i) - (5-idx)*change(i);
    end
end

