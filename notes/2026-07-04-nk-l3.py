"""L3 false-twin parity compression.

A false-twin class = maximal set of vertices with identical OPEN neighborhood.
Such vertices are automatically pairwise non-adjacent (equal open nbhd N(u)=N(v)
=> u in N(v) would force v in N(v), impossible). Claim: a class of size k can be
replaced by 1 vertex (k odd) or 2 vertices (k even) preserving whole-graph nimber.
"""
from collections import defaultdict


def false_twin_classes(adj):
    groups = defaultdict(list)
    for v in adj:
        groups[frozenset(adj[v])].append(v)
    return list(groups.values())


def compress_l3(adj, iterate=False):
    """Single-pass (or iterated-to-fixpoint) L3 compression. Returns new adj dict."""
    adj = {v: set(ns) for v, ns in adj.items()}
    while True:
        groups = false_twin_classes(adj)
        remove = set()
        for g in groups:
            if len(g) <= 1:
                continue
            # sanity: false twins must be pairwise non-adjacent
            for u in g:
                assert not (adj[u] & set(g)), "twin class not independent!"
            keep = 1 if (len(g) % 2 == 1) else 2
            for v in g[keep:]:
                remove.add(v)
        if not remove:
            return adj
        adj = {v: (adj[v] - remove) for v in adj if v not in remove}
        if not iterate:
            return adj
