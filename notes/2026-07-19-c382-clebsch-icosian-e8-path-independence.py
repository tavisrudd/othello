#!/usr/bin/env python3
"""Exact cheap-gate certificate for C382's marked D8/icosian comparison."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
import tempfile
from collections import Counter, deque
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-19-c382-clebsch-icosian-e8-path-independence.json"
C379_PATH = HERE / "2026-07-19-c379-clebsch-deep-hole-extension.py"
C379_SHA256 = "ca8024023173aaa09e0252780b8297ebac06bcc920115e3b9b808059d4b0d587"


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def load_c379():
    assert hashlib.sha256(C379_PATH.read_bytes()).hexdigest() == C379_SHA256
    spec = importlib.util.spec_from_file_location("c379_for_c382", C379_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(permutation):
    result = [0] * len(permutation)
    for i, value in enumerate(permutation):
        result[value] = i
    return tuple(result)


def permutation_order(permutation):
    power = tuple(range(len(permutation)))
    for order in range(1, 61):
        power = compose(permutation, power)
        if power == tuple(range(len(permutation))):
            return order
    raise AssertionError("order exceeds 60")


def parity(permutation):
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return inversions % 2


def a5_coset_character():
    group = tuple(p for p in itertools.permutations(range(5)) if parity(p) == 0)
    identity = tuple(range(5))
    rotation = (1, 2, 3, 4, 0)
    reflection = (0, 4, 3, 2, 1)
    subgroup = {identity}
    frontier = [rotation, reflection]
    while frontier:
        element = frontier.pop()
        if element in subgroup:
            continue
        subgroup.add(element)
        frontier.extend(compose(element, old) for old in tuple(subgroup))
        frontier.extend(compose(old, element) for old in tuple(subgroup))
    assert len(group) == 60 and len(subgroup) == 10
    unseen = set(group)
    cosets = []
    while unseen:
        representative = min(unseen)
        coset = frozenset(compose(representative, h) for h in subgroup)
        cosets.append(coset)
        unseen -= coset
    assert len(cosets) == 6
    character_by_order = {}
    for order in (1, 2, 3, 5):
        values = {
            sum(frozenset(compose(g, x) for x in coset) == coset for coset in cosets)
            for g in group
            if permutation_order(g) == order
        }
        assert len(values) == 1
        character_by_order[str(order)] = values.pop()
    return character_by_order


def d8_roots():
    roots = set()
    for i, j in itertools.combinations(range(8), 2):
        for left in (-1, 1):
            for right in (-1, 1):
                vector = [0] * 8
                vector[i], vector[j] = left, right
                roots.add(tuple(vector))
    assert len(roots) == 112
    return frozenset(roots)


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def apply_generator(vector, generator):
    kind, index = generator
    result = list(vector)
    if kind == "swap":
        result[index], result[index + 1] = result[index + 1], result[index]
    else:
        result[index] *= -1
        result[index + 1] *= -1
    return tuple(result)


def marked_a2_orbit(roots):
    pairs = frozenset(
        frozenset((left, right))
        for left in roots
        for right in roots
        if left < right and dot(left, right) == -1
    )
    generators = tuple(("swap", i) for i in range(7)) + (("flip", 0),)
    seed = min(pairs, key=lambda pair: tuple(sorted(pair)))
    orbit = {seed}
    queue = deque([seed])
    while queue:
        pair = queue.popleft()
        for generator in generators:
            image = frozenset(apply_generator(root, generator) for root in pair)
            assert image in pairs
            if image not in orbit:
                orbit.add(image)
                queue.append(image)
    assert orbit == pairs
    return len(pairs)


def quadratic_trace(pair):
    """Trace from Q(phi), phi^2=phi+1, for a+b*phi."""
    a, b = pair
    return 2 * a + b


def matched_fibre_character():
    geometry = load_c379()
    c341 = geometry.load_c341()
    parent = frozenset(geometry.normalize(point) for point in c341.six_points(11, 8))
    a5 = c341.projective_stabilizer_group(set(parent), 11)
    plane = geometry.projective_points(c341)
    conic = frozenset(point for point in plane if geometry.dot(point, point) == 0)
    pair = min(geometry.obstruction_matching(parent, conic), key=lambda item: tuple(sorted(item)))
    stabilizer = [matrix for matrix in a5 if geometry.image(matrix, pair) == pair]
    assert len(stabilizer) == 10

    def projective_order(matrix):
        power = geometry.I
        for result in range(1, 11):
            power = geometry.mat_normalize(geometry.mat_mul(power, matrix))
            if power == geometry.I:
                return result
        raise AssertionError("projective order exceeds D10")

    values = {}
    for order in (1, 2, 5):
        traces = {
            sum(
                geometry.normalize(geometry.mat_vec(matrix, point)) == point
                for point in parent | pair
            )
            for matrix in stabilizer
            if projective_order(matrix) == order
        }
        assert len(traces) == 1
        values[str(order)] = traces.pop()
    return values


def build_certificate():
    roots = d8_roots()
    marked_orbit = marked_a2_orbit(roots)
    wd8_order = (2**7) * 40320
    pair_character = a5_coset_character()
    fibre_character = matched_fibre_character()

    # Quaternion conjugation is 1 plus the 3D rotation character over Q(phi).
    conjugation_over_qphi = {
        "1": (4, 0),
        "2": (0, 0),
        "3": (1, 0),
        "5a": (1, 1),       # 1 + phi
        "5b": (2, -1),      # 1 + phi' = 2 - phi
    }
    icosian_character = {
        key: quadratic_trace(value) for key, value in conjugation_over_qphi.items()
    }
    picard_character = {
        "1": 2 + pair_character["1"],
        "2": 2 + pair_character["2"],
        "3": 2 + pair_character["3"],
        "5a": 2 + pair_character["5"],
        "5b": 2 + pair_character["5"],
    }
    assert icosian_character == {"1": 8, "2": 0, "3": 2, "5a": 3, "5b": 3}
    assert picard_character == {"1": 8, "2": 4, "3": 2, "5a": 3, "5b": 3}

    return {
        "schema": "c382-cheap-gate-v1",
        "marked_d8": {
            "root_count": len(roots),
            "ambient_e8_root_count": len(roots) + 128,
            "index_in_e8": 2,
            "quotient": "C2",
            "discriminant_classes": ["0", "vector", "spinor", "cospinor"],
            "e8_glue_class": "spinor",
            "ambient_normalizer": "W(D8)",
            "ambient_normalizer_order": wd8_order,
            "ambient_normalizer_index_in_w_e8": 135,
            "centralizer_of_w_d8_in_w_e8": ["+I", "-I"],
            "centralizer_order": 2,
            "unordered_a2_marking_orbit_count": 1,
            "unordered_a2_marking_orbit_size": marked_orbit,
            "unordered_a2_marking_stabilizer_order": wd8_order // marked_orbit,
            "action_on_e8_mod_d8": "trivial",
        },
        "c381_family": {
            "matched_base_orbit": "A5/D10",
            "matched_base_orbit_size": 6,
            "single_fibre_stabilizer": "D10",
            "single_fibre_has_a5_action": False,
            "single_fibre_d10_rational_character_by_order": fibre_character,
            "a5_pair_character_by_order": pair_character,
        },
        "icosian_actions": {
            "left_multiplication": {
                "acting_group": "2.A5",
                "central_minus_one_action": "-I",
                "descends_to_a5": False,
            },
            "conjugation": {
                "acting_group": "A5",
                "rational_character_by_class": icosian_character,
                "rational_decomposition": "2*1 + 3 + 3'",
                "restricted_d10_character_by_order": {"1": 8, "2": 0, "5": 3},
            },
        },
        "forced_fixed_child_trivialization": {
            "description": "permute six parent exceptional classes and fix H,E7,E8",
            "rational_e8_character_by_class": picard_character,
            "rational_decomposition": "3*1 + 5",
            "preserves_geometric_marked_family": False,
            "first_character_mismatch_class": "2",
        },
        "gate": {
            "verdict": "RED_CATEGORY_MISMATCH",
            "failed_step": 2,
            "reason": "C381 has an A5-equivariant six-fibre family with D10 fibre stabilizer; the natural icosian linear action is 2.A5, and descended conjugation already has a different involution trace after restriction to the legitimate D10 fibre action.",
            "full_isometry_search_authorized": False,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} ({len(payload)} bytes)")
        return
    assert OUTPUT.read_bytes() == payload
    with tempfile.TemporaryDirectory() as directory:
        candidate = Path(directory) / OUTPUT.name
        candidate.write_bytes(payload)
        assert candidate.read_bytes() == OUTPUT.read_bytes()
    print("C382 primary check: exact certificate matches tracked JSON")


if __name__ == "__main__":
    main()
