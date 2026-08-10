#!/usr/bin/env sage
"""Exact divisor-lattice proof for the C904 A5 cubic ppav.

Construct every A5-stable principal gluing of the six-axis source G=6I-J,
compute its integral divisor lattice and degree-four products, and certify
that the minimal class lies in the saturated product lattice.  The compact
certificate uses two coordinate projections of coprime indices 7 and 17.
"""

from itertools import combinations, combinations_with_replacement, product
import sys


def axis_action(permutation):
    """Action on v1,...,v5 when v6=-(v1+...+v5)."""
    columns = []
    for source in range(5):
        target = permutation[source]
        if target == 5:
            columns.append(vector(ZZ, [-1] * 5))
        else:
            columns.append(vector(ZZ, [1 if i == target else 0 for i in range(5)]))
    return matrix(ZZ, 5, 5, columns).transpose()


def mobius_generators():
    # Points are 0,1,2,3,4,infinity.  T:x->x+1 and S:x->-1/x
    translation = [1, 2, 3, 4, 0, 5]
    inversion = [5, 4, 2, 3, 1, 0]
    return axis_action(translation), axis_action(inversion)


def generated_axis_group():
    generators = mobius_generators()
    identity = identity_matrix(ZZ, 5)
    elements = {tuple(identity.list()): identity}
    frontier = [identity]
    while frontier:
        value = frontier.pop()
        for generator in generators:
            product_value = value * generator
            key = tuple(product_value.list())
            if key not in elements:
                elements[key] = product_value
                frontier.append(product_value)
    assert len(elements) == 60
    return list(elements.values())


def quotient_action(matrix_z, prime):
    """Action on (F_p^5)/<1>, in coordinates y_i-y_5."""
    field = GF(prime)
    dual = matrix_z.inverse().transpose().change_ring(field)
    columns = []
    for source in range(4):
        lifted = vector(field, [1 if i == source else 0 for i in range(5)])
        image = dual * lifted
        columns.append(vector(field, [image[i] - image[4] for i in range(4)]))
    return matrix(field, 4, 4, columns).transpose()


def commutant_basis(generators):
    field = generators[0].base_ring()
    rows = []
    for generator in generators:
        for i in range(4):
            for j in range(4):
                row = [field.zero()] * 16
                for k in range(4):
                    row[4 * i + k] += generator[k, j]
                    row[4 * k + j] -= generator[i, k]
                rows.append(row)
    kernel = matrix(field, rows).right_kernel()
    return [matrix(field, 4, 4, list(vector_value)) for vector_value in kernel.basis()]


def exotic_endomorphism(generators):
    field = GF(2)
    basis = commutant_basis(generators)
    elements = []
    for coefficients in product(field, repeat=len(basis)):
        value = sum((coefficient * item for coefficient, item in zip(coefficients, basis)),
                    matrix(field, 4))
        elements.append(value)
    identity = identity_matrix(field, 4)
    exotic = [value for value in elements
              if value not in (matrix(field, 4), identity)]
    assert len(elements) == 4 and len(exotic) == 2
    assert all(value * value + value + identity == 0 for value in exotic)
    return exotic[0]


