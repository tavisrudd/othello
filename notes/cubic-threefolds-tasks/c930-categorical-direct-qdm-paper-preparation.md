# C930 -- categorical direct-QDM paper preparation

**Lane:** cubic-threefolds

**Status:** queued; phase 1 proof memo and adversarial audit, then phase 2 manuscript adaptation

## Goal

Write a proof memo on top of the current
`papers/cubic-stabilization-irrationality/` manuscript that turns C925's
modular categorical direct-QDM packet into one candidate paper proof.  Use the
memo to determine how the manuscript's proof and narrative should eventually
be adapted around the smallest honest categorical transport theorem, with the
cubic stabilization result as the principal geometric application.  The
unconditional atom proof and the finer conditional framed proof must emerge as
two specializations of that same categorical spine, rather than as parallel
proofs joined only at the conclusion.

## Scope

This item owns the bridge from C925's mathematics-only module library to a
coherent overlay proof memo and manuscript plan.  The current manuscript is
the fixed comparison surface during this phase, with the atom and framed routes
in `papers/cubic-stabilization-epilogue/` supplying the two required
specialization tests.  The item does not silently close any open geometric
provider in C925 or weaken a hypothesis.  During phase 1 it does not edit
either manuscript.  After the memo and adversarial audit are delivered, the
author decides whether and when this same C930 item changes phase and owns the
resulting categorical-paper manuscript edits; no successor task is required
for implementation.

## Deliverables

1. Audit the present theorem, section, and dependency spine of
   `papers/cubic-stabilization-irrationality/` against C925's stable modules.
2. State the memo's candidate headline theorem at the smallest categorical
   level of generality actually supported: the reusable marked-row/point-line
   transport theorem first, followed by the cubic endpoint application.
3. Give two explicit specialization records for the common theorem.  The atom
   specialization must recover the unconditional rank-two
   residue/discriminant proof with only the data it actually consumes.  The
   finer specialization must recover the conditional framed/marked-monodromy
   proof with Hypotheses 5.7R and 5.7T, and their distinct roles, visible.
4. Prove that both records satisfy the same categorical interfaces; identify
   which fields collapse or become automatic in the atom case and which extra
   observations, marks, and providers the finer case retains.
5. Produce a causal proof spine showing the endpoint invariant, local
   wall comparison, adjacent reindexing, one-path weak-factorization transport,
   and final irrationality contradiction, with every conditional provider
   visible at the step where it is consumed.
6. Produce a proposed section architecture and an old-to-new migration map:
   retain, compress, move, split, or cut each current proof component.
7. Give a deletion ledger and page-budget estimate.  The shared categorical
   spine must replace the duplicated atom/framed setup and proof transitions;
   it must not be inserted as a third layer above two intact proofs.
8. Separate the paper's minimal theorem path from optional categorical
   dividends (universal shadows, Writer/State laws, holonomy, ExactTop, charge
   and resonant-saturation alternatives), so the latter do not obscure the
   proof actually used.
9. Identify the smallest publishable version under the presently proved
   inputs, the exact statements still conditional, and the C925 provider gates
   that would change the headline if closed.
10. Red-team every load-bearing arrow for hidden hypotheses, variance or typing
   errors, unlawful reindexing, unsupported exactness/base change, occurrence
   dependence, circularity, endpoint mismatch, and accidental use of a
   countermodel already isolated by C925.  Give the strongest explicit hostile
   model available for every failed implication.
11. Run independent proof-order and narrative-order audits: the proof-order
   audit must reconstruct the theorem from definitions and cited providers;
   the narrative-order audit must test whether a reader can see the mechanism,
   conditional boundary, and cubic payoff without reading optional machinery.
12. Record notation, audience, source, verification, and figure/table needs.
13. End phase 1 with a bounded implementation plan and stop for the author's
   decision.  If directed to continue, carry out that plan under C930: adapt
   the manuscript, then run the scoped build, proof-consistency, cold-read,
   literature, and standalone-mirror gates where applicable.

## Acceptance gate

- A dated proof memo gives the exact theorem ladder, causal proof spine,
  proposed table of contents, and component migration map against the current
  manuscript.
- Every load-bearing C925 input is classified as proved, imported, conditional,
  countermodel/boundary, or optional.
- One categorical theorem and interface diagram specializes exactly to both
  the unconditional atom proof and the finer conditional proof; neither route
  may be recovered by an untyped analogy or an additional parallel spine.
- The memo projects a shorter mathematical body, with named deletions and a
  section/page budget.  The implemented paper must be shorter than its frozen
  pre-edit baseline unless a red-team repair adds indispensable proof content;
  any exception must be itemized and justified.
- The proposed narrative states the governing mechanism before categorical
  abstraction and keeps the cubic theorem visible in the opening pages.
- A red-team ledger records every challenged arrow, the attempted break, the
  result, and the exact remaining evidence gap or repaired statement.
- Delivering the memo and audits does not itself authorize manuscript edits.
  The author decides whether and when C930 enters its manuscript-editing phase;
  if authorized, completion then requires the implemented source and all
  applicable validation gates, not merely the memo.

## Starting points

- `notes/cubic-threefolds-tasks/c925-modular-direct-qdm-proof-packet.md`
- `notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`
- `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`
- `papers/cubic-stabilization-irrationality/sections/`
- `papers/cubic-stabilization-epilogue/cubic_stabilization_epilogue.tex`
- the atom and conditional framed-route sections under
  `papers/cubic-stabilization-epilogue/sections/`
- `papers/style-guide.md`
