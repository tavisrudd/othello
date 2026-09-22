# C1208 — triage of the C1204 review findings: report

**Lane**: `ergodis`
**Date**: 2026-09-21
**Card**: `notes/2026-09-18-c1208-c1204-findings-triage.md`
**Sources**: the C1204 synthesis (`notes/2026-09-18-c1204-datalog-rel-architecture-review-report.md`,
"synthesis"), the private half (`notes/2026-09-18-c1204-review-half1-frontend-lowering-driver.md`,
"private") and the core half (`notes/2026-09-18-c1204-review-half2-contract-evaluator-checkers.md`,
"core").
**Code state**: core `96aee9b`, private `1500dc2`, dev `a60f03b`; all three clean and unchanged
since the review. Read-only; nothing under `ergodis*` was modified.
**Verification ledger** (one Opus sub, read-only, verbatim): `notes/2026-09-21-c1208-step2-code-verification.md`.
The main agent re-read two of its claims in the source (the wasm32 build of `ergodis-rules`, and
`scan_variant` not clearing the admission pools); both hold.

**Status**: COMPLETE 2026-09-22. Coverage, verification and folds were completed 2026-09-21;
Tavis approved the remaining decisions and allocations on 2026-09-22. C1210–C1218 now own
the nine remaining tasks; C1209 completed the split. The approved cleanup-first order and
post-split refinements are in `notes/2026-09-22-c1208-follow-up-triage.md`.
Sections 3–5 below retain the original proposal labels; the follow-up maps each to its owner.

## 1. Disposition table

One row per item of the three reports. Owner key: **C1205** transferable evidence, **C1206**
structured refusals, **C1207** error reporting audit, **C1194/C1195/C1196** the queued programme
cards; **bundle-core** / **bundle-private** the proposed small-repairs task (section 4);
**alloc-N** a proposed allocation (section 5); **decide-N** a question for Tavis (section 3).
"Fold" rows carry a card edit made in this commit (section 6).

### 1.1 Synthesis findings

