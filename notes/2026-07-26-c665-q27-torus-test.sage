#!/usr/bin/env sage
"""Exact first characteristic-three torus test for the C665 Platinum gap."""

from sage.all import GF, PolynomialRing, matrix


q = 27
k = GF(q, name="a")
a = k.gen()
points = tuple(k) + (None,)
point_index = {x: i for i, x in enumerate(points)}
infinity = q


def mobius(entries, x):
    aa, bb, cc, dd = map(k, entries)
    if x is None:
        return None if cc == 0 else aa / cc
    denominator = cc * x + dd
    return None if denominator == 0 else (aa * x + bb) / denominator


def permutation(entries):
    return tuple(point_index[mobius(entries, x)] for x in points)


def image(g, matching):
    return tuple(sorted(tuple(sorted((g[x], g[y]))) for x, y in matching))


def generated_orbit(generators, base):
    seen = {base}
    frontier = [base]
    while frontier:
        matching = frontier.pop()
        for generator in generators:
            target = image(generator, matching)
            if target not in seen:
                seen.add(target)
                frontier.append(target)
    return sorted(seen)


translation_one = permutation((1, 1, 0, 1))
translation_a = permutation((1, a, 0, 1))
inversion = permutation((0, -1, 1, 0))
square_dilation = permutation((a**2, 0, 0, 1))
outer_dilation = permutation((a, 0, 0, 1))
h_generators = (translation_one, translation_a, inversion, square_dilation)
g_generators = h_generators + (outer_dilation,)

squares = sorted({x**2 for x in k if x != 0})
base = tuple(
    sorted(
        [(point_index[k(0)], infinity)]
        + [
            tuple(sorted((point_index[x], point_index[a * x])))
            for x in squares
        ]
    )
)
assert len({vertex for edge in base for vertex in edge}) == q + 1

h_orbit = generated_orbit(h_generators, base)
g_orbit = generated_orbit(g_generators, base)
outer_image = image(outer_dilation, base)
other_h_orbit = generated_orbit(h_generators, outer_image)
assert set(g_orbit) == set(h_orbit) | set(other_h_orbit)
assert set(h_orbit).isdisjoint(other_h_orbit)
torus_matchings = [
    tuple(
        sorted(
            [(point_index[k(0)], infinity)]
            + [
                tuple(sorted((point_index[x], point_index[c * x])))
                for x in squares
            ]
        )
    )
    for c in k
    if c != 0 and c not in squares
]
print(
    {
        "torus_matching_count": len(torus_matchings),
        "torus_matchings_in_one_g_orbit": sum(
            matching in set(g_orbit) for matching in torus_matchings
        ),
    },
    flush=True,
)

R = PolynomialRing(k, names=("X", "Y", "Z"))
X, Y, Z = R.gens()
endpoint_vectors = tuple((x, k(1)) for x in k) + ((k(1), k(0)),)
conic = X * Z - Y**2


def matching_product(matching):
    answer = R.one()
    for left, right in matching:
        si, ti = endpoint_vectors[left]
        sj, tj = endpoint_vectors[right]
        answer *= ti * tj * X - (si * tj + ti * sj) * Y + si * sj * Z
    return answer


degree = (q - 3) // 2
monomials = tuple(
    X**i * Y**j * Z ** (degree - i - j)
    for i in range(degree + 1)
    for j in range(degree - i + 1)
)


def evaluate(orbit, orbit_number):
    h_part = generated_orbit(h_generators, orbit[0])
    split = len(orbit) == 2 * len(h_part)
    reference = matching_product(orbit[0])
    quotients = []
    for index, matching in enumerate(orbit):
        difference = matching_product(matching) - reference
        quotient, remainder = difference.quo_rem(conic)
        assert remainder == 0
        quotients.append(quotient)
        if index and index % 200 == 0:
            print("orbit", orbit_number, "quotients", index, flush=True)

    affine = matrix(
        k,
        [[1] * len(orbit)]
        + [[quotient.monomial_coefficient(monomial) for quotient in quotients]
           for monomial in monomials],
    )
    linear = affine.row_space().basis_matrix()
    square = matrix(
        k,
        [
            linear.row(i).pairwise_product(linear.row(j))
            for i in range(linear.nrows())
            for j in range(i, linear.nrows())
        ],
    )
    square_rank = square.rank()
    return {
        "orbit_number": orbit_number,
        "g_orbit_size": len(orbit),
        "split": split,
        "h_orbit_size": len(h_part),
        "lambda": len(h_part) // q if split else None,
        "affine_rank": linear.nrows(),
        "square_rows": square.nrows(),
        "square_rank": square_rank,
        "trade_dimension": len(orbit) - square_rank,
    }


remaining = set(torus_matchings)
torus_orbits = []
while remaining:
    representative = min(remaining)
    orbit = generated_orbit(g_generators, representative)
    torus_orbits.append(orbit)
    remaining -= set(orbit)

print({"torus_g_orbit_count": len(torus_orbits)}, flush=True)
for orbit_number, orbit in enumerate(torus_orbits, start=1):
    print(evaluate(orbit, orbit_number), flush=True)
