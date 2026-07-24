# C541 — Lean closure for polar induction and redundancies six/seven

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

The coherent polar mechanism and its redundancy-six and redundancy-seven synthesis boundaries are
formalized in three public modules:

- `RelativeConicArcs.PRSPolarInduction` checks finite and projective divided-power contraction,
  the infinity marker, arbitrary ordered marker iteration, base change, the forbidden-root lift,
  and the linear modular-nucleus contraction kernel.  Its contained-versus-transverse theorem
  selects a rational polar parameter outside the lower-carrier and collision divisors and lifts the
  declared lower-cover witness.
- `RelativeConicArcs.PRSRedundancySixSeven` specializes that theorem to the exact budgets
  `q>=29`, `7+6` for redundancy six and `q>=37`, `4+8` for redundancy seven.  It proves conditional
  high-field and all-field coding synthesis, the tangent/sigma plus modular cardinality identity,
  the fifth- and sixth-power orbit-count tables, and the tangent cocycle dichotomy.
- `RelativeConicArcs.PRSRedundancySixSevenCertificate` transcribes the public R6/R7 field summaries
  and exceptional orbit-count inventories.  Kernel reduction checks the persistent, central, and
  exceptional count identities.  Separate validation structures expose syndrome semantics, orbit
  exhaustion, and covering-radius promotion.

The import gate is
`RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven`; the adjacent module
`RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSevenAxiomAudit` audits the paper-facing
terminals.

## Exact formal boundary

The checked polar engine retains the mathematical distinctions needed by the manuscript:

1. finite markers and infinity are one projective contraction interface;
2. ordered iterated markers remain data even though contraction commutes;
3. a lower kernel member lifts only with a separate proof that it avoids the new marker;
4. identity-Frobenius strata carry explicit geometric-integrality, genus, and deletion data;
5. lower-bad and marked-collision divisors have separate cardinality budgets;
6. contained polar graphs are classified through explicit persistent or modular hypotheses;
7. the modular locus is the submodule of syndromes whose complete contraction family lands in the
   declared lower nucleus;
8. covering radius is a separate input used only to promote split-freeness to coding deepness.

The all-field terminals require a validated finite row below the geometric threshold.  The
redundancy-seven coding theorem begins at `q>=11`: the public `q=7,8,9` rows remain split-free
syndrome classifications and are not silently promoted to deep-hole tables.

The following content remains explicit input rather than a Lean axiom: identification with the
concrete projective parity-check coordinates; the degree-specific catalecticant and nucleus
equations; geometric integrality and Hasse--Weil/Aubry--Perret estimates for the lower covers;
contained-component classification; actual `PGL2/PGammaL2` actions and stabilizers; the
Seroussi--Roth covering-radius theorem; and semantic validation of the public finite records.

## Finite records

The certificate leaf checks:

- R6 field summaries at `q=7,8,9,11,13,16,17,19,23,25,27`;
- the R6 exceptional projective/semilinear orbit counts
  `18/18, 11/5, 4/2, 2/2, 1/1`;
- R7 field summaries at
  `q=7,8,9,11,13,16,17,19,23,25,27,29,31,32`;
- the R7 exceptional projective/semilinear orbit counts
  `194/194, 119/45, 54/29, 5/5`;
- `2*persistent=q(q+1)^2` in every row;
- exact decomposition into persistent, central, and exceptional counts; and
- the R7 radius-reporting boundary `q>=11`.

The source is
`papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`0a6c4066dff9983a9c2124bca27fbbe4e273b9868125a04c30071df3783b6725`.
Lean checks the transcription and arithmetic, not the external enumeration.

## Validation

Independent guarded elaboration passed for all three source leaves.  Serialized run
`run-20260724-070333-a16266b6` then passed:

- `RelativeConicArcs.PRSPolarInduction`;
- `RelativeConicArcs.PRSRedundancySixSevenCertificate`;
- `RelativeConicArcs.PRSRedundancySixSeven`;
- `RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSevenAxiomAudit`; and
- the trace-only aggregate gate
  `RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven`.

Exact-target trace confirmation in `run-20260724-070454-e8379608` found the audit target current
and passed the aggregate gate without rebuilding it.  The axiom audit reports only
`propext`, `Classical.choice`, and `Quot.sound`; the forbidden-root lift and both finite
count-exhaustion terminals are axiom-free.  No project-specific axiom, `sorry`, native evaluator,
generated oracle, or external certificate is imported.

The full new Lean modules, gates, names, docstrings, and comments were reviewed for mathematical
scope, trust-boundary disclosure, stable terminology, and forbidden workflow vocabulary.

Implementation commit: `82f9ddc1`.

## Extra-juice and Tao closeout

The first closeout question was whether finite-marker contraction had accidentally omitted the
projective point at infinity.  The public API now includes `projectiveDividedPowerContraction` and
arbitrary projective marker lists, with base-change commutation checked for both finite markers and
infinity.

The second question was whether “modular component” was merely a predicate supplied by a caller.
The module now constructs the actual linear submodule
`modularContractionKernel`: its members are exactly the syndromes whose entire linear contraction
family lands in the declared lower nucleus.

The Tao stress test asked where the genus and deletion numbers enter.  A bare threshold would have
hidden that geometry.  Every coherent polar input now carries explicit identity-Frobenius cover
strata, each with geometric integrality, genus, deletion degree, and the exact Hasse--Weil deletion
inequality; a lower witness must name one of those strata.  The finite parameter-count proof then
uses only the declared carrier and collision budgets.

No cheap formal strengthening can remove the remaining hypotheses honestly.  Concrete
catalecticant equations, lower-cover monodromy, group actions, and certificate semantics are
degree-specific mathematical evidence, not logical interface work.

## Mystery ledger

Settled:

- **Was infinity missing from the contraction flag?** No; it is a checked projective marker and
  commutes with base change and iteration.
- **Were forbidden roots only prose?** No; the pointed lift requires nonvanishing at the retained
  marker before squarefreeness can lift.
- **Was the modular nucleus only a label?** No; its complete contraction kernel is a formal
  submodule with an exact membership theorem.
- **Could R7 `q=7,8,9` become coding deep-hole tables by interface composition?** No; the all-field
  coding terminal requires a radius-certified row and starts at `q>=11`.
- **Could finite table arithmetic masquerade as orbit exhaustion?** No; semantic orbit and syndrome
  validation remain structure fields.

Open, with exact evidence owners:

- **Concrete projective coordinate and contained-component theorems:** the degree-specific
  catalecticant and nucleus equations remain hypotheses of this package.  They are mathematical
  inputs from the R6/R7 proof records, not hidden axioms.
- **Lower-cover geometry:** identity-twist integrality, genus/deletion calculations, and the
  rational-point theorem remain named inputs.  The formal engine checks their logical use.
- **Group-action and certificate semantics:** numerical orbit tables do not construct actions or
  validate the external enumeration.  The aggregate formalization and public replay gates retain
  those obligations.

No incidental observation met the discovery-track discriminator; every closeout refinement above
was a direct formalization obligation.
