# C426 / F7 — Lean q=11 Fourier self-duality

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

The scalar-line character sum, `P=Q`, `P²=1331 I`, multiplicity–valency equality, Fourier
self-duality, and 126-witness primitivity certificate are mandatory full-trust Lean exits. The
512-entry intersection tensor and consequent Krein/intersection equality are exact
replay/certificate-backed by default and upgrade only if the separate intersection-tensor checker
leaf, gate import, and clean axiom audit land. The 877-partition fusion census is likewise an
independent exact replay/certificate unless its own optional checker leaf lands. A conditional Lean
theorem assuming tensor correctness is recorded as conditional, never as a Lean proof of the tensor.

Internal reports may identify the originating task evidence and must point forward to exact Lean
declarations. Lean modules and generated artifact prose describe the mathematical data and trust
role without internal task identifiers.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschSchemeFourierData.lean`,
  `ClebschSchemeFourier.lean`, the optional `ClebschSchemeIntersectionTensor.lean`,
  `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean`, and the same-stem
  `.md/.py/.json/.sha256` evidence bundle.
- Import only the existing `RelativeConicArcs.ClebschGatewayA5FourierPhase` arithmetic interface;
  F7 is logically independent of C420--C425. Do not edit gateway or existing certificate modules.
- Freeze the eight class representatives and hyperplane counts as untrusted data. Prove the
  scalar-line character sum and connect it to exact matrix equalities `P=Q` and
  `P^2=1331 I`; derive multiplicity--valency equality and Fourier self-duality with all indexing and
  ordering conventions explicit.
- Prove primitivity in kernel with exactly one checked witness pair for each of the 126 proper
  nonempty unions of nonidentity classes. Do not replace this with a generator assertion or infer
  separability.
- First land and review the mandatory core gate. Do not begin the optional tensor or fusion leaf
  merely because time remains. They may be attempted only as separately measured leaves without
  changing the core architecture or trust labels.
- The optional 512-entry tensor leaf must check tensor indexing, intersection semantics, all
  entries, and the theorem deriving Krein/intersection equality. The optional 877-partition leaf
  must have a sound exhaustive fusion predicate. Without those landed leaves, retain the exact
  external replay/certificate rows and export no unconditional Lean theorem claiming the missing
  finite fact.
- Exit through `RelativeConicArcs.Gates.ClebschSchemeFourier`; its imports and public terminals must
  expose the mandatory core and only the optional claims that actually passed their own checker and
  axiom audit.

## Required judgment-call record

Before review, add a completed section here for every implementation or scope choice a later agent
could reasonably question. For each choice record: the question; admissible options; chosen option;
mathematical and measured evidence; effect on theorem statement, trust tier, imports, gate, and
paper claim; rejected alternatives; and the exact condition for reopening it. Include decisions to
omit an optional theorem, use or reject a certificate, weaken or generalize a statement, add a
hypothesis, choose a finite representation, stop after a measured failure, or classify a result as
external. “Obvious,” “standard,” “if feasible,” and an unrecorded absence of work are not
dispositions. If no judgment call occurred, state that explicitly and explain why execution was
fully forced by this brief.

## Implementation result and validation status (implementer)

**Status: post-initial-review repair implemented.** The initial independent review is
[`2026-07-21-c426-clebsch-scheme-fourier-initial-review.md`](2026-07-21-c426-clebsch-scheme-fourier-initial-review.md),
commit `b058a9a481e10c16c41acbd1f80118725eecfb48`, verdict `NO-GO`. Every finding has a
concrete repair below. The exact gate and axiom audit are green; the pinned implementation commit
is `4c7a848291906b3961f8af9eb86dd30da30e0f9b`; post-fix review remains required.

Owned implementation paths:

- `lean/RelativeConicArcs/ClebschSchemeFourierData.lean` (generated definitions);
- `lean/RelativeConicArcs/ClebschSchemeFourier.lean` (kernel theorems);
- `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean` (import-only gate); and
- `lean/verification/clebsch_scheme_fourier/{generate.py,data.json,SHA256SUMS,orbit_construction.py,scheme_certificate.json}`
  (stable generator, canonical schema output, full hash manifest, pinned exhaustive construction,
  and comparison certificate).

The evidence command, from the repository root, is:

```sh
python3 lean/verification/clebsch_scheme_fourier/generate.py --check
```

It reconstructs all 133 projective-line labels and all 126 additive-nonclosure witnesses by exact
enumeration over `F_11^3`, derives the candidate `P` table from scalar-line incidence counts,
computes `Q = 1331 P^{-1}` exactly over `Fraction`, checks `P=Q`, `P Q=1331 I`, candidate
multiplicity/valency equality, and cross-checks the frozen comparison certificate. Lean separately
checks the abstract character identity and every literal terminal listed below. The external trust
boundary is the identification of this exhaustive construction with the reduced projective
icosahedral orbit scheme and the association-scheme criteria applied to it.

Scoped guarded elaboration after repair:

- generated data module: green, 3.30 s;
- theorem module: green, 6.54 s after the final proof/style edit;
- the full 126-witness check is included in that theorem-module time, so no sharding is needed.

Exact queue command:

```sh
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschSchemeFourierData \
  RelativeConicArcs.ClebschSchemeFourier \
  RelativeConicArcs.Gates.ClebschSchemeFourier \
  --profile single --threads 1 \
  --serial-first RelativeConicArcs.ClebschSchemeFourierData \
  --aggregate RelativeConicArcs.Gates.ClebschSchemeFourier --cores 20-23
