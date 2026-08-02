#!/usr/bin/env python3
"""Exact collision statistics for the committed C756 covering controls."""

from collections import Counter, defaultdict
from hashlib import sha256
import json
from math import comb, gcd, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-01-c756-intercept-subresultant-cover.json"
OUTPUT = HERE / "2026-08-01-c756-masked-rs-collision-audit.json"


def cover_max_r(n, delta):
    """Max sum binom(mu_t,2), given q nonempty matching fibres."""
    cap = n // 2
    if cap <= 1:
        assert delta == 0
        return 0
    full, remainder = divmod(delta, cap - 1)
    return full * comb(cap, 2) + comb(remainder + 1, 2)


def audit(instance):
    q = instance["q"]
    points = [tuple(p) for p in instance["points"]]
    n = len(points)
    fibres = defaultdict(list)
    cells = Counter()
    for i in range(n):
        xi, yi = points[i]
        for j in range(i + 1, n):
            xj, yj = points[j]
            dx = (xj - xi) % q
            assert dx
            slope = ((yj - yi) * pow(dx, -1, q)) % q
            intercept = (yi - slope * xi) % q
            fibres[slope].append((i, j))
            cells[(slope, intercept)] += 1

    multiplicities = [len(fibres[t]) for t in range(q)]
    b = comb(n, 2)
    delta = b - q
    r_parallel = sum(comb(mu, 2) for mu in multiplicities)
    sum_squares = sum(mu * mu for mu in multiplicities)
    entropy_product = prod(pow(mu, mu) for mu in multiplicities if mu)
    g = gcd(sum_squares, b * b)
    assert all(multiplicities)
    assert sum(multiplicities) == b
    assert sum_squares == b + 2 * r_parallel
    assert max(cells.values()) == 1  # an arc: every collision cell names one chord
    assert max(multiplicities) <= n // 2  # parallel chords form a matching

    return {
        "q": q,
        "n": n,
        "b": b,
        "delta": delta,
        "fibre_profile": dict(sorted(Counter(multiplicities).items())),
        "parallel_chord_pair_count_R": r_parallel,
        "cover_max_R": cover_max_r(n, delta),
        "sum_mu_squared": sum_squares,
        "renyi_collision_probability": {
            "numerator": sum_squares // g,
            "denominator": b * b // g,
        },
        "conditional_entropy_exact": f"log({entropy_product})/{b}",
        "max_cell_occupancy": max(cells.values()),
    }


def main():
    raw = SOURCE.read_bytes()
    source = json.loads(raw)
    result = {
        "claim": (
            "Exact RS agreement-column statistics for the six committed "
            "direction-covering controls; these controls do not impose conic externality."
        ),
        "source": SOURCE.name,
        "source_sha256": sha256(raw).hexdigest(),
        "identities_checked": [
            "sum(mu_t)=binom(n,2)",
            "sum(mu_t^2)=binom(n,2)+2R",
            "collision cells have occupancy one",
            "direction fibres are matchings",
        ],
        "rows": [audit(x) for x in source["instances"]],
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
