# C222 — compact Lean closure of the `A3/H3` synthesis

**Lane:** `clebsch`

**Status:** ACTIVE; compact-proof gate; one independent review returned **READY FOR FIXES** (see the
independent-review section). Both task modules — the coordinate/finite-arrangement leaf
`lean/RelativeConicArcs/ReflectionArrangements.lean` and the downstream decoder corollary
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean` — are committed with compact kernel
(`decide`/`fin_cases`/`ring`/`norm_num`) proofs and no generated certificate tree. The source-level
report below is complete as a record, but every Lean route is **candidate** full-trust only: the
Lean-formalized label is withheld until the gate, current elaboration, pinned commit,
terminal-by-terminal `#print axioms` audit, and Clebsch trust-manifest row exist, and until a
post-fix review returns `GO`. Two objective consequences are deliberately not Lean-formalized — the
decoder-stratum identification of objective 4 and the full `A3` set equality of objective 3 — and are
narrowed to what the types prove, with the strengthenings recorded as build-gated. C222 stays live.

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

**What Lean checks versus what is cited.** Every route below is *candidate* full-trust pending the
axiom audit and gate. Lean checks the explicit coordinate tables and the integer/matrix identities.
Lean does **not**, in these modules, prove that the fifteen displayed `F_11` directions are the
projectivized `H3` reflection arrangement, that the four-point `F_5` frame construction is the
essentialized `A3` reflection arrangement, or that the displayed polynomials are those arrangements'
characteristic polynomials. Those identifications are classical (Orlik & Terao, *Arrangements of
Hyperplanes*, 1992, §6.4 and the exponent tables: `H3` exponents `{1,5,9}`, `A3` exponents `{1,2,3}`);
where a subclaim depends on them it is marked a **combination** route (Lean fact + cited classical
input), not pure Lean. The live `#print axioms` transcript is build-gated and recorded as pending.

**S1 — Golden-ratio parameter over the three named fields (objective 1).** The chosen element
`8 : ZMod 11` satisfies τ² = τ + 1, as does `3 : ZMod 5`; in `ZMod 2` no element satisfies that
equation and `-1 = 1`. Lean proves exactly these three fields, not a general-`F_q` statement; the
role of τ as the projectivized-`H3` golden-ratio parameter is the classical arrangement input above.
- Route: candidate full-trust Lean (`decide`) for the three field facts.
- Terminals: `tau11_relation`, `tau5_relation`, `h3_characteristic_two_boundary`.

**S2 — Fivefold arc and the fifteen mirrors (objective 2, first half).** The six A₅-fivefold points
`h3FivefoldPoint : Fin 6 → Point11` are in general position (every three have nonzero determinant, so
they form an arc), and their fifteen pairwise joins coincide projectively with the fifteen displayed
`H3` root directions: `h3Joins.card = 15`, `h3RootDirections.card = 15`, and each join matches some
root direction under `SameDirection` and conversely.
- Route: candidate full-trust Lean (`fin_cases`/`decide`); two-sided coverage and cardinality 15 are
  both in the type.
- Terminals: `h3_fivefold_points_arc`, `h3_joins_are_root_directions`.

**S3 — Projectivity to the Clebsch columns and dual secants (objective 2, second half).** The matrix
T = [[2,3,8],[10,6,9],[2,2,5]] over F_11 has determinant `3 : ZMod 11`; the map `h3Projectivity`
sends each fivefold point to the Clebsch witness column `witnessVec i`, and the row/dual map
`h3DualProjectivity` sends each `H3` join to the Clebsch secant line `rawChordLine (chordEdge i)`,
each under `SameDirection`.
- Route: candidate full-trust Lean (`decide`) for the finite row identities.
- Terminals: `h3_projectivity_det`, `h3_projectivity_maps_fivefold_points`,
  `h3_dual_projectivity_maps_mirrors`.
- Boundary: `h3_projectivity_det` proves `det T = 3` only. `3 ≠ 0`, the packaging of `T` as a linear
  or projective bijection, and the inverse-transpose identity for `h3DualProjectivity` are not
  separate terminals; the row-by-row maps are exact, but global transport of strata through the
  bijection is not a Lean-backed step here.

