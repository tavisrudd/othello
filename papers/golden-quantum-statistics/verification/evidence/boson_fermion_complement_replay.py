#!/usr/bin/env python3
"""Independent standard-library replay of the rational exchange-sector claims."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "boson_fermion_complement.json"
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def evaluate(terms: list[dict], values: tuple[int, ...]) -> int:
    return sum(
        term["coefficient"]
        * product(value**power for value, power in zip(values, term["exponents"]))
        for term in terms
    )


def product(values) -> int:
    answer = 1
    for value in values:
        answer *= value
    return answer


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1 if column % 2 else 1)
        * value
        * determinant([row[:column] + row[column + 1 :] for row in matrix[1:]])
        for column, value in enumerate(matrix[0])
    )


def cut_invariants(support: tuple[int, ...]) -> dict[str, Fraction]:
    chosen = set(support)
    other = tuple(i for i in range(6) if i not in chosen)
    cross = [[BASE_C[i][j] for j in other] for i in support]
    gram = [
        [sum(cross[i][k] * cross[j][k] for k in range(len(other)))
         for j in range(len(support))]
        for i in range(len(support))
    ]
    gram2 = [
        [sum(gram[i][k] * gram[k][j] for k in range(len(support)))
         for j in range(len(support))]
        for i in range(len(support))
    ]
    p1 = Fraction(sum(gram[i][i] for i in range(len(support))), 5)
    p2 = Fraction(sum(gram2[i][i] for i in range(len(support))), 25)
    e2 = (p1 * p1 - p2) / 2
    e3 = Fraction(determinant(gram), 125) if len(support) == 3 else Fraction(0)
    return {
        "p1": p1,
        "p2": p2,
        "exterior2": e2,
        "exterior3": e3,
        "symmetric3": e3 + p1 * p2,
        "mixed21": p1 * e2 - e3,
    }


def main() -> None:
    payload = json.loads(CERTIFICATE.read_text())
    terms = payload["exact_permanent"]["scaled_integer_polynomial_terms"]
    representatives = payload["six_protocols"]["lexicographic_representatives"]
    records = payload["balanced_census"]["records"]
    assert len(terms) == 44 and len(representatives) == 6 and len(records) == 20

    amplitudes = set()
    probabilities = set()
    multiset_counts: dict[tuple[Fraction, ...], int] = {}
    records_by_support = {
        tuple(record["negative_support"]): record for record in records
    }
    jc_layers = set()
    for support in itertools.combinations(range(6), 3):
        control = tuple(-1 if i in support else 1 for i in range(6))
        vector = tuple(
            evaluate(terms, tuple(control[permutation[i]] for i in range(6)))
            for permutation in representatives
        )
        amplitudes.add(vector)
        probability = tuple(Fraction(value * value, 50000) for value in vector)
        probabilities.add(probability)
        key = tuple(sorted(probability))
        multiset_counts[key] = multiset_counts.get(key, 0) + 1
        record = records_by_support[support]
        assert tuple(record["scaled_permanent_coordinates"]) == vector
        assert tuple(map(Fraction, record["collision_free_probabilities"])) == probability
        assert all(abs(value) == 8 for value in record["oriented_segre_coordinates"])
        jc = tuple(map(Fraction, record["jabbour_cerf_layers_m0_to_m3"]))
        assert jc[0] - jc[1] + jc[2] - jc[3] == 0
        assert jc[3] == Fraction(16, 125)
        jc_layers.add(jc)

    assert len(amplitudes) == 20
    assert len(probabilities) == 4
    assert sorted(multiset_counts.values()) == [8, 12]
    assert set(multiset_counts) == {
        (Fraction(36, 3125),) * 6,
        (Fraction(16, 3125),) * 2 + (Fraction(64, 3125),) * 4,
    }
    assert jc_layers == {
        tuple(Fraction(value, 3125) for value in (36, 172, 536, 400)),
        tuple(Fraction(value, 3125) for value in (16, 432, 816, 400)),
        tuple(Fraction(value, 3125) for value in (64, 360, 696, 400)),
    }

    eigenvalues = (Fraction(1, 5), Fraction(4, 5), Fraction(4, 5))
    h3 = sum(
        eigenvalues[i] * eigenvalues[j] * eigenvalues[k]
        for i in range(3)
        for j in range(i, 3)
        for k in range(j, 3)
    )
    e3 = product(eigenvalues)
    trace1 = sum(eigenvalues)
    trace2 = sum(value * value for value in eigenvalues)
    trace3 = sum(value**3 for value in eigenvalues)
    h2 = (trace1**2 + trace2) / 2
    e2 = (trace1**2 - trace2) / 2
    s21 = (trace1**3 - trace3) / 3
    assert h3 == Fraction(313, 125)
    assert e3 == Fraction(16, 125)
    assert h3 - e3 == trace1 * trace2 == Fraction(297, 125)
    assert h3 / 10 / e3 == Fraction(313, 160)
    assert (h2, e2, s21) == (Fraction(57, 25), Fraction(24, 25), Fraction(8, 5))
    assert h3 - trace1 * h2 + e2 * trace1 - e3 == 0
    assert h3 + 2 * s21 + e3 == trace1**3 == Fraction(729, 125)

    profiles = {
        row["negative_support_size"]: {
            key: Fraction(value)
            for key, value in row.items()
            if key != "negative_support_size"
        }
        for row in payload["continuous_control"]["boolean_profiles_up_to_complement"]
    }
    for signs in itertools.product((-1, 1), repeat=6):
        support = tuple(i for i, value in enumerate(signs) if value < 0)
        if len(support) > 3:
            support = tuple(i for i in range(6) if i not in support)
        assert cut_invariants(support) == profiles[len(support)]

    landscape = payload["hermitian_exchange_landscape"]
    for t in (Fraction(0), Fraction(1, 4), Fraction(1)):
        h_value = Fraction(317, 125) - Fraction(4, 125) * t
        s_value = Fraction(196, 125) + Fraction(4, 125) * t
        e_value = Fraction(20, 125) - Fraction(4, 125) * t
        assert h_value + s_value == Fraction(513, 125)
        assert s_value + e_value == Fraction(216, 125)
    assert landscape["stability"]["global_lower_squared_distance_factor"] == "10/3"
    assert landscape["stability"]["local_upper_squared_distance_factor"] == "40"
    print("ok: continuous endpoint profiles, Hermitian Pareto identities, and balanced census")


if __name__ == "__main__":
    main()
