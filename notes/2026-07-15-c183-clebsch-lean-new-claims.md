# C183 — Lean coverage for the new Clebsch claims

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **IN PROGRESS** — the C174 spine, C176 finite core, q=4/q=5/q=9 leaves, C185 decoding
synthesis, C187 arithmetic and geometric moments, and the actual q=11 defect-to-Dye seam all pass
narrow elaboration and axiom audit. Remaining work is the A₅ action certificate, C180's odd-field
line lemma, and the manuscript synthesis.

## Live subagent roster

Keep this table current until each result is integrated; these canonical task names survive context
compaction and are the recovery handles for `collaboration.list_agents`/`followup_task`.

| Task | Ownership | Build rule | Current state |
|---|---|---|---|
| `/root/decoding_lean_static` | C185 synthesis | no Lean or Lake invocation; root validates | complete; `Q11DecodingSynthesis.lean` passes narrow elaboration and standard-axiom audit |
| `/root/dye_interface_design` | exact imported Dye boundary | design only; root implements and validates | complete; two q=11 axioms only, with downstream dependency split audited |
| `/root/six_arc_defect_bridge` | actual geometric `u+c=22` bridge | no Lean or Lake invocation; root validates | complete; bridge passes with standard axioms and no Dye dependency |
| `/root/a5_lean_static` | C186 finite `A5` point-action bridge | no Lean or Lake invocation; root validates | active repair after the row-sharded pass exposed reducibility failures without an OOM |
| `/root/small_k_geometric_adapter` | C187 actual projective moment seam | no Lean or Lake invocation; root validates | complete; all six manuscript-facing results pass warning-clean with standard axioms |

Root owns integration, the Dye axiom interface and consequences, validation sequencing, and
manuscript/handoff synchronization. No two agents may run a Lean build concurrently. All current
Clebsch checks use `choom -n 500` as directed on 2026-07-15.

## Landed strict-kernel surface

- `ClebschChordDefect.lean`: the fifteen perfect matchings, injective `c<=15` bound, chord-defect
  algebra, and prime-power reduction to `q in {4,5,9,11}`.
- `Q11BrianchonPetersen.lean`: the five-plus-ten matching split, ten explicit Brianchon
  concurrences, `3^10 1^15` chord-intersection ledger, and Petersen `(10,3,0,1)` data.
- `ClebschSmallFields.lean`: the generic hyperoval completeness argument and q=4 exclusion.
- `Q5SixArcExclusion.lean`: four-cap normalization plus a `31^3` strict-kernel certificate proving
  every six-cap in `PG(2,5)` maximal and its uncovered locus empty.
- `Q9Sylvester.lean`: the 36 internal points, Sylvester intersection array, passant/exact-distance-
  two equivalence, an explicit five-clique, and a no-six-clique proof via a proper six-colouring and
  rainbow-prefix counts `6,24,66,120,126,0`.

Every displayed `#print axioms` result contains only `propext`, `Classical.choice`, and
`Quot.sound`. There is no `sorryAx`, `native_decide`, external oracle, or new axiom in these
modules.

The same strict-kernel verdict now holds for:

- `SmallKChordMoments.lean`: the `k=4,5,7` arithmetic specializations and prime-power reduction;
- `SmallKGeometricBridge.lean`: actual projective 4-/5-/7-arc uncovered formulas, the q=5
  four-arc conclusion, five-arc impossibility, and q=11/q=13 seven-arc spectra;
- `Q11DecodingSynthesis.lean`: the total distance oracle, uniform twenty deep-hole supports,
  ambiguity strata, and Brianchon/weight-two bridge; and
- `SixArcDefectBridge.lean`: the actual projective-plane identity
  `|U(A)| + |brianchonPoints(A)| = 22` for every q=11 six-arc.

## Dye source and formalization boundary

No exact formalization of Dye's Brianchon bound/equality classification was found in the pinned
mathlib tree, the public Rocq projective-geometry archive, or targeted Lean/Rocq/Isabelle/Mizar/Agda
searches. The Rocq archive provides incidence planes, duality, Desargues, and matroid foundations,
but no conic/Brianchon/Clebsch layer. Dye's open 1997 self-recap supports the 1991 theorem's use,
but the primary 1991 equality proof remains inaccessible locally.

`Q11DyeAxioms.lean` now imports exactly two precisely named statements: the ten-point bound for a
q=11 six-arc and the equality classification up to projective equivalence with the certified
witness. `Q11DyeConsequences.lean` proves `|U(A)|>=12`, equality of the `12+10` cards under conic
containment, and `contained in a nonsingular conic -> IsClebschHexagon`. Axiom audit shows the first
two consequences depend only on the bound, while the classification theorem depends on exactly
both Dye axioms. The proved `u+c=22` bridge depends on neither. A general formalization of Dye is
feasible but is a separate substantial
formal-geometry project; a reflected 1548-class q=11 certificate is the finite self-contained
alternative, not a formalization of Dye's conceptual proof.

## Remaining sequence

1. finish the memory-bounded A₅ action certificate and certify C186 point-orbit facts plus the
   remaining chirality action layer;
2. formalize C180's affine-direction/edge-colouring line lemma; the conditional conic-rigidity
   implication below Dye is already kernel-checked;
4. run narrow module builds/axiom audits, then a tracked aggregate only after the foreign Q25 tree
   is stable.

## Exit gate

- each new theorem is under a tracked root with a narrow `lake build --no-build` freshness probe;
- the finite certificates use kernel reduction or a checked reflected witness, not an untrusted
  printed computation;
- the q=9 clique upper bound has a compact, independently replayable certificate;
- `#print axioms` is recorded for every manuscript-facing theorem;
- manuscript wording distinguishes Lean-certified results from cited classical inputs; and
- no broad build starts until the shared-tree owner releases the foreign dirty generated modules
  and the representative peak-RSS cap has been measured.
