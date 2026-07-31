#!/usr/bin/env python3
"""Build and directly verify the C725 terminal passant-arc orbit DAG.

The vertices are PGL(2,q)-orbits of pairwise-passant arcs with no collinear
triple, for q in 13, 17, 19.  Edges are extension orbits under the setwise
stabilizer of a node.  Terminal nodes carry one explicit one-byte blocker for
every off-conic point.  The default mode verifies the tracked certificate;
``--check`` regenerates it byte for byte and ``--write`` updates it.
"""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
from collections import defaultdict
from itertools import combinations
from pathlib import Path
from typing import Iterable, Iterator


Point = tuple[int, int, int]
Matrix2 = tuple[int, int, int, int]
Arc = tuple[int, ...]

FIELDS = (13, 17, 19)
EXPECTED_SUMMARY = {
    13: {"passant_edges": 7098, "edge_orbits": 10, "six_orbits": 2, "six_mass": 546, "pair_fingerprints": 2},
    17: {"passant_edges": 20808, "edge_orbits": 13, "six_orbits": 22, "six_mass": 50184, "pair_fingerprints": 22},
    19: {"passant_edges": 32490, "edge_orbits": 15, "six_orbits": 94, "six_mass": 395124, "pair_fingerprints": 92},
}
SCHEMA = "clebsch-c725-terminal-passant-orbit-dag-v1"
CERTIFICATE = Path(__file__).with_name("c725_terminal_orbit_dag.json.gz")
MANIFEST = Path(__file__).with_name("c725_finite_boundary_manifest.json")
PAPER_ROOT = Path(__file__).resolve().parent.parent


def normalize(vector: Point, q: int) -> Point:
    pivot = next(value for value in vector if value % q)
    scale = pow(pivot, q - 2, q)
    return tuple(scale * coordinate % q for coordinate in vector)  # type: ignore[return-value]


def projective_points(q: int) -> list[Point]:
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


