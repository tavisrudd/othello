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
            "what_descends": ["six-point configuration as a degree-6 Q-subscheme", "anisotropic conic", "unique polar-pair matching"],
            "what_does_not_descend": "the golden sheet labeling: S versus sigma(S), equivalently a canonical prime above 11 / one of the two reduced singleton sheets",
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
