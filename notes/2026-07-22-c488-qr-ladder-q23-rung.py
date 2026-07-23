#!/usr/bin/env python3
"""C488 QR-ladder q=23 rung: the seven Modular Gateway gates for the binary Golay code.

Deterministic, plain-Python-3, standard-library-only exact F_2 linear algebra and exact
finite-group enumeration.  No sage / GAP / numpy / sympy.  Report:
notes/2026-07-22-c488-qr-ladder-q23-rung.md.

Question (C488, crowns lane): does the third nontrivial perfect code, the binary Golay [23,12,7],
give a q=23 rung of the Modular Gateway (notes/2026-07-22-c474-modular-gateway-theory.md), promoting
the proved two-example theorem (q=7 binary Hamming, q=11 ternary Golay) to a family theorem?

Two things are tested, because the gate battery splits into a code-realizability half and a
group-theoretic carrier half:

  PART A  code flag over F_2 (gates 1-2): the QR/cyclic construction of D (augmented QR, dim 12) and
          S (expurgated even-weight subcode, dim 11), D = <1> (+) S, S = D^perp, [23,12,7].

  PART B  the perfect-code -> carrier BRIDGE: the proved rows realise S as a size-q permutation
          sheet under PSL_2(q) (the exceptional degree-q action).  This bridge requires PSL_2(23) to
          act on 23 points.  It does not: PSL_2(23) has no subgroup of index 23 (Galois' theorem;
          certified here by exhausting the overgroups of a fixed Sylow-2).  So the odd-size G-set
          Omega demanded by gate 1 does not exist and the literal q=7/q=11 construction is blocked.

  PART C  the CARRIER itself, decoupled from the odd Omega (alternative attack).  The genuine
          11-dimensional PSL_2(23)-module S = C/<1>, where C is the extended binary Golay [24,12,8]
          on P^1(F_23) (which IS PSL_2(23)-invariant and carries the true dihedral D8 Sylow), is
          tested against the group-side gates 3-7 directly.  All pass: S and S^* are non-isomorphic
          simples (gate 6), End = F_2 (gate 7), End_0(S) is free on the D8 Sylow (gate 4: norm rank
          15 = 120/8), and H^1(D8, S(x)S) is 2-dimensional with the single fused-reflection kernel of
          dimension 1 that the odd-index (759) injective restriction sends to dim Ext^1 = 1 (gate 5),
          exactly the certified q=7 fusion cut.

Conclusion: the endotrivial carrier mechanism EXTENDS to q=23 (composite m=(q+1)/4=6), so the
m-coincidence is decorative; what does NOT extend is the perfect-code bridge, blocked by Galois'
theorem.  The two-example "perfect code -> PSL_2(q) permutation carrier" statement does not become a
family, but for the group-theoretic reason that only q in {5,7,11} admit the degree-q action, not
because the endotriviality fails.

Load-bearing conventions:
  * Field k = F_2 (q=23 is a binary quadratic-residue prime, (2/23)=+1).
  * Omega (code side) = Z/23 = the 23 coordinates; group side, P^1(F_23) = 24 points with the point
    at infinity indexed 23; PSL_2(23) = <x->x+1, x->-1/x>.
  * Gate numbering follows the theorem (1-7).  The C488 queue's "gates 4-7" is shorthand for the
    remaining group-side gates = theorem gates 3-7.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import tempfile
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c488-qr-ladder-q23-rung.json"

Q = 23
FIELD = 2
DEGREE = Q + 1  # P^1(F_23)


# ===========================================================================
# F_2 linear algebra on Q-bit-integer codewords (code side, Part A).
# ===========================================================================

def popcount(x: int) -> int:
    return bin(x).count("1")


def bit_reduce(vectors: list[int]) -> list[int]:
    pivots: dict[int, int] = {}
    for v in vectors:
        row = v
        while row:
            lead = row.bit_length() - 1
            if lead in pivots:
                row ^= pivots[lead]
            else:
                pivots[lead] = row
                break
    return [pivots[k] for k in sorted(pivots, reverse=True)]


def bit_rank(vectors: list[int]) -> int:
    return len(bit_reduce(vectors))


def bit_in_span(v: int, reduced: list[int]) -> bool:
    lead_index = {b.bit_length() - 1: b for b in reduced}
    row = v
    while row:
        lead = row.bit_length() - 1
        if lead in lead_index:
            row ^= lead_index[lead]
        else:
            return False
    return True


# ===========================================================================
# F_2 dense-matrix linear algebra (group/module side, Parts B and C).
# ===========================================================================

def mat_mul(a, b):
    n = len(a)
    cols = list(zip(*b))
    return tuple(tuple(sum(a[i][k] * col[k] for k in range(n)) % 2 for col in cols) for i in range(n))


def mat_vec(a, v):
    return tuple(sum(row[k] * v[k] for k in range(len(v))) % 2 for row in a)


def identity(n):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def mat_inverse(a):
    n = len(a)
    aug = [list(a[i]) + [int(i == j) for j in range(n)] for i in range(n)]
    r = 0
    for col in range(n):
        pivot = next(i for i in range(r, n) if aug[i][col])
        aug[r], aug[pivot] = aug[pivot], aug[r]
        for i in range(n):
            if i != r and aug[i][col]:
                aug[i] = [x ^ y for x, y in zip(aug[i], aug[r])]
        r += 1
    return tuple(tuple(aug[i][n:]) for i in range(n))


def transpose(a):
    return tuple(zip(*a))


def rref_flat(rows, width):
    a = [list(r) for r in rows if any(r)]
    pivots = []
    r = 0
    for col in range(width):
        pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        for i in range(len(a)):
            if i != r and a[i][col]:
                a[i] = [x ^ y for x, y in zip(a[i], a[r])]
        pivots.append(col)
        r += 1
    return [tuple(row) for row in a[:r]], pivots


def rank_flat(rows, width):
    return len(rref_flat(rows, width)[0])


def nullspace_flat(rows, width):
    reduced, pivots = rref_flat(rows, width)
    free = [j for j in range(width) if j not in pivots]
    basis = []
    for f in free:
        v = [0] * width
        v[f] = 1
        for row, col in zip(reduced, pivots):
            v[col] = row[f]
        basis.append(tuple(v))
    return basis


def act_row_vector(v, permutation):
    out = [0] * len(v)
    for i, x in enumerate(v):
        out[permutation[i]] = x
    return tuple(out)


def module_closure(rows, generators, width):
    basis, _ = rref_flat(rows, width)
    while True:
        enlarged, _ = rref_flat([*basis, *(mat_vec(g, b) for b in basis for g in generators)], width)
        if enlarged == basis:
            return basis
        basis = enlarged


def submodule_dimensions(generators, width):
    """All F_2-submodule dimensions of the module with the given generator matrices."""
    zero: tuple = ()
    found = {zero}
    vectors = [tuple(int(i == j) for i in range(width)) for j in range(width)]
    all_vectors = []
    for coefficients in itertools.product(range(2), repeat=width):
        all_vectors.append(tuple(coefficients))
    changed = True
    while changed:
        changed = False
        for sub in list(found):
            reduced, _ = rref_flat(list(sub), width)
            for v in all_vectors:
                if rank_flat([*reduced, v], width) == len(reduced):
                    continue
                candidate = tuple(module_closure([*sub, v], generators, width))
                if candidate not in found:
                    found.add(candidate)
                    changed = True
    return sorted(len(s) for s in found)


def hom_space_dimension(source_generators, target_generators, n):
    equations = []
    for a, b in zip(source_generators, target_generators):
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + a[i][k]) % 2
                    row[i * n + k] = (row[i * n + k] + b[k][j]) % 2
                equations.append(tuple(row))
    return n * n - rank_flat(equations, n * n)


def commutant_dimension(generators, n):
    return hom_space_dimension(generators, generators, n)


# ===========================================================================
# PSL_2(23) on P^1(F_23).
# ===========================================================================

def inv_mod(x, q):
    return pow(x % q, q - 2, q)


def point_permutation(g, q):
    a, b, c, d = g
    out = []
    for x in range(q + 1):
        if x == q:
            out.append(q if c == 0 else a * inv_mod(c, q) % q)
        else:
            den = (c * x + d) % q
            out.append(q if den == 0 else (a * x + b) * inv_mod(den, q) % q)
    return tuple(out)


def compose(g, h):
    return tuple(h[g[i]] for i in range(len(g)))


def enumerate_group(generators, degree):
    ident = tuple(range(degree))
    seen = {ident}
    queue = deque([ident])
    while queue:
        g = queue.popleft()
        for s in generators:
            h = compose(g, s)
            if h not in seen:
                seen.add(h)
                queue.append(h)
    return sorted(seen)


def element_order(g, ident):
    power = g
    order = 1
    while power != ident:
        power = compose(power, g)
        order += 1
    return order


def subgroup_closure(elements, cap=None):
    base = set(elements)
    frontier = list(base)
    while frontier:
        g = frontier.pop()
        for h in list(base):
            for product in (compose(g, h), compose(h, g)):
                if product not in base:
                    base.add(product)
                    frontier.append(product)
                    if cap is not None and len(base) > cap:
                        return None
    return frozenset(base)


# ===========================================================================
# PART A -- the binary QR-code flag over F_2 (gates 1-2).
# ===========================================================================

def part_a_code_flag():
    residues = frozenset((x * x) % Q for x in range(1, Q))
    indicator = sum(1 << i for i in range(Q) if i in residues)
    ones = (1 << Q) - 1

    def cyclic_shift(word, s):
        return sum(1 << ((i + s) % Q) for i in range(Q) if word & (1 << i))

    shifts = [cyclic_shift(indicator, s) for s in range(Q)]
    d_basis = bit_reduce(shifts)
    dim_d = len(d_basis)
    diffs = [shifts[0] ^ sh for sh in shifts[1:]]
    s_basis = bit_reduce(diffs)
    dim_s = len(s_basis)

    s_subset_dperp = all(popcount(b & c) % 2 == 0 for b in d_basis for c in s_basis)
    one_in_s = bit_in_span(ones, s_basis)
    d_equals_one_plus_s = bit_rank(s_basis + [ones]) == dim_d and not one_in_s
    s_is_even = all(popcount(b) % 2 == 0 for b in s_basis)

    def min_weight(basis):
        best = Q + 1
        k = len(basis)
        for mask in range(1, 1 << k):
            word = 0
            m, idx = mask, 0
            while m:
                if m & 1:
                    word ^= basis[idx]
                m >>= 1
                idx += 1
            best = min(best, popcount(word))
        return best

    min_wt_d = min_weight(d_basis)
    min_wt_s = min_weight(s_basis)

    gate1_arithmetic = (Q % FIELD) != 0
    gate2 = (dim_d == (Q + 1) // 2 and dim_s == (Q - 1) // 2 and s_subset_dperp
             and (Q - dim_d) == dim_s and d_equals_one_plus_s and s_is_even and min_wt_d == 7)

    return {
        "omega": {"definition": "Z/23, the 23 coordinates of the length-23 binary Golay code",
                  "size": Q, "size_mod_field": Q % FIELD, "size_nonzero_in_F2": gate1_arithmetic},
        "augmented_code_D": {"definition": "span of the 23 cyclic shifts of the QR-set indicator",
                             "dimension": dim_d, "expected_dimension": (Q + 1) // 2},
        "expurgated_core_S": {"definition": "even-weight subcode = span of pairwise shift differences",
                              "dimension": dim_s, "expected_dimension": (Q - 1) // 2,
                              "all_even_weight": s_is_even},
        "flag_relations": {"D_perp_dimension": Q - dim_d, "S_subset_D_perp": s_subset_dperp,
                           "S_equals_D_perp_by_dimension": s_subset_dperp and (Q - dim_d) == dim_s,
                           "all_ones_not_in_S": not one_in_s, "D_equals_one_plus_S": d_equals_one_plus_s},
        "weight_spectrum": {"min_weight_D": min_wt_d, "code_parameters_D": [Q, dim_d, min_wt_d],
                            "is_binary_golay_23_12_7": [Q, dim_d, min_wt_d] == [23, 12, 7],
                            "min_weight_S_even_subcode": min_wt_s},
        "augmentation_module_A": {"definition": "A = ker(epsilon), dim 22 (only on the odd 23-set)",
                                  "dimension": Q - 1},
        "gate1_arithmetic_pass": gate1_arithmetic,
        "gate2_pass": gate2,
    }


# ===========================================================================
# PART B -- degree-23 realizability obstruction for PSL_2(23).
# ===========================================================================

def part_b_group_obstruction(group, ident):
    order = len(group)
    r = next(g for g in group if element_order(g, ident) == 4)
    r_inverse = compose(compose(r, r), r)
    s = next(g for g in group if element_order(g, ident) == 2 and compose(compose(g, r), g) == r_inverse)
    sylow2 = subgroup_closure([r, s])
    involutions = sum(1 for g in sylow2 if element_order(g, ident) == 2)
    sylow2_is_d8 = len(sylow2) == 8 and involutions == 5

    index_23_order = order // Q  # 264
    found = {sylow2}
    queue = [sylow2]
    overgroup_orders = {len(sylow2)}
    while queue:
        base = queue.pop()
        covered = set(base)
        for g in group:
            if g in covered:
                continue
            closure = subgroup_closure(set(base) | {g}, cap=index_23_order)
            if closure is None:
                covered.update(compose(k, g) for k in base)
                continue
            covered.update(closure)
            if closure not in found:
                found.add(closure)
                queue.append(closure)
                overgroup_orders.add(len(closure))
    has_index_23 = any(len(h) == index_23_order for h in found)

    return {
        "group": f"PSL_2({Q})", "order": order, "order_factorization": "2^3 * 3 * 11 * 23",
        "natural_action": {"space": "P^1(F_23)", "degree": DEGREE, "degree_mod_field": DEGREE % FIELD,
                           "degree_nonzero_in_F2": (DEGREE % FIELD) != 0},
        "sylow_2": {"order": len(sylow2), "involution_count": involutions,
                    "is_dihedral_D8": sylow2_is_d8},
        "degree_23_realizability": {
            "required_point_stabilizer_order": index_23_order, "required_index": Q,
            "method": "exhaustive enumeration of subgroups of order <= 264 containing a fixed Sylow-2",
            "overgroup_orders_at_most_264": sorted(overgroup_orders),
            "number_of_such_overgroups": len(found),
            "subgroup_of_index_23_exists": has_index_23,
            "transitive_action_of_degree_23_exists": has_index_23,
            "classification_corroboration": ("Galois: PSL_2(p) has an index-p subgroup only for "
                                             "p in {5,7,11}; 23 is excluded"),
        },
        "affine_fallback_on_23_points": {
            "group": "23:11 (QR-multiplier affine group), order 253",
            "order": Q * ((Q - 1) // 2), "order_is_odd": True,
            "consequence": ("char 2 does not divide 253, so F_2[23:11] is semisimple (Maschke); every "
                            "extension splits equivariantly and the endotriviality gates collapse "
                            "(trivial Sylow-2). No size-23 group carrying the Golay coordinates "
                            "realizes the gateway."),
        },
        "_sylow2_generators": (r, s),
    }


# ===========================================================================
# PART C -- the genuine 11-dim PSL_2(23)-carrier (extended Golay), gates 3-7.
# ===========================================================================

# Shared construction of the extended binary Golay code C = [24,12,8] on P^1(F_23) and of the
# 11-dimensional quotient module S = C/<1>.  Everything downstream uses these to avoid drift.
_GOLAY_BASIS = None


def _golay_basis():
    """Basis of C = extended Golay [24,12,8] with the all-ones vector first (so C/<1> = coords 1..11)."""
    global _GOLAY_BASIS
    if _GOLAY_BASIS is None:
        residues = frozenset((x * x) % Q for x in range(1, Q))
        indicator = sum(1 << i for i in range(Q) if i in residues)
        cyclic_shift = lambda word, s: sum(1 << ((i + s) % Q) for i in range(Q) if word & (1 << i))
        d_basis = bit_reduce([cyclic_shift(indicator, s) for s in range(Q)])
        extend = lambda v: v | ((popcount(v) & 1) << 23)  # parity bit at the infinity coordinate
        c_reduced = bit_reduce([extend(b) for b in d_basis])
        all_ones = (1 << DEGREE) - 1
        assert bit_in_span(all_ones, c_reduced)
        basis = [all_ones]
        for b in c_reduced:
            if bit_rank(basis + [b]) > len(basis):
                basis.append(b)
        assert len(basis) == 12
        _GOLAY_BASIS = (basis, c_reduced)
    return _GOLAY_BASIS


def _permute_bits(word, perm):
    return sum(1 << perm[i] for i in range(DEGREE) if word & (1 << i))


def _coords_in(word, basis):
    """Coordinates of `word` in the F_2 basis `basis` (list of bit-integers), by tracked reduction."""
    pivots = {}
    for i, vec in enumerate(basis):
        row, tag = vec, 1 << i
        while row:
            lead = row.bit_length() - 1
            if lead in pivots:
                prow, ptag = pivots[lead]
                row ^= prow
                tag ^= ptag
            else:
                pivots[lead] = (row, tag)
                break
    row, tag = word, 0
    while row:
        lead = row.bit_length() - 1
        prow, ptag = pivots[lead]
        row ^= prow
        tag ^= ptag
    return [(tag >> i) & 1 for i in range(len(basis))]


_MODULE_MEMO: dict = {}


def module_matrix(perm):
    """11x11 matrix of the permutation `perm` acting on S = C/<1>."""
    if perm not in _MODULE_MEMO:
        basis, _ = _golay_basis()
        columns = [_coords_in(_permute_bits(basis[i], perm), basis)[1:12] for i in range(1, 12)]
        _MODULE_MEMO[perm] = tuple(tuple(columns[b][a] for b in range(11)) for a in range(11))
    return _MODULE_MEMO[perm]


def conjugation_matrix(g, n):
    """Action of g on End(S) = Hom(S,S): F -> g F g^{-1}.  (Coefficients for Ext^1(S,S).)"""
    gi = mat_inverse(g)
    dim = n * n
    matrix = [[0] * dim for _ in range(dim)]
    for a in range(n):
        for b in range(n):
            col = a * n + b
            for i in range(n):
                if g[i][a]:
                    for j in range(n):
                        if gi[b][j]:
                            matrix[i * n + j][col] ^= 1
    return tuple(tuple(row) for row in matrix)


def hom_star_matrix(g, n):
    """Action of g on Hom(S^*,S): F -> g F g^T.  (Correct coefficients for Ext^1(S^*,S).)"""
    dim = n * n
    matrix = [[0] * dim for _ in range(dim)]
    for a in range(n):
        for b in range(n):
            col = a * n + b
            for i in range(n):
                if g[i][a]:
                    for j in range(n):
                        if g[j][b]:
                            matrix[i * n + j][col] ^= 1
    return tuple(tuple(row) for row in matrix)


def _matmul_bits(a_rows_int, b_rows_int):
    """Product of two square F_2 matrices given as lists of row bit-integers."""
    out = []
    for a in a_rows_int:
        acc = 0
        row = a
        while row:
            k = (row & -row).bit_length() - 1
            acc ^= b_rows_int[k]
            row &= row - 1
        out.append(acc)
    return out


def global_h1(generators_perm, coefficient_generators, want_witness=False):
    """dim H^1(G, L) over the whole group, by the Cayley-graph Z^1/B^1 rank route.

    A 1-cochain is parametrised by its values on the two generators (`width = 2n` unknowns); the
    per-element expression matrices are propagated along a BFS of the Cayley graph, and every
    non-tree edge contributes cocycle constraints.  dim Z^1 = width - rank(constraints);
    dim B^1 = n - dim L^G.  Rows are packed as bit-integers for speed and memory.
    """
    n = len(coefficient_generators[0])
    ngen = len(generators_perm)
    width = ngen * n
    coeff_int = [[sum(1 << k for k in range(n) if g[i][k]) for i in range(n)]
                 for g in coefficient_generators]
    ident = tuple(range(DEGREE))
    actions = {ident: [1 << i for i in range(n)]}       # each row an n-bit integer
    expressions = {ident: [0] * n}                        # each row a width-bit integer
    pivots: dict[int, int] = {}                           # LSB-keyed echelon of the constraint rows

    def absorb(row):
        while row:
            lead = (row & -row).bit_length() - 1
            if lead in pivots:
                row ^= pivots[lead]
            else:
                pivots[lead] = row
                return

    queue = deque([ident])
    while queue:
        g = queue.popleft()
        ag, eg = actions[g], expressions[g]
        for s, gen in enumerate(generators_perm):
            h = compose(g, gen)
            candidate = [eg[i] ^ (ag[i] << (s * n)) for i in range(n)]
            action_h = _matmul_bits(ag, coeff_int[s])
            if h not in actions:
                actions[h] = action_h
                expressions[h] = candidate
                queue.append(h)
            else:
                eh = expressions[h]
                for i in range(n):
                    absorb(candidate[i] ^ eh[i])
    z1 = width - len(pivots)
    # dim B^1 = n - dim L^G.
    fixed_equations = []
    for g in coefficient_generators:
        for i in range(n):
            fixed_equations.append(tuple((g[i][j] - int(i == j)) % 2 for j in range(n)))
    fixed_dim = n - rank_flat(fixed_equations, n)
    b1 = n - fixed_dim
    h1 = z1 - b1

    witness = None
    if want_witness and h1 > 0:
        pivot_rows = [tuple((row >> j) & 1 for j in range(width)) for row in pivots.values()]
        z_basis = nullspace_flat(pivot_rows, width)
        coboundaries = []
        for j in range(n):
            vector = []
            for action in coefficient_generators:
                vector.extend((int(i == j) - action[i][j]) % 2 for i in range(n))
            coboundaries.append(tuple(vector))
        b_reduced, _ = rref_flat(coboundaries, width)
        span = list(b_reduced)
        for z in z_basis:
            if rank_flat([*span, z], width) > len(span):
                witness = z
                break
    return {"z1": z1, "b1": b1, "h1": h1,
            "witness_value_on_generator_0": list(witness[:n]) if witness else None,
            "witness_value_on_generator_1": list(witness[n:]) if witness else None}


def local_cocycle(sylow_generators_perm, coefficient_generators):
    """Z^1, B^1, and per-element expressions for H^1 of a small group in given coefficients."""
    n = len(coefficient_generators[0])
    width = len(sylow_generators_perm) * n
    ident = tuple(range(DEGREE))
    expressions = {ident: tuple(tuple(0 for _ in range(width)) for _ in range(n))}
    actions = {ident: identity(n)}
    injections = [tuple(tuple(int(j == s * n + i) for j in range(width)) for i in range(n))
                  for s in range(len(sylow_generators_perm))]
    constraints = []
    queue = deque([ident])
    while queue:
        g = queue.popleft()
        for s, gen in enumerate(sylow_generators_perm):
            h = compose(g, gen)
            candidate = tuple(tuple((x + y) % 2 for x, y in zip(a, b)) for a, b in zip(
                expressions[g], _apply(actions[g], injections[s], width)))
            action_h = mat_mul(actions[g], coefficient_generators[s])
            if h not in expressions:
                expressions[h] = candidate
                actions[h] = action_h
                queue.append(h)
            else:
                constraints.extend(tuple((x - y) % 2 for x, y in zip(a, b))
                                   for a, b in zip(candidate, expressions[h]))
    z_basis = nullspace_flat(constraints, width)
    coboundaries = []
    for j in range(n):
        vector = []
        for action in coefficient_generators:
            vector.extend((int(i == j) - action[i][j]) % 2 for i in range(n))
        coboundaries.append(tuple(vector))
    b_reduced, _ = rref_flat(coboundaries, width)
    return width, n, expressions, actions, z_basis, b_reduced


def _apply(action, injection, width):
    """action (n x n) times injection (n x width) over F_2."""
    n = len(action)
    return tuple(tuple(sum(action[i][k] * injection[k][j] for k in range(n)) % 2 for j in range(width))
                 for i in range(n))


def local_d8_profile(r, s, coefficient_generators):
    """Local H^1(D8, L) dimension and the C2 restriction profile, for either coefficient module."""
    n = len(coefficient_generators[0])
    width, cdim, expressions, actions, z_basis, b_reduced = local_cocycle([r, s], coefficient_generators)
    h1_dim = len(z_basis) - len(b_reduced)
    h1_basis = []
    span = list(b_reduced)
    for z in z_basis:
        if rank_flat([*span, z], width) > len(span):
            h1_basis.append(z)
            span.append(z)
    central = compose(r, r)

    def restriction_nonzero(cocycle, t_perm):
        action = actions[t_perm]
        columns = [tuple((int(i == j) - action[i][j]) % 2 for i in range(cdim)) for j in range(cdim)]
        base_rank = rank_flat(columns, cdim)
        value = tuple(sum(expressions[t_perm][i][k] * cocycle[k] for k in range(width)) % 2
                      for i in range(cdim))
        return rank_flat([*columns, value], cdim) == base_rank + 1

    d8_perms = sorted(subgroup_closure([r, s]))
    reflections = [g for g in d8_perms if element_order(g, tuple(range(DEGREE))) == 2 and g != central]
    fused = reflections[0]
    vanishing_on_fused = 0
    any_on_central = False
    for coefficients in itertools.product(range(2), repeat=len(h1_basis)):
        if not any(coefficients):
            continue
        cocycle = tuple(sum(coefficients[k] * h1_basis[k][i] for k in range(len(h1_basis))) % 2
                        for i in range(width))
        if restriction_nonzero(cocycle, central):
            any_on_central = True
        if not restriction_nonzero(cocycle, fused):
            vanishing_on_fused += 1
    return {"H1_dimension": h1_dim, "all_classes_trivial_on_central_C2": not any_on_central,
            "classes_vanishing_on_fused_reflection_C2": vanishing_on_fused}


def build_heart(generators_perm):
    """The even-parity middle module: heart H = A24/<1> (dim 22), with 0 -> S -> H -> H/S -> 0.

    On the odd rows the augmentation A = ker(epsilon) is the nonsplit carrier; at even parity
    |Omega|=24=0 in F_2, A does not appear and the heart H takes the middle slot.  This function
    tests whether that sequence is the carrier (no equivariant retraction) or splits.
    """
    all_ones = (1 << DEGREE) - 1
    # A24 = sum-zero submodule (dim 23), basis with all-ones first.
    a24_reduced = bit_reduce([(1 << i) ^ (1 << (DEGREE - 1)) for i in range(DEGREE - 1)])
    a_basis = [all_ones]
    for b in a24_reduced:
        if bit_rank(a_basis + [b]) > len(a_basis):
            a_basis.append(b)
    assert len(a_basis) == DEGREE - 1  # 23

    golay_basis, _ = _golay_basis()
    # C is contained in A24 iff every codeword has even weight.
    c_in_a24 = all(popcount(b) % 2 == 0 for b in golay_basis)

    def heart_matrix(perm):
        columns = [_coords_in(_permute_bits(a_basis[i], perm), a_basis)[1:23] for i in range(1, 23)]
        return tuple(tuple(columns[b][a] for b in range(22)) for a in range(22))

    heart_gens = [heart_matrix(perm) for perm in generators_perm]
    # Inclusion P (22x11): S = C/<1> inside H = A24/<1>.
    p_columns = [_coords_in(golay_basis[i], a_basis)[1:23] for i in range(1, 12)]
    inclusion = tuple(tuple(p_columns[b][a] for b in range(11)) for a in range(22))
    s_in_heart = [module_matrix(perm) for perm in generators_perm]
    # Verify the inclusion intertwines: H_g @ P == P @ S_g.
    for hg, sg in zip(heart_gens, s_in_heart):
        left = tuple(tuple(sum(hg[i][k] * inclusion[k][j] for k in range(22)) % 2 for j in range(11))
                     for i in range(22))
        right = tuple(tuple(sum(inclusion[i][k] * sg[k][j] for k in range(11)) % 2 for j in range(11))
                      for i in range(22))
        assert left == right

    # Gate-3 packaging: is there a G-equivariant retraction r: H -> S with r|S = id?
    equations, rhs = [], []
    for hg, sg in zip(heart_gens, s_in_heart):
        for a in range(11):
            for j in range(22):
                row = [0] * (11 * 22)
                for k in range(22):
                    row[a * 22 + k] = (row[a * 22 + k] + hg[k][j]) % 2
                for l in range(11):
                    row[l * 22 + j] = (row[l * 22 + j] + sg[a][l]) % 2
                equations.append(tuple(row))
                rhs.append(0)
    for a in range(11):
        for b in range(11):
            row = [0] * (11 * 22)
            for j in range(22):
                row[a * 22 + j] = inclusion[j][b]
            equations.append(tuple(row))
            rhs.append(int(a == b))
    coeff_rank = rank_flat(equations, 11 * 22)
    aug_rank = rank_flat([row + (v,) for row, v in zip(equations, rhs)], 11 * 22 + 1)
    retraction_exists = coeff_rank == aug_rank
    heart_commutant = commutant_dimension(heart_gens, 22)

    # H/S quotient (dim 11) and its isomorphism type versus S^*.
    heart_span = [tuple(inclusion[i][b] for i in range(22)) for b in range(11)]
    complement = []
    for j in range(22):
        e = tuple(int(i == j) for i in range(22))
        if rank_flat([*heart_span, *complement, e], 22) > len(heart_span) + len(complement):
            complement.append(e)
    full = heart_span + complement

    def coords_flat(v, basis):
        augmented = [[basis[j][i] for j in range(len(basis))] + [v[i]] for i in range(22)]
        reduced, pivot_cols = rref_flat(augmented, len(basis) + 1)
        solution = [0] * len(basis)
        for row, col in zip(reduced, pivot_cols):
            if col < len(basis):
                solution[col] = row[-1]
        return solution

    def quotient_matrix(hg):
        columns = []
        for b in range(11):
            image = tuple(sum(hg[i][k] * complement[b][k] for k in range(22)) % 2 for i in range(22))
            columns.append(coords_flat(image, full)[11:22])
        return tuple(tuple(columns[b][a] for b in range(11)) for a in range(11))

    quotient_gens = [quotient_matrix(hg) for hg in heart_gens]
    s_dual = [transpose(mat_inverse(sg)) for sg in s_in_heart]
    quotient_iso_to_s_dual = hom_space_dimension(quotient_gens, s_dual, 11) >= 1 and _has_iso(quotient_gens, s_dual, 11)

    return {
        "heart_definition": "H = A24/<1>, A24 = ker(epsilon) on P^1(F_23) (dim 23), H dim 22",
        "C_contained_in_A24_even_weight": c_in_a24,
        "S_embeds_in_heart_dim": 11,
        "quotient_H_over_S_dim": 11,
        "quotient_isomorphic_to_S_dual": quotient_iso_to_s_dual,
        "equivariant_retraction_H_to_S_exists": retraction_exists,
        "heart_endomorphism_dimension": heart_commutant,
        "heart_splits_as_S_plus_Sdual": retraction_exists and heart_commutant == 2,
        "reading": ("at even parity the augmentation A does not exist; the heart H takes the middle "
                    "slot but SPLITS (a G-equivariant retraction exists, End_G(H)=2), so H = S (+) S^* "
                    "realises the zero/split class -- the even-parity middle module is NOT the carrier. "
                    "The nonsplit carrier still exists (global Ext^1 = 1) but is not this module."),
    }


def _has_iso(source, target, n):
    equations = []
    for a, b in zip(source, target):
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + a[i][k]) % 2
                    row[i * n + k] = (row[i * n + k] + b[k][j]) % 2
                equations.append(tuple(row))
    basis = nullspace_flat(equations, n * n)
    if len(basis) > 16:
        return None
    for coefficients in itertools.product(range(2), repeat=len(basis)):
        if not any(coefficients):
            continue
        matrix = [[sum(coefficients[k] * basis[k][i * n + j] for k in range(len(basis))) % 2
                   for j in range(n)] for i in range(n)]
        if rank_flat([tuple(row) for row in matrix], n) == n:
            return True
    return False


def part_c_carrier(group, ident, sylow2_generators):
    generators_perm = [point_permutation((1, 1, 0, 1), Q), point_permutation((0, Q - 1, 1, 0), Q)]
    n = 11
    s_gens = [module_matrix(perm) for perm in generators_perm]
    # Certify C is PSL_2(23)-invariant (not assumed).
    golay_basis, c_reduced = _golay_basis()
    for b in golay_basis:
        for perm in generators_perm:
            assert bit_in_span(_permute_bits(b, perm), c_reduced)
    s_dual = [transpose(mat_inverse(g)) for g in s_gens]

    # Gate 6: simplicity and non-isomorphism.
    s_lattice = submodule_dimensions(s_gens, n)
    s_dual_lattice = submodule_dimensions(s_dual, n)
    hom_s_sdual = hom_space_dimension(s_gens, s_dual, n)
    gate6 = s_lattice == [0, n] and s_dual_lattice == [0, n] and hom_s_sdual == 0

    # Gate 7: rigidity.
    end_s = commutant_dimension(s_gens, n)
    end_s_dual = commutant_dimension(s_dual, n)
    gate7 = end_s == 1 and end_s_dual == 1

    # Gate 4: End_0(S) projective (free) on the D8 Sylow via norm rank. End(S) = conjugation action.
    r, s = sylow2_generators
    d8_perms = sorted(subgroup_closure([r, s]))
    d8_matrices = [module_matrix(p) for p in d8_perms]
    dim_end = n * n
    conjugations = [conjugation_matrix(g, n) for g in d8_matrices]
    norm = [[0] * dim_end for _ in range(dim_end)]
    for matrix in conjugations:
        for i in range(dim_end):
            row = matrix[i]
            for j in range(dim_end):
                if row[j]:
                    norm[i][j] ^= 1
    norm_columns = [tuple(norm[i][j] for i in range(dim_end)) for j in range(dim_end)]
    norm_rank = rank_flat(norm_columns, dim_end)
    expected_free_rank = (n * n - 1) // len(d8_perms)  # dim End_0 / |D8| = 120/8 = 15
    gate4 = norm_rank == expected_free_rank

    # Gates 3 and 5: DIRECT global cohomology, the correct coefficient module Hom(S^*,S): F -> gFg^T.
    hom_coeff = [hom_star_matrix(g, n) for g in s_gens]
    end_coeff = [conjugation_matrix(g, n) for g in s_gens]
    global_hom = global_h1(generators_perm, hom_coeff, want_witness=True)   # dim Ext^1(S^*,S)
    global_end = global_h1(generators_perm, end_coeff)                      # dim Ext^1(S,S), bonus/caution

    dim_ext = global_hom["h1"]
    gate3 = dim_ext >= 1                       # a nonsplit extension of S^* by S exists
    gate5 = dim_ext == 1                       # it is unique up to isomorphism

    # Corroborating LOCAL D8 structure, for BOTH coefficient modules (the caution).
    r_matrix, s_matrix = module_matrix(r), module_matrix(s)
    hom_local = local_d8_profile(r, s, [hom_star_matrix(r_matrix, n), hom_star_matrix(s_matrix, n)])
    end_local = local_d8_profile(r, s, [conjugation_matrix(r_matrix, n), conjugation_matrix(s_matrix, n)])
    sylow_index = len(group) // len(d8_perms)

    heart = build_heart(generators_perm)

    return {
        "module": "S = C/<1>, C = extended binary Golay [24,12,8] on P^1(F_23), as an F_2 PSL_2(23)-module",
        "dimension": n,
        "extended_code_is_PSL2_23_invariant": True,
        "gate_6_simple_core": {
            "S_submodule_dimensions": s_lattice, "S_is_simple": s_lattice == [0, n],
            "S_dual_submodule_dimensions": s_dual_lattice, "S_dual_is_simple": s_dual_lattice == [0, n],
            "hom_S_to_Sdual_dimension": hom_s_sdual, "S_not_isomorphic_to_S_dual": hom_s_sdual == 0,
            "pass": gate6,
        },
        "gate_7_rigidity": {"End_S_dimension": end_s, "End_S_dual_dimension": end_s_dual, "pass": gate7},
        "gate_4_local_picard": {
            "sylow_2": "D8", "End_dimension": n * n, "trace_zero_dimension": n * n - 1,
            "norm_map_rank": norm_rank, "expected_free_rank_dim_End0_over_8": expected_free_rank,
            "End0_restricted_to_D8_is_free": gate4,
            "criterion": "for a 2-group P, a kP-module is projective iff free iff rank(norm) = dim/|P|",
            "pass": gate4,
        },
        "gate_5_fusion_descent": {
            "certificate": "DIRECT global H^1(G, Hom(S^*,S)) over all 6072 elements",
            "coefficient_module": "Hom(S^*,S), action F -> g F g^T",
            "global_Z1": global_hom["z1"], "global_B1": global_hom["b1"],
            "dim_Ext1_S_dual_to_S": dim_ext,
            "corroborating_local_D8_H1_Hom_star": hom_local,
            "sylow_index": sylow_index, "restriction_injective_odd_index": sylow_index % 2 == 1,
            "pass": gate5,
        },
        "gate_3_nonsplitting": {
            "statement": "a nonsplit extension of S^* by S exists (Ext^1(S^*,S) != 0)",
            "certificate": "global dim H^1(G, Hom(S^*,S)) = 1 > 0; explicit nonzero cocycle recorded",
            "explicit_nonzero_cocycle_value_on_generator_0": global_hom["witness_value_on_generator_0"],
            "explicit_nonzero_cocycle_value_on_generator_1": global_hom["witness_value_on_generator_1"],
            "even_parity_heart_packaging": heart,
            "pass": gate3,
        },
        "global_self_extension_bonus": {
            "dim_Ext1_S_to_S": global_end["h1"], "global_Z1": global_end["z1"],
            "global_B1": global_end["b1"],
            "reading": "S has no self-extensions (H^1(G, End S) = 0)",
        },
        "local_global_caution": {
            "statement": ("the local D8 data alone does NOT determine the global dimension: End(S) and "
                          "Hom(S^*,S) have identical local D8 profiles yet different global Ext"),
            "End_S_local_D8": end_local, "Hom_star_local_D8": hom_local,
            "End_S_global_Ext": global_end["h1"], "Hom_star_global_Ext": dim_ext,
        },
    }


# ===========================================================================
# Assemble the seven-gate verdict.
# ===========================================================================

def build_certificate():
    code = part_a_code_flag()
    generators_perm = [point_permutation((1, 1, 0, 1), Q), point_permutation((0, Q - 1, 1, 0), Q)]
    ident = tuple(range(DEGREE))
    group = enumerate_group(generators_perm, DEGREE)
    obstruction = part_b_group_obstruction(group, ident)
    sylow2_generators = obstruction.pop("_sylow2_generators")
    carrier = part_c_carrier(group, ident, sylow2_generators)

    realizable = obstruction["degree_23_realizability"]["transitive_action_of_degree_23_exists"]

    gates = {
        "gate_1_semisimple_line": {
            "statement": "|Omega| is nonzero in k",
            "code_side": "on the 23 Golay coordinates |Omega| = 23 = 1 != 0 in F_2 (arithmetic holds)",
            "group_side": "no PSL_2(23)-set of odd size 23 exists (min faithful degree 24 = 0 in F_2; "
                          "no degree-23 action)",
            "code_arithmetic_pass": code["gate1_arithmetic_pass"],
            "perfect_code_bridge_instantiable": realizable,
            "verdict": "PASS (arithmetic) / BLOCKED as a perfect-code bridge (no odd G-set for PSL_2(23))",
        },
        "gate_2_cross_code": {
            "statement": "D = k1 (+) S and S = D^perp, [23,12,7]",
            "dimensions_S_D_A": [code["expurgated_core_S"]["dimension"],
                                 code["augmented_code_D"]["dimension"],
                                 code["augmentation_module_A"]["dimension"]],
            "verdict": "PASS" if code["gate2_pass"] else "FAIL",
        },
        "gate_3_nonsplitting": {"verdict": "PASS (abstract carrier)" if carrier["gate_3_nonsplitting"]["pass"] else "FAIL",
                                "carrier_detail": carrier["gate_3_nonsplitting"],
                                "bridge_note": "the size-23 permutation augmentation used in the proved rows "
                                               "does not exist for PSL_2(23)"},
        "gate_4_local_picard": {"verdict": "PASS (abstract carrier)" if carrier["gate_4_local_picard"]["pass"] else "FAIL",
                                "carrier_detail": carrier["gate_4_local_picard"]},
        "gate_5_fusion_descent": {"verdict": "PASS (abstract carrier)" if carrier["gate_5_fusion_descent"]["pass"] else "FAIL",
                                  "carrier_detail": carrier["gate_5_fusion_descent"]},
        "gate_6_simple_core": {"verdict": "PASS (abstract carrier)" if carrier["gate_6_simple_core"]["pass"] else "FAIL",
                               "carrier_detail": carrier["gate_6_simple_core"]},
        "gate_7_rigidity": {"verdict": "PASS (abstract carrier)" if carrier["gate_7_rigidity"]["pass"] else "FAIL",
                            "carrier_detail": carrier["gate_7_rigidity"]},
    }

    group_side_all_pass = all(carrier[k]["pass"] for k in
                              ("gate_3_nonsplitting", "gate_4_local_picard", "gate_5_fusion_descent",
                               "gate_6_simple_core", "gate_7_rigidity"))

    conclusion = (
        "Split verdict. (i) The binary Golay [23,12,7] passes the pure-F_2 code flag (gates 1-2). "
        "(ii) The perfect-code -> carrier BRIDGE used in the proved q=7/q=11 rows is NOT instantiable "
        "for PSL_2(23): that group has no permutation action of degree 23 (no index-23 subgroup; "
        "Galois), so there is no odd-size G-set carrying the code and the literal construction is "
        "blocked. (iii) The CARRIER itself does extend: the genuine 11-dimensional PSL_2(23)-module "
        "S = C/<1> from the extended Golay [24,12,8], which has the true dihedral D8 Sylow, passes "
        "every group-side gate 3-7 -- S and S^* are non-isomorphic simples, End = F_2, End_0(S) is "
        "free on the D8 Sylow (norm rank 15 = 120/8), and a DIRECT global computation of "
        "H^1(PSL_2(23), Hom(S^*,S)) over all 6072 elements gives dim Ext^1(S^*,S) = 1 (Z^1=122, "
        "B^1=121), certifying existence of a nonsplit extension (gate 3, with an explicit nonzero "
        "cocycle) and its uniqueness (gate 5). The even-parity heart H = A24/<1> that would take the "
        "augmentation's slot SPLITS (End_G(H)=2, H = S (+) S^*); the nonsplit carrier is not that "
        "module. Bonus: dim H^1(G, End S) = 0, so S has no self-extensions. So the endotrivial-carrier mechanism "
        "recognizes all three nontrivial perfect codes, but the perfect-code-as-permutation-sheet "
        "packaging is available only for the Galois primes q in {5,7,11}."
    )

    mystery = {
        "m_definition": "m = (q+1)/4, constant of alpha^2 + alpha + (q+1)/4 = 0",
        "m_at_q23": (Q + 1) // 4, "m_at_q23_is_composite": True,
        "proved_rows_m": {"q7": 2, "q11": 3},
        "resolution": (
            "First horn of the designed experiment (brief section 5): q=23 PASSES the Sylow/fusion "
            "gates on the genuine carrier despite composite m = 6, so the 'period polynomial and Gram "
            "both degenerate at m' coincidence is DECORATIVE. The load-bearing mechanism is local "
            "endotriviality (D8-Sylow projectivity), which is characteristic-driven and independent of "
            "m; that m = p is prime in the two proved rows (m=2 at q=7, m=3 at q=11) is a numerical "
            "shadow, not a hypothesis. Separately, the perfect-code permutation bridge fails at q=23 "
            "for an unrelated reason: Galois-primality of q (a degree-q action exists only for "
            "q in {5,7,11}). Two phenomena that coincided at q=7,11 -- endotriviality and odd-set "
            "code realizability -- are thereby separated, converting the standing mystery-ledger row "
            "into a theorem-shaped statement."
        ),
    }

    return {
        "schema": "c488-qr-ladder-q23-rung-v1", "task": "C488", "lane": "crowns",
        "field": FIELD, "q": Q,
        "gate_numbering_note": "theorem gates 1-7; the C488 queue's 'gates 4-7' = theorem gates 3-7",
        "code_flag": code,
        "group_obstruction": obstruction,
        "carrier_module": carrier,
        "gates": gates,
        "overall_verdict": "SPLIT: gates 1-2 pass; perfect-code bridge blocked (Galois); "
                           "group-side carrier gates 3-7 pass on the genuine PSL_2(23)-module",
        "carrier_mechanism_extends_to_q23": group_side_all_pass,
        "perfect_code_permutation_bridge_extends_to_q23": realizable,
        "family_theorem_perfect_code_permutation_carrier": realizable,
        "theorem_conclusion": conclusion,
        "m_mystery": mystery,
        "trusted_boundary": [
            "exact F_2 linear algebra (bit-integer codewords and dense matrices)",
            "complete deterministic enumeration of PSL_2(23) from two generators",
            "exhaustive enumeration of the subgroups of order <= 264 above a fixed Sylow-2 "
            "(abort-at-264 closure is sound: an order-264 subgroup is reached through its own smaller "
            "subgroups, none aborted)",
            "gate 4 free-module test by the norm-rank criterion for a 2-group",
            "gates 3 and 5 by a DIRECT global H^1(PSL_2(23), Hom(S^*,S)) over all 6072 elements via "
            "the Cayley-graph Z^1/B^1 rank route (coefficient action F -> g F g^T); this certifies "
            "existence and dim = 1 unconditionally. The local D8 H^1 and fusion profile are recorded "
            "as corroborating structure only, not as the load-bearing inference",
            "the even-parity heart H = A24/<1> and its equivariant retraction solver (same solver "
            "shape as the proved rows' gate 3)",
        ],
        "not_certified": [
            "the binary Golay as an M23-module (M23 is the full permutation automorphism group; its "
            "Sylow-2 has order 128, a different, larger mechanism outside the PSL_2(q) family)",
        ],
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true",
                        help="regenerate into a tempdir and verify hashes without touching the worktree")
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            probe = Path(tmp) / OUT.name
            probe.write_bytes(data)
            regenerated = hashlib.sha256(probe.read_bytes()).hexdigest()
        committed = hashlib.sha256(OUT.read_bytes()).hexdigest()
        assert OUT.read_bytes() == data, "regenerated certificate differs from committed bytes"
        assert regenerated == committed, "regenerated hash differs from committed hash"
        print(f"checked {OUT.relative_to(ROOT)} ({len(data)} bytes, sha256 {committed})")
    else:
        with tempfile.NamedTemporaryFile(dir=OUT.parent, delete=False) as handle:
            handle.write(data)
            temp = Path(handle.name)
        temp.replace(OUT)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
