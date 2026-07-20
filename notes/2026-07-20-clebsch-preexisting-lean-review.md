# Cold review of the pre-existing Clebsch Lean inputs

**Date:** 2026-07-20

**Reviewer:** user-launched independent Codex review

**Initial disposition:** **NO-GO** for treating the complete pre-existing Clebsch gateway closure as
a full-trust Lean foundation for the replacement-spine claims.  A bounded coordinate-level q=11
subclosure is safe to consume at full Lean trust.  The matching, fusion, and three arithmetic-phase
interfaces prove facts about displayed data but do not prove that those data have the advertised
geometric, group-theoretic, association-scheme, or exhaustive-classification semantics.

This document records the pre-fix review snapshot.  It is intentionally preserved before any source
repair.  A later section may record non-breaking repairs and remaining blockers, but may not erase or
retroactively weaken these findings.

## Scope and method

The campaign plan names the following pre-existing inputs for the new Clebsch formalization slices:

- the generic gateway and its q=11 extension, conic, matching, and fusion leaves;
- the conic/deep-hole, Coxeter-phase, and scalar-`A5` Fourier-phase interfaces;
- the four corresponding import-only gates;
- the q=11 semantic support actually used by those leaves.

The direct reviewed Lean inventory is:

| role | module |
|:---|:---|
| generic seams | `RelativeConicArcs.ClebschGateway` |
| q=11 coordinate extension | `RelativeConicArcs.ClebschGatewayQ11Extension` |
| q=11 conic termination | `RelativeConicArcs.ClebschGatewayQ11Conic` |
| displayed matching system | `RelativeConicArcs.ClebschGatewayQ11Matching` |
| displayed fusion/Fourier data | `RelativeConicArcs.ClebschGatewayQ11Fusion` |
| external deep-hole profile interface | `RelativeConicArcs.ClebschGatewayConicDeepHole` |
| external Coxeter profile interface | `RelativeConicArcs.ClebschGatewayCoxeterPhase` |
| external scalar-`A5` phase interface | `RelativeConicArcs.ClebschGatewayA5FourierPhase` |
| aggregate and phase gates | the four `RelativeConicArcs.Gates.ClebschGateway*` modules |

The load-bearing project-owned support inspected at declaration/type level is
`RelativeConicArcs.CodingBridge`, `RelativeConicArcs.Certificate`,
`RelativeConicArcs.Examples`, `RelativeConicArcs.ExampleChecks.Q11`,
`RelativeConicArcs.Q11Residual`, and `RelativeConicArcs.Q11Coding`.  In particular the review
followed the exact chain from the six displayed q=11 columns through `q11_check`, `check_sound`, the
standard-conic parameterization, and the typed parity-check-code statements.  Generic imports used
only to implement projective geometry, finite sums, matrices, and the unrelated residual game were
not re-reviewed as Clebsch-specific claims.

The following were explicitly excluded:

- newly landed F1/F2 modules (`ClebschMomentTrade` and `ClebschConicMatchingQuotient`);
- active or queued F3--F9 modules, except for noting a live downstream reference when assessing
  whether an unsafe API can presently be renamed;
- `RelativeConicArcs.ReflectionArrangementDecoding` and all active C222 work;
- every Q25 path;
- certificate regeneration, broad builds, and replay execution.

This was a source/type/prose review.  Existing build and axiom evidence is reported as existing
evidence, not replayed evidence.  No conclusion below relies merely on a task report's verdict.

## Executive trust verdict

The closure is mixed, not uniformly full-trust:

1. **Safe at full Lean trust, with a coordinate-correspondence qualification:** the generic
   arc/deep-transform and parity-check-code bridges; the six displayed q=11 points' exact
   standard-conic deep transform; the twelve displayed one-column `[7,4,4]` kernels; and the empty
   second transform of the displayed standard conic.
2. **Safe only as abstract/combinatorial statements:** the conditional two-sheet-character lemma;
   literal matching-table properties; literal fusion-size arithmetic; the four displayed exchanged
   indices; and the square of the displayed `4 x 4` integer matrix.
3. **Not safe as Lean proofs of advertised geometry:** identification of the 22 table rows with the
   geometric parent arcs, equivariance, `PSL_2(11)` sheet orbits, recovery of an actual Clebsch
   parent, identification of fusion rows with relation orbits, and identification of the displayed
   matrix with the scheme Fourier transform.
