#!/usr/bin/env sage
"""Exact exceptional-subgroup head data for the C665 Platinum seam.

The finite rows compute head multiplicities of the projective permutation
modules k[PSL(2,q)/K] from defining-characteristic decomposition matrices.
An independent binary-polyhedral character average gives the uniform
Steinberg-digit candidates, including the small-characteristic rows.
"""

import argparse
import itertools
import json
from pathlib import Path

from sage.all import CyclotomicField, QQ, GF, lcm, matrix, vector
from sage.libs.gap.libgap import libgap


EXCEPTIONAL_ORDERS = {"A4": 12, "S4": 24, "A5": 60}
ROTATION_CLASSES = {
    # (class size, order of one chosen lift in the binary polyhedral group)
    "A4": ((1, 1), (3, 4), (8, 6)),
    "S4": ((1, 1), (9, 4), (8, 6), (6, 8)),
    "A5": ((1, 1), (15, 4), (20, 6), (12, 10), (12, 5)),
}
CF = CyclotomicField(lcm([order for rows in ROTATION_CLASSES.values() for _, order in rows]))
ZETA = CF.gen()
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c665-exceptional-head-table.json"


def structure_name(group):
    return str(libgap.StructureDescription(group))


def exceptional_subgroup(group, name):
    """Return one embedded subgroup of the requested exceptional type."""
    order = EXCEPTIONAL_ORDERS[name]
    maximal = list(libgap.MaximalSubgroups(group))
    for subgroup in maximal:
        if int(libgap.Size(subgroup)) == order and structure_name(subgroup) == name:
            return subgroup
    for parent in maximal:
        parent_order = int(libgap.Size(parent))
        if parent_order <= order or parent_order > 1000:
            continue
        for subgroup_class in libgap.ConjugacyClassesSubgroups(parent):
            subgroup = libgap.Representative(subgroup_class)
            if int(libgap.Size(subgroup)) == order and structure_name(subgroup) == name:
                return subgroup
    raise ValueError(f"no embedded {name} found")


def head_record(q, name):
    """Compute PIM-head multiplicities in k[H/K], H=PSL(2,q)."""
    p = int(GF(q).characteristic())
    group = libgap.PSL(2, q)
    subgroup = exceptional_subgroup(group, name)
    assert int(libgap.Size(subgroup)) == EXCEPTIONAL_ORDERS[name]
    assert int(libgap.Size(subgroup)) % p != 0

    ordinary_table = libgap.CharacterTable(group)
    named_table = libgap.CharacterTable(f"L2({q})")
    permutation_character = libgap.PermutationCharacter(group, subgroup)
    ordinary_irreducibles = libgap.Irr(ordinary_table)
    actual_multiplicities = vector(
        QQ,
        [
            int(libgap.ScalarProduct(permutation_character, constituent))
            for constituent in ordinary_irreducibles
        ],
    )

    transform = libgap.TransformingPermutationsCharacterTables(
        ordinary_table, named_table
    )
    row_permutation = [
        int(value) - 1
        for value in transform["rows"].ListPerm(len(ordinary_irreducibles))
    ]
    inverse_row_permutation = [
        row_permutation.index(i) for i in range(len(row_permutation))
    ]

    brauer_table = libgap.BrauerTable(named_table, p)
    if brauer_table == libgap.fail:
        raise ValueError(f"no defining-characteristic Brauer table for L2({q})")
    decomposition = matrix(
        QQ,
        [
            [int(entry) for entry in row]
            for row in libgap.DecompositionMatrix(brauer_table)
        ],
    )
    named_ordinary_degrees = vector(
        QQ, [int(constituent[0]) for constituent in libgap.Irr(named_table)]
    )
    head_multiplicities = None
    for permutation in (row_permutation, inverse_row_permutation):
        candidate_multiplicities = vector(
            QQ, [actual_multiplicities[i] for i in permutation]
        )
        candidate_heads = decomposition.solve_right(candidate_multiplicities)
        if not all(
            value.denominator() == 1 and value >= 0 for value in candidate_heads
        ):
            continue
        candidate_heads = vector(QQ, [int(value) for value in candidate_heads])
        pim_dimensions = decomposition.transpose() * named_ordinary_degrees
        if candidate_heads * pim_dimensions == int(libgap.Index(group, subgroup)):
            head_multiplicities = [int(value) for value in candidate_heads]
            break
    if head_multiplicities is None:
        raise AssertionError("character-table transport did not yield projective heads")

    brauer_irreducibles = libgap.Irr(brauer_table)
    simple_dimensions = [int(constituent[0]) for constituent in brauer_irreducibles]
    heads = [
        {"dimension": dimension, "multiplicity": multiplicity}
        for dimension, multiplicity in zip(simple_dimensions, head_multiplicities)
        if multiplicity
    ]
    index = int(libgap.Index(group, subgroup))
    record = {
        "q": q,
        "p": p,
        "subgroup": name,
        "subgroup_order": EXCEPTIONAL_ORDERS[name],
        "sheet_size": index,
        "lambda": index // q,
        "heads": heads,
        "nonnegligible_nonprincipal_heads": [
            entry
            for entry in heads
            if entry["dimension"] != 1 and entry["dimension"] % p != 0
        ],
    }
    candidate = minimal_nonnegligible_candidate(name, p, GF(q).degree())
    record["direct_invariant_candidate"] = candidate
    if candidate is not None:
        assert any(
            entry["dimension"] == candidate["dimension"] for entry in heads
        )
    return record


