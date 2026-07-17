#!/usr/bin/env python3
"""C251 deterministic blinded remediation common-mode benchmark.

Selectors receive either public generation metadata or opaque C250-style lineage.
The hidden domain meanings and fault execution oracle are consulted only after every
selector's complete maximizing set has been frozen.  All ties are retained.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path
from typing import Any, Callable, Iterable


HERE = Path(__file__).resolve().parent
STEM = "2026-07-17-c251-agent-remediation-common-mode"
CORPUS = HERE / f"{STEM}-corpus.json"
RESULTS = HERE / f"{STEM}-results.json"


def load(path: Path) -> Any:
    return json.loads(path.read_text())


def tokens(text: str) -> set[str]:
    return set(text.lower().split())


def jaccard_distance(left: set[str], right: set[str]) -> float:
    union = left | right
    return 0.0 if not union else 1.0 - len(left & right) / len(union)


def pair_sum(items: Iterable[set[str]]) -> float:
    values = list(items)
    return sum(jaccard_distance(a, b) for a, b in itertools.combinations(values, 2))


def minimum_transversal(lineages: list[set[str]], domains: list[str]) -> int:
    for size in range(1, len(domains) + 1):
        for attack in itertools.combinations(domains, size):
            if all(set(attack) & lineage for lineage in lineages):
                return size
    raise AssertionError("nonempty lineage has no transversal")


def causal_score(plans: tuple[dict[str, Any], ...], domains: list[str]) -> tuple[int]:
    return (minimum_transversal([set(p["lineage"]) for p in plans], domains),)


def action_score(plans: tuple[dict[str, Any], ...], _: list[str]) -> tuple[int, float]:
    action_sets = [set(p["actions"]) for p in plans]
    return (len(set().union(*action_sets)), pair_sum(action_sets))


def embedding_score(plans: tuple[dict[str, Any], ...], _: list[str]) -> tuple[int, float]:
    token_sets = [tokens(p["text"]) for p in plans]
    return (len(set().union(*token_sets)), pair_sum(token_sets))


def axes_score(plans: tuple[dict[str, Any], ...], _: list[str]) -> tuple[int, int]:
    fields = ("model", "prompt", "language", "tool")
    distinct = [len({p["axes"][field] for p in plans}) for field in fields]
    return (min(distinct), sum(distinct))


def maximizing_portfolios(
    plans: list[dict[str, Any]],
    size: int,
    domains: list[str],
    scorer: Callable[[tuple[dict[str, Any], ...], list[str]], tuple[Any, ...]],
) -> tuple[tuple[Any, ...], list[tuple[dict[str, Any], ...]]]:
    candidates = list(itertools.combinations(plans, size))
    scores = [scorer(candidate, domains) for candidate in candidates]
    best = max(scores)
    return best, [candidate for candidate, score in zip(candidates, scores, strict=True) if score == best]


def campaigns(domains: list[str], max_faults: int) -> list[frozenset[str]]:
    return [
        frozenset(faults)
        for size in range(1, max_faults + 1)
        for faults in itertools.combinations(domains, size)
    ]


def failure_rates(
    portfolio: tuple[dict[str, Any], ...], injections: list[frozenset[str]]
) -> dict[str, float]:
    failure_counts = []
    for injection in injections:
        failure_counts.append(sum(bool(injection & set(plan["audit_lineage"])) for plan in portfolio))
    return {
        "coincident": sum(count == len(portfolio) for count in failure_counts) / len(injections),
        "majority": sum(count > len(portfolio) / 2 for count in failure_counts) / len(injections),
        "mean_plan_failure": sum(failure_counts) / (len(injections) * len(portfolio)),
    }


def rate_range(
    portfolios: list[tuple[dict[str, Any], ...]], injections: list[frozenset[str]]
) -> dict[str, dict[str, float]]:
    rates = [failure_rates(portfolio, injections) for portfolio in portfolios]
    return {
        metric: {"best": min(row[metric] for row in rates), "worst": max(row[metric] for row in rates)}
        for metric in ("coincident", "majority", "mean_plan_failure")
    }


def annotation_audit(scenario: dict[str, Any]) -> dict[str, Any]:
    domains = [domain["blind"] for domain in scenario["domains"]]
    cells = []
    exact_plan_matches = 0
    for plan in scenario["plans"]:
        declared = set(plan["lineage"])
        observed = set(plan["audit_lineage"])
        exact_plan_matches += declared == observed
        cells.extend((domain in declared, domain in observed) for domain in domains)
    agreement = sum(left == right for left, right in cells) / len(cells)
    left_yes = sum(left for left, _ in cells) / len(cells)
    right_yes = sum(right for _, right in cells) / len(cells)
    chance = left_yes * right_yes + (1 - left_yes) * (1 - right_yes)
    kappa = (agreement - chance) / (1 - chance) if chance != 1 else 1.0
    return {
        "plan_exact_matches": exact_plan_matches,
        "plans": len(scenario["plans"]),
        "cell_agreement": agreement,
        "cohen_kappa": kappa,
    }


def ids(portfolio: tuple[dict[str, Any], ...]) -> list[str]:
    return [plan["id"] for plan in portfolio]


def run(corpus: dict[str, Any]) -> dict[str, Any]:
    size = corpus["portfolio_size"]
    max_faults = corpus["fault_campaign"]["max_faults"]
    scorers = {
        "certified_causal": causal_score,
        "action_diversity": action_score,
        "embedding_diversity": embedding_score,
        "generation_axes": axes_score,
        "n_version": axes_score,
    }
    scenario_results = []

    for scenario in corpus["scenarios"]:
        blind_domains = [domain["blind"] for domain in scenario["domains"]]
        assert all(plan["cost"] == 1 for plan in scenario["plans"])
        assert all(set(plan["lineage"]) <= set(blind_domains) and plan["lineage"] for plan in scenario["plans"])

        # Freeze all maximizing portfolios using opaque labels/public metadata.  Only
        # after this point does execution consult the independently stored audit lineage.
        selector_plans = [
            {key: value for key, value in plan.items() if key != "audit_lineage"}
            for plan in scenario["plans"]
        ]
        frozen: dict[str, dict[str, Any]] = {}
        frozen_ids: dict[str, list[list[str]]] = {}
        for name, scorer in scorers.items():
            score, portfolios = maximizing_portfolios(selector_plans, size, blind_domains, scorer)
            frozen[name] = {"score": list(score), "ties": len(portfolios), "portfolios": [ids(p) for p in portfolios]}
            frozen_ids[name] = [ids(portfolio) for portfolio in portfolios]

        hidden_manifest = {domain["blind"]: domain["hidden"] for domain in scenario["domains"]}
        assert len(hidden_manifest) == len(blind_domains)
        execution_plans = {plan["id"]: plan for plan in scenario["plans"]}
        frozen_portfolios = {
            name: [tuple(execution_plans[plan_id] for plan_id in portfolio) for portfolio in portfolios]
            for name, portfolios in frozen_ids.items()
        }
        all_portfolios = list(itertools.combinations(scenario["plans"], size))
        injection_set = campaigns(blind_domains, max_faults)
        evaluated = {
            name: {**frozen[name], "rates": rate_range(portfolios, injection_set)}
            for name, portfolios in frozen_portfolios.items()
        }
        evaluated["random"] = {
            "population": len(all_portfolios),
            "rates": rate_range(all_portfolios, injection_set),
            "mean_rates": {
                metric: sum(failure_rates(p, injection_set)[metric] for p in all_portfolios) / len(all_portfolios)
                for metric in ("coincident", "majority", "mean_plan_failure")
            },
        }

        causal_worst = evaluated["certified_causal"]["rates"]["coincident"]["worst"]
        strict = {}
        for name in ("action_diversity", "embedding_diversity", "generation_axes", "n_version"):
            strict[name] = causal_worst < evaluated[name]["rates"]["coincident"]["best"]
        strict["random_mean"] = causal_worst < evaluated["random"]["mean_rates"]["coincident"]

        scenario_results.append(
            {
                "id": scenario["id"],
                "stratum": scenario["stratum"],
                "hidden_manifest_sha256": hashlib.sha256(json.dumps(hidden_manifest, sort_keys=True).encode()).hexdigest(),
                "injections": len(injection_set),
                "annotation_audit": annotation_audit(scenario),
                "selectors": evaluated,
                "strict_without_tiebreak": strict,
            }
        )

    assert all(all(row["strict_without_tiebreak"].values()) for row in scenario_results)
    assert all(row["annotation_audit"]["cohen_kappa"] == 1.0 for row in scenario_results)
    return {
        "schema_version": corpus["schema_version"],
        "portfolio_size": size,
        "scenario_count": len(scenario_results),
        "scenarios": scenario_results,
        "gate": "synthetic_success",
        "limitations": [
            "fixture annotations and execution oracle share a synthetic causal model",
            "no live agent generation or production infrastructure execution",
            "N-version majority is meaningful only for non-state-changing verdicts",
        ],
    }


def mutation_test(corpus: dict[str, Any]) -> None:
    mutated = json.loads(json.dumps(corpus))
    mutated["scenarios"][0]["plans"][0]["audit_lineage"] = ["fd_a"]
    assert annotation_audit(mutated["scenarios"][0])["cohen_kappa"] < 1.0


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", action="store_true", help="write deterministic checked results")
    args = parser.parse_args()
    corpus = load(CORPUS)
    mutation_test(corpus)
    results = run(corpus)
    if args.emit:
        RESULTS.write_text(json.dumps(results, indent=2, sort_keys=True) + "\n")
    print(json.dumps(results, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
