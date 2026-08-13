# C907 formal-primary Galois stability

**Lane:** `clebsch`

**Status:** exact structural theorem.  On a non-turning parameter locus, the
whole generalized primitive-sixth formal-monodromy sector is preserved by
large-radius line-bundle monodromy.  Via Iritani's Gamma framing, tensor by a
line bundle therefore defines an intrinsic nilpotent operator on the minimal
Silver packet.  This closes the commutation/intrinsicity part of the
line-bundle construction, but not supported Gysin locality.

## Abstract parameter-monodromy theorem

Let ((\mathcal E,\nabla)) be an integrable meromorphic connection on
(S\times\Delta_z), with poles along (z=0), and restrict to a connected
non-turning locus on which it has a good relative formal decomposition after
one fixed ramification.  Let (T_f) denote formal monodromy on the direct sum
of all regular-singular formal factors.

Parallel transport along (S) preserves the generalized
(\lambda)-primary formal sector

\[
 \mathcal E_{(\lambda)}=\ker(T_f-\lambda)^M
 \tag{1}
\]

for (M\gg0).  In particular every parameter-loop monodromy (G) satisfies

\[
 GT_f=T_fG,
 \qquad
 G\mathcal E_{(\lambda)}=\mathcal E_{(\lambda)}.
 \tag{2}
\]

### Proof

Horizontal transport in (S) is an isomorphism of formal meromorphic
(z)-connections.  The good formal decomposition is unique up to permutation
of equal formal types, so this transport carries formal exponential factors
and their regular-singular parts to the corresponding factors.  On each
regular-singular part it intertwines the angular (z)-monodromy.  Summing over
all formal exponential factors removes the possible permutation, and a loop
in (S) therefore commutes with the total formal monodromy.  Equation (1) is
the kernel of a polynomial in (T_f), so (2) follows.

Equivalently, after passing to the product cover of the parameter loop and
the formal angular circle, their two deck transformations commute.  The
non-turning hypothesis is the exact scope in which the relative formal ranks
and ramification are constant; no claim is made across a turning wall.

## Quantum and Gamma application

For the quantum connection, Iritani's Gamma-integral framing satisfies

\[
 s(V)(\tau-2\pi i c_1(L),z)=s(V\otimes L)(\tau,z).
 \tag{3}
\]

Thus the parameter-loop monodromy (G_L) is tensor by (L) on the framed
topological (K)-group.  Apply (2) with
(\lambda=\zeta_6), after extension to (K=\mathbf Q(\zeta_6)).  The whole
generalized (\zeta_6)-primary formal sector is (G_L)-stable, and

\[
 N_L=1-G_L
 \tag{4}
\]

is an intrinsic endomorphism of that sector.  Since tensor by a line bundle
is unipotent under the Chern character, (N_L) is nilpotent.

This uses the whole generalized primary sector.  A single exponential block
can be permuted by parameter monodromy and need not be invariant.  That is
why the minimal Silver category is safer than the earlier atomwise
zero-exponential formulation.

Iritani also records that the Gamma framing including odd classes is natural
for Cartesian products.  Hence on the product endpoint
(X\times\mathbf P^2), with (L=\operatorname{pr}_2^*\mathcal O(1)), the
one-dimensional cubic (\zeta_6)-line is tensored with

\[
 K_0(\mathbf P^2)_K\cong K[x]/(x^3),
 \qquad x=1-[\mathcal O(1)].
\]

Multiplication by (x) is one (J_3).  Therefore (4) gives the endpoint
operator required by Silver without choosing directed thimbles, a Beilinson
basis, or a Gamma marking inside the three-dimensional block.

## What this closes

1. Tensor by the base hyperplane does preserve the whole formal
   primitive-sixth packet; this is not an additional conjectural projector
   axiom.
2. The operator (N_L=1-\tau_L) is presentation-independent once the
   line-bundle parameter loop is part of the framed model.
3. Product/Gamma compatibility calibrates the endpoint as (J_3).
4. Any formal QDM comparison equivariant for the corresponding parameter
   deck transformations automatically intertwines (N_L).  Thus the
   remaining blowup question is the equivariance of the actual comparison
   maps, not the existence of the primary-sector operator.

## What remains open

Formal-primary stability is not support locality.  If
(i:T\hookrightarrow Y) is a surface support, (3) identifies tensor actions
on the ambient Gamma lattice, but it does not construct a quantum map

\[
 QDM(T)\longrightarrow QDM(Y)
\]

intertwining their formal monodromies.  Therefore the fact that (T) has
empty intrinsic primitive-sixth packet does not yet imply that the ambient
primary projection of (s(i_*V)) is zero.  This is exactly the missing
point-kernel/Gysin clause of the divisorial support-square theorem.

Likewise, Iritani's general blowup theorem proves a formal QDM
decomposition, while its identification with the Orlov semiorthogonal
decomposition through the Gamma lattice is stated as the expected analytic
picture outside the proved toric setting.  The theorem above must not be
reported as that stronger functoriality.

The remaining Silver bridge can now be stated more narrowly:

> prove that ambient primitive-sixth projection annihilates Gamma-framed
> classes supported in absolute dimension at most two, and that the formal
> blowup comparison is equivariant for the descended base-hyperplane loop.

The first clause is the genuinely new supported realization; primary-sector
commutation and the endpoint no longer belong to the mystery.

## Source audit

- Hiroshi Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938,
  equation (1.6) and the monodromy-invariance formulas immediately after
  (1.7), for (3); Remark 1.2 for Cartesian-product naturality.  Cached bytes:
  SHA-256
  `462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a`.
- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555,
  Theorem 1.1 and Remarks 1.4--1.5.  The formal decomposition is proved;
  Gamma/Orlov Stokes identification is described there as expected in
  general and proved in cited toric work.  Cached bytes: SHA-256
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.

## AA / EJ / TT and mystery ledger

- **AA:** this replaces the full-projector commutation axiom by formal
  uniqueness plus Iritani's existing Galois formula.  It does not replace the
  supported Gysin theorem.
- **EJ:** using the whole generalized primary sector removes exponential-block
  permutation as well as phase-marking ambiguity.  The minimal Silver object
  is more canonical than the earlier local-block packet.
- **TT:** commute the two loops before adding categorical structure.  The
  parameter loop already supplies the desired nilpotent; the hard theorem is
  whether low-dimensional support has zero ambient primitive-sixth
  projection.
- **Settled:** primary-sector stability, intrinsic (N_L), and endpoint
  (J_3) calibration on the non-turning locus.
- **Open:** supported Gamma/Gysin annihilation, equivariance of the general
  blowup comparison for the base loop, and transport across turning walls if
  a chosen factorization meets them.

