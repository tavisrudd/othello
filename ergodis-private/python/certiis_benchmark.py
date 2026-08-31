"""Benchmark certiis against established infeasibility explanations.

Three independent parties look at the same `certiis-instance/v1` files:

* `certiis` itself (Rust, `ergodis-private/src/bin/certiis.rs`),
* Google OR-Tools CP-SAT, whose unsatisfiable core over assumption literals is the
  directly comparable "which tasks are to blame" explanation,
* HiGHS, whose irreducible-infeasible-subsystem support is the linear-programming
  analogue (the constraint matrix is bipartite, hence totally unimodular, so the LP
  relaxation is exact here and an LP IIS is a fair comparison),

plus `networkx`'s Hopcroft-Karp maximum matching as a correctness oracle on the
unit-expanded graph, so a bug in the certiis extractor cannot masquerade as a win.

`highspy` and `ortools` cannot share one interpreter here: the OR-Tools wheel bundles its
own HiGHS shared object, and importing `highspy` afterwards fails with an undefined
`Highs::releaseMemory` symbol. The two incumbents are therefore run as separate passes and
merged with `--merge-from`.

Replay:
    cd ~/src/othello/ergodis-private
    cargo build --release --bin certiis
    C=~/.cache/ergodis/certiis
    ./target/release/certiis suite --out $C/instances
    uv run --python 3.12 --with highspy python python/certiis_benchmark.py \
        --engines highs --instances $C/instances --certificates $C/certificates \
        --binary ./target/release/certiis --out $C/benchmark-highs.json
    uv run --python 3.12 --with ortools --with networkx python python/certiis_benchmark.py \
        --engines hopcroft,cpsat --instances $C/instances --certificates $C/certificates \
        --binary ./target/release/certiis --merge-from $C/benchmark-highs.json \
        --out $C/benchmark.json
"""

from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys
import time


# ---------------------------------------------------------------------------
# instance helpers
# ---------------------------------------------------------------------------


def load(path: pathlib.Path) -> dict:
    with path.open() as handle:
        return json.load(handle)


def adjacency(instance: dict) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {task["id"]: [] for task in instance["tasks"]}
    seen: set[tuple[str, str]] = set()
    for task, resource in instance["eligible"]:
        if (task, resource) not in seen:
            seen.add((task, resource))
            out[task].append(resource)
    return out


def is_matching_regime(instance: dict) -> bool:
    """Mirror of the certiis classifier, written independently from the JSON."""
    if instance.get("couplings"):
        return False
    return not any(t.get("distinct") and t.get("demand", 1) > 1 for t in instance["tasks"])


# ---------------------------------------------------------------------------
# correctness oracle: Hopcroft-Karp on the unit expansion
# ---------------------------------------------------------------------------


def hopcroft_karp_feasible(instance: dict) -> tuple[bool, float]:
    import networkx as nx

    graph = nx.Graph()
    left = []
    adjacent = adjacency(instance)
    capacity = {r["id"]: r.get("capacity", 1) for r in instance["resources"]}
    right_copies = {
        rid: [f"R::{rid}::{k}" for k in range(cap)] for rid, cap in capacity.items()
    }
    for task in instance["tasks"]:
        for copy in range(task.get("demand", 1)):
            node = f"L::{task['id']}::{copy}"
            left.append(node)
            graph.add_node(node, bipartite=0)
            for resource in adjacent[task["id"]]:
                for target in right_copies[resource]:
                    graph.add_node(target, bipartite=1)
                    graph.add_edge(node, target)
    started = time.perf_counter()
    if not left:
        return True, 0.0
    matching = nx.bipartite.matching.hopcroft_karp_matching(graph, top_nodes=left)
    elapsed = time.perf_counter() - started
    covered = sum(1 for node in left if node in matching)
    return covered == len(left), elapsed