4. **Not safe as Lean proofs of any external census/classification:** the finite-field deep-hole
   profiles, decoration counts, rank-four exclusion, scalar-`A5` phase list, scheme ranks,
   eigenmatrix/fusion exhaustions, or their completeness.  Lean presently proves only computations
   about definitions containing the expected answers.

Consequently a downstream task may import the modules, but it must not infer a stronger trust tier
from the module name, a `certified*` declaration name, or an aggregate gate.  The release ledger must
split every literal-data theorem from the unformalized semantic identification.

## Prioritized findings

### F1 — Blocking: `certified*` phase APIs have no semantic checker theorem

**Locations and declarations**

- `lean/RelativeConicArcs/ClebschGatewayConicDeepHole.lean:26-66`:
  `CertifiedProfile`, `certifiedProfiles`, and `certifiedFullConicField`.
- `lean/RelativeConicArcs/ClebschGatewayCoxeterPhase.lean:88-139`:
  `CertifiedPhaseProfile`, `certifiedPhaseProfile`, `certifiedDecorationIndex`,
  `certifiedDecorationCounts`, `rankFourGateProfiles`, and `rankFourGate_closed`.
- `lean/RelativeConicArcs/ClebschGatewayA5FourierPhase.lean:38-126`:
  `CertifiedPhaseProfile`, `certifiedPhaseProfile`, `certifiedRank_eq_burnside`,
  `certifiedConicOrbitStabilizer`, `certifiedDeepProjectiveCount`, and
  `certifiedSmallFusionRanks`.

**Exact defect.**  Each theorem reduces against a table or list defined in the same module.  There is
no Lean predicate defining the intended finite geometry, no accepted certificate datum, no checker
soundness theorem, and no coverage theorem connecting the finite list to all objects in the stated
classification domain.  For example, `certifiedFullConicField` proves that a Boolean field of the
locally defined four-row list is true exactly at 11; it does not prove that the external census is
complete or that its rows represent semilinear classes.  Likewise, `certifiedSmallFusionRanks` is
an equality between `fusionRanks` and the lists used to define it; it is not a
Bannai--Muzychuk exhaustion.  `rankFourGate_closed` tests five supplied records and does not prove
that they exhaust the irreducible rank-four candidates.

**Impact.**  These interfaces cannot support full-trust Lean labels for conic-phase classification,
decoration counts, scheme ranks, eigenmatrices, orthogonal fusions, or fusion exhaustiveness.  This
is immediately relevant to the Fourier slice: the active downstream source currently reads
`A5FourierPhase.certifiedPhaseProfile .q11` at
`lean/RelativeConicArcs/ClebschSchemeFourier.lean:92`.  That consumer is outside this review and was
not edited, but it must not inherit certified-geometry trust from the name.

**Required fix.**  Either:

- introduce mathematical predicates, untrusted data, sound checkers, and explicit completeness
  theorems for the advertised domains; or
- rename/restate the interfaces as recorded external-profile data and keep every geometric claim in
  the exact replay/certificate tier.

Because a live downstream module already consumes the API, renaming is not a safe isolated repair.
Until coordinated repair occurs, this is a release blocker and the downstream ledger must classify
the imported values as external inputs, not Lean-certified geometry.

### F2 — Blocking: matching recovery recovers a row index, not a geometric parent

**Locations and declarations**

- `lean/RelativeConicArcs/ClebschGatewayQ11Matching.lean:14-20` defines
  `Parent := Fin 22`, `ChildPoint := Fin 12`, and `Matching := ChildPoint -> ChildPoint`.
- `:24-46` defines the 22 mate rows literally.
- `:95-107` defines a `DecoratedTransform Parent PUnit Matching` and proves
  `decorated_child_recovers_parent` from table injectivity.
- `lean/RelativeConicArcs/ClebschGateway.lean:290-305` defines generic decorated recovery by bundling
  injectivity as the field `faithful`.

**Exact defect.**  The concrete child is `PUnit`; the parent is a finite row label.  No Lean object
represents a six-arc parent, no construction derives its obstruction matching, and no theorem links
the 22 rows to a complete geometric parent locus.  The generic recovery theorem is a correct but
tautological projection of the `faithful` field.  The concrete theorem therefore proves only that a
displayed matching determines its table row.

**Impact.**  A downstream theorem may use this result to recover `Fin 22`; it may not say Lean has
proved recovery of the Clebsch parent, presentation independence, equivariance, or completeness of
the 22-parent locus.  The planned depth--Fourier--parent bridge is blocked at full trust if it ends
only in this theorem.

