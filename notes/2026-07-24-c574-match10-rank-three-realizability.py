#!/usr/bin/env python3
"""Exact certificates for C574's two MATCH(10,5,1) designs.

The construction follows Reichard--Woldar: enumerate the overlarge sets of
S(3,4,8) designs containing one fixed affine design, quotient by its
AGL(3,2) stabilizer, and turn each orbit representative into 63 perfect
matchings on ten vertices.  A separate GF(8) implementation constructs the
regular-hyperoval secant-concurrence design.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import subprocess
from typing import Iterable, Iterator


Block = tuple[int, int, int, int]
AffineDesign = tuple[Block, ...]
OverlargeSet = tuple[AffineDesign, ...]
Edge = tuple[int, int]
Matching = tuple[Edge, ...]

STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")


def affine_blocks(points: tuple[int, ...]) -> AffineDesign:
    """The 14 affine planes of AG(3,2), with points in binary order."""
    blocks: list[Block] = []
    for normal in range(1, 8):
        for constant in range(2):
            block = tuple(
                points[x]
                for x in range(8)
                if ((normal & x).bit_count() & 1) == constant
            )
            blocks.append(tuple(sorted(block)))
    return tuple(sorted(blocks))


STANDARD = affine_blocks(tuple(range(8)))


def all_affine_designs_on(points: tuple[int, ...]) -> tuple[AffineDesign, ...]:
    designs = {
        affine_blocks(tuple(points[i] for i in permutation))
        for permutation in itertools.permutations(range(8))
    }
    assert len(designs) == 30
    return tuple(sorted(designs))


def enumerate_overlarge_sets() -> tuple[OverlargeSet, ...]:
    """All labeled overlarge sets containing STANDARD as design 8."""
    candidates: dict[int, tuple[AffineDesign, ...]] = {}
    for omitted in range(8):
        points = tuple(x for x in range(9) if x != omitted)
        candidates[omitted] = tuple(
            design
            for design in all_affine_designs_on(points)
            if not set(design).intersection(STANDARD)
        )

    chosen: list[AffineDesign | None] = [None] * 9
    chosen[8] = STANDARD
    covered = set(STANDARD)
    solutions: list[OverlargeSet] = []

    def visit(remaining: tuple[int, ...]) -> None:
        if not remaining:
            assert len(covered) == 126
            solutions.append(tuple(design for design in chosen if design is not None))
            return
        viable = {
            omitted: tuple(
                design
                for design in candidates[omitted]
                if covered.isdisjoint(design)
            )
            for omitted in remaining
        }
        omitted = min(remaining, key=lambda item: len(viable[item]))
        rest = tuple(item for item in remaining if item != omitted)
        for design in viable[omitted]:
            chosen[omitted] = design
            covered.update(design)
            visit(rest)
            covered.difference_update(design)
            chosen[omitted] = None

    visit(tuple(range(8)))
    assert len(solutions) == 64
    return tuple(sorted(solutions))


def invertible_binary_matrices() -> Iterator[tuple[int, int, int]]:
    for rows in itertools.permutations(range(1, 8), 3):
        images = {
            tuple(((row & column).bit_count() & 1) for row in rows)
            for column in range(8)
        }
        if len(images) == 8:
            yield rows


def agl32_stabilizer() -> tuple[tuple[int, ...], ...]:
    permutations = set()
    for rows in invertible_binary_matrices():
        for translation in range(8):
            image = []
            for column in range(8):
                value = 0
                for bit, row in enumerate(rows):
                    value |= (((row & column).bit_count() & 1) << bit)
                image.append(value ^ translation)
            permutations.add(tuple(image) + (8,))
    assert len(permutations) == 1344
    return tuple(sorted(permutations))


def permute_block(block: Iterable[int], permutation: tuple[int, ...]) -> Block:
    return tuple(sorted(permutation[x] for x in block))


def permute_overlarge(
    overlarge: OverlargeSet, permutation: tuple[int, ...]
) -> OverlargeSet:
    image: list[AffineDesign | None] = [None] * 9
    for omitted, design in enumerate(overlarge):
        image[permutation[omitted]] = tuple(
            sorted(permute_block(block, permutation) for block in design)
        )
    return tuple(design for design in image if design is not None)


def overlarge_orbits(
    solutions: tuple[OverlargeSet, ...],
) -> tuple[tuple[OverlargeSet, ...], ...]:
    solution_set = set(solutions)
    stabilizer = agl32_stabilizer()
    orbits = []
    while solution_set:
        representative = min(solution_set)
        orbit = {
            permute_overlarge(representative, permutation)
            for permutation in stabilizer
        }
        assert orbit <= set(solutions)
        solution_set.difference_update(orbit)
        orbits.append(tuple(sorted(orbit)))
    assert sorted(len(orbit) for orbit in orbits) == [8, 56]
    return tuple(sorted(orbits, key=len))


def perfect_matchings(vertices: tuple[int, ...]) -> Iterator[Matching]:
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        edge = tuple(sorted((first, second)))
        for tail in perfect_matchings(rest):
            yield tuple(sorted((edge,) + tail))


def matching_design(overlarge: OverlargeSet) -> tuple[Matching, ...]:
    matchings: list[Matching] = []
    for omitted, design in enumerate(overlarge):
        block_set = set(design)
        remaining = tuple(x for x in range(9) if x != omitted)
        parallel_classes = []
        for matching in perfect_matchings(remaining):
            if all(
                tuple(sorted(edge1 + edge2)) in block_set
                for edge1, edge2 in itertools.combinations(matching, 2)
            ):
                parallel_classes.append(matching)
        assert len(parallel_classes) == 7
        for parallel_class in parallel_classes:
            matchings.append(
                tuple(sorted(parallel_class + ((omitted, 9),)))
            )
    result = tuple(sorted(matchings))
    validate_matching_design(result)
    return result


def validate_matching_design(design: tuple[Matching, ...]) -> None:
    assert len(design) == 63
    assert len(set(design)) == 63
    covered: dict[tuple[Edge, Edge], int] = {}
    edge_counts = {edge: 0 for edge in itertools.combinations(range(10), 2)}
    for matching in design:
        assert len(matching) == 5
        assert {vertex for edge in matching for vertex in edge} == set(range(10))
        for edge in matching:
            edge_counts[edge] += 1
        for pair in itertools.combinations(matching, 2):
            covered[tuple(sorted(pair))] = covered.get(tuple(sorted(pair)), 0) + 1
    assert len(covered) == 630
    assert set(covered.values()) == {1}
    assert set(edge_counts.values()) == {7}


def gf8_multiply(left: int, right: int) -> int:
    result = 0
    value = left
    multiplier = right
    while multiplier:
        if multiplier & 1:
            result ^= value
        multiplier >>= 1
        value <<= 1
        if value & 8:
            value ^= 0b1011  # x^3+x+1
    return result


def gf8_inverse(value: int) -> int:
    assert value
    return next(candidate for candidate in range(1, 8) if gf8_multiply(value, candidate) == 1)


def cross(left: tuple[int, int, int], right: tuple[int, int, int]) -> tuple[int, int, int]:
    return (
        gf8_multiply(left[1], right[2]) ^ gf8_multiply(left[2], right[1]),
        gf8_multiply(left[2], right[0]) ^ gf8_multiply(left[0], right[2]),
        gf8_multiply(left[0], right[1]) ^ gf8_multiply(left[1], right[0]),
    )


def canonical_projective(point: tuple[int, int, int]) -> tuple[int, int, int]:
    first = next(value for value in point if value)
    inverse = gf8_inverse(first)
    return tuple(gf8_multiply(inverse, value) for value in point)


def gf8_projective_points() -> tuple[tuple[int, int, int], ...]:
    return tuple(
        sorted(
            {
                canonical_projective(point)
                for point in itertools.product(range(8), repeat=3)
                if point != (0, 0, 0)
            }
        )
    )


def hyperoval_design() -> tuple[Matching, ...]:
    square = lambda value: gf8_multiply(value, value)
    hyperoval = tuple(
        canonical_projective(point)
        for point in (
            [(square(value), value, 1) for value in range(8)]
            + [(1, 0, 0), (0, 1, 0)]
        )
    )
    hyperoval_set = set(hyperoval)
    assert len(hyperoval_set) == 10
    projective_points = gf8_projective_points()
    secant_centres: dict[tuple[int, int, int], list[Edge]] = {}
    for edge in itertools.combinations(range(10), 2):
        line = cross(hyperoval[edge[0]], hyperoval[edge[1]])
        for centre in projective_points:
            if centre in hyperoval_set:
                continue
            incidence = 0
            for coefficient, coordinate in zip(line, centre):
                incidence ^= gf8_multiply(coefficient, coordinate)
            if incidence == 0:
                secant_centres.setdefault(centre, []).append(edge)
    design = tuple(sorted(tuple(sorted(edges)) for edges in secant_centres.values()))
    validate_matching_design(design)
    assert len(design) == 63
    return design


def permute_matching(
    matching: Matching, permutation: tuple[int, ...]
) -> Matching:
    return tuple(
        sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in matching)
    )


def find_design_isomorphism(
    source: tuple[Matching, ...], target: tuple[Matching, ...]
) -> tuple[int, ...] | None:
    target_set = set(target)
    probes = source[:8]
    for permutation in itertools.permutations(range(10)):
        if all(permute_matching(matching, permutation) in target_set for matching in probes):
            image = {
                permute_matching(matching, permutation)
                for matching in source
            }
            if image == target_set:
                return permutation
    return None


def digest_object(value: object) -> str:
    payload = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def polynomial_cross(
    left: tuple[str, str, str], right: tuple[str, str, str]
) -> tuple[str, str, str]:
    return (
        f"(({left[1]})*({right[2]})-({left[2]})*({right[1]}))",
        f"(({left[2]})*({right[0]})-({left[0]})*({right[2]}))",
        f"(({left[0]})*({right[1]})-({left[1]})*({right[0]}))",
    )


def polynomial_determinant(
    first: tuple[str, str, str],
    second: tuple[str, str, str],
    third: tuple[str, str, str],
) -> str:
    return (
        f"({first[0]})*(({second[1]})*({third[2]})-({second[2]})*({third[1]}))"
        f"-({first[1]})*(({second[0]})*({third[2]})-({second[2]})*({third[0]}))"
        f"+({first[2]})*(({second[0]})*({third[1]})-({second[1]})*({third[0]}))"
    )


def singular_program(
    design: tuple[Matching, ...], characteristic: int, ordering: str = "dp"
) -> str:
    assert ordering in {"dp", "lp"}
    variables = tuple(
        variable
        for vertex in range(4, 10)
        for variable in (f"x{vertex}", f"y{vertex}")
    )
    points: tuple[tuple[str, str, str], ...] = (
        ("1", "0", "0"),
        ("0", "1", "0"),
        ("0", "0", "1"),
        ("1", "1", "1"),
    ) + tuple((f"x{vertex}", f"y{vertex}", "1") for vertex in range(4, 10))
    equations = []
    for matching in design:
        lines = [
            polynomial_cross(points[first], points[second])
            for first, second in matching
        ]
        equations.extend(
            polynomial_determinant(lines[0], lines[1], line)
            for line in lines[2:]
        )
    return "\n".join(
        [
            f"ring r={characteristic},({','.join(variables)}),{ordering};",
            f"ideal I={','.join(equations)};",
            "ideal G=std(I);",
            'print("BASIS_SIZE"); print(size(G));',
            'print("DIMENSION"); print(dim(G));',
            'print("XY_REMAINDER"); print(NF(x9-y9,G));',
            'print("QUADRATIC_REMAINDER");',
            "print(NF(y9^2+x9-2*y9,G));",
            f"ring s={characteristic},({','.join(variables)},u),{ordering};",
            f"ideal J={','.join(equations)},u*x9*(x9-1)-1;",
            "ideal H=std(J);",
            'print("SATURATED_UNIT");',
            'if (size(H)==1 && H[1]==1) { print(1); } else { print(0); }',
            "quit;",
        ]
    )


def run_singular_check(
    design: tuple[Matching, ...], characteristic: int, ordering: str
) -> dict[str, int | str]:
    completed = subprocess.run(
        ["Singular", "-q"],
        input=singular_program(design, characteristic, ordering),
        text=True,
        capture_output=True,
        check=True,
    )
    lines = [line.strip() for line in completed.stdout.splitlines() if line.strip()]
    labels = (
        "BASIS_SIZE",
        "DIMENSION",
        "XY_REMAINDER",
        "QUADRATIC_REMAINDER",
        "SATURATED_UNIT",
    )
    positions = {label: lines.index(label) for label in labels}
    result = {
        "basis_size": int(lines[positions["BASIS_SIZE"] + 1]),
        "dimension": int(lines[positions["DIMENSION"] + 1]),
        "xy_remainder": lines[positions["XY_REMAINDER"] + 1],
        "quadratic_remainder": lines[positions["QUADRATIC_REMAINDER"] + 1],
        "saturated_unit": int(lines[positions["SATURATED_UNIT"] + 1]),
        "ordering": ordering,
    }
    return result


def generate() -> dict[str, object]:
    solutions = enumerate_overlarge_sets()
    orbits = overlarge_orbits(solutions)
    representatives = [orbit[0] for orbit in orbits]
    designs = [matching_design(representative) for representative in representatives]
    hyperoval = hyperoval_design()
    hyperoval_to_classical = find_design_isomorphism(hyperoval, designs[0])
    assert hyperoval_to_classical is not None
    assert find_design_isomorphism(hyperoval, designs[1]) is None
    algebraic_checks = []
    for characteristic, class_index, ordering in itertools.product(
        (2, 37), (0, 1), ("dp", "lp")
    ):
        check = run_singular_check(designs[class_index], characteristic, ordering)
        check.update(
            {
                "characteristic": characteristic,
                "class": (
                    "classical-hyperoval"
                    if class_index == 0
                    else "mathon-nonhyperoval"
                ),
            }
        )
        algebraic_checks.append(check)
    expected_units = {
        (2, "classical-hyperoval"): 0,
        (2, "mathon-nonhyperoval"): 1,
        (37, "classical-hyperoval"): 1,
        (37, "mathon-nonhyperoval"): 1,
    }
    assert all(
        check["saturated_unit"]
        == expected_units[(check["characteristic"], check["class"])]
        for check in algebraic_checks
    )
    assert all(
        (check["xy_remainder"], check["quadratic_remainder"]) == ("0", "0")
        for check in algebraic_checks
        if expected_units[(check["characteristic"], check["class"])]
    )
    return {
        "schema": "c574-match10-v1",
        "realization_chart": {
            "fixed_points": [
                [1, 0, 0],
                [0, 1, 0],
                [0, 0, 1],
                [1, 1, 1],
            ],
            "remaining_points": "[x_i:y_i:1], i=4,...,9",
            "concurrency_equations": 189,
            "forced_relations": [
                "x9-y9",
                "y9^2+x9-2*y9",
            ],
            "saturation": "u*x9*(x9-1)-1",
            "singular_version": "4.4.1",
        },
        "algebraic_checks": algebraic_checks,
        "overlarge_solutions_containing_fixed_design": len(solutions),
        "agl32_orbit_sizes": [len(orbit) for orbit in orbits],
        "classes": [
            {
                "name": "classical-hyperoval" if index == 0 else "mathon-nonhyperoval",
                "full_automorphism_order": 9 * 1344 // len(orbits[index]),
                "overlarge_representative": representative,
                "matching_design": designs[index],
                "matching_design_sha256": digest_object(designs[index]),
            }
            for index, representative in enumerate(representatives)
        ],
        "gf8_hyperoval": {
            "matching_design": hyperoval,
            "matching_design_sha256": digest_object(hyperoval),
            "transporter_to_classical": hyperoval_to_classical,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--singular", choices=("classical", "mathon"))
    parser.add_argument("--characteristic", type=int)
    args = parser.parse_args()
    if args.singular:
        if args.characteristic is None:
            parser.error("--singular requires --characteristic")
        certificate = json.loads(JSON_PATH.read_text())
        index = 0 if args.singular == "classical" else 1
        design = tuple(
            tuple(tuple(edge) for edge in matching)
            for matching in certificate["classes"][index]["matching_design"]
        )
        print(singular_program(design, args.characteristic))
        return
    generated = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.check:
        tracked = JSON_PATH.read_text()
        if generated != tracked:
            raise SystemExit("tracked JSON does not match regenerated certificate")
        print("C574 certificate check passed")
    else:
        print(generated, end="")


if __name__ == "__main__":
    main()