| Item | Component findings | State before triage | Disposition |
|---|---|---|---|
| A — accepted result carries no evidence; prepared certificate checkable only in-process | core F1, private F1 | owned, C1205 milestones a and b | none needed |
| B — the rebuild replays the builder; three unchecked fields; check optional | private F2, F9 | owned, C1205 milestone b and its decision for Tavis | none needed |
| C — checkers share completeness pass, helpers, stores, admission | core F2 | unowned | restating the claim at its eight docstring sites: **bundle-core** and **bundle-private**; independent completeness pass: **alloc-2** milestone b |
| D — externals unvalidated and unrecorded | private F3 | owned, C1205 milestone b | none needed |
| E — no tests for the two Datalog checkers in the checker crate | core F7 | partly owned (C1205 milestone a tests its new door only) | **alloc-2** milestone a |
| F — C1194 is an evaluator, certificate and seam task | core F3, private F6 | unowned; the C1194 card assumes the existing min-plus certificate | **alloc-1** (design memo), **decide-1**; **fold** gate into C1194 |
| G — one payload-free `Budget`; no budget model | core F4, F5; private F12 | owned, C1206 | none needed |
| H — packed key fixes the dictionary at 65,536 entries | main-agent probe | unowned | **decide-2**, then **alloc-5**; **fold** into C1195 |
| I — join order has two owners | private F7 | unowned | **decide-3**; documentation part **bundle-private**; planner seam **dropped** until a planner task exists |
| J — constructor and entry-point accretion; driver options | core F9, private F8 | partly owned (C1205 milestone a takes the source enum) | **alloc-3** |
| K — no Lean coverage of the Datalog certificates | core F12 | unowned | statement shape inside **alloc-1**; formalization **alloc-6** |
| L — two admission languages, one schema string and identity | core F6 | unowned | **decide-4** (format change), then **alloc-4** |
| M — dead wire backend; documentation describes it | private F5 | owned, C1205 milestone c | none needed |
| N — contract types in the checker crate | core F15 | unowned | **decide-5** (validation-gate change), then **alloc-9** |
| O — measurement instrumentation in public API | core F8, private F14 | unowned; the core half is already an open question for Tavis in the handoff (C1192 paragraph) | **decide-6**; core half rides in **alloc-3**; frontend half waits for **alloc-7** |
| P — stage sequencing is a doc comment | private F4 | unowned; verification found it worse than reported | **bundle-private**, first item |
| Q — `Literal.reserved` double-booked; id newtypes | private F11, core F10 | unowned | named field and corrected docstring: **bundle-private**; API-boundary newtypes: optional milestone of **alloc-3** |
| R — workspace model assumes Unix lazy commit | core F14, F5 first sub-problem | unowned; refuted as framed | **decide-7** (a gate for the existing wasm32 build); the row-bound default on wasm rides with **alloc-8** |
| S — the Datalog path has no ABI | core F16 | unowned | **decide-8**, then **alloc-8**; **fold** dependency note into C1196 |
| Smaller: record digests lack domain separation | private F16 | owned, C1205 milestone b | none needed |
| Smaller: one `ComplementMismatch` for three record kinds | private F10 | owned, C1205 milestone b or C1206, whichever runs first | none needed |
| Smaller: reference evaluator's stated contract | private F13 | unowned | **bundle-private** |
| Smaller: certificate decoders unbounded | core F17 | owned, C1205 milestone a | none needed |
| Smaller: `fact_count` docstring | core unexplained 3 | unowned | **bundle-core** |
| Smaller: no result records its `BodyPolicy` | private unexplained 5 | unowned; partly refuted (`rel-lower` records it) | bench receipt field: **bundle-private**; per-layer record: **alloc-3** driver options |
| Arrow 1 — lowering and driver are siblings of the frontend (parity harness) | private map 1 | known, recorded in ADR 0004 | **alloc-7** (crate boundary), gated on C1205 milestone c |
| Arrow 2 — driver depends on `rel_lowering` for the decode map only | private map 3 | resolved by C1205 milestone c (the module ends as decode map plus export) | none needed |
| Arrow 3 — contract types in the checker crate | core F15 | same as N | **decide-5** |
| Arrow 4 — `ergodis-rules` depends on `ergodis-modules` for the provider only | core section 6 | unowned | **drop**: correct for the grounded ABI; revisit under alloc-8 |
| Mystery 1 — was the C1193 comparison affected by the missing ordering pass | private F7 | open | **settled**: not affected (section 2) |
| Mystery 2 — three route bounds share one value | private unexplained 1 | the sharing is explained in the docstrings; the magnitude is not | **fold** into C1206 (state what 2^22 was chosen against) |
| Mystery 3 — checker direct limit against evaluator ceiling | core unexplained 1 | **settled** by reading: different quantities, each derived in its docstring | C1206's budget statement cross-references the two; none further |
| Mystery 4 — no external engine has evaluated a Rel-lowered program | private section 4 | believed C1195's; the card did not say so | **fold** into C1195 |

### 1.2 Items the synthesis did not carry, or carried only in passing

