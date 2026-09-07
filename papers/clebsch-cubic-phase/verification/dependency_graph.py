"""Write the deterministic authored statement dependency graph."""
from check import V, graph, statements
(V/'dependency-graph.dot').write_text(graph(statements()))
