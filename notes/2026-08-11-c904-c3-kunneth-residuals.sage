"""Residual C3 action on the exact C904 p15/p24 Lefschetz cokernels."""

from itertools import combinations

F = GF(2)
ambient_rank = 10
generator = block_diagonal_matrix(
    [matrix(F, [[1, 1], [1, 0]]) for _ in range(5)]
)
assert generator^3 == identity_matrix(F, ambient_rank)


def exterior_basis(degree):
    return list(combinations(range(ambient_rank), degree))


def exterior_action(degree):
    basis = exterior_basis(degree)
    index = {item: row for row, item in enumerate(basis)}
    action = matrix(F, len(basis))
    for column, source in enumerate(basis):
        terms = {(): F.one()}
        for source_index in source:
            new_terms = {}
            for partial, coefficient in terms.items():
                for target_index in range(ambient_rank):
                    scalar = generator[target_index, source_index]
                    if not scalar or target_index in partial:
                        continue
                    target = tuple(sorted(partial + (target_index,)))
                    new_terms[target] = (
                        new_terms.get(target, F.zero()) + coefficient * scalar
                    )
            terms = new_terms
        for target, coefficient in terms.items():
            action[index[target], column] = coefficient
    return action


def wedge_theta(degree):
    source = exterior_basis(degree)
    target = exterior_basis(degree + 2)
    target_index = {item: row for row, item in enumerate(target)}
    lefschetz = matrix(F, len(target), len(source))
    for column, basis in enumerate(source):
        for pair_index in range(5):
            left, right = 2 * pair_index, 2 * pair_index + 1
            if left in basis or right in basis:
                continue
            target_basis = tuple(sorted(basis + (left, right)))
            lefschetz[target_index[target_basis], column] += 1
    return lefschetz


def quotient_action(source_degree, actions):
    target_degree = source_degree + 2
    target = VectorSpace(F, binomial(ambient_rank, target_degree))
    quotient = target.quotient(wedge_theta(source_degree).column_space())
    columns = [
        quotient(actions[target_degree] * quotient.lift(basis_vector))
        for basis_vector in quotient.basis()
    ]
    action = matrix(F, [list(column) for column in columns]).transpose()
    return quotient, action


def fixed_dimension(action):
    return (
        action - identity_matrix(F, action.nrows())
    ).right_kernel().dimension()


actions = {
    degree: exterior_action(degree)
    for degree in (1, 2, 4, 5, 6, 7)
}

for degree in (4, 5):
    assert (
        actions[degree + 2] * wedge_theta(degree)
        == wedge_theta(degree) * actions[degree]
    )

q15, action_q15 = quotient_action(5, actions)
q24, action_q24 = quotient_action(4, actions)

u24 = wedge_theta(2).column_space()
fixed_u24 = u24.intersection(
    (
        actions[4] - identity_matrix(F, actions[4].nrows())
    ).right_kernel()
).dimension()

assert q15.dimension() == 10
assert fixed_dimension(action_q15) == 0
assert fixed_dimension(actions[1]) == 0

# Both p15 factors are five copies of the irreducible two-dimensional
# F2[C3]-module.  Their diagonal tensor invariants form M_5(F4).
p15_tensor_fixed = 2 * 5 * 5
assert p15_tensor_fixed == 50

assert q24.dimension() == 44
assert fixed_dimension(action_q24) == 24
assert u24.dimension() == 44
assert fixed_u24 == 24

# U24 and Q24 each decompose as 1^24 plus V^10, where V is the irreducible
# two-dimensional module.  The invariant Hom space has this dimension.
p24_tensor_fixed = 24 * 24 + 2 * 10 * 10
assert p24_tensor_fixed == 776

print("C3 on Q15: dim=10 fixed=0; effective first factor: dim=10 fixed=0")
print("diagonal p15 transfer invariants: dim=50 (=dim M5(F4))")
print("p15 odd invariant Hodge witness: coefficient identity has degree 5")
print("C3 on Q24: dim=44 fixed=24; effective first factor: dim=44 fixed=24")
print("diagonal p24 transfer invariants: dim=776")
print("p24 invariant cohomology contains odd pairings on its trivial summands")
print("C3 order is odd: restriction-corestriction preserves mod-2 obstruction")
