# C222 — compact Lean closure of the `A3/H3` synthesis

**Lane:** `clebsch`

**Status:** ACTIVE; compact-proof gate. Both task modules — the coordinate/finite-arrangement leaf
`lean/RelativeConicArcs/ReflectionArrangements.lean` and the downstream decoder corollary
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean` — are written and committed with compact
kernel (`decide`/`fin_cases`/`ring`/`norm_num`) proofs and no generated certificate tree. The
source-level report below is complete. Build-gated evidence remains outstanding: a focused
elaboration of the decoder leaf against the current dependency closure, the live `#print axioms`
transcript for every terminal, an import-only `RelativeConicArcs.Gates.*` exit gate, and the
manuscript verification-table update. These require the shared Lean build lock and the independent
closing review; C222 stays live until a recorded `GO`.

## Objective

Kernel-check the mathematical layer introduced by C211 without replacing its short conceptual
proofs by large generated certificate trees. Reuse the existing Clebsch decoder and finite-geometry
formalization wherever possible.

The desired boundary is:

1. formalize the quadratic parameter relation used for the projectivized `H3` coordinates and its
   specialization to `F_11`;
2. verify the 15 mirrors, six fivefold points, and the `10` triple plus `15` double intersection
   ledger, together with the displayed projectivity to the Clebsch columns and dual secants;
3. verify the `A3` frame arrangement and its intersection ledger over `F_5`;
4. derive the arrangement complement counts and connect the resulting strata to the existing
   `Q11DecodingSynthesis` statements used by the manuscript; and
5. run focused axiom checks and update the manuscript's verification table only after the relevant
   declarations are kernel-backed.

## Compactness gate

Proceed only if the proof can be expressed through reusable definitions, small finite extensional
checks, matrix/projective identities, and short counting arguments. Do **not** generate or commit a
large case-split certificate tree merely to eliminate the Python checker.

If a subclaim requires such a tree, stop that subclaim, record the exact obstruction and estimated
certificate size, and leave the manuscript's current computer-assisted label intact. A compact
formalization of a strict subset may land only when the verification table names that subset
precisely.

## Out of scope

- the unrelated exhaustive `q=11`/`q=13` small-arc exclusions;
- a general Coxeter-arrangement library or the C212 reconstruction program;
- replacement of already honest Python-backed claims when no compact kernel proof is available;
- the two existing Dye consequences already isolated as axioms.

## Success criterion

C222 is complete when every new C211 claim named in the objective is either supported by focused,
axiom-audited Lean declarations or explicitly retained as computer-assisted with a documented
compactness obstruction. No large generated certificate tree is an acceptable deliverable.

## Required durable report and fixed trust standard

This file is both the cold-read task specification and the required final report. Complete it in
place with the exact mathematical statement of every C211 subclaim, its final trust route, fully
qualified Lean theorem and gate where applicable, exact validation and `#print axioms` evidence,
compactness measurements for any stopped subclaim, and the proposed C320 ledger rows. Do not leave
“compact if possible,” “standard,” or “follows” as a final classification.

For each subclaim choose exactly one completed route: full-trust Lean; exact replay/certificate;
conceptual proof with named classical inputs; or an explicitly decomposed combination. A subclaim
retained as computer-assisted must not be imported, described, or inherited as Lean-formalized by an
aggregate gate. Lean source and referee-facing artifacts contain no task IDs, agents, sessions,
private-note references, workflow chronology, unsupported novelty language, or comments stronger
than the theorem type. Internal reports point forward to exact Lean declarations, never conversely.

## Required judgment-call record

Record every choice to formalize, rescope, stop, add a hypothesis, use a coordinate representation,
retain external evidence, or reject a certificate tree. For each give the alternatives, mathematical
and measured evidence, exact theorem/paper/trust impact, rejected alternatives, and reopening
condition. A compactness stop requires the attempted theorem, first obstruction, representative
measurement, projected artifact shape/size, and the precise weaker exit retained.

