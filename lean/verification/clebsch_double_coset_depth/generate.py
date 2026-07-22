#!/usr/bin/env python3
"""Check and render the finite q=11 matching-depth certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CERTIFICATE = HERE / "certificate.json"
SCHEMA = HERE / "schema.json"
CHECKSUM = HERE / "SHA256SUMS"
DATA_LEAN = ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean"
MATCHING_LEAN = ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Matching.lean"
OWNED_LEAN = [
    DATA_LEAN,
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthBase.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthPositive.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthNegative.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepth.lean",
    ROOT / "lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean",
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_schema(data: dict, schema: dict) -> None:
    assert schema["$id"] == data["schema"], "schema identifier mismatch"
    assert set(data) == set(schema["properties"]), "certificate top-level fields changed"
    assert set(schema["required"]) <= set(data), "certificate is missing a required field"
    for name, rule in schema["properties"].items():
        value = data[name]
        if "const" in rule:
            assert value == rule["const"], f"unexpected constant for {name}"
        if rule.get("type") == "array":
            assert isinstance(value, list), f"{name} is not an array"
            assert len(value) >= rule.get("minItems", 0), f"{name} is too short"
            assert len(value) <= rule.get("maxItems", len(value)), f"{name} is too long"
        elif rule.get("type") == "object":
            assert isinstance(value, dict), f"{name} is not an object"
        elif rule.get("type") == "integer":
            assert isinstance(value, int), f"{name} is not an integer"


def matching_rows(source: str) -> list[list[int]]:
    start = source.index("def matchingMate")
    end = source.index("\n\n", start)
    rows = [
        [int(value.strip()) for value in row.split(",")]
        for row in re.findall(r"!\[([-0-9, ]+)\]", source[start:end])
    ]
    assert len(rows) == 22 and all(len(row) == 12 for row in rows)
    return rows


def normalize(vector: list[int], prime: int) -> tuple[int, ...]:
    pivot = next(value for value in vector if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def mat_vec(matrix: list[list[int]], vector: list[int], prime: int) -> tuple[int, ...]:
    return tuple(sum(a * b for a, b in zip(row, vector)) % prime for row in matrix)


def rank_mod(rows: list[list[int]], prime: int) -> int:
    matrix = [[value % prime for value in row] for row in rows]
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next((i for i in range(rank, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [inverse * value % prime for value in matrix[rank]]
        for i, row in enumerate(matrix):
            if i != rank and row[column]:
                factor = row[column]
                matrix[i] = [(x - factor * y) % prime for x, y in zip(row, matrix[rank])]
        rank += 1
    return rank


def generated_orbit(parent: int, generators: list[list[int]]) -> list[int]:
    orbit = {parent}
    while True:
        expanded = orbit | {generator[p] for generator in generators for p in orbit}
        if expanded == orbit:
            return sorted(orbit)
        orbit = expanded


def verify_certificate(data: dict) -> None:
    prime = data["field"]
    assert prime == 11
    for relative, expected in data["input_hashes"].items():
        path = ROOT / relative
        assert digest(path) == expected, f"input drift: {relative}"

    points = data["projective_points"]
    assert all(any(value % prime for value in point) for point in points)
    assert len({normalize(point, prime) for point in points}) == 133
    point_index = {tuple(point): i for i, point in enumerate(points)}
    assert len(point_index) == 133

    rows = matching_rows(MATCHING_LEAN.read_text())
    generators = data["k_parent_generators"]
    endpoint_generators = data["k_endpoint_generators"]
    point_generators = data["k_point_generators"]
    for matrix, endpoint_action, point_action, parent_action in zip(
        data["k_generator_matrices"], endpoint_generators, point_generators, generators
    ):
        assert sorted(endpoint_action) == list(range(12))
        assert sorted(point_action) == list(range(133))
        assert sorted(parent_action) == list(range(22))
        for x, point in enumerate(points):
            assert normalize(list(mat_vec(matrix, point, prime)), prime) == tuple(points[point_action[x]])
        for parent, row in enumerate(rows):
            moved = rows[parent_action[parent]]
            assert all(moved[endpoint_action[x]] == endpoint_action[row[x]] for x in range(12))

    assert all(generators[0][generators[0][p]] == p for p in range(22))
    assert all(generators[1][generators[1][generators[1][p]]] == p for p in range(22))

    sheet_matrix = data["j_matrix"]
    sheet_point = data["j_point"]
    sheet_endpoint = data["j_endpoint"]
    sheet_parent = data["j_parent"]
    assert sorted(sheet_point) == list(range(133))
    assert sorted(sheet_endpoint) == list(range(12))
    assert sorted(sheet_parent) == list(range(22))
    for x, point in enumerate(points):
        assert normalize(list(mat_vec(sheet_matrix, point, prime)), prime) == tuple(points[sheet_point[x]])
    for parent, row in enumerate(rows):
        moved = rows[sheet_parent[parent]]
        assert all(moved[sheet_endpoint[x]] == sheet_endpoint[row[x]] for x in range(12))

    orbits = [generated_orbit(parent, generators) for parent in data["representatives"]]
    assert orbits == [sorted(orbit) for orbit in data["generator_orbits"]]
    assert [len(orbit) for orbit in orbits] == [1, 4, 6, 1, 4, 6]
    assert sorted(value for orbit in orbits for value in orbit) == list(range(22))

    h3_to_standard = data["h3_to_standard"]
    standard_points = [mat_vec(h3_to_standard, point, prime) for point in points]
    parameters = data["conic_parameters"]
    cells = data["relation_cell_of_point"]
    oriented_pairs = data["oriented_relation_pairs"]

    def secant(i: int, j: int) -> tuple[int, int, int]:
        left, right = parameters[i], parameters[j]
        return (
            left[1] * right[1] % prime,
            -(left[0] * right[1] + left[1] * right[0]) % prime,
            left[0] * right[0] % prime,
        )

    def on_union(parent: int, point: tuple[int, ...]) -> bool:
        return any(
            sum(a * b for a, b in zip(secant(i, rows[parent][i]), point)) % prime == 0
            for i in range(12) if i < rows[parent][i]
        )

    profiles = []
    zero_counts = []
    for parent in range(22):
        counts = [0] * 16
        for point, cell in zip(standard_points, cells):
            if on_union(parent, point):
                counts[cell] += 1
        zero_counts.append(counts)
        profiles.append([counts[left] - counts[right] for left, right in oriented_pairs])

    representatives = data["representatives"]
    derived = data["derived_checks"]
    representative_profiles = [profiles[p] for p in representatives]
    assert [zero_counts[p] for p in representatives] == derived["representative_zero_counts"]
    assert representative_profiles == derived["representative_profiles"]
    assert all(len({tuple(profiles[p]) for p in orbit}) == 1 for orbit in orbits)
    assert all(profiles[sheet_parent[p]] == [-value for value in profiles[p]] for p in range(22))
    assert rank_mod(representative_profiles, prime) == derived["linear_rank_mod_11"] == 2
    assert len(set(map(tuple, representative_profiles))) == 6
    barycentre = [
        sum(weight * representative_profiles[i][coordinate] for i, weight in enumerate((1, 4, 6)))
        for coordinate in range(4)
    ]
    assert barycentre == derived["weighted_positive_barycentre"] == [0, 0, 0, 0]
    moments = [
        sum(weight * representative_profiles[i][0] ** degree
            for i, weight in enumerate((1, 4, 6, -1, -4, -6))) % prime
        for degree in (1, 2, 3)
    ]
    assert moments == derived["scalar_moments_degrees_1_2_3_mod_11"] == [0, 0, 6]


def lean_array(value) -> str:
    if isinstance(value, list):
        return "![" + ", ".join(lean_array(item) for item in value) + "]"
    return str(value)


def render_data(data: dict) -> str:
    return f'''import RelativeConicArcs.ClebschGatewayQ11Matching
import Mathlib.Data.Matrix.Basic

/-!
# Frozen coordinate data for six matching-depth classes

This generated module is rendered by
`lean/verification/clebsch_double_coset_depth/generate.py` from
`lean/verification/clebsch_double_coset_depth/certificate.json`, whose format is specified by
`lean/verification/clebsch_double_coset_depth/schema.json`.  The arrays encode 133 normalized
coordinate representatives over `ZMod 11`, sixteen labels, conic parameters, two displayed linear
maps and their finite permutations, and a sheet-exchanging linear map and permutations.  The
generator exhaustively checks the finite coordinate, permutation, orbit, incidence, profile, rank,
and moment semantics; Lean checks the exported finite equalities by kernel reduction.  The origin
of the frozen certificate, identification with abstract named groups, endpoint/conic compatibility,
and exhaustive projective-space coverage remain trusted external inputs.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

abbrev Parent := ClebschGateway.Q11Matching.Parent
abbrev Endpoint := ClebschGateway.Q11Matching.ChildPoint
abbrev ProjectivePoint := Fin 133
abbrev RelationCell := Fin 16
abbrev Generator := Fin 2

/-- The 133 frozen normalized coordinate representatives over `ZMod 11`. -/
def projectivePoint : ProjectivePoint → Fin 3 → ZMod 11 := {lean_array(data["projective_points"])}

/-- The displayed relation-cell label of each frozen coordinate representative. -/
def relationCell : ProjectivePoint → RelationCell := {lean_array(data["relation_cell_of_point"])}

/-- The displayed coordinate change used in the secant-incidence calculation. -/
def h3ToStandard : Matrix (Fin 3) (Fin 3) (ZMod 11) := {lean_array(data["h3_to_standard"])}

/-- Homogeneous parameters for twelve points of the standard conic. -/
def conicParameter : Endpoint → Fin 2 → ZMod 11 := {lean_array(data["conic_parameters"])}

/-- Two displayed linear maps over `ZMod 11`. -/
def subgroupGeneratorMatrix : Generator → Matrix (Fin 3) (Fin 3) (ZMod 11) :=
  {lean_array(data["k_generator_matrices"])}

/-- The displayed endpoint permutations associated with the two linear maps. -/
def subgroupGeneratorEndpoint : Generator → Endpoint → Endpoint :=
  {lean_array(data["k_endpoint_generators"])}

/-- The point permutations proved downstream to be induced by the two linear maps. -/
def subgroupGeneratorPoint : Generator → ProjectivePoint → ProjectivePoint :=
  {lean_array(data["k_point_generators"])}

/-- The matching-row permutations compatible with the endpoint permutations. -/
def subgroupGeneratorParent : Generator → Parent → Parent :=
  {lean_array(data["k_parent_generators"])}

/-- The displayed linear involution associated with the sheet exchange. -/
def sheetInvolutionMatrix : Matrix (Fin 3) (Fin 3) (ZMod 11) := {lean_array(data["j_matrix"])}

/-- The displayed sheet-exchanging endpoint permutation. -/
def sheetInvolutionEndpoint : Endpoint → Endpoint := {lean_array(data["j_endpoint"])}

/-- The point permutation proved downstream to be induced by the displayed linear involution. -/
def sheetInvolutionPoint : ProjectivePoint → ProjectivePoint := {lean_array(data["j_point"])}

/-- The displayed sheet-exchanging matching-row permutation. -/
def sheetInvolutionParent : Parent → Parent := {lean_array(data["j_parent"])}

/-- The displayed sheet-exchanging permutation of the sixteen relation labels. -/
def sheetInvolutionRelation : RelationCell → RelationCell := {lean_array(data["j_relation"])}

/-- Four oriented pairs of relation labels exchanged by the sheet involution. -/
def orientedRelationPair : Fin 4 → Fin 2 → RelationCell :=
  {lean_array(data["oriented_relation_pairs"])}

/-- One matching-row representative for each of the six permutation-generator orbits. -/
def orbitRepresentative : Fin 6 → Parent := {lean_array(data["representatives"])}

end ClebschDoubleCosetDepth
end RelativeConicArcs
'''


def checksum_text(paths: list[Path]) -> str:
    return "".join(f"{digest(path)}  {path.relative_to(ROOT)}\n" for path in paths)


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    data = json.loads(CERTIFICATE.read_text())
    schema = json.loads(SCHEMA.read_text())
    validate_schema(data, schema)
    verify_certificate(data)
    lean_text = render_data(data)
    covered = [Path(__file__), SCHEMA, CERTIFICATE, *OWNED_LEAN]
    if args.write:
        DATA_LEAN.write_text(lean_text)
        CHECKSUM.write_text(checksum_text(covered))
        print(f"wrote {DATA_LEAN.relative_to(ROOT)} and {CHECKSUM.relative_to(ROOT)}")
        return
    assert DATA_LEAN.read_text() == lean_text, "stale generated Lean data"
    assert CHECKSUM.read_text() == checksum_text(covered), "stale checksum manifest"
    print("matching-depth certificate, semantics, generated Lean, and hashes OK")


if __name__ == "__main__":
    main()
