"""Strategy extractor for the sum-free achievement game on a finite abelian G.
Solve win/loss (memoized), then trace the HERO's winning strategy against ALL
opponent replies, printing hero's move keyed by opponent's last move so a
pattern (negation -z? translation z+m? something on the 3-torsion?) is visible.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    add = {}
    for i, ei in enumerate(elems):
        for j, ej in enumerate(elems):
            add[(i, j)] = idx[tuple((a + b) % m for a, b, m in zip(ei, ej, mods))]
    neg = {i: idx[tuple((-a) % m for a, m in zip(ei, mods))] for i, ei in enumerate(elems)}
    ord2 = [i for i in range(len(elems)) if i != zero and add[(i, i)] == zero]
    ord3 = [i for i in range(len(elems)) if i != zero and add[(add[(i, i)], i)] == zero]
    return elems, idx, zero, add, neg, ord2, ord3


def build(mods):
    elems, idx, zero, add, neg, ord2, ord3 = make(mods)
    N = len(elems)
    ground = [i for i in range(N) if i != zero]

    def sumfree(A):
        for a in A:
            for b in A:
                if add[(a, b)] in A:
                    return False
        return True

    @lru_cache(maxsize=None)
    def win(A):
        # True if player TO MOVE wins.
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2)) and not win(A2):
                return True
        return False

    return elems, idx, zero, add, neg, ord2, ord3, ground, sumfree, win


def label(elems, i):
    return "".join(str(c) for c in elems[i])


def trace(mods, hero_is_first, forced_opening=None, max_nodes=200000):
    """Explore the game with the hero following a winning strategy; record
    (opponent_last_move -> hero_move) descriptors to reveal the pattern."""
    elems, idx, zero, add, neg, ord2, ord3, ground, sumfree, win = build(mods)

    def descr(prev, mv):
        # describe hero move mv relative to opponent's last move prev
        tags = []
        if prev is not None:
            if mv == neg[prev]:
                tags.append("-x(neg)")
            for m in ord2:
                if mv == add[(prev, m)]:
                    tags.append(f"x+{label(elems,m)}(transl)")
        if mv in ord2:
            tags.append("ord2")
        if mv in ord3:
            tags.append("ord3")
        return ",".join(tags) if tags else "OTHER"

    records = []  # (depth, opp_move_lbl, hero_move_lbl, descr)
    seen = [0]

    def hero_move(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2)) and not win(A2):
                return x
        return None

    def rec(A, hero_turn, prev, depth):
        seen[0] += 1
        if seen[0] > max_nodes:
            return
        if hero_turn:
            mv = hero_move(A)
            if mv is None:
                return  # hero has no winning move here (shouldn't happen if won)
            records.append((depth, None if prev is None else label(elems, prev),
                            label(elems, mv), descr(prev, mv)))
            rec(A | frozenset([mv]), False, mv, depth + 1)
        else:
            # branch ALL opponent moves
            any_move = False
            for x in ground:
                if x in A:
                    continue
                A2 = A | frozenset([x])
                if sumfree(set(A2)):
                    any_move = True
                    rec(A2, True, x, depth + 1)
            # if no opponent move, opponent loses (good for hero)

    start = frozenset()
    if hero_is_first:
        rec(start, True, None, 0)
    else:
        if forced_opening is not None:
            # explore only the specified opening for readability, then all
            op = idx[forced_opening]
            rec(start | frozenset([op]), True, op, 1)
        else:
            rec(start, False, None, 0)
    return elems, ord2, ord3, records


def summarize(mods, hero_is_first, forced_opening=None):
    elems, ord2, ord3, records = trace(mods, hero_is_first, forced_opening)
    lbl = "x".join(f"Z{m}" for m in mods)
    print(f"=== {lbl}  hero={'FIRST' if hero_is_first else 'SECOND'}"
          + (f"  opening={forced_opening}" if forced_opening else "") + " ===")
    print(f"ord2={[ ''.join(map(str,elems[i])) for i in ord2]}  "
          f"ord3(count)={len(ord3)}")
    # tally descriptors
    from collections import Counter
    c = Counter(d for (_, _, _, d) in records)
    print("hero-move descriptor tally:", dict(c))
    # show first ~25 records
    for (depth, opp, hero, d) in records[:30]:
        print(f"  d{depth:2d} opp={opp!s:>6} -> hero={hero:>6}  [{d}]")
    print()


if __name__ == "__main__":
    # Case 4: s2=0, tau3=1, N -> hero is FIRST player. Z3xZ3.
    summarize((3, 3), hero_is_first=True)
    # Case 5: s2=1, tau3=1, P -> hero is SECOND player. Z2xZ3xZ3.
    # Show the hard branch: opponent opens the unique order-2 element m=(1,0,0).
    summarize((2, 3, 3), hero_is_first=False, forced_opening=(1, 0, 0))
    print("STRAT_DONE")
