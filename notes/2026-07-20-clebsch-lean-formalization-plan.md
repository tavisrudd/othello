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
implications become kernel-backed. Exhaustive ranks, orbit tables, and coordinate incidence rows
become compact Lean certificate leaves only when a sound checker theorem
connects accepted data to the quantified proposition; otherwise they remain honestly Python-backed
in the verification map.

C374/C375 quantum statements, C376 cubic-surface geometry, C381--C402 companions, and C407--C419
scope controls are not blockers for this spine. They may consume the finished API later, but are
not silently included here. C403's weighted 2-adjoint theorem is queued after the spine because it
is a substantial landed theorem and useful paper infrastructure, but it is not on the critical
path to the factorization-memory result.

The campaign is not complete, and no replacement-spine claim may be labelled Lean-formalized in
the manuscript, merely because C420--C428 elaborate. C320 is the release-blocking capstone: it must
merge the claim-level deltas from every completed slice into one referee-facing trust ledger, pin
the exact Lean commit and gates, and assign every paper claim exactly one final verification route.
An optional or failed kernel leaf becomes an explicit external-certificate or omitted route; it
never inherits a stronger label from the aggregate gate.

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
multilinear/polynomial interface over a new general symmetric-tensor library. Before creating
`ClebschMomentTrade.lean`, check the existing `RelativeConicArcs.Moments` module (classical unsigned
arc/line index moments): it shares the namespace but not the content, and its arc-moment lemmas may
be partially reusable here and in F2/F9. State affine covariance at general strength `s` — C409
proves it by one tensor expansion for arbitrary `s`, so the general statement is the cheaper one —
and specialize to `s=2` only where a downstream slice needs it.

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

Trust boundary fixed after C421 review: Lean proves switch reversibility for arbitrary `Fin m`, the
complete switch triangle on `Fin 4`, and connectivity of every `Fin 4` perfect matching to the base.
It does **not** prove connectivity for arbitrary `2n`. The familiar force-one-edge induction is a
conceptual argument outside Lean and is unused by the direct augmentation-kernel theorem. The
ledger must not call general switch connectivity kernel-backed. If a published claim needs that
general theorem, it requires a separately elaborated theorem before receiving a Lean label; it is
not an implicit C421 add-on.

**Exit:** reusable quotient API plus the precisely bounded `Fin 4` switch generator above; no
generated matching census and no general-`2n` connectivity claim.

### C422 / F3 — low-degree harmonic quotient

Define the conic Laplacian `4 d_X d_Z - d_Y^2` and prove the harmonic/radial decomposition needed
in degrees `1`, `2`, and `4` over `F_5`, `F_7`, and `F_11`, with every invertibility hypothesis
explicit. Connect F2's exact four-endpoint switch identity to this decomposition by proving that its
coordinate-generator instance is a radial `Q`-multiple. This slice does not claim a switch-span,
complete matching-kernel, or quotient--harmonic isomorphism theorem. A fully general Fischer
decomposition is explicitly optional and must not delay the bounded paper degrees.

**Exit:** symbolic low-degree decomposition and dimension formulas plus the exact four-endpoint
switch-radial bridge, independently of A3/B3/H3 coordinate tables.

### C423 / F4 — C406 finite quotient leaves

Split A3, B3, and H3 across module boundaries. Freeze the quotient vectors and prove image ranks
`3,6,10`; for B3/H3 prove the signed first and second moments vanish and the cubic is nonzero.
Expose character/kernel/image dimensions only to the extent used by the paper theorem. The H3
symmetric-cube calculation is its own leaf, `ClebschFactorizationH3` (the module named in the
ownership table), kept on a separate module boundary from A3/B3. For the nonzero-cubic witness,
freeze one linear functional `ell` and certify `sum_M eps(M) ell(Phi_M)^3 != 0` as a scalar sum over
the matchings (22 terms for H3, 14 for B3) rather than a full symmetric-tensor comparison. Each accepted table has a theorem connecting the
data to the stated rank/moment proposition, canonical hashes, source-report provenance, and an
independent replay.

**Exit:** three bounded leaves plus a light aggregator; generator/schema/checksum bundle; no full
group-algebra development in characteristic 11.

### C424 / F5 — balanced sheets and cubic orientation

