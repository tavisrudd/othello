#!/usr/bin/env python3
"""Does a Weil-amenable refined signature determine the escape child's Grundy value?

The equidistribution route to a positive-density P bound needs a BOUNDED, algebraic
invariant of the fourth centre y that determines 𝒢(R_{T∪{y}}), so that its
distribution over y is controlled by character sums.  s4_escape_probe already shows
the raw 3 pairwise ORDERS r_{iy}=|σ_iσ_y| do NOT determine 𝒢 (ambiguity grows).

This tests three progressively richer signatures per escape child:
  raw     : sorted (r_{iy})                                  [what s4_escape_probe uses]
  refined : sorted (r_{iy}, fix_{iy})   fix = #fixed pts of σ_iσ_y on P^1  (split type)
  full6   : refined signature PLUS the three within-triple invariants (r_{ij}, fix_{ij})
Reports, per S4 class, how many signature values map to >1 distinct Grundy value
(ambig).  ambig=0 for a signature ⇒ that bounded invariant determines the value.
"""
import argparse
import itertools
import math
from collections import defaultdict

from three_centre_probe import (
    centres, conic_point, determinant, generated_group, grundy,
    projective_line, residual_graph, sigma,
)


def compose(a, b):
    return tuple(a[b[i]] for i in range(len(a)))


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


def n_fixed(p):
    return sum(1 for i in range(len(p)) if p[i] == i)


def pair_orders(gens):
    return tuple(sorted(perm_order(compose(a, b))
                        for a, b in itertools.combinations(gens, 2)))


PATTERNS = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
S4_PROFILE = ((1, 1), (2, 9), (3, 8), (4, 6))


def order_profile(group):
    from collections import Counter
    return tuple(sorted(Counter(perm_order(g) for g in group).items()))


def probe(q):
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
        sp = [perms[s] for s in selected]
        within = tuple(sorted((perm_order(compose(a, b)), n_fixed(compose(a, b)))
                              for a, b in itertools.combinations(sp, 2)))
        sig_raw = defaultdict(set)
        sig_ref = defaultdict(set)
        sig_full = defaultdict(set)
        sig_tri = defaultdict(set)
        escape = 0
        for cand in points:
            if cand in selected:
                continue
            if any(determinant((a, b, cand), q) == 0
                   for a, b in itertools.combinations(selected, 2)):
                continue
            if cand in subgroup_pts:
                continue
            escape += 1
            _, adj, _ = residual_graph((*selected, cand), params, conic, q)
            val = grundy(adj, (1 << len(adj)) - 1)
            pc = perms[cand]
            raw = tuple(sorted(perm_order(compose(pc, s)) for s in sp))
            ref = tuple(sorted((perm_order(compose(pc, s)), n_fixed(compose(pc, s)))
                               for s in sp))
            # Fricke triple coordinates: order+split-type of sigma_i sigma_j sigma_y
            tri = tuple(sorted(
                (perm_order(compose(compose(a, b), pc)),
                 n_fixed(compose(compose(a, b), pc)))
                for a, b in itertools.combinations(sp, 2)))
            sig_raw[raw].add(val)
            sig_ref[ref].add(val)
            sig_full[(ref, within)].add(val)
            sig_tri[(ref, within, tri)].add(val)
        a_raw = sum(len(v) > 1 for v in sig_raw.values())
        a_ref = sum(len(v) > 1 for v in sig_ref.values())
        a_full = sum(len(v) > 1 for v in sig_full.values())
        a_tri = sum(len(v) > 1 for v in sig_tri.values())
        print(f"  {label}: escape={escape}  "
              f"raw[{len(sig_raw)}, ambig={a_raw}]  "
              f"refined[{len(sig_ref)}, ambig={a_ref}]  "
              f"full6[{len(sig_full)}, ambig={a_full}]  "
              f"+triple[{len(sig_tri)}, ambig={a_tri}]")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="+")
    args = ap.parse_args()
    for q in args.q:
        probe(q)


if __name__ == "__main__":
    main()
