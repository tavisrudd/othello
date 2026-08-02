import numpy as np, itertools, random
random.seed(11); np.random.seed(11)

popcount = bin

def wt(x): return bin(x).count('1')

# ---------- codes ----------
def span_from_basis(basis):
    S = [0]
    for g in basis:
        S += [s ^ g for s in S]
    return S

def rm(r, m):
    n = 2**m; pts = list(itertools.product([0,1], repeat=m))
    basis = [ (1 << n) - 1 & sum(1 << i for i in range(n)) ]  # constant
    basis = [sum(1 << i for i in range(n))]
    for d in range(1, r+1):
        for idx in itertools.combinations(range(m), d):
            basis.append(sum((np.prod([pts[i][a] for a in idx]) & 1) << i for i in range(n)))
    return basis, n

# extended Golay [24,12,8] from cyclic [23,12,7], g(x)=x^11+x^10+x^6+x^5+x^4+x^2+1
def golay24():
    g = (1<<11)|(1<<10)|(1<<6)|(1<<5)|(1<<4)|(1<<2)|1
    basis23 = [g << i for i in range(12)]
    # reduce nothing needed; extend by parity
    basis = []
    for b in basis23:
        b24 = b | (wt(b) % 2) << 23
        basis.append(b24)
    return basis, 24

def check_code(basis, n, name):
    S = span_from_basis(basis)
    wts = sorted({wt(x) for x in S})
    # self-orthogonality check
    so = all(wt(a & b) % 2 == 0 for a in basis for b in basis)
    print(f"{name}: dim {len(basis)}, n {n}, weights {wts}, self-orth gens {so}")
    return S

gG, nG = golay24()
SG = check_code(gG, nG, "Golay [24,12]")
gR, nR = rm(2,5)
SR = check_code(gR, nR, "RM(2,5) [32,16]")

# ---------- triply-even subspace machinery ----------
# subspace triply-even  <=>  on a basis: wt(gi) % 8 == 0, wt(gi&gj) % 4 == 0, wt(gi&gj&gk) % 2 == 0
def can_add(c, basis):
    if wt(c) % 8: return False
    for i,a in enumerate(basis):
        if wt(c & a) % 4: return False
        for b in basis[i+1:]:
            if wt(c & a & b) % 2: return False
    return True

def dual_distance(basis, n):
    """min weight dependency among columns of generator matrix = d(C^perp), meet in middle"""
    k = len(basis)
    cols = [sum(((basis[i] >> j) & 1) << i for i in range(k)) for j in range(n)]
    half = n // 2
    best = n + 1
    # enumerate subsets of first half, store min popcount per syndrome
    from collections import defaultdict
    d1 = {}
    for mask in range(1 << half):
        s = 0; m = mask
        # incremental would be faster; n<=32 so 2^16 max, fine with gray-ish simple loop
        w = bin(mask).count('1')
        if w >= best: continue
        mm = mask; 
        while mm:
            j = (mm & -mm).bit_length() - 1
            s ^= cols[j]; mm &= mm - 1
        if s not in d1 or d1[s] > w: d1[s] = w
    for mask in range(1 << (n - half)):
        w = bin(mask).count('1')
        if w >= best: continue
        s = 0; mm = mask
        while mm:
            j = (mm & -mm).bit_length() - 1
            s ^= cols[half + j]; mm &= mm - 1
        if s in d1:
            tot = d1[s] + w
            if 0 < tot < best: best = tot
    return best

def min_weight(basis):
    return min((wt(x) for x in span_from_basis(basis) if x), default=10**9)

def greedy_search(S, n, tries=4000, name=""):
    """randomized greedy for triply-even subcodes maximizing uniformity"""
    sing = [x for x in S if x and wt(x) % 8 == 0]
    best = {}   # dim -> (uniformity, dperp, basis)
    for t in range(tries):
        random.shuffle(sing)
        basis = []
        for c in sing:
            if can_add(c, basis):
                # keep independent
                red = c
                # check independence over F2 via span membership (small spans)
                inspan = False
                for s in span_from_basis(basis):
                    if s == c: inspan = True; break
                if not inspan:
                    basis.append(c)
        k = len(basis)
        if k == 0: continue
        dperp = dual_distance(basis, n)
        d = min_weight(basis)
        uni = min(d, dperp) - 1
        for kk in range(1, k+1):
            sub = basis[:kk]
            if kk == k:
                if kk not in best or uni > best[kk][0]:
                    dd = dual_distance(sub, n); u = min(min_weight(sub), dd) - 1
                    best[kk] = (u, dd, list(sub))
        # also track overall best uniformity at any dim by trimming
        for kk in range(1, k):
            sub = basis[:kk]
            dd = dual_distance(sub, n)
            u = min(min_weight(sub), dd) - 1
            if kk not in best or u > best[kk][0]:
                best[kk] = (u, dd, list(sub))
    return best

print("\n--- searching Golay [24,12] for triply-even subcodes (t=1 sector) ---")
bG = greedy_search(SG, nG, tries=300, name="Golay")
for k in sorted(bG):
    u, dd, bas = bG[k]
    print(f"  dim {k}: best uniformity {u}  (d = {min_weight(bas)}, d_perp = {dd})")

print("\n--- searching RM(2,5) [32,16] for triply-even subcodes ---")
bR = greedy_search(SR, nR, tries=60, name="RM25")
for k in sorted(bR):
    u, dd, bas = bR[k]
    print(f"  dim {k}: best uniformity {u}  (d = {min_weight(bas)}, d_perp = {dd})")

print("\nreference: RM(1,4) at n=16 gives uniformity 3;  2n^{1/4}: n=24 -> 4.4, n=32 -> 4.8")
