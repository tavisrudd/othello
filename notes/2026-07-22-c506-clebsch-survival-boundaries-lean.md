# C506 / F13 — Lean finite survival and erasure boundaries

**Lane:** `clebsch`

**Status:** complete; final independent-review `GO`

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Formalize the bounded arithmetic and linear-algebra cores of Paper 1's negative and visibility
rows from C443/C461, C450, C453, and C454:

- the exhausted permitted companion-weight routes do not produce the proposed integral cubic;
- the frozen cross-sheet matrices do not yield the claimed small Weil-module identity;
- the exact quadratic-character/mod-40 visibility law at the stated primes and hypotheses;
- the tested Klein/five-space and relative-cubic maps have the stated ranks and do not give the
  proposed identification.

Positive residual statements must be separated from failed identifications. A failed named map
does not imply that no construction of any kind exists.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschSurvivalBoundaryData.lean`,
  `lean/RelativeConicArcs/ClebschSurvivalBoundary.lean`,
  `lean/RelativeConicArcs/Gates/ClebschSurvivalBoundary.lean`, and this report.
- Consume the committed C443/C450/C453/C454/C461 bundles read-only.
- Exit through `RelativeConicArcs.Gates.ClebschSurvivalBoundary`.

## Required theorem and exclusion boundary

Every negative theorem must state its exact searched domain, candidate family, and stop condition.
The mod-40 theorem must state its frozen transporter hypotheses and distinguish proved laws from
predicted constructions. Ordinary character labels, Weil terminology, and density claims remain
external unless separately formalized. No universal nonexistence, integral-tensor impossibility,
or common quadratic-character carrier is claimed.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Translate finite data
through definitions-only modules and sound checker theorems; preserve hashes and independent
replays; audit all terminals for axioms; use guarded/unattended exact-target builds only.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

### Result

The bounded finite core is implemented as:

- `RelativeConicArcs.ClebschSurvivalBoundaryData`, a definitions-only module;
- `RelativeConicArcs.ClebschSurvivalBoundary`, the checker and interface module; and
- `RelativeConicArcs.Gates.ClebschSurvivalBoundary`, the import-only gate and
  fourteen-terminal axiom audit.

The exact formal exits are:

1. `companion_sheet_hit_bijection`,
   `companion_conjugation_has_no_fixed_candidate`, and
   `four_companions_fail_unique_stop_condition`: the complete four-companion by
   four-reduction table has one hit in every row and column, conjugation is `2+2` with no fixed
   companion, and the proposed unique-companion stop condition fails.
2. `descended_companion_lowerMoment_kernel_zero` and
   `no_nonzero_descended_weight_passes_lowerMoment_gate`: the selected
   `4 x 4` minor in stacked lower-moment coordinates `4,18,19,21` has a checked inverse over
   `ZMod 11`.  Hence the full four-dimensional descended companion-weight family has no nonzero
   lower-moment kernel and reaches no cubic comparison.
3. `crossSheet_gram_identities`, `seven_crossSheet_maps_injective`, and
   `eleven_crossSheet_maps_injective`: the four frozen relation matrices have exact Grams
   `2I+2J`, `2I+J`, `3I+3J`, and `3I+2J`; explicit rational left inverses prove injectivity.
   Thus the displayed eleven-sheet maps do not have the proposed `5+6` image/kernel profile.
4. `relativeCubic_quotient_injective`,
   `tested_fiveSpace_cubics_have_zero_quotient`, and
   `tested_fiveSpace_relativeCubic_intersection_zero`: three quotient functionals vanish on the
   frozen 35-column five-space cubic test and give the invertible evaluation matrix
   `[[0,9,10],[9,1,1],[6,3,2]]` on the three relative cubics.  The tested intersection is zero.
5. `exact_mod40_residue_partition`, `mod40_residue_partition_complete`, and
   `mod40_prediction_of_frozen_hypotheses`: under the explicitly supplied golden-splitting and
   determinant-two transporter predicates, the visible/fused/inert classes are exactly
   `11,19,21,29 / 1,9,31,39 / 3,7,13,17,23,27,33,37` modulo forty.  The sets are pairwise
   disjoint and exhaust all sixteen reduced residue classes.

### Trust and exclusion boundary

Lean checks the literal finite tables, selected rank witnesses, rational matrix identities,
inverse certificates, and residue partition.  It does not reconstruct the source certificates'
golden geometry, companion enumeration, character tables, group actions, or symmetric-cube
coordinate generation.

In particular:

- the C443/C461 theorem covers exactly linear weightings of the four displayed companion moment
  sums after the permitted localization at two; it does not exclude an abstract integral tensor
  built elsewhere in the invariant tensor lattice;
- the C450 theorem covers exactly the four displayed cross-sheet incidence matrices; ordinary
  character and Weil-module names remain cited interpretations;
- the C454 zero-intersection theorem treats the identification of the 35 zero-quotient columns
  with the frozen five-space symmetric cube as an external hash-pinned certificate input; it
  excludes neither nonlinear maps nor other five-spaces;
- the C453 theorem assumes the frozen mod-five splitting and mod-eight transporter predicates;
  it constructs no parent or continuation, proves no quadratic reciprocity theorem, and exports
  no density statement.

The positive residual statements are separate: the cross-sheet maps are rationally injective,
the relative-cubic quotient is injective, and the modulo-forty outcome sets form a complete
partition.  None of these positives repairs a failed named identification.

### Judgment calls

- A selected full-rank lower-moment minor is the smallest sound Lean witness for C461's zero
  kernel.  The full `135 x 4` stacked table remains in the consumed canonical certificate; the
  formal theorem records the four selected coordinate indices so the boundary is auditable.
- The C454 formal leaf uses the three quotient evaluations rather than copying the full
  `220 x 38` span calculation.  This keeps the kernel-checked core small while leaving the exact
  semantic column identification at its external certificate boundary.
- Both the seven- and eleven-sheet controls were retained.  The seven-sheet row is not needed to
  falsify the H3 `5+6` proposal, but it makes the bounded `3+4 / 5+6` claim symmetric and exposes
  the two exact control maps.
- `decide` and symbolic `norm_num` proofs replaced an initial `native_decide` draft so every
  terminal closes on the standard axiom set.  One unsuccessful symbolic diagnostic emitted an
  overlarge saved log; it was not reused as evidence, and the proof was reshaped before rerunning.

### Artifacts and replay

| artifact | SHA-256 |
|:--|:--|
| `lean/RelativeConicArcs/ClebschSurvivalBoundaryData.lean` | `ebb51dc198cb92579db7b816f7cb0542505dedd689470aa0b0c7a268ddd18bd5` |
| `lean/RelativeConicArcs/ClebschSurvivalBoundary.lean` | `0862b6a88532b9048d0c3f181ed79dc03148a5c3bcc66e851e8b0f88b07affb8` |
| `lean/RelativeConicArcs/Gates/ClebschSurvivalBoundary.lean` | `a4b992e61232a29e3c7eb1a56d0f028dcbca4e2fccb940c9d127d258778508b8` |

All five consumed manifests were rechecked successfully.  Independent replay passed for C443,
C450, C454, and C461.  C453's deterministic checker passed with `--check`; its source report
states why its elementary root/enumeration and Burnside cross-checks do not require a second
implementation.

Exact replay commands from the repository root:

```bash
uv run python3 notes/2026-07-21-c443-commuting-with-reduction-replay.py
python3 notes/2026-07-21-c450-weil-cross-sheet-replay.py
python3 notes/2026-07-21-c453-continuation-laws.py --check
python3 notes/2026-07-21-c454-klein-cubic-replay.py
uv run python3 notes/2026-07-21-c461-four-companion-weight-line-replay.py
```

### Validation and axiom audit

The guarded single-file checker passed.  The exact-target queue
`run-20260723-235404-509b92c6` then built
`RelativeConicArcs.ClebschSurvivalBoundary` and
`RelativeConicArcs.Gates.ClebschSurvivalBoundary`, followed by its trace-only aggregate gate.
Peak recorded RSS was 2,602,576 KiB for the checker and 1,763,124 KiB for the gate.

All fourteen `#print axioms` probes report only the standard set
`propext`, `Classical.choice`, and `Quot.sound`, or a subset; the elementary
`four_companions_fail_unique_stop_condition` uses no axioms.  No `sorry`, custom axiom,
`native_decide` axiom, or opaque oracle occurs.

