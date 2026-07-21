# C423 / F4 — Lean Clebsch factorization leaves

**Lane:** `clebsch`

**Status:** complete; independent post-fix review `GO` 2026-07-21

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

Land separate A3, B3, and H3 checker leaves proving image ranks `3,6,10`, the required lower signed
moment cancellations, and the nonzero B3/H3 cubic witnesses. Each paper claim is full-trust Lean
only when untrusted literal data are connected to it by a proved checker, the generated evidence
bundle and independent replay land atomically, and the light gate and axiom audit pass. A leaf that
cannot meet the measured profile stops for a revised sharding plan; it is not silently downgraded
inside this task.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschFactorizationData.lean`, the separate
  `ClebschFactorizationA3.lean`, `ClebschFactorizationB3.lean`, and
  `ClebschFactorizationH3.lean` leaves, `lean/RelativeConicArcs/Gates/ClebschFactorization.lean`,
  and the same-stem `.md/.py/.json/.sha256` evidence bundle in `notes/`.
- Import C422's committed harmonic-quotient API. Freeze the audited C406 quotient coordinates as
  untrusted literal input; do not freeze rank, vanishing, nonvanishing, character, or orbit
  conclusions as definitions.
- Prove image ranks `3`, `6`, and `10`. For B3 and H3 prove signed first- and second-moment
  vanishing and a nonzero cubic witness. Certify the cubic by one explicitly named linear
  functional and the scalar sum over 14 or 22 matchings, not a full symmetric-tensor equality.
- Split H3 from A3/B3 at a module boundary. The base/data module contains definitions only; each
  leaf invokes a small generic predicate and soundness theorem; the aggregator is light.
- The generator output is canonical and deterministic and records semantics, schema, hashes, byte
  counts, exact replay command, and an independent implementation or invariant check. A hash proves
  identity only; the Lean checker proves the accepted proposition.
- Benchmark one representative shard before generating a tree. If the `single` profile fails, stop
  with measured evidence and a revised sharding proposal; do not hand-edit generated leaves,
  silently move a required claim outside Lean, or touch Q25/certificate closures owned elsewhere.
- Exit only through `RelativeConicArcs.Gates.ClebschFactorization` after all three leaves are green
  and the exact terminal axiom audit is recorded here.

## Result

The three sharded leaves are implemented.  Their literal inputs are the factorization-difference
quotient vectors reconstructed from the frozen C406 matching orbit and secant-product conventions,
then transported by an invertible coordinate change so selected columns are the standard basis.
Lean checks those basis columns, derives the three image dimensions, checks the signed first and
second moments for B3/H3, and evaluates one named cubic coordinate in each case:

| type | field | points | quotient coordinates | image dimension | sheet sign | signed cubic witness |
|:--|--:|--:|--:|--:|:--|:--|
| A3 | `𝔽₅` | 5 | 3 | 3 | not applicable | not applicable |
| B3 | `𝔽₇` | 14 | 6 | 6 | two PSL₂ orbits of size 7 | `Σ ε(v) v₀³ = 2 ≠ 0` |
| H3 | `𝔽₁₁` | 22 | 10 | 10 | two PSL₂ orbits of size 11 | `Σ ε(v) v₀³ = 3 ≠ 0` |

For B3 and H3, Lean also proves `Σ ε(v)v = 0` and
`Σ ε(v)v_i v_j = 0` for every ordered coordinate pair `(i,j)`.  Thus the displayed coordinate
functional proves that the signed cubic tensor is nonzero without freezing or checking every
symmetric-cube coordinate.

The final route is deliberately decomposed.  Kernel-checked Lean proves the rank and moment claims
for the literal arrays.  The deterministic Python reconstruction and its invariant check bind those
arrays to the audited C406 quotient-coordinate convention.  Accordingly C320 should describe the
configuration arithmetic as full-trust Lean and the geometric identity of the frozen coordinates
as exact replay input, rather than claiming that Lean recomputes the secant products or PSL₂ orbits.

## Ordinary mathematical exits and exact Lean terminals

Let `V_T` be the displayed finite family of quotient-image coordinate vectors and let
`L_T : 𝔽_q^{|V_T|} → 𝔽_q^{r_T}` send a coefficient family to the corresponding linear
combination of the vectors.

1. **A3 rank.**  For the five displayed vectors over `𝔽₅`, `dim(im L_A3)=3`.
   Terminal:
   `RelativeConicArcs.ClebschFactorization.a3_factorizationImage_finrank`, with type
   `Module.finrank (ZMod 5) (LinearMap.range (configurationMap a3Vectors)) = 3`.
2. **B3 rank.**  For the fourteen displayed vectors over `𝔽₇`, `dim(im L_B3)=6`.
   Terminal:
   `RelativeConicArcs.ClebschFactorization.b3_factorizationImage_finrank`, with the analogous
   type over `ZMod 7` and right-hand side `6`.
3. **H3 rank.**  For the twenty-two displayed vectors over `𝔽₁₁`, `dim(im L_H3)=10`.
   Terminal:
   `RelativeConicArcs.ClebschFactorization.h3_factorizationImage_finrank`, with the analogous
   type over `ZMod 11` and right-hand side `10`.
4. **B3 lower moments.**  With the literal `±1` sheet sign,
   `Σ ε(v)v=0` and `Σ ε(v)v_i v_j=0` for all ordered `(i,j)`.
   Terminals: `b3_signedFirstMoment_eq_zero` and `b3_signedSecondMoment_eq_zero` in the same
   namespace.
5. **B3 cubic.**  `Σ ε(v)v₀³=2` in `𝔽₇`, hence this scalar and the signed cubic tensor are
   nonzero.  Terminals: `b3_signedCubicCoordinate_zero_zero_zero` and
   `b3_signedCubicCoordinate_ne_zero`.
6. **H3 lower moments.**  With the literal `±1` sheet sign,
   `Σ ε(v)v=0` and `Σ ε(v)v_i v_j=0` for all ordered `(i,j)`.
   Terminals: `h3_signedFirstMoment_eq_zero` and `h3_signedSecondMoment_eq_zero`.
7. **H3 cubic.**  `Σ ε(v)v₀³=3` in `𝔽₁₁`, hence this scalar and the signed cubic tensor are
   nonzero.  Terminals: `h3_signedCubicCoordinate_zero_zero_zero` and
   `h3_signedCubicCoordinate_ne_zero`.

The finite checker predicates are
`HasCoordinateBasis` and `ChecksSignedMomentWitness`.  The rank leaves prove that a checked set of
standard-basis columns makes `configurationMap` surjective, then compute the range finrank.  The
B3/H3 leaves use a separate predicate instance and soundness projection for the two vanishings and
the nonzero named cubic value.  Neither rank nor a moment conclusion occurs in a data definition.

## Owned artifacts and reproducibility

Owned Lean files:

- `lean/RelativeConicArcs/ClebschFactorizationData.lean` — definitions and untrusted literals only;
- `lean/RelativeConicArcs/ClebschFactorizationA3.lean`;
- `lean/RelativeConicArcs/ClebschFactorizationB3.lean`;
- `lean/RelativeConicArcs/ClebschFactorizationH3.lean`; and
- import-only gate `lean/RelativeConicArcs/Gates/ClebschFactorization.lean`;
- reproducible statement/axiom harness
  `lean/RelativeConicArcs/Gates/ClebschFactorizationAxiomAudit.lean`.

The evidence bundle is this report plus the same-stem `.py`, `.json`, and `.sha256` files.  From
`/home/tavis/src/othello`, replay it with:

```bash
python3 notes/2026-07-20-c423-clebsch-factorization-leaves-lean.py --check
sha256sum -c notes/2026-07-20-c423-clebsch-factorization-leaves-lean.sha256
```

Intentional JSON regeneration is:

```bash
python3 notes/2026-07-20-c423-clebsch-factorization-leaves-lean.py --write
```

The post-review schema is `clebsch-factorization-leaves-v2`; version 2 adds the mechanical
Lean-literal binding record.  Enumeration and serialization are deterministic:
matching orbits, PSL₂ sheets, monomial coordinates, point-basis columns, and JSON keys are sorted;
there is no random seed or timestamp.  The primary reconstruction consumes the frozen
`2026-07-20-c406-matching-orbit-scout.json` (25,443 bytes, SHA-256
`fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246`) and
`2026-07-20-c406-matching-module.py` (48,589 bytes, SHA-256
`a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51`).

As an independent invariant check, the generator uses a second modular row-reduction
implementation, verifies every selected standard-basis column, recomputes all three ranks, directly
recomputes both lower signed power sums, and independently reevaluates the named cubic scalar.
Its `--check` path also parses all eight literal declarations in
`ClebschFactorizationData.lean`—the three vector arrays, three basis-column arrays, and two sheet-sign
arrays—and requires exact equality with the reconstructed JSON payload.  The canonical joined
payload hash is `355a0810a6fcf4b3f8c3bf68791b33f196a4d39e59eb85f8b2b3c6b1024afa02`.
This is exhaustive over all `5/14/22` displayed points and all `3/6/10` coordinates, not sampled or
searched evidence.  It does not independently reconstruct the upstream C406 endpoints or group
orbits; those pinned inputs remain the replay boundary.

The checksum manifest records the generator, JSON, all four Lean modules, the import gate, and the
audit harness.  Byte counts before the final report-only commit are `10,442`, `9,728`, `5,519`,
`2,552`, `4,658`, `4,670`, `366`, and `2,596`, respectively; the manifest is authoritative for
final hashes.

## Validation and axiom evidence

The mandated representative benchmark was H3, the largest shard.  Under profile `single`, the
final leaf build took 10.89 seconds and used 2,375,700 KiB maximum RSS.  The same queue built A3 in
16.96 seconds / 1,822,328 KiB and B3 in 5.73 seconds / 1,948,216 KiB.  The first aggregate attempt
correctly found that the new import gate itself had not yet been built; after building that exact
target, the trace-only aggregate passed.  The post-audit import-only source is trace-current and its
aggregate gate passed in
`/home/tavis/.cache/othello-lean-build/run-20260721-193555-3ac41388` (runner state `success`, exact
target skipped as trace-current, aggregate `gate-passed`).
The post-fix audit target and the unchanged import gate then passed in
`/home/tavis/.cache/othello-lean-build/run-20260721-194600-ab13d396`: the audit built in 6.49 seconds
at 1,796,344 KiB maximum RSS and the trace-only aggregate gate passed.

Commands:

```bash
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschFactorizationData \
  RelativeConicArcs.ClebschFactorizationA3 \
  RelativeConicArcs.ClebschFactorizationB3 \
  RelativeConicArcs.ClebschFactorizationH3 \
  --profile single --threads 1 \
  --serial-first RelativeConicArcs.ClebschFactorizationData \
  --aggregate RelativeConicArcs.Gates.ClebschFactorization --cores 20-23

lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschFactorization \
  --profile single --threads 1 \
  --aggregate RelativeConicArcs.Gates.ClebschFactorization --cores 20-23

lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschFactorizationAxiomAudit \
  --profile single --threads 1 \
  --aggregate RelativeConicArcs.Gates.ClebschFactorization --cores 20-23
```

The committed `RelativeConicArcs.Gates.ClebschFactorizationAxiomAudit` harness prints the exact
eleven claim types and audits all sixteen public checker and claim terminals.
Every terminal reports exactly `[propext, Classical.choice, Quot.sound]`; none reports
`sorryAx`, `native_decide`, a project axiom, or non-kernel execution.  The main gate remains
import-only.  The successful build log contains eleven `#check` commands from the committed source
and sixteen C423 `depends on axioms` records.

Initial implementation commit: `21e9ce6a70858ad653fecdf2219a836fe845168f`.
Post-fix evidence commit: `da07d60d6769120a8a68767fd4af66b4256da7f9`.

## Trust and exclusion boundary

- The literal arrays, basis-column indices, and signs are data, not proofs.  Lean proves their
  displayed rank and moment properties by kernel reduction using `decide`; no `native_decide` is
  used.
- The Python replay establishes the arrays' exact correspondence to the audited C406 coordinate
  convention.  Lean does not reconstruct the projective endpoints, secant products, PGL₂/PSL₂
  groups, orbit membership, quotient division, or coordinate change.
