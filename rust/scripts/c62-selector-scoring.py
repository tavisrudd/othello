#!/usr/bin/env python3
"""Run and aggregate the exact C62 selector library over existing Grundy dumps."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from collections import Counter, defaultdict
from pathlib import Path


ROOTS = [
    (13, "1,2,3,7", "s4-dumps/2026-07-10/c63/q13-bucket00-1237.grundy.raw"),
    (13, "1,2,3,4", "s4-dumps/2026-07-09/c35/q13-root-1234.grundy.raw"),
    (13, "1,2,3,5", "s4-dumps/2026-07-10/c63/q13-bucket02-1235.grundy.raw"),
    (13, "1,2,3,8", "s4-dumps/2026-07-10/c63/q13-bucket03-1238.grundy.raw"),
    (13, "1,2,6,9", "s4-dumps/2026-07-10/c63/q13-bucket04-1269.grundy.raw"),
    (17, "1,2,3,9", "s4-dumps/2026-07-09/c38-forced/q17-bucket00-1239.grundy.raw"),
    (17, "1,2,3,5", "s4-dumps/2026-07-09/c38-forced/q17-bucket01-1235.grundy.raw"),
    (17, "1,2,3,6", "s4-dumps/2026-07-09/c38-forced/q17-bucket02-1236.grundy.raw"),
    (17, "1,2,5,6", "s4-dumps/2026-07-09/c38-forced/q17-bucket03-1256.grundy.raw"),
    (17, "1,2,6,8", "s4-dumps/2026-07-09/c38-forced/q17-bucket04-1268.grundy.raw"),
    (17, "1,2,3,8", "s4-dumps/2026-07-09/c38-forced/q17-bucket05-1238.grundy.raw"),
    (17, "1,2,3,4", "s4-dumps/2026-07-09/c38-forced/q17-bucket06-1234.grundy.raw"),
    (17, "1,3,7,8", "s4-dumps/2026-07-09/c38-forced/q17-bucket07-1378.grundy.raw"),
    (17, "1,2,5,14", "s4-dumps/2026-07-09/c38-forced/q17-bucket08-12514.grundy.raw"),
    (17, "1,2,3,10", "s4-dumps/2026-07-09/c38-forced/q17-bucket09-12310.grundy.raw"),
    (19, "1,2,3,4", "s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw"),
]

FIELDS = [
    "obligations",
    "defined",
    "p_hit",
    "psi_hit",
    "zero_hit",
    "all_p",
    "all_psi",
    "tied",
    "selected_sum_milli",
]


def q23_witness_profile(binary: str) -> dict[str, object]:
    paths = sorted(Path("s4-dumps/2026-07-09/q23-zone2-all").glob("*.txt"))
    counts = Counter()
    rank_hist = Counter()
    live_hist = Counter()
    component_hist = Counter()
    psi_hist = Counter()
    delta_psi_hist = Counter()
    examples = []
    for path in paths:
        t4 = None
        for line in path.read_text().splitlines():
            if line.startswith("S4XORMINE "):
                match = re.search(r"t4=\[([^]]+)\]", line)
                t4 = match.group(1).replace(" ", "") if match else "-"
                probe = subprocess.run(
                    [binary, "s4potentialprobe", "23", t4],
                    check=True,
                    text=True,
                    capture_output=True,
                ).stdout
                parent_psi = int(re.search(r"c63_candidate=(-?\d+)", probe).group(1))
            if not line.startswith("XORTRY ") or " value=P " not in line:
                continue
            v = key_values(line)
            xr, xc = map(int, v["x"].split(","))
            yr, yc = map(int, v["y"].split(","))
            rectangle = ((xr - yr) * (xc - yc)) % 23
            chi = 0 if rectangle == 0 else (1 if pow(rectangle, 11, 23) == 1 else -1)
            polar = (xc * yr + xr * yc - 2) % 23 == 0 and v["ygeom"] == "int"
            # XORRESULT.tried is the stable selector rank; recover it by counting trials per x.
            counts[("geom", v["ygeom"])] += 1
            counts[("chi", chi)] += 1
            counts[("polar_internal", int(polar))] += 1
            live = int(v["live_on"])
            comp = int(v["conic_comp"])
            zone = int(v["zone_v"])
            psi = (zone - 17) + 6 * comp - 4 * int(v["conic_off"]) - 2
            live_hist[live] += 1
            component_hist[comp] += 1
            psi_hist[psi] += 1
            delta_psi_hist[psi - parent_psi] += 1
            if len(examples) < 12:
                examples.append({"source": path.name, "t4": t4, "x": v["x"], "y": v["y"], "geom": v["ygeom"], "live": live, "components": comp, "chi": chi, "polar_internal": polar, "psi": psi})
        # Parse the actual try ranks independently so multiple failed XORTRY rows are counted.
        for line in path.read_text().splitlines():
            if line.startswith("XORRESULT ") and " status=hit " in line:
                rank_hist[int(key_values(line)["tried"])] += 1
    total = sum(rank_hist.values())
    return {
        "files": len(paths),
        "selected_witnesses": total,
        "try_rank_hist": dict(sorted(rank_hist.items())),
        "rank1_fraction": rank_hist[1] / total,
        "geometry": {str(k[1]): value for k, value in counts.items() if k[0] == "geom"},
        "rectangle_character": {str(k[1]): value for k, value in counts.items() if k[0] == "chi"},
        "polar_internal": {str(k[1]): value for k, value in counts.items() if k[0] == "polar_internal"},
        "live_on": dict(sorted(live_hist.items())),
        "defect_components": dict(sorted(component_hist.items())),
        "child_psi_range": [min(psi_hist), max(psi_hist)],
        "delta_psi": {
            "decreasing": sum(n for delta, n in delta_psi_hist.items() if delta < 0),
            "flat": delta_psi_hist[0],
            "increasing": sum(n for delta, n in delta_psi_hist.items() if delta > 0),
            "range": [min(delta_psi_hist), max(delta_psi_hist)],
        },
        "examples": examples,
    }


def key_values(line: str) -> dict[str, str]:
    return dict(re.findall(r"([a-zA-Z_]+)=([^ ]*)", line))


def parse_rank_hist(text: str) -> Counter[int]:
    out: Counter[int] = Counter()
    if not text:
        return out
    for item in text.split(","):
        rank, count = item.split(":")
        out[int(rank)] += int(count)
    return out


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", default="target/gridcap-c62")
    parser.add_argument("--out-dir", default="s4-dumps/2026-07-10/c62")
    parser.add_argument("--qs", default="13,17,19")
    parser.add_argument("--profile-only", action="store_true")
    args = parser.parse_args()
    wanted = {int(q) for q in args.qs.split(",") if q}
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    if args.profile_only:
        profile = q23_witness_profile(args.binary)
        out = out_dir / "q23-witness-profile.json"
        out.write_text(json.dumps(profile, indent=2, sort_keys=True) + "\n")
        print(json.dumps(profile, indent=2, sort_keys=True))
        print(f"wrote {out}")
        return

    roots = []
    aggregate: dict[int, dict[str, dict[str, object]]] = defaultdict(dict)
    for q, t4, dump in ROOTS:
        if q not in wanted:
            continue
        fail_path = out_dir / f"q{q}-{t4.replace(',', '')}.rho-fail.tsv"
        command = [
            args.binary,
            "s4selectors",
            str(q),
            t4,
            "--grundy",
            dump,
            "--fail-out",
            str(fail_path),
        ]
        run = subprocess.run(command, check=True, text=True, capture_output=True)
        root_rows = []
        for line in run.stdout.splitlines():
            if not line.startswith("S4SELECT "):
                continue
            values = key_values(line)
            family = values["family"]
            row = {field: int(values[field]) for field in FIELDS[:-1]}
            row["selected_avg_milli"] = int(values["selected_avg_milli"])
            row["p_rank_hist"] = dict(parse_rank_hist(values.get("p_rank_hist", "")))
            root_rows.append({"family": family, **row})
            agg = aggregate[q].setdefault(
                family,
                {field: 0 for field in FIELDS[:-1]}
                | {"selected_weighted_sum": 0, "p_rank_hist": Counter()},
            )
            for field in FIELDS[:-1]:
                agg[field] += row[field]
            agg["selected_weighted_sum"] += row["selected_avg_milli"] * row["defined"]
            agg["p_rank_hist"].update(parse_rank_hist(values.get("p_rank_hist", "")))
        roots.append(
            {
                "q": q,
                "t4": t4,
                "dump": dump,
                "fail_path": str(fail_path),
                "rows": root_rows,
                "summary": next(
                    line for line in run.stdout.splitlines() if line.startswith("S4SELECTORS ")
                ),
                "done": next(
                    line for line in run.stdout.splitlines() if line.startswith("S4SELECTORS-DONE ")
                ),
            }
        )

    clean_aggregate = {}
    for q, families in sorted(aggregate.items()):
        clean_aggregate[str(q)] = {}
        for family, values in sorted(families.items()):
            defined = values["defined"]
            clean_aggregate[str(q)][family] = {
                field: values[field] for field in FIELDS[:-1]
            } | {
                "selected_avg_milli": round(values["selected_weighted_sum"] / defined)
                if defined
                else 0,
                "p_rank_hist": dict(sorted(values["p_rank_hist"].items())),
                "p_hit_fraction": values["p_hit"] / values["obligations"],
                "psi_hit_fraction": values["psi_hit"] / values["obligations"],
                "conditional_p_hit_fraction": values["p_hit"] / defined if defined else 0.0,
            }
    result = {
        "semantics": {
            "p_hit": "selector argmin/family contains at least one exact Grundy-zero reply",
            "psi_hit": "selector contains an exact Grundy-zero reply with C63 Delta Psi < 0",
            "all_p": "every tied selected reply is Grundy-zero",
            "rho": "rho(S)=mean_m(1-rho(S+m)), terminal rho=0",
        },
        "aggregate": clean_aggregate,
        "q23_witness_profile": q23_witness_profile(args.binary),
        "roots": roots,
    }
    out = out_dir / "selector-results.json"
    out.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(clean_aggregate, indent=2, sort_keys=True))
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
