#!/usr/bin/env python3
"""Independent replay of the characteristic-seven pointed locator certificates.

This file shares no code with the projective Reed--Solomon toolkit and none
with the generator that produced the certificate.  It rebuilds the field from
the certificate's own ``field`` block, rebuilds every locator from its recorded
root set, and re-derives every equation the pointed statement needs.

Conventions, all taken from the public certificate schema and reproduced here
independently:

* ``polynomial-basis-base-p-integer-v1``: a field element is the base-``p``
  radix encoding of its polynomial-basis coordinates, least significant digit
  first, so the integer ``sum_i a_i p^i`` denotes ``sum_i a_i x^i`` in
  ``F_p[x]/(m)``.  The modulus list is ascending and monic: ``modulus[k]`` is
  the coefficient of ``x^k`` and ``modulus[degree] = 1``.
* A locator is a coefficient list in ascending order, ``locator[k]`` being the
  coefficient of ``x^k``, of length ``|support| + 1``.  It is normalized
  projectively by scaling its lowest nonzero coefficient to one, so it is a
  scalar multiple of the monic root polynomial, not literally monic.  A root at
  infinity is recorded as a support entry ``"infinity"`` and shows up as a zero
  top coefficient, i.e. as a drop in degree.
* The R11 Hankel criterion: for a redundancy-``r`` syndrome ``z`` and a locator
  ``g`` of formal degree ``d``, the ``r - d`` consecutive-window contractions
  ``sum_{k=0}^{d} z_{i+k} g_k = 0``, ``i = 0, ..., r-d-1``, must vanish.  With
  ``d = r - 2`` these are exactly the two consecutive Hankel equations of the
  pointed statement.  This is the same convention as the independent GF(16)
  replay in ``supplement/evidence/r11-binary-quotients``, whose contraction
  ``sum_j z_j g_{j-level}`` is this sum re-indexed by ``j = i + k``.

Additional checks beyond the Hankel system, all recomputed from scratch:

* the syndrome is supported exactly on the recorded carrier coordinates;
* the carrier is stable under the degree-``(r-1)`` divided-power translation
  action, by the Lucas vanishing ``binom(i,j) = 0 mod p`` above the carrier;
* the recorded root set is exactly the zero set of the recorded locator in the
  field, with the recorded multiplicity-free count;
* the recorded forbidden projective root is absent from the support;
* the recorded magnitudes reconstruct the syndrome on the recorded support.

What this does NOT certify: the ``distance`` field is the toolkit's exact
minimum-distance claim, which rests on its increasing-degree search order.  The
replay only re-establishes the displayed witness, i.e. the upper bound.

Usage:  python3 2026-08-28-r11-char7-pointed-orbits-replay.py [certificate.json]
"""

from __future__ import annotations

import hashlib
import json
import sys
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
DEFAULT_CERTIFICATE = HERE / "2026-08-28-r11-char7-pointed-orbits.json"
SCHEMA = "c973-char7-pointed-orbits-v1"
CERTIFICATE_SCHEMA = "projective-reed-solomon-locator-certificate-v1"
ENCODING = "polynomial-basis-base-p-integer-v1"


class Failure(SystemExit):
    pass


def fail(message: str) -> None:
    raise Failure(f"char7 replay: {message}")


# ---------------------------------------------------------------------------
# finite field, rebuilt from the certificate's own field block
# ---------------------------------------------------------------------------


