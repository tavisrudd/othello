"""Regenerate the source-only dependency graph."""
from check_formal_artifact import ROOT,dependency_graph
if __name__=='__main__':
    (ROOT/'verification/dependency-graph.dot').write_text(dependency_graph((ROOT/'continuation_graph_rigidity.tex').read_text()))
