#!/usr/bin/env sage
"""Exact exploratory lattice audit for elliptic subgroup curves on C904 A5 ppav."""

from itertools import product
from math import gcd as py_gcd
from functools import reduce


scope = dict(globals())
scope["__name__"] = "c904_import"
source_text = open(
    "notes/2026-08-10-c904-minimal-class-divisor-lattice.sage"
).read()
exec(preparse(source_text), scope)
principal_lattice = scope["principal_lattice"]
generated_axis_group = scope["generated_axis_group"]


def primitive_vectors(bound):
    """Primitive integer coefficient lines, one orientation each."""
    for entries in product(range(-bound, bound + 1), repeat=5):
        if not any(entries):
            continue
        if reduce(py_gcd, (abs(value) for value in entries)) != 1:
            continue
        first = next(value for value in entries if value)
        if first < 0:
            continue
        yield vector(ZZ, entries)


def wedge_vector(left, right):
    return vector(ZZ, [
        left[i] * right[j] - left[j] * right[i]
        for i in range(10) for j in range(i + 1, 10)
    ])


def canonical_line(value):
    common = gcd(list(value))
    value = vector(ZZ, [entry // common for entry in value])
    first = next(entry for entry in value if entry)
    return -value if first < 0 else value


def matrix_bivector(value):
    return vector(ZZ, [
        value[i, j] for i in range(10) for j in range(i + 1, 10)
    ])


def bivector_matrix(value):
    result = zero_matrix(QQ, 10)
    cursor = 0
    for i in range(10):
        for j in range(i + 1, 10):
            result[i, j] = value[cursor]
            result[j, i] = -value[cursor]
            cursor += 1
    return result


def half_parity(value):
    """The class of a 2-adic number of valuation >= -1 in (1/2 Z_2)/Z_2."""
    value = QQ(value)
    if value.denominator() % 2:
        return GF(2).zero()
    doubled = 2 * value
    assert doubled.denominator() % 2
    return GF(2)(doubled.numerator()) / GF(2)(doubled.denominator())


def tracked_identity(rows, target):
    source = matrix(ZZ, rows)
    hermite, transform = source.hermite_form(transformation=True)
    nonzero = [index for index, row in enumerate(hermite.rows()) if not row.is_zero()]
    lattice = span(ZZ, [hermite.row(index) for index in nonzero])
    coordinates = lattice.coordinate_vector(target)
    result = zero_vector(ZZ, len(rows))
    for coordinate, index in zip(coordinates, nonzero):
        assert coordinate.denominator() == 1
        result += ZZ(coordinate) * transform.row(index)
    assert result * source == target
    return result


def saturated_curve(vector_value, basis, symplectic):
    """Primitive H_2 class of the elliptic subtorus on Q*vector_value."""
    inverse_basis = basis.inverse()
    source_x = vector(QQ, list(vector_value) + [0] * 5)
    source_y = vector(QQ, [0] * 5 + list(vector_value))
    rational_rows = [source_x * inverse_basis, source_y * inverse_basis]
    integral_rows = []
    for row in rational_rows:
        denominator = lcm(entry.denominator() for entry in row)
        integral_rows.append(vector(ZZ, [ZZ(denominator * entry) for entry in row]))
    lattice = span(ZZ, integral_rows).saturation()
    assert lattice.rank() == 2
    rows = list(lattice.basis_matrix().rows())

    # Orient by the complex/source coordinates (x(v), y(v)).
    pivot = next(index for index, value in enumerate(vector_value) if value)
    coefficient_rows = []
    for row in rows:
        source = row * basis
        ax = source[pivot] / vector_value[pivot]
        ay = source[5 + pivot] / vector_value[pivot]
        assert source == vector(QQ, [ax * value for value in vector_value]
                                      + [ay * value for value in vector_value])
        coefficient_rows.append((ax, ay))
    orientation = (coefficient_rows[0][0] * coefficient_rows[1][1]
                   - coefficient_rows[0][1] * coefficient_rows[1][0])
    assert orientation != 0
    if orientation < 0:
        rows.reverse()

    area = abs(orientation)
    degree = (rows[0] * symplectic * rows[1].column())[0]
    assert degree > 0
    assert degree == area * (vector_value * gram_global * vector_value.column())[0]
    return wedge_vector(rows[0], rows[1]), ZZ(degree), area, matrix(ZZ, rows)


def audit(bound):
    gram, _, basis, symplectic = principal_lattice("omega", 1)
    global gram_global
    gram_global = gram
    minimal_matrix = -symplectic.inverse()
    assert minimal_matrix.denominator() == 1
    minimal = matrix_bivector(minimal_matrix.change_ring(ZZ))

    axes = [vector(ZZ, [1 if i == j else 0 for i in range(5)])
            for j in range(5)] + [vector(ZZ, [-1] * 5)]
    axis_data = [saturated_curve(value, basis, symplectic) for value in axes]
    assert sum((item[0] for item in axis_data), zero_vector(ZZ, 45)) == 6 * minimal
    assert [item[1] for item in axis_data] == [5] * 6

    records = []
    class_seen = set()
    for value in primitive_vectors(bound):
        curve, degree, area, homology = saturated_curve(value, basis, symplectic)
        key = tuple(curve)
        if key not in class_seen:
            class_seen.add(key)
            records.append((value, curve, degree, area, homology))

    classes = [item[1] for item in records]
    lattice = span(ZZ, classes)
    saturation = lattice.saturation()
    saturation_basis = saturation.basis_matrix()
    coordinate_rows = []
    for row in lattice.basis_matrix().rows():
        coordinates = saturation_basis.transpose().solve_right(row)
        assert all(value.denominator() == 1 for value in coordinates)
        coordinate_rows.append(vector(ZZ, coordinates))
    coordinate_matrix = matrix(ZZ, coordinate_rows)
    smith = coordinate_matrix.smith_form()[0]
    smith_diagonal = [abs(smith[i, i]) for i in range(smith.nrows())]
    minimal_order = next(value for value in range(1, 65)
                         if value * minimal in lattice)
    twice_coefficients = tracked_identity(classes, 2 * minimal)
    twice_expression = [
        (tuple(records[index][0]), ZZ(coefficient))
        for index, coefficient in enumerate(twice_coefficients) if coefficient
    ]

    # Exact closure: the 121 short lines generate every Hodge one-cycle whose
    # source coefficient matrix is 2-adically integral.  The other six
    # directions are precisely half-integral.
    parity_rows = []
    for hodge_row in saturation_basis.rows():
        principal_bivector = bivector_matrix(hodge_row)
        source_bivector = basis.transpose() * principal_bivector * basis
        assert source_bivector[:5, :5] == 0 and source_bivector[5:, 5:] == 0
        coefficient = source_bivector[:5, 5:]
        assert coefficient == coefficient.transpose()
        parity_rows.append(vector(GF(2), [
            half_parity(coefficient[i, j])
            for i in range(5) for j in range(i, 5)
        ]))
    parity_map = matrix(GF(2), parity_rows)
    integral_kernel = parity_map.left_kernel()
    elliptic_mod_two = coordinate_matrix.change_ring(GF(2)).row_space()
    assert integral_kernel == elliptic_mod_two
    assert integral_kernel.dimension() == 9
    print("C904 non-axis elliptic subgroup audit")
    print(f"  coefficient bound={bound}; rational lines={len(records)}")
    print(f"  curve-class rank={lattice.rank()}; saturation index={lattice.index_in(saturation)}")
    print(f"  elliptic-span Smith quotient={smith_diagonal}")
    print(f"  minimal in elliptic span={minimal in lattice}; in saturation={minimal in saturation}")
    print(f"  minimal order modulo elliptic span={minimal_order}")
    print(f"  exact twice-minimal expression={twice_expression}")
    print(f"  source-plane area factors={sorted(set(item[3] for item in records))}")
    print("  2-integral Hodge sublattice equals elliptic span: PASS")
    print(f"  half-integral defect rank={parity_map.rank()}")
    # Since G has least real eigenvalue one, degree <=8 implies |v|^2<=24
    # (the only area denominators are 1 and 3), hence every coordinate is at
    # most four.  This makes the following low-degree census exhaustive.
    low_records = []
    for value in primitive_vectors(4):
        norm = (value * gram * value.column())[0]
        if norm > 24:
            continue
        curve, degree, area, homology = saturated_curve(value, basis, symplectic)
        if degree <= 8:
            low_records.append((value, curve, degree, area, homology))
    print(f"  theta degrees <=8={sorted(set(item[2] for item in low_records))}")
    print(f"  minimum theta degree={min(item[2] for item in low_records)}")
    histogram = {}
    for item in low_records:
        histogram[item[2]] = histogram.get(item[2], 0) + 1
    print(f"  degree histogram <=8={sorted(item for item in histogram.items() if item[0] <= 8)}")
    group = generated_axis_group()
    low_seen = set()
    low_orbits = []
    for value, curve, degree, area, homology in low_records:
        key = tuple(canonical_line(value))
        if key in low_seen:
            continue
        orbit = {tuple(canonical_line(action * value)) for action in group}
        low_seen.update(orbit)
        low_orbits.append((degree, area, len(orbit), tuple(value)))
    print(f"  low-degree A5 line orbits={sorted(low_orbits)}")
    print("  six axes: degree 5 each and sum=6 minimal class: PASS")


if __name__ == "__main__":
    audit(1)
