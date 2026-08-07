# C834 — the ambient-plane axioms, proved from the cross product

**Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure) · **Date:** 2026-08-06

## What was closed

The structural upgrade's two ambient-plane leaves — that two distinct normalized points lie on a
unique normalized line, and that two distinct normalized lines meet in a unique normalized point —
were decided by native evaluation over the ordered pairs of the 183-point plane. Both are now
proved, and both carry only the foundational axioms. Direct kernel reduction was never an option
here: the two quantified pairs together with the inner search run to about six million steps, well
past the measured per-module ceiling.

## The construction

`PassantCodeQ13.PlaneJoin` develops the join on coordinate triples rather than through the general
cross product on functions from a three-element index type, which would need a conversion layer in
both directions for no gain. Points and lines are paired by the symmetric bilinear form, and the
join of two triples is their cross product. Three polynomial identities over the coefficient ring
carry the whole argument:

- the join is orthogonal to each of its two factors;
- the join of a triple with a join expands as `⟨line, second⟩ • first − ⟨line, first⟩ • second`, so
  a triple incident to both factors has vanishing join with their join;
- a vanishing join makes one triple a scalar multiple of the other, provided that other is nonzero.
  This is the one step needing the field: it splits on which coordinate of the nonzero triple is the
  first not to vanish, and in each case the scalar is an explicit quotient.

Existence is then the normalization of the join, and uniqueness follows because any second incident
representative is proportional to the join and normalization does not move a representative that is
already normalized. Both facts about normalization — that it rescales by a nonzero factor, and that
two normalized representatives differing by a nonzero scalar coincide — were already available and
are reused rather than rebuilt.

Because the pairing is symmetric, the meet of two lines is the join of two points with its arguments
exchanged, so the dual theorem costs three lines. That symmetry is what the plan meant by only one
of the two being a real obligation.

The one finite check in the new module is that no normalized representative is the zero triple, over
the 183 representatives, by kernel reduction.

An incidental simplification: the membership lemma needs no nonzero hypothesis. A triple whose first
two coordinates vanish — the zero triple included — normalizes to the vertical representative, which
is a listed representative, so normalization lands in the displayed list for every triple.

## Validation

`PassantCodeQ13.PlaneJoin` builds in 15 seconds on its own. `PassantCodeQ13.Gates.Main` then rebuilt
in 12 minutes and `PassantCodeQ13.Gates.AxiomAudit` in 5 seconds, both green, and the evidence
verifier passes with the manifest digest of `StructuralUpgrade.lean` refreshed.

The audit's 94 terminals now report 61 carrying only `propext`, `Classical.choice` and `Quot.sound`,
against 58 before this change and 53 at the start of the day, with 33 still carrying a
declaration-local native-evaluation axiom.

## What remains in the structural upgrade

Three leaves, all over the 364-member decoded support family: constancy of the unary degree at 56,
recovery of the polarity rows by concurrence-eight neighbourhoods, and the split of the fused
concurrence-six colour. These are the ones the plan routes through the equivariance transporters,
reducing the per-point statement to one representative point and the two per-pair statements to six
representative pairs. That work is unaffected by this round and remains the next step in the module.

## Mystery ledger

- **Why the plan expected the collinearity direction to be the hard part.** Settled, and in the
  plan's own favour: it had already been revised to name incidence symmetry as the real content and
  the remaining step as available in the pinned Mathlib. In the event neither was needed as
  imported, because stating the join on triples made all three identities immediate and the
  proportionality step a three-case field argument.
- Nothing else in this round is unexplained.
