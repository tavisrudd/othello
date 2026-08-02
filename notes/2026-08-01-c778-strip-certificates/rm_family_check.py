from itertools import combinations

def rm_basis(r, m):
    n = 1 << m
    # coordinate functions x_i over all points
    xs = [[(p >> i) & 1 for p in range(n)] for i in range(m)]
    basis = []
    for d in range(r + 1):
        for S in combinations(range(m), d):
            v = [1] * n
            for i in S:
                v = [a & b for a, b in zip(v, xs[i])]
            basis.append(v)
    return basis

def wt(v): return sum(v)
def andv(*vs): 
    out = vs[0]
    for v in vs[1:]: out = [a & b for a, b in zip(out, v)]
    return out

def triply_even_basis_criterion(r, m):
    B = rm_basis(r, m)
    k = len(B)
    for g in B:
        if wt(g) % 8: return False, "single", k
    for i, j in combinations(range(k), 2):
        if wt(andv(B[i], B[j])) % 4: return False, "pair", k
    for i, j, l in combinations(range(k), 3):
        if wt(andv(B[i], B[j], B[l])) % 2: return False, "triple", k
    return True, "ok", k

for (r, m) in [(1,4), (2,7), (2,6), (1,3)]:
    ok, where, k = triply_even_basis_criterion(r, m)
    n = 1 << m
    dC, dperp = 1 << (m - r), 1 << (r + 1)
    U = min(dC, dperp) - 1
    print(f"RM({r},{m}): n={n} k={k} triply-even={ok} ({where})  d={dC} dperp={dperp} U={U}")
