ECE457AProject
==============

ECE457A Project - GNSS Surveying

A random symmetric matrix can be generated using:

    graph = triu(randi(MAX_DISTANCE), num_points, num_points);
    graph = triu(graph, 1) + triu(graph, 1)';
