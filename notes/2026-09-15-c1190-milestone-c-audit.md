# C1190 milestone (c) — aggregation and comparisons: independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: COMPLETE. Written incrementally from the start of the audit.

## Scope

Target of the audit: `notes/2026-09-15-c1190-milestone-c.md`, the report on aggregation at layer
boundaries and arithmetic comparisons in the stratified Rel lowering. Predecessors read for the
state it builds on: `notes/2026-09-15-c1190-per-column-domains.md` and its audit
`notes/2026-09-15-c1190-per-column-domains-audit.md` (whose format and rigor this audit imitates),
`notes/2026-09-15-c1190-milestone-b.md` and `notes/2026-09-15-c1190-lowering-architecture.md`.
Rules read in full before touching the code: `~/src/ergodis-dev/PERFORMANCE.md`, and the playbook
sections "Measurement and acceptance", "Retained controls", "The interleaved A/B" and "Reporting"
in `~/src/ergodis-dev/performance-playbook.md`.

Code under audit: `~/src/ergodis-private` at `4c18658`, the six commits `79e9c52 … 4c18658` from
`9d5bf64`, consuming `~/src/ergodis` read-only. Both repositories were clean at the start and are
clean now. `~/src/ergodis` is at `3c3e7f8`, dated 2026-09-14, which predates every commit of this
task and is in a different repository, so the report's claim 3 that the core rule contract is
untouched holds. The measured arms `ergodis-tools-606136e` and `ergodis-tools-b1ce519` are present
under `~/.cache/ergodis/bin/`, were used as retained and never rebuilt, and both `sha256sum` and
the `.sha256` sidecars reproduce the report's table exactly.

This audit is read-only except for one transient mutation (item 3 of "What reproduced"), applied
with the Edit tool in two variants, measured, and reverted with the Edit tool.
`sha256sum src/rel_stratified.rs` returns the pristine
`9d83c109d2848bdd7fc66656011f2c6f7d4596780cfd777e66f9ebae7ab3c365` and `git status --short` is
empty in both `~/src/ergodis-private` and `~/src/ergodis`; the four test binaries are green again
after the revert. Nothing was staged, committed or reset anywhere except this file in
`~/src/othello`. Working files are under `~/.cache/ergodis/c1190-milestone-c-audit/`, never `/tmp`.

The tool runs below use the retained candidate `ergodis-tools-b1ce519` rather than a fresh
`cargo run --release`. `b1ce519` is the measured candidate and the commit after it adds only
receipts, so the binary and `HEAD` are the same program for `rel-lower`; the gate runs, the
mutation runs and the parity replay all went through `nix develop ~/src/ergodis` at `HEAD`.

## What reproduced

