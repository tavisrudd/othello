#!/usr/bin/env python3
"""Definitive Fricke-level test: do EXACT normalized trace coordinates of the
4-tuple (sigma_1, sigma_2, sigma_3, sigma_y) determine the conic-only Grundy value?

For an off-conic centre x=[a:b:c], the involution sigma_x lifts to A_x=[[b,-a],[c,-b]]
in GL(2,q), det A_x = ac - b^2 != 0.  The value G(R) is invariant under PGL-conjugation
of the whole config AND under A_i -> lambda_i A_i (projective).  The scale- and
conjugation-invariant coordinates are therefore
    pair_ij  = tr(A_i A_j)^2 / (det A_i det A_j)
    triple   = tr(A_i A_j A_k)^2 / (det A_i det A_j det A_k)
    quad     = tr(A_1 A_2 A_3 A_y)^2 / prod det
These are the Fricke coordinates (squared to kill the SL2 sign lift).  If the vector
of these EXACT field elements determines G, the equidistribution route (Weil/Lang-Weil
over the y-plane) is alive; if ambiguity persists and grows, it is dead.
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
    seen = [False] * len(p); o = 1
    for s in range(len(p)):
        if seen[s]:
            continue
        v, ln = s, 0
        while not seen[v]:
            seen[v] = True; v = p[v]; ln += 1
        o = math.lcm(o, ln)
    return o


def pair_orders(gens):
    return tuple(sorted(perm_order(compose(a, b))
                        for a, b in itertools.combinations(gens, 2)))


PATTERNS = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
S4_PROFILE = ((1, 1), (2, 9), (3, 8), (4, 6))


def order_profile(group):
    from collections import Counter
    return tuple(sorted(Counter(perm_order(g) for g in group).items()))


def mat(pt, q):
    a, b, c = pt
    return (b % q, (-a) % q, c % q, (-b) % q)   # [[b,-a],[c,-b]]


def mmul(m, n, q):
    a, b, c, d = m; e, f, g, h = n
    return ((a*e + b*g) % q, (a*f + b*h) % q, (c*e + d*g) % q, (c*f + d*h) % q)


def tr(m):
    return (m[0] + m[3])


def det(m, q):
    return (m[0]*m[3] - m[1]*m[2]) % q


def norm_tr(mats, q):
    """tr(prod)^2 / prod(det), a scale+conjugation invariant field element."""
    p = mats[0]
    for m in mats[1:]:
        p = mmul(p, m, q)
    dprod = 1
    for m in mats:
        dprod = dprod * det(m, q) % q
    t = tr(p) % q
    return t * t % q * pow(dprod, q - 2, q) % q


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
    for triv in itertools.combinations(invols, 3):
        if len(generated_group(triv)) != 24:
            continue
        reps.setdefault(PATTERNS[pair_orders(triv)], tuple(perm_to_pt[x] for x in triv))

    print(f"q={q}")
    for label in "ABCD":
        selected = reps[label]
        As = [mat(s, q) for s in selected]
        sig = defaultdict(set)
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
            Ay = mat(cand, q)
            pair = tuple(sorted(norm_tr([A, Ay], q) for A in As))
            trip = tuple(sorted(norm_tr([As[i], As[j], Ay], q)
                                for i, j in itertools.combinations(range(3), 2)))
            quad = norm_tr([As[0], As[1], As[2], Ay], q)
            sig[(pair, trip, quad)].add(val)
        ambig = sum(len(v) > 1 for v in sig.values())
        print(f"  {label}: escape={escape}  fricke[{len(sig)} sigs, ambig={ambig}]")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="+")
    args = ap.parse_args()
    for q in args.q:
        probe(q)


if __name__ == "__main__":
    main()