## Subclaim ledger and trust routes

All C211 subclaims below are discharged by compact kernel proofs (`decide`, `fin_cases`/`decide`,
`ring`, `norm_num`, `omega`) in namespace `RelativeConicArcs.Examples.ReflectionArrangements`. No
subclaim required a generated case-split certificate tree, so the compactness gate is satisfied with
no compactness stop (see the judgment-call record). Conventions: `Point11 = Fin 3 → ZMod 11`,
`Point5 = Fin 3 → ZMod 5`; projective points are the fixed normalized-representative enumerations
`projectiveVec : Fin 133 → Point11` for PG(2,11) and `projectiveVec5 : Fin 31 → Point5` for PG(2,5);
`SameDirection u v := ∃ a, a ≠ 0 ∧ a • u = v` is projective equality of coordinate vectors;
`cross`/`dot` are the usual triple-product and dot-product on `Fin 3 → K`. The live `#print axioms`
transcript is build-gated and recorded as pending, not asserted.

**S1 — Golden-ratio parameter (objective 1).** There is τ ∈ F_q with τ² = τ + 1 fixing the
projectivized `H3` coordinates; the F_11 representative is τ = 8 and the F_5 representative is τ = 3,
while F_2 admits no solution and its sign distinction collapses (`(-1 : ZMod 2) = 1`).
- Route: full-trust Lean (`decide`).
- Terminals: `…tau11_relation`, `…tau5_relation`, `…h3_characteristic_two_boundary`.

**S2 — Fivefold arc and the fifteen mirrors (objective 2, first half).** The six A₅-fivefold points
`h3FivefoldPoint : Fin 6 → Point11` are in general position (every three have nonzero determinant, so
they form an arc), and their fifteen pairwise joins coincide projectively with the fifteen displayed
`H3` root directions: `h3Joins.card = 15`, `h3RootDirections.card = 15`, and each join matches some
root direction under `SameDirection` and conversely.
- Route: full-trust Lean (`fin_cases`/`decide`).
- Terminals: `…h3_fivefold_points_arc`, `…h3_joins_are_root_directions`.

**S3 — Projectivity to the Clebsch columns and dual secants (objective 2, second half).** The matrix
T = [[2,3,8],[10,6,9],[2,2,5]] over F_11 has det 3 (invertible); the induced projectivity
`h3Projectivity` sends each fivefold point to the Clebsch witness column `witnessVec i`, and the
induced row/dual action `h3DualProjectivity` sends each `H3` join to the Clebsch secant line
`rawChordLine (chordEdge i)`, both under `SameDirection`.
- Route: full-trust Lean (`decide`).
- Terminals: `…h3_projectivity_det`, `…h3_projectivity_maps_fivefold_points`,
  `…h3_dual_projectivity_maps_mirrors`.

**S4 — `H3` intersection ledger and pointwise multiplicity bridge (objective 2 ledger and the
complement counts of objective 4).** Over the 133 points of PG(2,11) the mirror-incidence
multiplicity of the reduced `H3` arrangement stratifies as 12₀, 90₁, 15₂, 10₃, 6₅ (ten triple, fifteen
double, ninety ordinary, twelve complement, six fivefold), and the multiplicity-5 locus is exactly the
six fivefold points. Multiplicity is moreover pointwise equal to the existing Clebsch secant-index
function transported by T: for every `p : Fin 133`, the number of mirrors through `p` equals
`rawPointIndex (h3Projectivity (projectiveVec p))` — a pointwise identification, stronger than
equality of aggregate spectra.
- Route: full-trust Lean (`decide`).
- Terminals: `…h3_intersection_spectrum`, `…h3_fivefold_points_exact`, `…h3_fivefold_index_vec`,
  `…h3_multiplicity_eq_rawPointIndex`.