| Claim under audit | Method | Result |
| --- | --- | --- |
| Gates: `rel_lowering` 49, `rel_frontend` 28, `rel_frontend_portability` 1, `rel_reference_eval` 19, all passing | `choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private --test rel_lowering --test rel_frontend --test rel_frontend_portability --test rel_reference_eval -j 8` | 49 / 28 / 1 / 19 passed, 0 failed. Exact |
| Clippy on both crates and `cargo fmt --check` | `~/.claude/bin/run-quiet` on the report's two Clippy lines and the `fmt` line | exit 0, no diagnostics, formatting clean |
| `tests/rel_lowering.rs` went from 46 fixtures to 49, with the four named ones and the one renamed | `git show 9d5bf64:tests/rel_lowering.rs \| grep -c '^#\[test\]'` against the same grep at `HEAD`; `grep -c "fn <name>"` for each | 46 → 49; all four fixture names present; the old `…_is_represented_and_rejected_by_the_backend` exists at `9d5bf64` and not at `HEAD`. Exact |
| Three aggregate records rebuild independently, counts and SHA-256 digests | `~/.cache/ergodis/c1190-milestone-c-audit/rebuild.py`, which groups a hand-transcribed closure, applies the operator, orders groups by dictionary id and digests the tuples as little-endian `u32`, against `rel-lower --source-file agg1.rel` on `def w = {(1, 10); (1, 5); (2, 7); (2, 7); (3, 4)}` with `sum`, `count` and `min` | `ag0` `sum` 3 facts `27745646…`, `ag1` `count` 3 facts `7842eebf…`, `ag2` `min` 3 facts `7274a8e5…`. All three digests and all three counts match the tool's records field for field |
| Two comparison records rebuild independently | Same script on `def p = {(1, 3); (2, 2); (5, 4); (7, 1)}` with `x < y` and `x >= y`, enumerating `D₀ × D₁` in dictionary-id order | `cf0` `<` universe 16, 5 facts, `ae47b94c…`; `cf1` `>=` universe 16, 11 facts, `eaa43303…`. Both exact |
| Set semantics, the empty group, and the dictionary extension | The same `agg1.rel` run: `w` is written with `(2, 7)` twice and `k` holds a key `4` that `w` has no tuple for | `closure_tuples` 4 not 5, so the duplicate is one tuple and `count` gives 2/1/1; key `4` yields no result tuple at all; `sum` reports `interned: 1` for the value 15 and `dictionary` 8 against `dictionary_base` 7. Every reading in "Semantics adopted" holds in the shipped code |
| Corpus sizes and verdicts: 400 aggregation over ten shapes, 400 comparison over eight, 600 negation over sixteen, 1,200 in-fragment, 400 near-miss (387 rejected, 13 backend divergences) over twenty-three shapes, 120 name-resolution, zero disagreement | `cargo test … --test rel_reference_eval -j 8 -- --nocapture --test-threads 1` | Every count, every shape count and every verdict reproduces, including the near-miss decomposition 74 range-restriction, 53 stratification, 260 fragment, and the 13 `REL0503` arity divergences |
| Deliberate mutation 1 — the group fold's seed — breaks | Edit `src/rel_stratified.rs:763` in two variants, run `rel_lowering` and `rel_reference_eval`, revert with the Edit tool | The mutation is caught, but the report's stated failure list belongs to a different mutation from the one its prose describes. See defect 1 |
| Parity: 241 cases, 520,916 canonical bytes, native and WASM byte-equal, SHA-256 `abc3a493…c446b85` | `choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py --output ~/.cache/ergodis/c1190-milestone-c-audit/portability-audit.json` (native and WASM, 5.4 s) | All four figures reproduce, and the regenerated receipt is byte-identical to the committed `analysis/rel-frontend/portability-v1.json`. The split 97 admit / 40 lower / 57 rejected / 144 not reached is in the receipt's `record_summary` and reproduces exactly |
| The aggregate cohort series at key sets 32 / 64 / 128 | `ergodis-tools-b1ce519 rel-lower --cohort aggregate --definitions <n> --max-tuples 0` | Source bytes 996 / 1,870 / 3,768; dictionary 77→94, 154→186, 308→373; aggregate facts 96 / 192 / 384 (`3N`); filter facts 496 / 2,016 / 8,128 (`N(N−1)/2`) over candidates 1,024 / 4,096 / 16,384; layer-zero bytes 26,135 / 96,690 / 376,673 and layer-one 6,378 / 11,905 / 23,059. Every figure exact; peak RSS differs by tens of KiB, which is the noise the report itself calls it |
| The comparison boundary: key set 213 runs at 22,578 filter facts, 214 is refused | Same command at 213 and 214 | 213 runs, filter 22,578, layer bytes 1,042,903; 214 is `REL0503`, budget "canonical bytes of one layer's program", found 1,052,719, limit 1,048,576. Exact |
| At the boundary the three aggregates are 639 facts against the comparison's 22,578, under three per cent | Same run at 213 | 639 and 22,578, a 2.75 per cent share. Exact |
| The aggregate-only bisection: key set 1,365 runs, 1,366 is the first refusal, on the lowering workspace's fact capacity at 4,097 against 4,096, layer program 178,258 bytes, dictionary 3,959 | My own generator `genagg.py`, written from the shape of `~/.cache/ergodis/c1190/aggonly.rel` and not from that file, emitting `k` in blocks of 32 and `w(i, 10i), w(i, 20i)` in blocks of six, then one `sum` | 1,365 runs with dictionary 3,959 and layer bytes 178,258; 1,366 is `REL0503`, budget `facts`, found 4,097, limit 4,096. Every figure reproduces from an independently generated source, which is stronger evidence than the report's own untracked probe carries. The "47 keys from firing" reconciles: the dictionary grows about 2.9 entries per key, so 4,096 entries is about key set 1,412 |
| Arms: repository, revision, clean tree, rustc, retain recipe, measured hashes | `sha256sum` on the two retained binaries, their `.sha256` sidecars and the `MANIFEST.tsv` rows | Both hashes match the report's table; both rows say `clean`, `rustc 1.95.0 (59807616e 2026-04-14)`, `release`, no features. The four receipts carry the same two hashes and the same toolchain string |
| Scan, parse and admit ratios on all five default cohorts plus `datalog` and `stratified` | `~/.cache/ergodis/c1190-milestone-c-audit/rederive.py` over the four committed receipts | Every one of the 21 ratios matches the report's tables to the printed digit, including the `comment-string` 1.000011 / 1.000005 / 1.000007 that is the largest at eleven parts per million |
| Lowering-stage composed figures and ratios: 6,283/6,286, 6,296/6,302, 1,888,641/1,884,301, 1,370,392/1,368,762, 2,269,355/2,269,203 | Same script, `lower` minus `admit`, instructions | Exact, giving 0.99944, 0.99896, 1.00230, 1.00119, 1.00007, and the two unreadable malformed rows at −5/1 and −2/−0 |
| A/A instruction nulls 0.9999999, 1.0000004, 0.9999996, 1.0000020, 0.9999999 | Same script, the `byte over byte (A/A null drift)` comparisons | Exact, all five. The receipts also carry a second `candidate over control` null family the report does not quote, largest 1.0000082 on `datalog`, still within nine parts per million |
| Memory: `Workspace::retained_bytes` 11,045,388 on both arms and every cohort; peak RSS `ascii` `lower` byte 6,408 → 6,348 and `comment-string` 6,012 → 6,140 | The four receipts' `record` blocks | Every figure exact, and the reserved-workspace byte identity holds on all four receipts including the candidate-only one |
| Both lowering fingerprints bit-identical across arms | The `datalog` and `stratified` receipts' `lower/byte` records | `16adff1ed85f7e04` and `cf5e1f0fbea05d75` on both arms, and the representation fingerprint `1c67273131487fa9` likewise. The freeze the measurement needs does hold |
| The `aggregate` cohort's stage counters and derived figures: 507,136 / 1,303,489 / 1,590,586 / 3,744,894 instructions, 16,009 source bytes, 7,460 tokens, 6,320 nodes, 7 relations, 5 rules, 1,536 facts, 1,229 values, 6 strata, 1 binarized, fingerprint `32fafb12b5c66f90`, A/A null 0.9999980 | The candidate-only receipt | Every figure exact. The composed 2,154,307 (the report rounds to 2,154,308), 134.6 per source byte and 341 per node all recompute |
| My own interleaved A/B round pair against the two retained binaries | `choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py --binary …-b1ce519 --control …-606136e --rounds 2 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower --events instructions,cycles,branches,branch-misses,page-faults,minor-faults --out ~/.cache/ergodis/c1190-milestone-c-audit/ab-datalog-audit.json` | `datalog` lowering ratio 1.00119, the report's figure to five digits; candidate 1,370,379 against the receipt's 1,370,392 (9.5 ppm) and control 1,368,745 against 1,368,762 (12 ppm). `retained_bytes` 11,045,388 on both arms. My A/A nulls 10.5 and 11.2 ppm, wider than the receipt's two because two rounds at load 1.48–3.89 |
| `comment-string` executes none of this milestone's code | The receipt's `comment-string/lower/byte` record on both arms | `REL0503`, budget `relations`, found 896 against a limit of 64, with identical tokens, nodes and representation fingerprint on both arms. The cohort's refusal is reached before range restriction, binarization or the close pass, so the report's reading of the +0.23 per cent is sound as far as counted evidence can take it. See defect 5 |
| min-plus is structurally deferred because the fragment cannot write a min over sums | Read `term` (`src/rel_frontend/lower/build.rs:1808`), then two probes: `s = min[c: p(x, y, c + 1)]` and `y = 1 + 1` | `term` admits a wildcard, a variable or a constant and nothing else; both probes are `REL0504` at the lowering stage. The deferral is structural exactly as claimed |
| Claim 5: the reference evaluator reads the node pool and nothing else | `rg -n '^use ' tests/rel_reference/mod.rs` | Two lines: `std::collections::{BTreeMap, BTreeSet}` and `ergodis_private::rel_frontend::{Kind, Node, NodeKind, NONE}`. The `CMP_*` and `AGG_*` discriminants are defined locally at lines 96–112. Exact |
| Claim 8: the allocation gate drives twelve sources | `tests/rel_lowering.rs:1595` | Twelve: `datalog`, `ascii`, `stratified`, `columns`, `columns3`, `aggregate`, `unbound`, `wide`, `disjuncts`, `cycle`, `bad_aggregate`, `bad_comparison`. Exact, and the three new ones are the ones the report names |
| The Figure 3/4 table is 35 rows, 17 evaluated, 14 rejected, 2 admission, 2 not parsed; the surface table is 28 rows; the rejection surface is 20 | Counting `outcome: Outcome::…` fields inside each table's range in `tests/rel_reference_eval.rs` | 17 / 14 / 2 / 2 summing to 35; 28 `Surface` rows; 20 `REJECTIONS` rows. Every count exact. The `comparison` row's outcome did move to `Evaluated`; its prose did not. See defect 3 |
| The per-column audit's `MAX_COMPLEMENT` repair landed | `verify_records` (`src/rel_stratified.rs:908`) | `if record.universe > MAX_COMPLEMENT { return mismatch; }` is present before the membership vector is reserved, and the filter loop carries the matching `MAX_FILTER` guard. That closes per-column audit item 9's second half |
| The design note's three concessions to the later direct constructor | Read `aggregate_over`, `filter_over`, `complement_over` and the layer loop | All three hold concretely: `aggregate_over` returns a flat `Vec<u32>` and the caller builds the `Fact`s from it; the record carries the relational-IR id, the operator and the column, with the string `ag{n}` generated where the `Relation` is pushed; and each layer declares `domain: dictionary.len().max(1)`, with `MAX_UNIVERSE` and `MAX_INDEX_KEYS` re-checked per relation against that number |
| Chained aggregates keep `verify_records` reproducible | `chain3.rel`: a `sum` whose result feeds a relation that a second `sum` aggregates | Both records verify. The truncation to `dictionary_before` is sound because every value in a closure an aggregate reads was interned strictly before that aggregate ran, so no closure value can fall outside the truncated dictionary. I looked for a checker false-negative here and there is none |

