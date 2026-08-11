#!/usr/bin/env sage
"""Exact Jordan-height and indecomposability checks for two dyadic bases."""

from hashlib import sha256
from itertools import combinations


PRIMARY = "notes/2026-08-11-c904-graph-stabilization-base-certificates.sage"
REPLAY = "notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class.sage"
PRIMARY_SHA = "6c9e6b17fb8c8d7d7057721ddc3b16a7a759e1911de68fd6bb936c418243cc0e"
REPLAY_SHA = "e39a9349ce4749d2bc9142de737dde443cc109e0fb08c53a90c9b993a329ff5a"


def digest(path):
    return sha256(open(path, "rb").read()).hexdigest()


assert digest(PRIMARY) == PRIMARY_SHA
assert digest(REPLAY) == REPLAY_SHA

# Load only the function preambles; neither source's top-level census runs.
primary_source = open(PRIMARY).read()
exec(preparse(primary_source[:primary_source.index("\ncertify(\n")]))

replay_scope = dict(globals())
replay_source = open(REPLAY).read().split("def main():")[0]
exec(preparse(replay_source), replay_scope)


def divisor_data(slope):
    prime = 2
    rank = slope.nrows()
    basis, principal = graph_lattice(prime, slope)
    positions, coefficient_lattice = ns_lattice(basis)
    zero = zero_matrix(QQ, rank)
    divisors = []
    for coordinates in coefficient_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions, rank)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        divisors.append(two_form(form.change_ring(ZZ)))

    theta = two_form(principal)
    curve_targets = list(combinations(range(2 * rank), 2 * rank - 2))
    top_targets = [tuple(range(2 * rank))]
    curve = divided_power(theta, rank - 1, curve_targets)
    top = divided_power(theta, rank, top_targets)
    curve_data = product_data(divisors, rank, rank - 1, curve)
    top_data = product_data(divisors, rank, rank, top)
    return curve_data, top_data


def independent_curve_order(slope):
    field = slope.base_ring()
    rank = slope.nrows()
    graph = block_matrix(field, [[identity_matrix(field, rank), slope]])
    basis, principal = replay_scope["principal_lattice"](2, graph)
    positions, lattice = replay_scope["ns_lattice"](basis)
    order, product_rank, monomials = replay_scope["minimal_order"](
        basis, principal, positions, lattice
    )
    return int(order), int(product_rank), int(monomials)


def invariant_subspace_data(slope):
    field = slope.base_ring()
    rank = slope.nrows()
    space = VectorSpace(field, rank)
    checked = 0
    stable = 0
    nondegenerate_stable = []
    for dimension in range(1, rank):
        for subspace in space.subspaces(dimension):
            checked += 1
            matrix_basis = subspace.basis_matrix()
            is_stable = all(
                space(matrix_basis.row(i) * slope) in subspace
                for i in range(dimension)
            )
            if not is_stable:
                continue
            stable += 1
            if (matrix_basis * matrix_basis.transpose()).rank() == dimension:
                nondegenerate_stable.append((dimension, matrix_basis))
    return checked, stable, nondegenerate_stable


def jordan_height(minimal_polynomial):
    return max(int(exponent) for _, exponent in minimal_polynomial.factor())


def certify(label, entries, expected_indec):
    field = GF(2)
    slope = matrix(field, 5, 5, entries)
    assert slope.is_symmetric()
    minimal = slope.minimal_polynomial()
    height = jordan_height(minimal)
    predicted_exponent = min(
        valuation(factorial(4), 2),
        floor(log(height, 2)),
    )
    curve_data, top_data = divisor_data(slope)
    replay_order, replay_rank, replay_monomials = independent_curve_order(slope)
    checked, stable, nondegenerate = invariant_subspace_data(slope)
    assert curve_data[3] == 2 ** predicted_exponent
    assert replay_order == curve_data[3]
    assert replay_rank == curve_data[0]
    assert replay_monomials == binomial(15 + 4 - 1, 4)
    assert (not nondegenerate) == expected_indec

    print(f"label={label}")
    print(f"  charpoly={slope.charpoly()} minpoly={minimal} height={height}")
    print(
        f"  predicted_exponent={predicted_exponent} "
        f"curve_order={curve_data[3]} top_order={top_data[3]}"
    )
    print(
        f"  curve_saturation_index={curve_data[1]} "
        f"curve_elementary={curve_data[2]}"
    )
    print(
        f"  subspaces_checked={checked} invariant={stable} "
        f"nondegenerate_invariant={len(nondegenerate)}"
    )
    print(
        f"  independent_curve_order={replay_order} "
        f"independent_product_rank={replay_rank} "
        f"independent_monomials={replay_monomials}"
    )


# Regular nilpotent order-four base from the spectral-stabilization theorem.
certify(
    "regular-height5",
    [0, 1, 0, 1, 1,
     1, 0, 1, 0, 0,
     0, 1, 0, 0, 0,
     1, 0, 0, 0, 0,
     1, 0, 0, 0, 0],
    True,
)

# A height-four, characteristic-polynomial x^5 example.  It is not obtained
# by adjoining a spectrally disjoint scalar block.
certify(
    "height4-single-primary",
    [0, 0, 0, 0, 0,
     0, 0, 0, 0, 1,
     0, 0, 0, 0, 1,
     0, 0, 0, 1, 1,
     0, 1, 1, 1, 1],
    False,
)

print("PASS")