| Item | Source | Disposition |
|---|---|---|
| Checker identity absent from Datalog certificates | core F13 | rides with **decide-4** / **alloc-4** (one format change) |
| No plan fingerprint in any certificate | core F13, identity inventory | **drop** as a certificate field (the verdict must not depend on the plan); the policy is recorded per layer by **alloc-3** |
| `Prepared` names two unrelated things | core F11, second half | **alloc-3** (one public type, about fifteen naming sites, mechanical) |
| Parity record omits three lowering counters | private F15 | **bundle-private**, with a schema bump (**decide-9**) |
| Complement membership vector makes `MAX_COMPLEMENT` a memory bound, paid twice | private unexplained 3 | **fold** into C1206 (docstring); shared scratch buffer **dropped** (four mebibytes) |
| Layer programs declare relations no rule of the layer reads | private unexplained 4 | **fold** into C1205 milestone b (name the record field for what it is) |
| `MAX_WORKSPACE_BYTES` has no derivation | core unexplained 2 | **fold** into C1206 |
| Two unrelated 64s (`Limits::disjuncts`, `chain`'s stack) | private unexplained 2 | **bundle-private** (named constant for the `chain` buffer; minutes) |
| `MAX_NAME` restated privately, unanchored | private F12 | owned, C1206 |
| Whole-`ergodis` dependency; no crate boundary around the Rel subsystem | private map 2, section 4 | **alloc-7** |
| Eight private-side identities, relationships written nowhere | private section 4 | **fold** into C1205 milestone c (documentation refresh) |
| Per-column complement-domain exactness argument lives only in a module header | private section 4 | **fold** into C1205 milestone c (ADR records it); a formal statement belongs with **alloc-6** |
| `Readout::decode` maps an unknown id to `"?"` | private seam table | **fold** into C1207's inventory |
| `MAX_BODY` split between the two admission doors | private section 5, question 4 | **settled**: both checkers admit through `datalog::admit`, so a four-atom body is checkable; the language split itself is L (**decide-4**); **fold** a note into C1205 milestone c |
| Certificate structs are indexed directly by the checkers; `premise_stride` floors at two; the wire route nothing produces | core section 6, private section 4 | **fold** into C1196 |
| The demand path has no incremental evaluation | core section 6 | **drop**: recorded observation, no queued consumer |
| Does any private report or ADR call the checkers independent | core section 7, question 2 | **settled**: no ADR does; the claim lives in eight source docstrings (ledger item 1) |
| Default row bound is `MAX_ROWS` for every plan | core F5, first sub-problem | rides with **alloc-8** (matters only where commit is eager) |
| `implementation_identity()` omits `support.rs` | ledger item 7 (new) | input to **decide-5** |

## 2. Verification notes

Detail and `file:line` evidence are in the ledger; this section records only what changes a
disposition.

1. **Refuted as framed — synthesis R (core F14).** `ergodis-rules` is built for
   `wasm32-unknown-unknown` today: the toolchain file installs the target, `docs/rule-contract.md`
   carries the build command and drives the C ABI through `crates/rules/tests/wasm_abi.mjs`, and
   `pages.rs` gates the `alloc_zeroed` branch on exactly that target. WASM as a target is already
   decided and implemented for the grounded path. What is missing is (a) a gate that runs that
   build, which today is a manual replay, and (b) a usable default row bound where commit is
   eager, which matters only once the Datalog path is reachable on WASM, that is, with an ABI.
2. **Worse than reported — synthesis P (private F4).** `scan_variant` clears tokens, nodes, frames
   and modules but not `definitions`, `module_nodes`, `symbols` or `owners`. A second `parse`
   followed by `lower` without `admit` indexes the new node pool with the previous source's node
   ids: a silent wrong answer, not only an unenforced precondition. No in-tree caller does it. The
   generation counter is three constant-time field operations outside every loop, so the stage
   contracts are untouched.
3. **Settled — mystery 1.** The C1193 headline cohorts (`triangle`, `path3`, `path4`, `closure`,
   `samegen`) and the Soufflé rows are hand-built contract programs in `closure_ballpark`; the
   lowering is not on that path. Only the `datalog` cohort goes through the lowering, where the
   residue is at most a tiebreak in core's greedy link order. The C1193 comparison can be cited.
4. **Settled — mystery 3**, and mystery 2 narrowed to "why 2^22" (ledger item 19).
5. **Partly — synthesis C.** Private ADR 0004 makes no independence claim. The restatement is eight
   docstrings: two in `derivation.rs`/`ranked.rs`, two in `demand.rs`, four in `rel_stratified.rs`.
6. **Partly — synthesis E.** `datalog.rs` and `datalog_store.rs` have inline tests; the gap is the
   two checkers. The checker crate has no Datalog fixture builder, so alloc-2 starts by moving or
   writing fixtures.
7. **Sized — synthesis H.** Days, not hours: `pack`, `tuple_key` and the stores already use the
   program's domain as the radix and nothing assumes sixteen bits; the cost is two admission doors,
   the saturating `universe`, the mirrored private constant with its `Budget::Domain` refusal, and
   a constants test that becomes an agreement-of-rules test. Reach under a per-arity rule: arity
   two about 2^32 (the `u32` value range), arity three about 2^21, arity four unchanged.
8. **Sized — synthesis L.** A new schema string moves every wire `source_id` (`identity_of`
   prefixes the schema), so every recorded wire certificate, about ten fixture files and two
   proptest regression seeds regenerate. `PREPARED_SCHEMA` is already separate.
9. **Addition — synthesis N.** `implementation_identity()` hashes eleven named files and omits
   `support.rs`; its one consumer is the binary-composition verification record. Every edit to
   `datalog.rs`, `rule_contract.rs`, `derivation.rs` or `ranked.rs`, a docstring included, moves
   it. C1205 milestone a, C1206 and bundle-core all make such edits, so the identity moves in the
   coming weeks whatever is decided about the split.
10. **Settled — `Literal.reserved`.** Its docstring is false at head (it says the field is outside
    the canonical form; `canonical_literal` writes it). Two named `u32` fields keep the asserted
    32-byte stride and the emission order, so canonical bytes, `CANONICAL_SCHEMA` and the parity
    digest do not move.
11. **Settled — crate boundary.** The parity harness compiles one file that `#[path]`-includes
    `src/rel_frontend/**`, all std-only; the core-dependent code is already confined to
    `rel_lowering.rs` and `rel_stratified.rs`. A two-crate split satisfies the harness with one
    retargeted path.
12. **Foreign, raised not fixed.** Task IDs, dates and decision narrative in private source
    comments: `tests/rel_lowering.rs:1256`, `src/rel_frontend/lower.rs:583` and `:598`,
    `tasks/tools/src/rel_frontend_bench.rs:124`. These belong to the private comment clean-up the
    handoff already lists as not yet run.

## 3. Decisions for Tavis

Each leads with the recommendation.

1. **C1194 precursor (finding F, K).** Recommend: allocate a design memo before any C1194 code —
   weighted `Demand` against a second kernel, what a min-plus relational certificate carries, and
   the statement (on paper) of the relational support argument for the Boolean case. Lean
   formalization is its own later task. Pro: both reviewers found C1194 unscopable without it; the
   C1194 card's "the certificate is the existing min-plus certificate" is wrong for the demand
   path. Con: a week before optimization-from-source moves.
2. **Domain ceiling (finding H).** Recommend: make the ceiling a function of the program's largest
   arity, before C1195 fixes cohort sizes. Pro: binary programs go from 65,536 distinct values to
   the `u32` range, and the Rel path's dictionary is every value in program and data. Con: days,
   two repositories, the refusal's payload changes (coordinate with C1206). Alternative: state
   65,536 as the suite's reach and cap cohorts.
3. **Join-order owner (finding I).** Recommend: core owns it; `Rule.order` is documented as the
   chain-shape hint; no `order_body` on the n-ary path; planner seam opens when a planner task
   exists. The C1193 comparison is sound, so nothing needs re-measuring.
4. **Schema string for the Datalog language, with the checker identity field (findings L, core
   F13).** Recommend: one format change, before C1195 freezes artifacts — a separate schema string
   for `datalog::admit`, and a checker identity field on both Datalog certificates; C1196 builds
   on the result. Pro: a `Program` then says which language it is in, and a certificate says which
   checker accepted it. Con: every wire `source_id` and recorded wire certificate regenerates.
   Alternative: a profile field under the existing schema (same invalidation, less clear).
5. **Contract crate split (finding N). DECIDED (Tavis, 2026-09-21): yes, split first.** Allocated
   as **C1209** (`notes/2026-09-21-c1209-contract-crate-split.md`), which carries one new question
   the split raises: admission is trust-relevant code the checkers' verdict depends on, so what the
   checker identity must still cover is a design-step decision there. Original recommendation:
   do it, and first — before C1205 milestone a —
   so the prepared encoder and decoder, the refusal record and the admission code land outside the
   checker identity from the start. Pro: the identity moves anyway under C1205/C1206, its one
   consumer is the binary-composition record, it already omits `support.rs`, and nothing is
   published. Con: days of mechanical moves ahead of the evidence work, and binary-composition
   receipts regenerate once. Alternative: after C1206, accepting that contract edits keep moving
   the checker identity until then.
6. **Instrumentation surface (finding O; also the open C1192 question in the handoff).** Recommend:
   an `instrument` feature in core holding the `Policy` corners, the counted entry point, the plan
   reports and `reservations()`, done inside alloc-3 where `Policy` leaves the product
   constructors. The frontend half waits for the crate boundary.
7. **WASM and the wasm32 build gate (finding R, re-aimed). DECIDED (Tavis, 2026-09-21): WASM is a
   target for the Datalog path.** Consequence: the documented `ergodis-rules` wasm32 build plus
   `wasm_abi.mjs` becomes a gated command, and the demand path needs a usable row bound where
   commit is eager; both ride in alloc-8.
8. **ABI (finding S). DECIDED (Tavis, 2026-09-21): there should be an ABI, and it should reach the
   private modules.** Read here as: the module ABI covers the Datalog path in core and the private
   Rel route (frontend, lowering, stratified driver) as a module, not core's demand evaluator
   alone. Sequenced after C1205 milestone a (the byte door is its prerequisite) and, for the
   private side, after the crate boundary question (alloc-7) is at least scoped, since the driver
   is today one module of the private library. C1196's portability bullet stands. Open inside
   alloc-8's card: whether the private Rel module is one provider (source in, certified relations
   and evidence chain out) or the frontend and the driver are separate providers.
