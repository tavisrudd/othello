#!/usr/bin/env python3
"""Exact ID-3 orbit model strengthened by the 9-compression quotient."""

from __future__ import annotations

import json
import os
import sys
import time

from ortools.sat.python import cp_model

LENGTH = 333
COMPRESSED_LENGTH = 9
SUBGROUP = (1, 10, 100)


def multiplication_orbits() -> list[list[int]]:
    unseen = set(range(LENGTH))
    orbits: list[list[int]] = []
    while unseen:
        seed = min(unseen)
        orbit = sorted({seed * multiplier % LENGTH for multiplier in SUBGROUP})
        unseen.difference_update(orbit)
        orbits.append(orbit)
    return orbits


def build_model(
    compression: bool, compression37: bool, fixed_signature: tuple[int, ...] | None
) -> tuple[
    cp_model.CpModel, list[cp_model.IntVar], list[cp_model.IntVar], list[list[int]]
]:
    orbits = multiplication_orbits()
    if len(orbits) != 117 or orbits[0] != [0]:
        raise RuntimeError("ID-3 orbit census drifted")
    orbit_index = [0] * LENGTH
    for index, orbit in enumerate(orbits):
        for point in orbit:
            orbit_index[point] = index

    model = cp_model.CpModel()
    za = [model.new_bool_var(f"za{index}") for index in range(len(orbits))]
    zb = [model.new_bool_var(f"zb{index}") for index in range(len(orbits))]
    if not compression:
        model.add(za[0] == 0)
        model.add(zb[0] == 0)

    representatives = [orbit[0] for orbit in orbits[1:]]
    weights_by_shift: list[dict[tuple[int, int], int]] = []
    used_pairs: set[tuple[int, int]] = set()
    for shift in representatives:
        directed: dict[tuple[int, int], int] = {}
        for point in range(LENGTH):
            left = orbit_index[point]
            right = orbit_index[(point + shift) % LENGTH]
            directed[(left, right)] = directed.get((left, right), 0) + 1
        weights: dict[tuple[int, int], int] = {}
        for left in range(len(orbits)):
            for right in range(left + 1, len(orbits)):
                weight = directed.get((left, right), 0) + directed.get((right, left), 0)
                if weight:
                    weights[(left, right)] = weight
                    used_pairs.add((left, right))
        diagonal = sum(directed.get((index, index), 0) for index in range(len(orbits)))
        if diagonal + sum(weights.values()) != LENGTH:
            raise RuntimeError("orbit PAF weights do not partition the 333 terms")
        sample = [1 if index % 3 else -1 for index in range(len(orbits))]
        encoded = diagonal + sum(
            weight * sample[left] * sample[right]
            for (left, right), weight in weights.items()
        )
        direct = sum(
            sample[orbit_index[point]] * sample[orbit_index[(point + shift) % LENGTH]]
            for point in range(LENGTH)
        )
        if encoded != direct:
            raise RuntimeError("orbit PAF weights failed direct arithmetic replay")
        weights_by_shift.append(weights)

    def xor_variables(primary: list[cp_model.IntVar], prefix: str) -> dict[tuple[int, int], cp_model.IntVar]:
        result: dict[tuple[int, int], cp_model.IntVar] = {}
        for left, right in sorted(used_pairs):
            xor = model.new_bool_var(f"{prefix}_{left}_{right}")
            model.add(xor <= primary[left] + primary[right])
            model.add(xor >= primary[left] - primary[right])
            model.add(xor >= primary[right] - primary[left])
            model.add(xor <= 2 - primary[left] - primary[right])
            result[(left, right)] = xor
        return result

    wa = xor_variables(za, "wa")
    wb = xor_variables(zb, "wb")
    for weights in weights_by_shift:
        model.add(
            sum(weight * (wa[pair] + wb[pair]) for pair, weight in weights.items())
            == 334
        )

    orbit_sizes = [len(orbit) for orbit in orbits]
    for primary in (za, zb):
        negative_weight = sum(
            orbit_sizes[index] * primary[index] for index in range(len(orbits))
        )
        if compression:
            model.add(negative_weight == 166)
        else:
            model.add(negative_weight >= 166)
            model.add(negative_weight <= 167)

    if not compression:
        return model, za, zb, orbits

    columns = [[] for _ in range(COMPRESSED_LENGTH)]
    for index, orbit in enumerate(orbits):
        residue = orbit[0] % COMPRESSED_LENGTH
        if any(point % COMPRESSED_LENGTH != residue for point in orbit):
            raise RuntimeError("ID-3 multiplication orbit crossed a mod-9 column")
        columns[residue].append(index)

    compressed: list[list[cp_model.IntVar]] = []
    squares: list[list[cp_model.IntVar]] = []
    allowed = [(value, value * value) for value in range(-37, 38, 2)]
    for label, primary in (("a", za), ("b", zb)):
        values: list[cp_model.IntVar] = []
        value_squares: list[cp_model.IntVar] = []
        for column, members in enumerate(columns):
            value = model.new_int_var(-37, 37, f"c{label}{column}")
            square = model.new_int_var(1, 1369, f"q{label}{column}")
            model.add(
                value
                == 37
                - 2
                * sum(orbit_sizes[index] * primary[index] for index in members)
            )
            model.add_allowed_assignments([value, square], allowed)
            values.append(value)
            value_squares.append(square)
        compressed.append(values)
        squares.append(value_squares)
        minimum = model.new_int_var(-37, 37, f"minimum_{label}")
        model.add_min_equality(minimum, values)
        model.add(values[0] == minimum)
        place_values = [75 ** (COMPRESSED_LENGTH - 1 - index) for index in range(COMPRESSED_LENGTH)]
        score = sum(place_values[index] * values[index] for index in range(COMPRESSED_LENGTH))
        for shift in range(1, COMPRESSED_LENGTH):
            rotated = sum(
                place_values[index] * values[(index + shift) % COMPRESSED_LENGTH]
                for index in range(COMPRESSED_LENGTH)
            )
            model.add(score <= rotated)
        reflected = sum(
            place_values[index] * values[-index % COMPRESSED_LENGTH]
            for index in range(COMPRESSED_LENGTH)
        )
        model.add(score <= reflected)

    energies = [sum(sequence_squares) for sequence_squares in squares]
    model.add(energies[0] + energies[1] == 594)
    if fixed_signature is not None:
        model.add(energies[0] == fixed_signature[0])
    for shift in range(1, 5):
        pafs = []
        for sequence, label in zip(compressed, ("a", "b"), strict=True):
            products: list[cp_model.IntVar] = []
            for column in range(COMPRESSED_LENGTH):
                product = model.new_int_var(-1369, 1369, f"p{label}_{shift}_{column}")
                model.add_multiplication_equality(
                    product,
                    [sequence[column], sequence[(column + shift) % COMPRESSED_LENGTH]],
                )
                products.append(product)
            pafs.append(sum(products))
        model.add(pafs[0] + pafs[1] == -74)
        if fixed_signature is not None:
            model.add(pafs[0] == fixed_signature[shift])

    if compression37:
        unseen = set(range(37))
        residue_orbits: list[list[int]] = []
        while unseen:
            seed = min(unseen)
            orbit = sorted({seed * multiplier % 37 for multiplier in SUBGROUP})
            unseen.difference_update(orbit)
            residue_orbits.append(orbit)
        if len(residue_orbits) != 13 or residue_orbits[0] != [0]:
            raise RuntimeError("ID-3 mod-37 residue orbit census drifted")
        residue_index = [0] * 37
        for index, orbit in enumerate(residue_orbits):
            for residue in orbit:
                residue_index[residue] = index

        values37: list[list[cp_model.IntVar]] = []
        squares37: list[list[cp_model.IntVar]] = []
        products37: list[dict[tuple[int, int], cp_model.IntVar]] = []
        allowed37 = [(value, value * value) for value in range(-9, 10, 2)]
        for label, primary in (("a", za), ("b", zb)):
            values: list[cp_model.IntVar] = []
            value_squares: list[cp_model.IntVar] = []
            for index, orbit in enumerate(residue_orbits):
                representative = orbit[0]
                members = [
                    orbit_index[point]
                    for point in range(LENGTH)
                    if point % 37 == representative
                ]
                value = model.new_int_var(-9, 9, f"d{label}{index}")
                square = model.new_int_var(1, 81, f"r{label}{index}")
                model.add(value == 9 - 2 * sum(primary[member] for member in members))
                model.add_allowed_assignments([value, square], allowed37)
                values.append(value)
                value_squares.append(square)
            products: dict[tuple[int, int], cp_model.IntVar] = {}
            for left in range(len(residue_orbits)):
                for right in range(left + 1, len(residue_orbits)):
                    product = model.new_int_var(-81, 81, f"u{label}_{left}_{right}")
                    model.add_multiplication_equality(product, [values[left], values[right]])
                    products[(left, right)] = product
            values37.append(values)
            squares37.append(value_squares)
            products37.append(products)

        model.add(
            sum(
                len(residue_orbits[index]) * squares37[sequence][index]
                for sequence in range(2)
                for index in range(len(residue_orbits))
            )
            == 650
        )
        for shift_orbit in residue_orbits[1:]:
            shift = shift_orbit[0]
            weights: dict[tuple[int, int], int] = {}
            for residue in range(37):
                left = residue_index[residue]
                right = residue_index[(residue + shift) % 37]
                pair = (min(left, right), max(left, right))
                weights[pair] = weights.get(pair, 0) + 1
            pafs = []
            for sequence in range(2):
                terms = []
                for (left, right), weight in weights.items():
                    value = (
                        squares37[sequence][left]
                        if left == right
                        else products37[sequence][(left, right)]
                    )
                    terms.append(weight * value)
                pafs.append(sum(terms))
            model.add(pafs[0] + pafs[1] == -18)

    return model, za, zb, orbits