```

Run `20260721-184026-f32b576d` finished `success`: data 4.41 s / 1,136,076 kB peak;
theorem 7.68 s / 2,235,568 kB; gate 8.64 s / 1,783,284 kB; final aggregate exact-target
`--no-build` gate passed. A final generator replay returned `CHECK OK` and reproduced the built
Lean source byte-for-byte, so the content trace remains the final-source trace.

Final artifact identities before commit:

| Bytes | SHA-256 | Path |
|---:|---|---|
| 16,372 | `68f562947dcc474a6dd908eb1d98d093dd7a633bfefcedb9de8739809e27694e` | `lean/verification/clebsch_scheme_fourier/generate.py` |
| 38,486 | `cb32a53c04d26ff4dc0e4f98b2e4bbe84ef0e03c9be04051cc5bd6b7d4dd1fdd` | `lean/verification/clebsch_scheme_fourier/data.json` |
| 16,799 | `0973e9eb6e3ac804f5f18ee52c0e4793ebc76cc6c6a80efd547ac4728c4ff4b1` | `lean/verification/clebsch_scheme_fourier/orbit_construction.py` |
| 12,997 | `e9a110c2ca0b01327d4f5c61023f4905e2f2acb9a6f5affcd365283aae188ac4` | `lean/verification/clebsch_scheme_fourier/scheme_certificate.json` |
| 615 | `086779434a146f9e8480a2be24467a3a983c92c965c19c2485c64e80c8eab553` | `lean/verification/clebsch_scheme_fourier/SHA256SUMS` |
| 13,149 | `f84a05435d0bcf86e76409b0ce6366dce7d0f14d0ab7ea9077a5140156ae3e57` | `lean/RelativeConicArcs/ClebschSchemeFourierData.lean` |
| 12,142 | `3018501b6adb2f3218190490d197ae1c7021436b78a38bc2473a857337093764` | `lean/RelativeConicArcs/ClebschSchemeFourier.lean` |
| 1,166 | `6a17f12f095aade20e5887d0c951da273febbcc9f23f8ea4ea025f8189cbebfa` | `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean` |

### Initial-review finding dispositions

| Finding | Disposition |
|---|---|
| R1 gate not green | Repaired all elaboration errors; guarded data/theorem checks are green and the exact gate queue has built all three targets. Final aggregate trace status is recorded below. |
| R2 failure-as-identity lookup | Replaced `relationOf` by option-valued `relationOf?`; the terminal requires `some r` for both inputs and the sum. |
| R3 disconnected character sum | Added `nonzeroScalarLineContribution` derived from `characterSum`, defined the aggregate `scalarLineEigenvalue`, and stated the frozen entry theorem through that definition. |
| R4 scheme prose exceeds types | Narrowed headers, docstrings, theorem names, gate prose, and ledger routes to literal checks plus explicit external geometric semantics. |
| R5 false subgroup claim | Removed it; the generator describes and performs exhaustive witness search without assuming a subgroup classification. |
| R6 internal referee provenance | Moved/exposed the complete load-bearing bundle under `lean/verification/clebsch_scheme_fourier/`; generated prose names exact stable paths and trust roles. |
| R7 dimensions/constants unbound | Added `frozen_table_shapes`; products use `schemeOrder` and `schemeRank`; indexed multiplication avoids `List.transpose`. |
| R8 gate overclaim | Removed the gateway import/rank bridge and added an explicit external-geometric boundary and negative claims. |
| R9 incomplete exit report | Added exact terminals/routes, validation, artifact semantics, exclusions, judgment calls, checklist, axiom section, and C320 ledger delta. |

## Recorded judgment calls

**JC-1 — Trust boundary of the imported `ClebschGateway.A5FourierPhase` profile (use at
`ClebschSchemeFourier.lean:92`, theorem `schemeRank_eq_certified`).**
- Question: may a Lean theorem equating the frozen relation count with
  `(certifiedPhaseProfile .q11).schemeRank` be presented as kernel-certified evidence of the
  rank-eight geometry?
- Independent review finding: **no.** The gateway's `certified*` names freeze externally derived
  literal values; Lean does not check the underlying scalar-line/class/profile geometry or its
  exhaustive coverage. The name is not a full-trust geometric certificate.
- Admissible repair routes (per reviewer): (1) treat the imported values as untrusted literal data
  and add a sound checker theorem establishing the exact scalar-line/class/profile semantics and
  coverage C426 needs; or (2) state downstream theorems conditionally on the missing semantic premise
  and classify that premise/result as external exact replay/certificate in the verification map.
- **Disposition: route 2 selected by the committed initial review.** The gateway import,
  `schemeRank_eq_certified`, and gate rank claim are removed. No replacement conditional theorem is
  introduced because the owned modules contain no independently meaningful action/orbit/coverage
  premise. Rank and geometric identification remain exact external replay/certificate claims; the
  gateway API itself is untouched.
- Trust impact: the full-trust exits are the abstract character identity and exact literal-table
  checks (`P=Q`, `P·Q=1331I`, `P²=1331I`, row-zero/valency equality, mask coverage, and successful
  nonclosure classifications). Fourier self-duality and primitivity of the named geometric scheme
  require the external identification. Reopen only with a sound action/orbit/coverage checker.

**JC-2 — Krein/intersection-tensor tier.** Certificate-backed by default: no
`ClebschSchemeIntersectionTensor` leaf created; the 512-entry tensor and the Krein=intersection
equality remain exact replay/certificate (frozen scheme certificate), stated as such, with no
conditional Lean tensor theorem exported. Reopen only if a measured intersection-tensor checker leaf
plus gate plus clean axiom audit land.

**JC-3 — 877-partition fusion census.** Not brought in-kernel; remains exact replay/certificate. No
separability inferred. The gateway's `fusionRanks .q11 = [2,4,6,8]` is imported literal data under
the same JC-1 boundary. Reopen only if a sound exhaustive-fusion checker leaf lands.

**JC-4 — Additive-nonclosure representation.** Chose a 133-entry projective-line classifier (leading-
coefficient-one representatives → relation index) plus `normalizeVector` (frozen `inv11` table) plus
126 witness pairs keyed by seven-bit masks, over a 1331-vector classifier (kernel-`decide` cost) or
per-subset frozen unions (size). Coverage is certified by `primitivity_masks_exhaustive` (masks are
exactly the 126 proper-nonempty seven-subsets) and `primitivity_witness_masks_decode` (each
witness's relation list equals its mask's bits). The frozen orbit partition is the replay-backed
input. `relationOf?` is option-valued, and each witness theorem explicitly proves successful lookup
of `x`, `y`, and `x+y`; failure cannot masquerade as identity relation zero. Additive nonclosure of
each recorded union is checked in kernel. The complete theorem module elaborates in 6.54 s, so the
measured result rejects sharding. Reopen only if later certificate growth invalidates that profile.

**JC-5 — Character sum vs. eigenvalue reconstruction split.** The abstract cyclotomic identity
`∑_{a∈F₁₁} ζ^{(a s).val} = 11·[s=0]` is proved in-kernel over an arbitrary integral domain with a
primitive eleventh root (`characterSum`). Its direct corollary `nonzeroScalarLineContribution`
proves the per-line values `10` and `-1`; `scalarLineContributionsSum` proves for a list of dot
products that their total is `11 * count(0) - length`; `scalarLineEigenvalue z ell := 11*z-ell`
records the frozen integer specialization. The table formula is checked by
`frozen_eigenmatrix_scalar_line_formula`. That
the frozen `z`/`ell` are the
true orthogonal-line/line counts of the orbits — hence that the frozen `P` is the actual
character-sum eigenmatrix — is the replay-backed geometric input, not re-derived in kernel (the
campaign's declared mixed-verification entry boundary). Recorded so the reconstruction is not
over-claimed as a from-scratch in-kernel proof of the spectrum.

**JC-6 — Fourier self-duality encoding.** Lean checks `frozen_eigenmatrices_equal` (`P=Q`) and
`frozen_eigenmatrix_product` (`P·Q=1331I`) only as literal matrix statements. The same-ordering /
character-realized aspect (dual orbit labels equal primal labels) is the replay-backed geometric
fact. Therefore Fourier self-duality of the named scheme is classified as a combination of exact
Lean table checks and external geometric identification, never as a standalone full-trust Lean exit.

**JC-7 — Data/logic split.** `normalizeVector`/`relationOf?`/`inv11` are derived logic, placed in the
theorem module; the generated data module holds frozen tables only. Because `List.lookup` needs
`BEq` on the product vector type, `relationOf?` uses `List.find?` with a `DecidableEq`-based
predicate and preserves lookup failure as `none`.

**JC-8 — Named-expert context.** Loaded the umbrella per `lean/AGENTS.md`; it carries no
association-scheme/finite-field-Fourier dossier. Closest lens: the finite-projective-arcs specialist
(Hirschfeld/Thas/Storme/Ball/Lavrauw) for the PG(2,11) scalar-line framing. The core proofs are a
standard finite-field character sum and finite `decide` checks, not warranting a deeper dossier read.

**JC-9 — Missing `Mathlib.Algebra.GeomSum` olean.** The repo's partial Mathlib build lacks
`GeomSum.olean`. Rather than expand the Mathlib build, the geometric-root-sum vanishing is proved by
a cyclic-shift argument (`ζ·S=S ⟹ (ζ−1)S=0 ⟹ S=0`) using only `Finset.sum_range_succ` and
`Finset.sum_range_succ'`, which are in the built subset. The only missing modules encountered were
`GeomSum` and the moved `BigOperators.Basic`; `RootsOfUnity.Basic` and `BigOperators.Fin` are built.

