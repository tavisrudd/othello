# Independent review of C222 — compact `A3/H3` Lean closure

**Lane:** `clebsch`

**Review authority:** user-launched Codex review

**Disposition:** **NO-GO — READY FOR FIXES**. The post-fix remediation is interrupted and not a
coherent committed artifact. This is not `GO`, and C222 must remain active.

## Scope and method

This review read the actual types, definitions, comments, and names in
`lean/RelativeConicArcs/ReflectionArrangements.lean` and
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean`, together with their current
project-owned import closure, the C222 report, the Clebsch formalization plan and handoff, the paper
trust policy, `lean/TRUST.md`, and the Lean referee-facing standards. It did not edit or elaborate
Lean, create a gate, run Lake, regenerate data, or touch certificates or Q25 paths. C222 is an active
implementation, so missing build/gate evidence is classified as provisional work unless the report
already claims it is complete; a theorem or docstring stronger than its type is classified as an
error.

The two reviewed source hashes still agree with the C222 report:

- `ReflectionArrangements.lean`: sha256
  `9154964eb896470a61d222798cff654ad41343f3248b256939a08566d2d2ef82`, 11202 bytes.
- `ReflectionArrangementDecoding.lean`: sha256
  `11c6bf272e233fd137bcbeb2ae4d62231983ab91c791fe0bba886026624a519b`, 1463 bytes.

A source scan of the 33-file project-owned import closure found no `sorry`, `native_decide`, local
`axiom`, or `opaque` declaration. That is useful source evidence, not a substitute for the required
live `#print axioms` audit or a gate build. No current module under
`lean/RelativeConicArcs/Gates/` imports either C222 module.

## Prioritized findings

### 1. Blocking — the decoder terminal does not prove stratum agreement

**Location:** `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean:16-31`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:136-144,197`.

The docstring says the reduced `H3` multiplicity strata and Clebsch decoder strata “agree,” and the
report says the geometric identification is carried by the projectivity and pointwise-index bridge.
The theorem type is only a conjunction of eight independent cardinality equalities. Its proof simply
pairs `h3_intersection_spectrum` with `ambiguity_strata_counts`. It contains no map between an `H3`
projective point and an affine syndrome, no scalar-ray factor of ten, no membership equivalence, and
no statement relating multiplicity `0/1/2/3/5` to nearest-leader multiplicity `20/1/2/3/1`.

The existing `h3_multiplicity_eq_rawPointIndex` is a valuable pointwise bridge, but it stops at
`rawPointIndex (h3Projectivity (projectiveVec p))`. The decoder terminal does not compose it with
the affine-ray equivalence, the decoder soundness theorems, or bijectivity of the projectivity on
projective points. In particular, the `960` one-leader count combines 90 ordinary projective points
and six fivefold points, while the present theorem omits that decomposition entirely.

**Impact:** C222 objective 4's decoder-stratum consequence is not Lean-formalized. The current
docstring is stronger than the elaborated statement.

**Required fix:** either add an actual bridge theorem with an explicit point/ray map and membership
or leader-count equivalences (including the multiplicity-5 contribution and factor ten), or narrow
the declaration name, docstring, task ledger, and manuscript route to “joint numerical censuses.” A
mere conjunction must never be described as agreement or identification.

### 2. Blocking — the `A3` mirror theorem is one-sided

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:235-244`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:127-134`.

`a3_frame_joins_are_braid_mirrors` proves only that every one of the six indexed joins is parallel to
*some* indexed braid mirror. It proves neither the reverse inclusion nor distinctness/cardinality of
the two projective sets. Its type is compatible with all six joins mapping to one mirror. The report
instead claims equality with all six essentialized braid mirrors.

**Impact:** the formal statement does not establish that the computed join arrangement is the `A3`
arrangement whose spectrum is later advertised.

**Required fix:** strengthen the type with reverse coverage and projective cardinality six, following
the two-sided shape already used by `h3_joins_are_root_directions`, or narrow every claim to the
one-sided statement actually proved.

### 3. Blocking — full-trust and complete-report labels are premature

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:3-10,82-96,186-216,243-266`.