## Semantics reading

The two constructions are exact, and the report's "Semantics adopted" describes the shipped code
faithfully on every point I could test — with one omission, which is defect 2.

**An aggregate.** `aggregate_over` (`src/rel_stratified.rs:731`) walks the certified closure of the
aggregated relation in chunks of its arity, forms the group key from every position but the
aggregated one in order, and folds the aggregated column's integer payload into an `i128`
accumulator held in a `BTreeMap` keyed by that group. `count` adds one per tuple, `min` and `max`
take the extremum, `sum` adds. The first tuple of a group seeds the accumulator through
`or_insert` and the rest fold through `and_modify`, which is why `count` does not double-count its
first tuple — the property instructive negative 3 records. The output is one tuple per group, the
key followed by the interned result, emitted in ascending group-key order; since the result is a
function of the key, that is ascending lexicographic order of the whole tuple, which is the order
the digest fixes. A closure is a set, so `count` counts distinct tuples and `sum` sums distinct
pairs; I confirmed this by writing `(2, 7)` twice and getting `closure_tuples` 4, not 5. A group
exists exactly when the closure holds a tuple for it, so a key the relation does not produce has no
result tuple and the enclosing rule derives nothing for it; I confirmed this with a key relation
wider than the weighted one. An `i64::try_from` on the accumulator turns an out-of-range `sum` into
a refusal rather than a wrap.

