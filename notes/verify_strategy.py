#!/usr/bin/env python3
"""Strategy verifier for the sum-free achievement game.

The verifier branches over all opponent moves and applies one designated hero
strategy on every hero turn.  It checks that the strategy never makes an illegal
move and that the opponent, not the hero, is the first player stuck.

Built-in strategies:
  table             choose a solver-certified winning move at every hero turn
  neg               reply to the opponent's last move with -x
  tau:coords        reply with x+v
  f3sigma:coords    reply with -o-x on a pure F3^b group
  slice_pair        experimental Z2 x F3^b hyperplane pairing attempt
  slice_affine      open in S0, then use (eps,v) -> (eps,-o-v)
  slice_hybrid      try slice_pair, then the affine repair when blocked
  slice_local       hybrid plus negation/unique-move bounded repairs

The default memo key is raw state + side + last opponent move.  That is the safe
choice for arbitrary strategies; canonical memoization of a concrete strategy is
only valid when the strategy commutes with the canonicalizing automorphisms.
"""

from __future__ import annotations

import argparse
import os
import resource
import sys
import time
from typing import Callable, Dict, Optional, Sequence, Tuple


sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import (  # noqa: E402
    Group,
    Mask,
    Solver,
    build_canonical_group,
    mask_bits,
    parse_mods,
    parse_start,
    set_mem_limit_mb,
)


Strategy = Callable[["Verifier", Mask, Tuple[int, ...], Mask, Mask, Mask, Optional[int]], Optional[int]]


class Verifier:
    def __init__(
        self,
        group: Group,
        strategy: Strategy,
        solver: Optional[Solver] = None,
        max_nodes: int = 0,
        progress: int = 0,
    ):
        self.g = group
        self.strategy = strategy
        self.solver = solver
        self.raw = Solver(group)
        self.max_nodes = max_nodes
        self.progress = progress
        self.nodes = 0
        self.last_progress = 0
        self.t0 = time.time()
        self.memo: Dict[Tuple[Mask, bool, int], bool] = {}
        self.failure: Optional[str] = None
        self.failure_path: Tuple[int, ...] = ()

    def legal_mask(self, amask: Mask, s: Mask, d: Mask, t: Mask) -> Mask:
        return self.raw.legal_mask(amask, s, d, t)

    def child_state(
        self,
        amask: Mask,
        members: Tuple[int, ...],
        s: Mask,
        d: Mask,
        t: Mask,
        x: int,
    ):
        return self.raw.child_state(amask, members, s, d, t, x)

    def note_progress(self, depth: int) -> None:
        if not self.progress or self.nodes - self.last_progress < self.progress:
            return
        self.last_progress = self.nodes
        rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
        print(
            f"  ..verify nodes={self.nodes:>10} memo={len(self.memo):>9} depth={depth:>3} "
            f"rss={rss}MB time={time.time() - self.t0:8.1f}s",
            flush=True,
        )

    def verify_from(
        self,
        amask: Mask,
        members: Tuple[int, ...],
        s: Mask,
        d: Mask,
        t: Mask,
        hero_turn: bool,
        opponent_last: Optional[int],
        path: Tuple[int, ...],
    ) -> bool:
        self.nodes += 1
        self.note_progress(len(members))
        if self.max_nodes and self.nodes > self.max_nodes:
            self.failure = f"node cap exceeded ({self.max_nodes})"
            self.failure_path = path
            return False

        key = (amask, hero_turn, -1 if opponent_last is None else opponent_last)
        cached = self.memo.get(key)
        if cached is not None:
            return cached

        moves = self.legal_mask(amask, s, d, t)
        if moves == 0:
            # Side to move is stuck.  This is good iff it is the opponent's turn.
            ok = not hero_turn
            if not ok and self.failure is None:
                self.failure = "hero is stuck"
                self.failure_path = path
            self.memo[key] = ok
            return ok

        if hero_turn:
            reply = self.strategy(self, amask, members, s, d, t, opponent_last)
            if reply is None:
                self.failure = "strategy returned no reply"
                self.failure_path = path
                self.memo[key] = False
                return False
            if not (moves & self.g.pow2[reply]):
                self.failure = (
                    f"illegal reply {self.g.label(reply)} after "
                    f"{None if opponent_last is None else self.g.label(opponent_last)}"
                )
                self.failure_path = path + (reply,)
                self.memo[key] = False
                return False
            child = self.child_state(amask, members, s, d, t, reply)
            ok = self.verify_from(*child, False, None, path + (reply,))
            self.memo[key] = ok
            return ok

        for opp in mask_bits(moves):
            child = self.child_state(amask, members, s, d, t, opp)
            if not self.verify_from(*child, True, opp, path + (opp,)):
                self.memo[key] = False
                return False
        self.memo[key] = True
        return True

    def verify(self, start: Sequence[int], hero_turn: bool) -> bool:
        amask, members, s, d, t = self.raw.compute_state(tuple(start))
        return self.verify_from(amask, members, s, d, t, hero_turn, None, tuple(start))

    def path_labels(self) -> str:
        return " -> ".join(self.g.label(x) for x in self.failure_path)