The report calls the source-level report complete and assigns every subclaim “full-trust Lean,” but
it also correctly records that no import-only gate, current elaboration, pinned validated commit, or
live axiom transcript exists. `lean/TRUST.md` additionally says Clebsch has no per-paper manifest.
Those are release-policy blockers, not cosmetic omissions.

The claim at report lines 207-208 that the sources already contain probes “for every terminal” is
false. `ReflectionArrangements.lean:275-285` omits probes for at least `tau5_relation`,
`h3_projectivity_det`, `h3_fivefold_index_vec`, `a3_frame_joins_are_braid_mirrors`, and all five S7
terminals. The downstream module probes `h3_decoder_strata`, but that does not cover the omitted
terminals individually as the checklist requires.

**Impact:** the ledger cannot yet confer a Lean-formalized label, and a closing agent following the
current prose could mistake expected evidence for established evidence.

**Required fix:** call these routes “candidate full-trust Lean” until the adequacy fixes, exact gate,
guarded/gate validation, pinned commit, and complete terminal-by-terminal axiom audit land. Add all
missing probes or provide a deterministic audit module/command that prints every claimed terminal.
Record the actual output, not the expected standard axiom set.

### 4. Blocking — `H3`, `A3`, characteristic-polynomial, and conic-code semantics exceed the types

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:3-9,52-83,172-180,193-221,259-273`;
C222 report `notes/2026-07-16-c222-lean-a3-h3-closure.md:92-104,127-152`.

Lean checks explicit coordinate tables and arithmetic. It does not currently prove or cite, in this
module, that the fifteen displayed directions are the projectivized `H3` root arrangement, that the
four-point construction is the essentialized `A3` reflection arrangement, or that the displayed
polynomials are the characteristic polynomials of those arrangements. The S7 theorems are bare
integer polynomial identities; no arrangement characteristic polynomial, intersection lattice,
Möbius function, complement, code, or conic object occurs in their types.

The docstring “Characteristic five is lattice-faithful” at lines 216-217 is especially too strong:
the theorem proves a multiplicity spectrum only, not an intersection-lattice isomorphism. Likewise
the S1 report's “There is tau in F_q” is not quantified over a general field: Lean proves only the
chosen values in `ZMod 11` and `ZMod 5`, plus the `ZMod 2` boundary.

**Impact:** the report blurs full-trust coordinate/arithmetic facts with conceptual identifications
and classical arrangement consequences. Referees could reasonably read the names and prose as
formalizing more than Lean says.

**Required fix:** split the ledger routes. Keep the explicit coordinate and integer identities as
Lean facts; either formalize the semantic bridges, or state the exact named classical input with a
proper public citation and classify the result as a combination. Rename/re-docstring S7 declarations
as ledger-polynomial or arithmetic factorizations unless their connection to arrangement
characteristic polynomials is itself formalized. Replace “lattice-faithful” by the exact spectrum
claim. Restrict S1 to the three fields actually present.

### 5. Major — the projectivity API leaves crucial semantics implicit

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:114-150`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:106-125,248-251`.

`h3_projectivity_det` proves only `det T = 3`; no terminal states `3 != 0`, packages `T` as a linear
equivalence/projective bijection, or proves that `h3DualProjectivity` is the inverse-transpose action.
The coordinate mapping and multiplicity equalities happen to check the required rows directly, but
the prose calls both functions projectivities and uses bijective transport in the informal trust
argument. The checklist even paraphrases the type as “det = 3 != 0.”

**Impact:** the finite row equalities are safe, but global transport of strata through a projective
bijection is not presently an exposed Lean theorem. This contributes directly to finding 1.

**Required fix:** expose compact theorems for nonzero determinant, inverse/dual compatibility, and
the induced bijection on normalized projective representatives, or avoid using global projectivity
transport as a Lean-backed step. State explicitly whether line normals are transformed by
`(T^{-1})^T` and account for projective rescaling.

### 6. Major — referee-facing documentation is incomplete and contains strength/status prose

**Location:** throughout both modules, especially
`ReflectionArrangements.lean:3-9,43-50,70-83,114-134,152-170,188-221,239-273` and
`ReflectionArrangementDecoding.lean:4-18`.

Most intended public definitions and many claimed public theorems have no self-contained docstring.
Examples include `dot`, `tau11_relation`, both finite point-set constructors, the determinant and
point-map theorems, multiplicity loci, the exact fivefold theorem, `tau5_relation`, the `A3` spectrum,
and every S7 theorem. The module header relies on “the Clebsch paper,” “existing” theorems, and
implementation chronology rather than stating the exact mathematical scope and trust boundary.
The decoder source uses the vague phrase “paper-facing level.” The `projectiveVec5` and fivefold-index
docstrings call chosen enumerations “canonical” without stating the normalization/uniqueness
property. The tau judgment log also asserts, without a theorem or cited route, that the conjugate root
gives a projectively equivalent arrangement.

**Impact:** even corrected theorem types would not meet the repository's referee-facing artifact
standard on a cold read.

**Required fix:** give every ledger terminal and non-obvious public definition a precise docstring;
replace workflow/paper-status phrasing by ordinary mathematics; describe the first-nonzero-coordinate
normalization; and either prove/cite or remove every equivalence/strength statement. The module header
should enumerate the finite fields, coordinate conventions, terminal results, computation method,
and residual conceptual inputs.

### 7. Major — the task checklist records checks that have not been met

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:243-281`.

