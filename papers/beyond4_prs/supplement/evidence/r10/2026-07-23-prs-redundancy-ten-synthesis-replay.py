#!/usr/bin/env python3
"""Independent arithmetic replay for the R10 certificate."""

from __future__ import annotations

import json
import math
from pathlib import Path


DATA = Path(__file__).with_name("2026-07-23-prs-redundancy-ten-synthesis.json")


def prime(n: int) -> bool:
    return n >= 2 and all(n % d for d in range(2, math.isqrt(n) + 1))


def prime_powers(limit: int) -> set[int]:
    values: set[int] = set()
    for p in range(2, limit + 1):
        if prime(p):
            value = p
            while value <= limit:
                values.add(value)
                value *= p
    return values


def cyclic_classes(modulus: int, multipliers: tuple[int, ...]) -> list[frozenset[int]]:
    remaining = set(range(modulus))
    classes: list[frozenset[int]] = []
    while remaining:
        orbit = {min(remaining)}
        changed = True
        while changed:
            changed = False
            for x in tuple(orbit):
                for a in multipliers:
                    y = a * x % modulus
                    if y not in orbit:
                        orbit.add(y)
                        changed = True
        remaining -= orbit
        classes.append(frozenset(orbit))
    return classes


def main() -> None:
    data = json.loads(DATA.read_text())
    powers = prime_powers(1000)
    generic = min(q for q in powers if q + 1 - 2 * math.sqrt(q) > 42)
    char2 = min(2**m for m in range(1, 20)
                if 2**m >= 45 and 2**m + 1 - 2 * math.sqrt(2**m) > 23)
    assert generic == data["generic_spine"]["first_prime_power"] == 59
    assert char2 == data["characteristic_two_slice"]["first_power_of_two"] == 64
    assert sum(data["characteristic_two_slice"]["deletion_degrees"].values()) == 23
    assert len(cyclic_classes(9, (-1,))) == 5
    assert len(cyclic_classes(9, (-1, 8))) == 5
    assert len(cyclic_classes(9, (-1, 2))) == 3
    assert len(cyclic_classes(9, (-1, 5))) == 3
    for q in (59, 64, 67, 81, 125):
        tangent = q * (q + 1)
        sigma = q * (q * q - 1) // 2
        assert tangent + sigma == q * (q + 1) ** 2 // 2
        assert q * (q * q - 1) + q**4 * (q + 1) >= 0
    print("R10 independent arithmetic replay: PASS")


if __name__ == "__main__":
    main()
