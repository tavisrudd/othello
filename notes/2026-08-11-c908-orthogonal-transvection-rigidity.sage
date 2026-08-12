# C908: rigidity certificate for the transvection subgroup of O(q) on F_2^10.
#
# For both Arf classes of a nondegenerate quadratic form q on F_2^10 refining
# the standard symplectic form B, let T be the set of transvections
# x |-> x + B(x,v) v at anisotropic vectors v (q(v) = 1).  Certify:
#   (1) the commutant of T in End(F_2^10) is exactly the scalars F_2
#       (hence the module is absolutely irreducible under any group
#       containing T);
#   (2) the space of T-invariant bilinear forms is one-dimensional,
#       spanned by B.
# These are the only group-theoretic inputs of the rigidity theorem in
# notes/2026-08-11-c908-universal-family-even-rigidity.md section 4.2;
# generation of the full orthogonal group is NOT used.
#
# Replay (from the repository root):
#   nix shell nixpkgs#sage -c sage \
#     notes/2026-08-11-c908-orthogonal-transvection-rigidity.sage \
#     --out notes/2026-08-11-c908-orthogonal-transvection-rigidity.out
# Delete the .sage.py preparse file afterwards.

import argparse, hashlib

F = GF(2)
n = 10

# Symplectic basis e_1..e_5, f_1..f_5: B(e_i, f_i) = 1.
B = matrix(F, n, n)
for i in range(5):
    B[i, 5 + i] = 1
    B[5 + i, i] = 1

def quad_plus(x):
    return sum(x[i] * x[5 + i] for i in range(5))

def quad_minus(x):
    return sum(x[i] * x[5 + i] for i in range(5)) + x[4] ** 2 + x[9] ** 2

def transvections(q):
    V = VectorSpace(F, n)
    mats = []
    for v in V:
        if v.is_zero() or q(v) != 1:
            continue
        T = identity_matrix(F, n) + column_matrix(v) * (v.row() * B)
        assert T * B * T.transpose() == B
        mats.append(T)
    return mats

def arf(q):
    return sum(1 for v in VectorSpace(F, n) if q(v) == 1)

def commutant_dim(mats):
    # Solve M T = T M for all T: linear system in 100 unknowns.
    rows = []
    for T in mats:
        K = T.tensor_product(identity_matrix(F, n)) - \
            identity_matrix(F, n).tensor_product(T.transpose())
        rows.append(K)
    big = block_matrix([[r] for r in rows], subdivide=False)
    return n * n - big.rank()

def invariant_forms_dim(mats):
    # Solve T^t G T = G for all T.
    rows = []
    for T in mats:
        K = T.transpose().tensor_product(T.transpose()) - \
            identity_matrix(F, n * n)
        rows.append(K)
    big = block_matrix([[r] for r in rows], subdivide=False)
    return n * n - big.rank()

def main(out_path):
    lines = []
    for name, q in (("plus", quad_plus), ("minus", quad_minus)):
        aniso = arf(q)
        mats = transvections(q)
        cdim = commutant_dim(mats)
        fdim = invariant_forms_dim(mats)
        # Verify B itself is invariant (it is, T symplectic by construction).
        lines.append(
            "q_%s: anisotropic=%d transvections=%d commutant_dim=%d "
            "invariant_bilinear_forms_dim=%d" % (name, aniso, len(mats), cdim, fdim))
        assert cdim == 1 and fdim == 1
    # The two forms are inequivalent (different anisotropic counts) so both
    # Arf classes are covered.
    lines.append("PASS")
    output = "\n".join(lines) + "\n"
    if out_path:
        with open(out_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    print(output, end="")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--out")
    arguments = parser.parse_args()
    main(arguments.out)