The balanced-half uniqueness claim — the two `q`-element sheets are the only complementary halves
of the `2q` quotient points with equal first and second moments — now uses C430's symbolic
radical--Hadamard theorem; neither B3 nor H3 carries a subset-exhaustion leaf.  Formalize one
abstract lemma for a two-sheet affine evaluation space: restriction surjectivity onto the two
zero-sum hyperplanes, a one-dimensional second-moment radical whose evaluation separates the
sheets, and equality of the two second moments imply that coordinatewise products fill the
equal-sheet-sum hyperplane, whose orthogonal complement is the sheet-sign line.

The concrete B3/H3 leaves freeze only the ranks `6/10` on each sheet restriction, second-moment
ranks/radicals `5/1` and `9/1`, and the two distinct radical levels.  C430's exact certificate and
independent row-reduction replay provide the source data.  In H3 the two-dimensional affine-pairing
radical is additionally the sum of the two C412 `P(1)` socles; its outer-odd line is the sheet-sign
trade.  See `notes/2026-07-20-c430-conceptual-balanced-half-rigidity.md`.

The rest of F5 stays kernel-backed either way. Anti-invariance of the signed cubic reduces, via the
abstract index-two theorem, to the permutation action on the 22 quotient vectors plus sheet parity
(no 220-dimensional linear algebra); `mu_3 != 0` needs one nonzero coordinate. Add the abstract
index-two action theorem and separate concrete B3/H3 permutation-action leaves that instantiate the
supplied `PGL_2/PSL_2` hypotheses and anti-invariance. Only then conclude that the nonzero signed
cubic is fixed by `PSL_2(q)`, negated by the outer coset, and has stabilizer `PSL_2(q)` inside the
certified action. Derive the plane syzygies by expanding `P_M=P_0+Q Phi_M`.

**Exit:** paper-facing reconstruction/orientation theorem with balanced-half uniqueness carried by
the symbolic C430 lemma and the bounded B3/H3 rank/radical leaves. Do not formalize the false
uniqueness, Hessian, contraction, singular-locus, or linear cubic-to-Fourier claims.

### C425 / F6 — C411 double-coset and H3 depth--Fourier--parent bridge

Create a definitions-only concrete `G=PGL_2(11)`, `H=A5`, `K=A4` permutation-action base. Add a
subgroup-mark leaf, the six representative incidence rows sharded across a positive-sheet and a
negative-sheet leaf (`ClebschDoubleCosetDepthPositive`, `ClebschDoubleCosetDepthNegative`), and a
light aggregator. Formalize the group-action seam deriving `1+4+6` on each sheet, the six double
cosets, `K`-invariance and `J`-antipodality, and the abstract three-profile cubic-first pushforward.
State the mixed `K`--`H` matrix-coefficient interpretation only at the needed level: six-dimensional
double-coset domain, rank-two image, four-dimensional kernel, and set-theoretic separation. Do not
build general modular Hecke theory.

The equivariance content must be a theorem, not a definition. Do not freeze the six signed profile
vectors as the only data: freezing them makes `D(JM)=-D(M)` and `K`-orbit constancy true by
construction, so the leaf would silently trust the generator for exactly the geometry it exists to
certify. Instead freeze the six representative secant unions, the sixteen relation cells, and the
`K`/`J` generators as data; prove in-kernel that the cells partition the relevant projective sets,
are scalar-closed and `K`-invariant, and that recounting reproduces the profiles
`+/-v_1,+/-v_2,+/-v_3` with fibre sizes `1,4,6 / 1,4,6`, the two plane equations, and
`v_1+4v_2+6v_3=0`; prove that `J` carries each representative's secant union to its mate's; then
*derive* `D(JM)=-D(M)` from that geometry. Compose with the existing odd-Fourier and matching
leaves, and show that a singleton profile recovers the unordered golden matching pair; a chosen
singleton matching then invokes
`RelativeConicArcs.ClebschGateway.Q11Matching.decorated_child_recovers_parent`.

Optional non-gating strengthenings, absorbed only if free: state the cubic-first pushforward at all
degrees `k` via the compressed-moment parity identity (one induction on the same three-term
relation, strictly stronger than the degree-`<=3` statement); and add the elementary lemma that
`v_1+4v_2+6v_3=0` is the unique primitive integral dependence, so the unlabeled three-ray profile
recovers the orbit sizes `1,4,6` and stabilizer orders `12,3,2`.

