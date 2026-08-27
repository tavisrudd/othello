#!/usr/bin/env python3
"""Generate retained Nullstellensatz identities for the six empty branches.

The ordinary replay uses SymPy.  This optional archival generator asks
Singular for transformation matrices and stores identities

    sum(multiplier_i * generator_i) = constant != 0.

The regular verification scripts check those identities directly with
SymPy; Singular is needed only to regenerate this retained certificate.
"""

import argparse
import itertools
import json
import subprocess
import sys
from pathlib import Path

import sympy as sp

if sys.flags.optimize:
    raise RuntimeError("certificate generation requires assertions")


ROOT = Path(__file__).resolve().parent
SLICE_CERTIFICATE = ROOT / "slice-cover-certificate.json"


def singular(expression):
    return str(expression).replace("**", "^")


source = json.loads(SLICE_CERTIFICATE.read_text(encoding="utf-8"))
a, b, localizer = sp.symbols("a b localizer")
parse = {"a": a, "b": b}
determinants = [
    sp.sympify(value, locals=parse)
    for value in source["symbolic_four_hyperplane_evaluation_determinants"]
]
minors = [
    sp.sympify(value, locals=parse)
    for value in source["symbolic_tangent_smoothness_minors"]
]
determinant_numerators = [
    sp.together(value).as_numer_denom()[0] for value in determinants
]
minor_numerators = [
    sp.together(value).as_numer_denom()[0] for value in minors
]
delta = a * b * (a - 1) * (b - 1) * (a - b)
localization = localizer * delta - 1
empty_codes = [
    outcome["chosen_zero_factors"]
    for outcome in source["first_three_branch_outcomes"]
    if outcome["localized_zero_locus"] == "empty"
]

branch_generators = {}
program = ["ring r=0,(a,b,localizer),dp;"]
for index, code in enumerate(empty_codes):
    generators = [
        (minor_numerators if choice == "M" else determinant_numerators)[position]
        for position, choice in enumerate(code)
    ] + [localization]
    branch_generators[code] = generators
    program.extend([
        f"ideal I{index}=" + ",".join(singular(value) for value in generators) + ";",
        f"matrix T{index}; ideal G{index}=liftstd(I{index},T{index});",
        f'print("BEGIN_{code}");',
        f"print(G{index}[1]);",
        *[f"print(T{index}[{row},1]);" for row in range(1, 5)],
        f'print("END_{code}");',
    ])

result = subprocess.run(
    ["Singular", "-q"],
    input="\n".join(program) + "\n",
    text=True,
    capture_output=True,
    check=True,
)
assert not result.stderr.strip(), result.stderr
lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]

branches = {}
cursor = 0
for code in empty_codes:
    assert lines[cursor] == f"BEGIN_{code}"
    constant = lines[cursor + 1].replace("^", "**")
    multipliers = [
        lines[cursor + offset].replace("^", "**") for offset in range(2, 6)
    ]
    assert lines[cursor + 6] == f"END_{code}"
    cursor += 7
    generators = branch_generators[code]
    identity = sum(
        sp.sympify(multiplier, locals={"a": a, "b": b, "localizer": localizer})
        * generator
        for multiplier, generator in zip(multipliers, generators)
    )
    assert sp.expand(identity - sp.Integer(constant)) == 0
    branches[code] = {
        "constant": constant,
        "generators": [str(value) for value in generators],
        "multipliers": multipliers,
    }
assert cursor == len(lines)

payload = {
    "branches": branches,
    "schema": "quartic-del-pezzo-groebner-empty-identities-v1",
    "variables": ["a", "b", "localizer"],
}

parser = argparse.ArgumentParser()
parser.add_argument("--write-certificate", type=Path, required=True)
arguments = parser.parse_args()
arguments.write_certificate.write_text(
    json.dumps(payload, indent=2, sort_keys=True) + "\n",
    encoding="utf-8",
)
print("Groebner empty localized-case certificates: written")
