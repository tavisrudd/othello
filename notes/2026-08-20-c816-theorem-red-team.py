#!/usr/bin/env python3
"""C816 review gate 1: independent recomputation of the theorem-level claims of
Paper III's operator section (papers/clebsch-passages/sections/05-golden-operator.tex).

Every check here is deterministic and exhaustive over a stated finite domain.
Nothing in this file is randomized.

Replay (from the repository root):

    uv run --with sympy --with numpy python3 notes/2026-08-20-c816-theorem-red-team.py \
        --out notes/2026-08-20-c816-theorem-red-team.json
    uv run --with sympy --with numpy python3 notes/2026-08-20-c816-theorem-red-team.py \
        --check notes/2026-08-20-c816-theorem-red-team.json

Conventions fixed here and used throughout:

  * X = {0,...,5} in its natural order; edges and 3-subsets are listed in
    lexicographic order.
  * C is the marked representative displayed in sections/03-orientation-source.tex.
  * For a 3-subset S with complement S^c (both increasing), sgn(Sc,S) is the sign
    of the permutation listing S^c and then S.  The manuscript displays
    sgn(S,S^c) = (-1)^{sigma(S)-3}; the two differ by (-1)^{3*3} = -1, which is
    the *^2 = -1 identity recorded in the manuscript.
  * h_S(A) := coefficient of x_S in Pf[D_x, A];  tau_S(A) := a_ij a_jk a_ki.
  * w(K) for a 4-set K is the sum of its three signed Hamilton-cycle products;
    K is "aligned" when w(K) = 3.

What this certifies: the numerical and algebraic content of the statements listed
in the JSON output, for the stated matrices and the stated finite domains.
What it does not certify: any claim about the literature, any statement about
matrices outside the enumerated domains, and the manuscript's prose.
Trusted boundary: CPython, sympy exact rational arithmetic, and numpy integer
arithmetic (used only for determinants of small integer matrices, each rounded
and re-checked against an exact sympy determinant where it is load-bearing).
"""

import argparse
import hashlib
import itertools
import json
import os
import sys
from collections import Counter
from fractions import Fraction
from math import comb

import sympy as sp
from sympy import Matrix, symbols

# ---------------------------------------------------------------- basic data

CROWS = [
    [0, 1, 1, 1, -1, -1],
    [1, 0, -1, -1, -1, -1],
    [1, -1, 0, 1, 1, -1],
    [1, -1, 1, 0, -1, 1],
    [-1, -1, 1, -1, 0, -1],
    [-1, -1, -1, 1, -1, 0],
]
C = Matrix(CROWS)
EDGES = [(i, j) for i in range(6) for j in range(i + 1, 6)]
EIDX = {e: k for k, e in enumerate(EDGES)}
TRIPLES = [tuple(s) for s in itertools.combinations(range(6), 3)]

# the order in which the manuscript lists coefficient words in table (5.1)
WORD_ORDER = [
    "012", "013", "014", "015", "023", "024", "025", "034", "035", "045",
    "123", "124", "125", "134", "135", "145", "234", "235", "245", "345",
]

# the reduced Jacobian table displayed in the manuscript, keyed by its triple groups
MANUSCRIPT_REDUCED_TABLE = [
    (("012", "045", "234"), (1, 0, -1, -1, 1)),
    (("013", "145", "235"), (2, -1, 1, 3, -1)),
    (("014", "023", "245"), (-2, -1, -1, -3, -1)),
    (("015", "123", "345"), (-1, 1, 1, 1, 0)),
    (("024",), (-1, 2, 0, 1, 0)),
    (("025", "034", "124"), (3, -1, -1, 2, -1)),
    (("035", "125", "134"), (-3, -1, 1, -2, -1)),
    (("135",), (1, 0, 0, -1, 2)),
]


def perm_sign(seq):
    s = 1
    for i in range(len(seq)):
        for j in range(i + 1, len(seq)):
            if seq[i] > seq[j]:
                s = -s
    return s


