"""Improved sum-free game solver: multiplier-symmetry quotient (x -> u*x, u a unit,
preserves sum-freeness => Grundy-preserving) + incremental addable.  Extends the Z_n
nimber sequence and firms the mod-6 outcome law.  Also an outcome-only (P/N) fast path.
"""

import sys

sys.setrecursionlimit(1_000_000)


def gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def units(n):
    return [u for u in range(1, n) if gcd(u, n) == 1]


def canon(A, n, us):
    """lex-min bitmask over the multiplier orbit {u*A}."""
    best = A
    for u in us:
        B = 0
        x = A
        while x:
            i = (x & -x).bit_length() - 1
            x &= x - 1
            B |= 1 << ((u * i) % n)
        if B < best:
            best = B
    return best


def addable_list(A, n):
    elts = [i for i in range(n) if (A >> i) & 1]
    Aset = set(elts)
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
        if x in ApA or x in AmA:
            continue
        if (2 * x) % n in Aset:
            continue
        out.append(x)
    return out


def grundy_q(n):
    us = units(n)
    memo = {}

    def g(A):  # A canonical
        r = memo.get(A)
        if r is not None:
            return r
        opts = set()
        for x in addable_list(A, n):
            opts.add(g(canon(A | (1 << x), n, us)))
        m = 0
        while m in opts:
            m += 1
        memo[A] = m
        return m

    return g(0), len(memo)


def outcome_q(n):
    """P/N only (True=P), boolean short-circuit -> cheaper, higher reach."""
    us = units(n)
    memo = {}

    def is_P(A):  # canonical; True if position is a P-position (mover loses)
        r = memo.get(A)
        if r is not None:
            return r
        res = True  # P unless a move leads to a P-child (=> N)
        for x in addable_list(A, n):
            if is_P(canon(A | (1 << x), n, us)):
                res = False
                break
        memo[A] = res
        return res

    p = is_P(0)
    return (0 if p else "N>0"), len(memo)


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "grundy"
    nmax = int(sys.argv[2]) if len(sys.argv) > 2 else 46
    if mode == "grundy":
        print("Sum-free game Z_n, Grundy(empty), multiplier-quotient solver:")
        seq = []
        for n in range(1, nmax + 1):
            g, msz = grundy_q(n)
            seq.append(g)
            pred = "P" if (n % 6 in (0, 1, 5)) else "N"
            got = "P" if g == 0 else "N"
            flag = "" if pred == got else "  <<< LAW BREAKS"
            print(f"  n={n:>2}: G={g}  memo={msz:>8}  mod6={n%6} law={pred} obs={got}{flag}")
            sys.stdout.flush()
        print(f"SEQ {seq}")
    elif mode == "outcome":
        print("Sum-free game Z_n, OUTCOME only (P/N), quotient solver:")
        broke = []
        for n in range(1, nmax + 1):
            o, msz = outcome_q(n)
            pred = "P" if (n % 6 in (0, 1, 5)) else "N"
            got = "P" if o == 0 else "N"
            if pred != got:
                broke.append(n)
            print(f"  n={n:>2}: {got}  memo={msz:>9}  mod6={n%6} law={pred}"
                  f"{'  <<< BREAKS' if pred != got else ''}")
            sys.stdout.flush()
        print(f"law holds n=1..{nmax}: {'YES' if not broke else 'NO at '+str(broke)}")
    print("IMPROVED_DONE")
