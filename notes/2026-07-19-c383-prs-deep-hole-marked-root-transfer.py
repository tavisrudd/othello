#!/usr/bin/env python3
"""Exact q=7 scout for apolar profiles of PRS(2) deep-hole syndromes."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


Q = 7
M = 6
TRACKED = Path(__file__).with_suffix(".json")


def inv(a: int) -> int:
    return pow(a % Q, Q - 2, Q)


def normalize(v: tuple[int, ...]) -> tuple[int, ...]:
    for x in v:
        if x % Q:
            s = inv(x)
            return tuple((s * y) % Q for y in v)
    raise ValueError("zero vector has no projective normalization")


def projective_points(dim: int):
    for first in range(dim):
        prefix = (0,) * first + (1,)
        for tail in itertools.product(range(Q), repeat=dim - first - 1):
            yield prefix + tail


def curve_point(t: int | None) -> tuple[int, ...]:
    if t is None:
        return (0,) * (M - 1) + (1,)
    return tuple(pow(t, i, Q) for i in range(M))


def span_projective(columns: tuple[tuple[int, ...], ...]) -> set[tuple[int, ...]]:
    out: set[tuple[int, ...]] = set()
    for coeffs in itertools.product(range(Q), repeat=len(columns)):
        v = tuple(sum(coeffs[j] * columns[j][i] for j in range(len(columns))) % Q for i in range(M))
        if any(v):
            out.add(normalize(v))
    return out


def nullspace(matrix: list[list[int]]) -> list[tuple[int, ...]]:
    a = [[x % Q for x in row] for row in matrix]
    rows = len(a)
    cols = len(a[0])
    pivots: list[int] = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        scale = inv(a[r][c])
        a[r] = [(scale * x) % Q for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c]:
                scale = a[i][c]
                a[i] = [(a[i][j] - scale * a[r][j]) % Q for j in range(cols)]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in pivots]
    basis: list[tuple[int, ...]] = []
    for f in free:
        v = [0] * cols
        v[f] = 1
        for i, p in enumerate(pivots):
            v[p] = (-a[i][f]) % Q
        basis.append(tuple(v))
    return basis


def poly_trim(p: tuple[int, ...]) -> tuple[int, ...]:
    q = list(p)
    while len(q) > 1 and q[-1] % Q == 0:
        q.pop()
    return tuple(x % Q for x in q)


def poly_divmod(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[tuple[int, ...], tuple[int, ...]]:
    dividend = list(poly_trim(a))
    divisor = poly_trim(b)
    if divisor == (0,):
        raise ZeroDivisionError
    quotient = [0] * max(1, len(dividend) - len(divisor) + 1)
    while len(dividend) >= len(divisor) and any(dividend):
        shift = len(dividend) - len(divisor)
        scale = dividend[-1] * inv(divisor[-1]) % Q
        quotient[shift] = scale
        for i, x in enumerate(divisor):
            dividend[shift + i] = (dividend[shift + i] - scale * x) % Q
        dividend = list(poly_trim(tuple(dividend)))
    return poly_trim(tuple(quotient)), poly_trim(tuple(dividend))


def monic_polynomials(degree: int):
    for low in itertools.product(range(Q), repeat=degree):
        yield tuple(low) + (1,)


def irreducible_polynomials() -> tuple[tuple[int, ...], ...]:
    irreducibles: list[tuple[int, ...]] = []
    for degree in range(1, 5):
        for p in monic_polynomials(degree):
            reducible = False
            for d in range(1, degree // 2 + 1):
                if any(poly_divmod(p, f)[1] == (0,) for f in monic_polynomials(d)):
                    reducible = True
                    break
            if not reducible:
                irreducibles.append(p)
    return tuple(irreducibles)


IRREDUCIBLES = irreducible_polynomials()


def factorization_label(h: tuple[int, ...]) -> str:
    degree = max(i for i, x in enumerate(h) if x)
    factors: list[tuple[int, int]] = []
    if degree < 4:
        factors.append((1, 4 - degree))  # the projective root at infinity
    p = poly_trim(h)
    p = tuple(x * inv(p[-1]) % Q for x in p)
    for f in IRREDUCIBLES:
        if p == (1,):
            break
        multiplicity = 0
        while len(p) >= len(f):
            quotient, remainder = poly_divmod(p, f)
            if remainder != (0,):
                break
            p = quotient
            multiplicity += 1
        if multiplicity:
            factors.append((len(f) - 1, multiplicity))
    if poly_trim(p) != (1,):
        raise AssertionError("quartic factorization did not terminate")
    factors.sort()
    return "+".join(f"{degree}^{multiplicity}" for degree, multiplicity in factors)


FACTOR_LABELS = {h: factorization_label(h) for h in projective_points(5)}


def rational_root_count(h: tuple[int, ...]) -> int:
    roots = sum(1 for t in range(Q) if sum(h[i] * pow(t, i, Q) for i in range(5)) % Q == 0)
    return roots + int(h[4] == 0)


ROOT_COUNTS = {h: rational_root_count(h) for h in projective_points(5)}


def apolar_basis(v: tuple[int, ...], require_plane: bool = False) -> list[tuple[int, ...]]:
    basis = nullspace([list(v[:5]), list(v[1:])])
    if require_plane and len(basis) != 3:
        raise AssertionError("deep syndrome does not have a projective apolar plane")
    return basis


def apolar_quartic(basis: list[tuple[int, ...]], coeffs: tuple[int, ...]) -> tuple[int, ...]:
    return normalize(tuple(sum(coeffs[j] * basis[j][i] for j in range(len(basis))) % Q for i in range(5)))


def apolar_root_profile(v: tuple[int, ...]) -> tuple[int, ...]:
    basis = apolar_basis(v)
    histogram = [0] * 5
    for coeffs in projective_points(len(basis)):
        histogram[ROOT_COUNTS[apolar_quartic(basis, coeffs)]] += 1
    return tuple(histogram)


def apolar_full_profile(
    v: tuple[int, ...],
) -> tuple[tuple[int, ...], tuple[tuple[str, int], ...], tuple[tuple[tuple[tuple[str, int], ...], int], ...]]:
    basis = apolar_basis(v, require_plane=True)
    histogram = [0] * 5
    factorization: dict[str, int] = {}
    colors: dict[tuple[int, ...], str] = {}
    coefficient_points = tuple(projective_points(3))
    for coeffs in coefficient_points:
        h = apolar_quartic(basis, coeffs)
        roots = ROOT_COUNTS[h]
        histogram[roots] += 1
        label = FACTOR_LABELS[h]
        colors[coeffs] = label
        factorization[label] = factorization.get(label, 0) + 1
    line_profile_counts: dict[tuple[tuple[str, int], ...], int] = {}
    for line in projective_points(3):
        line_colors: dict[str, int] = {}
        for point in coefficient_points:
            if sum(line[i] * point[i] for i in range(3)) % Q == 0:
                label = colors[point]
                line_colors[label] = line_colors.get(label, 0) + 1
        if sum(line_colors.values()) != Q + 1:
            raise AssertionError("apolar projective line has incorrect size")
        profile = tuple(sorted(line_colors.items()))
        line_profile_counts[profile] = line_profile_counts.get(profile, 0) + 1
    return tuple(histogram), tuple(sorted(factorization.items())), tuple(sorted(line_profile_counts.items()))


def pgl2_representatives() -> list[tuple[int, int, int, int]]:
    reps: set[tuple[int, int, int, int]] = set()
    for a, b, c, d in itertools.product(range(Q), repeat=4):
        if (a * d - b * c) % Q:
            reps.add(normalize((a, b, c, d)))
    return sorted(reps)


def binom(n: int, k: int) -> int:
    if k < 0 or k > n:
        return 0
    result = 1
    for i in range(1, k + 1):
        result = result * (n - i + 1) // i
    return result


def representation(g: tuple[int, int, int, int]) -> tuple[tuple[int, ...], ...]:
    a, b, c, d = g
    rows = []
    for i in range(M):
        left = M - 1 - i
        right = i
        coeff = [0] * M
        for j in range(left + 1):
            for k in range(right + 1):
                coeff[j + k] += binom(left, j) * pow(a, left - j, Q) * pow(b, j, Q) * binom(right, k) * pow(c, right - k, Q) * pow(d, k, Q)
        rows.append(tuple(x % Q for x in coeff))
    return tuple(rows)


def matvec(matrix: tuple[tuple[int, ...], ...], v: tuple[int, ...]) -> tuple[int, ...]:
    return normalize(tuple(sum(row[j] * v[j] for j in range(M)) % Q for row in matrix))


def generate() -> dict:
    curve = tuple(curve_point(t) for t in range(Q)) + (curve_point(None),)
    all_points = set(projective_points(M))
    covered: set[tuple[int, ...]] = set()
    for indices in itertools.combinations(range(Q + 1), 4):
        covered.update(span_projective(tuple(curve[i] for i in indices)))
    deep = all_points - covered

    root_profile_of = {v: apolar_root_profile(v) for v in all_points}
    apolar_deep = {v for v, profile in root_profile_of.items() if profile[4] == 0}
    if deep != apolar_deep:
        raise AssertionError("direct four-secant coverage and apolar split-quartic test disagree")
    profile_of = {v: apolar_full_profile(v) for v in deep}

    group = pgl2_representatives()
    if len(group) != Q * (Q * Q - 1):
        raise AssertionError("incorrect PGL2 order")
    matrices = [representation(g) for g in group]
    curve_set = set(curve)
    for matrix in matrices:
        if {matvec(matrix, v) for v in curve} != curve_set:
            raise AssertionError("symmetric-power action does not preserve the normal rational curve")

    unseen = set(deep)
    orbits: list[set[tuple[int, ...]]] = []
    while unseen:
        seed = min(unseen)
        orbit = {matvec(matrix, seed) for matrix in matrices}
        if not orbit <= deep:
            raise AssertionError("PGL2 did not preserve the deep-hole set")
        orbits.append(orbit)
        unseen -= orbit

    root_profile_orbits: dict[tuple[int, ...], list[int]] = {}
    factor_profile_orbits: dict[tuple[tuple[str, int], ...], list[int]] = {}
    line_profile_orbits: dict[tuple[tuple[tuple[tuple[str, int], ...], int], ...], list[int]] = {}
    for orbit in orbits:
        profiles = {profile_of[v] for v in orbit}
        if len(profiles) != 1:
            raise AssertionError("apolar root profile is not PGL2-invariant")
        root_profile, factor_profile, line_profile = next(iter(profiles))
        root_profile_orbits.setdefault(root_profile, []).append(len(orbit))
        factor_profile_orbits.setdefault(factor_profile, []).append(len(orbit))
        line_profile_orbits.setdefault(line_profile, []).append(len(orbit))

    root_profiles = []
    for profile, orbit_sizes in sorted(root_profile_orbits.items()):
        root_profiles.append(
            {
                "root_support_histogram_0_to_4": list(profile),
                "orbit_sizes": sorted(orbit_sizes),
                "orbit_count": len(orbit_sizes),
                "point_count": sum(orbit_sizes),
            }
        )
    factor_profiles = []
    for profile, orbit_sizes in sorted(factor_profile_orbits.items()):
        factor_profiles.append(
            {
                "factorization_histogram": {key: value for key, value in profile},
                "orbit_sizes": sorted(orbit_sizes),
                "orbit_count": len(orbit_sizes),
                "point_count": sum(orbit_sizes),
            }
        )
    line_profiles = []
    for profile, orbit_sizes in sorted(line_profile_orbits.items()):
        line_payload = [
            {"line_color_histogram": {key: value for key, value in colors}, "line_count": count}
            for colors, count in profile
        ]
        canonical = json.dumps(line_payload, sort_keys=True, separators=(",", ":")).encode()
        line_profiles.append(
            {
                "line_profile_sha256": hashlib.sha256(canonical).hexdigest(),
                "distinct_line_color_profiles": len(profile),
                "orbit_sizes": sorted(orbit_sizes),
                "orbit_count": len(orbit_sizes),
                "point_count": sum(orbit_sizes),
            }
        )

    return {
        "schema": "c383-prs7-apolar-profile-v3",
        "field": {"kind": "prime", "q": Q},
        "code": {"name": "PRS_7(2)", "length": 8, "dimension": 2, "redundancy": 6},
        "projective_syndrome_space": {"dimension": 5, "point_count": len(all_points)},
        "normal_rational_curve_points": len(curve),
        "direct_union_of_four_point_spans": len(covered),
        "deep_hole_syndrome_points": len(deep),
        "apolar_split_quartic_zero_set_matches_direct_deep_set": True,
        "pgl2_order": len(group),
        "pgl2_deep_orbit_count": len(orbits),
        "pgl2_deep_orbit_sizes": sorted(len(orbit) for orbit in orbits),
        "apolar_rational_root_profile_count": len(root_profiles),
        "apolar_rational_root_profile_is_complete_orbit_invariant": all(item["orbit_count"] == 1 for item in root_profiles),
        "apolar_rational_root_profiles": root_profiles,
        "apolar_factorization_profile_count": len(factor_profiles),
        "apolar_factorization_profile_is_complete_orbit_invariant": all(item["orbit_count"] == 1 for item in factor_profiles),
        "apolar_factorization_profiles": factor_profiles,
        "apolar_colored_plane_profile_count": len(line_profiles),
        "apolar_colored_plane_profile_is_complete_orbit_invariant": all(item["orbit_count"] == 1 for item in line_profiles),
        "apolar_colored_plane_profiles": line_profiles,
    }


def encoded(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    data = generate()
    payload = encoded(data)
    if args.check:
        tracked = TRACKED.read_bytes()
        if tracked != payload:
            raise SystemExit("tracked JSON differs from deterministic regeneration")
        print(f"OK {TRACKED.name} sha256={hashlib.sha256(payload).hexdigest()} bytes={len(payload)}")
        return
    if args.output:
        args.output.write_bytes(payload)
    else:
        print(payload.decode(), end="")


if __name__ == "__main__":
    main()
