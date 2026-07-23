#!/usr/bin/env python3
"""C501 hexad outer-bit certification battery: primary generator/checker.

Run from /home/tavis/src/othello:
  python3 notes/2026-07-22-c501-hexad-outer-bit-explore.py
  python3 notes/2026-07-22-c501-hexad-outer-bit-explore.py --check

The computation is deterministic and uses exact integer and F_3 arithmetic.
"""
from collections import Counter, deque
import hashlib
import itertools
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
STEM = "2026-07-22-c501-hexad-outer-bit-explore"
INPUT_NAMES = [
    "2026-07-22-c471-hadamard-degeneration-complex.json",
    "2026-07-22-c472-signed-weil-lift.json",
    "2026-07-22-c489-maslov-roof-staged.json",
]
OUT = os.path.join(HERE, STEM + ".json")
P = 3
N = 12
IDP = tuple(range(N))


def digest(path):
    data = open(path, "rb").read()
    return {"sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}


def canonical(obj):
    return json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=True) + "\n"


def rref(rows):
    if not rows:
        return []
    a = [[x % P for x in row] for row in rows if any(x % P for x in row)]
    if not a:
        return []
    r = 0
    for c in range(len(a[0])):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = pow(a[r][c], -1, P)
        a[r] = [(z * x) % P for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][c]:
                z = a[i][c]
                a[i] = [(x - z * y) % P for x, y in zip(a[i], a[r])]
        r += 1
    return a[:r]


def null_basis(rows):
    cols = len(rows[0])
    a = [[x % P for x in row] for row in rows]
    pivot_cols = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = pow(a[r][c], -1, P)
        a[r] = [(z * x) % P for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][c]:
                z = a[i][c]
                a[i] = [(x - z * y) % P for x, y in zip(a[i], a[r])]
        pivot_cols.append(c)
        r += 1
    out = []
    for free in (c for c in range(cols) if c not in pivot_cols):
        v = [0] * cols
        v[free] = 1
        for i, pivot in enumerate(pivot_cols):
            v[pivot] = (-a[i][free]) % P
        out.append(v)
    return out


def span(basis):
    return {
        tuple(sum(c[k] * basis[k][j] for k in range(len(basis))) % P
              for j in range(len(basis[0])))
        for c in itertools.product(range(P), repeat=len(basis))
    }


def intersect(A, B):
    d = len(A[0])
    equations = [
        [A[k][i] for k in range(len(A))]
        + [(-B[k][i]) % P for k in range(len(B))]
        for i in range(d)
    ]
    vectors = []
    for coeffs in null_basis(equations):
        v = [sum(coeffs[k] * A[k][i] for k in range(len(A))) % P
             for i in range(d)]
        if any(v):
            vectors.append(v)
    return rref(vectors)


def mm(A, B, modulus=None):
    out = [
        [sum(A[i][k] * B[k][j] for k in range(len(B)))
         for j in range(len(B[0]))]
        for i in range(len(A))
    ]
    if modulus is not None:
        out = [[x % modulus for x in row] for row in out]
    return out


def transpose(A):
    return [list(row) for row in zip(*A)]


def permutation_matrix(p):
    A = [[0] * len(p) for _ in p]
    for i, j in enumerate(p):
        A[j][i] = 1
    return A


def pcompose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def pinverse(p):
    out = [0] * len(p)
    for i, j in enumerate(p):
        out[j] = i
    return tuple(out)


def permutation_order(p):
    x = IDP
    for k in range(1, 100):
        x = pcompose(p, x)
        if x == IDP:
            return k
    raise AssertionError("permutation order bound")


def permutation_group(generators):
    group = {IDP}
    queue = deque([IDP])
    while queue:
        x = queue.popleft()
        for g in generators:
            y = pcompose(g, x)
            if y not in group:
                group.add(y)
                queue.append(y)
    return group


def monomial_parts(A):
    perm, signs = [], []
    for j in range(len(A)):
        nz = [i for i in range(len(A)) if A[i][j]]
        assert len(nz) == 1 and abs(A[nz[0]][j]) == 1
        perm.append(nz[0])
        signs.append(A[nz[0]][j])
    return tuple(perm), tuple(signs)


def act_support(p, support):
    return frozenset(p[i] for i in support)