**A comparison.** `filter_over` enumerates `D₀ × D₁` in each column's ascending dictionary-id order
and keeps the pairs `satisfies` accepts. `satisfies` (`src/rel_stratified.rs:686`) decides `=` and
`!=` on the dictionary id, which is exact because interning is by value and distinct kinds never
share an id, and decides the four orderings on the integer payload, returning false when either
operand's kind is not `VALUE_INT`.

**The ordering comparison on non-integers is total, and it is applied consistently on both sides.**
The lowering's `satisfies` returns false; the reference evaluator's body-filter arm
(`tests/rel_reference/mod.rs:1777`) matches `(Value::Int(a), Value::Int(b))` and falls through to
`false` on anything else. The two are the same function, written independently, with no operand-
domain analysis on either side — which is the point of the reversal the report records, and it is
the right call for the reason milestone (b) established: a refusal both sides must agree on is only
cheap when the condition is syntactic, and "this variable's domain might hold a symbol" is not.
What is refused instead is the syntactic case, at build time and on both sides: `src/rel_frontend/
lower/build.rs` refuses `op >= CMP_LT` against a `TERM_CONSTANT` whose value kind is not
`VALUE_INT`, and `tests/rel_reference/mod.rs:899` does the same test on its own staged terms.

The report states the consequence — `<` and `>=` are not complementary on a mixed domain — and I
measured it rather than taking it on trust. On `def e = {(1, "a"); ("a", 1); (2, 1); ("b", "a")}`
the two filters over the same universe of 8 candidate pairs hold 0 and 2 facts respectively; they
do not partition the universe, because six pairs are false under both. The program is accepted and
`lt` is empty.

