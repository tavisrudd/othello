#!/usr/bin/env python3
"""Derive intrinsic labels for C498's frozen small exceptional orbits.

This is a read-only analysis of the canonical C498 census certificate.  It
reconstructs the unique apolar cubic of every trivial-gcd quintic syndrome,
checks it by two independent kernel calculations, constructs the complete
pointed first-polar quotient-pencil profile, and verifies that its shared-root
collision energy, plus the odd-characteristic quintic root type, separates
exactly the PGammaL2 orbits.

Run from the repository root:

  python3 notes/2026-07-23-c498-small-exceptional-normal-forms.py
"""

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from itertools import combinations
from math import comb
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


def one_plus_three_rational_root(F, quartic):
    """Return the unique rational root of a binary quartic of type 1+3."""
    coefficients = list(quartic)
    while len(coefficients) > 1 and coefficients[-1] == 0:
        coefficients.pop()
    infinity_multiplicity = 4 - (len(coefficients) - 1)
    rational_factors = []
    if infinity_multiplicity:
        rational_factors.append((None, infinity_multiplicity))

    for root in range(F.q):
        multiplicity = 0
        while len(coefficients) > 1 and evaluate(F, coefficients, root) == 0:
            coefficients = divide_linear(F, coefficients, root)
            multiplicity += 1
        if multiplicity:
            rational_factors.append((root, multiplicity))

    if len(rational_factors) != 1 or rational_factors[0][1] != 1:
        return False, None
    # After the unique simple rational factor is removed, the residual
    # homogeneous cubic has no rational projective root and is irreducible.
    return True, rational_factors[0][0]


