# C944 — Complete-ports recovery terminology revision

**Lane**: `complete-ports`

**Status**: ACTIVE

## Intent

Retire “port” as a technical noun in the complete-ports manuscript and recast
the exposition in coding-theory language centered on recovery sets, recovery
structures, and normalized dual recovery equations.  Preserve every theorem,
hypothesis, formula, example, reliability law, and formal-coverage boundary.

## Semantic guardrails

- Distinguish exact helper supports of normalized dual words from the standard
  upward-closed family of recovery sets.
- Use “repair” for the operational process, events, radii, and reliability.
- Treat the normalized dual words as recovery equations rather than assigning
  them another branded noun.
- State `z_x(I)` as the persistent or eventual confinement threshold: for a
  fixed concatenation the nonzero-functional weighted cost remains part of the
  exact gate.
- Present locality, overlap statistics, recovery-set data, and coefficient data
  as successively richer information, not as a literal inclusion of unlike
  mathematical objects.
- Preserve exact Lean declaration and module identifiers as code identifiers;
  a formal API rename is outside this manuscript task.

## Acceptance gates

1. Every whole-word manuscript use of “port” is classified and removed from
   mathematical prose, except an exact formal identifier if unavoidable.
2. The title, abstract, introduction, main theorem, MDS theorem, section
   headings, figure, and conclusion expose the standard terminology and the
   support/coefficient distinction accurately.
3. Claim-map prose, annotations, statement digests, verification ledgers,
   README, and metadata agree with the revised manuscript.
4. The deterministic manuscript and public-formal release gates pass with no
   mathematical or provenance drift.
5. The standalone paper export is synchronized and independently verified; no
   push or deposit is made.

## Result

Pending.
