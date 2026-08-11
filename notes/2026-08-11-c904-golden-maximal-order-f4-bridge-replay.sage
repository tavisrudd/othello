# Independent Sage replay of the golden maximal-order/F4-heart bridge.
#
# Run without creating a .sage.py file:
#   C904_MODE=write nix shell nixpkgs#sage --command sage -c \
#     "exec(preparse(open('../notes/2026-08-11-c904-golden-maximal-order-f4-bridge-replay.sage').read()))"

from itertools import permutations, product
from pathlib import Path
import os

B = matrix(ZZ, [
    [0, 1, 1, 1, 1, 1],
    [1, 0, 1, 1, -1, -1],
    [1, 1, 0, -1, 1, -1],
    [1, 1, -1, 0, -1, 1],
    [1, -1, 1, -1, 0, 1],
    [1, -1, -1, 1, 1, 0],
])
I6 = identity_matrix(ZZ, 6)
assert B * B == 5 * I6


def permutation_matrix_zero_based(p):
    ans = matrix(ZZ, 6, 6)
    for i in range(6):
        ans[p[i], i] = 1
    return ans


def compose(a, b):
    return tuple(a[b[i]] for i in range(6))


def inverse_perm(a):
    ans = [0] * 6
    for i, x in enumerate(a):
        ans[x] = i
    return tuple(ans)


def generated_group(gens):
    one = tuple(range(6))
    seen = {one}
    todo = [one]
    while todo:
        x = todo.pop()
        for g in gens:
            y = compose(g, x)
            if y not in seen:
                seen.add(y)
                todo.append(y)
    return frozenset(seen)


stabilizer = []
for p in permutations(range(6)):
    pp = permutation_matrix_zero_based(p)
    c = pp * B * pp.transpose()
    signs = [1] + [B[0, j] * c[0, j] for j in range(1, 6)]
    m = diagonal_matrix(ZZ, signs) * pp
    if m * B * m.transpose() == B:
        stabilizer.append((p, m))
assert len(stabilizer) == 60
perms = tuple(p for p, _ in stabilizer)

gens = None
for a in sorted(perms):
    for b in sorted(perms):
        if len(generated_group((a, b))) == 60:
            gens = (a, b)
            break
    if gens is not None:
        break
assert gens is not None

# Columns h=(1/2,...,1/2), e1,...,e5 give a Z-basis of Lmax.
P = matrix(QQ, 6, 6)
for i in range(6):
    P[i, 0] = QQ(1) / 2
for j in range(1, 6):
    P[j, j] = 1
assert abs(P.det()) == QQ(1) / 2

phi_q = (I6 + B) / 2
phi = P.inverse() * phi_q * P
assert phi in MatrixSpace(ZZ, 6)
phi = matrix(ZZ, phi)
assert phi * phi - phi == identity_matrix(ZZ, 6)

F = GF(2)
phi2 = matrix(F, phi)
lift = {p: m for p, m in stabilizer}
actions = {p: matrix(F, P.inverse() * lift[p] * P) for p in perms}
assert all(g * phi2 == phi2 * g for g in actions.values())
assert phi2 * phi2 + phi2 + identity_matrix(F, 6) == 0

# Independently generate all F4[A5]-submodules from individual vectors.
V = VectorSpace(F, 6)
submodules = set()
for v in V:
    if v == 0:
        continue
    spanning = []
    for g in actions.values():
        spanning.extend((g * v, phi2 * g * v))
    U = V.subspace(spanning)
    submodules.add((U.dimension(), tuple(tuple(x) for x in U.basis())))

proper = [(d, b) for d, b in submodules if 0 < d < 6]
assert [d for d, _ in proper].count(4) == 1
assert all(d == 4 for d, _ in proper)
Ubasis = [vector(F, x) for x in next(b for d, b in proper if d == 4)]
U = V.subspace(Ubasis)
assert U.dimension() == 4
assert all(phi2 * v in U for v in U.basis())
assert all(all(g * v in U for v in U.basis()) for g in actions.values())
commutator = V.subspace([g * v - v for g in actions.values() for v in V.basis()])
assert commutator == U