**Exit:** the complete conceptual C411 theorem and C406 -> C378 -> C379 arrow; six representatives
replace a 22-row proof, with the sign law derived from frozen geometry rather than frozen. No spine
gate yet.

### C426 / F7 — q=11 rank-eight Fourier self-duality

Formalize C372's scalar-line character sum and connect the frozen hyperplane-count/eigenmatrix leaf
to `P=Q`, multiplicity--valency equality, and Fourier self-duality; `P=Q` and `P^2=1331 I` are
kernel-feasible directly from the frozen class data (eight dual representatives against 133
projective lines). The intersection/Krein equality additionally needs the full intersection tensor
(the 512 numbers `p^k_ij`), which no existing leaf supplies and which sits at the top of the
measured kernel scale. Prescribe the compact primitivity
certificate: for each of the 126 proper nonempty unions of nonidentity classes, one witness pair
`(x,y)` in the union with `x+y` outside it — this makes primitivity a definite in-kernel yes. The
877-partition fusion census is independent of the definite F7 gate; do not infer separability.

The final trust routes are not a discretionary “if feasible” label. The scalar-line sum, `P=Q`,
`P^2=1331 I`, multiplicity--valency equality, Fourier self-duality, and the 126-witness primitivity
certificate are mandatory full-trust Lean exits. The intersection/Krein equality is exact
replay/certificate-backed by default. It upgrades to full-trust Lean only if an explicit
`ClebschSchemeIntersectionTensor` leaf, checker soundness theorem, gate import, and clean axiom
audit actually land. Likewise, the 877-fusion census remains exact replay/certificate-backed and
outside the F7 gate unless its separate checker leaf lands. A conditional Lean implication from an
assumed tensor is recorded as conditional, not as a Lean proof of the tensor. The internal ledger
may cite C372 as provenance; Lean source must describe the mathematics and artifacts without that
task identifier.

**Exit:** a dedicated q=11 Fourier-scheme gate, separate from the chirality endpoint, with the
mandatory kernel core above and separate ledger rows for the Krein equality and fusion census.

### C427 / F8 — q=11 intrinsic chirality and replacement-spine gate

Formalize only the committed C373 result, not new C207/outside-`S5` research: intrinsic recovery of
the six scalar-line blocks, their two ten-element three-subset orbits, and the unordered chirality
torsor. Supply either the compact affine-rigidity proof or a sound completeness-certificate theorem
for the full color-preserving automorphism/no-outer-lift claims; keep the verification boundary
explicit if the finite completeness check remains external. For the order-60 projective stabilizer
`Stab(hexagon)=A5`, the intended kernel route is the frame-transport bound: a stabilizing
projectivity permutes the six arc points and is determined by its action on any four of them (an
ordered four-point frame), so at most `6*5*4*3 = 360` candidate projectivities are checked, never an
enumeration of `PGL_3(11)`. Keep the
equitable-refinement bound `|Aut(X)| <= 1331*60*10` over the 1331-vertex edge-colored graph
external, with its declared trust boundary. Reuse the existing abstract two-sheet character theorem.