**S4 — `H3` incidence ledger and pointwise index equality (objective 2 ledger and the complement
counts of objective 4).** Over the 133 fixed representatives of PG(2,11) the number of the fifteen
displayed lines through each point stratifies as 12₀, 90₁, 15₂, 10₃, 6₅ (twelve complement, ninety
ordinary, fifteen double, ten triple, six fivefold; the five cardinalities sum to 133), and the
incidence-5 locus is exactly the six fivefold points. For every `p : Fin 133` this incidence count
equals `rawPointIndex (h3Projectivity (projectiveVec p))` — a pointwise equality of two explicit
functions, stronger than equality of aggregate spectra.
- Route: candidate full-trust Lean (`decide`) for the finite counts and the pointwise equality.
- Terminals: `h3_intersection_spectrum`, `h3_fivefold_points_exact`, `h3_fivefold_index_vec`,
  `h3_multiplicity_eq_rawPointIndex`.
- Boundary: the pointwise equality is with `rawPointIndex` of the *displayed image*, not composed
  with the projective bijection of S3, the affine-ray equivalence, or any decoder-soundness theorem.
  Naming the fifteen lines the `H3` arrangement is the classical input above.

**S5 — `A3` frame over F_5: one-sided join coverage and incidence spectra (objective 3).** Each of the
six pairwise joins of the four-point frame `a3FramePoint` in PG(2,5) is parallel (`SameDirection`) to
some one of the six essentialized braid directions {X, Y, Z, X−Y, X−Z, Y−Z}; the incidence spectrum of
those six join-lines over the 31 fixed representatives of PG(2,5) is 6₀, 18₁, 3₂, 4₃; and in
characteristic five the fifteen `H3` lines give incidence spectrum 15₂, 10₃, 6₅ with all 31 points on
at least two lines.
- Route: candidate full-trust Lean (`decide`) for the finite spectra; the join→direction statement is
  one-sided only.
- Terminals: `a3_frame_joins_are_braid_mirrors`, `a3_intersection_spectrum`,
  `h3_characteristic_five_spectrum`.
- Boundary: `a3_frame_joins_are_braid_mirrors` proves only that each join matches *some* braid
  direction; the reverse inclusion and projective cardinality six — hence equality of the two
  projective sets — are not in the type. Naming these the `A3` arrangement is the classical input
  above; the two-sided set equality is a deferred (build-gated) strengthening.

**S6 — Joint incidence/ambiguity census (objective 4 connection, narrowed).** `h3_decoder_strata`
proves one conjunction of eight cardinality equalities: the `H3` incidence-stratum sizes 12/90/15/10
for incidence 0/1/2/3, together with the Clebsch nearest-codeword ambiguity-census sizes
960/150/100/120 (`ambiguityOneSyndromes`, `ambiguityTwoSyndromes`, `ambiguityThreeSyndromes`,
`ambiguityTwentySyndromes`).
- Route: candidate full-trust Lean (`decide`) — a joint numerical census composing
  `h3_intersection_spectrum` with `ambiguity_strata_counts` from
  `RelativeConicArcs.Q11DecodingSynthesis`.
- Terminal: `h3_decoder_strata` (module `RelativeConicArcs.ReflectionArrangementDecoding`).
- Boundary: the type is a conjunction of counts only. It exhibits **no** map between an `H3`
  projective point and an affine syndrome, no membership or leader-count equivalence, no factor-ten
  scalar-ray correspondence, and no 90+6 decomposition of the 960 one-leader syndromes. Objective 4's
  decoder-stratum *identification* is therefore **not** Lean-formalized; it stays computer-assisted. A
  genuine bridge theorem (point/ray map plus leader-count equivalences, including the incidence-5
  contribution and the factor ten) is a deferred build-gated strengthening.

**S7 — Integer ledger identities (supporting).** The identities 6·4 + 10·2 + 15·1 = 59,
t³−15t²+59t−45 = (t−1)(t−5)(t−9), t³−6t²+11t−6 = (t−1)(t−2)(t−3),
(q−5)(q−9)−(q+1) = (q−4)(q−11), and (q−2)(q−3)−(q+1) = (q−1)(q−5) hold as integer/polynomial
identities.
- Route: candidate full-trust Lean (`ring`/`norm_num`) for the identities; **combination** for their
  arrangement meaning.
- Terminals: `h3_mobius_sum`, `h3_characteristic_polynomial`, `a3_characteristic_polynomial`,
  `h3_conic_size_factorization`, `a3_conic_size_factorization`.
- Boundary: the types are bare integer/polynomial identities; no arrangement characteristic
  polynomial, intersection lattice, Möbius function, complement, code, or conic object occurs in them.
  Reading them as the `H3`/`A3` characteristic polynomials (roots `1 +` the exponents) and as the
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
Axiom and gate evidence is pending the build window (next section) and is not asserted; every route is
candidate until that evidence lands.

