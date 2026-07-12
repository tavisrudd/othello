#!/usr/bin/env python3
"""C83(3): coarsest Grundy-respecting congruence of the residual grid-game DAG.

Enumerate the exact residual grid game (PrimeGridGame) reachable from the empty
residual position, label every state by its Grundy value, then compute the
coarsest bisimulation by Kanellakis--Smolka signature refinement.

Grundy value is a bisimulation invariant (bisimilar states have identical
successor-class sets, hence identical Grundy by induction), so the coarsest
bisimulation refining the Grundy coloring equals the coarsest Grundy-respecting
congruence: the minimal automaton whose Grundy computation reproduces the real
game. Its class count vs q is the decisive C83 dichotomy:

  small / stable across q  => a bounded bulk quotient exists (octal-periodicity
                              shape: automaton with arithmetic transition guards).
  blows up with q          => no bounded quotient; close the quotient lane.

Usage:  c83_bisimulation.py 11 [13 ...] [--invariants]
"""
from __future__ import annotations

import argparse
import importlib.util
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def mex(values: set[int]) -> int:
    m = 0
    while m in values:
        m += 1
    return m


def build_dag(game):
    """Enumerate reachable states from mask 0. Return (masks, child_ptr, child_flat).

    child_flat[child_ptr[i]:child_ptr[i+1]] are the child state-ids of state i.
    States are numbered in discovery order; masks[i] is the bitmask of state i.
    """
    ident: dict[int, int] = {0: 0}
    masks: list[int] = [0]
    stack = [0]
    # temporary per-state child lists, indexed by state id
    children: list[list[int]] = [[]]
    while stack:
        i = stack.pop()
        mask = masks[i]
        moves = game.legal_mask(mask)
        ch = children[i]
        m = moves
        while m:
            bit = m & -m
            m ^= bit
            cmask = mask | bit
            cid = ident.get(cmask)
            if cid is None:
                cid = len(masks)
                ident[cmask] = cid
                masks.append(cmask)
                children.append([])
                stack.append(cid)
            ch.append(cid)
    return masks, children


def grundy_values(masks, children):
    """Grundy value per state, computed in reverse topological order.

    Moves strictly increase popcount, so processing states by decreasing popcount
    guarantees children are done before parents.
    """
    n = len(masks)
    order = sorted(range(n), key=lambda i: bin(masks[i]).count("1"), reverse=True)
    g = [0] * n
    for i in order:
        ch = children[i]
        if ch:
            g[i] = mex({g[c] for c in ch})
    return g


def coarsest_bisimulation(children, grundy):
    """Kanellakis--Smolka partition refinement seeded by Grundy value.

    Returns (block, rounds_history) where block[i] is the final class id and
    rounds_history is the list of class counts after each refinement round.
    """
    n = len(children)
    # seed: block id per distinct grundy value
    block = list(grundy)  # grundy values are small ints; use them as initial ids
    # normalize seed ids to 0..k-1
    remap = {}
    for i in range(n):
        b = block[i]
        if b not in remap:
            remap[b] = len(remap)
        block[i] = remap[b]
    history = [len(remap)]
    while True:
        sig_id: dict[tuple, int] = {}
        new_block = [0] * n
        for i in range(n):
            # signature: own block + SET of child blocks (unlabeled moves)
            sig = (block[i], frozenset(block[c] for c in children[i]))
            nb = sig_id.get(sig)
            if nb is None:
                nb = len(sig_id)
                sig_id[sig] = nb
            new_block[i] = nb
        count = len(sig_id)
        history.append(count)
        if count == history[-2]:
            break
        block = new_block
    return block, history


def reverse_engineer(game, masks, grundy, block):
    """Test whether classes are explained by (grundy, small structural features).

    Structural features tried per state, all cheap and frame-relative:
      - popcount (residual size)
      - number of live conic cells remaining legal
      - number of off-conic selected cells (intruders)
      - defect spectrum of the live conic under selected intruders' involutions
    Report, for each candidate feature tuple, how many bisimulation classes it
    fails to separate (collisions) vs how many it over-splits.
    """
    n = len(masks)

    def features(i):
        mask = masks[i]
        legal = game.legal_mask(mask)
        live_conic = bin(legal & game.conic_mask).count("1")
        selected_conic = bin(mask & game.conic_mask).count("1")
        intruders = bin(mask & ~game.conic_mask).count("1")
        size = bin(mask).count("1")
        return (grundy[i], size, live_conic, selected_conic, intruders)

    # map bisim class -> set of feature tuples, and feature tuple -> set of classes
    class_to_feats: dict[int, set] = defaultdict(set)
    feat_to_classes: dict[tuple, set] = defaultdict(set)
    for i in range(n):
        f = features(i)
        class_to_feats[block[i]].add(f)
        feat_to_classes[f].add(block[i])
    # a feature vector "determines the class" iff every feature tuple maps to a
    # single bisim class.
    ambiguous = sum(1 for c in feat_to_classes.values() if len(c) > 1)
    return len(feat_to_classes), ambiguous


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="*", type=int, default=[11])
    parser.add_argument("--invariants", action="store_true",
                        help="reverse-engineer class invariants (extra pass)")
    args = parser.parse_args()

    notes = Path(__file__).resolve().parents[2] / "notes"
    c20 = load_module(notes / "2026-07-08-intrusion-census.py", "c83_c20")

    for q in args.q:
        t0 = time.time()
        game = c20.PrimeGridGame(q)
        masks, children = build_dag(game)
        t_build = time.time() - t0
        n_states = len(masks)
        n_edges = sum(len(c) for c in children)

        grundy = grundy_values(masks, children)
        t_grundy = time.time() - t0
        gcount = Counter(grundy)
        root_grundy = grundy[0]

        block, history = coarsest_bisimulation(children, grundy)
        n_classes = history[-1]
        t_bisim = time.time() - t0

        # per-Grundy class breakdown
        classes_by_g: dict[int, set] = defaultdict(set)
        for i in range(n_states):
            classes_by_g[grundy[i]].add(block[i])
        g_breakdown = {g: len(cs) for g, cs in sorted(classes_by_g.items())}

        print(
            f"C83-BISIM q={q} states={n_states} edges={n_edges} "
            f"grundy_values={dict(sorted(gcount.items()))} root_grundy={root_grundy} "
            f"bisim_classes={n_classes} refine_rounds={history} "
            f"classes_per_grundy={g_breakdown} "
            f"t_build={t_build:.1f}s t_grundy={t_grundy:.1f}s t_bisim={t_bisim:.1f}s"
        )
        if args.invariants:
            n_feat, ambiguous = reverse_engineer(game, masks, grundy, block)
            print(
                f"C83-INVARIANTS q={q} feature_tuples={n_feat} "
                f"ambiguous_tuples={ambiguous} "
                f"(0 ambiguous => (grundy,size,live_conic,sel_conic,intruders) "
                f"determines the bisim class)"
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