def strategy_table(verifier: Verifier, amask, members, s, d, t, opponent_last):
    if verifier.solver is None:
        raise ValueError("table strategy requires a Solver")
    moves = verifier.legal_mask(amask, s, d, t)
    for _cnt, x, camask, cmembers, cs, cd, ct, cmoves in verifier.solver.ordered_children(
        amask, members, s, d, t, moves
    ):
        if cmoves == 0:
            return x
        if not verifier.solver.win(camask, cmembers, cs, cd, ct, cmoves, len(cmembers)):
            return x
    return None


def strategy_neg(verifier: Verifier, amask, members, s, d, t, opponent_last):
    if opponent_last is None:
        return None
    return verifier.g.neg[opponent_last]


def make_strategy_tau(v: int) -> Strategy:
    def strategy(verifier: Verifier, amask, members, s, d, t, opponent_last):
        if opponent_last is None:
            return None
        return verifier.g.add[opponent_last][v]

    return strategy


def make_strategy_f3sigma(center: int) -> Strategy:
    def strategy(verifier: Verifier, amask, members, s, d, t, opponent_last):
        if opponent_last is None:
            return center
        # sigma(y) = -center-y
        return verifier.g.add[verifier.g.neg[center]][verifier.g.neg[opponent_last]]

    return strategy


def slice_pair_reply_index(g: Group, x: int) -> int:
    e = g.elems[x]
    out = list(e)
    out[-1] = (-out[-1]) % 3
    return g.idx[tuple(out)]


def strategy_slice_pair(verifier: Verifier, amask, members, s, d, t, opponent_last):
    """Experimental hyperplane strategy for Z2 x F3^b.

    It opens in the S0 hyperplane, replies inside S0 recursively by the same
    rule, and otherwise tries the e-coordinate reflection S1 <-> S2.  If the
    preferred reply is illegal it returns None; the verifier then records the
    first obstruction path.
    """
    g = verifier.g
    if not g.is_z2_x_f3() or len(g.mods) < 3:
        return None
    b = len(g.mods) - 1
    moves = verifier.legal_mask(amask, s, d, t)

    if opponent_last is None:
        first = g.idx[(0, 1) + (0,) * (b - 1)]
        return first if moves & g.pow2[first] else None

    coords = g.elems[opponent_last]
    if coords[-1] != 0:
        r = slice_pair_reply_index(g, opponent_last)
        return r if moves & g.pow2[r] else None

    # S0 fallback: for b=2 this is the Z2 x F3 base strategy after {m}.
    if b == 2:
        eps, h, _e = coords
        if opponent_last is None:
            cand = g.idx[(0, 1, 0)]
        elif eps == 0:
            cand = g.idx[(0, (-h) % 3, 0)]
        else:
            cand = g.idx[(1, (-h) % 3, 0)]
        return cand if moves & g.pow2[cand] else None

    # Recursive lift by deleting the last coordinate is intentionally simple:
    # reflect the F3^{b-1} part through origin inside S0.
    cand_coords = list(coords)
    for i in range(1, len(cand_coords) - 1):
        cand_coords[i] = (-cand_coords[i]) % 3
    cand = g.idx[tuple(cand_coords)]
    return cand if moves & g.pow2[cand] else None


def z2f3_opening_v(group: Group) -> Tuple[int, ...]:
    b = len(group.mods) - 1
    return (1,) + (0,) * (b - 1)