**Is there a program in the fragment where the total reading silently changes a result a user would
expect?** Yes, and it is worth naming even though I do not think it should be changed. Take a
relation whose second column mixes integers and symbols, say prices for some items and the symbol
`:unknown` for others, and write `cheap(x) = price(x, p) and p < 100`. Under the total reading the
`:unknown` rows are silently dropped; under a refusal the program would not run at all; under a
three-valued reading the rule would be undefined. Dropping is the reading a SQL user would also
get, it is the only one of the three the route can implement without a domain analysis on both
sides, and the report states it. The genuine hazard is the *dual*: `expensive(x) = price(x, p) and
p >= 100` also drops those rows, so `cheap` and `expensive` do not cover `price`'s first column, and
a reader who assumes they do has a wrong program the checker will happily certify. That is exactly
what the report's one-sentence consequence says, and I would leave the semantics alone and let the
sentence carry it.

**The aggregate binds.** `range_restrict` (`src/rel_frontend/lower/passes.rs`) now treats
`SIGN_AGGREGATE` like `SIGN_POSITIVE` in both of its loops: an aggregate literal contributes its
mask to `bound` and is not itself checked for a residue. That is sound for the reason the report
gives — the atom the backend projects it into reads the group-key-and-result relation, which
supplies values for every term of the literal — and it is what lets the result variable be a head
variable. The aggregated binder is scoped only while the body is built (`rir.scope.truncate(mark)`)
and never appears in the literal, so it is not a variable of the enclosing rule at all. The
reference evaluator adopts the same three tiers in `positives_first`, with aggregates between the
binding atoms and the filters, which is the only ordering that lets a filter read an aggregate's
result.

**min-plus.** Confirmed structural rather than a matter of effort. `term` admits a wildcard, a
variable or a constant and returns `Err(fragment(n))` for anything else, so no admitted source can
put a sum in a term position, and an aggregated column that is itself a sum is unwritable. Both of
my probes are `REL0504`. The carrier selection the architecture note describes has nothing to
trigger on, and the report names the right construct as the prerequisite.

**The dictionary extension.** Entries are only appended (`Dictionary::intern_int` pushes), each
layer declares `domain` as the dictionary stood when it was built, and `MAX_DOMAIN`,
`MAX_UNIVERSE` and `MAX_INDEX_KEYS` are re-checked against that number. `verify_records` rebuilds
an aggregate against `dictionary.truncated(record.dictionary_before)`, which recovers the earlier
state exactly because nothing ever moves. I checked the one way that could go wrong — an aggregate
reading a closure that already contains a value some earlier aggregate interned — and it cannot:
any such value was interned strictly before this aggregate's `dictionary_before` was taken. The
chained-aggregate probe verifies.

## Defects found

**1. The mutation-1 description and the failure list it is credited with belong to two different
mutations. Moderate; evidence.** Location: "The two deliberate mutations", item 1, and mystery
ledger item 3's claim that "the mutations show the corpora still decide them". The report describes
the mutation as "the group fold seeded at zero rather than at the first tuple's payload" and states
its arithmetic: "seeding at zero makes `count` correct and `min` wrong — the minimum of a group of
positive integers becomes zero — and leaves `sum` right." It then credits that mutation with two
lowering fixtures failing, "including the agreement with the independent Python oracle", and three
differential tests: `the_aggregation_corpus_agrees`,
`the_committed_fixtures_agree_with_the_reference_evaluator` and the Figure 3/4 table. I ran both
readings.

