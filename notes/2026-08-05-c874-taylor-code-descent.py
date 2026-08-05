#!/usr/bin/env python3
"""C874 -- the code-level fold is a formal property of Taylor doubles, not of quadrics.

Claim tested (derived on paper in the C874 report).  Let Gamma be ANY graph on
m vertices, T its Taylor double (vertices (x,i), i in {0,1}; (x,i) ~ (y,j) for
x != y iff (x ~ y and i = j) or (x !~ y and i != j)), and That the Taylor
double with the antipodal matching added ((x,0) ~ (x,1)).  Give any graph X
the "graph code" C(X) = span_F2 {all-ones, rows of the adjacency matrix}.
Then:

  (a) every adjacency row of That has fibre-difference all-ones, so the
      fibre-constant subcode of C(That) is exactly constants plus even sums
      of rows, of codimension one;
  (b) folding each antipodal fibre to one coordinate sends that subcode onto
      <1> + A_Gamma . (even-weight coefficient vectors), which is either
      C(Gamma) or its index-two subcode.

No quadratic form appears anywhere.  The script verifies (a) and (b) for
arbitrary graphs (Paley graphs plus an isolated vertex, the pentagon, seeded
pseudo-random graphs), and separately verifies that the quadric root-link
fold of C682/C872 is the special case: the induced link graph (Gosset plus
antipodal edges at rank 8) has graph code equal to the restricted affine
code, and its fold reproduces the next-level code on the nose.

Consequence recorded: the code-level residue left open by C871 ("corollary
or extra fact") is a corollary; the discovery-track lead "a non-quadratic
family satisfying the coclique condition would give a new code tower" is a
mirage at the code level, because the descent works for every graph and the
folded codes are ordinary graph codes of the base.

Replay:  python3 notes/2026-08-05-c874-taylor-code-descent.py --check
Standard library only; the pseudo-random graphs use a fixed-seed LCG.
"""
import json, sys, os, hashlib
from collections import Counter

# ------------------------------------------------------------ F2 linear algebra
def reduce2(basis, v):
    while v:
        p = v.bit_length() - 1
        if p in basis:
            v ^= basis[p]
        else:
            return v
    return 0

def rref2(rows):
    basis = {}
    for r in rows:
        r = reduce2(basis, r)
        if r:
            basis[r.bit_length() - 1] = r
    for piv in sorted(basis, reverse=True):
        for p2 in list(basis):
            if p2 != piv and (basis[p2] >> piv) & 1:
                basis[p2] ^= basis[piv]
    return basis

def nullspace2(eqs, nvars):
    basis = rref2(eqs)
    pivs = set(basis)
    out = []
    for f in range(nvars):
        if f in pivs:
            continue
        v = 1 << f
        for p, row in basis.items():
            if (row >> f) & 1:
                v |= 1 << p
        out.append(v)
    return out

def span_equal(a, b):
    return rref2(a) == rref2(b)

def weight_distribution(basis_rows):
    rows = list(basis_rows)
    k = len(rows)
    cnt = Counter()
    for m in range(1 << k):
        v = 0
        mm, t = m, 0
        while mm:
            if mm & 1:
                v ^= rows[t]
            mm >>= 1
            t += 1
        cnt[bin(v).count('1')] += 1
    return dict(sorted(cnt.items()))

# ------------------------------------------------------------ graph machinery
def graph_code(adj):
    """adj: list of int bitmasks (no self-loops). Returns rref basis of <1, rows>."""
    m = len(adj)
    return rref2([(1 << m) - 1] + list(adj))

def taylor_hat(adj):
    """Taylor double of the given graph plus the antipodal matching."""
    m = len(adj)
    T = [0] * (2 * m)
    for x in range(m):
        for y in range(m):
            if x == y:
                continue
            e = (adj[x] >> y) & 1
            for i in (0, 1):
                for j in (0, 1):
                    if (e and i == j) or (not e and i != j):
                        T[2 * x + i] |= 1 << (2 * y + j)
        T[2 * x] |= 1 << (2 * x + 1)
        T[2 * x + 1] |= 1 << (2 * x)
    return T