The full three-module referee-prose audit found no task IDs, lane/agent/session vocabulary,
internal-note references, status placeholders, or unresolved repository-local references.
Every public non-obvious definition and theorem has a mathematical docstring, and the module/gate
headers state the finite domain, checking method, and trusted semantic boundary.

### `ej` + `tt` closeout and mystery ledger

The closeout pass added `mod40_residue_partition_complete`, upgrading the three explicit class
lists to a proved exhaustive, pairwise-disjoint partition.  It also confirmed that the useful
positive content is already exposed separately from the negative identifications: four injective
cross-sheet maps, an injective relative-cubic quotient, and the complete residue law.

Mystery ledger:

- **Why does the full four-companion lower-moment map already have rank four in degree at most
  two?**  Unsettled here.  The exact evidence gap is a characteristic-independent conceptual
  description of that rank, outside the bounded finite theorem.  No successor is allocated by
  this task.
- **Why do three sparse annihilators separate all three relative cubics while killing the local
  five-space cube?**  The finite fact is settled by the displayed invertible quotient matrix;
  an intrinsic representation-theoretic explanation remains external to this slice.  It does
  not affect the zero-intersection gate.
- **Does the mod-forty law construct continuation parents?**  No: the closeout settles this as a
  false implication.  Parent existence is an explicit missing hypothesis, not a mystery left by
  the finite partition.