The mutation the prose describes — the fold genuinely seeded at zero, which I wrote as
`.or_insert(match operator { AGG_COUNT => 1, AGG_MIN => 0i128.min(payload), AGG_MAX =>
0i128.max(payload), _ => payload })` — has exactly the arithmetic the report states, and fails
**two** tests: `the_four_aggregates_are_computed_at_the_layer_boundary` and
`the_aggregation_corpus_agrees`. It cannot fail the oracle fixture, because
`tests/support/rel-closure-expected.json` carries only `count` and `sum` aggregates and both stay
correct under it; and it does not fail the committed-fixture or Figure 3/4 comparisons, which I
confirmed by running them.

The mutation that produces the report's exact failure list is the plain `.or_insert(0)`, which
leaves `and_modify` unreached for the first tuple of every group. That drops the first tuple from
the fold entirely: `count` undercounts by one, `sum` loses one addend and `min` collapses to zero.
Under it I get precisely two lowering failures — `every_fixture_agrees_with_the_independent_oracle`
and `the_four_aggregates_are_computed_at_the_layer_boundary` — and precisely three differential
failures — `the_aggregation_corpus_agrees`,
`the_committed_fixtures_agree_with_the_reference_evaluator` and
`every_figure_three_and_four_equation_agrees_with_the_reference_evaluator`.

So the failure list is real and was really measured; the sentence that explains what was changed
describes something else. *Repair*: describe mutation 1 as the accumulator initialized to zero
instead of the first tuple's payload, so that the first tuple of every group is dropped from the
fold — `count` undercounts by one, `sum` loses one addend and `min` becomes zero — and keep the
five-test failure list, which that mutation does produce. Then take the free strengthening: record
that the *other* seeding defect, the one whose arithmetic the report currently states, is caught by
only two tests, because the oracle expectations carry no `min` or `max`. That is the sharper
statement about what the corpora discriminate, and it points at a cheap upgrade — adding a `min`
fixture to `rel-closure-expected.json` — that would make the oracle decide both.

**2. "Semantics adopted" never says what an aggregate does when its column is not an integer, and
the two sides disagree there. Moderate; semantics and differential coverage.** Location: the
paragraph "What an aggregate denotes", which says only that `min`, `max` and `sum` are "the
corresponding function of their integer payloads". The shipped lowering *refuses the whole
program*: `aggregate_over` returns `AggregateRefusal::NotAnInteger` whenever a non-`count` operator
meets a value whose kind is not `VALUE_INT`, and the layer loop turns that into `REL0504` at the
literal's span. I measured it: `def w = {(1, 10); (1, "a"); (2, 7)}` with a `sum` gives `REL0504`
at the backend stage. The reference evaluator does something different: `aggregate_relation`
(`tests/rel_reference/mod.rs:1838`) maps a non-integer payload to `None`, poisons that group's
accumulator, and then *skips the poisoned group* while keeping every other group — so it accepts
the program and derives `s(2, 7)`.

This is the same class of defect as recorded disagreement 1, for aggregates instead of
comparisons, and it survives because no corpus reaches it: the aggregation generator's ten shapes
all weight with integers, and the near-miss corpus's six aggregate shapes are all syntactic. The
shipped code is not unsound — the lowering refuses rather than computing something wrong — but the
report's own standard is that a refusal both sides must agree on has to be syntactic, and this one
is not: whether a column holds a non-integer is a property of a closure, exactly the operand-domain
analysis the comparison reversal was made to avoid. *Repair*: state the reading in "Semantics
adopted" — an aggregate whose column meets a non-integer is `REL0504` at the literal — record in
the instructive negatives that the reference evaluator drops the offending group instead, and add
one near-miss shape that aggregates a mixed column so the disagreement is decided by the corpus
rather than left to the next reader. If the intent is to match the comparison reversal, the total
reading is available and cheaper: drop the group on both sides.

**3. The committed surface-construct table describes the reverted comparison semantics. Minor;
factual, in a record the project treats as its semantics map.** Location:
`tests/rel_reference_eval.rs:1143`, the `comparison` row's `treatment`, which reads "… the four
orderings are defined on integers, and an operand domain holding another kind is REL0504 at the
literal". That is the first implementation, which the task reversed. The shipped behaviour is that
an operand domain holding another kind makes the comparison *false*, with no refusal; only an
ordering comparison against a non-integer *constant* is `REL0504`. The adjacent rejection-surface
row was correctly updated in the same commit from "comparison literal" to "an ordering comparison
against a constant that is not an integer", so this is a missed edit rather than a misunderstanding.
The report's claim 7 leans on these tables ("the surface-construct table … fail if any outcome
moves"), and the outcome did move correctly; only the prose did not. *Repair*: replace the clause
with "Equality and inequality hold on any kind; the four orderings are decided on integer payloads
and are false on any other kind, and only an ordering comparison against a constant that is not an
integer is REL0504 at the literal."

