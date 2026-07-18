#!/usr/bin/env python3
"""C290 checker: closed polyhedral congruence laws vs the committed C288 census.

Verifies, against notes/2026-07-17-c288-polyhedral-embedding-census.json:
  1. the proved split-indicator congruence laws (Theorems B and C of the C290 report);
  2. the orbit-equation divisibility and the free-orbit-count parity law (Theorem D);
  3. the ten closed full-board value laws obtained by substituting the C284 template
     nimbers into the orbit formula (Theorem E), including the quadratic-character forms;
  4. the exact minimal modulus of each law over the admissible residue classes; and
  5. the residue-class balance counts behind the prime-density corollaries.

Pure stdlib, deterministic, no randomness/timestamps/host paths. Canonical JSON
(sorted keys) on stdout; asserts abort on any mismatch; "ALL CHECKS PASSED" on stderr.

Usage (from the repo root):
  python3 notes/2026-07-17-c290-polyhedral-congruence-laws.py \
      > notes/2026-07-17-c290-polyhedral-congruence-laws.json
"""

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CENSUS_PATH = HERE / "2026-07-17-c288-polyhedral-embedding-census.json"


# ----------------------------------------------------------------------------
# Split-indicator laws (proved in the C290 report from PGL2(q) group theory).
# ----------------------------------------------------------------------------

def ind_m2(q):  # [-2 is a square in F_q]  <=>  q = 1,3 (mod 8)
    return 1 if q % 8 in (1, 3) else 0


def ind_2ns(q):  # [2 is a nonsquare in F_q]  <=>  q = 3,5 (mod 8)
    return 1 if q % 8 in (3, 5) else 0


def eps_s4(q):
    return {
        "e2a": ind_m2(q),                 # transpositions split
        "e2b": 1 if q % 4 == 1 else 0,    # double transpositions split
        "e3": 1 if q % 3 == 1 else 0,     # C3 split
        "e4": 1 if q % 4 == 1 else 0,     # C4 split
    }


def eps_a5(q):
    return {
        "e2": 1 if q % 4 == 1 else 0,
        "e3": 1 if q % 3 == 1 else 0,
        "e5": 1 if q % 5 == 1 else 0,
    }


# ----------------------------------------------------------------------------
# Orbit equations and free-orbit parities (Theorem D).
# ----------------------------------------------------------------------------

def m1_s4(q):
    e = eps_s4(q)
    num = q + 1 - 12 * e["e2a"] - 8 * e["e3"] - 6 * e["e4"]
    assert num % 24 == 0, (q, num)
    m1 = num // 24
    assert m1 >= 0
    return m1


def m1_a5(q):
    e = eps_a5(q)
    num = q + 1 - 30 * e["e2"] - 20 * e["e3"] - 12 * e["e5"]
    assert num % 60 == 0, (q, num)
    m1 = num // 60
    assert m1 >= 0
    return m1


def m1_a5_parity_law(q):
    """m1 = [chi(6) = -1] + [q = 1 (mod 5)]  (mod 2)."""
    e = eps_a5(q)
    chi6_nonsquare = ind_m2(q) ^ e["e3"]  # [-2 sq] xor [-3 sq] = [6 nonsquare]
    return chi6_nonsquare ^ e["e5"]


# ----------------------------------------------------------------------------
# Closed full-board value laws (Theorem E): functions of q alone.
# ----------------------------------------------------------------------------

def board_laws_s4(q):
    e = eps_s4(q)
    v233 = 2 * (e["e2a"] ^ e["e4"])
    assert v233 == 2 * ind_2ns(q)  # character form: 2*[2 nonsquare]
    return {
        "(2,3,3);4": v233,
        "(2,3,4);3": e["e2a"],
        "(3,3,3);4": e["e2a"],
        "(3,4,4);3": e["e2a"],
    }


def board_laws_a5(q):
    e = eps_a5(q)
    m1p = m1_a5_parity_law(q)
    chi6_ns = ind_m2(q) ^ e["e3"]
    v255 = e["e5"] ^ m1p
    assert v255 == chi6_ns  # character form: [6 nonsquare]
    return {
        "(2,3,5);5": m1p,
        "(2,5,5);3": v255,
        "(3,3,5);3": 0,
        "(3,5,5);3": e["e3"] ^ e["e5"],
        "(3,5,5);5": 0,
        "(5,5,5);5": e["e2"],
    }


