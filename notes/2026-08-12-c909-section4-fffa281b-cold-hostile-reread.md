# C909 — cold hostile reread of Section 4 at fffa281b

Date: 2026-08-12

Status: audit only; no manuscript, PDF, mirror, bibliography, ledger, or Lean
file was changed.

## Verdict

**GO / MINOR repairs.** Section 4 is mathematically coherent in the scope it
actually prints: nu_6 is the primitive-sixth-root multiplicity of the framed
small-even quantum connection; the blowup and projective-bundle comparisons
transport that invariant; and the V14 statement uses Kuznetsov's smooth
projective-bundle flop plus the separately computed small-even cubic count.
There is no surviving major defect in the fourfold weak-factorization
argument, the exact cubic value 2, or the all-smooth V14 quantifier.

Minor repairs:

1. **Name the parity-dependent comparison fields.** The manuscript locally
   writes u=q^{-1/(c-1)} in the blowup proof (lines 163--177) and
   u=q^{-1/r} in the projective-bundle proof (lines 208--216), then says it
   extends scalars to “Iritani's Laurent comparison field.” Iritani's source
   uses s_c=c-1 for even codimension c and s_c=2(c-1) for odd c, with the
   QDM decomposition over C[z]((q^{-1/s_c})). Iritani--Koto use r'=r when
   r-1 is even and r'=2r when r-1 is odd, with the projective-bundle
   decomposition over C[z]((q^{-1/r'})). Thus the rank-two P1 comparison
   uses q^{-1/4}, although its mirror coordinate uses q^{-1/2}. The proof's
   ordering (finite-quotient base-shift argument first, scalar extension and
   Psi afterwards) avoids a mathematical failure, but it should state these
   fields and say that the extra root is a coefficient extension. Otherwise a
   reader can infer incorrectly that B_j already contains the full comparison
   matrix.

2. **Define the specialized notation.** The low-dimensional proposition uses
   nu_6(T;chi), and (4.3) uses nu_6(C;chi_j), without a formal definition.
   Add one sentence: this is the framed small-even invariant after scalar
   extension along the displayed strictly Novikov-admissible monomial map.

3. **Make the stabilization sentence implication-shaped.** The theorem says
   “nu_6 is invariant under one P1-stabilization.” The proof correctly
   establishes
   X x P1 birational Y x P1 => nu_6(X)=nu_6(Y)
   by obtaining 2 nu_6(X)=2 nu_6(Y) and cancelling in Z. It does not assert
   nu_6(X x P1)=nu_6(X); (4.2) gives the factor 2. Rewrite this as “one-P1
   stable-birational equality for threefolds” or print the implication.

4. **Tighten Cai's scalar-block wording.** Cai displays the two remaining
   rank-one blocks as scalar exponential solutions
   exp(plus-or-minus 6 sqrt(3) q^(1/2) z^(-1))(1+O(z)), with integral
   z-power prefactors. “Their formal-monodromy factors are 1” is source-exact;
   “have integral residues” is harmless but less precise. The rank-two block
   has roots -1/6 and -5/6, hence exactly one e^(pi i/3) and one
   e^(-pi i/3). Cai's Proposition 6 advertises the fractional pair for the
   big connection; the exact upper bound comes from the full small-even
   Section 3 block display.

These are local clarity/source-interface repairs, not a change in the
conclusion. The parity-dependent root extensions are not a major obstruction:
the manuscript performs the finite-quotient calculation before extending to
the cited comparison field, and framed formal monodromy is unchanged by
coefficient extension.

## Theorem checks

### Fourfold birational invariance

The theorem at sections/04-one-step.tex:349--376 has the correct orientation
and dimension bound. A birational map of smooth projective d-folds with d<=4
factors into blowups/blowdowns with centers of codimension at least two, hence
center dimension at most two. Formula (4.3), specialized low-dimensional
vanishing, and reversal of the elementary relations give equality in both
directions. No atom-group cancellation is used. Rational projective d-folds
with d<=4 have zero nu_6 because P^d is the projectivization of a rank d+1
trivial bundle over a point.

The proof works directly with the printed small-even framed connection and
the local numerical Novikov/base-shift lemmas; it does not infer that an
abstract KKPYY atom class automatically carries nu_6.

### Exact cubic value

The opening definition explicitly fixes the small-even connection, so Cai's
even-cohomology convention is not a defect here. For a smooth cubic
threefold, N_1 has rank one. Cai's Section 3 gives two scalar exponential
blocks with integral z-power prefactors and a rank-two zero-exponential block
with indicial polynomial

  rho^2+rho+5/36=(rho+1/6)(rho+5/6).

The original-disc formal-monodromy eigenvalues are e^(-pi i/3) and
e^(pi i/3). Therefore the printed equality nu_6(X)=2 is valid for the
invariant defined in Section 4. It does not claim equality for a full
odd-inclusive KKPYY super-atom.

### V14 corollary and attribution

Kuznetsov's Theorems 2.17--2.18 give, for every smooth V14, a smooth Pfaffian
cubic X, rank-two bundles U on V and E on X, and a flop between the smooth
projective fourfolds P_V(U) and P_X(E*). The corollary uses only the
paper-local formulas:

  2 nu_6(V)=nu_6(P_V(U))=nu_6(P_X(E*))=2 nu_6(X)=4.

Thus nu_6(V)=2 and nu_6(V x P1)=4, contradicting rationality of a smooth
fourfold. The nu_6 equality, stable-birational function-field step, and
irrationality conclusion are formal corollaries, not claims of Kuznetsov.
Kuznetsov's stronger Remark 2.19 (the bases are already birational) is
optional and not needed by the printed flop proof. The quantifier “every
smooth prime Fano threefold of genus eight” is supported by the all-smooth
source theorem, not merely by a generic period-locus argument.

## Source/read-depth record

**New full-text count: 0.** This is a cold reread using the committed
manuscript and inherited source audits. Official arXiv HTML/TeX was checked at
load-bearing theorem loci, but no new source was read cover-to-cover or cached
in this pass.

- Jiaji Cai, The cubic threefold is symplectically irrational,
  arXiv:2608.01577v1: full text, inherited; Section 3 and Propositions 6--7;
  cache key arXiv:2608.01577, SHA-256
  06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e.
- Hiroshi Iritani, Quantum cohomology of blowups, arXiv:2307.13555v3:
  partial, inherited and official TeX spot-check; introduction's
  comparison-ring definition, Theorem 5.18, and Fourier-projection parity
  parameter s_c; cache key arXiv:2307.13555, inherited SHA-256
  c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b.
- Hiroshi Iritani and Yuki Koto, Quantum cohomology of projective bundles,
  arXiv:2307.03696v4: partial, official arXiv HTML; Theorem 1.1,
  Theorem 1.7/5.1, Section 5.1 equations (5.1)--(5.3), (5.8)--(5.10), and
  the global-generation twist. No local cache SHA was generated in this pass.
- Alexander Kuznetsov, Derived categories of cubic and V14 threefolds,
  arXiv:math/0303037v1: full text, inherited; Section 2, Theorems 2.2,
  2.17--2.18, and Remark 2.19; cache SHA-256
  3223183a958572759e6f8ac3a26a7801c1dd13c6e6edd04f917d1646b5ec2a74.
- Katzarkov--Kontsevich--Pantev--Yu, Birational Invariants from Hodge
  Structures and Quantum Multiplication, arXiv:2508.05105v2: partial,
  inherited; Theorems 4.1, 4.5, 4.11, Proposition 5.22, and Claim 6.15;
  cache SHA-256
  2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64.

## Surface/ledger boundary

This note audits theorem text only. The owning novelty row remains
papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md, whose safe
posture is “formal corollary/application,” not a source theorem or
unqualified first claim. No manuscript, ledger, snapshot, or public summary
was edited.
