# C222 — compact Lean closure of the `A3/H3` synthesis

**Lane:** `clebsch`

**Status:** ACTIVE; compact-proof gate. Four user-launched reviews returned **READY FOR FIXES** (see
the independent-review record). The current implementation closes the two theorem gaps identified by
the latest review: the `A3`- and `H3`-labelled tables now have explicit pairwise projective
injectivity in addition to two-sided coverage; the projective-point/nonzero-scalar map is bijective
onto all nonzero syndromes; and the disjoint `90+6` union is proved equal to
`ambiguityOneSyndromes`, with actual nearest-leader count one on every member. The pointwise bridge
gives counts `20,1,2,3,1` on incidence multiplicities `0,1,2,3,5`. The coordinate map also
has an explicit inverse, contragredient pairing theorem, and induced bijection on the 133 normalized
projective points. All proofs remain compact kernel proofs with no generated certificate tree. The
Lean-formalized label remains withheld until the final gate/build/axiom/trust evidence is committed
and a user-launched post-fix review returns `GO`. C222 stays live.

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

All terminals below are in namespace `RelativeConicArcs.Examples.ReflectionArrangements` (short names
are used in prose; the C320 table gives fully qualified names). Each proof is a compact kernel proof
(`decide`, `fin_cases`/`decide`, `ring`, `norm_num`, `omega`); no subclaim required a generated
case-split certificate tree, so the compactness gate is satisfied with no compactness stop.
Conventions: `Point11 = Fin 3 → ZMod 11`, `Point5 = Fin 3 → ZMod 5`; projective points are the fixed
first-nonzero-coordinate-normalized enumerations `projectiveVec : Fin 133 → Point11` for PG(2,11) and
`projectiveVec5 : Fin 31 → Point5` for PG(2,5); `SameDirection u v := ∃ a, a ≠ 0 ∧ a • u = v` is
projective equality of coordinate vectors; `cross`/`dot` are the triple-product and dot-product on
`Fin 3 → K`.

**What Lean checks versus what is cited.** Every Lean route below has passed its focused build,
import-only gate, and terminal-by-terminal axiom audit. Lean checks the explicit coordinate tables
and the integer/matrix identities.
Lean does **not**, in these modules, prove that the fifteen displayed `F_11` directions are the
projectivized `H3` reflection arrangement, that the four-point `F_5` frame construction is the
essentialized `A3` reflection arrangement, or that the displayed polynomials are those arrangements'
characteristic polynomials. Those identifications are classical (Orlik & Terao, *Arrangements of
Hyperplanes*, 1992, §6.4 and the exponent tables: `H3` exponents `{1,5,9}`, `A3` exponents `{1,2,3}`);
where a subclaim depends on them it is marked a **combination** route (Lean fact + cited classical
input), not pure Lean. All 47 task-terminal probes report exactly `propext`, `Classical.choice`, and
`Quot.sound`; the manuscript label remains withheld only for the required independent `GO`.

**S1 — Golden-ratio parameter over the three named fields (objective 1).** The chosen element
`8 : ZMod 11` satisfies τ² = τ + 1, as does `3 : ZMod 5`; in `ZMod 2` no element satisfies that
equation and `-1 = 1`. Lean proves exactly these three fields, not a general-`F_q` statement; the
role of τ as the projectivized-`H3` golden-ratio parameter is the classical arrangement input above.
- Route: validated full-trust Lean (`decide`) for the three field facts.
- Terminals: `tau11_relation`, `tau5_relation`, `h3_characteristic_two_boundary`.

**S2 — Fivefold arc and the fifteen mirrors (objective 2, first half).** The six A₅-fivefold points
`h3FivefoldPoint : Fin 6 → Point11` are in general position (every three have nonzero determinant, so
they form an arc), and their fifteen pairwise joins coincide projectively with the fifteen displayed
`H3`-labelled directions: both raw tables have cardinality fifteen, each join matches some displayed
direction under `SameDirection` and conversely, and both indexed tables are projectively injective.
- Route: validated full-trust Lean (`fin_cases`/`decide`); two-sided coverage and projective
  distinctness/cardinality 15 are
  both in the type.
