"""Game (b): the impartial SUM-FREE / CAP-SET achievement game (hypergraph Node-Kayles).

Sum-free game on Z_n:
  Position = a sum-free set A subset Z_n  (A cap (A+A) = empty, a=b allowed so 2a notin A).
  Move     = add x notin A with A u {x} still sum-free.  Normal play: last to move wins.
  Sequence = Grundy value of the EMPTY position, as a function of n.  (0 never playable: 0+0=0.)

Cap-set game on F_3^d:
  Position = a cap C subset F_3^d (no a+b+c=0 with a,b,c distinct in C).
  Move     = add a point keeping it a cap.  Grundy of the empty cap, per d.

Both are subset-state DAGs -> the RAM-gated solver the DECISION parked.
"""

import sys

sys.setrecursionlimit(1_000_000)


# ---------------------------------------------------------------------------
# Z_n sum-free game
# ---------------------------------------------------------------------------
def addable_Zn(A, n, elts):
    """x addable to sum-free set A (bitmask) iff A u {x} stays sum-free.
    Conditions: x notin A; x notin A+A; x notin A-A (no a+x=b); 2x notin A."""
    ApA = set()
    AmA = set()
    for a in elts:
        for b in elts:
            ApA.add((a + b) % n)
            AmA.add((a - b) % n)
    out = []
    for x in range(1, n):
        if (A >> x) & 1:
            continue
        if x in ApA:
            continue
        if x in AmA:
            continue
        if (2 * x) % n in {a for a in elts}:  # 2x lands in A
            continue
        out.append(x)
    return out


def is_sum_free(mask, n):
    elts = [i for i in range(n) if (mask >> i) & 1]
    s = set(elts)
    for i, a in enumerate(elts):
        for b in elts[i:]:
            if (a + b) % n in s:
                return False
    return True


def sumfree_grundy(n):
    memo = {}

    def g(A):
        r = memo.get(A)
        if r is not None:
            return r
        elts = [i for i in range(n) if (A >> i) & 1]
        opts = set()
        for x in addable_Zn(A, n, elts):
            opts.add(g(A | (1 << x)))
        m = 0
        while m in opts:
            m += 1
        memo[A] = m
        return m

    val = g(0)
    return val, len(memo)


# ---------------------------------------------------------------------------
# F_3^d cap-set game
# ---------------------------------------------------------------------------
def cap_grundy(d):
    pts = []
    for i in range(3 ** d):
        v = []
        x = i
        for _ in range(d):
            v.append(x % 3)
            x //= 3
        pts.append(tuple(v))
    idx = {p: i for i, p in enumerate(pts)}
    N = 3 ** d

    def third(a, b):
        # the unique c with a+b+c=0 in F_3^d, i.e. c = -(a+b) = (2a+2b)
        return tuple((-(pa + pb)) % 3 for pa, pb in zip(pts[a], pts[b]))

    memo = {}

    def addable(C):
        elts = [i for i in range(N) if (C >> i) & 1]
        blocked = set()
        for i in range(len(elts)):
            for j in range(i + 1, len(elts)):
                blocked.add(idx[third(elts[i], elts[j])])
        out = []
        for x in range(N):
            if (C >> x) & 1:
                continue
            if x in blocked:
                continue
            out.append(x)
        return out

    def g(C):
        r = memo.get(C)
        if r is not None:
            return r
        opts = set()
        for x in addable(C):
            opts.add(g(C | (1 << x)))
        m = 0
        while m in opts:
            m += 1
        memo[C] = m
        return m

    return g(0), len(memo)


if __name__ == "__main__":
    what = sys.argv[1] if len(sys.argv) > 1 else "zn"
    if what == "validate":
        # cross-check addable-fast vs direct is_sum_free on random sets
        import itertools
        bad = 0
        for n in range(3, 14):
            for A in range(0, 1 << n, max(1, (1 << n) // 400)):
                if not is_sum_free(A, n):
                    continue
                elts = [i for i in range(n) if (A >> i) & 1]
                fast = set(addable_Zn(A, n, elts))
                slow = set(x for x in range(1, n)
                           if not (A >> x) & 1 and is_sum_free(A | (1 << x), n))
                if fast != slow:
                    bad += 1
                    print(f"  MISMATCH n={n} A={elts} fast={sorted(fast)} slow={sorted(slow)}")
        print(f"validate: mismatches={bad}")
    elif what == "zn":
        nmax = int(sys.argv[2]) if len(sys.argv) > 2 else 22
        print("Sum-free game on Z_n: Grundy(empty) sequence")
        seq = []
        for n in range(1, nmax + 1):
            g, msz = sumfree_grundy(n)
            seq.append(g)
            print(f"  n={n:>2}: G={g}   (memo={msz})")
            sys.stdout.flush()
        print(f"SEQ {seq}")
    elif what == "cap":
        dmax = int(sys.argv[2]) if len(sys.argv) > 2 else 3
        print("Cap-set game on F_3^d: Grundy(empty)")
        for d in range(1, dmax + 1):
            g, msz = cap_grundy(d)
            print(f"  d={d}: G={g}   (memo={msz}, |F_3^d|={3**d})")
            sys.stdout.flush()
    print("SUMFREE_DONE")
