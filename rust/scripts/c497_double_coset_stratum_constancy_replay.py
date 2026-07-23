#!/usr/bin/env python3
"""C497 independent replay.

Rebuilds PGL_2(17) a different way (closure of the intruder involutions, not the
Mobius generators used by the primary checker), re-derives the double-coset partition
of the frozen q17 Y_0 census with its own permutation arithmetic, recomputes the
mixed-bucket and verified-split counts, and re-verifies the committed certificate's
canonical witness (an explicit conjugator carrying a Y_NK0 object onto a non-Y_NK0
object in the same double-coset stratum).

Shared trust boundary with the primary checker: the committed game/geometry modules
(residual legality, sigma involutions, state_features, the census Y_0 / node-Kayles
definitions).  The group construction, invariant, bucketing, and witness verification
are re-implemented here.
"""

from __future__ import annotations

import importlib.util
import json
import sys
from collections import defaultdict, deque
from itertools import combinations
from math import gcd
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CENSUS = ROOT / "rust/scripts/c80_response_fibre_census.py"
GEOMETRY = ROOT / "notes/2026-07-08-zone-repair-geometry.py"
CERT = ROOT / "notes/2026-07-22-c497-double-coset-stratum-constancy.json"
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
Q = 17


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def main() -> int:
    cert = json.loads(CERT.read_text())
    census = load_module(CENSUS, "c497r_census")
    geometry = load_module(GEOMETRY, "c497r_geometry")
    c31 = geometry.load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(Q)
    lines = census.projective_lines(game)
    states, _ = c31.load_p_reply_states(ROWS, Q)

    params = game.params
    idx = {p: i for i, p in enumerate(params)}
    n = len(params)

    def involution(cell: int) -> tuple[int, ...]:
        sp = game.sigma_perm(cell)
        return tuple(idx[sp[params[i]]] for i in range(n))

    # --- PGL_2(17) as the closure of the intruder involutions ---
    off_conic = [c for c in range(Q * Q) if not game.is_conic_cell(c)]
    seeds = [involution(c) for c in off_conic]
    ident = tuple(range(n))

    def mul(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
        return tuple(a[b[i]] for i in range(n))

    group = {ident}
    frontier = deque([ident])
    seed_set = list(dict.fromkeys(seeds))
    while frontier:
        x = frontier.popleft()
        for s in seed_set:
            y = mul(s, x)
            if y not in group:
                group.add(y)
                frontier.append(y)
    group = sorted(group)
    assert len(group) == cert["group_order"], (len(group), cert["group_order"])
    inverses = {}
    for g in group:
        inv = [0] * n
        for i in range(n):
            inv[g[i]] = i
        inverses[g] = tuple(inv)

    def fixed(iv: tuple[int, ...]) -> int:
        return sum(1 for i in range(n) if iv[i] == i)

    def order_of(perm: tuple[int, ...]) -> int:
        seen = [False] * n
        order = 1
        for s in range(n):
            if seen[s]:
                continue
            t, length = s, 0
            while not seen[t]:
                seen[t] = True
                t = perm[t]
                length += 1
            order = order * length // gcd(order, length)
        return order

    def conj(g, gi, iv):
        return tuple(g[iv[gi[i]]] for i in range(n))

    # --- independent Y_0 / nk_zero enumeration ---
    objects = []
    three_intruder = 0
    for mask, _row in states:
        for move in geometry.bits(game.legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            old = geometry.intruders(game, child)
            if len(old) != 3:
                continue
            three_intruder += 1
            cells = tuple(geometry.cell(game, p) for p in old)
            if census.fixed_count(Q, census.discriminant(Q, *cells)):
                continue
            for reply in geometry.bits(game.legal_mask(child) & ~game.conic_mask):
                if geometry.prod_order(game, move, reply) not in (Q - 1, Q + 1):
                    continue
                quad = tuple(geometry.cell(game, p) for p in (*old, reply))
                if any(
                    census.fixed_count(Q, census.discriminant(Q, *(quad[i] for i in tri)))
                    for tri in combinations(range(4), 3)
                ):
                    continue
                grand = child | (1 << reply)
                grand_live = len(geometry.live_conic(game, grand))
                feats = game.state_features(grand, geometry.intruders(game, grand))
                nk_exact = census.node_kayles_exact(game, lines, grand)
                nk_zero = nk_exact and grand_live == 0 and feats["zone_grundy"] == 0
                objects.append((tuple(sorted(old)), reply, nk_zero))

    assert three_intruder == cert["three_intruder_transitions"]
    assert len(objects) == cert["y0_members"]
    assert sum(1 for _, _, nk in objects if nk) == cert["ynk0_members"]

    # --- independent double-coset partition ---
    invcache = {}

    def iv(cell):
        v = invcache.get(cell)
        if v is None:
            v = involution(cell)
            invcache[cell] = v
        return v

    def label(three, reply):
        ivs = [iv(c) for c in three]
        iz = iv(reply)
        return (
            tuple(sorted(fixed(v) for v in ivs)),
            fixed(iz),
            tuple(sorted(order_of(mul(ivs[a], ivs[b])) for a, b in combinations(range(3), 2))),
            tuple(sorted(order_of(mul(v, iz)) for v in ivs)),
        )

    buckets = defaultdict(list)
    for three, reply, nk in objects:
        buckets[label(three, reply)].append((three, reply, nk))
    assert len(buckets) == cert["double_coset_buckets"]

    mixed = sorted(k for k, v in buckets.items() if len({x[2] for x in v}) > 1)
    assert len(mixed) == cert["mixed_ynk0_buckets"]
    assert sum(len(buckets[k]) for k in mixed) == cert["y0_objects_in_mixed_buckets"]

    def has_conjugator(three_a, reply_a, three_b, reply_b):
        a_un = [iv(c) for c in three_a]
        a_mk = iv(reply_a)
        b_un = {iv(c) for c in three_b}
        b_mk = iv(reply_b)
        for g in group:
            gi = inverses[g]
            if conj(g, gi, a_mk) != b_mk:
                continue
            if {conj(g, gi, x) for x in a_un} == b_un:
                return True
        return False

    verified = 0
    for k in mixed:
        members = sorted(buckets[k])
        yes = [m for m in members if m[2]]
        no = [m for m in members if not m[2]]
        if any(has_conjugator(a[0], a[1], b[0], b[1]) for a in yes for b in no):
            verified += 1
    assert verified == cert["verified_true_orbit_split_buckets"]

    # --- re-verify the committed canonical witness from scratch ---
    w = cert["canonical_witness"]
    ya = w["ynk0_object"]
    na = w["non_ynk0_object"]
    assert has_conjugator(
        tuple(ya["intruder_cells"]), ya["reply_cell"],
        tuple(na["intruder_cells"]), na["reply_cell"],
    )
    membership = {(tuple(t), r): nk for t, r, nk in objects}
    assert membership[(tuple(ya["intruder_cells"]), ya["reply_cell"])] is True
    assert membership[(tuple(na["intruder_cells"]), na["reply_cell"])] is False

    assert cert["refines_ynk0_membership"] is False
    print(
        "C497 replay: PASS — PGL_2(17) rebuilt from involutions, "
        f"{verified} verified double-coset splits, witness re-confirmed; "
        "double-coset partition does NOT refine Y_NK0-membership"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
