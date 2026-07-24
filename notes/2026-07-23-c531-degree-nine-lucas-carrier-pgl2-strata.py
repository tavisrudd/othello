#!/usr/bin/env python3
"""Generate the compact exact certificate for C531.

The computation uses only integer arithmetic, polynomial arithmetic over F_2,
and deterministic finite-field enumeration.  It certifies the modular
representation identities, the bounded rational-orbit controls, and one split
squarefree kernel witness per rational orbit in the checked fields.
"""

from __future__ import annotations

import argparse
from collections import deque
from itertools import combinations, product
import json
from math import comb
from pathlib import Path
import tempfile


STEM = "2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata"
INF = -1


def degree(f: int) -> int:
    return f.bit_length() - 1


def poly_mod(f: int, modulus: int) -> int:
    n = degree(modulus)
    while degree(f) >= n:
        f ^= modulus << (degree(f) - n)
    return f


def poly_mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        a <<= 1
        b >>= 1
    return out


def poly_gcd(a: int, b: int) -> int:
    while b:
        a, b = b, poly_mod(a, b)
    return a


def gf_mul(a: int, b: int, modulus: int) -> int:
    return poly_mod(poly_mul(a, b), modulus)


def gf_pow(a: int, exponent: int, modulus: int) -> int:
    out = 1
    while exponent:
        if exponent & 1:
            out = gf_mul(out, a, modulus)
        a = gf_mul(a, a, modulus)
        exponent >>= 1
    return out


def irreducible(f: int, m: int) -> bool:
    x = 2
    z = x
    for i in range(1, m + 1):
        z = gf_mul(z, z, f)
        if i <= m // 2 and poly_gcd(z ^ x, f) != 1:
            return False
    return z == x


def first_irreducible(m: int) -> int:
    for low in range(1, 1 << m, 2):
        f = (1 << m) | low
        if irreducible(f, m):
            return f
    raise AssertionError(f"no irreducible polynomial of degree {m}")


def prime_factors(n: int) -> list[int]:
    factors = []
    d = 2
    while d * d <= n:
        if n % d == 0:
            factors.append(d)
            while n % d == 0:
                n //= d
        d += 1
    if n > 1:
        factors.append(n)
    return factors