def orbit(seed, generators):
    out = {seed}
    queue = deque([seed])
    while queue:
        x = queue.popleft()
        for g in generators:
            y = act_support(g, x)
            if y not in out:
                out.add(y)
                queue.append(y)
    return out


def support_orbits(supports, generators):
    remaining, out = set(supports), []
    while remaining:
        orb = orbit(min(remaining, key=lambda x: tuple(sorted(x))), generators)
        out.append(orb)
        remaining -= orb
    return out


def conjugacy_class(group, subgroup):
    return {
        frozenset(pcompose(pcompose(g, h), pinverse(g)) for h in subgroup)
        for g in group
    }


def signed_compose(left, right):
    lp, lm = left
    rp, rm = right
    perm = tuple(lp[rp[i]] for i in range(N))
    mask = rm
    for old in range(N):
        if (lm >> rp[old]) & 1:
            mask ^= 1 << old
    return perm, mask


def signed_inverse(element):
    p, mask = element
    ip = pinverse(p)
    inverse_mask = 0
    for old in range(N):
        if (mask >> old) & 1:
            inverse_mask |= 1 << p[old]
    return ip, inverse_mask


def signed_group(generators):
    identity = (IDP, 0)
    group = {identity}
    queue = deque([identity])
    while queue:
        x = queue.popleft()
        for g in generators:
            y = signed_compose(g, x)
            if y not in group:
                group.add(y)
                queue.append(y)
    return group


def signed_action(element, v):
    p, mask = element
    out = [0] * N
    for i in range(N):
        out[p[i]] = ((2 if (mask >> i) & 1 else 1) * v[i]) % P
    return out


def bilinear(B, x, y):
    return sum(x[i] * B[i][j] * y[j]
               for i in range(len(x)) for j in range(len(y))) % P


def invariant_form_dimension(generators, alternating=False):
    equations = []
    for p, mask in generators:
        R = [[0] * N for _ in range(N)]
        for i in range(N):
            R[p[i]][i] = 2 if (mask >> i) & 1 else 1
        for a in range(N):
            for b in range(N):
                row = [0] * (N * N)
                for i in range(N):
                    if not R[i][a]:
                        continue
                    for j in range(N):
                        if R[j][b]:
                            row[i * N + j] = (
                                row[i * N + j] + R[i][a] * R[j][b]
                            ) % P
                row[a * N + b] = (row[a * N + b] - 1) % P
                equations.append(row)
    if alternating:
        for i in range(N):
            for j in range(N):
                row = [0] * (N * N)
                row[i * N + j] = (row[i * N + j] + 1) % P
                row[j * N + i] = (row[j * N + i] + 1) % P
                equations.append(row)
    return len(null_basis(equations))


def determinant(A):
    A = [[x % P for x in row] for row in A]
    out = 1
    for c in range(len(A)):
        pivot = next((i for i in range(c, len(A)) if A[i][c]), None)
        if pivot is None:
            return 0
        if pivot != c:
            A[c], A[pivot] = A[pivot], A[c]
            out = (-out) % P
        out = out * A[c][c] % P
        z = pow(A[c][c], -1, P)
        A[c] = [(z * x) % P for x in A[c]]
        for i in range(c + 1, len(A)):
            if A[i][c]:
                z = A[i][c]
                A[i] = [(x - z * y) % P for x, y in zip(A[i], A[c])]
    return out


def quotient_data(W):
    radical = rref(null_basis(W))
    pivots = [next(i for i, x in enumerate(row) if x) for row in radical]
    free = [i for i in range(N) if i not in pivots]

    def reduce_vector(v):
        v = [x % P for x in v]
        for row, pivot in zip(radical, pivots):
            z = v[pivot]
            if z:
                v = [(x - z * y) % P for x, y in zip(v, row)]
        return [v[i] for i in free]

    lifts = []
    for i in free:
        e = [0] * N
        e[i] = 1
        lifts.append(e)
    Wq = [[bilinear(W, x, y) for y in lifts] for x in lifts]
    return radical, free, reduce_vector, Wq


def is_isotropic(B, basis):
    return all(bilinear(B, x, y) == 0 for x in basis for y in basis)