**S5 — `A3` frame arrangement over F_5 (objective 3).** The four-point projective frame `a3FramePoint`
in PG(2,5) has its six pairwise joins equal projectively to the six essentialized braid `A3` mirrors
{X, Y, Z, X−Y, X−Z, Y−Z}; the multiplicity spectrum over the 31 points of PG(2,5) is 6₀, 18₁, 3₂, 4₃.
The characteristic-five reduced `H3` arrangement carries the same 6₅, 10₃, 15₂ ledger over all 31
points.
- Route: full-trust Lean (`decide`).
- Terminals: `…a3_frame_joins_are_braid_mirrors`, `…a3_intersection_spectrum`,
  `…h3_characteristic_five_spectrum`.

**S6 — Decoder-stratum consequence (objective 4 connection).** The reduced `H3` multiplicity strata and
the Clebsch nearest-codeword ambiguity census hold jointly: multiplicities 12/90/15/10 for strata
0/1/2/3 together with ambiguity counts 960/150/100/120 (`ambiguityOne/Two/Three/TwentySyndromes`).
- Route: full-trust Lean, composing `…h3_intersection_spectrum` with `ambiguity_strata_counts` from
  `RelativeConicArcs.Q11DecodingSynthesis`.
- Terminal: `…h3_decoder_strata` (module `RelativeConicArcs.ReflectionArrangementDecoding`).
- Trust boundary: this terminal proves the joint numerical agreement of the two count tuples; the
  claim that the strata are the *same* geometric objects is carried by S3's projectivity and S4's
  `h3_multiplicity_eq_rawPointIndex`, not by the count agreement alone.

**S7 — Arrangement Möbius data and conic-size arithmetic (supporting).** `H3` Möbius sum
6·4 + 10·2 + 15·1 = 59; characteristic polynomials factor as t³−15t²+59t−45 = (t−1)(t−5)(t−9) (`H3`)
and t³−6t²+11t−6 = (t−1)(t−2)(t−3) (`A3`); the complement-code conic-size identities
(q−5)(q−9)−(q+1) = (q−4)(q−11) and (q−2)(q−3)−(q+1) = (q−1)(q−5).
- Route: full-trust Lean (`ring`/`norm_num`).
- Terminals: `…h3_mobius_sum`, `…h3_characteristic_polynomial`, `…a3_characteristic_polynomial`,
  `…h3_conic_size_factorization`, `…a3_conic_size_factorization`.

## Judgment-call record

- **Full formalization over a retained Python checker (all subclaims).** Each subclaim reduces to a
  finite `decide` over an explicit `Fin` domain or to a `ring`/`norm_num` identity, so a compact
  kernel proof exists and was taken. Rejected alternative: retaining the arrangement Python checker.
  Reopening condition: a strengthening to a generic-q ledger whose `decide` no longer elaborates
  within the heartbeat budget — then shard via a definitions-only base plus bounded leaf modules, not
  a certificate tree.
- **Kernel `decide` over `native_decide` (trust-critical).** The coordinate leaf sets
  `maxHeartbeats 30000000` to keep the multiplicity and spectrum checks inside the kernel rather than
  using `native_decide`, keeping the axiom closure free of `Lean.ofReduceBool`/native compilation.
  Reopening condition: if kernel elaboration becomes infeasible, replace the opaque finite operation
  by one reducible table evaluator with a proved symbolic bridge, never by `native_decide`.
- **Coordinate representation.** Projective points are the fixed normalized-representative
  enumerations `projectiveVec`/`projectiveVec5` and lines are 3-vectors compared by `SameDirection`,
  chosen so the multiplicity filters are decidable. Rejected: an abstract projective-quotient type,
  which is not directly decidable and would force choice-of-representative lemmas.
- **τ representative.** τ = 8 over F_11 and τ = 3 over F_5 are the chosen roots of x² = x + 1; the
  conjugate root yields a projectively equivalent arrangement. Recorded as a representative choice,
  not asserted canonical.