def direct_net_collision_energy(replay, F, quintic):
    basis = replay.nullspace(F, [quintic[:5], quintic[1:]], 5)
    assert len(basis) == 3
    root_counts = Counter()
    for coefficients in replay.pg_points(F.q, 3):
        quartic = tuple(
            sum_field(F, (F.mul(c, b[i])
                          for c, b in zip(coefficients, basis)))
            for i in range(5)
        )
        is_one_plus_three, root = one_plus_three_rational_root(F, quartic)
        if is_one_plus_three:
            root_counts[root] += 1
    member_count = sum(root_counts.values())
    energy = sum(count * (count - 1) // 2 for count in root_counts.values())
    return member_count, energy


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
    signature = (collision_energy(record["polar_profile"]),)
    # In odd characteristic the ordinary binary-quintic root divisor is an
    # intrinsic covariant of the divided-power syndrome.  In characteristic
    # two the frozen descriptive label is not Frobenius-stable, so it is not
    # used as a classifier.
    if F.p != 2:
        signature += (record["quintic_factor_type"],)
    return signature


def projected_polar_profile(profile, factor_types):
    projected = Counter()
    for histogram, marker_count in profile:
        counts = dict(histogram)
        key = tuple(counts.get(factor_type, 0) for factor_type in factor_types)
        projected[key] += marker_count
    return tuple(sorted(projected.items()))


def projected_signature(F, record, factor_types):
    signature = (
        projected_polar_profile(record["polar_profile"], factor_types),
    )
    if F.p != 2:
        signature += (record["quintic_factor_type"],)
    return signature


def polar_moments(profile, degrees):
    spectrum = projected_polar_profile(profile, ("3",))
    return tuple(
        sum(marker_count * counts[0] ** degree
            for counts, marker_count in spectrum)
        for degree in degrees
    )


def collision_energy(profile):
    first, second = polar_moments(profile, (1, 2))
    assert (second - first) % 2 == 0
    return (second - first) // 2


def irreducible_root_load_distribution(profile):
    spectrum = projected_polar_profile(profile, ("3",))
    return {
        counts[0]: marker_count
        for counts, marker_count in spectrum
    }


def verify_factorial_energy_inversion(profile):
    loads = irreducible_root_load_distribution(profile)
    maximum = max(loads, default=0)
    energies = [
        sum(marker_count * comb(load, degree)
            for load, marker_count in loads.items())
        for degree in range(maximum + 1)
    ]
    recovered = {
        load: sum(
            (-1) ** (degree - load) * comb(degree, load) * energies[degree]
            for degree in range(load, maximum + 1)
        )
        for load in range(maximum + 1)
    }
    assert recovered == {
        load: loads.get(load, 0) for load in range(maximum + 1)
    }


def moment_signature(F, record, degrees):
    signature = (polar_moments(record["polar_profile"], degrees),)
    if F.p != 2:
        signature += (record["quintic_factor_type"],)
    return signature


def signature_classes(F, records, factor_types=None):
    groups = {}
    for record in records:
        signature = (
            invariant_signature(F, record)
            if factor_types is None
            else projected_signature(F, record, factor_types)
        )
        groups.setdefault(signature, []).append(record["rep_index"])
    return sorted(tuple(sorted(indices)) for indices in groups.values())


def moment_signature_classes(F, records, degrees):
    groups = {}
    for record in records:
        signature = moment_signature(F, record, degrees)
        groups.setdefault(signature, []).append(record["rep_index"])
    return sorted(tuple(sorted(indices)) for indices in groups.values())


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
                "shared_root_collision_energy_of_1_plus_3_net_members",
                "binary_quintic_factor_type",
            ],
            "characteristic_two": [
                "shared_root_collision_energy_of_1_plus_3_net_members",
            ],
        },
        "fields": {},
    }
    classification_instances = []
    for q in FIELDS:
        F = replay.GF(q)
        records = []
        for orbit in data["fields"][str(q)]["pgl2_orbits"]:
            if orbit["net_gcd_deg"] != 0:
                continue
            cubic = apolar_cubic(replay, F, tuple(orbit["rep"]))
            profile = polar_profile(replay, F, tuple(orbit["rep"]))
            verify_factorial_energy_inversion(profile)
            assert polar_moments(profile, (1,))[0] == (
                orbit["member_hist"].get("1+3", 0)
            )
            direct_count, direct_energy = direct_net_collision_energy(
                replay, F, tuple(orbit["rep"])
            )
            assert direct_count == orbit["member_hist"].get("1+3", 0)
            assert direct_energy == collision_energy(profile)
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
                "polar_profile": profile,
            }
            records.append(record)
        total += len(records)

        cycles = frobenius_cycles(records)
        cycle_classes = sorted(tuple(sorted(cycle)) for cycle in cycles)
        assert signature_classes(F, records) == cycle_classes
        classification_instances.append((F, records, cycle_classes))

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
                "irreducible_cubic_polar_moments": {
                    str(degree): value
                    for degree, value in zip(
                        (1, 2, 3),
                        polar_moments(record["polar_profile"], (1, 2, 3)),
                    )
                },
                "shared_root_collision_energy":
                    collision_energy(record["polar_profile"]),
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

    factor_types = sorted({
        factor_type
        for _, records, _ in classification_instances
        for record in records
        for histogram, _ in record["polar_profile"]
        for factor_type, _ in histogram
    })
    minimal_coordinate_sets = []
    for size in range(len(factor_types) + 1):
        for subset in combinations(factor_types, size):
            if all(
                signature_classes(F, records, subset) == cycle_classes
                for F, records, cycle_classes in classification_instances
            ):
                minimal_coordinate_sets.append(list(subset))
        if minimal_coordinate_sets:
            break
    certificate["polar_profile_ablation"] = {
        "available_factor_coordinates": factor_types,
        "minimum_coordinate_count": len(minimal_coordinate_sets[0]),
        "all_minimum_coordinate_sets": minimal_coordinate_sets,
        "odd_characteristic_root_type_retained": True,
    }

    candidate_degrees = tuple(range(1, 11))
    first_moment_cutoff = next(
        cutoff
        for cutoff in range(len(candidate_degrees) + 1)
        if all(
            moment_signature_classes(
                F, records, candidate_degrees[:cutoff]
            ) == cycle_classes
            for F, records, cycle_classes in classification_instances
        )
    )
    minimum_moment_sets = []
    for size in range(len(candidate_degrees) + 1):
        for degrees in combinations(candidate_degrees, size):
            if all(
                moment_signature_classes(F, records, degrees)
                == cycle_classes
                for F, records, cycle_classes in classification_instances
            ):
                minimum_moment_sets.append(list(degrees))
        if minimum_moment_sets:
            break
    certificate["irreducible_cubic_spectrum_ablation"] = {
        "candidate_moment_degrees": list(candidate_degrees),
        "least_initial_moment_count": first_moment_cutoff,
        "minimum_moment_count": len(minimum_moment_sets[0]),
        "all_minimum_moment_degree_sets": minimum_moment_sets,
        "odd_characteristic_root_type_retained": True,
    }
    certificate["collision_energy_identity"] = {
        "first_moment": "number_of_1_plus_3_quartic_net_members",
        "energy_formula": "(second_moment-first_moment)/2",
        "interpretation":
            "unordered_pairs_of_1_plus_3_members_with_the_same_rational_root",
        "energy_plus_odd_root_type_classifies_pgammal2": True,
    }
    zero_energy_orbits = [
        {"q": F.q, "pgl2_rep_index": record["rep_index"]}
        for F, records, _ in classification_instances
        for record in records
        if collision_energy(record["polar_profile"]) == 0
    ]
    assert zero_energy_orbits == [{"q": 8, "pgl2_rep_index": 64}]
    certificate["zero_energy_small_exceptional_orbits"] = zero_energy_orbits
    zero_mass_orbits = [
        {"q": F.q, "pgl2_rep_index": record["rep_index"]}
        for F, records, _ in classification_instances
        for record in records
        if polar_moments(record["polar_profile"], (1,))[0] == 0
    ]
    assert zero_mass_orbits == zero_energy_orbits
    certificate["zero_1_plus_3_mass_small_exceptional_orbits"] = (
        zero_mass_orbits
    )
    certificate["factorial_energy_inversion"] = {
        "formula":
            "E_k=sum_j binom(j,k)m_j; "
            "m_j=sum_(k>=j)(-1)^(k-j)binom(k,j)E_k",
        "verified_for_all_36_exceptional_pgl2_orbits": True,
    }
    s3_characters = {
        "identity": (1, 1, 2),
        "transposition": (1, -1, 0),
        "three_cycle": (1, 1, -1),
    }
    assert {
        conjugacy_class: (trivial + sign - standard) // 3
        for conjugacy_class, (trivial, sign, standard)
        in s3_characters.items()
    } == {"identity": 0, "transposition": 0, "three_cycle": 1}
    certificate["s3_irreducible_cubic_character_identity"] = {
        "formula": "1_(three_cycle)=(chi_triv+chi_sign-chi_std)/3",
        "verified_on_all_conjugacy_classes": True,
    }
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
