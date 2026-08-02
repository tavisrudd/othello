#!/usr/bin/env python3
"""Verify the paper-local evidence certificate and replay inputs."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import re
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PAPER_ROOT = HERE.parent
EVIDENCE = HERE / "evidence"
CERTIFICATE = HERE / "evidence_certificate.json"
MANIFEST = HERE / "evidence_manifest.json"

SOURCES = {
    "anomaly_inverse": EVIDENCE / "anomaly_inverse",
    "boson_fermion_complement": EVIDENCE / "boson_fermion_complement",
    "six_mode_demonstrator": EVIDENCE / "six_mode_demonstrator",
}

INTERNAL_ID = re.compile(r"(?<![A-Za-z0-9])[Cc][0-9]{2,}(?![A-Za-z0-9])")
PRIVATE_PATH = re.compile(r"notes/20[0-9]{2}-[0-9]{2}-[0-9]{2}-c[0-9]+")
TEXT_SUFFIXES = {".json", ".md", ".py", ".tex"}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_public_hygiene() -> None:
    for path in sorted(PAPER_ROOT.rglob("*")):
        relative_path = path.relative_to(PAPER_ROOT)
        if any(part in {".venv", "__pycache__"} for part in relative_path.parts):
            continue
        relative = str(relative_path)
        assert not INTERNAL_ID.search(relative), f"internal identifier in filename: {relative}"
        if (not path.is_file() or path.name == "uv.lock"
                or (path.name != "Makefile" and path.suffix not in TEXT_SUFFIXES)):
            continue
        text = path.read_text(encoding="utf-8")
        assert not INTERNAL_ID.search(text), f"internal identifier in public file: {relative}"
        assert not PRIVATE_PATH.search(text), f"private source path in public file: {relative}"


def source_record(stem: Path) -> dict[str, dict[str, int | str]]:
    checked = {}
    for path in (stem.with_suffix(".py"), stem.parent / f"{stem.name}_replay.py",
                 stem.with_suffix(".json")):
        payload = path.read_bytes()
        checked[str(path.relative_to(PAPER_ROOT))] = {
            "bytes": len(payload),
            "sha256": hashlib.sha256(payload).hexdigest(),
        }
    return checked


def load_json(stem: Path) -> dict:
    return json.loads(stem.with_suffix(".json").read_text(encoding="utf-8"))


def h3(values: tuple[Fraction, ...]) -> Fraction:
    total = Fraction(0)
    for indices in itertools.combinations_with_replacement(range(len(values)), 3):
        total += math.prod(values[index] for index in indices)
    return total


def pairwise_distances(words: list[list[int]]) -> list[int]:
    return sorted(
        sum(left != right for left, right in zip(a, b))
        for a, b in itertools.combinations(words, 2)
    )


def identity(size: int) -> list[list[float]]:
    return [[float(row == column) for column in range(size)] for row in range(size)]


def mm(left: list[list[float]], right: list[list[float]]) -> list[list[float]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def givens_matrix(size: int, a: int, b: int, theta: float) -> list[list[float]]:
    result = identity(size)
    cosine, sine = math.cos(theta), math.sin(theta)
    result[a][a] = cosine
    result[a][b] = sine
    result[b][a] = -sine
    result[b][b] = cosine
    return result


def network_error(network: dict, decimal_places: int | None = None) -> float:
    target = network["base_O_numeric"]
    size = len(target)
    signs = network["base_O_input_phase_signs"]
    reconstruction = [
        [float(signs[i] if i == j else 0) for j in range(size)]
        for i in range(size)
    ]
    for item in network["base_O_input_to_output_givens"]:
        a, b = item["modes_zero_based"]
        theta = float(item["theta_radians"])
        if decimal_places is not None:
            theta = round(theta, decimal_places)
        reconstruction = mm(givens_matrix(size, a, b, theta), reconstruction)
    return max(
        abs(target[i][j] - reconstruction[i][j])
        for i in range(size)
        for j in range(size)
    )


def build_certificate() -> dict:
    source_files = {
        name: source_record(stem) for name, stem in SOURCES.items()
    }
    anomaly = load_json(SOURCES["anomaly_inverse"])
    exchange = load_json(SOURCES["boson_fermion_complement"])
    demonstrator = load_json(SOURCES["six_mode_demonstrator"])

    invariant = exchange["balanced_invariant"]
    spectrum = tuple(Fraction(value) for value in invariant["squared_singular_values"])
    p1 = sum(spectrum, Fraction(0))
    p2 = sum((value * value for value in spectrum), Fraction(0))
    p3 = sum((value**3 for value in spectrum), Fraction(0))
    computed_h3 = h3(spectrum)
    computed_e3 = math.prod(spectrum)
    computed_s21 = (p1**3 - p3) / 3
    assert computed_h3 == Fraction(invariant["bosonic_symmetric_cube_probability_sum_h3"])
    assert computed_e3 == Fraction(invariant["fermionic_exterior_cube_probability_e3"])
    assert computed_s21 == Fraction(invariant["degree_three_schur_s21"])
    assert computed_h3 - computed_e3 == p1 * p2 == Fraction(297, 125)
    assert computed_h3 + 2 * computed_s21 + computed_e3 == p1**3
    assert computed_h3 / 10 == Fraction(
        invariant["bosonic_uniform_input_average_h3_over_10"]
    )

    census = exchange["balanced_census"]
    assert len(census["records"]) == math.comb(6, 3) == 20
    probability_counts = {
        tuple(item["sorted_probabilities"]): item["balanced_masks"]
        for item in census["collision_free_probability_multiset_counts"]
    }
    assert sorted(probability_counts.values()) == [8, 12]
    probability_values = sorted(
        {value for probabilities in probability_counts for value in probabilities},
        key=Fraction,
    )
    assert probability_values == ["16/3125", "36/3125", "64/3125"]

    unbalanced_count = sum(math.comb(6, size) for size in range(7) if size != 3)
    assert unbalanced_count == 44

    chiral = demonstrator["controls"]["chiral"]
    charges = chiral["charge_vector"]
    kappa = Fraction(chiral["common_amplitude_scale_kappa"])
    probabilities = [
        Fraction(item["probability"]) for item in chiral["fermion_probabilities"]
    ]
    expected_probabilities = [kappa * kappa * charge * charge / 500 for charge in charges]
    assert probabilities == expected_probabilities
    assert sum(charges) == 0
    assert sum(charge**3 for charge in charges) == 0
    assert chiral["path_filter"] == ["1", "7/13", "1/7", "-1/5", "-1/2", "-1"]

    decoder = demonstrator["simplex_decoder"]
    words = decoder["six_words"]
    distances = pairwise_distances(words)
    assert distances == [6] * math.comb(6, 2)
    three = decoder["example_three_cut_classifier_zero_based"]
    assert len({tuple(word[index] for index in three) for word in words}) == 6
    assert decoder["example_five_cycle_zero_based"] == [0, 3, 4, 7, 9]
    assert decoder["guaranteed_sign_error_correction_full_ten"] == 2
    assert decoder["number_of_three_cut_classifiers"] == 60

    network = demonstrator["logical_network"]
    assert network["base_O_mzi_count"] == 15
    exact_network_error = network_error(network)
    rounded_network_error = network_error(network, decimal_places=6)
    assert exact_network_error < 2e-15
    assert rounded_network_error < 7e-7

    anomaly_charges = anomaly["charge_witness"]["primitive_charges"]
    assert anomaly_charges == charges

    return {
        "claims": {
            "balanced_boolean_boundary": {
                "nonzero_balanced_masks": 20,
                "rank_at_most_two_unbalanced_masks": 44,
            },
            "balanced_exchange_invariants": {
                "bosonic_uniform_input_average": str(computed_h3 / 10),
                "e3": str(computed_e3),
                "h3": str(computed_h3),
                "h3_minus_e3": str(computed_h3 - computed_e3),
                "s21": str(computed_s21),
                "squared_singular_values": [str(value) for value in spectrum],
            },
            "calibrated_boson_census": {
                "balanced_records": len(census["records"]),
                "probability_values": probability_values,
                "two_multiset_class_sizes": sorted(probability_counts.values()),
            },
            "chiral_filter": {
                "charge_vector": charges,
                "common_amplitude_scale": str(kappa),
                "path_filter": chiral["path_filter"],
                "probabilities": [str(value) for value in probabilities],
            },
            "simplex_decoder": {
                "all_pairwise_hamming_distances": sorted(set(distances)),
                "cut_representatives": decoder["cut_representatives"],
                "correctable_hard_sign_errors": 2,
                "five_cut_positions_zero_based": decoder[
                    "example_five_cycle_zero_based"
                ],
                "number_of_three_cut_classifiers": 60,
                "six_words": words,
                "three_cut_signatures": [
                    [word[index] for index in three] for word in words
                ],
                "three_cut_positions_zero_based": three,
            },
            "six_mode_compilation": {
                "base_O_input_phase_signs": network["base_O_input_phase_signs"],
                "base_O_input_to_output_givens": network[
                    "base_O_input_to_output_givens"
                ],
                "givens_convention": network["givens_convention"],
                "mzi_count": network["base_O_mzi_count"],
                "reconstruction_max_entry_error_full_precision": exact_network_error,
                "reconstruction_max_entry_error_six_decimal_angles": rounded_network_error,
                "six_protocol_path_permutations": network[
                    "six_protocol_path_permutations"
                ],
            },
        },
        "schema": "golden-quantum-statistics-evidence-v1",
        "evidence_bundles": source_files,
        "trust_boundary": {
            "certificate_checked": [
                "balanced census and calibrated permanent probabilities",
                "rational chiral filter, scale, and postselection probabilities",
                "six sign words, schedules, and pairwise Hamming distance",
                "six-mode compilation, full-precision netlist, and rounded-table residual",
            ],
            "human_derived": [
                "44 unbalanced masks have rank at most two",
                "symmetric-function and Schur-Weyl identities",
                "nearest-word correction radius from distance six",
            ],
            "not_certified_here": [
                "experimental feasibility or source availability",
                "literature novelty or priority",
            ],
        },
    }


def canonical_bytes(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode("utf-8")


def local_manifest_bytes(certificate_bytes: bytes) -> bytes:
    local_files = [
        (Path(__file__), Path(__file__).read_bytes()),
        (CERTIFICATE, certificate_bytes),
        (HERE / "README.md", (HERE / "README.md").read_bytes()),
        (HERE / "EVIDENCE.md", (HERE / "EVIDENCE.md").read_bytes()),
        (PAPER_ROOT / "Makefile", (PAPER_ROOT / "Makefile").read_bytes()),
        (PAPER_ROOT / "golden_quantum_statistics.tex",
         (PAPER_ROOT / "golden_quantum_statistics.tex").read_bytes()),
        (PAPER_ROOT / "pyproject.toml", (PAPER_ROOT / "pyproject.toml").read_bytes()),
        (PAPER_ROOT / "uv.lock", (PAPER_ROOT / "uv.lock").read_bytes()),
    ]
    for stem in SOURCES.values():
        for path in (stem.with_suffix(".py"), stem.parent / f"{stem.name}_replay.py",
                     stem.with_suffix(".json")):
            local_files.append((path, path.read_bytes()))
    files = {}
    for path, payload in local_files:
        files[str(path.relative_to(PAPER_ROOT))] = {
            "bytes": len(payload),
            "sha256": hashlib.sha256(payload).hexdigest(),
        }
    return canonical_bytes({
        "files": files,
        "schema": "golden-quantum-statistics-manifest-v1",
    })


def write_outputs() -> None:
    verify_public_hygiene()
    certificate_bytes = canonical_bytes(build_certificate())
    CERTIFICATE.write_bytes(certificate_bytes)
    MANIFEST.write_bytes(local_manifest_bytes(certificate_bytes))
    print(f"wrote {CERTIFICATE.relative_to(PAPER_ROOT)} and {MANIFEST.relative_to(PAPER_ROOT)}")


def check_outputs() -> None:
    verify_public_hygiene()
    expected_certificate = canonical_bytes(build_certificate())
    assert CERTIFICATE.read_bytes() == expected_certificate, "stale evidence certificate"
    expected_manifest = local_manifest_bytes(expected_certificate)
    assert MANIFEST.read_bytes() == expected_manifest, "stale evidence manifest"
    assert digest(CERTIFICATE) == hashlib.sha256(expected_certificate).hexdigest()
    print(
        "ok: evidence verifies 20+44 masks, h3/e3/s21, three permanent values, "
        "the chiral filter, distance-six decoder, and 15-cell compilation"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write:
        write_outputs()
    else:
        check_outputs()


if __name__ == "__main__":
    main()