def principal_lattice(two_slope="omega", three_slope=1):
    gram = 6 * identity_matrix(ZZ, 5) - matrix(ZZ, 5, 5, [1] * 25)
    first, second = mobius_generators()
    assert first.transpose() * gram * first == gram
    assert second.transpose() * gram * second == gram

    action_two = [quotient_action(value, 2) for value in (first, second)]
    action_three = [quotient_action(value, 3) for value in (first, second)]
    assert len(commutant_basis(action_two)) == 2
    assert len(commutant_basis(action_three)) == 1
    omega = exotic_endomorphism(action_two)
    identity_two = identity_matrix(GF(2), 4)
    two_maps = {
        "zero": zero_matrix(GF(2), 4),
        "one": identity_two,
        "omega": omega,
        "omega2": omega + identity_two,
    }
    assert two_slope == "infinity" or two_slope in two_maps
    assert three_slope in ("infinity", 0, 1, 2)

    gram_inverse = gram.inverse()
    generators = [6 * vector(ZZ, [1 if i == j else 0 for i in range(10)])
                  for j in range(10)]

    # Order-two graph y |-> omega*y.  Quotient representatives use fifth
    # coordinate zero; multiplying by three selects the 2-primary classes.
    for source in range(4):
        y = vector(ZZ, [3 if i == source else 0 for i in range(5)])
        if two_slope == "infinity":
            x = zero_vector(QQ, 5)
            z = y
        else:
            x = gram_inverse * y
            image_q = two_maps[two_slope] * vector(
                GF(2), [1 if i == source else 0 for i in range(4)]
            )
            z = vector(ZZ, [3 * ZZ(image_q[i]) for i in range(4)] + [0])
        glued = vector(QQ, list(x) + list(gram_inverse * z))
        generators.append(vector(ZZ, [ZZ(6 * entry) for entry in glued]))

    # The monodromy-selected order-three graph may be normalized to any one
    # of the four P1(F3) points by a multiplicity-coordinate change.
    for source in range(4):
        y = vector(ZZ, [2 if i == source else 0 for i in range(5)])
        if three_slope == "infinity":
            x = zero_vector(QQ, 5)
            z = y
        else:
            x = gram_inverse * y
            z = ZZ(three_slope) * y
        glued = vector(QQ, list(x) + list(gram_inverse * z))
        generators.append(vector(ZZ, [ZZ(6 * entry) for entry in glued]))

    scaled_lattice = span(ZZ, generators)
    assert scaled_lattice.rank() == 10
    basis_scaled = scaled_lattice.basis_matrix()
    basis = basis_scaled.change_ring(QQ) / 6

    zero = zero_matrix(ZZ, 5)
    symplectic_source = block_matrix(ZZ, [[zero, gram], [-gram, zero]])
    symplectic_principal = basis * symplectic_source * basis.transpose()
    assert symplectic_principal.denominator() == 1
    symplectic_principal = symplectic_principal.change_ring(ZZ)
    assert abs(symplectic_principal.det()) == 1
    return gram, omega, basis, symplectic_principal


def ns_integrality_matrix(basis):
    """Linear map from symmetric coefficient matrices to quotient pairings."""
    positions = [(i, j) for i in range(5) for j in range(i, 5)]
    columns = []
    for i, j in positions:
        coefficient = zero_matrix(QQ, 5)
        coefficient[i, j] = 1
        coefficient[j, i] = 1
        if i == j:
            coefficient[i, i] = 1
        zero = zero_matrix(QQ, 5)
        alternating = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        pulled = basis * alternating * basis.transpose()
        columns.append(vector(QQ, pulled.list()))
    return positions, matrix(QQ, columns).transpose()


def congruence_kernel_lattice(linear_map):
    """Return {x in Z^n : linear_map*x is integral} as a row lattice."""
    denominator = lcm(entry.denominator() for entry in linear_map.list())
    integral_map = (denominator * linear_map).change_ring(ZZ)
    modulus = ZZ(denominator)
    # Solve A*x-modulus*y=0 over ZZ and project its saturated integer kernel.
    augmented = integral_map.augment(-modulus * identity_matrix(ZZ, linear_map.nrows()))
    integer_kernel = augmented.right_kernel().basis_matrix()
    projected = [vector(ZZ, row[:linear_map.ncols()]) for row in integer_kernel.rows()]
    lattice = span(ZZ, projected)
    assert lattice.rank() == linear_map.ncols()
    assert all(all(value.denominator() == 1 for value in linear_map * row)
               for row in lattice.basis_matrix().rows())
    return denominator, lattice


def coefficient_matrix(coordinates, positions):
    result = zero_matrix(ZZ, 5)
    for value, (i, j) in zip(coordinates, positions):
        result[i, j] = value
        result[j, i] = value
    return result


