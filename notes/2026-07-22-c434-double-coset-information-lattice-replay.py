#!/usr/bin/env python3
r"""Independent replay for C434 (portable K\G/H recovery information lattice).

Shares only the frozen geometric constructors from the C406 module
(conic_parameterization, full_pgl, coxeter_group, h3_group -- which return group elements as
permutation tuples).  All double-coset / orbit / fibre / K-selection logic is reimplemented here
with independent permutation code (union-find orbits, independent double-coset sweep, independent
canonical-J selection).  It reconstructs the load-bearing quantities for B3 (q=7) and H3 (q=11)
and asserts they equal the tracked primary certificate.
"""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
PRIMARY_JSON = HERE / "2026-07-22-c434-double-coset-information-lattice.json"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"

CASES = (("B3", 7), ("H3", 11))


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c434_replay_c406", C406_PATH)


# --- independent permutation utilities ------------------------------------------------------

def mul(p, q):
    return tuple(p[q[i]] for i in range(len(p)))


def inv(p):
    out = [0] * len(p)
    for i, v in enumerate(p):
        out[v] = i
    return tuple(out)


def order(p):
    n = 1
    cur = p
    identity = tuple(range(len(p)))
    while cur != identity:
        cur = mul(p, cur)
        n += 1
    return n


def apply_to_matching(p, matching):
    return tuple(sorted(tuple(sorted((p[a], p[b]))) for a, b in matching))


def edges(matching):
    return frozenset(tuple(sorted(e)) for e in matching)


def union_find_orbits(actions, objects):
    """Independent orbit computation via union-find over each group element's action."""
    n = len(objects)
    idx = {v: i for i, v in enumerate(objects)}
    parent = list(range(n))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[max(ra, rb)] = min(ra, rb)

    for g in actions:
        for i, obj in enumerate(objects):
            union(i, idx[apply_to_matching(g, obj)])
    groups = {}
    for i in range(n):
        groups.setdefault(find(i), set()).add(i)
    return sorted((frozenset(s) for s in groups.values()), key=lambda s: (min(s), len(s)))


def main():
    primary = json.loads(PRIMARY_JSON.read_text())
    primary_cases = {c["type"]: c for c in primary["cases"]}
    scout = json.loads(SCOUT_PATH.read_text())

    for name, prime in CASES:
        record = next(r for r in scout["types"] if r["type"] == name)
        conic, parameters = C406.C399.conic_parameterization(prime)
        full_group, psl_group = C406.full_pgl(prime, parameters)
        parent = C406.h3_group(prime, conic) if name == "H3" else C406.coxeter_group(name, prime, conic)
        base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])

        omega = sorted({apply_to_matching(g, base) for g in full_group})
        idx = {m: i for i, m in enumerate(omega)}
        plus = {apply_to_matching(g, base) for g in psl_group}
        assert len(omega) == 2 * prime
        assert len(plus) == prime and len(omega) - len(plus) == prime

        stab0 = frozenset(g for g in full_group if apply_to_matching(g, base) == base)
        assert stab0 == parent

        # independent canonical-J selection: max |K| over outer involutions, tie-break min tuple
        best = None
        dist = {}
        for g in sorted(full_group):
            if g in psl_group or order(g) != 2:
                continue
            mate = apply_to_matching(g, base)
            stabm = frozenset(h for h in full_group if apply_to_matching(h, mate) == mate)
            k = stab0 & stabm
            cc = len(union_find_orbits(k, omega))
            dist[(len(k), cc)] = dist.get((len(k), cc), 0) + 1
            if best is None or len(k) > best[0]:
                best = (len(k), g, mate, k)
        _, J, mate, K = best

        # J normalizes K
        Ji = inv(J)
        assert all(mul(mul(J, k), Ji) in K for k in K)

        orbits = union_find_orbits(K, omega)
        c = len(orbits)
        sizes = sorted(len(o) for o in orbits)

        # sheets of orbits, J pairing
        def sheet(o):
            s = {0 if omega[i] in plus else 1 for i in o}
            assert len(s) == 1
            return s.pop()

        plus_sizes = sorted(len(o) for o in orbits if sheet(o) == 0)
        minus_sizes = sorted(len(o) for o in orbits if sheet(o) == 1)
        assert plus_sizes == minus_sizes

        # clause 2: D' joint fibres = K-orbits
        e0, em = edges(base), edges(mate)

        def dprime(m):
            e = edges(m)
            return (len(e & e0), len(e & em))

        assert all(len({dprime(omega[i]) for i in o}) == 1 for o in orbits)
        joint = {}
        for i, m in enumerate(omega):
            joint.setdefault((0 if m in plus else 1, dprime(m)), set()).add(i)
        assert {frozenset(s) for s in joint.values()} == set(orbits)

        # clause 3: independent double-coset sweep (right-to-left order, independent of primary)
        remaining = set(full_group)
        klist, hlist = list(K), list(stab0)
        dcount = 0
        while remaining:
            g = max(remaining)  # opposite extremal pick from primary (which used min)
            coset = {mul(mul(k, g), h) for k in klist for h in hlist}
            remaining -= coset
            dcount += 1
        assert dcount == c

        # clause 4: chain dims
        g_orbits = union_find_orbits(full_group, omega)
        gplus_orbits = union_find_orbits(psl_group, omega)
        chain = [len(g_orbits), len(gplus_orbits), c, len(omega)]
        assert chain == [1, 2, c, 2 * prime]

        # sign line odd + K-invariant
        sign = [1 if omega[i] in plus else -1 for i in range(len(omega))]
        j_act = tuple(idx[apply_to_matching(J, m)] for m in omega)
        assert all(len({sign[i] for i in o}) == 1 for o in orbits)
        assert all(sign[j_act[i]] == -sign[i] for i in range(len(omega)))

        # stabilizer orders + singletons
        stab_orders = sorted({len(K) // len(o) for o in orbits})
        singletons = {omega[min(o)] for o in orbits if len(o) == 1}
        assert singletons == {base, mate}

        # --- compare against tracked primary certificate ---
        p = primary_cases[name]
        assert p["G_order"] == len(full_group)
        assert p["G_plus_order"] == len(psl_group)
        assert p["H_order"] == len(parent)
        assert p["canonical_K_order"] == len(K)
        assert p["clause_1_strata"]["num_K_orbits_c"] == c
        assert p["clause_1_strata"]["K_orbit_sizes"] == sizes
        assert p["clause_2_intrinsic_middle"]["joint_fibres_equal_K_orbits"] is True
        assert p["clause_3_bihecke_dimension"]["direct_double_coset_count_in_G"] == dcount
        assert p["clause_4_algebra_chain"]["chain_dimensions_G_Gplus_K_Omega"] == chain
        assert p["clause_6_reconstruction"]["K_orbit_stabilizer_orders"] == stab_orders
        assert p["clause_6_reconstruction"]["singleton_fibres_are_base_and_J_mate"] is True
        assert p["all_clauses_pass"] is True

        print(
            f"replay {name} q={prime}: |K|={len(K)} c={c} sizes={sizes} "
            f"double_cosets={dcount} chain={chain} stab_orders={stab_orders} OK"
        )

    print("C434 independent replay OK")


if __name__ == "__main__":
    main()
