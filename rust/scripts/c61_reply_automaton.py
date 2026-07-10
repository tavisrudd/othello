#!/usr/bin/env python3
"""C61 finite-state reply quotient over the durable C38/C63 artifacts.

The C63 rows describe one exact P reply for every (P parent, opponent move)
obligation.  The C38 rows describe genuinely forced replies.  We keep those
semantics separate: variation in C63 is selector nondeterminism, while a C38
collision is a real obstruction to the proposed quotient.
"""

from __future__ import annotations

import argparse
import csv
import glob
import json
import re
from collections import Counter, defaultdict
from pathlib import Path


def geom(q: int, cell: str) -> str:
    r, c = map(int, cell.split(","))
    if r and (r * c) % q == 1:
        return "on"
    tangents = int(c == 0) + int(r == 0)
    for pr in range(1, q):
        pc = pow(pr, -1, q)
        tangents += (pr * c + pc * r - 2) % q == 0
    return {0: "int", 2: "ext"}.get(tangents, "anom")


def bucket(value: int, q: int) -> str:
    if value == 0:
        return "0"
    sign = "+" if value > 0 else "-"
    n = abs(value)
    if n <= q:
        return sign + "1q"
    if n <= 2 * q:
        return sign + "2q"
    return sign + "3q+"


def delta_bucket(value: int) -> str:
    if value <= -3:
        return "d<=-3"
    if value >= 3:
        return "d>=3"
    return f"d{value}"


def strict_cells(q: int, cells: str) -> str:
    out = []
    for cell in cells.split(";"):
        if not cell:
            continue
        r, c = map(int, cell.split(","))
        out.append(f"C{r}" if r and (r * c) % q == 1 else f"O{r}:{c}")
    return ",".join(sorted(out))


PARENT_FEATURES = (
    "conic_xor_zero",
    "defect_components",
    "defect_paths",
    "defect_odd_components",
    "defect_max_path",
    "defect_path_sum_sq",
    "interface_intruders",
    "interface_endpoints",
    "interface_isolates",
)


def c63_state(row: dict[str, str], level: int) -> tuple[str, ...]:
    q = int(row["q"])
    base = [f"opp={geom(q, row['opponent'])}"]
    base += [f"{x}={row['parent_' + x]}" for x in PARENT_FEATURES]
    base += [
        f"zone_parity={row['parent_zone_parity']}",
        f"slack={bucket(int(row['parent_reservoir_slack_total']), q)}",
        f"minslack={bucket(int(row['parent_reservoir_slack_min']), q)}",
    ]
    if level >= 1:
        base += [f"ply={row['parent_ply']}", f"live={row['parent_live_on']}"]
    if level >= 2:
        base += [f"t4={row['t4']}"]
    if level >= 3:
        # Strict C36-style normalized opponent state (parent plus the move).
        base += [f"cells={strict_cells(q, row['parent_cells'] + ';' + row['opponent'])}"]
    return tuple(base)


def c63_action(row: dict[str, str]) -> tuple[str, ...]:
    q = int(row["q"])
    out = [f"geom={geom(q, row['reply'])}"]
    for x in (
        "conic_xor_zero",
        "defect_components",
        "defect_paths",
        "defect_odd_components",
        "interface_intruders",
        "interface_endpoints",
        "interface_isolates",
    ):
        out.append(delta_bucket(int(row["child_" + x]) - int(row["parent_" + x])))
    parent_psi = (
        int(row["parent_reservoir_slack_total"])
        + 6 * int(row["parent_defect_components"])
        - 4 * int(row["parent_interface_intruders"])
        - 2 * int(row["parent_conic_xor_zero"])
    )
    child_psi = (
        int(row["child_reservoir_slack_total"])
        + 6 * int(row["child_defect_components"])
        - 4 * int(row["child_interface_intruders"])
        - 2 * int(row["child_conic_xor_zero"])
    )
    out += [
        f"live={delta_bucket(int(row['child_live_on']) - int(row['parent_live_on']))}",
        f"zone={bucket(int(row['child_zone_v']) - int(row['parent_zone_v']), q)}",
        f"psi={'down' if child_psi < parent_psi else 'nondown'}",
    ]
    return tuple(out)


def parse_forced(path: Path):
    with path.open() as f:
        next(f, None)
        for line in f:
            if not line.startswith("FORCED "):
                continue
            fields = {}
            for item in line.split():
                if "=" in item:
                    k, v = item.split("=", 1)
                    fields[k] = v
            yield fields