basis = list(U.basis())
for e in V.basis():
    if V.subspace(basis + [e]).dimension() > len(basis):
        basis.append(e)
assert len(basis) == 6
C = matrix(F, basis).transpose()
Ci = C.inverse()

sub_actions = {}
for p, g in actions.items():
    gg = Ci * g * C
    assert gg[4:6, 0:4] == 0
    assert gg[4:6, 4:6] == identity_matrix(F, 2)
    sub_actions[p] = gg[0:4, 0:4]
phic = Ci * phi2 * C
assert phic[4:6, 0:4] == 0
sub_phi = phic[0:4, 0:4]


def six_heart_matrix(p):
    cols = []
    for i in range(4):
        y = [F(0)] * 6
        y[p[i]] += 1
        y[p[5]] += 1
        cols.append(vector(F, [y[j] + y[4] for j in range(4)]))
    return matrix(F, cols).transpose()


def hom_space_basis(source, target):
    rows = []
    E = []
    for i in range(4):
        for j in range(4):
            z = matrix(F, 4, 4)
            z[i, j] = 1
            E.append(z)
    for a, b in zip(source, target):
        images = [e * a - b * e for e in E]
        for i in range(4):
            for j in range(4):
                rows.append([z[i, j] for z in images])
    K = matrix(F, rows).right_kernel()
    return [sum((c[k] * E[k] for k in range(16)), matrix(F, 4, 4))
            for c in K.basis()]


source = [sub_actions[p] for p in gens]
target = [six_heart_matrix(p) for p in gens]
hom = hom_space_basis(source, target)
assert len(hom) == 2
assert all(x.rank() in (0, 4) for x in hom)
X = next(x for x in hom if x.rank() == 4)
omega = X * sub_phi * X.inverse()
assert all(x * sub_phi * x.inverse() == omega for x in hom if x.rank() == 4)
omega2 = omega + identity_matrix(F, 4)
assert omega * omega + omega + identity_matrix(F, 4) == 0
assert omega2 == omega * omega

# Normalizer outer coset and golden conjugation both act by Frobenius.
A5 = frozenset(perms)
normalizer = []
for p in permutations(range(6)):
    pi = inverse_perm(p)
    if all(compose(compose(p, g), pi) in A5 for g in A5):
        normalizer.append(p)
assert len(normalizer) == 120
outer = next(p for p in normalizer if p not in A5)
N = six_heart_matrix(outer)
assert N * omega * N.inverse() == omega2

phi_conjugate = identity_matrix(F, 6) + phi2
sub_phi_conjugate = (Ci * phi_conjugate * C)[0:4, 0:4]
assert X * sub_phi_conjugate * X.inverse() == omega2


def matrix_tuple(a):
    return tuple(tuple(ZZ(a[i, j]) for j in range(a.ncols()))
                 for i in range(a.nrows()))


out = "\n".join([
    "C904 independent Sage golden/F4 replay",
    "  det(Lmax basis)=1/2, saturation index=2",
    "  phi integral on Lmax, phi^2-phi-1=0",
    "  generated proper F4[A5] submodules: unique dimension=4",
    "  submodule=[A5,Lmax/2], quotient=trivial F4-line",
    "  submodule is six-point heart: Hom dimension=2, invertible=True",
    f"  omega={matrix_tuple(omega)}",
    f"  omega^2={matrix_tuple(omega2)}",
    "  golden and outer conjugations both act by Frobenius",
    "PASS",
]) + "\n"

path = Path("../notes/2026-08-11-c904-golden-maximal-order-f4-bridge-replay.out")
mode = os.environ.get("C904_MODE", "print")
if mode == "write":
    path.write_text(out)
    print(f"wrote {path.name}")
elif mode == "check":
    assert path.read_text() == out
    print(f"PASS {path.name}")
elif mode == "print":
    print(out, end="")
else:
    raise ValueError("C904_MODE must be write, check, or print")