- Terminals: `h3_fivefold_points_arc`, `h3_joins_are_root_directions`,
  `h3_join_directions_injective`, `h3_root_directions_injective`.

**S3 — Projectivity to the Clebsch columns and dual secants (objective 2, second half).** The matrix
T = [[2,3,8],[10,6,9],[2,2,5]] over F_11 has determinant `3 : ZMod 11`; the map `h3Projectivity`
sends each fivefold point to the Clebsch witness column `witnessVec i`, and the row/dual map
`h3DualProjectivity` sends each `H3` join to the Clebsch secant line `rawChordLine (chordEdge i)`,
each under `SameDirection`.
The explicit map `h3ProjectivityInverse` is proved on both sides, the determinant is proved nonzero,
`h3_dual_projectivity_dot` proves pairing preservation, and `h3ProjectiveIndex` is a bijection of the
133 normalized projective representatives.
- Route: validated full-trust Lean (`decide`/`ring` plus the existing affine-ray bijection).
- Terminals: `h3_projectivity_det`, `h3_projectivity_maps_fivefold_points`,
  `h3_dual_projectivity_maps_mirrors`, `h3_projectivity_det_ne_zero`,
  `h3_projectivity_inverse_apply`, `h3_projectivity_apply_inverse`,
  `h3_dual_projectivity_dot`, and `h3_projective_index_bijective`.
- Boundary: these are explicit coordinate-map theorems; no abstract projectivization quotient is
  introduced. `SameDirection` is interpreted projectively only for nonzero vectors, and its zero
  degeneracy is stated in the source.

**S4 — `H3` incidence ledger and pointwise index equality (objective 2 ledger and the complement
counts of objective 4).** Over the 133 fixed representatives of PG(2,11) the number of the fifteen
displayed lines through each point stratifies as 12₀, 90₁, 15₂, 10₃, 6₅ (twelve complement, ninety
ordinary, fifteen double, ten triple, six fivefold; the five cardinalities sum to 133), and the
incidence-5 locus is exactly the six fivefold points. For every `p : Fin 133` this incidence count
equals `rawPointIndex (h3Projectivity (projectiveVec p))` — a pointwise equality of two explicit
functions, stronger than equality of aggregate spectra.
- Route: validated full-trust Lean (`decide`) for the finite counts and the pointwise equality.
- Terminals: `h3_intersection_spectrum`, `h3_fivefold_points_exact`, `h3_fivefold_index_vec`,
  `h3_multiplicity_eq_rawPointIndex`.
- Boundary: the pointwise equality is with `rawPointIndex` of the *displayed image*, not composed
  with the projective bijection of S3, the affine-ray equivalence, or any decoder-soundness theorem.
  Naming the fifteen lines the `H3` arrangement is the classical input above.

**S5 — `A3` frame over F_5: projective-set equality and incidence spectra (objective 3).** The six
pairwise joins of the four-point frame and the six essentialized braid directions
{X, Y, Z, X−Y, X−Z, Y−Z} cover each other under `SameDirection`, and both indexed tables
are projectively injective, hence have projective cardinality six;
the incidence spectrum of those six join-lines over the 31 fixed representatives of PG(2,5) is
6₀, 18₁, 3₂, 4₃; and in characteristic five the fifteen `H3` lines give incidence spectrum
15₂, 10₃, 6₅ with all 31 points on at least two lines.
- Route: validated full-trust Lean (`decide`) for projective distinctness, two-sided equality, and
  the finite spectra.
- Terminals: `a3_frame_joins_are_braid_mirrors`, `a3_join_directions_injective`,
  `a3_root_directions_injective`, `a3_intersection_spectrum`,
  `h3_characteristic_five_spectrum`.
- Boundary: naming the coordinate model the essentialized `A3` reflection arrangement remains the
  cited classical input; equality of the two displayed projective tables is in the type.