The checked statement-adequacy item misses findings 1, 2, 4, and 5. The checked prose/name item misses
finding 6. The checked finite-computation evidence item names only an internal task-level
“computer-assisted arrangement enumeration,” not the exact durable replay artifact, command,
version/hash, coverage, or result. The checked adequacy-appendix item supplies summaries and
abbreviated terminal names, not verbatim theorem statements and load-bearing definitions or a
deterministic extraction. The proposed ledger uses ellipses rather than fully qualified declaration
names, despite the local requirement.

**Impact:** reviewer agents cannot safely treat the checklist as evidence, and the report is not yet
sufficient for archival or C320 reconciliation.

**Required fix:** reopen the affected boxes, record this review and each remediation, use fully
qualified names, identify the exact independent replay or explicitly say none exists, and include a
deterministic adequacy extraction plan/output. After all source and report changes, the implementer
must stop and ask the user to launch a post-fix review.

## Exact claim inventory

### Safe to claim from the current source, conditional on later elaboration and axiom audit

- The chosen elements `8 : ZMod 11` and `3 : ZMod 5` satisfy `tau^2 = tau + 1`; in `ZMod 2`,
  `-1 = 1` and no element satisfies that equation.
- The six explicitly listed `ZMod 11` vectors have every pairwise-distinct triple determinant
  nonzero.
- The fifteen explicitly indexed joins and fifteen explicitly indexed root-direction vectors give
  two projective sets of cardinality fifteen with two-sided `SameDirection` coverage.
- The displayed matrix has determinant `3 : ZMod 11`; the six point rows and fifteen dual-line rows
  satisfy the stated `SameDirection` checks.
- For every one of the 133 fixed normalized representatives, the explicit mirror-incidence count
  equals `rawPointIndex` of its displayed linear image.
- The explicit `H3`-labelled and `A3`-labelled coordinate tables have the stated finite multiplicity
  spectra, and the six listed fivefold indices give exactly the multiplicity-five locus.
- The five S7 integer equalities and polynomial factorizations hold as arithmetic identities.
- The current decoder terminal proves the conjunction of its eight cardinality equalities.

These are source-level claims only until the current build and axiom evidence is recorded.

### Blocked from a Lean-formalized label

- A general-field golden-ratio parameter theorem.
- Identification of the coordinate tables with the `H3` and `A3` reflection arrangements without a
  formal semantic bridge or an explicit conceptual/citation route.
- Equality of the `A3` join and braid-mirror projective sets from the current one-sided theorem.
- Lattice faithfulness in characteristic five.
- Arrangement characteristic-polynomial, complement-code, or conic conclusions from the current
  bare arithmetic identities alone.
- A projective bijection/transport theorem for `h3Projectivity` and its dual action.
- Any geometric equivalence between `H3` multiplicity strata and decoder ambiguity strata, including
  the factor-ten affine-ray correspondence and the one-leader `90+6` decomposition.
- Every full-trust release label before the C222 gate, current elaboration, exhaustive axiom audit,
  pinned commit, Clebsch trust-manifest row, and post-fix independent `GO` exist.

