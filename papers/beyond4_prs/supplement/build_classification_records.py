#!/usr/bin/env python3
"""Build the public R5--R7 classification record from frozen certificates."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


SUPPLEMENT = Path(__file__).resolve().parent
OUT = SUPPLEMENT / "CLASSIFICATION-RECORDS.json"

ARTIFACTS = {
    "R5": (
        "evidence/r5/2026-07-22-prs-deep-hole-census.py",
        "evidence/r5/2026-07-22-prs-deep-hole-census.json",
        "evidence/r5/2026-07-22-redundancy-five-deep-hole-replay.py",
    ),
    "R6": (
        "evidence/r6/2026-07-22-prs-deep-hole-census.rs",
        "evidence/r6/2026-07-22-prs-deep-hole-census.json",
        "evidence/r6/2026-07-22-redundancy-six-deep-hole-replay.py",
    ),
    "R6-NF": (
        "evidence/r6-normal-forms/2026-07-23-small-exceptional-normal-forms.py",
        "evidence/r6-normal-forms/2026-07-23-small-exceptional-normal-forms.json",
    ),
    "R7": (
        "evidence/r7/2026-07-23-prs-deep-hole-calibration.py",
        "evidence/r7/2026-07-23-prs-deep-hole-calibration.json",
        "evidence/r7/2026-07-23-prs-deep-hole-calibration-replay.py",
    ),
}


def load(name: str) -> dict:
    return json.loads((SUPPLEMENT / name).read_text())


def integrity(names: tuple[str, ...]) -> list[dict]:
    rows = []
    for name in names:
        path = SUPPLEMENT / name
        data = path.read_bytes()
        rows.append(
            {
                "artifact_path": name,
                "sha256": hashlib.sha256(data).hexdigest(),
                "bytes": len(data),
            }
        )
    return rows


def sorted_fields(fields: dict) -> list[tuple[int, dict]]:
    return sorted(((int(q), row) for q, row in fields.items()), key=lambda x: x[0])


def r5_record(source: dict) -> dict:
    fields = []
    for q, row in sorted_fields(source["fields"]):
        orbits = []
        for orbit in row["pgl2_orbits"]:
            modular = (
                q % 3 == 0
                and orbit["family"] == "excess"
                and orbit["size"] in {1, (q * q - 1) // 2}
            )
            orbits.append(
                {
                    "canonical_representative": orbit["rep"],
                    "canonical_index": orbit["rep_index"],
                    "orbit_size": orbit["size"],
                    "stabilizer_order": orbit["stab_order"],
                    "frobenius_target_index": orbit[
                        "frobenius_maps_to_rep_index"
                    ],
                    "invariants": {
                        "family": orbit["family"],
                        "factor_type": orbit["factor_type"],
                        "pencil_gcd_degree": orbit["pencil_gcd_deg"],
                        "rational_osculating_points": orbit[
                            "osc_rational_points"
                        ],
                        "member_histogram": orbit["member_stats"],
                    },
                    "flags": {
                        "persistent": orbit["family"]
                        in {"tangent", "sigma_secant"},
                        "modular": modular,
                        "split_free": True,
                        "code_deep": True,
                    },
                }
            )
        orbit_sum = sum(orbit["orbit_size"] for orbit in orbits)
        fields.append(
            {
                "q": q,
                "ambient_domain": f"PG(4,{q})",
                "ambient_point_count": row["pg4_points"],
                "classified_split_free_count": row["deep_hole_count"],
                "orbit_size_sum": orbit_sum,
                "exhaustion_identity": orbit_sum == row["deep_hole_count"],
                "pgl2_order": row["pgl2_order"],
                "pgl2_orbit_count": len(orbits),
                "pgammal2_orbit_count": row["pgammal_orbit_count"],
                "radius_status": {
                    "value": 4,
                    "source": "Seroussi--Roth covering-radius theorem",
                    "definition_scan_rho_le_4": row["rho_le_4_verified"],
                },
                "orbits": orbits,
            }
        )
    return {
        "public_label": "Certificate R5",
        "source_schema": source["schema"],
        "normalization": {
            "projective_vector": "scale the first nonzero coordinate to 1",
            "point_index": "base-q radix index with coordinate 0 most significant",
            "orbit_representative": "minimum point index in the PGL2 orbit",
            "ordering": "(orbit size, canonical point index)",
        },
        "searched_domain": (
            "Every point of PG(4,q) in the nineteen recorded fields; the "
            "orbits listed below exhaust the split-free subset."
        ),
        "field_models": source["moduli"],
        "artifact_integrity": integrity(ARTIFACTS["R5"]),
        "fields": fields,
    }


def r6_record(source: dict, normal_forms: dict) -> dict:
    fields = []
    for q, row in sorted_fields(source["fields"]):
        orbits = []
        for orbit in row["pgl2_orbits"]:
            modular = q == 8 and orbit["net_gcd_deg"] == 0 and orbit["size"] == q + 1
            orbits.append(
                {
                    "canonical_representative": orbit["rep"],
                    "canonical_index": orbit["rep_index"],
                    "orbit_size": orbit["size"],
                    "stabilizer_order": orbit["stab_order"],
                    "frobenius_target_index": orbit[
                        "frobenius_maps_to_rep_index"
                    ],
                    "invariants": {
                        "quintic_factor_type": orbit["quintic_factor_type"],
                        "net_gcd_degree": orbit["net_gcd_deg"],
                        "totally_split_members": orbit["totalsplit_members"],
                        "member_histogram": orbit["member_hist"],
                    },
                    "flags": {
                        "persistent": orbit["net_gcd_deg"] == 2,
                        "modular": modular,
                        "split_free": True,
                        "code_deep": True,
                    },
                }
            )
        orbit_sum = sum(orbit["orbit_size"] for orbit in orbits)
        fields.append(
            {
                "q": q,
                "ambient_domain": f"PG(5,{q})",
                "ambient_point_count": row["pg5_points"],
                "classified_split_free_count": row["deep_hole_count"],
                "orbit_size_sum": orbit_sum,
                "exhaustion_identity": orbit_sum == row["deep_hole_count"],
                "pgl2_order": row["pgl2_order"],
                "pgl2_orbit_count": len(orbits),
                "pgammal2_orbit_count": row["pgammal_orbit_count"],
                "radius_status": {
                    "value": row["covering_radius"],
                    "source": "complete definition-level syndrome scan",
                },
                "orbits": orbits,
            }
        )
    return {
        "public_label": "Certificate R6",
        "source_schema": source["schema"],
        "normalization": {
            "projective_vector": "scale the first nonzero coordinate to 1",
            "point_index": "base-q radix index with coordinate 0 most significant",
            "orbit_representative": "minimum point index in the PGL2 orbit",
            "ordering": "(orbit size, canonical point index)",
            "semilinear_normal_form": (
                "lexicographically first frozen representative in its "
                "coefficient-Frobenius cycle"
            ),
        },
        "searched_domain": (
            "Every point of PG(5,q) in the eleven recorded fields; the "
            "orbits listed below exhaust the split-free subset."
        ),
        "artifact_integrity": integrity(ARTIFACTS["R6"]),
        "normal_form_artifact_integrity": integrity(ARTIFACTS["R6-NF"]),
        "fields": fields,
        "exceptional_semilinear_normal_forms": normal_forms["fields"],
    }


def r7_record(source: dict) -> dict:
    fields = []
    for row in sorted(source["fields"], key=lambda item: item["q"]):
        q = row["q"]
        orbits = []
        for orbit in row["orbits"]:
            code_deep = True if q >= 11 else None
            orbits.append(
                {
                    "canonical_representative": orbit["representative"],
                    "canonical_index": orbit["representative_index"],
                    "orbit_size": orbit["size"],
                    "stabilizer_order": orbit["stabilizer_order"],
                    "frobenius_target_index": orbit[
                        "frobenius_to_representative_index"
                    ],
                    "invariants": {
                        "persistent": orbit["persistent"],
                        "central_nucleus": orbit["central_nucleus"],
                    },
                    "flags": {
                        "persistent": orbit["persistent"],
                        "modular": orbit["central_nucleus"],
                        "split_free": True,
                        "code_deep": code_deep,
                    },
                }
            )
        orbit_sum = sum(orbit["orbit_size"] for orbit in orbits)
        fields.append(
            {
                "q": q,
                "ambient_domain": f"PG(6,{q})",
                "searched_domain": "exact pointed-bad polar candidate locus",
                "searched_candidate_count": row["candidate_count"],
                "classified_split_free_count": row["deep_count"],
                "persistent_count": row["persistent_count"],
                "exceptional_count": row["exceptional_count"],
                "orbit_size_sum": orbit_sum,
                "exhaustion_identity": orbit_sum == row["deep_count"],
                "pgl2_orbit_count": row["pgl_orbit_count"],
                "pgammal2_orbit_count": row["pgammal_orbit_count"],
                "radius_status": {
                    "value": 6 if q >= 11 else None,
                    "source": (
                        "Seroussi--Roth covering-radius theorem"
                        if q >= 11
                        else "not supplied; record classifies split-free syndromes only"
                    ),
                },
                "orbits": orbits,
            }
        )
    return {
        "public_label": "Certificate R7",
        "source_schema": source["schema"],
        "normalization": {
            "projective_vector": "scale the first nonzero coordinate to 1",
            "point_index": "base-q radix index with coordinate 0 most significant",
            "orbit_representative": "minimum point index in the PGL2 orbit",
            "ordering": "(orbit size, canonical point index)",
        },
        "searched_domain": (
            "The exact pointed-bad candidate locus at every recorded field; "
            "each survivor is independently checked against every five-point "
            "span and its full PGL2 orbit."
        ),
        "artifact_integrity": integrity(ARTIFACTS["R7"]),
        "fields": fields,
    }


def build() -> dict:
    r5 = load(ARTIFACTS["R5"][1])
    r6 = load(ARTIFACTS["R6"][1])
    r6_nf = load(ARTIFACTS["R6-NF"][1])
    r7 = load(ARTIFACTS["R7"][1])
    return {
        "schema": "beyond4-prs-public-classification-records-v1",
        "generated_from_frozen_certificates": True,
        "records": {
            "R5": r5_record(r5),
            "R6": r6_record(r6, r6_nf),
            "R7": r7_record(r7),
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if args.check:
        if OUT.read_text() != content:
            raise SystemExit(f"stale: {OUT}")
        print("classification records: PASS")
    else:
        OUT.write_text(content)


if __name__ == "__main__":
    main()