def cross(left: Point, right: Point, q: int) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def dot(left: Point, right: Point, q: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % q


def passant(left: Point, right: Point, q: int) -> bool:
    a, b, c = cross(left, right, q)
    discriminant = (b * b - 4 * a * c) % q
    return discriminant != 0 and pow(discriminant, (q - 1) // 2, q) == q - 1


def pgl2(q: int) -> Iterator[Matrix2]:
    seen: set[Matrix2] = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    raw = (a, b, c, d)
                    pivot = next(value for value in raw if value)
                    scale = pow(pivot, q - 2, q)
                    matrix = tuple(scale * value % q for value in raw)
                    if matrix not in seen:
                        seen.add(matrix)
                        yield matrix  # type: ignore[misc]


def act(matrix: Matrix2, point: Point, q: int) -> Point:
    a, b, c, d = matrix
    x, y, z = point
    return normalize(
        (
            a * a * x + 2 * a * b * y + b * b * z,
            a * c * x + (a * d + b * c) * y + b * d * z,
            c * c * x + 2 * c * d * y + d * d * z,
        ),
        q,
    )


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def encoded_certificate(value: object) -> bytes:
    return gzip.compress(canonical_bytes(value), compresslevel=9, mtime=0)


def read_certificate() -> dict[str, object]:
    return json.loads(gzip.decompress(CERTIFICATE.read_bytes()))


def verify_manifest() -> None:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    assert manifest["schema"] == "clebsch-c725-final-finite-boundary-v1"
    checked: set[tuple[str, str]] = set()
    for claim in manifest["claims"]:
        pairs = []
        if claim.get("artifact") is not None:
            pairs.append((claim["artifact"], claim["sha256"]))
        if claim.get("independent_artifact") is not None:
            pairs.append((claim["independent_artifact"], claim["independent_sha256"]))
        pairs.extend((item["path"], item["sha256"]) for item in claim.get("legacy_inputs", []))
        for relative, expected in pairs:
            key = (relative, expected)
            if key in checked:
                continue
            checked.add(key)
            path = PAPER_ROOT / relative
            assert path.is_file()
            assert hashlib.sha256(path.read_bytes()).hexdigest() == expected


class Geometry:
    def __init__(self, q: int) -> None:
        self.q = q
        points = projective_points(q)
        conic = {point for point in points if (point[0] * point[2] - point[1] ** 2) % q == 0}
        self.off = [point for point in points if point not in conic]
        self.index = {point: index for index, point in enumerate(self.off)}
        assert len(points) == q * q + q + 1
        assert len(conic) == q + 1
        assert len(self.off) == q * q

        self.matrices = list(pgl2(q))
        assert len(self.matrices) == q * (q - 1) * (q + 1)
        self.permutations = [
            tuple(self.index[act(matrix, point, q)] for point in self.off)
            for matrix in self.matrices
        ]

        self.neighbors = [0] * len(self.off)
        self.edges: list[tuple[int, int]] = []
        for left in range(len(self.off)):
            for right in range(left + 1, len(self.off)):
                if passant(self.off[left], self.off[right], q):
                    self.edges.append((left, right))
                    self.neighbors[left] |= 1 << right
                    self.neighbors[right] |= 1 << left
        self.canonical_cache: dict[Arc, Arc] = {}

    def image(self, arc: Arc, permutation: tuple[int, ...]) -> Arc:
        return tuple(sorted(permutation[vertex] for vertex in arc))

    def canonical(self, arc: Iterable[int]) -> Arc:
        key = tuple(sorted(arc))
        if key not in self.canonical_cache:
            self.canonical_cache[key] = min(
                self.image(key, permutation) for permutation in self.permutations
            )
        return self.canonical_cache[key]

    def canonical_under(self, arc: Iterable[int], group: Iterable[tuple[int, ...]]) -> Arc:
        key = tuple(sorted(arc))
        return min(self.image(key, permutation) for permutation in group)

    def orbit(self, arc: Arc) -> set[Arc]:
        return {self.image(arc, permutation) for permutation in self.permutations}

    def stabilizer(self, arc: Arc) -> list[tuple[int, ...]]:
        return [
            permutation
            for permutation in self.permutations
            if self.image(arc, permutation) == arc
        ]

    def collinear(self, left: int, middle: int, right: int) -> bool:
        return dot(cross(self.off[left], self.off[middle], self.q), self.off[right], self.q) == 0

    def valid_extension(self, arc: Arc, vertex: int) -> bool:
        if vertex in arc:
            return False
        if any(not (self.neighbors[selected] >> vertex) & 1 for selected in arc):
            return False
        return not any(
            self.collinear(left, right, vertex) for left, right in combinations(arc, 2)
        )

    def extensions(self, arc: Arc) -> list[int]:
        return [vertex for vertex in range(len(self.off)) if self.valid_extension(arc, vertex)]

    def edge_orbits(self) -> list[set[Arc]]:
        remaining = set(self.edges)
        result = []
        while remaining:
            root = min(remaining)
            orbit = self.orbit(root)
            assert orbit <= remaining
            remaining -= orbit
            result.append(orbit)
        return result

    def blocker_codes(self, arc: Arc) -> bytes:
        pair_list = list(combinations(range(len(arc)), 2))
        codes = bytearray()
        for vertex in range(len(self.off)):
            if vertex in arc:
                codes.append(255)
                continue
            nonpassant = next(
                (
                    position
                    for position, selected in enumerate(arc)
                    if not (self.neighbors[selected] >> vertex) & 1
                ),
                None,
            )
            if nonpassant is not None:
                codes.append(nonpassant)
                continue
            collinear_pair = next(
                (
                    pair_index
                    for pair_index, (left, right) in enumerate(pair_list)
                    if self.collinear(arc[left], arc[right], vertex)
                ),
                None,
            )
            if collinear_pair is None:
                raise AssertionError((self.q, arc, vertex, "unblocked extension"))
            codes.append(16 + collinear_pair)
        return bytes(codes)


def point_list(geometry: Geometry, arc: Arc) -> list[list[int]]:
    return [list(geometry.off[vertex]) for vertex in arc]


def arc_from_points(geometry: Geometry, value: object) -> Arc:
    assert isinstance(value, list)
    return tuple(sorted(geometry.index[tuple(point)] for point in value))  # type: ignore[arg-type]


def build_field(q: int) -> dict[str, object]:
    geometry = Geometry(q)
    group_order = len(geometry.permutations)
    edge_orbits = geometry.edge_orbits()
    root_records = []
    for root_index, orbit in enumerate(edge_orbits):
        root = min(orbit)
        root_stabilizer = geometry.stabilizer(root)
        assert len(root_stabilizer) * len(orbit) == group_order
        frontier: set[Arc] = {root}
        nodes: dict[Arc, dict[str, object]] = {}
        for size in range(2, 7):
            current = sorted(arc for arc in frontier if len(arc) == size)
            next_frontier: set[Arc] = set()
            for arc in current:
                local_orbit = {
                    geometry.image(arc, permutation) for permutation in root_stabilizer
                }
                node_stabilizer = [
                    permutation
                    for permutation in root_stabilizer
                    if geometry.image(arc, permutation) == arc
                ]
                assert len(local_orbit) * len(node_stabilizer) == len(root_stabilizer)
                extensions = set(geometry.extensions(arc))
                extension_records = []
                while extensions:
                    representative = min(extensions)
                    extension_orbit = {
                        permutation[representative] for permutation in node_stabilizer
                    }
                    assert extension_orbit <= extensions
                    extensions -= extension_orbit
                    target = geometry.canonical_under(
                        (*arc, representative), root_stabilizer
                    )
                    next_frontier.add(target)
                    extension_records.append(
                        {
                            "representative": list(geometry.off[representative]),
                            "orbit_size": len(extension_orbit),
                            "target_key": ",".join(map(str, target)),
                        }
                    )
                record: dict[str, object] = {
                    "representative": point_list(geometry, arc),
                    "root_stabilizer_orbit_size": len(local_orbit),
                    "node_stabilizer_order": len(node_stabilizer),
                    "extension_orbits": extension_records,
                }
                if not extension_records:
                    blockers = geometry.blocker_codes(arc)
                    record["terminal_obstruction_codes_hex"] = blockers.hex()
                    record["terminal_obstruction_sha256"] = hashlib.sha256(blockers).hexdigest()
                nodes[arc] = record
            frontier |= next_frontier
        assert all(len(arc) <= 6 for arc in frontier)
        assert all(not geometry.extensions(arc) for arc in nodes if len(arc) == 6)

        ordered_arcs = sorted(nodes, key=lambda arc: (len(arc), arc))
        node_id = {
            arc: f"q{q}-r{root_index:02d}-k{len(arc)}-n{index:04d}"
            for index, arc in enumerate(ordered_arcs)
        }
        node_records = []
        for arc in ordered_arcs:
            record = dict(nodes[arc])
            transitions = []
            for transition in record.pop("extension_orbits"):
                transition = dict(transition)
                target_key = tuple(map(int, transition.pop("target_key").split(",")))
                transition["target"] = node_id[target_key]
                transitions.append(transition)
            record["id"] = node_id[arc]
            record["size"] = len(arc)
            record["extension_orbits"] = transitions
            node_records.append(record)

        root_levels = []
        for size in range(2, 7):
            level = [arc for arc in ordered_arcs if len(arc) == size]
            local_mass = sum(nodes[arc]["root_stabilizer_orbit_size"] for arc in level)
            extension_incidence = sum(
                nodes[arc]["root_stabilizer_orbit_size"]
                * sum(item["orbit_size"] for item in nodes[arc]["extension_orbits"])
                for arc in level
            )
            if size < 6:
                next_mass = sum(
                    nodes[arc]["root_stabilizer_orbit_size"]
                    for arc in ordered_arcs
                    if len(arc) == size + 1
                )
                assert extension_incidence == (size - 1) * next_mass
            else:
                assert extension_incidence == 0
            root_levels.append(
                {
                    "size": size,
                    "orbit_count": len(level),
                    "fixed_root_arc_mass": local_mass,
                    "fixed_root_extension_incidence": extension_incidence,
                }
            )
        root_records.append(
            {
                "representative": point_list(geometry, root),
                "edge_orbit_size": len(orbit),
                "root_stabilizer_order": len(root_stabilizer),
                "levels": root_levels,
                "nodes": node_records,
            }
        )

    level_records = []
    for size in range(2, 7):
        rooted_mass = sum(
            root["edge_orbit_size"]
            * next(level["fixed_root_arc_mass"] for level in root["levels"] if level["size"] == size)
            for root in root_records
        )
        pair_count = size * (size - 1) // 2
        assert rooted_mass % pair_count == 0
        level_records.append(
            {
                "size": size,
                "rooted_incidence_mass": rooted_mass,
                "labelled_arc_mass": rooted_mass // pair_count,
            }
        )

    terminal_representatives = [
        arc_from_points(geometry, node["representative"])
        for root in root_records
        for node in root["nodes"]
        if node["size"] == 6
    ]
    projective_terminals = sorted({geometry.canonical(arc) for arc in terminal_representatives})
    assert projective_terminals
    edge_type = {
        edge: orbit_index
        for orbit_index, orbit in enumerate(edge_orbits)
        for edge in orbit
    }
    terminal_records = []
    for arc in projective_terminals:
        orbit = geometry.orbit(arc)
        pair_signature = [0] * len(edge_orbits)
        for left, right in combinations(arc, 2):
            pair_signature[edge_type[(left, right) if left < right else (right, left)]] += 1
        point_types = [0, 0]
        for vertex in arc:
            x, y, z = geometry.off[vertex]
            value = (x * z - y * y) % q
            point_types[0 if pow(value, (q - 1) // 2, q) == 1 else 1] += 1
        terminal_records.append(
            {
                "representative": point_list(geometry, arc),
                "orbit_size": len(orbit),
                "stabilizer_order": group_order // len(orbit),
                "point_type_counts_square_nonsquare": point_types,
                "passant_edge_orbit_signature": pair_signature,
            }
        )
    assert sum(record["orbit_size"] for record in terminal_records) == level_records[-1]["labelled_arc_mass"]
    return {
        "q": q,
        "off_conic_points": len(geometry.off),
        "pgl2_order": group_order,
        "passant_edges": len(geometry.edges),
        "root_dags": root_records,
        "levels": level_records,
        "maximum_passant_arc_size": 6,
        "projective_six_arc_orbits": len(projective_terminals),
        "projective_six_arc_records": terminal_records,
        "six_point_witness": point_list(geometry, projective_terminals[0]),
        "terminal_obstruction_legend": {
            "0..5": "nonpassant join to the indexed selected point",
            "16..30": "collinear with the indexed pair in lexicographic pair order",
            "255": "the point is selected",
        },
    }


def build() -> dict[str, object]:
    return {"schema": SCHEMA, "fields": [build_field(q) for q in FIELDS]}


def verify_field(field: dict[str, object]) -> None:
    q = field["q"]
    assert q in FIELDS
    geometry = Geometry(q)
    group_order = len(geometry.permutations)
    assert field["off_conic_points"] == q * q
    assert field["pgl2_order"] == group_order
    assert field["passant_edges"] == len(geometry.edges)

    covered_edges: set[Arc] = set()
    rooted_masses = defaultdict(int)
    terminal_representatives: list[Arc] = []
    for root_record in field["root_dags"]:
        root = arc_from_points(geometry, root_record["representative"])
        edge_orbit = geometry.orbit(root)
        root_stabilizer = geometry.stabilizer(root)
        assert root == min(edge_orbit)
        assert len(edge_orbit) == root_record["edge_orbit_size"]
        assert len(root_stabilizer) == root_record["root_stabilizer_order"]
        assert len(edge_orbit) * len(root_stabilizer) == group_order
        assert not (covered_edges & edge_orbit)
        covered_edges |= edge_orbit

        nodes_by_id = {record["id"]: record for record in root_record["nodes"]}
        assert len(nodes_by_id) == len(root_record["nodes"])
        represented: dict[Arc, dict[str, object]] = {}
        for record in root_record["nodes"]:
            arc = arc_from_points(geometry, record["representative"])
            assert len(arc) == record["size"]
            assert geometry.canonical_under(arc, root_stabilizer) == arc
            assert set(root) <= set(arc)
            assert arc not in represented
            represented[arc] = record
            local_orbit = {
                geometry.image(arc, permutation) for permutation in root_stabilizer
            }
            node_stabilizer = [
                permutation
                for permutation in root_stabilizer
                if geometry.image(arc, permutation) == arc
            ]
            assert len(local_orbit) == record["root_stabilizer_orbit_size"]
            assert len(node_stabilizer) == record["node_stabilizer_order"]
            assert len(local_orbit) * len(node_stabilizer) == len(root_stabilizer)

            remaining = set(geometry.extensions(arc))
            for transition in record["extension_orbits"]:
                representative = geometry.index[tuple(transition["representative"])]
                extension_orbit = {
                    permutation[representative] for permutation in node_stabilizer
                }
                assert extension_orbit <= remaining
                assert len(extension_orbit) == transition["orbit_size"]
                remaining -= extension_orbit
                target = geometry.canonical_under((*arc, representative), root_stabilizer)
                target_record = nodes_by_id[transition["target"]]
                assert arc_from_points(geometry, target_record["representative"]) == target
            assert not remaining

            if record["extension_orbits"]:
                assert "terminal_obstruction_codes_hex" not in record
            else:
                blockers = bytes.fromhex(record["terminal_obstruction_codes_hex"])
                assert blockers == geometry.blocker_codes(arc)
                assert hashlib.sha256(blockers).hexdigest() == record["terminal_obstruction_sha256"]
            if len(arc) == 6:
                terminal_representatives.append(arc)

        assert {root} == {arc for arc in represented if len(arc) == 2}
        for size in range(2, 6):
            targets = {
                arc_from_points(geometry, nodes_by_id[transition["target"]]["representative"])
                for arc, record in represented.items()
                if len(arc) == size
                for transition in record["extension_orbits"]
            }
            assert targets == {arc for arc in represented if len(arc) == size + 1}

        root_levels = {record["size"]: record for record in root_record["levels"]}
        for size in range(2, 7):
            arcs = [arc for arc in represented if len(arc) == size]
            record = root_levels[size]
            assert record["orbit_count"] == len(arcs)
            local_mass = sum(represented[arc]["root_stabilizer_orbit_size"] for arc in arcs)
            assert record["fixed_root_arc_mass"] == local_mass
            incidence = sum(
                represented[arc]["root_stabilizer_orbit_size"]
                * sum(item["orbit_size"] for item in represented[arc]["extension_orbits"])
                for arc in arcs
            )
            assert record["fixed_root_extension_incidence"] == incidence
            if size < 6:
                assert incidence == (size - 1) * root_levels[size + 1]["fixed_root_arc_mass"]
            else:
                assert incidence == 0
            rooted_masses[size] += len(edge_orbit) * local_mass
    assert covered_edges == set(geometry.edges)

    levels = {record["size"]: record for record in field["levels"]}
    for size in range(2, 7):
        assert levels[size]["rooted_incidence_mass"] == rooted_masses[size]
        pair_count = size * (size - 1) // 2
        assert rooted_masses[size] == pair_count * levels[size]["labelled_arc_mass"]

    projective_terminals = {geometry.canonical(arc) for arc in terminal_representatives}
    assert len(projective_terminals) == field["projective_six_arc_orbits"]
    recorded_terminals = set()
    terminal_mass = 0
    edge_orbits = geometry.edge_orbits()
    edge_type = {
        edge: orbit_index
        for orbit_index, orbit in enumerate(edge_orbits)
        for edge in orbit
    }
    pair_fingerprints = set()
    for record in field["projective_six_arc_records"]:
        arc = arc_from_points(geometry, record["representative"])
        orbit = geometry.orbit(arc)
        assert arc == min(orbit)
        assert len(orbit) == record["orbit_size"]
        assert group_order == len(orbit) * record["stabilizer_order"]
        recorded_terminals.add(arc)
        terminal_mass += len(orbit)
        pair_signature = [0] * len(edge_orbits)
        for left, right in combinations(arc, 2):
            pair_signature[edge_type[(left, right) if left < right else (right, left)]] += 1
        assert pair_signature == record["passant_edge_orbit_signature"]
        pair_fingerprints.add(tuple(pair_signature))
        point_types = [0, 0]
        for vertex in arc:
            x, y, z = geometry.off[vertex]
            value = (x * z - y * y) % q
            point_types[0 if pow(value, (q - 1) // 2, q) == 1 else 1] += 1
        assert point_types == record["point_type_counts_square_nonsquare"]
    assert recorded_terminals == projective_terminals
    assert terminal_mass == levels[6]["labelled_arc_mass"]
    expected = EXPECTED_SUMMARY[q]
    assert len(field["root_dags"]) == expected["edge_orbits"]
    assert field["passant_edges"] == expected["passant_edges"]
    assert field["projective_six_arc_orbits"] == expected["six_orbits"]
    assert levels[6]["labelled_arc_mass"] == expected["six_mass"]
    assert len(pair_fingerprints) == expected["pair_fingerprints"]

    witness = arc_from_points(geometry, field["six_point_witness"])
    assert len(witness) == field["maximum_passant_arc_size"] == 6
    assert geometry.canonical(witness) in projective_terminals
    assert not geometry.extensions(witness)


def verify(certificate: dict[str, object]) -> None:
    assert certificate["schema"] == SCHEMA
    fields = certificate["fields"]
    assert [field["q"] for field in fields] == list(FIELDS)
    for field in fields:
        verify_field(field)


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()

    if args.check or args.write:
        certificate = build()
        verify(certificate)
        encoded = encoded_certificate(certificate)
        if args.write:
            CERTIFICATE.write_bytes(encoded)
            print(f"wrote={CERTIFICATE.name} bytes={len(encoded)}")
        else:
            assert encoded == CERTIFICATE.read_bytes()
            verify_manifest()
            print("c725_terminal_orbit_dag_regeneration=PASS")
        return

    certificate = read_certificate()
    verify(certificate)
    verify_manifest()
    summary = [
        {
            "q": field["q"],
            "root_dag_nodes": sum(len(root["nodes"]) for root in field["root_dags"]),
            "projective_six_arc_orbits": field["projective_six_arc_orbits"],
            "labelled_six_arcs": field["levels"][-1]["labelled_arc_mass"],
        }
        for field in certificate["fields"]
    ]
    print(json.dumps({"status": "ok", "fields": summary}, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
