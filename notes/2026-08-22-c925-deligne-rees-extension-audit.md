# C925 logarithmic extension and Kummer-trait drift

**Lane:** `cubic-threefolds`

## Conclusion

Canonical logarithmic extension is compatible with more of the marked Rees
construction than the first (z^{-1})-pole objection suggested.  After the
rank-two elementary modification, C924 proves that every even base-direction
connection is regular in (z).  Hence, over a punctured coefficient trait, the
deck-stable sum of the modified blocks is an ordinary relative connection over
a coefficient ring retaining (z=0).  A relative Deligne--Manin theorem can
extend that object if the trait connection is regular singular.

This does not supply the finite affine-Bruhat reduction proposed in the marked
Rees report.  Exact cubic period, effectiveness, and self-duality admit
arbitrarily large relative coweights.  The family

\[
  A_k=\mathbf C[[q,h]][x,e]/(x^3-qh^{3k},e^2),\qquad k\geq0,
\]

has a fixed graded self-dual special fibre.  On the diagonal trait (q=h=r),
its cubic exponent is (3k+1), so its sheet action still has exact period
three, while its generic paired comparison with (u^3=r) has coweight

\[
  (0,-k,-2k,2k,k,0),
\]

or, after sorting,

\[
  (-2k,-k,0,0,k,2k).
\]

These coweights are unbounded.  Lean checks the period, self-duality,
unit/top normalization, injectivity, and unboundedness in
`Comparison.KummerTraitRescaling`.

The source target must therefore do one of two stronger things:

1. construct a primitive marked valuation/cocharacter from the actual
   divisor equation, rather than from the period alone; or
2. quotient the coweight and first Rees jet simultaneously by loop-trivial
   cocharacter drift, and prove that the resulting pointed port still
   determines the modified-residue marker.

A bounded affine-coweight theorem without one of these clauses is false.

## Why the (z)-integral objection is not decisive

On one centered rank-two block, write the (z)-connection as

\[
 z\partial_z=z^{-1}N+A_0+zA_1+\cdots,
 \qquad N^2=0,\quad N\ne0.
\]

Pairing horizontality makes (L=\operatorname{im}N=\ker N) isotropic and
forces (A_0L\subseteq L).  The elementary modification

\[
 B^\sharp=\{s:s\bmod z\in L\}
\]

is therefore regular in the (z)-direction.  For a centered even
base-direction connection

\[
 \partial+B_\partial(z),\qquad
 B_\partial=z^{-1}C_\partial+C_{\partial,0}+O(z),
\]

flatness gives (C_\partial=q_\partial N).  After modification, the only
possible base pole is (z^{-1}kE_{21}).  Modified flatness forces (k=0), so

\[
 B_\partial^\sharp=G_\partial+O(z),
 \qquad \partial R=[G_\partial,R].
\]

Thus the modified block is a connection over a ring containing
\(\mathbf C[[z]]\), rather than only after inverting (z).  Since the line
\(L\) is intrinsic, a deck transformation permuting three blocks also
permutes their modified lattices.  Their direct sum descends over the
punctured cubic trait.  What is not automatic is regular singularity at the
missing point or identification of the resulting logarithmic extension with
the native cohomology order.

This corrects the earlier coarse diagnosis that the relative logarithmic
theorems were unusable merely because the unmodified QDM base connection
contains (z^{-1}).  The elementary modification removes exactly that pole on
the marked block.

## What logarithmic-extension theory supplies

Deligne, *Équations différentielles à points singuliers réguliers*, Chapter II,
Proposition 5.2, constructs the unique logarithmic extension with nilpotent
residues for unipotent monodromy and proves exactness and compatibility with
the usual tensor constructions.  Proposition 5.4 constructs the canonical
extension for an arbitrary chosen section
\(\tau:\mathbf C/\mathbf Z\to\mathbf C\); Remark 5.5 warns that this general
choice is not tensor-compatible.  Theorem 5.9 identifies regular-singular
connections with finite-dimensional representations.  The checked source is
DOI `10.1007/BFb0061194`, cached PDF SHA-256
`0dc37edd7758198cc4cd7ebed0dae63ff821336cebe739636a31591671593ba2`.
Read depth: Chapter II, Section 5, Propositions 5.2 and 5.4, Remark 5.5,
Corollary 5.6, and Theorem 5.9.

