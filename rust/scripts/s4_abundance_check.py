#!/usr/bin/env python3
"""Independent stress-test of the C84 S4-rooted escape abundance claim.

Verifies TWO things the current s4_escape_probe.py does not:
  1. the order-24 subgroup it locks onto is genuinely S4 (element-order profile
     {1:1, 2:9, 3:8, 4:6}), NOT the dihedral D24 ({1:1,2:13,3:2,4:2,6:2,12:4}),
     which also has order 24 in PGL(2,q) when 12 | q^2-1.  (Codex correction #1.)
  2. the per-class escaping-fourth-centre P-fraction (conic-only Grundy 0) and its
     minimum over the four S4 classes, extended past q=11, to see whether the
     min-fraction stays bounded away from 0.
"""
import argparse
import itertools
import math
from collections import Counter, defaultdict

from three_centre_probe import (
    centres, conic_point, determinant, generated_group, grundy,
    projective_line, residual_graph, sigma,
)


def compose(a, b):
    return tuple(a[b[i]] for i in range(len(a)))


def perm_order(p):
    seen = [False] * len(p)
    order = 1
    for s in range(len(p)):
        if seen[s]:
            continue
        v, ln = s, 0
        while not seen[v]:
            seen[v] = True
            v = p[v]
            ln += 1
        order = math.lcm(order, ln)
    return order


def order_profile(group):
    return tuple(sorted(Counter(perm_order(g) for g in group).items()))


def pair_orders(gens):
    return tuple(sorted(perm_order(compose(a, b))
                        for a, b in itertools.combinations(gens, 2)))


S4_PROFILE = ((1, 1), (2, 9), (3, 8), (4, 6))
PATTERNS = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}


def find_true_s4(points, perms):
    """Return the first order-24 subgroup whose element-order profile is S4's."""
    for triple in itertools.combinations(points, 3):
        gens = tuple(perms[p] for p in triple)
        if pair_orders(gens) not in PATTERNS:
            continue
        group = generated_group(gens)
        if len(group) == 24 and order_profile(group) == S4_PROFILE:
            return group
    raise RuntimeError("no genuine S4 found")


def probe(q):
    params = projective_line(q)
    conic = tuple(conic_point(t, q) for t in params)
    points = centres(q)
    perms = {p: tuple(params.index(sigma(p, t, q)) for t in params) for p in points}
    perm_to_pt = {v: k for k, v in perms.items()}
    group = find_true_s4(points, perms)
    ident = tuple(range(q + 1))
    invols = tuple(g for g in group if g != ident and compose(g, g) == ident)
    subgroup_pts = {perm_to_pt[g] for g in invols}

    reps = {}
    for tri in itertools.combinations(invols, 3):
        if len(generated_group(tri)) != 24:
            continue
        reps.setdefault(PATTERNS[pair_orders(tri)],
                        tuple(perm_to_pt[x] for x in tri))

    fracs = []
    rows = []
    for label in "ABCD":
        selected = reps[label]
        internal = escape = pzero = 0
        sig_vals = defaultdict(set)
        for cand in points:
            if cand in selected:
                continue
            if any(determinant((a, b, cand), q) == 0
                   for a, b in itertools.combinations(selected, 2)):
                continue
            if cand in subgroup_pts:
                internal += 1
                continue
            escape += 1
            dead, adj, _ = residual_graph((*selected, cand), params, conic, q)
            val = grundy(adj, (1 << len(adj)) - 1)
            if val == 0:
                pzero += 1
            sig = tuple(sorted(perm_order(compose(perms[cand], perms[p]))
                               for p in selected))
            sig_vals[sig].add(val)
        frac = pzero / escape if escape else float("nan")
        fracs.append(frac)
        ambig = sum(len(v) > 1 for v in sig_vals.values())
        rows.append(f"    {label}: internal={internal} escape={escape} "
                    f"P={pzero} frac={frac:.3f} sigs={len(sig_vals)} ambig={ambig}")
    print(f"q={q}  S4 confirmed (profile {order_profile(group)})")
    print("\n".join(rows))
    print(f"    -> min P-fraction over classes = {min(fracs):.3f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="+")
    args = ap.parse_args()
    for q in args.q:
        probe(q)


if __name__ == "__main__":
    main()