- The formal rank is the rank of `configurationMap` on the displayed coordinate arrays.  The
  generator records the invertible normalization from the raw quotient monomial coordinates.
- The cubic result is one explicitly named linear functional of the symmetric cubic tensor.  It
  proves nonvanishing, not a full tensor equality or classification.
- The gate does not prove uniqueness of the balanced halves, recovery of the unordered sheets,
  the outer determinant-square character, a stabilizer theorem, harmonic/radial image equality,
  the C411 depth--Fourier bridge, parent recovery, or any novelty/priority statement.
- A3 has no two-sheet signed-moment assertion: its five markers form one PSL₂ orbit in the audited
  input.
- The task does not touch Q25 or any certificate closure outside the listed Clebsch paths.

## Judgment-call record

### Coordinate representation

- **Question:** retain raw degree-`1/2/4` monomial coordinates or transport each image to an intrinsic
  `3/6/10` coordinate space?
- **Options:** raw `3/6/15` coordinates with a row-reduction checker; normalized image coordinates
  with checked standard-basis columns; or freeze a claimed rank.
- **Choice and evidence:** normalized image coordinates.  The generator derives pivot monomials and
  an invertible point-basis matrix, independently recomputes rank, and verifies the selected columns
  are standard.  H3 then passed the representative `single` profile.