def primitive_element(q: int, modulus: int) -> int:
    factors = prime_factors(q - 1)
    for a in range(2, q):
        if all(gf_pow(a, (q - 1) // r, modulus) != 1 for r in factors):
            return a
    raise AssertionError("no primitive element")


Monomial = tuple[int, int, int, int]
Polynomial = set[Monomial]


def polynomial_sum(*terms: Polynomial) -> Polynomial:
    out: Polynomial = set()
    for term in terms:
        out.symmetric_difference_update(term)
    return out


def polynomial_product(left: Polynomial, right: Polynomial) -> Polynomial:
    out: Polynomial = set()
    for x in left:
        for y in right:
            z = tuple(a + b for a, b in zip(x, y))
            if z in out:
                out.remove(z)
            else:
                out.add(z)
    return out


def polynomial_fourth(term: Polynomial) -> Polynomial:
    square = polynomial_product(term, term)
    return polynomial_product(square, square)


def monomial(a: int = 0, b: int = 0, c: int = 0, d: int = 0) -> Polynomial:
    return {(a, b, c, d)}


def action_entry(source: int, target: int) -> Polynomial:
    """Coefficient of x^(9-source)y^source in target monomial after substitution."""
    out: Polynomial = set()
    for r in range(10 - target):
        s = 9 - source - r
        if (
            0 <= s <= target
            and comb(9 - target, r) % 2
            and comb(target, s) % 2
        ):
            out.add((r, 9 - target - r, s, target - s))
    return out


def representation_certificate() -> dict[str, object]:
    delta = polynomial_sum(monomial(a=1, d=1), monomial(b=1, c=1))
    delta2 = polynomial_product(delta, delta)
    delta4 = polynomial_product(delta2, delta2)
    columns = {
        0: (monomial(a=1), monomial(c=1)),
        1: (monomial(b=1), monomial(d=1)),
    }
    tensor_sources = {2: (0, 0), 3: (0, 1), 6: (1, 0), 7: (1, 1)}
    support: dict[str, list[int]] = {}
    for source in range(2, 8):
        targets = [target for target in range(10) if action_entry(source, target)]
        support[str(source)] = targets
        assert set(targets) <= set(range(2, 8))
    for source, (row, col) in tensor_sources.items():
        expected = (
            polynomial_product(
                delta2,
                polynomial_product(
                    polynomial_fourth(columns[row][0]),
                    columns[col][0],
                ),
            ),
            polynomial_product(
                delta2,
                polynomial_product(
                    polynomial_fourth(columns[row][0]),
                    columns[col][1],
                ),
            ),
            polynomial_product(
                delta2,
                polynomial_product(
                    polynomial_fourth(columns[row][1]),
                    columns[col][0],
                ),
            ),
            polynomial_product(
                delta2,
                polynomial_product(
                    polynomial_fourth(columns[row][1]),
                    columns[col][1],
                ),
            ),
        )
        for target, want in zip((2, 3, 6, 7), expected):
            assert action_entry(source, target) == want
    quotient_expected = {
        (4, 4): polynomial_product(delta4, monomial(a=1)),
        (4, 5): polynomial_product(delta4, monomial(c=1)),
        (5, 4): polynomial_product(delta4, monomial(b=1)),
        (5, 5): polynomial_product(delta4, monomial(d=1)),
    }
    for key, want in quotient_expected.items():
        assert action_entry(*key) == want
    return {
        "carrier_basis": [2, 3, 4, 5, 6, 7],
        "invariant_tensor_block": [2, 3, 6, 7],
        "action_target_support": support,
        "tensor_identity": "U = det^2 tensor (E^(4) tensor E); A -> det(g)^2 g^(4) A g^T",
        "quotient_identity": "M/U = det^4 tensor E",
        "rank_one_graph": "[u^(4) tensor u] for [u] in P1",
        "rank_two_representative": "e3+e6 (alternating matrix J)",
        "rank_two_geometric_stabilizer": "PGL2(F4), order 60",
    }


def canonical(point: tuple[int, ...], modulus: int) -> tuple[int, ...]:
    q = 1 << degree(modulus)
    for coordinate in point:
        if coordinate:
            inverse = gf_pow(coordinate, q - 2, modulus)
            return tuple(gf_mul(x, inverse, modulus) for x in point)
    raise AssertionError("zero projective point")


def matrix_action(
    point: tuple[int, int, int, int],
    matrix: tuple[int, int, int, int],
    modulus: int,
) -> tuple[int, int, int, int]:
    a, b, c, d = matrix
    af, bf, cf, df = (gf_pow(x, 4, modulus) for x in matrix)
    x, y, z, w = point
    left = (
        gf_mul(af, x, modulus) ^ gf_mul(bf, z, modulus),
        gf_mul(af, y, modulus) ^ gf_mul(bf, w, modulus),
        gf_mul(cf, x, modulus) ^ gf_mul(df, z, modulus),
        gf_mul(cf, y, modulus) ^ gf_mul(df, w, modulus),
    )
    return canonical(
        (
            gf_mul(left[0], a, modulus) ^ gf_mul(left[1], b, modulus),
            gf_mul(left[0], c, modulus) ^ gf_mul(left[1], d, modulus),
            gf_mul(left[2], a, modulus) ^ gf_mul(left[3], b, modulus),
            gf_mul(left[2], c, modulus) ^ gf_mul(left[3], d, modulus),
        ),
        modulus,
    )


def determinant(point: tuple[int, int, int, int], modulus: int) -> int:
    return gf_mul(point[0], point[3], modulus) ^ gf_mul(
        point[1], point[2], modulus
    )


def graph_points(q: int, modulus: int) -> set[tuple[int, int, int, int]]:
    points = set()
    for u in [(1, t) for t in range(q)] + [(0, 1)]:
        points.add(
            canonical(
                (
                    gf_mul(gf_pow(u[0], 4, modulus), u[0], modulus),
                    gf_mul(gf_pow(u[0], 4, modulus), u[1], modulus),
                    gf_mul(gf_pow(u[1], 4, modulus), u[0], modulus),
                    gf_mul(gf_pow(u[1], 4, modulus), u[1], modulus),
                ),
                modulus,
            )
        )
    assert len(points) == q + 1
    return points


def roots_to_polynomial(roots: tuple[int, ...], modulus: int) -> tuple[int, ...]:
    coefficients = [1]
    for root in roots:
        nxt = [0] * (len(coefficients) + 1)
        for i, coefficient in enumerate(coefficients):
            nxt[i] ^= gf_mul(coefficient, root, modulus)
            nxt[i + 1] ^= coefficient
        coefficients = nxt
    return tuple(coefficients + [0] * (9 - len(coefficients)))


def in_kernel(
    point: tuple[int, int, int, int],
    coefficients: tuple[int, ...],
    modulus: int,
) -> bool:
    syndrome = (point[0], point[1], point[2], point[3])
    indices = (2, 3, 6, 7)
    first = 0
    second = 0
    for value, index in zip(syndrome, indices):
        first ^= gf_mul(value, coefficients[index - 1], modulus)
        second ^= gf_mul(value, coefficients[index], modulus)
    return first == second == 0


def fmt_field_element(value: int) -> str:
    return "inf" if value == INF else hex(value)


def orbit_control(m: int) -> dict[str, object]:
    q = 1 << m
    modulus = first_irreducible(m)
    primitive = primitive_element(q, modulus)
    generators = (
        (1, 1, 0, 1),
        (primitive, 0, 0, 1),
        (0, 1, 1, 0),
    )
    points = [
        (0,) * lead + (1,) + tail
        for lead in range(4)
        for tail in product(range(q), repeat=3 - lead)
    ]
    graph = graph_points(q, modulus)
    orbit_index: dict[tuple[int, int, int, int], int] = {}
    orbits: list[dict[str, object]] = []
    for seed in points:
        if seed in orbit_index:
            continue
        seen = {seed}
        queue = deque([seed])
        while queue:
            point = queue.popleft()
            for generator in generators:
                image = matrix_action(point, generator, modulus)
                if image not in seen:
                    seen.add(image)
                    queue.append(image)
        index = len(orbits)
        for point in seen:
            orbit_index[point] = index
        rank = 1 if determinant(seed, modulus) == 0 else 2
        kind = "rank2"
        if rank == 1:
            kind = "graph" if seed in graph else "rank1_off_graph"
        orbits.append(
            {
                "kind": kind,
                "representative_hex": [hex(x) for x in seed],
                "orbit_size": len(seen),
                "stabilizer_order": q * (q * q - 1) // len(seen),
            }
        )
    expected_rank_two_sizes = {
        3: [84, 168, 252],
        4: [68, 816, 816, 1020, 1360],
        5: [5456, 10912, 16368],
    }
    assert sorted(
        orbit["orbit_size"] for orbit in orbits if orbit["kind"] == "rank2"
    ) == expected_rank_two_sizes[m]
    assert sorted(
        orbit["orbit_size"]
        for orbit in orbits
        if orbit["kind"] == "rank1_off_graph"
    ) == [q * (q + 1)]
    assert sorted(
        orbit["orbit_size"] for orbit in orbits if orbit["kind"] == "graph"
    ) == [q + 1]

    known_root_sets = {
        4: {
            (1, 0, 0, 0): (1, 2, 3, 4, 7, 9, 11, 12),
            (1, 0, 1, 0): (0, 1, 2, 3, 4, 7, 9, 12),
            (1, 0, 0, 1): (0, 1, 2, 3, 4, 7, 10, 13),
            (1, 0, 0, 2): (0, 1, 2, 3, 4, 6, 10, 14),
            (1, 0, 0, 4): (0, 1, 2, 3, 5, 11, 12, 13),
            (1, 0, 1, 2): (0, 1, 2, 3, 6, 11, 14, 15),
            (1, 0, 1, 1): (0, 1, 2, 3, 6, 7, 10, 12),
        },
        5: {
            (1, 0, 0, 0): (1, 2, 3, 4, 5, 6, 12, 17),
            (1, 0, 1, 0): (0, 1, 2, 3, 4, 6, 10, 22),
            (1, 0, 1, 7): (0, 1, 2, 3, 4, 8, 11, INF),
            (1, 0, 1, 1): (0, 1, 2, 3, 4, 10, 22, 28),
            (1, 0, 0, 1): (0, 1, 2, 3, 4, 13, 16, 27),
        },
    }
    missing = set(range(len(orbits)))
    witnesses: dict[int, dict[str, object]] = {}
    divisor_counts = [0] * len(orbits)
    subsets_tested = 0
    root_sets: object
    if m == 3:
        root_sets = combinations(tuple(range(q)) + (INF,), 8)
    else:
        roots_by_representative = known_root_sets[m]
        assert len(roots_by_representative) == len(orbits)
        root_sets = roots_by_representative.values()
    for root_set in root_sets:
        subsets_tested += 1
        finite_roots = tuple(root for root in root_set if root != INF)
        coefficients = roots_to_polynomial(finite_roots, modulus)
        candidates = range(len(orbits)) if m == 3 else tuple(sorted(missing))
        for index in candidates:
            representative = tuple(
                int(x, 16) for x in orbits[index]["representative_hex"]
            )
            if in_kernel(representative, coefficients, modulus):
                if m == 3:
                    divisor_counts[index] += 1
                if index in missing:
                    witnesses[index] = {
                        "roots_hex": [fmt_field_element(x) for x in root_set],
                        "coefficients_low_to_high_hex": [
                            hex(x) for x in coefficients
                        ],
                    }
                    missing.remove(index)
        if not missing and m != 3:
            break
    if m != 3:
        assert not missing
    for index, witness in witnesses.items():
        orbits[index]["split_squarefree_witness"] = witness
    for index in missing:
        orbits[index]["split_squarefree_witness"] = None
    if m == 3:
        for index, count in enumerate(divisor_counts):
            orbits[index]["split_divisor_count"] = count
        assert sum(
            orbit["orbit_size"] * count
            for orbit, count in zip(orbits, divisor_counts)
        ) == (q + 1) * (q * q + q + 1)
    orbits.sort(
        key=lambda row: (
            {"graph": 0, "rank1_off_graph": 1, "rank2": 2}[row["kind"]],
            row["orbit_size"],
            row["representative_hex"],
        )
    )
    return {
        "m": m,
        "q": q,
        "modulus_hex": hex(modulus),
        "PGL2_order": q * (q * q - 1),
        "projective_tensor_points": len(points),
        "subsets_tested_until_all_orbits_witnessed": subsets_tested,
        "complete_projective_8_subset_scan": m == 3,
        "split_free_orbit_count": len(missing),
        "orbits": orbits,
    }


def certificate() -> dict[str, object]:
    return {
        "schema": "c531-degree-nine-lucas-carrier-strata-v1",
        "field_characteristic": 2,
        "representation": representation_certificate(),
        "geometric_strata": [
            {
                "name": "Frobenius graph",
                "dimension": 1,
                "stabilizer": "Borel",
                "closure": "closed",
                "arithmetic": "shallow for every q=2^m, m>=3 (C530)",
            },
            {
                "name": "rank-one off graph",
                "dimension": 2,
                "stabilizer": "split torus",
                "closure": "adds the Frobenius graph",
                "arithmetic": "shallow for every q=2^m, m>=3 by reciprocal subspace polynomial",
            },
            {
                "name": "rank two",
                "dimension": 3,
                "stabilizer": "PGL2(F4)",
                "closure": "adds the full rank-one quadric",
                "arithmetic": "nonconstant Artin-Schreier C2 layer; global deepness unresolved",
            },
        ],
        "rank_two_rational_twists": {
            "m_even": {
                "classes": ["1A", "2A", "3A", "5A", "5B"],
                "centralizer_orders": [60, 4, 3, 5, 5],
                "coefficient_Frobenius": "fixes 1A,2A,3A and swaps 5A,5B",
            },
            "m_odd": {
                "classes": [
                    "transposition-twisted",
                    "(2)(3)-twisted",
                    "4-cycle-twisted",
                ],
                "centralizer_orders": [6, 3, 2],
            },
        },
        "rank_two_six_root_normalization": {
            "representative": "e3+e6",
            "kernel_equations": ["b2+b5=0", "b3+b6=0"],
            "A": [
                "A0=h0+h3",
                "A1=h1+h4",
                "A2=h2+h5",
                "A3=h3+1",
            ],
            "Delta": "A1*A3+A2^2",
            "Ns": "A0*A3+A1*A2",
            "Np": "A1^2+A0*A2",
            "s": "Ns/Delta",
            "p": "Np/Delta",
            "artin_schreier_rhs": "Np*Delta/Ns^2",
            "residue_on_Ns": "Delta^2*A1/A3",
            "geometric_deck_group": "C2",
            "rational_lift": "Tr_Fq/F2(Np*Delta/Ns^2)=0",
        },
        "bounded_controls": [orbit_control(m) for m in (3, 4, 5)],
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = certificate()
    payload = canonical_bytes(data)
    if args.check:
        with tempfile.TemporaryDirectory(prefix="c531-check-") as directory:
            candidate = Path(directory) / f"{STEM}.json"
            candidate.write_bytes(payload)
            expected = args.check.read_bytes()
            if candidate.read_bytes() != expected:
                raise SystemExit(f"certificate drift: {args.check}")
        print(f"OK {args.check}")
        return
    output = args.output or Path(__file__).with_suffix(".json")
    output.write_bytes(payload)
    print(output)


if __name__ == "__main__":
    main()