def class_key(pair_orders, rho):
    return "(%d,%d,%d);%d" % (pair_orders[0], pair_orders[1], pair_orders[2], rho)


# ----------------------------------------------------------------------------
# Check 1: census comparison (every embedding, every refined class).
# ----------------------------------------------------------------------------

def check_census(census):
    n_emb = n_eps = n_m1 = n_val = n_direct = 0
    for row in census:
        g, q = row["group"], row["q"]
        laws = board_laws_s4(q) if g == "S4" else board_laws_a5(q)
        eps_pred = eps_s4(q) if g == "S4" else eps_a5(q)
        eps_got = dict(row["eps"])
        for k, v in eps_got.items():
            assert eps_pred[k] == v, (g, q, k, eps_pred[k], v)
            n_eps += 1
        m1_pred = m1_s4(q) if g == "S4" else m1_a5(q)
        assert m1_pred == row["m1"], (g, q, m1_pred, row["m1"])
        if g == "A5":
            assert m1_a5_parity_law(q) == row["m1"] % 2, (g, q)
        # independent orbit-sum identity: census orbits partition P^1(F_q)
        assert sum(s for s, _ in row["orbit_size_stab"]) == q + 1, (g, q)
        n_m1 += 1
        for cl in row["classes"]:
            key = class_key(cl["pair_orders"], cl["rho"])
            pred = laws[key]
            assert pred == cl["board_value"], (g, q, key, pred, cl["board_value"])
            n_val += 1
            if cl.get("board_direct") is not None:
                assert pred == cl["board_direct"], (g, q, key)
                n_direct += 1
        n_emb += 1
    return {
        "embeddings": n_emb,
        "eps_comparisons": n_eps,
        "m1_comparisons": n_m1,
        "class_value_comparisons": n_val,
        "class_direct_comparisons": n_direct,
    }


# ----------------------------------------------------------------------------
# Check 2: quadratic-character forms on primes (Euler's criterion), 5 <= p < 10000.
# ----------------------------------------------------------------------------

def primes_below(n):
    sieve = bytearray([1]) * n
    sieve[0:2] = b"\x00\x00"
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
    return [i for i in range(n) if sieve[i]]


