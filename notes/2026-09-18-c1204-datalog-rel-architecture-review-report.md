# C1204 — architecture review of the Datalog/Rel functionality: synthesis report

**Lane**: `ergodis`
**Date**: 2026-09-18
**Card**: `notes/2026-09-18-c1204-datalog-rel-architecture-review.md`
**Code reviewed**: core `~/src/ergodis` at `96aee9b`, private `~/src/ergodis-private` at `1500dc2`.
Read-only; nothing under `ergodis*` was modified.

**Component reports** (verbatim from the two Opus reviewers; this report does not restate their
detail):

- private half — frontend, lowering, stratified driver, reference evaluator, tooling:
  `notes/2026-09-18-c1204-review-half1-frontend-lowering-driver.md` (cited below as *private
  report*);
- core half — rule contract, demand evaluator, certificates and checkers, carrier:
  `notes/2026-09-18-c1204-review-half2-contract-evaluator-checkers.md` (cited as *core report*).

**How the synthesis was made.** The main agent probed the code directly in parallel with the two
reviewers (trust boundary, identity, error model, carrier relation, crate arrows) and afterwards
spot-checked the reviewers' highest-severity claims against the source. Each finding below says
whether it was read by the main agent (**probed**), by a reviewer only (**reviewer**), or both.
Where the two halves asked each other questions, section 5 answers them.

## 1. Verdict

The layering is right and the split between core and private is principled: core owns the
contract, the evaluator and the checkers; private owns the language, the lowering and the route
that turns non-monotone constructs into positive programs. `ergodis-verify` does not depend on
`ergodis-rules`, the lowering's refusals carry numbers and spans, every construction checks its
projected size before enumerating, and the differential oracle against an independent evaluator is
a real asset.

What is bending is the **evidence story**, and it bends in one direction at every level: each
"independent check" shares more with what it checks than its documentation says, and the artifacts
that would let anyone re-check later are discarded. The Rel product path produces an answer whose
acceptance means "this process ran and nothing returned an error". That is a design gap rather
than a bug: no wrong answer was found, and the oracle corpus agrees. But the programme's stated
goal is a certificate a second party can check, and on the only route the product uses, no such
object exists.

The second pressure point is that the queued min-plus work (C1194) is scoped as a lowering task,
and both halves independently found it is an evaluator, certificate-format and seam task.

## 2. Architecture map

```text
 Rel source bytes
      │
      ▼                                   ergodis-private (one library crate; no boundary
 rel_frontend/  (std only)                 around this subsystem)
   lexer ─▶ parser ─▶ admit ─▶ lower/{build,passes} ─▶ Rir (pooled relational IR,
   │                                                       canonical bytes, FNV fingerprint)
   │ compiled with bare rustc by the native/WASM parity harness  ── this is why the two
   │                                                                modules below are siblings
   ▼
 rel_lowering.rs    readout_of ─▶ Readout (decode map)          [used by the driver]
                    project    ─▶ rule_contract::Program (wire) [one test caller; not on
                                                                 any running path]
 rel_stratified.rs  evaluate: strata ─▶ layers; per layer:
                      aggregates, complements, filters built from the previous closure
                      ─▶ PreparedSource ─▶ Demand::from_prepared_bounded(.., Policy::Auto)
                      ─▶ evaluate_into ─▶ certificate + ranked_certificate
                      ─▶ Demand::verify / verify_ranked  ─▶ checker relations
                      ─▶ compared tuple-wise with evaluator rows ─▶ closure for next layer
                    verify_records: replays the three constructions and compares digests
 tests/rel_reference/  naive evaluator over the admitted AST + seeded differential harness
 ─────────────────────────────────────────────────────────────────────────────────────────
 ergodis-rules  ──depends on──▶  ergodis-verify               core
   Prepared  (grounded, carrier-generic: min-plus and Boolean; small bounds; the only thing
              the C ABI / WASM provider exposes; has incremental update)
   Demand    (demand-driven semi-naive, Boolean only, set semantics; plan, Policy, Pages
              workspace; emits both certificate kinds; verify methods live on the producer)
 ergodis-verify
   rule_contract  wire Program, Error (the single error enum), grounded admission, JSON identity
   datalog        Admitted, admit (wire), admit_prepared (+ streamed binary identity),
                  PreparedSource — producer input types living in the checker crate
   derivation     trace-following checker + closed_world (completeness pass) + unify helpers
   ranked         searching checker; reuses derivation's closed_world and helpers
   datalog_store  checker stores and join indexes
   weight         sealed TransitionWeight carrier trait: used by the grounded path only
   lib            implementation_identity(): hash of checker sources incl. datalog.rs
```