# ---------------------------------------------------------------------------
# incumbent 1: OR-Tools CP-SAT unsatisfiable core over assumptions
# ---------------------------------------------------------------------------


def cpsat_explanation(instance: dict, time_limit: float) -> dict:
    from ortools.sat.python import cp_model

    adjacent = adjacency(instance)
    capacity = {r["id"]: r.get("capacity", 1) for r in instance["resources"]}
    model = cp_model.CpModel()
    units: dict[tuple[str, str], object] = {}
    for task in instance["tasks"]:
        demand = task.get("demand", 1)
        for resource in adjacent[task["id"]]:
            upper = min(demand, capacity[resource])
            units[(task["id"], resource)] = model.NewIntVar(
                0, upper, f"x_{task['id']}_{resource}"
            )

    assumption = {}
    for task in instance["tasks"]:
        literal = model.NewBoolVar(f"served_{task['id']}")
        assumption[task["id"]] = literal
        terms = [units[(task["id"], r)] for r in adjacent[task["id"]]]
        model.Add(sum(terms) == task.get("demand", 1)).OnlyEnforceIf(literal)

    for resource in instance["resources"]:
        terms = [
            var for (t, r), var in units.items() if r == resource["id"]
        ]
        if terms:
            model.Add(sum(terms) <= resource.get("capacity", 1))

    order = [task["id"] for task in instance["tasks"]]
    model.AddAssumptions([assumption[t] for t in order])

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = time_limit
    solver.parameters.num_workers = 1
    started = time.perf_counter()
    status = solver.Solve(model)
    elapsed = time.perf_counter() - started

    result = {
        "status": solver.StatusName(status),
        "seconds": elapsed,
        "explanation_size": None,
        "explanation": None,
    }
    if status == cp_model.INFEASIBLE:
        core = solver.SufficientAssumptionsForInfeasibility()
        index = {assumption[t].Index(): t for t in order}
        names = [index[i] for i in core if i in index]
        result["explanation_size"] = len(names)
        result["explanation"] = sorted(names)
    return result


# ---------------------------------------------------------------------------
# incumbent 2: HiGHS irreducible infeasible subsystem on the LP relaxation
# ---------------------------------------------------------------------------


def highs_explanation(instance: dict, time_limit: float) -> dict:
    try:
        import highspy
    except Exception as error:  # pragma: no cover - environment dependent
        return {"status": "unavailable", "error": str(error)}

    adjacent = adjacency(instance)
    capacity = {r["id"]: r.get("capacity", 1) for r in instance["resources"]}
    columns: list[tuple[str, str]] = []
    column_index: dict[tuple[str, str], int] = {}
    for task in instance["tasks"]:
        for resource in adjacent[task["id"]]:
            column_index[(task["id"], resource)] = len(columns)
            columns.append((task["id"], resource))

    rows = []          # (lower, upper, [(col, coeff)])
    row_label = []
    for task in instance["tasks"]:
        demand = float(task.get("demand", 1))
        entries = [(column_index[(task["id"], r)], 1.0) for r in adjacent[task["id"]]]
        rows.append((demand, demand, entries))
        row_label.append(("task", task["id"]))
    for resource in instance["resources"]:
        entries = [
            (column_index[key], 1.0)
            for key in column_index
            if key[1] == resource["id"]
        ]
        rows.append((0.0, float(resource.get("capacity", 1)), entries))
        row_label.append(("resource", resource["id"]))

    h = highspy.Highs()
    h.setOptionValue("output_flag", False)
    h.setOptionValue("time_limit", time_limit)
    # Only `iis_strategy = 2` (column priority) returns a populated IIS in HiGHS 1.15.1:
    # the default 0 silently returns an empty one and 1 returns kError.
    h.setOptionValue("iis_strategy", 2)
    inf = highspy.kHighsInf
    upper = []
    for task_id, resource_id in columns:
        demand = next(t.get("demand", 1) for t in instance["tasks"] if t["id"] == task_id)
        upper.append(float(min(demand, capacity[resource_id])))
    h.addVars(len(columns), [0.0] * len(columns), upper)
    h.changeColsCost(
        len(columns), list(range(len(columns))), [0.0] * len(columns)
    )
    starts, index, value = [], [], []
    lowers, uppers = [], []
    for lower, up, entries in rows:
        starts.append(len(index))
        for col, coeff in entries:
            index.append(col)
            value.append(coeff)
        lowers.append(lower)
        uppers.append(up)
    h.addRows(len(rows), lowers, uppers, len(index), starts, index, value)

    started = time.perf_counter()
    h.run()
    status = h.getModelStatus()
    elapsed = time.perf_counter() - started
    result = {
        "status": str(h.modelStatusToString(status)),
        "seconds": elapsed,
        "explanation_size": None,
        "explanation": None,
    }
    if "nfeasible" not in result["status"].lower():
        return result

    iis_started = time.perf_counter()
    try:
        iis_status, iis = h.getIis()
        result["iis_status"] = str(iis_status)
        row_ix = list(iis.row_index_)
        col_ix = list(iis.col_index_)
    except Exception as error:  # pragma: no cover - version dependent
        result["iis_error"] = str(error)
        return result
    result["iis_seconds"] = time.perf_counter() - iis_started
    result["seconds"] = elapsed + result["iis_seconds"]
    tasks = sorted(row_label[i][1] for i in row_ix if row_label[i][0] == "task")
    resources = sorted(row_label[i][1] for i in row_ix if row_label[i][0] == "resource")
    result["explanation_size"] = len(tasks)
    result["explanation"] = tasks
    result["iis_resource_rows"] = len(resources)
    result["iis_columns"] = len(col_ix)
    return result


