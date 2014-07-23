function [x] = sa(initial, cooling_schedule, alpha, iter_per_temp)
current_score = Inf;
current_sol;

temp_iter = 0;
iter = 0;

initial_temp = 100;
current_temp = initial_temp;

%for next_solution in all next iterations
    next_score = evaluate(next_solution);
    if next_score < current_score
        current_score = next_score;
        current_sol = next_solution;
    else
        p = exp(-(next_score-current_score)/current_temp);
        if p > rand
            current_score = next_score;
            current_sol = next_solution;
        end
    end
    
    temp_iter = temp_iter + 1;
    iter = iter + 1;
    if temp_iter == iter_per_temp
        current_temp = change_temp(inital_temp, cooling_schedule, iter);
        temp_iter = 0;
    end
end

function new_temp = change_temp(temp, schedule, alpha, iteration)
if schedule == 1
    new_temp = initial_temp*alpha^iteration
end     
end
 
function [y] = evaluate(solution)
y = 0;
end

