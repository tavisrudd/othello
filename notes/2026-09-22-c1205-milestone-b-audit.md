# C1205 milestone b: independent audit

**Lane**: `ergodis`
**Date**: 2026-09-22
**Auditor**: fresh Opus sub, read-only on every repository.
**Subject**: core `c1205b` `064cde2` (against `4b57649`), private `c1205b` `267acdd` (against
`482d6e9`); card `notes/2026-09-18-c1205-rel-transferable-evidence.md` (milestone b, the decision,
Acceptance); report `notes/2026-09-22-c1205-rel-transferable-evidence-report.md`, section
"Milestone b" and everything under it.

Summary: 1 High, 2 Medium, 8 Low, 3 Info. The implementation matches the approved design and
every number I re-derived holds apart from wording slips. The worst finding is a soundness gap
in the offline verifier's default mode: the program statement's binding sites are trusted, so a
consistently forged chain whose result is not the stratified model of the stated rules is
accepted (demonstrated). Verdict at the end.

## Findings, by severity

### H1: the verifier accepts a chain whose result is not the stratified model of the statement's rules

Evidence. The program statement's `rules[].bindings` decide every complement and filter domain
(`rel_chain::site_signature` builds `Bound` domains from them), but `rel_verify::validate`
checks only that each site is in range (`relation < relations`, `column < arity`). Nothing
checks that a site is a positive body literal of the rule, holding the variable at that column.
Scratch test `audit_forged_binding_site_is_accepted_with_a_wrong_model`
(`~/.cache/ergodis/worktrees/audit-c1205b-scratch/ergodis-private/tests/audit_forgery.rs`,
against the `267acdd` library, built clean under a separate profile) takes the honest chain of

```text
def node = {1; 2; 3; 4}
def edge = {(1, 2); (2, 3); (3, 4)}
def src(x) = edge(x, _)
def stop(y) = edge(_, y) and not src(y)
```

(honest `stop` = {4}, id `[3]`), changes the binding site of `stop`'s `y` from `(edge, 1)` to
`(edge, 0)` in `program.json`, rebuilds the complement record over the new domain {1, 2, 3}
(so the complement is empty), re-certifies layer 1 through `Demand` exactly as the committed
`reforge` helper does, and recomputes the statement identity, the layer's source identity, both
certificate digests and `stop`'s result digest. `verify_parts` accepts: identity `61b96f37…`,
`stop` = `[]`.

Failure scenario. The verifier's stated claim is "the relations the result table names are the
stratified model of the program statement". A reader takes the statement's rules as Datalog
rules; the accepted chain says `stop` is empty, and the stratified model of those rules says
`stop` = {4}. The exactness argument in `rel_stratified`'s module header (a complement is exact
because each domain is the union over the rule's own positive binding literals) is the premise
the verifier does not check. The same path is common-mode between producer and checker: both
read the frontend `bind` pass's output (`Rir::binding_sites`, copied into `P`), so a defect in
that pass (a wrong column, a site from the wrong rule) is invisible to `check`, to the offline
verifier and to the independent rebuild, whose module header does not list the bindings among
its non-independent parts. `--source-check` closes the forgery only by trusting the whole
frontend, including that pass, and it is off by default. (Counterargument considered: the
bindings are part of `P`, so the chain is "the model of `P` under `P`'s domains". That reading
makes the claim unfalsifiable by a wrong binding and is not what the design text or the card
means by a stratified model.)

Repair. In `validate`, recompute each non-auxiliary rule's binding sites from its own positive
body literals (body order, column) and require equality. For a binarized rule, record its source
rule's id in `ProgramRule` (the statement has no parent link today) and require the sites to be
that rule's positive literals, or, weaker but sufficient for exactness, require at least one
site per variable to be a positive literal of the same rule at that column. Turn the scratch
test into a refusal in `consistent_forgeries_are_refused_by_what_they_contradict`, add
statement-level mutations with the identity recomputed to the suite (none exist today), and name
the bindings in `rel_rebuild`'s "what is not independent".

### M1: the suite does not discriminate most of the verifier's soundness checks

Evidence. Thirteen single-point mutations of the verifier and construction checker, each applied
alone to a scratch copy of `267acdd` and run against `tests/rel_chain.rs` and
`tests/rel_check.rs` (plus `tests/rel_lowering.rs` for `rel_chain.rs` mutants). Driver, mutant
definitions and per-mutant logs: `~/.cache/ergodis/audit-c1205b/mut/`. Nine survive:

| Mutant | Check removed                                                                        | Result      |
|--------|--------------------------------------------------------------------------------------|-------------|
| M1     | a complement's relation must be established before its layer (`rel_chain.rs`)        | survives    |
| M2     | the same for an aggregate's relation                                                 | survives    |
| M3     | a derived relation may be read as input only after its deriving layer (`rel_verify`) | survives    |
| M4     | derivation and ranked checkers must establish the same relations                     | survives    |
| M5     | a layer rule's variable count equals the statement's                                 | survives    |
| M6     | a derived relation's facts in its own layer equal the statement's facts              | survives    |
| M9     | a seeded relation holds every statement fact                                         | survives    |
| M12    | a layer rule's head atom equals the statement's (only body atoms compared)           | survives    |
| M13    | a layer holds exactly the statement's rules (extra decoded rules ignored)            | survives    |
| M7     | a binding relation of the same layer forces the dictionary fallback                  | killed (13) |
| M14    | the layer bytes hash to `source_id`                                                  | killed (3)  |
| M15    | the literal map is ascending                                                         | killed (2)  |
| M16    | a result entry's tuple count                                                         | killed (1)  |

M1, M2, M3, M6, M9, M12 and M13 each guard soundness: with M13 a forger adds a rule to a layer
and re-certifies; with M12 a rule's head is redirected; with M6 a derived relation gets free
facts; with M9 a statement fact is dropped; with M1 to M3 an invalid layering is accepted. The
unmutated verifier refuses the two such forgeries I built (`audit_injected_derived_fact_is_refused`,
refused at `layers[0].declared[2]` with `Differs`; `audit_missing_seeded_fact_is_refused`, at
`seeded[0]` with `Differs`), so these are gaps in the evidence, not holes in the code. The
card's six named categories are covered; the checks behind them mostly are not, because the
manifest leaf and list suites cannot reach a check that needs a re-certified layer. M4 and M5
are close to equivalent mutants (two correct checkers cannot disagree; admission fixes the
variable count) and need no test.

Repair. Extend `consistent_forgeries_are_refused_by_what_they_contradict` with one forgery per
surviving soundness check, built with `reforge` generalized to edit rules and declarations as
well as facts: an extra rule, a redirected head, an injected derived fact, a dropped statement
fact, a derived relation read one layer early, and a merged layering that puts a negated
relation in its reader's layer.

### M2: the manifest's construction lists have a free order; the chain identity is not canonical

Evidence. The `demo.rel` chain from the retained candidate `ergodis-tools-c1205b-drop-71c25e7`
(`rel-lower --chain demo --externals ext.json`; `rel-verify --source-check` accepts, identity
`c29a38ee…`). Swapping `complements[0]` and `complements[1]` in `chain.json` and swapping the
matching `origin.complement` indices in the layer declarations, touching no layer file and no
digest: `rel-verify` prints `accepted: true`, identity `35d1551d…`. The same with the two
filters: accepted, identity `6b330420…`.

Why. `check_constructions_observed` and `record_place` pair records with declarations through
the `origin` index only; nothing fixes the order of `complements`, `filters` or `aggregates`.

Failure scenario. One result has several manifest spellings and chain identities with no change
to any evidence file; a consumer that pins or deduplicates chains by identity treats them as
different. The report's mystery ledger says the literal-map order was "the one case where the
manifest had a free order the verifier did not fix"; that statement is false.

Repair. Require records sorted by `(layer, declared)` (equivalently, `origin` indices ascending
with declaration position), which is the order the driver produces. Add the consistent
re-indexed permutation to the list-shape suite; today it has only the inconsistent swap. Correct
the ledger sentence.

### L1: `Stratified` vouches for the records, not for the closure it carries

`check(evaluation, rir)` takes an `Evaluation` whose fields are all `pub`, checks the seeded
list and the constructions against `evaluation.closure`, and wraps it; it never re-establishes a
closure. Scratch test `audit_check_accepts_an_altered_unread_closure`: `evaluate`, overwrite
`closure[stop]` with `[0, 1, 2]`, and `check` returns `Ok`. Every caller today passes
`evaluate`'s own output, so nothing false is printed, and the doc comment ("holding one means
the check ran and passed") is accurate; but `rel-lower`, `manifest()` and the bench's
`closure_sha256` trust a closure the type does not cover. No other constructor exists (private
field, no `Default` or `Deserialize`), so the answer to "can a `Stratified` be built without
`check`" is no. Repair: make `Evaluation`'s closure and records private with read accessors and
a test-only tamper hook, or say in the type's doc that it means "records consistent with the
closure it carries".

