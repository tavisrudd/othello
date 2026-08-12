from contextlib import redirect_stdout
from io import StringIO
from itertools import product
import sys

_saved = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved

F = GF(2)
DIM = 10


def compose(a, b):
    return [a[b[i]] for i in range(6)]


def inv(p):
    r = [0] * 6
    for i, t in enumerate(p):
        r[t] = i
    return r


def induced(M, basis):
    A = block_diagonal_matrix(M, M)
    return (basis * A.transpose() * basis.inverse()).change_ring(ZZ)


def intertwiners(L, R, field):
    rows = []
    for left, right in zip(L, R):
        for i in range(DIM):
            for j in range(DIM):
                row = [field.zero()] * (DIM * DIM)
                for k in range(DIM):
                    row[DIM * k + j] += field(left[i, k])
                    row[DIM * i + k] -= field(right[k, j])
                rows.append(row)
    return [matrix(field, DIM, DIM, list(v))
            for v in matrix(field, rows).right_kernel().basis()]


_, _, basis, symplectic = principal_lattice("omega", 1)
T = [1, 2, 3, 4, 0, 5]
S = [5, 4, 2, 3, 1, 0]
m = [0, 2, 4, 1, 3, 5]
gens = [T, S]
tw = [compose(m, compose(p, inv(m))) for p in gens]
rho = [induced(axis_action(p), basis) for p in gens]
rho_t = [induced(axis_action(p), basis) for p in tw]
rho2 = [r.change_ring(F) for r in rho]
rho2_t = [r.change_ring(F) for r in rho_t]
I = identity_matrix(F, DIM)
Z = zero_matrix(F, DIM)
S2 = symplectic.change_ring(F)

C = intertwiners(rho2, rho2, F)
els = [sum((c * b for c, b in zip(co, C)), Z) for co in product(F, repeat=len(C))]
nilp = [x for x in els if x ** DIM == Z]
print("commutant dim", len(C), "nilpotents", len(nilp))
rad = matrix(F, [x.list() for x in nilp]).row_space()
print("radical is a subspace of dim", rad.dimension(),
      "square zero:", all((x * y) == Z for x in nilp for y in nilp))
cube = [x for x in els if x * x + x + I == Z]
w = cube[0]
eps = [x for x in nilp if x != Z]
print("w*eps == eps*w^2 for all eps:",
      all(w * e == e * (w * w) for e in eps),
      "| w*eps == eps*w:", all(w * e == e * w for e in eps))
print("w symplectic:", w * S2 * w.transpose() == S2)

# module structure: fixed space, socle scan
fixed = (rho2[0] - I).transpose().kernel().intersection(
    (rho2[1] - I).transpose().kernel())
print("fixed subspace dim (row vectors x with x*rho = x):", fixed.dimension())
V = VectorSpace(F, DIM)
dims = {}
for v in V:
    if v.is_zero():
        continue
    sub = V.span([v])
    while True:
        bigger = V.span(list(sub.basis()) + [b * r for b in sub.basis() for r in rho2])
        if bigger.dimension() == sub.dimension():
            break
        sub = bigger
    dims[sub.dimension()] = dims.get(sub.dimension(), 0) + 1
print("cyclic submodule dimensions:", sorted(dims.items()))

# involution search
group = []
seen = set()
frontier = [identity_matrix(F, DIM)]
seen.add(tuple(frontier[0].list()))
while frontier:
    x = frontier.pop()
    group.append(x)
    for r in rho2:
        y = x * r
        k = tuple(y.list())
        if k not in seen:
            seen.add(k)
            frontier.append(y)
print("mod-2 group order", len(group))
Tw = intertwiners(rho2, rho2_t, F)
tw_els = [sum((c * b for c, b in zip(co, Tw)), Z)
          for co in product(F, repeat=len(Tw))]
cands = []
for t in tw_els:
    if not t.is_invertible():
        continue
    for a in group:
        s = t * a
        if s * s == I and s.inverse() * w * s == w * w:
            fx = [x for x in els if x * s == s * x]
            cands.append((len(fx), bool(s * S2 * s.transpose() == S2), s))
print("involutions s with s w s = w^2:", len(cands))
print("fixed-count / symplectic profile:",
      sorted({(c[0], c[1]) for c in cands}))
if cands:
    s = cands[0][2]
    fx = [x for x in els if x * s == s * x]
    print("fixed set contains 1:", I in fx, "contains w:", w in fx,
          "nilpotent members:", len([x for x in fx if x ** DIM == Z]))
