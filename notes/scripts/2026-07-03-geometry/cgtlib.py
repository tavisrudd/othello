"""Small-board Node-Kayles lab: queens/torus/knights, Grundy, pairings."""
import sys
sys.setrecursionlimit(100000)

def queen_attacks(n, wrap=False):
    """attack[s] = bitmask of closed neighborhood of square s (includes s)."""
    N = n * n
    att = [0] * N
    for r in range(n):
        for c in range(n):
            s = r * n + c
            m = 0
            for r2 in range(n):
                for c2 in range(n):
                    t = r2 * n + c2
                    if wrap:
                        hit = (r == r2 or c == c2 or (r - c) % n == (r2 - c2) % n
                               or (r + c) % n == (r2 + c2) % n)
                    else:
                        hit = (r == r2 or c == c2 or r - c == r2 - c2
                               or r + c == r2 + c2)
                    if hit:
                        m |= 1 << t
            att[s] = m
    return att

def knight_attacks(n):
    N = n * n
    att = [0] * N
    for r in range(n):
        for c in range(n):
            s = r * n + c
            m = 1 << s
            for dr, dc in ((1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)):
                r2, c2 = r + dr, c + dc
                if 0 <= r2 < n and 0 <= c2 < n:
                    m |= 1 << (r2 * n + c2)
            att[s] = m
    return att

def make_grundy(att, N):
    memo = {}
    def g(avail):
        if avail == 0:
            return 0
        v = memo.get(avail)
        if v is not None:
            return v
        seen = set()
        a = avail
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            seen.add(g(avail & ~att[s]))
        v = 0
        while v in seen:
            v += 1
        memo[avail] = v
        return v
    return g, memo

def make_win(att, N):
    memo = {}
    def w(avail):
        if avail == 0:
            return False
        v = memo.get(avail)
        if v is not None:
            return v
        a = avail
        res = False
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            if not w(avail & ~att[s]):
                res = True
                break
        memo[avail] = res
        return res
    return w, memo

def bits(m):
    while m:
        b = m & -m
        yield b.bit_length() - 1
        m ^= b

def diag_mask(n):
    m = 0
    for i in range(n):
        m |= 1 << (i * n + i)
        m |= 1 << (i * n + (n - 1 - i))
    return m

def rho(n, s):
    r, c = divmod(s, n)
    return (n - 1 - r) * n + (n - 1 - c)

# ---- closed pairing search ----
def closed_pairing(verts, att):
    """Search a perfect matching pi on verts (list of square ids) with:
       (a) u not adjacent to pi(u); (b) for every two pairs {u,v},{a,b}:
       u in N[a]|N[b] <=> v in N[a]|N[b], and a in N[u]|N[v] <=> b in N[u]|N[v].
       Returns a matching (list of pairs) or None."""
    verts = sorted(verts)
    if len(verts) % 2:
        return None
    vs = set(verts)
    def compat(p, q):
        (u, v), (a, b) = p, q
        nab = att[a] | att[b]
        nuv = att[u] | att[v]
        if bool(nab >> u & 1) != bool(nab >> v & 1):
            return False
        if bool(nuv >> a & 1) != bool(nuv >> b & 1):
            return False
        return True
    def rec(unmatched, pairs):
        if not unmatched:
            return list(pairs)
        u = unmatched[0]
        rest = unmatched[1:]
        for i, v in enumerate(rest):
            if att[u] >> v & 1:
                continue
            p = (u, v)
            if all(compat(p, q) for q in pairs):
                r = rec(rest[:i] + rest[i+1:], pairs + [p])
                if r is not None:
                    return r
        return None
    return rec(verts, [])