**4. A synthesized aggregate or filter relation can collide with a source relation's mangled name,
and the collision is an opaque backend failure. Minor; robustness, with an exact repair the
codebase already contains.** Location: `src/rel_stratified.rs`, `let name = format!("ag{}",
aggregate_built.len())` and `let name = format!("cf{}", filter_built.len())`, against
`complement_name(sequence, taken)` at line 398, which exists precisely to break this collision by
appending `_` until the name is unused. Relation mangling keeps ASCII alphanumerics and underscores
and prefixes `r` only when the first kept byte is not alphabetic, so a source that writes `def ag0
= …` produces a relation literally named `ag0`. I measured both: `def ag0 = {(1, 99)}` with a `sum`
whose result relation lands in the same layer fails with `Core(Source)`, and the same construction
with `def cf0` and a comparison fails the same way. The failure carries no `REL0…` code and no
span, so an admitted, in-fragment program is refused by an error the diagnostic surface cannot
explain, and the differential would score it as an unrecorded backend divergence. *Repair*: route
both names through `complement_name`, or give it a prefix parameter and call it three times;
`complement_name(aggregate_built.len(), &relations)` with prefix `ag` is the whole change. A
near-miss or in-fragment shape that names a relation `ag0` would keep it fixed.

**5. The `comment-string` swing is argued from where the cohort fails, not from the code, and the
argument is one step short of what the playbook asks. Minor; evidence scope.** Location: "The
lowering stage" and mystery ledger item 5. The report's reasoning is sound as far as it goes and I
confirmed its premise from the receipts: the cohort is `REL0503` on the `relations` budget at 896
against 64, identically on both arms, with identical tokens, nodes and representation fingerprint,
and that refusal is reached before range restriction, binarization or the close pass, all three of
which are where this milestone's changes to the measured stage live. So no instruction of the
change executes and +0.23 per cent cannot be a cost of it. What the playbook asks for on top of
that is the disassembly — "Check a kernel is unchanged by disassembling its symbols in both
binaries" — and the report declines it for the fifth time while calling it overdue. I agree with
the ledger's framing and add one supporting figure it does not use: on the same cohort and the same
rounds, `scan`, `parse` and `admit` move by at most eleven parts per million while `lower` moves by
2,300, so whatever moved is confined to one stage's code layout rather than being a drift in the
measurement. *Repair*: none to the conclusion. Add the three-stage contrast to the paragraph, since
it is already in the receipt and it is the cheapest available evidence that the swing is
stage-local, and leave the profile in the ledger.

**6. The aggregate-only bisection's source is an untracked cache file, and the mystery ledger
treats its number as settled while the measurement section disclaims it. Minor; reproducibility and
internal consistency.** Location: "And where aggregation runs out", which says the probe "is a
generated source under `~/.cache/ergodis/c1190/aggonly.rel` rather than a committed cohort, so it is
reported as a one-off measurement and its number is not load-bearing", against mystery ledger item
1, which opens "**Settled:** … the first refusal is the lowering workspace's own fact capacity at a
key set of 1,365" and closes "*Nothing about this item is open.*" A figure cannot be both
non-load-bearing and the thing that settles a ledger item.
`notes/research-reproducibility-conventions.md` is explicit that a local cache entry is never sole
evidence. There is also no committed generator: `~/.cache/ergodis/c1190/aggbisect.py` bisects the
`aggregate` cohort, not this probe, and the `.rel` file is the only artifact of it. I regenerated
the source from its shape with an eight-line script and every figure reproduced — 1,365 runs at
178,258 bytes and dictionary 3,959, 1,366 refused at 4,097 against 4,096 — so the *result* is
sound; it is the *evidence* that is not committed. Also note the off-by-one between the two places:
1,365 is the largest key set that runs and 1,366 is the first refusal, and the ledger's phrasing
puts the refusal at 1,365. *Repair*: commit the eight-line generator beside the report, or add the
probe as a cohort; say 1,366 for the refusal in the ledger; and if neither is wanted, downgrade
ledger item 1 to cite only the boundary figures the committed `aggregate` cohort produces.

