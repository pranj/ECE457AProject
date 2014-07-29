function [GlobalBest, GlobalBestCost] = new_pso( ...
                Costs, NumIterations, NumParticles, ...
                NumPoints, NumReceivers, ...
                inertiaWeight, cognitiveAccel, socialAccel)
    SolutionSize = NumPoints + NumReceivers - 1;
    maxVelocity = 50;

    % initialize particle position/solution
    ParticlePosition = zeros(NumParticles, SolutionSize);
    ParticleBest = zeros(NumParticles, SolutionSize);
    ParticleBestCost = zeros(1, NumParticles);
    
    % 3D matrix of velocity swap sets
    ParticleVelocity = zeros(NumParticles, 2, maxVelocity);
    for particle = 1:NumParticles
        ParticleSolution = pso_initial_solution(NumPoints, NumReceivers);
        
        ParticlePosition(particle, :) = ParticleSolution;
        ParticleBest(particle, :) = ParticlePosition(particle, :); 
        ParticleBestCost(particle) = calculate_cost(ParticlePosition(particle, :), Costs, Costs(end, :));
    end
    
    % initialize global best
    [GlobalBestCost GlobalBestParticle] = min(ParticleBestCost);
    GlobalBest = ParticleBest(GlobalBestParticle, :);

    % perform PSO
    for iteration = 1:NumIterations
        for particle = 1:NumParticles
            % update particle velocity
            vInertia = 1*squeeze(ParticleVelocity(particle, :, :))';
            if ~any(vInertia)
                vInertia = [];
            else
                vInertia(~any(vInertia, 2), :) = [];
            end
            
            vCognitive = calculate_velocity(ParticleBest(particle, :), ParticlePosition(particle, :));
            vSocial = calculate_velocity(GlobalBest, ParticlePosition(particle, :));
            
            rCognitive = rand;
            rSocial = rand;
            
            % ceiling up to next 0.5 multiple
            cogCoeff = cognitiveAccel * rCognitive;
            socCoeff = socialAccel * rSocial;
            
            % how many of each velocity set to apply
            inertiaCount = floor(inertiaWeight * size(vInertia, 1));
            cogCount = floor(cogCoeff * size(vCognitive, 1));
            socCount = floor(socCoeff * size(vSocial, 1));
            
            nextVelocity = calculate_next_velocity(inertiaCount, vInertia, cogCount, vCognitive, socCount, vSocial);
            
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

function [nextVelocity] = calculate_next_velocity(w, vInertia, c1r1, vCog, c2r2, vSoc)
    if any([w c1r1 c2r2])
        velocityIndex = 1;
        nextVelocity = zeros(w + c1r1 + c2r2, 2);
        for v = 1:w
            if size(vInertia, 1) == 1
                truV = 1;
            elseif v ~= size(vInertia, 1)
                truV = mod(v, size(vInertia, 1));
            else
                truV = v;
            end
            nextVelocity(velocityIndex, :) = vInertia(truV, :);
            velocityIndex = velocityIndex + 1;
        end
        for v = 1:c1r1
            if size(vCog, 1) == 1
                truV = 1;
            elseif v ~= size(vCog, 1)
                truV = mod(v, size(vCog, 1));
            else
                truV = v;
            end
            nextVelocity(velocityIndex, :) = vCog(truV, :);
            velocityIndex = velocityIndex + 1;
        end
        for v = 1:c2r2
            if size(vSoc, 1) == 1
                truV = 1;
            elseif v ~= size(vSoc, 1)
                truV = mod(v, size(vSoc, 1));
            else
                truV = v;
            end
            nextVelocity(velocityIndex, :) = vSoc(truV, :);
            velocityIndex = velocityIndex + 1;
        end
    else
        nextVelocity = [];
    end
end
