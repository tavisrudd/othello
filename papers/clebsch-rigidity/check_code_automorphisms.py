#!/usr/bin/env python3
"""Exact automorphism checks for the displayed Clebsch hexagon code.

This is a standalone, standard-library-only checker.  It distinguishes three
objects which must not be conflated:

* pure coordinate permutations preserving the displayed code;
* projective automorphisms of the six parity-check column directions;
* monomial automorphisms of the displayed code.

All arithmetic is exact in F_11.  The final assertions are the expected
output contract; any mathematical or implementation regression exits nonzero.
No splitting of the monomial extension is asserted or used.
"""

from __future__ import annotations

from collections import Counter
from itertools import permutations, product


Q = 11
NONZERO = tuple(range(1, Q))
IDENTITY_PERM = tuple(range(6))
IDENTITY_MATRIX = ((1, 0, 0), (0, 1, 0), (0, 0, 1))

# The columns of H in the order displayed in clebsch_hexagon_code.tex.
COLUMNS = (
    (1, 10, 0),
    (1, 9, 1),
    (1, 4, 7),
    (1, 8, 5),
    (0, 1, 4),
    (1, 1, 7),
)


def inv(x: int) -> int:
    assert x % Q
    return pow(x, -1, Q)


def matrix_from_columns(columns: tuple[tuple[int, int, int], ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(tuple(column[row] % Q for column in columns) for row in range(3))


def matrix_mul(a: tuple[tuple[int, ...], ...], b: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    assert len(a[0]) == len(b)
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(len(b))) % Q for j in range(len(b[0])))
        for i in range(len(a))
    )


def matrix_vec(a: tuple[tuple[int, ...], ...], v: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(a[i][j] * v[j] for j in range(len(v))) % Q for i in range(len(a)))


