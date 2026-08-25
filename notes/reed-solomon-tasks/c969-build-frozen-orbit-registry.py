#!/usr/bin/env python3
"""Build C969's compact R5--R7 semilinear exception registry."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCES = {
    5: ROOT / "notes/2026-07-22-c491-prs-deep-hole-census.json",
    6: ROOT / "notes/2026-07-22-c498-prs-deep-hole-census.json",
    7: ROOT / "notes/2026-07-23-c509-prs-deep-hole-calibration.json",
}

FIELD_MODELS = {
    7: (7, 1, [0, 1]),
    8: (2, 3, [1, 1, 0, 1]),
    9: (3, 2, [1, 0, 1]),
    11: (11, 1, [0, 1]),
    13: (13, 1, [0, 1]),
    16: (2, 4, [1, 1, 0, 0, 1]),
    17: (17, 1, [0, 1]),
    19: (19, 1, [0, 1]),
    23: (23, 1, [0, 1]),
    25: (5, 2, [3, 0, 1]),
    27: (3, 3, [1, 2, 0, 1]),
    29: (29, 1, [0, 1]),
    31: (31, 1, [0, 1]),
    32: (2, 5, [1, 0, 1, 0, 0, 1]),
    37: (37, 1, [0, 1]),
    41: (41, 1, [0, 1]),
    43: (43, 1, [0, 1]),
    47: (47, 1, [0, 1]),
    49: (7, 2, [4, 0, 1]),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cycles(orbits: list[dict], link_key: str, rep_key: str) -> list[list[int]]:
    by_index = {int(orbit["rep_index"] if "rep_index" in orbit else orbit["representative_index"]): orbit
                for orbit in orbits}
    unseen = set(by_index)
    result = []
    while unseen:
        start = min(unseen)
        cycle = []
        current = start
        while current not in cycle:
            cycle.append(current)
            current = int(by_index[current][link_key])
        if current != start:
            raise ValueError(f"Frobenius links have a tail at {start}")
        unseen.difference_update(cycle)
        result.append(cycle)
    return result


def r5_family(q: int, orbit: dict) -> str:
    if orbit["family"] != "excess":
        raise ValueError("persistent R5 orbit leaked into exception registry")
    size = int(orbit["size"])
    p, _, _ = FIELD_MODELS[q]
    if p == 3 and size == 1:
        return "r5.char3_nucleus"
    if p == 3 and size == (q * q - 1) // 2:
        return "r5.char3_wild"
    if q % 3 == 2 and size == q * (q + 1) // 2:
        return "r5.osculating_rational"
    if q % 3 == 1 and size == q * (q - 1) // 2:
        return "r5.osculating_conjugate"
    return "r5.sporadic"


def make_record(r: int, q: int, members: list[dict], rep_key: str, family: str) -> dict:
    p, m, modulus = FIELD_MODELS[q]
    canonical = min((member[rep_key] for member in members), key=tuple)
    semilinear_size = sum(int(member["size"]) for member in members)
    pgamma_order = m * (q**3 - q)
    if pgamma_order % semilinear_size:
        raise ValueError(f"bad semilinear orbit size R{r} q={q}")
    return {
        "redundancy": r,
        "q": q,
        "field": {"p": p, "degree": m, "modulus": modulus},
        "canonical_representative": canonical,
        "family": family,
        "pgl_orbit_count": len(members),
        "semilinear_orbit_size": semilinear_size,
        "semilinear_stabilizer_order": pgamma_order // semilinear_size,
    }


def build() -> dict:
    records = []

    r5 = json.loads(SOURCES[5].read_text())
    for q_text, field in r5["fields"].items():
        q = int(q_text)
        relevant = [orbit for orbit in field["pgl2_orbits"] if orbit["family"] == "excess"]
        by_index = {int(orbit["rep_index"]): orbit for orbit in relevant}
        for cycle in cycles(relevant, "frobenius_maps_to_rep_index", "rep"):
            members = [by_index[index] for index in cycle]
            families = {r5_family(q, member) for member in members}
            if len(families) != 1:
                raise ValueError(f"R5 family changed under Frobenius at q={q}")
            records.append(make_record(5, q, members, "rep", families.pop()))

    r6 = json.loads(SOURCES[6].read_text())
    for q_text, field in r6["fields"].items():
        q = int(q_text)
        relevant = [orbit for orbit in field["pgl2_orbits"] if int(orbit["net_gcd_deg"]) == 0]
        by_index = {int(orbit["rep_index"]): orbit for orbit in relevant}
        for cycle in cycles(relevant, "frobenius_maps_to_rep_index", "rep"):
            members = [by_index[index] for index in cycle]
            family = "r6.sporadic"
            p, m, _ = FIELD_MODELS[q]
            if p == 2 and m % 2 == 1 and sum(int(x["size"]) for x in members) == q + 1:
                family = "r6.char2_nucleus"
            records.append(make_record(6, q, members, "rep", family))

    r7 = json.loads(SOURCES[7].read_text())
    for field in r7["fields"]:
        q = int(field["q"])
        relevant = [orbit for orbit in field["orbits"] if not orbit["persistent"]]
        by_index = {int(orbit["representative_index"]): orbit for orbit in relevant}
        for cycle in cycles(relevant, "frobenius_to_representative_index", "representative"):
            members = [by_index[index] for index in cycle]
            flags = {bool(member["central_nucleus"]) for member in members}
            if len(flags) != 1:
                raise ValueError(f"R7 central flag changed under Frobenius at q={q}")
            family = "r7.char2_central" if flags.pop() else "r7.sporadic"
            records.append(make_record(7, q, members, "representative", family))

    records.sort(key=lambda row: (row["redundancy"], row["q"], row["canonical_representative"]))
    return {
        "schema": "c969-frozen-orbit-registry-v1",
        "source_sha256": {str(r): sha256(path) for r, path in SOURCES.items()},
        "records": records,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(build(), sort_keys=True, separators=(",", ":")) + "\n"
    if args.check:
        if args.output.read_text() != encoded:
            raise SystemExit("registry differs")
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
