# C183 — Lean coverage for the new Clebsch claims

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **IN PROGRESS** — the C174 spine, C176 finite core, q=4/q=5/q=9 leaves, C185 decoding
synthesis, C187 arithmetic and geometric moments, and the actual q=11 defect-to-Dye seam all pass
narrow elaboration and axiom audit. C186's finite A₅ point-action bridge also passes its full
serial build, freshness, generator, and standard-axiom gates. C180's equality fibers now induce a
proper five-edge-colouring, the named prism factors are extracted, and the complete odd-field
projective contradiction passes its focused build and freshness gate. Remaining work is C186's
conceptual/source argument and manuscript synthesis.

## Live subagent roster

Keep this table current until each result is integrated; these canonical task names survive context
compaction and are the recovery handles for `collaboration.list_agents`/`followup_task`.

| Task | Ownership | Build rule | Current state |
|---|---|---|---|
| `/root/decoding_lean_static` | C185 synthesis | no Lean or Lake invocation; root validates | complete; `Q11DecodingSynthesis.lean` passes narrow elaboration and standard-axiom audit |
| `/root/dye_interface_design` | exact imported Dye boundary | design only; root implements and validates | complete; two q=11 axioms only, with downstream dependency split audited |
| `/root/six_arc_defect_bridge` | actual geometric `u+c=22` bridge | no Lean or Lake invocation; root validates | complete; bridge passes with standard axioms and no Dye dependency |
| `/root/a5_lean_static` | C186 finite `A5` point-action bridge | no Lean or Lake invocation; root validates | complete; 113-module leaf split, aggregator, freshness probe, generator replay, and standard-axiom audit pass |
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
- `Q11A5PointOrbits.lean` and its bounded leaves: the 60-element projective point action, orbit
  partition and uniqueness, order-five fixed union, Brianchon orbit, and triple-point invariance;
  and
- `SixArcDefectBridge.lean`: the actual projective-plane identity
  `|U(A)| + |brianchonPoints(A)| = 22` for every q=11 six-arc.
- `OddSixArcLineBound.lean`: the complete generic incidence case split for the `q-5` line bound,
  conditional only on excluding the five-covered-point disjoint-line equality case, plus the final
  odd-characteristic scalar contradiction once the two affine equations are supplied.
- `SixVertexOneFactorization.lean`: a semantic proof that every proper five-edge-colouring of `K6`
  is a one-factorization, plus a six-witness strict-kernel certificate for its triangular-prism
  normal form and a geometry-facing extraction of three named colours on the nine prism edges;
  its tracked `uv` replay independently confirms the `15` matchings and `6` labelled totals.
- `OddSixArcAffinePrism.lean`: the common-point-at-infinity direction determinant lemma, normalized
  obstruction, and projectively invariant triangular-prism impossibility over every field with
  `(2 : K) != 0`.
- `ProjectiveTripleNormalization.lean`: ordered noncollinear-triple projective normalization and
  the diagonal affine rescaling needed to put the first two prism directions in standard form.
- `OddSixArcPrismExtraction.lean`: canonical chord-direction colouring, properness, named prism
  extraction, exact incidence/projective witness transport, and the unconditional odd-field
  `card covered != 5` theorem.

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

1. use the certified C186 point-action bridge for the remaining chirality action layer and write
   the conceptual/source argument;
2. integrate C180's completed conceptual line-pair proof while keeping the Dye classification
   boundary explicit;
3. run any manuscript-level aggregate only after the foreign Q25 tree
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