def affine_v_reply(g: Group, opponent_last: int) -> int:
    """For Z2 x F3^b after opening o=(0,1,0,...), return (eps, -o-v)."""
    eps, *v = g.elems[opponent_last]
    o = z2f3_opening_v(g)
    w = tuple((-o[i] - v[i]) % 3 for i in range(len(v)))
    return g.idx[(eps,) + w]


def strategy_slice_affine(verifier: Verifier, amask, members, s, d, t, opponent_last):
    g = verifier.g
    if not g.is_z2_x_f3() or len(g.mods) < 3:
        return None
    b = len(g.mods) - 1
    moves = verifier.legal_mask(amask, s, d, t)
    if opponent_last is None:
        first = g.idx[(0, 1) + (0,) * (b - 1)]
        return first if moves & g.pow2[first] else None
    cand = affine_v_reply(g, opponent_last)
    return cand if moves & g.pow2[cand] else None


def strategy_slice_hybrid(verifier: Verifier, amask, members, s, d, t, opponent_last):
    cand = strategy_slice_pair(verifier, amask, members, s, d, t, opponent_last)
    if cand is not None:
        return cand
    return strategy_slice_affine(verifier, amask, members, s, d, t, opponent_last)


def strategy_slice_local(verifier: Verifier, amask, members, s, d, t, opponent_last):
    moves = verifier.legal_mask(amask, s, d, t)
    for fn in (strategy_slice_pair, strategy_slice_affine, strategy_neg):
        cand = fn(verifier, amask, members, s, d, t, opponent_last)
        if cand is not None and (moves & verifier.g.pow2[cand]):
            return cand
    if moves.bit_count() == 1:
        return next(mask_bits(moves))
    return None


def build_strategy(group: Group, spec: str, solver: Optional[Solver]) -> Strategy:
    if spec == "table":
        return strategy_table
    if spec == "neg":
        return strategy_neg
    if spec == "slice_pair":
        return strategy_slice_pair
    if spec == "slice_affine":
        return strategy_slice_affine
    if spec == "slice_hybrid":
        return strategy_slice_hybrid
    if spec == "slice_local":
        return strategy_slice_local
    if spec.startswith("tau:"):
        coords = tuple(int(x) for x in spec[4:].split(","))
        return make_strategy_tau(group.idx[coords])
    if spec.startswith("f3sigma:"):
        coords = tuple(int(x) for x in spec[8:].split(","))
        return make_strategy_f3sigma(group.idx[coords])
    raise ValueError(f"unknown strategy {spec!r}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("mods", help="moduli, e.g. 3,3,3 or 2,3,3")
    ap.add_argument("--start", default="", help="semicolon-separated coords")
    ap.add_argument("--hero-turn", choices=["yes", "no"], default="yes")
    ap.add_argument("--strategy", default="table")
    ap.add_argument("--canon", default="auto", choices=["auto", "full", "monomial", "coord", "none"])
    ap.add_argument("--canon-cap", type=int, default=200_000)
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--max-nodes", type=int, default=0)
    ap.add_argument("--progress", type=int, default=0)
    args = ap.parse_args()

    set_mem_limit_mb(args.mem_mb)
    group = Group(parse_mods(args.mods))
    start = parse_start(group, args.start)

    solver = None
    if args.strategy == "table":
        cg, label = build_canonical_group(group, args.canon, args.canon_cap)
        solver = Solver(group, cg, progress=0)
    strategy = build_strategy(group, args.strategy, solver)
    verifier = Verifier(group, strategy, solver=solver, max_nodes=args.max_nodes, progress=args.progress)
    ok = verifier.verify(start, hero_turn=(args.hero_turn == "yes"))
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    print(
        f"[verify {'x'.join('Z'+str(m) for m in group.mods)}] strategy={args.strategy} "
        f"start={[group.elems[i] for i in start]} hero_turn={args.hero_turn}"
    )
    print(
        f"  result={'VERIFIED' if ok else 'FAILED'} nodes={verifier.nodes} "
        f"memo={len(verifier.memo)} solver_nodes={0 if solver is None else solver.nodes} rss={rss}MB"
    )
    if not ok:
        print(f"  reason={verifier.failure}")
        print(f"  path={verifier.path_labels()}")


if __name__ == "__main__":
    main()
