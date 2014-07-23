Simulated Annealing for mTSP.

Design
------

1. Determine starting temperature T0

  a. T0 = -max(f1-f2)/lnP0
  
  b. Heuristic: start at a high T and reduce until 50% are selected. Use this T for SA

2. Stopping criteria

  a. Low temperature (Tf = 10E-10 to 10E-5)
  
  b. Frozen system: worse solutions are never being accepted anymore

3. Cooling schedule

  a. Linear T = T0 - Bi (need to know final temperature and number of iterations to solve for B)
  
  b. Geometric T = Ta^i

4. Iteration at each temperature

  a. Constant

  b. Dynamic based on better or worse solutions
