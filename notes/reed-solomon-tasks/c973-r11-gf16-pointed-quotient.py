#!/usr/bin/env python3
"""Generate the exact pointed GF(16) R11 Lucas-carrier quotient certificate.

Repair, 2026-08-28.  The first version of this generator built its
"upper Borel" action by calling C531's ``action_entry`` -- the PGL_2 action on
degree-NINE binary forms, i.e. the R10 syndrome space -- and truncating it to
the coordinate slice ``e_3..e_7``, which is not invariant under that action
(``e_3 -> e_2 + e_3``).  The truncated matrices are not symmetries of the R11
Hankel system this file verifies against, so the resulting orbits were orbits
of a group that does not preserve the certified property.

The R11 syndrome is a divided-power form of degree ``n = r - 1 = 10``, so the
stabiliser of infinity acts on ``e_3..e_7`` by

    translation  t -> t + a :  e_j -> sum_{i>=j} binom(i,j) a^(i-j) e_i
    scaling      t -> s t   :  e_j -> s^j e_j

and ``<e_3,...,e_7>`` is invariant because ``binom(i,j) = 0 mod 2`` for every
``i in {8,9,10}`` and ``j in {3,...,7}``.  Both facts are asserted below, and a
seeded 1000-pair equivariance test fails closed if the action ever stops
matching the Hankel system.  Do not validate a future change against the orbit
count: the discarded wrong group happens to have the same number of orbits.

This file has no dependency on C531 and computes its own field arithmetic.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from itertools import combinations, product
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
DEFAULT_BINARY = (
    ROOT
    / "papers/high_weight_grs_cosets/software/projective-reed-solomon/target/release/projective-reed-solomon"
)
DEFAULT_OUTPUT = HERE / "c973-r11-gf16-pointed-quotient.json"
SCHEMA = "c973-r11-gf16-pointed-quotient-v2"
REPAIR = (
    "2026-08-28: rebuilt on the degree-ten divided-power upper-Borel action; "
    "the superseded v1 quotient used C531's degree-nine R10 action truncated "
    "to a non-invariant slice"
)
Q = 16
MODULUS = 0b10011
FIELD_NAME = "GF(2)[x]/(x^4+x+1)"
FIELD_REQUEST = {
    "p": 2,
    "degree": 4,
    "modulus": [1, 1, 0, 0, 1],
    "encoding": "polynomial-basis-base-p-integer-v1",
}
CARRIER_SUPPORT = tuple(range(3, 8))
REDUNDANCY = 11
SYNDROME_DEGREE = REDUNDANCY - 1
LOCATOR_DEGREE = REDUNDANCY - 2
WIDTH = len(CARRIER_SUPPORT)
EQUIVARIANCE_PAIRS = 1000
EQUIVARIANCE_SEED = 0xC973_2026_0828
SWITCH_BASE_LIMIT = 200_000


# --------------------------------------------------------------------------
# field arithmetic
# --------------------------------------------------------------------------


def gf_mul(left: int, right: int) -> int:
    product_value = 0
    while right:
        if right & 1:
            product_value ^= left
        right >>= 1
        left <<= 1
        if left & Q:
            left ^= MODULUS
    return product_value


def gf_pow(base: int, exponent: int) -> int:
    result = 1
    for _ in range(exponent):
        result = gf_mul(result, base)
    return result


def gf_inv(value: int) -> int:
    if value == 0:
        raise ZeroDivisionError("gf_inv(0)")
    return gf_pow(value, Q - 2)


def primitive_element() -> int:
    for candidate in range(2, Q):
        seen = set()
        power = 1
        for _ in range(Q - 1):
            power = gf_mul(power, candidate)
            seen.add(power)
        if len(seen) == Q - 1:
            return candidate
    raise RuntimeError("no primitive element")


# --------------------------------------------------------------------------
# the degree-(r-1) divided-power action of the stabiliser of infinity
# --------------------------------------------------------------------------


def assert_carrier_is_borel_stable() -> None:
    """<e_3..e_7> is a submodule: no translation image leaves the slice."""
    for source in CARRIER_SUPPORT:
        for target in range(max(CARRIER_SUPPORT) + 1, SYNDROME_DEGREE + 1):
            if comb(target, source) % 2 != 0:
                raise SystemExit(
                    f"carrier is not translation stable at ({source},{target})"
                )


def translation_matrix(shift: int) -> tuple[tuple[int, ...], ...]:
    """e_j -> sum_{i>=j} binom(i,j) shift^(i-j) e_i, restricted to the carrier."""
    rows = []
    for source in CARRIER_SUPPORT:
        row = []
        for target in CARRIER_SUPPORT:
            if target < source or comb(target, source) % 2 == 0:
                row.append(0)
            else:
                row.append(gf_pow(shift, target - source))
        rows.append(tuple(row))
    return tuple(rows)


def scaling_matrix(factor: int) -> tuple[tuple[int, ...], ...]:
    """e_j -> factor^j e_j, restricted to the carrier."""
    base = CARRIER_SUPPORT[0]
    return tuple(
        tuple(
            gf_pow(factor, source - base) if source == target else 0
            for target in CARRIER_SUPPORT
        )
        for source in CARRIER_SUPPORT
    )


def matrix_product(
    left: tuple[tuple[int, ...], ...], right: tuple[tuple[int, ...], ...]
) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(
            _xor(gf_mul(left[row][mid], right[mid][column]) for mid in range(WIDTH))
            for column in range(WIDTH)
        )
        for row in range(WIDTH)
    )


def _xor(values) -> int:
    total = 0
    for value in values:
        total ^= value
    return total


def carrier_matrix(mobius: tuple[int, int, int, int]) -> tuple[tuple[int, ...], ...]:
    """Carrier action of the upper-triangular Mobius map t -> (a t + b)/d."""
    a, b, c, d = mobius
    if c != 0:
        raise ValueError("only the stabiliser of infinity acts on the carrier")
    if a == 0 or d == 0:
        raise ValueError("singular Mobius matrix")
    shift = gf_mul(b, gf_inv(a))
    factor = gf_mul(a, gf_inv(d))
    return matrix_product(translation_matrix(shift), scaling_matrix(factor))


def mobius_image(mobius: tuple[int, int, int, int], point: int) -> int:
    a, b, c, d = mobius
    return gf_mul(gf_mul(a, point) ^ b, gf_inv(d))


def act(point: tuple[int, ...], matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return canonical(
        tuple(
            _xor(gf_mul(point[source], matrix[source][target]) for source in range(WIDTH))
            for target in range(WIDTH)
        )
    )


def canonical(point: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in point if value)
    scale = gf_inv(pivot)
    return tuple(gf_mul(value, scale) for value in point)


def borel_generators() -> list[tuple[int, int, int, int]]:
    return [(1, 1, 0, 1), (primitive_element(), 0, 0, 1)]


# --------------------------------------------------------------------------
# the R11 Hankel / apolarity system
# --------------------------------------------------------------------------


def root_polynomial(roots) -> list[int]:
    coefficients = [1]
    for root in roots:
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] ^= gf_mul(coefficient, root)
            extended[index + 1] ^= coefficient
        coefficients = extended
    return coefficients


def is_locator(point: tuple[int, ...], roots) -> bool:
    """iota_g f = 0 in Gamma^(n-d): all n-d+1 equations, not just two."""
    degree = len(roots)
    if degree > LOCATOR_DEGREE:
        return False
    coefficients = root_polynomial(roots)
    for level in range(SYNDROME_DEGREE - degree + 1):
        total = 0
        for offset, index in enumerate(CARRIER_SUPPORT):
            position = index - level
            if 0 <= position < len(coefficients):
                total ^= gf_mul(point[offset], coefficients[position])
        if total != 0:
            return False
    return True


def hankel_rows(roots) -> list[tuple[int, ...]]:
    degree = len(roots)
    coefficients = root_polynomial(roots)
    rows = []
    for level in range(SYNDROME_DEGREE - degree + 1):
        row = []
        for index in CARRIER_SUPPORT:
            position = index - level
            row.append(coefficients[position] if 0 <= position < len(coefficients) else 0)
        rows.append(tuple(row))
    return rows


def nullspace(rows: list[tuple[int, ...]]) -> list[list[int]]:
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    rank = 0
    for column in range(WIDTH):
        pivot_row = next(
            (index for index in range(rank, len(matrix)) if matrix[index][column]), None
        )
        if pivot_row is None:
            continue
        matrix[rank], matrix[pivot_row] = matrix[pivot_row], matrix[rank]
        scale = gf_inv(matrix[rank][column])
        matrix[rank] = [gf_mul(value, scale) for value in matrix[rank]]
        for index in range(len(matrix)):
            if index != rank and matrix[index][column]:
                factor = matrix[index][column]
                matrix[index] = [
                    matrix[index][j] ^ gf_mul(factor, matrix[rank][j])
                    for j in range(WIDTH)
                ]
        pivots.append(column)
        rank += 1
    basis = []
    for free in (column for column in range(WIDTH) if column not in pivots):
        vector = [0] * WIDTH
        vector[free] = 1
        for index, column in enumerate(pivots):
            vector[column] = matrix[index][free]
        basis.append(vector)
    return basis


# --------------------------------------------------------------------------
# fail-closed equivariance gate
# --------------------------------------------------------------------------


class SplitMix64:
    """Deterministic stdlib-only PRNG so the gate is reproducible."""

    def __init__(self, seed: int) -> None:
        self.state = seed & 0xFFFFFFFFFFFFFFFF

    def next(self) -> int:
        self.state = (self.state + 0x9E3779B97F4A7C15) & 0xFFFFFFFFFFFFFFFF
        value = self.state
        value = ((value ^ (value >> 30)) * 0xBF58476D1CE4E5B9) & 0xFFFFFFFFFFFFFFFF
        value = ((value ^ (value >> 27)) * 0x94D049BB133111EB) & 0xFFFFFFFFFFFFFFFF
        return value ^ (value >> 31)

    def below(self, bound: int) -> int:
        return self.next() % bound

    def sample(self, population: int, size: int) -> list[int]:
        chosen: list[int] = []
        while len(chosen) < size:
            candidate = self.below(population)
            if candidate not in chosen:
                chosen.append(candidate)
        return chosen


def assert_equivariance(pairs: int = EQUIVARIANCE_PAIRS) -> int:
    """g maps the Hankel system of z to the Hankel system of g.z.

    For each seeded pair the test checks the biconditional
    ``is_locator(z, S) == is_locator(z.M, phi(S))`` for both Borel generators,
    on a syndrome drawn from the kernel of S (a genuine locator) and on an
    independent uniform syndrome (usually not one).  Raises SystemExit on the
    first mismatch, so a wrong action can never reach the certificate again.
    """
    assert_carrier_is_borel_stable()
    rng = SplitMix64(EQUIVARIANCE_SEED)
    generators = borel_generators()
    matrices = [carrier_matrix(generator) for generator in generators]
    positive = 0
    for _ in range(pairs):
        support = rng.sample(Q, LOCATOR_DEGREE)
        basis = nullspace(hankel_rows(support))
        kernel_point = [0] * WIDTH
        while not any(kernel_point):
            kernel_point = [0] * WIDTH
            for vector in basis:
                coefficient = rng.below(Q)
                if coefficient:
                    for index in range(WIDTH):
                        kernel_point[index] ^= gf_mul(coefficient, vector[index])
        random_point = [0] * WIDTH
        while not any(random_point):
            random_point = [rng.below(Q) for _ in range(WIDTH)]
        if not is_locator(tuple(kernel_point), support):
            raise SystemExit("equivariance gate: kernel construction is wrong")
        positive += 1
        for generator, matrix in zip(generators, matrices):
            image_support = [mobius_image(generator, root) for root in support]
            if len(set(image_support)) != len(support):
                raise SystemExit("equivariance gate: Mobius image collided")
            for probe in (kernel_point, random_point):
                before = is_locator(tuple(probe), support)
                moved = act(tuple(probe), matrix)
                after = is_locator(moved, image_support)
                if before != after:
                    raise SystemExit(
                        "equivariance gate FAILED: the recorded Borel action is not "
                        f"a symmetry of the R11 Hankel system (generator {generator})"
                    )
    if positive != pairs:
        raise SystemExit("equivariance gate: not enough positive pairs")
    return positive


# --------------------------------------------------------------------------
# the marked-root quotient
# --------------------------------------------------------------------------


def projective_points() -> set[tuple[int, ...]]:
    points: set[tuple[int, ...]] = set()
    for pivot in range(WIDTH):
        for tail in product(range(Q), repeat=WIDTH - pivot - 1):
            points.add((0,) * pivot + (1,) + tail)
    return points


def orbit_representatives() -> list[tuple[int, ...]]:
    matrices = [carrier_matrix(generator) for generator in borel_generators()]
    unseen = projective_points()
    representatives: list[tuple[int, ...]] = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            point = frontier.pop()
            for matrix in matrices:
                image = act(point, matrix)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        representatives.append(representative)
    return representatives


def syndrome(point: tuple[int, ...]) -> list[int]:
    out = [0] * REDUNDANCY
    for index, coefficient in zip(CARRIER_SUPPORT, point):
        out[index] = coefficient
    return out


# --------------------------------------------------------------------------
# locator searches
# --------------------------------------------------------------------------


def exhaustive_finite_locator(point: tuple[int, ...]):
    examined = 0
    for degree in range(1, LOCATOR_DEGREE + 1):
        for roots in combinations(range(Q), degree):
            examined += 1
            if is_locator(point, roots):
                return list(roots), examined
    return None, examined


def switch_finite_locator(point: tuple[int, ...], limit: int = SWITCH_BASE_LIMIT):
    """Deterministic two-point switch: complete a base of r-4 roots by a pair.

    Enumerates base sets in lexicographic order, solves the two remaining
    Hankel equations for the completing monic quadratic, and keeps the first
    base whose quadratic splits into two distinct roots off the base.
    """
    examined = 0
    for base in combinations(range(Q), LOCATOR_DEGREE - 2):
        examined += 1
        if examined > limit:
            break
        head = root_polynomial(base)

        def coefficient(index: int) -> int:
            return head[index] if 0 <= index < len(head) else 0

        rows = []
        for level in (0, 1):
            constant = linear = quadratic = 0
            for offset, index in enumerate(CARRIER_SUPPORT):
                value = point[offset]
                if value:
                    constant ^= gf_mul(value, coefficient(index - level - 2))
                    linear ^= gf_mul(value, coefficient(index - level - 1))
                    quadratic ^= gf_mul(value, coefficient(index - level))
            rows.append((linear, quadratic, constant))
        (b1, c1, a1), (b2, c2, a2) = rows
        determinant = gf_mul(b1, c2) ^ gf_mul(b2, c1)
        if determinant == 0:
            continue
        inverse = gf_inv(determinant)
        beta = gf_mul(gf_mul(a1, c2) ^ gf_mul(a2, c1), inverse)
        gamma = gf_mul(gf_mul(b1, a2) ^ gf_mul(b2, a1), inverse)
        if beta == 0:
            continue
        roots = [
            value
            for value in range(Q)
            if gf_mul(value, value) ^ gf_mul(beta, value) ^ gamma == 0
        ]
        if len(roots) != 2 or any(root in base for root in roots):
            continue
        support = sorted(set(base) | set(roots))
        if len(support) != LOCATOR_DEGREE or not is_locator(point, support):
            continue
        return support, examined
    return None, examined


def run_json(command: list[str], payload: dict) -> dict:
    completed = subprocess.run(
        command,
        input=json.dumps(payload, sort_keys=True),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip())
    return json.loads(completed.stdout)


def request_for(point: tuple[int, ...]) -> dict:
    return {
        "schema": "projective-reed-solomon-request-v1",
        "field": dict(FIELD_REQUEST),
        "redundancy": REDUNDANCY,
        "evaluation": "full-projective-nrc-v1",
        "syndrome": syndrome(point),
    }


def finite_support(certificate: dict):
    support = certificate.get("support")
    if support is None or any(not isinstance(root, dict) for root in support):
        return None
    return [root["finite"] for root in support]


def record_for(binary: Path, point: tuple[int, ...], candidate_limit: int) -> dict:
    """Public toolkit first, self-contained deterministic searches as fallback."""
    request = request_for(point)
    try:
        result = run_json(
            [
                str(binary),
                "--candidate-limit",
                str(candidate_limit),
                "--compact",
                "simultaneous-locator",
                "--forbid-infinity",
            ],
            request,
        )
    except RuntimeError as error:
        result = None
        message = str(error)
        if "no split locator" not in message and "candidate limit" not in message.lower():
            raise RuntimeError(f"representative {point}: {error}") from error
    if result is not None:
        if result.get("schema") != "projective-reed-solomon-simultaneous-locator-v1":
            raise RuntimeError("unexpected locator-result schema")
        certificate = result["certificate"]
        if run_json([str(binary), "--compact", "verify"], certificate).get("status") != "VALID":
            raise RuntimeError("public verifier rejected generated certificate")
        support = finite_support(certificate)
        if support is not None and len(support) == LOCATOR_DEGREE:
            return {
                "representative": list(point),
                "status": "WITNESS",
                "source": "simultaneous-locator",
                "support": support,
                "candidates_examined": certificate["candidates_examined"],
            }
    classified = run_json([str(binary), "--compact", "classify"], request)
    certificate = classified.get("locator_certificate")
    if classified.get("status") == "NOT_DEEP" and certificate is not None:
        support = finite_support(certificate)
        if support is not None:
            if run_json([str(binary), "--compact", "verify"], certificate).get("status") != "VALID":
                raise RuntimeError("public verifier rejected fallback certificate")
            return {
                "representative": list(point),
                "status": "WITNESS",
                "source": "classify",
                "support": sorted(support),
                "candidates_examined": certificate["candidates_examined"],
            }
    support, examined = switch_finite_locator(point)
    if support is not None:
        return {
            "representative": list(point),
            "status": "WITNESS",
            "source": "switch",
            "support": support,
            "candidates_examined": examined,
        }
    support, examined = exhaustive_finite_locator(point)
    if support is not None:
        return {
            "representative": list(point),
            "status": "WITNESS",
            "source": "exhaustive",
            "support": support,
            "candidates_examined": examined,
        }
    return {
        "representative": list(point),
        "status": "NO_POINTED_LOCATOR",
        "source": "exhaustive",
        "candidates_examined": examined,
    }


def summarize(records: list[dict], candidate_limit: int, binary: Path, pairs: int) -> dict:
    witnesses = [record for record in records if record["status"] == "WITNESS"]
    degrees: dict[str, int] = {}
    sources: dict[str, int] = {}
    for record in witnesses:
        degrees[str(len(record["support"]))] = degrees.get(str(len(record["support"])), 0) + 1
        sources[record["source"]] = sources.get(record["source"], 0) + 1
    return {
        "schema": SCHEMA,
        "repair": REPAIR,
        "field": FIELD_NAME,
        "field_order": Q,
        "modulus_integer": MODULUS,
        "carrier_support": list(CARRIER_SUPPORT),
        "redundancy": REDUNDANCY,
        "syndrome_degree": SYNDROME_DEGREE,
        "locator_degree": LOCATOR_DEGREE,
        "marked_root": "infinity",
        "borel_action": (
            "degree-(r-1) divided-power: translation e_j -> sum_i binom(i,j) a^(i-j) e_i, "
            "scaling e_j -> s^j e_j"
        ),
        "borel_generators": [list(generator) for generator in borel_generators()],
        "equivariance_pairs": pairs,
        "equivariance_seed": EQUIVARIANCE_SEED,
        "projective_carrier_points": (Q**WIDTH - 1) // (Q - 1),
        "orbit_count": len(records),
        "candidate_limit": candidate_limit,
        "witness_orbits": len(witnesses),
        "no_pointed_locator_orbits": len(records) - len(witnesses),
        "witness_degree_histogram": degrees,
        "witness_source_histogram": sources,
        "maximum_candidates_examined": max(
            (record["candidates_examined"] for record in witnesses), default=0
        ),
        "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
        "records": records,
    }


def generate(binary: Path, candidate_limit: int) -> dict:
    pairs = assert_equivariance()
    records = [
        record_for(binary, representative, candidate_limit)
        for representative in orbit_representatives()
    ]
    return summarize(records, candidate_limit, binary, pairs)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", type=Path, default=DEFAULT_BINARY)
    parser.add_argument("--candidate-limit", type=int, default=2_000_000)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate(args.binary, args.candidate_limit)
    encoded = json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit("tracked output differs from deterministic regeneration")
        print(f"C973 GF(16) pointed quotient: PASS ({result['orbit_count']} orbits)")
    else:
        args.output.write_text(encoded)
        print(
            json.dumps(
                {
                    "output": str(args.output),
                    "orbit_count": result["orbit_count"],
                    "witness_orbits": result["witness_orbits"],
                    "witness_degree_histogram": result["witness_degree_histogram"],
                    "witness_source_histogram": result["witness_source_histogram"],
                    "maximum_candidates_examined": result["maximum_candidates_examined"],
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
