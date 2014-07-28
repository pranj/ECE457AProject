function [Child1 Child2] = cycle_crossover(Parent1, Parent2)
    ChromosomeLength = size(Parent1, 2);
    Cycles = zeros(1, ChromosomeLength);

    CurrentCycle = 1;
    while !isempty(find(Cycles == 0))
        StartingIndex = find(Cycles == 0, 1);

        CurrentIndex = StartingIndex;
        i = 1;
        while i == 1 || CurrentIndex ~= StartingIndex
            i = i + 1; % Do-while hack... sorry :/
            Cycles(CurrentIndex) = CurrentCycle;
            CurrentValue = Parent2(CurrentIndex);
            CurrentIndex = find(Parent1 == CurrentValue, 1);
        end
        CurrentCycle = CurrentCycle + 1;
    end

    Child1 = zeros(1, ChromosomeLength);
    Child2 = zeros(1, ChromosomeLength);

    for idx = 1:ChromosomeLength
        if mod(Cycles(idx), 2) == 1
            Child1(idx) = Parent1(idx);
            Child2(idx) = Parent2(idx);
        else
            Child1(idx) = Parent2(idx);
            Child2(idx) = Parent1(idx);
        end
    end
end