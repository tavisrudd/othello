# C928: closure of the inherited relative-Ext and descent debts

**Date:** 2026-08-20

**Verdict:** both debts are closed without adding a dependency to the lattice
paper

## Relative Ext object

The pass-5 twist lemma asserted normalization independence for the relative
Ext object

\[
E=R\mathcal Hom_{\pi_{12}}
(\pi_{13}^*\mathcal E,\pi_{23}^*\mathcal E)[1]
\]

under

\[
E\longmapsto
\operatorname{pr}_1^*N^\vee\otimes
\operatorname{pr}_2^*N\otimes E.
\]

Its proof forced every degree-three odd leg into the ambient Lefschetz
image.  The corrected lattice theorem gives explicit half-integral classes
outside that image, so the proof does not establish the claim.

The direct rank-three Chern formula in the mutation-comparison note repairs
the universal-family class `c_4(Ecal)` only.  It does not repair the two-sided
relative-Ext twist.  No later C908 theorem computes the missing leakage.

The clean closure is therefore retraction, not another conditional lemma:

- the pass-5 note now excludes relative-Ext Chern classes from its examples;
- Theorem E is narrowed to classes whose normalization-independent residue
  is proved separately;
- the valid rank-three universal-family branch is retained;
- C928's lattice and intersection-cohomology theorems do not use the
  relative Ext object at all.

This closes the correctness debt.  Repairing the relative-Ext branch would
be a new C908 construction problem and is not a gate on C928.

## Span-model descent

The current lambda-reduction note already contains the corrected Lemma D:
the span-model family descends along the degree-six map `q`, up to the base
twist tracked there.  It records the earlier swap-antisymmetry obstruction as
superseded and proves that it never prevented descent.

No further source edit is needed.  The C908 task card was stale and has been
updated to reflect that this debt was already closed.  The correction
strengthens the negative `(1,5)` verdict but does not populate a new Chow
channel.

## Dependency consequence

Neither the universal family, its relative Ext convolution, nor the
span-model descent enters the C928 theorem graph.  They belong to the route
by which the lattice was discovered and tested, not to the proof of the
lattice or `IH^3(Theta,Z)`.

## Mystery ledger

| question | status | evidence or boundary |
|---|---|---|
| Is relative-Ext twist invariance proved? | no; claim retracted | corrected half-integral `H^3(M)` invalidates the only proof |
| Does that weaken C928? | no | no dependency path from Ext classes to the lattice theorem |
| Does the span model descend? | yes | corrected Lemma D in the lambda-reduction note |
| Should relative Ext be repaired under C928? | no | it would be a new C908 cycle-construction branch |
