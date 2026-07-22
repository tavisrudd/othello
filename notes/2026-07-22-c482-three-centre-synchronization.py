#!/usr/bin/env python3
"""Exact replay for the C482 multi-centre reconstruction theorem.

The checker uses only finite-field arithmetic.  It verifies the normalized
compatibility equations, reconstructs every candidate on the stated kernel
chart, and checks two distinct deep six-arc reconstructions over F_101 and
GF(2^8).  The latter is the characteristic-two separability witness.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


STEM = Path(__file__).with_suffix("")
CERTIFICATE = STEM.with_suffix(".json")


class PrimeField:
    def __init__(self, prime: int):
        self.name = f"F_{prime}"
        self.order = prime
        self.zero = 0
        self.one = 1

    def add(self, left: int, right: int) -> int:
        return (left + right) % self.order

    def sub(self, left: int, right: int) -> int:
        return (left - right) % self.order

    def neg(self, value: int) -> int:
        return (-value) % self.order

    def mul(self, left: int, right: int) -> int:
        return left * right % self.order

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return pow(value, self.order - 2, self.order)


class BinaryField256:
    """GF(2^8) in the basis modulo x^8+x^4+x^3+x+1."""

    name = "F_256"
    order = 256
    zero = 0
    one = 1

    def add(self, left: int, right: int) -> int:
        return left ^ right

    sub = add

    def neg(self, value: int) -> int:
        return value

    def mul(self, left: int, right: int) -> int:
        answer = 0
        while right:
            if right & 1:
                answer ^= left
            right >>= 1
            left <<= 1
            if left & 0x100:
                left ^= 0x11B
        return answer

    def power(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return self.power(value, 254)


def div(field, numerator: int, denominator: int) -> int:
    return field.mul(numerator, field.inv(denominator))


def total(field, values) -> int:
    answer = field.zero
    for value in values:
        answer = field.add(answer, value)
    return answer


def determinant(field, first, second, third) -> int:
    return total(
        field,
        (
            field.mul(
                first[0],
                field.sub(
                    field.mul(second[1], third[2]),
                    field.mul(second[2], third[1]),
                ),
            ),
            field.neg(
                field.mul(
                    first[1],
                    field.sub(
                        field.mul(second[0], third[2]),
                        field.mul(second[2], third[0]),
                    ),
                )
            ),
            field.mul(
                first[2],
                field.sub(
                    field.mul(second[0], third[1]),
                    field.mul(second[1], third[0]),
                ),
            ),
        ),
    )


def rref(field, matrix):
    rows = [row[:] for row in matrix]
    pivots = []
    pivot_row = 0
    for column in range(len(rows[0])):
        selected = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column]),
            None,
        )
        if selected is None:
            continue
        rows[pivot_row], rows[selected] = rows[selected], rows[pivot_row]
        scale = field.inv(rows[pivot_row][column])
        rows[pivot_row] = [field.mul(value, scale) for value in rows[pivot_row]]
        for row in range(len(rows)):
            if row == pivot_row or rows[row][column] == 0:
                continue
            scale = rows[row][column]
            rows[row] = [
                field.sub(value, field.mul(scale, pivot_value))
                for value, pivot_value in zip(rows[row], rows[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return rows, pivots


def nullspace(field, matrix):
    reduced, pivots = rref(field, matrix)
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [field.zero] * len(matrix[0])
        vector[free_column] = field.one
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(reduced[row][free_column])
        basis.append(vector)
    return pivots, free, basis


def compatibility_row(field, view):
    A, B, C = view
    one_minus_B = field.sub(field.one, B)
    one_minus_C = field.sub(field.one, C)
    A_minus_one = field.sub(A, field.one)
    return [
        field.neg(field.mul(B, A_minus_one)),
        field.neg(field.mul(A, one_minus_B)),
        field.mul(C, A_minus_one),
        field.mul(A, one_minus_C),
        field.mul(C, one_minus_B),
        field.neg(field.mul(B, one_minus_C)),
    ]


def dot(field, left, right):
    return total(field, (field.mul(x, y) for x, y in zip(left, right)))


def normalized_parent(field, coordinates):
    a, b, c, d = coordinates
    return [
        (field.one, field.zero, field.zero),
        (field.zero, field.one, field.zero),
        (field.zero, field.zero, field.one),
        (field.one, field.one, field.one),
        (field.one, a, b),
        (field.one, c, d),
    ]


def is_arc(field, parent) -> bool:
    return all(
        determinant(field, parent[i], parent[j], parent[k])
        for i, j, k in itertools.combinations(range(6), 3)
    )


def camera_parameter(field, view, coordinates):
    A, B, C = view
    a, b, c, d = coordinates
    equations = []
    for image, x, y in ((B, a, b), (C, c, d)):
        denominator = field.sub(field.mul(image, x), A)
        numerator = total(
            field,
            (A, field.neg(field.one), field.mul(field.sub(field.one, image), y)),
        )
        if denominator:
            equations.append(div(field, numerator, denominator))
        elif numerator:
            return None
    if not equations or any(value != equations[0] for value in equations[1:]):
        return None
    return equations[0]


def verify_candidate(field, views, coordinates):
    parent = normalized_parent(field, coordinates)
    if not is_arc(field, parent):
        return None
    centres = []
    for view in views:
        A, B, C = view
        beta = camera_parameter(field, view, coordinates)
        if beta is None:
            return None
        alpha = field.sub(field.mul(A, field.add(beta, field.one)), field.one)
        centre = (beta, alpha, field.neg(field.mul(alpha, beta)))
        if not all(
            determinant(field, centre, parent[i], parent[j])
            for i, j in itertools.combinations(range(6), 2)
        ):
            return None
        # Recompute t_4,t_5,t_6 from the camera matrix
        images = []
        for point in parent[3:]:
            first = total(
                field,
                (field.mul(beta, point[1]), point[2]),
            )
            second = total(
                field,
                (field.mul(alpha, point[0]), point[2]),
            )
            if first == 0 or second != field.mul(images_value := view[len(images)], first):
                return None
            images.append(images_value)
        centres.append(centre)
    return centres


def reconstruct(field, views):
    matrix = [compatibility_row(field, view) for view in views]
    pivots, free, basis = nullspace(field, matrix)
    if len(pivots) != 4 or len(basis) != 2:
        raise AssertionError("the witness is outside the rank-four kernel chart")
    collision = [field.one] * 6
    if any(dot(field, row, collision) for row in matrix):
        raise AssertionError("universal collision vector is not in the kernel")

    candidates = {}
    directions = []
    first, second = basis
    for parameter in range(field.order):
        directions.append(
            (
                parameter,
                [
                    field.add(x, field.mul(parameter, y))
                    for x, y in zip(first, second)
                ],
            )
        )
    directions.append(("infinity", second))

    product_roots = 0
    collision_roots = 0
    for parameter, vector in directions:
        if vector[1] == 0 or vector[2] == 0 or vector[4] == 0:
            continue
        scale = div(field, vector[4], field.mul(vector[1], vector[2]))
        lifted = [field.mul(scale, value) for value in vector]
        if lifted[4] != field.mul(lifted[1], lifted[2]):
            continue
        if lifted[5] != field.mul(lifted[0], lifted[3]):
            continue
        product_roots += 1
        coordinates = tuple(lifted[:4])
        if coordinates == (field.one,) * 4:
            collision_roots += 1
            continue
        centres = verify_candidate(field, views, coordinates)
        if centres is not None:
            candidates[coordinates] = {
                "kernel_parameter": parameter,
                "centres": [list(centre) for centre in centres],
            }
    return {
        "matrix_rank": len(pivots),
        "pivot_columns": pivots,
        "free_columns": free,
        "product_roots_on_kernel_line": product_roots,
        "universal_collision_roots": collision_roots,
        "candidates": candidates,
    }


def homography(field, source, target):
    equations = []
    for (x, y), (X, Y) in zip(source[:3], target[:3]):
        equations.append(
            [
                field.mul(x, Y),
                field.mul(y, Y),
                field.neg(field.mul(x, X)),
                field.neg(field.mul(y, X)),
            ]
        )
    _, _, basis = nullspace(field, equations)
    if len(basis) != 1:
        return None
    a, b, c, d = basis[0]
    if field.sub(field.mul(a, d), field.mul(b, c)) == 0:
        return None
    return a, b, c, d


def acts_as(field, matrix, source, target) -> bool:
    a, b, c, d = matrix
    for (x, y), (X, Y) in zip(source, target):
        gx = field.add(field.mul(a, x), field.mul(b, y))
        gy = field.add(field.mul(c, x), field.mul(d, y))
        if field.sub(field.mul(gx, Y), field.mul(gy, X)):
            return False
    return True


def common_diagonal_stabilizer_size(field, views) -> int:
    sextics = [
        [
            (field.zero, field.one),
            (field.one, field.zero),
            (field.one, field.one),
            (field.one, A),
            (field.one, B),
            (field.one, C),
        ]
        for A, B, C in views
    ]
    answer = 0
    for permutation in itertools.permutations(range(6)):
        preserves_all = True
        for sextic in sextics:
            target = [sextic[index] for index in permutation]
            matrix = homography(field, sextic, target)
            if matrix is None or not acts_as(field, matrix, sextic, target):
                preserves_all = False
                break
        answer += preserves_all
    return answer


WITNESSES = (
    {
        "field": PrimeField(101),
        "views": ((54, 99, 4), (73, 24, 8), (87, 26, 13), (76, 87, 37)),
        "parents": ((66, 40, 49, 74), (37, 98, 73, 26)),
    },
    {
        "field": BinaryField256(),
        "views": ((88, 47, 216), (222, 99, 168), (24, 209, 150), (247, 95, 235)),
        "parents": ((134, 235, 130, 227), (153, 213, 62, 128)),
    },
)


def build_certificate():
    records = []
    for witness in WITNESSES:
        field = witness["field"]
        views = witness["views"]
        reconstruction = reconstruct(field, views)
        found = tuple(sorted(reconstruction["candidates"]))
        expected = tuple(sorted(witness["parents"]))
        if found != expected:
            raise AssertionError(f"candidate mismatch over {field.name}: {found} != {expected}")
        stabilizer_size = common_diagonal_stabilizer_size(field, views)
        if stabilizer_size != 1:
            raise AssertionError(f"nontrivial diagonal stabilizer over {field.name}")
        records.append(
            {
                "field": field.name,
                "field_convention": (
                    "integers modulo 101"
                    if field.name == "F_101"
                    else "polynomial basis modulo x^8+x^4+x^3+x+1"
                ),
                "views_ABC": [list(view) for view in views],
                "matrix_rank": reconstruction["matrix_rank"],
                "pivot_columns": reconstruction["pivot_columns"],
                "free_columns": reconstruction["free_columns"],
                "product_roots_on_kernel_line": reconstruction[
                    "product_roots_on_kernel_line"
                ],
                "universal_collision_roots": reconstruction[
                    "universal_collision_roots"
                ],
                "valid_deep_arc_reconstructions": [list(parent) for parent in found],
                "common_diagonal_S6_stabilizer_size": stabilizer_size,
            }
        )
    return {
        "schema": "c482-three-centre-synchronization-v1",
        "normalization": {
            "parent_frame": ["(1,0,0)", "(0,1,0)", "(0,0,1)", "(1,1,1)"],
            "remaining_parent_points": ["(1,a,b)", "(1,c,d)"],
            "view_points": ["infinity", "0", "1", "A_s", "B_s", "C_s"],
            "kernel_coordinates": ["a", "b", "c", "d", "bc", "ad"],
        },
        "checked_claim": (
            "Each witness has a rank-four compatibility matrix, exactly two valid deep "
            "six-arc reconstructions on the kernel chart, and trivial common diagonal S6 "
            "stabilizer.  The F_256 witness proves the quadratic ambiguity is separable in "
            "characteristic two."
        ),
        "witnesses": records,
    }


def canonical_bytes(value) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.emit == args.check:
        parser.error("choose exactly one of --emit or --check")
    payload = canonical_bytes(build_certificate())
    if args.emit:
        CERTIFICATE.write_bytes(payload)
        print(f"wrote {CERTIFICATE.name} ({len(payload)} bytes)")
        return
    tracked = CERTIFICATE.read_bytes()
    if tracked != payload:
        raise SystemExit("tracked certificate differs from exact regeneration")
    print(
        "ok:",
        CERTIFICATE.name,
        len(payload),
        "bytes",
        hashlib.sha256(payload).hexdigest(),
    )


if __name__ == "__main__":
    main()