class Field:
    def __init__(self, spec: dict) -> None:
        if spec.get("encoding") != ENCODING:
            fail(f"unsupported element encoding {spec.get('encoding')!r}")
        p = spec["p"]
        degree = spec["degree"]
        modulus = list(spec["modulus"])
        if p < 2 or any(p % divisor == 0 for divisor in range(2, p)):
            fail(f"characteristic {p} is not prime")
        if degree < 1:
            fail("field degree must be positive")
        if len(modulus) != degree + 1 or modulus[degree] != 1:
            fail("modulus must be ascending, monic, and of length degree+1")
        if any(not 0 <= coefficient < p for coefficient in modulus):
            fail("modulus coefficients must lie in F_p")
        self.p = p
        self.degree = degree
        self.modulus = modulus
        self.order = p**degree

    # element <-> polynomial coordinates ------------------------------------

    def digits(self, value: int) -> list[int]:
        if not 0 <= value < self.order:
            fail(f"{value} is not an element of the field")
        out = []
        for _ in range(self.degree):
            out.append(value % self.p)
            value //= self.p
        return out

    def undigits(self, coordinates) -> int:
        value = 0
        for index in reversed(range(self.degree)):
            value = value * self.p + coordinates[index] % self.p
        return value

    # arithmetic -------------------------------------------------------------

    def add(self, left: int, right: int) -> int:
        a = self.digits(left)
        b = self.digits(right)
        return self.undigits([(a[i] + b[i]) % self.p for i in range(self.degree)])

    def neg(self, value: int) -> int:
        return self.undigits([(-digit) % self.p for digit in self.digits(value)])

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def mul(self, left: int, right: int) -> int:
        a = self.digits(left)
        b = self.digits(right)
        degree = self.degree
        product = [0] * (2 * degree - 1)
        for i in range(degree):
            if a[i] == 0:
                continue
            for j in range(degree):
                product[i + j] = (product[i + j] + a[i] * b[j]) % self.p
        # x^degree = -(modulus[0] + ... + modulus[degree-1] x^(degree-1))
        for position in reversed(range(degree, len(product))):
            lead = product[position]
            if lead == 0:
                continue
            product[position] = 0
            for j in range(degree):
                product[position - degree + j] = (
                    product[position - degree + j] - lead * self.modulus[j]
                ) % self.p
        return self.undigits(product[:degree])

    def power(self, base: int, exponent: int) -> int:
        out = 1
        while exponent > 0:
            if exponent & 1:
                out = self.mul(out, base)
            base = self.mul(base, base)
            exponent >>= 1
        return out

    def evaluate(self, coefficients, point: int) -> int:
        """Horner on an ascending coefficient list."""
        out = 0
        for coefficient in reversed(coefficients):
            out = self.add(self.mul(out, point), coefficient)
        return out

    # validation -------------------------------------------------------------

    def assert_is_a_field(self) -> None:
        """Exhaustive inverse search: reducible moduli fail here, not later."""
        for value in range(1, self.order):
            if not any(self.mul(value, other) == 1 for other in range(1, self.order)):
                fail(f"the modulus is reducible: {value} has no inverse")
        if self.mul(1, 1) != 1 or self.add(0, 0) != 0:
            fail("field units are wrong")


# ---------------------------------------------------------------------------
# projective roots
# ---------------------------------------------------------------------------


INFINITY = "infinity"


def parse_root(entry, field: Field):
    """Return ``INFINITY`` or a finite field element."""
    if entry == INFINITY:
        return INFINITY
    if isinstance(entry, dict) and set(entry) == {"finite"}:
        value = entry["finite"]
        if not isinstance(value, int) or not 0 <= value < field.order:
            fail(f"finite root {value!r} is outside the field")
        return value
    fail(f"unrecognized projective root {entry!r}")


def root_polynomial(roots, field: Field, length: int) -> list[int]:
    """Ascending monic product of (x - s) over the finite roots, zero padded."""
    coefficients = [1]
    for root in roots:
        if root is INFINITY:
            continue
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] = field.sub(extended[index], field.mul(root, coefficient))
            extended[index + 1] = field.add(extended[index + 1], coefficient)
        coefficients = extended
    if len(coefficients) > length:
        fail("more finite roots than the locator can carry")
    return coefficients + [0] * (length - len(coefficients))


# ---------------------------------------------------------------------------
# structural checks
# ---------------------------------------------------------------------------


