#!/usr/bin/env python3
"""Exact maximal-order and residue-sheet certificate for C457/T10."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
STEM = ROOT / "notes" / "2026-07-21-c457-quaternion-order-reduction"
OUTPUT = STEM.with_suffix(".json")
MANIFEST = STEM.with_suffix(".sha256")
INPUT_STEMS = (
    "2026-07-21-c440-conventions-freeze",
    "2026-07-21-c442-antipodal-singleton-reduction",
    "2026-07-21-c458-golden-sheet-frame-freeze",
    "2026-07-21-c444-silver-fusion",
    "2026-07-19-c382-clebsch-icosian-e8-path-independence",
)


class Quad:
    """a+b*t in Q[t]/(t^2-A*t-B)."""

    __slots__ = ("a", "b", "A", "B")

    def __init__(self, a=0, b=0, *, A=0, B=0):
        self.a, self.b = Fraction(a), Fraction(b)
        self.A, self.B = A, B

    def coerce(self, other):
        return other if isinstance(other, Quad) else Quad(other, A=self.A, B=self.B)

    def __add__(self, other):
        other = self.coerce(other)
        return Quad(self.a + other.a, self.b + other.b, A=self.A, B=self.B)

    __radd__ = __add__

    def __neg__(self):
        return Quad(-self.a, -self.b, A=self.A, B=self.B)

    def __sub__(self, other):
        return self + -self.coerce(other)

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        return Quad(
            self.a * other.a + self.b * other.b * self.B,
            self.a * other.b + self.b * other.a + self.b * other.b * self.A,
            A=self.A,
            B=self.B,
        )

    __rmul__ = __mul__

    def conjugate(self):
        return Quad(self.a + self.A * self.b, -self.b, A=self.A, B=self.B)

    def inverse(self):
        norm = (self * self.conjugate()).a
        return self.conjugate() * (1 / norm)

    def __truediv__(self, other):
        return self * self.coerce(other).inverse()

    def __eq__(self, other):
        other = self.coerce(other)
        return (self.a, self.b, self.A, self.B) == (other.a, other.b, other.A, other.B)

    def __hash__(self):
        return hash((self.a, self.b, self.A, self.B))

    def encode(self):
        def enc(x):
            return int(x) if x.denominator == 1 else f"{x.numerator}/{x.denominator}"

        return [enc(self.a), enc(self.b)]


def qmul(x, y):
    a, b, c, d = x
    e, f, g, h = y
    return (
        a * e - b * f - c * g - d * h,
        a * f + b * e + c * h - d * g,
        a * g - b * h + c * e + d * f,
        a * h + b * g - c * f + d * e,
    )


def qconj(x):
    return (x[0], -x[1], -x[2], -x[3])


def quaternion_group(generators, expected_order):
    one = (generators[0][0].coerce(1),) + (generators[0][0].coerce(0),) * 3
    steps = tuple(generators) + tuple(qconj(g) for g in generators)
    seen, todo = {one}, deque([one])
    while todo:
        x = todo.popleft()
        for g in steps:
            y = qmul(x, g)
            if y not in seen:
                seen.add(y)
                todo.append(y)
                assert len(seen) <= expected_order
    assert len(seen) == expected_order
    return seen


def solve_basis(basis, target):
    aug = [[basis[j][i] for j in range(4)] + [target[i]] for i in range(4)]
    for col in range(4):
        pivot = next(row for row in range(col, 4) if aug[row][col] != 0)
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = aug[col][col]
        aug[col] = [x / scale for x in aug[col]]
        for row in range(4):
            if row != col:
                scale = aug[row][col]
                aug[row] = [aug[row][j] - scale * aug[col][j] for j in range(5)]
    return tuple(aug[i][4] for i in range(4))


def determinant(matrix):
    work = [list(row) for row in matrix]
    out = matrix[0][0].coerce(1)
    for col in range(len(work)):
        pivot = next(row for row in range(col, len(work)) if work[row][col] != 0)
        if pivot != col:
            work[col], work[pivot] = work[pivot], work[col]
            out = -out
        value = work[col][col]
        out *= value
        for row in range(col + 1, len(work)):
            scale = work[row][col] / value
            for j in range(col, len(work)):
                work[row][j] -= scale * work[col][j]
    return out


def order_certificate(basis):
    structure = []
    for i in range(4):
        row = []
        for j in range(4):
            coeffs = solve_basis(basis, qmul(basis[i], basis[j]))
            assert all(c.a.denominator == c.b.denominator == 1 for c in coeffs)
            row.append([c.encode() for c in coeffs])
        structure.append(row)
    gram = [
        [2 * sum((basis[i][k] * basis[j][k] for k in range(4)), basis[0][0].coerce(0)) for j in range(4)]
        for i in range(4)
    ]
    disc = determinant(gram)
    assert disc == 1
    return {
        "multiplication_structure_constants": structure,
        "reduced_trace_gram": [[x.encode() for x in row] for row in gram],
        "reduced_trace_discriminant": disc.encode(),
        "closed_over_integer_ring": True,
        "maximality_reason": "unit reduced-trace discriminant; hence every localization is maximal/Azumaya and there is no finite residue-characteristic denominator",
    }


def reduce_quad(x, root, prime):
    num = x.a.numerator * pow(x.a.denominator, -1, prime)
    num += x.b.numerator * pow(x.b.denominator, -1, prime) * root
    return num % prime


def mmul(x, y, p):
    a, b, c, d = x
    e, f, g, h = y
    return ((a * e + b * g) % p, (a * f + b * h) % p, (c * e + d * g) % p, (c * f + d * h) % p)


def madd(terms, p):
    return tuple(sum(term[i] for term in terms) % p for i in range(4))


def mscale(s, matrix, p):
    return tuple(s * x % p for x in matrix)


def qmatrix(quaternion, root, prime, I, J):
    one = (1, 0, 0, 1)
    K = mmul(I, J, prime)
    values = [reduce_quad(x, root, prime) for x in quaternion]
    return madd([mscale(values[0], one, prime), mscale(values[1], I, prime), mscale(values[2], J, prime), mscale(values[3], K, prime)], prime)


def matrix_group(generators, prime):
    identity = (1, 0, 0, 1)
    seen, todo = {identity}, deque([identity])
    while todo:
        g = todo.popleft()
        for h in generators:
            gh = mmul(g, h, prime)
            if gh not in seen:
                seen.add(gh)
                todo.append(gh)
    return seen


def normalize_matrix(g, prime):
    first = next(x for x in g if x % prime)
    inv = pow(first, -1, prime)
    return tuple(x * inv % prime for x in g)


def inv_matrix(g, prime):
    a, b, c, d = g
    det = (a * d - b * c) % prime
    z = pow(det, -1, prime)
    return (d * z % prime, -b * z % prime, -c * z % prime, a * z % prime)


def conjugate_group(group, comparison, prime):
    cinv = inv_matrix(comparison, prime)
    return {normalize_matrix(mmul(mmul(comparison, g, prime), cinv, prime), prime) for g in group}


def act_point(g, x, prime):
    infinity = prime
    a, b, c, d = g
    if x == infinity:
        return infinity if c == 0 else a * pow(c, -1, prime) % prime
    den = (c * x + d) % prime
    return infinity if den == 0 else (a * x + b) * pow(den, -1, prime) % prime


def permutation(g, prime):
    return tuple(act_point(g, x, prime) for x in range(prime + 1))


def matching_image(g, matching, prime):
    perm = permutation(g, prime)
    return tuple(sorted(tuple(sorted((perm[a], perm[b]))) for a, b in matching))


def pgl(prime):
    return {
        normalize_matrix((a, b, c, d), prime)
        for a in range(prime)
        for b in range(prime)
        for c in range(prime)
        for d in range(prime)
        if (a * d - b * c) % prime
    }


def invariant_pair_orbit(group, prime):
    perms = {permutation(g, prime) for g in group}
    pairs = {(a, b) for a in range(prime + 1) for b in range(a + 1, prime + 1)}
    orbits = []
    while pairs:
        pair = min(pairs)
        orbit = {tuple(sorted((g[pair[0]], g[pair[1]]))) for g in perms}
        pairs -= orbit
        orbits.append(orbit)
    matching = next(orbit for orbit in orbits if len(orbit) == (prime + 1) // 2)
    assert len(set().union(*(set(edge) for edge in matching))) == prime + 1
    return tuple(sorted(matching)), sorted(len(orbit) for orbit in orbits)


def rank_matrices(matrices, prime):
    work = [[x % prime for x in matrix] for matrix in matrices]
    rank = 0
    for col in range(4):
        pivot = next((r for r in range(rank, len(work)) if work[r][col]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inv = pow(work[rank][col], -1, prime)
        work[rank] = [x * inv % prime for x in work[rank]]
        for row in range(len(work)):
            if row != rank:
                scale = work[row][col]
                work[row] = [(work[row][j] - scale * work[rank][j]) % prime for j in range(4)]
        rank += 1
    return rank


def finite_case(name, basis, generators, root, prime, I, J, comparison, target, expected_spin):
    basis_images = [qmatrix(x, root, prime, I, J) for x in basis]
    assert rank_matrices(basis_images, prime) == 4
    spin = matrix_group(tuple(qmatrix(x, root, prime, I, J) for x in generators), prime)
    assert len(spin) == expected_spin
    projective = {normalize_matrix(g, prime) for g in spin}
    raw_matching, pair_orbits = invariant_pair_orbit(projective, prime)
    compared = conjugate_group(projective, comparison, prime)
    target = tuple(sorted(tuple(sorted(edge)) for edge in target))
    full_stabilizer = {g for g in pgl(prime) if matching_image(g, target, prime) == target}
    assert matching_image(comparison, raw_matching, prime) == target
    assert compared == full_stabilizer
    return {
        "name": name,
        "residue_root": root,
        "residue_field": f"F_{prime}",
        "order_reduction_matrix_rank": 4,
        "order_reduction_equals": f"M2(F_{prime})",
        "spin_group_order": len(spin),
        "projective_group_order": len(projective),
        "pair_orbit_sizes": pair_orbits,
        "raw_invariant_matching": [list(edge) for edge in raw_matching],
        "comparison_matrix": list(comparison),
        "frozen_matching": [list(edge) for edge in target],
        "comparison_gives_exact_full_stabilizer_equality": True,
    }


def digest(path):
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def build_certificate():
    inputs = {}
    loaded = {}
    for stem in INPUT_STEMS:
        report = ROOT / "notes" / f"{stem}.md"
        certificate = ROOT / "notes" / f"{stem}.json"
        inputs[stem] = {"report": digest(report), "certificate": digest(certificate)}
        loaded[stem] = json.loads(certificate.read_text())
    assert loaded[INPUT_STEMS[0]]["schema"] == "c440-conventions-freeze-v1"
    assert loaded[INPUT_STEMS[1]]["verdict"].startswith("GREEN") is False  # C442 was AMBER before C458
    assert loaded[INPUT_STEMS[2]]["verdict"].startswith("GREEN")
    assert loaded[INPUT_STEMS[3]]["verdict"].startswith("GREEN")
    assert loaded[INPUT_STEMS[4]]["gate"]["verdict"] == "RED_CATEGORY_MISMATCH"

    zero5, one5, phi = Quad(A=1, B=1), Quad(1, A=1, B=1), Quad(0, 1, A=1, B=1)
    H5 = (one5 / 2, one5 / 2, one5 / 2, one5 / 2)
    G5 = ((one5 - phi) / 2, phi / 2, zero5, one5 / 2)
    icosian_basis = ((one5, zero5, zero5, zero5), (zero5, one5, zero5, zero5), H5, G5)
    icosian_order = order_certificate(icosian_basis)
    binary_icosahedral = quaternion_group((H5, G5), 120)
    assert icosian_basis[1] in binary_icosahedral

    zero2, one2, sqrt2 = Quad(A=0, B=2), Quad(1, A=0, B=2), Quad(0, 1, A=0, B=2)
    R2 = (one2 / sqrt2, one2 / sqrt2, zero2, zero2)
    H2 = (one2 / 2, one2 / 2, one2 / 2, one2 / 2)
    binary_basis = ((one2, zero2, zero2, zero2), R2, H2, qmul(R2, H2))
    binary_order = order_certificate(binary_basis)
    binary_octahedral = quaternion_group((R2, H2), 48)
    assert all(element in binary_octahedral for element in binary_basis)

    I11, J11 = (0, 1, 10, 0), (1, 3, 3, 10)
    base = ((0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, 11))
    jmate = ((0, 10), (1, 11), (2, 7), (3, 5), (4, 8), (6, 9))
    h3_comparison = lambda root: (0, 1, 2, (9 - root) % 11)
    h3_pi = finite_case("H3/pi", icosian_basis, (H5, G5), 8, 11, I11, J11, h3_comparison(8), base, 120)
    h3_pibar = finite_case("H3/pibar", icosian_basis, (H5, G5), 4, 11, I11, J11, h3_comparison(4), jmate, 120)

    b3_cases = []
    b3_targets = {
        3: ((0, 7), (1, 3), (2, 6), (4, 5)),
        4: ((0, 7), (1, 5), (2, 3), (4, 6)),
    }
    for root in (3, 4):
        I7 = (0, 1, 6, 0)
        J7 = (2, root, root, 5)
        comparison = (1, root, 0, 1)
        b3_cases.append(finite_case(f"B3/sqrt2={root}", binary_basis, (R2, H2), root, 7, I7, J7, comparison, b3_targets[root], 48))

    return {
        "schema": "c457-quaternion-order-reduction-v1",
        "task": "C457/T10",
        "verdict": "GREEN — maximal orders reduce to full matrix orders and their spin units give the frozen H3/B3 sheet embeddings exactly",
        "inputs": inputs,
        "icosian_order": {
            "base_field": "Q(phi), phi^2=phi+1",
            "integer_ring": "Z[phi]",
            "quaternion_algebra": "(-1,-1) over Q(phi)",
            "basis": ["1", "i", "(1+i+j+k)/2", "((1-phi)+phi*i+k)/2"],
            "spin_generators": ["(1+i+j+k)/2", "((1-phi)+phi*i+k)/2"],
            "characteristic_zero_spin_group_order": len(binary_icosahedral),
            "spin_group_integrally_spans_displayed_order": True,
            **icosian_order,
            "prime_ideals": ["(11,phi-8)", "(11,phi-4)"],
            "localizations": ["I_(11,phi-8)", "I_(11,phi-4)"],
            "split_matrix_basis": {"i": list(I11), "j": list(J11)},
            "comparison_map_family": {
                "formula": "C(phi)=[[0,1],[2,9-phi]]",
                "determinant": -2,
                "at_phi_8": list(h3_comparison(8)),
                "at_phi_4": list(h3_comparison(4)),
                "galois_covariant": True,
                "boundary": "one O_5-valued formula for the two residue comparisons; it does not define a characteristic-zero split representation of the quaternion algebra",
            },
            "reductions": [h3_pi, h3_pibar],
            "structural_statement": "The same integral icosian order and binary-icosahedral unit group reduce through the two residue maps; after the displayed comparison maps their projective images equal a5(8) and a5(4), not merely conjugate subgroups of the same size.",
        },
        "binary_octahedral_order": {
            "base_field": "Q(sqrt2)",
            "integer_ring": "Z[sqrt2]",
            "quaternion_algebra": "(-1,-1) over Q(sqrt2)",
            "basis": ["1", "R=(1+i)/sqrt2", "H=(1+i+j+k)/2", "R*H"],
            "spin_generators": ["R", "H"],
            "characteristic_zero_spin_group_order": len(binary_octahedral),
            "spin_group_integrally_spans_displayed_order": True,
            **binary_order,
            "prime_ideals": ["(7,sqrt2-3)", "(7,sqrt2-4)"],
            "localizations": ["B_(7,sqrt2-3)", "B_(7,sqrt2-4)"],
            "reductions": b3_cases,
            "structural_statement": "The same maximal order and binary-octahedral unit group reduce at the two primes above 7; C_s=[[1,s],[0,1]] identifies the projective images exactly with the two frozen S4 matching stabilizers.",
        },
        "C382_boundary": "C382's red gate concerns a global comparison between a six-fibre Picard family and an E8/icosian lattice action. C457 is local order reduction of the genuine spin groups; it introduces no A5 action on a single C381 fibre and no E8 isometry, so it sharpens rather than repairs C382.",
        "A3_control": "C444's inert prime (5) in Z[sqrt2] remains the fused control: over F25 the two spin orientations are Frobenius-conjugate and projectivize to one F5 S4. C457 makes no two-prime claim there.",
        "trusted_boundary": "Exact quadratic-field and Hamilton-quaternion arithmetic; exhaustive multiplication tables and unit reduced-trace discriminants; exact finite matrix closure, order-basis rank, PGL enumeration, invariant matching extraction, and equality with full frozen matching stabilizers.",
    }


def rendered_json(certificate):
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes():
    paths = [STEM.with_suffix(ext) for ext in (".md", ".py")] + [
        ROOT / "notes" / "2026-07-21-c457-quaternion-order-reduction-replay.py",
        OUTPUT,
    ]
    return ("\n".join(f"{digest(path)['sha256']}  {path.relative_to(ROOT / 'notes')}" for path in paths) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check or --write")
    expected = rendered_json(build_certificate())
    if args.write:
        OUTPUT.write_bytes(expected)
        MANIFEST.write_bytes(manifest_bytes())
    else:
        assert OUTPUT.read_bytes() == expected
        assert MANIFEST.read_bytes() == manifest_bytes()
        print("C457 primary check: OK")


if __name__ == "__main__":
    main()
