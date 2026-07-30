#!/usr/bin/env python3
"""Independent replay of the C682 all-weight maximal-rank theorem."""

import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
AMBIENT_PATH = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-all-weight-maximal-rank.json"
PRIMES = (1_000_000_007, 1_000_000_009)
FORCED = {0: 1, 1: 2, 2: 3, 6: 3, 10: 3, 11: 2, 12: 1}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


AMBIENT = load(AMBIENT_PATH, "maximal_rank_ambient")


def rank(matrix, prime):
    if not matrix or not matrix[0]:
        return 0
    work = [row[:] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column] % prime
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column] % prime, -1, prime)
        for row in range(pivot_row + 1, len(work)):
            if not work[row][column] % prime:
                continue
            value = work[row][column] * inverse % prime
            work[row] = [
                (left - value * right) % prime
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def falling(value, order, prime):
    out = 1
    for offset in range(order):
        out = out * (value - offset) % prime
    return out


def d1(degree, index, prime):
    return (
        330
        * falling(index, 2, prime)
        * (degree - 4 * index + 6)
    ) % prime


def d11(degree, index, prime):
    return (
        -330
        * falling(degree - index, 2, prime)
        * (3 * degree - 4 * index - 6)
    ) % prime


def selected_diagonal(
    degree_residue, chain_residue, selection, quotient, prime
):
    degree = degree_residue + 20 * quotient
    source = list(range(chain_residue, degree + 1, 5))
    if "source columns 0..|source|-2" in selection:
        source = source[:-1]
    function = d1 if selection.startswith("first") else d11
    return [function(degree, index, prime) for index in source]


def replay_selected_minors(certificate, prime):
    rows = []
    rows.extend(certificate["unforced_even_residues"].values())
    rows.extend(
        row
        for family in certificate["unforced_odd_residues"].values()
        for row in family
    )
    rows.extend(
        certificate["forced_dimension_one_residues"].values()
    )
    for quotient in (13, 1000):
        for row in rows:
            values = selected_diagonal(
                int(
                    next(
                        key
                        for key, value in (
                            list(
                                certificate[
                                    "unforced_even_residues"
                                ].items()
                            )
                            + [
                                (key, item)
                                for key, family in certificate[
                                    "unforced_odd_residues"
                                ].items()
                                for item in family
                            ]
                            + list(
                                certificate[
                                    "forced_dimension_one_residues"
                                ].items()
                            )
                        )
                        if value is row
                    )
                ),
                row["source_residue_mod_5"],
                row["selection"],
                quotient,
                prime,
            )
            assert values and all(values)


def replay_finite_ranks(prime):
    for degree in range(121):
        matrix = AMBIENT.delta_matrix(degree, prime)
        nullity = degree + 1 - rank(matrix, prime)
        assert nullity == FORCED.get(degree % 20, 0)


def replay_leading_coefficient(prime):
    degree = 10
    images = []
    for exponent in range(4):
        vector = [0] * (degree + 1)
        vector[exponent] = 1
        matrix = AMBIENT.delta_matrix(degree, prime)
        image = [
            sum(
                matrix[row][column] * vector[column]
                for column in range(len(vector))
            )
            % prime
            for row in range(len(matrix))
        ]
        images.append(image)

    def shift(vector, amount):
        return [0] * amount + vector[: len(vector) - amount]

    a0 = images[0]
    a1 = [
        (left - right) % prime
        for left, right in zip(images[1], shift(a0, 1))
    ]
    a2 = [
        (
            images[2][index]
            - shift(a0, 2)[index]
            - 2 * shift(a1, 1)[index]
        )
        * pow(2, -1, prime)
        % prime
        for index in range(degree + 7)
    ]
    leading = [
        (
            images[3][index]
            - shift(a0, 3)[index]
            - 3 * shift(a1, 2)[index]
            - 6 * shift(a2, 1)[index]
        )
        * pow(6, -1, prime)
        % prime
        for index in range(degree + 7)
    ]
    expected = [0] * (degree + 7)
    expected[1] = -1320 % prime
    expected[6] = -14520 % prime
    expected[11] = 1320 % prime
    assert leading == expected


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    for prime in PRIMES:
        replay_finite_ranks(prime)
        replay_selected_minors(certificate, prime)
        replay_leading_coefficient(prime)
    print("PASS: independent C682 all-weight maximal-rank replay")


if __name__ == "__main__":
    main()