def hodge_sign(S):
    """sgn(S^c, S): sign of the permutation listing S^c and then S."""
    Sc = [i for i in range(6) if i not in S]
    return perm_sign(list(Sc) + list(S))


def sym_matrix(vals):
    M = sp.zeros(6, 6)
    for k, (i, j) in enumerate(EDGES):
        M[i, j] = vals[k]
        M[j, i] = vals[k]
    return M


def pfaffian(M, idx):
    if not idx:
        return sp.Integer(1)
    i = idx[0]
    total = 0
    for k in range(1, len(idx)):
        j = idx[k]
        rest = [q for q in idx[1:] if q != j]
        total += (-1) ** (k - 1) * M[i, j] * pfaffian(M, rest)
    return total


def h_and_tau_generic():
    a = symbols("a0:15")
    x = symbols("x0:6")
    A = sym_matrix(a)
    M = sp.zeros(6, 6)
    for i in range(6):
        for j in range(6):
            M[i, j] = (x[i] - x[j]) * A[i, j]
    Phi = sp.expand(pfaffian(M, list(range(6))))
    h = {}
    for S in TRIPLES:
        c = Phi
        for i in range(6):
            c = c.coeff(x[i], 1 if i in S else 0)
        h[S] = sp.expand(c)
    tau = {S: A[S[0], S[1]] * A[S[1], S[2]] * A[S[0], S[2]] for S in TRIPLES}
    return a, A, h, tau, Phi, x


# ------------------------------------------------------------------- checks

def check_operator_and_recognition(res):
    a, A, h, tau, Phi, x = h_and_tau_generic()
    res["C_is_symmetric_conference"] = bool(C.T == C and C * C == 5 * sp.eye(6))

    # generic identity behind "what the four descriptions do and do not assert"
    ok = True
    for S in TRIPLES:
        Sc = [i for i in range(6) if i not in S]
        want = hodge_sign(S) * A[Sc, list(S)].det()
        if sp.simplify(sp.expand(h[S] - want)) != 0:
            ok = False
    res["generic_pfaffian_coefficient_is_signed_complementary_minor"] = ok
    res["pfaffian_is_homogeneous_cubic_in_x"] = bool(
        sp.Poly(Phi, *x).is_homogeneous and sp.Poly(Phi, *x).total_degree() == 3
    )

    subs = {a[k]: C[i, j] for k, (i, j) in enumerate(EDGES)}
    hC = {S: sp.expand(h[S].subs(subs)) for S in TRIPLES}
    tauC = {S: sp.expand(tau[S].subs(subs)) for S in TRIPLES}
    res["C_lies_in_X_plus_one"] = all(hC[S] == 4 * tauC[S] for S in TRIPLES)
    res["triangle_word_row_0"] = "".join(
        "+" if tauC[tuple(int(ch) for ch in s)] == 1 else "-" for s in WORD_ORDER
    )

    # the two triangle-orbit representatives displayed in the operator proof
    orbit = {}
    for S in ((0, 1, 2), (0, 1, 4)):
        Sc = [i for i in range(6) if i not in S]
        blk = C[Sc, list(S)]
        orbit["".join(map(str, S))] = {
            "block": [[int(v) for v in blk.row(r)] for r in range(3)],
            "determinant": int(blk.det()),
            "hodge_sign_Sc_S": int(hodge_sign(S)),
            "triangle_product": int(tauC[S]),
        }
    res["orbit_representatives"] = orbit

    # the odd-relabelling claim behind "the opposite oriented representative"
    sigma = [1, 0, 2, 3, 4, 5]
    P = sp.zeros(6, 6)
    for i in range(6):
        P[sigma[i], i] = 1
    Cp = P * C * P.T
    subs_p = {a[k]: Cp[i, j] for k, (i, j) in enumerate(EDGES)}
    res["odd_relabelling_lies_in_X_minus_one"] = all(
        sp.expand(h[S].subs(subs_p)) == -4 * sp.expand(tau[S].subs(subs_p))
        for S in TRIPLES
    )
    subs_m = {a[k]: -C[i, j] for k, (i, j) in enumerate(EDGES)}
    res["negated_representative_lies_in_X_plus_one"] = all(
        sp.expand(h[S].subs(subs_m)) == 4 * sp.expand(tau[S].subs(subs_m))
        for S in TRIPLES
    )
    return a, h, tau, subs


