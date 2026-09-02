#!/usr/bin/env python3
"""Independent small-field oracle for the q29 mod-3/mod-9 norm counts.

GR(9,2) is represented as Z/9[t]/(t^2+1); conjugation sends t to -t,
so N(a+bt)=a^2+b^2.  Histogram convolution counts four-norm spheres
without using the Rust extractor or its group-ring representation.
"""


def cyclic_convolution(left: list[int], right: list[int]) -> list[int]:
    modulus = len(left)
    output = [0] * modulus
    for i, left_count in enumerate(left):
        for j, right_count in enumerate(right):
            output[(i + j) % modulus] += left_count * right_count
    return output


def four_norm_count(modulus: int) -> int:
    histogram = [0] * modulus
    for a in range(modulus):
        for b in range(modulus):
            histogram[(a * a + b * b) % modulus] += 1
    pair = cyclic_convolution(histogram, histogram)
    quartet = cyclic_convolution(pair, pair)
    return quartet[1]


def main() -> None:
    residue_count = four_norm_count(3)
    mod9_count = four_norm_count(9)
    assert residue_count == 3**7 - 3**3
    assert mod9_count == 3**14 - 3**10
    assert mod9_count == residue_count * 3**7
    print(f"residue_count={residue_count} expected={3**7 - 3**3}")
    print(f"mod9_count={mod9_count} expected={3**14 - 3**10}")
    print(f"lifts_per_residue={mod9_count // residue_count}")
    print("provenance=IndependentExhaustiveSmallOracle; degree-one analogue")


if __name__ == "__main__":
    main()