def fibre_constant_fold(code_basis, m):
    """Subcode of words with equal bits on each fibre {2x, 2x+1}, folded to length m."""
    rows = list(code_basis.values())
    k = len(rows)
    eqs = []
    for x in range(m):
        eq = 0
        for t in range(k):
            if ((rows[t] >> (2 * x)) & 1) ^ ((rows[t] >> (2 * x + 1)) & 1):
                eq |= 1 << t
        if eq:
            eqs.append(eq)
    folded = []
    subdim = 0
    for coef in nullspace2(eqs, k):
        v = 0
        mm, t = coef, 0
        while mm:
            if mm & 1:
                v ^= rows[t]
            mm >>= 1
            t += 1
        subdim += 1
        w = 0
        for x in range(m):
            if (v >> (2 * x)) & 1:
                w |= 1 << x
        folded.append(w)
    return rref2(folded), subdim

def descent_case(name, adj):
    """Run the general lemma checks on one base graph (already includes any
    isolated vertex); returns a report dict."""
    m = len(adj)
    That = taylor_hat(adj)
    CT = graph_code(That)
    # (a) every row of That has fibre-difference all-ones
    for r in That:
        for x in range(m):
            assert ((r >> (2 * x)) & 1) ^ ((r >> (2 * x + 1)) & 1) == 1, name
    folded, subdim = fibre_constant_fold(CT, m)
    assert subdim == len(CT) - 1, (name, subdim, len(CT))  # codimension one
    base_full = graph_code(adj)
    ones = (1 << m) - 1
    even = [ones] + [adj[0] ^ adj[y] for y in range(1, m)]
    base_even = rref2(even)
    assert folded == base_even, name  # the derived identity (b)
    full_descent = folded == base_full
    rep = {
        'base_vertices': m,
        'code_dim_taylor_hat': len(CT),
        'fibre_constant_subcode_dim': subdim,
        'folded_dim': len(folded),
        'base_graph_code_dim': len(base_full),
        'full_descent': full_descent,
    }
    if len(folded) <= 16:
        rep['folded_weight_distribution'] = {str(k): v for k, v in
                                             weight_distribution(folded.values()).items()}
    return rep

# ------------------------------------------------------------ base graphs
def pentagon():
    adj = [0] * 5
    for x in range(5):
        for y in ((x + 1) % 5, (x - 1) % 5):
            adj[x] |= 1 << y
    return adj

def paley_prime(q):
    sq = {(x * x) % q for x in range(1, q)}
    adj = [0] * q
    for a in range(q):
        for b in range(q):
            if a != b and (a - b) % q in sq:
                adj[a] |= 1 << b
    return adj

def paley_prime_power_9():
    # GF(9) = F3[t]/(t^2+1); elements (a,b) = a + bt
    els = [(a, b) for a in range(3) for b in range(3)]
    idx = {e: i for i, e in enumerate(els)}
    def mul(u, v):
        a, b = u; c, d = v
        return ((a * c - b * d) % 3, (a * d + b * c) % 3)
    sq = {mul(e, e) for e in els if e != (0, 0)}
    adj = [0] * 9
    for u in els:
        for v in els:
            if u != v:
                diff = ((u[0] - v[0]) % 3, (u[1] - v[1]) % 3)
                if diff in sq:
                    adj[idx[u]] |= 1 << idx[v]
    return adj

def paley_prime_power_25():
    # GF(25) = F5[t]/(t^2-2)
    els = [(a, b) for a in range(5) for b in range(5)]
    idx = {e: i for i, e in enumerate(els)}
    def mul(u, v):
        a, b = u; c, d = v
        return ((a * c + 2 * b * d) % 5, (a * d + b * c) % 5)
    sq = {mul(e, e) for e in els if e != (0, 0)}
    adj = [0] * 25
    for u in els:
        for v in els:
            if u != v:
                diff = ((u[0] - v[0]) % 5, (u[1] - v[1]) % 5)
                if diff in sq:
                    adj[idx[u]] |= 1 << idx[v]
    return adj

def with_isolated(adj):
    return list(adj) + [0]

def lcg_graph(n, seed):
    s = seed
    adj = [0] * n
    for x in range(n):
        for y in range(x + 1, n):
            s = (s * 6364136223846793005 + 1442695040888963407) % (1 << 64)
            if (s >> 33) & 1:
                adj[x] |= 1 << y
                adj[y] |= 1 << x
    return adj

