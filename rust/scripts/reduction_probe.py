#!/usr/bin/env python3
"""Leaf/simplicial/dominated-vertex REDUCTION probe for Node-Kayles (Non-Attacking Queens).

Two questions:
  (1) PREVALENCE: over distinct deep-tail graphs (pc/m 18-28, dedup by avail), how many
      leaves (deg1), simplicial vertices (closed nbhd is a clique), dominated-vertex pairs
      (N[u] subset N[v], u!=v), deg-2 vertices does each graph have?
  (2) SOUNDNESS: propose candidate nimber-preserving vertex reductions, and EMPIRICALLY
      validate each against the exact Grundy value (nk_solve nimber). Discard any rule that
      EVER mispredicts. Then apply the validated set to a fixed point, canonicalize the
      reduced form, and measure the collapse ratio.

Reuses load/build_graph/nk_solve from treewidth_dp_probe.
"""
import sys, random
from collections import defaultdict, Counter
sys.path.insert(0, sys.path[0] or '.')
sys.setrecursionlimit(1 << 20)

from treewidth_dp_probe import load, build_graph, nk_solve

# ----------------------------------------------------------------- graph helpers
# Graph repr: list of int adjacency bitmasks `adj` over local vertices [0..m).
# closed[i] = adj[i] | (1<<i).

def closed_of(adj):
    return [adj[i] | (1 << i) for i in range(len(adj))]

def deg(adj, i):
    return bin(adj[i]).count('1')

def is_simplicial(adj, i):
    """v is simplicial iff its open neighborhood induces a clique (N(v) is a clique)."""
    nb = adj[i]
    rem = nb
    while rem:
        b = rem & -rem; rem ^= b
        u = b.bit_length() - 1
        # every other neighbor of v must be adjacent to u (or be u)
        others = nb & ~(1 << u)
        if (adj[u] & others) != others:
            return False
    return True

def dominated_pairs(adj):
    """Count ORDERED pairs (u,v), u!=v, with N[u] subset N[v] (closed-nbhd domination).
    Returns (count_ordered, set_of_u_that_are_dominated_by_some_v)."""
    m = len(adj)
    cl = closed_of(adj)
    cnt = 0
    dom_u = set()
    for u in range(m):
        cu = cl[u]
        for v in range(m):
            if u == v:
                continue
            if (cu & cl[v]) == cu:   # N[u] subset N[v]
                cnt += 1
                dom_u.add(u)
    return cnt, dom_u

def open_dominated_pairs(adj):
    """Ordered pairs (u,v), u!=v, N(u) subset N[v] AND u adjacent to v (open domination,
    the classic 'v dominates u' used in some reductions). Just for prevalence."""
    m = len(adj)
    cl = closed_of(adj)
    cnt = 0
    for u in range(m):
        nu = adj[u]
        for v in range(m):
            if u == v:
                continue
            if (nu & cl[v]) == nu and (adj[u] >> v) & 1:
                cnt += 1
    return cnt

# ----------------------------------------------------------------- relabel/compact
def compact(adj, keep_mask):
    """Return new adjacency containing only vertices in keep_mask (a bitmask), relabeled 0..k."""
    keep = []
    rem = keep_mask
    while rem:
        b = rem & -rem; rem ^= b
        keep.append(b.bit_length() - 1)
    idx = {old: new for new, old in enumerate(keep)}
    k = len(keep)
    new = [0] * k
    for old in keep:
        ni = idx[old]
        nb = adj[old] & keep_mask
        r = nb
        while r:
            b = r & -r; r ^= b
            o = b.bit_length() - 1
            new[ni] |= (1 << idx[o])
    return new

def grundy(adj, cap=1 << 22):
    """Exact Grundy value via full nimber. Returns nimber or None if capped."""
    m = len(adj)
    if m == 0:
        return 0
    full = (1 << m) - 1
    closed = closed_of(adj)
    memo = {}
    overflow = [False]
    def g(A):
        if A == 0:
            return 0
        v = memo.get(A)
        if v is not None:
            return v
        if len(memo) >= cap:
            overflow[0] = True
            return 0
        s = set()
        rem = A
        while rem:
            b = rem & -rem; rem ^= b
            i = b.bit_length() - 1
            s.add(g(A & ~closed[i]))
        gg = 0
        while gg in s:
            gg += 1
        memo[A] = gg
        return gg
    res = g(full)
    return None if overflow[0] else res