The per-seam contract tables are in the two component reports (section 2 of each); the identity
and budget inventories are sections 3 and 4 of the core report and the "Identity" answer of the
private report. They are accurate as far as the main agent's probes overlapped them and are not
duplicated here.

**Arrows that exist for an incidental reason**

1. `rel_lowering.rs` and `rel_stratified.rs` sit beside `rel_frontend/` rather than inside it,
   because the parity harness compiles the frontend with bare `rustc` and they need core crates.
   Known and recorded in ADR 0004.
2. `rel_stratified` depends on `rel_lowering` only for the decode map; the wire backend that
   module is named for is not on any running path.
3. Contract types (`Program`, `Admitted`, `PreparedSource`, `Error`) live in the checker crate, so
   the evaluator depends on the checker crate and `implementation_identity()` changes whenever a
   producer-facing input type does.
4. `ergodis-rules` depends on `ergodis-modules` only for the grounded path's C ABI vocabulary.

## 3. Ranked findings

Severity: **S1** soundness or trust-boundary risk; **S2** blocks queued work; **S3** costs every
future change; **S4** cosmetic. Sizes are rough.

### Evidence and trust boundary

**A. An accepted stratified result carries no evidence, and a prepared-route certificate is
checkable only by the process that made it (S1; days).** Probed and both reviewers.
`rel_stratified.rs:evaluate` builds both certificates per layer, checks them, and drops them;
`Stratified` holds no certificate, no digest of one, no per-layer `source_id` (computed by core
for every layer and read by nobody), no declared-relation list, and no record of which synthetic
relation replaced which negated, compared or aggregated literal. Underneath, `Demand::verify` on
the prepared route calls `check_admitted(&self.admitted, ..)`: the checker reads the producer's
own admitted object, `PreparedSource` has no serialization, and `admit_prepared` is the only
implementation of the prepared identity. Within one run the layer-to-layer hand-off is strong (the
next layer reads the checker's relations, compared tuple-wise with the evaluator's rows); outside
the run nothing binds anything. *Recommendation:* in core, factor the canonical encoding that
`admit_prepared` already streams into SHA-256 into `encode_prepared`/`decode_prepared`, giving the
checkers a byte-level door for the prepared route; in private, make `LayerReport` carry the layer
`source_id`, declared relations, certificate digests, the literal-to-relation mapping and input
digests, so a stratified result is a chain that stands on its own. Core report F1, private report
F1.

**B. The "independent rebuild" of complements, filters and aggregates replays the builder (S1;
hours to restate, days to make independent).** Probed and both reviewers. `verify_records` calls
the same `complement_over`, `filter_over`/`satisfies`, `aggregate_over`, `digest_of` and
`Dictionary` that built the records; only `rebuild_domain` is a second implementation. It detects
a tampered record, not a defective construction, and these constructions are exactly the step the
core checkers cannot see. Three recorded fields are never checked (`ComplementRecord.source`,
`FilterRecord.literal`, `FilterRecord.operator`). The check is also optional: `evaluate` does not
call it, and the bench records its failure as a boolean in an otherwise valid receipt.
*Recommendation:* choose explicitly. Either promote the reference evaluator's set-based route into
a separately written rebuild that resolves records against the recorded layer program, or keep the
replay, correct the module header to say what it is, and make oracle agreement part of the shipped
evidence. Either way run the check inside `evaluate` or make checked/unchecked a type. Private
report F2, F9.

**C. The two checkers share their completeness half, their admission and their stores (S1 as a
claim; hours to restate, days to separate).** Reviewer, verified by the main agent.
`ranked.rs` imports `derivation::closed_world`, `unify`, `head_matches`, `fixed_mask` and
`mark_bound`; both use `datalog_store` and the same admission function. The driver's
`CheckersDisagree` therefore corroborates only the soundness half (trace-following against
search). A defect in `closed_world`, `unify`, the store or admission passes both. With no Lean
statement for these certificates (finding K), the two checkers' agreement is the whole of the
formal evidence. *Recommendation:* state the shared core where independence is claimed; if the
corroboration is to carry weight, give one checker its own completeness pass. Core report F2.

**D. Externally supplied facts are unvalidated and unrecorded (S1; hours).** Reviewer.
An `Externals` key that matches no relation is silently skipped, and tuple width is not checked
against arity, so a wrong-width tuple set whose total length divides by the arity is re-cut into
different tuples. The run then certifies the fixed point of a program the caller did not mean. The
differential harness performs the check the library should. *Recommendation:* refuse an unknown
name and a wrong-width tuple; record seeded relation names with a digest. Private report F3.

