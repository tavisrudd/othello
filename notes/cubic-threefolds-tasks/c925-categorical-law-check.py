#!/usr/bin/env python3
"""Finite law checks for the C925 categorical compiler.

This is a sanity model for the algebraic interface, not a verification of the
Iritani, Guere, BFGMP, or KKPYY comparison theorems.
"""

from __future__ import annotations

from collections import Counter
from fractions import Fraction
from itertools import permutations, product
import json


def bag(xs):
    return Counter(xs)


def flatten(xss):
    return [x for xs in xss for x in xs]


def add_obs(left, right):
    return tuple(a + b for a, b in zip(left, right))


def bad_club(obs):
    rho, nu, _nu_prime, _gamma = obs
    return nu != 0 and rho <= 2


def bad_heart(obs):
    _rho, nu, nu_prime, gamma = obs
    return nu != 0 and nu_prime == 0 and gamma <= 1


def separate_spectra(spectra):
    """Choose integral unit shifts making finitely many finite spectra disjoint."""
    shifted = []
    occupied = set()
    shifts = []
    for spectrum in spectra:
        shift = 0
        while any(value + shift in occupied for value in spectrum):
            shift += 1
        translated = {value + shift for value in spectrum}
        assert translated.isdisjoint(occupied)
        occupied.update(translated)
        shifted.append(translated)
        shifts.append(shift)
    return shifts, shifted


def localize(spectrum, carrier_dimension, cutoff):
    return Counter(
        {
            atom: multiplicity
            for atom, multiplicity in spectrum.items()
            if carrier_dimension[atom] > cutoff
        }
    )


def kan_push(counter, coarsen):
    result = Counter()
    for rich, multiplicity in counter.items():
        result[coarsen[rich]] += multiplicity
    return result


def vector(**entries):
    return Counter({key: value for key, value in entries.items() if value})


def scale(counter, scalar):
    return Counter({key: scalar * value for key, value in counter.items()})


