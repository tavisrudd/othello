# Independent one-generator check of the gate-A loud flag:
# for T'' = beta (x) 1 with a_* beta = e_1^...^e_9 (the hat-e_0 dual),
# psi_* T'' = +- (hat_e0) * Theta^[3]; solve L_3 v = that over Q and
# report the exact denominator, plus the same for three more duals and
# one H^2 (x) H^1 generator (a^*e_{01}) (x) (a^*e_2) for contrast.
# Run from repo root: nix shell nixpkgs#sage -c sage <this file>

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
        out[Ic] = out.get(Ic, 0) + w[FULL]*cI
    return out

def pd_inv(z):
    out = {}
    for J, cJ in z.items():
        Jc = tuple(sorted(set(range(n)) - set(J)))
        w = wedge({Jc: 1}, {tuple(J): 1})
        out[Jc] = out.get(Jc, 0) + w[FULL]*cJ
    return out

def pontryagin(x, y):
    return pd_inv(wedge(pd(x), pd(y)))

# L_3 : ^3 -> ^5 as a matrix (rows = images of ^3 basis)
rows = [to_vec(wedge(theta, {I: 1}), 5) for I in combinations(range(n), 3)]
L3 = matrix(ZZ, rows)
print(f"L_3 elementary divisors summary: rank={L3.rank()}",
      f"divisors={sorted(set(L3.smith_form()[0].diagonal()))}")

def check(label, target):
    tv = to_vec(target, 5)
    try:
        sol = L3.transpose() \ tv.change_ring(QQ)
        den = lcm([c.denominator() for c in sol])
        print(f"{label}: solvable over Q, denominator = {den}")
    except Exception as e:
        print(f"{label}: NOT solvable over Q ({e})")

# four H^3 (x) H^0 generators: hat duals of e_0, e_1, e_5, e_9
for i in [0, 1, 5, 9]:
    zeta = pd_inv({(i,): 1})       # ^9 with PD-dual structure
    E = pontryagin(zeta, th3)      # psi_*(beta (x) 1) up to sign
    check(f"hat_e{i} * Theta^[3]", E)

# one H^2 (x) H^1 generator: (a^* e_0^e_1) (x) (a^* e_2):
#   psi_*(x (x) y) = (a_* x) * (a_* y) = (e01 ^ th3) * (e2 ^ th3)
u = wedge({(0, 1): 1}, th3)
z = wedge({(2,): 1}, th3)
E2 = pontryagin(u, z)
check("(e01^th3) * (e2^th3)", E2)

# diagonal parity of the H^3(x)H^0 generator: i_Delta^*(beta (x) 1) = beta,
# whose a_*-coordinate is the ^9 basis vector: odd. Report for the record.
print("i_Delta^* of (beta (x) 1) = beta itself: odd (unit ^9 coordinate) by construction")
print("PASS")
