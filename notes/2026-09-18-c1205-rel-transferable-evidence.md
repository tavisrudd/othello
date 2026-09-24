# C1205 — transferable evidence for the Rel route

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: IN PROGRESS (allocated by Tavis, 2026-09-18, from the C1204 review's first recommendation).
Milestone a done, audited and repaired 2026-09-22 (core `a92050a`, `c73ed85`; report
`notes/2026-09-22-c1205-rel-transferable-evidence-report.md`, audit
`notes/2026-09-22-c1205-milestone-a-audit.md`). Milestone b decides `Demand::prepared_encoding`'s
return type (today `Error::Schema` on a wire plan; the audit recommends a typed return).

## Goal

An accepted stratified Rel result becomes an object a second party can check without the process
that produced it. Today the driver builds each layer's certificates, checks them and drops them;
on the prepared route the checker reads the producer's own admitted object and no serialized form
of a prepared source exists; the construction records are re-checked by the code that built them;
externally supplied facts are neither validated nor recorded.

Source of the findings, with citations and consequences:
`notes/2026-09-18-c1204-datalog-rel-architecture-review-report.md` (evidence findings A, B, D, and
M for the dead wire backend), backed by
`notes/2026-09-18-c1204-review-half1-frontend-lowering-driver.md` (F1, F2, F3, F5, F9, F10, F16)
and `notes/2026-09-18-c1204-review-half2-contract-evaluator-checkers.md` (F1, F11, F17).

## Scope

### Milestone a — core: a byte-level door for the prepared route

Runs after C1209 (contract crate split, Tavis 2026-09-21): the encoder, the decoder and the source
enum's contract half land in the contract crate; the checker entry points land in `ergodis-verify`.
C1209 and this milestone are complete. C1213 owns the approved subsequent Datalog
schema/provenance migration; it must start from the delivered byte interface rather than
redo this milestone. The preservation acceptance below records this milestone's original
baseline; later migrations must identify their own deliberate changes. Existing prepared
source identities remain a preservation requirement.

- Factor the canonical encoding that `datalog::admit_prepared` already streams into SHA-256 into
  an encoder and a decoder for a prepared source, so the prepared identity is recomputable from
  bytes; the identity of every existing prepared source must not change.
- Give both checkers an entry point that admits those bytes for itself, so the prepared route has
  the same re-admission the wire route has. `check_admitted` stays as the documented in-process
  fast path.
- Replace the `Option<Program>` mode flag in `Demand` with an explicit source enum whose variants
  name the verification regime; bound the two certificate decoders' input.
- Tests live in the checker crate and include certificates the producer cannot emit.

### Milestone b — private: a stratified result that stands on its own

- `LayerReport` (or a successor record) carries, per layer: the prepared source identity, the
  declared relations with arity and input flag, digests of both certificates, the mapping from each
  negated, compared or aggregated literal to the declared relation that replaced it, and a digest
  per seeded input relation. The declared set is deliberately a superset of what the layer's
  rules read (a relation whose own layer this is gets declared even when no rule reads it, which
  a fact-only layer zero depends on), so name the field for what it is, not "relations read".
  Decide and record whether the certificates and the encoded layer
  source themselves are retained, returned on request, or written by the tool.
- Record digests get domain separation (schema tag, record kind, relation, arity) before anything
  durable stores one.
- `Externals`: an unknown relation name and a tuple whose length is not the arity are errors; the
  seeded names are recorded.
- The record check runs inside `evaluate`, or checked and unchecked results are distinct types; a
  bench receipt cannot record a run whose record check failed. Errors name the record kind, index
  and failing field; `CheckersDisagree` names the relation and first differing tuple.
- The record fields currently written and never checked (`ComplementRecord.source`,
  `FilterRecord.literal`, `FilterRecord.operator`) are checked against the recorded layer program.
- An offline verifier (library function plus an `ergodis-tools` subcommand) that takes the
  recorded chain and re-checks it end to end with no `Demand` in the process: each layer's bytes
  re-admitted, both certificates checked, each construction rebuilt from the previous layer's
  checked relations, each layer's inputs shown to be those relations.

### Milestone c — one backend route

- Replace `rel_lowering::project` with a wire export built from the per-layer assembly the driver
  already does, so an exported program is by construction the one that ran; the fragment check
  lives in one place. Refresh ADR 0004 and the lowering architecture note to describe the code as
  it stands. The refresh also records two things that today are written nowhere but source
  comments (C1208 triage): the inventory of identities on the Rel route and which binds which, and
  the exactness argument for per-column complement domains (now only in the `rel_stratified`
  module header). An export under the n-ary body policy is admitted by the Datalog admission only,
  never by the grounded one; both checkers admit through the Datalog door, so it is checkable.

## Milestone b construction-verifier decision

Tavis accepted the separately written construction rebuild on 2026-09-24. Promote the reference
evaluator's set-based route out of the test tree for the offline verifier. The core checkers cannot
see these constructions, so the builder's own replay does not establish their correctness. Keep
the reconstruction independent of `Demand` and the producing driver. Milestones a and c do not
depend on this choice.

## Acceptance

- A stratified result with negation, a comparison and an aggregate is written to disk by one
  process and accepted by the offline verifier in another; every single-field mutation of the
  chain (a layer identity, a certificate digest, a literal mapping, an input digest, a record
  field, a certificate entry) is rejected with an error naming what failed.
- Prepared identities, the parity digest, plan fingerprints and the C1189 differential are
  unmoved; the wire route's identities and certificates are byte-identical.
- The derivation loop and the frontend/backend stages hold against the retained controls named in
  the lane handoff (re-retain first, as the handoff says); evidence retention must not enter the
  hot loop. Performance rules: `~/src/ergodis-dev/PERFORMANCE.md` and the playbook.
- Source comments follow the professional-comment standard: no task IDs, notes paths or process
  narrative.
- Independent read-only audit by a fresh Opus sub before close.

## Out of scope

An independent completeness pass for one checker and the wider checker-crate mutation suite; the
contract-crate split; a separate schema string for the Datalog language; an ABI for the Datalog
path; certificate encodings (C1196, which should build on milestone a's byte form); structured
refusals. Allocated owners: C1214 checker tests/independent completeness; completed C1209
contract split; C1213 schema/provenance; C1216 ABI; C1196 encodings; C1206 refusals.

## Deliverables

- Dated report `notes/<date>-c1205-rel-transferable-evidence-report.md`, written incrementally,
  one section per milestone, with the audit beside it.
- Lifecycle close per `notes/task-lifecycle-conventions.md`.
