#!/usr/bin/env python3
"""Exact certificate for the all-weight C682 two-sided defect theorem."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c682-all-weight-defect-theorem.json"
ROWS = {
    5: {
        "content": -224_139_069_000_000,
        "linear_roots": [-1, -1, 0, 1, 2, 5, 6, 10, 11, 20, 21, 22, 40],
        "nonlinear_coefficients_descending": [
            1,
            -212,
            15_223,
            -488_904,
            7_808_148,
            -66_741_312,
            297_475_776,
            -549_918_720,
        ],
        "root_exclusion_prime": 19,
    },
    6: {
        "content": -313_083_144_000_000,
        "linear_roots": [-1, -1, 1, 2, 6, 7, 10, 11, 12, 21, 22, 32, 52],
        "nonlinear_coefficients_descending": [
            1,
            -222,
            16_093,
            -522_804,
            8_516_428,
            -72_644_832,
            304_415_136,
            -465_004_800,
        ],
        "root_exclusion_prime": 37,
    },
    7: {
        "content": -425_793_075_840_000,
        "linear_roots": [-1, -1, 2, 3, 7, 8, 14, 22, 24],
        "nonlinear_coefficients_descending": [
            1,
            -366,
            54_046,
            -4_333_948,
            211_782_253,
            -6_665_676_310,
            138_723_826_572,
            -1_920_916_253_560,
            17_436_078_244_704,
            -99_121_205_538_432,
            317_523_863_255_040,
            -431_617_455_360_000,
        ],
        "root_exclusion_prime": 31,
    },
    8: {
        "content": -566_111_248_560_000,
        "linear_roots": [-1, -1, 3, 4, 6, 8, 9, 16, 26],
        "nonlinear_coefficients_descending": [
            1,
            -422,
            73_196,
            -7_030_994,
            420_297_995,
            -16_540_077_656,
            439_827_993_736,
            -7_944_771_857_568,
            96_010_933_196_016,
            -742_769_807_731_584,
            3_325_327_086_977_280,
            -6_553_069_205_760_000,
        ],
        "root_exclusion_prime": 37,
    },
    9: {
        "content": -738_164_667_240_000,
        "linear_roots": [-1, -1, 4, 5, 9, 10, 18, 28],
        "nonlinear_coefficients_descending": [
            1,
            -468,
            90_698,
            -9_823_740,
            669_662_709,
            -30_478_355_136,
            954_494_459_312,
            -20_809_117_566_864,
            314_503_451_849_584,
            -3_222_432_487_323_840,
            21_288_623_589_033_984,
            -81_499_619_083_530_240,
            136_681_560_981_504_000,
        ],
        "root_exclusion_prime": 29,
    },
}


def trim(polynomial: list[int]) -> list[int]:
    out = polynomial[:]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def add(left: list[int], right: list[int]) -> list[int]:
    size = max(len(left), len(right))
    return trim(
        [
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
            for index in range(size)
        ]
    )


def scale(polynomial: list[int], scalar: int) -> list[int]:
    return trim([scalar * coefficient for coefficient in polynomial])


def multiply(left: list[int], right: list[int]) -> list[int]:
    out = [0] * (len(left) + len(right) - 1)
    for left_degree, left_coefficient in enumerate(left):
        for right_degree, right_coefficient in enumerate(right):
            out[left_degree + right_degree] += (
                left_coefficient * right_coefficient
            )
    return trim(out)


def product(polynomials: list[list[int]]) -> list[int]:
    out = [1]
    for polynomial in polynomials:
        out = multiply(out, polynomial)
    return out


def linear(constant: int, slope: int = 1) -> list[int]:
    return [constant, slope]


def falling_linear(constant: int, order: int) -> list[int]:
    return product(
        [linear(constant - offset) for offset in range(order)]
    )


def falling_integer(value: int, order: int) -> int:
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def d1(degree_shift: int, index: int) -> list[int]:
    return scale(
        linear(degree_shift - 4 * index + 6),
        330 * falling_integer(index, 2),
    )


def d11(degree_shift: int, index: int) -> list[int]:
    return scale(
        multiply(
            falling_linear(degree_shift - index, 2),
            linear(3 * degree_shift - 4 * index - 6, 3),
        ),
        -330,
    )


def d6_from_complement(complement_shift: int, index: int) -> list[int]:
    complement = linear(complement_shift)
    pieces = [
        scale(falling_linear(complement_shift, 3), 2),
        scale(
            falling_linear(complement_shift, 2),
            -9 * index,
        ),
        scale(
            complement,
            9 * falling_integer(index, 2),
        ),
        [-2 * falling_integer(index, 3)],
    ]
    return scale(sum_polynomials(pieces), 660)


def sum_polynomials(polynomials: list[list[int]]) -> list[int]:
    out = [0]
    for polynomial in polynomials:
        out = add(out, polynomial)
    return out


def upper_row(center: int) -> list[list[int]]:
    return [
        d11(0, center - 5),
        d6_from_complement(-center, center),
        d1(0, center + 5),
    ]


def lower_row(center: int) -> list[list[int]]:
    complement_shift = -center
    return [
        scale(
            product(
                [linear(-4 * center + 12)]
                + [
                    linear(complement_shift + offset)
                    for offset in range(-2, 6)
                ]
            ),
            330,
        ),
        multiply(
            d6_from_complement(-center - 3, center - 3),
            scale(falling_linear(-center, 3), falling_integer(center, 3)),
        ),
        scale(
            linear(3 * 0 - 4 * center - 12, 3),
            -330
            * product_of_integers(center + offset for offset in range(-2, 6)),
        ),
    ]


def product_of_integers(values) -> int:
    out = 1
    for value in values:
        out *= value
    return out


def cross(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        add(
            multiply(left[1], right[2]),
            scale(multiply(left[2], right[1]), -1),
        ),
        add(
            multiply(left[2], right[0]),
            scale(multiply(left[0], right[2]), -1),
        ),
        add(
            multiply(left[0], right[1]),
            scale(multiply(left[1], right[0]), -1),
        ),
    ]


def local_determinant(center: int) -> list[int]:
    first = cross(upper_row(center), lower_row(center))
    second = cross(upper_row(center + 5), lower_row(center + 5))
    return add(
        multiply(first[2], second[0]),
        scale(multiply(first[1], second[1]), -1),
    )


def descending_to_ascending(coefficients: list[int]) -> list[int]:
    return list(reversed(coefficients))


def expected_factorization(row: dict) -> list[int]:
    return scale(
        multiply(
            product([linear(-root) for root in row["linear_roots"]]),
            descending_to_ascending(
                row["nonlinear_coefficients_descending"]
            ),
        ),
        row["content"],
    )


def evaluate(polynomial: list[int], value: int) -> int:
    out = 0
    for coefficient in reversed(polynomial):
        out = out * value + coefficient
    return out


def build_certificate() -> dict:
    determinant_rows = []
    for center, row in ROWS.items():
        actual = local_determinant(center)
        expected = expected_factorization(row)
        assert actual == expected
        prime = row["root_exclusion_prime"]
        nonlinear = descending_to_ascending(
            row["nonlinear_coefficients_descending"]
        )
        residues = [
            residue
            for residue in range(prime)
            if evaluate(nonlinear, residue) % prime == 0
        ]
        assert residues == []
        assert max(row["linear_roots"]) <= 52
        determinant_rows.append(
            {
                "source_residue_mod_5": center - 5,
                "first_center": center,
                "degree": len(actual) - 1,
                **row,
                "nonlinear_roots_mod_prime": residues,
            }
        )

    return {
        "schema": "c682-all-weight-two-sided-defect-v1",
        "operator": "Q_n=(Delta_n,Delta_{n-6}^dagger)",
        "chain_split": (
            "The three source-to-target shifts -2,3,8 are congruent "
            "modulo 5."
        ),
        "local_block": (
            "For each residue r, the upper and lower equations at centers "
            "j=r+5 and j+5 form a four-by-four block on "
            "(v_r,v_{r+5},v_{r+10},v_{r+15})."
        ),
        "determinant_rows": determinant_rows,
        "propagation": {
            "right_upper_factor": "n-4c-14",
            "right_lower_factor": "3n-4c-12",
            "bezout_combination": (
                "3(n-4c-14)-(3n-4c-12)=-8c-30, nonzero for c>=5"
            ),
        },
        "theorem": (
            "ker Q_n=0 for every integer n>52. Combined with the exact "
            "bounded spectrum, the complete exceptional degrees are "
            "0,1,2,6,10,11,12,20,21,22,32,40,52."
        ),
        "repeated_isotypic_consequence": (
            "Degree 22 is the unique two-sided defect in all weights that "
            "can occupy a repeated isotypic summand."
        ),
        "claim_boundary": (
            "This proves the all-weight two-sided-defect theorem, not the "
            "all-weight full-corner theorem; codimension-two upper-return "
            "mixing and off-peak propagation remain."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 all-weight two-sided defect theorem")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
