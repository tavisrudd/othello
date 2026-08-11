"""Independent Sage replay of the C904 mod-two twist-invariant census.

Run from /home/tavis/src/othello with:

  nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-universal-sheaf-twist-invariants-replay.sage").read()))'

This implementation uses Sage polynomial rings and matrix kernels.  The
primary Python certificate uses sparse bitsets and its own row reduction.
"""

F = GF(2)
ranks = (0, 0, 2, 3)
weights = (1, 2, 3) * 4
names = [f"c{i}_{j}" for i in range(4) for j in range(1, 4)] + ["ell"]
R = PolynomialRing(F, names=names)
variables = R.gens()[:-1]
ell = R.gens()[-1]


def exponent_tuples(total):
    answer = []

    def visit(index, remaining, prefix):
        if index == len(weights):
            if remaining == 0:
                answer.append(tuple(prefix))
            return
        for value in range(remaining // weights[index] + 1):
            visit(index + 1, remaining - value * weights[index], prefix + [value])

    visit(0, total, [])
    return answer


def monomial(exponents):
    value = R.one()
    for variable, exponent in zip(variables, exponents):
        value *= variable**exponent
    return value


def transformed_generators():
    answer = []
    for i, rank in enumerate(ranks):
        c1, c2, c3 = variables[3 * i : 3 * i + 3]
        answer.extend(
            (
                c1 + binomial(rank, 1) * ell,
                c2 + binomial(rank - 1, 1) * c1 * ell + binomial(rank, 2) * ell**2,
                c3
                + binomial(rank - 2, 1) * c2 * ell
                + binomial(rank - 1, 2) * c1 * ell**2
                + binomial(rank, 3) * ell**3,
            )
        )
    return tuple(R(value) for value in answer)


substitution = transformed_generators()


def invariant_data(total):
    exponents = exponent_tuples(total)
    domain = [monomial(exponent) for exponent in exponents]
    images = [value(*(substitution + (ell,))) + value for value in domain]
    targets = sorted({key for image in images for key in image.dict()})
    rows = []
    for target in targets:
        rows.append([image.dict().get(target, F.zero()) for image in images])
    matrix = Matrix(F, rows) if rows else Matrix(F, 0, len(domain))
    basis = list(matrix.right_kernel().basis())
    invariants = [sum((coefficient * value for coefficient, value in zip(vector, domain)), R.zero()) for vector in basis]
    assert all(value(*(substitution + (ell,))) == value for value in invariants)
    return domain, invariants


def sq2_degree_two(value):
    answer = R.zero()
    for exponent, coefficient in value.dict().items():
        if not coefficient:
            continue
        exponent = tuple(exponent)
        support = [i for i, power in enumerate(exponent[:-1]) for _ in range(power)]
        assert exponent[-1] == 0
        if len(support) == 1:
            variable = support[0]
            assert variable % 3 == 1
            i = variable // 3
            c1, c2, c3 = variables[3 * i : 3 * i + 3]
            answer += c1 * c2 + c3
        else:
            assert len(support) == 2 and all(i % 3 == 0 for i in support)
            i, j = support
            if i != j:
                answer += variables[i] ** 2 * variables[j] + variables[i] * variables[j] ** 2
    return answer


data = {degree: invariant_data(degree) for degree in (1, 2, 3)}
for degree in (1, 2, 3):
    monomials, invariants = data[degree]
    print(f"degree {degree}: monomials={len(monomials)} invariant_dim={len(invariants)}")

degree_one = data[1][1]
degree_two = data[2][1]
degree_three_monomials, degree_three = data[3]
coordinates = {value: i for i, value in enumerate(degree_three_monomials)}


def coordinate_vector(value):
    vector = [F.zero()] * len(degree_three_monomials)
    for exponent, coefficient in value.dict().items():
        exponent = tuple(exponent)
        term = monomial(exponent[:-1])
        vector[coordinates[term]] += coefficient
    return vector


obvious = []
for divisor in degree_one:
    for surface in degree_two:
        obvious.append(coordinate_vector(divisor * surface))
for surface in degree_two:
    square = sq2_degree_two(surface)
    assert square(*(substitution + (ell,))) == square
    obvious.append(coordinate_vector(square))

obvious_rank = Matrix(F, obvious).rank()
full_rank = Matrix(F, obvious + [coordinate_vector(value) for value in degree_three]).rank()
print(f"obvious degree-3 span rank={obvious_rank}")
print(f"all degree-3 invariant rank={len(degree_three)}")
print(f"rank after adjoining all invariants={full_rank}")
print(f"residual invariant quotient dimension={full_rank - obvious_rank}")
assert (len(degree_three_monomials), obvious_rank, len(degree_three), full_rank) == (40, 26, 26, 26)
