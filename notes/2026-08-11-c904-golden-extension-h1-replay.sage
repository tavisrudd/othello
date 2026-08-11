# Independent Sage replay for the C904 golden extension H^1 calculation.

import os

K.<w> = GF(4, modulus=x^2 + x + 1)
S = matrix(K, [[1, 1], [0, 1]])
T = matrix(K, [[0, w], [w^2, 1]])
I2 = identity_matrix(K, 2)


def order(A):
    X = identity_matrix(K, A.nrows())
    for n in range(1, 61):
        X *= A
        if X == 1:
            return n
    raise AssertionError("matrix order exceeds 60")


def norm(A, n):
    out = zero_matrix(K, A.nrows())
    power = identity_matrix(K, A.nrows())
    for _ in range(n):
        out += power
        power *= A
    return out


assert (order(S), order(T), order(S*T)) == (2, 3, 5)
G = MatrixGroup([S, T])
assert G.order() == 60

# A cocycle is determined by a=f(S), b=f(T).  Stack the three relation maps
# on H+H.  For (ST)^5, f(ST)=a+S*b.
N2 = norm(S, 2)
N3 = norm(T, 3)
N5 = norm(S*T, 5)
R = block_matrix(K, [
    [N2, zero_matrix(K, 2)],
    [zero_matrix(K, 2), N3],
    [N5, N5*S],
])
Z1 = R.right_kernel()
assert Z1.dimension() == 3

# Coboundary v |-> ((S-I)v,(T-I)v).
D = block_matrix(K, 2, 1, [S-I2, T-I2])
assert D.rank() == 2
assert all(R * D.column(j) == 0 for j in range(D.ncols()))
assert Z1.dimension() - D.rank() == 1

# Verify directly that a representative outside im(D) gives a nonsplit
# extension and that the three nonzero scalar multiples have no complement.
B1 = D.column_space()
z = next(v for v in Z1 if v not in B1)
split_counts = []
for c in [K(0), K(1), w, w^2]:
    zz = c*z
    a = vector(K, zz[:2])
    b = vector(K, zz[2:])
    GS = block_matrix(K, [[S, matrix(K, 2, 1, a)],
                          [zero_matrix(K, 1, 2), matrix(K, [[1]])]])
    GT = block_matrix(K, [[T, matrix(K, 2, 1, b)],
                          [zero_matrix(K, 1, 2), matrix(K, [[1]])]])
    assert (order(GS), order(GT), order(GS*GT)) == (2, 3, 5)
    count = 0
    for x0 in K:
        for x1 in K:
            v = vector(K, [x0, x1, 1])
            if GS*v == v and GT*v == v:
                count += 1
    split_counts.append(count)
assert split_counts == [1, 0, 0, 0]

output = "\n".join([
    "C904 golden extension H1 independent Sage replay",
    "  group order=60",
    "  presentation orders=(2, 3, 5)",
    "  dim_F4 Z1=3",
    "  dim_F4 B1=2",
    "  dim_F4 H1=1",
    "  invariant complements zero/nonzero=(1, 0, 0, 0)",
    "PASS",
]) + "\n"

source_path = os.environ.get(
    "C904_SOURCE", "../notes/2026-08-11-c904-golden-extension-h1-replay.sage"
)
out_path = os.path.splitext(os.path.abspath(source_path))[0] + ".out"
mode = os.environ.get("C904_MODE", "print")
if mode == "write":
    open(out_path, "w").write(output)
    print("wrote " + os.path.basename(out_path))
elif mode == "check":
    assert open(out_path).read() == output
    print("PASS " + os.path.basename(out_path))
else:
    print(output, end="")