**Required fix.**  Add a semantic parent type (or a precise coordinate parent subtype), a checked
map from each parent to its obstruction matching, an injectivity theorem for that map, and the
needed completeness/equivariance statement.  This is new theorem/certificate architecture and is
not a prose-only repair.

### F3 — Blocking: fusion and Fourier semantics are frozen, not checked

**Locations and declarations**

- `lean/RelativeConicArcs/ClebschGatewayQ11Fusion.lean:22-42` defines the fusion map and fine
  valencies.
- `:49-62` defines `commonJ` and checks four images.
- `:64-76` defines `oddFourier` and checks `oddFourier * oddFourier = 1331 I`.

**Exact defect.**  Lean proves exact arithmetic about the displayed arrays.  It does not define the
underlying affine relations, prove that the fine valencies are their cardinalities, prove that
`commonJ` is induced by the geometric involution on those relations, or derive the matrix from a
Fourier/character sum.  The source contains no checker theorem connecting the external relation
data to these meanings.

**Impact.**  `oddFourier_square` and the four index exchanges are full-trust literal matrix/permutation
facts.  The statements “rank-eight association-scheme fusion,” “four `J`-odd relation pairs,” and
“signed Fourier block” remain external exact-certificate claims.  Aggregate imports do not upgrade
them.

**Required fix.**  Downstream tasks must either build their own semantic relation/checker layer and
derive these arrays, or retain a decomposed trust row: Lean arithmetic on displayed data plus an
external certificate identifying those data with the scheme.  Do not call the combined claim
full-trust Lean without the missing bridge.

### F4 — Blocking for referee-facing release: Lean prose points backward to private workflow records

**Locations.**  Internal task identifiers and workflow ownership/status language occur throughout
the module headers and docstrings, including:

- `ClebschGateway.lean:8,342`;
- `ClebschGatewayQ11Extension.lean:5`;
- `ClebschGatewayQ11Conic.lean:5,9`;
- `ClebschGatewayQ11Matching.lean:4,6-8,22`;
- `ClebschGatewayQ11Fusion.lean:5,7,22,35,64`;
- `ClebschGatewayConicDeepHole.lean:4,8`;
- `ClebschGatewayCoxeterPhase.lean:4,8`;
- `ClebschGatewayA5FourierPhase.lean:4,6`;
- all four `Gates/ClebschGateway*.lean` headers, including `crowns-owned` at
  `Gates/ClebschGateway.lean:11`.

**Impact.**  A referee cannot resolve these identifiers from the scholarly artifact.  They violate
the required one-way reference direction and make trust assertions depend on adjacent internal
reports/certificates that are neither named as enduring artifacts nor consumed by Lean.

**Required fix.**  Replace each reference with the mathematical object, exact formal limitation,
and checking method.  An external certificate may be mentioned only through a stable distributed
artifact with independent semantics; internal task/report identifiers are never authority.

### F5 — Major: the q=11 coordinate theorems do not identify the displayed parent as Clebsch

**Locations and declarations**

- `RelativeConicArcs.Examples.q11Witness` is the six-row coordinate list in
  `lean/RelativeConicArcs/Examples.lean:46-53`.
- `RelativeConicArcs.Examples.q11_check` at
  `lean/RelativeConicArcs/ExampleChecks/Q11.lean:12` proves the generic certificate accepts it.
- `Q11Coding.projective_distanceThreeDirections_eq_standardConic` at
  `lean/RelativeConicArcs/Q11Coding.lean:76-105` derives the exact conic locus.
- `Q11Extension.parent_deepTransform_eq_standardConic` at
  `lean/RelativeConicArcs/ClebschGatewayQ11Extension.lean:67-71` transports that result.

**Exact boundary.**  This is a sound full-trust proof for the displayed coordinate set.  The generic
checker soundness theorem at `Certificate.lean:347-350` connects Boolean acceptance to
`CompleteOutside`; the conic inclusion in the opposite direction is proved from singleton
extension checks.  But this closure does not prove that the displayed six-set is projectively
equivalent to a separately defined Clebsch hexagon, has stabilizer `A5`, or represents a complete
classification class.

**Impact and required handling.**  It is safe if the paper defines its parent by these exact
coordinates or supplies a separately verified coordinate/projective-equivalence lemma.  It is not
alone an adequacy proof for every theorem phrased about “the Clebsch parent.”  The final ledger must
name the correspondence route.