| Subclaim | Fully qualified terminals | Route | Trusted boundary |
|---|---|---|---|
| S1 field golden-ratio facts | `RelativeConicArcs.Examples.ReflectionArrangements.tau11_relation`, `RelativeConicArcs.Examples.ReflectionArrangements.tau5_relation`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_two_boundary` | kernel `decide`; combination for the τ role | proves the three named fields only; general-field and `H3`-role reading classical (Orlik–Terao) |
| S2 fivefold arc + 15 mirrors | `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_arc`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_joins_are_root_directions` | kernel `decide` (two-sided) | self-contained; naming the lines `H3` is classical |
| S3 projectivity rows | `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_det`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_maps_fivefold_points`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_dual_projectivity_maps_mirrors` | kernel `decide` | `det T = 3` only; bijection/inverse-transpose not exposed; consumes `witnessVec`, `rawChordLine`, `chordEdge` |
| S4 incidence ledger + pointwise index | `RelativeConicArcs.Examples.ReflectionArrangements.h3_intersection_spectrum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_exact`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_index_vec`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_multiplicity_eq_rawPointIndex` | kernel `decide` | pointwise index equality only, no bijection transport; consumes `projectiveVec`, `rawPointIndex` |
| S5 `A3` one-sided joins + spectra | `RelativeConicArcs.Examples.ReflectionArrangements.a3_frame_joins_are_braid_mirrors`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_intersection_spectrum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_five_spectrum` | kernel `decide`; one-sided join coverage | reverse inclusion and set equality not proved; naming the lines `A3` is classical |
| S6 joint census | `RelativeConicArcs.Examples.ReflectionArrangements.h3_decoder_strata` (module `RelativeConicArcs.ReflectionArrangementDecoding`) | kernel `decide` (conjunction) | conjunction of eight counts only; no stratum map; consumes `ambiguity_strata_counts` from `RelativeConicArcs.Q11DecodingSynthesis` |
| S7 integer identities | `RelativeConicArcs.Examples.ReflectionArrangements.h3_mobius_sum`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_polynomial`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_characteristic_polynomial`, `RelativeConicArcs.Examples.ReflectionArrangements.h3_conic_size_factorization`, `RelativeConicArcs.Examples.ReflectionArrangements.a3_conic_size_factorization` | `ring`/`norm_num`; combination for meaning | bare integer/polynomial identities; arrangement char-poly and conic reading classical (Orlik–Terao) |

## Build-gated evidence pending the shared Lean lock

The following cannot be produced in a source-only, no-elaboration session and remain outstanding
behind the shared build-owner lock; none is fabricated here:

- a focused elaboration of `RelativeConicArcs.ReflectionArrangementDecoding`, and a re-elaboration of
  `RelativeConicArcs.ReflectionArrangements`, against the current dependency closure;
- the live `#print axioms` transcript for every terminal above — the source now carries a per-terminal
  `#print axioms` probe for each listed terminal, but none has been run; both task modules use only
  `decide`/`fin_cases`/`ring`/`norm_num`/`omega` with no `native_decide`, `sorry`, or local `axiom`,
  so the expected closure is `propext`, `Classical.choice`, `Quot.sound`; this is an expectation, not
  recorded output, and the full transitive Q11/Mathlib closure must still be inspected;
- an import-only `RelativeConicArcs.Gates.*` exit gate importing the paper-facing terminals — no gate
  module currently imports them — together with its exact-target `--no-build` confirmation;
- a Clebsch trust-manifest row for these terminals (`lean/TRUST.md` currently records no per-paper
  Clebsch manifest);
- the pinned validated commit for the C320 ledger (current source identity recorded below);
- the manuscript verification-table update, which must retain the computer-assisted label for these
  claims until the axiom transcript and gate land;
- the optional type-strengthenings that would upgrade the narrowed claims to Lean-formalized: a real
  decoder-stratum bridge theorem for S6 (point/ray map plus leader-count equivalences, the incidence-5
  contribution, and the factor ten), a two-sided `A3` join-equals-braid-arrangement theorem with
  projective cardinality six for S5, and a projective-bijection / inverse-transpose API for `T` in S3.
  These require writing and elaborating new Lean and are out of scope for a source-only session.

Source identity at report time (identity, not correctness):