def main() -> None:
    compression = os.environ.get("ERGODIS_ID3_COMPRESSION", "1") != "0"
    compression37 = os.environ.get("ERGODIS_ID3_COMPRESSION37", "1") != "0"
    fixed_signature = None
    if value := os.environ.get("ERGODIS_ID3_SIGNATURE"):
        fixed_signature = tuple(int(item) for item in value.split(","))
        if len(fixed_signature) != 5 or not compression:
            raise ValueError("ERGODIS_ID3_SIGNATURE needs five integers and compression enabled")
    model, za, zb, orbits = build_model(compression, compression37, fixed_signature)
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = float(os.environ.get("ERGODIS_ID3_SECONDS", "300"))
    solver.parameters.num_search_workers = int(os.environ.get("ERGODIS_ID3_WORKERS", "16"))
    started = time.perf_counter()
    status = solver.solve(model)
    elapsed = time.perf_counter() - started
    record: dict[str, object] = {
        "subgroup_id": 3,
        "subgroup": list(SUBGROUP),
        "orbit_count": len(orbits),
        "compression_quotient": compression,
        "compression37_quotient": compression37,
        "fixed_signature": fixed_signature,
        "variables": len(model.proto.variables),
        "constraints": len(model.proto.constraints),
        "status": solver.status_name(status),
        "elapsed_seconds": elapsed,
        "branches": solver.num_branches,
        "conflicts": solver.num_conflicts,
    }
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        orbit_a = [1 - 2 * solver.value(variable) for variable in za]
        orbit_b = [1 - 2 * solver.value(variable) for variable in zb]
        point_to_orbit = [0] * LENGTH
        for index, orbit in enumerate(orbits):
            for point in orbit:
                point_to_orbit[point] = index
        a = [orbit_a[point_to_orbit[point]] for point in range(LENGTH)]
        b = [orbit_b[point_to_orbit[point]] for point in range(LENGTH)]
        valid = abs(sum(a)) == 1 and abs(sum(b)) == 1
        for shift in range(1, LENGTH):
            valid &= (
                sum(a[index] * a[(index + shift) % LENGTH] for index in range(LENGTH))
                + sum(b[index] * b[(index + shift) % LENGTH] for index in range(LENGTH))
                == -2
            )
        if not valid:
            raise RuntimeError("CP-SAT incumbent failed direct length-333 replay")
        record["verified_legendre_pair"] = True
        record["a_orbit_values"] = orbit_a
        record["b_orbit_values"] = orbit_b
    text = json.dumps(record, indent=2) + "\n"
    if len(sys.argv) == 1:
        print(text, end="")
    else:
        with open(sys.argv[1], "x", encoding="utf-8") as stream:
            stream.write(text)


if __name__ == "__main__":
    main()
