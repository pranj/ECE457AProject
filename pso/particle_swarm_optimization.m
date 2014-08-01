function [GlobalBestSolution, GlobalBestCost] = particle_swarm_optimization( ...
                Costs, NumIterations, NumParticles, NumPoints, NumReceivers, VMax)
    SolutionSize = NumPoints + NumReceivers - 1;

    GlobalBestCost = Inf;
    GlobalBestSolution = zeros(1, SolutionSize);

    % Initialization
    Particles = zeros(NumParticles, SolutionSize);
    for particle = 1:NumParticles
        ParticleSolution = gen_initial_solution(NumPoints, NumReceivers);
        Particles(particle, :) = ParticleSolution;
    end
    
    % Iterate until we hit the max number of iterations
    for iteration = 1:NumIterations
        IterationParticleCosts = Inf * ones(1, NumParticles);
    
        % Calculate the Fitness of each of the particles
        for particle = 1:NumParticles
            ParticleSolution = Particles(particle, :);
            IterationParticleCosts(particle) = calculate_cost(ParticleSolution, Costs, Costs(end, :));
        end
        
        % Get the local best and local worst
        [IterationBestParticleCost, IterationBestParticle] = min(IterationParticleCosts);
        IterationWorstParticleCost = max(IterationParticleCosts);
        
        % Replace global best if there is one
        if IterationBestParticleCost < GlobalBestCost
            GlobalBestCost = IterationBestParticleCost;
            GlobalBestSolution = Particles(IterationBestParticle, :);
        end

        % Calculate velocity and next position
        for particle = 1:NumParticles
            ParticleSolution = Particles(particle, :);
            ParticleVelocity = calculate_velocity_size(VMax, IterationParticleCosts(particle), IterationWorstParticleCost);

            NextParticleSolution = ParticleSolution;
            for i = 1:ParticleVelocity
                CandidateNeighbour = random_neighbour(NextParticleSolution);
                while ~any(CandidateNeighbour)
                    CandidateNeighbour = random_neighbour(NextParticleSolution);
                end
                NextParticleSolution = CandidateNeighbour;
            end

            Particles(particle, :) = NextParticleSolution;
        end
    end

end

function [NumMoves] = calculate_velocity_size(VMax, ParticleCost, WorstParticleCost)
    NumMoves = ceil((ParticleCost / WorstParticleCost) * VMax);
end