**S6 — Arrangement incidence to actual decoder multiplicity (objective 4).** For every normalized
projective point `p : Fin 133` and every `a : NonzeroScalar`, `h3AffineSyndrome p a` is the affine ray
of the normalized projective image under `h3Projectivity`. The point/scalar map is bijective onto
all nonzero syndromes, each incidence stratum contributes exactly ten affine syndromes per
projective point, and actual
`nearestLeaderCount` is `20,1,2,3,1` at arrangement multiplicities `0,1,2,3,5`. Thus the ninety
incidence-one points and six incidence-five points form a disjoint union of cardinality
`10*(90+6)=960`, and that union is exactly `ambiguityOneSyndromes`.
The older `h3_decoder_strata` remains a separately named joint census only.
- Route: validated full-trust Lean, composing the projective-index bijection and pointwise
  incidence/index equality with `affineRay_syndromeDistance_exact`,
  `affineRay_weightTwo_leader_count`, `distanceOne_leader_count_one`, and
  `distanceThree_leader_count_twenty`.
- Terminals: `h3_affine_syndrome_bijective`, `h3_affine_syndromes_card`,
  `h3_affine_syndrome_nearestLeaderCount`, `h3_affine_syndromes_disjoint_of_ne`,
  `h3_one_leader_syndromes_card`, `h3_one_leader_syndromes_sound`,
  `h3_one_leader_syndromes_eq_ambiguityOne`, and the census-only `h3_decoder_strata` (module
  `RelativeConicArcs.ReflectionArrangementDecoding`).
- Boundary: the bridge is stated for actual nearest-leader cardinality on all 1330 nonzero
  syndromes; the one-leader union is identified exactly with `ambiguityOneSyndromes`. The other
  separately defined `ambiguity*Syndromes` finsets are not identified by set equality here because
  their actual nearest-leader cardinalities already follow pointwise from the bridge theorem.

**S7 — Integer ledger identities (supporting).** The identities 6·4 + 10·2 + 15·1 = 59,
t³−15t²+59t−45 = (t−1)(t−5)(t−9), t³−6t²+11t−6 = (t−1)(t−2)(t−3),
(q−5)(q−9)−(q+1) = (q−4)(q−11), and (q−2)(q−3)−(q+1) = (q−1)(q−5) hold as integer/polynomial
identities.
- Route: validated full-trust Lean (`ring`/`norm_num`) for the identities; **combination** for their
  arrangement meaning.
- Terminals: `h3_mobius_sum`, `h3_characteristic_polynomial`, `a3_characteristic_polynomial`,
  `h3_conic_size_factorization`, `a3_conic_size_factorization`.
- Boundary: the types are bare integer/polynomial identities; no arrangement characteristic
  polynomial, intersection lattice, Möbius function, complement, code, or conic object occurs in them.
  Reading them as the `H3`/`A3` characteristic polynomials (with roots equal to the Coxeter
  exponents) and as the
  complement-code conic-size relations is the classical input above.

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
- **τ representative.** `8 : ZMod 11` and `3 : ZMod 5` are the chosen roots of x² = x + 1, recorded as
  a representative choice. No claim is made or used here about the conjugate root's arrangement; that
  equivalence is not formalized.
- **Module sharding.** The decoder corollary `h3_decoder_strata` lives in the separate downstream
  module `ReflectionArrangementDecoding` so the coordinate leaf's elaboration does not accumulate the
  Q11 decoder closure.
- **Pointwise equality over aggregate equality.** `h3_multiplicity_eq_rawPointIndex` was proved
  pointwise (over `Fin 133`) rather than as an equality of spectra. This is stronger than
  aggregate-spectrum equality, but it does not by itself identify the decoder strata: it stops at
  `rawPointIndex` of the displayed image and is not composed with the projective bijection or the
  affine-ray/leader equivalences (see S6).

No compactness stop occurred: every attempted subclaim closed compactly, so no obstruction,
representative measurement, or weaker exit is on record.

## Proposed C320 ledger rows

Each row is `subclaim → fully qualified terminals → route → trusted boundary`. Names are written in
full (no abbreviations); the shared namespace is `RelativeConicArcs.Examples.ReflectionArrangements`.
The exact gate, axiom, hash, and commit evidence for these completed routes is recorded in the next
section. The separate Coxeter-arrangement interpretation remains a cited conceptual input.

