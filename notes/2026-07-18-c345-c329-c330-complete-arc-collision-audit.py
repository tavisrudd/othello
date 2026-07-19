#!/usr/bin/env python3
"""Independent finite-field replay of the C329/C330 support and direction formulas."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import tempfile
from pathlib import Path


def poly_degree(a: int) -> int:
    return a.bit_length() - 1


def poly_mod(a: int, modulus: int) -> int:
    degree = poly_degree(modulus)
    while poly_degree(a) >= degree:
        a ^= modulus << (poly_degree(a) - degree)
    return a


def irreducible(modulus: int, degree: int) -> bool:
    for divisor_degree in range(1, degree // 2 + 1):
        start = (1 << divisor_degree) | 1
        stop = 1 << (divisor_degree + 1)
        for divisor in range(start, stop, 2):
            if poly_degree(divisor) == divisor_degree and poly_mod(modulus, divisor) == 0:
                return False
    return True


def canonical_modulus(degree: int) -> int:
    for candidate in range((1 << degree) | 1, 1 << (degree + 1), 2):
        if irreducible(candidate, degree):
            return candidate
    raise RuntimeError(f"no irreducible polynomial of degree {degree}")


class Field:
    def __init__(self, degree: int):
        self.degree = degree
        self.order = 1 << degree
        self.modulus = canonical_modulus(degree)

    @staticmethod
    def add(a: int, b: int) -> int:
        return a ^ b

    def mul(self, a: int, b: int) -> int:
        out = 0
        while b:
            if b & 1:
                out ^= a
            b >>= 1
            a <<= 1
            if a & self.order:
                a ^= self.modulus
        return out

    def power(self, a: int, n: int) -> int:
        out = 1
        while n:
            if n & 1:
                out = self.mul(out, a)
            a = self.mul(a, a)
            n >>= 1
        return out

    def inv(self, a: int) -> int:
        assert a
        return self.power(a, self.order - 2)

    def div(self, a: int, b: int) -> int:
        return self.mul(a, self.inv(b))


def point(field: Field, x: int, height: int) -> tuple[int, int, int]:
    return (1, x, field.add(field.mul(x, x), height))


def determinant(field: Field, p: tuple[int, int, int], q: tuple[int, int, int],
                r: tuple[int, int, int]) -> int:
    a = field.mul(p[0], field.add(field.mul(q[1], r[2]), field.mul(q[2], r[1])))
    b = field.mul(p[1], field.add(field.mul(q[0], r[2]), field.mul(q[2], r[0])))
    c = field.mul(p[2], field.add(field.mul(q[0], r[1]), field.mul(q[1], r[0])))
    return field.add(field.add(a, b), c)


def direction(field: Field, x: int, height_x: int, y: int, height_y: int) -> int | None:
    p = field.add(x, y)
    if p == 0:
        return None
    return field.add(p, field.div(field.add(height_x, height_y), p))


def reciprocal_image(field: Field, domain: list[int], offset: int) -> set[int]:
    return {field.add(p, field.div(offset, p)) for p in domain if p}


def fixture(field: Field, q: int, delta_repair: int) -> dict[str, object]:
    subfield = [a for a in range(field.order) if field.power(a, q) == a]
    assert len(subfield) == q
    assert all(field.mul(a, field.inv(a)) == 1 for a in range(1, field.order))
    omega = next(a for a in range(field.order)
                 if field.add(field.add(field.mul(a, a), a), 1) == 0 and a not in subfield)
    rho = next(a for a in subfield if a not in (0, 1))
    gamma_alpha, gamma_beta = next(
        (a, b) for a in range(1, field.order) for b in range(1, field.order)
        if a != b and field.add(a, b) not in subfield)
    d = field.add(1, rho)
    layers = [
        [(field.add(omega, r), 0) for r in subfield],
        [(field.add(field.mul(rho, omega), r), delta_repair) for r in subfield],
        [(r, gamma_alpha) for r in subfield],
        [(r, gamma_beta) for r in subfield],
    ]
    direct: set[int] = set()
    infinity_pairs = 0
    tagged = [(i, x, h) for i, layer in enumerate(layers) for x, h in layer]
    for (_, x, h_x), (_, y, h_y) in itertools.combinations(tagged, 2):
        value = direction(field, x, h_x, y, h_y)
        if value is None:
            infinity_pairs += 1
        else:
            direct.add(value)

    f_nonzero = [a for a in subfield if a]
    formula = set(f_nonzero)
    formula |= reciprocal_image(
        field, [field.add(field.mul(d, omega), r) for r in subfield], delta_repair)
    formula |= reciprocal_image(
        field, [field.add(omega, r) for r in subfield], gamma_alpha)
    formula |= reciprocal_image(
        field, [field.add(omega, r) for r in subfield], gamma_beta)
    formula |= reciprocal_image(
        field, [field.add(field.mul(rho, omega), r) for r in subfield],
        field.add(delta_repair, gamma_alpha))
    formula |= reciprocal_image(
        field, [field.add(field.mul(rho, omega), r) for r in subfield],
        field.add(delta_repair, gamma_beta))
    formula |= reciprocal_image(field, f_nonzero, field.add(gamma_alpha, gamma_beta))
    assert direct == formula
    missing = next(a for a in range(field.order) if a not in direct)

    return {
        "Q": q,
        "ambient_order": field.order,
        "modulus_bits": bin(field.modulus),
        "delta_repair": delta_repair,
        "rho": rho,
        "omega": omega,
        "gamma_alpha": gamma_alpha,
        "gamma_beta": gamma_beta,
        "direct_direction_count": len(direct),
        "formula_direction_count": len(formula),
        "bound_7Q_minus_2": 7 * q - 2,
        "bound_verified": len(direct) <= 7 * q - 2,
        "uncovered_finite_direction_count": field.order - len(direct),
        "explicit_uncovered_direction": missing,
        "pairs_with_conic_infinity_direction": infinity_pairs,
        "parameters": (subfield, omega, rho, d, gamma_alpha, gamma_beta),
    }


def collision_interface_replay(field: Field, q: int) -> dict[str, int]:
    base = fixture(field, q, 0)
    subfield, omega, rho, d, gamma_alpha, gamma_beta = base.pop("parameters")
    rr_mismatches = 0
    rr_cases = 0
    for gamma in (gamma_alpha, gamma_beta):
        for u in subfield:
            for a in subfield:
                qelt = field.add(field.mul(d, omega), u)
                z = field.add(omega, a)
                lhs = determinant(field, point(field, omega, 0),
                                  point(field, field.add(field.mul(rho, omega), u), 0),
                                  point(field, a, gamma))
                rhs = field.mul(qelt, field.add(gamma, field.add(field.mul(z, z), field.mul(qelt, z))))
                rr_mismatches += lhs != rhs
                rr_cases += 1

    ss_mismatches = 0
    ss_cases = 0
    p_zero_collisions = 0
    delta_seed = field.add(gamma_alpha, gamma_beta)
    for e in (1, rho):
        for p in subfield:
            for a in subfield:
                y = field.add(field.mul(e, omega), a)
                det = determinant(field, point(field, 0, gamma_alpha),
                                  point(field, p, gamma_beta), point(field, y, 0))
                if p == 0:
                    p_zero_collisions += det == 0
                else:
                    chi = field.add(field.mul(y, y),
                                    field.mul(y, field.add(p, field.div(delta_seed, p))))
                    rhs_zero = chi == gamma_alpha
                    ss_mismatches += (det == 0) != rhs_zero
                ss_cases += 1
    assert rr_mismatches == ss_mismatches == p_zero_collisions == 0
    return {
        "repair_repair_seed_cases": rr_cases,
        "repair_repair_seed_identity_mismatches": rr_mismatches,
        "seed_seed_repair_cases": ss_cases,
        "seed_seed_repair_zero_equivalence_mismatches": ss_mismatches,
        "seed_pair_sum_zero_collisions": p_zero_collisions,
        "layer_support_multisets": 20,
        "previously_safe_support_types": 16,
        "four_distinct_layer_support_types": 4,
    }


def replay() -> dict[str, object]:
    records = []
    interfaces = []
    for n in (3, 5):
        q = 1 << n
        field = Field(2 * n)
        subfield = [a for a in range(field.order) if field.power(a, q) == a]
        generic_delta = next(a for a in range(1, field.order) if a not in subfield)
        for delta in (0, generic_delta):
            item = fixture(field, q, delta)
            item.pop("parameters")
            records.append(item)
        interfaces.append({"Q": q, **collision_interface_replay(field, q)})
    return {
        "schema": "c345-c329-c330-collision-audit-v1",
        "direction_replays": records,
        "c329_collision_interface_replays": interfaces,
        "scope": (
            "Exhaustive representative odd-tower identity checks at Q=8,32. This independently "
            "checks the lossless collision formulas and C330 direction equality; it does not "
            "instantiate C329's nonconstructive Q>=2^45 Chebotarev witness."
        ),
    }


def serialized() -> bytes:
    return (json.dumps(replay(), indent=2, sort_keys=True) + "\n").encode()


def verify_manifest(stem: Path) -> None:
    for row in stem.with_suffix(".sha256").read_text().splitlines():
        expected, name = row.split("  ", 1)
        actual = hashlib.sha256(stem.with_name(name).read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(f"hash mismatch for {name}: {actual} != {expected}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    stem = Path(__file__).with_suffix("")
    payload = serialized()
    if args.check:
        with tempfile.TemporaryDirectory(prefix="c345-replay-") as tmp:
            candidate = Path(tmp) / stem.with_suffix(".json").name
            candidate.write_bytes(payload)
            if candidate.read_bytes() != stem.with_suffix(".json").read_bytes():
                raise SystemExit("tracked JSON differs from deterministic regeneration")
        verify_manifest(stem)
        print("C345 replay and SHA-256 manifest verified")
    else:
        (args.output or stem.with_suffix(".json")).write_bytes(payload)


if __name__ == "__main__":
    main()