def check_rigidity(res, a, h, tau, subs):
    F = {S: sp.expand(h[S] - 4 * tau[S]) for S in TRIPLES}
    J = sp.zeros(20, 15)
    for r, S in enumerate(TRIPLES):
        for c in range(15):
            J[r, c] = sp.diff(F[S], a[c]).subs(subs)
    res["jacobian_rank_at_C"] = int(J.rank())
    ker = J.nullspace()
    cvec = Matrix([C[i, j] for (i, j) in EDGES])
    res["jacobian_kernel_dimension"] = len(ker)
    res["jacobian_kernel_is_scaling_line"] = bool(
        len(ker) == 1 and Matrix.hstack(ker[0], cvec).rank() == 1
    )

    # derivative shape claimed in the proof
    S = (0, 1, 2)
    inside = [e for e in EDGES if e[0] in S and e[1] in S]
    outside = [e for e in EDGES if e[0] not in S and e[1] not in S]
    res["derivative_inside_S"] = {
        "".join(map(str, e)): str(sp.expand(sp.diff(F[S], a[EIDX[e]]))) for e in inside
    }
    res["derivative_inside_S_complement_vanishes"] = all(
        sp.diff(F[S], a[EIDX[e]]) == 0 for e in outside
    )

    # stabilizer G
    stab = []
    for sigma in itertools.permutations(range(6)):
        P = sp.zeros(6, 6)
        for i in range(6):
            P[sigma[i], i] = 1
        M = P * C * P.T
        eps = [None] * 6
        eps[0] = 1
        for _ in range(6):
            for i in range(6):
                if eps[i] is None:
                    for j in range(6):
                        if eps[j] is not None and M[i, j] != 0:
                            eps[i] = C[i, j] * M[i, j] * eps[j]
                            break
        if any(e is None for e in eps):
            continue
        D = sp.diag(*eps)
        if D * M * D == C:
            stab.append((sigma, tuple(eps)))

    def edge_action(sigma, eps):
        M = sp.zeros(15, 15)
        for k, (i, j) in enumerate(EDGES):
            i2, j2 = sigma[i], sigma[j]
            e2 = (min(i2, j2), max(i2, j2))
            M[EIDX[e2], k] = eps[i2] * eps[j2]
        return M

    acts = [(s, e, edge_action(s, e)) for s, e in stab]

    def order_of(M):
        I = sp.eye(15)
        X = M
        o = 1
        while X != I:
            X = X * M
            o += 1
        return o

    orders = Counter(order_of(M) for _, _, M in acts)
    res["stabilizer_order"] = len(stab)
    res["stabilizer_element_order_profile"] = {str(k): v for k, v in sorted(orders.items())}
    chi = {}
    for _, _, M in acts:
        chi.setdefault(order_of(M), set()).add(int(sp.trace(M)))
    res["edge_module_character_by_element_order"] = {
        str(k): sorted(v) for k, v in sorted(chi.items())
    }

    # A5 character table, classes ordered 1, 2, 3, 5a, 5b with sizes 1,15,20,12,12
    sizes = [1, 15, 20, 12, 12]
    phi = (1 + sp.sqrt(5)) / 2
    irr = {
        "1": [1, 1, 1, 1, 1],
        "3a": [3, -1, 0, phi, 1 - phi],
        "3b": [3, -1, 0, 1 - phi, phi],
        "4": [4, 0, 1, -1, -1],
        "5": [5, 1, -1, 0, 0],
    }
    chi_W = [15, 3, 0, 0, 0]
    res["edge_module_multiplicities"] = {
        name: int(sp.simplify(sum(sizes[i] * chi_W[i] * v[i] for i in range(5)) / 60))
        for name, v in irr.items()
    }

    # W^<h> and the reduced table
    sigma_h = [2, 3, 4, 5, 0, 1]
    eps_h = (1, -1, -1, -1, -1, 1)
    res["displayed_order_three_element_is_in_G"] = any(
        list(s) == sigma_h and tuple(e) == eps_h for s, e in stab
    )
    Mh = edge_action(sigma_h, eps_h)
    res["dim_W_fixed_by_h"] = len((Mh - sp.eye(15)).nullspace())

    def vec(terms):
        v = sp.zeros(15, 1)
        for c, e in terms:
            v[EIDX[e]] = c
        return v

    u = [
        vec([(1, (0, 1)), (1, (2, 3)), (-1, (4, 5))]),
        vec([(1, (0, 2)), (-1, (0, 4)), (1, (2, 4))]),
        vec([(1, (0, 3)), (-1, (1, 4)), (-1, (2, 5))]),
        vec([(1, (0, 5)), (1, (1, 2)), (1, (3, 4))]),
        vec([(1, (1, 3)), (1, (1, 5)), (-1, (3, 5))]),
    ]
    U = Matrix.hstack(*u)
    res["displayed_basis_is_h_fixed_and_independent"] = bool(
        all(Mh * v == v for v in u) and U.rank() == 5
    )
    coords = U.solve_least_squares(cvec)
    res["C_coordinates_in_displayed_basis"] = [int(v) for v in coords]

    rows = {}
    for S in TRIPLES:
        g = Matrix([[sp.diff(F[S], a[c]).subs(subs) for c in range(15)]])
        rows[S] = tuple(int(v) for v in (g * U))
    grouped = {}
    for S, r in rows.items():
        g = 0
        for v in r:
            g = sp.gcd(g, abs(v))
        prim = tuple(int(v) // int(g) for v in r) if g else tuple(0 for _ in r)
        grouped.setdefault(prim, []).append("".join(map(str, S)))
    computed = sorted(
        (tuple(sorted(v)), k) for k, v in grouped.items()
    )
    expected = sorted((tuple(sorted(k)), v) for k, v in MANUSCRIPT_REDUCED_TABLE)
    res["reduced_jacobian_table_matches_manuscript"] = computed == expected
    res["reduced_jacobian_table"] = [
        {"triples": list(t), "row": list(r)} for t, r in computed
    ]
    R = Matrix([list(r) for r in grouped.keys()])
    res["reduced_table_rank"] = int(R.rank())
    res["reduced_table_kernel"] = [[int(v) for v in k] for k in R.nullspace()]
    sel = [rows[(0, 1, 2)], rows[(0, 1, 3)], rows[(0, 1, 5)], rows[(0, 2, 4)]]
    sel = [[v // int(sp.gcd(sp.gcd(sp.gcd(abs(r[0]), abs(r[1])), abs(r[2])),
                            sp.gcd(abs(r[3]), abs(r[4])))) for v in r] for r in sel]
    res["displayed_four_by_four_minor"] = int(Matrix([r[:4] for r in sel]).det())

    # tangent space to {A^2 = lambda I}
    b = symbols("b0:15")
    X = sym_matrix(b)
    mu = sp.Symbol("mu")
    eqs = []
    Y = C * X + X * C - mu * sp.eye(6)
    for i in range(6):
        for j in range(i, 6):
            eqs.append(sp.expand(Y[i, j]))
    Ms, _ = sp.linear_eq_to_matrix(eqs, list(b) + [mu])
    L = Matrix.hstack(*[Matrix(v[:15, 0]) for v in Ms.nullspace()])
    res["dim_tangent_space_of_scalar_square_locus"] = int(L.rank())
    for sign, key in ((-5, "minus"), (5, "plus")):
        e2 = []
        Y2 = C * X * C - sign * X
        for i in range(6):
            for j in range(i, 6):
                e2.append(sp.expand(Y2[i, j]))
        M2, _ = sp.linear_eq_to_matrix(e2, list(b))
        res["dim_conjugation_eigenspace_" + key] = 15 - int(M2.rank())
    Lp = L * (L.T * L).inv() * L.T
    chiL = {}
    for s, e, M in acts:
        chiL.setdefault(order_of(M), set()).add(int(sp.nsimplify(sp.trace(Lp * M))))
    res["tangent_space_character_by_element_order"] = {
        str(k): sorted(v) for k, v in sorted(chiL.items())
    }


