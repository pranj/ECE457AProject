ECE457AProject
==============

ECE457A Project - GNSS Surveying

Generate random symmetric matrix and depot to point costs:
    graph = triu(randi(MAX_DISTANCE, num_points));
    graph = triu(graph, 1) + triu(graph, 1)';
    depotCosts = randi(MAX_DISTANCE, 1 num_points);
