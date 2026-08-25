#!/usr/bin/env python3
"""CRT and rationally reconstruct generic C958 coefficient certificates."""

import argparse
import copy
import json
import math
from pathlib import Path


def crt(residue, modulus, next_residue, next_prime):
    return residue + modulus * ((next_residue - residue) * pow(modulus, -1, next_prime) % next_prime)


def rational_reconstruct(residue, modulus):
    bound = math.isqrt(modulus // 2)
    r0, r1 = modulus, residue % modulus
    s0, s1 = 0, 1
    while r1 > bound:
        quotient = r0 // r1
        r0, r1 = r1, r0 - quotient * r1
        s0, s1 = s1, s0 - quotient * s1
    if s1 == 0 or abs(s1) > bound or math.gcd(r1, s1) != 1:
        return None
    if (r1 - residue * s1) % modulus:
        return None
    if s1 < 0:
        r1, s1 = -r1, -s1
    return r1, s1


def dense(terms, bounds):
    values = {(term["parameter_exponents"][0], term["parameter_exponents"][1]):
              int(term["coefficient"]) for term in terms}
    return [values.get((i, j), 0)
            for i in range(bounds[0] + 1) for j in range(bounds[1] + 1)]


def sparse(values, bounds):
    answer = []
    for (i, j), value in zip(
            ((i, j) for i in range(bounds[0] + 1) for j in range(bounds[1] + 1)), values):
        if value != (0, 1):
            numerator, denominator = value
            answer.append({
                "coefficient": str(numerator) if denominator == 1
                else f"{numerator}/{denominator}",
                "parameter_exponents": [i, j],
            })
    return answer


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificates", type=Path, nargs="+")
    parser.add_argument("--write", type=Path)
    arguments = parser.parse_args()
    certificates = [json.loads(path.read_text()) for path in arguments.certificates]
    assert len(certificates) >= 2
    assert all(item["schema"] == "c958-generic-rational-inverse-modular-v1"
               for item in certificates)
    primes = [item["prime"] for item in certificates]
    output = copy.deepcopy(certificates[0])
    output["schema"] = "c958-generic-rational-inverse-v1"
    output["reconstruction_primes"] = primes
    output.pop("prime")
    unresolved = []
    reconstructed_count = 0
    maximum_numerator = 0
    maximum_denominator = 0

    for target in range(4):
        for position, coefficient in enumerate(output["vectors"][target]):
            peers = [item["vectors"][target][position] for item in certificates]
            assert all(peer["inverse_vector_index"] == coefficient["inverse_vector_index"]
                       and peer["numerator_degree_bounds"] == coefficient["numerator_degree_bounds"]
                       and peer["denominator_degree_bounds"] == coefficient["denominator_degree_bounds"]
                       for peer in peers)
            for key, bounds_key in (("numerator", "numerator_degree_bounds"),
                                    ("denominator", "denominator_degree_bounds")):
                bounds = coefficient[bounds_key]
                dense_values = [dense(peer[key], bounds) for peer in peers]
                rational_values = []
                for term_index, residues in enumerate(zip(*dense_values)):
                    value = residues[0]
                    modulus = primes[0]
                    for next_value, next_prime in zip(residues[1:], primes[1:]):
                        value = crt(value, modulus, next_value, next_prime)
                        modulus *= next_prime
                    rational = rational_reconstruct(value, modulus)
                    if rational is None:
                        unresolved.append((target, coefficient["inverse_vector_index"],
                                           key, term_index))
                        rational = (0, 1)
                    else:
                        reconstructed_count += 1
                        maximum_numerator = max(maximum_numerator, abs(rational[0]))
                        maximum_denominator = max(maximum_denominator, rational[1])
                    rational_values.append(rational)
                coefficient[key] = sparse(rational_values, bounds)
    output["crt_reconstruction"] = {
        "reconstructed_dense_coefficients": reconstructed_count,
        "unresolved_dense_coefficients": len(unresolved),
        "maximum_absolute_numerator": maximum_numerator,
        "maximum_denominator": maximum_denominator,
    }
    print(json.dumps(output["crt_reconstruction"], sort_keys=True))
    print("unresolved_first", unresolved[:20])
    if arguments.write and not unresolved:
        arguments.write.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