Hai and dos Santos, *Regular-singular connections on relative complex
schemes*, arXiv:2002.06629, give the relative form needed to retain a complete
coefficient base.  Proposition 6.5 proves stability under subobjects,
quotients, tensor products, and duals.  Theorem 6.8 constructs a unique
relative-vector-bundle Deligne--Manin extension over a finite-dimensional
local complex algebra after choosing the exponent section.  Theorem 6.11
assembles compatible logarithmic models over a complete noetherian local
complex algebra.  The checked v2 PDF has SHA-256
`ff04accf7b067ecbb9dd07fe236a57c9f5e5b70c2e8f5d59dd4e39c6bd2ed17a`.
Read depth: introduction; Sections 6.1--6.3 through Theorem 6.11 and Lemma
6.12; relevant construction material in Sections 5.4--5.5.

Achinger, *Regular logarithmic connections*, arXiv:2304.01135, Theorem 3.17,
gives a complementary algebraic canonical-extension equivalence for
\(\tau\)-adapted logarithmic connections and proves that local freeness is
preserved.  It is a corroborating absolute/logarithmic source, not the
relative (z)-adic provider.  The checked PDF has SHA-256
`712dee78d155aa94a3aba535ba033e5ccc0ceebf7fd5be3db247880547e1c480`.
Read depth: Section 3.3, Definition 3.16, Theorem 3.17, and Lemma 3.18.

Applied to C925, these theorems give a conditional construction:

\[
 \begin{gathered}
 \text{deck-stable modified orbit on a punctured trait}\\
 +\ \text{relative regular singularity}\\
 +\ \text{noetherian complete coefficient base}
 \end{gathered}
 \quad\Longrightarrow\quad
 \text{a functorial logarithmic modified carrier}.
\]

They do not prove the hypotheses for Iritani's Laurent correction, identify
the extension with the native large-radius order, or give a finite relative
coweight.  In the non-unipotent case, pairing compatibility also requires an
exponent choice compatible with duality; it must not be inferred from the
general canonical-extension statement.

## The Iritani trait is not automatically regular singular

For a codimension-two center, put (t=q^{-1}).  Iritani's center monomials
pull back as

\[
 Q_Z^d\longmapsto Q^{i_*d}q^{-\rho_Z\cdot d}
 =Q^{i_*d}t^{\rho_Z\cdot d}.
\]

The normal first Chern class (ho_Z=c_1(N_{Z/Y})) need not be nef.  Hence
the naive (t\to0) pullback can contain arbitrarily negative valuations and
need not define a regular-singular effective degeneration of the center QDM.
The relative Deligne--Manin theorem cannot repair this failure: regular
singularity is an input.

One can make the monomials effective by moving the ambient Novikov variables
along the same trait.  If (H) is ample on (Y), then

\[
 Q^\beta\longmapsto c_\beta t^{M H\cdot\beta}
\]

makes (M H|_Z+\rho_Z) ample for sufficiently large (M).  Scaling (M) by
a common multiple of the finite packet-action orders can make the added
ambient loop act trivially on the chosen finite packet.  This preserves its
permutation fingerprint while producing an effective trait.

The construction has no canonical size.  Increasing (M) changes the
relative lattice coweight by a loop-trivial cocharacter.  The following family
shows that this ambiguity is genuinely unbounded even before the full QDM
adapter is imposed.

## The unbounded effective family

Give (x,e) half-cohomological degree one, (q) degree three, and (h)
degree zero.  Then

\[
 A_k=\mathbf C[[q,h]][x,e]/(x^3-qh^{3k},e^2)
\]

is a graded free rank-six algebra with basis

\[
 (1,x,x^2,e,xe,x^2e).
\]

The coefficient of (x^2e) defines a Frobenius functional with unimodular
pairing, and the special fibre is always

\[
 \mathbf C[x,e]/(x^3,e^2).
\]

On (q=h=r), adjoining (s) with (s^3=r) gives

\[
 x=s^{3k+1}.
\]

