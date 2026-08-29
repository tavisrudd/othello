#!/usr/bin/env python3
"""Search for a signed-permutation basis of rank-seven type-I1 lattices."""

import itertools
import math
import runpy

import sympy as sp


d = runpy.run_path(
    "notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.py"
)
group = d["group_i1"]
root_basis = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)
root_left_inverse = (root_basis.T * root_basis).inv() * root_basis.T
root_actions = {
    value: root_left_inverse * d["old_actions"][value][:6, :6] * root_basis
    for value in group
}


def augmentation_three(permutation_action):
    return sp.Matrix.hstack(
        permutation_action[:2, 0] - permutation_action[:2, 2],
        permutation_action[:2, 1] - permutation_action[:2, 2],
    )


def quotient_three(permutation_action):
    result = sp.zeros(2)
    for column in range(2):
        result[:, column] = (
            permutation_action[:2, column]
            - permutation_action[2, column] * sp.ones(2, 1)
        )
    return result


i_actions = {
    value: augmentation_three(d["old_actions"][value][6:9, 6:9])
    for value in group
}
j_actions = {
    value: quotient_three(d["old_actions"][value][6:9, 6:9])
    for value in group
}


def canonical_line(vector):
    entries = tuple(int(entry) for entry in vector)
    divisor = math.gcd(*(abs(entry) for entry in entries if entry))
    entries = tuple(entry // divisor for entry in entries)
    first = next(entry for entry in entries if entry)
    return entries if first > 0 else tuple(-entry for entry in entries)


def find_basis(actions, bound):
    matrices = list(actions.values())
    orbits = {}
    for entries in itertools.product(range(-bound, bound + 1), repeat=7):
        if not any(entries) or math.gcd(*(abs(entry) for entry in entries)) != 1:
            continue
        vector = sp.Matrix(entries)
        orbit = frozenset(canonical_line(matrix * vector) for matrix in matrices)
        if len(orbit) > 7 or orbit in orbits:
            continue
        orbit_matrix = sp.Matrix.hstack(*(sp.Matrix(item) for item in sorted(orbit)))
        if orbit_matrix.rank() == len(orbit):
            orbits[orbit] = orbit_matrix
    candidates = sorted(orbits.values(), key=lambda matrix: matrix.cols)
    print("bound", bound, "independent_line_orbits", {
        size: sum(matrix.cols == size for matrix in candidates)
        for size in sorted({matrix.cols for matrix in candidates})
    })

    def visit(start, total, blocks):
        if total == 7:
            candidate = sp.Matrix.hstack(*blocks)
            if candidate.det() in (-1, 1):
                return candidate
            return None
        for index in range(start, len(candidates)):
            block = candidates[index]
            if total + block.cols > 7:
                continue
            combined = sp.Matrix.hstack(*blocks, block)
            if combined.rank() != combined.cols:
                continue
            result = visit(index + 1, total + block.cols, [*blocks, block])
            if result is not None:
                return result
        return None

    return visit(0, 0, [])


for root_variant in ("column", "dual"):
    for auxiliary_name, auxiliary in (("I", i_actions), ("J", j_actions)):
        actions = {}
        for value in group:
            root = root_actions[value]
            if root_variant == "dual":
                root = root.inv().T
            actions[value] = sp.diag(root, auxiliary[value])
        print("VARIANT", root_variant, auxiliary_name)
        for bound in (1, 2):
            basis = find_basis(actions, bound)
            print("RESULT", "bound", bound, "basis", basis)
            if basis is not None:
                break