### Proposed C320 trust-ledger delta

> **Finite survival/erasure boundary.** Import
> `RelativeConicArcs.Gates.ClebschSurvivalBoundary`.  The gate kernel-checks the complete
> four-companion/four-reduction hit table, a full-rank minor of the four-dimensional descended
> lower-moment map, exact Gram and rational inverse identities for the four frozen cross-sheet
> incidence matrices, the three-functional frozen five-space/relative-cubic intersection test,
> and the exhaustive pairwise-disjoint mod-forty visible/fused/inert partition.  Its fourteen
> terminals use only `propext`, `Classical.choice`, and `Quot.sound`, or a subset.  Companion
> enumeration and moment-coordinate semantics, ordinary-character/Weil names, the semantic
> identification of the 35 five-space cubic columns, and the golden-splitting/transporter
> interpretations remain external hash-pinned certificate or cited-input boundaries.  The gate
> proves no universal integral-cubic impossibility, nonlinear-map obstruction, common
> quadratic-character carrier, parent construction, quadratic-reciprocity theorem, or density
> claim.

### Review checklist and disposition

- [x] Owned modules and report only.
- [x] Consumed source bundles unchanged and hash-verified.
- [x] Independent replays or the source-stated elementary-check rationale recorded.
- [x] Exact finite domains and stop conditions visible in theorem types and docstrings.
- [x] Positive residuals separated from negative identifications.
- [x] Exact-target gate and aggregate trace passed.
- [x] Fourteen-terminal axiom audit on standard axioms only.
- [x] Referee-facing prose/name/closure audit passed.
- [x] `ej` + `tt` closeout and mystery ledger completed.
- [x] User-launched independent review.
- [x] Resolution or narrowing of every review finding: no findings.
- [x] Post-fix review not required because the reviewer requested no changes.
- [x] Recorded final `GO`.

The independent reviewer returned final `GO` on implementation commit `51b21674` with no
findings and made no edits.  The reviewer independently matched the companion table, the selected
C461 rows `4/18/19/21`, all four cross-sheet matrices and Gram boundaries, the frozen
five-space zero-intersection boundary, and the mod-forty classes to the consumed bundles.  All
five manifests and replay/check routes, the fourteen-terminal standard-axiom audit, artifact
hashes, exact-target validation record, definitions-only discipline, referee prose/names,
exclusions, gate coverage, and proposed C320 delta passed.

The discovery-track closeout found no genuinely incidental observation: the two open conceptual
questions in the mystery ledger were deliberately sought by the required closeout pass and remain
task-report material rather than discovery entries.
