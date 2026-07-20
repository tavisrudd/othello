# Clebsch replacement-spine Lean formalization plan

**Lane:** `clebsch`, planned from `crowns` with explicit user authorization

**Date:** 2026-07-20

**Status:** red-team approved and queued as C420--C428

## Decision and scope

Formalize the stronger C399--C411 Clebsch paper spine as one dependency-ordered mixed-verification
campaign:

```text
C399 Coxeter conic phase
  -> C403 conic restriction forgets a secant pairing
  -> C406 harmonic quotient and balanced-sheet recovery
  -> C409/C406 cubic-first orientation
  -> C411 six double-coset depth profiles
  -> C378 odd Fourier sector
  -> C379 matching-decorated parent recovery
  -> C372/C373 intrinsic syndrome algebra and unordered chirality.
```

This adopts the replacement-spine direction for formalization planning. It does not edit the
manuscript or claim unrestricted priority. C399's current Lean arithmetic terminals plus its
reproducible incidence/conic certificates are the explicit entry boundary; this campaign does not
pretend to internalize their finite geometry or full group closures. Downstream symbolic
implications become kernel-backed. Exhaustive ranks, balanced-half uniqueness, orbit tables, and
coordinate incidence rows become compact Lean certificate leaves only when a sound checker theorem
connects accepted data to the quantified proposition; otherwise they remain honestly Python-backed
in the verification map.

C374/C375 quantum statements, C376 cubic-surface geometry, C381--C402 companions, and C407--C419
scope controls are not blockers for this spine. They may consume the finished API later, but are
not silently included here. C403's weighted 2-adjoint theorem is queued after the spine because it
is a substantial landed theorem and useful paper infrastructure, but it is not on the critical
path to the factorization-memory result.

## Existing Lean and certificate base: consume, do not duplicate

- Active C222 owns the compact A3/H3 coordinate bridge, intersection ledgers, complement counts,
  and decoder-stratum consequence. Its sole task path is
  `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean`; new work must not overlap it.
- `RelativeConicArcs.ClebschGateway` already supplies the typed arc/MDS bridge, decorated recovery,
  two-sheet character inference, and orbit-fusion seam.
- The q=11 extension, conic, matching, and fusion leaves already prove the twelve-point transform,
  `[7,4,4]` extensions, second-transform termination, 22 faithful matchings in two sheets, the
  frozen rank-four fusion, the four `J`-odd relation pairs, and `M_odd^2=1331 I_4`.
- `ClebschGatewayConicDeepHole`, `ClebschGatewayCoxeterPhase`, and
  `ClebschGatewayA5FourierPhase` already expose the compact C398--C400 arithmetic/certificate
  interfaces. C399's incidence and conic-set proofs and C400's full scheme theorem are not thereby
  internalized.

Every task below imports these terminals. None regenerates their certificate trees or widens the
stable C380 gate in place.

## Proof architecture and task slices

### C420 / F1 — signed moment/trade foundation

Formalize the generic C409 lemmas actually consumed downstream over an explicit commutative
coefficient ring/module interface: finite signed moments through
degree three, affine translation/base-point independence under vanishing lower moments,
antipodal cancellation of even moments, weighted-barycentre cancellation in degree one, and a
nonzero cubic witness as the first surviving signed power sum. Prefer a small finite
multilinear/polynomial interface over a new general symmetric-tensor library.

**Exit:** symbolic theorems, no Clebsch tables; guarded elaboration; axiom audit.

### C421 / F2 — conic pairing-forgetting quotient

Formalize C403's standard-conic secant pullback and four-endpoint identity over the weakest ring
with the required polynomial identities:

```text
L_ab L_cd - L_ac L_bd = [a,d][b,c](XZ-Y^2),
```

Then state matching restriction, divisibility, and the augmentation-space presentation over a
field with distinct projective endpoints. Matching-switch connectivity is purely finite. The sharp
`2r=q+1` rational-evaluation boundary is restricted to a finite field with all rational conic
points enumerated. Keep the full factorized-support census out of this structural module.

**Exit:** reusable quotient API plus a light paper-facing theorem; no generated matching census.

### C422 / F3 — low-degree harmonic quotient

Define the conic Laplacian `4 d_X d_Z - d_Y^2` and prove the harmonic/radial decomposition needed
in degrees `1`, `2`, and `4` over `F_5`, `F_7`, and `F_11`, with every invertibility hypothesis
explicit. Connect F2's quotient to this decomposition. A fully general Fischer decomposition is
explicitly optional and must not delay the bounded paper degrees.

