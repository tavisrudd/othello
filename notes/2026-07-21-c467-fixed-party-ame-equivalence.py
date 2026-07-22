#!/usr/bin/env python3
"""Exact C467 fixed-party LC and LU-invariant checker."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "notes/2026-07-21-c467-fixed-party-ame-equivalence.json"
INPUTS = {
    "notes/2026-07-19-c374-clebsch-ame-equivalence.py":
        "15a99411b06f46f07e9b77a8593541031d98b4353fa0d9076d8452e2484ca694",
    "notes/2026-07-19-c374-clebsch-ame-equivalence.json":
        "b3ecefac292797375ec7849480cd003039bf6e56219f61a117e39f575898405d",
    "notes/2026-07-19-c384-clebsch-ame-family-classification.py":
        "14fcefef44a8a4dd1979a4c4a544de5eb7ca543dd58abfc046b38635d9aa2046",
    "notes/2026-07-19-c384-clebsch-ame-family-classification.json":
        "6f9eae589da917d51bab6129648c96c5e4d57995ac7b44bf1c68685e002ba2b0",
    "notes/2026-07-21-c456-ame-chirality.py":
        "34b7ba678e576dea10f790a2fb7c62920a22c5ab16b05cc1040575592578f260",
    "notes/2026-07-21-c456-ame-chirality.json":
        "74fdbce454d4090cf6e6af46a50d107c55d1bfe34dbc5647d6b06164d7f93de3",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_module(relative: str, name: str):
    path = ROOT / relative
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise AssertionError(f"cannot load {relative}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def fixed_party_lc(c374, source, target) -> dict[str, object]:
    source_data = c374.minimal_support_data(source)
    target_data = c374.minimal_support_data(target)
    source_space = c374.stabilizer_space(source)
    target_space = c374.stabilizer_space(target)
    identity = tuple(range(c374.N))
    supports_by_pair = {
        (a, b): next(s for s in sorted(source_data) if a in s and b in s)
        for a in range(c374.N)
        for b in range(a + 1, c374.N)
    }
    candidates = []
    relation_consistent = 0
    determinant_failures = 0
    relation_failures = 0
    for anchor in c374.sl2():
        local = [((1, 0), (0, 1)) for _ in range(c374.N)]
        local[0] = anchor
        valid = True
        for b in range(1, c374.N):
            support = supports_by_pair[(0, b)]
            source_rel = c374.relation(source_data, support, 0, b)
            target_rel = c374.relation(target_data, support, 0, b)
            local[b] = c374.m2_mul(c374.m2_mul(target_rel, anchor), c374.m2_inv(source_rel))
            if c374.m2_det(local[b]) != 1:
                determinant_failures += 1
                valid = False
                break
        if not valid:
            continue
        for support in sorted(source_data):
            a = support[0]
            for b in support[1:]:
                lhs = c374.m2_mul(local[b], c374.relation(source_data, support, a, b))
                rhs = c374.m2_mul(c374.relation(target_data, support, a, b), local[a])
                if lhs != rhs:
                    relation_failures += 1
                    valid = False
                    break
            if not valid:
                break
        if not valid:
            continue
        relation_consistent += 1
        local_tuple = tuple(local)
        if c374.transform_stabilizer(source_space, identity, local_tuple) != target_space:
            raise AssertionError("support-consistent blocks fail full stabilizer equality")
        candidates.append([[list(row) for row in block] for block in local_tuple])
    return {
        "party_permutation": list(identity),
        "sl2_anchor_blocks_checked": len(c374.sl2()),
        "determinant_failure_anchors": determinant_failures,
        "relation_failure_anchors": relation_failures,
        "relation_consistent_candidates": relation_consistent,
        "fixed_party_lc_equivalent": bool(candidates),
        "local_symplectic_solutions": candidates,
        "complete_reason": (
            "For each anchor in SL(2,11), the minimal-support projections force the other five "
            "local blocks; every support relation and then the full stabilizer rowspace are checked."
        ),
    }


def exact_fourier_maps(c374, c456, source, target, lc_result) -> dict[str, object]:
    source_dual_words = c456.codewords(c374.dual(source))
    target_words = c456.codewords(target)
    base_signs = (10, 10, 10, 10, 1, 1)
    transported = {
        tuple(base_signs[index] * word[index] % 11 for index in range(6))
        for word in source_dual_words
    }
    if transported != target_words:
        raise AssertionError("signed Fourier support is not the target code")

    expected_solutions = []
    parameters = []
    for a in range(1, 11):
        inverse_a = pow(a, 9, 11)
        first = ((0, a), ((-inverse_a) % 11, 0))
        last = ((0, (-a) % 11), (inverse_a, 0))
        signs = ((-inverse_a) % 11,) * 4 + (inverse_a,) * 2
        if {
            tuple(signs[index] * word[index] % 11 for index in range(6))
            for word in source_dual_words
        } != target_words:
            raise AssertionError("a signed Fourier family member misses the target support")
        expected_solutions.append([[list(row) for row in block] for block in (first,) * 4 + (last,) * 2])
        parameters.append({
            "a": a,
            "first_four_fourier_kernel_sign": (-inverse_a) % 11,
            "last_two_fourier_kernel_sign": inverse_a,
        })
    if lc_result["local_symplectic_solutions"] != expected_solutions:
        raise AssertionError("forced LC solutions are not exactly the signed Fourier family")

    return {
        "fourier_convention": "F_s|x> = 11^(-1/2) sum_y omega^(s*x*y)|y>",
        "representative_kernel_signs": list(base_signs),
        "representative_exact_map": "(F_-1)^tensor4 tensor (F_+1)^tensor2 maps |Psi_8> to |Psi_4>",
        "support_identity": "diag(-1,-1,-1,-1,+1,+1) C_8^perp = C_4",
        "source_dual_words_checked": len(source_dual_words),
        "target_words_checked": len(target_words),
        "support_sets_equal": True,
        "all_ten_support_sets_equal": True,
        "nonzero_amplitude": "11^-3/2",
        "global_phase": 1,
        "all_ten_maps": parameters,
    }


def golden_symbolic_duality() -> dict[str, object]:
    def integer_h(t: int) -> tuple[tuple[int, ...], ...]:
        return (
            (0, 0, 1, 1, 1, 1),
            (1, 1, 1 - t, t - 1, 0, 0),
            (1 - t, t - 1, 0, 0, -t, t),
        )

    def product(t: int) -> tuple[tuple[int, ...], ...]:
        left = integer_h(1 - t)
        right = integer_h(t)
        signs = (-1, -1, -1, -1, 1, 1)
        return tuple(
            tuple(sum(left[i][k] * signs[k] * right[j][k] for k in range(6)) for j in range(3))
            for i in range(3)
        )

    coefficient_matrix = []
    values = [product(t) for t in (0, 1, 2)]
    for i in range(3):
        row = []
        for j in range(3):
            value0, value1, value2 = (values[t][i][j] for t in range(3))
            coefficients = (
                value0,
                (-3 * value0 + 4 * value1 - value2) // 2,
                (value2 - 2 * value1 + value0) // 2,
            )
            row.append(coefficients)
        coefficient_matrix.append(row)
    expected = [[(0, 0, 0) for _ in range(3)] for _ in range(3)]
    expected[1][1] = (-2, -2, 2)
    if coefficient_matrix != expected:
        raise AssertionError("symbolic golden-duality matrix changed")
    for t in range(-5, 6):
        target = [[0] * 3 for _ in range(3)]
        target[1][1] = 2 * (t * t - t - 1)
        if product(t) != tuple(tuple(row) for row in target):
            raise AssertionError("symbolic identity replay failed")
    return {
        "integer_identity": "H_(1-t) diag(-1,-1,-1,-1,+1,+1) H_t^T = diag(0,2(t^2-t-1),0)",
        "polynomial_coefficient_order": ["1", "t", "t^2"],
        "coefficient_matrix": coefficient_matrix,
        "consequence": "For t^2-t-1=0 and rank(H_t)=rank(H_(1-t))=3, signed(C_t^perp)=C_(1-t).",
        "golden_arc_factor_reductions": ["t", "t-1", "2", "2(1-t)"],
        "odd_field_rank_and_arc_boundary": "All four factors are nonzero for a golden root in odd characteristic, so both parity checks have rank 3 and define six-arcs.",
        "odd_finite_field_quantum_consequence": "The signed local Fourier transform exchanges the two golden-conjugate equal-phase CSS states over every odd finite-field realization.",
        "characteristic_5_boundary": "The roots coalesce, so the same formula becomes signed Fourier self-duality.",
    }


def full_q11_pencil_classification(c374, c456) -> dict[str, object]:
    parameters = (2, 3, 4, 6, 7, 8, 10)
    codes = {t: c456.kernel_generator(t) for t in parameters}
    lc_counts = [
        [fixed_party_lc(c374, codes[left], codes[right])["relation_consistent_candidates"]
         for right in parameters]
        for left in parameters
    ]
    lc_classes = []
    unseen = set(parameters)
    while unseen:
        representative = min(unseen)
        index = parameters.index(representative)
        block = tuple(t for t, count in zip(parameters, lc_counts[index]) if count)
        lc_classes.append(block)
        unseen.difference_update(block)

    ranks = {t: c456.indexed_moment_ranks(c456.shortenings(codes[t])) for t in parameters}
    ambient = {t: c456.indexed_moment_ranks(c456.ambient_shortenings(codes[t])) for t in parameters}
    if ranks != ambient:
        raise AssertionError("full-pencil ambient moment replay disagrees")
    moment_classes = []
    unseen = set(parameters)
    while unseen:
        representative = min(unseen)
        block = tuple(t for t in parameters if ranks[t] == ranks[representative])
        moment_classes.append(block)
        unseen.difference_update(block)
    expected = [(2, 6), (3, 4, 7, 8), (10,)]
    if lc_classes != expected or moment_classes != expected:
        raise AssertionError("unexpected fixed-party pencil partition")

    witnesses = []
    for left, right in ((2, 3), (2, 10), (3, 10)):
        triple = next(key for key in ranks[left] if ranks[left][key] != ranks[right][key])
        witnesses.append({
            "parameters": [left, right],
            "omitted_party_pairs": triple,
            "ranks": [ranks[left][triple], ranks[right][triple]],
            "moments": [f"11^-{ranks[left][triple]}", f"11^-{ranks[right][triple]}"],
        })
    representatives = (2, 3, 10)
    return {
        "admitted_parameters": parameters,
        "fixed_party_lc_solution_count_matrix": lc_counts,
        "fixed_party_lc_classes": lc_classes,
        "indexed_degree_six_moment_classes": moment_classes,
        "class_representative_rank_vectors": {
            str(t): list(ranks[t].values()) for t in representatives
        },
        "pairwise_separating_witnesses": witnesses,
        "independent_ambient_replay": True,
        "fixed_party_lu_class_count": 3,
        "classification_reason": "Within each block an exact fixed-party Clifford exists; across blocks an indexed degree-six marginal moment differs.",
        "lowest_possible_separating_total_degree": 6,
        "lower_degree_reason": "Degree 2 is normalization; every degree-4 pure-state contraction is a marginal purity, fixed for AME(6,11) by maximal mixing and complementarity.",
        "comparison_with_party_permutations": "C384's two LU classes become three when party labels are fixed: its six-parameter class splits into the first two blocks, while {10} stays separate.",
    }


def build_certificate() -> dict[str, object]:
    for relative, expected in INPUTS.items():
        if digest(ROOT / relative) != expected:
            raise AssertionError(f"input hash mismatch: {relative}")
    c374 = load_module("notes/2026-07-19-c374-clebsch-ame-equivalence.py", "c467_c374")
    c456 = load_module("notes/2026-07-21-c456-ame-chirality.py", "c467_c456")
    source = c456.kernel_generator(8)
    target = c456.kernel_generator(4)
    lc_result = fixed_party_lc(c374, source, target)
    fourier_result = exact_fourier_maps(c374, c456, source, target, lc_result)
    return {
        "schema": "c467-fixed-party-ame-equivalence-v1",
        "field_order": 11,
        "input_sha256": INPUTS,
        "state_parameters": [8, 4],
        "fixed_party_local_clifford": lc_result,
        "exact_state_map": fourier_result,
        "golden_family_mechanism": golden_symbolic_duality(),
        "full_q11_pencil_fixed_party_classification": full_q11_pencil_classification(c374, c456),
        "degree_eight_lu_contractions": {
            "copy_count": 4,
            "amplitude_bidegree": [4, 4],
            "total_degree": 8,
            "raw_indexed_contraction_count": 24 ** 6,
            "gauge_fixed_contraction_count": 24 ** 5,
            "comparison": "all equal",
            "reason": "The exhibited fixed-party local Clifford is a fixed-party local unitary, so every indexed LU contraction is invariant term-by-term.",
            "stronger_statement": "Every fixed-party LU invariant at every degree agrees.",
        },
        "verdict": {
            "fixed_party_lc_equivalent": True,
            "fixed_party_lu_equivalent": True,
            "labeled_quantum_chirality_survives": False,
            "ordered_geometric_chirality_requires_external_advice": True,
            "automorphism_rigidity_route_needed": False,
        },
    }


def encoded(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument("--probe", action="store_true")
    modes.add_argument("--write", action="store_true")
    modes.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    if args.probe:
        print(json.dumps(certificate["fixed_party_local_clifford"], sort_keys=True))
        return
    payload = encoded(certificate)
    if args.write:
        OUTPUT.write_bytes(payload)
    elif OUTPUT.read_bytes() != payload:
        raise SystemExit("tracked certificate differs from exact regeneration")
    print("C467 certificate OK")


if __name__ == "__main__":
    main()