**7. "It lowers completely" at 512 definitions means the frontend lowering stage, not the layer
chain, and a reader will take it the other way. Minor; wording.** Location: "The `aggregate` cohort,
and where the route runs out", first paragraph. At 512 the cohort's comparison would need a filter
relation of 130,816 facts, which is fifty-eight times the measured ceiling the same section
establishes at 213 — so the sentence as written contradicts the boundary table two paragraphs
below. What the receipt actually records is `lowered: true` from the measured `lower` stage, which
is the frontend lowering into the relational IR and stops before the stratified backend. *Repair*:
"it lowers to a relational IR completely: 7 relations, 5 rules, …", and add that the measured stage
stops before the layer chain, which is why 512 is measurable and 214 is not.

**8. Two derived figures are one unit off their source. Trivial.** Location: the `aggregate` cohort
paragraph, "2,154,308 instructions", where `lower` minus `admit` over the receipt's means is
2,154,307; and the fixtures table, which credits `a_comparison_literal_becomes_a_filter_relation`
with asserting "the filter's operator, product and fact count" — it does, and the claim is right, so
only the first is a figure. *Repair*: 2,154,307, or state the rounding.

## Verdict

The milestone's substance holds, and the two constructions are as independently checkable as the
report claims. Every record I rebuilt from scratch rebuilt: three aggregate records and two
comparison records match their recorded counts and SHA-256 digests field for field, computed from
nothing but the closure, the operator and the dictionary ordering. Every semantic reading in
"Semantics adopted" that I could test is the reading the code implements — set semantics, the
absent group, the constant group-key column, the append-only dictionary extension, the aggregate
that binds — and the total ordering comparison is implemented identically and independently on both
sides, which is the thing the report most needed to be right about. The structural deferral of
min-plus is genuine: `term` admits a wildcard, a variable or a constant, and both of my arithmetic
probes are `REL0504`. All four corpora reproduce at their stated sizes with zero disagreement, the
parity replay regenerates a receipt byte-identical to the committed one at 241 cases, 520,916 bytes
and `abc3a493…`, both boundaries reproduce exactly — including the aggregate-only one from a source
I generated myself rather than from the report's cache file — and every stage ratio, A/A null, arm
hash, peak-RSS figure and the reserved-workspace byte identity re-derives from the four committed
receipts. My own interleaved A/B against the two retained binaries returns the `datalog` lowering
ratio to five digits and the instruction counts to about ten parts per million.

Two defects are worth acting on and the rest are hygiene. The first is that mutation 1's prose and
its failure list describe two different mutations: the list is real and belongs to the accumulator
initialized to zero, while the arithmetic the report states belongs to a genuinely zero-seeded fold
that only two tests catch. Nothing in the shipped code is wrong, but the discrimination evidence
for claim 6 is weaker than it reads, and the gap points at a cheap upgrade — the committed oracle
expectations carry no `min` or `max`, so the oracle cannot decide a min-only defect at all. The
second is a genuine and untested disagreement the report does not mention: an aggregate whose
column meets a non-integer is refused outright by the lowering and quietly loses one group in the
reference evaluator, which is the same class of defect as the comparison disagreement the task went
to some trouble to remove, surviving only because no corpus weights a relation with anything but
integers. Beside those, the committed surface-construct table still describes the reverted
comparison semantics, the synthesized `ag{n}` and `cf{n}` relation names skip the collision guard
that `complement_name` applies to `nc{n}` and turn a legal program into an opaque `Core(Source)`
failure, the aggregate-only bisection rests on an untracked cache file that the mystery ledger
nonetheless treats as settled, and "it lowers completely" at 512 definitions means a stage that
stops before the layer chain the same section bisects at 213.

On the question the brief asked about the total ordering comparison: the reading is right, it is
applied consistently on both sides, it is stated with its consequence, and the consequence is the
real hazard — `cheap` and `expensive` written as `p < 100` and `p >= 100` do not cover a mixed
column, and the certificate will not say so. I would keep the semantics and keep the sentence. The
same question asked of aggregates has a different answer, and that is defect 2.