**Exit:** symbolic low-degree decomposition and dimension formulas, independently of A3/B3/H3
coordinate tables.

### C423 / F4 — C406 finite quotient leaves

Split A3, B3, and H3 across module boundaries. Freeze the quotient vectors and prove image ranks
`3,6,10`; for B3/H3 prove the signed first and second moments vanish and the cubic is nonzero.
Expose character/kernel/image dimensions only to the extent used by the paper theorem. The H3
symmetric-cube calculation is its own leaf. Each accepted table has a theorem connecting the data
to the stated rank/moment proposition, canonical hashes, source-report provenance, and an
independent replay.

**Exit:** three bounded leaves plus a light aggregator; generator/schema/checksum bundle; no full
group-algebra development in characteristic 11.

### C424 / F5 — balanced sheets and cubic orientation

Use compact certificate leaves for the statement that the two `q`-element sheets are the only
complementary halves with equal first and second moments. Prove symbolically that this recovers the
unordered pair. Add an abstract index-two action theorem and separate concrete B3/H3 permutation-
action leaves that instantiate the supplied `PGL_2/PSL_2` hypotheses and anti-invariance. Only
then conclude that the nonzero signed cubic is fixed by `PSL_2(q)`, negated by the outer coset, and
has stabilizer `PSL_2(q)` inside the certified action. Derive the plane syzygies by expanding
`P_M=P_0+Q Phi_M`.

**Exit:** paper-facing reconstruction/orientation theorem with finite uniqueness isolated from the
generic moment proof. Do not formalize the false uniqueness, Hessian, contraction, singular-locus,
or linear cubic-to-Fourier claims.

### C425 / F6 — C411 double-coset and H3 depth--Fourier--parent bridge

Create a definitions-only concrete `G=PGL_2(11)`, `H=A5`, `K=A4` permutation-action base. Add a
subgroup-mark leaf, the six representative incidence leaves, and a light aggregator. Formalize the
group-action seam deriving `1+4+6` on each sheet, the six double cosets, `K`-invariance and
`J`-antipodality, and the abstract three-profile cubic-first pushforward. State the mixed `K`--`H`
matrix-coefficient interpretation only at the needed level: six-dimensional double-coset domain,
rank-two image, four-dimensional kernel, and set-theoretic separation. Do not build general
modular Hecke theory.

The same task freezes the six representative incidence rows and certifies the profiles
`+/-v_1,+/-v_2,+/-v_3`, fibre sizes `1,4,6 / 1,4,6`, the two plane equations, and
`v_1+4v_2+6v_3=0`. Prove `D(JM)=-D(M)`, compose with the existing odd Fourier and matching leaves,
and show that a singleton profile recovers the unordered golden matching pair; a chosen singleton
matching then invokes `decorated_child_recovers_parent`.

**Exit:** the complete conceptual C411 theorem and C406 -> C378 -> C379 arrow; six representatives
replace a 22-row proof. No spine gate yet.

### C426 / F7 — q=11 rank-eight Fourier self-duality

Formalize C372's scalar-line character sum and connect the frozen hyperplane-count/eigenmatrix leaf
to `P=Q`, multiplicity--valency equality, Fourier self-duality, and the intersection/Krein
consequence used by the paper. The 877-partition fusion census and primitivity exhaustion remain
separate bounded leaves with checker theorems if kernel-feasible; do not infer separability.

**Exit:** a dedicated q=11 Fourier-scheme gate, separate from the chirality endpoint.

### C427 / F8 — q=11 intrinsic chirality and replacement-spine gate

Formalize only the committed C373 result, not new C207/outside-`S5` research: intrinsic recovery of
the six scalar-line blocks, their two ten-element three-subset orbits, and the unordered chirality
torsor. Supply either the compact affine-rigidity proof or a sound completeness-certificate theorem
for the full color-preserving automorphism/no-outer-lift claims; keep the verification boundary
explicit if the finite completeness check remains external. Reuse the existing abstract two-sheet
character theorem.

**Exit:** `RelativeConicArcs.Gates.ClebschReplacementSpine` imports the existing C380 gate and the
F1--F8 terminals without modifying stable C380 modules. Exact-target `--no-build` and the terminal
axiom audit are green. Hand the target list and verification-map delta to C320.

### C428 / F9 — weighted 2-adjoint and arrangement-code closure

