#!/usr/bin/env python3
"""Check the compact C767 import certificate against the frozen source bundles."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import tempfile
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CERTIFICATE = HERE / "c767-import-certificate.json"
MANIFEST = HERE / "SHA256SUMS"

SOURCES = {
    "C715": ROOT / "notes/2026-07-31-c715-golden-anomaly-inverse",
    "C718": ROOT / "notes/2026-08-01-c718-golden-boson-fermion-complement",
    "C719": ROOT / "notes/2026-08-01-c719-golden-six-mode-demonstrator",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def manifest_entries(path: Path) -> list[tuple[str, int | None, Path]]:
    entries = []
    for line in path.read_text(encoding="utf-8").splitlines():
        fields = line.split()
        if len(fields) == 2:
            expected, relative = fields
            size = None
        elif len(fields) == 3:
            expected, size_text, relative = fields
            size = int(size_text)
        else:
            raise AssertionError(f"malformed manifest line in {path}: {line!r}")
        entries.append((expected, size, ROOT / relative))
    return entries


def verify_source_manifest(stem: Path) -> dict[str, dict[str, int | str]]:
    manifest = stem.with_suffix(".sha256")
    checked = {}
    for expected, expected_size, path in manifest_entries(manifest):
        payload = path.read_bytes()
        assert hashlib.sha256(payload).hexdigest() == expected, path
        if expected_size is not None:
            assert len(payload) == expected_size, path
        checked[str(path.relative_to(ROOT))] = {
            "bytes": len(payload),
            "sha256": expected,
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


def build_certificate() -> dict:
    source_files = {
        task: verify_source_manifest(stem) for task, stem in SOURCES.items()
    }
    c715 = load_json(SOURCES["C715"])
    c718 = load_json(SOURCES["C718"])
    c719 = load_json(SOURCES["C719"])

    invariant = c718["balanced_invariant"]
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

    census = c718["balanced_census"]
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

    chiral = c719["controls"]["chiral"]
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

    decoder = c719["simplex_decoder"]
    words = decoder["six_words"]
    distances = pairwise_distances(words)
    assert distances == [6] * math.comb(6, 2)
    three = decoder["example_three_cut_classifier_zero_based"]
    assert len({tuple(word[index] for index in three) for word in words}) == 6
    assert decoder["example_five_cycle_zero_based"] == [0, 3, 4, 7, 9]
    assert decoder["guaranteed_sign_error_correction_full_ten"] == 2
    assert decoder["number_of_three_cut_classifiers"] == 60

    network = c719["logical_network"]
    assert network["base_O_mzi_count"] == 15
    assert network["reconstruction_max_entry_error"] < 2e-15

    c715_charges = c715["charge_witness"]["primitive_charges"]
    assert c715_charges == charges

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
                "correctable_hard_sign_errors": 2,
                "five_cut_positions_zero_based": decoder[
                    "example_five_cycle_zero_based"
                ],
                "number_of_three_cut_classifiers": 60,
                "three_cut_positions_zero_based": three,
            },
            "six_mode_compilation": {
                "mzi_count": network["base_O_mzi_count"],
                "reconstruction_max_entry_error": network[
                    "reconstruction_max_entry_error"
                ],
            },
        },
        "schema": "c767-golden-statistics-import-v1",
        "source_bundles": source_files,
        "trust_boundary": {
            "certificate_checked": [
                "balanced census and calibrated permanent probabilities",
                "rational chiral filter, scale, and postselection probabilities",
                "six sign words, schedules, and pairwise Hamming distance",
                "six-mode compilation count and reconstruction residual",
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
    rows = []
    local_files = (
        (Path(__file__), Path(__file__).read_bytes()),
        (CERTIFICATE, certificate_bytes),
        (HERE.parent / "pyproject.toml", (HERE.parent / "pyproject.toml").read_bytes()),
        (HERE.parent / "uv.lock", (HERE.parent / "uv.lock").read_bytes()),
    )
    for path, payload in local_files:
        rows.append(
            f"{hashlib.sha256(payload).hexdigest()}  {len(payload):6d}  "
            f"{path.relative_to(ROOT)}"
        )
    return ("\n".join(rows) + "\n").encode("utf-8")


def write_outputs() -> None:
    certificate_bytes = canonical_bytes(build_certificate())
    CERTIFICATE.write_bytes(certificate_bytes)
    MANIFEST.write_bytes(local_manifest_bytes(certificate_bytes))
    print(f"wrote {CERTIFICATE.relative_to(ROOT)} and {MANIFEST.relative_to(ROOT)}")


def check_outputs() -> None:
    expected_certificate = canonical_bytes(build_certificate())
    assert CERTIFICATE.read_bytes() == expected_certificate, "stale C767 certificate"
    expected_manifest = local_manifest_bytes(expected_certificate)
    assert MANIFEST.read_bytes() == expected_manifest, "stale C767 manifest"
    with tempfile.TemporaryDirectory(prefix="c767-check-") as directory:
        temporary = Path(directory) / CERTIFICATE.name
        temporary.write_bytes(expected_certificate)
        assert digest(temporary) == digest(CERTIFICATE)
    print(
        "ok: C767 imports 20+44 masks, h3/e3/s21, three permanent values, "
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
