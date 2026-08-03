#!/usr/bin/env python3
"""Check the frozen R7 direct locus certificate and, optionally, Certificate R7.

The intrinsic checks do not import the generator or any finite-field code.
The comparison mode is intentionally separate so the independent certificate
can be frozen before the public R7 record is read.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
DEFAULT_CERTIFICATE = HERE / "2026-08-02-r7-direct-locus-certificate.json"
DEFAULT_PUBLIC_RECORD = HERE.parent.parent / "CLASSIFICATION-RECORDS.json"
DEFAULT_COMPARISON = HERE / "2026-08-02-r7-direct-locus-public-comparison.json"
EXPECTED_FIELDS = (7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32)
FIELD_SHAPES = {
    7: (7, 1), 8: (2, 3), 9: (3, 2), 11: (11, 1), 13: (13, 1),
    16: (2, 4), 17: (17, 1), 19: (19, 1), 23: (23, 1),
    25: (5, 2), 27: (3, 3), 29: (29, 1), 31: (31, 1), 32: (2, 5),
}
FAMILIES = (
    "persistent-rank-two", "central-binary", "bounded-exceptional"
)


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def encode_base_q(vector, q: int) -> int:
    result = 0
    for value in vector:
        assert 0 <= value < q
        result = result * q + value
    return result


def decode_base_q(code: int, q: int, length: int):
    vector = [0] * length
    for index in range(length - 1, -1, -1):
        vector[index] = code % q
        code //= q
    assert code == 0
    return vector


def check_intrinsic(document, certificate: Path):
    assert document["schema"] == "r7_direct-r7-independent-completeness-v2"
    assert document["comparison_status"] == "not-compared"
    assert tuple(document["field_domain"]) == EXPECTED_FIELDS
    assert tuple(row["q"] for row in document["fields"]) == EXPECTED_FIELDS

    engine = HERE.parent / "papers" / "beyond4_prs" / "supplement" / "evidence" / "r7" / document["engine"]
    field_implementation = (
        HERE.parent / "papers" / "beyond4_prs" / "supplement" /
        document["field_implementation"]
    )
    assert sha256_path(engine) == document["engine_sha256"]
    assert sha256_path(field_implementation) == document["field_implementation_sha256"]

    for row in document["fields"]:
        q = row["q"]
        assert (row["characteristic"], row["extension_degree"]) == FIELD_SHAPES[q]
        expected_method = (
            "literal-four-secant-complement" if q < 16 else
            "direct-r6-persistent-marked-star-transient-union" if q == 19 else
            "direct-r6-persistent-marked-star-nucleus-union"
        )
        assert row["pointed_method"] == expected_method
        assert row["transient_pointed_count"] == (19 if q == 19 else 0)
        assert row["projective_domain_count"] == (q ** 7 - 1) // (q - 1)
        assert row["candidate_count"] == q * row["pointed_bad_count"] + 1
        assert (
            row["rejected_by_infinity_count"] + row["candidate_count"]
            == row["projective_domain_count"]
        )
        assert (
            row["rejected_by_other_marker_count"] + row["split_free_count"]
            == row["candidate_count"]
        )
        assert row["pgl_order"] == q ** 3 - q
        assert row["orbit_record_columns"] == [
            "canonical_index", "orbit_size", "frobenius_target_index", "family_code"
        ]
        assert row["family_codes"] == {
            "P": "persistent-rank-two",
            "C": "central-binary",
            "E": "bounded-exceptional",
        }
        records = row["orbit_records"]
        assert row["pgl_orbit_count"] == len(records)
        assert set(row["family_mass"]) == set(FAMILIES)
        assert sum(row["family_mass"].values()) == row["split_free_count"]

        indices = {record[0] for record in records}
        assert len(indices) == len(records)
        assert sum(record[1] for record in records) == row["split_free_count"]
        family_mass = {family: 0 for family in FAMILIES}
        for record in records:
            assert len(record) == 4
            vector = decode_base_q(record[0], q, 7)
            assert len(vector) == 7
            assert next(value for value in vector if value) == 1
            assert encode_base_q(vector, q) == record[0]
            assert record[3] in row["family_codes"]
            family_mass[row["family_codes"][record[3]]] += record[1]
            assert row["pgl_order"] % record[1] == 0
            assert record[2] in indices
        assert family_mass == row["family_mass"]
        targets = [record[2] for record in records]
        assert len(set(targets)) == len(targets)
        assert len(row["orbit_partition_sha256"]) == 64
        print(
            f"q={q}: PG={row['projective_domain_count']} "
            f"candidates={row['candidate_count']} split_free={row['split_free_count']} "
            f"orbits={row['pgl_orbit_count']}: INTRINSIC PASS"
        )
    print(
        f"PASS intrinsic R7 direct locus certificate {certificate} "
        f"sha256={sha256_path(certificate)} bytes={certificate.stat().st_size}"
    )


def permutation_cycle_count(records) -> int:
    target = {
        record[0]: record[2]
        for record in records
    }
    unseen = set(target)
    cycles = 0
    while unseen:
        cycles += 1
        point = next(iter(unseen))
        while point in unseen:
            unseen.remove(point)
            point = target[point]
    return cycles


def compare_public(document, certificate: Path, public_path: Path):
    public_path = public_path.resolve()
    public_document = json.loads(public_path.read_text(encoding="utf-8"))
    public = public_document["records"]["R7"]
    assert public["public_label"] == "Certificate R7"
    public_fields = {row["q"]: row for row in public["fields"]}
    assert tuple(sorted(public_fields)) == EXPECTED_FIELDS
    comparisons = []
    for row in document["fields"]:
        q = row["q"]
        expected = public_fields[q]
        assert row["candidate_count"] == expected["searched_candidate_count"]
        assert row["split_free_count"] == expected["classified_split_free_count"]
        assert row["pgl_orbit_count"] == expected["pgl2_orbit_count"]
        records = row["orbit_records"]
        assert sum(record[1] for record in records) == expected["orbit_size_sum"]
        assert permutation_cycle_count(records) == expected["pgammal2_orbit_count"]
        assert row["family_mass"]["persistent-rank-two"] == expected["persistent_count"]
        assert row["family_mass"]["bounded-exceptional"] == expected["exceptional_count"]
        assert (expected["radius_status"]["value"] is None) == (q in (7, 8, 9))

        actual_orbits = []
        for record in records:
            family = row["family_codes"][record[3]]
            actual_orbits.append({
                "canonical_index": record[0],
                "canonical_representative": decode_base_q(record[0], q, 7),
                "persistent": family == "persistent-rank-two",
                "central_nucleus": family == "central-binary",
                "orbit_size": record[1],
                "stabilizer_order": row["pgl_order"] // record[1],
                "frobenius_target_index": record[2],
            })
        expected_orbits = []
        for record in expected["orbits"]:
            assert record["flags"]["split_free"] is True
            assert record["flags"]["persistent"] == record["invariants"]["persistent"]
            assert record["flags"]["modular"] == record["invariants"]["central_nucleus"]
            assert (record["flags"]["code_deep"] is None) == (q in (7, 8, 9))
            expected_orbits.append({
                "canonical_index": record["canonical_index"],
                "canonical_representative": record["canonical_representative"],
                "persistent": record["invariants"]["persistent"],
                "central_nucleus": record["invariants"]["central_nucleus"],
                "orbit_size": record["orbit_size"],
                "stabilizer_order": record["stabilizer_order"],
                "frobenius_target_index": record["frobenius_target_index"],
            })
        key = lambda record: (record["orbit_size"], record["canonical_index"])
        assert sorted(actual_orbits, key=key) == sorted(expected_orbits, key=key)
        comparisons.append({
            "q": q,
            "candidate_count_match": True,
            "split_free_count_match": True,
            "canonical_orbits_match": True,
            "stabilizers_match": True,
            "family_flags_match": True,
            "frobenius_fusion_match": True,
            "covering_radius_boundary_retained": True,
        })
        print(f"q={q}: Certificate R7 exact comparison PASS")
    return {
        "schema": "r7_direct-r7-public-comparison-v1",
        "independent_certificate": certificate.name,
        "independent_certificate_sha256": sha256_path(certificate),
        "public_record": str(public_path.relative_to(HERE.parent)),
        "public_record_sha256": sha256_path(public_path),
        "comparison_performed_after_freeze": True,
        "fields": comparisons,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", nargs="?", type=Path, default=DEFAULT_CERTIFICATE)
    parser.add_argument("--compare-public", type=Path)
    parser.add_argument("--output-comparison", type=Path, default=DEFAULT_COMPARISON)
    parser.add_argument("--check-comparison", action="store_true")
    args = parser.parse_args()
    document = json.loads(args.certificate.read_text(encoding="utf-8"))
    check_intrinsic(document, args.certificate)
    if args.compare_public:
        comparison = compare_public(document, args.certificate, args.compare_public)
        payload = json.dumps(comparison, sort_keys=True, separators=(",", ":")) + "\n"
        if args.check_comparison:
            assert args.output_comparison.read_text(encoding="utf-8") == payload
            print(f"PASS byte-identical frozen/public comparison {args.output_comparison}")
        else:
            args.output_comparison.write_text(payload, encoding="utf-8")
            print(f"PASS wrote frozen/public comparison {args.output_comparison}")


if __name__ == "__main__":
    main()
