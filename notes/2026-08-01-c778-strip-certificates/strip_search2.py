import numpy as np, itertools, random
random.seed(5); np.random.seed(5)
def wt(x): return bin(x).count('1')

def can_add(c, basis):
    if wt(c) % 8: return False
    for i,a in enumerate(basis):
        if wt(c & a) % 4: return False
        for b in basis[i+1:]:
            if wt(c & a & b) % 2: return False
    return True

def strength_ok(basis, n, s):
    """d(C^perp) >= s+1  <=>  every <= s columns of gen matrix independent"""
    k = len(basis)
    cols = [sum(((basis[i] >> j) & 1) << i for i in range(k)) for j in range(n)]
    if any(c == 0 for c in cols): return False
    # check all subsets of size 2..s have no zero XOR (distinctness handles 2)
    for size in range(2, s+1):
        for sub in itertools.combinations(range(n), size):
            x = 0
            for j in sub: x ^= cols[j]
            if x == 0: return False
    return True

def dual_distance_exact(basis, n, cap=10):
    k = len(basis)
    cols = [sum(((basis[i] >> j) & 1) << i for i in range(k)) for j in range(n)]
    for size in range(1, cap+1):
        for sub in itertools.combinations(range(n), size):
            x = 0
            for j in sub: x ^= cols[j]
            if x == 0: return size
    return cap+1

# sanity: RM(1,4)
def rm1(m):
    n = 2**m; pts = list(itertools.product([0,1], repeat=m))
    basis = [sum(1 << i for i in range(n))]
    for a in range(m):
        basis.append(sum(pts[i][a] << i for i in range(n)))
    return basis, n
b14, n14 = rm1(4)
print("sanity RM(1,4): d_perp =", dual_distance_exact(b14, n14), "(expect 4)")

def rand_word(n, w):
    pos = random.sample(range(n), w)
    return sum(1 << p for p in pos)

def search(n, target_s=4, tries=20000, inner=400):
    """try to build triply-even code with strength >= target_s (d_perp >= target_s+1)"""
    best_dim, best_bas = 0, []
    best_dperp_at_dim = {}
    for t in range(tries):
        basis = []
        for _ in range(inner):
            w = random.choice([8]* 6 + [16]*2) if n >= 16 else 8
            if w > n: w = 8
            c = rand_word(n, w)
            if not can_add(c, basis): continue
            trial = basis + [c]
            if strength_ok(trial, n, target_s):
                basis = trial
        k = len(basis)
        if k > best_dim:
            best_dim, best_bas = k, list(basis)
    return best_dim, best_bas

for n in [16, 24, 32, 40, 48]:
    k, bas = search(n, target_s=4, tries=60, inner=1500)
    if k >= 1:
        dd = dual_distance_exact(bas, n)
        print(f"n={n}: best triply-even with strength-4 constraint: dim {k}, d_perp = {dd}, "
              f"uniformity = {min(8, dd)-1 if k>0 else '-'}")
    else:
        print(f"n={n}: nothing found with d_perp >= 5")

# and without the strength constraint, what's the max dim we can find (dimension landscape)
print("\nmax triply-even dimension found (no dual-distance constraint):")
for n in [16, 24, 32, 40, 48]:
    best = 0
    for t in range(40):
        basis = []
        for _ in range(3000):
            c = rand_word(n, random.choice([8]*5+[16]*2 + ([24] if n>=24 else [8])))
            if can_add(c, basis):
                # independence check
                sp = [0]
                indep = True
                for g in basis: sp += [s ^ g for s in sp]
                if c in sp: indep = False
                if indep: basis.append(c)
        best = max(best, len(basis))
    print(f"  n={n}: dim >= {best}   (n/4 = {n//4})")
