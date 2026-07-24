# Formalization ledger

The shared definitions are fixed in
`RelativeConicArcs.AMELU.Definitions`, with import-only terminal
`RelativeConicArcs.Gates.AMELUDefinitions`.  The dictionary is proved
unconditionally.  The admitted-pencil classification now has a
hypothesis-explicit Lean interface; it is not adopted as an unconditional
formal proof of its geometric and holonomy inputs.

| Manuscript result | Formal status | Unformalized boundary | Action |
|---|---|---|---|
| `thm:dictionary` | complete in `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary`: arc-to-`[6,3,4]`, AME equivalence for equal-phase states, projective-to-monomial-to-LC, tensor Weyl stabilizers, CSS Lagrangian/support, and minimum computational support | none at statement level; aggregate manuscript adoption remains | reconcile exact theorem names and axioms in C570 |
| `thm:lc-pencil` | algebraic quotient complete in `RelativeConicArcs.AMELU.PencilClassification`; `admitted_nonGRS_pencil_classified_by_z` proves the full projective/monomial/LC equivalence from `PencilClassificationInputs` | six-arc verification, explicit projectivity construction, complementary-bracket invariance, and LC holonomy recovery are four named hypotheses; no exceptional fibre is hidden | reconcile the conditional theorem and exact hypothesis names in C570 |
| `cor:lu-lc-pencil` | LC classification interface complete; LU composition not formalized | the all-MDS/CSS LU-to-LC rigidity theorem | retain as manuscript proof composition; reconcile in C570 |
| `thm:lu-h3-grs` | conditional interface complete in `RelativeConicArcs.AMELU.MarginalMoment`: concrete CSS supported-space rank, exact 455/60/15 graph counts, `60+b` reduction, rank-four trace specialization, and `70>66` LU-separation implication | density-matrix trace expansion, chord-concurrency/rank equivalence, H3 determinant ten-count, GRS involution six-bound, and LU covariance are explicit hypotheses | reconcile the conditional theorem and exact hypothesis names in C570 |
| `thm:q13-lu` and `thm:logical-phase` | none adopted | logical symplectic kernel and exact contraction bridge | C568 candidate package |
| `thm:transport-divisor` | none adopted | cycle-cover algebra, rank bridge, and orbit geometry | C569 candidate package |
| `thm:lu-lc-rigidity` | proved in C560; not formalized | diagonal-tensor axis lemma, Weyl normalization, and MDS shortening bridge | no current Lean package; retain as a manuscript proof input |

Any Lean action requires an allocated `ame-lu` task and the nested Lean guide.
A future ledger must state exact theorem names, imports, toolchain, axioms,
unsafe/native use, external computation, and the manuscript correspondence.

The stabilizer dictionary exits through
`RelativeConicArcs.Gates.AMELUStabilizerDictionary` and
`RelativeConicArcs.Gates.AMELUStabilizerDictionaryAxioms`.  Its paper-facing
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`;
there is no native evaluation, generated source, external certificate,
project-specific axiom, or admitted declaration.

The admitted-pencil package exits through
`RelativeConicArcs.Gates.AMELUPencilClassification` and
`RelativeConicArcs.Gates.AMELUPencilClassificationAxioms`.  Its audited
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`;
there is no native evaluation, generated source, external certificate,
project-specific axiom, or admitted declaration.
