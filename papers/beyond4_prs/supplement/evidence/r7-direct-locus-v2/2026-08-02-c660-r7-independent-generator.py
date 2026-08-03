#!/usr/bin/env python3
"""Freeze the independent C660 redundancy-seven completeness records.

This generator deliberately has no Certificate R7 input.  It reuses the
post-Version-1 direct-locus engine, which is independent of the C509 quotient
enumerator, and adds a canonical candidate-domain ledger, full orbit records,
and intrinsic family flags.  Public-record comparison belongs to the separate
C660 checker and may be run only after this output has been frozen.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ENGINE_PATH = HERE.parent / "r7" / "2026-07-26-r7-direct-locus-replay.py"
DEFAULT_OUTPUT = HERE / "2026-08-02-c660-r7-independent-certificate.json"
FIELDS = (7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32)


def load_engine():
    spec = importlib.util.spec_from_file_location("c660_direct_locus", ENGINE_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


ENGINE = load_engine()


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def digest_integers(values) -> str:
    payload = "\n".join(str(value) for value in sorted(values)) + "\n"
    return hashlib.sha256(payload.encode("ascii")).hexdigest()


def matrix_rank(field, rows) -> int:
    _, pivots = ENGINE.rref(field, rows, len(rows[0]))
    return len(pivots)


def catalecticant_rank(field, vector) -> int:
    return matrix_rank(field, [vector[start:start + 4] for start in range(4)])


def orbit_records(field, split_free):
    primitive = ENGINE.primitive_element(field)
    unseen = set(split_free)
    raw = []
    point_to_representative = {}
    central = ENGINE.encode(field, (0, 0, 0, 1, 0, 0, 0))
    while unseen:
        representative = min(unseen)
        component = ENGINE.pgl_orbit(
            field, ENGINE.decode(field, representative, 7), primitive
        )
        assert component <= split_free
        unseen -= component
        for point in component:
            point_to_representative[point] = representative
        persistent_bits = {
            catalecticant_rank(field, ENGINE.decode(field, point, 7)) <= 2
            for point in component
        }
        assert len(persistent_bits) == 1
        persistent = persistent_bits.pop()
        contains_central = central in component
        assert not (persistent and contains_central)
        family = (
            "persistent-rank-two"
            if persistent else
            "central-binary"
            if contains_central else
            "bounded-exceptional"
        )
        raw.append({
            "canonical_index": representative,
            "family_flag": family,
            "orbit_size": len(component),
        })
    for record in raw:
        vector = ENGINE.decode(field, record["canonical_index"], 7)
        frobenius = tuple(
            ENGINE.field_pow(field, value, field.p) for value in vector
        )
        record["frobenius_target_index"] = point_to_representative[
            ENGINE.encode(field, ENGINE.canonical(field, frobenius))
        ]
    raw.sort(key=lambda record: (
        record["orbit_size"], record["canonical_index"]
    ))
    partition_payload = "".join(
        f"{point}:{point_to_representative[point]}\n"
        for point in sorted(point_to_representative)
    )
    family_code = {
        "persistent-rank-two": "P",
        "central-binary": "C",
        "bounded-exceptional": "E",
    }
    compact = [
        [
            record["canonical_index"],
            record["orbit_size"],
            record["frobenius_target_index"],
            family_code[record["family_flag"]],
        ]
        for record in raw
    ]
    return compact, hashlib.sha256(partition_payload.encode("ascii")).hexdigest()


def pointed_method(q: int) -> str:
    if q < 16:
        return "literal-four-secant-complement"
    if q == 19:
        return "direct-r6-persistent-marked-star-transient-union"
    return "direct-r6-persistent-marked-star-nucleus-union"


def freeze_field(q: int):
    field = ENGINE.R5.GF(q)
    base = (
        ENGINE.pointed_bad_exhaustive(field)
        if q < 16 else
        ENGINE.pointed_bad_formula(field)
    )
    split_free = ENGINE.split_free_sextics(field, base)
    records, partition_digest = orbit_records(field, split_free)

    projective_domain_count = (q ** 7 - 1) // (q - 1)
    candidate_count = len(base) * q + 1
    rejected_by_infinity_count = projective_domain_count - candidate_count
    rejected_by_other_marker_count = candidate_count - len(split_free)
    assert candidate_count + rejected_by_infinity_count == projective_domain_count
    assert len(split_free) + rejected_by_other_marker_count == candidate_count
    assert sum(record[1] for record in records) == len(split_free)

    family_mass = {
        family: sum(
            record[1] for record in records
            if record[3] == {
                "persistent-rank-two": "P",
                "central-binary": "C",
                "bounded-exceptional": "E",
            }[family]
        )
        for family in (
            "persistent-rank-two", "central-binary", "bounded-exceptional"
        )
    }
    assert sum(family_mass.values()) == len(split_free)
    return {
        "q": q,
        "characteristic": field.p,
        "extension_degree": field.m,
        "pointed_method": pointed_method(q),
        "pointed_bad_count": len(base),
        "pointed_bad_set_sha256": digest_integers(base),
        "transient_pointed_count": len(ENGINE.transient_pointed_orbit(field)),
        "projective_domain_count": projective_domain_count,
        "rejected_by_infinity_count": rejected_by_infinity_count,
        "candidate_count": candidate_count,
        "rejected_by_other_marker_count": rejected_by_other_marker_count,
        "split_free_count": len(split_free),
        "split_free_set_sha256": digest_integers(split_free),
        "family_mass": family_mass,
        "pgl_order": q ** 3 - q,
        "pgl_orbit_count": len(records),
        "orbit_record_columns": [
            "canonical_index", "orbit_size", "frobenius_target_index", "family_code"
        ],
        "family_codes": {
            "P": "persistent-rank-two",
            "C": "central-binary",
            "E": "bounded-exceptional",
        },
        "orbit_partition_sha256": partition_digest,
        "orbit_records": records,
    }


def canonical_document(fields):
    rows = []
    for q in fields:
        row = freeze_field(q)
        rows.append(row)
        print(
            f"q={q}: domain={row['projective_domain_count']} "
            f"candidates={row['candidate_count']} "
            f"split_free={row['split_free_count']} "
            f"PGL={row['pgl_orbit_count']}: FROZEN",
            flush=True,
        )
    return {
        "schema": "c660-r7-independent-completeness-v2",
        "comparison_status": "not-compared",
        "field_domain": list(fields),
        "engine": ENGINE_PATH.name,
        "engine_sha256": sha256_path(ENGINE_PATH),
        "field_implementation": str(ENGINE.R5_REPLAY.relative_to(ENGINE.SUPPLEMENT)),
        "field_implementation_sha256": sha256_path(ENGINE.R5_REPLAY),
        "coverage_identity": (
            "|PG(6,q)| = rejected_by_infinity + (q*|B_infinity|+1); "
            "q*|B_infinity|+1 = rejected_by_other_marker + split_free"
        ),
        "fields": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fields", default=",".join(str(q) for q in FIELDS)
    )
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    fields = tuple(int(value) for value in args.fields.split(",") if value)
    assert fields and all(q in FIELDS for q in fields)
    document = canonical_document(fields)
    payload = json.dumps(document, sort_keys=True, separators=(",", ":")) + "\n"
    if args.check:
        assert args.output.read_text(encoding="utf-8") == payload
        print(f"PASS byte-identical independent certificate {args.output}")
    else:
        args.output.write_text(payload, encoding="utf-8")


if __name__ == "__main__":
    main()
