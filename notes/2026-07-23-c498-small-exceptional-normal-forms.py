#!/usr/bin/env python3
"""Derive intrinsic labels for C498's frozen small exceptional orbits.

This is a read-only analysis of the canonical C498 census certificate.  It
reconstructs the unique apolar cubic of every trivial-gcd quintic syndrome,
checks it by two independent kernel calculations, constructs the complete
pointed first-polar quotient-pencil profile, and verifies that this profile
plus the odd-characteristic quintic root type separates exactly the
PGammaL2 orbits.

Run from the repository root:

  python3 notes/2026-07-23-c498-small-exceptional-normal-forms.py
"""

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
CENSUS = HERE / "2026-07-22-c498-prs-deep-hole-census.json"
REPLAY = HERE / "2026-07-22-c498-prs-deep-hole-replay.py"
OUTPUT = HERE / "2026-07-23-c498-small-exceptional-normal-forms.json"
FIELDS = (7, 8, 9, 11, 13)


def load_replay():
    spec = importlib.util.spec_from_file_location("c498_replay", REPLAY)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def determinant3(F, rows):
    total = 0
    for permutation, sign in (
        ((0, 1, 2), 1),
        ((1, 2, 0), 1),
        ((2, 0, 1), 1),
        ((2, 1, 0), -1),
        ((1, 0, 2), -1),
        ((0, 2, 1), -1),
    ):
        term = 1
        for row, col in enumerate(permutation):
            term = F.mul(term, rows[row][col])
        total = F.add(total, term if sign == 1 else F.neg(term))
    return total


def proportional(F, left, right):
    pivot = next((i for i, x in enumerate(right) if x), None)
    if pivot is None:
        return not any(left)
    scale = F.mul(left[pivot], F.inv(right[pivot]))
    return all(x == F.mul(scale, y) for x, y in zip(left, right))


def apolar_cubic(replay, F, quintic):
    catalecticant = [
        list(quintic[0:4]),
        list(quintic[1:5]),
        list(quintic[2:6]),
    ]
    kernel = replay.nullspace(F, catalecticant, 4)
    assert len(kernel) == 1
    by_elimination = kernel[0]

    # The right kernel of a full-rank 3 x 4 matrix is given by its signed
    # maximal minors.  This is algebraically independent of row reduction.
    by_minors = []
    for omitted in range(4):
        minor = [[row[j] for j in range(4) if j != omitted]
                 for row in catalecticant]
        value = determinant3(F, minor)
        by_minors.append(value if omitted % 2 == 0 else F.neg(value))
    assert any(by_minors)
    assert proportional(F, by_elimination, by_minors)
    assert all(
        sum_field(F, (F.mul(x, y) for x, y in zip(row, by_minors))) == 0
        for row in catalecticant
    )
    return canonical(F, by_minors)


def sum_field(F, values):
    total = 0
    for value in values:
        total = F.add(total, value)
    return total


def canonical(F, vector):
    pivot = next(x for x in vector if x)
    inverse = F.inv(pivot)
    return tuple(F.mul(inverse, x) for x in vector)


def divide_linear(F, coefficients, root):
    """Divide low-to-high p(x) by x-root; require zero remainder."""
    degree = len(coefficients) - 1
    quotient = [0] * degree
    quotient[-1] = coefficients[-1]
    for i in range(degree - 2, -1, -1):
        quotient[i] = F.add(coefficients[i + 1],
                            F.mul(root, quotient[i + 1]))
    assert coefficients[0] == F.neg(F.mul(root, quotient[0]))
    while len(quotient) > 1 and quotient[-1] == 0:
        quotient.pop()
    return quotient


def evaluate(F, coefficients, value):
    total = 0
    for coefficient in reversed(coefficients):
        total = F.add(F.mul(total, value), coefficient)
    return total