9. **Two record-format bumps in the bundle.** Recommend: bump the parity record to
   `ergodis.rel_frontend_portability.v2` when the three counters are added (positional format,
   digest moves), and treat `body_policy` in the bench receipt as an additive field under `v1`.
10. **Bundle first item.** Recommend the stage-sequencing counter lands first and on its own
    commit, since verification found a silent wrong-answer path behind it.

## 4. Small-repairs bundle (proposed; one task, two halves that commit separately)

**Core half** (docstrings only; each moves `implementation_identity()`, so one commit):

| Item | Acceptance |
|---|---|
| Restate checker independence at `derivation.rs:209`, `ranked.rs:216`, `demand.rs:2759` and `:2772` | each site names what is shared (admission, stores, unification helpers, the closed-world pass) and what is independent (trace-following against search) |
| `DerivationCertificate::fact_count` docstring | states both routes, matching `Admitted::fact_count` |

**Private half:**

| Item | Acceptance |
|---|---|
| Stage-sequencing generation counter | `parse(a); admit(a); parse(b); lower(b)` is refused with a `REL05xx` code; a test pins it; allocation gate and stage A/B within the A/A null |
| `Literal.reserved` split into two named fields, docstring corrected | 32-byte stride assertion holds; canonical bytes, fingerprints and parity digest unmoved |
| Restate checker independence at the four `rel_stratified.rs` sites | same wording rule as the core half |
| `Rule.order` and `Rir::join_order` documented as the chain-shape hint (after decide-3) | docstrings match the code on both policies |
| Reference evaluator header | states the fragment it evaluates (comparisons and aggregates included) and that scanner, parser and admission are shared and invisible to the differential |
| `body_policy` in the bench receipt | field present, spelled as `rel-lower` spells it |
| Three lowering counters in the parity record | schema bumped per decide-9; new digest recorded |
| Named constant for `chain`'s order buffer | no behaviour change |

