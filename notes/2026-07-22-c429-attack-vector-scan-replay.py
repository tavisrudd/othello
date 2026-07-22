#!/usr/bin/env python3
"""Independent arithmetic replay for the C429 phase certificate."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERT = HERE / "2026-07-22-c429-attack-vector-scan.json"


def mul(x: tuple[int, int], y: tuple[int, int], p: int) -> tuple[int, int]:
    a, b = x
    c, d = y
    return ((a * c + b * d) % p, (a * d + b * c + b * d) % p)


def power(x: tuple[int, int], n: int, p: int) -> tuple[int, int]:
    out = (1, 0)
    while n:
        if n & 1:
            out = mul(out, x, p)
        x = mul(x, x, p)
        n //= 2
    return out


def roots(p: int) -> list[int]:
    return [x for x in range(p) if (x * x - x - 1) % p == 0]


def main() -> None:
    data = json.loads(CERT.read_text())
    m = data["smith_fitting"]["multiplication_by_delta_basis_1_tau"]
    det = m[0][0] * m[1][1] - m[0][1] * m[1][0]
    assert abs(det) == 5 and data["smith_fitting"]["smith_invariants"] == [1, 5]
    assert roots(19) == [5, 15] and roots(13) == []
    assert power((0, 1), 13, 13) == (1, 12)  # 1-tau
    delta = (4, 2)
    assert delta != (0, 0) and mul(delta, delta, 5) == (0, 0)
    assert data["orientation_line"]["smith_invariants"] == [2]
    assert data["orientation_line"]["delta_image"] == "2*(1 wedge tau)"

    # At 2 the algebra is etale (t^2+t+1 irreducible), but sign equals trivial character.
    assert roots(2) == [] and (1 % 2) == (-1 % 2)

    # The mod-5 multiplication matrix has one-dimensional image and kernel, both span(delta).
    image = {((m[0][0] * a + m[0][1] * b) % 5,
              (m[1][0] * a + m[1][1] * b) % 5) for a in range(5) for b in range(5)}
    kernel = {(a, b) for a in range(5) for b in range(5)
              if ((m[0][0] * a + m[0][1] * b) % 5,
                  (m[1][0] * a + m[1][1] * b) % 5) == (0, 0)}
    delta_line = {((c * delta[0]) % 5, (c * delta[1]) % 5) for c in range(5)}
    assert image == kernel == delta_line
    assert data["phase_pilots"]["ramified_p5"]["nilradical_equals_cotangent_line"] is True

    for upstream in data["upstream"].values():
        path = HERE / upstream["file"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == upstream["sha256"]
    print("C429 independent replay: PASS")


if __name__ == "__main__":
    main()
