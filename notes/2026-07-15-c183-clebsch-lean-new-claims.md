# C183 — Lean coverage for the new Clebsch claims

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **IN PROGRESS** — the C174 spine, C176 finite core, and q=4/q=5/q=9 leaves all pass
narrow elaboration and axiom audit. Remaining work is the equivariant/action layer, the C185
decoding synthesis, the C180 line lemma plus explicit Dye interface, and C187's general moments.

## Live subagent roster

Keep this table current until each result is integrated; these canonical task names survive context
compaction and are the recovery handles for `collaboration.list_agents`/`followup_task`.

| Task | Ownership | Build rule | Current state |
|---|---|---|---|
| `/root/c183_chord_defect` | `ClebschChordDefect.lean` plus `Q5SixArcExclusion.lean`; C174 and q=5 | no Lean or Lake invocation until root coordinates | complete; both narrow elaborations and axiom audits pass |
| `/root/c183_brianchon` | C176 core and C185 checker/synthesis | no Lean or Lake invocation until root coordinates | C176/Python complete; active on `Q11DecodingSynthesis.lean` |
| `/root/c183_q9_sylvester` | q=9/C187, then C186 finite `A5` point-action bridge | no Lean or Lake invocation until root coordinates | q=9/C187 complete; active on `Q11A5PointOrbits.lean` |
| `/root/c183_curve_loci` | C184 curve audit, then C187 small-`k` Lean moments | no concurrent Lean; root coordinates elaboration | C184 complete; active on `SmallKChordMoments.lean` |

Root owns integration, small-field q=4/q=5 work, the Dye-formalization source audit and axiom
interface, validation sequencing, and manuscript/handoff synchronization. No two agents may run a
Lean build concurrently.

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

## Dye source and formalization boundary

No exact formalization of Dye's Brianchon bound/equality classification was found in the pinned
mathlib tree, the public Rocq projective-geometry archive, or targeted Lean/Rocq/Isabelle/Mizar/Agda
searches. The Rocq archive provides incidence planes, duality, Desargues, and matroid foundations,
but no conic/Brianchon/Clebsch layer. Dye's open 1997 self-recap supports the 1991 theorem's use,
but the primary 1991 equality proof remains inaccessible locally.

The near-term C180 theorem will therefore import two precisely named Dye statements as axioms:
the ten-point bound under the exact field hypotheses and the equality classification. The new line
lemma and every implication below those inputs remain kernel-checked, and `#print axioms` will make
the seam visible. A general formalization of Dye is feasible but is a separate substantial
formal-geometry project; a reflected 1548-class q=11 certificate is the finite self-contained
alternative, not a formalization of Dye's conceptual proof.

## Remaining sequence

1. add the shared `Fin 6` action table and certify C176 equivariance, the C186 point-orbit facts,
   chirality, and the C185 decoder synthesis;
2. connect the abstract C174 moments directly to the geometric `Moments.lean` definitions and add
   C187's `k=4,5,7` specializations;
3. formalize C180's affine-direction/edge-colouring line lemma and its conditional Dye theorem;
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