All source comments follow the professional-comment standard. Items C1206 touches in the same
docstrings (`MAX_COMPLEMENT`, `MAX_WORKSPACE_BYTES`) are folded there, not here.

## 5. Proposed allocations in expected-value order

No identifiers are reserved; each waits for section 3.

1. **alloc-1 — C1194 precursor design memo** (decide-1). Unblocks C1194, the optimization half of
   the programme goal. Week.
2. **Small-repairs bundle** (section 4). Hours; closes a silent wrong-answer path and stops the
   evidence claims reading wider than they are while C1205 is in progress.
3. **alloc-9 — contract crate split** (decide-5). **Allocated as C1209, 2026-09-21**, ahead of
   C1205 milestone a and C1206's core half. Days.
4. **alloc-5 — arity-dependent domain ceiling** (decide-2). Before C1195 fixes cohort sizes. Days.
5. **alloc-4 — Datalog schema string and checker identity field** (decide-4). Before C1195 freezes
   artifacts; C1196 builds on it. Days.
6. **alloc-2 — checker-crate tests for the two checkers with a certificate mutation harness
   (milestone a); an independently written completeness pass for one checker (milestone b).**
   Starts from C1205 milestone a's tests. Days each.
7. **alloc-3 — `Demand` builder, one checker entry point over the source enum, driver options
   struct recording both policies per layer, `Prepared` rename, `instrument` feature; optional
   API-boundary id newtypes.** After C1205 milestone a, before the C1203 successor. Days.
