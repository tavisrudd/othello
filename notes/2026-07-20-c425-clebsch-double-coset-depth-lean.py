#!/usr/bin/env python3
"""Generate and replay the finite q=11 double-coset depth data."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
OUTPUT = Path(__file__).with_suffix(".json")
CHECKSUM = Path(__file__).with_suffix(".sha256")
DATA_LEAN = ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean"
C411_PATH = HERE / "2026-07-20-c411-double-coset-hecke.py"
C411_JSON = C411_PATH.with_suffix(".json")
C380_PATH = HERE / "2026-07-19-c380-clebsch-gateway-lean-foundations.py"
MATCHING_LEAN = ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Matching.lean"
OWNED_LEAN = [
    DATA_LEAN,
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthBase.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthPositive.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepthNegative.lean",
    ROOT / "lean/RelativeConicArcs/ClebschDoubleCosetDepth.lean",
    ROOT / "lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean",
]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C411 = load_module("c425_c411", C411_PATH)
C406 = C411.C406
C380 = load_module("c425_c380", C380_PATH)


def normalize(vector, prime=11):
    pivot = next(value for value in vector if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def mat_vec(matrix, vector, prime=11):
    return tuple(sum(a * b for a, b in zip(row, vector)) % prime for row in matrix)


def lean_array(value):
    if isinstance(value, (list, tuple)):
        return "![" + ", ".join(lean_array(item) for item in value) + "]"
    return str(value)


def sha_record(path: Path):
    payload = path.read_bytes()
    return {"bytes": len(payload), "sha256": hashlib.sha256(payload).hexdigest()}


def edge_factorization_maps(matchings, sheets):
    result = []
    for indices in sheets:
        cells = {}
        for local_row, index in enumerate(indices):
            for left, right in matchings[index]:
                cells[tuple(sorted((left, right)))] = local_row
        assert len(cells) == 66
        result.append(cells)
    return result


def factorization_relabeling(source_matchings, source_sheets, target_matchings, target_sheets):
    """Recover an endpoint relabeling from the two unlabelled one-factorizations."""
    source = edge_factorization_maps(source_matchings, source_sheets)
    target = edge_factorization_maps(target_matchings, target_sheets)
    for swap in (0, 1):
        assignment = {}
        used = set()
        forward = [{}, {}]
        backward = [{}, {}]

        def search(vertex):
            if vertex == 12:
                return tuple(assignment[i] for i in range(12))
            for image in range(12):
                if image in used:
                    continue
                changes = []
                valid = True
                for old_vertex, old_image in assignment.items():
                    source_edge = tuple(sorted((vertex, old_vertex)))
                    target_edge = tuple(sorted((image, old_image)))
                    for sheet in (0, 1):
                        source_row = source[sheet][source_edge]
                        target_row = target[sheet ^ swap][target_edge]
                        if source_row in forward[sheet] and forward[sheet][source_row] != target_row:
                            valid = False
                            break
                        if target_row in backward[sheet] and backward[sheet][target_row] != source_row:
                            valid = False
                            break
                        if source_row not in forward[sheet]:
                            forward[sheet][source_row] = target_row
                            backward[sheet][target_row] = source_row
                            changes.append((sheet, source_row, target_row))
                    if not valid:
                        break
                if valid:
                    assignment[vertex] = image
                    used.add(image)
                    answer = search(vertex + 1)
                    if answer is not None:
                        return answer
                    used.remove(image)
                    del assignment[vertex]
                for sheet, source_row, target_row in reversed(changes):
                    del forward[sheet][source_row]
                    del backward[sheet][target_row]
            return None

        answer = search(0)
        if answer is not None:
            return answer, swap
    raise AssertionError("the displayed factorization pairs are not isomorphic")


def build_data():
    prime = 11
    scout = json.loads(C411.SCOUT_PATH.read_text())
    certificate = json.loads(C411.C406_CERT_PATH.read_text())
    scout_h3 = next(row for row in scout["types"] if row["type"] == "H3")
    c406_h3 = next(row for row in certificate["types"] if row["type"] == "H3")
    bridge = c406_h3["outer_sheet_sign"]["c378_depth_fourier_bridge"]

    conic, parameters = C406.C399.conic_parameterization(prime)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    h_group = C406.h3_group(prime, conic)
    base_matching = tuple(tuple(pair) for pair in scout_h3["coxeter_invariant_matching"])
    matchings = sorted({C406.matching_image(g, base_matching) for g in full_group})
    plus_sheet = {C406.matching_image(g, base_matching) for g in psl_group}
    source_sheets = [
        [i for i, matching in enumerate(matchings) if matching in plus_sheet],
        [i for i, matching in enumerate(matchings) if matching not in plus_sheet],
    ]
    gateway_rows = C380.vector_rows(MATCHING_LEAN.read_text(), "matchingMate", 22)
    gateway_matchings = [
        tuple((i, row[i]) for i in range(12) if i < row[i]) for row in gateway_rows
    ]
    endpoint_bridge, sheet_swap = factorization_relabeling(
        matchings, source_sheets, gateway_matchings, [list(range(11)), list(range(11, 22))]
    )
    transformed_matchings = [C406.matching_image(endpoint_bridge, matching) for matching in matchings]
    gateway_index = {matching: index for index, matching in enumerate(gateway_matchings)}
    source_to_gateway_parent = [gateway_index[matching] for matching in transformed_matchings]
    gateway_to_source_parent = [source_to_gateway_parent.index(i) for i in range(22)]

    c341 = C406.C378.load_c341()
    plus_group, labels, plus_relations = C406.C378.scheme(c341, 8)
    minus_group, minus_labels, minus_relations = C406.C378.scheme(c341, 4)
    assert labels == minus_labels
    intersection = plus_group & minus_group
    assert (len(full_group), len(psl_group), len(h_group), len(intersection)) == (1320, 660, 60, 12)

    common = C406.C378.orbits(
        c341, C406.C378.linear_group(intersection), c341.all_vectors(prime)
    )
    metadata = []
    for relation in common:
        plus_index = next(i for i, target in enumerate(plus_relations) if relation <= target)
        minus_index = next(i for i, target in enumerate(minus_relations) if relation <= target)
        metadata.append((plus_index, minus_index, min(relation), relation))
    metadata.sort(key=lambda item: item[:3])
    common = [item[3] for item in metadata]
    projective_cells = [
        {normalize(vector) for vector in relation if vector != (0, 0, 0)} for relation in common
    ]
    points = sorted(set().union(*projective_cells))
    assert len(points) == 133 and sum(map(len, projective_cells)) == 133
    point_index = {point: i for i, point in enumerate(points)}
    cell_of = [next(i for i, cell in enumerate(projective_cells) if point in cell) for point in points]

    conic_index = {point: i for i, point in enumerate(conic)}

    def point_action(matrix, source_points):
        target_index = {point: i for i, point in enumerate(source_points)}
        return [target_index[normalize(mat_vec(matrix, point))] for point in source_points]

    def source_endpoint_action(matrix):
        return [conic_index[normalize(mat_vec(matrix, point))] for point in conic]

    inverse_bridge = [endpoint_bridge.index(i) for i in range(12)]

    def gateway_endpoint_action(source_action):
        return [endpoint_bridge[source_action[inverse_bridge[i]]] for i in range(12)]

    action_to_matrix = {}
    for matrix in intersection:
        action_to_matrix[tuple(source_endpoint_action(matrix))] = matrix
    generator_actions = sorted(C406.permutation_generators(set(action_to_matrix)))
    generator_matrices = [action_to_matrix[action] for action in generator_actions]
    assert 1 <= len(generator_actions) <= 3

    def parent_action(source_endpoint_permutation):
        return [source_to_gateway_parent[
            matchings.index(C406.matching_image(
                source_endpoint_permutation, matchings[gateway_to_source_parent[gateway_parent]]
            ))
        ] for gateway_parent in range(22)]

    j_matrix = C406.C378.J
    j_source_endpoint = source_endpoint_action(j_matrix)
    j_endpoint = gateway_endpoint_action(j_source_endpoint)
    relation_permutation = []
    for relation in common:
        image = {c341.mat_vec(j_matrix, vector, prime) for vector in relation}
        relation_permutation.append(next(i for i, target in enumerate(common) if image == target))
    odd_pairs = [(i, image) for i, image in enumerate(relation_permutation) if i < image]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]

    h3_to_standard = C406.matrix_inverse(bridge["standard_to_h3_projectivity"], prime)
    signs = [
        1 if matchings[gateway_to_source_parent[i]] in plus_sheet else prime - 1
        for i in range(22)
    ]
    source_representatives = [0, 3, 4, 19, 5, 1]
    representatives = [source_to_gateway_parent[i] for i in source_representatives]
    source_orbits = [[0], [3, 9, 15, 17], [4, 6, 11, 13, 18, 20], [19], [2, 5, 10, 16], [1, 7, 8, 12, 14, 21]]
    expected_orbits = [[source_to_gateway_parent[i] for i in orbit] for orbit in source_orbits]
    gateway_parameters = [parameters[inverse_bridge[i]] for i in range(12)]
    k_parent_generators = [parent_action(action) for action in generator_actions]

    def secant_line(left, right):
        (sl, tl), (sr, tr) = gateway_parameters[left], gateway_parameters[right]
        return (tl * tr % prime, -(sl * tr + tl * sr) % prime, sl * sr % prime)

    standard_points = [mat_vec(h3_to_standard, point) for point in points]

    def lies_on_union(parent, point_index_value):
        point = standard_points[point_index_value]
        return any(
            sum(a * b for a, b in zip(secant_line(left, right), point)) % prime == 0
            for left, right in gateway_matchings[parent]
        )

    zero_counts = []
    profiles = []
    for parent in range(22):
        counts = [
            sum(cell_of[x] == relation and lies_on_union(parent, x) for x in range(133))
            for relation in range(16)
        ]
        zero_counts.append(counts)
        profiles.append([counts[left] - counts[right] for left, right in odd_pairs])

    def generated_orbit(parent):
        orbit = {parent}
        for _ in range(12):
            orbit |= {generator[p] for generator in k_parent_generators for p in orbit}
        return sorted(orbit)

    replay_orbits = [generated_orbit(parent) for parent in representatives]
    assert replay_orbits == [sorted(orbit) for orbit in expected_orbits]
    assert [len(orbit) for orbit in replay_orbits] == [1, 4, 6, 1, 4, 6]
    assert sorted(set().union(*map(set, replay_orbits))) == list(range(22))
    assert sum(map(len, replay_orbits)) == 22
    assert all(len({tuple(profiles[p]) for p in orbit}) == 1 for orbit in replay_orbits)
    j_parent = parent_action(j_source_endpoint)
    assert all(profiles[j_parent[p]] == [-value for value in profiles[p]] for p in range(22))
    representative_profiles = [profiles[p] for p in representatives]
    assert representative_profiles == [
        [-6, 0, 12, -12], [-3, 3, 0, 3], [3, -2, -2, 0],
        [6, 0, -12, 12], [3, -3, 0, -3], [-3, 2, 2, 0],
    ]
    assert C406.rank([[value % prime for value in row] for row in representative_profiles], prime) == 2
    assert len(set(map(tuple, representative_profiles))) == 6
    assert [
        sum(weight * representative_profiles[i][coordinate] for i, weight in enumerate((1, 4, 6)))
        for coordinate in range(4)
    ] == [0, 0, 0, 0]
    scalar_moments = [
        sum(weight * (representative_profiles[i][0] ** degree) for i, weight in enumerate((1, 4, 6, -1, -4, -6))) % prime
        for degree in (1, 2, 3)
    ]
    assert scalar_moments == [0, 0, 6]

    raw = {
        "schema": "clebsch-double-coset-depth-v1",
        "field": prime,
        "group_orders": {"PGL2": 1320, "PSL2": 660, "A5": 60, "A4": 12},
        "projective_points": [list(point) for point in points],
        "relation_cell_of_point": cell_of,
        "h3_to_standard": [list(row) for row in h3_to_standard],
        "conic_parameters": [list(parameter) for parameter in gateway_parameters],
        "endpoint_bridge_from_canonical_checker": list(endpoint_bridge),
        "factorization_sheet_swap": sheet_swap,
        "k_generator_matrices": [[list(row) for row in matrix] for matrix in generator_matrices],
        "k_endpoint_generators": [gateway_endpoint_action(action) for action in generator_actions],
        "k_point_generators": [point_action(matrix, points) for matrix in generator_matrices],
        "k_parent_generators": k_parent_generators,
        "j_matrix": [list(row) for row in j_matrix],
        "j_endpoint": j_endpoint,
        "j_point": point_action(j_matrix, points),
        "j_parent": j_parent,
        "j_relation": relation_permutation,
        "oriented_relation_pairs": [list(pair) for pair in odd_pairs],
        "representatives": representatives,
        "expected_orbits_replay_only": expected_orbits,
        "sheet_signs": signs,
        "derived_checks": {
            "representative_zero_counts": [zero_counts[p] for p in representatives],
            "representative_profiles": representative_profiles,
            "orbit_sizes": [1, 4, 6, 1, 4, 6],
            "profiles_distinct": True,
            "linear_rank_mod_11": 2,
            "linear_kernel_dimension": 4,
            "weighted_positive_barycentre": [0, 0, 0, 0],
            "scalar_moments_degrees_1_2_3_mod_11": scalar_moments,
            "j_negates_all_profiles": True,
        },
        "input_hashes": {
            C411_PATH.name: hashlib.sha256(C411_PATH.read_bytes()).hexdigest(),
            C411_JSON.name: hashlib.sha256(C411_JSON.read_bytes()).hexdigest(),
            C380_PATH.name: hashlib.sha256(C380_PATH.read_bytes()).hexdigest(),
            MATCHING_LEAN.name: hashlib.sha256(MATCHING_LEAN.read_bytes()).hexdigest(),
        },
    }
    return raw


def render_data(data):
    ngen = len(data["k_endpoint_generators"])
    return f'''import RelativeConicArcs.ClebschGatewayQ11Matching
import Mathlib.Data.Matrix.Basic

/-!
# Concrete projective data for six mixed double cosets

The arrays encode normalized points of the projective plane over `ZMod 11`, their sixteen relation
cells, conic parameters, two generators of the common tetrahedral subgroup, and the involution
exchanging the two special-linear sheets.  No depth profile, orbit decomposition, equivariance
statement, or recovery conclusion is included as input; checker modules derive those facts by
kernel reduction from these arrays and the displayed matching table.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

abbrev Parent := ClebschGateway.Q11Matching.Parent
abbrev Endpoint := ClebschGateway.Q11Matching.ChildPoint
abbrev ProjectivePoint := Fin 133
abbrev RelationCell := Fin 16
abbrev Generator := Fin {ngen}

/-- Normalized representatives of all points of the projective plane over `ZMod 11`. -/
def projectivePoint : ProjectivePoint → Fin 3 → ZMod 11 := {lean_array(data["projective_points"])}

/-- The common tetrahedral relation cell containing each normalized projective point. -/
def relationCell : ProjectivePoint → RelationCell := {lean_array(data["relation_cell_of_point"])}

/-- The projectivity from the icosahedral coordinates to the standard conic coordinates. -/
def h3ToStandard : Matrix (Fin 3) (Fin 3) (ZMod 11) := {lean_array(data["h3_to_standard"])}

/-- Homogeneous parameters for the twelve points of the standard conic. -/
def conicParameter : Endpoint → Fin 2 → ZMod 11 := {lean_array(data["conic_parameters"])}

/-- Linear representatives for generators of the common tetrahedral subgroup. -/
def subgroupGeneratorMatrix : Generator → Matrix (Fin 3) (Fin 3) (ZMod 11) :=
  {lean_array(data["k_generator_matrices"])}

/-- The induced generator actions on conic endpoints. -/
def subgroupGeneratorEndpoint : Generator → Endpoint → Endpoint :=
  {lean_array(data["k_endpoint_generators"])}

/-- The induced generator actions on normalized projective points. -/
def subgroupGeneratorPoint : Generator → ProjectivePoint → ProjectivePoint :=
  {lean_array(data["k_point_generators"])}

/-- The induced generator actions on the twenty-two matching rows. -/
def subgroupGeneratorParent : Generator → Parent → Parent :=
  {lean_array(data["k_parent_generators"])}

/-- A linear representative of the involution exchanging the two sheets. -/
def sheetInvolutionMatrix : Matrix (Fin 3) (Fin 3) (ZMod 11) := {lean_array(data["j_matrix"])}

/-- The sheet involution on conic endpoints. -/
def sheetInvolutionEndpoint : Endpoint → Endpoint := {lean_array(data["j_endpoint"])}

/-- The sheet involution on normalized projective points. -/
def sheetInvolutionPoint : ProjectivePoint → ProjectivePoint := {lean_array(data["j_point"])}

/-- The sheet involution on matching rows. -/
def sheetInvolutionParent : Parent → Parent := {lean_array(data["j_parent"])}

/-- The induced permutation of the sixteen relation cells. -/
def sheetInvolutionRelation : RelationCell → RelationCell := {lean_array(data["j_relation"])}

/-- Four oriented pairs of relation cells exchanged by the sheet involution. -/
def orientedRelationPair : Fin 4 → Fin 2 → RelationCell :=
  {lean_array(data["oriented_relation_pairs"])}

/-- One matching-row representative for each of the six generator orbits. -/
def orbitRepresentative : Fin 6 → Parent := {lean_array(data["representatives"])}

end ClebschDoubleCosetDepth
end RelativeConicArcs
'''


def canonical_json(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def checksum_text(paths):
    lines = []
    for path in paths:
        payload = path.read_bytes()
        lines.append(f"{hashlib.sha256(payload).hexdigest()}  {path.relative_to(ROOT)}")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    data = build_data()
    json_bytes = canonical_json(data)
    lean_text = render_data(data)
    if args.write:
        OUTPUT.write_bytes(json_bytes)
        DATA_LEAN.write_text(lean_text)
        CHECKSUM.write_text(checksum_text([Path(__file__), OUTPUT, *OWNED_LEAN]))
        print(f"wrote {OUTPUT.name}, {DATA_LEAN.relative_to(ROOT)}, and {CHECKSUM.name}")
        return

    assert OUTPUT.read_bytes() == json_bytes, "stale JSON certificate"
    assert DATA_LEAN.read_text() == lean_text, "stale generated Lean data"
    expected = checksum_text([Path(__file__), OUTPUT, *OWNED_LEAN])
    assert CHECKSUM.read_text() == expected, "stale checksum manifest"
    print("double-coset depth data, replay, and hashes OK")


if __name__ == "__main__":
    main()
