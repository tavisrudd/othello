#!/usr/bin/env python3
"""C475 edge-torus atlas on the frozen C398 and Coxeter controls."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import tempfile
from collections import Counter
from pathlib import Path


STEM = "2026-07-22-c478-exceptional-family-controls"
SCHEMA = "c478-exceptional-family-controls-v1"
ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / f"{STEM}.json"
INPUT_STEMS = (
    "2026-07-20-c398-conic-deep-hole-classification",
    "2026-07-22-c474-reed-solomon-decorated-deep-holes",
    "2026-07-20-c399-coxeter-number-conic-phase",
    "2026-07-21-c465-mod3-weil-golay",
    "2026-07-22-c474-uniform-ext-carrier",
)
SUPPORT_PERMUTATIONS = tuple(itertools.permutations(range(6)))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(stem: str) -> dict[str, object]:
    return json.loads((ROOT / "notes" / f"{stem}.json").read_text())


def frozen_inputs() -> list[dict[str, object]]:
    paths = [ROOT / "notes" / f"{stem}.json" for stem in INPUT_STEMS]
    paths += [
        ROOT / "notes" / "2026-07-20-c398-conic-deep-hole-classification.py",
        ROOT / "notes" / "2026-07-22-c474-reed-solomon-decorated-deep-holes.py",
    ]
    return [
        {
            "path": str(path.relative_to(ROOT)),
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        }
        for path in paths
    ]


def atlas(module, field, support, syndrome, permutation=range(6)) -> tuple[int, ...]:
    points = tuple(support[index] for index in permutation)
    edges = {
        (i, j): module.det3(field, syndrome, points[i], points[j])
        for i, j in itertools.combinations(range(6), 2)
    }
    assert all(edges.values())
    answer = []
    for i, j, k, ell in itertools.combinations(range(6), 4):
        numerator = field.mul(edges[i, j], edges[k, ell])
        answer.append(field.mul(numerator, field.inverse(field.mul(edges[i, k], edges[j, ell]))))
        answer.append(field.mul(numerator, field.inverse(field.mul(edges[i, ell], edges[j, k]))))
    assert len(answer) == 30
    return tuple(answer)


def canonical_unlabelled_atlas(module, field, support, syndrome) -> tuple[int, ...]:
    candidates = []
    for permutation in SUPPORT_PERMUTATIONS:
        value = atlas(module, field, support, syndrome, permutation)
        for power in range(field.degree):
            candidates.append(tuple(field.frobenius(x, power) for x in value))
    return min(candidates)


def orbit_partition(points, transformations, apply) -> list[list[int]]:
    point_index = {point: index for index, point in enumerate(points)}
    unseen = set(range(len(points)))
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = sorted({point_index[apply(g, points[seed])] for g in transformations})
        unseen -= set(orbit)
        answer.append(orbit)
    return sorted(answer, key=lambda part: (len(part), part))


def atlas_partition(module, field, support, locus, transformations, apply) -> list[list[int]]:
    labelled = [atlas(module, field, support, point) for point in locus]
    unseen = set(range(len(locus)))
    answer = []
    while unseen:
        seed = min(unseen)
        transformed = {atlas(module, field, support, apply(g, locus[seed])) for g in transformations}
        part = sorted(index for index in unseen if labelled[index] in transformed)
        unseen -= set(part)
        answer.append(part)
    return sorted(answer, key=lambda part: (len(part), part))


def signature_digest(signature) -> str:
    payload = json.dumps(signature, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def rank_mod_prime(rows, prime: int) -> int:
    matrix = [[value % prime for value in row] for row in rows]
    rank = 0
    width = len(matrix[0]) if matrix else 0
    for column in range(width):
        pivot = next((i for i in range(rank, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(inverse * x) % prime for x in matrix[rank]]
        for i in range(len(matrix)):
            if i == rank or not matrix[i][column]:
                continue
            factor = matrix[i][column]
            matrix[i] = [(x - factor * y) % prime for x, y in zip(matrix[i], matrix[rank])]
        rank += 1
    return rank


def gram_rank(matrix, prime: int) -> int:
    gram = [
        [sum(x * y for x, y in zip(left, right)) for right in matrix]
        for left in matrix
    ]
    return rank_mod_prime(gram, prime)


def analyze_c398(module, companion, c398_data, c474_data) -> list[dict[str, object]]:
    companion_cases = {
        (case["q"], case["survivor_index"]): case
        for case in c474_data["cases"]
    }
    answer = []
    for field_record in c398_data["fields"]:
        for survivor_index, survivor in enumerate(field_record["survivors"]):
            q = field_record["q"]
            field = module.FiniteField(q)
            support = tuple(tuple(point) for point in survivor["arc"])
            locus = tuple(tuple(point) for point in survivor["locus"])
            full_locus_group = companion.locus_stabilizer(module, field, locus)
            apply = lambda transformation, point: companion.apply_semilinear(
                module, field, transformation, point
            )
            parent_group = tuple(
                transformation for transformation in full_locus_group
                if tuple(sorted(apply(transformation, point) for point in support)) == support
            )
            point_orbits = orbit_partition(locus, parent_group, apply)
            full_child_orbits = orbit_partition(locus, full_locus_group, apply)
            atlas_orbits = atlas_partition(module, field, support, locus, parent_group, apply)
            labelled_atlases = [atlas(module, field, support, point) for point in locus]

            parents = tuple(sorted({
                tuple(sorted(apply(transformation, point) for point in support))
                for transformation in full_locus_group
            }))
            parent_signatures = []
            for parent in parents:
                signature = tuple(
                    canonical_unlabelled_atlas(module, field, parent, point)
                    for point in locus
                )
                parent_signatures.append(signature)
            distinct_parent_signatures = set(parent_signatures)
            assert len(distinct_parent_signatures) == 1
            common_parent_signature = parent_signatures[0]
            unseen = set(range(len(locus)))
            unlabelled_value_partition = []
            while unseen:
                seed = min(unseen)
                part = sorted(
                    index for index in unseen
                    if common_parent_signature[index] == common_parent_signature[seed]
                )
                unseen -= set(part)
                unlabelled_value_partition.append(part)
            unlabelled_value_partition.sort(key=lambda part: (len(part), part))
            atlas_function_stabilizer_order = sum(
                all(
                    common_parent_signature[locus.index(apply(transformation, point))]
                    == common_parent_signature[index]
                    for index, point in enumerate(locus)
                )
                for transformation in full_locus_group
            )
            assert unlabelled_value_partition == full_child_orbits
            assert atlas_function_stabilizer_order == len(full_locus_group)

            companion_case = companion_cases[q, survivor_index]
            relation = companion_case["signature_overlap_relation"]
            modular = {"carrier_gate_entered": relation is not None}
            if relation is not None:
                modular |= {
                    "coefficient_prime": relation["coefficient_prime"],
                    "sheet_size": len(relation["parts"][0]),
                    "shared_rank": relation["shared_rank"],
                    "shared_gram_rank": relation["shared_gram_rank"],
                    "zero_share_rank": relation["zero_share_rank"],
                    "zero_share_gram_rank": relation["zero_share_gram_rank"],
                }
                if q == 9:
                    # The C3 action (012)(3) makes A4 the regular F3 C3-module.
                    modular |= {
                        "gram_gate_passes": False,
                        "sylow_group": "C3",
                        "sylow_endpoint_model": "regular F3[C3]",
                        "sylow_endomorphism_projectivity_gate_passes": False,
                        "stable_endpoint": "zero (projective)",
                        "modular_gateway_passes": False,
                    }
                else:
                    modular |= {
                        "gram_gate_passes": True,
                        "sylow_group": "C3",
                        "sylow_endpoint_model": "Omega(F3) plus free F3[C3]",
                        "sylow_endomorphism_projectivity_gate_passes": True,
                        "stable_endpoint": "endotrivial Picard unit",
                        "modular_gateway_passes": True,
                    }

            answer.append({
                "q": q,
                "survivor_index": survivor_index,
                "locus_size": len(locus),
                "parent_automorphism_order": len(parent_group),
                "projective_deep_hole_orbit_sizes": sorted(map(len, point_orbits)),
                "labelled_atlas_distinct_count": len(set(labelled_atlases)),
                "labelled_atlas_fibre_size_histogram": {
                    str(size): count
                    for size, count in sorted(Counter(Counter(labelled_atlases).values()).items())
                },
                "atlas_orbit_sizes": sorted(map(len, atlas_orbits)),
                "atlas_exactly_recovers_syndrome_orbits": atlas_orbits == point_orbits,
                "full_child_semilinear_stabilizer_order": len(full_locus_group),
                "full_child_point_orbit_sizes": sorted(map(len, full_child_orbits)),
                "fixed_child_parent_count": len(parents),
                "unlabelled_atlas_parent_signature_count": len(distinct_parent_signatures),
                "unlabelled_atlas_recovers_parent": len(distinct_parent_signatures) == len(parents),
                "common_unlabelled_atlas_parent_signature_sha256": signature_digest(common_parent_signature),
                "unlabelled_atlas_value_count": len(set(common_parent_signature)),
                "unlabelled_atlas_value_fibre_sizes": sorted(map(len, unlabelled_value_partition)),
                "unlabelled_atlas_exactly_recovers_full_child_point_orbits": (
                    unlabelled_value_partition == full_child_orbits
                ),
                "unlabelled_atlas_function_stabilizer_order": atlas_function_stabilizer_order,
                "unlabelled_atlas_function_is_full_child_invariant": (
                    atlas_function_stabilizer_order == len(full_locus_group)
                ),
                "deletion_trace_signature_count": companion_case["distinct_deletion_trace_signatures"],
                "deletion_trace_recovers_parent": companion_case["decoration_is_injective"],
                "modular_carrier": modular,
            })
    return answer


def analyze_coxeter(module, c399_data, c465_data, ext_data) -> list[dict[str, object]]:
    decorations = {
        row["type"]: row for row in c399_data["free_symmetry_completion_upgrade"]
    }
    c465_cases = {case["q"]: case for case in c465_data["cases"]}
    ext_cases = {case["q"]: case for case in ext_data["cases"]}
    types = (("A3", 5), ("B3", 7), ("H3", 11))
    answer = []
    for coxeter_type, q in types:
        field = module.FiniteField(q)
        points = module.projective_points(field)
        conic = tuple(
            point for point in points
            if not field.add(field.add(field.mul(point[0], point[0]), field.mul(point[1], point[1])),
                             field.mul(point[2], point[2]))
        )
        deep_locus = module.uncovered_locus(field, conic, points)
        decoration = decorations[coxeter_type]
        modular = {"carrier_gate_entered": coxeter_type != "A3"}
        if coxeter_type == "A3":
            modular |= {
                "reason_not_entered": "five decorations admit no equal two-sheet split",
                "gram_gate_passes": None,
                "sylow_endomorphism_projectivity_gate_passes": None,
                "modular_gateway_passes": False,
            }
        else:
            code_case = c465_cases[q]
            ext_case = ext_cases[q]
            prime = code_case["characteristic"]
            shared = code_case["relations"]["shared_edge"]["matrix"]
            disjoint = code_case["relations"]["disjoint"]["matrix"]
            mechanism = ext_case["local_detection"]["local_module_mechanism"]
            orbit_model = mechanism["orbit_category_endpoint_model"]
            modular |= {
                "coefficient_prime": prime,
                "sheet_size": q,
                "shared_rank": code_case["relations"]["shared_edge"]["rank"],
                "shared_gram_rank": gram_rank(shared, prime),
                "disjoint_rank": code_case["relations"]["disjoint"]["rank"],
                "disjoint_gram_rank": gram_rank(disjoint, prime),
                "orthogonal_flag": code_case["module_structure"]["orthogonal_flag"],
                "gram_gate_passes": gram_rank(shared, prime) == 0,
                "sylow_group": orbit_model["sylow_group"],
                "sylow_endpoint_model": orbit_model["endpoint"],
                "sylow_endomorphism_projectivity_gate_passes": mechanism["endpoint_is_endotrivial"],
                "stable_endpoint": mechanism["stable_endpoint_class"],
                "modular_gateway_passes": True,
            }
        answer.append({
            "type": coxeter_type,
            "q": q,
            "full_conic_size": len(conic),
            "full_conic_deep_syndrome_count": len(deep_locus),
            "c475_atlas_domain_is_empty": not deep_locus,
            "coxeter_decoration_count": decoration["conjugate_coxeter_decoration_count"],
            "bare_child_recovers_decoration": False,
            "modular_carrier": modular,
        })
    return answer


def generate() -> dict[str, object]:
    c398_module = load_module(
        "c398_for_c478", ROOT / "notes" / "2026-07-20-c398-conic-deep-hole-classification.py"
    )
    c474_module = load_module(
        "c474_for_c478", ROOT / "notes" / "2026-07-22-c474-reed-solomon-decorated-deep-holes.py"
    )
    c398_data = load_json(INPUT_STEMS[0])
    c474_data = load_json(INPUT_STEMS[1])
    c399_data = load_json(INPUT_STEMS[2])
    c465_data = load_json(INPUT_STEMS[3])
    ext_data = load_json(INPUT_STEMS[4])
    c398_cases = analyze_c398(c398_module, c474_module, c398_data, c474_data)
    coxeter_cases = analyze_coxeter(c398_module, c399_data, c465_data, ext_data)
    assert all(case["atlas_exactly_recovers_syndrome_orbits"] for case in c398_cases)
    assert all(not case["unlabelled_atlas_recovers_parent"] for case in c398_cases)
    assert all(case["c475_atlas_domain_is_empty"] for case in coxeter_cases)
    return {
        "schema": SCHEMA,
        "task": "C478",
        "frozen_inputs": frozen_inputs(),
        "atlas_definition": {
            "coordinates_per_syndrome": 30,
            "formula": "(d_ij*d_kl/(d_ik*d_jl), d_ij*d_kl/(d_il*d_jk)) for every i<j<k<l",
            "parent_comparison": "canonicalize over all six support relabellings and Frobenius powers",
        },
        "c398_non_grs_controls": c398_cases,
        "coxeter_conic_phase_controls": coxeter_cases,
        "sharp_negative": (
            "The edge-torus atlas recovers every frozen syndrome orbit but no fixed-child parent; "
            "the full-conic A3/B3/H3 children have no deep-syndrome atlas domain at all. "
            "Modular invertibility begins only after an independently supplied recovering matching decoration "
            "passes both the isotropic Gram and Sylow endomorphism-projectivity gates."
        ),
    }


def serialized() -> bytes:
    return (json.dumps(generate(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = serialized()
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / OUTPUT.name
            candidate.write_bytes(data)
            if not OUTPUT.exists() or OUTPUT.read_bytes() != candidate.read_bytes():
                raise SystemExit(f"stale certificate: {OUTPUT}")
        print("C478 primary check: exact certificate matches")
    else:
        OUTPUT.write_bytes(data)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
