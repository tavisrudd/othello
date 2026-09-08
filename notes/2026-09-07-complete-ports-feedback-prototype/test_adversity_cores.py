from __future__ import annotations

import json
import random
from dataclasses import replace
from fractions import Fraction
from itertools import combinations, product
from math import comb
from pathlib import Path

from adversity_cores import (
    Certificate, Dependency, Witness, compile_core, failure_optimum,
    oracle_portfolio, retained_witnesses, verify_core,
)


def subsets(n: int, limit: int | None = None):
    for k in range(min(n, n if limit is None else limit) + 1):
        for support in combinations(range(n), k):
            yield frozenset(support)


def xor_label(support: frozenset[int], columns: tuple[int, ...]) -> int:
    value = 0
    for h in support:
        value ^= columns[h]
    return value


def run() -> dict:
    rng = random.Random(20260905)
    results = {"seed": 20260905}
    failure_checks = adverse_checks = certificate_checks = 0
    for case in range(120):
        n, r, f = 7, rng.randint(1, 3), rng.randint(0, 2)
        family = tuple(Witness(s, rng.randint(-3, 30)) for s in subsets(n, r) if rng.random() < 0.6)
        cert = compile_core(family, n, r, f)
        assert verify_core(family, cert)
        certificate_checks += 1
        kept = retained_witnesses(family, cert)
        core = frozenset().union(*(w.support for w in kept))
        assert len(kept) <= comb(r + f, r)
        for failed in subsets(n):
            if len(failed.intersection(core)) <= f:
                assert failure_optimum(family, failed) == failure_optimum(kept, failed)
                failure_checks += 1
        for _ in range(30):
            affected_core = frozenset(rng.sample(sorted(core), rng.randint(0, min(f, len(core)))))
            affected = affected_core | frozenset(h for h in range(n) if h not in core and rng.random() < 0.8)
            penalties = {h: rng.randint(0, 20) for h in affected}
            joint = frozenset(rng.sample(sorted(affected), min(2, len(affected))))
            def objective(w: Witness) -> int:
                used = w.support & affected
                return w.cost + sum(penalties[h] for h in used) + 17 * (len(used) >= 2) + 9 * bool(joint and joint <= used)
            assert min(map(objective, family), default=None) == min(map(objective, kept), default=None)
            adverse_checks += 1
    results["random_weighted_families"] = 120
    results["core_local_failure_comparisons"] = failure_checks
    results["nonlinear_monotone_penalty_comparisons"] = adverse_checks
    results["independent_wedge_certificate_checks"] = certificate_checks

    n, r, f = 8, 3, 2
    family = tuple(Witness(s, sum(h + 1 for h in s)) for s in subsets(n, r) if len(s) == r)
    oracle_calls = 0
    def oracle(failed: frozenset[int]) -> Witness | None:
        return min((w for w in family if not w.support & failed), key=lambda w: (w.cost, sorted(w.support)), default=None)
    portfolio, oracle_calls = oracle_portfolio(oracle, r, f)
    cert = compile_core(portfolio, n, r, f)
    kept = retained_witnesses(portfolio, cert)
    for failed in subsets(n, f):
        assert failure_optimum(family, failed) == failure_optimum(kept, failed)
    assert oracle_calls <= sum(r**i for i in range(f + 1))
    results["oracle_construction"] = {"raw_alternatives": len(family), "oracle_calls": oracle_calls, "retained": len(kept), "bound": comb(r + f, r)}

    for r in range(1, 4):
        for f in range(3):
            n = r + f
            tight = tuple(Witness(frozenset(s), 0) for s in combinations(range(n), r))
            assert len(compile_core(tight, n, r, f).retained) == comb(r + f, r)
    results["tight_binomial_examples"] = 9

    n, r, f = 10, 4, 2
    columns = (1, 2, 4, 8, 3, 5, 6, 9, 10, 12)
    weights = tuple(range(1, n + 1))
    def groups(indices: range):
        output = {}
        for k in range(min(r, len(indices)) + 1):
            for support in combinations(indices, k):
                s = frozenset(support)
                key = (xor_label(s, columns), k)
                output.setdefault(key, []).append(Witness(s, sum(weights[h] for h in s)))
        return output
    left, right = groups(range(5)), groups(range(5, 10))
    compressed = []
    for side in (left, right):
        compressed.append({key: retained_witnesses(values, compile_core(values, n, key[1], f)) for key, values in side.items()})
    joined = {}
    for (a, ka), fa in compressed[0].items():
        for (b, kb), fb in compressed[1].items():
            if ka + kb <= r:
                key = (a ^ b, ka + kb)
                joined.setdefault(key, []).extend(Witness(x.support | y.support, x.cost + y.cost) for x in fa for y in fb)
    final = {key: retained_witnesses(values, compile_core(values, n, key[1], f)) for key, values in joined.items()}
    original = groups(range(n))
    composition_checks = 0
    for key, values in original.items():
        for failed in subsets(n, f):
            assert failure_optimum(values, failed) == failure_optimum(final[key], failed)
            composition_checks += 1
    results["label_and_degree_composition_comparisons"] = composition_checks

    packing_checks = 0
    for _ in range(20):
        n, r, demands, external = 7, 2, 2, 1
        budget = external + r * (demands - 1)
        families = [tuple(Witness(s, rng.randint(1, 25)) for s in subsets(n, r) if s and rng.random() < 0.6) for _ in range(demands)]
        portfolios = [retained_witnesses(fam, compile_core(fam, n, r, budget)) for fam in families]
        capacities = tuple(rng.randint(1, 2) for _ in range(n))
        def packing_value(fs, failed):
            return min((sum(w.cost for w in assignment) for assignment in product(*fs)
                        if all(not w.support & failed for w in assignment)
                        and all(sum(h in w.support for w in assignment) <= capacities[h] for h in range(n))), default=None)
        for failed in subsets(n, external):
            assert packing_value(families, failed) == packing_value(portfolios, failed)
            packing_checks += 1
    results["capacity_packing_comparisons"] = packing_checks

    n, r, f = 8, 2, 1
    family = tuple(Witness(frozenset(s), sum(s)) for s in combinations(range(n), r))
    kept = retained_witnesses(family, compile_core(family, n, r, f))
    assert {w.support for w in kept} == {frozenset(s) for s in combinations(range(3), 2)}
    dual_price = {0: 2}
    full_priced = min(w.cost + sum(dual_price.get(h, 0) for h in w.support) for w in family)
    compiled_priced = min(w.cost + sum(dual_price.get(h, 0) for h in w.support) for w in kept)
    assert full_priced == compiled_priced == 3
    for demands in (1, 3, 100):
        primal_value = 1 + 3 * (demands - 1)
        dual_bound = demands * compiled_priced - 2
        assert primal_value == dual_bound
    results["sparse_dual_example"] = {"raw_per_demand": len(family), "retained_per_demand": len(kept), "dual_support": 1, "optimum_for_100_demands": 298}
    assert min(w.cost + sum(5 + dual_price.get(h, 0) for h in w.support) for w in family) == 13
    assert min(w.cost + sum(5 + dual_price.get(h, 0) for h in w.support) for w in kept) == 13
    results["dense_price_modulo_cardinality"] = {"raw_price_support": n, "residual_support": 1, "priced_optimum": 13}

    n, r, f = 5, 2, 1
    family = tuple(Witness(frozenset(s), sum(0 if h < 3 else 100 for h in s)) for s in combinations(range(n), r))
    kept = retained_witnesses(family, compile_core(family, n, r, f))
    core = frozenset().union(*(w.support for w in kept))
    assert core == frozenset(range(3))
    epsilon = Fraction(1, 10)
    full_success = small_success = tail = Fraction(0)
    for failed in subsets(3):
        probability = epsilon**len(failed) * (1 - epsilon)**(3 - len(failed))
        full_success += probability * (failure_optimum(family, failed) is not None)
        small_success += probability * (failure_optimum(kept, failed) is not None)
        tail += probability * (len(failed) > f)
    assert full_success - small_success == tail == Fraction(7, 250)
    results["sharp_probability_bound"] = {"full_reliability": str(full_success), "catalog_reliability": str(small_success), "error_and_bound": str(tail)}

    family = tuple(Witness(frozenset(s), sum(s)) for s in combinations(range(7), 2))
    cert = compile_core(family, 7, 2, 1)
    d = cert.dependencies[0]
    i, a = d.coefficients[0]
    changed = tuple((j, (coefficient % (cert.prime - 1) + 1) if j == i else coefficient) for j, coefficient in d.coefficients)
    corrupted = replace(cert, dependencies=(replace(d, coefficients=changed), *cert.dependencies[1:]))
    mutations = [corrupted, replace(cert, prime=4), replace(cert, dependencies=cert.dependencies[1:]), replace(cert, retained=cert.retained + cert.retained[:1])]
    assert all(not verify_core(family, mutated) for mutated in mutations)
    # Inverting costs makes the previously cheaper dependency witnesses more expensive.
    inverted = tuple(Witness(w.support, -w.cost) for w in family)
    assert not verify_core(inverted, cert)
    results["rejected_certificate_mutations"] = 5
    results["status"] = "all assertions passed"
    return results


if __name__ == "__main__":
    results = run()
    text = json.dumps(results, indent=2)
    print(text)
    Path(__file__).with_name("test_results.json").write_text(text + "\n")
