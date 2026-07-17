#!/usr/bin/env python3
"""Bounded plan-portfolio experiment for C249.

The corpus is deliberately small enough that every portfolio and every
failure-domain transversal can be enumerated.  No optimizer or ML package is
required.  Run without ``-O``: assertions are part of the certificate.
"""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from itertools import combinations
import json
import math
from pathlib import Path


if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


@dataclass(frozen=True)
class Plan:
    name: str
    actions: tuple[str, ...]
    description: str
    domains: frozenset[str]


@dataclass(frozen=True)
class Case:
    name: str
    portfolio_size: int
    plans: tuple[Plan, ...]


SURFACE_MODES = (
    ("snapshot", "replay", "reconcile"),
    ("export", "rebuild", "checksum"),
    ("mirror", "promote", "rewire"),
    ("journal", "restore", "audit"),
)


def surface_case(name: str, hub: str, robust_prefix: str) -> Case:
    """Four surface-diverse hub plans and four surface-similar disjoint plans."""
    plans: list[Plan] = []
    for index, words in enumerate(SURFACE_MODES):
        actions = (*[f"{name}-{word}-{index}" for word in words], "validate")
        plans.append(
            Plan(
                name=f"H{index}",
                actions=actions,
                description=" ".join(actions),
                domains=frozenset((hub, f"{name}-edge-{index}", f"{name}-operator-{index}")),
            )
        )
    for index in range(4):
        actions = ("assess", "prestage", f"switch-channel-{index}", "validate")
        plans.append(
            Plan(
                name=f"R{index}",
                actions=actions,
                description=" ".join((*actions, "isolated recovery channel")),
                domains=frozenset(
                    f"{robust_prefix}-{index}-{kind}" for kind in ("control", "transport", "identity")
                ),
            )
        )
    return Case(name=name, portfolio_size=4, plans=tuple(plans))


def higher_order_case() -> Case:
    """A fixed 3-uniform instance where pairwise risk diversity misses tau=3."""
    labels = (
        "global-identity",
        "east-control",
        "west-control",
        "audit-plane",
        "vendor-a",
        "vendor-b",
        "backbone-a",
        "backbone-b",
    )
    triples = (
        (1, 4, 6),
        (3, 5, 6),
        (1, 5, 7),
        (0, 2, 7),
        (0, 1, 2),
        (4, 6, 7),
        (1, 3, 5),
        (1, 4, 7),
        (1, 3, 4),
    )
    plans = tuple(
        Plan(
            name=f"P{index}",
            actions=(f"inspect-{index}", f"stage-{index}", f"remediate-{index}", "validate"),
            description=f"inspect stage remediate route {index} validate",
            domains=frozenset(labels[item] for item in triple),
        )
        for index, triple in enumerate(triples)
    )
    return Case("cross-control", 4, plans)


def corpus() -> tuple[Case, ...]:
    return (
        surface_case("database-recovery", "primary-admin-plane", "db-island"),
        surface_case("credential-revocation", "global-root-credential", "identity-island"),
        surface_case("service-failover", "global-orchestrator", "service-island"),
        surface_case("patch-remediation", "central-package-trust", "patch-island"),
        higher_order_case(),
    )


def jaccard_distance(left: frozenset[str], right: frozenset[str]) -> float:
    return 1.0 - len(left & right) / len(left | right)


def tokenize(text: str) -> frozenset[str]:
    return frozenset(text.lower().replace("-", " ").split())


def tfidf_vectors(plans: tuple[Plan, ...]) -> dict[str, dict[str, float]]:
    documents = {plan.name: tokenize(plan.description) for plan in plans}
    frequency = Counter(token for tokens in documents.values() for token in tokens)
    count = len(plans)
    vectors: dict[str, dict[str, float]] = {}
    for name, tokens in documents.items():
        vector = {token: math.log((1 + count) / (1 + frequency[token])) + 1 for token in tokens}
        norm = math.sqrt(sum(value * value for value in vector.values()))
        vectors[name] = {token: value / norm for token, value in vector.items()}
    return vectors


def cosine_distance(left: dict[str, float], right: dict[str, float]) -> float:
    return 1.0 - sum(value * right.get(token, 0.0) for token, value in left.items())


def pair_score(portfolio: tuple[Plan, ...], distance) -> tuple[float, float]:
    distances = [distance(left, right) for left, right in combinations(portfolio, 2)]
    return min(distances), sum(distances)