Record in the verification-map delta that spine clause 4's rank-16 statements are only partially
kernel-backed: `M_odd^2 = 1331 I_4` and the four exchanged pairs are formal (existing leaf), while
`P_16^2 = 1331 I`, the full rank-16 eigenmatrix, and minimality of the common coherent refinement
remain certificate-backed and are not brought in-kernel by any F1--F8 terminal.

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
| C421 / F2 | `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean`; `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | `notes/2026-07-20-c421-clebsch-conic-matching-quotient-lean.md`; no generated data expected | imports the existing conic API; exits through exact secant/list pullbacks, four-point switch/divisibility, generic rank-one augmentation kernel, pointwise factor and boundary-form identities, arbitrary-size switch reversibility, and `Fin 4` connectivity; no geometric restriction-map bridge, matching count/switch span, word weight, full-product boundary bridge, or general-`2n` connectivity |
| C422 / F3 | `lean/RelativeConicArcs/ClebschHarmonicQuotient.lean`; `lean/RelativeConicArcs/Gates/ClebschHarmonicQuotient.lean`; `lean/RelativeConicArcs/Gates/ClebschHarmonicQuotientAxiomAudit.lean` | `notes/2026-07-20-c422-clebsch-harmonic-quotient-lean.md`; no generated data expected | imports F2; exits through degree-one harmonicity, the degree `2/4` `F_5/F_7/F_11` Laplacian decompositions and dimensions, and the exact four-endpoint switch-radial bridge; no switch-span or quotient-isomorphism claim |
| C423 / F4 | `lean/RelativeConicArcs/ClebschFactorizationData.lean`; separate `lean/RelativeConicArcs/ClebschFactorizationA3.lean`, `ClebschFactorizationB3.lean`, and `ClebschFactorizationH3.lean` leaves; `lean/RelativeConicArcs/Gates/ClebschFactorization.lean` | `notes/2026-07-20-c423-clebsch-factorization-leaves-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F3 and newly generated data from the frozen C406 coordinates; exits through ranks `3/6/10`, lower-moment cancellation, and nonzero B3/H3 cubic |
| C424 / F5 | `lean/RelativeConicArcs/ClebschBalancedSheets.lean`; `lean/RelativeConicArcs/ClebschBalancedSheetsB3.lean`; `lean/RelativeConicArcs/ClebschBalancedSheetsH3.lean`; `lean/RelativeConicArcs/Gates/ClebschBalancedSheets.lean` | `notes/2026-07-20-c424-clebsch-balanced-sheets-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F1/F4; exits through C430 radical--Hadamard balanced-half rigidity with B3/H3 rank/radical leaves, abstract index-two sign theorem, concrete anti-invariance/stabilizer, and plane syzygies |
| C425 / F6 | `lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthBase.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthPositive.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepthNegative.lean`; `lean/RelativeConicArcs/ClebschDoubleCosetDepth.lean`; `lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean` | `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F1/F5 plus `RelativeConicArcs.ClebschGatewayQ11Fusion` and `RelativeConicArcs.ClebschGatewayQ11Matching`; exits through `1,4,6 / 1,4,6`, six profiles, rank-two plane, cubic pushforward, odd-Fourier sign, and decorated parent recovery |
| C426 / F7 | `lean/RelativeConicArcs/ClebschSchemeFourierData.lean`; `lean/RelativeConicArcs/ClebschSchemeFourier.lean`; optional `lean/RelativeConicArcs/ClebschSchemeIntersectionTensor.lean`; `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean` | `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.md`, `.py`, `.json`, and `.sha256` with that same stem; generated mathematical data use stable semantic provenance without task IDs in Lean | imports existing `RelativeConicArcs.ClebschGatewayA5FourierPhase`; mandatory full-trust exits are the scalar-line sum, `P=Q`, `P²=1331I`, multiplicity--valency equality, Fourier self-duality, and primitivity; intersection/Krein equality and the separate 877-fusion census remain exact external certificates unless their own checker leaves actually land |
| C427 / F8 | `lean/RelativeConicArcs/ClebschSchemeChiralityData.lean`; `lean/RelativeConicArcs/ClebschSchemeChirality.lean`; `lean/RelativeConicArcs/Gates/ClebschReplacementSpine.lean` | `notes/2026-07-20-c427-clebsch-scheme-chirality-lean.md`, `.py`, `.json`, and `.sha256` with that same stem | imports F6/F7 and existing `RelativeConicArcs.Gates.ClebschGateway`; exits through six intrinsic blocks, unordered `10+10`, full/no-outer-lift evidence at its declared trust boundary, and the replacement-spine aggregate |
| C428 / F9 | `lean/RelativeConicArcs/ArrangementWeightedAdjoint.lean`; `lean/RelativeConicArcs/ClebschWeightedAdjointB3.lean`; `lean/RelativeConicArcs/Gates/ClebschWeightedAdjoint.lean` | `notes/2026-07-20-c428-clebsch-weighted-adjoint-lean.md`; add same-stem `.py/.json/.sha256` only for the B3 leaf | imports F2, existing `RelativeConicArcs.ClebschGatewayCoxeterPhase`, and C222's committed `RelativeConicArcs.ReflectionArrangementDecoding` terminal; exits through weighted depth, punctured enumerator, Hamming/distance theorem, and all three C399 specializations |

Every shorthand gate above is under `lean/RelativeConicArcs/Gates/`. Generated data modules are
definitions-only; transport and paper theorems live downstream. If implementation discovers that a
named leaf cannot satisfy the measured `single` profile, the task stops with a revised sharding
plan before generation.

## Campaign trust-ledger capstone — C320

