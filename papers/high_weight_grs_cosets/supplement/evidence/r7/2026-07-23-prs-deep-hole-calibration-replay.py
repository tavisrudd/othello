#!/usr/bin/env python3
"""Independent replay of REDUNDANCY_SEVEN_CALIBRATION's bounded redundancy-seven calibration.

This checker does not use the generator's pointed-contraction test.  It checks
every recorded orbit representative against the original geometric definition:
absence from every five-point span of the sextic normal rational curve.  It
then rebuilds every PGL2 orbit, Frobenius link, persistent count, and the exact
exceptional orbit-size profiles.
"""

import importlib.util
import itertools
import json
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
REDUNDANCY_SIX_PATH = HERE / "2026-07-22-redundancy-six-deep-hole-replay.py"
DATA_PATH = HERE / "2026-07-23-prs-deep-hole-calibration.json"
SPEC = importlib.util.spec_from_file_location("redundancy_six_replay", REDUNDANCY_SIX_PATH)
REDUNDANCY_SIX = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(REDUNDANCY_SIX)
REDUNDANCY_SIX.MODULI.setdefault(32, (2, [1, 0, 1, 0, 0]))


FIELDS = (7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32)
EXCEPTIONAL_PROFILES = {
    7: {56: 1, 84: 5, 112: 2, 168: 45, 336: 141},
    8: {63: 1, 72: 1, 84: 3, 168: 4, 252: 24, 504: 86},
    9: {180: 3, 240: 6, 360: 18, 720: 27},
    11: {264: 2, 440: 1, 660: 2},
}


def curve(F):
    out = []
    for t in range(F.q):
        row = [1]
        for _ in range(6):
            row.append(F.mul(row[-1], t))
        out.append(tuple(row))
    out.append(tuple([0] * 6 + [1]))
    return out


def poly_mul(F, a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] = F.add(out[i + j], F.mul(x, y))
    return out


def sym6_matrix(F, g):
    alpha, beta, gamma, delta = g
    out = [[0] * 7 for _ in range(7)]
    for i in range(7):
        left = [1]
        right = [1]
        for _ in range(i):
            left = poly_mul(F, left, [beta, alpha])
        for _ in range(6 - i):
            right = poly_mul(F, right, [delta, gamma])
        for j, value in enumerate(poly_mul(F, left, right)):
            out[i][j] = value
    return out


def matvec(F, matrix, vector):
    out = []
    for row in matrix:
        value = 0
        for x, y in zip(row, vector):
            value = F.add(value, F.mul(x, y))
        out.append(value)
    return tuple(out)


def orbit(F, start):
    generators = (
        sym6_matrix(F, (0, 1, 1, 0)),
        sym6_matrix(F, (1, 1, 0, 1)),
        sym6_matrix(F, (F.gen, 0, 0, 1)),
    )
    start = REDUNDANCY_SIX.canon(F, start)
    seen = {REDUNDANCY_SIX.encode(F, start)}
    todo = [start]
    while todo:
        current = todo.pop()
        for matrix in generators:
            image = REDUNDANCY_SIX.canon(F, matvec(F, matrix, current))
            code = REDUNDANCY_SIX.encode(F, image)
            if code not in seen:
                seen.add(code)
                todo.append(image)
    return seen


def deep_by_five_secants(F, vector):
    points = curve(F)
    for indices in itertools.combinations(range(F.q + 1), 5):
        rows = [points[i] for i in indices] + [vector]
        if REDUNDANCY_SIX.matrix_rank(F, rows) <= 5:
            return False
    return True


def expected_persistent_orbits(F):
    tangent = 2 if 6 % F.p == 0 else 1
    d = gcd(6, F.q + 1)
    sigma = d // 2 + 1
    return tangent + sigma


def replay_field(record):
    q = record["q"]
    F = REDUNDANCY_SIX.GF(q)
    seen = set()
    reps = {row["representative_index"] for row in record["orbits"]}
    exceptional_profile = {}
    persistent_orbits = 0
    central_orbits = 0
    frobenius = {}
    for row in record["orbits"]:
        representative = tuple(row["representative"])
        assert REDUNDANCY_SIX.encode(F, representative) == row["representative_index"]
        assert deep_by_five_secants(F, representative)
        component = orbit(F, representative)
        assert len(component) == row["size"]
        assert not (component & seen)
        seen |= component
        assert (q ** 3 - q) // len(component) == row["stabilizer_order"]
        fv = REDUNDANCY_SIX.canon(F, tuple(F.pow(x, F.p) for x in representative))
        target = min(orbit(F, fv))
        assert target == row["frobenius_to_representative_index"]
        assert target in reps
        frobenius[row["representative_index"]] = target
        if row["persistent"]:
            persistent_orbits += 1
        elif row["central_nucleus"]:
            central_orbits += 1
        else:
            exceptional_profile[row["size"]] = exceptional_profile.get(row["size"], 0) + 1

    assert len(seen) == record["deep_count"]
    assert sum(row["size"] for row in record["orbits"]) == record["deep_count"]
    assert persistent_orbits == expected_persistent_orbits(F)
    assert sum(row["size"] for row in record["orbits"] if row["persistent"]) == (
        q * (q + 1) ** 2 // 2
    )
    assert central_orbits == int(F.p == 2 and F.m % 2 == 1)
    assert exceptional_profile == EXCEPTIONAL_PROFILES.get(q, {})
    if q in (16, 17):
        expected_pointed = q * (q + 1) ** 2 // 2 + q * q - q + 1
        assert record["pointed_bad_count"] == expected_pointed
    if q >= 16:
        assert record["pointed_method"] == "exact affine-stabilizer orbit reduction"
        assert record["affine_orbit_count"] >= record["pointed_bad_affine_orbit_count"]
        pointed_reps = record["pointed_bad_affine_representatives"]
        assert len(pointed_reps) == record["pointed_bad_affine_orbit_count"]
        assert len(set(pointed_reps)) == len(pointed_reps)

    unseen = set(frobenius)
    cycles = 0
    while unseen:
        cycles += 1
        current = unseen.pop()
        while frobenius[current] in unseen:
            current = frobenius[current]
            unseen.remove(current)
    assert cycles == record["pgammal_orbit_count"]
    print(
        f"q={q}: deep={record['deep_count']} "
        f"PGL={record['pgl_orbit_count']} "
        f"PGammaL={record['pgammal_orbit_count']}: PASS",
        flush=True,
    )


def main():
    payload = json.loads(DATA_PATH.read_text())
    assert payload["schema"] == "redundancy_seven_calibration-prs-redundancy-seven-calibration-v1"
    assert tuple(row["q"] for row in payload["fields"]) == FIELDS
    for record in payload["fields"]:
        replay_field(record)
    print("REDUNDANCY_SEVEN_CALIBRATION bounded-field independent replay: ALL CHECKS PASS")


if __name__ == "__main__":
    main()