### F6 — Major: gate prose overstates what importing establishes

**Locations.**  The phase gate headers at
`Gates/ClebschGatewayConicDeepHole.lean:4-7`,
`Gates/ClebschGatewayCoxeterPhase.lean:4-7`, and
`Gates/ClebschGatewayA5FourierPhase.lean:4-7` describe certified classification, conic-phase, and
fusion interfaces.  The aggregate header at `Gates/ClebschGateway.lean:9-14` calls the closure a
stable paper-facing exit.

**Exact defect and impact.**  Import completeness is not semantic completeness.  These gates import
the named modules, but no gate theorem reconciles their mixed trust boundary, no gate imports an
enduring manifest, and no gate-level axiom output distinguishes literal-table facts from external
identifications.  A green aggregate confirms elaboration only.

**Required fix.**  Rewrite gate prose to state exactly what is kernel-checked and what remains an
external semantic identification.  The final replacement-spine gate and trust ledger must not
derive trust labels from these gates.

### F7 — Moderate: strength-bearing prose is unsupported by theorem domains

Examples include “complete first higher-rank point-count gate” for a five-row list
(`ClebschGatewayCoxeterPhase.lean:126`), “exact Bannai--Muzychuk exhaustions” for an equality of
literal lists (`ClebschGatewayA5FourierPhase.lean:122`), “exact orbit classifier” where the orbit
equivalence is already a structure field (`ClebschGateway.lean:360-372`), and “orientation sheets”
for the index cut `p < 11` (`ClebschGatewayQ11Matching.lean:64-89`).

These phrases must either be backed by explicit domain/coverage/equivariance theorems or weakened
to describe the literal finite objects actually checked.

## Claim-by-claim trust inventory

| consumed terminal or family | exact Lean content | admissible trust label | downstream restriction |
|:---|:---|:---|:---|
| `oneColumnArcExtension_iff_mem_deepTransform` | equivalence between a fresh arc extension and membership in `distanceThreeDirections`, assuming an arc | full-trust Lean | none beyond its explicit projective-plane hypotheses |
| `codimThreeMDSColumns_of_arc`, `oneColumnMDS_of_mem_deepTransform` | representative columns of an injectively indexed arc satisfy a transparent rank-three parity-check package | full-trust Lean | “MDS” means the explicit `CodimThreeMDSColumns` predicate; code duality/GRS claims need separate bridges |
| `rawArc_complete_empty` | raw determinant arc plus exhaustive canonical coverage implies ordinary completeness | full-trust Lean | only as strong as the checked raw predicates |
| q=11 transform and `[7,4,4]` terminals | exact results for the displayed six-column witness and twelve standard-conic points | full-trust Lean | identify the paper's Clebsch object with these coordinates separately |
| `standardConic_secondTransform_empty` | all 133 canonical projective points are covered by the displayed conic or its secants | full-trust Lean | q=11 standard conic only |
| `twoSheetCharacter_eq_of_ker_eq`, `s5_quotientCharacter_inference` | equality of two `Fin 2` permutation characters under explicit kernel/parity hypotheses | full-trust conditional Lean | proves no concrete action satisfies the hypotheses |
| `DecoratedTransform.recovers_parent` | injectivity recovery from the structure's `faithful` field | full-trust conditional/structural Lean | never evidence that a concrete geometric transform is faithful |
| matching fixed-point-free/involutive/injective/cardinality/edge-unique facts | exhaustive reduction on a literal `22 x 12` mate table | full-trust combinatorics on displayed data | geometric provenance, parent completeness, group action, and equivariance remain external |
| `decorated_child_recovers_parent` | a matching row determines its `Fin 22` row index | full-trust literal-data Lean | not a theorem about six-arcs or projective parents |
| fusion fibers and size sums | arithmetic on literal maps and valency arrays | full-trust literal-data Lean | not relation-orbit fusion without external identification |
| `commonJ_odd_pairs` | four values of a literal permutation on `Fin 16` | full-trust literal-data Lean | not induced geometric action without external identification |
| `oddFourier_square` | square of a displayed integer matrix | full-trust literal-data Lean | not Fourier self-duality of a scheme without a derivation/checker |
| `fieldOrder_le_fifteen` | elementary implication from the explicit covering inequality | full-trust Lean | the geometric covering inequality is a hypothesis, not proved here |
| `certifiedProfiles*` | equalities and a Boolean property of a literal finite table | full-trust only about the table | external exact replay/certificate for geometry and completeness |
| Coxeter identities and `conicPhase_length/distance` | arithmetic from the locally defined formulas for the three type tags | full-trust arithmetic Lean | complement-code formulas are definitions here, not derived from arrangements |
| Coxeter `certified*` and `rankFourGate_closed` | arithmetic/Boolean facts about supplied profiles | full-trust only about supplied data | all geometry, completeness, and higher-rank coverage external |
| scalar-`A5` `certified*` and fusion-rank terminals | arithmetic equalities about supplied profiles/lists | full-trust only about supplied data | Burnside/orbit/eigenmatrix/fusion semantics and exhaustiveness external |
| `OrbitClassifier.fuse` | constructs a classifier assuming the desired fused orbit equivalence | full-trust conditional Lean | supplies no concrete group closure or orbit proof |