def two_form(matrix_value):
    return {(i, j): ZZ(matrix_value[i, j])
            for i in range(matrix_value.nrows())
            for j in range(i + 1, matrix_value.ncols())
            if matrix_value[i, j] != 0}


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(1 for i in left_indices for j in right_indices if i > j)
            indices = tuple(sorted(left_indices + right_indices))
            sign = -1 if inversions % 2 else 1
            result[indices] = result.get(indices, 0) + sign * left_value * right_value
    return {indices: value for indices, value in result.items() if value}


def divisor_product_lattice(basis, symplectic, positions, ns_lattice,
                            find_identity=True):
    zero = zero_matrix(QQ, 5)
    divisor_forms = []
    ns_basis = ns_lattice.basis_matrix().LLL()
    for coordinates in ns_basis.rows():
        coefficient = coefficient_matrix(coordinates, positions)
        alternating = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        integral_form = basis * alternating * basis.transpose()
        assert integral_form.denominator() == 1
        divisor_forms.append(two_form(integral_form.change_ring(ZZ)))

    degree_two = {}
    for i, j in combinations_with_replacement(range(len(divisor_forms)), 2):
        degree_two[(i, j)] = wedge(divisor_forms[i], divisor_forms[j])

    degree_three = {}
    for i, j, k in combinations_with_replacement(range(len(divisor_forms)), 3):
        degree_three[(i, j, k)] = wedge(degree_two[(i, j)], divisor_forms[k])

    eight_indices = list(combinations(range(10), 8))
    product_rows = []
    monomials = []
    for i, j, k, ell in combinations_with_replacement(range(len(divisor_forms)), 4):
        value = wedge(degree_three[(i, j, k)], divisor_forms[ell])
        product_rows.append(vector(ZZ, [value.get(indices, 0) for indices in eight_indices]))
        monomials.append((i, j, k, ell))
    product_lattice = span(ZZ, product_rows)
    saturated_product_lattice = product_lattice.saturation()

    theta = two_form(symplectic)
    theta_squared = wedge(theta, theta)
    theta_fourth = wedge(theta_squared, theta_squared)
    assert all(value % factorial(4) == 0 for value in theta_fourth.values())
    minimal = vector(ZZ, [theta_fourth.get(indices, 0) // factorial(4)
                          for indices in eight_indices])
    rational_span = span(QQ, product_rows)
    assert minimal in rational_span
    coordinates = product_lattice.coordinate_vector(minimal)
    parity_order = lcm(value.denominator() for value in coordinates)
    assert parity_order * minimal in product_lattice

    product_lookup = {tuple(row): index for index, row in enumerate(product_rows)}
    short_identity = None
    if tuple(minimal) in product_lookup:
        short_identity = [(monomials[product_lookup[tuple(minimal)]], 1)]
    else:
        for index, row in enumerate(product_rows):
            for sign in (-1, 1):
                needed = tuple(minimal - sign * row)
                if needed in product_lookup:
                    short_identity = [
                        (monomials[index], sign),
                        (monomials[product_lookup[needed]], 1),
                    ]
                    break
            if short_identity is not None:
                break

    if not find_identity:
        return (product_lattice, saturated_product_lattice, minimal, parity_order,
                len(product_rows), None, short_identity, product_rows, monomials)

    # Track a small integral identity incrementally.  Keeping only the current
    # rank-at-most-15 HNF basis avoids a 3060-variable Smith computation.
    basis_rows = []
    representations = []
    support = None
    for generator_index, generator in enumerate(product_rows):
        input_rows = basis_rows + [generator]
        input_representations = representations + [{generator_index: ZZ.one()}]
        hermite, transform = matrix(ZZ, input_rows).hermite_form(transformation=True)
        next_rows = []
        next_representations = []
        for row_index, row in enumerate(hermite.rows()):
            if row.is_zero():
                continue
            representation = {}
            for source_index, coefficient in enumerate(transform[row_index]):
                if not coefficient:
                    continue
                for key, value in input_representations[source_index].items():
                    representation[key] = representation.get(key, 0) + coefficient * value
            representation = {key: value for key, value in representation.items() if value}
            next_rows.append(row)
            next_representations.append(representation)
        basis_rows, representations = next_rows, next_representations
        current_lattice = span(ZZ, basis_rows)
        if current_lattice.rank() == product_lattice.rank() and minimal in current_lattice:
            target_coordinates = current_lattice.coordinate_vector(minimal)
            combined = {}
            for coefficient, representation in zip(target_coordinates, representations):
                assert coefficient.denominator() == 1
                for key, value in representation.items():
                    combined[key] = combined.get(key, 0) + ZZ(coefficient) * value
            support = [(monomials[index], value)
                       for index, value in sorted(combined.items()) if value]
            assert sum((value * product_rows[monomials.index(monomial)]
                        for monomial, value in support), zero_vector(ZZ, 45)) == minimal
            break
    assert support is not None
    return (product_lattice, saturated_product_lattice, minimal, parity_order,
            len(product_rows), support, short_identity, product_rows, monomials)