def witt_class(S):
    """Return (class in W(F_3)=Z/4, nondegenerate rank) by congruence reduction."""
    S0 = [[x % P for x in row] for row in S]
    n = len(S0)

    def b(x, y):
        return bilinear(S0, x, y)

    remaining = [[int(i == j) for j in range(n)] for i in range(n)]
    diagonal = []
    while remaining:
        v = next((x for x in remaining if b(x, x)), None)
        if v is None:
            pair = next(
                ((x, y) for i, x in enumerate(remaining)
                 for y in remaining[i + 1:] if b(x, y)),
                None,
            )
            if pair is None:
                break
            x, y = pair
            v = [(a + c) % P for a, c in zip(x, y)]
            if not b(v, v):
                v = [(a + 2 * c) % P for a, c in zip(x, y)]
        d = b(v, v)
        diagonal.append(d)
        next_space = []
        for x in remaining:
            z = b(x, v) * pow(d, -1, P) % P
            y = [(a - z * c) % P for a, c in zip(x, v)]
            if any(y):
                next_space.append(y)
        remaining = rref(next_space)
    return (
        (sum(d == 1 for d in diagonal) - sum(d == 2 for d in diagonal)) % 4,
        len(diagonal),
    )


def kashiwara(W, L1, L2, L3):
    tagged = [(0, v) for v in L1] + [(1, v) for v in L2] + [(2, v) for v in L3]
    n = len(tagged)

    def component(coeffs, tag):
        return [
            sum(coeffs[k] * tagged[k][1][i]
                for k in range(n) if tagged[k][0] == tag) % P
            for i in range(len(W))
        ]

    def q(coeffs):
        x1, x2, x3 = (component(coeffs, tag) for tag in range(3))
        return (
            bilinear(W, x1, x2)
            + bilinear(W, x2, x3)
            + bilinear(W, x3, x1)
        ) % P

    gram = [[0] * n for _ in range(n)]
    qe = []
    for i in range(n):
        e = [0] * n
        e[i] = 1
        qe.append(q(e))
    for i in range(n):
        gram[i][i] = qe[i]
        for j in range(i + 1, n):
            e = [0] * n
            e[i] = e[j] = 1
            gram[i][j] = gram[j][i] = (q(e) - qe[i] - qe[j]) * 2 % P
    return witt_class(gram)


def symplectic_basis(W):
    n = len(W)
    remaining = [[int(i == j) for j in range(n)] for i in range(n)]
    pairs = []
    while remaining:
        e = remaining[0]
        f = next(x for x in remaining if bilinear(W, e, x))
        z = pow(bilinear(W, e, f), -1, P)
        f = [(z * x) % P for x in f]
        pairs.append((e, f))
        reduced = []
        for x in remaining:
            y = [
                (x[i] - bilinear(W, x, f) * e[i]
                 + bilinear(W, x, e) * f[i]) % P
                for i in range(n)
            ]
            if any(y):
                reduced.append(y)
        remaining = rref(reduced)
    return pairs


