# C753 — Paper I Lean proof-spine correspondence closure

**Lane:** `clebsch`

**Status:** active; C752 is complete and its implementation interface is
frozen.  Begin with the finite prose-source repairs and R1; orientation is
split into O1--O8 and must remain packet-gated.

## Current implementation state

R1 is complete at `c9dd5421`.  The committed projective normalization,
one-factorization extraction, and affine parallelism modules now feed the
terminal theorem
`RelativeConicArcs.OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five`.
Its guarded elaboration is green, and its printed axiom set contains only
`propext`, `Classical.choice`, and `Quot.sound`.

The finite source-owned prose repairs are implemented in the authoritative
working tree.  The q11 generator now emits the correct repository-relative
banner, and regeneration changed exactly 55 arithmetic leaves and 11
aggregators.  The misleading “reflected” terminology, “opaque certificates”
wording, and the status-language sentence in `SmallKChordMoments.lean` are
repaired.  `SmallKChordMoments.lean` elaborates cleanly; the q11 generated
bundle remains uncommitted pending its serialized package gate.  The prior
direct elaboration of `Q11A5PointOrbitsData.lean` ended with exit 137 before
Lean emitted a diagnostic and must not be repeated unchanged.  The first
serialized replacement run correctly refused because the Paper II structural
gate already owned the shared build window; retry only after that foreign run
releases the lock.

## Objective

Implement the frozen C752 interface so the Paper I Lean development follows
the same causal spine as the final human proofs, with exact bridges at every
definition and trust boundary.

## Work package

The exact declaration names, files, mechanisms, and gate order are frozen in
`notes/2026-07-31-c752-paper-i-lean-spine-audit.md`, under “Frozen C753
rigidity interface” and “Frozen C753 orientation packets.”  The implementation
order is prose-source repairs, R1--R4, O1--O8, aggregate gate, cold review, and
release synchronization.

1. Formalize the dependency-ordered same-mechanism lemmas frozen by C752;
   do not redesign the interface inside implementation.
2. Prefer structural objects used in the paper---moments, line incidence,
   orbitals, the signed pentagon, switching invariants, principal minors, and
   trace pairings---over opaque coordinate enumeration.
3. For Dye and Hassett--Tschinkel, formalize the exact conditional interfaces
   and their paper-owned deductions unless C752 explicitly admits a bounded
   proof of the imported theorem itself.
4. Prove every paper/Lean definition bridge and normalization lemma named by
   C752. Preserve projective, monomial, and code equivalence distinctions.
5. Repair every C752 prose or naming defect in the owning human source,
   generator, template, schema, or diagnostic. Do not hand-edit generated
   output. Give scholarly-public declarations self-contained mathematical
   docstrings; make headers and comments agree with elaborated statements and
   exact trust routes; remove internal workflow references and stale status
   prose; and give external inputs stable pinpoint citations at the level used.
6. Re-audit the entire touched module and its project-owned transitive
   verification closure, not only changed lines, for mathematical prose,
   names, generated banners, artifact semantics, and trust disclosures.
7. Update the paper claim map, statement identity, trust manifest, axiom audit,
   paper-local replay, and q11 gate only to the strength actually achieved.
8. Obtain an independent cold review that compares the Lean declaration graph
   and referee-facing prose with the human proof graph, and reports any
   parallel-but-unbridged theorem or misleading comment.
9. Synchronize the authoritative paper and standalone mirror only after the
   formal gate and correspondence review are green.

## Acceptance

Every C752 target is closed by a same-mechanism theorem or an exact reviewed
conditional interface. The final claim map exposes all residual axioms and
published inputs, and the human and Lean dependency graphs commute at every
language change. The guarded q11 Lean gate, axiom audit, paper aggregate,
warning-free PDFs, and standalone replay are green. The complete
referee-facing Lean closure is self-contained, mathematically accurate, free
of internal workflow prose, and generated from reviewed owning sources.

## Boundaries

Do not replace a requested structural bridge by a finite endpoint check, alter
the frozen manuscript theorem surface, weaken validation, absorb Paper II or
III, or formalize broad external algebraic geometry without an explicit scope
decision from C752.
