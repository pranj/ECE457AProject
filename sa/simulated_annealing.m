function [x] = ...
    simulated_annealing(initial, cooling_schedule, alpha, iter_per_temp)
current_score = Inf;
current_solution = initial;

temp_iter = 0;
cooling_iter = 0;

initial_temp = 100;
current_temp = initial_temp;

%pick random neighbour instead of for loop
%for next_solution in all next iterations
    next_score = CalculateCost(next_solution);
    if next_score < current_score
        current_score = next_score;
        current_solution = next_solution;
    else
        p = exp(-(next_score-current_score)/current_temp);
        if p > rand
            current_score = next_score;
            current_solution = next_solution;
        end
    end
    
    temp_iter = temp_iter + 1;
    if temp_iter == iter_per_temp
        current_temp = change_temp(inital_temp, cooling_schedule, iter);
        cooling_iter = cooling_iter + 1;
        temp_iter = 0;
    end
end

function new_temp = change_temp(temp, schedule, alpha, iteration)
if schedule == 1
    new_temp = initial_temp*alpha^iteration
end     
end

function [solutions] = next_iteration(solution)

end