## Safe-to-import versus blocked

| module | disposition | safe use |
|:---|:---|:---|
| `ClebschGateway` | **GO with qualifications** | generic lemmas exactly as typed; do not treat bundled hypotheses as proved instances |
| `ClebschGatewayQ11Extension` | **GO with coordinate qualification** | exact transform and `[7,4,4]` statements for the displayed witness |
| `ClebschGatewayQ11Conic` | **GO** | q=11 standard-conic completeness and empty second transform |
| `ClebschGatewayQ11Matching` | **GO only as literal combinatorics** | perfect-matching and one-factorization properties of the displayed table; row-index recovery |
| `ClebschGatewayQ11Fusion` | **GO only as literal arithmetic** | displayed fusion fibers, sizes, permutation values, and matrix square |
| `ClebschGatewayConicDeepHole` | **BLOCKED for classification use** | only `fieldOrder_le_fifteen` is an unconditional mathematical theorem beyond table arithmetic |
| `ClebschGatewayCoxeterPhase` | **BLOCKED for arrangement/code semantics** | symbolic integer identities and literal-profile arithmetic only |
| `ClebschGatewayA5FourierPhase` | **BLOCKED for scheme semantics** | symbolic valency identity and literal-profile arithmetic only |
| existing gateway gates | **BLOCKED as trust labels** | usable as import aggregators, never as evidence that external semantics became kernel-backed |

## Initial review checklist and disposition

- [x] Derived the direct scope from campaign imports and named terminals.
- [x] Followed the load-bearing q=11 semantic support to checker soundness and code definitions.
- [x] Read actual declaration types and bodies, not only reports.
- [x] Checked for `sorry`, project axioms, `native_decide`, and opaque oracles in the scoped sources;
  the source scan found no such dependency marker.  Existing reports claim only standard Lean
  axioms, but this review did not replay `#print axioms`.
- [x] Distinguished kernel reduction over literal data from a sound checker connecting data to a
  quantified mathematical proposition.
- [x] Checked gate import coverage and found imports present for the advertised modules, but no
  trust reconciliation.
- [x] Checked vacuity/baked conclusions: generic decorated recovery and orbit fusion are explicitly
  conditional structures; phase classifications and exhaustions are baked into definitions.
- [x] Checked prose and names for unsupported strength and private workflow references.
- [x] Checked generated-data semantics and provenance: the matching/fusion/profile arrays are
  handwritten Lean data; internal-note scripts and JSON provide external provenance but are not
  imported checker evidence or enduring referee-facing artifacts under the current standard.
- [x] Recorded explicit exclusions and did not touch Q25, active C222, certificates, or new task
  modules.

**Initial disposition: NO-GO.**  The coordinate-level extension/termination core is admissible, but
the complete pre-existing closure must not be advertised as a full-trust Clebsch gateway.  Findings
F1--F4 block referee-facing release; F2 and F3 also block the corresponding downstream
parent-recovery and scheme-semantic claims from receiving a full-trust Lean label.

## Judgment calls

1. **Literal-data theorems were not rejected as false.**  They are valid Lean theorems about the
   definitions in their types.  The defect is adequacy: the advertised mathematical nouns are not
   connected to those definitions in Lean.
2. **The q=11 witness was accepted as a coordinate theorem, not as an intrinsic Clebsch theorem.**
   The checker chain is substantive and sound; only the paper-object correspondence remains.
