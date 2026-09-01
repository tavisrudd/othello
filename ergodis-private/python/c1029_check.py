#!/usr/bin/env python3
"""C1029 — independent checker for a `c1029-parametric/1` certificate.

Written against the certificate specification, not against the generator: it shares no code
with `ergodis-private/src/bin/c1029_parametric_cert.rs`, re-derives every quantity, and uses
sympy for the polynomial identities so that they are verified *symbolically* (exact equality of
polynomials in Z[t]) rather than by sampling values.

What the certificate asserts, and what this script therefore checks:

  CLAIM: for every integer n with 2 <= n <= range_hi there are positive integers x, y, z with
         4/n = 1/x + 1/y + 1/z.

  Layer 1 (parametric, infinite).  Each `family` line gives a modulus m, a residue r, a
  threshold tmin, and three polynomials A, B, C in Z[t].  Writing n = m*t + r, the family
  discharges every n in its class with t >= tmin, provided
      (i)   n*(B*C + A*C + A*B) - 4*A*B*C = 0 identically in Z[t]      [symbolic]
      (ii)  A, B, C have non-negative integer coefficients and value >= 1 at t = tmin
            (hence value >= 1 for every t >= tmin, since tmin >= 0)
      (iii) the least integer n >= 2 in the class has t >= tmin.

  Layer 1 covering.  Every residue a mod `cover_modulus` is either covered by a tier-1 family
  whose modulus divides `cover_modulus`, or is listed in `exceptional`.

  Layer 2 (residual, finite).  Every prime p <= range_hi whose residue mod `cover_modulus` is
  exceptional is either covered by some tier-2 family, or appears in the witness file with a
  triple that satisfies the equation exactly.

  Composition.  If n's residue mod `cover_modulus` is non-exceptional, layer 1 solves n itself.
  Otherwise let q be the least prime factor of n; then q <= n <= range_hi, and q is solved by
  layer 1, by a tier-2 family, or by a witness.  A solution for q gives one for n = q*k by
  scaling every denominator by k.  Nothing else is needed, so the two layers compose into the
  claim.  This script verifies the finite conditions above; the scaling lemma is the one
  mathematical step it does not re-derive.

Usage:
    uv run --with sympy --with numpy python3 c1029_check.py <cert.txt> [--witness-dir DIR]
Exit code 0 = accepted, 1 = rejected (with the reasons printed).
"""

from __future__ import annotations

import argparse
import hashlib
import sys
from pathlib import Path

import sympy
from sympy import Poly, Symbol

T = Symbol("t")


class Rejected(Exception):
    pass


REASONS: list[str] = []


def reject(msg: str) -> None:
    REASONS.append(msg)


# ---------------------------------------------------------------------------- parsing


class Fam:
    __slots__ = ("tier", "name", "m", "r", "tmin", "a", "b", "c")

    def __init__(self, tier, name, m, r, tmin, a, b, c):
        self.tier, self.name, self.m, self.r, self.tmin = tier, name, m, r, tmin
        self.a, self.b, self.c = a, b, c


def parse_cert(path: Path) -> dict:
    hdr: dict = {}
    fams: list[Fam] = []
    lines = path.read_text().splitlines()
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        i += 1
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        key = parts[0]
        if key == "family":
            tier = int(parts[1])
            name = parts[2]
            m, r, tmin = int(parts[3]), int(parts[4]), int(parts[5])
            polys = []
            for tag in ("A", "B", "C"):
                row = lines[i].split()
                i += 1
                if row[0] != tag:
                    raise Rejected(f"family {name}: expected row {tag}, got {row[0]!r}")
                polys.append([int(v) for v in row[1:]])
            fams.append(Fam(tier, name, m, r, tmin, *polys))
        elif key == "end":
            break
        else:
            hdr[key] = parts[1:]
    hdr["_families"] = fams
    return hdr


def one(hdr, key, cast=str):
    if key not in hdr or len(hdr[key]) != 1:
        raise Rejected(f"header field {key!r} missing or malformed")
    return cast(hdr[key][0])


# ---------------------------------------------------------------------------- layer 1


def coeffs_to_poly(cs: list[int]) -> Poly:
    # certificate coefficients are low-to-high; sympy wants high-to-low
    if not cs:
        return Poly(0, T, domain="ZZ")
    return Poly(list(reversed(cs)), T, domain="ZZ")