### L2: the bench harness still records a stratify run whose record check failed

The timed `Stage::Stratify` calls `evaluate` only; the untimed description runs `check` and on
failure writes `{"stratified":false,"error":"record check: …"}`. `bench.py` compares `tokens`,
`nodes`, `failure`, `admission` (line 412) and never reads `stratification`. A regression that
makes `check` fail yields normal-looking `stratify` ratios and one unread field, so the card's
"a bench receipt cannot record a run whose record check failed" holds only in the sense that the
closure digest is withheld. Repair: exit non-zero from `rel-frontend-bench` when `check` fails
on an evaluated cohort, or refuse such an operation in `bench.py`; a backend refusal (the
`columns3` complement budget) stays a legitimate outcome.

### L3: `rel-lower --externals` silently merges a repeated spelling

`{"ext": [[0]], "ext": [[1]]}` with `demo.rel` on the retained candidate: exit 0, chain written,
`ext` seeded with 1 tuple. The file is decoded into a `BTreeMap`, so serde keeps the last value
and `ExternalProblem::Repeated` is unreachable from the command line. The library refuses
unknown, derived, repeated, wrong-width and out-of-dictionary inputs by name before seeding, and
records every seeded spelling (both tests in `tests/rel_externals.rs`, green). Repair: decode
through a visitor that refuses a repeated key, or take a JSON list of pairs.

### L4: publish is atomic, not durable

`StagedChain::publish` renames with no `fsync` of the files, the staging directory or the
parent. After a host crash the renamed directory can hold truncated files; the verifier refuses
them (decode or identity), so nothing false is accepted, but "the target never holds a partial
chain at any instant" holds for a process death, not a power loss. A killed run leaves only a
`.partial-<pid>` sibling, as stated; a later run with the same pid fails to create its staging
directory. Repair: `sync_all` the files and the staging directory before `rename` and the
parent after, or state the scope.

### L5: unread `source.rel` and `lowering.json` ride along with an accepted chain

Without `--source-check` the verifier bounds these two files and ignores them, so a chain can
carry a source that does not lower to `program.json` and still print `accepted: true`
(`"source_check": false`). With H1 open, a reader who opens `source.rel` to learn what was
proved is misled twice. Repair: refuse the pair when the check is off, or print a field such as
`"source_unchecked": true`.

### L6: the statement admits undefined operators and duplicate names

`validate` does not check a comparison literal's `op` against the `CMP_*` set, that `op` is zero
where unused, or that relation names and spellings are distinct. An undefined comparison
operator is rebuilt as an empty filter (`rel_rebuild::compare` falls through to `false`), so the
verifier gives meaning to a statement the frontend cannot emit, and a nonzero unused `op` is a
second statement spelling with another identity. Repair: refuse all three in `validate`.

### L7: verifier cost is not bounded by its input bounds

`rel_rebuild::aggregate` interns each group result by a linear dictionary scan (groups ×
dictionary); `site_signature` materializes a whole-dictionary domain per column per mapped
literal before the universe bound is tested; serde decoding of a 64 MiB `program.json` of empty
lists allocates about eight times the file. None of this is reachable from the honest producer
at the measured sizes (`rel-verify` peaks at 48 to 114 MB), but the verifier's job is untrusted
input. Repair: intern through a map built once per aggregate, test the universe from domain
sizes before collecting, and bound the statement's list lengths before decoding the rest.

### L8: the dependency-closure test is textual and bypassable

`the_verifier_reaches_no_evaluator` follows `crate::<module>` tokens from `rel_verify` and greps
the reached files for `ergodis_rules`, `rel_stratified` and `Demand`. It never scans `lib.rs`.
Demonstrated in the scratch copy: `pub use rel_stratified as audit_alias;` in `lib.rs` and
`use crate::audit_alias::evaluate as _audit_evaluate;` in `rel_verify.rs` compile and the test
passes. It also does not follow a grouped `use crate::{a, b}`. Nothing in the tree does either
today, and nothing in the verifier's reach calls `Demand`, `ergodis_rules` or `rel_stratified`
(read every reached import; `ergodis-verify` does not depend on `ergodis-rules`). The
guarantee is module-level, as the report says; the `rel-verify` process links `Demand`.
Repair: move `rel_chain`, `rel_rebuild` and `rel_verify` into a crate without an
`ergodis-rules` dependency, so the compiler enforces it.