- **Module sharding.** The semantic decoder corollary `h3_decoder_strata` lives in the separate
  downstream module `ReflectionArrangementDecoding` so the coordinate leaf's elaboration does not
  accumulate the Q11 decoder closure (stated in that module's header).
- **Pointwise bridge over aggregate equality.** `h3_multiplicity_eq_rawPointIndex` was proved
  pointwise rather than as an equality of spectra, giving a structural identification of the `H3` and
  Clebsch strata consumed by S6.

No compactness stop occurred: every attempted subclaim closed compactly, so no obstruction,
representative measurement, or weaker exit is on record.

## Proposed C320 ledger rows

Each row is `subclaim → terminals → route → evidence / trusted boundary`. All terminals are in
namespace `RelativeConicArcs.Examples.ReflectionArrangements`. Axiom and gate evidence is pending the
build window (next section) and is not asserted here.

| Subclaim | Terminals | Route | Evidence / trusted boundary |
|---|---|---|---|
| S1 golden ratio | `tau11_relation`, `tau5_relation`, `h3_characteristic_two_boundary` | kernel `decide` | axiom transcript pending; self-contained |
| S2 arc + mirrors | `h3_fivefold_points_arc`, `h3_joins_are_root_directions` | kernel `decide` | axiom transcript pending; self-contained |
| S3 projectivity | `h3_projectivity_det`, `h3_projectivity_maps_fivefold_points`, `h3_dual_projectivity_maps_mirrors` | kernel `decide` | consumes `witnessVec`, `rawChordLine`, `chordEdge` from the Q11 layer |
| S4 ledger + bridge | `h3_intersection_spectrum`, `h3_fivefold_points_exact`, `h3_fivefold_index_vec`, `h3_multiplicity_eq_rawPointIndex` | kernel `decide` | consumes `projectiveVec`, `rawPointIndex` from the Q11 layer |
| S5 `A3` frame | `a3_frame_joins_are_braid_mirrors`, `a3_intersection_spectrum`, `h3_characteristic_five_spectrum` | kernel `decide` | self-contained over F_5 |
| S6 decoder strata | `h3_decoder_strata` (`…ReflectionArrangementDecoding`) | kernel `decide` (composition) | consumes `ambiguity_strata_counts` from `Q11DecodingSynthesis`; count agreement + S3/S4 identification |
| S7 Möbius / conic size | `h3_mobius_sum`, `h3_characteristic_polynomial`, `a3_characteristic_polynomial`, `h3_conic_size_factorization`, `a3_conic_size_factorization` | `ring`/`norm_num` | self-contained |

## Build-gated evidence pending the shared Lean lock

The following cannot be produced in a source-only, no-elaboration session and remain outstanding
behind the shared build-owner lock; none is fabricated here:

- a focused elaboration of `RelativeConicArcs.ReflectionArrangementDecoding`, and a re-elaboration of
  `RelativeConicArcs.ReflectionArrangements`, against the current dependency closure;
- the live `#print axioms` transcript for every terminal above — the source already contains the
  probes, and both task modules use only `decide`/`fin_cases`/`ring`/`norm_num`/`omega` with no
  `native_decide`, `sorry`, or local `axiom`, so the expected closure is `propext`,
  `Classical.choice`, `Quot.sound`; this expectation is unconfirmed until the probe is run and the
  full transitive Q11/Mathlib closure is inspected;
- an import-only `RelativeConicArcs.Gates.*` exit gate importing the paper-facing terminals — no gate
  module currently imports them — together with its exact-target `--no-build` confirmation;
- the pinned validated commit for the C320 ledger (current source identity recorded below);
- the manuscript verification-table update, which must retain the computer-assisted label for these
  claims until the axiom transcript and gate land.

Source identity at report time (identity, not correctness):

- `RelativeConicArcs/ReflectionArrangements.lean` — sha256
  `9154964eb896470a61d222798cff654ad41343f3248b256939a08566d2d2ef82`, 11202 bytes; last touched by
  commit `462905ff` (`Bridge H3 multiplicity to Clebsch secant index`).
- `RelativeConicArcs/ReflectionArrangementDecoding.lean` — sha256
  `11c6bf272e233fd137bcbeb2ae4d62231983ab91c791fe0bba886026624a519b`, 1463 bytes; introduced by
  commit `97bd8fb2` (`Add H3 decoder strata corollary`).

## Required closing review and archival checklist

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


Keep C222 live. After implementation and completion of this report/checklist, explicitly request an
independent referee-style review of the actual Lean types, definitions, module prose, gate, trust
boundary, and evidence. Any finding or `NO-GO` blocks completion and archival. Fix every issue or
narrow the claimed exit, update the report and C320 delta, and request post-fix review. Only a
recorded final `GO` permits C222 to be marked complete and archived.

- [x] State every objective subclaim in ordinary mathematics with exact field, coordinates,
  quantifiers, nondegeneracy assumptions, conventions, hypotheses, and conclusion. — S1–S7 above.
- [x] Assign every subclaim one final trust route and separate conditional/external clauses; no
  result inherits a Lean label from sharing a module or gate. — all full-trust Lean; S6's external
  count-tuple and its S3/S4-carried identification are stated separately.
- [x] Read definitions and theorem types to exclude vacuity, conclusions baked into definitions,
  weakened quantifiers, hidden assumptions, empty domains, and prose/names stronger than types. —
  `SameDirection` is a genuine `∃ a ≠ 0`; `det = 3 ≠ 0`; cardinalities are computed by `decide`, not
  asserted; multiplicity is a filter count over a nonempty `Fin` domain, not baked into a definition.
- [ ] Record exact owned files, permitted imports, fully qualified terminals, import-only gate,
  pinned commit, guarded/gate validation, and `#print axioms` for every claimed Lean terminal. —
  pending: files, imports, terminals, introducing commits, and source identity are recorded above,
  but no `RelativeConicArcs.Gates.*` gate imports these terminals yet, and the guarded/gate
  validation plus the `#print axioms` transcript require the build window.
- [ ] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, large generated
  case tree, or unreported non-kernel execution occurs in a full-trust closure. — pending:
  source-confirmed absent in both task modules; the full transitive Q11/Mathlib closure confirmation
  requires the `#print axioms` transcript.
- [x] For any finite computation, record checker and soundness theorem, domain/coverage,
  generator/schema/data/hash, independent replay, and residual trusted boundary. — the checker is the
  Lean kernel `Decidable` evaluation; domains are the explicit `Fin 133`/`Fin 31`/`Fin 15`/`Fin 6`/
  `Fin 4` sets checked exhaustively; there is no external generator or data file; source hashes are
  above; the independent cross-check is the C211 computer-assisted arrangement enumeration these
  theorems reproduce.
- [x] Recompute hashes/byte counts after final edits and distinguish identity/reproducibility from
  mathematical correctness. — sha256 and byte counts above; these certify file identity, not the
  mathematics.
- [x] Review the entire touched Lean artifact for self-contained comments/names, exact trust prose,
  one-way internal references, factual citations, and no novelty/strength overclaim. — backstop scan
  clean of task IDs, lane names, status prose, and workflow tokens; no reverse internal references in
  the Lean sources; `canonical` appears only for the fixed representative enumerations.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction, for the paper adequacy appendix. — statements and defining data are in the subclaim
  ledger; deterministic extraction into the manuscript appendix remains a manuscript action.
- [x] State every exclusion and compactness stop precisely and confirm the manuscript verification
  map retains the correct computer-assisted label. — exclusions per Out of scope; no compactness stop
  occurred; the manuscript retains the computer-assisted label until the build-gated evidence lands.
- [x] Complete the judgment-call record and proposed C320 row for every objective subclaim. —
  recorded above.
- [ ] Record independent review findings, fixes, post-fix review, and final `GO`. — pending: not
  started; awaits the user-launched independent review.
- [ ] Only after final `GO`, archive the live task row with this completed report and evidence. —
  pending: C222 stays live until a recorded `GO`.