**E. The checker crate has no tests of its own for the Datalog checkers (S3; days).** Reviewer,
verified. `crates/verify/tests/` holds nothing for `datalog`, `derivation`, `ranked` or
`datalog_store`; every rejection assertion lives in the producer crate and is built from
certificates the producer can emit, which is the family a checker least needs testing on.
*Recommendation:* move the rejection suites into the checker crate with hand-built certificates
and a mutation harness. Core report F7.

### Blocks queued work

**F. C1194 (min-plus and term arithmetic) is an evaluator, certificate and seam task, not a
lowering task (S2; week+, decision first).** Probed and both reviewers. `Demand` is a parallel
Boolean implementation, not an instance of the carrier: it never touches `TransitionWeight`
(sealed, grounded path only), `admit` refuses every other carrier, `PreparedSource` has no carrier
or fact cost, and set semantics are built into `emit` and into both certificate formats, which
reject as `Duplicate` exactly the event min-plus needs (improving a tuple after first derivation).
The grounded path that has min-plus stops at small bounds and two-atom bodies. On the private side
the RIR has no term arithmetic and no construct declares a carrier, and complements over a cost
carrier are a different object from Boolean complements. *Recommendation:* before scoping C1194,
settle (a) whether the min-plus relational evaluator reuses `Demand`'s plan, index and `Pages`
machinery with a value column and a re-derivation rule or is a second kernel, and (b) what a
min-plus relational certificate carries; (b) also decides whether the Lean support argument can be
reused. Core report F3, private report F6.

**G. One payload-free `Error::Budget` for every refusal; no single budget model (S2; days).**
Probed and both reviewers. `rule_contract::Error` is the only error type; `Demand` raises `Budget`
for a zero row bound, a reservation above `MAX_WORKSPACE_BYTES`, row capacity exhausted
mid-evaluation and the round guard. The driver maps all of them to
`LayerCapacity { layer, max_rows }`, which is wrong advice when the refusal was address space. On
the private side refusals come in three further shapes. C1195's reach limits against a competitor
cannot be reported through this. `check_bounded` also accepts an unclamped `direct_limit` that
sizes an allocation. *Recommendation:* a `Refusal { kind, relation, limit, observed }` record at
each core site; give every route refusal the `Budget`-with-numbers shape the lowering already
uses; clamp `direct_limit`. Core report F4, F5; private report F12.

**H. The 64-bit packed key fixes the dictionary at 65,536 entries for every program (S2; design
decision).** Probed by the main agent; neither reviewer raised it as a finding. `MAX_DOMAIN` is
65,536 because a tuple packs into a `u64` at `MAX_ARITY` four (`universe(MAX_DOMAIN, 4)` is
`u64::MAX`). The domain ceiling is therefore set by the widest arity the contract allows, not by
the program: a binary-only program is held to the same 65,536 although its keys would fit a
2^32 domain. On the Rel path the domain is the whole value dictionary — every integer and string
in the program and its inputs, plus values aggregates invent — so the ceiling is a product limit on
distinct values, and the closure benchmark at N = 65,536 already sits on it. C1195's end-to-end
suite against Soufflé will reach it on any realistic dataset. *Recommendation:* make the domain
ceiling a function of the program's maximum arity (the packing already depends on both), or state
the ceiling as the product's current reach in the suite's design. Decide before C1195 fixes its
cohort sizes.

**I. Join order has two owners, and the lowering's ordering pass does not run under the default
policy (S2/S3; hours plus a decision).** Reviewer, verified. `order_body` has one call site, inside
`chain`, which runs only for bodies longer than the policy keeps; under the default `Nary` policy
three- and four-atom bodies reach core in source order, while core's plan orders links itself
(most bound key columns, then fewest new variables, then body order). `Rule.order`'s documentation
and the "a planner is a policy swap" claim hold only on the chained path. Combining the two
halves: core's plan already owns link order on the n-ary path, so the lowering's order matters
only for chain shape. *Recommendation:* declare core the owner, document `Rule.order` as a hint
that shapes chains, and open the planner seam in core (`estimate_probes`/`fan_out` are private
with no seam). Check once whether the C1193 comparison was affected before citing it again.
Private report F7.

**J. The driver exposes one knob and hard-wires `Policy::Auto`; `Demand` has four constructors and
each checker four entry points, with the next parameter already named (S2/S3; days).** Both
reviewers. The Rel path cannot select or observe a policy per layer and has nowhere to put the
expected-evaluation-count hint the C1203 successor needs; on the core side that hint would, by the
existing pattern, double the constructors again. *Recommendation:* one `Demand` builder (source,
row bound, policy, later the evaluation count) and one `check(source, certificate)` over an
explicit `Source` enum, before the C1203 successor lands; an options struct in the driver that
records the chosen policy in `LayerReport`. Core report F9, F11; private report F8.