**JC-10 — Enduring verification artifacts.** The initial reviewer rejected task-dated evidence under
`notes/` as referee-facing provenance. The generator, canonical JSON, complete checksum manifest,
pinned construction, and comparison certificate now live under
`lean/verification/clebsch_scheme_fourier/` with workflow-neutral names and prose. The generated
module names those exact paths and distinguishes external geometric semantics from kernel checks.
The dated report remains internal coordination/evidence prose and points forward to the enduring
bundle. Reopen only if the repository adopts a different declared packaging allowlist.

**JC-11 — Matrix representation and shape.** Retained list matrices for compact generated data, but
replaced `List.transpose` multiplication with indexed column extraction and added
`frozen_table_shapes`, checking every row length and all outer dimensions against `schemeRank`.
The product theorems now use `schemeOrder` and `schemeRank`, so `entry`/`getD` defaults cannot hide
ragged frozen inputs. A `Matrix (Fin 8) (Fin 8) ℤ` rewrite was rejected as unnecessary API churn.

**JC-12 — Scheme-level naming and claims.** Public theorem names were narrowed to
`frozen_*` descriptions wherever the type checks only literals. Module and gate prose explicitly
deny an in-kernel association-scheme construction, rank proof, Fourier-self-duality theorem, or
primitivity theorem for the named geometry. The stronger scheme-level conclusions are decomposed
into exact external identification plus the relevant Lean literal checks. Reopen only if semantic
scheme/action definitions and soundness theorems land.