- `RelativeConicArcs/ReflectionArrangements.lean` — sha256
  `6d1fa115246c0ddfcffc0a69e2b888a6755056a2eab5d0e8f18f316931d130f1`, 16165 bytes, after the
  docstring/header/probe remediation of this pass (the 179 code lines are byte-identical to the prior
  version; only comments and `#print axioms` probes changed).
- `RelativeConicArcs/ReflectionArrangementDecoding.lean` — sha256
  `780d7bc937fac57a7a55cc6004c0571917cf0dc32a1cee7ac397c199d9659fdd`, 1572 bytes, after the
  docstring/header remediation of this pass (code lines byte-identical to the prior version). The
  pinned validated commit for the C320 ledger still awaits the build window.

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

- [ ] State every objective subclaim in ordinary mathematics with exact field, coordinates,
  quantifiers, nondegeneracy assumptions, conventions, hypotheses, and conclusion. — reopened by
  review findings 1, 2, 4, 5; each statement is now narrowed to the proved type (S1 three named fields;
  S4 pointwise index equality; S5 one-sided join coverage; S6 census-only; S7 integer identities);
  awaits post-fix confirmation.
- [ ] Assign every subclaim one final trust route and separate conditional/external clauses; no
  result inherits a Lean label from sharing a module or gate. — reopened; routes are now split into
  Lean fact versus combination (classical Orlik–Terao input) versus deferred strengthening, and
  objective 3's full `A3` set equality and objective 4's decoder-stratum identification are marked
  not Lean-formalized; awaits post-fix confirmation.
- [x] Read definitions and theorem types to exclude vacuity, conclusions baked into definitions,
  weakened quantifiers, hidden assumptions, empty domains, and prose/names stronger than types. —
  `SameDirection` is a genuine `∃ a ≠ 0`; cardinalities are computed by `decide`, not asserted;
  incidence is a filter count over a nonempty `Fin` domain, not baked into a definition; the one-sided
  `A3` coverage and census-only decoder theorem are now stated at their exact strength.
- [ ] Record exact owned files, permitted imports, fully qualified terminals, import-only gate,
  pinned commit, guarded/gate validation, and `#print axioms` for every claimed Lean terminal. —
  pending: files, imports, fully qualified terminals, introducing commits, and source identity are
  recorded above, but no `RelativeConicArcs.Gates.*` gate imports these terminals, and the
  guarded/gate validation, `#print axioms` transcript, trust-manifest row, and pinned validated commit
  require the build window.
- [ ] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, large generated
  case tree, or unreported non-kernel execution occurs in a full-trust closure. — pending:
  source-confirmed absent in both task modules and in the project-owned import closure; the full
  transitive Q11/Mathlib closure confirmation requires the `#print axioms` transcript.
- [x] For any finite computation, record checker and soundness theorem, domain/coverage,
  generator/schema/data/hash, independent replay, and residual trusted boundary. — the checker is the
  in-kernel `Decidable` evaluation; domains are the explicit `Fin 133`/`Fin 31`/`Fin 15`/`Fin 6`/
  `Fin 4` sets checked exhaustively; there is no external generator or data file, hence no separate
  replay artifact; residual trust is the Lean kernel plus the pending axiom audit.
- [x] Recompute hashes/byte counts after final edits and distinguish identity/reproducibility from
  mathematical correctness. — sha256 and byte counts above; these certify file identity, not the
  mathematics, and must be recomputed after the source docstring edits land.
- [ ] Review the entire touched Lean artifact for self-contained comments/names, exact trust prose,
  one-way internal references, factual citations, and no novelty/strength overclaim. — reopened by
  finding 6; docstrings were added, module headers rewritten to be self-contained, and the strength
  words `agree`/`complete`/`canonical`/`paper-facing`/`lattice-faithful` removed or narrowed in
  source; a full cold re-audit awaits post-fix review.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction, for the paper adequacy appendix. — verbatim theorem signatures and load-bearing
  definitions are listed in the adequacy-appendix extraction section below.
- [x] State every exclusion and compactness stop precisely and confirm the manuscript verification
  map retains the correct computer-assisted label. — exclusions per Out of scope; no compactness stop
  occurred; the manuscript retains the computer-assisted label, and the objective 3/4 consequences are
  explicitly held out of the Lean-formalized set.
- [x] Complete the judgment-call record and proposed C320 row for every objective subclaim. —
  recorded above; the conjugate-root claim and the pointwise-bridge overstatement were corrected per
  findings 6 and 7.