# ------------------------------------------------------------ quadric sanity
def quadric_case(half):
    """Plus-type rank 2*half quadric in packed coordinates; root-link fold."""
    n = 2 * half
    mask = (1 << half) - 1
    def Q(v):
        return bin((v & mask) & (v >> half)).count('1') & 1
    pts = [v for v in range(1 << n) if Q(v)]
    def B(u, v):
        return Q(u ^ v) ^ Q(u) ^ Q(v)
    alpha = pts[0]
    link = [u for u in pts if B(alpha, u)]
    li = {u: i for i, u in enumerate(link)}
    L = len(link)
    # induced link graph, adjacency B(u,v)=1 (includes the antipodal edges)
    adj = [0] * L
    for i, u in enumerate(link):
        for j, v in enumerate(link):
            if i != j and B(u, v):
                adj[i] |= 1 << j
    # restricted affine code: constants + all linear functionals B(a,.)|link
    rows = [(1 << L) - 1]
    for a in range(1, 1 << n):
        r = 0
        for i, u in enumerate(link):
            if Q(a ^ u) ^ Q(a) ^ Q(u):
                r |= 1 << i
        rows.append(r)
    restricted_affine = rref2(rows)
    gc = graph_code(adj)
    graph_code_equals_restricted_affine = (gc == restricted_affine)
    # fold along fibres {u, u+alpha}; reindex so fibres are (2x, 2x+1)
    fibres = []
    seen = set()
    for u in link:
        if u in seen:
            continue
        v = u ^ alpha
        fibres.append((u, v))
        seen.add(u)
        seen.add(v)
    order = []
    for (u, v) in fibres:
        order.append(li[u])
        order.append(li[v])
    inv = {old: new for new, old in enumerate(order)}
    def remap(r):
        w = 0
        for old in range(L):
            if (r >> old) & 1:
                w |= 1 << inv[old]
        return w
    gc_re = rref2([remap(r) for r in gc.values()])
    folded, subdim = fibre_constant_fold(gc_re, L // 2)
    wd = weight_distribution(folded.values())
    return {
        'rank': n,
        'points': len(pts),
        'link': L,
        'graph_code_equals_restricted_affine': graph_code_equals_restricted_affine,
        'restricted_affine_dim': len(restricted_affine),
        'folded_dim': len(folded),
        'folded_weight_distribution': {str(k): v for k, v in wd.items()},
    }

# ---------------------------------------------------------------------- main
def main():
    check = '--check' in sys.argv
    report = {'cases': {}}

    q8 = quadric_case(4)
    assert q8['points'] == 120 and q8['link'] == 56
    assert q8['graph_code_equals_restricted_affine']
    assert q8['folded_dim'] == 7
    assert q8['folded_weight_distribution'] == {'0': 1, '12': 63, '16': 63, '28': 1}
    report['cases']['quadric_plus_rank8'] = q8

    q6 = quadric_case(3)
    assert q6['points'] == 28 and q6['link'] == 12
    assert q6['folded_dim'] == 5
    report['cases']['quadric_plus_rank6'] = q6

    general = {
        'pentagon_plus_isolated': with_isolated(pentagon()),
        'paley9_plus_isolated': with_isolated(paley_prime_power_9()),
        'paley13_plus_isolated': with_isolated(paley_prime(13)),
        'paley25_plus_isolated': with_isolated(paley_prime_power_25()),
        'random_n8_seed1': lcg_graph(8, 1),
        'random_n11_seed2': lcg_graph(11, 2),
        'random_n13_seed3': lcg_graph(13, 3),
    }
    for name, adj in general.items():
        report['cases'][name] = descent_case(name, adj)

    report['lemma'] = (
        'For every tested graph, each adjacency row of the matched Taylor double '
        'has fibre-difference all-ones, the fibre-constant subcode has codimension '
        'one, and its fold equals <1> + A.(even coefficient vectors); the descent '
        'is a formal property of Taylor doubles, with no quadratic-form input.')

    out = json.dumps(report, indent=1, sort_keys=True)
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        '2026-08-05-c874-taylor-code-descent.json')
    if check and os.path.exists(path):
        with open(path) as fh:
            prev = fh.read()
        if json.loads(prev) != report:
            print('MISMATCH against tracked certificate', file=sys.stderr)
            sys.exit(1)
        print('certificate matches; sha256 =',
              hashlib.sha256(prev.encode()).hexdigest())
    else:
        with open(path, 'w') as fh:
            fh.write(out)
        print('wrote', path)
    print(out)

if __name__ == '__main__':
    main()
