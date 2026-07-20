#!/usr/bin/env python3
"""Primary exact checker for C381's 22 x 66 marked eight-point domain."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import tempfile
from collections import Counter, defaultdict, deque
from pathlib import Path

Q = 11
ROOT = Path(__file__).resolve().parent.parent
C379_PATH = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.py"
C379_JSON = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.json"
OUTPUT = ROOT / "notes/2026-07-19-c381-clebsch-e8-extension-obstruction.json"
C379_SHA256 = "ca8024023173aaa09e0252780b8297ebac06bcc920115e3b9b808059d4b0d587"


def load_c379():
    assert hashlib.sha256(C379_PATH.read_bytes()).hexdigest() == C379_SHA256
    spec = importlib.util.spec_from_file_location("c379", C379_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def monomials3(point):
    x, y, z = point
    return (
        x**3, x * x * y, x * x * z, x * y * y, x * y * z,
        x * z * z, y**3, y * y * z, y * z * z, z**3,
    )


def cubic_derivatives(point):
    x, y, z = point
    return (
        (3*x*x, 2*x*y, 2*x*z, y*y, y*z, z*z, 0, 0, 0, 0),
        (0, x*x, 0, 2*x*y, x*z, 0, 3*y*y, 2*y*z, z*z, 0),
        (0, 0, x*x, 0, x*y, 2*x*z, 0, y*y, 2*y*z, 3*z*z),
    )


def root_intersection(left, right):
    return left[0] * right[0] - sum(a * b for a, b in zip(left[1:], right[1:]))


def vector_rank(rows):
    # C379's finite-field rref is unsuitable for integral root-lattice rank.
    from fractions import Fraction
    work = [[Fraction(value) for value in row] for row in rows]
    rank = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next((i for i in range(rank, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = work[rank][column]
        work[rank] = [value / scale for value in work[rank]]
        for i in range(len(work)):
            if i != rank and work[i][column]:
                scale = work[i][column]
                work[i] = [a - scale * b for a, b in zip(work[i], work[rank])]
        rank += 1
    return rank


def standard_roots():
    roots = set()
    for i, j in itertools.permutations(range(8), 2):
        vector = [0] * 9
        vector[1 + i], vector[1 + j] = 1, -1
        roots.add(tuple(vector))
    for triple in itertools.combinations(range(8), 3):
        vector = [1] + [0] * 8
        for i in triple:
            vector[1 + i] = 1
        roots.add(tuple(vector)); roots.add(tuple(-x for x in vector))
    for six in itertools.combinations(range(8), 6):
        vector = [2] + [0] * 8
        for i in six:
            vector[1 + i] = 1
        roots.add(tuple(vector)); roots.add(tuple(-x for x in vector))
    for i in range(8):
        vector = [3] + [1] * 8
        vector[1 + i] = 2
        roots.add(tuple(vector)); roots.add(tuple(-x for x in vector))
    assert len(roots) == 240
    assert all(root_intersection(root, root) == -2 for root in roots)
    return frozenset(roots)


E8_ROOTS = standard_roots()


def root_closure(generators):
    generated = set(generators) | {tuple(-x for x in root) for root in generators}
    changed = True
    while changed:
        changed = False
        for root in tuple(generated):
            for alpha in tuple(generated):
                # Reflection in alpha for alpha^2=-2: s_alpha(root)=root+(root.alpha)alpha.
                image = tuple(x + root_intersection(root, alpha) * y for x, y in zip(root, alpha))
                if image in E8_ROOTS and image not in generated:
                    generated.add(image)
                    changed = True
    return frozenset(generated)


def dynkin_type(roots):
    if not roots:
        return "empty"
    unseen = set(roots)
    components = []
    while unseen:
        seed = min(unseen)
        component = {seed}
        queue = deque([seed])
        unseen.remove(seed)
        while queue:
            root = queue.popleft()
            adjacent = {other for other in unseen if root_intersection(root, other) != 0}
            unseen -= adjacent
            component |= adjacent
            queue.extend(adjacent)
        rank = vector_rank(list(component))
        count = len(component)
        candidates = {n * (n + 1): f"A{n}" for n in range(1, 9)}
        candidates.update({2 * n * (n - 1): f"D{n}" for n in range(4, 9)})
        candidates.update({72: "E6", 126: "E7", 240: "E8"})
        name = candidates.get(count)
        assert name is not None, (rank, count)
        assert int(name[1:]) == rank
        components.append(name)
    return "+".join(sorted(components))


def direct_effective_roots(c379, points):
    line_roots = []
    for triple in itertools.combinations(range(8), 3):
        if c379.determinant([points[i] for i in triple]) == 0:
            vector = [1] + [0] * 8
            for i in triple: vector[1 + i] = 1
            line_roots.append(tuple(vector))
    conic_roots = []
    for six in itertools.combinations(range(8), 6):
        if c379.rank([c379.conic_row(points[i]) for i in six]) < 6:
            vector = [2] + [0] * 8
            for i in six: vector[1 + i] = 1
            conic_roots.append(tuple(vector))
    cubic_roots = []
    value_rows = [[value % Q for value in monomials3(point)] for point in points]
    for singular in range(8):
        rows = value_rows + [[value % Q for value in row] for row in cubic_derivatives(points[singular])]
        if c379.rank(rows) < 10:
            vector = [3] + [1] * 8
            vector[1 + singular] = 2
            cubic_roots.append(tuple(vector))
    roots = line_roots + conic_roots + cubic_roots
    assert len(roots) == len(set(roots))
    return line_roots, conic_roots, cubic_roots


def has_four_collinear(c379, points):
    return any(c379.rank([points[i] for i in subset]) < 3 for subset in itertools.combinations(range(8), 4))


def seven_point_conics(c379, points):
    return [subset for subset in itertools.combinations(range(8), 7)
            if c379.rank([c379.conic_row(points[i]) for i in subset]) < 6]


def orbit(group, c379, parent, pair):
    return frozenset(
        (c379.image(matrix, parent), frozenset(c379.normalize(c379.mat_vec(matrix, p)) for p in pair))
        for matrix in group
    )


def pair_orbit(group, c379, pair):
    return frozenset(
        frozenset(c379.normalize(c379.mat_vec(matrix, point)) for point in pair)
        for matrix in group
    )


def certificate():
    c379 = load_c379()
    pinned = json.loads(C379_JSON.read_text())
    assert pinned["schema"] == "othello.c379.clebsch_deep_hole_extension.v2"
    c341 = c379.load_c341()
    plane = c379.projective_points(c341)
    conic = frozenset(point for point in plane if c379.dot(point, point) == 0)
    plus = frozenset(c379.normalize(point) for point in c341.six_points(Q, 8))
    roots = c341.h3_roots(Q, 8)
    a5 = {c379.mat_normalize(matrix) for matrix in c341.reflection_group(Q, roots)}
    pgl = c379.closure(list(a5) + [c379.J])
    psl = c379.closure(list(a5) + list(c379.conjugate(c379.J, a5)))
    parents = frozenset(c379.image(matrix, plus) for matrix in pgl)
    assert (len(conic), len(a5), len(psl), len(pgl), len(parents)) == (12, 60, 660, 1320, 22)
    matchings = {parent: c379.obstruction_matching(parent, conic) for parent in parents}

    marked = frozenset((parent, frozenset(pair)) for parent in parents for pair in itertools.combinations(conic, 2))
    unseen = set(marked)
    orbit_records = []
    configurations = {}
    while unseen:
        representative = min(unseen, key=lambda item: (tuple(sorted(item[0])), tuple(sorted(item[1]))))
        current_orbit = orbit(pgl, c379, *representative)
        unseen -= current_orbit
        orbit_records.append((representative, current_orbit))
    assert sum(map(lambda item: len(item[1]), orbit_records)) == 1452

    for parent, pair in sorted(marked, key=lambda item: (tuple(sorted(item[0])), tuple(sorted(item[1])))):
        parent_points = sorted(parent)
        child_points = sorted(pair)
        points = parent_points + child_points
        line_roots, conic_roots, cubic_roots = direct_effective_roots(c379, points)
        effective = frozenset(line_roots + conic_roots + cubic_roots)
        closure_roots = root_closure(effective)
        seven_conics = seven_point_conics(c379, points)
        matched = pair in matchings[parent]

        inherited = []
        for child_index in (6, 7):
            candidates = [root for root in conic_roots if root[1 + child_index] == 1 and sum(root[1:7]) == 5]
            assert len(candidates) == 1
            inherited.append(candidates[0])
        inherited_intersection = root_intersection(*inherited)
        assert matched == (inherited_intersection == -1)
        assert (not matched) == (inherited_intersection == 0)
        inherited_closure = root_closure(inherited)
        assert dynkin_type(inherited_closure) == ("A2" if matched else "A1+A1")

        four_line = has_four_collinear(c379, points)
        weak = not four_line and not seven_conics
        eight_arc = not line_roots
        record = {
            "eight_arc": eight_arc,
            "mds_parameters": [[8, 5, 4], [8, 3, 6]] if eight_arc else None,
            "matched_pair": matched,
            "inherited_root_intersection": inherited_intersection,
            "inherited_root_type": dynkin_type(inherited_closure),
            "direct_effective_root_counts": {
                "line": len(line_roots), "conic": len(conic_roots), "singular_cubic": len(cubic_roots),
            },
            "direct_effective_root_count": len(effective),
            "generated_root_count": len(closure_roots),
            "generated_root_type": dynkin_type(closure_roots),
            "has_four_collinear": four_line,
            "seven_point_conic_count": len(seven_conics),
            "weak_del_pezzo": weak,
            "geometry": "weak_degree_one" if weak else "worse_than_weak_degree_one_blowup",
        }
        key = (parent, pair)
        configurations[key] = record

    # Every full-group orbit is homogeneous for the complete classification record.
    serialized_orbits = []
    for orbit_index, (representative, current_orbit) in enumerate(sorted(orbit_records, key=lambda x: (len(x[1]), tuple(sorted(x[0][0])), tuple(sorted(x[0][1]))))):
        spectra = {json.dumps(configurations[item], sort_keys=True) for item in current_orbit}
        assert len(spectra) == 1
        parent, pair = representative
        stabilizer = len(pgl) // len(current_orbit)
        serialized_orbits.append({
            "orbit": orbit_index,
            "size": len(current_orbit),
            "stabilizer_order": stabilizer,
            "representative_parent": [list(point) for point in sorted(parent)],
            "representative_pair": [list(point) for point in sorted(pair)],
            "classification": configurations[representative],
        })

    class_counter = Counter(json.dumps(record, sort_keys=True) for record in configurations.values())
    classification = [
        {"count": count, "properties": json.loads(properties)}
        for properties, count in sorted(class_counter.items())
    ]
    assert sum(item["count"] for item in classification) == 1452
    assert sum(item["count"] for item in classification if item["properties"]["matched_pair"]) == 132

    # The same three classes are the three A5-orbits on pairs for a fixed parent.
    unseen_pairs = {frozenset(pair) for pair in itertools.combinations(conic, 2)}
    a5_pair_orbits = []
    while unseen_pairs:
        representative = min(unseen_pairs, key=lambda pair: tuple(sorted(pair)))
        current = pair_orbit(a5, c379, representative)
        unseen_pairs -= current
        a5_pair_orbits.append({
            "size": len(current),
            "stabilizer_order": len(a5) // len(current),
            "representative_pair": [list(point) for point in sorted(representative)],
            "classification": configurations[(plus, representative)],
        })
    assert sorted(item["size"] for item in a5_pair_orbits) == [6, 30, 30]

    # PSL preserves the two 11-parent sheets, so each PGL orbit splits in two; J exchanges the halves.
    unseen_psl = set(marked)
    psl_orbits = []
    while unseen_psl:
        representative = min(unseen_psl, key=lambda item: (tuple(sorted(item[0])), tuple(sorted(item[1]))))
        current = orbit(psl, c379, *representative)
        unseen_psl -= current
        psl_orbits.append({
            "size": len(current),
            "stabilizer_order": len(psl) // len(current),
            "classification": configurations[representative],
        })
    assert sorted(item["size"] for item in psl_orbits) == [66, 66, 330, 330, 330, 330]

    return {
        "schema": "c381-clebsch-e8-extension-obstruction-v1",
        "field": Q,
        "trusted_input": {
            "c379_primary_sha256": C379_SHA256,
            "c379_schema": pinned["schema"],
        },
        "domain": {"parent_count": 22, "pairs_per_parent": 66, "marked_configuration_count": 1452},
        "abstract_e8_root_count": len(E8_ROOTS),
        "full_group_orbit_count": len(serialized_orbits),
        "full_group_orbits": serialized_orbits,
        "fixed_parent_a5_pair_orbits": sorted(a5_pair_orbits, key=lambda item: (item["size"], json.dumps(item["classification"], sort_keys=True))),
        "psl_marked_orbits": sorted(psl_orbits, key=lambda item: (item["size"], json.dumps(item["classification"], sort_keys=True))),
        "classification_spectrum": classification,
        "matching_recovery": {
            "criterion": "the two inherited conic-root classes have intersection -1",
            "matched_configuration_count": 132,
            "unmatched_configuration_count": 1320,
            "matched_inherited_type": "A2",
            "unmatched_inherited_type": "A1+A1",
            "uses_original_matching_input": False,
        },
        "information_lattice": {
            "parent_levels": [22, 2, 1],
            "groups": ["A5 parent stabilizer", "PSL2(11)", "PGL2(11)"],
            "golden_J_exchanges_psl_sheets": True,
            "root_classification_is_sheet_independent": True,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(certificate())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.relative_to(ROOT)} ({len(payload)} bytes)")
    else:
        with tempfile.TemporaryDirectory(prefix="c381-check-", dir="/home/tavis") as directory:
            candidate = Path(directory) / OUTPUT.name
            candidate.write_bytes(payload)
            assert OUTPUT.read_bytes() == candidate.read_bytes()
        print(f"checked {OUTPUT.relative_to(ROOT)} ({len(payload)} bytes)")


if __name__ == "__main__":
    main()