def symmetric_trace(degree, eigenvalue):
    return sum(eigenvalue ** (degree - 2 * j) for j in range(degree + 1))


def fixed_dimension(name, p, digits):
    """Average the Steinberg-digit character over the binary lift of K."""
    total = CF.zero()
    conductor = CF.zeta_order()
    for class_size, lift_order in ROTATION_CLASSES[name]:
        eigenvalue = ZETA ** (conductor // lift_order)
        value = CF.one()
        for frobenius_index, digit in enumerate(digits):
            value *= symmetric_trace(
                digit, eigenvalue ** (p**frobenius_index)
            )
        total += class_size * value
    answer = total / EXCEPTIONAL_ORDERS[name]
    assert answer in QQ and QQ(answer).denominator() == 1
    return int(answer)


def minimal_nonnegligible_candidate(name, p, extension_degree):
    """Find the smallest nontrivial PSL2-simple with K-fixed vectors.

    Digits equal to p-1 are omitted: exactly those simples have dimension
    zero in characteristic p and cannot serve H1.
    """
    candidates = []
    for digits in itertools.product(range(p - 1), repeat=extension_degree):
        if not any(digits) or sum(digits) % 2:
            continue
        invariants = fixed_dimension(name, p, digits)
        if invariants:
            dimension = 1
            for digit in digits:
                dimension *= digit + 1
            candidates.append((dimension, digits, invariants))
    if not candidates:
        return None
    dimension, digits, invariants = min(candidates)
    return {
        "steinberg_digits": list(digits),
        "dimension": dimension,
        "fixed_dimension": invariants,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--case",
        action="append",
        default=[],
        help="exceptional case NAME:q, repeatable",
    )
    parser.add_argument(
        "--candidate",
        action="append",
        default=[],
        help="direct binary-polyhedral invariant case NAME:p:e, repeatable",
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    cases = args.case or [
        "A4:5",
        "A4:7",
        "A4:11",
        "A4:25",
        "A4:49",
        "S4:7",
        "S4:17",
        "S4:25",
        "S4:49",
        "A5:11",
        "A5:19",
        "A5:29",
        "A5:31",
        "A5:49",
    ]
    records = []
    for case in cases:
        name, q_text = case.split(":")
        records.append(head_record(int(q_text), name))
    candidate_cases = args.candidate or [
        "A4:5:1",
        "A4:5:2",
        "A4:7:1",
        "A4:7:2",
        "A4:11:1",
        "S4:5:2",
        "S4:7:1",
        "S4:7:2",
        "S4:11:1",
        "A5:7:2",
        "A5:11:1",
        "A5:11:2",
        "A5:13:2",
        "A5:17:1",
    ]
    candidate_records = []
    for case in candidate_cases:
        name, p_text, degree_text = case.split(":")
        p = int(p_text)
        extension_degree = int(degree_text)
        candidate_records.append(
            {
                "subgroup": name,
                "p": p,
                "extension_degree": extension_degree,
                "candidate": minimal_nonnegligible_candidate(
                    name, p, extension_degree
                ),
            }
        )
    encoded = (
        json.dumps(
            {
                "schema": 1,
                "head_records": records,
                "direct_invariant_records": candidate_records,
            },
            default=int,
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