### Costs every future change

**K. The Datalog certificates have no Lean coverage (S3; week+).** Reviewer. The Lean
formalization proves least-fixedness for the grounded scalar form only; the argument that the
trace pass plus the closed-world pass gives the least model is one docstring. The strongest formal
claim covers the evaluator the product does not use. Stating the relational argument is the
natural companion to finding F's certificate decision. Core report F12.

**L. Two admission languages share one wire format, one schema string and one identity function
(S3; days, a format change).** Reviewer. `ground` and `datalog::admit` accept different programs
under the same `finite-min-plus-rules.v1` schema; a `Program` does not determine which language it
is in, and the identity records nothing about the regime. *Recommendation:* a separate schema
string or a declared profile field, decided before C1195 freezes artifacts. Core report F6.

**M. The wire backend is dead and the documented architecture describes it (S3; about a day).**
Reviewer. `rel_lowering::project` has one test caller; ADR 0004 and the C1190 architecture note
still describe it as the boundary and the direct constructor as future work. The positive-fragment
check exists twice. C1196's certificate encodings start from a route nothing produces.
*Recommendation:* collapse to one route: a wire *export* built from the per-layer assembly the
driver already does, so the exported program is the one that ran. This composes with finding A.
Private report F5.

**N. Contract types live in the checker crate (S3; days, a validation-gate change).** Probed and
reviewer. Splitting a contract crate out of `ergodis-verify` would leave the checker identity
covering checker source only, but it changes `implementation_identity()` and so invalidates
existing receipts. Tavis's call. Core report F15.

**O. About half of `Demand`'s public surface, and much of the frontend's, is measurement
instrumentation (S3; days).** Probed and both reviewers. Five of six `Policy` variants,
`evaluate_counted_into`, `index_lookups`, the plan reports, `reservations()` and the crossover
constants are public in core and used only by `closure_ballpark` and tests; the product path uses
none. The `COUNT` const-generic mechanism itself is done well. *Recommendation:* an `instrument`
module behind a non-default feature; `Policy::Auto` stops being a product constructor parameter.
Core report F8, private report F14.

**P. Stage sequencing in the frontend is a doc comment (S2 by consequence, hours).** Reviewer,
verified. `lower` reads `definitions`/`module_nodes` that only `admit` clears and fills;
`parse(a); admit(a); parse(b); lower(b)` lowers one source against another's item list. No in-tree
caller does it. *Recommendation:* a generation counter bumped by the scanner and checked by
`lower`. Private report F4.

**Q. Invariants by convention in the RIR and the plan records (S3; about a day for the worst).**
Both reviewers. Bare `u32` ids and `NONE` sentinels throughout; the worst case is
`Literal.reserved`, documented as scratch outside the canonical form while `canonical_literal`
writes it for aggregates and the driver reads it as the aggregated column. *Recommendation:* give
the aggregate column a named field; newtype ids at the core API boundary and leave the packed
kernel records alone. Private report F11, core report F10.

**R. The workspace model is a Unix property (S3; decision).** Reviewer, marked inferred there.
Every budget default assumes lazy `MAP_NORESERVE` commit; the non-Unix `alloc_zeroed` branch
commits eagerly and `MAX_WORKSPACE_BYTES` exceeds the wasm32 address space. Nobody has met it
because `ergodis-rules` is not built for WASM today. Given the binding direction that WASM is a
full execution target, this needs a decision, not a fix. Core report F14.

**S. The Datalog path has no ABI (S3; sequencing).** Reviewer. The provider exposes the grounded
path only. Finding A's byte-level door is the prerequisite. Core report F16.

### Smaller

Record digests have no domain separation (fix before anything durable stores one; private report
F16). One `ComplementMismatch(usize)` serves three record kinds (F10). The reference evaluator's
stated contract understates what it covers, and the place it is stated should also say that the
scanner, parser and admission are shared with the code under test and invisible to the
differential (F13). Certificate decoders have no input bound (core report F17). `fact_count`'s
docstring is wrong for the prepared route (core report, unexplained 3). No result records which
`BodyPolicy` produced it (private report, unexplained 5).

## 4. What I would do first

1. **Make the evidence real on the product route** (findings A, B, D together; M rides along).
   Core: `encode_prepared`/`decode_prepared` and a byte-level checker door. Private: layer records
   that bind program, certificate digests and constructions; externals validated and recorded;
   `verify_records` inside `evaluate`; decide replay-versus-independent for the rebuild and write
   down which. This is the smallest change that makes "accepted" mean something to a second party,
   and C1195 and C1196 both build on it.