def check_family(f: Fam) -> None:
    tag = f"family {f.name} (tier {f.tier}, {f.m}t+{f.r})"
    if f.m < 1 or not (0 <= f.r < f.m):
        reject(f"{tag}: modulus/residue out of range")
        return
    if f.tmin < 0:
        reject(f"{tag}: tmin < 0 breaks the monotonicity argument for positivity")
        return
    A, B, C = (coeffs_to_poly(f.a), coeffs_to_poly(f.b), coeffs_to_poly(f.c))
    N = Poly([f.m, f.r], T, domain="ZZ")
    # (i) symbolic identity in Z[t]
    lhs = N * (B * C + A * C + A * B) - 4 * (A * B * C)
    if not lhs.is_zero:
        reject(f"{tag}: polynomial identity n*(BC+AC+AB) - 4ABC is not identically zero")
        return
    # (ii) positivity, proved rather than sampled
    for label, cs, P in (("A", f.a, A), ("B", f.b, B), ("C", f.c, C)):
        if any(v < 0 for v in cs):
            reject(f"{tag}: {label} has a negative coefficient; positivity is not established")
            return
        val = P.eval(f.tmin)
        if val < 1:
            reject(f"{tag}: {label}({f.tmin}) = {val} < 1")
            return
    # (iii) every integer n >= 2 in the class is within reach of tmin
    n_min = f.r if f.r >= 2 else f.r + f.m
    if (n_min - f.r) // f.m < f.tmin:
        reject(f"{tag}: least n >= 2 in the class is {n_min}, below tmin = {f.tmin}")


def check_covering(fams: list[Fam], cover_mod: int, exceptional: set[int]) -> None:
    tier1 = [f for f in fams if f.tier == 1 and cover_mod % f.m == 0]
    uncovered = set()
    for a in range(cover_mod):
        if not any(a % f.m == f.r for f in tier1):
            uncovered.add(a)
    extra = uncovered - exceptional
    if extra:
        reject(
            f"covering: residues {sorted(extra)[:12]} mod {cover_mod} are covered by no tier-1 "
            f"family and are not declared exceptional"
        )
    slack = exceptional - uncovered
    if slack:
        print(f"  note: {len(slack)} declared exceptional residues are in fact covered by tier-1 "
              f"({sorted(slack)[:6]}); sound but wasteful")


# ---------------------------------------------------------------------------- layer 2


def sieve_primes(n_max: int):
    """primes <= n_max as a numpy boolean mask over 0..n_max"""
    import numpy as np

    mask = np.ones(n_max + 1, dtype=bool)
    mask[:2] = False
    for p in range(2, int(n_max**0.5) + 1):
        if mask[p]:
            mask[p * p :: p] = False
    return mask


def check_witness(p: int, s: int, d: int) -> str | None:
    """Reconstruct (x, y, z) from (p, s, d) and verify 4/p = 1/x + 1/y + 1/z exactly."""
    if s < 1 or d < 1:
        return "s or d not positive"
    if (p + s) % 4 != 0:
        return f"4 does not divide p+s = {p + s}"
    x = (p + s) // 4
    M = p * x
    if (M + d) % s != 0:
        return "s does not divide M+d"
    y = (M + d) // s
    if (M * M) % d != 0:
        return "d does not divide M^2"
    co = (M * M) // d
    if (M + co) % s != 0:
        return "s does not divide M + M^2/d"
    z = (M + co) // s
    if x < 1 or y < 1 or z < 1:
        return f"non-positive denominator ({x}, {y}, {z})"
    # the actual equation, independent of how (x, y, z) was derived
    if 4 * x * y * z != p * (y * z + x * z + x * y):
        return f"4/{p} != 1/{x} + 1/{y} + 1/{z}"
    return None


