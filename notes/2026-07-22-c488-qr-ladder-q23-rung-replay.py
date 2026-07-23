#!/usr/bin/env python3
"""Independent replay of the C488 q=23 QR-ladder rung certificate.

Re-derives every load-bearing fact WITHOUT importing the primary generator: the binary Golay
[23,12,7] code flag, the PSL_2(23) degree-23 realizability obstruction (no index-23 subgroup), and
the group-side carrier gates for the 11-dimensional extended-Golay module (submodule lattice,
commutant, duality, D8 norm-rank projectivity, and the local H^1(D8, S(x)S) fusion cut).

This file uses a deliberately different code path from the primary script (dense tuple vectors over
F_2 rather than bit-integer codewords, a different Sylow-2 element choice, and independently coded
linear algebra) so that agreement is not an artefact of shared implementation.  It reads only the
committed JSON certificate to compare the reproduced numbers; it imports no project code.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERT = ROOT / "notes" / "2026-07-22-c488-qr-ladder-q23-rung.json"
Q = 23
DEG = Q + 1


# --- dense F_2 linear algebra on tuple vectors -----------------------------

def rref(rows):
    a = [list(r) for r in rows if any(r)]
    width = len(a[0]) if a else 0
    pivots = []
    r = 0
    for col in range(width):
        pr = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pr is None:
            continue
        a[r], a[pr] = a[pr], a[r]
        for i in range(len(a)):
            if i != r and a[i][col]:
                a[i] = [(x ^ y) for x, y in zip(a[i], a[r])]
        pivots.append(col)
        r += 1
    return [tuple(row) for row in a[:r]], pivots


def rank(rows, width):
    return len(rref([r for r in rows] or [(0,) * width])[0]) if rows else 0


def matrank(rows):
    return len(rref(rows)[0])


def nullspace(rows, width):
    reduced, pivots = rref(rows if rows else [(0,) * width])
    free = [j for j in range(width) if j not in pivots]
    out = []
    for f in free:
        v = [0] * width
        v[f] = 1
        for row, col in zip(reduced, pivots):
            v[col] = row[f]
        out.append(tuple(v))
    return out


def mmul(a, b):
    n = len(a)
    cols = list(zip(*b))
    return tuple(tuple(sum(a[i][k] * col[k] for k in range(n)) % 2 for col in cols) for i in range(n))


def mvec(a, v):
    return tuple(sum(row[k] * v[k] for k in range(len(v))) % 2 for row in a)


def minv(a):
    n = len(a)
    aug = [list(a[i]) + [int(i == j) for j in range(n)] for i in range(n)]
    r = 0
    for col in range(n):
        pr = next(i for i in range(r, n) if aug[i][col])
        aug[r], aug[pr] = aug[pr], aug[r]
        for i in range(n):
            if i != r and aug[i][col]:
                aug[i] = [(x ^ y) for x, y in zip(aug[i], aug[r])]
        r += 1
    return tuple(tuple(aug[i][n:]) for i in range(n))


# --- Part A: binary Golay [23,12,7] flag over F_2 --------------------------

def code_flag():
    residues = {(x * x) % Q for x in range(1, Q)}
    indicator = tuple(1 if i in residues else 0 for i in range(Q))
    shifts = [tuple(indicator[(i - s) % Q] for i in range(Q)) for s in range(Q)]
    d_reduced, _ = rref(shifts)
    diffs = [tuple(shifts[0][i] ^ sh[i] for i in range(Q)) for sh in shifts[1:]]
    s_reduced, _ = rref(diffs)
    dim_d, dim_s = len(d_reduced), len(s_reduced)
    ones = (1,) * Q
    s_subset_dperp = all(sum(x & y for x, y in zip(b, c)) % 2 == 0 for b in d_reduced for c in s_reduced)
    one_in_s = matrank([*s_reduced, ones]) == dim_s
    d_is_one_plus_s = matrank([*s_reduced, ones]) == dim_d and not one_in_s

    def min_weight(reduced):
        best = Q + 1
        for coeffs in itertools.product(range(2), repeat=len(reduced)):
            if not any(coeffs):
                continue
            w = [0] * Q
            for c, row in zip(coeffs, reduced):
                if c:
                    w = [a ^ b for a, b in zip(w, row)]
            best = min(best, sum(w))
        return best

    return {"dim_S": dim_s, "dim_D": dim_d, "min_wt_D": min_weight(d_reduced),
            "S_subset_Dperp": s_subset_dperp, "S_eq_Dperp": s_subset_dperp and (Q - dim_d) == dim_s,
            "D_eq_one_plus_S": d_is_one_plus_s}


# --- PSL_2(23) on P^1(F_23) ------------------------------------------------

def pperm(g):
    a, b, c, d = g
    out = []
    for x in range(Q + 1):
        if x == Q:
            out.append(Q if c == 0 else a * pow(c, Q - 2, Q) % Q)
        else:
            den = (c * x + d) % Q
            out.append(Q if den == 0 else (a * x + b) * pow(den, Q - 2, Q) % Q)
    return tuple(out)


def comp(g, h):
    return tuple(h[g[i]] for i in range(len(g)))


def enumerate_group(gens):
    ident = tuple(range(DEG))
    seen = {ident}
    dq = deque([ident])
    while dq:
        g = dq.popleft()
        for s in gens:
            h = comp(g, s)
            if h not in seen:
                seen.add(h)
                dq.append(h)
    return sorted(seen)


def order_of(g, ident):
    p, o = g, 1
    while p != ident:
        p = comp(p, g)
        o += 1
    return o


def closure(elems, cap=None):
    base = set(elems)
    frontier = list(base)
    while frontier:
        g = frontier.pop()
        for h in list(base):
            for pr in (comp(g, h), comp(h, g)):
                if pr not in base:
                    base.add(pr)
                    frontier.append(pr)
                    if cap is not None and len(base) > cap:
                        return None
    return frozenset(base)


# --- extended-Golay 11-dim module S = C/<1> --------------------------------

def build_module_and_group():
    gens_perm = [pperm((1, 1, 0, 1)), pperm((0, Q - 1, 1, 0))]
    ident = tuple(range(DEG))
    group = enumerate_group(gens_perm)

    # extended Golay basis on 24 coordinates (parity bit at index 23).
    residues = {(x * x) % Q for x in range(1, Q)}
    indicator = tuple(1 if i in residues else 0 for i in range(Q))
    shifts = [tuple(indicator[(i - s) % Q] for i in range(Q)) for s in range(Q)]

    def extend(v):
        return v + (sum(v) % 2,)

    c_reduced, _ = rref([extend(sh) for sh in shifts])
    ones24 = (1,) * DEG
    # basis of C with all-ones first
    basis = [ones24]
    for b in c_reduced:
        if matrank([*basis, b]) > len(basis):
            basis.append(b)
    assert len(basis) == 12
    basis_matrix = basis  # rows = basis vectors in F_2^24

    def coords(word):
        # solve x * basis_matrix = word
        aug = [list(basis_matrix[j][i] for j in range(12)) + [word[i]] for i in range(DEG)]
        reduced, pivots = rref(aug)
        sol = [0] * 12
        for row, col in zip(reduced, pivots):
            if col < 12:
                sol[col] = row[-1]
        assert tuple(sum(sol[j] * basis_matrix[j][i] for j in range(12)) % 2 for i in range(DEG)) == word
        return sol

    def perm_word(word, perm):
        out = [0] * DEG
        for i in range(DEG):
            out[perm[i]] = word[i]
        return tuple(out)

    # invariance of C
    for b in basis:
        for perm in gens_perm:
            assert matrank([*c_reduced, perm_word(b, perm)]) == len(c_reduced)

    def qmat(perm):
        columns = [coords(perm_word(basis[i], perm))[1:12] for i in range(1, 12)]
        return tuple(tuple(columns[b][a] for b in range(11)) for a in range(11))

    return group, ident, gens_perm, qmat, basis, perm_word


# --- gate re-derivations ---------------------------------------------------

def module_closure(rows, gens):
    basis, _ = rref(rows)
    while True:
        enlarged, _ = rref([*basis, *(mvec(g, b) for b in basis for g in gens)])
        if enlarged == basis:
            return basis
        basis = enlarged


def submodule_dims(gens, n):
    found = {()}
    all_vecs = list(itertools.product(range(2), repeat=n))
    changed = True
    while changed:
        changed = False
        for sub in list(found):
            reduced, _ = rref(list(sub) if sub else [(0,) * n])
            base = reduced if sub else []
            for v in all_vecs:
                if matrank([*base, v]) == len(base):
                    continue
                cand = tuple(module_closure([*sub, v], gens))
                if cand not in found:
                    found.add(cand)
                    changed = True
    return sorted(len(s) for s in found)


def hom_dim(src, tgt, n):
    eqs = []
    for a, b in zip(src, tgt):
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] ^= a[i][k]
                    row[i * n + k] ^= b[k][j]
                eqs.append(tuple(row))
    return n * n - matrank(eqs)


def conj_matrix(g, n):
    gi = minv(g)
    dim = n * n
    M = [[0] * dim for _ in range(dim)]
    for a in range(n):
        for b in range(n):
            col = a * n + b
            for i in range(n):
                if g[i][a]:
                    for j in range(n):
                        if gi[b][j]:
                            M[i * n + j][col] ^= 1
    return tuple(tuple(row) for row in M)


def main():
    cert = json.loads(CERT.read_text())

    # Code flag.
    cf = code_flag()
    code = cert["code_flag"]
    assert cf["dim_S"] == code["expurgated_core_S"]["dimension"] == 11
    assert cf["dim_D"] == code["augmented_code_D"]["dimension"] == 12
    assert cf["min_wt_D"] == code["weight_spectrum"]["min_weight_D"] == 7
    assert cf["S_eq_Dperp"] and cf["D_eq_one_plus_S"]

    group, ident, gens_perm, qmat, cbasis, perm_word = build_module_and_group()
    obstruction = cert["group_obstruction"]
    assert len(group) == obstruction["order"] == 6072

    # Sylow-2 D8, chosen via a DIFFERENT involution than the primary script.
    r = next(g for g in group if order_of(g, ident) == 4)
    rinv = comp(comp(r, r), r)
    involutions_inverting_r = [g for g in group
                               if order_of(g, ident) == 2 and comp(comp(g, r), g) == rinv]
    s = involutions_inverting_r[-1]  # last, not first
    sylow2 = closure([r, s])
    assert len(sylow2) == 8
    assert sum(1 for g in sylow2 if order_of(g, ident) == 2) == 5  # dihedral D8

    # No index-23 subgroup: independent overgroup exhaustion above this Sylow-2.
    cap = len(group) // Q  # 264
    found = {sylow2}
    stack = [sylow2]
    orders = {8}
    while stack:
        base = stack.pop()
        covered = set(base)
        for g in group:
            if g in covered:
                continue
            H = closure(set(base) | {g}, cap=cap)
            if H is None:
                covered.update(comp(k, g) for k in base)
                continue
            covered.update(H)
            if H not in found:
                found.add(H)
                stack.append(H)
                orders.add(len(H))
    assert sorted(orders) == obstruction["degree_23_realizability"]["overgroup_orders_at_most_264"] == [8, 24]
    assert not any(len(H) == cap for H in found)

    # Carrier module gates.
    n = 11
    s_gens = [qmat(p) for p in gens_perm]
    s_dual = [tuple(zip(*minv(g))) for g in s_gens]
    carrier = cert["carrier_module"]

    # Gate 6.
    assert submodule_dims(s_gens, n) == carrier["gate_6_simple_core"]["S_submodule_dimensions"] == [0, 11]
    assert submodule_dims(s_dual, n) == [0, 11]
    assert hom_dim(s_gens, s_dual, n) == carrier["gate_6_simple_core"]["hom_S_to_Sdual_dimension"] == 0

    # Gate 7.
    assert hom_dim(s_gens, s_gens, n) == carrier["gate_7_rigidity"]["End_S_dimension"] == 1
    assert hom_dim(s_dual, s_dual, n) == 1

    # D8 matrices.
    d8_perms = sorted(sylow2)
    d8_mats = [qmat(p) for p in d8_perms]

    # Gate 4: End_0(S) free on D8 via norm rank = 120/8 = 15.
    dim = n * n
    norm = [[0] * dim for _ in range(dim)]
    for g in d8_mats:
        cm = conj_matrix(g, n)
        for i in range(dim):
            for j in range(dim):
                if cm[i][j]:
                    norm[i][j] ^= 1
    norm_cols = [tuple(norm[i][j] for i in range(dim)) for j in range(dim)]
    assert matrank(norm_cols) == carrier["gate_4_local_picard"]["norm_map_rank"] == 15

    # Coefficient-module actions on the 121-dim endomorphism space.
    def hom_star(g):          # Hom(S*,S): F -> g F g^T  (correct target for Ext^1(S*,S))
        m = len(g); D = m * m
        M = [[0] * D for _ in range(D)]
        for a in range(m):
            for b in range(m):
                col = a * m + b
                for i in range(m):
                    if g[i][a]:
                        for j in range(m):
                            if g[j][b]:
                                M[i * m + j][col] ^= 1
        return tuple(tuple(row) for row in M)

    # ---- Gates 3 & 5: DIRECT global H^1 over all 6072 elements (independent bitmask cocycle) ----
    def rowint(row):
        return sum(1 << k for k, x in enumerate(row) if x)

    def matmul_bits(a_rows, b_rows):
        out = []
        for a in a_rows:
            acc, row = 0, a
            while row:
                k = (row & -row).bit_length() - 1
                acc ^= b_rows[k]
                row &= row - 1
            out.append(acc)
        return out

    def global_h1(coeff):
        m = len(coeff[0]); ng = 2; width = ng * m
        cint = [[rowint(g[i]) for i in range(m)] for g in coeff]
        acts_b = {ident: [1 << i for i in range(m)]}
        expr_b = {ident: [0] * m}
        piv = {}
        def absorb(row):
            while row:
                lead = (row & -row).bit_length() - 1
                if lead in piv:
                    row ^= piv[lead]
                else:
                    piv[lead] = row
                    return
        dq = deque([ident])
        while dq:
            g = dq.popleft(); ag = acts_b[g]; eg = expr_b[g]
            for sidx, gg in enumerate(gens_perm):
                h = comp(g, gg)
                cand = [eg[i] ^ (ag[i] << (sidx * m)) for i in range(m)]
                ah = matmul_bits(ag, cint[sidx])
                if h not in acts_b:
                    acts_b[h] = ah; expr_b[h] = cand; dq.append(h)
                else:
                    eh = expr_b[h]
                    for i in range(m):
                        absorb(cand[i] ^ eh[i])
        z1 = width - len(piv)
        fix = []
        for g in coeff:
            for i in range(m):
                fix.append(tuple((g[i][j] - int(i == j)) % 2 for j in range(m)))
        b1 = matrank(fix)  # = m - dim L^G
        return z1, b1, z1 - b1

    g5 = carrier["gate_5_fusion_descent"]
    z1h, b1h, h1h = global_h1([hom_star(g) for g in s_gens])
    assert (z1h, b1h, h1h) == (g5["global_Z1"], g5["global_B1"], g5["dim_Ext1_S_dual_to_S"]) == (122, 121, 1)
    bonus = carrier["global_self_extension_bonus"]
    z1e, b1e, h1e = global_h1([conj_matrix(g, n) for g in s_gens])
    assert (z1e, b1e, h1e) == (bonus["global_Z1"], bonus["global_B1"], bonus["dim_Ext1_S_to_S"]) == (120, 120, 0)
    assert (len(group) // 8) % 2 == 1  # odd index -> restriction injective

    # ---- corroborating local D8 profile with the CORRECT Hom(S*,S) action ----
    def local_d8(coeff):
        width = 2 * dim
        expr = {ident: tuple(tuple(0 for _ in range(width)) for _ in range(dim))}
        acts = {ident: tuple(tuple(int(i == j) for j in range(dim)) for i in range(dim))}
        cons = []
        inj = [tuple(tuple(int(j == sidx * dim + i) for j in range(width)) for i in range(dim))
               for sidx in range(2)]
        dq = deque([ident])
        while dq:
            g = dq.popleft()
            for sidx, gg in enumerate([r, s]):
                h = comp(g, gg)
                shifted = tuple(tuple(sum(acts[g][i][k] * inj[sidx][k][j] for k in range(dim)) % 2
                                      for j in range(width)) for i in range(dim))
                cand = tuple(tuple((x + y) % 2 for x, y in zip(a, b)) for a, b in zip(expr[g], shifted))
                ah = mmul(acts[g], coeff[sidx])
                if h not in expr:
                    expr[h] = cand; acts[h] = ah; dq.append(h)
                else:
                    cons.extend(tuple((x - y) % 2 for x, y in zip(a, b)) for a, b in zip(cand, expr[h]))
        z_basis = nullspace(cons, width)
        b_reduced, _ = rref([tuple((int(i == j) - A[i][j]) % 2 for A in coeff for i in range(dim))
                             for j in range(dim)])
        h1 = []
        span = list(b_reduced)
        for z in z_basis:
            if matrank([*span, z]) > len(span):
                h1.append(z); span.append(z)
        central = comp(r, r)
        fused = [g for g in d8_perms if order_of(g, ident) == 2 and g != central][0]

        def restr_nonzero(cocy, t):
            A = acts[t]
            cols = [tuple((int(i == j) - A[i][j]) % 2 for i in range(dim)) for j in range(dim)]
            base = matrank(cols)
            val = tuple(sum(expr[t][i][k] * cocy[k] for k in range(width)) % 2 for i in range(dim))
            return matrank([*cols, val]) == base + 1

        vanish, any_central = 0, False
        for coeffs in itertools.product(range(2), repeat=len(h1)):
            if not any(coeffs):
                continue
            cocy = tuple(sum(coeffs[k] * h1[k][i] for k in range(len(h1))) % 2 for i in range(width))
            if restr_nonzero(cocy, central):
                any_central = True
            if not restr_nonzero(cocy, fused):
                vanish += 1
        return len(h1), not any_central, vanish

    local_hom = local_d8([hom_star(qmat(r)), hom_star(qmat(s))])
    assert local_hom == (2, True, 1)  # identical local shape to End(S): the caution
    local_end = local_d8([conj_matrix(qmat(r), n), conj_matrix(qmat(s), n)])
    assert local_end == (2, True, 1)  # same local data, yet global 0 vs 1

    # ---- gate-3 even-parity heart H = A24/<1>: exists, contains S, splits ----
    ones24 = (1,) * DEG
    a24_reduced, _ = rref([tuple(int(k == i) ^ int(k == DEG - 1) for k in range(DEG)) for i in range(DEG - 1)])
    abasis = [ones24]
    for b in a24_reduced:
        if matrank([*abasis, b]) > len(abasis):
            abasis.append(b)
    assert len(abasis) == 23

    def coords24(word, basis):
        aug = [[basis[j][i] for j in range(len(basis))] + [word[i]] for i in range(DEG)]
        reduced, pivots = rref(aug)
        sol = [0] * len(basis)
        for row, col in zip(reduced, pivots):
            if col < len(basis):
                sol[col] = row[-1]
        return sol

    def heart_matrix(p):
        cols = [coords24(perm_word(abasis[i], p), abasis)[1:23] for i in range(1, 23)]
        return tuple(tuple(cols[b][a] for b in range(22)) for a in range(22))

    Hg = [heart_matrix(p) for p in gens_perm]
    Pmat = tuple(tuple([coords24(cbasis[i], abasis)[1:23] for i in range(1, 12)][b][a]
                       for b in range(11)) for a in range(22))
    Sg_heart = [qmat(p) for p in gens_perm]
    for hg, sg in zip(Hg, Sg_heart):
        left = tuple(tuple(sum(hg[i][k] * Pmat[k][j] for k in range(22)) % 2 for j in range(11)) for i in range(22))
        right = tuple(tuple(sum(Pmat[i][k] * sg[k][j] for k in range(11)) % 2 for j in range(11)) for i in range(22))
        assert left == right
    # equivariant retraction r: H -> S with r|S = id
    eqs, rhs = [], []
    for hg, sg in zip(Hg, Sg_heart):
        for a in range(11):
            for j in range(22):
                row = [0] * (11 * 22)
                for k in range(22):
                    row[a * 22 + k] ^= hg[k][j]
                for l in range(11):
                    row[l * 22 + j] ^= sg[a][l]
                eqs.append(tuple(row)); rhs.append(0)
    for a in range(11):
        for b in range(11):
            row = [0] * (11 * 22)
            for j in range(22):
                row[a * 22 + j] = Pmat[j][b]
            eqs.append(tuple(row)); rhs.append(int(a == b))
    retraction_exists = matrank(eqs) == matrank([r_ + (v,) for r_, v in zip(eqs, rhs)])
    heart = carrier["gate_3_nonsplitting"]["even_parity_heart_packaging"]
    assert retraction_exists == heart["equivariant_retraction_H_to_S_exists"] is True
    end_h = hom_dim(Hg, Hg, 22)
    assert end_h == heart["heart_endomorphism_dimension"] == 2  # split S (+) S*
    assert heart["C_contained_in_A24_even_weight"] is True

    print(json.dumps({"status": "ok", "code_params": [Q, cf["dim_D"], cf["min_wt_D"]],
                      "group_order": len(group), "index_23_subgroup": False,
                      "gate4_norm_rank": 15,
                      "global_Ext_S_dual_to_S": h1h, "global_Ext_S_to_S": h1e,
                      "local_D8_Hom_star": list(local_hom), "heart_retraction_exists": retraction_exists,
                      "heart_End": end_h, "gate6_S_lattice": [0, 11], "gate7_End": 1}, sort_keys=True))


if __name__ == "__main__":
    main()