## Exact exits and statement adequacy

All names below are in `RelativeConicArcs.ClebschSchemeFourier` and are re-exported by
`RelativeConicArcs.Gates.ClebschSchemeFourier`.

| Terminal | Exact mathematical content | Route |
|---|---|---|
| `characterSum` | In any commutative integral domain, for a primitive eleventh root `zeta` and `s : ZMod 11`, `sum_a zeta^((a*s).val)` is `11` if `s=0` and `0` otherwise. | full-trust Lean |
| `nonzeroScalarLineContribution` | Under the same hypotheses, subtracting the zero scalar gives `10` when `s=0` and `-1` otherwise. | full-trust Lean |
| `scalarLineContributionsSum` | For any list of character/line dot products, the total nonzero-scalar contribution is `11` times the number of zero dot products minus the list length. | full-trust Lean |
| `frozen_table_shapes` | The frozen candidate `P`, `Q`, and hyperplane-count tables are square of dimension `schemeRank`; the candidate valency list has that length. | full-trust Lean literal check |
| `frozen_eigenmatrices_equal` | The two frozen candidate integer tables are equal in their recorded ordering. | full-trust Lean literal check |
| `frozen_eigenmatrix_product` | Their list-matrix product is `scaledIdentity schemeOrder schemeRank`. | full-trust Lean literal check |
| `frozen_first_eigenmatrix_sq` | The frozen candidate `P` squares to the same normalized identity. | full-trust Lean literal check |
| `frozen_q_row_zero_eq_valencies` | Row zero of frozen candidate `Q` equals the candidate valency list. | full-trust Lean literal check |
| `frozen_eigenmatrix_scalar_line_formula` | Every frozen candidate `P[i,j]` is `1` in column zero and otherwise `scalarLineEigenvalue z(i,j) ell(j) = 11*z(i,j)-ell(j)`. | full-trust Lean literal check; geometric meaning external |
| `inv11_mul` | Every nonzero residue is inverted by the frozen inverse table. | full-trust Lean literal check |
| `primitivity_witness_masks_decode` | Every recorded witness relation list equals the seven-bit mask decoding. | full-trust Lean literal check |
| `primitivity_masks_exhaustive` | Recorded masks are exactly the 126 integers `1..126`, hence all proper nonempty subsets of seven labels. | full-trust Lean literal check |
| `frozen_witnesses_break_additive_closure` | For every witness, option-valued classifier lookup succeeds for both summands inside the selected labels and for their nonzero sum outside them. | full-trust Lean literal check; geometric transfer external |