def np_det3(rows):
    (a, b, c), (d, e, f), (g, h, i) = rows
    return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)


def check_sign_census(res):
    """Exhaustive over all 2^15 symmetric hollow sign matrices of order six."""
    conference = 0
    minors_nonzero = 0
    proportional = 0
    disagreements = 0
    constants = set()
    minor_values = set()
    for bits in range(1 << 15):
        vals = [1 if (bits >> k) & 1 else -1 for k in range(15)]
        A = [[0] * 6 for _ in range(6)]
        for k, (i, j) in enumerate(EDGES):
            A[i][j] = vals[k]
            A[j][i] = vals[k]
        sq = [[sum(A[i][m] * A[m][j] for m in range(6)) for j in range(6)] for i in range(6)]
        is_conf = all(
            sq[i][j] == (5 if i == j else 0) for i in range(6) for j in range(6)
        )
        h = {}
        for S in TRIPLES:
            Sc = [i for i in range(6) if i not in S]
            h[S] = hodge_sign(S) * np_det3([[A[p][m] for m in S] for p in Sc])
            minor_values.add(abs(h[S]))
        tau = {S: A[S[0]][S[1]] * A[S[1]][S[2]] * A[S[0]][S[2]] for S in TRIPLES}
        nz = all(h[S] != 0 for S in TRIPLES)
        ratios = {h[S] // tau[S] for S in TRIPLES}
        prop = len(ratios) == 1 and 0 not in ratios
        conference += is_conf
        minors_nonzero += nz
        proportional += prop
        if prop:
            constants |= ratios
        if not (is_conf == nz == prop):
            disagreements += 1
    res["sign_census_domain"] = "all 2^15 symmetric hollow sign matrices of order six"
    res["sign_census_conference"] = conference
    res["sign_census_complementary_minors_all_nonzero"] = minors_nonzero
    res["sign_census_proportional"] = proportional
    res["sign_census_disagreements"] = disagreements
    res["sign_census_proportionality_constants"] = sorted(constants)
    res["sign_census_complementary_minor_absolute_values"] = sorted(minor_values)


def paley(q, field):
    """Symmetric conference matrix of order q+1; field is a list of elements with
    add/mul closures supplied by the caller."""
    els, sub, mul = field
    squares = {mul(x, x) for x in els if x != els[0]}
    n = q + 1
    M = [[0] * n for _ in range(n)]
    for i in range(1, n):
        M[0][i] = 1
        M[i][0] = 1
    for i in range(1, n):
        for j in range(1, n):
            if i != j:
                d = sub(els[i - 1], els[j - 1])
                M[i][j] = 1 if d in squares else -1
    return M


def prime_field(p):
    els = list(range(p))
    return els, (lambda u, v: (u - v) % p), (lambda u, v: (u * v) % p)


def gf9():
    els = [(u, v) for u in range(3) for v in range(3)]
    els = [els[0]] + [e for e in els if e != (0, 0)]
    return (
        els,
        lambda u, v: ((u[0] - v[0]) % 3, (u[1] - v[1]) % 3),
        lambda u, v: ((u[0] * v[0] - u[1] * v[1]) % 3, (u[0] * v[1] + u[1] * v[0]) % 3),
    )


def w_of(M, K):
    a, b, c, d = K
    cycles = [(a, b, c, d), (a, b, d, c), (a, c, b, d)]
    return sum(M[p[0]][p[1]] * M[p[1]][p[2]] * M[p[2]][p[3]] * M[p[3]][p[0]] for p in cycles)


def check_designs(res):
    out = {}
    cases = [("order6", None), ("order10", gf9()), ("order14", prime_field(13)),
             ("order18", prime_field(17))]
    for name, field in cases:
        if name == "order6":
            M = [[int(C[i, j]) for j in range(6)] for i in range(6)]
            n, d = 6, 3
        else:
            q = {"order10": 9, "order14": 13, "order18": 17}[name]
            M = paley(q, field)
            n = q + 1
            d = n // 2
        sq = [[sum(M[i][m] * M[m][j] for m in range(n)) for j in range(n)] for i in range(n)]
        entry = {"is_conference": all(
            sq[i][j] == (n - 1 if i == j else 0) for i in range(n) for j in range(n))}
        aligned = {K for K in itertools.combinations(range(n), 4) if w_of(M, K) == 3}
        entry["aligned_four_sets"] = len(aligned)
        entry["aligned_density"] = str(Fraction(len(aligned), comb(n, 4)))
        entry["rho_formula"] = str(Fraction(d - 3, 2 * (2 * d - 3)))
        cnt = Counter()
        for K in aligned:
            for T in itertools.combinations(K, 3):
                cnt[T] += 1
        lam = sorted({cnt.get(T, 0) for T in itertools.combinations(range(n), 3)})
        entry["three_design_lambda_values"] = lam
        entry["three_design_lambda_expected"] = str(Fraction(d - 3, 2))
        entry["det_block_identity_failures"] = sum(
            1 for K in itertools.combinations(range(n), 4)
            if int(Matrix([[M[i][j] for j in K] for i in K]).det()) != 3 - 2 * w_of(M, K)
        )
        halves = [Y for Y in itertools.combinations(range(n), d) if 0 in Y]
        cs = [sum(1 for K in itertools.combinations(Y, 4) if K in aligned) for Y in halves]
        m = Fraction(sum(cs), len(cs))
        v = Fraction(sum(c * c for c in cs), len(cs)) - m * m
        rho = Fraction(d - 3, 2 * (2 * d - 3))
        entry["cuts"] = len(halves)
        entry["mean_c_Y"] = str(m)
        entry["mean_c_Y_formula"] = str(rho * comb(d, 4))
        entry["var_c_Y"] = str(v)
        entry["var_c_Y_formula"] = (
            str(Fraction(comb(n, 4) * comb(n - 8, d - 4), comb(n, d)) * rho * (1 - rho))
            if d >= 4 else "not applicable (d < 4)"
        )
        entry["c_Y_distribution"] = sorted(Counter(cs).items())
        # The exchange spectrum is compared exactly, through the characteristic
        # polynomial of the integer matrix A^2, only at the two orders where the
        # manuscript makes an explicit spectral claim.
        if n <= 10:
            specs = set()
            for Y in halves:
                A = Matrix([[M[i][j] for j in Y] for i in Y])
                specs.add(tuple(int(c) for c in (A * A).charpoly().all_coeffs()))
            entry["distinct_exchange_spectra_over_all_cuts"] = len(specs)
            if name == "order6":
                A = Matrix([[M[i][j] for j in halves[0]] for i in halves[0]])
                entry["exchange_spectrum"] = sorted(
                    str(sp.Rational(1) - sp.Rational(e, n - 1))
                    for e in (A * A).eigenvals(multiple=True)
                )
        out[name] = entry
    res["conference_orders"] = out


def two_graph_fibres(V):
    """Exhaustive fibre analysis of tau |-> aligned family, over all two-graphs on V
    points, parametrized by graphs in which vertex 0 is isolated."""
    triples = list(itertools.combinations(range(V), 3))
    tindex = {T: k for k, T in enumerate(triples)}
    pairs = [(i, j) for i in range(1, V) for j in range(i + 1, V)]
    emask = []
    for (i, j) in pairs:
        m = 0
        for T in triples:
            if i in T and j in T:
                m |= 1 << tindex[T]
        emask.append(m)
    fours = list(itertools.combinations(range(V), 4))
    fmask = []
    for Q in fours:
        m = 0
        for T in itertools.combinations(Q, 3):
            m |= 1 << tindex[T]
        fmask.append(m)
    fibres = Counter()
    taus = [0]
    for m in emask:
        taus = taus + [t ^ m for t in taus]
    for t in taus:
        sig = 0
        for k, m in enumerate(fmask):
            x = t & m
            if x == 0 or x == m:
                sig |= 1 << k
        fibres[sig] += 1
    return Counter(fibres.values()), len(taus)


def check_faithfulness(res, full):
    out = {}
    for V in ([6, 7, 8] if full else [6, 7]):
        sizes, total = two_graph_fibres(V)
        out[str(V)] = {
            "two_graphs": total,
            "expected_two_graphs": 2 ** (V * (V - 1) // 2 - V + 1),
            "fibre_sizes": {str(k): v for k, v in sorted(sizes.items())},
        }
    res["aligned_family_fibres"] = out

    # the six-point witness of the sharpness remark
    def two_graph(edgeset, V=6):
        return {
            T: sum(1 for p in itertools.combinations(T, 2)
                   if tuple(sorted(p)) in edgeset) % 2
            for T in itertools.combinations(range(V), 3)
        }

    def aligned_family(tau, V=6):
        return sorted(
            Q for Q in itertools.combinations(range(V), 4)
            if len({tau[T] for T in itertools.combinations(Q, 3)}) == 1
        )

    G = {(1, 2), (1, 5), (2, 4), (2, 5), (3, 5)}
    H = {(1, 3), (1, 4), (2, 4), (3, 4), (3, 5)}
    tG, tH = two_graph(G), two_graph(H)
    parity_ok = all(
        sum(t[T] for T in itertools.combinations(Q, 3)) % 2 == 0
        for t in (tG, tH) for Q in itertools.combinations(range(6), 4)
    )
    res["six_point_witness"] = {
        "both_are_two_graphs": parity_ok,
        "aligned_family_G": [list(q) for q in aligned_family(tG)],
        "aligned_family_H": [list(q) for q in aligned_family(tH)],
        "families_agree": aligned_family(tG) == aligned_family(tH),
        "H_equals_G": tG == tH,
        "H_equals_complement_of_G": {T: 1 - v for T, v in tH.items()} == tG,
    }

    # the seven-point signature table
    def aligned_triples(p):
        out = []
        for T in itertools.combinations([1, 2, 3, 4], 3):
            i, j, k = T
            vals = {0}
            for (uu, vv) in ((i, j), (i, k), (j, k)):
                vals.add((p[uu - 1] + p[vv - 1]) % 2)
            if len(vals) == 1:
                out.append("".join(map(str, T)))
        return out

    res["seven_point_signature_table"] = {
        "".join(map(str, p)): aligned_triples(p)
        for p in [(0, 0, 0, 0), (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0),
                  (1, 1, 1, 0), (1, 1, 0, 0), (1, 0, 1, 0), (0, 1, 1, 0)]
    }

    B = {"B12": (1, 1, 0, 0), "B13": (1, 0, 1, 0), "B14": (0, 1, 1, 0)}

    def Bset(p, s, e):
        return [
            f"{i}{j}" for i, j in itertools.combinations([1, 2, 3, 4], 2)
            if (p[i - 1] + s[i - 1]) % 2 == (p[j - 1] + s[j - 1]) % 2
            and e == (p[j - 1] + s[i - 1]) % 2
        ]

    res["one_known_cut_table"] = {
        f"{''.join(map(str,k))}|{name}": {"e0": Bset(k, bc, 0), "e1": Bset(k, bc, 1)}
        for k in ((0, 0, 0, 0), (1, 0, 0, 0)) for name, bc in sorted(B.items())
    }
    res["both_balanced_table"] = {
        f"{n1}|{n2}": {"e0": Bset(b1, b2, 0), "e1": Bset(b1, b2, 1)}
        for (n1, b1), (n2, b2)
        in itertools.combinations_with_replacement(sorted(B.items()), 2)
    }
    res["balanced_pair_swap_invariant"] = all(
        Bset(b1, b2, e) == Bset(b2, b1, e)
        for (n1, b1), (n2, b2) in itertools.combinations(sorted(B.items()), 2)
        for e in (0, 1)
    )

    nsym = sp.Symbol("n")
    binom2 = lambda z: z * (z - 1) / 2
    res["query_count_polynomial_identity"] = bool(
        sp.expand(1 + 4 * (nsym - 4) + 6 * binom2(nsym - 4)
                  - (3 * nsym ** 2 - 23 * nsym + 45)) == 0
    )
    res["counting_lower_bound_matches_binomial_form"] = bool(
        sp.expand(binom2(nsym) - nsym - (binom2(nsym - 1) - 1)) == 0
    )
    H14 = -(sp.Rational(1, 4) * sp.log(sp.Rational(1, 4), 2)
            + sp.Rational(3, 4) * sp.log(sp.Rational(3, 4), 2))
    res["inverse_binary_entropy_at_one_quarter"] = float(sp.N(1 / H14, 20))
    res["query_ratio_limit"] = float(sp.N(3 / (sp.Rational(1, 2) * 1 / H14), 20))


def check_exchange_moments(res):
    """Symbolic verification of the trace identities and the (2d-3)w = -3 pin."""
    d, q, cY = symbols("d q c_Y", positive=True)
    F_d = (d * q ** 2 - 2 * q * d * (d - 1) + d * (d - 1)
           + 12 * sp.binomial(d, 3) - 8 * sp.binomial(d, 4))
    # tr(H^2) numerator from tr((qI - A^2)^2) with tr(A^4) sorted by support
    trA2 = d * (d - 1)
    trA4 = d * (d - 1) + 12 * sp.binomial(d, 3) + 8 * (4 * cY - sp.binomial(d, 4))
    numerator = sp.expand(d * q ** 2 - 2 * q * trA2 + trA4)
    res["second_moment_numerator_matches_F_d_plus_32c"] = bool(
        sp.simplify(numerator - (F_d + 32 * cY)) == 0
    )
    res["first_moment_is_d_squared_over_q"] = bool(
        sp.simplify(((d * (2 * d - 1) - trA2) / (2 * d - 1)) - d ** 2 / (2 * d - 1)) == 0
    )
    w = sp.Symbol("w")
    lhs = 2 * d * (2 * d - 1) ** 2
    rhs = 2 * d * (2 * d - 1) + 12 * sp.binomial(2 * d, 3) + 8 * w * sp.binomial(2 * d, 4)
    sol = sp.solve(sp.expand(lhs - rhs), w)
    res["whole_matrix_pin"] = str(sp.simplify(sol[0]))
    res["whole_matrix_pin_is_minus_three_over_2d_minus_3"] = bool(
        sp.simplify(sol[0] - sp.Rational(-3, 1) / (2 * d - 3)) == 0
    )
    t = sp.Symbol("t")
    res["order_three_char_poly_factors"] = [
        str(sp.factor(t ** 3 - 3 * t - 2)), str(sp.factor(t ** 3 - 3 * t + 2))
    ]


# ------------------------------------------------------------------ driver

def build(full):
    res = {"schema": "c816-theorem-red-team/1"}
    a, h, tau, subs = check_operator_and_recognition(res)
    check_rigidity(res, a, h, tau, subs)
    check_sign_census(res)
    check_designs(res)
    check_faithfulness(res, full)
    check_exchange_moments(res)
    return res


def canonical(obj):
    return json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=True) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out")
    ap.add_argument("--check")
    ap.add_argument("--full", action="store_true",
                    help="include the exhaustive eight-point fibre analysis")
    args = ap.parse_args()
    res = build(args.full or bool(args.check and
                                  "\"8\"" in open(args.check).read()))
    text = canonical(res)
    if args.check:
        want = open(args.check).read()
        if want != text:
            sys.stderr.write("MISMATCH against %s\n" % args.check)
            return 1
        print("OK %s sha256=%s" % (args.check,
                                   hashlib.sha256(text.encode()).hexdigest()))
        return 0
    if args.out:
        with open(args.out, "w") as fh:
            fh.write(text)
        print("wrote %s sha256=%s" % (args.out,
                                      hashlib.sha256(text.encode()).hexdigest()))
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main())