3. **No broad build was launched.**  The assignment initially requested read-only inspection, and
   existing successful build/axiom evidence was sufficient to distinguish proof validity from
   statement adequacy.  Any subsequent source repair requires scoped validation under the Lean
   build rules.
4. **No unsafe API rename was attempted during initial review.**  A live downstream Fourier module
   already consumes `certifiedPhaseProfile`; changing it would overlap an excluded active task.

## Repair pass after the frozen initial review

The user subsequently authorized repairs within the reviewed pre-existing Lean modules and gates.
The repair pass did not edit any new campaign module, Q25 path, active C222 path, generator,
certificate, task queue, handoff, or earlier report.

### Repairs made

1. **Removed every reverse workflow reference in the reviewed Lean surface.**  The twelve touched
   modules/gates no longer mention internal task identifiers, lanes, reports, agents, sessions, or
   workflow chronology.  Module headers now describe mathematical objects, finite domains, checking
   methods, and limitations directly.
2. **Made the mixed trust boundary explicit at the point of use.**  The matching module now says
   that `Parent` is a row index and that the concrete decorated theorem recovers only that index.
   The fusion module now says that its permutation, valencies, and matrix are literal data whose
   scheme semantics are not established there.  All four gate headers distinguish elaboration and
   literal-data arithmetic from semantic certification.
3. **Removed unsupported classification language where no live consumer prevented it.**
   `ClebschGatewayConicDeepHole` now uses `RecordedProfile`, `recordedProfiles`, and
   `recordedFullConicField`.  `ClebschGatewayCoxeterPhase` now uses `RecordedPhaseProfile`,
   `recordedPhaseProfile`, `RankFourCardinalityProfile`, and
   `recordedRankFourProfiles_fail_cardinality_test`.  Their docstrings state that Lean has no
   geometric witness or coverage theorem for the supplied rows.
4. **Qualified all strength-bearing prose.**  Claims previously described as a complete rank-four
   gate, exhaustive fusion census, geometric orientation sheet, exact orbit fusion, or concrete
   parent recovery now describe the literal proposition in the theorem type.
5. **Added missing public API explanations in touched modules.**  Non-obvious row labels, maps,
   appended columns, fibre calculations, recorded formulas, and conditional constructors now state
   their quantifier domain and trust role in ordinary mathematical language.

The active Fourier consumer prevented renaming
`ClebschGateway.A5FourierPhase.certifiedPhaseProfile`.  Its source header and declaration docstrings
now state the exact limitation, but the unsupported strength-bearing public name remains finding F1
until the consumer and provider can be migrated together.

### Validation performed

All twelve touched Lean modules/gates passed guarded single-file elaboration under the repository's
default `single` controls:

- `RelativeConicArcs.ClebschGateway`;
- `RelativeConicArcs.ClebschGatewayQ11Extension`;
- `RelativeConicArcs.ClebschGatewayQ11Conic`;
- `RelativeConicArcs.ClebschGatewayQ11Matching`;
- `RelativeConicArcs.ClebschGatewayQ11Fusion`;
- `RelativeConicArcs.ClebschGatewayConicDeepHole`;
- `RelativeConicArcs.ClebschGatewayCoxeterPhase`;
- `RelativeConicArcs.ClebschGatewayA5FourierPhase`;
- the four corresponding `RelativeConicArcs.Gates.ClebschGateway*` modules.

The in-source `#print axioms` output contained only the permitted standard axioms (`propext`,
`Classical.choice`, and `Quot.sound`, with some arithmetic/table theorems using fewer or none).
No `sorryAx`, `native_decide`, or project-local axiom appeared.  This was single-file elaboration,
not an exact-target Lake build or a replay of the external certificates.

Post-repair source identities are:

| file | SHA-256 |
|:---|:---|
| `ClebschGateway.lean` | `24e786a37ad2dab7d91651e51d5dbb5427fc26bd9e22c6a54fddda97abc66fd8` |
| `ClebschGatewayQ11Extension.lean` | `501c1a378d0f1596d4830504c4cb1b6bd7c584791ee695d68647c8818c067890` |
| `ClebschGatewayQ11Conic.lean` | `1c0ec7d04457717e1447b395c7cd9cfbdce7739c8fea877348ecf6cded8bc5ee` |
| `ClebschGatewayQ11Matching.lean` | `010c59e1310cb13df0594ffc3db5a346c048a1c66c2b91d6f6d2639a0ea19ec7` |
| `ClebschGatewayQ11Fusion.lean` | `b27929ee0834d64ccaaaba13114fbee0f14949eaeded8fbdac1fb9f511c45c3e` |
| `ClebschGatewayConicDeepHole.lean` | `da3053afd394e2e5f30274c97c896c41f626a7f8d64c483fa1e56953b8d97898` |
| `ClebschGatewayCoxeterPhase.lean` | `8c3b5bc56e3db03024a09e714bc777e15e491155edd6c228697f4f559545d140` |
| `ClebschGatewayA5FourierPhase.lean` | `c95b3cd0c46b20f85004e104ea9b0eddf7e06621bad9ad2e6ad13a690d2e0064` |
| `Gates/ClebschGateway.lean` | `8f2d07c6c91e1b1b0f1eb133d2bbc7f4b8702dd3edb23d8c4342b16e10ea2478` |
| `Gates/ClebschGatewayConicDeepHole.lean` | `db9e27061b9c82ae2701332f2ba72d549f8c0b9315ae7b3e143b9f54f14b7e46` |
| `Gates/ClebschGatewayCoxeterPhase.lean` | `e9adb3cee2d7a3d5c103b7160c95894a1728e9f4e2b83656af9735801e66a689` |
| `Gates/ClebschGatewayA5FourierPhase.lean` | `1e4cef0d215124bc9461c398b9d05dd58871626034f9991ea1d84ca5fa71cc60` |

The older internal checksum manifests for the gateway and conic-profile work include pre-repair
Lean hashes and are consequently stale.  They were not edited because checksum manifests and
external evidence were outside the authorized repair surface.  They must not be represented as a
green replay of the repaired source until their owners reconcile them in an authorized evidence
update.  The Coxeter and scalar-`A5` checksum files hash only their script/JSON pair, so their
external data identities are unchanged; that fact still does not supply the missing Lean semantic
bridge.

### Remaining blockers after repair

| finding | post-repair status | required next action |
|:---|:---|:---|
| F1, scalar-`A5` `certified*` API | **open/blocking** | coordinate migration with the active Fourier consumer, or add a sound semantic checker and completeness theorem |
| F1, deep-hole/Coxeter naming and prose | **source fixed; semantics remain external** | ledger must retain exact replay/certificate tier unless checker architecture is added |
| F2, geometric parent recovery | **open/blocking** | define/check semantic parents, obstruction map, injectivity, completeness, and required equivariance |
| F3, scheme fusion/Fourier identification | **open/blocking** | derive the data from defined relations/character sums or retain a decomposed external-identification trust row |
| F4, reverse references | **fixed in reviewed Lean surface** | post-fix reviewer should repeat the closure search |
| F5, displayed witness versus intrinsic Clebsch object | **open/claim-dependent** | exact coordinate correspondence in Lean or a separately declared conceptual/certificate route |
| F6, gate overstatement | **fixed in reviewed gate prose** | final trust comes from the claim ledger, never the import gate alone |
| F7, unsupported strength prose | **fixed except blocked scalar-`A5` public names** | migrate the remaining names with their live consumer |
| stale pre-repair source hashes in older internal manifests | **open/evidence hygiene** | owner-authorized manifest/checker reconciliation without regenerating mathematical data unless required |

### Post-repair checklist

- [x] Preserved the initial findings in a standalone pre-fix commit.
- [x] Touched only the reviewed pre-existing Lean modules/gates and this report.
- [x] Did not edit Q25, active C222, `ReflectionArrangementDecoding.lean`, new campaign modules,
  certificates, generators, queues, handoffs, or other reports.
- [x] Re-read the complete touched modules and checked their comments/names against the
  referee-facing standard.
- [x] Removed internal task/lane/report/agent/session references from the touched Lean surface.
- [x] Rechecked that comments do not promote literal data into geometric certification.
- [x] Ran guarded elaboration on every touched module and gate.
- [x] Recorded the actual axiom output boundary and current source hashes.
- [x] Recorded rather than concealed the evidence manifests made stale by source edits.
- [x] Kept architectural/certificate gaps as blockers rather than inventing new proof scope.
- [x] Did not issue a post-fix `GO`; the repair implementer cannot review its own changes.

**Status: READY FOR USER-LAUNCHED POST-FIX REVIEW.**  The post-fix reviewer should determine whether
the prose/API repairs are adequate, confirm the remaining blocker classification, and specifically
audit the live Fourier consumer's use of `certifiedPhaseProfile` before any full-trust label or task
archival is permitted.
