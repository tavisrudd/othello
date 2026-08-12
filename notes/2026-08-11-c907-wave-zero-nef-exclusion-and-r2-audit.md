# C907 Wave 0: nef-canonical exclusion and codimension-two audit

**Lane:** `clebsch`

**Date:** 2026-08-11

## Verdict

Two formal inputs close, and the analytic frontier moves one step earlier.

1. KKPYY Claim 6.15 is dimension-free: every smooth projective variety with
   nef canonical class has local formal residue classes only `0` and `1/2`.
   In particular every smooth nef-canonical threefold has empty formal cubic
   `+/-1/6` packet.  Quintic Calabi--Yau and sextic general-type hypersurfaces
   are immediate cases, not unresolved carrier tests.
2. For a codimension-two blow-up, Iritani (5.28) has an exact basepoint form
   whose `t`-adic then exceptional-first associated graded is the direct sum
   of the target and one center copy.
3. This does not define a first-Novikov center-valued obstruction.  Even at
   order zero, the published toric analytic theorem leaves equality of the
   residual Stokes structure with the center Stokes structure open.  The next
   analytic calculation is the order-zero residual-center Stokes cocycle for
   `Bl_(P^3) P^5`; first-Novikov differentiation comes only after it vanishes.

No new finite computation supports these conclusions; they are exact
source-level deductions.

## 1. Dimension-free nef-canonical exclusion

Let `Z` be a smooth complex projective variety of dimension `d` with `K_Z`
nef.  Let `(H,nabla)/B_Z` be KKPYY's maximal A-model `F`-bundle, and fix the
rigid even point `b` used in Section 6.3: its coordinate corresponding to the
unit in `H^0(Z)` vanishes.  The restricted `u`-connection is

\[
\nabla_{\partial_u}
=\partial_u-u^{-2}(E_u\star -)+u^{-1}Gr.
\]

Let `T` act as the identity on `H^a(Z)` when `a-d` is odd and as zero when it
is even, and put

\[
g=Gr+\tfrac12T.
\]

The eigenvalues of `g` are integral.  Write

\[
\kappa_{ij}:H^i(Z)\longrightarrow H^{i+2j}(Z)
\]

for the degree blocks of `E_u star`.  Nefness of `K_Z` gives
`kappa_(ij)=0` for `j<=0`.  After adding the parity term
`(1/2)u^(-1)T du` and gauging by `u^g`, the `ij` block of the remaining
operator is `u^(j-1)kappa_(ij)`.  Thus the transformed connection is regular
singular with strictly triangular, hence nilpotent, residue.

The gauge `u^g` shifts residues integrally.  The transformed connection has
only residue class zero; undoing the parity twist leaves classes `0` and
`1/2`.  Hence formal monodromy has eigenvalues only `1` and `-1`, never the
primitive sixth roots corresponding to `+/-1/6`.

### Proposition

At every KKPYY rigid even basepoint in the scope above, the local formal
primitive-sixth-root packet of a smooth nef-canonical projective variety is
empty.

This holds in every dimension.  For threefolds it proves empty formal cubic
support.  The enriched carrier conclusion `ell_(1/6)=0` remains conditional on
the separate realization of C907's analytic Stokes/Gamma/Rees packet.

### Scope

The proposition concerns KKPYY's `k`-analytic/non-archimedean A-model
`F`-bundle and local formal type at its specified basepoint.  It does not
construct a complex sectorial Gamma/Rees object or prove its blow-up
functoriality.  Empty formal support makes phase ambiguity harmless locally,
but passage to C907's enriched invariant remains part of the analytic gate.

For a degree-`d` hypersurface `V_d subset P^4`,

\[
K_{V_d}=O_{V_d}(d-5).
\]

Thus `V_5` and `V_6` are already covered.  Exact quantum-Lefschetz calculations
may test conventions but add no theorem-level evidence: finite vanishing
cannot strengthen the all-orders grading proof.

## 2. Exact codimension-two basepoint matrix

Set the blow-up codimension `r=2`.  Iritani's conventions give

\[
s=1,\qquad t=q^{-1},\qquad q_{Z,0}=-t,
\qquad h_{Z,0}=\rho_Z/2,\qquad a_0=1.
\]

In the normalized bases of Lemma 5.12, equation (5.28) becomes

\[
\Phi|_{Q=\theta=0}
=
\begin{pmatrix}I&0\\ \iota^*&I\end{pmatrix}
+
\begin{pmatrix}
O(t)&O(t^2)\\ O(t)&O(t)
\end{pmatrix}.
\]

The `t`-adic associated graded kills the error but retains `iota^*`.  Putting
the exceptional module first in the two-step dominance filtration kills that
lower-left block, so

\[
gr^{dom}gr_t\Phi_0=I_Y\oplus I_Z.
\]

This is the exact formal basepoint normalization.  It does not include the
analytic Stokes structure or Gamma lattice.  The full comparison is
`Psi=Phi circle FT^(-1)`, not `Phi` alone.

## 3. Why first Novikov order is premature

Iritani's general blow-up theorem supplies a formal Laurent quantum
`D`-module isomorphism.  Its basepoint formula does not supply the coefficients
of the master-space `J`-function needed to compute a general first-Novikov
matrix.