- **Effect:** theorem statements concern an explicitly invertibly transported quotient image;
  rank is proved, not frozen.  Imports and the gate stay small.  The paper claim is a
  Lean-plus-replay combination because the transport provenance is external.
- **Rejected:** raw H3 coordinates add five unused ambient directions and a larger checker;
  freezing `3/6/10` would violate the brief.
- **Reopen if:** a reviewer requires Lean to certify the raw-to-normalized matrix or C320 adopts a
  raw-coordinate statement verbatim.

### Cubic certificate

- **Question:** check the full symmetric cube or one functional?
- **Options:** all `56/220` symmetric coordinates, one nonzero coordinate, or an external cubic
  claim.
- **Choice and evidence:** the lexicographically first nonzero normalized coordinate, `x₀³`, whose
  exact values are `2` and `3`.  This is precisely sufficient for nonvanishing and follows the task
  brief.
- **Effect:** full-trust Lean proves the scalar sums and their nonzero consequences; no stronger
  tensor identity enters the gate.
- **Rejected:** full tensors enlarge data and elaboration without strengthening the required exit;
  external-only evidence would unnecessarily weaken it.
- **Reopen if:** a downstream formal theorem consumes actual cubic coordinates rather than mere
  nonvanishing.

### Checker and sharding shape

- **Question:** place generic soundness in the base, share it through one leaf, or duplicate a small
  proof in each independent leaf?
- **Options:** theorem-bearing base; transitive A3/B3 dependency for H3; or definitions-only base
  with local soundness proofs.
- **Choice and evidence:** definitions-only base plus local soundness.  This preserves the requested
  H3 module boundary and keeps the aggregator import-only.  The largest shard measured below the
  `single` cap.
- **Effect:** a few lines of rank proof are duplicated, but no leaf imports another leaf and each
  trust closure is independently inspectable.
- **Rejected:** theorem-bearing data module violates the definitions-only boundary; importing B3
  into H3 couples their rebuilds.
- **Reopen if:** a separately owned stable generic finite-certificate library is introduced.

### Independent check

- **Question:** add a second same-stem replay program or use the permitted independent invariant
  check inside the generator?
- **Options:** second implementation file; independent row reduction and direct power sums in the
  required `.py`; or no cross-check.