def orbit_scan(basis, symplectic, positions, ns_lattice):
    zero = zero_matrix(QQ, 5)
    theta = two_form(symplectic)
    theta_squared = wedge(theta, theta)
    theta_fourth = wedge(theta_squared, theta_squared)
    eight_indices = list(combinations(range(10), 8))
    minimal = vector(ZZ, [theta_fourth.get(indices, 0) // factorial(4)
                          for indices in eight_indices])
    first_nonzero = next(index for index, value in enumerate(minimal) if value)
    group = generated_axis_group()
    results = []
    for basis_index, coordinates in enumerate(ns_lattice.basis_matrix().LLL().rows()):
        coefficient = coefficient_matrix(coordinates, positions)
        orbit = {}
        for action in group:
            image = action.transpose() * coefficient * action
            orbit[tuple(image.list())] = image
        orbit_sum = zero_vector(ZZ, len(eight_indices))
        for image in orbit.values():
            alternating = block_matrix(QQ, [[zero, image], [-image, zero]])
            integral_form = basis * alternating * basis.transpose()
            assert integral_form.denominator() == 1
            divisor = two_form(integral_form.change_ring(ZZ))
            fourth = wedge(wedge(divisor, divisor), wedge(divisor, divisor))
            orbit_sum += vector(ZZ, [fourth.get(indices, 0) for indices in eight_indices])
        multiplier = orbit_sum[first_nonzero] / minimal[first_nonzero]
        assert multiplier.denominator() == 1
        assert orbit_sum == ZZ(multiplier) * minimal
        results.append((basis_index, len(orbit), ZZ(multiplier)))
    return results


