"""Audit whether an explanation actually explains the whole infeasibility.

An explanation names a set of tasks. The residual test deletes exactly those tasks from the
instance and asks certiis whether what remains is feasible. If it is not, the explanation
named some of the trouble but not all of it, and a planner acting on it will come back to a
still-infeasible roster.

The script applies the residual test to certiis's own certificates and to the CP-SAT
unsatisfiable core recorded in a benchmark JSON, and reports the two side by side.

    uv run --python 3.12 python python/certiis_core_audit.py \
        --benchmark ~/.cache/ergodis/certiis/benchmark.json \
        --instances ~/.cache/ergodis/certiis/instances \
        --binary ./target/release/certiis \
        --workdir ~/.cache/ergodis/certiis/audit
"""

from __future__ import annotations

import argparse
import json
import pathlib
import subprocess


def solve(binary: pathlib.Path, instance: dict, workdir: pathlib.Path, tag: str) -> dict:
    path = workdir / f"{tag}.json"
    out = workdir / f"{tag}.cert.json"
    path.write_text(json.dumps(instance))
    subprocess.run(
        [str(binary), "solve", "--input", str(path), "--out", str(out)],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(out.read_text())


def without(instance: dict, drop: set[str]) -> dict:
    residual = dict(instance)
    residual["name"] = instance["name"] + "-residual"
    residual["tasks"] = [t for t in instance["tasks"] if t["id"] not in drop]
    residual["eligible"] = [p for p in instance["eligible"] if p[0] not in drop]
    residual.pop("ground_truth", None)
    return residual


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", type=pathlib.Path, required=True)
    parser.add_argument("--instances", type=pathlib.Path, required=True)
    parser.add_argument("--binary", type=pathlib.Path, required=True)
    parser.add_argument("--workdir", type=pathlib.Path, required=True)
    arguments = parser.parse_args()
    arguments.workdir.mkdir(parents=True, exist_ok=True)

    payload = json.loads(arguments.benchmark.read_text())
    rows = [
        r
        for r in payload["rows"]
        if r["certiis"]["status"] == "infeasible"
        and (r.get("cpsat") or {}).get("explanation") is not None
    ]

    print("| instance | certiis size | residual after certiis | CP-SAT core | residual after core |")
    print("|---|---:|---|---:|---|")
    incomplete_core = []
    incomplete_ours = []
    for row in rows:
        instance = json.loads((arguments.instances / f"{row['instance']}.json").read_text())
        ours = set(row["certiis"]["explanation"])
        core = set(row["cpsat"]["explanation"])
        after_ours = solve(arguments.binary, without(instance, ours), arguments.workdir, "ours")
        after_core = solve(arguments.binary, without(instance, core), arguments.workdir, "core")
        if after_core["status"] != "feasible":
            incomplete_core.append(row["instance"])
        if after_ours["status"] != "feasible":
            incomplete_ours.append(row["instance"])
        print(
            f"| {row['instance']} | {len(ours)} | {after_ours['status']} "
            f"| {len(core)} | {after_core['status']} |"
        )

    print()
    print(f"instances audited: {len(rows)}")
    print(
        f"CP-SAT core left the instance infeasible on {len(incomplete_core)} of them: "
        f"{incomplete_core or 'none'}"
    )
    print(
        f"certiis certificates left the instance infeasible on {len(incomplete_ours)} of them: "
        f"{incomplete_ours or 'none'}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