After C222 is complete and the spine gate is independently green, formalize C403's ambient
line-section formula, weighted 2-adjoint
depth identity, punctured depth polynomial, and resulting Hamming enumerator/minimum-distance
formula. Consume only C222's committed public terminal for the A3/H3 specializations and add a
separate B3 certificate leaf. Never touch `ReflectionArrangementDecoding.lean`. Treat the broader orbit enumerators,
generalized weights, Tutte consequences, and all-degree factorized-support counts as certificate or
downstream corollary surfaces, not prerequisites.

**Exit:** one reusable rank-three arrangement-code theorem, exact C399 specialization, and a
separate `RelativeConicArcs.Gates.ClebschWeightedAdjoint` gate. Hand its verification delta to
C320; do not duplicate the trust manifest.

## Exact task ownership before ID allocation

All paths are relative to the repository root. The allocator reserved C420--C428 as one contiguous
`[clebsch]` block before any ID was placed in this document or the live queue.

| slice | owned Lean surface | evidence/report surface | imported terminals and paper-facing exit |
|:---|:---|:---|:---|
| C420 / F1 | `lean/RelativeConicArcs/ClebschMomentTrade.lean`; `lean/RelativeConicArcs/Gates/ClebschMomentTrade.lean` | `notes/2026-07-20-c420-clebsch-moment-trade-lean.md` | imports Mathlib finite sums/tensors only; exits through affine covariance, antipodal cancellation, barycentre cancellation, cubic witness |
| C421 / F2 | `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean`; `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | `notes/2026-07-20-c421-clebsch-conic-matching-quotient-lean.md`; no generated data expected | imports the existing conic/projective API; exits through secant pullback, four-point switch, quotient divisibility, switch connectivity, augmentation kernel, full-rational-boundary theorem |
| C422 / F3 | `lean/RelativeConicArcs/ClebschHarmonicQuotient.lean`; `lean/RelativeConicArcs/Gates/ClebschHarmonicQuotient.lean` | `notes/2026-07-20-c422-clebsch-harmonic-quotient-lean.md`; no generated data expected | imports F2; exits through the degree `1/2/4` `F_5/F_7/F_11` Laplacian decompositions and quotient-span bridge |
| C423 / F4 | `lean/RelativeConicArcs/ClebschFactorizationData.lean`; separate `lean/RelativeConicArcs/ClebschFactorizationA3.lean`, `ClebschFactorizationB3.lean`, and `ClebschFactorizationH3.lean` leaves; `lean/RelativeConicArcs/Gates/ClebschFactorization.lean` | `notes/2026-07-20-c423-clebsch-factorization-leaves-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F3 and newly generated data from the frozen C406 coordinates; exits through ranks `3/6/10`, lower-moment cancellation, and nonzero B3/H3 cubic |
| C424 / F5 | `lean/RelativeConicArcs/ClebschBalancedSheets.lean`; `lean/RelativeConicArcs/ClebschBalancedSheetsB3.lean`; `lean/RelativeConicArcs/ClebschBalancedSheetsH3.lean`; `lean/RelativeConicArcs/Gates/ClebschBalancedSheets.lean` | `notes/2026-07-20-c424-clebsch-balanced-sheets-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F1/F4; exits through unique complementary halves, abstract index-two sign theorem, concrete anti-invariance/stabilizer, and plane syzygies |
| C425 / F6 | `lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthBase.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthPositive.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthNegative.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepth.lean`; `lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean` | `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F1/F5 plus `RelativeConicArcs.ClebschGatewayQ11Fusion` and `RelativeConicArcs.ClebschGatewayQ11Matching`; exits through `1,4,6 / 1,4,6`, six profiles, rank-two plane, cubic pushforward, odd-Fourier sign, and decorated parent recovery |
| C426 / F7 | `lean/RelativeConicArcs/ClebschSchemeFourierData.lean`; `lean/RelativeConicArcs/ClebschSchemeFourier.lean`; `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean` | `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.md`, `.py`, `.json`, and `.sha256` with that same stem; the new data module is generated from C372's frozen artifact | imports existing `RelativeConicArcs.ClebschGatewayA5FourierPhase` for the C400 arithmetic interface; exits through the scalar-line sum, `P=Q`, Fourier self-duality, and the paper-used intersection/Krein consequence |
| C427 / F8 | `lean/RelativeConicArcs/ClebschSchemeChiralityData.lean`; `lean/RelativeConicArcs/ClebschSchemeChirality.lean`; `lean/RelativeConicArcs/Gates/ClebschReplacementSpine.lean` | `notes/2026-07-20-c427-clebsch-scheme-chirality-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F6/F7 and existing `RelativeConicArcs.Gates.ClebschGateway`; exits through six intrinsic blocks, unordered `10+10`, full/no-outer-lift evidence at its declared trust boundary, and the replacement-spine aggregate |
| C428 / F9 | `lean/RelativeConicArcs/ArrangementWeightedAdjoint.lean`; `lean/RelativeConicArcs/ClebschWeightedAdjointB3.lean`; `lean/RelativeConicArcs/Gates/ClebschWeightedAdjoint.lean` | `notes/2026-07-20-c428-clebsch-weighted-adjoint-lean.md`; add same-stem `.py/.json/.sha256` only for the B3 leaf | imports F2, existing `RelativeConicArcs.ClebschGatewayCoxeterPhase`, and C222's committed `RelativeConicArcs.ReflectionArrangementDecoding` terminal; exits through weighted depth, punctured enumerator, Hamming/distance theorem, and all three C399 specializations |

Every shorthand gate above is under `lean/RelativeConicArcs/Gates/`. Generated data modules are
definitions-only; transport and paper theorems live downstream. If implementation discovers that a
named leaf cannot satisfy the measured `single` profile, the task stops with a revised sharding
plan before generation.

## Dependency and dispatch order

```text
C222 (existing) -------------------------------> F9
F1 -------------------------> F5 ----\
F2 -> F3 -> F4 ------------> F5 -----+-> F6 -> F7 -> F8 [spine gate]
F1 -------------------------------> F6 -/
existing C378/C379/C380 -----------------------> F6/F8
existing C398/C399/C400 -----------------------> F7/F9
C222 + F2 -------------------------------------> F9 [separate gate]
```

Dispatch is serial at the dependency level but permits bounded parallel work after foundations:
F1 and F2 may proceed independently; after F2, F3 may proceed while F1 finishes. Heavy finite leaves
remain serialized through the shared build-owner queue. No worker receives a broad umbrella target
until its leaves are individually trace-current.

## Validation and evidence contract

- Before proof development, load the named-expert context and relevant Lean dossier.
- Use definitions-only bases, bounded leaf modules, and light aggregators. Sharding must cross
  module boundaries.
- Each generated finite leaf lands atomically with its generator/schema, canonical compact output,
  checksums, independent replay, a theorem connecting accepted data to the quantified proposition,
  source-report provenance, trusted-boundary text, and a green subtree gate.
- Run single-file smoke checks only through `lean/scripts/guarded-lean`; run multi-target gates
  through the unattended build queue with the `single` profile unless measured evidence authorizes
  another profile.
- Each task names its exact terminal `#print axioms` list. Neither gate may expose `sorryAx` or a
  project-local axiom. `RelativeConicArcs` is not a lane gate.
