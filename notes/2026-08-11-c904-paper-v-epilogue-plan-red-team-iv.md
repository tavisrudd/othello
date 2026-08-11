# Paper V and epilogue plan: fourth red team on torsor quotient compression

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** hostile review of the proposal to remove the golden/exotic
basepoint calibration by working up to deck conjugacy. No manuscript, Lean,
mirror, or release edit.

## Verdict

**GO for the unmarked geometric theorem; NO for a canonically named sheet.**

The calibration gate can be removed if the epilogue states its realization
theorem for the unordered exotic conjugacy class and proves every downstream
construction deck-equivariant. The correct comparison is then equality of
isomorphism classes in the groupoid of outer-normalizer-equivariant
\(C_2\)-torsors. No pointwise identification is required.

This does not prove that Paper V's chosen golden orientation canonically names
one exotic sheet. If that marked claim remains desirable, the intrinsic
calibration problem from the third red team returns unchanged.

## First correction: do not use the naive action quotient

For a free transitive \(C_2\)-set \(E\), the action groupoid
\(E//C_2\) is contractible: it has one isomorphism class and trivial
stabilizers. Passing to it erases precisely the torsor structure the series is
trying to remember.

The correct object is the groupoid

\[
\operatorname{Tors}^{N}_{C_2}
\]

of \(N\)-equivariant \(C_2\)-torsors and equivariant isomorphisms, where
\(N/A_5\simeq C_2\) is the common outer-normalizer quotient. The content is
that

\[
[\mathscr O_{\mathrm{gold}}]
=
[\mathscr E_{\mathrm{ex}}]
\quad\text{in}\quad
\pi_0\operatorname{Tors}^{N}_{C_2}.
\]

This is not the vacuous fact that two abstract two-element torsors are
isomorphic. It uses the same nontrivial outer action on both. Once the action
is verified, the isomorphism class is unique, although any literal
isomorphism still has a deck-conjugate mate.

## Why the calibration can disappear

Suppose every construction \(F\) after the torsor comparison is equivariant:

\[
F(\omega^2)\simeq sF(\omega),
\]

with \(s\) the deck involution. Then the two choices of
\(\mathscr O_{\mathrm{gold}}\to\mathscr E_{\mathrm{ex}}\) yield the same
unmarked output up to the declared equivalence. The epilogue may canonically
state:

> the reconstructed carrier determines an exotic conjugacy class of
> principal gluings, and the marked cubic pencil realizes one member of that
> class.

The theorem then proves the same period degree, primitive minimal class,
universal \(CH_0\)-triviality, and stabilized irrationality for either member.
No theorem should say which member is \(\omega\) without extra calibration.

## Exact deck-equivariance gates

The quotient formulation is valid only after all of the following are proved.

1. **Integral lattice.** The deck representative carries the
   \(\omega\)-overlattice isomorphically to the \(\omega^2\)-overlattice and
   preserves the symplectic form. Existing exact lattice work strongly
   supports this, but the published proof must be structural.
2. **PEL and period curves.** The two exotic PEL components are exchanged by
   the deck action, and the period-image normalization and generic degree are
   preserved. A fibrewise lattice isomorphism alone does not prove this
   family-level statement.
3. **Cubic family.** Either the deck action lifts to the marked cubic parameter
   curve or the theorem explicitly treats the two conjugate period images
   without claiming an isomorphism of marked families.
4. **Minimal class.** The local graph-slope primitivity theorem is invariant
   under \(\omega\leftrightarrow\omega^2\), including its integral divisor
   realization and factorial normalization.
5. **Voisin consequence.** Universal \(CH_0\)-triviality is asserted for both
   conjugate realizations or shown to depend only on the underlying ppav
   isomorphism class.
6. **Quantum half.** The sixth-root obstruction is independent of the sheet;
   this should be automatic because it holds for every smooth cubic, but the
   logical independence should be stated.

The family-level PEL/period item is the only genuinely new risk. If its degree
or normalization is sheet-sensitive, the calibration cannot be discarded.

## Paper V compression: valid but stack-sensitive

The proposed replacement of repeated sign checks by a principal cover

\[
\widetilde{\mathcal C}\longrightarrow\mathcal C
\]

is structurally sound if the orientation-forgetting functor is representable
and free over the declared essential-image groupoid. Automorphisms at special
objects can otherwise turn the cover into a stacky quotient rather than a
principal torsor. Paper V must compute the stabilizers once and state the
correct categorical level.

If freeness holds, this is a real compression:

- all three marked reconstruction groupoids are pullbacks of one cover;
- the round-trip signs become naturality of that cover;
- the marking boundary is the nontriviality of its \(C_2\)-class;
- pairwise orientation calculations disappear.

Paper IV remains parallel rather than part of the same Cartesian square: its
\(C_3\)-torsor lives over a different reconstructed carrier groupoid.

## The serious narrative tradeoff

Removing the sheet calibration also weakens the claim that Paper V's full
golden orientation is causally necessary for the epilogue.

The current integral envelope

\[
A(\Omega)^\vee e\oplus A(\Omega)f
\]

and the unordered exotic pair may already be determined by the abstract
\(A_5\) six-set \(\Omega\). That six-set is classical and is visible directly
in the cubic geometry. If the golden plane, selected chordal line, and
orientation do no further work, then the series-to-epilogue connection is:

> the sparse shadows reconstruct a carrier that can independently be used in
> the geometric theorem,

not:

> the complete marked output of Paper V forces the geometric realization.

This is still an honest punchline, but it is provenance rather than strict
logical necessity.

There are three acceptable exits:

1. **Unmarked exit.** Accept that V recovers the six-set and its torsor profile;
   the epilogue realizes the resulting exotic conjugacy class. This is the
   cleanest and lowest-risk paper.
2. **Marked exit.** Find the intrinsic golden/exotic calibration and recover
   the stronger claim that V's orientation selects a literal sheet.
3. **Intermediate exit.** Show that some other marked output of V---for
   example the golden plane or selected chordal line---determines the
   parameter marking, monodromy line at three, or period-map normalization,
   even though it does not name \(\omega\).

The plan should default to the first exit. The second or third is an upgrade,
not an acceptance gate for the separation theorem.

## Paper IV after compression

Paper IV needs no new computation to play its structural role. Its existing
hidden-field theorem already determines the Frobenius orbit
\(\{\alpha,\alpha^2,\alpha^4\}\). The exact toric-orbit labeling is an optional
illustration of stabilizer refinement, not an integration gate.

This is beneficial for formalization: a one-paragraph corollary can reuse the
existing theorem, while the general finite-field descent lemma is proved in
the epilogue. Do not enlarge Paper IV merely to make it appear more causal.

## Strength and priority after the correction

The quotient formulation improves canonicity and shortens Paper V. It does
not add external theorem strength to the successor. The Annals case remains:

1. strong period-image realization of the exotic conjugacy class;
2. structural integral minimal-class algebraicity;
3. universal \(CH_0\)-triviality for the non-isotrivial family;
4. a self-contained proof that every cubic remains irrational after one
   stabilization.

The series connection becomes more honest: it produces the conjugacy class,
not a coordinate name. If referees regard the finite reconstruction as
ornamental, the epilogue must still stand on its separation theorem and period
geometry alone.

## Revised acceptance tests

1. Define the groupoid of \(N\)-equivariant \(C_2\)-torsors; do not use the
   contractible action quotient as a substitute.
2. Prove that the upper orientation cover is a genuine principal cover of the
   declared carrier groupoid, including stabilizer checks.
3. Prove that the outer actions on \(\mathscr O_{\mathrm{gold}}\) and
   \(\mathscr E_{\mathrm{ex}}\) are both nontrivial, hence define the same
   equivariant torsor class.
4. Prove deck-equivariance of the lattice, PEL, period-degree, minimal-class,
   and family statements.
5. Audit exactly which geometric outputs use the six-set, golden plane,
   selected chordal line, and orientation. Do not call unused data causal.
6. State every unmarked theorem for the exotic conjugacy class or “either
   member,” never for a canonically named \(\omega\)-sheet.
7. Keep the Paper IV toric labeling optional.
8. If any marked sheet statement survives, restore the intrinsic calibration
   as a separate theorem rather than smuggling in a basepoint convention.

## Final hostile recommendation

Adopt the equivariant-torsor-class formulation and make the unmarked exit the
baseline plan. It removes an artificial normalization gate and gives Paper V
a cleaner structural proof.

Do not claim that the problem has vanished until the family-level deck action
and dependency audit pass. The cheap exact next move is to trace the deck
involution through the PEL curve and period map, then tabulate which output of
Paper V each epilogue theorem actually consumes. That audit will decide
whether the quotient formulation is a genuine compression or merely a loss of
the strongest series-causality claim.
