#!/usr/bin/env python3
"""Extract and classify solver-backed strategies for hard socle peels."""

from __future__ import annotations

import argparse
import collections
import os
import resource
import sys

sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, build_canonical_group, mask_bits, parse_mods, set_mem_limit_mb


def classify_strategy(mods, max_nodes, terminal_sizes=False):
    g = Group(mods)
    cg, _ = build_canonical_group(g, "auto", 200_000)
    sv = Solver(g, cg)
    raw = Solver(g)
    outcome, first0 = sv.solve()

    def hero_move(am, mem, s, d, t):
        moves = raw.legal_mask(am, s, d, t)
        for _, x, cam, cm, cs, cd, ct, cmoves in sv.ordered_children(am, mem, s, d, t, moves):
            if cmoves == 0 or not sv.win(cam, cm, cs, cd, ct, cmoves, len(cm)):
                return x
        return None

    am, mem, s, d, t = raw.compute_state(())
    first = hero_move(am, mem, s, d, t)
    if first is None:
        print(f"outcome={outcome}; no first-player strategy to extract")
        return

    # For (3,3,p), treat first two coordinates as the F3 socle and last as coprime.
    def hpart(x):
        return g.elems[x][:-1]

    def kpart(x):
        return g.elems[x][-1]

    def sigma_h_same_k(y):
        o = hpart(first)
        e = g.elems[y]
        h = tuple((-o[i] - e[i]) % 3 for i in range(len(o)))
        return g.idx[h + (e[-1],)]

    def describe(opp, reply, amask):
        tags = []
        tags.append("opp_socle" if kpart(opp) == 0 else "opp_mixed")
        tags.append("rep_socle" if kpart(reply) == 0 else "rep_mixed")
        if reply == g.neg[opp]:
            tags.append("full_neg")
        if reply == sigma_h_same_k(opp):
            tags.append("sigmaH_sameK")
        if hpart(reply) == hpart(opp) and kpart(reply) == (-kpart(opp)) % g.mods[-1]:
            tags.append("rho_newfactor")
        elif kpart(reply) == (-kpart(opp)) % g.mods[-1]:
            tags.append("neg_newfactor")
        blockers = []
        for a in mask_bits(amask):
            if g.add[a][opp] == reply:
                blockers.append(g.elems[a])
        if blockers:
            tags.append("reply_is_A_plus_opp")
        return ",".join(tags)

    records = []
    terminal_counter = collections.Counter()
    terminal_examples = {}
    seen = set()

    def rec(amask, members, ss, dd, tt, hero_turn, last, depth):
        if len(seen) >= max_nodes:
            return
        key = (amask, hero_turn, -1 if last is None else last)
        if key in seen:
            return
        seen.add(key)
        moves = raw.legal_mask(amask, ss, dd, tt)
        if moves == 0:
            if terminal_sizes:
                terminal_counter[len(members)] += 1
                terminal_examples.setdefault(len(members), [g.elems[i] for i in members])
            return
        if hero_turn:
            r = hero_move(amask, members, ss, dd, tt)
            if r is None:
                records.append((depth, last, None, "NO_REPLY"))
                return
            records.append((depth, last, r, describe(last, r, amask)))
            rec(*raw.child_state(amask, members, ss, dd, tt, r), False, None, depth + 1)
        else:
            for y in mask_bits(moves):
                rec(*raw.child_state(amask, members, ss, dd, tt, y), True, y, depth + 1)

    rec(*raw.child_state(am, mem, s, d, t, first), False, None, 1)
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    print(f"group={'x'.join('Z'+str(m) for m in mods)} outcome={outcome} first={g.label(first)}")
    print(f"solver_nodes={sv.nodes} solver_tt={len(sv.tt)} explored={len(seen)} records={len(records)} rss={rss}MB")
    counts = collections.Counter(row[3] for row in records)
    for desc, n in counts.most_common(50):
        print(f"{n:7d}  {desc}")
    print("sample records:")
    for depth, opp, rep, desc in records[:80]:
        print(f"  d{depth:2d} opp={g.label(opp)} -> rep={g.label(rep) if rep is not None else None} [{desc}]")
    if terminal_sizes:
        print("terminal sizes under this table strategy:")
        for size, count in sorted(terminal_counter.items()):
            print(f"  size={size:2d} count={count:6d} example={terminal_examples[size][:20]}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mods", nargs="?", default="3,3,5")
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--max-nodes", type=int, default=200_000)
    ap.add_argument("--terminal-sizes", action="store_true")
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)
    classify_strategy(parse_mods(args.mods), args.max_nodes, args.terminal_sizes)


if __name__ == "__main__":
    main()