def binary_cubic_factor_type(F, cubic):
    coefficients = list(cubic)
    while len(coefficients) > 1 and coefficients[-1] == 0:
        coefficients.pop()
    infinity_multiplicity = 3 - (len(coefficients) - 1)
    factors = []
    if infinity_multiplicity:
        factors.append((1, infinity_multiplicity))

    for root in range(F.q):
        multiplicity = 0
        while len(coefficients) > 1 and evaluate(F, coefficients, root) == 0:
            coefficients = divide_linear(F, coefficients, root)
            multiplicity += 1
        if multiplicity:
            factors.append((1, multiplicity))

    residual_degree = len(coefficients) - 1
    if residual_degree:
        # A residual cubic or quadratic with no rational root is irreducible.
        assert residual_degree in (2, 3)
        factors.append((residual_degree, 1))

    factors.sort()
    return "+".join(
        str(degree) if multiplicity == 1 else f"{degree}^{multiplicity}"
        for degree, multiplicity in factors
    )


def histogram_key(histogram):
    return tuple(sorted(histogram.items()))


def quotient_syndrome(F, quintic, marker):
    if marker is None:
        return tuple(quintic[:5])
    return tuple(
        F.sub(quintic[i + 1], F.mul(marker, quintic[i]))
        for i in range(5)
    )


def cubic_pencil_profile(replay, F, quintic, marker):
    syndrome = quotient_syndrome(F, quintic, marker)
    basis = replay.nullspace(F, [syndrome[:4], syndrome[1:]], 4)
    assert len(basis) == 2
    histogram = Counter()
    split = 0
    marked_split = 0
    for coefficients in replay.pg_points(F.q, 2):
        cubic = tuple(
            sum_field(F, (F.mul(c, b[i])
                          for c, b in zip(coefficients, basis)))
            for i in range(4)
        )
        factor_type = binary_cubic_factor_type(F, cubic)
        histogram[factor_type] += 1
        if factor_type == "1+1+1":
            split += 1
            value = (
                cubic[3]
                if marker is None
                else evaluate(F, cubic, marker)
            )
            marked_split += value == 0
    # For a C498 deep net, every split quotient cubic must contain its
    # prescribed marker; otherwise it lifts to a split squarefree quartic.
    assert split == marked_split
    return histogram_key(histogram)


def polar_profile(replay, F, quintic):
    profiles = Counter(
        cubic_pencil_profile(replay, F, quintic, marker)
        for marker in [None, *range(F.q)]
    )
    return tuple(sorted(profiles.items()))


def invariant_signature(F, record):
    signature = (record["polar_profile"],)
    # In odd characteristic the ordinary binary-quintic root divisor is an
    # intrinsic covariant of the divided-power syndrome.  In characteristic
    # two the frozen descriptive label is not Frobenius-stable, so it is not
    # used as a classifier.
    if F.p != 2:
        signature += (record["quintic_factor_type"],)
    return signature


def frobenius_cycles(records):
    by_index = {record["rep_index"]: record for record in records}
    assert set(by_index) == {
        record["frobenius_maps_to_rep_index"] for record in records
    }
    unseen = set(by_index)
    cycles = []
    while unseen:
        start = min(unseen)
        cycle = []
        current = start
        while current not in cycle:
            assert current in unseen
            cycle.append(current)
            unseen.remove(current)
            current = by_index[current]["frobenius_maps_to_rep_index"]
        assert current == start
        cycles.append(tuple(cycle))
    return cycles