| Subclaim | Fully qualified terminals | Route | Trusted boundary |
|---|---|---|---|
| S1 field golden-ratio facts | `RelativeConicArcs.Examples.ReflectionArrangements.tau11_relation`, `RelativeConicArcs.Examples.ReflectionArrangements.tau5_relation`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_two_boundary` | kernel `decide`; combination for the τ role | proves the three named fields only; general-field and `H3`-role reading classical (Orlik–Terao) |
| S2 fivefold arc + 15 mirrors | `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_arc`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_joins_are_root_directions`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_join_directions_injective`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_root_directions_injective` | kernel `decide` (two-sided and projectively injective) | self-contained coordinate/projective-set result; naming the lines `H3` is classical |
| S3 invertible projective coordinate map | `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_det`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_det_ne_zero`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_inverse_apply`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_apply_inverse`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_dual_projectivity_dot`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projective_index_bijective`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_maps_fivefold_points`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_dual_projectivity_maps_mirrors` | kernel `decide`/`ring`; existing affine-ray bijection | explicit coordinate/projective bijection and contragredient pairing; consumes `witnessVec`, `rawChordLine`, `chordEdge` |
| S4 incidence ledger + normalized pointwise index | `RelativeConicArcs.Examples.ReflectionArrangements.h3_intersection_spectrum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_exact`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_index_vec`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_multiplicity_eq_rawPointIndex`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_multiplicity_eq_normalized_rawPointIndex` | kernel `decide` plus scalar-invariance lemma | pointwise index equality transported through the normalized projective bijection; consumes `projectiveVec`, `rawPointIndex` |
| S5 `A3` two-sided joins + spectra | `RelativeConicArcs.Examples.ReflectionArrangements.a3_frame_joins_are_braid_mirrors`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_join_directions_injective`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_root_directions_injective`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_intersection_spectrum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_five_spectrum` | kernel `decide`; projective injectivity, two-sided coverage, and cardinality six | equality of the displayed projective sets; naming the coordinate model `A3` remains classical |
| S6 actual decoder multiplicity bridge | `RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndrome_bijective`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndromes_card`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndrome_nearestLeaderCount`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndromes_disjoint_of_ne`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_card`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_sound`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_eq_ambiguityOne`; census-only companion `RelativeConicArcs.Examples.ReflectionArrangements.h3_decoder_strata` | kernel proof composing the projective and decoder APIs | bijection onto all nonzero syndromes; multiplicities `0,1,2,3,5` map to actual leader counts `20,1,2,3,1`; the disjoint `90+6` union is exactly `ambiguityOneSyndromes` |
| S7 integer identities | `RelativeConicArcs.Examples.ReflectionArrangements.h3_mobius_sum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_polynomial`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_characteristic_polynomial`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_conic_size_factorization`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_conic_size_factorization` | `ring`/`norm_num`; combination for meaning | bare integer/polynomial identities; arrangement char-poly and conic reading classical (Orlik–Terao) |

## Build, gate, axiom, and trust evidence

The compact source and exact import-only gate elaborate against the current dependency closure.
Successful evidence:

- guarded single-file elaboration of `RelativeConicArcs/ReflectionArrangements.lean` and
  `RelativeConicArcs/ReflectionArrangementDecoding.lean`;
- exact queue builds of `RelativeConicArcs.ReflectionArrangements`,
  `RelativeConicArcs.ReflectionArrangementDecoding`, and
  `RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding`, followed by the trace-only
  aggregate confirmation, in run
  `/home/tavis/.cache/othello-lean-build/run-20260721-193843-39bbc5d6`;
- all 47 explicit `#print axioms` probes from the two task modules occurred in the aggregate log; a
  deterministic name-to-log comparison found no missing probe, and the union of their reported
  axioms is exactly `propext`, `Classical.choice`, and `Quot.sound`;
- `lean/RelativeConicArcs/CLEBSCH_TRUST.md` records the slice boundary, and `lean/TRUST.md` points to
  it without claiming a manifest for the complete Clebsch manuscript.

Replay from repository root:

```bash
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ReflectionArrangements \
  RelativeConicArcs.ReflectionArrangementDecoding \
  RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding \
  --profile single --threads 1 \
  --aggregate RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding --cores 20-23
```

Source identity at report time (identity, not mathematical correctness):

- `RelativeConicArcs/ReflectionArrangements.lean` — sha256
  `e7d891f0b758a2652e3b577cc7f99c7a146c9306b19e78576321d2b0f8062716`, 28490 bytes;
