#!/usr/bin/env python3
"""C250: generate and independently check a tiny remediation certificate bundle.

The generator is deliberately treated as untrusted.  The checker replays typed plan
composition, reconstructs the SAT instance, checks a resolution refutation for the
lower bound, and checks a cheap-attack witness for the matching upper bound.
"""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path
from typing import Any


HERE = Path(__file__).resolve().parent
STEM = "2026-07-17-c250-proof-carrying-remediation"
FIXTURE = HERE / f"{STEM}-fixture.json"
CERTIFICATE = HERE / f"{STEM}-certificate.json"
CNF = HERE / f"{STEM}-lower-bound.cnf"


def load(path: Path) -> Any:
    return json.loads(path.read_text())


def derive_dependencies(fixture: dict[str, Any]) -> dict[str, list[str]]:
    """Type-check each acyclic plan and derive goal lineage from trusted schemas."""
    resources = fixture["resources"]
    schemas = fixture["schemas"]
    known_domains = set(fixture["domains"])
    result: dict[str, list[str]] = {}
    seen_plans: set[str] = set()

    for plan in fixture["plans"]:
        plan_id = plan["id"]
        assert plan_id not in seen_plans, f"duplicate plan id: {plan_id}"
        seen_plans.add(plan_id)
        values: dict[str, tuple[str, set[str]]] = {}
        step_ids: set[str] = set()

        for step in plan["steps"]:
            step_id = step["id"]
            assert step_id not in step_ids, f"duplicate step id in {plan_id}: {step_id}"
            step_ids.add(step_id)
            schema = schemas[step["schema"]]
            assert len(step["inputs"]) == len(schema["inputs"])
            lineage: set[str] = set()

            for ref, expected_type in zip(step["inputs"], schema["inputs"], strict=True):
                kind, name = ref.split(":", 1)
                if kind == "resource":
                    resource = resources[name]
                    actual_type = resource["type"]
                    domains = set(resource["domains"])
                    assert domains <= known_domains
                elif kind == "step":
                    actual_type, domains = values[name]
                else:
                    raise AssertionError(f"unknown reference kind: {kind}")
                assert actual_type == expected_type, (plan_id, step_id, actual_type, expected_type)
                lineage.update(domains)

            values[step_id] = (schema["output"], lineage)

        goal_kind, goal_id = plan["goal"].split(":", 1)
        assert goal_kind == "step"
        goal_type, goal_domains = values[goal_id]
        assert goal_type == "remediation_success"
        assert goal_id == plan["steps"][-1]["id"], "goal must be the terminal step"
        result[plan_id] = sorted(goal_domains)

    return result


def compile_cnf(
    domains: list[str], dependencies: dict[str, list[str]], threshold: int
) -> list[list[int]]:
    """Encode a unit-cost transversal of cost < threshold as CNF."""
    assert 1 <= threshold <= len(domains) + 1
    variables = {domain: index + 1 for index, domain in enumerate(domains)}
    clauses = [[variables[domain] for domain in deps] for deps in dependencies.values()]
    # At most threshold-1 selected domains: forbid every threshold-subset.
    clauses.extend(
        [-variables[domain] for domain in subset]
        for subset in itertools.combinations(domains, threshold)
    )
    return clauses


def resolution_refutation(initial: list[list[int]]) -> list[dict[str, Any]]:
    """Untrusted exhaustive producer for a small resolution refutation."""
    clauses = [frozenset(clause) for clause in initial]
    known = set(clauses)
    steps: list[dict[str, Any]] = []
    cursor = 0
    while cursor < len(clauses):
        left = clauses[cursor]
        for right_index in range(cursor):
            right = clauses[right_index]
            for pivot in sorted(literal for literal in left if -literal in right):
                resolvent = (left - {pivot}) | (right - {-pivot})
                if any(-literal in resolvent for literal in resolvent) or resolvent in known:
                    continue
                clauses.append(frozenset(resolvent))
                known.add(frozenset(resolvent))
                steps.append(
                    {
                        "clause": sorted(resolvent),
                        "parents": [cursor + 1, right_index + 1],
                        "pivot": pivot,
                    }
                )
                if not resolvent:
                    return steps
        cursor += 1
    raise AssertionError("producer failed to find a resolution refutation")


def make_certificate(fixture: dict[str, Any]) -> dict[str, Any]:
    dependencies = derive_dependencies(fixture)
    domains = fixture["domains"]
    threshold = 2
    clauses = compile_cnf(domains, dependencies, threshold)
    return {
        "claimed_dependencies": dependencies,
        "lower_bound": {
            "claim": "rho >= 2",
            "threshold": threshold,
            "variables": {domain: index + 1 for index, domain in enumerate(domains)},
            "clauses": clauses,
            "resolution_steps": resolution_refutation(clauses),
        },
        "upper_bound": {
            "claim": "rho < 3",
            "threshold": 3,
            "attack": ["trust_root", "control_plane"],
        },
    }


def check_resolution(initial: list[list[int]], steps: list[dict[str, Any]]) -> None:
    clauses = [frozenset(clause) for clause in initial]
    for step in steps:
        left_id, right_id = step["parents"]
        assert 1 <= left_id <= len(clauses) and 1 <= right_id <= len(clauses)
        left, right = clauses[left_id - 1], clauses[right_id - 1]
        pivot = step["pivot"]
        assert pivot in left and -pivot in right
        expected = (left - {pivot}) | (right - {-pivot})
        assert not any(-literal in expected for literal in expected), "tautological resolvent"
        claimed = frozenset(step["clause"])
        assert claimed == expected, (claimed, expected)
        clauses.append(claimed)
    assert steps and not clauses[-1], "proof does not end in contradiction"


def check(fixture: dict[str, Any], certificate: dict[str, Any]) -> dict[str, Any]:
    dependencies = derive_dependencies(fixture)
    assert certificate["claimed_dependencies"] == dependencies
    lower = certificate["lower_bound"]
    expected_variables = {
        domain: index + 1 for index, domain in enumerate(fixture["domains"])
    }
    assert lower["variables"] == expected_variables
    clauses = compile_cnf(fixture["domains"], dependencies, lower["threshold"])
    assert lower["clauses"] == clauses
    check_resolution(clauses, lower["resolution_steps"])

    upper = certificate["upper_bound"]
    attack = set(upper["attack"])
    assert attack <= set(fixture["domains"])
    assert len(attack) < upper["threshold"]
    assert all(attack & set(plan_dependencies) for plan_dependencies in dependencies.values())
    assert lower["threshold"] + 1 == upper["threshold"]

    return {
        "plans_checked": len(dependencies),
        "dependencies": dependencies,
        "lower_bound": lower["threshold"],
        "upper_bound": len(attack),
        "exact_rho": lower["threshold"],
        "resolution_steps": len(lower["resolution_steps"]),
    }


def emit_dimacs(path: Path, clauses: list[list[int]], variable_count: int) -> None:
    lines = [f"p cnf {variable_count} {len(clauses)}"]
    lines.extend(" ".join(map(str, clause)) + " 0" for clause in clauses)
    path.write_text("\n".join(lines) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", action="store_true", help="run the untrusted producer first")
    args = parser.parse_args()
    fixture = load(FIXTURE)
    if args.emit:
        certificate = make_certificate(fixture)
        CERTIFICATE.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
        lower = certificate["lower_bound"]
        emit_dimacs(CNF, lower["clauses"], len(lower["variables"]))
    certificate = load(CERTIFICATE)
    print(json.dumps(check(fixture, certificate), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
