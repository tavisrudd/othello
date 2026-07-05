"""Shared Node-Kayles engine for arithmetic Cayley graphs.

Graphs handled:
  - Paley_p / GP(p,k): Cayley(F_p, S) with S = nonzero k-th power residues mod p.
  - Peisert P*_q (q=p^2, p=3 mod 4): Cayley(F_q, S), S = { g^j : j = 0,1 mod 4 }.

Vertex-transitivity => G(root) in {0,1}, and G=1 iff the residual after deleting
N[0] (the closed neighborhood of one vertex) is a P-position (Grundy 0). So we only
need a boolean win/loss recursion (P=True/N=False), which short-circuits and never
materializes actual nimbers. This is much cheaper than full mex/Grundy while giving
the identical root verdict for vertex-transitive graphs.
"""

import sys

sys.setrecursionlimit(1_000_000)


class MemoCap(Exception):
    pass


# ---------------------------------------------------------------------------
# adjacency
# ---------------------------------------------------------------------------
def kth_power_residues(p, k):
    """Nonzero k-th power residues mod p (a subgroup of F_p^*)."""
    S = set()
    for x in range(1, p):
        S.add(pow(x, k, p))
    S.discard(0)
    return S


def cayley_adj_mod(p, S):
    """Closed-neighborhood bitmasks for Cay(Z_p, S). adj[v] includes v itself."""
    adj = []
    for v in range(p):
        m = 1 << v
        for d in S:
            m |= 1 << ((v + d) % p)
        adj.append(m)
    return adj


def cayley_adj_from_edges(n, nbrs):
    """Closed-neighborhood bitmasks from an explicit neighbor-list (len n)."""
    adj = []
    for v in range(n):
        m = 1 << v
        for u in nbrs[v]:
            m |= 1 << u
        adj.append(m)
    return adj


# ---------------------------------------------------------------------------
# win/loss (P/N) engine  --  True = P-position (Grundy 0)
# ---------------------------------------------------------------------------
def outcome(live, adj, memo, cap):
    if live == 0:
        return True  # empty: no move, current player loses => P-position
    r = memo.get(live)
    if r is not None:
        return r
    res = True  # P unless we find a child that is P (=> we are N)
    m = live
    while m:
        v = (m & -m).bit_length() - 1
        m &= m - 1
        if outcome(live & ~adj[v], adj, memo, cap):
            res = False
            break
    memo[live] = res
    if cap and len(memo) > cap:
        raise MemoCap()
    return res


def game_G(adj, n, memo=None, cap=0):
    """G in {0,1} for a vertex-transitive graph of n vertices with adjacency adj.
    G=1 iff residual after deleting N[0] is a P-position."""
    if memo is None:
        memo = {}
    full = (1 << n) - 1
    child_is_P = outcome(full & ~adj[0], adj, memo, cap)
    return (1 if child_is_P else 0), len(memo)


# ---------------------------------------------------------------------------
# full-Grundy engine (validation cross-check only; slower)
# ---------------------------------------------------------------------------
def grundy(live, adj, memo):
    if live == 0:
        return 0
    r = memo.get(live)
    if r is not None:
        return r
    opts = set()
    m = live
    while m:
        v = (m & -m).bit_length() - 1
        m &= m - 1
        opts.add(grundy(live & ~adj[v], adj, memo))
    g = 0
    while g in opts:
        g += 1
    memo[live] = g
    return g


def game_G_grundy(adj, n):
    full = (1 << n) - 1
    child = grundy(full & ~adj[0], adj, {})
    return 1 if child == 0 else 0


# ---------------------------------------------------------------------------
# small helpers
# ---------------------------------------------------------------------------
def primes_up_to(N):
    sieve = bytearray([1]) * (N + 1)
    sieve[0] = sieve[1] = 0
    for i in range(2, int(N**0.5) + 1):
        if sieve[i]:
            sieve[i * i :: i] = b"\x00" * len(sieve[i * i :: i])
    return [i for i in range(2, N + 1) if sieve[i]]