Statement-adequacy appendix (the namespace prefix is omitted and Greek binder names are
alpha-renamed; proposition types otherwise match `lean/RelativeConicArcs/ClebschSchemeFourier.lean`):

```lean
characterSum {R : Type*} [CommRing R] [IsDomain R]
  {zeta : R} (hzeta : IsPrimitiveRoot zeta 11) (s : ZMod 11) :
  (∑ a : ZMod 11, zeta ^ (a * s).val) = if s = 0 then 11 else 0

nonzeroScalarLineContribution {R : Type*} [CommRing R] [IsDomain R]
  {zeta : R} (hzeta : IsPrimitiveRoot zeta 11) (s : ZMod 11) :
  (∑ a : ZMod 11, zeta ^ (a * s).val) - 1 = if s = 0 then 10 else -1

scalarLineContributionsSum {R : Type*} [CommRing R] [IsDomain R]
  {zeta : R} (hzeta : IsPrimitiveRoot zeta 11) (dots : List (ZMod 11)) :
  (dots.map fun s => (∑ a : ZMod 11, zeta ^ (a * s).val) - 1).sum =
    (11 : R) * (dots.count 0 : R) - (dots.length : R)

frozen_table_shapes :
  firstEigenmatrix.length = schemeRank ∧
  (∀ row ∈ firstEigenmatrix, row.length = schemeRank) ∧
  secondEigenmatrix.length = schemeRank ∧
  (∀ row ∈ secondEigenmatrix, row.length = schemeRank) ∧
  hyperplaneLineCounts.length = schemeRank ∧
  (∀ row ∈ hyperplaneLineCounts, row.length = schemeRank) ∧
  valencies.length = schemeRank

frozen_eigenmatrices_equal : firstEigenmatrix = secondEigenmatrix
frozen_eigenmatrix_product :
  matMul firstEigenmatrix secondEigenmatrix = scaledIdentity schemeOrder schemeRank
frozen_first_eigenmatrix_sq :
  matMul firstEigenmatrix firstEigenmatrix = scaledIdentity schemeOrder schemeRank
frozen_q_row_zero_eq_valencies : secondEigenmatrix.getD 0 [] = valencies

frozen_eigenmatrix_scalar_line_formula : ∀ i j : Fin schemeRank,
  entry firstEigenmatrix i j =
    (if j.val = 0 then 1 else scalarLineEigenvalue
      (entry hyperplaneLineCounts i j) (entry hyperplaneLineCounts 0 j))

inv11_mul : ∀ a : ZMod 11, a ≠ 0 → inv11 a * a = 1
primitivity_witness_masks_decode :
  ∀ w ∈ primitivityWitnesses, w.2.1 = maskRelations w.1
primitivity_masks_exhaustive :
  primitivityWitnesses.map (fun w => w.1) =
    (List.range 128).filter (fun m => decide (m ≠ 0 ∧ m ≠ 127))
frozen_witnesses_break_additive_closure : ∀ w ∈ primitivityWitnesses,
  (∃ r ∈ w.2.1, relationOf? w.2.2.1 = some r) ∧
  (∃ r ∈ w.2.1, relationOf? w.2.2.2 = some r) ∧
  (∃ r, r ∉ w.2.1 ∧ relationOf? (w.2.2.1 + w.2.2.2) = some r) ∧
  w.2.2.1 + w.2.2.2 ≠ (0, 0, 0)
```