More importantly, the toric weak-Fano analytic theorem decomposes the blow-up
quantum module sectorially into the target and residual pieces, with a
Gamma-induced Orlov decomposition on `K`-theory.  Iritani's Remark 1.4(3)
states that each residual piece has the same formal structure as the center
quantum module but that equality of their Stokes structures is unknown.

Therefore a center-valued first-order extension class is not yet defined.
The prior datum is a sectorial residual-center framing.  Given such framings
`g_a` on consecutive sector overlaps, the literal order-zero mismatch is the
Stokes cocycle

\[
D_a=g_{a+1}^{-1}S_a^{R_\pi}g_a(S_a^Z)^{-1},
\]

modulo simultaneous block-diagonal, lattice- and pairing-preserving gauge.
The residual-center theorem is `D_a=I` for all `a`.  Only after this holds is
there a center-valued first-Novikov derivative to compute.

## 4. Wave-0 algebra and its limit

KKPYY's rationality criterion is stated for abstract `G`-atoms, after the
elementary disjoint-union, blow-up, and projective-bundle equivalences.  The
primitive-sixth-root and Stokes/Rees data live first on geometric atomic
`F`-bundles.  Proposition 5.22 gives a map from abstract `G`-atoms to those
geometric classes, not an identification or injectivity theorem.  Therefore
C907 must define the enrichment geometrically, pull it back along that map,
and verify invariance under every elementary equivalence before using it in a
weak-factorization argument.

The ordinary carrier-height invariant cannot reach `X x P^2`: its cubic
abstract atom is already carried by the allowed threefold `X`.  Thus ordinary
atom multiplicity and carrier height are closed branches, not weakened
versions of the desired length.

The smallest abstract endpoint category is the category of finite-dimensional
nilpotent `C[N]`-modules.  Its indecomposables are

\[
J_l=C[N]/(N^l),
\]

and `End(J_l)` is local.  Hence actual biproducts have a unique multiset of
Jordan lengths.  This distinguishes the endpoint `J_3` from `J_1^3`.

Exact sequences do not suffice:

\[
0\longrightarrow J_1\longrightarrow J_2\longrightarrow J_1
\longrightarrow0
\]

can be nonsplit, and iterated extensions join three `J_1` factors into
`J_3`.  The analytic blow-up theorem must therefore produce an enriched
biproduct, or an associated-graded biproduct retaining a block-diagonal `N`.

At the ordinary Stokes level, the graded object for a globally fixed zero
exponential factor is independent of sector up to continuation and conjugacy;
its filtered-automorphism Jordan form is therefore phase invariant.  This
does not make the projected Gamma lattice phase invariant: Stokes mutation
changes sectorial projections.  The Gamma/Rees realization remains new input.

## 5. Revised next passes

### Analytic

Compute the order-zero cocycle `D_a` for the toric codimension-two pilot

\[
Bl_{P^3}P^5\longrightarrow P^5
\]

in the Orlov Gamma basis.  First verify its fan/charge data and mirror
`GKZ` system.  If `D_a` is trivial, differentiate the same system in one
non-exceptional Novikov direction.  If it is nontrivial, the strict-direct-sum
candidate fails and the cocycle itself becomes the correction datum.

### Carriers

The nef-canonical branch is formally closed.  The universal gap is now:

- pseudo-effective non-nef threefolds, where MMP reaches terminal
  `Q`-factorial models and needs packet transport across contractions/flips;
- non-pseudo-effective threefolds, where Mori fibre spaces require relative
  control of discriminant/gluing data; or
- preferably, a direct dimension-three grading theorem avoiding singular
  MMP models altogether.

Smooth point/curve blow-ups are the first calibration, not the universal
argument.  Fano tables remain counterexample reconnaissance only.

## Sources

- KKPYY, *Birational Invariants from Hodge Structures and Quantum
  Multiplication*, arXiv:2508.05105v2, Section 6.3, Claim 6.15, and
  Section 3.4, Remark 3.14.  Cached SHA-256:
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.
- Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  equations (5.11), (5.19), (5.27), (5.28), Lemma 5.12,
  Theorem 5.18, and Remark 1.5.  Cached SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Iritani, *Global Mirrors and Discrepant Transformations for Toric
  Deligne--Mumford Stacks*, arXiv:1906.00801, Theorem 1.3 and
  Remark 1.4(3).  Cached SHA-256:
  `dc25e5cbd849ee5daa7643d69ae2e77936d5cd343ceb66ce8bbd8e03fbf874c7`.

## Mystery ledger

- **Settled:** nef-canonical varieties have no formal cubic packet in every
  dimension; quintic and sextic threefolds are not open cases.
- **Settled:** the codimension-two basepoint double-associated-graded map is
  the expected direct sum.
- **Open, analytic owner:** identify the toric residual Stokes structure with
  the center, beginning with the order-zero cocycle above.
- **Open, carrier owner:** control non-nef smooth projective threefolds or find
  a length-two counterexample.
- **Open, realization owner:** lift the phase-invariant local Stokes grade to
  a mutation-compatible Gamma/Rees object with block-diagonal `N`.