### I1: comments, commit messages, paths

- `tests/rel_externals.rs:44–45`: "which is what used to let it through re-cut" is change
  history in a source comment.
- `src/rel_stratified.rs`: the module header, rewritten in this branch, keeps "the route ADR
  0004 fixes for milestone (b)" (line 6), "milestone (b) used" (40), "milestone (a) already
  lowers" (66, 72), and the file has three more (763, 891, 1253). They predate the branch, but
  the card asks for no process narrative and the paragraph between them was edited here.
- No task ID, notes path or review-finding name in any added source line. No commit message on
  either branch carries a task ID or a private path.
- No `/home/` in the core diff. In private, `/home/tavis/...` appears only in the new receipts
  under `analysis/` (the measured binary path, twice per receipt; 540 times in the
  derivation-loop `.jsonl`). The private repository is never exported, so the public boundary
  holds.

### I2: performance record

- The default `evaluate` has no evidence code: in both candidates `evaluate` calls the
  `NoEvidence` instantiation of `evaluate_with`, whose callees include `tuple_digest` (needed by
  the records on every path) and no `transferable_source`, `ChainWriter::layer` or certificate
  serialization. Confirmed on `db37035` (0x7548 of 0x7ace/0x7548) and on `71c25e7` (0x7538).
- "The milestone's own added work is +8 to +20 thousand instructions per iteration" is not
  isolated. The "rest of the code" column mixes code generation with work: on `datalog`, one
  layer and no construction, its +12,724 is `ergodis_rules`/`verify`/`contract` +3,954 (source
  unchanged apart from the D3 perturbation) and "other" +9,176; on `columns3`, +6.8 thousand of
  it is the `evaluate` body moving into `evaluate_with`. Supported: "at most about 20
  thousand"; the attributable part is the header compressions and the per-layer declaration and
  literal-map vectors.
- Between-session reproducibility is weaker than the intervals suggest. My rerun of the
  `71c25e7` stage A/B on the same retained binaries (3 rounds, core 5, load 12 to 31):
  `stratified` 0.99969, delta −479,981 against −480,335; `columns3` 0.99754, delta −19,984
  against 0.99734 and −21,552, a move of 1.6 thousand, about a hundred times the receipt's
  interval half-width. The heap-layout term the report identified is the likely cause; the
  intervals are within-session only.
- The milestone-b section gives no exact replay command for the two construction-cohort
  `bench.py` runs or the derivation-loop `ab.py` run ("method as milestone a"); the stage-shift
  replay block is complete.
- `PERFORMANCE.md` invariant 1 names "check" loops among the allocation-free ones; `rel_rebuild`
  allocates per tuple by the approved design (D1 (a)) and is off every timed path. Reasonable,
  but an exception to a binding rule that the report's deviations should record.

### I3: mutation-suite tables and accepted certificate mutations

- `LEAF_TABLE` and `LIST_TABLE` follow their four stated reasons, and the "every row matches"
  guard holds. Three rows are loose: a provenance tag swap may be refused by any decode failure
  (`chain.json: ` with an empty path), an origin tag swap at `layers[*].declared` of any layer,
  and `origin.program` at any field under the declaration or any origin of the layer. Every
  mutation is still refused, so this weakens only "the error names the field".
- The three accepted derivation-certificate mutations (layer 1, `premises[66]`, `[68]`, `[70]`
  plus one) are valid alternative supports; the test requires the completed chain to establish
  exactly the original relations, and it does.
- No `program.json` field is mutated with the identity recomputed; that is where H1 lives.

## Answers to the audit questions

1. Soundness. Forged construction records, inputs that are not the previous layer's checked
   relations, a swapped literal map, a certificate from another layer and an omitted layer are
   all refused by the code as read, and the suite's forgeries and my two added ones confirm the
   cases they cover. An inserted layer that derives nothing would change only the identity (M2's
   class) if the core admits such a program; not tested. One consistent forgery is accepted
   with a wrong model: H1.