def carrier_is_translation_stable(carrier, syndrome_degree: int, p: int) -> bool:
    """Lucas vanishing above the carrier for e_j -> sum_i binom(i,j) a^(i-j) e_i."""
    return all(
        comb(target, source) % p == 0
        for source in carrier
        for target in range(max(carrier) + 1, syndrome_degree + 1)
    )


def check_record(record: dict, field: Field, field_spec: dict) -> dict:
    orbit = record["orbit"]
    certificate = record["certificate"]
    if certificate.get("schema") != CERTIFICATE_SCHEMA:
        fail(f"{orbit}: unexpected nested certificate schema")
    if certificate.get("field") != field_spec:
        fail(f"{orbit}: nested certificate uses a different field")

    redundancy = record["redundancy"]
    if certificate.get("redundancy") != redundancy:
        fail(f"{orbit}: nested redundancy disagrees")
    syndrome = certificate["normalized_syndrome"]
    if len(syndrome) != redundancy:
        fail(f"{orbit}: syndrome length is not the redundancy")
    for value in syndrome:
        field.digits(value)
    if all(value == 0 for value in syndrome):
        fail(f"{orbit}: zero syndrome")

    # 1. the syndrome sits exactly on the recorded carrier coordinates.
    carrier = list(record["carrier_indices"])
    coefficients = list(record["carrier_coefficients"])
    if len(carrier) != len(coefficients) or len(set(carrier)) != len(carrier):
        fail(f"{orbit}: malformed carrier description")
    expected = [0] * redundancy
    for index, coefficient in zip(carrier, coefficients):
        if not 0 <= index < redundancy:
            fail(f"{orbit}: carrier index {index} is out of range")
        expected[index] = coefficient
    if syndrome != expected:
        fail(f"{orbit}: syndrome is not supported on the recorded carrier")

    # 2. the carrier is stable under the divided-power translation action.
    if not carrier_is_translation_stable(carrier, redundancy - 1, field.p):
        fail(f"{orbit}: carrier is not translation stable in degree {redundancy - 1}")

    # 3. support: distinct projective roots, at most one at infinity.
    support = [parse_root(entry, field) for entry in certificate["support"]]
    if record["support"] != certificate["support"]:
        fail(f"{orbit}: outer and nested supports differ")
    if len(support) != len(set(map(repr, support))):
        fail(f"{orbit}: repeated root in the support")
    if sum(1 for root in support if root is INFINITY) > 1:
        fail(f"{orbit}: more than one root at infinity")
    if certificate["distance"] != len(support):
        fail(f"{orbit}: recorded distance is not the support size")

    # 4. the locator is the projectively normalized root polynomial.
    locator = certificate["locator"]
    if len(locator) != len(support) + 1:
        fail(f"{orbit}: locator length is not |support| + 1")
    for value in locator:
        field.digits(value)
    rebuilt = root_polynomial(support, field, len(locator))
    pivot = next((k for k, value in enumerate(rebuilt) if value), None)
    if pivot is None:
        fail(f"{orbit}: rebuilt locator is zero")
    if locator[pivot] == 0:
        fail(f"{orbit}: locator normalization disagrees with the root set")
    scale = field.mul(locator[pivot], field.power(rebuilt[pivot], field.order - 2))
    if any(
        locator[k] != field.mul(scale, rebuilt[k]) for k in range(len(locator))
    ):
        fail(f"{orbit}: locator is not a scalar multiple of the root polynomial")
    if next(value for value in locator if value) != 1:
        fail(f"{orbit}: locator is not projectively normalized")

    # 5. root set, recomputed by exhaustive evaluation over the whole field.
    finite_support = sorted(root for root in support if root is not INFINITY)
    zeros = sorted(x for x in range(field.order) if field.evaluate(locator, x) == 0)
    if zeros != finite_support:
        fail(f"{orbit}: the locator's zero set is not the recorded finite support")
    formal_degree = max(k for k, value in enumerate(locator) if value)
    if formal_degree != len(finite_support):
        fail(f"{orbit}: locator degree does not match the finite root count")
    if (INFINITY in support) != (formal_degree < len(support)):
        fail(f"{orbit}: infinity bookkeeping disagrees with the locator degree")

    # 6. the pointed condition: the forbidden projective root is avoided.
    forbidden = [parse_root(entry, field) for entry in record["forbidden"]]
    if len(forbidden) != 1:
        fail(f"{orbit}: expected exactly one typed forbidden root")
    if forbidden[0] in support:
        fail(f"{orbit}: the support contains the forbidden root")
    if forbidden[0] is not INFINITY and field.evaluate(locator, forbidden[0]) == 0:
        fail(f"{orbit}: the locator vanishes at the forbidden root")

    # 7. the Hankel-kernel equations.
    windows = redundancy - (len(locator) - 1)
    if windows < 1:
        fail(f"{orbit}: locator degree leaves no Hankel window")
    for start in range(windows):
        total = 0
        for k, coefficient in enumerate(locator):
            total = field.add(total, field.mul(syndrome[start + k], coefficient))
        if total != 0:
            fail(f"{orbit}: Hankel equation {start} evaluates to {total}")

    # 8. the magnitudes reconstruct the syndrome on the recorded support.
    magnitudes = certificate["magnitudes"]
    if len(magnitudes) != len(support):
        fail(f"{orbit}: magnitude count is not the support size")
    if any(value == 0 for value in magnitudes):
        fail(f"{orbit}: a magnitude vanishes")
    for row in range(redundancy):
        total = 0
        for magnitude, root in zip(magnitudes, support):
            column = (
                1 if row + 1 == redundancy else 0
                if root is INFINITY
                else field.power(root, row)
            )
            total = field.add(total, field.mul(magnitude, column))
        if total != syndrome[row]:
            fail(f"{orbit}: magnitude reconstruction fails in coordinate {row}")

    # 9. the recorded locator digest.
    digest = hashlib.sha256(
        json.dumps(locator, separators=(",", ":")).encode()
    ).hexdigest()
    if digest != record["locator_sha256"]:
        fail(f"{orbit}: recorded locator digest is stale")

    return {
        "orbit": orbit,
        "redundancy": redundancy,
        "degree": formal_degree,
        "windows": windows,
    }