- **Choice and evidence:** the independent invariant check in the generator, as explicitly allowed
  by the brief.  It shares only reconstructed vectors, not the primary row-reduction routine.
- **Effect:** one canonical `.py/.json/.sha256` bundle; the upstream geometric reconstruction remains
  a disclosed trusted boundary.
- **Rejected:** a second file falls outside the specified same-stem bundle and would duplicate the
  large upstream C406 reconstruction; no cross-check is inadmissible.
- **Reopen if:** review finds a shared-bug risk in orbit or quotient reconstruction material to a
  paper-facing claim.

No optional theorem was silently omitted or downgraded.  Uniqueness, group-character, and
depth--Fourier statements were excluded because they belong to later campaign items, not because a
checker failed.

## Proposed C320 ledger delta

| claim | exact terminal(s) | final route | finite/provenance boundary |
|:--|:--|:--|:--|
| A3 quotient image rank `3` | `a3_factorizationImage_finrank` | Lean + exact replay | literal 5×3 normalized C406 coordinates |
| B3 quotient image rank `6` | `b3_factorizationImage_finrank` | Lean + exact replay | literal 14×6 normalized C406 coordinates |
| H3 quotient image rank `10` | `h3_factorizationImage_finrank` | Lean + exact replay | literal 22×10 normalized C406 coordinates |
| B3 signed moments vanish in degrees 1 and 2 | `b3_signedFirstMoment_eq_zero`, `b3_signedSecondMoment_eq_zero` | Lean + exact replay | literal sheet signs and coordinates |
| B3 signed cubic is nonzero | `b3_signedCubicCoordinate_zero_zero_zero`, `b3_signedCubicCoordinate_ne_zero` | Lean + exact replay | named `x₀³` functional only |
| H3 signed moments vanish in degrees 1 and 2 | `h3_signedFirstMoment_eq_zero`, `h3_signedSecondMoment_eq_zero` | Lean + exact replay | literal sheet signs and coordinates |
| H3 signed cubic is nonzero | `h3_signedCubicCoordinate_zero_zero_zero`, `h3_signedCubicCoordinate_ne_zero` | Lean + exact replay | named `x₀³` functional only |

Verify-all entry-point delta: add
`RelativeConicArcs.Gates.ClebschFactorization` after the existing harmonic-quotient gate.  The gate
imports all three leaves.  C320 must retain the exact-replay provenance qualifier and must not use
this gate for balanced-half uniqueness, group-character, or depth--Fourier claims.

## Independent review record

The user explicitly launched the dedicated Codex reviewer `/root/c423_reviewer` on 2026-07-21.
Its initial verdict was **NO-GO** with two blocking evidence findings and no mathematical,
naming/prose, exclusion, judgment-call, or ledger-scope objection.

1. **Lean-literal provenance was not mechanically bound.**  The initial generator reconstructed the
   JSON but neither generated nor parsed `ClebschFactorizationData.lean`; the checksum manifest
   established only separate identities.  **Disposition:** fixed.  The generator now parses and
   compares every vector, basis-column, and sign literal against its reconstructed payload during
   both `--write` and `--check`, records the eight declaration names, includes the Lean source hash
   as an input, and records the canonical payload hash.  A mismatch fails loudly.
2. **Statement adequacy and axiom evidence were transient.**  The initial report referred to
   temporary commands removed from the gate.  **Disposition:** fixed.  The new committed
   `RelativeConicArcs.Gates.ClebschFactorizationAxiomAudit` deterministically `#check`s all eleven
   claim terminals and `#print axioms` for all sixteen public checker/claim terminals while the main
   gate remains import-only.  It is in the checksum manifest and validation command set.

The same reviewer performed the post-fix review on 2026-07-21 and returned final **GO**.  It accepted
both dispositions, reran the replay and eight-entry checksum manifest, matched the committed audit
source to its saved eleven-type/sixteen-axiom output, confirmed the import-only aggregate gate, and
found no new mathematical, provenance, prose/naming, trust-boundary, validation, exclusion, or C320
ledger blocker.

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
