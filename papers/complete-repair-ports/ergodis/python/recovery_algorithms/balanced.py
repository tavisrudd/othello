"""Small exact oracle for the normalized GF(27) balanced transversal quotient."""

from __future__ import annotations

from collections import Counter
from typing import Sequence

from .geometry import TernaryExtensionField


def _pow(field: TernaryExtensionField, value: int, exponent: int) -> int:
    result = 1
    while exponent:
        if exponent & 1:
            result = field.multiply(result, value)
        value = field.multiply(value, value)
        exponent >>= 1
    return result


def _mapping_key(
    rows: tuple[int, int, int],
    columns: tuple[int, int, int],
    ratios: tuple[int, int, int],
) -> tuple[tuple[int, int, int], ...]:
    return tuple(sorted(zip(ratios, rows, columns)))


def q27_high_fiber_from_carrier(
    trace: tuple[int, ...], product: tuple[int, ...], value: int
) -> tuple[int, ...]:
    """Return coefficients of ``C-yA+y^2`` through the supplied degree."""

    if len(trace) != len(product) or not trace or not 0 <= value < 27:
        raise ValueError("carrier dimensions or fiber value are invalid")
    field = TernaryExtensionField(27)
    coefficients = [
        field.add(c, field.multiply(2, field.multiply(value, a)))
        for a, c in zip(trace, product)
    ]
    coefficients[0] = field.add(coefficients[0], field.multiply(value, value))
    return tuple(coefficients)


