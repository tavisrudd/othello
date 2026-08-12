# C908 pass-7 side probe: pass-6 bimodal histogram in the symplectic basis.
# Replay (from repo root):
#   nix shell nixpkgs#sage -c sage <this file>
# Reuses the corpus lattice machinery (notes/2026-08-10-c904-minimal-class-
# divisor-lattice.sage) exactly as the committed Pontryagin certificate does.

import io, sys
from contextlib import redirect_stdout
from itertools import combinations

_buf = io.StringIO()
sys.argv = ['minimal-class-divisor-lattice.sage', '--export-constants']
with redirect_stdout(_buf):
    load('notes/2026-08-10-c904-minimal-class-divisor-lattice.sage')

gram5, omega, basis10, S = principal_lattice("omega", 1)
n = 10
theta = two_form(S)

def divided_power(x, k):
    p = {(): 1}
    for _ in range(k):
        p = wedge(p, x)
    fk = factorial(k)
    assert all(c % fk == 0 for c in p.values())
    return {K: c // fk for K, c in p.items()}

def to_vec(x, deg):
    idx = {I: i for i, I in enumerate(combinations(range(n), deg))}
    v = [0]*binomial(n, deg)
    for K, c in x.items():
        v[idx[tuple(sorted(K))]] = c
    return vector(ZZ, v)

th3 = divided_power(theta, 3)
FULL = tuple(range(n))

def pd(x):
    out = {}
    for I, cI in x.items():
        Ic = tuple(sorted(set(range(n)) - set(I)))
        w = wedge({tuple(I): 1}, {Ic: 1})
        assert list(w.keys()) == [FULL]
        out[Ic] = out.get(Ic, 0) + w[FULL]*cI
    return out

def pd_inv(z):
    out = {}
    for J, cJ in z.items():
        Jc = tuple(sorted(set(range(n)) - set(J)))
        w = wedge({Jc: 1}, {tuple(J): 1})
        assert list(w.keys()) == [FULL]
        out[Jc] = out.get(Jc, 0) + w[FULL]*cJ
    return out

def pontryagin(x, y):
    return pd_inv(wedge(pd(x), pd(y)))

# L_5 mod 2 and the quotient Q_15
rows = [to_vec(wedge(theta, {I: 1}), 7) for I in combinations(range(n), 5)]
L5 = matrix(ZZ, rows)
L5_2 = L5.change_ring(GF(2))
assert 120 - L5_2.rank() == 10
V2 = GF(2)**120
Qquot = V2 / L5_2.row_space()

# symplectic basis change: F = C S C^t, new basis 1-forms are rows of (C^t)^-1
F_form, C = S.symplectic_form()
P = (C.transpose())**(-1)
assert all(x in ZZ for x in P.list())
P = P.change_ring(ZZ)

def one_form(vec):
    return {(i,): c for i, c in enumerate(vec) if c}

sym_vecs = [one_form(P.row(i)) for i in range(n)]

# recognize the pairing convention and check Theta = sum of pair products
def try_pairs(pairs):
    acc = {}
    for a, b in pairs:
        t = wedge(sym_vecs[a], sym_vecs[b])
        for K, c in t.items():
            acc[K] = acc.get(K, 0) + c
    return {k: v for k, v in acc.items() if v}

pairing = None
for name, pairs in [('interleaved', [(2*k, 2*k+1) for k in range(5)]),
                    ('split', [(k, 5+k) for k in range(5)])]:
    if try_pairs(pairs) == theta:
        pairing = name
        pair_set = set(pairs)
        break
assert pairing is not None, "symplectic pairing convention not recognized"
print(f"symplectic pairing convention: {pairing}")

hist = {}
pair_dims = []
nonpair_hist = {}
for i in range(n):
    for j in range(i+1, n):
        u = wedge(sym_vecs[i], sym_vecs[j])
        uth3 = wedge(u, th3)
        vecs = []
        for z in range(n):
            zeta = pd_inv({(z,): 1})
            E = pontryagin(uth3, zeta)
            vecs.append(list(Qquot(to_vec(E, 7).change_ring(GF(2)))))
        d = matrix(GF(2), vecs).rank()
        hist[d] = hist.get(d, 0) + 1
        if (i, j) in pair_set:
            pair_dims.append(((i, j), d))
        else:
            nonpair_hist[d] = nonpair_hist.get(d, 0) + 1

print(f"histogram of dim span_z [E(u,z)] over the 45 symplectic bivectors: {hist}")
print(f"the 5 symplectic-pair bivectors: {pair_dims}")
print(f"histogram over the other 40: {nonpair_hist}")

# Candidate intrinsic invariant: parity of l(u) = coefficient of u ^ Theta^[4]
# (the Pfaffian-complement functional). Cross-tab in BOTH bases.
th4 = divided_power(theta, 4)

def ell(u):
    w = wedge(u, th4)
    return w.get(FULL, 0)

def crosstab(vec_list, label):
    tab = {}
    for i in range(n):
        for j in range(i+1, n):
            u = wedge(vec_list[i], vec_list[j])
            uth3 = wedge(u, th3)
            vecs = []
            for z in range(n):
                zeta = pd_inv({(z,): 1})
                E = pontryagin(uth3, zeta)
                vecs.append(list(Qquot(to_vec(E, 7).change_ring(GF(2)))))
            d = matrix(GF(2), vecs).rank()
            par = ell(u) % 2
            tab[(d, par)] = tab.get((d, par), 0) + 1
    print(f"cross-tab (dim, ell-parity) in {label} basis: {sorted(tab.items())}")
    return tab

std_vecs = [{(i,): 1} for i in range(n)]
tab_std = crosstab(std_vecs, "standard")
tab_sym = crosstab(sym_vecs, "symplectic")
clean = all((d == 8) == (p == 1) for (d, p) in list(tab_std) + list(tab_sym))
print(f"dichotomy 'dim 8 <=> ell odd' holds in both bases: {clean}")
print("PASS")