The table rows and witness records are definitions in `ClebschSchemeFourierData.lean`, generated
from schema `clebsch-scheme-fourier-lean-v1`. No predicate is defined to mean the desired
scheme-level conclusion, and no conditional theorem hides the missing geometric premise.

## External boundaries and exclusions

Exact external replay/certificate supplies the reduced projective icosahedral action, its exhaustive
eight-label scalar-line orbit partition, identification of the frozen `P`, `Q`, incidence counts and
candidate valencies with that translation association scheme, and the criterion transferring the
checked nonclosure records to primitivity. Consequently the paper-facing claims “Fourier self-dual”
and “primitive” are decomposed combinations, not full-trust Lean claims.

The gate proves no intersection tensor, intersection/Krein equality, 877-partition fusion census,
separability, automorphism group, semantic scheme rank, or exhaustive action/orbit checker. The
512-entry tensor and fusion census retain their independent exact replay/certificate routes.

## Proposed C320 ledger delta

| Claim | Lean evidence | External evidence / residual boundary | Final route |
|---|---|---|---|
| scalar-line character identity and `11z-ell` aggregation | `characterSum`; `nonzeroScalarLineContribution`; `scalarLineContributionsSum` | none | full-trust Lean |
| frozen candidate matrix dimensions and `11z-ell` formula | `frozen_table_shapes`; `frozen_eigenmatrix_scalar_line_formula` | meaning of frozen counts and labels | combined Lean literal check + exact external replay |
| `P=Q`, `P*Q=1331I`, `P^2=1331I` for frozen tables | `frozen_eigenmatrices_equal`; `frozen_eigenmatrix_product`; `frozen_first_eigenmatrix_sq` | identification as scheme eigenmatrices and dual ordering | combined Lean literal check + exact external replay |
| candidate multiplicity/valency equality | `frozen_q_row_zero_eq_valencies` | identification of row zero and valencies with the scheme | combined Lean literal check + exact external replay |
| all 126 recorded unions break additive closure | `primitivity_witness_masks_decode`; `primitivity_masks_exhaustive`; `frozen_witnesses_break_additive_closure` | exhaustive orbit/classifier semantics and transfer to scheme primitivity | combined Lean literal check + exact external replay |
| intersection/Krein equality | none in gate | frozen 512-entry external certificate | exact replay/certificate |
| 877-partition fusion census | none in gate | frozen exhaustive external certificate | exact replay/certificate |

Verify-all delta: add exact target `RelativeConicArcs.Gates.ClebschSchemeFourier` after the enduring
bundle's `generate.py --check`; require trace-current `lake build --no-build` and the axiom audit
listed below. Do not include the removed gateway rank bridge.

## Axiom audit