# ----------------------------------------------------------------- component split
def components(adj):
    """Yield connected components as compacted adjacency lists."""
    m = len(adj)
    seen = 0
    comps = []
    for start in range(m):
        if (seen >> start) & 1:
            continue
        # BFS
        comp = 0
        stack = [start]
        seen |= (1 << start)
        comp |= (1 << start)
        while stack:
            x = stack.pop()
            nb = adj[x] & ~seen
            r = nb
            while r:
                b = r & -r; r ^= b
                y = b.bit_length() - 1
                seen |= (1 << y); comp |= (1 << y); stack.append(y)
        comps.append(compact(adj, comp))
    return comps

# ----------------------------------------------------------------- canonical form (WL-ish hash)
def wl_hash(adj, rounds=4):
    """Weisfeiler-Leman color refinement hash (graph invariant, not a perfect canon but a
    good collision-resistant proxy for counting distinct reduced forms)."""
    m = len(adj)
    if m == 0:
        return ('empty',)
    colors = [1] * m
    for _ in range(rounds):
        newc = []
        for i in range(m):
            nb = adj[i]
            multiset = []
            r = nb
            while r:
                b = r & -r; r ^= b
                multiset.append(colors[b.bit_length() - 1])
            newc.append(hash((colors[i], tuple(sorted(multiset)))))
        # renormalize colors to small ints to keep hashes stable
        uniq = {c: k for k, c in enumerate(sorted(set(newc)))}
        colors = [uniq[c] for c in newc]
    return (m, tuple(sorted(Counter(colors).items())),
            tuple(sorted(deg(adj, i) for i in range(m))))

def canon_form(adj):
    """Canonical multiset over connected components (sorted WL hashes). Components are an
    exact decomposition for Node-Kayles (Grundy = XOR), so canonicalizing per-component is
    sound for the TT-merge intent."""
    comps = components(adj)
    return tuple(sorted(wl_hash(c) for c in comps))

# ============================================================ candidate reductions
# Each reduction: try to find an applicable vertex/structure, return (new_adj, delta_nimber)
# where claimed: grundy(G) == grundy(new_adj) XOR delta_nimber.
# We validate this empirically.

def reduce_isolated(adj):
    """deg-0 vertex (K1, nimber 1). Removing it XORs 1 into the nimber.
    Claim: grundy(G) == grundy(G - v) XOR 1.  (Known ISO_STRIP.)"""
    for i in range(len(adj)):
        if adj[i] == 0:
            new = compact(adj, ((1 << len(adj)) - 1) & ~(1 << i))
            return new, 1, i
    return None

def reduce_pendant_pair(adj):
    """A pendant (leaf) u attached to v, where v's ONLY other structure... try the simplest:
    if u is a leaf (deg 1) attached to v, and v has degree 1 too (i.e. {u,v} is an isolated
    edge K2). K2 has nimber 1. Removing the whole K2 component XORs 1.
    Claim: grundy(G) == grundy(G - {u,v}) XOR 1 when {u,v} is an isolated edge."""
    m = len(adj)
    for u in range(m):
        if deg(adj, u) == 1:
            v = (adj[u] & -adj[u]).bit_length() - 1
            if deg(adj, v) == 1:   # isolated edge
                new = compact(adj, ((1 << m) - 1) & ~((1 << u) | (1 << v)))
                return new, 1, (u, v)
    return None

def reduce_dominated_delete(adj):
    """DOMINATED VERTEX DELETION (candidate, to be validated):
    If N[u] subset N[v] (u != v), claim u is 'irrelevant' and grundy(G) == grundy(G - u).
    Tests the prompt's hypothesis directly. delta = 0."""
    m = len(adj)
    cl = closed_of(adj)
    for u in range(m):
        cu = cl[u]
        for v in range(m):
            if u == v:
                continue
            if (cu & cl[v]) == cu:
                new = compact(adj, ((1 << m) - 1) & ~(1 << u))
                return new, 0, (u, v)
    return None

def reduce_dominated_open(adj):
    """Open-domination deletion variant: N(u) subset N(v), u != v, u NOT adjacent v.
    (The 'twin-ish without edge' case.) Claim grundy(G) == grundy(G - u). delta=0."""
    m = len(adj)
    for u in range(m):
        nu = adj[u]
        for v in range(m):
            if u == v:
                continue
            if not ((nu >> v) & 1) and (nu & adj[v]) == nu and nu != 0:
                # N(u) subset N(v), non-adjacent
                new = compact(adj, ((1 << m) - 1) & ~(1 << u))
                return new, 0, (u, v)
    return None