def build():
    paths = {name: os.path.join(HERE, name) for name in INPUT_NAMES}
    C471, C472, C489 = (json.load(open(paths[name])) for name in INPUT_NAMES)
    assert C489["task"].startswith("C489")
    H = C471["integral_matrix_factorization"]["hadamard_matrix_H"]
    Ht = transpose(H)
    KB = C471["mod_3_exact_complex"]["kernel_H_basis_rref"]
    KBt = C471["mod_3_exact_complex"]["kernel_Ht_basis_rref"]
    K1, K2 = span(KB), span(KBt)
    common = intersect(KB, KBt)
    assert len(common) == 1
    s = min((tuple((a * x) % P for x in common[0]) for a in (1, 2)))
    hexad = frozenset(i for i, x in enumerate(s) if x)
    assert len(hexad) == 6

    pure = C472["full_preimage"]["literal_complement_generators"]
    Tperm = tuple(pure["T"]["permutation"])
    Sperm = tuple(pure["S"]["permutation"])
    Gamma = permutation_group([Tperm, Sperm])
    assert len(Gamma) == 660

    def row_transport(p):
        numerator = mm(mm(H, permutation_matrix(p)), Ht)
        assert all(x % 12 == 0 for row in numerator for x in row)
        return [[x // 12 for x in row] for row in numerator]

    rho = {g: monomial_parts(row_transport(g))[0] for g in Gamma}
    assert len(set(rho.values())) == 660
    assert all(
        rho[pcompose(x, y)] == pcompose(rho[x], rho[y])
        for x in Gamma for y in (Tperm, Sperm)
    )
    fixed_col = [i for i in range(N) if all(g[i] == i for g in Gamma)]
    fixed_row = [i for i in range(N) if all(rho[g][i] == i for g in Gamma)]

    col_stab = frozenset(g for g in Gamma if act_support(g, hexad) == hexad)
    row_stab = frozenset(g for g in Gamma if act_support(rho[g], hexad) == hexad)
    col_class = conjugacy_class(Gamma, col_stab)
    row_class = conjugacy_class(Gamma, row_stab)
    assert len(col_stab) == len(row_stab) == 60
    assert len(col_class) == len(row_class) == 11
    assert row_stab not in col_class

    theta_solutions = []
    for a in range(1, 11):
        for b in range(11):
            beta = [None] * N
            beta[0] = 11
            for j in range(1, 12):
                beta[j] = (a * (j - 1) + b) % 11
            beta = tuple(beta)
            beta_inv = pinverse(beta)

            def theta(g):
                return pcompose(pcompose(beta, rho[g]), beta_inv)

            if theta(Tperm) in Gamma and theta(Sperm) in Gamma:
                theta_solutions.append((a, b, beta))
    assert len(theta_solutions) == 55
    theta_slope_counts = Counter(a for a, _, _ in theta_solutions)
    assert set(theta_slope_counts.values()) == {11}
    assert set(theta_slope_counts) in (
        {1, 3, 4, 5, 9},
        {2, 6, 7, 8, 10},
    )
    inner_generator_pairs = {
        (
            pcompose(pcompose(x, Tperm), pinverse(x)),
            pcompose(pcompose(x, Sperm), pinverse(x)),
        )
        for x in Gamma
    }
    theta_inner_count = 0
    theta_class_swap_count = 0
    for _, _, beta_i in theta_solutions:
        beta_i_inv = pinverse(beta_i)

        def theta_i(g):
            return pcompose(pcompose(beta_i, rho[g]), beta_i_inv)

        theta_inner_count += (theta_i(Tperm), theta_i(Sperm)) in inner_generator_pairs
        theta_class_swap_count += frozenset(theta_i(g) for g in col_stab) in row_class
    assert theta_inner_count == 0 and theta_class_swap_count == 55
    all_conjugating_relabelings = {
        pcompose(g, theta_solutions[0][2]) for g in Gamma
    }
    assert len(all_conjugating_relabelings) == 660
    assert all(
        pcompose(pcompose(beta_i, rho[g]), pinverse(beta_i)) in Gamma
        for beta_i in all_conjugating_relabelings for g in (Tperm, Sperm)
    )
    a0, b0, beta = theta_solutions[0]
    beta_inv = pinverse(beta)

    def theta(g):
        return pcompose(pcompose(beta, rho[g]), beta_inv)

    assert {theta(g) for g in Gamma} == Gamma
    inner = any(
        all(theta(g) == pcompose(pcompose(x, g), pinverse(x))
            for g in (Tperm, Sperm))
        for x in Gamma
    )
    theta_col_stab = frozenset(theta(g) for g in col_stab)
    assert not inner and theta_col_stab in row_class

    def order_census(subgroup):
        return {str(k): v for k, v in sorted(
            Counter(permutation_order(g) for g in subgroup).items()
        )}

    col_hexads = {
        frozenset(i for i, x in enumerate(v) if x)
        for v in K1 if sum(bool(x) for x in v) == 6
    }
    row_hexads = {
        frozenset(i for i, x in enumerate(v) if x)
        for v in K2 if sum(bool(x) for x in v) == 6
    }
    col_orbits = support_orbits(col_hexads, [Tperm, Sperm])
    row_orbits = support_orbits(row_hexads, [rho[Tperm], rho[Sperm]])
    col_11 = [orb for orb in col_orbits if len(orb) == 11]
    row_11 = [orb for orb in row_orbits if len(orb) == 11]
    fixed_by_col = sorted(
        [sorted(h) for h in col_hexads
         if all(act_support(g, h) == h for g in col_stab)]
    )
    fixed_by_row_on_col = [
        h for h in col_hexads if all(act_support(g, h) == h for g in row_stab)
    ]
    assert len(col_hexads) == len(row_hexads) == 132
    assert sorted(map(len, col_orbits)) == sorted(map(len, row_orbits)) == [11, 11, 55, 55]
    assert len(fixed_by_col) == 2 and not fixed_by_row_on_col
    assert set(fixed_by_col[0]).isdisjoint(fixed_by_col[1])

    # A5 certificate: order census and faithful even index-five coset action.
    involutions = [g for g in col_stab if permutation_order(g) == 2]
    sylow2 = next(
        {IDP, x, y, pcompose(x, y)}
        for x, y in itertools.combinations(involutions, 2)
        if pcompose(x, y) == pcompose(y, x)
    )
    normalizer_sylow2 = [
        g for g in col_stab
        if all(pcompose(pcompose(g, x), pinverse(g)) in sylow2 for x in sylow2)
    ]
    cosets = []
    for g in sorted(col_stab):
        coset = frozenset(pcompose(g, n) for n in normalizer_sylow2)
        if coset not in cosets:
            cosets.append(coset)

    def coset_action(g):
        return tuple(cosets.index(frozenset(pcompose(g, x) for x in coset))
                     for coset in cosets)

    coset_image = {coset_action(g) for g in col_stab}

    def parity(p):
        return sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p))) % 2

    assert len(normalizer_sylow2) == 12
    assert len(cosets) == 5 and len(coset_image) == 60
    assert all(parity(p) == 0 for p in coset_image)

    # Ambient normalizer inside C472's full signed group.
    gluing = C472["two_parent_signed_gluing"]
    signed_gens = [
        (tuple(g["permutation"]), g["sign_mask"])
        for parent in ("coordinate_oriented_parent", "row_oriented_parent")
        for g in gluing[parent]["generators"]
    ]
    signed_ambient = signed_group(signed_gens)
    assert len(signed_ambient) == 190080
    all_parent_generators_fix_K1 = all(
        rref([signed_action(g, row) for row in KB]) == rref(KB)
        for g in signed_gens
    )
    assert all_parent_generators_fix_K1
    frozen_signed = {(g, 0) for g in Gamma}
    normalizer = []
    for x in signed_ambient:
        xi = signed_inverse(x)
        if all(
            signed_compose(signed_compose(x, (g, 0)), xi) in frozen_signed
            for g in (Tperm, Sperm)
        ):
            normalizer.append(x)
    assert len(normalizer) == 1320
    assert set(normalizer) == {(g, m) for g in Gamma for m in (0, (1 << N) - 1)}
    induced_pairs = {
        (
            signed_compose(signed_compose(x, (Tperm, 0)), signed_inverse(x))[0],
            signed_compose(signed_compose(x, (Sperm, 0)), signed_inverse(x))[0],
        )
        for x in normalizer
    }
    inner_pairs = {
        (
            pcompose(pcompose(x, Tperm), pinverse(x)),
            pcompose(pcompose(x, Sperm), pinverse(x)),
        )
        for x in Gamma
    }
    assert induced_pairs == inner_pairs

    # Canonical alternating repair and its quotient.
    W = [[(H[i][j] - H[j][i]) % P for j in range(N)] for i in range(N)]
    radical, quotient_coordinates, reduce_vector, Wq = quotient_data(W)
    assert len(rref(W)) == 10 and len(radical) == 2
    assert rref(radical + [list(s)]) == radical
    L1q = rref([reduce_vector(v) for v in KB])
    L2q = rref([reduce_vector(v) for v in KBt])
    ell = intersect(L1q, L2q)
    assert len(L1q) == len(L2q) == 5 and len(ell) == 1
    assert is_isotropic(Wq, L1q) and is_isotropic(Wq, L2q)
    other_radical = next(row for row in radical if rref([row, list(s)]) != rref([list(s)]))
    radical_coset_weights = sorted(
        sum(bool((other_radical[i] + c * s[i]) % P) for i in range(N))
        for c in range(P)
    )

    # Candidate third spaces.
    shortened = C471["puncture_shorten_bridge"]["shortened_basis_rref"]
    shortened_q = rref([reduce_vector(row + [0]) for row in shortened])
    mirror = [[(x * (2 if i == 11 else 1)) % P for i, x in enumerate(row)] for row in KB]
    mirror_q = rref([reduce_vector(row) for row in mirror])

    def Hmul(v):
        return [sum(H[i][j] * v[j] for j in range(N)) for i in range(N)]

    graph_results = {}
    for lam in (1, 2):
        graphs = []
        for signed_lift in (False, True):
            graph = []
            for row in KB:
                lift = [x if (not signed_lift or x != 2) else -1 for x in row]
                image = Hmul(lift)
                assert all(x % P == 0 for x in image)
                beta_H = [(x // P) % P for x in image]
                graph.append([(row[i] + lam * beta_H[i]) % P for i in range(N)])
            graphs.append(graph)
        graph_q = rref([reduce_vector(row) for row in graphs[0]])
        graph_results[str(lam)] = {
            "ambient_dimension": len(rref(graphs[0])),
            "quotient_dimension": len(graph_q),
            "omega_isotropic": is_isotropic(Wq, graph_q),
            "dot_isotropic": all(
                sum(x[i] * y[i] for i in range(N)) % P == 0
                for x in graphs[0] for y in graphs[0]
            ),
            "lift_independent": rref(graphs[0]) == rref(graphs[1]),
        }

    Hmod = [[x % P for x in row] for row in H]
    plus = [[(Hmod[i][j] + Hmod[j][i]) % P for j in range(N)] for i in range(N)]
    H2 = mm(Hmod, Hmod, P)
    candidate_spaces = {
        "extended_shortened_S11": {
            "quotient_dimension": len(shortened_q),
            "equals_L1": shortened_q == L1q,
        },
        "parity_mirror": {
            "quotient_dimension": len(mirror_q),
            "omega_isotropic": is_isotropic(Wq, mirror_q),
        },
        "ker_H_plus_Ht": {
            "ambient_dimension": len(null_basis(plus)),
            "quotient_dimension": len(rref([reduce_vector(v) for v in null_basis(plus)])),
        },
        "ker_H_squared": {"ambient_dimension": len(null_basis(H2))},
        "H_eigenspaces": {
            "plus_one_dimension": len(null_basis([
                [(Hmod[i][j] - int(i == j)) % P for j in range(N)] for i in range(N)
            ])),
            "minus_one_dimension": len(null_basis([
                [(Hmod[i][j] + int(i == j)) % P for j in range(N)] for i in range(N)
            ])),
        },
        "divided_operator_graphs": graph_results,
    }

    # Capacity demonstration over graph Lagrangians in a symplectic basis.
    pairs = symplectic_basis(Wq)
    assert len(pairs) == 5
    E, F = zip(*pairs)
    samples = [
        (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 0, 0, 0),
        (1, 1, 1, 0, 0), (2, 0, 0, 0, 0), (1, 1, 1, 1, 1),
        (2, 2, 2, 2, 2), (1, 2, 0, 0, 0),
    ]
    tau_samples = {}
    for diagonal in samples:
        L3 = rref([
            [(E[k][i] + diagonal[k] * F[k][i]) % P for i in range(10)]
            for k in range(5)
        ])
        tau_samples["".join(map(str, diagonal))] = list(kashiwara(Wq, L1q, L2q, L3))
    assert {value[0] for value in tau_samples.values()} == {0, 1, 2, 3}
    assert kashiwara(Wq, L1q, L2q, L1q)[0] == 0

    # C472 central loop.
    word = gluing["central_witness_word_generator_indices"]
    current = (IDP, 0)
    chain = [L1q]
    ambient_chain_dimensions = [len(KB)]
    radical_intersections = [len(intersect(KB, radical))]
    for index in word:
        current = signed_compose(signed_gens[index], current)
        image = rref([signed_action(current, row) for row in KB])
        ambient_chain_dimensions.append(len(image))
        radical_intersections.append(len(intersect(image, radical)))
        image_q = rref([reduce_vector(row) for row in image])
        assert len(image_q) == 5 and is_isotropic(Wq, image_q)
        chain.append(image_q)
    assert current == (IDP, (1 << N) - 1)
    assert chain[-1] == chain[0]
    kernel_pivots = [next(i for i, x in enumerate(row) if x) for row in rref(KB)]
    restricted_holonomy = [
        [signed_action(current, row)[pivot] for pivot in kernel_pivots]
        for row in rref(KB)
    ]
    minus_identity_six = [
        [2 if i == j else 0 for j in range(len(KB))] for i in range(len(KB))
    ]
    assert restricted_holonomy == minus_identity_six
    restricted_determinant = determinant(restricted_holonomy)
    assert restricted_determinant == 1
    fan_terms = [kashiwara(Wq, chain[0], chain[k], chain[k + 1])
                 for k in range(len(word))]
    loop_class = sum(term[0] for term in fan_terms) % 4
    other_chain_keys = sorted({str(L) for L in chain if L != L1q and L != L2q})
    chain_labels = [
        "L1" if L == L1q else "L2" if L == L2q else f"X{other_chain_keys.index(str(L)) + 1}"
        for L in chain
    ]
    adjacent_intersections = [
        len(intersect(chain[k], chain[k + 1])) for k in range(len(word))
    ]

    # The full signed group preserves only the dot form, not an alternating form.
    invariant_bilinear_dim = invariant_form_dimension(signed_gens)
    invariant_alternating_dim = invariant_form_dimension(signed_gens, alternating=True)
    frozen_alternating_dim = invariant_form_dimension([(Tperm, 0), (Sperm, 0)], alternating=True)
    assert invariant_bilinear_dim == 1 and invariant_alternating_dim == 0

    return {
        "schema": "c501-hexad-outer-bit-explore-v1",
        "task": "C501",
        "inputs": {name: digest(path) for name, path in paths.items()},
        "conventions": {
            "field": "F_3 represented by integers 0,1,2",
            "permutations": "old-to-new arrays; compose(left,right)[i]=left[right[i]]",
            "signed_masks": "bit i negates old coordinate i before permutation",
            "row_transport": "M(g)=H R(g) H^T/12",
            "witt_group": "W(F_3)=Z/4 generated by <1>; <2>=-<1>",
            "loop_index": "fan sum sum_k tau(L0,Lk,L{k+1}) for k=0,...,7",
        },
        "leg0_canonicity": {
            "shared_line_rref": common,
            "canonical_projective_generator": list(s),
            "hexad": sorted(hexad),
            "ambient_signed_group_order": len(signed_ambient),
            "normalizer_order": len(normalizer),
            "normalizer_is_scalar_times_Gamma": True,
            "normalizer_induced_automorphisms": "all inner",
            "binary_residue": "column and row stabilizers lie in opposite A5 classes",
        },
        "leg1_outer_swap": {
            "Gamma_order": len(Gamma),
            "fixed_points": {"column": fixed_col, "row": fixed_row},
            "hexad_counts": {"column": len(col_hexads), "row": len(row_hexads)},
            "orbit_sizes": {
                "column": sorted(map(len, col_orbits)),
                "row": sorted(map(len, row_orbits)),
            },
            "column_stabilizer": {
                "order": len(col_stab),
                "order_census": order_census(col_stab),
                "conjugacy_class_size": len(col_class),
                "index_five_action_image_order": len(coset_image),
                "index_five_action_all_even": True,
            },
            "row_stabilizer": {
                "order": len(row_stab),
                "order_census": order_census(row_stab),
                "conjugacy_class_size": len(row_class),
            },
            "intersection_order": len(col_stab & row_stab),
            "intersection_order_census": order_census(col_stab & row_stab),
            "classes_equal": False,
            "relabelings_realizing_automorphism": len(theta_solutions),
            "affine_relabelings_tested": 110,
            "affine_relabelings_realizing_outer_automorphism": len(theta_solutions),
            "all_conjugating_relabelings_count": len(all_conjugating_relabelings),
            "relabeling_slope_counts": {
                str(a): theta_slope_counts[a] for a in sorted(theta_slope_counts)
            },
            "first_relabeling": {"a": a0, "b": b0, "old_row_to_coordinate": list(beta)},
            "automorphism_inner": False,
            "automorphism_maps_column_class_to_row_class": True,
            "all_relabelings_outer": theta_inner_count == 0,
            "all_relabelings_swap_classes": theta_class_swap_count == len(theta_solutions),
            "column_hexads_fixed_by_column_stabilizer": fixed_by_col,
            "column_hexads_fixed_by_opposite_class": 0,
            "correction": (
                "The two column 11-orbits are complement-paired and use the same A5 class; "
                "the invariant is the relative outer class of the column and row degree-11 "
                "actions, with the common hexad as a canonical local witness."
            ),
        },
        "leg2_triple_index": {
            "symmetric_dot_reading": {
                "class": 0,
                "reason": (
                    "For x=x1+x2 in an isotropic L3, "
                    "0=b(x,x)=2b(x1,x2), so the triple form vanishes."
                ),
            },
            "canonical_alternating_repair": {
                "definition": "omega=(H-H^T) mod 3",
                "rank": len(rref(W)),
                "radical_basis_rref": radical,
                "shared_line_in_radical": True,
                "other_radical_coset_weights_mod_shared_line": radical_coset_weights,
                "quotient_coordinates": quotient_coordinates,
                "quotient_dimension": len(Wq),
                "L1_dimension": len(L1q),
                "L2_dimension": len(L2q),
                "intersection_dimension": len(ell),
                "intersection_rref": ell,
            },
            "candidate_third_spaces": candidate_spaces,
            "capacity_sample_tau_class_and_rank": tau_samples,
            "sample_classes_observed": sorted({value[0] for value in tau_samples.values()}),
            "verdict": (
                "The literal symmetric index is zero. The canonical alternating repair has "
                "full Z/4 capacity, but none of the task's canonical standalone L3 candidates "
                "selects a new quotient Lagrangian."
            ),
        },
        "leg3_central_scalar": {
            "word": word,
            "word_product": {"permutation": list(current[0]), "sign_mask": current[1]},
            "partial_code_dimensions": ambient_chain_dimensions,
            "partial_code_radical_intersection_dimensions": radical_intersections,
            "all_ten_parent_generators_fix_ker_H": all_parent_generators_fix_K1,
            "all_partial_codes_descend_to_Lagrangians": True,
            "distinct_quotient_lagrangians": len({str(L) for L in chain}),
            "quotient_lagrangian_labels": chain_labels,
            "adjacent_intersection_dimensions": adjacent_intersections,
            "fan_terms_class_and_rank": [list(term) for term in fan_terms],
            "loop_witt_class": loop_class,
            "loop_phase_minus_one_if_class_two": loop_class == 2,
            "restricted_GL6_holonomy": restricted_holonomy,
            "restricted_GL6_holonomy_is_minus_identity": True,
            "restricted_PGL6_holonomy_is_identity": True,
            "determinant_line_holonomy": restricted_determinant,
            "full_signed_invariant_bilinear_dimension": invariant_bilinear_dim,
            "full_signed_invariant_alternating_dimension": invariant_alternating_dim,
            "frozen_Gamma_invariant_alternating_dimension": frozen_alternating_dim,
            "comparison": (
                "All ten signed parent generators preserve ker(H), so the witnessed path is "
                "constant in the quotient Lagrangian Grassmannian. Its fan Maslov sum is "
                f"{loop_class} in Z/4 and cannot detect the central scalar -1 (class 2)."
            ),
        },
        "ej2_two_bit_separation": {
            "ambient_normalizer_quotient": "N_signed(Gamma)/Gamma = <-I> = C2",
            "map_from_ambient_normalizer_quotient_to_Out_Gamma": "trivial",
            "row_transport_outer_class": "nontrivial",
            "row_transport_realized_in_ambient_normalizer": False,
            "central_bit": (
                "linear-frame scalar: fixes carrier geometry and A5-class labels; "
                "survives only in GL6, not PGL6 or determinant"
            ),
            "outer_bit": (
                "comparison of column/row carrier embeddings: swaps A5 classes; "
                "has no realization by the signed ambient normalizer"
            ),
            "verdict": (
                "The C472 central C2 and C501 outer C2 are independent residues at different "
                "functorial levels and cannot be identified by the canonical constructions tested."
            ),
        },
        "trusted_boundary": (
            "Exact integer/F_3 arithmetic; exhaustive closure of the 660-element frozen "
            "permutation group and 190080-element signed ambient group; exhaustive finite "
            "stabilizer, conjugacy, relabeling, normalizer, codeword, and invariant-form "
            "computations; hash-pinned C471/C472/C489 certificates. No literature claim and "
            "no identification of a non-invariant omega construction with a canonical "
            "metaplectic representation beyond the stated finite loop calculation."
        ),
    }


def main():
    cert = build()
    text = canonical(cert)
    if "--check" in sys.argv:
        if not os.path.exists(OUT):
            print("FAIL: certificate missing")
            return 1
        if open(OUT).read() != text:
            print("FAIL: certificate differs from regeneration")
            return 1
        print("OK: C501 certificate matches regeneration")
        print("loop Witt class:", cert["leg3_central_scalar"]["loop_witt_class"])
        return 0
    with open(OUT, "w") as f:
        f.write(text)
    print("wrote", OUT)
    print("loop Witt class:", cert["leg3_central_scalar"]["loop_witt_class"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
