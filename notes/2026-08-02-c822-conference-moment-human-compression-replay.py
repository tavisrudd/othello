#!/usr/bin/env python3
"""Independent arithmetic replay for the C822 four-representative certificate."""

from fractions import Fraction
import json
import math
from pathlib import Path


CERTIFICATE = Path(__file__).with_name(
    "2026-08-02-c822-conference-moment-human-compression.json"
)
EXPECTED = {
    "latin_non_group": (4, 7640, 701666, Fraction(5824547586, 687739675)),
    "latin_cyclic": (0, 7800, 705250, Fraction(504439650, 27509587)),
    "steiner_noncyclic": (8, 9160, 682290, Fraction(-489762702, 137547935)),
    "steiner_cyclic": (13, 9360, 679770, Fraction(-699456186, 137547935)),
}


def probability(size: int) -> Fraction:
    return Fraction(math.comb(26 - size, 13 - size), math.comb(26, 13))


def moment(data: dict[str, object], x5: int, x6: int) -> Fraction:
    affine = data["profile_affine"]
    profile = {
        int(size): row["constant"] + row["x5"] * x5 + row["x6"] * x6
        for size, row in affine.items()
    }
    pair = {int(size): count for size, count in data["pair_profile"].items()}
    mean = Fraction(3250) * probability(4)
    factorial_two = sum(2 * count * probability(size) for size, count in pair.items())
    factorial_three = sum(
        6 * count * probability(size) for size, count in profile.items()
    )
    raw_two = factorial_two + mean
    raw_three = factorial_three + 3 * factorial_two + mean
    return raw_three - 3 * mean * raw_two + 2 * mean**3


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c822-conference-moment-human-compression-v1"
    observed = {}
    for record in data["representatives"]:
        name = record["name"]
        primitive = record.get("intercalates", record.get("pasch_configurations"))
        if primitive is None:
            primitive = record["pasch_configurations"]
        x5 = record["x5"]
        x6 = record["x6"]
        assert x5 == 10 * record["five_set_aligned_block_histogram"]["all"]["5"]
        assert x6 == record["six_set_spanning_triples"]["total"]
        if record["construction"] == "TD(3,5)":
            assert x5 == 7800 - 40 * primitive
            assert x6 == 705250 - 896 * primitive
        else:
            assert x5 == 8840 + 40 * primitive
            assert x6 == 686322 - 504 * primitive
        value = moment(data, x5, x6)
        assert value == Fraction(record["third_centered_moment"])
        observed[name] = (primitive, x5, x6, value)
    assert observed == EXPECTED
    assert len({row[3] for row in observed.values()}) == 4
    for name, (_, x5, x6, value) in observed.items():
        print(f"{name}: x5={x5} x6={x6} third_centered_moment={value}")


if __name__ == "__main__":
    main()