## Checklist disposition and policy guards

- **Statement adequacy:** fail; findings 1, 2, 4, and 5.
- **Quantifiers, hypotheses, and vacuity:** fail for the one-sided `A3` coverage and overgeneralized
  S1 prose; no empty-domain or baked-conclusion defect was found in the principal finite checks.
- **Comments, names, and self-containment:** fail; finding 6. No internal task ID or novelty claim was
  found in the two C222 Lean sources.
- **Trust route:** provisional; direct source uses kernel tactics and the project-owned closure scan
  is clean, but the gate and live axiom evidence are absent.
- **Gate coverage:** fail; no C222 gate exists.
- **Compactness:** pass at source shape. The two modules are small and contain no generated
  certificate tree. Runtime/profile feasibility remains unmeasured in this review because no build
  was authorized.
- **Report and judgment log:** fail; finding 7. The representation, kernel-`decide`, sharding, and
  pointwise-bridge choices are useful, but their claim impact is overstated and the conjugate-root
  assertion lacks a route.
- **Archival readiness:** fail. C222 remains active.

Add these guards to the C222 repair checklist and copy the applicable ones into later Clebsch task
documents:

1. A theorem advertised as identifying two structures must contain a map and a relation or
   equivalence in its type; conjunctions of census numbers are labelled only as joint censuses.
2. Every finite-set equality claim must audit both directions and cardinality/distinctness; an
   existential image statement alone is not equality.
3. Every semantic noun in a declaration or docstring (`H3`, `A3`, characteristic polynomial,
   projectivity, decoder stratum, lattice-faithful) must be present in the formal type or assigned an
   explicit conceptual/citation route in the ledger.
4. Every claimed terminal receives an explicit fully qualified name, gate import, and individual
   axiom-audit entry; never infer coverage from a neighboring terminal.
5. Strength/status words in source (`agree`, `complete`, `canonical`, `paper-facing`) require a
   matching theorem or are replaced by exact neutral language.
6. A checked report box must point to durable evidence. Expected output, internal-task provenance,
   or an abbreviated theorem summary does not satisfy it.

## Final disposition

**READY FOR FIXES.** The compact coordinate work appears promising and several finite statements are
substantive, but C222 does not yet prove the advertised decoder connection or full `A3` identification,
and its prose/trust report currently overstates the types. After the implementing agent fixes or
narrows every finding, completes the gate and evidence, and updates the judgment log and C320 delta,
it must stop and ask the user to launch Codex for post-fix review. This review does not authorize
archival.

## Post-fix review — 2026-07-20

**Disposition:** **NO-GO — READY FOR FIXES**. The remediation agent stopped before producing a
coherent committed bundle. Only committed evidence is eligible for a final disposition; the current
dirty source and report are provisional.

### What was inspected and replayed

This user-launched post-fix review reread the complete current C222 report, both C222 Lean modules,
the claimed adequacy extraction, the proposed C320 ledger delta, and the initial review above. It
inspected scoped Git status, current and committed hashes, last commits by path, the exact
project-owned import closure, and the gate directory. It replayed no Lean elaboration or Lake build:
there is no C222 gate to validate, the purported repairs are uncommitted, and the report itself says
the shared-lock validation and axiom audit have not occurred. It did replay the bounded source scan
over the 33-file project-owned closure; no `sorry`, `native_decide`, local `axiom`, or `opaque`
declaration was found. `git diff --check` found no whitespace error. Neither check establishes
elaboration or an axiom closure.

No obvious end-of-file truncation was found in the dirty coordinate module or report, but the
remediation is incomplete in content and Git state.

### PF1 — blocking: the remediation is not a committed atomic artifact