2. Independence. `rel_rebuild` imports only operator and kind constants from the frontend; it
   shares no code with the builder (`complement_over`, `filter_over`, `aggregate_over`,
   `Dictionary`). Comparison semantics are shared with the reference evaluator, which imports
   `Value` and `compare` back, as designed. The construction checker (`check_constructions`) is
   one function used by both the in-process `check` and the verifier, as designed. Not
   independent and not stated: the binding sites (H1). The closure test enforces the property
   for today's tree only (L8).
3. Checked results. No `Stratified` without `check`; `check` does not cover the closure (L1).
   A bench receipt still records a failing run's counters (L2).
4. Externals. All five refusals by name, seeded names recorded; the CLI hides `Repeated` (L3).
5. Chain format. Record digests are domain-separated by tag, kind, scope, length-prefixed name,
   arity and count; the manifest identity uses the same tag string, separated from tuple digests
   only by the first payload byte (`{` against a kind name), which holds but is incidental.
   Canonicality: whitespace and JSON escapes give byte variants with one identity, as designed;
   construction-list order gives identity variants (M2). The verifier never reads
   `producer.json`. Every file is bounded from the listing and again while read. Decoding can
   allocate several times its input (L7). Publish is atomic, and no crash leaves a directory the
   verifier accepts (L4).
6. Mutation suite. Counts re-derive; the three alternatives are valid; tables justified with
   three loose rows (I3); nine of thirteen verifier mutants survive (M1).
7. Preservation. `git log -p` on the pin and assertion files: `tests/rel_layer_identities.rs`
   changed after `1f8200b` only by one doc-comment line and appended tests;
   `tests/rel_frontend_portability.rs` untouched; `tests/rel_lowering.rs` changed only in the
   stratified helper and the tamper test (fingerprint and parity assertions untouched);
   `tests/rel_reference_eval.rs` changed only in the `verify_records` call site, and
   `tests/rel_reference/mod.rs` only by importing `Value`/`compare` (populations and assertions
   untouched; semantics equivalent for the six defined operators); core `demand_prepared.rs`
   changed only in API calls, no pinned hex edited. `1f8200b` touched layer assembly nowhere
   (one field and one assignment), so the pins it introduced describe the base's layers. All of
   these pass in the gate below.
8. Performance. Every table re-derives (below); one stage A/B reproduced; the no-evidence-code
   claim holds; the 8 to 20 thousand claim is an upper bound, not an attribution (I2).
9. Gates at `267acdd` under `nix develop` of the core worktree, `choom -n 1000`, `-j 12`:
   `cargo fmt --all --check` clean; clippy `--all-targets --all-features -D warnings` clean for
   the root and for `-p ergodis-tools`; `cargo test --all-features --no-fail-fast` 1,196 passed,
   17 ignored, 0 failed, doctests included; `-p ergodis-tools` 46 passed. No stale-rlib or
   two-versions failure occurred; no `cargo clean` was needed. Log:
   `/tmp/claude-run-quiet/20260922-185301-nix-develop-ergodis-c-gate.sh/`.
10. Comments and commit messages: I1.
11. Numbers: below; all hold except the wording and label slips marked.

## Numbers reproduced

From the committed receipts at private `267acdd`, reruns of the committed tests, and the
retained binaries (hashes re-measured). Scripts in `~/.cache/ergodis/audit-c1205b/`.

