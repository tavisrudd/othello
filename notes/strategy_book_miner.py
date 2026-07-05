#!/usr/bin/env python3
"""Mine a finite rule+book strategy for the hard peel F3^2 x Z5.

The script verifies a strategy of the form:
  first move fixed;
  at each hero turn, try structural reply families in priority order;
  if no family contains a solver-certified winning reply, fall back to a finite
  canonical book entry.

This is a proof-search tool, not a proof.  It identifies which broad patterns
cover the all-lines strategy tree and how large the residual exception book is.
"""

from __future__ import annotations

import argparse
import collections
import os
import resource
import sys
from typing import Callable, Dict, Iterable, List, Optional, Tuple

sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, build_canonical_group, mask_bits, set_mem_limit_mb


Mods = Tuple[int, ...]


class Miner:
    def __init__(self, mods: Mods):
        self.g = Group(mods)
        self.canon_group, _ = build_canonical_group(self.g, "auto", 200_000)
        self.solver = Solver(self.g, self.canon_group)
        self.raw = Solver(self.g)
        self.first = self.g.idx[(0, 1, 0)]
        self.o_h = (0, 1)
        self.rule_hits = collections.Counter()
        self.book: Dict[int, int] = {}
        self.book_examples: Dict[int, Tuple[int, ...]] = {}
        self.book_records = []
        self.visited = set()
        self.terminal_sizes = collections.Counter()

    def h(self, x: int) -> Tuple[int, int]:
        e = self.g.elems[x]
        return e[0], e[1]

    def k(self, x: int) -> int:
        return self.g.elems[x][2]

    def idx(self, h: Tuple[int, int], k: int) -> int:
        return self.g.idx[h + (k % 5,)]

    def sig_h(self, y: int) -> Tuple[int, int]:
        yh = self.h(y)
        return ((-self.o_h[0] - yh[0]) % 3, (-self.o_h[1] - yh[1]) % 3)

    def neg_h(self, y: int) -> Tuple[int, int]:
        yh = self.h(y)
        return ((-yh[0]) % 3, (-yh[1]) % 3)

    def winning(self, state, x: int) -> bool:
        child = self.raw.child_state(*state, x)
        cmoves = self.raw.legal_mask(child[0], child[2], child[3], child[4])
        return cmoves == 0 or not self.solver.win(child[0], child[1], child[2], child[3], child[4], cmoves, len(child[1]))

    def winning_from_candidates(self, state, candidates: Iterable[int]) -> Optional[int]:
        moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
        for x in candidates:
            if (moves & self.g.pow2[x]) and self.winning(state, x):
                return x
        return None

    def all_legal_winning(self, state) -> List[int]:
        moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
        out = []
        for x in mask_bits(moves):
            if self.winning(state, x):
                out.append(x)
        return out

    def rule_candidates(self, name: str, state, last: int) -> List[int]:
        yh, yk = self.h(last), self.k(last)
        if name == "terminal":
            moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
            out = []
            for x in mask_bits(moves):
                child = self.raw.child_state(*state, x)
                if self.raw.legal_mask(child[0], child[2], child[3], child[4]) == 0:
                    out.append(x)
            return out
        if name.startswith("lowLegal"):
            threshold = int(name[len("lowLegal"):])
            moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
            if moves.bit_count() <= threshold:
                return list(mask_bits(moves))
            return []
        if name == "full_neg":
            return [self.g.neg[last]]
        if name == "rho":
            return [self.idx(yh, -yk)]
        if name == "sigma_negk":
            return [self.idx(self.sig_h(last), -yk)]
        if name == "sigma_samek":
            return [self.idx(self.sig_h(last), yk)]
        if name == "negH_samek":
            return [self.idx(self.neg_h(last), yk)]
        if name == "negH_negk":
            return [self.idx(self.neg_h(last), -yk)]
        if name == "sameH_anyK":
            return [self.idx(yh, k) for k in range(5)]
        if name == "sigmaH_anyK":
            return [self.idx(self.sig_h(last), k) for k in range(5)]
        if name == "negH_anyK":
            return [self.idx(self.neg_h(last), k) for k in range(5)]
        if name == "sameK_anyH":
            return [self.g.idx[(a, b, yk)] for a in range(3) for b in range(3)]
        if name == "negK_anyH":
            return [self.g.idx[(a, b, (-yk) % 5)] for a in range(3) for b in range(3)]
        if name.startswith("shiftK"):
            delta = int(name[len("shiftK"):])
            return [self.g.idx[(a, b, (yk + delta) % 5)] for a in range(3) for b in range(3)]
        if name.startswith("hShift"):
            _, a, b = name.split("_")
            dh = ((yh[0] + int(a)) % 3, (yh[1] + int(b)) % 3)
            return [self.idx(dh, k) for k in range(5)]
        if name.startswith("delta"):
            _, a, b, dk = name.split("_")
            dh = ((yh[0] + int(a)) % 3, (yh[1] + int(b)) % 3)
            return [self.idx(dh, yk + int(dk))]
        if name == "socle_if_opp_mixed":
            return [self.g.idx[(a, b, 0)] for a in range(3) for b in range(3)]
        if name == "mixed_if_opp_socle":
            return [self.g.idx[(a, b, k)] for a in range(3) for b in range(3) for k in range(1, 5)]
        raise KeyError(name)

    def choose(self, state, last: Optional[int], rules: List[str]) -> Tuple[int, str]:
        moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
        if last is None:
            if moves & self.g.pow2[self.first]:
                return self.first, "first"
            raise RuntimeError("fixed first move illegal")

        for rule in rules:
            if rule == "mixed_if_opp_socle" and self.k(last) != 0:
                continue
            if rule == "socle_if_opp_mixed" and self.k(last) == 0:
                continue
            x = self.winning_from_candidates(state, self.rule_candidates(rule, state, last))
            if x is not None:
                return x, rule

        key = self.solver.canon(state[0], state[1])
        wins = self.all_legal_winning(state)
        if not wins:
            raise RuntimeError("no winning move in N-position")
        # Stable deterministic book move: smallest canonical-label raw index among winning replies.
        x = wins[0]
        self.book.setdefault(key, x)
        self.book_examples.setdefault(key, tuple(state[1]))
        self.book_records.append((last, x, tuple(state[1])))
        return x, "BOOK"

    def verify(self, rules: List[str], max_states: int):
        self.rule_hits.clear()
        self.book.clear()
        self.book_examples.clear()
        self.book_records.clear()
        self.visited.clear()
        self.terminal_sizes.clear()

        def rec(state, hero_turn: bool, last: Optional[int]):
            if len(self.visited) >= max_states:
                raise RuntimeError("state cap")
            key = (state[0], hero_turn, -1 if last is None else last)
            if key in self.visited:
                return True
            self.visited.add(key)
            moves = self.raw.legal_mask(state[0], state[2], state[3], state[4])
            if moves == 0:
                if hero_turn:
                    return False
                self.terminal_sizes[len(state[1])] += 1
                return True
            if hero_turn:
                x, rule = self.choose(state, last, rules)
                if not (moves & self.g.pow2[x]):
                    raise RuntimeError(f"illegal chosen move {self.g.label(x)} by {rule}")
                self.rule_hits[rule] += 1
                return rec(self.raw.child_state(*state, x), False, None)
            for y in mask_bits(moves):
                if not rec(self.raw.child_state(*state, y), True, y):
                    return False
            return True

        start = self.raw.child_state(*self.raw.compute_state(()), self.first)
        ok = rec(start, False, None)
        return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--max-states", type=int, default=300_000)
    ap.add_argument("--rules", help="comma-separated custom rule list; if set, run only this list")
    ap.add_argument("--brief", action="store_true", help="suppress book examples")
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)

    default_rule_sets = [
        ["terminal", "full_neg", "rho", "sigma_negk", "sigma_samek"],
        ["terminal", "full_neg", "rho", "sameH_anyK", "sigmaH_anyK", "negH_anyK"],
        [
            "terminal",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
        [
            "terminal",
            "lowLegal3",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
        [
            "terminal",
            "lowLegal5",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
        [
            "terminal",
            "lowLegal7",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
        [
            "terminal",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "shiftK1",
            "shiftK3",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
        [
            "terminal",
            "full_neg",
            "rho",
            "sameH_anyK",
            "sigmaH_anyK",
            "negH_anyK",
            "sameK_anyH",
            "negK_anyH",
            "shiftK1",
            "shiftK2",
            "shiftK3",
            "shiftK4",
            "mixed_if_opp_socle",
            "socle_if_opp_mixed",
        ],
    ]
    rule_sets = [args.rules.split(",")] if args.rules else default_rule_sets
    for rules in rule_sets:
        miner = Miner((3, 3, 5))
        ok = miner.verify(rules, args.max_states)
        rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
        print("RULES", rules)
        print(
            f"  ok={ok} visited={len(miner.visited)} book={len(miner.book)} "
            f"solver_nodes={miner.solver.nodes} solver_tt={len(miner.solver.tt)} rss={rss}MB"
        )
        print(f"  hits={dict(miner.rule_hits)}")
        print(f"  terminal_sizes={dict(sorted(miner.terminal_sizes.items()))}")
        if miner.book_records:
            rels = collections.Counter()
            for last, reply, _mem in miner.book_records:
                yh = miner.h(last)
                rh = miner.h(reply)
                dk = (miner.k(reply) - miner.k(last)) % 5
                rels[(rh[0] - yh[0]) % 3, (rh[1] - yh[1]) % 3, dk] += 1
            print("  top book delta(H),deltaK:")
            for rel, n in rels.most_common(12):
                print(f"    {rel}: {n}")
        if not args.brief:
            for i, (key, mem) in enumerate(list(miner.book_examples.items())[:5]):
                print(f"  book_ex{i+1}: {[miner.g.elems[x] for x in mem]} -> {miner.g.elems[miner.book[key]]}")


if __name__ == "__main__":
    main()