C320 is a required successor to all paper-adopted C420--C428 slices, not optional housekeeping. It
creates the Clebsch per-paper trust manifest and one verify-all entry point. The campaign and
manuscript release gate remain open until that ledger is complete and independently reviewed.

The ledger has one row per published claim, including separately stated subclaims. Each row records:

- the exact paper statement and adequacy correspondence;
- the final trust route: full-trust Lean, exact replay/certificate, conceptual proof with named
  classical inputs, or an explicitly decomposed combination;
- every fully qualified Lean terminal, import-only gate, exact commit, and `#print axioms` result;
- every checker soundness theorem, generator/schema/data/hash, independent replay, finite domain,
  and residual trusted boundary;
- every cited or axiomatized mathematical input and what remains unconditional without it;
- optional, failed, conditional, or deliberately external clauses that must not inherit a Lean
  label; and
- the exact verify-all command or durable entry point that checks the claimed route.

Each C420--C428 task document must end with its own copied closing-review checklist and a proposed
ledger delta. C320 reconciles those deltas against the actual gates; it does not infer trust from a
task verdict, module name, or aggregate import.

For every C420--C428 task, completion and archival occur only after this exact sequence: finish the
artifact and durable report; complete the local checklist and proposed ledger delta; explicitly
request an independent referee-style review; record its findings and `GO`/`NO-GO`; fix every issue
or narrow the claimed exit; request post-fix review; and obtain a recorded final `GO`. Keep the live
queue row until that sequence is complete. A green build, axiom audit, implementer self-review, or
initial `GO` followed by further changes does not by itself authorize archival.

The user owns reviewer launch. An implementing agent, including Opus, must not spawn, delegate to,
choose, simulate, or stand in for the independent reviewer. When its artifact/report/checklist and
ledger delta are ready, it stops and tells the user to launch Codex for review. After addressing
findings, it stops again and asks the user to launch Codex for post-fix review. Only a user-launched
review and recorded final `GO` satisfy the archival gate.

The path named for each task's evidence report is also its cold-read task specification while
queued. It must be self-contained: exact owned files, permitted imports, mathematical obligations,
fixed trust routes and fallbacks, exclusions, stop conditions, validation, and closing review all
appear locally rather than only by reference to this campaign plan. During execution it becomes the
durable result report. It records every judgment call with the options considered, evidence,
theorem/trust impact, rejected alternatives, and reopening condition. A later reviewer must be able
to answer scope and trust questions from that report plus the Lean artifact without reconstructing
an agent conversation.

## Dependency and dispatch order

```text
C222 (existing) -------------------------------> F9
F1 -------------------------> F5 ----\
F2 -> F3 -> F4 ------------> F5 -----+-> F6 -> F8 [spine gate]   (F7 joins F8 independently)
F1 -------------------------------> F6 -/
existing C378/C379/C380 -----------------------> F6/F8
existing C398/C399/C400 --------------> F7 -> F8; and -> F9
C222 + F2 -------------------------------------> F9 [separate gate]
```

Dispatch is serial at the dependency level but permits bounded parallel work after foundations:
F1 and F2 may proceed independently; after F2, F3 may proceed while F1 finishes. F7 depends only on
the existing `ClebschGatewayA5FourierPhase` terminal, not on F1--F6, so any serialization of F7
after F6 in the build queue is dispatch-order only; F7 may run in parallel with the whole F1--F6
chain, and only F8 logically consumes both F6 and F7. Heavy finite leaves remain serialized through
the shared build-owner queue. No worker receives a broad umbrella target until its leaves are
individually trace-current.

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
- Each task completes the review checklist copied into its own task document, records the
  independent review disposition, and supplies its claim-by-claim C320 ledger delta. A task cannot
  close on “if feasible,” “standard,” or “follows” language: every such clause must finish with a
  concrete trust route or be removed from the claimed exit.
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

A subsequent Fable review (`notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`) found
no blocking defect and drove the revisions folded in above: the original F5 balanced-half
verification route (subsequently replaced by C430's symbolic radical--Hadamard theorem), the F6
derived-not-frozen sign-law obligation, the F7 intersection-tensor scoping and 126-pair primitivity
certificate, the F8 frame-transport stabilizer bound and rank-16 verification-map note, the F6->F7
dispatch-order clarification, and the F1 `Moments` namespace check. The two documentation errors it
caught — the spine's biplane-vs-design wording and the C378 `J`-fixed relation count — are corrected
at their sources, not here.