- `RelativeConicArcs/ReflectionArrangementDecoding.lean` — sha256
  `c1c98b3b25c868c02b7e302935b51813d73a6bfd5b20ab22c250bfe93747afd6`, 12966 bytes;
- `RelativeConicArcs/Gates/ClebschReflectionArrangementDecoding.lean` — sha256
  `bd34f178b36a6d5aeed294247230ac9207cfa72f39363606e50e461d6ad6391a`, 957 bytes;
- `RelativeConicArcs/CLEBSCH_TRUST.md` — sha256
  `e1b2a7c25f69769141476a522b60faad8fc8b045cd76e064b1e55ce25886054e`, 3336 bytes.
- `notes/scripts/extract_c222_adequacy.py` — sha256
  `ae778ed2dfb142dde7e23f41d827d47c2c6f4bf6bf0d3cc80fd4f4408901fd8e`, 2423 bytes.

The validated source/gate/trust bundle is pinned at commit
`7ecb98b5e0c743099ba8a7dc00aa53981da461e8`. The manuscript verification-table delta is deliberately
deferred until the required user-launched post-fix review returns `GO`; no paper claim is upgraded
from an unreviewed candidate route.

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
  quantifiers, nondegeneracy assumptions, conventions, hypotheses, and conclusion. — S1--S7 now
  match the strengthened theorem types, including two-sided `A3`, explicit projective transport, and
  actual nearest-leader counts on every point/scalar pair.
- [x] Assign every subclaim one final trust route and separate conditional/external clauses; no
  result inherits a Lean label from sharing a module or gate. — S1--S7 and the proposed C320 rows
  separate coordinate/kernel facts from the external Coxeter-arrangement interpretation.
- [x] Read definitions and theorem types to exclude vacuity, conclusions baked into definitions,
  weakened quantifiers, hidden assumptions, empty domains, and prose/names stronger than types. —
  `SameDirection` is a genuine `∃ a ≠ 0`; cardinalities are computed by `decide`, not asserted;
  incidence is a filter count over a nonempty `Fin` domain, not baked into a definition; the
  projective and decoder maps now occur explicitly in the relevant theorem types.
- [x] Record exact owned files, permitted imports, fully qualified terminals, import-only gate,
  pinned commit, guarded/gate validation, and `#print axioms` for every claimed Lean terminal. — the
  validated bundle is pinned at `7ecb98b5e0c743099ba8a7dc00aa53981da461e8`; the build run, gate,
  hashes, 47 probes, and trust manifest are recorded above.
- [x] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, large generated
  case tree, or unreported non-kernel execution occurs in a full-trust closure. — all 47 terminal
  probes report exactly `propext`, `Classical.choice`, and `Quot.sound`; source and manifest record the
  compact kernel boundary.
- [x] For any finite computation, record checker and soundness theorem, domain/coverage,
  generator/schema/data/hash, independent replay, and residual trusted boundary. — the checker is the
  in-kernel `Decidable` evaluation; domains are the explicit `Fin 133`/`Fin 31`/`Fin 15`/`Fin 6`/
  `Fin 4` sets checked exhaustively; there is no external generator or data file, hence no separate
  replay artifact; residual trust is the Lean kernel and the three audited standard axioms.
- [x] Recompute hashes/byte counts after final edits and distinguish identity/reproducibility from
  mathematical correctness. — sha256 and byte counts above; these certify file identity, not the
  mathematics; they were recomputed after the final source edits.
- [x] Review the entire touched Lean artifact for self-contained comments/names, exact trust prose,
  one-way internal references, factual citations, and no novelty/strength overclaim. — the three
  touched Lean modules contain no internal workflow reference; zero-vector, raw-normalization,
  computation, semantic-label, and trust boundaries are explicit.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction, for the paper adequacy appendix. — `notes/scripts/extract_c222_adequacy.py --check`
  validates the exact terminal and definition extraction.
- [x] State every exclusion and compactness stop precisely and confirm the manuscript verification
  map retains the correct computer-assisted label. — exclusions per Out of scope; no compactness stop
  occurred; the manuscript verification row is not upgraded before the independent `GO`.
