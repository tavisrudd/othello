"""Bounded LOCAL-invariant confirmation of the translation-mirror lemmas that
power the s2>=2 => P proof (and the s2=1 non-m-opening reduction).

For a fixed order-2 element v, over all T_v-invariant sum-free sets A (BFS, capped):
  L2: every legal y (y != v) has reply y+v legal and A U {y,y+v} sum-free.
  L3: v is NOT legal from any NONEMPTY T_v-invariant A (self-blocks).
Plus the move-2 fact: {x, x+v} is sum-free iff x != v (checked over all x,v).
Report any violation. Zero violations => the mirror never gets stuck.
"""
import sys
from itertools import product

sys.setrecursionlimit(1 << 20)


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    N = len(elems)
    addm = [[idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]
             for j in range(N)] for i in range(N)]
    ord2 = [i for i in range(N) if i != zero and addm[i][i] == zero]
    return elems, idx, zero, addm, ord2, N


def sumfree(A, addm):
    for a in A:
        for b in A:
            if addm[a][b] in A:
                return False
    return True


def check(mods, cap=40000):
    elems, idx, zero, addm, ord2, N = make(mods)
    ground = [i for i in range(N) if i != zero]
    lbl = "x".join(f"Z{m}" for m in mods)
    if not ord2:
        print(f"  {lbl:14s}  (no order-2 element; skip)")
        return True

    # move-2 fact: {x,x+v} sum-free iff x != v, for all order-2 v and all x
    m2bad = 0
    for v in ord2:
        for x in ground:
            xv = addm[x][v]
            if xv == zero:
                continue
            sf = sumfree({x, xv}, addm)
            if sf != (x != v):
                m2bad += 1

    v = ord2[0]  # test the mirror with the first order-2 element
    l2bad = l3bad = 0
    tested = 0
    # genuine T_v-invariant sum-free sets NEVER contain v (its partner is 0,
    # unplayable), so seed ONLY the empty set and grow by adding {y, y+v} pairs.
    seen = {frozenset(): None}
    stack = [frozenset()]
    while stack:
        A = stack.pop()
        # L3: v not legal from nonempty A
        if A and (v not in A) and sumfree(set(A) | {v}, addm):
            l3bad += 1
        for y in ground:
            if y in A or y == v:
                continue
            if not sumfree(set(A) | {y}, addm):
                continue
            yv = addm[y][v]
            tested += 1
            A2 = frozenset(set(A) | {y, yv})
            if yv == zero or yv == y or not sumfree(A2, addm):
                l2bad += 1
            elif A2 not in seen and len(A2) < N and len(seen) < cap:
                seen[A2] = None
                stack.append(A2)
    ok = (m2bad == 0 and l2bad == 0 and l3bad == 0)
    print(f"  {lbl:14s} |ord2|={len(ord2):2d}  move2bad={m2bad}  "
          f"L2bad={l2bad}/{tested}  L3bad={l3bad}  symsets={len(seen)}  "
          f"{'OK' if ok else '*** VIOLATION ***'}")
    return ok


if __name__ == "__main__":
    print("=== translation-mirror local invariants (v = an order-2 element) ===")
    allok = True
    for mods in [(2,), (4,), (6,), (2, 2), (2, 4), (4, 4), (2, 2, 2),
                 (2, 2, 3), (2, 6), (2, 9), (2, 3, 3), (2, 2, 3, 3), (2, 15),
                 (8,), (10,), (2, 8)]:
        allok &= check(mods)
    print("ALL_OK" if allok else "SOME_VIOLATION")
    print("VERIFY_LOCAL_DONE")
