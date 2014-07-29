function [GlobalBest, GlobalBestCost] = new_pso( ...
                Costs, NumIterations, NumParticles, NumPoints, NumReceivers)
    SolutionSize = NumPoints + NumReceivers - 1;
    maxVelocity = 50;

    % initialize particle position/solution and initial velocity (which can
    % be tuned)
    ParticlePosition = zeros(NumParticles, SolutionSize);
    ParticleBest = zeros(NumParticles, SolutionSize);
    ParticleBestCost = zeros(1, NumParticles);
    % 3D matrix of velocity swap sets
    ParticleVelocity = zeros(NumParticles, 2, maxVelocity);
    for particle = 1:NumParticles
        ParticleSolution = gen_initial_solution(NumPoints, NumReceivers);
        
        ParticlePosition(particle, :) = ParticleSolution;
        ParticleBest(particle, :) = ParticlePosition(particle, :); 
        ParticleBestCost(particle) = calculate_cost(ParticlePosition(particle, :), Costs, Costs(end, :));
    end
    
    % initialize global best
    [GlobalBestCost GlobalBestParticle] = min(ParticleBestCost);
    GlobalBest = ParticleBest(GlobalBestParticle, :);

    % perform PSO
    for iteration = 1:NumIterations

        % move each particle
        for particle = 1:NumParticles
            % update particle velocity
            vInertia = 1*squeeze(ParticleVelocity(particle, :, :))';
            if ~any(vInertia)
                vInertia = [];
            else
                vInertia(~any(vInertia, 2), :) = [];
            end
            vCognitive = 1*1*calculate_velocity(ParticleBest(particle, :), ParticlePosition(particle, :));
            vSocial = 1*1*calculate_velocity(GlobalBest, ParticlePosition(particle, :));
            
            nextVelocity = [vInertia' vCognitive' vSocial']';
            
            % update particle position
            ParticlePosition(particle, :) = update_position(ParticlePosition(particle, :), nextVelocity);
            
            % update particle personal best
            newCost = calculate_cost(ParticlePosition(particle, :), Costs, Costs(end, :));
            if newCost < ParticleBestCost(particle)
                ParticleBestCost(particle) = newCost;
                ParticleBest(particle, :) = ParticlePosition(particle, :);
            end
            
            % update global best
            if newCost < GlobalBestCost
                GlobalBestCost = newCost;
                GlobalBestParticle = particle;
                GlobalBest = ParticlePosition(particle, :);
            end
            
            % loop through to update particle velocity for next iteration
            for y = 1:size(nextVelocity, 1)
                ParticleVelocity(particle, :, y) = nextVelocity(y, :);
            end
        end   
    end
end

function [position] = update_position(position, velocity)
    for x = 1:size(velocity, 1)
        swapIdx1 = find(position == velocity(x, 1));
        swapIdx2 = find(position == velocity(x, 2));
        position = swap(position, swapIdx1, swapIdx2);
    end
end

function [velocity] = calculate_velocity(best, current)
if ~isequal(current, best)
    velocity = zeros(size(best, 2), 2) - 1;
    for x = 1:size(best, 2)
        if best(x) ~= current(x)
            % account for trivial swaps
            % do not want to swap 0, 3 then 3, 0
            if find(velocity(:, 2) == current(x))
                continue
            else
                velocity(x, :) = [current(x) best(x)];
            end
        end
        
    end
    velocity(velocity(:, 2) < 0, :) = [];
else
    velocity = [];
end
end