def transversal(portfolio: tuple[Plan, ...]) -> tuple[int, tuple[str, ...]]:
    universe = sorted(set().union(*(plan.domains for plan in portfolio)))
    for size in range(len(universe) + 1):
        for chosen in combinations(universe, size):
            hit = frozenset(chosen)
            if all(hit & plan.domains for plan in portfolio):
                return size, chosen
    raise AssertionError("finite portfolio has no transversal")


def score_key(case: Case, portfolio: tuple[Plan, ...], baseline: str, vectors) -> tuple[float, ...]:
    if baseline == "action":
        return pair_score(
            portfolio,
            lambda a, b: jaccard_distance(frozenset(a.actions), frozenset(b.actions)),
        )
    if baseline == "embedding":
        return pair_score(portfolio, lambda a, b: cosine_distance(vectors[a.name], vectors[b.name]))
    if baseline == "risk-pairwise":
        return pair_score(portfolio, lambda a, b: jaccard_distance(a.domains, b.domains))
    if baseline == "risk-union":
        return (float(len(set().union(*(plan.domains for plan in portfolio)))),)
    if baseline == "risk-frequency":
        counts = Counter(domain for plan in portfolio for domain in plan.domains)
        return (-float(max(counts.values())), -float(sum(value * value for value in counts.values())))
    if baseline == "exact-transversal":
        return (float(transversal(portfolio)[0]),)
    raise ValueError(baseline)


def evaluate(case: Case) -> dict:
    vectors = tfidf_vectors(case.plans)
    portfolios = tuple(combinations(case.plans, case.portfolio_size))
    baselines = (
        "action",
        "embedding",
        "risk-union",
        "risk-frequency",
        "risk-pairwise",
        "exact-transversal",
    )
    result = {
        "case": case.name,
        "candidate_count": len(case.plans),
        "portfolio_size": case.portfolio_size,
        "portfolio_count": len(portfolios),
        "uniform_action_cost": sorted({len(plan.actions) for plan in case.plans}),
        "uniform_domain_count": sorted({len(plan.domains) for plan in case.plans}),
        "candidates": [
            {
                "name": plan.name,
                "actions": list(plan.actions),
                "description": plan.description,
                "failure_domains": sorted(plan.domains),
            }
            for plan in case.plans
        ],
        "baselines": {},
    }
    for baseline in baselines:
        scored = [(score_key(case, portfolio, baseline, vectors), portfolio) for portfolio in portfolios]
        best = max(score for score, _portfolio in scored)
        winners = [portfolio for score, portfolio in scored if all(abs(x - y) < 1e-12 for x, y in zip(score, best))]
        robustness = [transversal(portfolio)[0] for portfolio in winners]
        representative = min(winners, key=lambda portfolio: tuple(plan.name for plan in portfolio))
        tau, witness = transversal(representative)
        result["baselines"][baseline] = {
            "score": [round(value, 12) for value in best],
            "cooptimal_count": len(winners),
            "cooptimal_tau_range": [min(robustness), max(robustness)],
            "representative": [plan.name for plan in representative],
            "representative_tau": tau,
            "representative_minimum_transversal": list(witness),
        }
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    cases = [evaluate(case) for case in corpus()]
    for case in cases[:4]:
        assert case["uniform_action_cost"] == [4]
        assert case["uniform_domain_count"] == [3]
        assert case["baselines"]["exact-transversal"]["cooptimal_tau_range"] == [4, 4]
        assert case["baselines"]["action"]["cooptimal_tau_range"][1] < 4
        assert case["baselines"]["embedding"]["cooptimal_tau_range"][1] < 4
        assert case["baselines"]["risk-pairwise"]["cooptimal_tau_range"] == [4, 4]

    higher = cases[-1]
    assert higher["baselines"]["exact-transversal"]["cooptimal_tau_range"] == [3, 3]
    assert higher["baselines"]["risk-pairwise"]["cooptimal_tau_range"] == [2, 2]

    payload = {
        "schema": "c249-transversal-plan-portfolios-v1",
        "objective": "maximize the minimum unit-cost failure-domain transversal",
        "cases": cases,
        "summary": {
            "surface_cases": 4,
            "surface_strict_action_separations": sum(
                case["baselines"]["action"]["cooptimal_tau_range"][1]
                < case["baselines"]["exact-transversal"]["cooptimal_tau_range"][0]
                for case in cases[:4]
            ),
            "surface_strict_embedding_separations": sum(
                case["baselines"]["embedding"]["cooptimal_tau_range"][1]
                < case["baselines"]["exact-transversal"]["cooptimal_tau_range"][0]
                for case in cases[:4]
            ),
            "higher_order_pairwise_separation": True,
        },
    }
    encoded = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(encoded)
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