- [x] Complete the judgment-call record and proposed C320 row for every objective subclaim. —
  recorded above; the conjugate-root claim and the pointwise-bridge overstatement were corrected per
  findings 6 and 7.
- [ ] Record independent review findings, fixes, post-fix review, and final `GO`. — all four
  `READY FOR FIXES` reviews and the current remediation are recorded; the new post-fix review and
  `GO` are pending.
- [ ] Only after final `GO`, archive the live task row with this completed report and evidence. —
  pending: C222 stays live until a recorded `GO`.

## Independent review and remediation

A user-launched initial review and three user-launched post-fix reviews are recorded at
`notes/2026-07-20-c222-independent-review.md`; every disposition was **READY FOR FIXES**, not `GO`.
The first review found seven type/prose/trust defects. The interrupted first remediation was then
committed coherently, and the second post-fix review isolated five remaining defects SF1--SF5.
The third post-fix review confirmed the build/axiom repairs but found four residual strength/prose
defects. Current remediation:

- **SF1 (gate/trust evidence):** added the import-only gate
  `RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding`, exact leaf/gate builds, all 47
  terminal probes, and the bounded Clebsch slice manifest.
- **SF2 (`A3` and decoder exits):** strengthened the `A3` theorem to two-sided coverage plus
  cardinality six; added an explicit point/scalar-to-syndrome map, injectivity, factor-ten cardinality,
  actual nearest-leader equivalence, and the `90+6` one-leader theorem. No compactness fallback is
  needed because both intended theorems close compactly.
- **SF3 (projective transport):** added the nonzero determinant, two-sided explicit inverse,
  contragredient pairing identity, normalized projective-index injection/bijection, and normalized
  pointwise secant-index transport.
- **SF4 (referee prose):** stated the zero-vector degeneracy of `SameDirection`, corrected the raw
  join-vector description, removed the inadequate source-level classical citation, and neutralized
  every inverse/semantic claim until backed by a theorem type.
- **SF5 (adequacy/checklist):** added the deterministic extraction script, refreshed the C320 rows,
  hashes, review history, and evidence checklist.
- **Third-review projective cardinality:** added pairwise projective-injectivity terminals for both
  join and displayed-direction tables in the `H3`- and `A3`-labelled coordinate models.
- **Third-review exact one-leader decomposition:** added a bijection onto all nonzero syndromes,
  disjointness of distinct incidence images, exact cardinality and nearest-leader soundness for the
  `90+6` union, and equality of that union with `ambiguityOneSyndromes`.
- **Third-review stale trust/prose:** changed every completed route from candidate/pending to its
  validated route, corrected the determinant and exponent prose, and made `A3`/`H3` labels explicitly
  mnemonic rather than uncited abstract identifications in the referee-facing artifact.

Adopted review guards (also to be copied into later Clebsch task documents): a theorem advertised as
identifying two structures must contain a map and a relation in its type; every finite-set equality
must audit both directions and cardinality; every semantic noun must be in the type or carry an
explicit citation route; every terminal gets its own fully qualified name, gate import, and axiom
entry; strength words require a matching theorem or neutral replacement; a checked box must point to
durable evidence.

Remaining for `GO`: commit and pin this coherent bundle, then obtain the required user-launched
post-fix review. The implementer does not launch that review.

## Adequacy-appendix extraction

The authoritative deterministic extraction is:

```bash
python3 notes/scripts/extract_c222_adequacy.py
python3 notes/scripts/extract_c222_adequacy.py --check
```

It reads both task modules, extracts every theorem named by a `#print axioms` probe and every
load-bearing definition named in the script, fails unless each declaration occurs exactly once, and
prints theorem signatures without proof bodies plus full definition bodies. The following compact
excerpt records the original terminal surface; the command above also covers the strengthened
projectivity, `A3`, and decoder terminals.