A transient import wrapper containing one `#print axioms` command per terminal was built through the
same prescribed queue and then removed. Run `20260721-184639-2728e3fc` rebuilt the final theorem and
gate closure, built the audit in 17.08 s with 2,222,060 kB peak RSS, and passed its final aggregate
trace gate. Exact output groups:

| Axioms | Terminals |
|---|---|
| none | `frozen_table_shapes`, `frozen_eigenmatrices_equal` |
| `propext` | `frozen_eigenmatrix_product`, `frozen_first_eigenmatrix_sq`, `frozen_q_row_zero_eq_valencies`, `frozen_eigenmatrix_scalar_line_formula` |
| `propext`, `Quot.sound` | `primitivity_witness_masks_decode`, `primitivity_masks_exhaustive` |
| `propext`, `Classical.choice`, `Quot.sound` | `characterSum`, `nonzeroScalarLineContribution`, `scalarLineContributionsSum`, `inv11_mul`, `frozen_witnesses_break_additive_closure` |

No terminal depends on `sorryAx`, a project axiom, `native_decide`, or an opaque oracle. All listed
axioms are standard Lean foundations already permitted by the campaign's full-trust tier.

## Required closing review process

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


The implementer first completes the checklist and a claim-by-claim ledger delta. A separate
referee-style reviewer then reads the actual theorem types, module prose, proof/trust boundary, gate,
and evidence; issues a recorded `GO` or `NO-GO`; and lists every finding. The implementer resolves
each finding or narrows the claimed exit explicitly. The task cannot close until the final
disposition and ledger delta agree with the landed artifact.

**Archival gate:** keep the task row live. After implementation, explicitly request the independent
review; do not infer that review from a build, report, or agent self-check. Any finding or `NO-GO`
blocks completion and archival. Fix every issue, update the artifact/report/checklist/ledger delta,
and request post-fix review. Only a recorded final `GO` permits the task to be marked complete and
archived under the repository completion invariant.

- [x] State every claimed exit in ordinary mathematics, with exact domain, hypotheses, conclusion,
  and correspondence to the intended paper statement.
- [x] Assign each exit exactly one final route: full-trust Lean, exact replay/certificate,
  conceptual proof with named classical inputs, or an explicitly decomposed combination.
- [x] Read the definitions and theorem types themselves: rule out vacuous predicates, conclusions
  baked into definitions or frozen data, weakened quantifiers, hidden typeclass/characteristic or
  nondegeneracy assumptions, empty domains, and theorem names or prose stronger than the type.
- [x] Verify that every claimed terminal is actually imported by the named gate and that validation
  is trace-current for the final source; a green dependency, stale build, report verdict, or
  authoritative-sounding filename is not evidence for an omitted theorem.
- [x] Remove or separately classify every optional, conditional, failed, “standard,” “follows,” or
  “if feasible” clause; no such clause inherits the module or gate's strongest label.
- [x] Record exact owned files, fully qualified terminal names, import-only gate, pinned commit,
  validation command/result, and `#print axioms` output for every terminal.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction committed with the report, for the paper's verbatim statement-adequacy appendix.
- [x] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, or unreported
  non-kernel execution occurs in the claimed dependency closure.
- [x] For every finite/computational claim, record the checker and soundness theorem, finite domain,
  generator/schema/data/hash, independent replay, exhaustive-versus-search status, and residual
  trusted boundary; write “not applicable” only with a reason.
- [x] Recompute byte counts and hashes only after the final source/evidence edit and compare them to
  the committed files; hashes establish identity, not mathematical correctness or regeneration.
- [x] List every cited or axiomatized input and what remains unconditional without it.
- [x] Review the entire touched module, names, filenames, comments, docstrings, banners, diagnostics,
  and changed verification artifacts for mathematical accuracy and referee-facing self-containment.
- [x] Confirm internal records point to exact Lean declarations while Lean and verification
  artifacts contain no reverse references, task IDs, workflow language, or unsupported novelty or
  strength claims.
- [x] State exclusions and negative boundaries explicitly, including what the task and gate do not
  prove.
- [x] Complete the judgment-call record with evidence, trust impact, rejected alternatives, and
  reopening conditions; ensure the verification map and ledger use the chosen final route.
- [x] Record the independent reviewer's identity, date, `GO`/`NO-GO`, findings, and dispositions.
- [x] Supply C320 with one ledger row per claim and the exact verify-all entry-point delta.
