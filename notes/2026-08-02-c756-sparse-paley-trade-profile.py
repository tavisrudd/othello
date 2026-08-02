#!/usr/bin/env python3
"""C756 Route F: exact integral Fourier/valuation/autocorrelation census.

For every normalized pairwise-resultant-character candidate in the bounded
prime fields q in {5, 7, 11, 19, 23} (the same orientation-minimization bound
as the 2026-08-01 uncertainty pass), build the conjugation-odd signed vector

    x = 1_Z - 1_{Z^q}

on the additive group of F_{q^2} in the canonical minimizing orientation, and
record exact integral data only:

  * Fourier values x^(w) = sum_z x(z) zeta_p^{Tr(wz)} as elements of Z[zeta_p],
    with the Frobenius antisymmetry x^(w^q) = -x^(w) asserted exactly;
  * the Paley class census: how much Fourier support lies on the wrong
    eigenvalue class for the target eigenvalue (q-1)/2;
  * pi-adic valuations at the unique prime pi = (1 - zeta_p) above p, via the
    exact digit formula v_pi(alpha) = min_j (j + (p-1) v_p(c_j)) for the
    (1-zeta)-expansion c of alpha (the minimum is uniquely attained because
    distinct j < p-1 are distinct modulo p-1);
  * which squared moduli |x^(w)|^2 are rational integers, and their histogram;
  * the full integer autocorrelation A(d) = sum_z x(z) x(z+d), refined by the
    quadratic class of d and by rationality of d.

No norm, entropy, or interlacing statistic is introduced: every recorded field
is a finite integral invariant.
"""

from __future__ import annotations

import argparse
from collections import Counter
from hashlib import sha256
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, product
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-01-c756-probability-cheap-tests.py"
AUDIT = HERE / "2026-08-01-c756-saturated-internal-audit.json"
OUTPUT = HERE / "2026-08-02-c756-sparse-paley-trade-profile.json"
FIELDS = (5, 7, 11, 19, 23)

spec = spec_from_file_location("c756_probability", SOURCE)
source = module_from_spec(spec)
spec.loader.exec_module(source)


def canonical_orientation(candidate, field, chi_table, q):
    """Exact replica of the 2026-08-01 minimizing-orientation rule."""
    sub, conj, sigma = field["sub"], field["conj"], field["sigma"]
    k = len(candidate)
    best = None
    for bits in product((0, 1), repeat=k):
        oriented = [conj(z) if bit else z for z, bit in zip(candidate, bits)]
        violations = sum(
            chi_table[sub(oriented[i], conj(oriented[j]))] != sigma
            for i, j in combinations(range(k), 2)
        )
        key = (violations, bits)
        if best is None or key < best[0]:
            best = (key, oriented)
    (violations, bits), oriented = best
    return violations, bits, oriented


def reduce_cyclotomic(vector, p):
    """Length-p integer vector on 1, zeta, ..., zeta^(p-1) -> degree < p-1."""
    tail = vector[p - 1]
    return tuple(vector[i] - tail for i in range(p - 1))


def pi_valuation(reduced, p, digit_matrix):
    """v_pi at pi = 1 - zeta_p; None encodes alpha = 0."""
    if all(value == 0 for value in reduced):
        return None
    best = None
    for j, row in enumerate(digit_matrix):
        digit = sum(row[i] * reduced[i] for i in range(p - 1))
        if digit == 0:
            continue
        vp = 0
        while digit % p == 0:
            digit //= p
            vp += 1
        value = j + (p - 1) * vp
        if best is None or value < best:
            best = value
    assert best is not None
    return best


def multiply_cyclotomic(left, right, p):
    """Product of two length-p vectors modulo X^p - 1."""
    out = [0] * p
    for i, a in enumerate(left):
        if a == 0:
            continue
        for j, b in enumerate(right):
            if b:
                out[(i + j) % p] += a * b
    return out


def rational_value(reduced):
    """Return the rational integer r with alpha = r, else None."""
    if any(value != 0 for value in reduced[1:]):
        return None
    return reduced[0]


