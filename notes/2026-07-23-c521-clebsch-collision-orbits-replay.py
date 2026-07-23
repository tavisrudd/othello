#!/usr/bin/env python3
"""Independent invariant replay for the C521 collision-orbit certificate."""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-23-c521-clebsch-collision-orbits.json"
C490 = HERE / "2026-07-22-c490-small-field-base-size-closure.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c521-clebsch-collision-orbits-v1"
    for name, record in data["inputs"].items():
        path = HERE / name
        assert path.stat().st_size == record["bytes"]
        assert sha256(path) == record["sha256"]

    group = data["group"]
    assert group == {
        "child_degree": 12,
        "name": "PGL_2(11)",
        "order": 1320,
        "parent_degree": 22,
        "point_stabilizer_order": 110,
        "unordered_pair_stabilizer_order": 20,
    }

    one = data["agreement_one_orbits"]
    assert len(one) == 1
    assert (one[0]["orbit_size"], one[0]["stabilizer_order"]) == (1320, 1)

    two = data["agreement_two_orbits"]
    profile = Counter((record["orbit_size"], record["stabilizer_order"]) for record in two)
    assert profile == Counter({
        (660, 2): 8,
        (330, 4): 2,
        (132, 10): 2,
        (66, 20): 1,
    })
    assert all(
        record["orbit_size"] * record["stabilizer_order"] == group["order"]
        for record in one + two
    )
    assert sum(record["orbit_size"] for record in two) == 6270

    contributions = sorted(
        group["unordered_pair_stabilizer_order"] // record["stabilizer_order"]
        for record in two
    )
    assert contributions == [1, 2, 2, 5, 5] + [10] * 8
    assert contributions == data["pair_fibre_contributions"]
    assert sum(contributions) == data["pair_fibre_total"] == 95

    canonical = [record for record in two if record["stabilizer_order"] == 20]
    assert len(canonical) == 1
    assert canonical[0]["orbit_size"] == 66
    assert canonical[0]["agreement_is_unique_shared_deletion_edge"]
    assert canonical[0]["parents_are_cross_sheet"]

    source = json.loads(C490.read_text())
    fibre = next(
        fibre
        for field_record in source["fields"] if field_record["q"] == 11
        for fibre in field_record["fibres"] if fibre["child_size"] == 12
    )
    multiplicities = Counter(fibre["disagreement_mask_multiplicities"].values())
    assert multiplicities == Counter({95: 66, 110: 12, 158730: 1})
    assert 12 * 110 == 1320
    assert 66 * 95 == 6270
    assert 6270 + 1320 + 158730 == 166320

    print(
        "ok regular-agreement-one orbit; "
        "agreement-two stabilizers 2^8,4^2,10^2,20; "
        "pair fibre 10*8+5*2+2*2+1=95"
    )


if __name__ == "__main__":
    main()
