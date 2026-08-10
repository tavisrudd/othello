#!/usr/bin/env python3
"""Exact low-cost boundary probes for the integral six-point A5 cubic pencil.

The icosahedral action is PSL(2,5) on P^1(F_5).  On the deleted
permutation representation sum(z_i)=0, its invariant cubics are generated
by sum(z_i^3) and the signed difference of the two A5-orbits of triples.
This script recovers the isolated singular-orbit parameters without using
the Paper-V finite-field coordinates.
"""

from fractions import Fraction
import itertools


POINTS = tuple(range(6))  # 0,...,4 and 5=infinity


def compose(left, right):
    return tuple(left[right[index]] for index in POINTS)


def generated_group(generators):
    identity = tuple(POINTS)
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(generator, element)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return tuple(sorted(group))


TRANSLATION = (1, 2, 3, 4, 0, 5)
NEGATIVE_INVERSION = (5, 4, 2, 3, 1, 0)
GROUP = generated_group((TRANSLATION, NEGATIVE_INVERSION))


def image_subset(permutation, subset):
    return tuple(sorted(permutation[index] for index in subset))


def subset_orbit(seed):
    return tuple(sorted({image_subset(element, seed) for element in GROUP}))


TRIPLES_PLUS = subset_orbit((0, 1, 2))
TRIPLES_MINUS = tuple(
    sorted(set(itertools.combinations(POINTS, 3)) - set(TRIPLES_PLUS))
)


def cubic_value(point, signed_triples):
    power_sum = sum(value**3 for value in point)
    orbit_difference = sum(
        sign * point[i] * point[j] * point[k]
        for sign, triples in ((1, signed_triples), (-1, TRIPLES_MINUS))
        for i, j, k in triples
    )
    return power_sum, orbit_difference


def cubic_gradients(point):
    power_gradient = [3 * value**2 for value in point]
    orbit_gradient = [0] * 6
    for sign, triples in ((1, TRIPLES_PLUS), (-1, TRIPLES_MINUS)):
        for triple in triples:
            for index in triple:
                others = [other for other in triple if other != index]
                orbit_gradient[index] += sign * point[others[0]] * point[others[1]]
    return power_gradient, orbit_gradient


def singular_parameter(point):
    """Return t for which sum(z_i^3)+t Q is singular at point, if unique."""
    grad_p, grad_q = cubic_gradients(point)
    candidates = set()
    for index in range(1, 6):
        delta_p = grad_p[index] - grad_p[0]
        delta_q = grad_q[index] - grad_q[0]
        if delta_q:
            candidates.add(Fraction(-delta_p, delta_q))
        elif delta_p:
            return None
    if len(candidates) != 1:
        return None
    parameter = candidates.pop()
    value_p, value_q = cubic_value(point, TRIPLES_PLUS)
    return parameter if value_p + parameter * value_q == 0 else None


def normalize_sign(point):
    point = tuple(point)
    negation = tuple(-value for value in point)
    return min(point, negation)


def projective_points(field_order, dimension):
    for first in range(dimension):
        for tail in itertools.product(
            range(field_order), repeat=dimension - first - 1
        ):
            yield [0] * first + [1] + list(tail)


def finite_field_singular_census(field_order):
    counts = {parameter: 0 for parameter in range(field_order)}
    counts[None] = 0
    for affine_point in projective_points(field_order, 5):
        point = tuple(affine_point) + (-sum(affine_point) % field_order,)
        value_p, value_q = cubic_value(point, TRIPLES_PLUS)
        grad_p, grad_q = cubic_gradients(point)
        value_p %= field_order
        value_q %= field_order
        delta_p = [(grad_p[index] - grad_p[0]) % field_order for index in range(1, 6)]
        delta_q = [(grad_q[index] - grad_q[0]) % field_order for index in range(1, 6)]
        if value_q == 0 and not any(delta_q):
            counts[None] += 1
        candidates = {
            (-left * pow(right, -1, field_order)) % field_order
            for left, right in zip(delta_p, delta_q)
            if right
        }
        if len(candidates) == 1:
            parameter = candidates.pop()
            if (
                (value_p + parameter * value_q) % field_order == 0
                and all(
                    (left + parameter * right) % field_order == 0
                    for left, right in zip(delta_p, delta_q)
                )
            ):
                counts[parameter] += 1
    return {parameter: count for parameter, count in counts.items() if count}


def square_roots(value, field_order):
    value %= field_order
    return {candidate for candidate in range(field_order) if candidate**2 % field_order == value}


def main():
    assert len(GROUP) == 60
    assert len(TRIPLES_PLUS) == len(TRIPLES_MINUS) == 10
    axes = [tuple(5 if index == axis else -1 for index in POINTS) for axis in POINTS]
    partitions = sorted(
        {
            normalize_sign(tuple(1 if index in triple else -1 for index in POINTS))
            for triple in itertools.combinations(POINTS, 3)
        }
    )
    assert len(axes) == 6 and len(partitions) == 10
    axis_parameters = {singular_parameter(point) for point in axes}
    partition_parameters = {singular_parameter(point) for point in partitions}
    assert len(axis_parameters) == len(partition_parameters) == 1
    print(f"A5 order: {len(GROUP)}")
    print(f"triple-orbit sizes: {len(TRIPLES_PLUS)}, {len(TRIPLES_MINUS)}")
    print(f"six-axis singular parameter t: {axis_parameters.pop()}")
    print(f"ten-partition singular parameter t: {partition_parameters.pop()}")
    for field_order in (7, 11, 13, 17, 19, 23, 29, 31):
        census = finite_field_singular_census(field_order)
        expected = {0: 10, None: 6}
        for parameter in square_roots(-pow(3, -1, field_order), field_order):
            expected[parameter] = 5
        for parameter in square_roots(9 * pow(5, -1, field_order), field_order):
            expected[parameter] = field_order + 1
        assert census == expected
        print(f"F_{field_order} singular census (None=infinity): {census}")
    print("boundary parameters: infinity (6 points), 0 (10 points), "
          "t^2=-1/3 (5 points), t^2=9/5 (rational normal quartic)")
    print("PASS")


if __name__ == "__main__":
    main()
