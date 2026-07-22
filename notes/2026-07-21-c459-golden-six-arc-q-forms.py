#!/usr/bin/env python3
"""C459: classify Q(sqrt(5))/Q descents of the frozen golden six-arc.

Run from the repository root:
  python3 notes/2026-07-21-c459-golden-six-arc-q-forms.py --write
  python3 notes/2026-07-21-c459-golden-six-arc-q-forms.py --check

The computation is exact and deterministic.  It consumes the hash-pinned C442
Q(phi) implementation, reconstructs the full order-60 projective stabilizer,
enumerates every transporter from sigma(S) to S, imposes the projective cocycle
condition, and quotients by the exact gauge action.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from fractions import Fraction as F
from itertools import permutations
from pathlib import Path

HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c459-golden-six-arc-q-forms"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
C442_STEM = "2026-07-21-c442-antipodal-singleton-reduction"
SCHEMA = "c459-golden-six-arc-q-forms-v1"


def load_c442():
    path = HERE / f"{C442_STEM}.py"
    spec = importlib.util.spec_from_file_location("c459_c442", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def manifest_hash(stem: str, filename: str) -> str:
    for line in (HERE / f"{stem}.sha256").read_text().splitlines():
        parts = line.split()
        if len(parts) >= 2 and Path(parts[1]).name == filename:
            return parts[0]
    raise AssertionError(f"{filename} absent from {stem}.sha256")


def qrawmul(m, A, B):
    return tuple(
        tuple(
            m.qadd(
                m.qadd(m.qmul(A[i][0], B[0][j]), m.qmul(A[i][1], B[1][j])),
                m.qmul(A[i][2], B[2][j]),
            )
            for j in range(3)
        )
        for i in range(3)
    )


def qinv3(m, A):
    a, b, c = A[0]
    d, e, f = A[1]
    g, h, i = A[2]
    C = (
        (
            m.qsub(m.qmul(e, i), m.qmul(f, h)),
            m.qsub(m.qmul(c, h), m.qmul(b, i)),
            m.qsub(m.qmul(b, f), m.qmul(c, e)),
        ),
        (
            m.qsub(m.qmul(f, g), m.qmul(d, i)),
            m.qsub(m.qmul(a, i), m.qmul(c, g)),
            m.qsub(m.qmul(c, d), m.qmul(a, f)),
        ),
        (
            m.qsub(m.qmul(d, h), m.qmul(e, g)),
            m.qsub(m.qmul(b, g), m.qmul(a, h)),
            m.qsub(m.qmul(a, e), m.qmul(b, d)),
        ),
    )
    det = m.qadd(
        m.qadd(m.qmul(a, C[0][0]), m.qmul(b, C[1][0])),
        m.qmul(c, C[2][0]),
    )
    assert det != m.QZERO
    return tuple(tuple(m.qmul(m.qinv(det), C[r][s]) for s in range(3)) for r in range(3))


def sigma(m, A):
    return tuple(tuple(m.qsigma(x) for x in row) for row in A)


def qmatrix_identity(m):
    return ((m.QONE, m.QZERO, m.QZERO), (m.QZERO, m.QONE, m.QZERO), (m.QZERO, m.QZERO, m.QONE))


def qnorminv(m, A):
    return m.qnormmat(qinv3(m, A))


def qmatrix_order(m, A, limit=30):
    I = m.qnormmat(qmatrix_identity(m))
    x = I
    for n in range(1, limit + 1):
        x = m.qnormmat(m.qmatmul(x, A))
        if x == I:
            return n
    raise AssertionError("order exceeds bound")


def frac_json(x: F):
    return str(x.numerator) if x.denominator == 1 else f"{x.numerator}/{x.denominator}"


def q_json(x):
    a, b = x
    return [frac_json(a), frac_json(b)]


def vec_json(v):
    return [q_json(x) for x in v]


def mat_json(A):
    return [[q_json(x) for x in row] for row in A]


def mat_key(A):
    return json.dumps(mat_json(A), separators=(",", ":"))


def rational_matrix_json(A):
    assert all(x[1] == 0 for row in A for x in row)
    return [[frac_json(x[0]) for x in row] for row in A]


def cocycle_scalar(m, u):
    P = qrawmul(m, u, sigma(m, u))
    off = [P[i][j] for i in range(3) for j in range(3) if i != j]
    assert all(x == m.QZERO for x in off)
    assert P[0][0] == P[1][1] == P[2][2]
    return P[0][0]


def build_certificate():
    m = load_c442()
    c442_path = HERE / f"{C442_STEM}.py"
    assert sha256(c442_path) == manifest_hash(C442_STEM, c442_path.name)

    I = m.qnormmat(qmatrix_identity(m))
    S = m.q_six(m.QPHI)
    Sc = m.q_six(m.QPHIBAR)
    A5 = m.q_closure([m.qnormmat(m.q_refl(v)) for v in m.q_roots(m.QPHI)])
    assert len(A5) == 60
    assert all(frozenset(m.qnormvec(m.qmatvec(a, v)) for v in S) == S for a in A5)

    # A particularly simple exact descent datum sigma(S) -> S.
    u0 = (
        (m.QZERO, m.QZERO, m.QONE),
        (m.QZERO, (F(-1), F(0)), m.QZERO),
        (m.QONE, m.QZERO, m.QZERO),
    )
    assert frozenset(m.qnormvec(m.qmatvec(u0, v)) for v in Sc) == S
    assert qrawmul(m, u0, sigma(m, u0)) == qmatrix_identity(m)

    # Since Aut(S)=A5, every transporter sigma(S)->S is a*u0, a in A5.
    transporters = {m.qnormmat(m.qmatmul(a, u0)) for a in A5}
    assert len(transporters) == 60
    assert all(frozenset(m.qnormvec(m.qmatvec(u, v)) for v in Sc) == S for u in transporters)
    descent_data = {
        u for u in transporters
        if m.qnormmat(qrawmul(m, u, sigma(m, u))) == I
    }
    assert len(descent_data) == 10

    # Gauge equivalence: u -> a*u*sigma(a)^(-1).
    gauge_orbits = []
    unseen = set(descent_data)
    while unseen:
        u = min(unseen, key=mat_key)
        orbit = {
            m.qnormmat(m.qmatmul(m.qmatmul(a, u), qnorminv(m, sigma(m, a))))
            for a in A5
        }
        assert orbit <= descent_data
        gauge_orbits.append(orbit)
        unseen -= orbit
    assert [len(o) for o in gauge_orbits] == [10]

    # Constructive Hilbert 90: h = u0*sigma(h), hence u0=h*sigma(h)^(-1).
    sqrt5 = m.qsub(m.qmul((F(2), F(0)), m.QPHI), m.QONE)
    h = (
        (m.QPHI, m.QZERO, m.QONE),
        (m.QZERO, sqrt5, m.QZERO),
        (m.qsub(m.QONE, m.QPHI), m.QZERO, m.QONE),
    )
    hinv = qinv3(m, h)
    assert h == qrawmul(m, u0, sigma(m, h))
    assert m.qnormmat(qrawmul(m, h, qinv3(m, sigma(m, h)))) == m.qnormmat(u0)

    descended_arc = frozenset(m.qnormvec(m.qmatvec(hinv, v)) for v in S)
    assert len(descended_arc) == 6
    assert frozenset(m.qnormvec(tuple(m.qsigma(x) for x in v)) for v in descended_arc) == descended_arc
    arc_list = sorted(descended_arc)
    arc_index = {v: i for i, v in enumerate(arc_list)}
    sigma_perm = tuple(
        arc_index[m.qnormvec(tuple(m.qsigma(x) for x in v))] for v in arc_list
    )
    galois_pairs = sorted({tuple(sorted((i, sigma_perm[i]))) for i in range(6)})
    assert len(galois_pairs) == 3 and all(i != j for i, j in galois_pairs)

    def qcross(v, w):
        return (
            m.qsub(m.qmul(v[1], w[2]), m.qmul(v[2], w[1])),
            m.qsub(m.qmul(v[2], w[0]), m.qmul(v[0], w[2])),
            m.qsub(m.qmul(v[0], w[1]), m.qmul(v[1], w[0])),
        )

    pair_secants = [m.qnormvec(qcross(arc_list[i], arc_list[j])) for i, j in galois_pairs]
    assert all(x[1] == 0 for ell in pair_secants for x in ell)
    assert sorted(rational_matrix_json((ell,))[0] for ell in pair_secants) == [
        ["0", "1", "-1"], ["0", "1", "0"], ["0", "1", "1"]
    ]
    concurrence_points = {
        m.qnormvec(qcross(pair_secants[i], pair_secants[j]))
        for i in range(3) for j in range(i + 1, 3)
    }
    assert concurrence_points == {(m.QONE, m.QZERO, m.QZERO)}

    # The descended conic is y^T G y=0, G=h^T h, and is rational.
    ht = tuple(tuple(x for x in row) for row in zip(*h))
    gram = qrawmul(m, ht, h)
    assert all(x[1] == 0 for row in gram for x in row)
    assert rational_matrix_json(gram) == [["3", "0", "1"], ["0", "5", "0"], ["1", "0", "2"]]

    # Matching decoration: the six polar lines G*y cut the conic in the six antipodal pairs.
    polar_lines = frozenset(m.qnormvec(m.qmatvec(gram, y)) for y in descended_arc)
    assert len(polar_lines) == 6
    assert frozenset(m.qnormvec(tuple(m.qsigma(x) for x in ell)) for ell in polar_lines) == polar_lines

    # Rational stabilizer is the fixed subgroup for the twisted Galois action.
    fixed = {
        a for a in A5
        if m.qnormmat(m.qmatmul(m.qmatmul(u0, sigma(m, a)), qnorminv(m, u0))) == a
    }
    assert len(fixed) == 6
    rational_stabilizer = {
        m.qnormmat(m.qmatmul(m.qmatmul(hinv, a), h)) for a in fixed
    }
    assert len(rational_stabilizer) == 6
    assert all(x[1] == 0 for A in rational_stabilizer for row in A for x in row)
    order_distribution = sorted(qmatrix_order(m, A) for A in rational_stabilizer)
    assert order_distribution == [1, 2, 2, 2, 3, 3]
    fixed_point = (m.QONE, m.QZERO, m.QZERO)
    assert all(m.qnormvec(m.qmatvec(A, fixed_point)) == fixed_point for A in rational_stabilizer)
    polar_line = m.qnormvec(m.qmatvec(gram, fixed_point))
    assert rational_matrix_json((polar_line,)) == [["1", "0", "1/3"]]
    gen3 = min((A for A in rational_stabilizer if qmatrix_order(m, A) == 3), key=mat_key)
    gen2 = min((A for A in rational_stabilizer if qmatrix_order(m, A) == 2), key=mat_key)
    generated = m.q_closure([gen2, gen3])
    assert generated == rational_stabilizer
    arc_perms = {
        tuple(arc_index[m.qnormvec(m.qmatvec(A, v))] for v in arc_list)
        for A in rational_stabilizer
    }
    point_orbits = []
    unseen_points = set(range(6))
    while unseen_points:
        i = min(unseen_points)
        orbit = {p[i] for p in arc_perms}
        point_orbits.append(sorted(orbit)); unseen_points -= orbit
    assert sorted(len(o) for o in point_orbits) == [3, 3]
    assert {sigma_perm[i] for i in point_orbits[0]} == set(point_orbits[1])
    pair_index = {pair: i for i, pair in enumerate(galois_pairs)}
    pair_perms = {
        tuple(pair_index[tuple(sorted((p[i], p[j])))] for i, j in galois_pairs)
        for p in arc_perms
    }
    assert pair_perms == set(permutations(range(3)))

    # Structural D5 obstruction: its natural action on five letters is self-centralizing in S5.
    def compose(p, q):
        return tuple(p[q[i]] for i in range(5))

    rotation = (1, 2, 3, 4, 0)
    reflection = (0, 4, 3, 2, 1)
    centralizer = [
        p for p in permutations(range(5))
        if compose(p, rotation) == compose(rotation, p)
        and compose(p, reflection) == compose(reflection, p)
    ]
    assert centralizer == [tuple(range(5))]

    # Conceptual H^1 model: cocycles are the ten odd involutions (transpositions) in S5.
    def parity(p):
        return sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5)) % 2

    S5 = list(permutations(range(5)))
    A5_perm = [p for p in S5 if parity(p) == 0]
    transpositions = [p for p in S5 if parity(p) == 1 and compose(p, p) == tuple(range(5))]
    assert len(A5_perm) == 60 and len(transpositions) == 10
    t = transpositions[0]
    conjugacy_orbit = {
        compose(compose(a, t), tuple(a.index(i) for i in range(5))) for a in A5_perm
    }
    assert len(conjugacy_orbit) == 10
    assert sum(compose(a, t) == compose(t, a) for a in A5_perm) == 6

    # The companion inner/trivial-action taxonomy has two classes: 1 and a double transposition.
    even_involutions = [p for p in A5_perm if compose(p, p) == tuple(range(5))]
    assert len(even_involutions) == 16
    nontrivial_involutions = [p for p in even_involutions if p != tuple(range(5))]
    d = nontrivial_involutions[0]
    inner_orbit = {
        compose(compose(a, d), tuple(a.index(i) for i in range(5))) for a in A5_perm
    }
    assert len(inner_orbit) == 15
    assert sum(compose(a, d) == compose(d, a) for a in A5_perm) == 4

    # The intrinsic quotient has equation T^2-T-1; combine its split character with spinor (2/p).
    assert sorted(t for t in range(11) if (t*t - t - 1) % 11 == 0) == [4, 8]
    unit_classes = [r for r in range(1, 40, 2) if r % 5]
    golden_split = [r for r in unit_classes if r % 5 in (1, 4)]
    golden_inert = [r for r in unit_classes if r % 5 in (2, 3)]
    split_visible = [r for r in golden_split if r % 8 in (3, 5)]
    split_fused = [r for r in golden_split if r % 8 in (1, 7)]
    assert golden_inert == [3, 7, 13, 17, 23, 27, 33, 37]
    assert split_visible == [11, 19, 21, 29]
    assert split_fused == [1, 9, 31, 39]

    # The normalized Q-model extends integrally through 5 and has an exact ramified degeneration.
    def red5(x):
        a, b = x
        assert a.denominator % 5 and b.denominator % 5
        return (a.numerator * pow(a.denominator, -1, 5)
                + 3 * b.numerator * pow(b.denominator, -1, 5)) % 5

    def pnorm5(v):
        pivot = next(x for x in v if x % 5)
        invp = pow(pivot, -1, 5)
        return tuple(x * invp % 5 for x in v)

    arc_mod5 = sorted({pnorm5(tuple(red5(x) for x in v)) for v in descended_arc})
    assert arc_mod5 == [(1, 0, 2), (1, 2, 2), (1, 3, 2)]
    assert all(z == 2*x % 5 for x, y, z in arc_mod5)
    gram_mod5 = tuple(tuple(red5(x) for x in row) for row in gram)
    assert gram_mod5 == ((3, 0, 1), (0, 0, 0), (1, 0, 2))
    # y^T G y = 2*(z-2*x)^2 in F_5.
    for x in range(5):
        for y in range(5):
            for z in range(5):
                lhs = sum((x, y, z)[i] * gram_mod5[i][j] * (x, y, z)[j]
                          for i in range(3) for j in range(3)) % 5
                assert lhs == 2 * (z - 2*x)**2 % 5

    cocycles = []
    for u in sorted(descent_data, key=mat_key):
        cocycles.append({"matrix": mat_json(u), "raw_cocycle_scalar": q_json(cocycle_scalar(m, u))})

    return {
        "schema": SCHEMA,
        "scope": {
            "base_field": "Q",
            "splitting_field": "Q(phi), phi^2=phi+1",
            "object": "frozen golden six-arc with anisotropic conic and unique polar-pair matching",
            "completeness": "all descents through Q(phi)/Q inside the frozen PGL3 embedding",
            "absolute_forms": "H^1(Q,Aut) outside this quadratic splitting condition is not classified",
        },
        "input": {
            "c442_python": c442_path.name,
            "sha256": sha256(c442_path),
            "bytes": c442_path.stat().st_size,
        },
        "enumeration": {
            "geometric_stabilizer": "A5",
            "geometric_stabilizer_order": len(A5),
            "transporter_count": len(transporters),
            "projective_cocycle_count": len(descent_data),
            "gauge_orbit_count": len(gauge_orbits),
            "gauge_orbit_sizes": [len(o) for o in gauge_orbits],
            "cocycle_representatives": cocycles,
        },
        "representative": {
            "descent_cocycle_u_sigmaS_to_S": mat_json(u0),
            "hilbert90_h": mat_json(h),
            "identity": "u=h*sigma(h)^(-1); equivalently h=u*sigma(h)",
            "descended_arc_projective_points": [vec_json(v) for v in sorted(descended_arc)],
            "descended_conic_gram": rational_matrix_json(gram),
            "matching_polar_lines": [vec_json(v) for v in sorted(polar_lines)],
            "galois_pair_secants": [rational_matrix_json((ell,))[0] for ell in pair_secants],
            "galois_pair_secants_concurrent_at": ["1", "0", "0"],
        },
        "rational_stabilizer": {
            "isomorphism_type": "S3",
            "order": len(rational_stabilizer),
            "element_order_distribution": order_distribution,
            "generator_order_2": rational_matrix_json(gen2),
            "generator_order_3": rational_matrix_json(gen3),
            "all_projective_matrices": [rational_matrix_json(A) for A in sorted(rational_stabilizer, key=mat_key)],
            "canonical_fixed_point": ["1", "0", "0"],
            "canonical_polar_line": ["1", "0", "1/3"],
            "representation_shape": "1+2 over Q",
            "normal_C3_eigenpair": {
                "polar_line": "3*x+z=0",
                "intersection_with_conic": "5*(y^2+3*x^2)=0",
                "field": "Q(sqrt(-3))",
            },
        },
        "classification": {
            "quadratic_descent_classes": 1,
            "verdict": "the exhibited S3 form is the unique Q-form split by Q(sqrt5) in the frozen decorated category",
            "D5_test": "negative: no second quadratic descent class; a global D5-rational form is also impossible because an automorphism of A5 fixing D5 pointwise is trivial, which would force all A5 symmetry rational",
            "centralizer_of_natural_D5_in_Aut_A5_equals_S5_order": len(centralizer),
            "conceptual_H1": {
                "outer_involution_model": "conjugation by a transposition in Aut(A5)=S5",
                "cocycles_as_odd_involutions": len(transpositions),
                "A5_conjugacy_orbits": 1,
                "fixed_centralizer_order": 6,
            },
            "quadratic_A5_descent_taxonomy": {
                "inner_or_trivial_action": {
                    "H1_class_count": 2,
                    "cocycle_orbit_sizes": [1, 15],
                    "rational_fixed_groups": ["A5", "V4"],
                    "fixed_group_orders": [60, 4],
                },
                "outer_action": {
                    "H1_class_count": 1,
                    "cocycle_orbit_sizes": [10],
                    "rational_fixed_groups": ["S3"],
                    "fixed_group_orders": [6],
                },
                "quadratic_split_rational_symmetry_types": ["A5", "V4", "S3"],
            },
            "what_descends": ["six-point configuration as a degree-6 Q-subscheme", "anisotropic conic", "unique polar-pair matching"],
            "what_does_not_descend": "the golden sheet labeling: S versus sigma(S), equivalently a canonical prime above 11 / one of the two reduced singleton sheets",
            "intrinsic_golden_quotient": {
                "degree_6_etale_algebra": "Q(phi)^3",
                "three_closed_degree_2_points": True,
                "S3_action_on_closed_points": "full permutation action",
                "geometric_point_orbits": [3, 3],
                "galois_exchanges_orbits": True,
                "quotient_by_rational_S3": "Spec(Q(phi))",
                "rational_section": False,
                "integral_model_away_from_5": "Z[1/5,T]/(T^2-T-1)",
                "mod_11_factorization": "(T-4)*(T-8)",
            },
            "two_character_prime_machine_mod_40": {
                "golden_character": "(5/p): controls whether the quotient splits into two F_p sheets",
                "spinor_character": "(2/p): at golden-split primes, controls PSL distinction (-1) versus fusion (+1)",
                "golden_inert_no_Fp_sheet": golden_inert,
                "golden_split_PSL_visible": split_visible,
                "golden_split_PSL_fused": split_fused,
                "ramified_characteristic_5": "the two roots coalesce at T=3 and the quotient is nonreduced",
            },
            "characteristic_5_degeneration": {
                "integral_descended_model_exists": True,
                "quotient_algebra": "(F_5[epsilon]/epsilon^2)^3",
                "support_points": [list(v) for v in arc_mod5],
                "support_line": "z-2*x=0",
                "conic_equation": "2*(z-2*x)^2=0",
                "scheme_description": "three ramified length-2 points supported on the double line",
                "hilbert90_matrix_warning": "h has determinant 5, but the normalized descended coordinates and Gram matrix are integral",
            },
        },
    }


def canonical_bytes(obj) -> bytes:
    return (json.dumps(obj, indent=2, sort_keys=True) + "\n").encode()


def write_manifest():
    replay = HERE / f"{STEM}-replay.py"
    paths = [Path(__file__).resolve(), replay, JSON_PATH]
    SHA_PATH.write_text("".join(f"{sha256(path)}  notes/{path.name}\n" for path in paths))


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    if args.write:
        JSON_PATH.write_bytes(data)
        write_manifest()
        print(f"wrote {JSON_PATH.name} and {SHA_PATH.name}")
        return
    assert JSON_PATH.read_bytes() == data, "certificate drift"
    expected = {Path(line.split()[1]).name: line.split()[0] for line in SHA_PATH.read_text().splitlines()}
    for path in (Path(__file__).resolve(), JSON_PATH):
        assert expected[path.name] == sha256(path), f"hash drift: {path.name}"
    print("PASS C459 primary: 60 transporters, 10 cocycles, one gauge class, rational stabilizer S3")


if __name__ == "__main__":
    main()
