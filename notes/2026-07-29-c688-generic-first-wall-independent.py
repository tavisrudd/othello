#!/usr/bin/env python3
"""Independent closed-form replay of the C688 local certificate."""

import argparse
import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c688-generic-first-wall.json"


def digest(value):
    text = json.dumps(value, separators=(",", ":"), sort_keys=True)
    return hashlib.sha256(text.encode()).hexdigest()


def closed_cg(a, b, k, p):
    c = a + b - 2 * k
    entries = []
    for m in range(c + 1):
        divisor = pow(math.comb(c, m) % p, -1, p)
        column = {}
        for j in range(k + 1):
            top = (-1) ** j * math.comb(k, j)
            for u in range(m + 1):
                v = m - u
                if u <= a - j and v <= b - k + j:
                    key = (j + u, k - j + v)
                    term = (
                        top
                        * math.comb(a - j, u)
                        * math.comb(b - k + j, v)
                        * divisor
                    )
                    column[key] = (column.get(key, 0) + term) % p
        entries.extend(
            [left, right, m, value]
            for (left, right), value in sorted(column.items())
            if value
        )
    return {
        "source_dimension": c + 1,
        "left_dimension": a + 1,
        "right_dimension": b + 1,
        "normalization": "highest coefficient (0,k) = 1",
        "entries": entries,
    }


def replay_case(case):
    p, s, e, r = (case[key] for key in ("p", "s", "e", "r"))
    assert r == p - 2 - s and 1 <= r < p
    assert case["occurrence"]["occurs"] == (
        e * ((p - 1) // 2) % 2 == (1 + s // 2) % 2
    )
    zeroth = closed_cg(r, p - 2, r, p)
    assert case["local_clebsch_gordan"]["zeroth_digit_sha256"] == digest(zeroth)
    toeplitz = [
        [j, r - j + m, m, (-1) ** j * math.comb(r, j) % p]
        for m in range(s + 1)
        for j in range(r + 1)
    ]
    assert zeroth["entries"] == toeplitz
    assert case["local_clebsch_gordan"]["zeroth_digit_exact_entries"] == (
        (s + 1) * (r + 1)
    )
    assert case["local_clebsch_gordan"]["zeroth_digit_toeplitz_band_width"] == (
        r + 1
    )
    assert case["local_clebsch_gordan"]["frobenius_digit_sha256"] == digest(
        closed_cg(1, 1, 1, p)
    )
    wall = case["first_wall"]
    assert wall["unique_adjacent_candidates"] == [[p - 2, 1]]
    seed = [(-1) ** j * math.comb(r, j) % p for j in range(r + 1)]
    assert wall["seed_polynomial"]["coefficients_mod_p"] == seed
    assert wall["seed_polynomial"]["constant_coordinate"] == 1
    assert wall["seed_polynomial"]["negative_linear_coordinate"] == r
    product = [1]
    for _ in range(r):
        next_product = [0] * (len(product) + 1)
        for index, value in enumerate(product):
            next_product[index] = (next_product[index] + value) % p
            next_product[index + 1] = (next_product[index + 1] - value) % p
        product = next_product
    assert product == seed
    assert wall["trace_scalar"] == sum(range(r + 1)) - sum(range(r))
    assert wall["trace_scalar"] == r
    assert wall["spill_coordinate"]["coefficient"] == 1
    assert case["trace_target_dimension"] == 2 * (s + 1) * (p - 1)
    assert case["spill_target_dimension"] == 6 * (p - 1 - s)
    gap = case["torus_gap"]
    assert gap["coefficient_plus_one_interval"][0] == s + 2
    assert gap["coefficient_minus_one_interval"][1] == -s - 2
    if gap["degenerate_root_group_repair"] is not None:
        assert (p, s, e) == (3, 0, 2)
        repair = gap["degenerate_root_group_repair"]
        # Independently expand the two degree-one factors which separate
        # the wrapped torus-fixed basis under u(t)-1.
        matrix = [[math.comb(1, 1) % p, 0], [0, math.comb(1, 1) % p]]
        assert repair["coefficient_matrix"] == matrix
        assert repair["root_coefficients"] == ["t", f"t^{p}"]
    assert gap["hom_B_dimension"] == 0


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", required=True)
    parser.parse_args()
    certificate = json.loads(CERTIFICATE.read_text())
    for case in certificate["cases"]:
        replay_case(case)
    assert certificate["committed_cross_checks"]["q121"]["trace_scalar"] == 3
    assert certificate["committed_cross_checks"]["q169"]["trace_scalar"] == 5
    print("C688 independent closed-form replay OK")


if __name__ == "__main__":
    main()
