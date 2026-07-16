#!/usr/bin/env python3
"""Generate compact C151 obstruction masks for the five minimum Q25 rows.

This is a proposal generator, not a trusted checker.  It uses the same concrete
field model as ``RelativeConicArcs.GF25``: elements are encoded as ``a + 5*b``
in ``F_5[w]/(w^2 - 2)``.  For each normalized eight-point row it evaluates the
``ReflectedLegal`` decomposition

  * freshness of the candidate conjugate pair;
  * avoidance of the 28 old secants by the selected representative; and
  * avoidance of the candidate carrier by the eight old points.

Every result is independently compared with a direct ``LegalPair``-style
evaluation (freshness plus both successive ``RawExtension`` checks).  Bits are
indexed by the stable Lean ``orbitNumber`` in the range 0..309.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from dataclasses import dataclass
from itertools import combinations, product
from typing import Iterable, Sequence

Vec = tuple[int, int, int]
Orbit = tuple[Vec, Vec]

WORD_BITS = 64
ORBIT_COUNT = 310
WORD_COUNT = (ORBIT_COUNT + WORD_BITS - 1) // WORD_BITS

# C150 residual-orbit representatives.  The first entry, 65, maps to Lean
# orbitNumber 5; the other two are converted below rather than trusted.
INTERNAL_REPRESENTATIVES = (
    (65, 93, 154),
    (65, 96, 216),
    (65, 98, 251),
    (65, 119, 232),
    (65, 123, 279),
)
EXPECTED_LEAN_ROWS = (
    (5, 58, 169),
    (5, 61, 81),
    (5, 63, 141),
    (5, 97, 109),
    (5, 113, 194),
)


def add(x: int, y: int) -> int:
    return ((x % 5 + y % 5) % 5) + 5 * ((x // 5 + y // 5) % 5)


def neg(x: int) -> int:
    return ((-x) % 5) + 5 * ((-(x // 5)) % 5)


def sub(x: int, y: int) -> int:
    return add(x, neg(y))


def mul(x: int, y: int) -> int:
    a, b, c, d = x % 5, x // 5, y % 5, y // 5
    return ((a * c + 2 * b * d) % 5) + 5 * ((a * d + b * c) % 5)


def power(x: int, n: int) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, x)
        x = mul(x, x)
        n >>= 1
    return out


def normalize(v: Vec) -> Vec:
    pivot = next(x for x in v if x)
    inverse = power(pivot, 23)
    return tuple(mul(x, inverse) for x in v)  # type: ignore[return-value]


def point_key(v: Vec) -> int:
    return v[0] + 25 * v[1] + 625 * v[2]


def point_rank(v: Vec) -> int:
    if v[0] == 1:
        return v[1] * 25 + v[2]
    if v[1] == 1:
        return 625 + v[2]
    return 650


def conjugate(v: Vec) -> Vec:
    return normalize(tuple(power(x, 5) for x in v))  # type: ignore[arg-type]


def cross(a: Vec, b: Vec) -> Vec:
    return normalize(
        (
            sub(mul(a[1], b[2]), mul(a[2], b[1])),
            sub(mul(a[2], b[0]), mul(a[0], b[2])),
            sub(mul(a[0], b[1]), mul(a[1], b[0])),
        )
    )


def dot(a: Vec, b: Vec) -> int:
    return add(add(mul(a[0], b[0]), mul(a[1], b[1])), mul(a[2], b[2]))


def determinant(a: Vec, b: Vec, c: Vec) -> int:
    """A projectively scaled determinant; only zero/nonzero is consumed."""

    return dot(c, cross(a, b))


def lean_orbit_number(p: Vec, q: Vec) -> int:
    """Mirror ``Q25PairCertificate.orbitNumber`` on a conjugate pair."""

    v = p if point_rank(p) < point_rank(q) else q
    if v[0] == 1:
        yr, yi = v[1] % 5, v[1] // 5
        if yi:
            assert yi in (1, 2)
            return (yr * 2 + yi - 1) * 25 + v[2]
        zr, zi = v[2] % 5, v[2] // 5
        assert zi in (1, 2)
        return 250 + (yr * 5 + zr) * 2 + zi - 1
    zr, zi = v[2] % 5, v[2] // 5
    assert v[1] == 1 and zi in (1, 2)
    return 300 + zr * 2 + zi - 1


@dataclass(frozen=True)
class Geometry:
    points: tuple[Vec, ...]
    fixed: tuple[Vec, ...]
    internal_orbits: tuple[Orbit, ...]
    orbit_by_number: tuple[Orbit, ...]


def enumerate_geometry() -> Geometry:
    points: list[Vec] = []
    seen: set[int] = set()
    for raw in product(range(25), repeat=3):
        if raw == (0, 0, 0):
            continue
        point = normalize(raw)
        if point_key(point) not in seen:
            seen.add(point_key(point))
            points.append(point)
    assert len(points) == 651

    point_index = {point_key(point): i for i, point in enumerate(points)}
    sigma = [point_index[point_key(conjugate(point))] for point in points]
    fixed = tuple(points[i] for i, j in enumerate(sigma) if i == j)
    internal = tuple(
        (points[i], points[sigma[i]]) for i in range(len(points)) if i < sigma[i]
    )
    assert len(fixed) == 31
    assert len(internal) == ORBIT_COUNT

    numbered: dict[int, Orbit] = {}
    for p, q in internal:
        if point_rank(q) < point_rank(p):
            p, q = q, p
        number = lean_orbit_number(p, q)
        assert number not in numbered
        assert point_rank(p) < point_rank(q)
        numbered[number] = (p, q)
    assert set(numbered) == set(range(ORBIT_COUNT))

    # These are exactly the two fixed points in Q25PairCertificate.fixedPair.
    assert fixed[0] == (0, 0, 1)
    assert fixed[1] == (0, 1, 0)
    return Geometry(
        tuple(points),
        fixed,
        internal,
        tuple(numbered[number] for number in range(ORBIT_COUNT)),
    )


def raw_cap(points: Sequence[Vec]) -> bool:
    return all(determinant(a, b, c) != 0 for a, b, c in combinations(points, 3))


def raw_extension(old: Sequence[Vec], candidate: Vec) -> bool:
    return all(determinant(a, b, candidate) != 0 for a, b in combinations(old, 2))


def direct_legal_pair(old: Sequence[Vec], orbit: Orbit) -> bool:
    """Mirror LegalPair directly, without using the reflected factorization."""

    p, q = orbit
    old_set = set(old)
    return (
        p not in old_set
        and raw_extension(old, p)
        and q not in old_set | {p}
        and raw_extension(tuple(old) + (p,), q)
    )


@dataclass(frozen=True)
class CandidateResult:
    freshness_obstruction: bool
    secant_obstruction: bool
    carrier_obstruction: bool

    @property
    def legal(self) -> bool:
        return not (
            self.freshness_obstruction
            or self.secant_obstruction
            or self.carrier_obstruction
        )


def reflected_result(old: Sequence[Vec], orbit: Orbit) -> CandidateResult:
    p, q = orbit
    old_set = set(old)
    secants = tuple(cross(a, b) for a, b in combinations(old, 2))
    assert len(secants) == 28
    assert len(set(secants)) == 28
    carrier = cross(p, q)
    return CandidateResult(
        freshness_obstruction=p in old_set or q in old_set,
        secant_obstruction=any(dot(p, line) == 0 for line in secants),
        carrier_obstruction=any(dot(a, carrier) == 0 for a in old),
    )


def mask_words(indices: Iterable[int]) -> tuple[int, ...]:
    words = [0] * WORD_COUNT
    for index in indices:
        assert 0 <= index < ORBIT_COUNT
        words[index // WORD_BITS] |= 1 << (index % WORD_BITS)
    assert words[-1] >> (ORBIT_COUNT % WORD_BITS) == 0
    return tuple(words)


@dataclass(frozen=True)
class RowMasks:
    row: tuple[int, int, int]
    freshness: tuple[int, ...]
    secant: tuple[int, ...]
    carrier: tuple[int, ...]
    legal: tuple[int, ...]
    legal_numbers: tuple[int, ...]


def normalized_row(geometry: Geometry, row: tuple[int, int, int]) -> tuple[Vec, ...]:
    points: list[Vec] = [geometry.fixed[0], geometry.fixed[1]]
    for number in row:
        points.extend(geometry.orbit_by_number[number])
    assert len(points) == 8 and len(set(points)) == 8
    assert raw_cap(points)
    return tuple(points)


def compute_row_masks(geometry: Geometry, row: tuple[int, int, int]) -> RowMasks:
    old = normalized_row(geometry, row)
    results = tuple(reflected_result(old, orbit) for orbit in geometry.orbit_by_number)
    direct = tuple(direct_legal_pair(old, orbit) for orbit in geometry.orbit_by_number)
    reflected = tuple(result.legal for result in results)
    assert reflected == direct

    legal_numbers = tuple(number for number, legal in enumerate(reflected) if legal)
    assert len(legal_numbers) == 32
    return RowMasks(
        row=row,
        freshness=mask_words(
            number for number, result in enumerate(results) if result.freshness_obstruction
        ),
        secant=mask_words(
            number for number, result in enumerate(results) if result.secant_obstruction
        ),
        carrier=mask_words(
            number for number, result in enumerate(results) if result.carrier_obstruction
        ),
        legal=mask_words(legal_numbers),
        legal_numbers=legal_numbers,
    )


def known_rows(geometry: Geometry) -> tuple[tuple[int, int, int], ...]:
    internal_numbers = tuple(
        tuple(sorted(lean_orbit_number(*geometry.internal_orbits[i]) for i in representative))
        for representative in INTERNAL_REPRESENTATIVES
    )
    assert internal_numbers == EXPECTED_LEAN_ROWS
    return internal_numbers


def compute_all() -> tuple[RowMasks, ...]:
    geometry = enumerate_geometry()
    return tuple(compute_row_masks(geometry, row) for row in known_rows(geometry))


def data_fingerprint(rows: Sequence[RowMasks]) -> str:
    payload = [
        {
            "row": row.row,
            "freshness": row.freshness,
            "secant": row.secant,
            "carrier": row.carrier,
            "legal": row.legal,
            "legal_numbers": row.legal_numbers,
        }
        for row in rows
    ]
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def lean_array(values: Sequence[int]) -> str:
    return "#[" + ", ".join(map(str, values)) + "]"


def emit_summary(rows: Sequence[RowMasks]) -> None:
    print(f"rows={len(rows)} orbits={ORBIT_COUNT} words_per_mask={WORD_COUNT}")
    print(f"data_sha256={data_fingerprint(rows)}")
    for result in rows:
        counts = {
            "fresh": sum(word.bit_count() for word in result.freshness),
            "secant": sum(word.bit_count() for word in result.secant),
            "carrier": sum(word.bit_count() for word in result.carrier),
        }
        print(
            f"row={','.join(map(str, result.row))} legal={len(result.legal_numbers)} "
            f"blocked_fresh={counts['fresh']} blocked_secant={counts['secant']} "
            f"blocked_carrier={counts['carrier']}"
        )
        print("legal_numbers=" + ",".join(map(str, result.legal_numbers)))


def emit_json(rows: Sequence[RowMasks]) -> None:
    payload = {
        "orbit_count": ORBIT_COUNT,
        "word_bits": WORD_BITS,
        "word_count": WORD_COUNT,
        "bit_convention": "word[n/64], bit(n%64), indexed by Lean orbitNumber",
        "data_sha256": data_fingerprint(rows),
        "rows": [
            {
                "row": result.row,
                "freshness_obstruction_words": result.freshness,
                "secant_obstruction_words": result.secant,
                "carrier_obstruction_words": result.carrier,
                "legal_words": result.legal,
                "legal_numbers": result.legal_numbers,
            }
            for result in rows
        ],
    }
    print(json.dumps(payload, indent=2))


def emit_lean(rows: Sequence[RowMasks]) -> None:
    print("-- Generated by notes/2026-07-15-c151-mask-generator.py --format lean")
    print("-- word n contains orbitNumber bits 64*n through 64*n+63; high padding is zero.")
    print(f'-- data_sha256: {data_fingerprint(rows)}')
    print("def c151MinimumRows : Array (Nat × Nat × Nat) := #[")
    for result in rows:
        print(f"  ({result.row[0]}, {result.row[1]}, {result.row[2]}),")
    print("]")
    for field, lean_name in (
        ("freshness", "c151FreshnessObstructionWords"),
        ("secant", "c151SecantObstructionWords"),
        ("carrier", "c151CarrierObstructionWords"),
        ("legal", "c151LegalWords"),
    ):
        print(f"def {lean_name} : Array (Array Nat) := #[")
        for result in rows:
            print(f"  {lean_array(getattr(result, field))},")
        print("]")
    print("def c151LegalOrbitNumbers : Array (Array Nat) := #[")
    for result in rows:
        print(f"  {lean_array(result.legal_numbers)},")
    print("]")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--format",
        choices=("summary", "json", "lean"),
        default="summary",
        help="output format (all formats run the same exhaustive self-check)",
    )
    args = parser.parse_args()

    rows = compute_all()
    if args.format == "summary":
        emit_summary(rows)
    elif args.format == "json":
        emit_json(rows)
    else:
        emit_lean(rows)


if __name__ == "__main__":
    main()
