"""Lemma R attack (s2=0 side): does the COMBINED strategy win for the first
player on s2=0, tau3=1 groups?

Combined first-player strategy sigma*:
  - opening: a winning FIRST move t0 of the F3^r sum-free B-game on T\\{0}
    (T = G[3], the order-3 subgroup).
  - response to opponent z:
      z order-3  -> the B-game winning RESPONSE (keeps the B-position a
                    B-P-position; exists since a P-position's child is an N-pos).
      z else     -> -z (negation mirror on the 'good' part).
Claim: sigma*'s response is ALWAYS legal in the full group G => first player
never gets stuck => first player makes the last move => N. Test by branching
ALL opponent play (memoized on the G-position); report any illegal response.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    N = len(elems)
    addm = [[idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]
             for j in range(N)] for i in range(N)]
    negm = [idx[tuple((-a) % m for a, m in zip(e, mods))] for e in elems]
    dbl = [addm[i][i] for i in range(N)]
    ord3 = [i for i in range(N) if i != zero and addm[dbl[i]][i] == zero]
    ord2 = [i for i in range(N) if i != zero and dbl[i] == zero]
    return elems, idx, zero, addm, negm, ord3, ord2, N


def sumfree(A, addm):
    for a in A:
        for b in A:
            if addm[a][b] in A:
                return False
    return True


def bgame_oracle(Tset, addm):
    """Solver for the sum-free game restricted to ground set Tset (order-3 elts).
    Returns win(frozenset)->bool and a winmove(frozenset)->elt (to a P-position)."""
    Tlist = tuple(sorted(Tset))

    @lru_cache(maxsize=None)
    def win(A):
        for x in Tlist:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2), addm) and not win(A2):
                return True
        return False

    def winmoves(A):
        # ALL B-winning responses (children that are B-P-positions)
        out = []
        for x in Tlist:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2), addm) and not win(A2):
                out.append(x)
        return out
    return win, winmoves


def test(mods, cap=3000000):
    elems, idx, zero, addm, negm, ord3, ord2, N = make(mods)
    assert not ord2, f"{mods}: s2!=0"
    assert ord3, f"{mods}: tau3=0"
    ground = [i for i in range(N) if i != zero]
    Tset = set(ord3)
    bwin, bwinmoves = bgame_oracle(Tset, addm)
    assert bwin(frozenset()), f"{mods}: B-game (F3^r) is not N!"

    def legal(A, x):
        return x != zero and x not in A and sumfree(set(A) | {x}, addm)

    def response(A, z):
        # first player's combined-strategy reply after opponent played z into A
        if z in Tset:
            PB = frozenset(a for a in A if a in Tset)   # includes z
            cands = bwinmoves(PB)
            # LEGALITY-AWARE: prefer a B-winning response that is also G-legal
            for w in cands:
                if legal(A, w):
                    return w
            return cands[0] if cands else None
        else:
            return negm[z]

    fails = [0]
    nodes = [0]
    seen = set()

    def branch_opponent(A):
        # opponent to move in A; branch all; after each, first player responds
        nodes[0] += 1
        if nodes[0] > cap or A in seen:
            return
        seen.add(A)
        moved = False
        for z in ground:
            if not legal(A, z):
                continue
            moved = True
            A1 = frozenset(set(A) | {z})
            w = response(A1, z)
            if w is None or not legal(A1, w):
                fails[0] += 1
                if fails[0] <= 4:
                    zk = "".join(map(str, elems[z]))
                    wk = "None" if w is None else "".join(map(str, elems[w]))
                    print(f"    FAIL {mods}: A={[ ''.join(map(str,elems[a])) for a in A1]} "
                          f"opp={zk}({'ord3' if z in Tset else 'good'}) reply={wk}")
                continue
            A2 = frozenset(set(A1) | {w})
            branch_opponent(A2)
        # if not moved: opponent stuck -> first player won this line (fine)

    # opening t0 = B-game first winning move
    t0 = bwinmoves(frozenset())[0]
    branch_opponent(frozenset([t0]))
    lbl = "x".join(f"Z{m}" for m in mods)
    print(f"  {lbl:12s} |ord3|={len(ord3):2d} opening={''.join(map(str,elems[t0]))}"
          f" nodes={nodes[0]:6d}  fails={fails[0]}  "
          f"{'COMBINED STRATEGY WINS' if fails[0]==0 else '*** FAILS ***'}")
    return fails[0] == 0


if __name__ == "__main__":
    print("=== Lemma R (s2=0 side): combined B-game + negation-mirror strategy ===")
    for mods in [(3, 3), (5, 3, 3), (7, 3, 3)]:  # elementary Sylow-3 + coprime part
        try:
            test(mods)
        except AssertionError as e:
            print(f"  skip {mods}: {e}")
    print("LEMMAR_DONE")