def matrix_scale(a: int, m: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(tuple(a * x % Q for x in row) for row in m)


def matrix_inverse_3(a: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    augmented = [
        [a[i][j] % Q for j in range(3)] + [int(i == j) for j in range(3)]
        for i in range(3)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column] % Q)
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        pivot_inverse = inv(augmented[column][column])
        augmented[column] = [pivot_inverse * x % Q for x in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            coefficient = augmented[row][column]
            augmented[row] = [
                (x - coefficient * y) % Q
                for x, y in zip(augmented[row], augmented[column])
            ]
    inverse = tuple(tuple(row[3:]) for row in augmented)
    assert matrix_mul(a, inverse) == IDENTITY_MATRIX
    assert matrix_mul(inverse, a) == IDENTITY_MATRIX
    return inverse


def proportionality_scalar(v: tuple[int, ...], w: tuple[int, ...]) -> int | None:
    """Return the unique nonzero a with v=a*w, or None."""
    assert any(w)
    pivot = next(i for i, x in enumerate(w) if x)
    a = v[pivot] * inv(w[pivot]) % Q
    if a and all(v[i] == a * w[i] % Q for i in range(len(v))):
        return a
    return None


def compose_perm(p: tuple[int, ...], r: tuple[int, ...]) -> tuple[int, ...]:
    """Composition p after r."""
    return tuple(p[r[i]] for i in range(len(p)))


def inverse_perm(p: tuple[int, ...]) -> tuple[int, ...]:
    result = [0] * len(p)
    for i, image in enumerate(p):
        result[image] = i
    return tuple(result)


def perm_order(p: tuple[int, ...]) -> int:
    power = IDENTITY_PERM
    for order in range(1, 61):
        power = compose_perm(p, power)
        if power == IDENTITY_PERM:
            return order
    raise AssertionError("permutation order exceeds group order")


def cycle_type(p: tuple[int, ...]) -> tuple[int, ...]:
    unseen = set(range(len(p)))
    cycles = []
    while unseen:
        start = min(unseen)
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            current = p[current]
            length += 1
        cycles.append(length)
    return tuple(sorted(cycles, reverse=True))


def subgroup_generated(
    generators: set[tuple[int, ...]], group: set[tuple[int, ...]]
) -> set[tuple[int, ...]]:
    generators = generators | {inverse_perm(g) for g in generators}
    result = {IDENTITY_PERM}
    frontier = [IDENTITY_PERM]
    while frontier:
        h = frontier.pop()
        for g in generators:
            product_perm = compose_perm(g, h)
            assert product_perm in group
            if product_perm not in result:
                result.add(product_perm)
                frontier.append(product_perm)
    return result


def normal_closure(g: tuple[int, ...], group: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    conjugates = {
        compose_perm(compose_perm(h, g), inverse_perm(h))
        for h in group
    }
    return subgroup_generated(conjugates, group)


def row_space() -> set[tuple[int, ...]]:
    """The 1,331 words in the row space of H."""
    return {
        tuple(sum(a[j] * COLUMNS[i][j] for j in range(3)) % Q for i in range(6))
        for a in product(range(Q), repeat=3)
    }


def pure_permutation_automorphisms() -> set[tuple[int, ...]]:
    """Pure coordinate permutations preserving C, checked through C^perp=row(H)."""
    dual = row_space()
    assert len(dual) == Q**3
    return {
        p
        for p in permutations(range(6))
        if all(tuple(word[p[i]] for i in range(6)) in dual for word in dual)
    }


def projective_lifts() -> dict[
    tuple[int, ...], tuple[tuple[tuple[int, ...], ...], tuple[int, ...]]
]:
    """Find every support permutation and its unique lift normalized by lambda_0=1.

    A returned pair (M, lambdas) satisfies

        M * h_i = lambdas[i] * h_{p(i)}

    for all six columns.  The first three source columns are a basis, so a
    choice of the first three target scalars determines M.  Fixing the first
    scalar to one removes the common F_11^x ambiguity.
    """
    basis = matrix_from_columns(COLUMNS[:3])
    basis_inverse = matrix_inverse_3(basis)
    result = {}
    for p in permutations(range(6)):
        candidates = []
        for second_scalar, third_scalar in product(NONZERO, repeat=2):
            target_basis = matrix_from_columns(
                (
                    COLUMNS[p[0]],
                    tuple(second_scalar * x % Q for x in COLUMNS[p[1]]),
                    tuple(third_scalar * x % Q for x in COLUMNS[p[2]]),
                )
            )
            matrix = matrix_mul(target_basis, basis_inverse)
            lambdas = tuple(
                proportionality_scalar(matrix_vec(matrix, COLUMNS[i]), COLUMNS[p[i]])
                for i in range(6)
            )
            if all(a is not None for a in lambdas):
                candidates.append((matrix, tuple(int(a) for a in lambdas)))
        # A projectivity is determined by a projective frame contained in the arc.
        assert len(candidates) <= 1
        if candidates:
            matrix, lambdas = candidates[0]
            assert lambdas[0] == 1
            assert all(
                matrix_vec(matrix, COLUMNS[i])
                == tuple(lambdas[i] * x % Q for x in COLUMNS[p[i]])
                for i in range(6)
            )
            result[p] = (matrix, lambdas)
    return result


Monomial = tuple[tuple[int, ...], tuple[int, ...]]


def compose_monomial(left: Monomial, right: Monomial) -> Monomial:
    """Composition left after right for e_i -> d_i e_{p(i)}."""
    p, d = left
    r, e = right
    return compose_perm(p, r), tuple(e[i] * d[r[i]] % Q for i in range(6))


def monomial_group(
    lifts: dict[tuple[int, ...], tuple[tuple[tuple[int, ...], ...], tuple[int, ...]]]
) -> dict[Monomial, tuple[tuple[int, ...], ...]]:
    """Construct all scalar multiples of all normalized projective lifts."""
    result = {}
    for p, (matrix, lambdas) in lifts.items():
        for scalar in NONZERO:
            element = p, tuple(scalar * a % Q for a in lambdas)
            action_matrix = matrix_scale(scalar, matrix)
            if element in result:
                assert result[element] == action_matrix
            result[element] = action_matrix
    return result


def verify_monomial_group(
    group: dict[Monomial, tuple[tuple[int, ...], ...]]
) -> None:
    elements = set(group)
    identity = IDENTITY_PERM, (1,) * 6
    assert identity in elements
    assert group[identity] == IDENTITY_MATRIX
    for left in elements:
        for right in elements:
            product_element = compose_monomial(left, right)
            assert product_element in elements
            assert group[product_element] == matrix_mul(group[left], group[right])


def nonzero_conic_syndromes() -> set[tuple[int, int, int]]:
    """The 120 nonzero vectors over the standard conic XZ=Y^2."""
    return {
        (x, y, z)
        for x, y, z in product(range(Q), repeat=3)
        if (x, y, z) != (0, 0, 0) and (x * z - y * y) % Q == 0
    }


def main() -> None:
    pure = pure_permutation_automorphisms()
    assert pure == {IDENTITY_PERM}

    lifts = projective_lifts()
    support_group = set(lifts)
    assert len(support_group) == 60
    assert IDENTITY_PERM in support_group
    assert all(
        compose_perm(g, h) in support_group
        for g in support_group
        for h in support_group
    )

    order_histogram = Counter(perm_order(g) for g in support_group)
    assert order_histogram == Counter({1: 1, 2: 15, 3: 20, 5: 24})
    cycle_histogram = Counter(cycle_type(g) for g in support_group)
    assert cycle_histogram == Counter(
        {
            (1, 1, 1, 1, 1, 1): 1,
            (2, 2, 1, 1): 15,
            (3, 3): 20,
            (5, 1): 24,
        }
    )

    # Every nonidentity element normally generates the whole group: the
    # support group is nonabelian simple of order 60, hence A5.
    assert all(
        normal_closure(g, support_group) == support_group
        for g in support_group
        if g != IDENTITY_PERM
    )

    ordered_pair_orbit = {(g[0], g[1]) for g in support_group}
    assert len(ordered_pair_orbit) == 6 * 5
    point_stabilizer = {g for g in support_group if g[0] == 0}
    assert len(point_stabilizer) == 10
    assert Counter(perm_order(g) for g in point_stabilizer) == Counter({1: 1, 2: 5, 5: 4})

    monomial = monomial_group(lifts)
    assert len(monomial) == 600
    verify_monomial_group(monomial)
    support_image = {p for p, _ in monomial}
    kernel = {(p, d) for p, d in monomial if p == IDENTITY_PERM}
    assert support_image == support_group
    assert len(kernel) == 10
    assert {d for _, d in kernel} == {(a,) * 6 for a in NONZERO}
    pure_inside_monomial = {
        (p, d) for p, d in monomial if d == (1,) * 6
    }
    assert pure_inside_monomial == {(IDENTITY_PERM, (1,) * 6)}

    holes = nonzero_conic_syndromes()
    assert len(holes) == 120
    base = min(holes)
    syndrome_orbit = {matrix_vec(matrix, base) for matrix in monomial.values()}
    assert syndrome_orbit == holes
    assert all(
        matrix_vec(matrix, syndrome) in holes
        for matrix in monomial.values()
        for syndrome in holes
    )

    print(f"field=F_{Q} columns={len(COLUMNS)} dual_row_space={len(row_space())}")
    print(f"pure_permutation_automorphisms={len(pure)}")
    print(f"projective_support_automorphisms={len(support_group)}")
    print(f"support_element_orders={dict(sorted(order_histogram.items()))}")
    print(f"support_cycle_types={dict(sorted(cycle_histogram.items()))}")
    print("support_group_simple=True")
    print("support_group_identification=A5")
    print("support_action_2_transitive=True")
    print(f"support_point_stabilizer_order={len(point_stabilizer)}")
    print(f"monomial_automorphisms={len(monomial)}")
    print(f"support_projection_image={len(support_image)}")
    print(f"support_projection_kernel={len(kernel)}")
    print("kernel_is_global_scalars=True")
    print(f"nonzero_conic_affine_syndromes={len(holes)}")
    print(f"nonzero_conic_syndrome_orbit={len(syndrome_orbit)}")
    print("nonzero_conic_syndrome_transitive=True")
    print("splitting_claim=NONE")
    print("all assertions passed")


if __name__ == "__main__":
    main()
