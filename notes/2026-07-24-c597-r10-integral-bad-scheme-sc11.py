#!/usr/bin/env python3
"""Generate and independently check the compact C597 certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")
MANIFEST_PATH = STEM.with_suffix(".sha256")
C595_JSON = STEM.with_name("2026-07-24-c595-stable-component-fano-elimination.json")
Poly = dict[tuple[int, ...], int]


class Ring:
    def __init__(self, names: tuple[str, ...]):
        self.names = names
        self.n = len(names)

    def const(self, value: int) -> Poly:
        return {} if value == 0 else {(0,) * self.n: value}

    def var(self, index: int) -> Poly:
        exponent = [0] * self.n
        exponent[index] = 1
        return {tuple(exponent): 1}

    def add(self, *polys: Poly) -> Poly:
        result: Poly = {}
        for poly in polys:
            for monomial, coefficient in poly.items():
                result[monomial] = result.get(monomial, 0) + coefficient
                if result[monomial] == 0:
                    del result[monomial]
        return result

    def scale(self, poly: Poly, coefficient: int) -> Poly:
        return {
            monomial: coefficient * value
            for monomial, value in poly.items()
            if coefficient * value
        }

    def mul(self, *polys: Poly) -> Poly:
        result = self.const(1)
        for poly in polys:
            product: Poly = {}
            for left, left_coefficient in result.items():
                for right, right_coefficient in poly.items():
                    monomial = tuple(a + b for a, b in zip(left, right))
                    product[monomial] = (
                        product.get(monomial, 0)
                        + left_coefficient * right_coefficient
                    )
            result = {
                monomial: value for monomial, value in product.items() if value
            }
        return result

    def power(self, poly: Poly, exponent: int) -> Poly:
        result = self.const(1)
        for _ in range(exponent):
            result = self.mul(result, poly)
        return result

    def determinant(self, matrix: list[list[Poly]]) -> Poly:
        size = len(matrix)
        result: Poly = {}
        for permutation in itertools.permutations(range(size)):
            inversions = sum(
                permutation[i] > permutation[j]
                for i in range(size)
                for j in range(i + 1, size)
            )
            term = self.mul(
                *(matrix[row][permutation[row]] for row in range(size))
            )
            result = self.add(
                result, self.scale(term, -1 if inversions % 2 else 1)
            )
        return result


def verify_factor_branches() -> None:
    ring = Ring(("a", "b", "c", "d", "A", "B", "C", "t", "s"))
    a, b, c, d, aa, bb, cc, t, s = [ring.var(index) for index in range(9)]

    def ordered_root_form(z: list[Poly]) -> Poly:
        return ring.add(
            z[0],
            ring.mul(z[1], ring.add(t, s)),
            ring.mul(
                z[2],
                ring.add(ring.power(t, 2), ring.mul(t, s), ring.power(s, 2)),
            ),
            ring.mul(z[3], t, s),
            ring.mul(z[4], t, s, ring.add(t, s)),
            ring.mul(z[5], ring.power(t, 2), ring.power(s, 2)),
        )

    left = ring.add(a, ring.mul(b, t), ring.mul(c, s), ring.mul(d, t, s))
    swapped = ring.add(a, ring.mul(c, t), ring.mul(b, s), ring.mul(d, t, s))
    z_swapped = [
        ring.power(a, 2),
        ring.mul(a, ring.add(b, c)),
        ring.mul(b, c),
        ring.add(
            ring.power(b, 2),
            ring.power(c, 2),
            ring.scale(ring.mul(a, d), 2),
            ring.scale(ring.mul(b, c), -1),
        ),
        ring.mul(d, ring.add(b, c)),
        ring.power(d, 2),
    ]
    assert ring.mul(left, swapped) == ordered_root_form(z_swapped)
    plucker_swapped = ring.add(
        ring.mul(z_swapped[0], z_swapped[5]),
        ring.scale(ring.mul(z_swapped[1], z_swapped[4]), -1),
        ring.mul(z_swapped[2], z_swapped[3]),
    )
    collision = ring.add(ring.mul(a, d), ring.scale(ring.mul(b, c), -1))
    cyclic = ring.add(
        ring.mul(a, d),
        ring.scale(ring.power(b, 2), -1),
        ring.mul(b, c),
        ring.scale(ring.power(c, 2), -1),
    )
    assert plucker_swapped == ring.mul(collision, cyclic)

    symmetric_left = ring.add(a, ring.mul(b, ring.add(t, s)), ring.mul(c, t, s))
    symmetric_right = ring.add(
        aa, ring.mul(bb, ring.add(t, s)), ring.mul(cc, t, s)
    )
    z_symmetric = [
        ring.mul(a, aa),
        ring.add(ring.mul(a, bb), ring.mul(b, aa)),
        ring.mul(b, bb),
        ring.add(ring.mul(a, cc), ring.mul(c, aa), ring.mul(b, bb)),
        ring.add(ring.mul(b, cc), ring.mul(c, bb)),
        ring.mul(c, cc),
    ]
    assert ring.mul(symmetric_left, symmetric_right) == ordered_root_form(
        z_symmetric
    )
    plucker_symmetric = ring.add(
        ring.mul(z_symmetric[0], z_symmetric[5]),
        ring.scale(ring.mul(z_symmetric[1], z_symmetric[4]), -1),
        ring.mul(z_symmetric[2], z_symmetric[3]),
    )
    first_rank_one = ring.add(
        ring.mul(a, c), ring.scale(ring.power(b, 2), -1)
    )
    second_rank_one = ring.add(
        ring.mul(aa, cc), ring.scale(ring.power(bb, 2), -1)
    )
    assert plucker_symmetric == ring.mul(first_rank_one, second_rank_one)


def bridge_polynomials() -> tuple[Ring, list[Poly], list[Poly], Poly]:
    ring = Ring(("c0", "c1", "c2", "c3", "c4"))
    c0, c1, c2, c3, c4 = [ring.var(index) for index in range(5)]
    z = [
        ring.add(ring.mul(c2, c4), ring.scale(ring.power(c3, 2), -1)),
        ring.add(
            ring.scale(ring.mul(c1, c4), -1), ring.mul(c2, c3)
        ),
        ring.add(ring.mul(c1, c3), ring.scale(ring.power(c2, 2), -1)),
        ring.add(ring.mul(c0, c4), ring.scale(ring.mul(c1, c3), -1)),
        ring.add(
            ring.scale(ring.mul(c0, c3), -1), ring.mul(c1, c2)
        ),
        ring.add(ring.mul(c0, c2), ring.scale(ring.power(c1, 2), -1)),
    ]
    z0, z1, z2, z3, z4, z5 = z
    bridge = [
        ring.add(
            ring.scale(ring.power(z4, 2), 3),
            ring.scale(ring.mul(z2, z5), -9),
            ring.scale(ring.mul(z3, z5), -1),
        ),
        ring.add(ring.mul(z3, z4), ring.scale(ring.mul(z1, z5), -3)),
        ring.add(ring.power(z3, 2), ring.scale(ring.mul(z0, z5), -9)),
        ring.add(
            ring.mul(z2, z3),
            ring.scale(ring.mul(z1, z4), -1),
            ring.mul(z0, z5),
        ),
        ring.add(ring.mul(z1, z3), ring.scale(ring.mul(z0, z4), -3)),
        ring.add(
            ring.scale(ring.power(z1, 2), 3),
            ring.scale(ring.mul(z0, z2), -9),
            ring.scale(ring.mul(z0, z3), -1),
        ),
    ]
    cyclic = [
        ring.add(
            ring.scale(ring.power(c3, 3), 2),
            ring.scale(ring.mul(c2, c3, c4), -3),
            ring.mul(c1, ring.power(c4, 2)),
        ),
        ring.add(
            ring.scale(ring.mul(c2, ring.power(c3, 2)), 6),
            ring.scale(ring.mul(ring.power(c2, 2), c4), -9),
            ring.scale(ring.mul(c1, c3, c4), 2),
            ring.mul(c0, ring.power(c4, 2)),
        ),
        ring.add(
            ring.scale(ring.mul(c1, ring.power(c3, 2)), 2),
            ring.scale(ring.mul(c1, c2, c4), -3),
            ring.mul(c0, c3, c4),
        ),
        ring.add(
            ring.mul(c0, ring.power(c3, 2)),
            ring.scale(ring.mul(ring.power(c1, 2), c4), -1),
        ),
        ring.add(
            ring.scale(ring.mul(ring.power(c1, 2), c3), 2),
            ring.scale(ring.mul(c0, c2, c3), -3),
            ring.mul(c0, c1, c4),
        ),
        ring.add(
            ring.scale(ring.mul(ring.power(c1, 2), c2), 6),
            ring.scale(ring.mul(c0, ring.power(c2, 2)), -9),
            ring.scale(ring.mul(c0, c1, c3), 2),
            ring.mul(ring.power(c0, 2), c4),
        ),
        ring.add(
            ring.scale(ring.power(c1, 3), 2),
            ring.scale(ring.mul(c0, c1, c2), -3),
            ring.mul(ring.power(c0, 2), c3),
        ),
    ]
    hankel = [
        [c0, c1, c2],
        [c1, c2, c3],
        [c2, c3, c4],
    ]
    return ring, bridge, cyclic, ring.determinant(hankel)


def verify_bridge_certificate() -> None:
    ring, bridge, cyclic, determinant = bridge_polynomials()
    c0, c1, c2, c3, c4 = [ring.var(index) for index in range(5)]

    # J = V*A: the Pluecker factorization pullback is contained integrally
    # in the syndrome cyclic carrier.
    bridge_from_cyclic = [
        ring.add(
            ring.mul(ring.scale(c0, 3), cyclic[3]),
            ring.mul(ring.scale(c1, 4), cyclic[4]),
            ring.mul(ring.scale(c2, -1), cyclic[5]),
        ),
        ring.add(
            ring.mul(c1, cyclic[3]),
            ring.mul(c2, cyclic[4]),
            ring.mul(ring.scale(c4, -1), cyclic[6]),
        ),
        ring.add(
            ring.mul(ring.scale(c1, -4), cyclic[2]),
            ring.mul(ring.scale(c2, 9), cyclic[3]),
            ring.mul(c4, cyclic[5]),
        ),
        {},
        ring.add(
            ring.mul(c2, cyclic[2]),
            ring.mul(ring.scale(c3, -3), cyclic[3]),
            ring.mul(ring.scale(c4, -1), cyclic[4]),
        ),
        ring.add(
            ring.mul(ring.scale(c1, 4), cyclic[0]),
            ring.mul(ring.scale(c2, -1), cyclic[1]),
            ring.mul(c4, cyclic[3]),
        ),
    ]
    assert bridge == bridge_from_cyclic

    # 6*D*V = J*B.  This is the compact cleared-denominator saturation
    # certificate proving (J:D^infinity)=V over Z[1/6].
    multipliers: list[list[Poly]] = [[{} for _ in range(6)] for _ in range(7)]
    multipliers[0] = [
        {},
        ring.scale(ring.power(c4, 2), 2),
        ring.scale(ring.mul(c3, c4), 2),
        {},
        ring.add(
            ring.scale(ring.power(c3, 2), 4),
            ring.scale(ring.mul(c2, c4), 2),
        ),
        ring.scale(ring.mul(c2, c3), 2),
    ]
    multipliers[1] = [
        {},
        {},
        {},
        {},
        ring.add(
            ring.scale(ring.mul(c2, c3), 12),
            ring.scale(ring.mul(c1, c4), -12),
        ),
        ring.add(
            ring.scale(ring.power(c2, 2), 6),
            ring.scale(ring.mul(c0, c4), -6),
        ),
    ]
    multipliers[2] = [
        {},
        ring.scale(ring.mul(c2, c4), 3),
        ring.scale(ring.mul(c1, c4), 3),
        {},
        ring.add(
            ring.scale(ring.power(c2, 2), -6),
            ring.scale(ring.mul(c1, c3), 12),
            ring.scale(ring.mul(c0, c4), 3),
        ),
        ring.scale(ring.mul(c0, c3), 3),
    ]
    multipliers[3] = [
        ring.scale(ring.mul(c2, c4), -1),
        ring.scale(ring.mul(c1, c4), -2),
        {},
        {},
        ring.scale(ring.mul(c0, c3), 2),
        ring.mul(c0, c2),
    ]
    multipliers[4] = [
        ring.scale(ring.mul(c1, c4), -3),
        ring.add(
            ring.scale(ring.power(c2, 2), -6),
            ring.scale(ring.mul(c0, c4), -3),
        ),
        ring.scale(ring.mul(c0, c3), -3),
        {},
        ring.add(
            ring.scale(ring.power(c1, 2), 12),
            ring.scale(ring.mul(c0, c2), -15),
        ),
        {},
    ]
    multipliers[5] = [
        ring.scale(ring.power(c2, 2), 6),
        ring.scale(ring.mul(c1, c2), 12),
        {},
        {},
        ring.scale(ring.mul(c0, c1), -12),
        ring.scale(ring.power(c0, 2), -6),
    ]
    multipliers[6] = [
        ring.scale(ring.mul(c1, c2), 2),
        ring.add(
            ring.scale(ring.power(c1, 2), 4),
            ring.scale(ring.mul(c0, c2), 2),
        ),
        ring.scale(ring.mul(c0, c1), 2),
        {},
        ring.scale(ring.power(c0, 2), 2),
        {},
    ]
    for cyclic_generator, row in zip(cyclic, multipliers):
        right = ring.add(
            *(ring.mul(multiplier, generator) for multiplier, generator in zip(row, bridge))
        )
        assert ring.scale(ring.mul(determinant, cyclic_generator), 6) == right


def projective_points(prime: int, dimension: int):
    for pivot in range(dimension + 1):
        prefix = (0,) * pivot + (1,)
        for tail in itertools.product(range(prime), repeat=dimension - pivot):
            yield prefix + tail


def normalize(point: tuple[int, ...], prime: int) -> tuple[int, ...]:
    pivot = next(value for value in point if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple((inverse * value) % prime for value in point)


def product_form(
    left: tuple[int, int, int, int],
    right: tuple[int, int, int, int],
    prime: int,
) -> tuple[int, ...]:
    # Coefficient order in a bilinear form is 1,t,s,ts.
    left_matrix = ((left[0], left[2]), (left[1], left[3]))
    right_matrix = ((right[0], right[2]), (right[1], right[3]))
    result = [[0] * 3 for _ in range(3)]
    for i, row in enumerate(left_matrix):
        for j, value in enumerate(row):
            for k, other_row in enumerate(right_matrix):
                for ell, other in enumerate(other_row):
                    result[i + k][j + ell] += value * other
    return tuple(value % prime for row in result for value in row)


def z_from_symmetric_product(coefficients: tuple[int, ...], prime: int):
    matrix = [coefficients[0:3], coefficients[3:6], coefficients[6:9]]
    if any(matrix[i][j] != matrix[j][i] for i in range(3) for j in range(3)):
        return None
    z = (
        matrix[0][0],
        matrix[1][0],
        matrix[2][0],
        (matrix[1][1] - matrix[2][0]) % prime,
        matrix[2][1],
        matrix[2][2],
    )
    if not any(z):
        return None
    if (z[0] * z[5] - z[1] * z[4] + z[2] * z[3]) % prime:
        return None
    return normalize(z, prime)


def finite_factor_control(prime: int) -> dict[str, int]:
    bilinear = list(projective_points(prime, 3))
    all_factorizations = set()
    for left in bilinear:
        for right in bilinear:
            z = z_from_symmetric_product(product_form(left, right, prime), prime)
            if z is not None:
                all_factorizations.add(z)

    cyclic = set()
    swapped_collision = set()
    for a, b, c, d in bilinear:
        z = normalize(
            (
                a * a,
                a * (b + c),
                b * c,
                b * b + c * c + 2 * a * d - b * c,
                d * (b + c),
                d * d,
            ),
            prime,
        )
        if (a * d - b * c) % prime == 0:
            swapped_collision.add(z)
        if (a * d - b * b + b * c - c * c) % prime == 0:
            cyclic.add(z)

    symmetric_collision = set()
    symmetric = list(projective_points(prime, 2))
    for left in symmetric:
        for right in symmetric:
            if (
                (left[0] * left[2] - left[1] * left[1]) % prime
                and (right[0] * right[2] - right[1] * right[1]) % prime
            ):
                continue
            bilinear_left = (left[0], left[1], left[1], left[2])
            bilinear_right = (right[0], right[1], right[1], right[2])
            z = z_from_symmetric_product(
                product_form(bilinear_left, bilinear_right, prime), prime
            )
            assert z is not None
            symmetric_collision.add(z)

    classified = cyclic | swapped_collision | symmetric_collision
    assert all_factorizations == classified
    return {
        "rational_symmetric_factorization_images": len(all_factorizations),
        "cyclic_swapped_images": len(cyclic),
        "swapped_collision_images": len(swapped_collision),
        "symmetric_collision_images": len(symmetric_collision),
        "classified_union_images": len(classified),
    }


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def payload() -> dict[str, object]:
    verify_factor_branches()
    verify_bridge_certificate()
    c595 = json.loads(C595_JSON.read_text())
    assert c595["cleared_denominator_certificate"]["integer_N"] == 6
    return {
        "schema": "c597-r10-integral-bad-scheme-sc11-v1",
        "universal_ordered_root_model": {
            "base": "Gr(2,Gamma^3 E)_Z",
            "pluecker_relation": "z0*z5-z1*z4+z2*z3",
            "equation": (
                "z0+z1(t+s)+z2(t^2+ts+s^2)+z3*ts+"
                "z4*ts(t+s)+z5*t^2*s^2"
            ),
            "factorization_dichotomy": {
                "symmetric_factors": "(ac-b^2)(AC-B^2)=0",
                "swapped_factors": "(ad-bc)(ad-b^2+bc-c^2)=0",
            },
        },
        "integral_bridge": {
            "pluecker_pullback_generators": 6,
            "syndrome_cyclic_generators": 7,
            "persistent_equation": "det Hankel_3(c)",
            "certificate": [
                "J is contained in V integrally",
                "6*D*V is contained in J integrally",
                "(J:D^infinity)=V over Z[1/6]",
            ],
            "cleared_denominator": 6,
        },
        "finite_factor_controls": {
            str(prime): finite_factor_control(prime) for prime in (2, 3, 5)
        },
        "vertical_fibres": {
            "2": (
                "Pluecker pullback has the binary cyclic plane c0=c4=0 "
                "plus a component contained in the persistent determinant; "
                "C525 closes the remaining ordered-Hessian inseparable locus."
            ),
            "3": (
                "Use the true wild cone rather than the non-flat primitive "
                "specialization; C595 confines its coherent-Fano pullback to "
                "the rank/fixed-factor boundary."
            ),
        },
        "sc11": {
            "status": "proved",
            "reason": (
                "rank/persistent and Lucas branches are C536; collision and "
                "fixed-factor branches are uniform; the factorization "
                "dichotomy leaves only collision or cyclic branches; C595 "
                "eliminates cyclic/wild residues; C525 closes characteristic 2."
            ),
            "combined_integer_N11": 6,
        },
        "uniform_upgrade": {
            "status": "proved for every j>=6",
            "scope": (
                "the recursively pointed component assertion SC(j), not "
                "arithmetic deepness of points on the Lucas carrier"
            ),
        },
        "inputs": {
            "c595_json_sha256": digest(C595_JSON),
            "c595_integer_N": 6,
        },
    }


def canonical_bytes() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes() -> bytes:
    paths = (Path(__file__), STEM.with_suffix(".sing"), JSON_PATH)
    return "".join(
        f"{digest(path)}  {path.stat().st_size}  {path.name}\n" for path in paths
    ).encode()


def write_bundle() -> None:
    JSON_PATH.write_bytes(canonical_bytes())
    MANIFEST_PATH.write_bytes(manifest_bytes())


def check_bundle() -> None:
    if JSON_PATH.read_bytes() != canonical_bytes():
        raise SystemExit(f"stale certificate: {JSON_PATH}")
    if MANIFEST_PATH.read_bytes() != manifest_bytes():
        raise SystemExit(f"stale manifest: {MANIFEST_PATH}")
    print(
        "C597 Python certificate OK: integral factor dichotomy, "
        "bridge saturation, F_2/F_3/F_5 controls"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--write", action="store_true")
    action.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write:
        write_bundle()
    else:
        check_bundle()


if __name__ == "__main__":
    main()