def q27_reconstruct_carrier_from_fibers(
    first_value: int,
    first: tuple[int, ...],
    second_value: int,
    second: tuple[int, ...],
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    """Recover ``(A,C)`` from two distinct high fibers by `(SR24z)`."""

    if (
        first_value == second_value
        or not 0 <= first_value < 27
        or not 0 <= second_value < 27
        or len(first) != len(second)
        or not first
    ):
        raise ValueError("need two distinct same-width GF(27) fibers")
    field = TernaryExtensionField(27)
    denominator = field.add(first_value, field.multiply(2, second_value))
    inverse = _pow(field, denominator, 25)
    quotient = tuple(
        field.multiply(field.add(a, field.multiply(2, b)), inverse)
        for a, b in zip(first, second)
    )
    trace = [field.multiply(2, coefficient) for coefficient in quotient]
    trace[0] = field.add(trace[0], field.add(first_value, second_value))
    product = [
        field.add(coefficient, field.multiply(first_value, trace_coefficient))
        for coefficient, trace_coefficient in zip(first, trace)
    ]
    product[0] = field.add(
        product[0], field.multiply(2, field.multiply(first_value, first_value))
    )
    return tuple(trace), tuple(product)


def q27_balanced_carrier_affine_rank(
    ratio_index: int | None = None, transversal_index: int | None = None
) -> dict[str, int | None]:
    """Rank the 102 raw RS parities over all 26 row-pair option families."""

    field = TernaryExtensionField(27)
    fixed_rows: set[int] = set()
    fixed_completion: dict[int, int] = {}
    ratio_kappa = None
    if (ratio_index is None) != (transversal_index is None):
        raise ValueError("ratio and transversal indices must be supplied together")
    if ratio_index is not None:
        fibers = sorted(
            (
                kappa,
                tuple(
                    value
                    for value in range(27)
                    if field.multiply(
                        value,
                        _pow(field, field.add(value, 1), 2),
                    )
                    == kappa
                ),
            )
            for kappa in range(1, 27)
        )
        fibers = [(kappa, roots) for kappa, roots in fibers if len(roots) == 3]
        if not 0 <= ratio_index < len(fibers):
            raise ValueError("ratio index is out of range")
        ratio_kappa, ratios = fibers[ratio_index]
        inverse = {value: _pow(field, value, 25) for value in range(1, 27)}
        mappings = []
        for first in range(1, 27):
            for second in range(1, 27):
                if first == second:
                    continue
                third = inverse[field.multiply(first, second)]
                rows = (first, second, third)
                columns = tuple(
                    field.multiply(ratio, row) for ratio, row in zip(ratios, rows)
                )
                if len(set(rows)) == 3 and len(set(columns)) == 3:
                    mappings.append((rows, columns))
        assert transversal_index is not None
        if not 0 <= transversal_index < len(mappings):
            raise ValueError("transversal index is out of range")
        rows, columns = mappings[transversal_index]
        fixed_rows = set(rows)
        fixed_completion = dict(zip(rows, columns))
    basis: dict[int, list[int]] = {}

    def insert(vector: list[int]) -> None:
        for pivot in sorted(basis):
            coefficient = vector[pivot]
            if coefficient:
                vector = [
                    (value - coefficient * row_value) % 3
                    for value, row_value in zip(vector, basis[pivot])
                ]
        pivot = next((i for i, value in enumerate(vector) if value), None)
        if pivot is None:
            return
        if vector[pivot] == 2:
            vector = [(2 * value) % 3 for value in vector]
        for old_pivot, row in tuple(basis.items()):
            coefficient = row[pivot]
            if coefficient:
                basis[old_pivot] = [
                    (value - coefficient * new_value) % 3
                    for value, new_value in zip(row, vector)
                ]
        basis[pivot] = vector

    option_count = 0
    for u_value in range(1, 27):
        x_value = _pow(field, u_value, 3)
        powers = [_pow(field, x_value, exponent) for exponent in range(1, 18)]
        row_options = []
        for first in range(27):
            for second in range(first + 1, 27):
                if fixed_rows:
                    has_zero_t = u_value in (first, second)
                    if has_zero_t != (u_value in fixed_rows):
                        continue
                    if (
                        u_value in fixed_rows
                        and field.add(u_value, fixed_completion[u_value])
                        in (first, second)
                    ):
                        continue
                row_options.append((field.add(first, second), field.multiply(first, second)))
                option_count += 1
        baseline_a, baseline_c = row_options[0]
        for option_a, option_c in row_options[1:]:
            difference_a = field.add(option_a, field.multiply(2, baseline_a))
            difference_c = field.add(option_c, field.multiply(2, baseline_c))
            vector = []
            for difference in (difference_a, difference_c):
                for power in powers:
                    vector.extend(field._coefficients(field.multiply(difference, power)))
            insert(vector)
    return {
        "raw_width": 102,
        "affine_rank": len(basis),
        "row_families": 26,
        "row_pair_options": option_count,
        "ratio_kappa": ratio_kappa,
        "transversal_index": transversal_index,
    }


def q27_unmarked_pair_local_ranks() -> tuple[int, ...]:
    """Ranks of `(A,C)` option differences at each unmarked carrier row."""

    field = TernaryExtensionField(27)
    ranks = []
    for omitted in range(1, 27):
        pairs = [
            (field.add(first, second), field.multiply(first, second))
            for first in range(27)
            for second in range(first + 1, 27)
            if omitted not in (first, second)
        ]
        baseline = pairs[0]
        basis: dict[int, list[int]] = {}
        for pair in pairs[1:]:
            vector = []
            for value, base in zip(pair, baseline):
                difference = field.add(value, field.multiply(2, base))
                vector.extend(field._coefficients(difference))
            for pivot in sorted(basis):
                coefficient = vector[pivot]
                if coefficient:
                    vector = [
                        (entry - coefficient * row_entry) % 3
                        for entry, row_entry in zip(vector, basis[pivot])
                    ]
            pivot = next((i for i, entry in enumerate(vector) if entry), None)
            if pivot is None:
                continue
            if vector[pivot] == 2:
                vector = [(2 * entry) % 3 for entry in vector]
            for old_pivot, row in tuple(basis.items()):
                coefficient = row[pivot]
                if coefficient:
                    basis[old_pivot] = [
                        (entry - coefficient * new_entry) % 3
                        for entry, new_entry in zip(row, vector)
                    ]
            basis[pivot] = vector
        ranks.append(len(basis))
    return tuple(ranks)


def q27_search_high_fiber_candidates(
    families: Sequence[Sequence[tuple[int, tuple[int, ...]]]],
) -> dict[str, object] | None:
    """Choose the least-product seed pair and verify seven candidate families."""

    normalized = tuple(tuple(family) for family in families)
    if len(normalized) != 9 or any(not family for family in normalized):
        raise ValueError("need nine nonempty high-fiber families")
    values = tuple(family[0][0] for family in normalized)
    if (
        any(not 0 < value < 27 for value in values)
        or len(set(values)) != 9
        or any(candidate[0] != values[slot]
               for slot, family in enumerate(normalized)
               for candidate in family)
    ):
        raise ValueError("candidate families need distinct fixed fiber values")
    first_slot, second_slot = min(
        ((first, second) for first in range(8) for second in range(first + 1, 9)),
        key=lambda pair: (
            len(normalized[pair[0]]) * len(normalized[pair[1]]),
            pair,
        ),
    )
    indexes = tuple(
        {coefficients: index for index, (_, coefficients) in reversed(tuple(enumerate(family)))}
        for family in normalized
    )
    examined = 0
    for first_index, (_, first) in enumerate(normalized[first_slot]):
        for second_index, (_, second) in enumerate(normalized[second_slot]):
            examined += 1
            carrier = q27_reconstruct_carrier_from_fibers(
                values[first_slot], first, values[second_slot], second
            )
            selected = [0] * 9
            selected[first_slot] = first_index
            selected[second_slot] = second_index
            for slot in range(9):
                if slot in (first_slot, second_slot):
                    continue
                expected = q27_high_fiber_from_carrier(*carrier, values[slot])
                if expected not in indexes[slot]:
                    break
                selected[slot] = indexes[slot][expected]
            else:
                return {
                    "carrier": carrier,
                    "candidate_indices": tuple(selected),
                    "seed_slots": (first_slot, second_slot),
                    "candidates_examined": examined,
                }
    return None


def q27_carrier_from_high_cells(
    cells: Sequence[tuple[int, int]],
) -> dict[str, object]:
    """Solve the 18 trace/product coefficients from affine high cells."""

    field = TernaryExtensionField(27)
    if any(not 0 < x < 27 or not 0 <= y < 27 for x, y in cells):
        raise ValueError("cell coordinates are outside the carrier chart")
    rows: dict[int, list[int]] = {}
    for x, y in cells:
        equation = []
        power = 1
        for _ in range(9):
            equation.append(field.multiply(2, field.multiply(y, power)))
            power = field.multiply(power, x)
        power = 1
        for _ in range(9):
            equation.append(power)
            power = field.multiply(power, x)
        equation.append(field.multiply(2, field.multiply(y, y)))
        for pivot in sorted(rows):
            coefficient = equation[pivot]
            if coefficient:
                equation = [
                    field.add(value, field.multiply(2, field.multiply(coefficient, basis)))
                    for value, basis in zip(equation, rows[pivot])
                ]
        pivot = next((i for i, value in enumerate(equation[:18]) if value), None)
        if pivot is None:
            if equation[18]:
                return {"consistent": False, "rank": len(rows), "carrier": None}
            continue
        inverse = _pow(field, equation[pivot], 25)
        equation = [field.multiply(value, inverse) for value in equation]
        for old_pivot, row in tuple(rows.items()):
            coefficient = row[pivot]
            if coefficient:
                rows[old_pivot] = [
                    field.add(value, field.multiply(2, field.multiply(coefficient, new)))
                    for value, new in zip(row, equation)
                ]
        rows[pivot] = equation
    carrier = None
    if len(rows) == 18:
        solution = [0] * 18
        for pivot, row in rows.items():
            solution[pivot] = row[18]
        carrier = (tuple(solution[:9]), tuple(solution[9:]))
    return {"consistent": True, "rank": len(rows), "carrier": carrier}


def q27_balanced_terminal_rejection(
    trace: Sequence[int],
    product: Sequence[int],
    rows: Sequence[int],
    columns: Sequence[int],
    ratios: Sequence[int],
    kappa: int,
    high_values: Sequence[int],
    cubic_values: Sequence[int],
) -> str | None:
    """Replay the Rust terminal gates in their canonical rejection order."""

    if (
        len(trace) != 9
        or len(product) != 9
        or len(rows) != 3
        or len(columns) != 3
        or len(ratios) != 3
        or len(high_values) != 9
        or len(set(high_values)) != 9
        or set(cubic_values) != set(high_values).intersection(columns)
        or any(not 0 <= value < 27 for value in (*trace, *product))
    ):
        raise ValueError("invalid balanced-terminal fixture")
    field = TernaryExtensionField(27)

    def evaluate(coefficients: Sequence[int], x: int) -> int:
        result = 0
        for coefficient in reversed(coefficients):
            result = field.add(field.multiply(result, x), coefficient)
        return result

    y_counts = [0] * 27
    t_counts = [0] * 27
    ratio_counts = [0] * 27
    points: list[tuple[int, int]] = []
    for x in range(1, 27):
        u = _pow(field, x, 9)
        a_value = evaluate(trace, x)
        c_value = evaluate(product, x)
        roots = [
            y
            for y in range(27)
            if field.add(
                field.add(
                    field.multiply(y, y),
                    field.multiply(2, field.multiply(a_value, y)),
                ),
                c_value,
            )
            == 0
        ]
        if len(roots) != 2:
            return "CarrierDoesNotSplit"
        for y in roots:
            t = field.add(y, u)
            ratio = field.multiply(t, _pow(field, u, 25))
            y_counts[y] += 1
            t_counts[t] += 1
            ratio_counts[ratio] += 1
            points.append((u, t))

    expected_y = [1] * 27
    expected_y[0] = 2
    for value in columns:
        expected_y[value] = 0
    for value in high_values:
        expected_y[value] = 3 if value in cubic_values else 4
    if y_counts != expected_y:
        return "HighFiberProfile"

    row_cubes = tuple(_pow(field, row, 3) for row in rows)
    forbidden = tuple(
        field.multiply(field.add(ratio, 2), row)
        for ratio, row in zip(ratios, rows)
    )
    if any(
        evaluate(trace, x) == value for x, value in zip(row_cubes, forbidden)
    ):
        return "MappingCellPresent"

    expected_t = [2] * 27
    expected_t[0] = 3
    for value in columns:
        expected_t[value] = 1
    if t_counts != expected_t:
        return "UnshiftedNorm"

    expected_ratio = [2] * 27
    expected_ratio[0] = 3
    for value in ratios:
        expected_ratio[value] = 1
    if ratio_counts != expected_ratio:
        return "ReciprocalNorm"

    def witt4_theta(u: int, t: int) -> int:
        neg = lambda value: field.multiply(2, value)
        t4 = _pow(field, t, 4)
        u3 = _pow(field, u, 3)
        ku4 = field.multiply(kappa, _pow(field, u, 4))
        one_minus_kappa = field.add(1, neg(kappa))
        e3 = field.add(_pow(field, t, 3), field.multiply(one_minus_kappa, u3))
        e4 = field.add(
            field.add(t4, field.multiply(one_minus_kappa, field.multiply(t, u3))),
            neg(ku4),
        )
        powers = [0] * 9
        powers[1:5] = (t, _pow(field, t, 2), _pow(field, t, 3), field.add(t4, ku4))
        for exponent in range(5, 9):
            powers[exponent] = field.add(
                field.add(
                    field.multiply(t, powers[exponent - 1]),
                    field.multiply(e3, powers[exponent - 3]),
                ),
                neg(field.multiply(e4, powers[exponent - 4])),
            )
        e3_fourth = field.add(
            field.add(
                _pow(field, e3, 4),
                field.multiply(field.multiply(t, e3), _pow(field, e4, 2)),
            ),
            neg(_pow(field, e4, 3)),
        )
        carry_four = field.add(
            field.add(
                neg(field.multiply(powers[4], powers[8])),
                _pow(field, powers[4], 3),
            ),
            e3_fourth,
        )
        carry_target = neg(
            field.add(
                field.multiply(_pow(field, t4, 2), ku4),
                field.multiply(t4, _pow(field, ku4, 2)),
            )
        )
        return _pow(field, field.add(carry_four, neg(carry_target)), 9)

    fourth_sum = 0
    for u, t in points:
        fourth_sum = field.add(fourth_sum, witt4_theta(u, t))
    a5, a6, a7, a8 = (_pow(field, value, 9) for value in trace[5:9])
    delta = field.add(field.multiply(a6, a8), field.multiply(2, field.multiply(a7, a7)))
    kappa_r = _pow(field, kappa, 9)
    kappa_minus_one_r = _pow(field, field.add(kappa, 2), 9)
    common = field.multiply(kappa_r, kappa_minus_one_r)
    fourth_target = field.add(
        field.multiply(field.multiply(common, field.add(kappa_r, 1)), a5),
        field.multiply(field.multiply(common, kappa_minus_one_r), delta),
    )
    return None if fourth_sum == fourth_target else "FourthWitt"


def q27_balanced_transversal_oracle() -> dict[str, object]:
    """Enumerate normalized mappings and their full Frobenius quotient."""

    field = TernaryExtensionField(27)
    inverse = {value: _pow(field, value, 25) for value in range(1, 27)}
    fibers: dict[int, tuple[int, int, int]] = {}
    for kappa in range(1, 27):
        roots = tuple(
            value
            for value in range(27)
            if field.multiply(
                value,
                _pow(field, field.add(value, 1), 2),
            )
            == kappa
        )
        if len(roots) == 3:
            fibers[kappa] = roots

    mappings: dict[
        int,
        tuple[
            tuple[
                tuple[int, int, int],
                tuple[int, int, int],
                tuple[int, int, int],
            ],
            ...,
        ],
    ] = {}
    pair_multiplicities: Counter[
        tuple[int, tuple[int, ...], tuple[int, ...]]
    ] = Counter()
    for kappa, ratios in fibers.items():
        values = []
        for first in range(1, 27):
            for second in range(1, 27):
                if first == second:
                    continue
                third = inverse[field.multiply(first, second)]
                rows = (first, second, third)
                if len(set(rows)) != 3:
                    continue
                columns = tuple(
                    field.multiply(ratio, row)
                    for ratio, row in zip(ratios, rows)
                )
                if len(set(columns)) != 3:
                    continue
                values.append((rows, columns, ratios))
                pair_multiplicities[(
                    kappa, tuple(sorted(rows)), tuple(sorted(columns))
                )] += 1
        mappings[kappa] = tuple(values)

    def frobenius_key(mapping, power: int):
        rows, columns, ratios = mapping
        exponent = 3 ** power
        return _mapping_key(
            tuple(_pow(field, value, exponent) for value in rows),
            tuple(_pow(field, value, exponent) for value in columns),
            tuple(_pow(field, value, exponent) for value in ratios),
        )

    fixed_kappa_two = sum(
        _mapping_key(*mapping) == frobenius_key(mapping, 1)
        for mapping in mappings[2]
    )
    kappa_two_orbits = len({
        min(
            _mapping_key(*mapping),
            frobenius_key(mapping, 1),
            frobenius_key(mapping, 2),
        )
        for mapping in mappings[2]
    })
    return {
        "normalized_fibers": {kappa: roots for kappa, roots in fibers.items()},
        "mappings_per_fiber": {
            kappa: len(values) for kappa, values in mappings.items()
        },
        "mapping_count": sum(map(len, mappings.values())),
        "distinct_pair_count": len(pair_multiplicities),
        "pair_multiplicities": dict(Counter(pair_multiplicities.values())),
        "kappa_two_frobenius_fixed_mappings": fixed_kappa_two,
        "kappa_two_mapping_orbits": kappa_two_orbits,
        "full_semilinear_mapping_orbits": (
            sum(map(len, mappings.values())) + 2 * fixed_kappa_two
        ) // 3,
    }