2. **Take the C1194 design decision before any C1194 code** (finding F): weighted `Demand` or
   second kernel, and what the certificate carries. Pair it with a first Lean statement of the
   relational support argument (finding K), because the two decisions constrain each other.
3. **Structured refusals** (finding G) and **the domain-ceiling decision** (finding H), both
   before C1195 fixes its cohort sizes and its reach tables.
4. **Builder and `Source` enum** (finding J) before the C1203 successor adds a plan parameter.
5. **Restate the independence claims** where they are made (findings B and C): hours, and it
   stops the evidence from being read wider than it is while item 1 is in progress.

## 5. Cross-half questions, answered

- *Does the prepared `source_id` cover names, arities, input flags, rules and the fact sets?* Yes
  (main agent read `admit_prepared`): the tag, domain, each relation's name, arity and input flag,
  each rule's variable count and resolved slots, and the sorted deduplicated facts per relation,
  all length-prefixed. Recording it per layer with the declared names is enough to bind a layer
  program.
- *Can `Budget` from `workspace()` or `evaluate_into` mean something other than row capacity?*
  Yes: the workspace reservation cap and the round guard. The driver's mapping mislabels them.
- *Does core object to layers of one run declaring different domains?* No: each layer is its own
  source with its own identity, and the domain is part of that identity.
- *Are the layer certificates kept anywhere?* No; they are dropped when the loop iteration ends.
- *Is the parity-harness constraint still live?* Yes; `portability.py` still compiles the frontend
  with bare `rustc`.
- *Are the `Policy` corners meant to be public?* Their only consumer outside core tests is
  `closure_ballpark`; see finding O.

## 6. Candidates to queue (no identifiers allocated)

1. Transferable evidence for the Rel route: prepared-source encoding in core, self-standing layer
   records in the driver, externals validation, record check inside `evaluate`, wire export
   replacing `project`, ADR 0004 refreshed.
2. C1194 precursor: design memo on the weighted relational evaluator and its certificate, with a
   Lean statement of the relational support argument for the Boolean case.
3. Structured refusals across core and the driver, with the `direct_limit` clamp.
4. Domain ceiling as a function of program arity, or an explicit reach statement for C1195.
5. `Demand` builder, `Source` enum, single checker entry point, `Prepared` rename; driver options
   struct recording the chosen policy.
6. Checker-crate test suite with a certificate mutation harness; independent completeness pass for
   one checker.
7. Join-order ownership: core owns it, `Rule.order` documented as a hint, planner seam opened.
8. Instrumentation behind a feature in core and the frontend.
9. Small repairs in one pass: stage-sequencing generation counter, `Literal.reserved` named field,
   digest domain separation, record-kind error variants, decoder bounds, docstring corrections,
   `BodyPolicy` recorded in results.
10. Decisions for Tavis that are not tasks yet: contract crate split (invalidates receipts);
    separate schema string for the Datalog language; whether WASM is a target for the Datalog
    path; whether the Datalog path gets an ABI.

## 7. Mystery ledger

1. **Whether the C1193 n-ary-versus-binarized comparison was affected by the missing ordering
   pass.** Open. The binarized arm was ordered by `order_body`; the n-ary arm reached core in
   source order and was then ordered by core's own link heuristic, which may absorb the
   difference. Evidence gap: one re-read of the C1193 receipts' plans, or one run with
   `order_body` applied to every rule. Owner: the join-order candidate above.
2. **Three route bounds share one value** (`MAX_COMPLEMENT`, `MAX_FILTER`, `MAX_LAYER_TUPLES`), so
   the layer bound can bind only on multi-construction layers. Possibly intended; not stated as a
   choice. Owner: structured-refusals candidate.
3. **The checker's direct limit and the evaluator's direct-key ceiling differ by a factor of four
   with neither docstring mentioning the other.** Probably independent choices, which is
   defensible for a checker; unstated. Owner: the budget statement in the structured-refusals
   candidate.
4. **No external Datalog engine has evaluated a Rel-lowered program**: the Soufflé comparison runs
   on hand-built contract programs. Not a mystery but an evidence gap that C1195 closes; recorded
   so C1195 treats cross-engine agreement on lowered programs as a correctness deliverable, not
   only a timing one.

Settled by the closeout pass: the prepared identity's coverage, the meaning of `Budget` at the two
driver call sites, the per-layer domain question, and that the lowering's join order is moot on
the n-ary path because core reorders links (section 5).