**Locations:** `lean/RelativeConicArcs/ReflectionArrangements.lean` (dirty),
`notes/2026-07-16-c222-lean-a3-h3-closure.md` (dirty), and the unchanged
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean`.

Scoped status shows 91 insertions/23 deletions in `ReflectionArrangements.lean` and 289
insertions/123 deletions in the C222 report, neither committed. The last committed versions remain:

- `ReflectionArrangements.lean`: commit `462905ff`, sha256
  `9154964eb896470a61d222798cff654ad41343f3248b256939a08566d2d2ef82`;
- `ReflectionArrangementDecoding.lean`: commit `97bd8fb2`, sha256
  `11c6bf272e233fd137bcbeb2ae4d62231983ab91c791fe0bba886026624a519b`;
- C222 report: commit `a9925548`.

The dirty coordinate module instead has sha256
`6d1fa115246c0ddfcffc0a69e2b888a6755056a2eab5d0e8f18f316931d130f1` and 16165 bytes. The dirty
report still records the old 11202-byte committed hash at
`notes/2026-07-16-c222-lean-a3-h3-closure.md:265-272`, while its status paragraph at lines 5-15 says
the task modules are committed and describes the provisional docstring work as the completed record.
Its checklist at lines 320-322 concedes that hashes must be recomputed after those edits land.

**Impact:** there is no immutable post-fix object to review, no pinned repair commit, and the report
does not identify its actual working source. A final `GO` is impossible irrespective of mathematical
quality.

**Required fix:** finish all intended source/report/gate edits, recompute hashes and byte counts,
validate the exact final files, and commit the complete task-owned bundle. Do not claim committed or
final evidence while a described file is dirty. Then have the user launch another post-fix review.

### PF2 — blocking: initial finding 1 remains verbatim in the actual decoder source

**Location:** `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean:7-18` versus C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:162-176,351-354`.

The report says the decoder docstring was narrowed to a joint census. It was not. The committed and
working decoder module still says the two strata “agree at the paper-facing level” and that
`h3_dual_projectivity_maps_mirrors` supplies their “exact geometric identification.” Its theorem
remains only the same conjunction of eight cardinality equalities. The module header also retains
the strength-bearing phrase “existing complete nearest-codeword ambiguity theorem.”

**Impact:** the referee-facing source still asserts the exact semantic conclusion that the theorem
does not prove. The report's remediation narrative is factually false.

**Required fix:** either implement the point/ray and leader-count equivalence theorem described in
the initial review, or actually narrow the module header and theorem docstring to a joint numerical
census with no identification language. Commit that change and update its hash.

### PF3 — blocking: objective 3/4 exits were narrowed without satisfying the task's fallback rule

**Locations:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:53-57,147-176,193-221,240-263,383-384`;
`lean/RelativeConicArcs/ReflectionArrangements.lean:282-290`.

The provisional report now accurately admits that the `A3` theorem is one-sided and the decoder
terminal is census-only. That is an honest improvement, but it does not complete the stated
objectives. The success criterion requires every omitted objective claim to be retained as
computer-assisted with a documented compactness obstruction. Instead the report says no compactness
stop occurred and calls both missing results “deferred build-gated” strengthenings. No attempted
theorem, first obstruction, measurement, projected certificate shape, exact replay artifact, or
completed external trust route is supplied. “Build-gated” is also inaccurate when new definitions
and proofs have not been written.

**Impact:** full `A3` arrangement equality and the decoder-stratum correspondence have neither a Lean
route nor the task's required completed fallback route. The report cannot call its subclaim ledger or
judgment record complete.

**Required fix:** either land the compact two-sided `A3` theorem and genuine decoder bridge, or
record the exact external conceptual/replay route and the required measured compactness stop for
each omitted objective. If the intended task scope is being reduced without such a stop, obtain and
record an explicit scope decision rather than silently treating deferral as completion.

### PF4 — major: projectivity/inverse-dual transport remains implicit and source prose still asserts it

**Locations:** `lean/RelativeConicArcs/ReflectionArrangements.lean:138-176`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:120-145,234-235,259-262`.

The provisional report now honestly says that only `det T = 3` and row-by-row identities are exposed.
The source still names the map `h3Projectivity`, describes `h3DualProjectivity` as “the displayed
inverse of `T`,” and has no theorem for nonzero determinant, inverse-transpose compatibility, or a
bijection on normalized projective representatives. The report itself lists that API as an optional
deferred strengthening even though its original objective and decoder-transport explanation use the
global projectivity semantics.

**Impact:** the row identities are safe candidate Lean facts, but projective transport is not a
paper-facing terminal and cannot support the decoder identification.