```lean
theorem tau11_relation : tau11 ^ 2 = tau11 + 1
theorem tau5_relation : tau5 ^ 2 = tau5 + 1
theorem h3_characteristic_two_boundary :
    (-1 : ZMod 2) = 1 ∧ ¬∃ tau : ZMod 2, tau ^ 2 = tau + 1
theorem h3_fivefold_points_arc :
    ∀ i j k : Fin 6, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![h3FivefoldPoint i, h3FivefoldPoint j, h3FivefoldPoint k] ≠ 0
theorem h3_joins_are_root_directions :
    h3Joins.card = 15 ∧ h3RootDirections.card = 15 ∧
      (∀ i : Fin 15, ∃ j : Fin 15, SameDirection (h3Join i) (h3RootDirection j)) ∧
      (∀ j : Fin 15, ∃ i : Fin 15, SameDirection (h3Join i) (h3RootDirection j))
theorem h3_projectivity_det :
    Matrix.det (![![2, 3, 8], ![10, 6, 9], ![2, 2, 5]] : Matrix (Fin 3) (Fin 3) (ZMod 11)) = 3
theorem h3_projectivity_maps_fivefold_points (i : Fin 6) :
    SameDirection (h3Projectivity (h3FivefoldPoint i)) (witnessVec i)
theorem h3_dual_projectivity_maps_mirrors (i : Fin 15) :
    SameDirection (h3DualProjectivity (h3Join i)) (rawChordLine (chordEdge i))
theorem h3_multiplicity_eq_rawPointIndex :
    ∀ p : Fin 133,
      (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card =
        rawPointIndex (h3Projectivity (projectiveVec p))
theorem h3_fivefold_index_vec (i : Fin 6) :
    projectiveVec (h3FivefoldIndex i) = h3FivefoldPoint i
theorem h3_fivefold_points_exact :
    h3PointsOfMultiplicity 5 = Finset.univ.image h3FivefoldIndex
theorem h3_intersection_spectrum :
    (h3PointsOfMultiplicity 0).card = 12 ∧ (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧ (h3PointsOfMultiplicity 3).card = 10 ∧
    (h3PointsOfMultiplicity 5).card = 6
theorem h3_characteristic_five_spectrum :
    (h3PointsOfMultiplicity5 2).card = 15 ∧ (h3PointsOfMultiplicity5 3).card = 10 ∧
    (h3PointsOfMultiplicity5 5).card = 6
theorem a3_frame_joins_are_braid_mirrors :
    a3Joins.card = 6 ∧ a3RootDirections.card = 6 ∧
      (∀ i : Fin 6, ∃ j : Fin 6, SameDirection (a3Join i) (a3RootDirection j)) ∧
      (∀ j : Fin 6, ∃ i : Fin 6, SameDirection (a3Join i) (a3RootDirection j))
theorem a3_intersection_spectrum :
    (a3PointsOfMultiplicity 0).card = 6 ∧ (a3PointsOfMultiplicity 1).card = 18 ∧
    (a3PointsOfMultiplicity 2).card = 3 ∧ (a3PointsOfMultiplicity 3).card = 4
theorem h3_mobius_sum : 6 * (5 - 1) + 10 * (3 - 1) + 15 * (2 - 1) = 59
theorem h3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 15 * t ^ 2 + 59 * t - 45 = (t - 1) * (t - 5) * (t - 9)
theorem a3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 6 * t ^ 2 + 11 * t - 6 = (t - 1) * (t - 2) * (t - 3)
theorem h3_conic_size_factorization (q : ℤ) :
    (q - 5) * (q - 9) - (q + 1) = (q - 4) * (q - 11)
theorem a3_conic_size_factorization (q : ℤ) :
    (q - 2) * (q - 3) - (q + 1) = (q - 1) * (q - 5)
theorem h3_decoder_strata :
    (h3PointsOfMultiplicity 0).card = 12 ∧ (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧ (h3PointsOfMultiplicity 3).card = 10 ∧
    ambiguityOneSyndromes.card = 960 ∧ ambiguityTwoSyndromes.card = 150 ∧
    ambiguityThreeSyndromes.card = 100 ∧ ambiguityTwentySyndromes.card = 120
```

The extraction additionally includes `ProjectivelyInjective`, `h3ProjectivityInverse`,
`projectiveIndex11`, `h3ProjectiveIndex`, `a3Joins`, `a3RootDirections`, `h3AffineSyndrome`,
`h3AffineSyndromeNonzero`, `h3AffineSyndromesOfMultiplicity`, and `h3OneLeaderSyndromes`. Imported
Q11 declarations are cited by fully qualified theorem composition in S4/S6 and remain audited by
their own source modules.
