import sys

sys.setrecursionlimit(1_000_000)


def paley_adj(p):
    qr = {(x * x) % p for x in range(1, p)}
    adj = []
    for v in range(p):
        m = 1 << v
        for d in qr:
            m |= 1 << ((v + d) % p)
        adj.append(m)
    return adj, qr


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


for p in [5, 13, 17, 29, 37, 41]:
    adj, qr = paley_adj(p)
    two_qr = 2 in qr
    full = (1 << p) - 1
    memo = {}
    # vertex-transitive: single root-child value decides G in {0,1}
    child = grundy(full & ~adj[0], adj, memo)
    g_root = 1 if child == 0 else 0
    print(
        f"p={p:3d}  p mod 8 = {p % 8}  2 QR: {str(two_qr):5s}  "
        f"child G = {child}  =>  G(Paley_{p}) = {g_root}  (memo {len(memo)})"
    )
