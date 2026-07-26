#!/usr/bin/env python3
"""Check the incidence-pattern compression of the PG(2,16) eight-arc leaves.

For every leaf in the checked augmentation list, compute its ordinary
uncovered locus.  A pattern certificate consists of three collinear uncovered
points on a line together with three noncollinear uncovered points off that
line.  No quadratic can contain such a six-point configuration: the first
triple forces the line as a component, while the residual linear factor
cannot contain the second triple.

The three leaves without this pattern are checked separately by computing the
one-dimensional quadratic kernel and its intersection with the selected arc.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import pathlib
import re
import sys
import tempfile

MODULUS = 0x13  # x^4 + x + 1
Q = 16


def mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return out


def inv(a: int) -> int:
    if not a:
        raise ZeroDivisionError
    return next(b for b in range(1, Q) if mul(a, b) == 1)


def scale(c: int, v: tuple[int, ...] | list[int]) -> tuple[int, ...]:
    return tuple(mul(c, x) for x in v)


def normalize(v: tuple[int, ...] | list[int]) -> tuple[int, ...]:
    lead = next(x for x in v if x)
    return scale(inv(lead), v)


POINTS = tuple(
    [(0, 0, 1)]
    + [(0, 1, z) for z in range(Q)]
    + [(1, y, z) for y in range(Q) for z in range(Q)]
)
POINT_INDEX = {p: i for i, p in enumerate(POINTS)}


def dot(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    out = 0
    for x, y in zip(a, b):
        out ^= mul(x, y)
    return out


def cross(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
    return normalize(
        (
            mul(a[1], b[2]) ^ mul(a[2], b[1]),
            mul(a[2], b[0]) ^ mul(a[0], b[2]),
            mul(a[0], b[1]) ^ mul(a[1], b[0]),
        )
    )


def det(a: tuple[int, ...], b: tuple[int, ...], c: tuple[int, ...]) -> int:
    return dot(cross(a, b), c)


LINES = {
    line: tuple(i for i, point in enumerate(POINTS) if dot(line, point) == 0)
    for line in POINTS
}


def read_level8(path: pathlib.Path) -> list[tuple[int, ...]]:
    text = path.read_text()
    match = re.search(r"def level8 .*? := \[\n(.*?)\n\]\n\nend", text, re.S)
    if not match:
        raise ValueError(f"could not locate level8 in {path}")
    arcs = [
        tuple(map(int, members.split(",")))
        for members in re.findall(r"\{([0-9,]+)\}", match.group(1))
    ]
    if len(arcs) != 2633 or any(len(arc) != 8 for arc in arcs):
        raise ValueError(f"unexpected level-eight list: {len(arcs)} leaves")
    return arcs


def uncovered(arc: tuple[int, ...]) -> tuple[int, ...]:
    covered: set[int] = set()
    for a, b in itertools.combinations(arc, 2):
        covered.update(LINES[cross(POINTS[a], POINTS[b])])
    return tuple(i for i in range(len(POINTS)) if i not in covered)


def pattern(points: tuple[int, ...]) -> tuple[int, ...] | None:
    for line_triple in itertools.combinations(points, 3):
        line = cross(POINTS[line_triple[0]], POINTS[line_triple[1]])
        if dot(line, POINTS[line_triple[2]]) != 0:
            continue
        off_line = tuple(i for i in points if dot(line, POINTS[i]) != 0)
        for triangle in itertools.combinations(off_line, 3):
            if det(*(POINTS[i] for i in triangle)) != 0:
                return line_triple + triangle
    return None


def monomial(point: tuple[int, ...]) -> tuple[int, ...]:
    x, y, z = point
    return (mul(x, x), mul(y, y), mul(z, z), mul(x, y), mul(x, z), mul(y, z))


def eval_quadratic(form: tuple[int, ...], point: tuple[int, ...]) -> int:
    return dot(monomial(point), form)


def eval_linear(form: tuple[int, ...], point: tuple[int, ...]) -> int:
    return dot(form, point)


def matrix_mul_vec(
    matrix: tuple[tuple[int, ...], ...], point: tuple[int, ...]
) -> tuple[int, ...]:
    return tuple(dot(row, point) for row in matrix)


def det3(matrix: tuple[tuple[int, ...], ...]) -> int:
    a, b, c = matrix
    return (
        mul(a[0], mul(b[1], c[2]) ^ mul(b[2], c[1]))
        ^ mul(a[1], mul(b[0], c[2]) ^ mul(b[2], c[0]))
        ^ mul(a[2], mul(b[0], c[1]) ^ mul(b[1], c[0]))
    )


def verify_exceptional_arithmetic(exception: dict) -> None:
    leaf = exception["leaf"]
    form = tuple(exception["kernel_generator"])
    vectors = itertools.product(range(Q), repeat=3)
    if leaf == 89:
        left = (1, 6, 6)
        right = (1, 7, 7)
        if any(
            eval_quadratic(form, v)
            != mul(eval_linear(left, v), eval_linear(right, v))
            for v in vectors
        ):
            raise AssertionError("leaf 89 factorization")
        exception["factorization"] = [[1, 6, 6], [1, 7, 7]]
        exception["factorization_vector_count"] = Q**3
    elif leaf == 2631:
        left = (1, 4, 15)
        right = (1, 15, 4)
        if any(
            eval_quadratic(form, v)
            != mul(eval_linear(left, v), eval_linear(right, v))
            for v in vectors
        ):
            raise AssertionError("leaf 2631 factorization")
        exception["factorization"] = [[1, 4, 15], [1, 15, 4]]
        exception["factorization_vector_count"] = Q**3
    elif leaf == 90:
        matrix = ((0, 1, 10), (0, 0, 15), (5, 0, 1))
        determinant = det3(matrix)
        if determinant != 6:
            raise AssertionError(("leaf 90 determinant", determinant))
        for v in vectors:
            x, y, z = matrix_mul_vec(matrix, v)
            standard_conic = mul(y, y) ^ mul(x, z)
            if standard_conic != mul(5, eval_quadratic(form, v)):
                raise AssertionError(("leaf 90 transport", v))
        exception["nonsingular_model_matrix"] = [list(row) for row in matrix]
        exception["nonsingular_model_matrix_det"] = determinant
        exception["nonsingular_model_scalar"] = 5
        exception["standard_conic_transport_vector_count"] = Q**3
    else:
        raise AssertionError(("unexpected exceptional leaf", leaf))


def kernel(rows: list[tuple[int, ...]]) -> list[tuple[int, ...]]:
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    row = 0
    for column in range(6):
        pivot = next((i for i in range(row, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        matrix[row] = list(scale(inv(matrix[row][column]), matrix[row]))
        for i in range(len(matrix)):
            if i != row and matrix[i][column]:
                coefficient = matrix[i][column]
                matrix[i] = [
                    x ^ mul(coefficient, y) for x, y in zip(matrix[i], matrix[row])
                ]
        pivots.append(column)
        row += 1
    free = [column for column in range(6) if column not in pivots]
    answer = []
    for column in free:
        vector = [0] * 6
        vector[column] = 1
        for i, pivot in enumerate(pivots):
            vector[pivot] = matrix[i][column]
        answer.append(normalize(vector))
    return answer


def build_summary(levels: pathlib.Path) -> dict:
    arcs = read_level8(levels)
    patterns = []
    exceptions = []
    for leaf, arc in enumerate(arcs):
        locus = uncovered(arc)
        witness = pattern(locus)
        if witness is not None:
            patterns.append({"leaf": leaf, "points": list(witness)})
            continue
        forms = kernel([monomial(POINTS[i]) for i in locus])
        if len(forms) != 1:
            raise AssertionError((leaf, len(forms)))
        form = forms[0]
        hits = [i for i in arc if dot(monomial(POINTS[i]), form) == 0]
        exceptions.append(
            {
                "arc": list(arc),
                "arc_hit_points": hits,
                "arc_points": [list(POINTS[i]) for i in arc],
                "kernel_generator": list(form),
                "leaf": leaf,
                "uncovered_size": len(locus),
            }
        )
        verify_exceptional_arithmetic(exceptions[-1])
    if len(patterns) != 2630 or len(exceptions) != 3:
        raise AssertionError((len(patterns), len(exceptions)))
    return {
        "exceptional_leaves": exceptions,
        "field": "GF(16), polynomial basis modulo x^4+x+1",
        "leaf_count": len(arcs),
        "levels_sha256": hashlib.sha256(levels.read_bytes()).hexdigest(),
        "pattern": (
            "three collinear ordinary-uncovered points, followed by three "
            "noncollinear ordinary-uncovered points off their line"
        ),
        "pattern_leaf_count": len(patterns),
        "pattern_witnesses": patterns,
        "schema": "q16-uncovered-patterns-v1",
    }


def canonical_bytes(summary: dict) -> bytes:
    return (json.dumps(summary, sort_keys=True, separators=(",", ":")) + "\n").encode()


def main() -> None:
    here = pathlib.Path(__file__).resolve().parent
    default_levels = (
        here.parents[1] / "lean/RelativeConicArcs/Q16CertificateLevels.lean"
    )
    default_output = here / "check_q16_uncovered_patterns.json"
    parser = argparse.ArgumentParser()
    parser.add_argument("--levels", type=pathlib.Path, default=default_levels)
    parser.add_argument("--output", type=pathlib.Path, default=default_output)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    content = canonical_bytes(build_summary(args.levels))
    if args.write:
        args.output.write_bytes(content)
        return
    with tempfile.TemporaryDirectory() as directory:
        candidate = pathlib.Path(directory) / args.output.name
        candidate.write_bytes(content)
        if not args.output.exists() or candidate.read_bytes() != args.output.read_bytes():
            print(f"stale output: {args.output}", file=sys.stderr)
            raise SystemExit(1)
    print(
        "PASS: 2630 line-plus-off-line-triangle patterns and 3 exceptional leaves"
    )


if __name__ == "__main__":
    main()