# ---------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------


def run_certiis(
    binary: pathlib.Path,
    instance_path: pathlib.Path,
    out: pathlib.Path,
    repeats: int = 1,
) -> dict:
    wall = None
    report = None
    in_process = None
    for _ in range(max(1, repeats)):
        started = time.perf_counter()
        completed = subprocess.run(
            [str(binary), "solve", "--input", str(instance_path), "--out", str(out)],
            capture_output=True,
            text=True,
            check=True,
        )
        this_wall = time.perf_counter() - started
        report = load(out)
        this_in_process = report["total_micros"] / 1e6
        wall = this_wall if wall is None else min(wall, this_wall)
        in_process = (
            this_in_process if in_process is None else min(in_process, this_in_process)
        )
    verify_started = time.perf_counter()
    subprocess.run(
        [
            str(binary),
            "verify",
            "--input",
            str(instance_path),
            "--certificate",
            str(out),
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    verify_wall = time.perf_counter() - verify_started
    status = report["status"]
    size = None
    if status == "infeasible":
        size = len(report["certificate"]["tasks"])
    return {
        "status": status,
        "regime": report["regime"],
        "repeats": max(1, repeats),
        "seconds_in_process": in_process,
        "seconds_wall": wall,
        "verify_seconds_wall": verify_wall,
        "explanation_size": size,
        "raw_deficient_tasks": (
            report["certificate"]["raw_deficient_tasks"] if status == "infeasible" else None
        ),
        "explanation": (
            sorted(report["certificate"]["tasks"]) if status == "infeasible" else None
        ),
        "stdout": completed.stdout.strip(),
    }


def fastest(call, repeats: int) -> dict:
    """Run an engine `repeats` times and keep its fastest result."""
    best = None
    for _ in range(max(1, repeats)):
        result = call()
        result["repeats"] = max(1, repeats)
        if best is None:
            best = result
        elif result.get("seconds") is not None and best.get("seconds") is not None:
            if result["seconds"] < best["seconds"]:
                best = result
    return best


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--instances", type=pathlib.Path, required=True)
    parser.add_argument("--certificates", type=pathlib.Path, required=True)
    parser.add_argument("--binary", type=pathlib.Path, required=True)
    parser.add_argument("--out", type=pathlib.Path, required=True)
    parser.add_argument("--time-limit", type=float, default=120.0)
    parser.add_argument(
        "--repeats",
        type=int,
        default=1,
        help="repeat each engine and keep the fastest run, to damp machine noise",
    )
    parser.add_argument(
        "--engines",
        default="hopcroft,cpsat",
        help="comma-separated subset of hopcroft,cpsat,highs",
    )
    parser.add_argument(
        "--merge-from",
        type=pathlib.Path,
        default=None,
        help="earlier benchmark JSON whose engine results are folded into this one",
    )
    arguments = parser.parse_args()
    arguments.certificates.mkdir(parents=True, exist_ok=True)
    engines = {name.strip() for name in arguments.engines.split(",") if name.strip()}

    import importlib.metadata as metadata

    versions = {"python": sys.version.split()[0]}
    for package in ("ortools", "networkx", "highspy"):
        try:
            versions[package] = metadata.version(package)
        except Exception:
            versions[package] = "not installed in this pass"

    merged: dict[str, dict] = {}
    if arguments.merge_from is not None:
        earlier = load(arguments.merge_from)
        versions["merged_from"] = {
            "path": str(arguments.merge_from),
            "versions": earlier["versions"],
        }
        merged = {row["instance"]: row for row in earlier["rows"]}

    rows = []
    for path in sorted(arguments.instances.glob("*.json")):
        instance = load(path)
        name = path.stem
        certificate = arguments.certificates / f"{name}.cert.json"
        ours = run_certiis(arguments.binary, path, certificate, arguments.repeats)

        row = {
            "instance": name,
            "tasks": len(instance["tasks"]),
            "resources": len(instance["resources"]),
            "eligible_pairs": len(instance["eligible"]),
            "matching_regime": is_matching_regime(instance),
            "ground_truth": instance.get("ground_truth"),
            "certiis": ours,
        }
        previous = merged.get(name, {})
        for key in ("hopcroft_karp", "cpsat", "highs"):
            row[key] = previous.get(key)
        row["oracle_agrees"] = previous.get("oracle_agrees")

        if row["matching_regime"]:
            if "hopcroft" in engines:
                feasible, seconds = hopcroft_karp_feasible(instance)
                row["hopcroft_karp"] = {"feasible": feasible, "seconds": seconds}
                row["oracle_agrees"] = (ours["status"] == "feasible") == feasible
            if "cpsat" in engines:
                row["cpsat"] = fastest(
                    lambda: cpsat_explanation(instance, arguments.time_limit),
                    arguments.repeats,
                )
            if "highs" in engines:
                row["highs"] = fastest(
                    lambda: highs_explanation(instance, arguments.time_limit),
                    arguments.repeats,
                )
        else:
            row["oracle_agrees"] = ours["status"] == "declined"
        rows.append(row)
        print(
            f"{name}: certiis={ours['status']}"
            f" size={ours['explanation_size']}"
            f" ({ours['seconds_in_process']*1000:.2f} ms)"
            f" cpsat={(row['cpsat'] or {}).get('explanation_size')}"
            f" ({(row['cpsat'] or {}).get('seconds', 0)*1000:.1f} ms)"
            f" highs={(row['highs'] or {}).get('explanation_size')}"
            f" oracle_agrees={row['oracle_agrees']}",
            flush=True,
        )

    payload = {"versions": versions, "rows": rows}
    arguments.out.parent.mkdir(parents=True, exist_ok=True)
    with arguments.out.open("w") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")
    disagreements = [r["instance"] for r in rows if r["oracle_agrees"] is False]
    print(f"\nwrote {arguments.out}")
    print(f"oracle disagreements: {disagreements or 'none'}")
    return 1 if disagreements else 0


if __name__ == "__main__":
    raise SystemExit(main())
