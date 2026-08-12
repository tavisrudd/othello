# C909 hostile audit: nonsplit etale root-weight slopes

Date: 2026-08-11

Scope: hostile referee pass on
notes/2026-08-11-c909-nonsplit-etale-root-weight-slopes.md. No manuscript,
PDF, mirror, Lean, or commit change.

## Hostile verdict

The local quadratic-form assertions survive. The odd-prime rank-one trace
construction is valid once the discriminant factor is made explicit. The
dyadic assertion

    I_d + J_d is isometric to H^(d/2),  d = 2^a - 2, a >= 3

is valid: its determinant is the unit 2^a - 1, its residual quadratic form
has Arf invariant zero, and the trace of the hyperbolic form on O^2 is
literally hyperbolic over the base ring.

The polarized-indecomposability argument is valid for the stated non-CM
elliptic-power graph quotient, but the proof should record that (i) all
rational endomorphisms are coefficient matrices acting as diag(U,U) on the
two symplectic halves, (ii) an idempotent lifts as an actual rational
idempotent, and (iii) reduction preserves the transferred O-adjoint.

The smallest dyadic case is N=8, d=6, q=3; it is already a successful local
test and reveals no counterexample. The exact wording repair is that
R = Z/p^a and its unramified degree-m extension are finite etale local rings,
not fields when a > 1. Thus “field algebra” and “field-valued” should be
replaced by “unramified local etale algebra” or “nonsplit finite etale
algebra.”

## 1. Trace transfer and odd p

Let R = Z/p^a, let O/R be unramified of rank m, and let M be free over O.
The trace pairing O x O -> R is perfect because O/R is finite etale. Given
a self-adjoint O-action on a perfect symmetric R-pairing B, the equation

    Tr_O/R(alpha h(x,y)) = B(alpha x,y), for every alpha in O

defines a unique O-bilinear symmetric h. The induced map

    M -> Hom_O(M,O)

is an isomorphism exactly when the induced R-map
M -> Hom_R(M,R) is an isomorphism: trace duality identifies the two targets,
and an O-linear map between finite free O-modules which is an R-isomorphism
is an O-isomorphism. Hence the “unimodular exactly when” sentence in the
source note is correct, with this length/free-module justification.

For an O-basis of M, the determinant identity is exact:

    det_R(Tr h) = disc(O/R)^n * Norm_O/R(det_O h),
    n = rank_O(M).

Changing the R-basis multiplies the Gram determinant by a square. Therefore
a rank-one form h(x,y) = cxy can match any prescribed unit determinant square
class: the discriminant factor is fixed and the norm O^* -> R^* is surjective
for an unramified extension. No Hasse invariant is missing at odd p:
unimodular symmetric forms over Z/p^a are classified by rank and determinant
square class (integral diagonalization followed by the finite-field
classification). This is an integral-lattice statement, not a classification
of arbitrary forms over Q_p.

For N = p^a, p odd, and d = N - 2, the root block is p^a B with B
unimodular, so the degree-d rank-one transfer realizes it. Also d >= p for
a >= 2, hence p divides d!. The pure unramified algebra claim is R[T] = O,
not that O itself is a field for a > 1.

## 2. Dyadic I + J check

Put N = 2^a, a >= 3, d = N - 2, and q = d/2 = 2^(a-1) - 1. Then
d is 6 modulo 8, and

    B = I_d + J_d,       det(B) = 1 + d = N - 1.

Thus B is unimodular (the determinant is odd), and its determinant has the
Z_2-unit square class of -1, since N - 1 is 7 modulo 8. The diagonal
entries are 2, so B is even.

For x in F_2^d, with w = wt(x), lifting to integers gives

    x^t B x / 2 = (w + w^2)/2
                  = w + binom(w,2) modulo 2.

The signs have period +, -, -, + in w. Consequently the binomial Gauss sum
is +2^(d/2) for d congruent to 6 modulo 8; the Arf invariant is zero.
Together with rank 2q and determinant class -1, the standard type-II
unimodular 2-adic classification gives B isometric to H^q, where
H = [[0,1],[1,0]]. The first case N=8 is B = I_6 + J_6, det(B) = 7, and
B isometric to H^3.

