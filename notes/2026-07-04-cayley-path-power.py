"""Node-Kayles on the k-th power of a PATH P_m^k (a finite octal take-and-break game)
and the derived CYCLE outcome G(C_n^k).

Move at position i in a length-m run deletes [i-k, i+k] cap [0,m-1], splitting into
two independent shorter P^k runs:  left = max(0,i-k), right = max(0,m-1-i-k).
  g(m) = mex over i in 0..m-1 of  g(left) XOR g(right),   g(0)=0.

C_n^k first move (cycle, no ends) deletes exactly 2k+1 consecutive -> one run
P_{n-2k-1}^k, so  G(C_n^k) = 1  iff  g_path_k(n-2k-1) = 0.

Certify eventual periodicity via Guy-Smith: for a finite octal game whose largest
token-removal is r (=2k+1), if g(n)=g(n+p) holds for all n0 <= n <= 2*n0+p+r, then
g is periodic with period p and preperiod <= n0 for ALL n>=n0.
"""

import sys


def grundy_path(k, M):
    """g[0..M] for Node-Kayles on P_m^k."""
    g = [0] * (M + 1)
    for m in range(1, M + 1):
        seen = set()
        # option(i) is symmetric under i <-> m-1-i; scan half + middle.
        for i in range(m):
            L = i - k
            if L < 0:
                L = 0
            R = m - 1 - i - k
            if R < 0:
                R = 0
            seen.add(g[L] ^ g[R])
        mex = 0
        while mex in seen:
            mex += 1
        g[m] = mex
    return g


def find_period(g, r):
    """Return (p, n0, certified) for the smallest certified period, else None."""
    M = len(g) - 1
    best = None
    for p in range(1, M // 3):
        # minimal n0 such that g[n]==g[n+p] for all n0<=n<=M-p
        n0 = None
        ok_from = M - p
        n = M - p
        while n >= 1:
            if g[n] != g[n + p]:
                break
            ok_from = n
            n -= 1
        n0 = ok_from
        # Guy-Smith certification window: need M-p >= 2*n0 + p + r
        certified = (M - p) >= (2 * n0 + p + r)
        if certified:
            best = (p, n0, True)
            break
    return best


def cycle_outcome_from_path(g, k, n):
    """G(C_n^k) via the path reduction, for n >= 2k+1."""
    m = n - (2 * k + 1)
    if m < 0:
        # tiny cycle: all n<=2k => complete graph K_n (every pair within dist k
        # on the cycle when 2k>=n-1) => one move clears => G=1 for n>=1
        return 1
    return 1 if g[m] == 0 else 0


def brute_cycle(n, k):
    """Direct brute (validation) using the boolean circulant engine."""
    S = set()
    for d in range(1, k + 1):
        S.add(d % n)
        S.add((n - d) % n)
    S.discard(0)
    adj = []
    for v in range(n):
        mm = 1 << v
        for d in S:
            mm |= 1 << ((v + d) % n)
        adj.append(mm)
    memo = {}

    def outcome(live):
        if live == 0:
            return True
        r = memo.get(live)
        if r is not None:
            return r
        res = True
        mm = live
        while mm:
            v = (mm & -mm).bit_length() - 1
            mm &= mm - 1
            if outcome(live & ~adj[v]):
                res = False
                break
        memo[live] = res
        return res

    full = (1 << n) - 1
    return 1 if outcome(full & ~adj[0]) else 0


if __name__ == "__main__":
    M = int(sys.argv[1]) if len(sys.argv) > 1 else 6000
    for k in range(1, 5):
        r = 2 * k + 1
        g = grundy_path(k, M)
        maxv = max(g)
        res = find_period(g, r)
        print(f"\n=== k={k}  (P^k path game, r={r}, M={M}) ===")
        print(f"  g[0..30] = {g[:31]}")
        print(f"  max Grundy value = {maxv}")
        if res:
            p, n0, cert = res
            print(f"  PERIODIC: period p={p}, preperiod n0={n0}  "
                  f"(Guy-Smith CERTIFIED: {cert})")
            print(f"  period block g[n0..n0+p-1] = {g[n0:n0 + p]}")
            # zeros of g in one period => cycle N-positions
            zeros = [n0 + j for j in range(p) if g[n0 + j] == 0]
            print(f"  zero residues mod {p} (>= n0): "
                  f"{sorted(set((z) % p for z in zeros))}")
        else:
            print("  no certified period within M (increase M)")
        sys.stdout.flush()

    # Cross-check the path-derived cycle outcome vs direct brute, small n.
    print("\n=== cross-check G(C_n^k): path-reduction vs brute ===")
    g_by_k = {k: grundy_path(k, 200) for k in range(1, 5)}
    bad = 0
    for k in range(1, 5):
        for n in range(2 * k + 1, 40):
            a = cycle_outcome_from_path(g_by_k[k], k, n)
            b = brute_cycle(n, k)
            if a != b:
                bad += 1
                print(f"  MISMATCH k={k} n={n}: path={a} brute={b}")
    print(f"  mismatches = {bad}")
    print("\nPATH_POWER_DONE")
