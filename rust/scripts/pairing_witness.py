#!/usr/bin/env python3
"""Do the P escaping-fourth-centre residuals have a PAIRING witness?

A Node-Kayles position on graph R is Grundy 0 (2nd player wins) if R has an
automorphism tau with tau^2=id, no fixed vertex, and no edge {v, tau(v)}:
2nd player answers move u with tau(u).  Such a tau is (a) an independent
re-proof that the child is P, and (b) an explicit, geometrically-constructible
certificate — exactly the kind of object a positive-density theorem could count.

This measures, among the P escape children of the four S4 triple classes, what
fraction admit such a pairing tau (vs. being P only for an adaptive reason).
"""
import argparse
import itertools

import networkx as nx

from three_centre_probe import (
    centres, conic_point, determinant, generated_group, grundy,
    projective_line, residual_graph, sigma,
)


def compose(a, b):
    return tuple(a[b[i]] for i in range(len(a)))


import math
def perm_order(p):
    seen = [False] * len(p); order = 1
    for s in range(len(p)):
        if seen[s]:
            continue
        v, ln = s, 0
        while not seen[v]:
            seen[v] = True; v = p[v]; ln += 1
        order = math.lcm(order, ln)
    return order


def pair_orders(gens):
    return tuple(sorted(perm_order(compose(a, b))
                        for a, b in itertools.combinations(gens, 2)))


PATTERNS = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
S4_PROFILE = ((1, 1), (2, 9), (3, 8), (4, 6))


def order_profile(group):
    from collections import Counter
    return tuple(sorted(Counter(perm_order(g) for g in group).items()))


def to_graph(adj):
    G = nx.Graph()
    G.add_nodes_from(range(len(adj)))
    for u in range(len(adj)):
        m = adj[u]
        while m:
            b = m & -m; v = b.bit_length() - 1
            if v > u:
                G.add_edge(u, v)
            m ^= b
    return G


def has_pairing(adj, cap=2_000_000):
    """True if R has a fpf involutory automorphism with no {v,tau v} edge."""
    n = len(adj)
    if n == 0:
        return True                      # empty position: 2nd player wins
    if n % 2 == 1:
        return False                     # fpf involution needs even |V|
    G = to_graph(adj)
    def is_edge(u, v):
        return (adj[u] >> v) & 1
    it = nx.algorithms.isomorphism.GraphMatcher(G, G).isomorphisms_iter()
    for k, m in enumerate(it):
        if k >= cap:
            return None                  # undecided (aut group too big to scan)
        ok = True
        for v in range(n):
            w = m[v]
            if w == v or m[w] != v or is_edge(v, w):
                ok = False
                break
        if ok:
            return True
    return False


def probe(q, per_class_cap=None):
    params = projective_line(q)
    conic = tuple(conic_point(t, q) for t in params)
    points = centres(q)
    perms = {p: tuple(params.index(sigma(p, t, q)) for t in params) for p in points}
    perm_to_pt = {v: k for k, v in perms.items()}
    group = None
    for triple in itertools.combinations(points, 3):
        gens = tuple(perms[p] for p in triple)
        if pair_orders(gens) not in PATTERNS:
            continue
        g = generated_group(gens)
        if len(g) == 24 and order_profile(g) == S4_PROFILE:
            group = g; break
    ident = tuple(range(q + 1))
    invols = tuple(g for g in group if g != ident and compose(g, g) == ident)
    subgroup_pts = {perm_to_pt[g] for g in invols}
    reps = {}
    for tri in itertools.combinations(invols, 3):
        if len(generated_group(tri)) != 24:
            continue
        reps.setdefault(PATTERNS[pair_orders(tri)], tuple(perm_to_pt[x] for x in tri))

    print(f"q={q}")
    for label in "ABCD":
        selected = reps[label]
        pair_yes = pair_no = pair_undec = ptotal = 0
        for cand in points:
            if cand in selected:
                continue
            if any(determinant((a, b, cand), q) == 0
                   for a, b in itertools.combinations(selected, 2)):
                continue
            if cand in subgroup_pts:
                continue
            dead, adj, _ = residual_graph((*selected, cand), params, conic, q)
            if grundy(adj, (1 << len(adj)) - 1) != 0:
                continue
            ptotal += 1
            if per_class_cap and ptotal > per_class_cap:
                ptotal -= 1
                break
            res = has_pairing(adj)
            if res is True:
                pair_yes += 1
            elif res is False:
                pair_no += 1
            else:
                pair_undec += 1
        print(f"  {label}: P-children={ptotal}  pairing:yes={pair_yes} "
              f"no={pair_no} undecided={pair_undec}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="+")
    ap.add_argument("--cap", type=int, default=None, help="max P-children per class")
    args = ap.parse_args()
    for q in args.q:
        probe(q, args.cap)


if __name__ == "__main__":
    main()