- [ ] Record independent review findings, fixes, post-fix review, and final `GO`. — the first review
  (READY FOR FIXES) and the remediation are recorded in the independent-review section below; the
  post-fix review and `GO` are pending.
- [ ] Only after final `GO`, archive the live task row with this completed report and evidence. —
  pending: C222 stays live until a recorded `GO`.

## Independent review and remediation

A user-launched independent review is recorded at `notes/2026-07-20-c222-independent-review.md`
(disposition **READY FOR FIXES**, not `GO`). It confirmed the two source hashes and a clean
project-owned closure scan (no `sorry`/`native_decide`/`axiom`/`opaque`), and raised seven findings.
Remediation applied in this source-only, no-build pass:

- **F1 (blocking) — decoder terminal proves only a census, not stratum agreement.** S6 and the
  `h3_decoder_strata` docstring are narrowed to a joint numerical census; objective 4's decoder-stratum
  identification is marked **not** Lean-formalized; a real bridge theorem is recorded as a deferred
  build-gated strengthening.
- **F2 (blocking) — `A3` mirror theorem is one-sided.** S5 and the `a3_frame_joins_are_braid_mirrors`
  docstring now state only that each join is parallel to some braid direction; reverse inclusion and
  cardinality six are recorded as a deferred strengthening.
- **F3 (blocking) — premature full-trust/complete labels.** Every route is relabelled **candidate**
  full-trust; the false "probes for every terminal" claim is corrected and per-terminal `#print axioms`
  probes were added to source; the absent gate, trust-manifest row, pinned validated commit, and live
  transcript are listed as build-gated.
- **F4 (blocking) — semantics exceed types.** The ledger now splits Lean facts (coordinate tables,
  integer identities) from the classical arrangement identification (Orlik & Terao, *Arrangements of
  Hyperplanes*, 1992); S1 is restricted to the three named fields; "lattice-faithful" is replaced by
  the exact spectrum statement; S7 is stated as integer/polynomial identities.
- **F5 (major) — projectivity API implicit.** S3 records that only `det T = 3` is proved and that no
  bijection/inverse-transpose terminal exists, so global stratum transport is not a Lean-backed step.
- **F6 (major) — documentation incomplete / strength prose.** A docstring pass was applied to both
  modules, the module headers were rewritten to be self-contained (fields, conventions, terminals,
  method, trust boundary), and the words `agree`/`complete`/`canonical`/`paper-facing`/
  `lattice-faithful` were removed or narrowed.
- **F7 (major) — checklist over-ticked.** The adequacy, route, and prose boxes are reopened; the
  finite-computation box now states that no external replay artifact exists; ledger names are fully
  qualified; a verbatim adequacy-appendix extraction is added below.

Adopted review guards (also to be copied into later Clebsch task documents): a theorem advertised as
identifying two structures must contain a map and a relation in its type; every finite-set equality
must audit both directions and cardinality; every semantic noun must be in the type or carry an
explicit citation route; every terminal gets its own fully qualified name, gate import, and axiom
entry; strength words require a matching theorem or neutral replacement; a checked box must point to
durable evidence.

Remaining for `GO`: the build-gated evidence listed above, optionally the deferred type-strengthenings,
and a user-launched post-fix review. The implementer does not launch that review.

## Adequacy-appendix extraction (verbatim signatures)

Exact terminal signatures, copied from source for the paper adequacy appendix. Namespace
`RelativeConicArcs.Examples.ReflectionArrangements`; the last is in module
`RelativeConicArcs.ReflectionArrangementDecoding`.

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
    ∀ i : Fin 6, ∃ j : Fin 6, SameDirection (a3Join i) (a3RootDirection j)
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

Load-bearing definitions in the closure: `SameDirection`, `cross`, `dot`, `tau11`, `tau5`,
`h3FivefoldPoint`, `h3Join`, `h3RootDirection`, `h3Projectivity`, `h3DualProjectivity`,
`h3Multiplicity`, `h3PointsOfMultiplicity`, `h3FivefoldIndex`, `projectiveVec5`, `h3RootDirection5`,
`h3Multiplicity5`, `h3PointsOfMultiplicity5`, `a3FramePoint`, `a3Join`, `a3RootDirection`,
`a3Multiplicity`, `a3PointsOfMultiplicity`; and, from the Q11 layer, `projectiveVec`, `witnessVec`,
`rawChordLine`, `chordEdge`, `rawPointIndex`, and the `ambiguity*Syndromes` families.