**Required fix:** expose and audit the compact nonzero-determinant, inverse-dual, and induced
projective-bijection theorems, or remove every claim that uses global transport and phrase the dual
definition as an explicit coordinate map rather than an established inverse action.

### PF5 — major: the provisional documentation pass still fails the referee-facing standard

**Locations:** `lean/RelativeConicArcs/ReflectionArrangements.lean:11-24,42-44,91-92,146-147,
314-330`; `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean:4-18`.

In addition to PF2 and PF4:

- `SameDirection` is called projective equality without stating its zero-vector degeneracy: as
  defined, `SameDirection 0 0` holds although zero is not a projective point or line.
- `h3Joins` is described as a set of “normalized directions,” but it is the raw image of cross
  products and performs no normalization.
- the Orlik–Terao citation gives authors, title, year, and a broad section/table description in the
  internal report, but the Lean header has no stable identifier/version and no pinpoint theorem,
  lemma, or page as required by the Lean citation standard;
- the unchanged decoder source contains vague workflow/strength language (`existing`, `complete`,
  `paper-facing`) and the false agreement claim.

The dirty documentation is therefore not ready even if it later elaborates.

**Required fix:** state degeneracy and normalization conventions exactly; correct the raw-join
description; provide a standards-compliant public citation pinpoint for each classical semantic
input or remove the source-level attribution-dependent claim; and complete the decoder prose repair.

### PF6 — blocking: gate, validation, axiom evidence, and trust pin are all absent

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:227-263,305-314`.

No module under `lean/RelativeConicArcs/Gates/` imports either C222 module. The report explicitly says
that focused elaboration, exact-target gate confirmation, terminal-by-terminal `#print axioms`
output, a Clebsch manifest row, and a pinned validated commit are pending. The added axiom probes in
the dirty coordinate source have not been run. The source-only closure scan is not a substitute.

**Impact:** no claim in C222 currently satisfies the repository's full-trust release policy.

**Required fix:** after committing a coherent source, create the import-only C222 gate, run the
guarded/focused and exact-target validations through the authorized build owner, record every
terminal's actual axiom output, pin the validated commit and hashes, and supply the C320/manifest
delta. Review the gate's complete imported terminal surface, not just its existence.

### PF7 — major: appendix and checklist evidence remain incomplete

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:290-342,386-451`.

The adequacy section copies theorem signatures, but its “load-bearing definitions” are only a list of
names. It gives neither their verbatim definitions nor a deterministic extraction artifact/command,
so checklist lines 328-330 are over-ticked. Checklist lines 315-319 say no external replay artifact
exists because the implemented `decide` checks use no generator, while the same report leaves the
full `A3` and decoder-identification objectives computer-assisted without naming their exact replay
evidence. The hash box is checked despite the acknowledged stale hash. The statement, route, prose,
gate, trust, and review boxes correctly remain open; those open boxes themselves preclude `GO`.

**Required fix:** include or deterministically extract the actual load-bearing definitions; separate
the in-kernel finite checks from every externally retained objective and name the latter's durable
replay/citation evidence; recompute identity evidence only after final edits; and leave no box checked
without the referenced artifact.

### Prior-finding disposition

- **Initial F1 (decoder agreement): unresolved** — PF2.
- **Initial F2 (`A3` equality): prose provisionally narrowed in the dirty coordinate source, but the
  objective/fallback remains unresolved** — PF3.
- **Initial F3 (premature trust): wording provisionally improved, evidence unresolved** — PF1/PF6.
- **Initial F4 (semantics exceed types): partially narrowed; classical citation and completed route
  remain inadequate** — PF3/PF5.
- **Initial F5 (projectivity API): unresolved** — PF4.
- **Initial F6 (documentation): partially repaired in one dirty module, unresolved overall** — PF2/PF5.
- **Initial F7 (checklist/report): unresolved** — PF1/PF3/PF7.

### Final post-fix disposition

**NO-GO — READY FOR FIXES.** The artifact is not a coherent committed bundle, the decoder overclaim
survives verbatim, two objective exits have no completed trust route, and all release evidence is
still absent. C222 must remain active. The implementer should complete the minimal fixes above,
commit them atomically, stop, and ask the user to launch another Codex post-fix review. This review
does not authorize archival or task completion.
