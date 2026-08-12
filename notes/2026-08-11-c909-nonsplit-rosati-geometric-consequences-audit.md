# C909: Rosati commutant and geometric-consequence audit

Date: 2026-08-11  
Scope: explicit EJ/TT follow-up for the nonsplit trace-transfer root-weight
family; no manuscript, PDF, mirror, Lean, or commit change

## Verdict

The trace-transfer condition is intrinsic to a **marked local polarized
lattice**

\[
 (M,B,\iota:O\hookrightarrow \operatorname{End}_{R}(M)),
 \qquad R=\mathbf Z/p^a,
\]

with (O/R) finite etale, (iota(O)) (B)-self-adjoint, and (M) free
over (O).  The perfect trace pairing then recovers the unique unimodular
(O)-form (h) satisfying (B=\operatorname{Tr}_{O/R}h).  This is a marked
isomorphism invariant.

It is not, as currently constructed, an intrinsic characterization of the
bare complex ppav ((A,\lambda)) by its global Rosati commutant.  For
non-CM (E), every quotient in the note is isogenous to (E^g), hence

\[
 \operatorname{End}^{0}(A)\simeq M_g(\mathbf Q).
\]

The nonsplit datum is a local order/action modulo (p^a), together with a
graph presentation.  A finite etale (R)-algebra in this local presentation
need not globalize to a Rosati-stable number-field subalgebra of
(\operatorname{End}^{0}(A)).  Therefore the Rosati commutant is a useful
indecomposability detector for the marked presentation, not a bare-ppav
classification invariant.

## 1. What the commutant does characterize

For the marked local module (M\simeq O^n), the ordinary commutant is

\[
 \operatorname{Cent}_{\operatorname{End}_{R}(M)}(O)=M_n(O).
\]

The two root constructions give:

\[
\begin{array}{c|c|c}
\text{local construction}&n&\text{commutant}\\ \hline
\text{odd }p&1&O\\
\text{dyadic}&2&M_2(O).
\end{array}
\]

The Rosati-fixed part must be taken with respect to (h), not with respect
to an arbitrary matrix transpose.  In the odd case a local commutant (O)
has only idempotents (0,1).  In the dyadic case a self-adjoint idempotent
in (M_2(O)) would give an orthogonal decomposition of the hyperbolic
(O^2).  A proper summand has rank one, but

\[
 h((x,y),(x,y))=2xy\in2O,
\]

so its restriction cannot be unimodular.  Thus the local Rosati commutant
proves polarized indecomposability after the graph quotient, exactly as in
the hostile audit.

The correct intrinsic statement is therefore conditional and marked:

> A graph quotient from a non-CM elliptic power is polarized-indecomposable
> if its marked local Rosati commutant has no nontrivial self-adjoint
> idempotent.

This criterion is invariant under isomorphism of the marked (p)-adic
polarized lattice.  The commutant alone does not recover the trace-transfer
form: one must retain (B), the embedding (O\hookrightarrow M_d(R)), and
the (O)-rank.

## 2. Why this is not yet a bare-ppav invariant

The graph matrix (T) is specified modulo (p^a).  An integral lift gives a
quotient endomorphism because it commutes with its own graph slope, but its
global characteristic polynomial and global Rosati adjoint are not determined
by the finite etale algebra (R[T]\simeq O).  The local trace identity only
says that the reduction of the coefficient polarization is a transfer from
(O); it does not produce a global Rosati-stable number field action.

Consequently, a global PEL/field-commutant conclusion would require an extra
lemma: construct a number field (K\subset\operatorname{End}^{0}(A)), an
order stable under Rosati, and an identification of its (p)-adic order with
(O).  Without that lemma, “nonsplit” is a property of the marked graph
chart/local level structure, not of ((A,\lambda)) alone.  Different local
embeddings can have the same underlying ppav, and the full rational
endomorphism algebra (M_g(\mathbf Q)) is present independently of the
chosen (O).

This is consistent with the audited prior-art boundary: the Rosati/form
dictionary for non-CM elliptic powers is standard (Lange; de Gaay
Fortman--Schreieder), while the finite-etale graph cofactor theorem is the
new synthesis under audit.  No novelty sentence about an intrinsic moduli
invariant is licensed by the present construction.

## 3. Does divisor saturation force a Jacobian?

No immediate consequence follows.  The saturated class

\[
 \gamma_\Theta=\Theta^{g-1}/(g-1)!
 \in \operatorname{im}\bigl(\operatorname{Sym}^{g-1}\operatorname{NS}(A)
 \to H^{2g-2}(A,\mathbf Z)\bigr)
\]

is an algebraic cohomology class represented by an integral combination of
divisor intersections.  This does not make it an **effective** curve class.
The Matsusaka--Ran implication used in the existing cubic audit runs in the
opposite direction: an indecomposable ppav containing an effective curve of
minimal class is a Jacobian.  Debarre's primary result likewise concerns the
locus where a minimal class is represented by an effective algebraic cycle,
not merely where it lies in the divisor-product lattice
([Debarre, arXiv:alg-geom/9301002](https://arxiv.org/abs/alg-geom/9301002)).

Hence polarized indecomposability plus divisor saturation gives neither a
Jacobian obstruction nor a Jacobian realization.  It remains compatible with
the possibility that the ppav is a Jacobian, especially because these
examples are deliberately isogenous to a power of an elliptic curve.  The
“no power isogenous to a Jacobian” results of de Gaay Fortman--Schreieder
apply to very general ppavs and point in the opposite direction from this
special isogeny locus; they do not obstruct the present family
([de Gaay Fortman--Schreieder, arXiv:2401.06577](https://arxiv.org/abs/2401.06577)).

## 4. Moduli and special-subvariety content

For fixed (N=p^a), fixed root-weight graph data, and varying (E), the
construction spreads only after adding finite level structure on (E[N]).
That level cover is finite over a modular curve, so the resulting family in
(\mathcal A_g) has dimension at most one (a fixed (E) gives only a point).
This is a parameter count, not a new codimension theorem.

The finite (p^a)-level trace-transfer condition by itself does not define a
new Hodge or special-subvariety condition: it is discrete level data.  The
one-dimensional family is naturally expected to lie in the isogeny/PEL locus
coming from the diagonal elliptic-power variation, but calling its image a
special subvariety requires proving that the graph quotient spreads as the
corresponding Shimura/PEL morphism.  That has not been supplied here.

A genuine special-locus consequence would follow only from the extra global
field-action lemma in Section 2.  If a Rosati-stable number field (K) of
degree (r>1) were constructed globally, its PEL locus would impose Hodge
endomorphism conditions; the codimension would then be computed from the
resulting Shimura datum, not from the local trace algebra alone.

## Final TT/EJ closeout

- **Settled:** trace transfer is intrinsic for marked local polarized lattices;
  its commutant gives the stated self-adjoint-idempotent test.
- **Settled:** divisor-saturated minimal class is weaker than an effective
  minimal curve, so no automatic Jacobian consequence follows.
- **Bounded:** fixed graph data varying (E) give at most a one-dimensional
  moduli family after finite level; no exact codimension or specialness claim
  is made.
- **Open:** globalize the local (O)-action to a Rosati-stable field/order and
  determine whether the resulting marked family has a genuine PEL closure.

**EJ:** the nonsplit family has a meaningful marked Rosati-commutant
criterion, but not yet a new geometric detector.  
**TT:** the exact separation is local-marked algebra versus global Hodge
geometry; no Jacobian, special-subvariety, or codimension conclusion is being
silently inferred.