# ---------------------------------------------------------------------------- driver


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cert", type=Path)
    ap.add_argument("--witness-dir", type=Path, default=None)
    ap.add_argument("--expect", choices=["accept", "reject"], default="accept")
    args = ap.parse_args()

    try:
        hdr = parse_cert(args.cert)
    except Rejected as e:
        reject(str(e))
        hdr = None
    except Exception as e:  # malformed certificate is a rejection, not a crash
        reject(f"parse error: {e}")
        hdr = None

    if hdr is not None:
        try:
            if one(hdr, "format") != "c1029-parametric/1":
                reject("unknown certificate format")
            range_lo = one(hdr, "range_lo", int)
            range_hi = one(hdr, "range_hi", int)
            cover_mod = one(hdr, "cover_modulus", int)
            exceptional = {int(v) for v in hdr["exceptional"]}
            wit_name = one(hdr, "witness_file")
            wit_sha = one(hdr, "witness_sha256")
            wit_count = one(hdr, "witness_count", int)
            fams: list[Fam] = hdr["_families"]

            if range_lo != 2:
                reject(f"claim starts at {range_lo}, not 2")
            if range_hi < 2 or cover_mod < 1:
                reject("range_hi or cover_modulus out of range")
            if any(not (0 <= e < cover_mod) for e in exceptional):
                reject("exceptional residue outside [0, cover_modulus)")
            if len(fams) != one(hdr, "tier1_families", int) + one(hdr, "tier2_families", int):
                reject("declared family counts do not match the family rows")

            print(f"[1] {len(fams)} identity families, symbolic check in Z[t]")
            for f in fams:
                check_family(f)

            print(f"[2] covering of Z/{cover_mod}")
            check_covering(fams, cover_mod, exceptional)

            wdir = args.witness_dir or args.cert.parent
            wpath = wdir / wit_name
            print(f"[3] witness file {wpath.name}")
            if not wpath.exists():
                reject(f"witness file {wpath} not found")
            else:
                raw = wpath.read_bytes()
                got = hashlib.sha256(raw).hexdigest()
                if got != wit_sha:
                    reject(f"witness sha256 {got} != declared {wit_sha}")
                wits: dict[int, tuple[int, int]] = {}
                bad = 0
                for ln, line in enumerate(raw.decode().splitlines(), 1):
                    if not line.strip():
                        continue
                    try:
                        p, s, d = (int(v) for v in line.split())
                    except ValueError:
                        reject(f"witness line {ln}: malformed")
                        bad += 1
                        continue
                    if p in wits:
                        reject(f"witness line {ln}: duplicate entry for p = {p}")
                    wits[p] = (s, d)
                    err = check_witness(p, s, d)
                    if err is not None:
                        bad += 1
                        if bad <= 5:
                            reject(f"witness line {ln} (p = {p}): {err}")
                if bad > 5:
                    reject(f"... and {bad - 5} further bad witnesses")
                if len(wits) != wit_count:
                    reject(f"witness_count {wit_count} != {len(wits)} entries read")

                print(f"[4] completeness of the residual layer up to {range_hi}")
                mask = sieve_primes(range_hi)
                tier2 = [(f.m, f.r) for f in fams if f.tier == 2]
                missing = []
                n_resid = 0
                import numpy as np

                idx = np.flatnonzero(mask)
                resid = idx[np.isin(idx % cover_mod, np.array(sorted(exceptional)))]
                n_resid = int(resid.size)
                witset = set(wits)
                for p in resid.tolist():
                    if p in witset:
                        continue
                    if any(p % m == r for (m, r) in tier2):
                        continue
                    missing.append(p)
                    if len(missing) > 8:
                        break
                if missing:
                    reject(
                        f"completeness: {len(missing)}+ primes in exceptional classes have "
                        f"neither a tier-2 family nor a witness, e.g. {missing[:8]}"
                    )
                stray = [p for p in witset if p > range_hi or not mask[p]]
                if stray:
                    reject(f"witness list contains non-primes or out-of-range entries: {stray[:8]}")
                print(
                    f"    residual primes {n_resid}, absorbed by tier-2 {n_resid - len(wits)}, "
                    f"witnesses {len(wits)}"
                )
        except Rejected as e:
            reject(str(e))
        except Exception as e:
            reject(f"checker aborted: {type(e).__name__}: {e}")

    if REASONS:
        print("\nREJECTED:")
        for r in REASONS:
            print(f"  - {r}")
        verdict = "reject"
    else:
        print("\nACCEPTED: the certificate establishes its claim.")
        verdict = "accept"

    if verdict != args.expect:
        print(f"\n!! expected {args.expect}, got {verdict}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