def paley_eigenvalue_classes(q, field, chi_table):
    """Map chi2 class -> exact Paley eigenvalue on that frequency class."""
    mul = field["mul"]
    elements = [(a, b) for a in range(q) for b in range(q)]
    squares = sorted({field["fpow"](z, 2) for z in elements if z != (0, 0)})
    assert len(squares) == (q * q - 1) // 2
    eps = field["eps"]
    out = {}
    for target in (1, -1):
        w = next(z for z in elements if chi_table[z] == target)
        counts = Counter(
            (2 * (w[0] * s[0] + eps * w[1] * s[1])) % q for s in squares
        )
        nonzero = {counts.get(t, 0) for t in range(1, q)}
        assert len(nonzero) == 1
        eig = counts.get(0, 0) - nonzero.pop()
        out[target] = eig
    assert sorted(out.values()) == [-(q + 1) // 2, (q - 1) // 2]
    return out


def candidate_profile(candidate, field, chi_table, q, digit_matrix, eig_class):
    sub, conj, eps = field["sub"], field["conj"], field["eps"]
    violations, bits, oriented = canonical_orientation(
        candidate, field, chi_table, q
    )
    signed = {z: 1 for z in oriented}
    signed.update({conj(z): -1 for z in oriented})
    assert len(signed) == 2 * len(candidate)
    assert all(z[1] != 0 for z in signed)

    good_class = next(c for c, e in eig_class.items() if e == (q - 1) // 2)

    transforms = {}
    for w in ((a, b) for a in range(q) for b in range(q)):
        vector = [0] * q
        for z, sign in signed.items():
            vector[(2 * (w[0] * z[0] + eps * w[1] * z[1])) % q] += sign
        transforms[w] = reduce_cyclotomic(vector, q)

    zero = tuple([0] * (q - 1))
    for w, reduced in transforms.items():
        mirror = transforms[conj(w)]
        assert all(mirror[i] == -reduced[i] for i in range(q - 1))
        if w[1] == 0:
            assert reduced == zero

    support = [w for w, reduced in transforms.items() if reduced != zero]
    wrong_class = sum(1 for w in support if chi_table[w] != good_class)

    valuations = Counter()
    valuations_by_class = Counter()
    rational_moduli = Counter()
    irrational_moduli = 0
    for w in support:
        reduced = transforms[w]
        v = pi_valuation(reduced, q, digit_matrix)
        valuations[v] += 1
        valuations_by_class[(chi_table[w], v)] += 1
        full = list(reduced) + [0]
        conjugate = [full[0]] + full[1:][::-1]
        modulus = rational_value(
            reduce_cyclotomic(multiply_cyclotomic(full, conjugate, q), q)
        )
        if modulus is None:
            irrational_moduli += 1
        else:
            rational_moduli[modulus] += 1

    auto = Counter()
    for z, sz in signed.items():
        for z2, sz2 in signed.items():
            auto[sub(z2, z)] += sz * sz2
    assert auto[(0, 0)] == 2 * len(candidate)
    energy = sum(value * value for value in auto.values())
    auto_by_class = Counter()
    auto_rational = Counter()
    for d in ((a, b) for a in range(q) for b in range(q)):
        if d == (0, 0):
            continue
        value = auto.get(d, 0)
        auto_by_class[(chi_table[d], value)] += 1
        if d[1] == 0:
            auto_rational[value] += 1

    profile = {
        "coherence_violations_min": violations,
        "orientation_bits": "".join(map(str, bits)),
        "fourier_support_size": len(support),
        "wrong_class_support": wrong_class,
        "pi_valuation_histogram": {
            str(v): count for v, count in sorted(valuations.items())
        },
        "pi_valuation_by_class": {
            f"chi={chi}:v={v}": count
            for (chi, v), count in sorted(valuations_by_class.items())
        },
        "rational_squared_moduli": {
            str(m): count for m, count in sorted(rational_moduli.items())
        },
        "irrational_squared_moduli": irrational_moduli,
        "autocorrelation_by_class": {
            f"chi={chi}:A={value}": count
            for (chi, value), count in sorted(auto_by_class.items())
        },
        "autocorrelation_on_rational_d": {
            str(value): count for value, count in sorted(auto_rational.items())
        },
        "additive_energy": energy,
    }
    exact_values = None
    if q == 5:
        exact_values = [
            {
                "w": list(w),
                "chi": chi_table[w],
                "coefficients": list(transforms[w]),
                "pi_valuation": pi_valuation(transforms[w], q, digit_matrix),
            }
            for w in sorted(support)
        ]
    return profile, exact_values


def field_row(q, expected_candidates):
    candidates, field = source.saturated_candidates(q)
    assert len(candidates) == expected_candidates
    chi_table = {
        (a, b): field["chi2"]((a, b)) for a in range(q) for b in range(q)
    }
    digit_matrix = [
        [comb(i, j) * (-1) ** j for i in range(q - 1)] for j in range(q - 1)
    ]
    eig_class = paley_eigenvalue_classes(q, field, chi_table)
    profiles = []
    frames = []
    for candidate in candidates:
        profile, exact_values = candidate_profile(
            candidate, field, chi_table, q, digit_matrix, eig_class
        )
        profiles.append(profile)
        if exact_values is not None:
            frames.append(exact_values)
    signature_counts = Counter(
        json.dumps(profile, sort_keys=True) for profile in profiles
    )
    distinct = [
        {"count": count, "profile": json.loads(signature)}
        for signature, count in sorted(signature_counts.items())
    ]
    return {
        "q": q,
        "candidate_count": len(candidates),
        "paley_eigenvalue_by_chi_class": {
            str(chi): eig for chi, eig in sorted(eig_class.items())
        },
        "distinct_profiles": distinct,
        "frame_exact_fourier_values": frames or None,
    }


def generate():
    expected = {
        row["q"]: row["candidates"]
        for row in json.loads(AUDIT.read_text())["rows"]
    }
    return {
        "schema": "c756-sparse-paley-trade-profile-v1",
        "scope": (
            "every normalized pairwise-resultant-character candidate in the "
            "bounded prime fields q in {5,7,11,19,23}, in the canonical "
            "minimizing orientation of the 2026-08-01 uncertainty pass"
        ),
        "vector": (
            "x = 1_Z - 1_{Z^q} on the additive group of F_{q^2}, "
            "trace pairing Tr(wz), values in Z[zeta_q]"
        ),
        "inputs": {
            SOURCE.name: sha256(SOURCE.read_bytes()).hexdigest(),
            AUDIT.name: sha256(AUDIT.read_bytes()).hexdigest(),
        },
        "rows": [field_row(q, expected[q]) for q in FIELDS],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