def main() -> int:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_CERTIFICATE
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema") != SCHEMA:
        fail(f"unexpected schema {data.get('schema')!r}")
    field_spec = data["field"]
    field = Field(field_spec)
    field.assert_is_a_field()

    records = data["records"]
    if data["orbit_count"] != len(records):
        fail("declared orbit count disagrees with the record list")
    if data.get("all_verified") is not True:
        fail("the certificate does not claim a complete verification")

    summaries = [check_record(record, field, field_spec) for record in records]

    if max(record["candidates_examined"] for record in records) != data[
        "max_candidates_examined"
    ]:
        fail("declared maximum candidate count disagrees")
    if any(
        record["candidates_examined"] > data["candidate_limit"] for record in records
    ):
        fail("a recorded search exceeded the declared candidate limit")

    orbits = [summary["orbit"] for summary in summaries]
    if len(set(orbits)) != len(orbits):
        fail("duplicate orbit name")
    levels: dict[int, int] = {}
    for summary in summaries:
        levels[summary["redundancy"]] = levels.get(summary["redundancy"], 0) + 1
        if summary["windows"] != 2:
            fail(f"{summary['orbit']}: expected two Hankel windows")

    print(
        "independent characteristic-seven pointed replay: PASS "
        f"({len(summaries)} orbits over GF({field.order}), "
        f"redundancy histogram {dict(sorted(levels.items()))}, "
        "two Hankel windows each, every locator rebuilt from its root set)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