def check_characters(bound=10000):
    n = 0
    for p in primes_below(bound):
        if p < 5:
            continue

        def sq(a):
            return pow(a % p, (p - 1) // 2, p) == 1

        assert sq(-1) == (p % 4 == 1)
        assert sq(2) == (p % 8 in (1, 7))
        assert sq(-2) == (p % 8 in (1, 3))
        if p % 3 != 0:
            assert sq(-3) == (p % 3 == 1)
        if p % 5 != 0:
            assert sq(5) == (p % 5 in (1, 4))
            assert sq(6) == (not (ind_m2(p) ^ (1 if p % 3 == 1 else 0)))
        n += 1
    return {"primes_checked": n, "bound": bound}


# ----------------------------------------------------------------------------
# Check 3: orbit-equation divisibility + parity laws over all admissible
# residues, swept over integers (arithmetic identities, not only prime powers).
# ----------------------------------------------------------------------------

def check_parity_sweep(lo=5, hi=6000):
    n_s4 = n_a5 = 0
    s4_par = {}   # q mod 48 -> m1 parity (must be well defined)
    for q in range(lo, hi):
        if q % 2 == 0 or q % 3 == 0:
            continue
        m = m1_s4(q)   # asserts 24-divisibility
        r = q % 48
        assert s4_par.setdefault(r, m % 2) == m % 2, (q, r)
        n_s4 += 1
        if q % 5 in (1, 4):
            m5 = m1_a5(q)  # asserts 60-divisibility
            assert m5 % 2 == m1_a5_parity_law(q), (q, m5)
            n_a5 += 1
    s4_odd = sorted(r for r, v in s4_par.items() if v == 1)
    return {
        "range": [lo, hi],
        "s4_orbit_eq_checked": n_s4,
        "a5_orbit_eq_and_parity_checked": n_a5,
        "s4_m1_odd_classes_mod_48": s4_odd,
    }


# ----------------------------------------------------------------------------
# Check 4: minimal moduli and residue-class balance (density corollaries).
# ----------------------------------------------------------------------------

def divisors(n):
    return [d for d in range(1, n + 1) if n % d == 0]


def minimal_modulus(law, modulus, admissible):
    """Smallest divisor d of `modulus` such that the law factors through q mod d
    on the admissible residues; asserts the law does factor through `modulus`."""
    vals = {r: law(r) for r in admissible}
    best = None
    for d in divisors(modulus):
        classes = {}
        ok = True
        for r in admissible:
            key = r % d
            if classes.setdefault(key, vals[r]) != vals[r]:
                ok = False
                break
        if ok:
            best = d
            break
    assert best is not None
    return best


def check_moduli_and_balance():
    # S4: laws are functions of q mod 8; admissible odd residues mod 8.
    adm8 = [r for r in range(8) if r % 2 == 1]
    s4 = {}
    for key in ("(2,3,3);4", "(2,3,4);3", "(3,3,3);4", "(3,4,4);3"):
        law = lambda r, k=key: board_laws_s4(r)[k]
        mod = minimal_modulus(law, 8, adm8)
        dist = {}
        for r in adm8:
            dist[str(law(r))] = dist.get(str(law(r)), 0) + 1
        s4[key] = {"minimal_modulus": mod, "value_counts_mod_8": dist}
    assert s4["(2,3,3);4"]["minimal_modulus"] == 8
    assert s4["(2,3,3);4"]["value_counts_mod_8"] == {"0": 2, "2": 2}
    for key in ("(2,3,4);3", "(3,3,3);4", "(3,4,4);3"):
        assert s4[key]["minimal_modulus"] == 8
        assert s4[key]["value_counts_mod_8"] == {"0": 2, "1": 2}

    # A5: laws are functions of q mod 120; admissible residues are the units
    # mod 120 with r = +-1 (mod 5) (tame + embedding existence).
    adm120 = [r for r in range(120)
              if r % 2 == 1 and r % 3 != 0 and r % 5 in (1, 4)]
    assert len(adm120) == 16
    a5 = {}
    expected_mod = {
        "(2,3,5);5": 120, "(2,5,5);3": 24, "(3,3,5);3": 1,
        "(3,5,5);3": 15, "(3,5,5);5": 1, "(5,5,5);5": 4,
    }
    for key, exp in expected_mod.items():
        law = lambda r, k=key: board_laws_a5(r)[k]
        mod = minimal_modulus(law, 120, adm120)
        assert mod == exp, (key, mod, exp)
        dist = {}
        for r in adm120:
            dist[str(law(r))] = dist.get(str(law(r)), 0) + 1
        if key in ("(3,3,5);3", "(3,5,5);5"):
            assert dist == {"0": 16}, (key, dist)
        else:
            assert dist == {"0": 8, "1": 8}, (key, dist)
        a5[key] = {"minimal_modulus": mod, "value_counts_mod_120": dist}

    # A5 free-orbit parity: function of q mod 120, minimal modulus 120,
    # balanced (8 odd / 8 even admissible classes).
    par_mod = minimal_modulus(m1_a5_parity_law, 120, adm120)
    assert par_mod == 120
    par_dist = {}
    for r in adm120:
        v = str(m1_a5_parity_law(r))
        par_dist[v] = par_dist.get(v, 0) + 1
    assert par_dist == {"0": 8, "1": 8}
    return {
        "S4": s4,
        "A5": a5,
        "A5_m1_parity": {"minimal_modulus": par_mod,
                         "value_counts_mod_120": par_dist},
        "admissible_classes_mod_120_A5": adm120,
    }


def main():
    census = json.loads(CENSUS_PATH.read_text())["census"]
    out = {
        "schema": "c290-congruence-law-check-v1",
        "census_file": CENSUS_PATH.name,
        "census_comparison": check_census(census),
        "character_forms_on_primes": check_characters(),
        "parity_sweep": check_parity_sweep(),
        "moduli_and_balance": check_moduli_and_balance(),
    }
    json.dump(out, sys.stdout, sort_keys=True, indent=1)
    sys.stdout.write("\n")
    print("ALL CHECKS PASSED", file=sys.stderr)


if __name__ == "__main__":
    main()