def matrix_add(left, right):
    return [
        [a + b for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_multiply(left, right):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def identity(size):
    return [[Fraction(i == j) for j in range(size)] for i in range(size)]


def jordan(size):
    return [
        [Fraction(1 if j == i + 1 else 0) for j in range(size)]
        for i in range(size)
    ]


def kronecker(left, right):
    rows = len(left) * len(right)
    columns = len(left[0]) * len(right[0])
    result = [[Fraction(0) for _ in range(columns)] for _ in range(rows)]
    for i, left_row in enumerate(left):
        for j, coefficient in enumerate(left_row):
            for u, right_row in enumerate(right):
                for v, entry in enumerate(right_row):
                    result[i * len(right) + u][j * len(right[0]) + v] = (
                        coefficient * entry
                    )
    return result


def rational_rank(matrix):
    work = [list(map(Fraction, row)) for row in matrix]
    if not work:
        return 0
    rows = len(work)
    columns = len(work[0])
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        work[pivot_row] = [entry / pivot_value for entry in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            coefficient = work[row][column]
            if coefficient:
                work[row] = [
                    entry - coefficient * pivot_entry
                    for entry, pivot_entry in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def nilpotent_jordan_partition(matrix):
    size = len(matrix)
    power = identity(size)
    kernel_dimensions = [0]
    for _ in range(size):
        power = matrix_multiply(power, matrix)
        kernel_dimensions.append(size - rational_rank(power))
    blocks_at_least = [
        kernel_dimensions[k] - kernel_dimensions[k - 1]
        for k in range(1, size + 1)
    ]
    partition = []
    for block_size in range(1, size + 1):
        next_count = blocks_at_least[block_size] if block_size < size else 0
        exact_count = blocks_at_least[block_size - 1] - next_count
        partition.extend([block_size] * exact_count)
    return sorted(partition, reverse=True)


def nilpotent_tensor(left_size, right_size):
    return matrix_add(
        kronecker(jordan(left_size), identity(right_size)),
        kronecker(identity(left_size), jordan(right_size)),
    )


def matrix_power(matrix, exponent):
    result = identity(len(matrix))
    for _ in range(exponent):
        result = matrix_multiply(result, matrix)
    return result


def block_diagonal(blocks):
    size = sum(len(block) for block in blocks)
    result = [[Fraction(0) for _ in range(size)] for _ in range(size)]
    offset = 0
    for block in blocks:
        for row, entries in enumerate(block):
            for column, entry in enumerate(entries):
                result[offset + row][offset + column] = entry
        offset += len(block)
    return result


def integer_partitions(total, maximum=None):
    if total == 0:
        yield ()
        return
    if maximum is None:
        maximum = total
    for first in range(min(total, maximum), 0, -1):
        for tail in integer_partitions(total - first, first):
            yield (first,) + tail


def kernel_profile(matrix):
    size = len(matrix)
    return [
        size - rational_rank(matrix_power(matrix, exponent))
        for exponent in range(1, size + 1)
    ]


def partition_from_kernel_profile(profile):
    kernels = [0] + profile + [profile[-1]]
    partition = []
    for block_size in range(1, len(profile) + 1):
        exact_count = (
            2 * kernels[block_size]
            - kernels[block_size - 1]
            - kernels[block_size + 1]
        )
        partition.extend([block_size] * exact_count)
    return sorted(partition, reverse=True)


def matrix_vector(matrix, vector):
    return [
        sum(entry * coordinate for entry, coordinate in zip(row, vector))
        for row in matrix
    ]


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def solve_square(matrix, vector):
    size = len(matrix)
    work = [
        list(map(Fraction, row)) + [Fraction(value)]
        for row, value in zip(matrix, vector)
    ]
    for column in range(size):
        pivot = next(
            (row for row in range(column, size) if work[row][column]), None
        )
        assert pivot is not None
        work[column], work[pivot] = work[pivot], work[column]
        pivot_value = work[column][column]
        work[column] = [entry / pivot_value for entry in work[column]]
        for row in range(size):
            if row == column:
                continue
            coefficient = work[row][column]
            if coefficient:
                work[row] = [
                    entry - coefficient * pivot_entry
                    for entry, pivot_entry in zip(work[row], work[column])
                ]
    return [work[row][-1] for row in range(size)]


def main():
    checks = {}

    # Free symmetric-monoidal 2-monad: units, multiplication, associativity,
    # symmetry, and fold fusion.
    xs = ["a", "b", "a", "c"]
    triple = [[["a"], ["b", "a"]], [[], ["c"]], [["b"]]]
    left_assoc = flatten([flatten(level) for level in triple])
    right_assoc = flatten(flatten(triple))
    assert bag(flatten([[x] for x in xs])) == bag(xs)
    assert bag(flatten([xs])) == bag(xs)
    assert bag(left_assoc) == bag(right_assoc)
    assert all(bag(order) == bag(xs) for order in permutations(xs))
    weights = {"a": 2, "b": 3, "c": 5}
    folded = sum(weights[x] for x in xs)
    assert (folded > 0) == any(weights[x] > 0 for x in xs)
    checks["free_sym_monad_and_fold_fusion"] = "pass"

    # Indexed scalar extension: identity, composition, and a commuting square.
    signature = (2, "J2", "disc_nonzero")

    def extend(block_signature, _source, _target):
        return block_signature

    assert extend(signature, "K", "K") == signature
    assert extend(extend(signature, "K", "L"), "L", "M") == extend(
        signature, "K", "M"
    )
    upper_then_right = extend(extend(signature, "K", "L"), "L", "Omega")
    left_then_lower = extend(extend(signature, "K", "Kprime"), "Kprime", "Omega")
    assert upper_then_right == left_then_lower
    checks["indexed_base_change_and_beck_chevalley_shadow"] = "pass"

    # Formal coordinate transport is a third marker law, distinct from field
    # extension.  The uncentered eigenvalue function u is not literally equal
    # to u'+5, but it is its pullback along u=u'+5.  A marker comparing the
    # raw coefficient tuples would therefore be unlawful.
    def pullback_linear(linear_polynomial, translation):
        slope, intercept = linear_polynomial
        return slope, intercept + slope * translation

    eigenvalue_in_u = (Fraction(1), Fraction(0))
    eigenvalue_in_u_prime = (Fraction(1), Fraction(5))
    assert eigenvalue_in_u != eigenvalue_in_u_prime
    assert pullback_linear(eigenvalue_in_u, Fraction(5)) == eigenvalue_in_u_prime
    centered_eigenvalue = lambda eigenvalue, unit: (
        eigenvalue[0] - unit[0],
        eigenvalue[1] - unit[1],
    )
    assert centered_eigenvalue(eigenvalue_in_u, eigenvalue_in_u) == (0, 0)
    assert centered_eigenvalue(
        eigenvalue_in_u_prime, eigenvalue_in_u_prime
    ) == (0, 0)
    checks["formal_coordinate_pseudonaturality_not_raw_equality"] = "pass"

    # Center localization is idempotent and nested cutoffs compose by max.
    dimensions = {"point": 0, "curve": 1, "surface": 2, "cubic": 3}
    spectrum = Counter({"point": 2, "curve": 1, "surface": 3, "cubic": 2})
    assert localize(localize(spectrum, dimensions, 2), dimensions, 2) == localize(
        spectrum, dimensions, 2
    )
    assert localize(localize(spectrum, dimensions, 1), dimensions, 2) == localize(
        spectrum, dimensions, 2
    )
    checks["center_localization_idempotent_and_nested"] = "pass"

    # Blowup plus exceptional projective bundle gives the Bittner relation.
    for codimension in range(2, 7):
        y = vector(Y=1)
        z = vector(Z=1)
        blowup = y + vector(Z=codimension - 1)
        exceptional = vector(Z=codimension)
        lhs = {key: blowup[key] - exceptional[key] for key in {"Y", "Z"}}
        rhs = {key: y[key] - z[key] for key in {"Y", "Z"}}
        assert lhs == rhs
    checks["bittner_relation_codimension_2_through_6"] = "pass"

    # Finite Kan aggregation is functorial under composite coarsening.
    rich = Counter({"J2_disc+": 2, "J2_disc0": 1, "J1": 5})
    first = {
        "J2_disc+": "rank2_kept",
        "J2_disc0": "rank2_rejected",
        "J1": "rank1",
    }
    second = {
        "rank2_kept": "retained",
        "rank2_rejected": "discarded",
        "rank1": "discarded",
    }
    composite = {key: second[value] for key, value in first.items()}
    assert kan_push(kan_push(rich, first), second) == kan_push(rich, composite)
    assert sum(kan_push(rich, first).values()) == sum(rich.values())
    checks["finite_kan_coarsening_composition"] = "pass"

    # Guere collision guard: collision can hide a violating block, while a
    # unit shift restores the blockwise Boolean fold.
    club_bad = (2, 1, 0, 0)
    club_mask = (2, 0, 0, 0)
    assert bad_club(club_bad) or bad_club(club_mask)
    assert not bad_club(add_obs(club_bad, club_mask))
    heart_bad = (0, 1, 0, 1)
    heart_mask = (0, 0, 0, 1)
    assert bad_heart(heart_bad) or bad_heart(heart_mask)
    assert not bad_heart(add_obs(heart_bad, heart_mask))
    shifts, separated = separate_spectra([{0, 2}, {0, 1}, {1, 3}])
    assert len(set().union(*separated)) == sum(len(x) for x in separated)
    assert len(shifts) == 3
    # In the cofinite quotient, finite modifications disappear and the tail
    # truth value is the complete eventual invariant.
    eventually_zero_a = (False, frozenset({1, 4, 9}))
    eventually_zero_b = (False, frozenset({2, 3}))
    assert eventually_zero_a[0] == eventually_zero_b[0]
    checks["guere_cofinite_probe_and_collision_guard"] = "pass"

    # KKPYY chemical formulas after atomization.
    atom_class = {
        "X_local": "alpha",
        "Bl_X_local": "alpha",
        "Z_local": "beta",
        "Bl_Z_1": "beta",
        "Bl_Z_2": "beta",
    }

    def atomize(local_blocks):
        return bag(atom_class[block] for block in local_blocks)

    assert atomize(["Bl_X_local", "Bl_Z_1", "Bl_Z_2"]) == atomize(
        ["X_local"]
    ) + scale(atomize(["Z_local"]), 2)
    assert scale(atomize(["X_local"]), 3) == atomize(
        ["X_local", "X_local", "X_local"]
    )
    checks["kkpyy_atomization_and_chemical_formula"] = "pass"

    # Retention ladder: split K0 distinguishes Jordan partitions that exact
    # K0 (length) identifies.
    partition_a = Counter({3: 1, 1: 2})
    partition_b = Counter({2: 2, 1: 1})
    assert partition_a != partition_b
    length_a = sum(size * multiplicity for size, multiplicity in partition_a.items())
    length_b = sum(size * multiplicity for size, multiplicity in partition_b.items())
    assert length_a == length_b == 5
    checks["split_vs_exact_k0_retention"] = "pass"

    # The unmarked constituent theory cannot pass the center-vanishing gate
    # after two or more stabilizations: the threefold carrier itself is then
    # an allowed center.
    for stabilization in range(2, 7):
        center_cutoff = 3 + stabilization - 2
        assert 3 <= center_cutoff
        stabilized = Counter({"cubic": stabilization + 1})
        assert localize(stabilized, {"cubic": 3}, center_cutoff) == Counter()
    checks["unmarked_constituent_no_go_m_2_through_6"] = "pass"

    # Rep(G_a) Clebsch-Gordan law for nilpotent Jordan blocks in characteristic
    # zero, including the projective/blowup coherence J_m tensor J_2.
    for left_size in range(1, 6):
        for right_size in range(1, 6):
            expected = sorted(
                [
                    left_size + right_size - 2 * index + 1
                    for index in range(1, min(left_size, right_size) + 1)
                ],
                reverse=True,
            )
            assert nilpotent_jordan_partition(
                nilpotent_tensor(left_size, right_size)
            ) == expected
    for size in range(2, 7):
        assert nilpotent_jordan_partition(nilpotent_tensor(size, 2)) == [
            size + 1,
            size - 1,
        ]
    checks["ga_clebsch_gordan_and_higher_pb_coherence"] = "pass"

    # Row-stabilizer telescope: actual row-preserving transitions remain
    # row-preserving under ordered composition.  This does not need an
    # ambient quotient by a two-sided ideal.
    transition_1 = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(2), Fraction(1), Fraction(0)],
        [Fraction(3), Fraction(0), Fraction(1)],
    ]
    transition_2 = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(4)],
        [Fraction(5), Fraction(0), Fraction(1)],
    ]
    composite_transition = matrix_multiply(transition_2, transition_1)
    rank_row = [Fraction(1), Fraction(0), Fraction(0)]
    assert transition_1[0] == rank_row
    assert transition_2[0] == rank_row
    assert composite_transition[0] == rank_row
    checks["row_stabilizer_composition_telescope"] = "pass"

    # The raw row kernel {e : r e = 0} is generally only a right ideal.  It
    # cannot be used as the two-sided ideal in an ambient category quotient.
    row_2 = [[Fraction(1), Fraction(0)]]
    row_null = [
        [Fraction(0), Fraction(0)],
        [Fraction(1), Fraction(0)],
    ]
    hostile_left_factor = [
        [Fraction(0), Fraction(1)],
        [Fraction(0), Fraction(0)],
    ]
    assert matrix_multiply(row_2, row_null) == [
        [Fraction(0), Fraction(0)]
    ]
    assert matrix_multiply(
        row_2, matrix_multiply(row_null, hostile_left_factor)
    ) == [[Fraction(0), Fraction(0)]]
    assert matrix_multiply(
        row_2, matrix_multiply(hostile_left_factor, row_null)
    ) == [[Fraction(1), Fraction(0)]]
    generated_e11 = matrix_multiply(hostile_left_factor, row_null)
    generated_e22 = matrix_multiply(row_null, hostile_left_factor)
    assert matrix_add(generated_e11, generated_e22) == identity(2)
    checks["row_kernel_two_sided_closure_trivializes_m2"] = "pass"

    # Correct repair: in the operator-enriched arrow category, a morphism is
    # a commuting square r_B f = ell r_A.  The output-line component ell is
    # functorial, so its kernel is automatically a two-sided ideal.  Allowing
    # nonzero ell also proves that exact row normalization is unnecessary.
    row_a = [[Fraction(1), Fraction(0)]]
    row_b = [[Fraction(1), Fraction(0)]]
    arrow_f = [
        [Fraction(2), Fraction(0)],
        [Fraction(3), Fraction(4)],
    ]
    arrow_g = [
        [Fraction(5), Fraction(0)],
        [Fraction(7), Fraction(6)],
    ]
    assert matrix_multiply(row_b, arrow_f) == [
        [Fraction(2), Fraction(0)]
    ]
    assert matrix_multiply(row_b, arrow_g) == [
        [Fraction(5), Fraction(0)]
    ]
    arrow_gf = matrix_multiply(arrow_g, arrow_f)
    assert matrix_multiply(row_b, arrow_gf) == [
        [Fraction(10), Fraction(0)]
    ]
    compatible_left = arrow_g
    compatible_right = arrow_f
    assert matrix_multiply(
        row_b, matrix_multiply(compatible_left, row_null)
    ) == [[Fraction(0), Fraction(0)]]
    assert matrix_multiply(
        row_b, matrix_multiply(row_null, compatible_right)
    ) == [[Fraction(0), Fraction(0)]]
    # A morphism can be invertible only after the output-kernel quotient.
    # Its output scalar is still invertible and the nonzero row Boolean is
    # unchanged, even though the carrier map itself is singular.
    quotient_iso_representative = [
        [Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0)],
    ]
    quotient_inverse_representative = quotient_iso_representative
    quotient_inverse_error = matrix_add(
        matrix_multiply(
            quotient_inverse_representative, quotient_iso_representative
        ),
        [[Fraction(-1), Fraction(0)], [Fraction(0), Fraction(-1)]],
    )
    assert matrix_multiply(row_a, quotient_iso_representative) == row_a
    assert matrix_multiply(row_a, quotient_inverse_error) == [
        [Fraction(0), Fraction(0)]
    ]
    assert rational_rank(quotient_iso_representative) == 1
    checks["augmented_row_output_kernel_is_two_sided"] = "pass"

    # Zero-mode quotient descent for a dual cyclic row.  A T-stable
    # vanishing submodule V contained in ker(r) is annihilated by every rT^k;
    # the quotient pullback therefore identifies the whole Krylov row module,
    # without choosing a complement or converting the row to a column.
    nearby_operator = jordan(4)
    reduced_operator = jordan(3)
    nearby_row = [[Fraction(0), Fraction(1), Fraction(0), Fraction(0)]]
    reduced_row = [[Fraction(1), Fraction(0), Fraction(0)]]
    quotient_map = [
        [Fraction(0), Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(0), Fraction(1)],
    ]
    assert matrix_multiply(quotient_map, nearby_operator) == matrix_multiply(
        reduced_operator, quotient_map
    )
    for exponent in range(4):
        assert matrix_multiply(
            matrix_multiply(reduced_row, matrix_power(reduced_operator, exponent)),
            quotient_map,
        ) == matrix_multiply(
            nearby_row, matrix_power(nearby_operator, exponent)
        )
    assert matrix_multiply(nearby_row, [[Fraction(1)], [0], [0], [0]]) == [
        [Fraction(0)]
    ]
    checks["zero_mode_dual_cyclic_row_descends_through_quotient"] = "pass"

    # The row-annihilation hypothesis is necessary.  Since the first column
    # of q is zero, no row on the quotient can pull back to a row that is
    # nonzero on the discarded stable line.
    non_descending_row = [[Fraction(1), Fraction(1), Fraction(0), Fraction(0)]]
    assert non_descending_row[0][0] != 0
    assert all(
        pulled_back[0][0] == 0
        for pulled_back in (
            matrix_multiply(candidate, quotient_map)
            for candidate in (
                [[Fraction(1), Fraction(0), Fraction(0)]],
                [[Fraction(1), Fraction(1), Fraction(0)]],
                [[Fraction(0), Fraction(1), Fraction(1)]],
            )
        )
    )
    checks["zero_mode_row_annihilation_is_necessary"] = "pass"

    # K-theoretic forcing of the blowup point row.  The first two source
    # coordinates are ambient K(Y), the last two exceptional K(Z) copies.
    # Generic rank kills the exceptional columns of the Orlov matrix.  Any
    # analytic comparison lifting that matrix therefore preserves the rank
    # row up to the ambient normalization (here, the scalar 2).
    orlov_matrix = [
        [Fraction(1), 0, 0, 0],
        [Fraction(2), 1, 0, 0],
        [Fraction(3), 0, 1, 0],
        [Fraction(4), 5, 6, 1],
    ]
    analytic_comparison = [
        [Fraction(2), 0, 0, 0],
        [Fraction(-6), 3, 0, 0],
        [Fraction(-12), 0, 4, 0],
        [Fraction(120), -25, -30, 5],
    ]
    gamma_block_scaling = [
        [Fraction(2), 0, 0, 0],
        [Fraction(0), 3, 0, 0],
        [Fraction(0), 0, 4, 0],
        [Fraction(0), 0, 0, 5],
    ]
    rank_blowup = [[Fraction(1), 0, 0, 0]]
    rank_decomposition = [[Fraction(1), 0, 0, 0]]
    assert matrix_multiply(rank_blowup, orlov_matrix) == rank_decomposition
    assert matrix_multiply(analytic_comparison, orlov_matrix) == gamma_block_scaling
    assert matrix_multiply(rank_decomposition, analytic_comparison) == [
        [Fraction(2), 0, 0, 0]
    ]
    checks["orlov_gamma_lift_forces_blowup_rank_row"] = "pass"

    # Provider implications are not reversible.  A lower shear preserves
    # the row while leaving its action on the row kernel undetermined.  An
    # upper shear and its inverse preserve the row only in aggregate, so a
    # path-level Boolean cannot be promoted to edgewise compatibility.
    provider_row = [[Fraction(1), Fraction(0)]]
    lower_shear = [[Fraction(1), Fraction(0)], [Fraction(7), Fraction(3)]]
    upper_shear = [[Fraction(1), Fraction(1)], [Fraction(0), Fraction(1)]]
    upper_shear_inverse = [
        [Fraction(1), Fraction(-1)],
        [Fraction(0), Fraction(1)],
    ]
    assert matrix_multiply(provider_row, lower_shear) == provider_row
    assert matrix_multiply(provider_row, upper_shear) != provider_row
    assert matrix_multiply(
        matrix_multiply(provider_row, upper_shear), upper_shear_inverse
    ) == provider_row
    checks["provider_implications_are_not_reversible"] = "pass"

    # Affine-parabolic coordinates for the row-line stabilizer.  Relative to
    # V = K.s + ker(r), (c,u,A)(d,v,B) = (cd,d*u+A*v,A*B), and the displayed
    # inverse follows from the same law.
    affine_row_map = [
        [Fraction(2), 0, 0],
        [Fraction(3), 1, 2],
        [Fraction(5), 0, 1],
    ]
    second_affine_row_map = [
        [Fraction(7), 0, 0],
        [Fraction(11), 2, 0],
        [Fraction(13), 1, 1],
    ]
    assert matrix_multiply(affine_row_map, second_affine_row_map) == [
        [Fraction(14), 0, 0],
        [Fraction(58), 4, 2],
        [Fraction(48), 1, 1],
    ]
    affine_row_inverse = [
        [Fraction(1, 2), 0, 0],
        [Fraction(7, 2), 1, -2],
        [Fraction(-5, 2), 0, 1],
    ]
    assert matrix_multiply(affine_row_map, affine_row_inverse) == identity(3)
    checks["row_line_stabilizer_affine_group_law"] = "pass"

    # Four sectorial half-space shadows jointly recover the zero-exponent
    # block.  Any one shadow retains decaying nonzero exponents, while the
    # intersection excludes each nonzero lattice exponent in some direction.
    exponent_labels = {
        "zero": (0, 0),
        "east": (1, 0),
        "west": (-1, 0),
        "north": (0, 1),
        "south": (0, -1),
        "northeast": (1, 1),
    }
    separating_directions = ((1, 0), (-1, 0), (0, 1), (0, -1))
    half_space_shadows = [
        {
            label
            for label, exponent in exponent_labels.items()
            if direction[0] * exponent[0] + direction[1] * exponent[1] <= 0
        }
        for direction in separating_directions
    ]
    assert len(half_space_shadows[0]) > 1
    assert set.intersection(*half_space_shadows) == {"zero"}
    checks["multi_sector_sparse_shadows_recover_zero_exponent"] = "pass"

    # Coherent transport of sectorial fibers does not identify their
    # filtration embeddings.  A Stokes shear can turn the formal zero line
    # into a graph that survives every transported shadow while retaining an
    # exceptional coordinate.
    formal_zero_line = {(Fraction(t), Fraction(0)) for t in (-1, 0, 1)}
    stokes_sheared_line = {(Fraction(t), Fraction(t)) for t in (-1, 0, 1)}
    whole_plane_sample = {
        (Fraction(a), Fraction(b)) for a in (-1, 0, 1) for b in (-1, 0, 1)
    }
    assert formal_zero_line != stokes_sheared_line
    assert stokes_sheared_line & whole_plane_sample == stokes_sheared_line
    assert (Fraction(1), Fraction(1)) in stokes_sheared_line
    checks["sector_path_transport_needs_stokes_optic_residual"] = "pass"

    # Exposed exponential faces are multiplicative; addition is only
    # filtered because equal top faces may cancel.  Exponents are integers
    # and coefficients exact rationals in this finite group-algebra model.
    def exponential_product(
        left: dict[int, Fraction], right: dict[int, Fraction]
    ) -> dict[int, Fraction]:
        answer: dict[int, Fraction] = {}
        for left_exponent, left_coefficient in left.items():
            for right_exponent, right_coefficient in right.items():
                exponent = left_exponent + right_exponent
                answer[exponent] = answer.get(exponent, Fraction(0)) + (
                    left_coefficient * right_coefficient
                )
        return {
            exponent: coefficient
            for exponent, coefficient in answer.items()
            if coefficient != 0
        }

    negative_degree_tail = {0: Fraction(1), -1: Fraction(-1)}
    second_factor = {0: Fraction(1), 2: Fraction(3)}
    convolution_product = exponential_product(negative_degree_tail, second_factor)
    growth_weight = lambda exponent: -exponent
    tail_face = max(negative_degree_tail, key=growth_weight)
    second_face = max(second_factor, key=growth_weight)
    product_face = max(convolution_product, key=growth_weight)
    assert product_face == tail_face + second_face
    assert convolution_product[product_face] == (
        negative_degree_tail[tail_face] * second_factor[second_face]
    )
    cancelling_top_face = {-1: Fraction(1), 0: Fraction(2)}
    summed = {
        exponent: negative_degree_tail.get(exponent, Fraction(0))
        + cancelling_top_face.get(exponent, Fraction(0))
        for exponent in negative_degree_tail.keys() | cancelling_top_face.keys()
    }
    summed = {exponent: value for exponent, value in summed.items() if value != 0}
    assert max(summed, key=growth_weight) == 0
    checks["exponential_initial_face_filtered_monoidal_laws"] = "pass"

    # Comma-bridge descent: a high retained carrier surjects onto the QDM
    # carrier, its output kills the realization kernel, and a commuting
    # bridge square forces the row law downstairs.  If the output does not
    # kill the kernel, no descended row can exist.
    gamma_realization = [
        [Fraction(1), 0, 0],
        [Fraction(0), 1, 0],
    ]
    high_transition = [
        [Fraction(1), 0, 0],
        [Fraction(2), 3, 0],
        [Fraction(0), 0, 4],
    ]
    qdm_transition = [
        [Fraction(1), 0],
        [Fraction(2), 3],
    ]
    high_output = [[Fraction(1), 0, 0]]
    descended_row = [[Fraction(1), 0]]
    assert matrix_multiply(qdm_transition, gamma_realization) == matrix_multiply(
        gamma_realization, high_transition
    )
    assert matrix_multiply(descended_row, gamma_realization) == high_output
    assert matrix_multiply(high_output, high_transition) == high_output
    assert matrix_multiply(descended_row, qdm_transition) == descended_row
    non_descending_output = [[Fraction(1), 0, 1]]
    realization_kernel_vector = [[Fraction(0)], [Fraction(0)], [Fraction(1)]]
    assert matrix_multiply(gamma_realization, realization_kernel_vector) == [
        [Fraction(0)],
        [Fraction(0)],
    ]
    assert matrix_multiply(
        non_descending_output, realization_kernel_vector
    ) == [[Fraction(1)]]
    checks["comma_bridge_forces_descended_augmented_row"] = "pass"

    # Hodge equivariance, a preserved pairing, and an intertwined primary
    # operator do not by themselves preserve a point/rank row.  All four
    # basis directions may be Tate, so the Hodge action is trivial.  The
    # isometry below commutes with the displayed semisimple operator, but it
    # shears the point vector p to p+e and changes the row <p,->.  A geometric
    # point/Gamma compatibility theorem is therefore a genuine extra input.
    pairing = [
        [Fraction(0), Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(1), Fraction(0), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(0), Fraction(1)],
        [Fraction(0), Fraction(0), Fraction(1), Fraction(0)],
    ]
    hodge_equivariant_isometry = [
        [Fraction(1), Fraction(0), Fraction(0), Fraction(-1)],
        [Fraction(0), Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(0), Fraction(1)],
    ]
    primary_operator = [
        [Fraction(1, 2), Fraction(0), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(2), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(2), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(0), Fraction(1, 2)],
    ]
    point_vector = [Fraction(0), Fraction(1), Fraction(0), Fraction(0)]
    point_row = [Fraction(1), Fraction(0), Fraction(0), Fraction(0)]
    assert matrix_multiply(
        matrix_multiply(transpose(hodge_equivariant_isometry), pairing),
        hodge_equivariant_isometry,
    ) == pairing
    assert matrix_multiply(
        hodge_equivariant_isometry, primary_operator
    ) == matrix_multiply(primary_operator, hodge_equivariant_isometry)
    assert matrix_vector(hodge_equivariant_isometry, point_vector) == [
        Fraction(0),
        Fraction(1),
        Fraction(1),
        Fraction(0),
    ]
    transported_row = matrix_multiply([point_row], hodge_equivariant_isometry)[0]
    assert transported_row == [
        Fraction(1),
        Fraction(0),
        Fraction(0),
        Fraction(-1),
    ]
    assert transported_row != point_row
    checks["hodge_pairing_operator_do_not_force_point_row"] = "pass"

    # A nilpotent matrix may be forgotten after retaining only its kernel
    # dimensions: that sparse integer profile reconstructs every Jordan block.
    for dimension in range(1, 9):
        for partition in integer_partitions(dimension):
            matrix = block_diagonal([jordan(size) for size in partition])
            profile = kernel_profile(matrix)
            assert partition_from_kernel_profile(profile) == list(partition)
    j3 = jordan(3)
    j2_plus_j1 = block_diagonal([jordan(2), jordan(1)])
    split_three = block_diagonal([jordan(1), jordan(1), jordan(1)])
    assert rational_rank(matrix_power(j3, 2)) == 1
    assert rational_rank(matrix_power(j2_plus_j1, 2)) == 0
    assert rational_rank(matrix_power(split_three, 2)) == 0
    checks["sparse_kernel_profile_reconstructs_jordan_type"] = "pass"

    # In a cyclic/cocyclic realization, 2n scalar Krylov moments recover the
    # monic annihilator.  The standard J_n realization recovers t^n exactly.
    for size in range(1, 7):
        operator = jordan(size)
        cyclic_vector = [Fraction(0)] * (size - 1) + [Fraction(1)]
        row = [Fraction(1)] + [Fraction(0)] * (size - 1)
        moments = []
        iterate = cyclic_vector
        for _ in range(2 * size):
            moments.append(dot(row, iterate))
            iterate = matrix_vector(operator, iterate)
        hankel = [
            [moments[i + j] for j in range(size)] for i in range(size)
        ]
        assert rational_rank(hankel) == size
        coefficients = solve_square(
            hankel, [-moments[size + i] for i in range(size)]
        )
        assert coefficients == [Fraction(0)] * size
    checks["cyclic_krylov_moments_reconstruct_nilpotent_string"] = "pass"

    # Reader is fixed, State changes index, Writer summaries commute, and raw
    # path certificates retain their order.  Parenthesization does not matter.
    environment = {
        "coefficient_spine": "C[q][[Q,t]]",
        "retained_output": "augmented_row_output",
    }

    def effect_step(delta, evidence, path_label):
        def run(env, state):
            assert env is environment
            assert env["retained_output"] == "augmented_row_output"
            return state + delta, frozenset({evidence}), (path_label,)

        return run

    def effect_identity(env, state):
        assert env is environment
        return state, frozenset(), ()

    def effect_compose(first, second):
        def run(env, state):
            middle, evidence_1, path_1 = first(env, state)
            target, evidence_2, path_2 = second(env, middle)
            return target, evidence_1 | evidence_2, path_1 + path_2

        return run

    step_a = effect_step(2, "a", "wall-a")
    step_b = effect_step(3, "b", "wall-b")
    step_c = effect_step(5, "c", "wall-c")
    left_associated = effect_compose(effect_compose(step_a, step_b), step_c)
    right_associated = effect_compose(step_a, effect_compose(step_b, step_c))
    assert left_associated(environment, 7) == right_associated(environment, 7)
    assert effect_compose(effect_identity, step_a)(environment, 7) == step_a(
        environment, 7
    )
    assert effect_compose(step_a, effect_identity)(environment, 7) == step_a(
        environment, 7
    )
    ab = effect_compose(step_a, step_b)(environment, 7)
    ba = effect_compose(step_b, step_a)(environment, 7)
    assert ab[:2] == ba[:2]
    assert ab[2] != ba[2]
    checks["reader_indexed_state_writer_composition"] = "pass"

    # A path functor maps identities and composites, while payload naturality
    # is a separate required law.  A residual, unlike a path label alone,
    # recovers a parallel projection.
    def map_path(path):
        return tuple(2 * increment for increment in path)

    def source_transport(path, value):
        return value + sum(path)

    def target_transport(path, value):
        return value + sum(path)

    def map_shadow(value):
        return 2 * value

    path_p = (1, 3)
    path_q = (2,)
    assert map_path(()) == ()
    assert map_path(path_p + path_q) == map_path(path_p) + map_path(path_q)
    assert map_shadow(source_transport(path_p, 11)) == target_transport(
        map_path(path_p), map_shadow(11)
    )
    rich_plus = ("six_axes", "+")
    rich_minus = ("six_axes", "-")
    coarse = lambda rich: rich[0]
    path_label = lambda _rich: "forget_orientation"
    parallel = lambda rich: (rich[0], "chordal_" + rich[1])
    residualize = lambda rich: (rich[1], coarse(rich))
    reconstruct = lambda residual_shadow: (
        residual_shadow[1],
        residual_shadow[0],
    )
    assert coarse(rich_plus) == coarse(rich_minus)
    assert path_label(rich_plus) == path_label(rich_minus)
    assert parallel(rich_plus) != parallel(rich_minus)
    assert reconstruct(residualize(rich_plus)) == rich_plus
    assert reconstruct(residualize(rich_minus)) == rich_minus
    checks["optic_residual_and_path_functor_naturality"] = "pass"

    # A residual torsor can be propagated along a tree, but a loop has a
    # compatible global lift exactly when its holonomy is trivial.  Pulling a
    # path theory back changes which loops are visible; it does not turn a
    # prescribed endpoint mismatch into a proof.
    def z2_transport(label, value):
        return (value + label) % 2

    tree_edge_labels = (1, 0)
    tree_lift = [0]
    for edge_label in tree_edge_labels:
        tree_lift.append(z2_transport(edge_label, tree_lift[-1]))
    assert tree_lift == [0, 1, 1]
    assert z2_transport(sum(tree_edge_labels) % 2, tree_lift[0]) == tree_lift[-1]

    triangle_edge_labels = (1, 0, 0)
    triangle_holonomy = sum(triangle_edge_labels) % 2
    assert triangle_holonomy == 1
    assert all(
        z2_transport(triangle_holonomy, base_lift) != base_lift
        for base_lift in (0, 1)
    )

    pulled_interval_labels = triangle_edge_labels[:2]
    pulled_endpoint = 0
    for edge_label in pulled_interval_labels:
        pulled_endpoint = z2_transport(edge_label, pulled_endpoint)
    assert pulled_endpoint == 1
    assert pulled_endpoint != 0  # a prescribed canonical endpoint mismatch
    checks["torsor_path_holonomy_and_endpoint_obstruction"] = "pass"

    # If a retained algebra character occurs on a unique covector line, every
    # intertwiner preserves that row line.  Repeated characters permit the
    # Hodge/Tate shear above and therefore do not meet this hypothesis.
    separating_operator = [
        [Fraction(0), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(2)],
    ]
    separating_intertwiner = [
        [Fraction(3), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(4), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(5)],
    ]
    unique_character_row = [Fraction(1), Fraction(0), Fraction(0)]
    assert matrix_multiply(
        separating_intertwiner, separating_operator
    ) == matrix_multiply(separating_operator, separating_intertwiner)
    assert matrix_multiply(
        [unique_character_row], separating_intertwiner
    )[0] == [Fraction(3), Fraction(0), Fraction(0)]
    repeated_character_operator = [
        [Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(0)],
    ]
    repeated_character_shear = [
        [Fraction(1), Fraction(1)],
        [Fraction(0), Fraction(1)],
    ]
    assert matrix_multiply(
        repeated_character_shear, repeated_character_operator
    ) == matrix_multiply(repeated_character_operator, repeated_character_shear)
    assert matrix_multiply(
        [[Fraction(1), Fraction(0)]], repeated_character_shear
    )[0] == [Fraction(1), Fraction(1)]
    checks["simple_retained_character_forces_row_line"] = "pass"

    # The Rees/Laurent grading z*d/dz + mu is not separating when two base
    # weights differ by an allowed Laurent exponent: the exponent shifts one
    # branch into the same total character as the other.
    ramification_degree = 2
    ambient_mu = Fraction(1)
    center_mu = Fraction(1, 2)
    center_laurent_power = ambient_mu - center_mu
    assert center_laurent_power * ramification_degree == Fraction(1)
    ambient_total_weight = Fraction(0) + ambient_mu
    center_total_weight = center_laurent_power + center_mu
    assert ambient_total_weight == center_total_weight
    checks["laurent_grading_shift_collides_row_character"] = "pass"

    # A wall transvection/mutation fixes a common-open point vector when the
    # point is Euler-orthogonal to the wall.  Removing orthogonality allows the
    # same rank-one operation to move the point and its pairing row.
    point = [Fraction(1), Fraction(0), Fraction(0)]
    wall = [Fraction(0), Fraction(1), Fraction(0)]
    euler_pairing = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1)],
    ]
    assert dot(point, matrix_vector(euler_pairing, wall)) == 0
    wall_mutation = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(1)],
        [Fraction(0), Fraction(0), Fraction(1)],
    ]
    assert matrix_vector(wall_mutation, point) == point
    nonorthogonal_mutation = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(1), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1)],
    ]
    assert matrix_vector(nonorthogonal_mutation, point) != point
    checks["wall_mutations_fix_common_open_point"] = "pass"

    # Modding numerical K0 out by every proper-support direction leaves the
    # one-dimensional generic-rank quotient.  Hence a support-null additive
    # row is uniquely a scalar multiple of rank.
    support_basis = [
        [Fraction(0), Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(0), Fraction(1)],
    ]
    support_null_rows = []
    for candidate in product(range(-1, 2), repeat=4):
        row_candidate = [Fraction(value) for value in candidate]
        if all(dot(row_candidate, basis) == 0 for basis in support_basis):
            support_null_rows.append(row_candidate)
    assert all(row[1:] == [Fraction(0)] * 3 for row in support_null_rows)
    assert [Fraction(1), Fraction(0), Fraction(0), Fraction(0)] in support_null_rows
    checks["generic_rank_is_universal_support_null_character"] = "pass"

    # For codimension-one rank quotients, the only obstruction to descending
    # an isomorphism is its boundary-to-rank leakage row (the top-right block).
    rank_row = [Fraction(1), Fraction(0), Fraction(0)]
    zero_leakage = [
        [Fraction(2), Fraction(0), Fraction(0)],
        [Fraction(3), Fraction(1), Fraction(1)],
        [Fraction(4), Fraction(0), Fraction(1)],
    ]
    second_zero_leakage = [
        [Fraction(5), Fraction(0), Fraction(0)],
        [Fraction(1), Fraction(1), Fraction(0)],
        [Fraction(2), Fraction(1), Fraction(1)],
    ]
    leaking_map = [
        [Fraction(1), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1)],
    ]
    boundary_basis = (
        [Fraction(0), Fraction(1), Fraction(0)],
        [Fraction(0), Fraction(0), Fraction(1)],
    )
    assert all(
        dot(rank_row, matrix_vector(zero_leakage, basis)) == 0
        for basis in boundary_basis
    )
    zero_leakage_composite = matrix_multiply(
        second_zero_leakage, zero_leakage
    )
    assert all(
        dot(rank_row, matrix_vector(zero_leakage_composite, basis)) == 0
        for basis in boundary_basis
    )
    assert any(
        dot(rank_row, matrix_vector(leaking_map, basis)) != 0
        for basis in boundary_basis
    )
    checks["rank_leakage_covector_is_sole_quotient_defect"] = "pass"

    # The conditional framed m=1 specialization composes once every actual
    # comparison-generated center specialization is null.  The P1 product
    # value is unconditional; only the blowup edges consume the R/T provider.
    def framed_blowup_value(ambient, specialized_centers, tail_certified):
        assert tail_certified
        return ambient + sum(specialized_centers)

    cubic_times_p1_nu6 = 4
    path_value = cubic_times_p1_nu6
    for specialized_center_terms in ([0], [0, 0], [], [0]):
        path_value = framed_blowup_value(
            path_value, specialized_center_terms, tail_certified=True
        )
    assert path_value == cubic_times_p1_nu6
    projective4_nu6 = 0
    assert path_value != projective4_nu6
    checks[
        "conditional_framed_m1_telescope_with_specialized_center_null"
    ] = "pass"

    # Intrinsic center vanishing cannot replace specialized center vanishing:
    # a noninjective coefficient map is an independent interface operation.
    intrinsic_center_nu6 = 0
    uncertified_specialized_center_nu6 = 1
    assert intrinsic_center_nu6 == 0
    assert uncertified_specialized_center_nu6 != intrinsic_center_nu6
    assert framed_blowup_value(
        4, [uncertified_specialized_center_nu6], tail_certified=True
    ) == 5
    checks["intrinsic_center_nu6_zero_not_specialized_zero"] = "pass"

    # Ordinary coordinate/base-change laws place no constraint on a move from
    # the designated small point to a reconstruction-tail point.  Equality is
    # exactly the extra 5.7R certificate, not a generic pseudonaturality law.
    abstract_small_nu6 = 2
    abstract_tail_nu6 = 3
    ordinary_laws_available = {
        "coefficient_base_change": True,
        "integral_z_gauge": True,
        "formal_coordinate_pullback_away_from_marked_point": True,
    }
    assert all(ordinary_laws_available.values())
    assert abstract_small_nu6 != abstract_tail_nu6
    checks["reconstruction_tail_is_not_generic_coordinate_law"] = "pass"

    # Decategorified center localization is the quotient which sends every
    # indexed center generator to zero.  Work exhaustively in (Z/2)^3, whose
    # coordinates are the ambient generator, a point-center generator, and a
    # surface-center generator.
    bit_states = list(product((0, 1), repeat=3))

    def bit_add(left, right):
        return tuple(x ^ y for x, y in zip(left, right))

    finite_ledgers = bit_states

    def point_localization(ledger):
        return (ledger[0], ledger[2])

    def surface_localization(ledger):
        return (ledger[0],)

    assert all(
        point_localization(bit_add(left, right))
        == bit_add(point_localization(left), point_localization(right))
        and surface_localization(bit_add(left, right))
        == bit_add(surface_localization(left), surface_localization(right))
        for left in finite_ledgers
        for right in finite_ledgers
    )
    assert all(
        surface_localization(ledger)
        == (point_localization(ledger)[0],)
        for ledger in finite_ledgers
    )
    def binary_weight_value(weight, ledger):
        value = 0
        for coefficient, coordinate in zip(weight, ledger):
            value ^= coefficient & coordinate
        return value

    center_null_weights = [(weight, 0, 0) for weight in (0, 1)]
    for weight in center_null_weights:
        for ledger in finite_ledgers:
            direct = binary_weight_value(weight, ledger)
            factored = weight[0] & surface_localization(ledger)[0]
            assert direct == factored
    checks[
        "universal_center_localization_represents_center_null_markers"
    ] = "pass"

    # The universal quotient is jointly complete for the entire class of
    # center-null markers: equality in it is equivalent to equality under all
    # such markers.  The identity-weight consumer already detects every
    # unequal pair of ambient coordinates.
    for left in finite_ledgers:
        for right in finite_ledgers:
            quotient_equal = surface_localization(left) == surface_localization(
                right
            )
            every_marker_equal = all(
                binary_weight_value(weight, left)
                == binary_weight_value(weight, right)
                for weight in center_null_weights
            )
            assert quotient_equal == every_marker_equal
    checks["universal_center_quotient_detects_all_retained_equalities"] = (
        "pass"
    )

    # A finite model of the kernel congruence identifies the joint marker
    # image as a factor of a richer sufficient shadow.  The theorem proof,
    # rather than this one example, supplies terminality among all shadows.
    def marker_family(state):
        x, y, z = state
        return (x ^ y, y ^ z)

    def richer_shadow(state):
        return (*marker_family(state), state[2])

    assert all(
        marker_family(bit_add(left, right))
        == bit_add(marker_family(left), marker_family(right))
        for left in bit_states
        for right in bit_states
    )
    richer_image = {richer_shadow(state) for state in bit_states}
    assert all(
        richer_shadow(bit_add(left, right))
        == bit_add(richer_shadow(left), richer_shadow(right))
        for left in bit_states
        for right in bit_states
    )
    induced_to_minimal = {
        shadow: marker_family(state)
        for shadow in richer_image
        for state in bit_states
        if richer_shadow(state) == shadow
    }
    assert all(
        induced_to_minimal[richer_shadow(state)] == marker_family(state)
        for state in bit_states
    )
    assert all(
        marker_family(left) == marker_family(right)
        for left in bit_states
        for right in bit_states
        if richer_shadow(left) == richer_shadow(right)
    )
    checks["minimal_sufficient_shadow_is_joint_marker_image"] = "pass"

    # Two projections may jointly retain a marker even though neither does,
    # while still forgetting the rich object.  This is the sparse-shadow
    # phenomenon rather than ordinary object reconstruction.
    def first_shadow(state):
        return state[0]

    def second_shadow(state):
        return state[1]

    def xor_marker(state):
        return state[0] ^ state[1]

    assert all(
        first_shadow(bit_add(left, right))
        == (first_shadow(left) ^ first_shadow(right))
        and second_shadow(bit_add(left, right))
        == (second_shadow(left) ^ second_shadow(right))
        and xor_marker(bit_add(left, right))
        == (xor_marker(left) ^ xor_marker(right))
        for left in bit_states
        for right in bit_states
    )
    assert any(
        first_shadow(left) == first_shadow(right)
        and xor_marker(left) != xor_marker(right)
        for left in bit_states
        for right in bit_states
    )
    assert any(
        second_shadow(left) == second_shadow(right)
        and xor_marker(left) != xor_marker(right)
        for left in bit_states
        for right in bit_states
    )
    assert all(
        xor_marker(left) == xor_marker(right)
        for left in bit_states
        for right in bit_states
        if (
            first_shadow(left),
            second_shadow(left),
        )
        == (
            first_shadow(right),
            second_shadow(right),
        )
    )
    assert any(
        left != right
        and first_shadow(left) == first_shadow(right)
        and second_shadow(left) == second_shadow(right)
        for left in bit_states
        for right in bit_states
    )
    checks["joint_sparse_shadows_retain_marker_without_object"] = "pass"

    # The m=2 specialization retains primitive-sixth support seen by the
    # point row, not the unmarked primitive packet count.  Row-null exceptional
    # packets can change the latter while leaving the former unchanged.
    cubic_times_p2 = [
        {"character": character, "point_row": True}
        for character in ("zeta6", "zeta6_bar")
        for _ in range(3)
    ]
    projective5 = [
        {"character": "trivial", "point_row": True} for _ in range(6)
    ]
    projective5_with_exceptional = projective5 + [
        {"character": "zeta6", "point_row": False}
    ]

    def unmarked_primitive_count(blocks):
        return sum(
            block["character"] in {"zeta6", "zeta6_bar"} for block in blocks
        )

    def pointed_primary_boolean(blocks):
        return any(
            block["character"] in {"zeta6", "zeta6_bar"}
            and block["point_row"]
            for block in blocks
        )

    assert unmarked_primitive_count(cubic_times_p2) == 6
    assert pointed_primary_boolean(cubic_times_p2)
    assert unmarked_primitive_count(projective5) == 0
    assert not pointed_primary_boolean(projective5)
    assert unmarked_primitive_count(projective5_with_exceptional) == 1
    assert not pointed_primary_boolean(projective5_with_exceptional)
    checks["m2_pointed_primary_shadow_ignores_row_null_packets"] = "pass"

    result = {
        "status": "pass",
        "check_count": len(checks),
        "checks": checks,
        "scope": "finite algebraic law model only; external comparison theorems are inputs",
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
