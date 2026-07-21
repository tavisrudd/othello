#!/usr/bin/env python3
"""C447: reconstruct the q=11 cap knife edge and test the golden-pair claim."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "notes/2026-07-21-c447-cap-knife-edge.json"
INPUTS = {
    "cap_feat": ROOT / "notes/data/codex-feat11-c15.out",
    "c406_gate1": ROOT / "notes/2026-07-20-c406-matching-orbit-scout.json",
    "c406_module": ROOT / "notes/2026-07-20-c406-matching-module.json",
    "c458_freeze": ROOT / "notes/2026-07-21-c458-golden-sheet-frame-freeze.json",
}
Q = 11
INF = "inf"


def inv(x: int) -> int:
    return pow(x % Q, Q - 2, Q)


def normalize_vector(v: tuple[int, ...] | list[int]) -> tuple[int, ...]:
    v = tuple(x % Q for x in v)
    pivot = next(x for x in v if x)
    scale = inv(pivot)
    return tuple(x * scale % Q for x in v)


def normalize_matrix(m: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return normalize_vector(m)  # type: ignore[return-value]


def mat_vec(m: list[list[int]], v: tuple[int, int, int]) -> tuple[int, int, int]:
    return tuple(sum(m[i][j] * v[j] for j in range(3)) % Q for i in range(3))  # type: ignore[return-value]


def mat_mul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [[sum(a[i][k] * b[k][j] for k in range(3)) % Q for j in range(3)] for i in range(3)]


def matrix_inverse(m: list[list[int]]) -> list[list[int]]:
    a = [row[:] + [int(i == j) for j in range(3)] for i, row in enumerate(m)]
    for col in range(3):
        pivot = next(row for row in range(col, 3) if a[row][col] % Q)
        a[col], a[pivot] = a[pivot], a[col]
        scale = inv(a[col][col])
        a[col] = [x * scale % Q for x in a[col]]
        for row in range(3):
            if row != col:
                scale = a[row][col]
                a[row] = [(a[row][j] - scale * a[col][j]) % Q for j in range(6)]
    return [row[3:] for row in a]


def mobius_group() -> list[tuple[int, int, int, int]]:
    group = []
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q:
                        m = (a, b, c, d)
                        if next(x for x in m if x) == 1:
                            group.append(m)
    assert len(group) == Q * (Q * Q - 1)
    return group


def act(m: tuple[int, int, int, int], x: int | str) -> int | str:
    a, b, c, d = m
    if x == INF:
        return INF if c == 0 else a * inv(c) % Q
    den = (c * int(x) + d) % Q
    return INF if den == 0 else (a * int(x) + b) * inv(den) % Q


def compose(g: tuple[int, int, int, int], h: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = g
    e, f, k, ell = h
    return normalize_matrix(((a * e + b * k) % Q, (a * f + b * ell) % Q,
                             (c * e + d * k) % Q, (c * f + d * ell) % Q))


def inverse_mobius(g: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = g
    return normalize_matrix((d, -b, -c, a))


def conjugate(g: tuple[int, int, int, int], h: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return compose(compose(g, h), inverse_mobius(g))


def det_is_square(g: tuple[int, int, int, int]) -> bool:
    a, b, c, d = g
    return pow((a * d - b * c) % Q, (Q - 1) // 2, Q) == 1


def point_key(x: int | str) -> tuple[int, str]:
    return (1 if x == INF else 0, str(x))


def edge(a: int | str, b: int | str) -> tuple[int | str, int | str]:
    return tuple(sorted((a, b), key=point_key))  # type: ignore[return-value]


def matching_image(g: tuple[int, int, int, int], matching: set[tuple[int | str, int | str]]) -> set[tuple[int | str, int | str]]:
    return {edge(act(g, a), act(g, b)) for a, b in matching}


def parse_cap() -> dict[int, dict]:
    classes: dict[int, dict] = {}
    cls_re = re.compile(
        r"CLS q=11 cls=(\d+) S3=\[\(([^)]+)\), \(([^)]+)\), \(([^)]+)\)\] "
        r"escape=(\d+) bad=(\d+) onP=(\d+) onN=(\d+) extP=(\d+) extN=(\d+) intP=(\d+) intN=(\d+)"
    )
    child_re = re.compile(r"X q=11 cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(on|ext|int)")
    for line in INPUTS["cap_feat"].read_text().splitlines():
        match = cls_re.match(line)
        if match:
            cls = int(match.group(1))
            children = classes.get(cls, {}).get("children", [])
            classes[cls] = {
                "S3": [tuple(map(int, match.group(i).split(", "))) for i in (2, 3, 4)],
                "escape": int(match.group(5)),
                "onP": int(match.group(7)),
                "onN": int(match.group(8)),
                "children": children,
            }
            continue
        match = child_re.match(line)
        if match:
            classes.setdefault(int(match.group(1)), {"children": []})["children"].append(
                ((int(match.group(2)), int(match.group(3))), match.group(4), match.group(5))
            )
    assert len(classes) == 8
    return classes


def find_unique_key(obj, key: str):
    hits = []
    if isinstance(obj, dict):
        if key in obj:
            hits.append(obj[key])
        for value in obj.values():
            hits.extend(find_unique_key(value, key))
    elif isinstance(obj, list):
        for value in obj:
            hits.extend(find_unique_key(value, key))
    return hits


def input_metadata() -> dict[str, dict[str, int | str]]:
    result = {}
    for name, path in INPUTS.items():
        data = path.read_bytes()
        result[name] = {"path": str(path.relative_to(ROOT)), "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
    return result


def build() -> dict:
    group = mobius_group()
    cap = parse_cap()
    gate1 = json.loads(INPUTS["c406_gate1"].read_text())
    module = json.loads(INPUTS["c406_module"].read_text())
    freeze = json.loads(INPUTS["c458_freeze"].read_text())

    h3 = next(record for record in gate1["types"] if record["type"] == "H3")
    standard_to_h3_hits = find_unique_key(module, "standard_to_h3_projectivity")
    assert len(standard_to_h3_hits) == 1
    standard_to_h3 = standard_to_h3_hits[0]

    polar = freeze["golden_sheet_frame"]["polar_pair_matching"]
    plus = {edge(a, INF if b == "inf" else b) for a, b in polar["reduction_at_pi_phi_to_8"]["matching"]}
    minus = {edge(a, INF if b == "inf" else b) for a, b in polar["reduction_at_pibar_phi_to_4"]["matching"]}
    label_to_index = {i: i for i in range(Q)} | {INF: Q}
    plus_indices = sorted([sorted([label_to_index[a], label_to_index[b]]) for a, b in plus])
    assert plus_indices == h3["coxeter_invariant_matching"]

    plus_stab = {g for g in group if matching_image(g, plus) == plus}
    minus_stab = {g for g in group if matching_image(g, minus) == minus}
    pair_stab = {
        g for g in group
        if {frozenset(matching_image(g, plus)), frozenset(matching_image(g, minus))}
        == {frozenset(plus), frozenset(minus)}
    }
    assert len(plus_stab) == len(minus_stab) == 60
    assert all(det_is_square(g) for g in plus_stab | minus_stab)
    assert len(pair_stab) == 24

    knife_edges = []
    for cls, record in sorted(cap.items()):
        if (record["onP"], record["onN"]) != (2, 5):
            continue
        on_cells = [cell for cell, _, position in record["children"] if position == "on"]
        conic_affine = record["S3"] + on_cells
        missing_rows = sorted(set(range(Q)) - {r for r, _ in conic_affine})
        missing_cols = sorted(set(range(Q)) - {c for _, c in conic_affine})
        assert len(missing_rows) == len(missing_cols) == 1
        rho, A = missing_rows[0], missing_cols[0]
        products = {((r - rho) * (c - A)) % Q for r, c in conic_affine}
        assert len(products) == 1
        B = products.pop()
        assert B
        frame = {INF, 0, *((r - rho) % Q for r, _ in record["S3"])}
        child_values = {(r - rho) % Q: value for (r, _), value, position in record["children"] if position == "on"}
        candidates = set(child_values)
        assert frame.isdisjoint(candidates) and len(frame) == 5 and len(candidates) == 7
        frame_stab = {g for g in group if {act(g, x) for x in frame} == frame}
        assert len(frame_stab) == 10

        remaining = set(candidates)
        orbits = []
        while remaining:
            seed = min(remaining)
            orbit = {act(g, seed) for g in frame_stab}
            assert orbit <= remaining
            values = {child_values[int(x)] for x in orbit}
            assert len(values) == 1
            orbits.append({"parameters": sorted(orbit), "size": len(orbit), "value": values.pop()})
            remaining -= orbit
        orbits.sort(key=lambda item: (item["size"], item["parameters"]))
        assert [(o["size"], o["value"]) for o in orbits] == [(2, "P"), (5, "N")]
        p_pair = set(orbits[0]["parameters"])

        standard_to_cap = [[0, rho, 1], [B, A, 0], [0, 1, 0]]
        cap_to_standard = matrix_inverse(standard_to_cap)
        cap_to_h3 = mat_mul(standard_to_h3, cap_to_standard)
        for r, c in conic_affine:
            w = (r - rho) % Q
            assert normalize_vector(mat_vec(cap_to_standard, (r, c, 1))) == normalize_vector((1, w, w * w))
        assert normalize_vector(mat_vec(cap_to_standard, (1, 0, 0))) == (0, 0, 1)
        assert normalize_vector(mat_vec(cap_to_standard, (0, 1, 0))) == (1, 0, 0)
        frozen_points = [tuple(point) for point in h3["conic_points"]]
        endpoints = list(range(Q)) + [INF]
        for index, w in enumerate(endpoints):
            standard = (0, 0, 1) if w == INF else (1, int(w), int(w) * int(w) % Q)
            assert normalize_vector(mat_vec(standard_to_h3, standard)) == frozen_points[index]

        natural_edge_plus = edge(*p_pair) in plus
        natural_edge_minus = edge(*p_pair) in minus
        forced_edge_maps = {
            "base": sum(edge(*(act(g, x) for x in p_pair)) in plus for g in group),
            "j_mate": sum(edge(*(act(g, x) for x in p_pair)) in minus for g in group),
        }
        compatible_singleton = {
            "base": sum(
                edge(*(act(g, x) for x in p_pair)) in plus
                and all(conjugate(g, h) in plus_stab for h in frame_stab)
                for g in group
            ),
            "j_mate": sum(
                edge(*(act(g, x) for x in p_pair)) in minus
                and all(conjugate(g, h) in minus_stab for h in frame_stab)
                for g in group
            ),
        }
        compatible_pair = sum(all(conjugate(g, h) in pair_stab for h in frame_stab) for g in group)
        assert forced_edge_maps == {"base": 120, "j_mate": 120}
        assert compatible_singleton == {"base": 0, "j_mate": 0}
        assert compatible_pair == 0

        knife_edges.append({
            "class": cls,
            "S3": [list(cell) for cell in record["S3"]],
            "hyperbola": {"rho": rho, "A": A, "B": B, "equation": f"(r-{rho})(c-{A})={B} mod 11"},
            "frame_parameters": sorted(frame, key=point_key),
            "frame_stabilizer": {
                "order": len(frame_stab),
                "abstract_type": "D10",
                "determinant_square_count": sum(det_is_square(g) for g in frame_stab),
                "determinant_nonsquare_count": sum(not det_is_square(g) for g in frame_stab),
            },
            "child_orbits": orbits,
            "standard_to_cap_projectivity": standard_to_cap,
            "cap_to_standard_projectivity": cap_to_standard,
            "cap_to_frozen_h3_projectivity": cap_to_h3,
            "natural_p_pair_is_edge_of_base_singleton": natural_edge_plus,
            "natural_p_pair_is_edge_of_j_mate_singleton": natural_edge_minus,
            "unframed_projectivities_forcing_p_pair_to_singleton_edge": forced_edge_maps,
            "symmetry_compatible_projectivities_to_singleton": compatible_singleton,
            "symmetry_compatible_projectivities_to_unordered_singleton_pair": compatible_pair,
        })

    assert [record["class"] for record in knife_edges] == [4, 7]
    by_class = {record["class"]: record for record in knife_edges}
    frame4 = set(by_class[4]["frame_parameters"])
    frame7 = set(by_class[7]["frame_parameters"])
    p4 = set(by_class[4]["child_orbits"][0]["parameters"])
    p7 = set(by_class[7]["child_orbits"][0]["parameters"])
    n4 = set(by_class[4]["child_orbits"][1]["parameters"])
    n7 = set(by_class[7]["child_orbits"][1]["parameters"])
    class_equivalences = [
        g for g in group
        if {act(g, x) for x in frame4} == frame7
        and {act(g, x) for x in p4} == p7
        and {act(g, x) for x in n4} == n7
    ]
    assert len(class_equivalences) == 10
    assert class_equivalences[0] == (0, 1, 4, 10)
    return {
        "schema": "c447-cap-knife-edge-v1",
        "task": "C447",
        "inputs": input_metadata(),
        "frozen_c406": {
            "standard_conic": "XZ-Y^2=0",
            "standard_to_h3_projectivity": standard_to_h3,
            "base_singleton_matching": sorted([list(pair) for pair in plus], key=str),
            "j_mate_singleton_matching": sorted([list(pair) for pair in minus], key=str),
            "base_and_j_mate_stabilizer_orders": [len(plus_stab), len(minus_stab)],
            "base_and_j_mate_stabilizers_lie_in_PSL2": True,
            "unordered_singleton_pair_stabilizer_order": len(pair_stab),
            "unordered_singleton_pair_stabilizer_type": "S4",
            "unordered_singleton_pair_stabilizer_det_square_nonsquare": [
                sum(det_is_square(g) for g in pair_stab), sum(not det_is_square(g) for g in pair_stab)
            ],
        },
        "knife_edge_classes": knife_edges,
        "cap_knife_edge_class_equivalence": {
            "projectivity_count": len(class_equivalences),
            "example_mobius_matrix": list(class_equivalences[0]),
            "example_formula": "w -> 1/(4w+10)",
            "maps_class_4_frame_p_n_to_class_7_frame_p_n": True,
            "determinant_square_nonsquare_counts": [
                sum(det_is_square(g) for g in class_equivalences),
                sum(not det_is_square(g) for g in class_equivalences),
            ],
            "consequence": "The two cap knife-edge conic configurations form one PGL2 orbit and cannot canonically label the two golden sheets.",
        },
        "acceptance": {
            "seven_on_conic_children_each": True,
            "d10_stabilizer_each": True,
            "p2_n5_orbits_each": True,
            "explicit_cap_to_frozen_c406_projectivity_each": True,
            "golden_singleton_identification": "REFUTED_AS_AN_EQUIVARIANT_IDENTIFICATION",
        },
        "verdict": {
            "register_row_35": "SHARP_NEGATIVE",
            "reason": (
                "The cap P orbit is a two-point conic orbit, whereas the golden singleton pair consists of two "
                "perfect matchings. Under the frozen parameter projectivity neither P pair is an edge of either "
                "singleton. More invariantly, each cap D10 contains five determinant-nonsquare elements, while "
                "each singleton A5 lies in PSL2, and the unordered singleton-pair stabilizer is S4 of order 24. "
                "Hence no projectivity makes the proposed identification equivariant. An unframed PGL2 map can "
                "force either P pair onto an arbitrary singleton edge (120 maps for each singleton), showing why "
                "bare incidence is coordinate choice rather than a correspondence."
            ),
            "x3_consequence": "Only the abstract orbit-valued-selector statement survives; row 35 supplies no cap/golden identification.",
        },
    }


def canonical_bytes(payload: dict) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.write:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")
    else:
        assert OUT.read_bytes() == data, "tracked JSON differs from canonical regeneration"
        print("C447 primary check: PASS")


if __name__ == "__main__":
    main()