| Claim (report, milestone b)                     | Reported                                 | Reproduced                                                          | Verdict    |
|-------------------------------------------------|------------------------------------------|---------------------------------------------------------------------|------------|
| Leaf mutations                                  | 968                                      | 968                                                                 | holds      |
| List-shape mutations                            | 448                                      | 448                                                                 | holds      |
| Derivation / ranked certificate mutations       | 379 (3 accepted) / 183                   | 379 (layer 1 premises 66, 68, 70 accepted) / 183                    | holds      |
| Consistent forgeries                            | 5                                        | 5 cases in the test                                                 | holds      |
| Generated chains accepted, multi-layer          | 470, 252                                 | 470, 252                                                            | holds      |
| Derivation loop instruction ratios              | 0.99994 to 1.00001                       | 0.999943 to 1.000014                                                | holds      |
| `mutual:blocks:8192`                            | 0.99994 [0.99988, 1.00000], null 0.99996 | same                                                                | holds      |
| Derivation loop peak RSS                        | within 16 KiB                            | max difference 16                                                   | holds      |
| Construction cohorts, `lower` byte ratio        | 0.99701 ... 0.99304                      | 0.99701, 0.99263, 0.99271, 0.99267, 0.99304                         | holds      |
| Construction cohorts, `stratify` byte ratio     | 0.99975 ... 0.99971                      | 0.99975, 0.99973, 0.99973, 0.99772, 0.99971                         | holds      |
| "Every interval is narrower than 1e-5"          | all                                      | `lower`/`stratify` max 3.6e-6; `scan` 7.4e-5, `parse` 2.8e-5        | wording    |
| `lower`'s own delta "(`lower` - `admit`)"       | -16,953 ... -25,876                      | those are raw `lower` deltas; `lower` - `admit` differs by up to 22 | label slip |
| `stratify`'s own delta at `db37035`             | -402,650 ... -178,964                    | equal to within 1                                                   | holds      |
| `prepare`                                       | 1.00516, +174                            | 1.005159, +173.7                                                    | holds      |
| Stage-shift table, `stratified` row             | -399,127 / -437,341 / -450,993           | equal (mmap receipt; bucket sum)                                    | holds      |
| Peak RSS tables at `db37035` and `71c25e7`      | as tabled                                | every median and delta equal                                        | holds      |
| Released-relations A/B at `71c25e7`             | as tabled                                | every ratio and delta equal                                         | holds      |
| A/A nulls at `71c25e7`                          | within 7e-6                              | 6.9e-6                                                              | holds      |
| Chain cost, `stratified` row                    | 1.742 -> 2.245 G; 10,875,186 B           | equal                                                               | holds      |
| No evidence code in default `evaluate`          | by disassembly                           | confirmed in `db37035` and `71c25e7`                                | holds      |
| Stage A/B rerun, `stratified`                   | 0.99969, delta -480,335                  | 0.99969, delta -479,981                                             | holds      |
| Stage A/B rerun, `columns3` byte                | 0.99734, delta -21,552                   | 0.99754, delta -19,984                                              | moves 2e-4 |
| Retained binary hashes (5)                      | as tabled                                | equal                                                               | holds      |
| Full private gate at `267acdd`                  | 1,196 root + 46 tools                    | 1,242 passed, 17 ignored, 0 failed                                  | holds      |
| `rel_externals` test count (gates at `71c25e7`) | 1                                        | 2                                                                   | slip       |

## Verdict

Not ready to close milestone b. The design is implemented as approved, the chain format, the
externals, the sealed result types, the error naming, the preservation pins and the performance
record all check out, and the gate is green. H1 is a real soundness gap in the offline
verifier's default mode and has to be repaired, with a refusal test, before the verifier's
claim can be stated as written. M1 should land with it (the forgery tests are the evidence the
acceptance criterion asks for), and M2 is a small canonicality fix plus a correction to the
mystery ledger. The Low items can be repaired or recorded as open; none blocks on its own.

## Scratch locations and method notes

- `~/.cache/ergodis/worktrees/audit-c1205b-scratch/ergodis-private`: a `git archive` export of
  private `267acdd` (no worktree registered, no git state touched), with path dependencies
  rewritten to the `c1205b` core worktree, a `[profile.audit]` (inherits `dev`) added, and
  `tests/audit_forgery.rs` (four tests). Its source matches `267acdd` again after the mutation
  runs.
- `~/.cache/ergodis/audit-c1205b/`: gate script, receipt re-derivation scripts, the chains
  produced with the retained binaries (`demo`, `perm-complement`, `perm-filter`, `dupch`), the
  reproduced bench receipt `bench-drop-repro.json`, and `mut/` (mutation driver and logs).
- Deviation: the scratch builds used the `audit` profile, which puts their artifacts under
  `~/.cache/ergodis/target/ergodis-private/audit/` inside the shared target. Cargo hashes a
  workspace member's artifacts by its workspace-relative path, so a mutated scratch build in the
  `dev` profile would have overwritten the `dev` artifacts that the `c1205b` worktree and the
  concurrent `~/src/ergodis-private` session link, and could have fed them mutated code. The
  gate itself ran in the `c1205b` worktree in the `dev` profile as asked.