- Preserve C222's working path and any foreign dirty/stale closure. No task may build across it.

## Stop rules

- Stop and retain an external certificate when a finite uniqueness or orbit claim would require a
  monolithic case tree or exceed the existing compact-certificate boundary.
- Do not generalize beyond degrees `1,2,4`, symmetric moment degree three, or the supplied
  `A3/B3/H3` actions unless the general proof is strictly cheaper than the bounded statement.
- Do not formalize known false upgrades: cubic uniqueness, Hessian/contraction recovery,
  quotient-point singular recovery, a linear cubic-to-Fourier intertwiner, or scheme separability.
- A failed optional generalization does not block the paper-facing bounded theorem.

## Queue policy

The allocator reserved contiguous block C420--C428 for F1--F9, with every row pegged `[clebsch]`:
these are
paper-verification tasks even though their research inputs came from `crowns`. Each row and the
allocation table below name exact report/module ownership. C222 remains the pre-existing owner of
its path and is not renumbered or duplicated. C320 remains the trust-manifest owner.

No task may edit an existing `ClebschGateway*.lean` module or
`ReflectionArrangementDecoding.lean`; all nine add new modules, leaves, reports, and gates only.
The `clebsch-next` merge into `crowns` is reconciled separately and does not re-peg these rows.

## Red-team disposition

The first draft received `NO-GO`. This revision resolves every allocation blocker: the spine gate
now ends F8 and is independent of weighted adjoint; C320 retains manifest ownership; C372 and C373
are separate tasks; C411's duplicated slices are merged; concrete group/action leaves are explicit;
C399 is an honest mixed-verification entry boundary; C222 and B3 ownership are named; field and
characteristic assumptions are bounded; and every certificate leaf has a checker-theorem,
provenance, replay, hash, and axiom-audit contract.
