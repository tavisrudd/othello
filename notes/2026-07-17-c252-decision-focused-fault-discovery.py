#!/usr/bin/env python3
"""C252 exact finite decision-focused fault-discovery experiment.

The C251 operational fixture supplies the plan and domain names.  C252 hides one
portfolio-relevant incidence pattern and adds an independent nuisance pattern.
Each singleton fault injection returns the complete vector of failed plans.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import json
import math
from pathlib import Path
from typing import Any, Callable


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-07-17-c251-agent-remediation-common-mode-corpus.json"
RESULTS = HERE / "2026-07-17-c252-decision-focused-fault-discovery-results.json"


def load(path: Path) -> Any:
    return json.loads(path.read_text())


def entropy(values: list[Any]) -> float:
    counts = collections.Counter(values)
    total = len(values)
    return -sum((count / total) * math.log2(count / total) for count in counts.values())


def minimum_transversal(portfolio: tuple[str, ...], lineage: dict[str, frozenset[str]], domains: list[str]) -> int:
    for size in range(1, len(domains) + 1):
        for attack in itertools.combinations(domains, size):
            if all(set(attack) & lineage[plan] for plan in portfolio):
                return size
    raise AssertionError("every plan has nonempty lineage")


def optimal_portfolios(model: dict[str, Any], plans: list[str], domains: list[str], size: int) -> tuple[int, tuple[tuple[str, ...], ...]]:
    portfolios = list(itertools.combinations(plans, size))
    scores = [minimum_transversal(portfolio, model["lineage"], domains) for portfolio in portfolios]
    optimum = max(scores)
    return optimum, tuple(portfolio for portfolio, score in zip(portfolios, scores, strict=True) if score == optimum)


def build_fixture() -> dict[str, Any]:
    source = load(SOURCE)
    scenario = next(row for row in source["scenarios"] if row["id"] == "shared_operational_control_plane")
    plans = [plan["id"] for plan in scenario["plans"]]
    domains = [domain["blind"] for domain in scenario["domains"]]
    base = {plan["id"]: set(plan["lineage"]) for plan in scenario["plans"]}
    models = []

    # decision=0 preserves C251's robust causal quartet.  decision=1 changes
    # only fd_b: it becomes common to the causal plans and disappears from the
    # axis plans, so the optimal portfolio changes.  The holder of fd_h is an
    # eight-way nuisance parameter which never changes the optimum.
    for decision in (0, 1):
        for nuisance_holder in plans:
            lineage = {plan: set(dependencies) - {"fd_h"} for plan, dependencies in base.items()}
            lineage[nuisance_holder].add("fd_h")
            if decision:
                for plan in plans[:4]:
                    lineage[plan].add("fd_b")
                for plan in plans[4:]:
                    lineage[plan].discard("fd_b")
            model = {
                "id": f"decision_{decision}__holder_{nuisance_holder}",
                "decision": decision,
                "nuisance_holder": nuisance_holder,
                "lineage": {plan: frozenset(dependencies) for plan, dependencies in lineage.items()},
            }
            optimum, portfolios = optimal_portfolios(model, plans, domains, source["portfolio_size"])
            model["optimum"] = optimum
            model["optimal_portfolios"] = portfolios
            models.append(model)

    labels_by_decision = {
        decision: {model["optimal_portfolios"] for model in models if model["decision"] == decision}
        for decision in (0, 1)
    }
    assert all(len(labels) == 1 for labels in labels_by_decision.values())
    assert labels_by_decision[0] != labels_by_decision[1]
    return {
        "plans": plans,
        "domains": domains,
        "portfolio_size": source["portfolio_size"],
        "models": models,
    }


def outcome(model: dict[str, Any], domain: str, plans: list[str]) -> tuple[str, ...]:
    return tuple(plan for plan in plans if domain in model["lineage"][plan])


def common_optimum(version: list[dict[str, Any]]) -> tuple[str, ...] | None:
    shared = set(version[0]["optimal_portfolios"])
    for model in version[1:]:
        shared &= set(model["optimal_portfolios"])
    return min(shared) if shared else None


def decision_gain(version: list[dict[str, Any]], domain: str, plans: list[str]) -> float:
    labels = [model["optimal_portfolios"] for model in version]
    before = entropy(labels)
    groups: dict[tuple[str, ...], list[dict[str, Any]]] = collections.defaultdict(list)
    for model in version:
        groups[outcome(model, domain, plans)].append(model)
    after = sum(len(group) / len(version) * entropy([model["optimal_portfolios"] for model in group]) for group in groups.values())
    return before - after


def graph_gain(version: list[dict[str, Any]], domain: str, plans: list[str]) -> float:
    return entropy([outcome(model, domain, plans) for model in version])


def greedy_policy(gain: Callable[[list[dict[str, Any]], str, list[str]], float]) -> Callable[..., str]:
    def select(version: list[dict[str, Any]], remaining: list[str], plans: list[str]) -> str:
        return max(remaining, key=lambda domain: (gain(version, domain, plans), -remaining.index(domain)))

    return select


def ordered_policy(order: list[str]) -> Callable[..., str]:
    def select(_: list[dict[str, Any]], remaining: list[str], __: list[str]) -> str:
        return next(domain for domain in order if domain in remaining)

    return select


def run_policy(fixture: dict[str, Any], truth: dict[str, Any], select: Callable[..., str]) -> dict[str, Any]:
    version = list(fixture["models"])
    remaining = list(fixture["domains"])
    trace = []
    while common_optimum(version) is None:
        domain = select(version, remaining, fixture["plans"])
        observed = outcome(truth, domain, fixture["plans"])
        version = [model for model in version if outcome(model, domain, fixture["plans"]) == observed]
        remaining.remove(domain)
        trace.append({"fault": domain, "failed_plans": list(observed), "models_remaining": len(version)})
    certificate = common_optimum(version)
    assert certificate is not None and certificate in truth["optimal_portfolios"]
    return {"interventions": len(trace), "certified_portfolio": list(certificate), "trace": trace}


def summarize(rows: dict[str, dict[str, Any]]) -> dict[str, Any]:
    counts = [row["interventions"] for row in rows.values()]
    return {
        "mean_interventions": sum(counts) / len(counts),
        "min_interventions": min(counts),
        "max_interventions": max(counts),
        "histogram": {str(value): counts.count(value) for value in sorted(set(counts))},
    }


def serializable_model(model: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": model["id"],
        "decision": model["decision"],
        "nuisance_holder": model["nuisance_holder"],
        "optimum": model["optimum"],
        "optimal_portfolios": [list(portfolio) for portfolio in model["optimal_portfolios"]],
        "lineage": {plan: sorted(dependencies) for plan, dependencies in model["lineage"].items()},
    }


def run() -> dict[str, Any]:
    fixture = build_fixture()
    domains = fixture["domains"]
    plans = fixture["plans"]

    # Coverage follows the frozen C251 domain order.  The LDFI-style baseline
    # exhausts hazards from one corrupted declared lineage: fd_h is declared as
    # common and the omitted fd_b incidence is considered only in the final
    # coverage fallback.  It is a bounded objective baseline, not Molly itself.
    coverage_order = list(domains)
    ldfi_order = ["fd_h", "fd_a", "fd_c", "fd_d", "fd_e", "fd_f", "fd_g", "fd_b"]
    policies = {
        "decision_focused": greedy_policy(decision_gain),
        "full_graph_information_gain": greedy_policy(graph_gain),
        "coverage": ordered_policy(coverage_order),
        "ldfi_hazard_enumeration": ordered_policy(ldfi_order),
    }
    evaluated = {
        name: {model["id"]: run_policy(fixture, model, policy) for model in fixture["models"]}
        for name, policy in policies.items()
    }
    summaries = {name: summarize(rows) for name, rows in evaluated.items()}

    # Every non-b query is decision-invariant and b alone resolves the decision,
    # so exact uniform random ordering has a uniform stopping position 1..8.
    random_summary = {
        "mean_interventions": (len(domains) + 1) / 2,
        "min_interventions": 1,
        "max_interventions": len(domains),
        "histogram": {str(position): math.factorial(len(domains) - 1) for position in range(1, len(domains) + 1)},
        "permutations": math.factorial(len(domains)),
    }
    summaries["random_uniform_order"] = random_summary

    assert summaries["decision_focused"]["max_interventions"] == 1
    for baseline in ("full_graph_information_gain", "coverage", "ldfi_hazard_enumeration"):
        assert summaries["decision_focused"]["max_interventions"] < summaries[baseline]["min_interventions"]
    assert summaries["decision_focused"]["mean_interventions"] < random_summary["mean_interventions"]
    assert all(
        row["trace"][0]["fault"] == "fd_h"
        for row in evaluated["full_graph_information_gain"].values()
    )

    return {
        "schema_version": 1,
        "source_fixture": SOURCE.name,
        "observation": "singleton fault -> complete failed-plan vector",
        "stop_rule": "surviving models have a common exactly optimal size-four portfolio",
        "model_count": len(fixture["models"]),
        "models": [serializable_model(model) for model in fixture["models"]],
        "policy_summaries": summaries,
        "representative_traces": {name: rows[fixture["models"][0]["id"]] for name, rows in evaluated.items()},
        "gate": "synthetic_sample_advantage_with_novelty_kill",
        "limitations": [
            "finite authored version space and deterministic noiseless execution oracle",
            "singleton equal-cost injections only",
            "LDFI row is a lineage-hazard objective translation, not a reimplementation of Molly",
            "decision-focused acquisition is an instance of established targeted active learning/value of information",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", action="store_true", help="write deterministic checked results")
    args = parser.parse_args()
    results = run()
    if args.emit:
        RESULTS.write_text(json.dumps(results, indent=2, sort_keys=True) + "\n")
    print(json.dumps(results, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