def main():
    if sys.argv[1:] == ["--export-constants"]:
        _, _, basis, symplectic = principal_lattice()
        positions, linear_map = ns_integrality_matrix(basis)
        _, ns_lattice = congruence_kernel_lattice(linear_map)
        print("PRINCIPAL_BASIS =", [list(row) for row in basis.rows()])
        print("PRINCIPAL_SYMPLECTIC =", [list(row) for row in symplectic.rows()])
        print("NS_BASIS =", [list(row) for row in ns_lattice.basis_matrix().LLL().rows()])
        print("PASS")
        return
    if sys.argv[1:] == ["--minor-certificate"]:
        _, _, basis, symplectic = principal_lattice()
        positions, linear_map = ns_integrality_matrix(basis)
        _, ns_lattice = congruence_kernel_lattice(linear_map)
        (_, _, minimal, _, _, _, _, product_rows, monomials) = (
            divisor_product_lattice(
                basis, symplectic, positions, ns_lattice, find_identity=False
            )
        )
        product_matrix = matrix(ZZ, product_rows)
        pivot_rows = list(product_matrix.transpose().pivots())
        assert len(pivot_rows) == 15
        rational_coefficients = product_matrix[pivot_rows, :].transpose().solve_right(minimal)
        assert rational_coefficients * product_matrix[pivot_rows, :] == minimal
        pivot_columns = list(product_matrix[pivot_rows, :].pivots())
        candidates = [
            pivot_columns,
            [0, 1, 2, 6, 7, 8, 10, 11, 13, 16, 17, 18, 23, 31, 36],
        ]
        running_gcd = ZZ.zero()
        improvements = []
        for column_indices in candidates:
            projected = product_matrix[:, column_indices]
            if projected.rank() != 15:
                continue
            projected_lattice = span(ZZ, projected.rows())
            projection_index = projected_lattice.index_in(ZZ ** 15)
            next_gcd = gcd(running_gcd, projection_index)
            if next_gcd != running_gcd:
                improvements.append((
                    next_gcd,
                    column_indices,
                    projection_index,
                ))
                running_gcd = next_gcd
        print("C904 saturation minor certificate")
        print(f"  projections=2 improvements={len(improvements)} gcd={running_gcd}")
        print(f"  rational-basis monomials={[monomials[i] for i in pivot_rows]}")
        print(f"  minimal rational coordinates={list(rational_coefficients)}")
        for index, item in enumerate(improvements):
            print(f"  certificate[{index}]={item}")
        assert running_gcd == 1
        print("PASS")
        return
    if sys.argv[1:] == ["--all-gluings"]:
        print("C904 all principal gluing parity audit")
        for two_slope in ("infinity", "zero", "one", "omega", "omega2"):
            for three_slope in ("infinity", 0, 1, 2):
                _, _, basis, symplectic = principal_lattice(two_slope, three_slope)
                positions, linear_map = ns_integrality_matrix(basis)
                _, ns_lattice = congruence_kernel_lattice(linear_map)
                (product_lattice, saturated_product_lattice, _, parity_order,
                 product_count, _, _, _, _) = (
                    divisor_product_lattice(
                        basis, symplectic, positions, ns_lattice,
                        find_identity=False,
                    )
                )
                print(
                    f"  p2={two_slope:8} p3={str(three_slope):8} "
                    f"NS-index={ns_lattice.index_in(ZZ**15)} "
                    f"Hodge-rank={product_lattice.rank()} order={parity_order} "
                    f"Hodge-index={product_lattice.index_in(saturated_product_lattice)} "
                    f"products={product_count}"
                )
        print("PASS")
        return
    orbit_scan_only = sys.argv[1:] == ["--orbit-scan"]
    if sys.argv[1:] and not orbit_scan_only:
        raise SystemExit(
            "usage: minimal-class-divisor-lattice.sage "
            "[--all-gluings|--orbit-scan|--export-constants|--minor-certificate]"
        )

    gram, omega, basis, symplectic = principal_lattice()
    positions, linear_map = ns_integrality_matrix(basis)
    denominator, ns_lattice = congruence_kernel_lattice(linear_map)
    if orbit_scan_only:
        print("C904 A5 divisor-orbit scan")
        for basis_index, orbit_size, multiplier in orbit_scan(
                basis, symplectic, positions, ns_lattice):
            print(f"  D{basis_index}: orbit={orbit_size:2} fourth-power sum={multiplier}*minimal")
        print("PASS")
        return
    (product_lattice, saturated_product_lattice, minimal, parity_order,
     product_count, support, short_identity, _, _) = divisor_product_lattice(
         basis, symplectic, positions, ns_lattice
     )

    print("C904 exotic cubic divisor lattice: stage 1")
    print(f"  det(6I-J)={gram.det()}; exotic omega polynomial check=PASS")
    print(f"  principal homology Gram determinant={symplectic.det()}")
    print(f"  integrality denominator={denominator}")
    print(f"  NS rank={ns_lattice.rank()}; coefficient index={ns_lattice.index_in(ZZ**15)}")
    print(f"  degree-four divisor monomials={product_count}; Hodge-span rank={product_lattice.rank()}")
    print(f"  divisor-product index in saturated Hodge lattice="
          f"{product_lattice.index_in(saturated_product_lattice)}")
    print(f"  minimal-class order modulo divisor products={parity_order}")
    print(f"  integral identity support={len(support)}; L1={sum(abs(value) for _, value in support)}")
    print(f"  one-or-two-term identity={short_identity}")
    print(f"  reduced NS coefficient basis=\n{ns_lattice.basis_matrix().LLL()}")
    print("PASS")


if __name__ == "__main__":
    main()