def polar_profile_json(profile):
    return [
        {
            "marker_count": multiplicity,
            "pencil_member_hist": dict(histogram),
        }
        for histogram, multiplicity in profile
    ]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_certificate():
    replay = load_replay()
    data = json.loads(CENSUS.read_text())
    total = 0
    certificate = {
        "schema": "c498-small-exceptional-normal-forms-v1",
        "source": {
            "census": CENSUS.name,
            "census_sha256": sha256(CENSUS),
            "replay": REPLAY.name,
            "replay_sha256": sha256(REPLAY),
        },
        "classifier": {
            "odd_characteristic": [
                "pointed_polar_profile",
                "binary_quintic_factor_type",
            ],
            "characteristic_two": [
                "pointed_polar_profile",
            ],
        },
        "fields": {},
    }
    for q in FIELDS:
        F = replay.GF(q)
        records = []
        for orbit in data["fields"][str(q)]["pgl2_orbits"]:
            if orbit["net_gcd_deg"] != 0:
                continue
            cubic = apolar_cubic(replay, F, tuple(orbit["rep"]))
            record = {
                "rep_index": orbit["rep_index"],
                "rep": tuple(orbit["rep"]),
                "apolar_cubic": cubic,
                "waring_type": binary_cubic_factor_type(F, cubic),
                "quintic_factor_type": orbit["quintic_factor_type"],
                "member_hist": histogram_key(orbit["member_hist"]),
                "size": orbit["size"],
                "stab_order": orbit["stab_order"],
                "frobenius_maps_to_rep_index":
                    orbit["frobenius_maps_to_rep_index"],
                "polar_profile": polar_profile(
                    replay, F, tuple(orbit["rep"])
                ),
            }
            records.append(record)
        total += len(records)

        groups = {}
        for record in records:
            signature = invariant_signature(F, record)
            groups.setdefault(signature, []).append(record["rep_index"])
        cycles = frobenius_cycles(records)
        signature_classes = sorted(
            tuple(sorted(indices)) for indices in groups.values()
        )
        cycle_classes = sorted(tuple(sorted(cycle)) for cycle in cycles)
        assert signature_classes == cycle_classes

        by_index = {record["rep_index"]: record for record in records}
        normal_forms = []
        for cycle in cycles:
            representative_index = min(cycle)
            record = by_index[representative_index]
            semilinear_stabilizer = (
                F.m * record["stab_order"] // len(cycle)
            )
            assert (
                semilinear_stabilizer * len(cycle) * record["size"]
                == F.m * data["fields"][str(q)]["pgl2_order"]
            )
            form = {
                "normal_form": list(record["rep"]),
                "pgl2_rep_indices": sorted(cycle),
                "pgl2_orbit_size": record["size"],
                "pgl2_stabilizer_order": record["stab_order"],
                "pgammal2_orbit_size": len(cycle) * record["size"],
                "pgammal2_stabilizer_order": semilinear_stabilizer,
                "frobenius_cycle_length": len(cycle),
                "apolar_cubic": list(record["apolar_cubic"]),
                "apolar_cubic_waring_type": record["waring_type"],
                "quartic_net_member_histogram":
                    dict(record["member_hist"]),
                "pointed_polar_profile":
                    polar_profile_json(record["polar_profile"]),
            }
            if F.p != 2:
                form["binary_quintic_factor_type"] = (
                    record["quintic_factor_type"]
                )
            normal_forms.append(form)
        normal_forms.sort(key=lambda form: tuple(form["normal_form"]))
        certificate["fields"][str(q)] = {
            "characteristic": F.p,
            "extension_degree": F.m,
            "exceptional_pgl2_orbit_count": len(records),
            "exceptional_pgammal2_orbit_count": len(cycles),
            "normal_forms": normal_forms,
        }
    assert total == 36
    return certificate


def serialized(certificate):
    return (
        json.dumps(certificate, indent=2, sort_keys=True, separators=(",", ": "))
        + "\n"
    ).encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--write", action="store_true",
        help="write the canonical certificate to its tracked path",
    )
    parser.add_argument(
        "--summary", action="store_true",
        help="print the bounded field-level classification summary",
    )
    args = parser.parse_args()
    certificate = build_certificate()
    content = serialized(certificate)
    if args.write:
        OUTPUT.write_bytes(content)
    else:
        assert OUTPUT.read_bytes() == content, (
            f"{OUTPUT.name} is stale; regenerate with --write"
        )
    if args.summary:
        for q in FIELDS:
            field = certificate["fields"][str(q)]
            print(
                f"q={q}: {field['exceptional_pgl2_orbit_count']} PGL2 "
                f"orbits -> {field['exceptional_pgammal2_orbit_count']} "
                "intrinsic PGammaL2 normal forms"
            )
    print(f"{OUTPUT.name}: {len(content)} bytes, sha256={hashlib.sha256(content).hexdigest()}")


if __name__ == "__main__":
    main()