The deck generator (s\mapsto\zeta_3s) therefore sends
\(x\mapsto\zeta_3x\), independently of (k).  If it also sends
\(e\mapsto\zeta_3e\), the top class and Frobenius functional are fixed.  Thus
the three doubled factors have the same exact external period for every
\(k\).

Over (K=\mathbf C((r))), compare with

\[
 A_0=K[u,\epsilon]/(u^3-r,\epsilon^2)
\]

by

\[
 u\longmapsto r^{-k}x,
 \qquad
 \epsilon\longmapsto r^{2k}e.
\]

The coefficient of (u^2\epsilon) is preserved.  On the ordered basis
\((1,u,u^2,\epsilon,u\epsilon,u^2\epsilon)\), the six valuations are

\[
 (0,-k,-2k,2k,k,0).
\]

They pair to zero under the basis involution and fix the unit and top class.
The positive coordinate (k) is unbounded, while the reduced cyclic period is

\[
 \frac{3}{\gcd(3,3k+1)}=3.
\]

This is an exact algebraic family, not an assertion that every member is the
native QDM of a smooth projective threefold.  It falsifies only provider
statements whose hypotheses stop at effective graded Frobenius order,
self-duality, and exact cubic sheet period.  A full divisor-equation/QDM
calibration may still rule it out, but that extra datum must be stated.

## Lean correspondence

The module

`TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerTraitRescaling`

proves:

- `rescalingCoweight_unit_top`;
- `rescalingCoweight_selfDual`;
- `rescalingCoweight_injective`;
- `liftedCubicCharge_fixedness`;
- `liftedCubicCharge_reducedPeriod`; and
- `exists_exactCubicCharge_with_coweight_above`.

The last theorem packages the unboundedness statement.  The proof is
structural rather than a finite search, so no Rust certificate is needed at
this stage.  This is the compression step after the earlier Rust-to-Lean
finite chart census.  The module does not formalize the quotient algebra,
Frobenius functional, logarithmic extension, or geometric QDM realization.

Standalone elaboration passed in guarded run
`20260822-223404-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma`.
The module target and reviewer interface passed queued runs
`20260823-053609-f84147b4` and `20260823-053942-346c32a3`.
The guarded axiom audit passed in run
`20260822-224141-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma`;
the six new public theorems use only `propext`, `Classical.choice`, and
`Quot.sound` where reported.  No `native_decide`, admitted declaration, or
external oracle is used.

## Revised source interface

The candidate adapter should no longer assert that every effective marked
calibration lies in one fixed bounded affine-Bruhat union.  A safe interface
has the following shape.

1. `OccurrenceOrbit`: the exact-(4/9) primitive factors and the actual based
   loop action.
2. `ModifiedFlatCarrier`: the deck-stable sum of their intrinsic elementary
   modifications, with the regular even-base connection proved by modified
   flatness.
3. `EffectiveTrait`: a trait on which the pulled-back center coefficients are
   nonnegative and the extra ambient winding acts trivially on the selected
   occurrence.
4. One of:
   - `PrimitiveMarkedValuation`, fixing the integral valuation of a separating
     divisor eigenbranch; or
   - `PortModuloTrivialCocharacters`, carrying both coweight and first jet and
     proving the residue marker invariant under the loop-trivial cocharacter
     action.
5. `RelativeLogExtension`: regular singularity and the hypotheses needed to
   apply the relative Deligne--Manin extension over the retained (z)-adic
   coefficient base.

The fifth item constructs a canonical logarithmic carrier after the first
four have selected the correct trait and equivalence relation.  It does not
replace them.

## Highest-EV next test

Compute the action of the rescaling cocharacter

\[
 (0,-k,-2k,2k,k,0)
\]

on the first marked Rees jet and the normalized recurrence.  There are two
decisive outcomes.

- If the coweight shift and derivative jet cancel and preserve the residue
  discriminant, define the port modulo this semidirect action and rerun the two
  native-order charts on the quotient.
- If they do not, the proof needs a genuinely primitive geometric valuation;
  regular-singular extension and exact loop transport alone cannot close the
  (m=2) gate.

This test is finite and gauge-covariant.  It is more informative than
enumerating additional bounded affine cells.
