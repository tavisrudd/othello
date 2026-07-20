#!/usr/bin/env python3
"""Generate/check the C392 q=11 two-sheet compatibility certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
C295_PATH = HERE / "2026-07-17-c295-intrinsic-continuation-reconstruction.py"
DEFAULT_JSON = HERE / "2026-07-19-c392-clebsch-two-sheet-service.json"


def load_c295():
    spec = importlib.util.spec_from_file_location("c295_checker", C295_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load C295 checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def serial_decomposition(decomposition):
    return [[[u, v] for u, v in block] for block in decomposition]


def sheet_record(module, decomposition, conic):
    blocks = []
    for block in decomposition:
        used = {vertex for edge in block for vertex in edge}
        point = module.concurrency_point(block, conic)
        blocks.append(
            {
                "pairs": [[u, v] for u, v in block],
                "ports": [vertex for vertex in range(12) if vertex not in used],
                "concurrency_point": list(module.normalize(point)) if point is not None else None,
            }
        )
    return {
        "blocks": blocks,
        "concurrent_block_count": sum(
            block["concurrency_point"] is not None for block in blocks
        ),
    }


def result() -> dict[str, object]:
    module = load_c295()
    conic, geometric_blocks, edges = module.geometry()
    distances = module.graph_distances(edges)
    candidates = tuple(
        block
        for block in module.matching_blocks(edges)
        if distances[block[1][0], block[1][1]] == 3
    )
    decompositions = module.decompositions(edges, candidates)
    automorphisms = module.graph_automorphisms(edges)
    orbits = module.decomposition_orbits(decompositions, automorphisms)
    geometric = tuple(sorted(geometric_blocks))
    orbit = next(orbit for orbit in orbits if geometric in orbit)
    assert len(orbit) == 2
    mate = next(decomposition for decomposition in orbit if decomposition != geometric)

    geometric_record = sheet_record(module, geometric, conic)
    mate_record = sheet_record(module, mate, conic)
    assert geometric_record["concurrent_block_count"] == 6
    assert mate_record["concurrent_block_count"] == 0

    return {
        "schema": "c392-clebsch-two-sheet-service-v1",
        "field_order": 11,
        "c295_checker_sha256": sha256(C295_PATH),
        "admissible_decomposition_count": len(decompositions),
        "graph_automorphism_order": len(automorphisms),
        "decomposition_orbit_count": len(orbits),
        "geometric_orbit_size": len(orbit),
        "fixed_conic_points": [list(point) for point in conic],
        "geometric_sheet": geometric_record,
        "intrinsic_mate_sheet": mate_record,
        "geometric_sheet_c357": {
            "stored_points": 12,
            "secant_pairs_per_target": 5,
            "tangent_ports_per_target": 2,
            "disjoint_pir_availability": 5,
            "disjoint_majority_radius": 2,
            "maximal_service": False,
            "maximal_pir": False,
        },
        "mate_sheet_c357": None,
        "verdict": "forgotten-sheet dependence: mate blocks are not projection pencils",
        "orbit_decompositions_sha256": hashlib.sha256(
            json.dumps(
                sorted(
                    [serial_decomposition(geometric), serial_decomposition(mate)]
                ),
                separators=(",", ":"),
            ).encode()
        ).hexdigest(),
    }


def encode(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("path", nargs="?", type=Path, default=DEFAULT_JSON)
    args = parser.parse_args()
    encoded = encode(result())
    if args.write:
        args.path.write_bytes(encoded)
        print(f"wrote {args.path} ({len(encoded)} bytes)")
    else:
        tracked = args.path.read_bytes()
        if tracked != encoded:
            raise SystemExit(f"certificate mismatch: {args.path}")
        print(f"checked {args.path} ({len(encoded)} bytes)")


if __name__ == "__main__":
    main()