There is also a direct transfer check. If K is the trace Gram matrix
K_ij = Tr(e_i e_j) for an R-basis of O, the transfer of

    h((x1,x2),(y1,y2)) = x1 y2 + x2 y1

has matrix [[0,K],[K,0]]. Since K is unimodular, changing the second half by
K^(-1) gives [[0,I_q],[I_q,0]], exactly H^q after reordering. No unverified
trace-form square-class argument is needed in the dyadic case.

The parity obstruction is also correct. If B modulo 2 is alternating and
h(v,v) is nonzero in the residue field, the Frobenius-surjective map
alpha -> alpha^2 h(v,v), followed by the nondegenerate trace pairing, gives
an alpha with Tr(alpha^2 h(v,v)) nonzero, a contradiction. Hence an
O-rank-one transfer cannot realize an alternating dyadic block.

## 3. Self-adjoint idempotents and the graph quotient

For

    C = [[p^(-a) I, 0], [p^(-a) T, I]],

direct multiplication gives

    C^(-1) diag(U,U) C
      = [[U, 0], [(UT - TU)/p^a, U]].

The diag(U,U) restriction is not a missing block of endomorphisms. For a
non-CM elliptic curve, End^0(E) = Q, so End^0(E^g) = M_g(Q), represented on
the two symplectic halves by exactly diag(U,U). A quotient endomorphism lifts
through the isogeny to a rational coefficient matrix. Integrality of the
conjugate forces U to be p-integral, and the lower-left block gives
UT - TU = 0 modulo p^a.

If the quotient endomorphism is an idempotent, its rational lift is an actual
idempotent: pi(U^2 - U) = 0, and a homomorphism from a connected abelian
variety into the finite kernel of an isogeny is zero. Thus the reduction is
an idempotent in the indicated centralizer, not merely an approximate one.

In the odd case T = multiplication by theta on O, the centralizer is O, a
local ring, so its only idempotents are 0 and 1. In the dyadic case the
centralizer is M_2(O). Rosati self-adjointness for the transferred form is
the h-adjoint condition by trace duality. A self-adjoint idempotent in
M_2(O) gives an orthogonal direct sum of its image and kernel. A proper
idempotent has rank one over the local ring O; a primitive generator
v = (x,y) of that line has h(v,v) = 2xy in 2O, so the line restriction is
not unimodular. This contradicts orthogonal unimodularity of the summands.
Therefore the only self-adjoint idempotents are 0 and 1.

Finally, if an integral idempotent is congruent to 0 modulo p^a, write
U = p^a V in the torsion-free p-adic coefficient ring. U^2 = U gives
V = p^a V^2, and iteration gives U = 0. Apply the same argument to 1 - U
for the congruent-to-one case.

This proves polarized indecomposability for the stated non-CM graph quotient,
provided the standard maximal-isotropic quotient construction is included:
the root form has determinant supported only at p, the self-adjoint graph is
maximal isotropic in its p^a-kernel, and the quotient therefore carries the
descended principal polarization. The graph-descent calculation in
papers/cubic-stabilization-epilogue/sections/03-minimal-class.tex is the
normalization to reuse. The local trace form alone is not by itself a global
quotient theorem; these gluing facts must be stated when the family is
promoted.

## Final status and mystery ledger

- Proved locally: trace-transfer equivalence, determinant/norm matching,
  odd-p rank-one realization, and dyadic I + J isometric to H^q.
- Proved conditionally on the standard graph chart: principal quotient
  polarization and polarized indecomposability for non-CM E.
- Repair required: replace “field algebra” by “finite etale unramified local
  algebra” at exponent a > 1, and display the discriminant factor and
  rational-idempotent lift in the theorem proof.
- Not shown here: classification of all finite-etale slopes, or any second
  geometric separation detector.

EJ: the nonsplit trace family is a genuine local extension of the split
etale construction, including the first dyadic case N=8.

TT: the trace discriminant and dyadic Arf checks expose the exact local
invariants; no Hasse factor or hidden trace-degree denominator remains.
