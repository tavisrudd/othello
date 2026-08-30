#!/usr/bin/env python3
"""Stream compact frozen feature batches for the experimental campaign layer."""

from __future__ import annotations

import argparse
import glob
import json
from pathlib import Path


SCHEMA = "ergodis-campaign-data-v0"


def write_jsonl(path: Path, header: dict, rows) -> None:
    with path.open("x", encoding="utf-8") as stream:
        stream.write(json.dumps(header, separators=(",", ":")) + "\n")
        for row in rows:
            stream.write(json.dumps(row, separators=(",", ":")) + "\n")


def c80_rows(q11_path: Path, q13_path: Path):
    rows = []
    row_id = 0
    for q, path in ((11, q11_path), (13, q13_path)):
        source = json.loads(path.read_text())
        profiles = source["delta_profiles_support_omega_old_half_next_persistent"]
        for profile, weight in sorted(profiles.items()):
            support, omega, old_rank, half_rank, next_rank, persistent = map(
                int, profile.split("/")
            )
            rows.append(
                {
                    "id": row_id,
                    "weight": weight,
                    "expected": True,
                    "values": [
                        q,
                        support,
                        omega,
                        old_rank,
                        half_rank,
                        next_rank,
                        persistent,
                        int(support == 0),
                    ],
                }
            )
            row_id += 1
    return rows


def c880_rows(pattern: str):
    rows = []
    for row_id, name in enumerate(sorted(glob.glob(pattern))):
        source = json.loads(Path(name).read_text())
        marginal = int(source["marginal_cost"])
        naive = int(source["three_per_new_point"])
        rows.append(
            {
                "id": row_id,
                "weight": 1,
                "expected": naive > marginal,
                "values": [
                    int(source["m"]),
                    int(source["known_points"]),
                    int(source["new_points"]),
                    marginal,
                    naive,
                    naive - marginal,
                    int(source["search_nodes"]),
                ],
            }
        )
    if not rows:
        raise SystemExit(f"no C880 inputs matched {pattern!r}")
    return rows


def c80_bank_rows(path: Path):
    source = json.loads(path.read_text())
    rows = []

    def append(q: int, record: dict, survivor: bool, filtered: int = -1) -> None:
        coordinates = record["raw_bank_coordinates"]
        rows.append(
            {
                "id": len(rows),
                "weight": 1,
                "expected": survivor,
                "values": [
                    q,
                    int(coordinates["omega"]),
                    int(coordinates["tutte_excess"]),
                    int(coordinates["deficiency"]),
                    int(coordinates["legal_moves"]),
                    int(coordinates["strict_edges"]),
                    filtered,
                    int(filtered >= 0),
                ],
            }
        )

    for thread, fibre in zip(
        source["q17_defect_thread"], source["q17_marked_fibre_falsifier"]
    ):
        append(
            17,
            thread,
            True,
            int(thread["recursive_M_omega_filtered_coordinates"]["deficiency"]),
        )
        decoy = fibre["strongest_checked_dominant_nonsurvivor"]
        rows.append(
            {
                "id": len(rows),
                "weight": 1,
                "expected": False,
                "values": [17, int(decoy["omega"]), int(decoy["tutte_excess"]), 0, -1, -1, -1, 0],
            }
        )
    for record in source["q19_marked_control"]:
        append(19, record, bool(record["target_in_copycat_survivor"]))
    return rows


def merge_batches(pattern: str, output: Path) -> None:
    paths = [Path(name) for name in sorted(glob.glob(pattern))]
    if not paths:
        raise SystemExit(f"no campaign batches matched {pattern!r}")
    headers = []
    for path in paths:
        with path.open(encoding="utf-8") as stream:
            headers.append(json.loads(stream.readline()))
    fields = headers[0]["fields"]
    if any(header.get("schema") != SCHEMA or header["fields"] != fields for header in headers):
        raise SystemExit("campaign batches have incompatible schemas or fields")
    header = {
        "schema": SCHEMA,
        "presentation": "merge-" + "-".join(header["presentation"] for header in headers),
        "problem": " + ".join(header["problem"] for header in headers),
        "fields": fields,
        "rows": sum(int(header["rows"]) for header in headers),
    }
    row_id = 0
    with output.open("x", encoding="utf-8") as target:
        target.write(json.dumps(header, separators=(",", ":")) + "\n")
        for path in paths:
            with path.open(encoding="utf-8") as source:
                next(source)
                for line in source:
                    row = json.loads(line)
                    row["id"] = row_id
                    target.write(json.dumps(row, separators=(",", ":")) + "\n")
                    row_id += 1
    if row_id != header["rows"]:
        raise SystemExit("campaign batch row count mismatch")


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="adapter", required=True)
    c80 = subparsers.add_parser("c80")
    c80.add_argument("--q11", type=Path, required=True)
    c80.add_argument("--q13", type=Path, required=True)
    c80.add_argument("--output", type=Path, required=True)
    c880 = subparsers.add_parser("c880")
    c880.add_argument("--inputs", required=True)
    c880.add_argument("--output", type=Path, required=True)
    bank = subparsers.add_parser("c80-bank")
    bank.add_argument("--input", type=Path, required=True)
    bank.add_argument("--output", type=Path, required=True)
    merge = subparsers.add_parser("merge")
    merge.add_argument("--inputs", required=True)
    merge.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    if args.adapter == "merge":
        merge_batches(args.inputs, args.output)
        print(json.dumps({"output": str(args.output), "adapter": "merge"}))
        return

    if args.adapter == "c80":
        fields = [
            "q",
            "support_surplus",
            "omega_drop",
            "old_rank",
            "half_rank",
            "next_rank",
            "persistent",
            "equal_support",
        ]
        rows = c80_rows(args.q11, args.q13)
        problem = "C80 projective reply admission profiles"
        presentation = "c80-q11-q13-support-omega-v0"
        output = args.output
    elif args.adapter == "c880":
        fields = [
            "m",
            "known_points",
            "new_points",
            "marginal_cost",
            "naive_cost",
            "saving",
            "search_nodes",
        ]
        rows = c880_rows(args.inputs)
        problem = "C880 strict marginal improvement classification"
        presentation = "c880-marginal-strict-saving-kj-v0"
        output = args.output
    else:
        fields = [
            "q",
            "omega",
            "raw_tutte_excess",
            "raw_deficiency",
            "legal_moves",
            "strict_edges",
            "filtered_deficiency",
            "recursive_feature_available",
        ]
        rows = c80_bank_rows(args.input)
        problem = "C80 overload/Tutte bank falsifier"
        presentation = "c80-q17-q19-bank-v0"
        output = args.output
    header = {
        "schema": SCHEMA,
        "presentation": presentation,
        "problem": problem,
        "fields": fields,
        "rows": len(rows),
    }
    write_jsonl(output, header, rows)
    print(json.dumps({"output": str(output), "rows": len(rows), "fields": len(fields)}))


if __name__ == "__main__":
    main()