8. **alloc-8 — module ABI for the Datalog path in core and for the private Rel route, with the
   wasm32 gate and the eager-commit row bound** (decide-7 and decide-8, both decided). After C1205
   milestone a; C1196's portability bullet depends on it. Larger than first sized now that it
   reaches the private modules: days for core, more for the private provider.
9. **alloc-6 — Lean statement of the relational support argument** (finding K). After alloc-1
   fixes what the certificate carries. Week or more; Lean build rules apply.
10. **alloc-7 — crate boundary for the Rel subsystem** (std-only frontend crate plus a
    core-dependent lowering and driver crate; frontend measurement aids behind a feature). After
    C1205 milestone c. Days; lowest urgency.

## 6. Card edits made with this report

| Card | Edit |
|---|---|
| C1194 `notes/2026-09-16-c1194-min-plus-lowering.md` | status gate: scoping waits for the precursor design decision (finding F); the "existing min-plus certificate" bullet flagged as not holding on the demand path |
| C1195 `notes/2026-09-16-c1195-end-to-end-benchmark-suite.md` | cross-engine tuple-set agreement on Rel-lowered programs is a correctness deliverable; cohort sizes wait for the domain-ceiling decision; refused cohorts record C1206's refusal record |
| C1196 `notes/2026-09-16-c1196-certificate-encoding.md` | start from C1205 milestone a's byte form, not the wire route nothing produces; stride rule, sentinel and direct indexing move together; the ABI bullet depends on decide-8; a checker identity field rides with any format change |
| C1205 `notes/2026-09-18-c1205-rel-transferable-evidence.md` | milestone b: the declared-relation set is a superset of the read set, name the field so; milestone c: the documentation refresh records the identity inventory and the per-column exactness argument, and notes that an export under the n-ary policy is admitted by the Datalog door only |
| C1206 `notes/2026-09-18-c1206-structured-refusals.md` | budget statement also covers why `MAX_WORKSPACE_BYTES` and the 2^22 route bounds have their values, and that `MAX_COMPLEMENT` bounds a membership-vector allocation as well as a tuple count; mystery 3 is settled and needs only the cross-reference |
| C1207 `notes/2026-09-18-c1207-error-reporting-audit-and-design.md` | private inventory includes `Readout::decode`'s `"?"` placeholder for an unknown id |

## 7. Closeout

No mystery remains open from the C1204 ledger without an owner: item 1 is settled, item 2 is
narrowed and folded into C1206, item 3 is settled, item 4 is folded into C1195. The one residue
with no owner by choice is whether any three-atom body of the `datalog` bench cohort hits core's
link-order tie; it bears on no cited number and is dropped unless that cohort is used to compare
body policies again.

Tavis answered on 2026-09-22; IDs C1210–C1218 are reserved and their cards written.
The allocation deliverable is complete; implementation belongs to those successors.