def c38_state(r: dict[str, str], level: int) -> tuple[str, ...]:
    q = int(r["q"])
    base = (
        f"xor={int(r['conic_nk_xor']) == 0}",
        f"comp={r['conic_comp']}",
        f"paths={r['conic_path']}",
        f"odd={r['conic_odd']}",
        f"max={r['conic_max']}",
        f"off={r['conic_off']}",
        f"iso={r['conic_iso']}",
        f"zpar={int(r['zone_v']) % 2}",
        f"zrows={bucket(int(r['zone_rows']), q)}",
        f"zcols={bucket(int(r['zone_cols']), q)}",
        f"zmin={bucket(min(int(r['zone_row_min']), int(r['zone_col_min'])), q)}",
    )
    if level == 0:
        return base
    if level == 1:
        return base + (f"ply={r['ply']}", f"live={r['live_on_before']}")
    refined = base + (f"ply={r['ply']}", f"live={r['live_on_before']}", f"t4={r['t4']}")
    if level >= 3:
        refined += (f"cells={strict_cells(q, r['cells'])}",)
    return refined


def c38_action(r: dict[str, str]) -> tuple[str, ...]:
    return (
        f"geom={r['xgeom']}",
        f"live={delta_bucket(int(r['live_on_after']) - int(r['live_on_before']))}",
        f"empty={r['conic_emptying']}",
    )


def summarize(rows, state_fn, action_fn, levels=(0, 1, 2, 3)):
    # One streaming pass: the source corpora have >2M rows and materializing their
    # dictionaries would waste several GB for no benefit.
    by_level = {
        level: defaultdict(lambda: {"actions": Counter(), "qs": Counter(), "examples": []})
        for level in levels
    }
    q_rows = Counter()
    for row in rows:
        q = int(row["q"])
        q_rows[q] += 1
        action = action_fn(row)
        example = {k: row[k] for k in ("q", "t4", "ply", "key", "x", "xgeom") if k in row}
        example.update({k: row[k] for k in ("parent_key", "parent_ply", "opponent", "reply") if k in row})
        for level in levels:
            state = state_fn(row, level)
            cell = by_level[level][state]
            cell["actions"][action] += 1
            cell["qs"][q] += 1
            if len(cell["examples"]) < 5:
                cell["examples"].append(example)
    output = {}
    for level in levels:
        states = by_level[level]
        conflicts = [(s, x) for s, x in states.items() if len(x["actions"]) > 1]
        cross = [(s, x) for s, x in conflicts if len(x["qs"]) > 1]
        cross_states = sum(len(x["qs"]) > 1 for x in states.values())
        output[str(level)] = {
            "rows_by_q": dict(sorted(q_rows.items())),
            "states": len(states),
            "conflicting_states": len(conflicts),
            "cross_q_states": cross_states,
            "cross_q_conflicting_states": len(cross),
            "max_actions": max((len(x["actions"]) for x in states.values()), default=0),
            "first_conflicts": [
                {
                    "state": list(s),
                    "qs": dict(sorted(x["qs"].items())),
                    "actions": [
                        {"action": list(a), "count": n}
                        for a, n in x["actions"].most_common(8)
                    ],
                    "examples": x["examples"],
                }
                for s, x in (cross + [pair for pair in conflicts if pair not in cross])[:12]
            ],
        }
    return output


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--c63", default="s4-dumps/2026-07-10/c63/*.transitions.tsv")
    ap.add_argument("--c38", default="s4-dumps/2026-07-09/c38-forced/*.forced.rows")
    ap.add_argument("--out", type=Path, default=Path("s4-dumps/2026-07-10/c61/quotient.json"))
    args = ap.parse_args()

    c63_paths = sorted(glob.glob(args.c63))
    c38_paths = sorted(glob.glob(args.c38))
    # q17 bucket10/11 are the two extra C31 score-9 roots, not additional
    # full-PGL buckets; including them double-weights overlapping states.
    c38_paths = [
        p for p in c38_paths
        if not re.search(r"q17-bucket(?:10|11)-", Path(p).name)
    ]

    def steering_rows():
        for path in c63_paths:
            with open(path, newline="") as f:
                yield from csv.DictReader(f, delimiter="\t")

    def forced_rows():
        for path in c38_paths:
            yield from parse_forced(Path(path))

    result = {
        "semantics": {
            "c63": "selected exact P replies; conflicts mean selector variation, not impossibility",
            "c38": "unique exact P replies; conflicts are obstructions to this quotient/action table",
        },
        "c63_files": c63_paths,
        "c38_files": c38_paths,
        "steering": summarize(steering_rows(), c63_state, c63_action),
        "forced": summarize(forced_rows(), c38_state, c38_action),
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    for corpus in ("steering", "forced"):
        for level, summary in result[corpus].items():
            print(
                f"C61 corpus={corpus} level={level} rows={summary['rows_by_q']} "
                f"states={summary['states']} conflicts={summary['conflicting_states']} "
                f"cross_q_states={summary['cross_q_states']} "
                f"cross_q_conflicts={summary['cross_q_conflicting_states']} max_actions={summary['max_actions']}"
            )
    print(f"C61-DONE out={args.out}")


if __name__ == "__main__":
    main()
