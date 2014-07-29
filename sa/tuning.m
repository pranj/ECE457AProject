aplha = 0.5:0.1:0.9
ipt = 10:10:1000
X = zeros(5, 100)


BestCost = Inf;
bestalpha = Inf;
bestipt = Inf;
A = 0.5:0.1:0.9;
B = 10:10:1000;
M = zeros(numel(A), numel(B));
for alpha = A
    for ipt = B
        Y = zeros(1, 2);
        for idx = 1:numel(Y)
            [S C] = simulated_annealing(Costs, alpha, 2.2768e+04, ipt, 0.1, I);
            Y(idx) = C;
            if C < BestCost
                bestipt = ipt;
                bestalpha = alpha;
            end
        end
        M((aplha - 0.5)/0.1 + 1, (ipt - 10)/10 + 1) = mean(Y);
    end
end

I = [34    1   35   30   37   43   50    4   15   25   11   47   14   21    0   44   49   46    8   42   40   26    2   33 12   18   51    5   10   45   20    7   16   39   41   23   13   31    6   32   29    3   48    0   19   17   38   28 24    9   36    0   22   27];
