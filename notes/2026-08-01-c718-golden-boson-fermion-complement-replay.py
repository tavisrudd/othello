#!/usr/bin/env python3
"""Independent standard-library replay of the rational C718 crown claims."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-08-01-c718-golden-boson-fermion-complement.json"


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
    print("ok: 20 amplitudes, 4 probability vectors, 313/125 symmetric-cube trace")


if __name__ == "__main__":
    main()
