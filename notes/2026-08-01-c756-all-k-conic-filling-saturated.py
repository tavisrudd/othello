#!/usr/bin/env python3
"""C756 — exhaustive search of the two saturated families of Lemma 3.

A conic-external arc is a set of squarefree binary quadratics f_i over F_q, no three in
a pencil, with chi(Res(f_i,f_j)) = -1 for all i<j.  Split forms are the external points
of the conic (unordered pairs of P^1(F_q)); irreducible forms are the internal points
(conjugate pairs).  Lemma 3 says a conic-filling arc either satisfies C(k-1,2) >= q or is
saturated, and saturation forces one of:

  saturated-external : k = (q+1)/2 split forms, i.e. a PERFECT MATCHING of P^1(F_q)
                       with all pairwise resultants non-residues;
  saturated-internal : k = (q+3)/2 conjugate pairs with the analogous condition.

Both searches fix one representative, legitimate because PGL(2,q) is transitive on
external points and on internal points.  Prime q only (both saturated families are
searched over the prime fields where the counting bound leaves them open).

Run:  python3 notes/2026-08-01-c756-all-k-conic-filling-saturated.py 5 7 11 13 17 19 23
"""
import json
import sys
from itertools import combinations

INF = "inf"


def squares(q):
    return set((x * x) % q for x in range(1, q))


def external_family(q):
    """Perfect matchings of P^1(F_q) with pairwise non-residue resultants; returns
    (number satisfying the character condition, number of those in general position)."""
    sq = squares(q)
    chi = lambda x: 0 if x % q == 0 else (1 if x % q in sq else -1)
    pts = list(range(q)) + [q]  # q stands for the point at infinity

    def res(e, f):
        p = 1
        for a in e:
            for b in f:
                if a == q and b == q:
                    return 0
                if a == q or b == q:
                    continue  # bracket [(1:0),(b:1)] = 1
                p = (p * (a - b)) % q
                if p == 0:
                    return 0
        return p

    def vec(e):
        a, b = e
        if a == q:
            return (0, 1, (-b) % q)
        if b == q:
            return (0, 1, (-a) % q)
        return (1, (-(a + b)) % q, (a * b) % q)

    edges = list(combinations(pts, 2))
    ne = len(edges)
    adj = [0] * ne
    for i in range(ne):
        for j in range(i + 1, ne):
            if set(edges[i]) & set(edges[j]):
                continue
            if chi(res(edges[i], edges[j])) == -1:
                adj[i] |= 1 << j
                adj[j] |= 1 << i
    target = (q + 1) // 2
    sols = []

    def dfs(chosen, cand):
        if len(chosen) == target:
            sols.append([edges[i] for i in chosen])
            return
        c = cand
        while c:
            v = (c & -c).bit_length() - 1
            c &= c - 1
            if len(chosen) + 1 + bin(c & adj[v]).count("1") < target:
                continue
            dfs(chosen + [v], c & adj[v])

    dfs([edges.index((0, q))], adj[edges.index((0, q))])
    arcs = [s for s in sols if in_general_position([vec(e) for e in s], q)]
    return len(sols), len(arcs), [[list(e) for e in s] for s in arcs]


def internal_family(q):
    """Conjugate-pair systems of size (q+3)/2 with pairwise non-residue resultants."""
    sq = squares(q)
    eps = next(e for e in range(2, q) if e not in sq)
    mul = lambda u, v: ((u[0] * v[0] + eps * u[1] * v[1]) % q, (u[0] * v[1] + u[1] * v[0]) % q)
    sub = lambda u, v: ((u[0] - v[0]) % q, (u[1] - v[1]) % q)
    conj = lambda u: (u[0], (-u[1]) % q)
    nrm = lambda u: (u[0] * u[0] - eps * u[1] * u[1]) % q
    chi = lambda x: 0 if x % q == 0 else (1 if x % q in sq else -1)
    pairs, seen = [], set()
    for b in range(1, q):
        for a in range(q):
            z = (a, b)
            if z in seen:
                continue
            seen.add(z)
            seen.add(conj(z))
            pairs.append(z)
    n = len(pairs)
    adj = [0] * n
    for i in range(n):
        for j in range(i + 1, n):
            d = mul(sub(pairs[i], pairs[j]), sub(pairs[i], conj(pairs[j])))
            if chi(nrm(d)) == -1:
                adj[i] |= 1 << j
                adj[j] |= 1 << i
    vecs = [(1, (-(2 * z[0])) % q, nrm(z)) for z in pairs]
    target = (q + 3) // 2
    sols = []

    def dfs(chosen, cand):
        if len(chosen) == target:
            sols.append(list(chosen))
            return
        c = cand
        while c:
            v = (c & -c).bit_length() - 1
            c &= c - 1
            if len(chosen) + 1 + bin(c & adj[v]).count("1") < target:
                continue
            if not all(det3(vecs[a], vecs[b], vecs[v], q) for a, b in combinations(chosen, 2)):
                continue
            dfs(chosen + [v], c & adj[v])

    dfs([0], adj[0])
    return len(sols), [[list(pairs[i]) for i in s] for s in sols]


def det3(u, v, w, q):
    return (
        u[0] * (v[1] * w[2] - v[2] * w[1])
        - u[1] * (v[0] * w[2] - v[2] * w[0])
        + u[2] * (v[0] * w[1] - v[1] * w[0])
    ) % q


def in_general_position(vs, q):
    return all(det3(u, v, w, q) for u, v, w in combinations(vs, 3))


def main():
    qs = [int(a) for a in sys.argv[1:]] or [5, 7, 11, 13, 17, 19, 23]
    rows = []
    for q in qs:
        n_char, n_arc, arcs = external_family(q)
        n_int, iarcs = internal_family(q)
        rows.append(
            {
                "q": q,
                "k_external": (q + 1) // 2,
                "saturated_external_character_only": n_char,
                "saturated_external_arcs": n_arc,
                "saturated_external_witness": sorted(json.dumps(a) for a in arcs)[:1],
                "k_internal": (q + 3) // 2,
                "saturated_internal_arcs": n_int,
                "saturated_internal_witness": sorted(json.dumps(a) for a in iarcs)[:1],
            }
        )
    print(json.dumps({"task": "C756", "family": "saturated", "rows": rows}, indent=1, sort_keys=True))


if __name__ == "__main__":
    main()
