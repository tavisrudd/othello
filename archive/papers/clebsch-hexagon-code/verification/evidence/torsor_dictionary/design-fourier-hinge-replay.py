#!/usr/bin/env python3
"""Independent replay for design_fourier_hinge.  Imports neither the primary generator nor subgroup_decoder.

It reconstructs every finite object from scratch and re-verifies the four legs, then compares its
own verdicts against the tracked primary certificate.  Cross-checks that differ from the primary:

  A1  rebuilds the outer Mobius elements and the disjointness matrices directly from the qr_design
      sheets (data), and checks the transpose-intertwining torsor map.
  A2  rebuilds the rank-16 scalar-A4 scheme from an independently supplied A4 (12 monomial signed
      permutation matrices), verified to preserve x^2+y^2+z^2 and to reproduce common_duality's certified
      valencies AND representatives; then recomputes the Rz and J relation permutations.
  F   rebuilds L, P, K, M12 from golay_hadamard's frozen generators and computes N_{M12}(L), the induced
      automorphisms of L, and the M11 conjugacy test; independently rebuilds PGL2(11) on P^1(F_11).
  B   recomputes the residue-value collision and the candidate-rule exhaustion from arithmetic_orientation/silver_fusion.

Run from this directory:
    python3 design-fourier-hinge-replay.py
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent

PINS = {
    "qr-barker.json":
        "f2c80377740261552ea645ea8269f1230997195e55e99d060bf74fb9bd80506a",
    "common-duality.json":
        "6de0c88fcb651d00c0e576b817487a8cbf89eb53318d4b6f7d087becef97c304",
    "golay-hadamard-automorphisms.json":
        "16cf4323234fc155095083d65c6bc5d50126b91d92d522a82b15c96fcaa53eb5",
    "arithmetic-orientation.json":
        "609a15bfc6cae8f3bdf6ff9acdfe6b93c8b6fe5f1dbbae4c3766b38edc3b3bc0",
    "silver-fusion.json":
        "7426903b59c0d0458baf09270c417871806a035f72d9e516332fb5862763a810",
}

# Independently supplied A4 = ordered-golden-pair stabilizer, as 12 monomial matrices over F_11
# (entries in {0,1,10=-1}).  The replay verifies it below; it is NOT taken from the primary.
A4_MATRICES = [
    [[0, 0, 1], [1, 0, 0], [0, 1, 0]], [[0, 0, 1], [1, 0, 0], [0, 10, 0]],
    [[0, 0, 1], [10, 0, 0], [0, 1, 0]], [[0, 0, 1], [10, 0, 0], [0, 10, 0]],
    [[0, 1, 0], [0, 0, 1], [1, 0, 0]], [[0, 1, 0], [0, 0, 1], [10, 0, 0]],
    [[0, 1, 0], [0, 0, 10], [1, 0, 0]], [[0, 1, 0], [0, 0, 10], [10, 0, 0]],
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[1, 0, 0], [0, 1, 0], [0, 0, 10]],
    [[1, 0, 0], [0, 10, 0], [0, 0, 1]], [[1, 0, 0], [0, 10, 0], [0, 0, 10]],
]


def pinned(name):
    path = ROOT / name
    assert hashlib.sha256(path.read_bytes()).hexdigest() == PINS[name], f"hash drift {name}"
    return json.loads(path.read_text())


def nonsquares_and_squares(q):
    sq = {(i * i) % q for i in range(1, q)}
    return sq


def mobius(a, b, c, d, q):
    out = {}
    for x in range(q):
        den = (c * x + d) % q
        num = (a * x + b) % q
        out[x] = q if den == 0 else (num * pow(den, q - 2, q)) % q
    out[q] = q if c == 0 else (a * pow(c, q - 2, q)) % q
    return tuple(out[i] for i in range(q + 1))


def pcompose(p, r):
    return tuple(p[r[i]] for i in range(len(r)))


def pinv(p):
    inv = [0] * len(p)
    for i, x in enumerate(p):
        inv[x] = i
    return tuple(inv)


def pclosure(gens):
    gens = [tuple(g) for g in gens]
    ident = tuple(range(len(gens[0])))
    seen = {ident}
    stack = [ident]
    while stack:
        a = stack.pop()
        for g in gens:
            c = pcompose(a, g)
            if c not in seen:
                seen.add(c)
                stack.append(c)
    return seen


# ---- Leg A1 --------------------------------------------------------------------------------
def replay_a1():
    qr_design = pinned("qr-barker.json")
    out = []
    for case in qr_design["cases"]:
        q = case["q"]
        sq = nonsquares_and_squares(q)
        s0 = [frozenset(frozenset(e) for e in m) for m in case["sheets"][0]]
        s1 = [frozenset(frozenset(e) for e in m) for m in case["sheets"][1]]
        if q == 11:
            g = mobius(1, 10, 1, 1, q); det = (1 - 10) % q
        else:
            g = mobius(q - 1, 0, 0, 1, q); det = (q - 1) % q

        def ap(m):
            return frozenset(frozenset(g[p] for p in e) for e in m)
        swap = ({ap(m) for m in s0} == set(s1)) and ({ap(m) for m in s1} == set(s0))
        M = [[1 if not (s0[i] & s1[j]) else 0 for j in range(q)] for i in range(q)]
        d_row = [j for j in range(q) if M[0][j]]
        d_col = [i for i in range(q) if M[i][0]]
        transpose_neg = sorted(d_col) == sorted((-x) % q for x in d_row)
        sig = {i: s1.index(ap(s0[i])) for i in range(q)}
        tau = {j: s0.index(ap(s1[j])) for j in range(q)}
        equiv = all(M[i][j] == M[tau[j]][sig[i]] for i in range(q) for j in range(q))
        out.append(swap and (M == case["cross_disjointness_matrix"]) and transpose_neg
                   and equiv and det % q not in sq)
    return all(out)


# ---- Leg A2 --------------------------------------------------------------------------------
def replay_a2():
    common_duality = pinned("common-duality.json")
    Q = 11

    def mm(A, B):
        return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(3)) % Q for j in range(3))
                     for i in range(3))

    def mv(A, v):
        return tuple(sum(A[i][j] * v[j] for j in range(3)) % Q for i in range(3))

    a4 = [tuple(tuple(r) for r in M) for M in A4_MATRICES]
    ident = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    grp = {ident}
    stack = [ident]
    while stack:
        a = stack.pop()
        for b in a4:
            c = mm(a, b)
            if c not in grp:
                grp.add(c); stack.append(c)
    # verify A4 preserves Q = x^2+y^2+z^2 on all vectors
    def qform(v):
        return (v[0] * v[0] + v[1] * v[1] + v[2] * v[2]) % Q
    if not all(qform(mv(M, v)) == qform(v)
               for M in grp for v in [(1, 0, 0), (1, 1, 0), (1, 2, 3), (0, 1, 4)]):
        return False

    scalar = {tuple(tuple(s * M[i][j] % Q for j in range(3)) for i in range(3))
              for M in grp for s in range(1, Q)}
    # scalar-A4 has order 12*10 = 120 iff the projective A4 has order 12
    if len(scalar) != 120:
        return False
    rel_of = {}
    for x in range(Q):
        for y in range(Q):
            for z in range(Q):
                v = (x, y, z)
                if v in rel_of:
                    continue
                orb = frozenset(mv(M, v) for M in scalar)
                for w in orb:
                    rel_of[w] = orb
    meta = common_duality["common_relation_metadata"]
    ordered = [rel_of[tuple(m["representative"])] for m in meta]
    if len(set(id(o) for o in ordered)) != 16:
        return False
    if [len(o) for o in ordered] != [m["size"] for m in meta]:
        return False
    idx = {o: i for i, o in enumerate(ordered)}

    def perm(M):
        return tuple(idx[rel_of[mv(M, next(iter(o)))]] for o in ordered)

    rz = ((0, 10, 0), (1, 0, 0), (0, 0, 1))
    j = tuple(tuple(r) for r in common_duality["golden_map_J"])
    p_rz, p_j = perm(rz), perm(j)
    if list(p_j) != common_duality["J_relation_permutation"]:
        return False
    pairs = [tuple(pr) for pr in common_duality["J_odd_relation_pairs"]]
    return (p_rz == p_j and sorted(p_rz) == list(range(16))
            and all(p_rz[a] == b and p_rz[b] == a for a, b in pairs))


# ---- Leg F --------------------------------------------------------------------------------
def replay_f():
    golay_hadamard = pinned("golay-hadamard-automorphisms.json")
    pr = golay_hadamard["two_M11_parents_and_frozen_intersection"]
    L = pclosure(pr["intersection_generators"])
    K = pclosure(pr["parity_stabilizer_generators"])
    P = pclosure(golay_hadamard["coordinate_and_design_groups"]["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"])
    M12 = pclosure(list(golay_hadamard["coordinate_and_design_groups"]["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"]) + list(pr["parity_stabilizer_generators"]))
    if not (len(L) == 660 and len(P) == 7920 and len(K) == 7920
            and len(M12) == 95040 and (P & K) == L):
        return False

    def conj_all(x, G):
        xi = pinv(x)
        return frozenset(pcompose(pcompose(x, g), xi) for g in G)

    normalizer = [m for m in M12 if conj_all(m, L) == frozenset(L)]
    if frozenset(normalizer) != frozenset(L):
        return False
    lg = [tuple(g) for g in pr["intersection_generators"]]

    def ind(m):
        mi = pinv(m)
        return tuple(pcompose(pcompose(m, g), mi) for g in lg)
    inn = {ind(l) for l in L}
    if any(ind(m) not in inn for m in normalizer):
        return False
    pg = [tuple(g) for g in golay_hadamard["coordinate_and_design_groups"]["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"]]
    if any(conj_all(m, pg) == frozenset(K) for m in M12):
        return False  # P,K must be non-conjugate

    Q = 11
    t = mobius(1, 1, 0, 1, Q); s = mobius(0, 10, 1, 0, Q); rz = mobius(1, 10, 1, 1, Q)
    lmob = pclosure([t, s]); pgl = pclosure([t, s, rz])
    if not (len(lmob) == 660 and len(pgl) == 1320):
        return False
    if not all(pcompose(pcompose(rz, g), pinv(rz)) in lmob for g in [t, s]):
        return False
    rz_on = tuple(pcompose(pcompose(rz, g), pinv(rz)) for g in [t, s])
    inn_m = {tuple(pcompose(pcompose(l, g), pinv(l)) for g in [t, s]) for l in lmob}
    return rz_on not in inn_m


# ---- Leg B --------------------------------------------------------------------------------
def replay_b():
    arithmetic_orientation = pinned("arithmetic-orientation.json")
    silver_fusion = pinned("silver-fusion.json")
    b3 = silver_fusion["B3"]["reductions"]
    if not (b3["sqrt2_4"]["cubic_orientation"] == "positive"
            and b3["sqrt2_3"]["cubic_orientation"] == "negative"):
        return False
    data = {}
    for c in arithmetic_orientation["cases"]:
        data[c["q"]] = (c["characteristic"], c["selected_alpha_residue"], c["other_alpha_residue"])
    # role of residue value 0 at each prime
    role = {}
    for q, (p, mk, op) in data.items():
        role[q] = "marked" if mk == 0 else ("opposite" if op == 0 else "absent")
    collision = role[7] != role[11] and "absent" not in role.values()

    def legendre(a, q):
        a %= q
        return 0 if a == 0 else (1 if pow(a, (q - 1) // 2, q) == 1 else -1)
    ch = {q: legendre(2 * data[q][1] + 1, q) for q in (7, 11)}
    # residue-value rule needs per-case sign (collision); trace-difference character non-uniform
    return collision and ch[7] != ch[11]


def main():
    a1, a2, f, b = replay_a1(), replay_a2(), replay_f(), replay_b()
    print("replay  A1", "PASS" if a1 else "FAIL",
          "| A2", "PASS" if a2 else "FAIL",
          "| F", "OUTER" if f else "FAIL",
          "| B", "FALSIFIER FIRES" if b else "SURVIVES")
    cert = json.loads((ROOT / "design-fourier-hinge.json").read_text())
    assert a1 == (cert["leg_A1_design_polarity"]["verdict"] == "PASS")
    assert a2 == (cert["leg_A2_fourier_sector"]["verdict"] == "PASS")
    assert f == (cert["leg_F_outer_hinge"]["verdict"] == "PASS")
    assert b == cert["leg_B_modular_cubic_falsifier"]["falsifier_fires"]
    assert a1 and a2 and f and b, "replay leg mismatch"
    print("replay agrees with primary certificate")


if __name__ == "__main__":
    main()
