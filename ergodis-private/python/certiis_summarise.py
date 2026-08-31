"""Reduce a certiis benchmark JSON to the markdown tables used in the report.

    uv run --python 3.12 python python/certiis_summarise.py \
        --benchmark ~/.cache/ergodis/certiis/benchmark.json
"""

from __future__ import annotations

import argparse
import json
import pathlib
import statistics


def milliseconds(value) -> str:
    return "-" if value is None else f"{value * 1000:.2f}"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", type=pathlib.Path, required=True)
    arguments = parser.parse_args()
    payload = json.loads(arguments.benchmark.read_text())
    rows = payload["rows"]

    print("versions:", json.dumps(payload["versions"]))
    print()

    infeasible = [r for r in rows if r["certiis"]["status"] == "infeasible"]
    feasible = [r for r in rows if r["certiis"]["status"] == "feasible"]
    declined = [r for r in rows if r["certiis"]["status"] == "declined"]
    print(
        f"instances: {len(rows)} total, {len(infeasible)} infeasible, "
        f"{len(feasible)} feasible, {len(declined)} declined"
    )
    disagree = [r["instance"] for r in rows if r["oracle_agrees"] is False]
    print(f"oracle disagreements: {disagree or 'none'}")

    exact = 0
    for row in infeasible:
        truth = row.get("ground_truth") or {}
        if row["certiis"]["explanation"] == sorted(truth.get("planted_tasks", [])):
            exact += 1
    print(f"certificates equal to the planted ground truth: {exact}/{len(infeasible)}")
    blocks = sum(
        1
        for r in infeasible
        if r["certiis"].get("certificate_count")
        == ((r.get("ground_truth") or {}).get("bottleneck_count"))
    )
    print(f"bottleneck count equal to the planted count: {blocks}/{len(infeasible)}")
    print()

    header = (
        "| instance | tasks | certiis size | blocks | raw set | CP-SAT core | "
        "HiGHS task rows | certiis ms | CP-SAT ms | HiGHS ms |"
    )
    print(header)
    print("|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    for row in sorted(infeasible, key=lambda r: r["instance"]):
        cp = row.get("cpsat") or {}
        hi = row.get("highs") or {}
        sizes = "+".join(str(s) for s in row["certiis"].get("certificate_sizes", []))
        print(
            f"| {row['instance']} | {row['tasks']} "
            f"| {sizes} "
            f"| {row['certiis'].get('certificate_count')} "
            f"| {row['certiis']['raw_deficient_tasks']} "
            f"| {cp.get('explanation_size', '-')} "
            f"| {hi.get('explanation_size', '-')} "
            f"| {milliseconds(row['certiis']['seconds_in_process'])} "
            f"| {milliseconds(cp.get('seconds'))} "
            f"| {milliseconds(hi.get('seconds'))} |"
        )
    print()

    def summary(label, selector, key):
        values = [selector(r) for r in rows if selector(r) is not None]
        if not values:
            print(f"{label}: no data")
            return
        print(
            f"{label}: median {statistics.median(values)*1000:.2f} ms, "
            f"max {max(values)*1000:.2f} ms, over {len(values)} instances ({key})"
        )

    for group, label in ((infeasible, "infeasible"), (feasible, "feasible")):
        print(f"-- {label} --")
        summary(
            "  certiis in-process",
            lambda r: r["certiis"]["seconds_in_process"] if r in group else None,
            label,
        )
        summary(
            "  certiis wall (process launch included)",
            lambda r: r["certiis"]["seconds_wall"] if r in group else None,
            label,
        )
        summary(
            "  certiis verify wall",
            lambda r: r["certiis"]["verify_seconds_wall"] if r in group else None,
            label,
        )
        summary(
            "  CP-SAT",
            lambda r: (r.get("cpsat") or {}).get("seconds") if r in group else None,
            label,
        )
        summary(
            "  HiGHS (solve + IIS)",
            lambda r: (r.get("highs") or {}).get("seconds") if r in group else None,
            label,
        )
        summary(
            "  Hopcroft-Karp oracle",
            lambda r: (r.get("hopcroft_karp") or {}).get("seconds") if r in group else None,
            label,
        )

    print()
    print("-- explanation size, infeasible instances --")
    for name, get in (
        ("certiis", lambda r: r["certiis"]["explanation_size"]),
        ("certiis pre-minimization", lambda r: r["certiis"]["raw_deficient_tasks"]),
        ("CP-SAT core", lambda r: (r.get("cpsat") or {}).get("explanation_size")),
        ("HiGHS IIS task rows", lambda r: (r.get("highs") or {}).get("explanation_size")),
        (
            "HiGHS IIS total rows+cols",
            lambda r: (
                None
                if not r.get("highs") or r["highs"].get("explanation_size") is None
                else r["highs"]["explanation_size"]
                + r["highs"].get("iis_resource_rows", 0)
                + r["highs"].get("iis_columns", 0)
            ),
        ),
    ):
        values = [get(r) for r in infeasible if get(r) is not None]
        if values:
            print(
                f"  {name}: median {statistics.median(values):.0f}, "
                f"min {min(values)}, max {max(values)}"
            )

    mismatch = [
        (r["instance"], r["certiis"]["explanation_size"], (r.get("cpsat") or {}).get("explanation_size"))
        for r in infeasible
        if (r.get("cpsat") or {}).get("explanation_size") is not None
        and r["certiis"]["explanation_size"] != r["cpsat"]["explanation_size"]
    ]
    print()
    print(f"instances where CP-SAT's core size differs from ours: {mismatch or 'none'}")

    losses = [
        r["instance"]
        for r in rows
        if (r.get("cpsat") or {}).get("seconds") is not None
        and r["certiis"]["seconds_wall"] is not None
        and r["cpsat"]["seconds"] < r["certiis"]["seconds_wall"]
    ]
    print(f"instances where CP-SAT beats our end-to-end wall time: {losses or 'none'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
