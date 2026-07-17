#!/usr/bin/env python3
"""Certify generic irreducibility of the C210 collision resultant."""

from __future__ import annotations

import json
import shutil
import subprocess

from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)


def main() -> None:
    ring = BinaryRing()
    polynomial = resultant(ring, expected_quadratics(ring))
    used = [
        name for index, name in enumerate(NAMES)
        if any(monomial[index] for monomial in polynomial)
    ]

    def term(monomial: tuple[int, ...]) -> str:
        factors = []
        for index, name in enumerate(NAMES):
            exponent = monomial[index]
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        return "*".join(factors) or "1"

    source = "\n".join((
        f"ring q=2,({','.join(used)}),dp;",
        "poly R=" + "+".join(term(monomial) for monomial in polynomial) + ";",
        "list F=factorize(R);",
        "print(size(F[1]));",
        "print(F[2][2]);",
    ))
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command,
        input=source,
        text=True,
        capture_output=True,
        check=True,
    )
    assert completed.stderr == ""
    factor_list_size, exponent = map(int, completed.stdout.split())
    # Singular includes the unit as the first entry.
    assert factor_list_size == 2 and exponent == 1

    degrees = {
        name: max(monomial[NAMES.index(name)] for monomial in polynomial)
        for name in ("u", "t")
    }
    print(json.dumps({
        "coefficient_field": "GF(2)",
        "coefficient_parameters": [
            name for name in used if name not in ("u", "t")
        ],
        "resultant_term_count": len(polynomial),
        "resultant_degrees": degrees,
        "irreducible_factors": 1,
        "generic_geometric_irreducibility":
            "the prior absolutely irreducible degree-preserving GF(8) fiber lies in this family",
        "conclusion":
            "the coefficient-generic collision curve is absolutely irreducible; factorization is confined to a proper closed coefficient locus",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
