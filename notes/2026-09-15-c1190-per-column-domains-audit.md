# C1190 milestone (b′) — per-column domains: independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: COMPLETE. Written incrementally from the start of the audit.

## Scope

Target of the audit: `notes/2026-09-15-c1190-per-column-domains.md`, the report on per-column domains
for the complement construction of the stratified Rel lowering. Predecessors read for the state it
builds on: `notes/2026-09-15-c1190-milestone-b.md`, `notes/2026-09-15-c1190-milestone-a-audit.md`
and `notes/2026-09-15-c1190-lowering-architecture.md`. Rules read in full before touching the code:
`~/src/ergodis-dev/PERFORMANCE.md`, and the playbook sections "Measurement and acceptance",
"Retained controls", "The interleaved A/B" and "Reporting" in
`~/src/ergodis-dev/performance-playbook.md`.

Code under audit: `~/src/ergodis-private` at `3c0992f`, the ten commits `3895dbc … 3c0992f` from
`73dd56b`, consuming `~/src/ergodis` read-only. Both repositories were clean at the start and are
clean now; `~/src/ergodis` is at `3c3e7f8` (2026-09-14) and no commit of this task is in it, so the
report's claim 6 holds. The measured arms `ergodis-tools-ebecae2`, `ergodis-tools-ef358f8` and
`ergodis-tools-606136e` are present under `~/.cache/ergodis/bin/` and were used as retained, never
rebuilt.

This audit is read-only except for one transient mutation (item 3 below), which was applied with the
Edit tool, measured, and reverted with the Edit tool; `sha256sum src/rel_stratified.rs` returns the
pristine `defbe7db50c47e50f2e13be0c8adc43367ffe58f48a47ee11606eac349dab899` and
`git status --short` is empty in all three repositories. Nothing was staged, committed or reset
anywhere except this file in `~/src/othello`. Working files are under
`~/.cache/ergodis/c1190-audit/`, never `/tmp`.

## What reproduced

| Claim under audit | Method | Result |
| --- | --- | --- |
| Gates: `rel_lowering` 46, `rel_frontend` 28, `rel_frontend_portability` 1, `rel_reference_eval` 17, all passing | `nix develop ~/src/ergodis --command cargo test -p ergodis-private --test rel_lowering --test rel_frontend --test rel_frontend_portability --test rel_reference_eval -j 8` | 46 / 28 / 1 / 17 passed, 0 failed. Exact |
| `tests/rel_lowering.rs` went from 42 fixtures to 46, with the four named new ones | `git show 73dd56b:tests/rel_lowering.rs \| grep -c '^#\[test\]'` against the same grep at HEAD; `grep -q "fn <name>"` for each | 42 → 46; all four new fixture names present. Exact |
| Deviation 1: the column type's sub-range is not a sound filter, and the parity corpus carries the worked counterexample | `ergodis-tools rel-lower --source-file` on `def w = {"a"; ^E1} / def n = {1; 2} / def k = {^E2} / def mix(a, b) = w(a) and n(b) and not k(b)` | `k`'s column reports `type` 3, `type_range` [3,5), `source` bound, site `("n", 0)`, 2 values, `closure_inside` 0, 2 complement facts, and `mix` derives all four tuples. Intersecting the domain with [3,5) empties it. The counterexample is real and demonstrates exactly the unsoundness claimed |
| Three complement records rebuild independently, counts and SHA-256 digests | `~/.cache/ergodis/c1190-audit/rebuild.py`, which enumerates ∏ᵢ Dᵢ minus the closure in ascending lexicographic order and digests the values as little-endian u32, from domains and closures transcribed by hand from the source programs | `mix/nc0` universe 2, inside 0, 2 facts, `01acecb5…`; `gap/nc0` universe 4, inside 1, 3 facts, `4107000e…`; `narrow/nc0` universe 3, inside 1, 2 facts, `9882ec2a…`. All three match the tool's records field for field |
| Closed-form complement count `N² − 2N + 2` plus `⌊N/2⌋` plus 1 | Arithmetic against the measured series | 979, 4,003, 16,195 at N = 32, 64, 128. Exact at every point |
| The `stratified` cohort did not move: 979 / 4,003 / 16,195 facts and 45,080 / 178,792 / 723,680 layer-one bytes | `rel-lower --cohort stratified --definitions {32,64,128} --max-tuples 0` | Bit-identical to milestone (b)'s figures, and `ergodis-tools-ef358f8` gives the same 16,195 and 723,680 at a dictionary of 128, so the identity holds on a binary and not only at HEAD |
| The `columns` series is milestone (b)'s shifted one doubling | Same command with `--cohort columns` | 979 / 4,003 / 16,195 at dictionaries 64 / 128 / 256; saving 4.09× and 4.05× at equal dictionary size. Exact |
| Complement sharing takes three records for four use sites, the shared one reporting `uses: 2` | The `complements` array of the same runs | Three records with `uses` [1, 2, 1] on both cohorts at every size. Exact |
| Corpus sizes and verdicts: 1,200 in-fragment, 600 negation over sixteen shapes, 400 near-miss (377 rejected, 23 backend divergences), 120 name-resolution, zero disagreement | `cargo test … --test rel_reference_eval -- --nocapture --test-threads 1` | All four counts and all verdicts reproduce; sixteen negation shapes; no divergence anywhere |
| Deliberate mutation 1 — a column's domain read without the `established` guard — breaks | Edit `src/rel_stratified.rs:419` to drop `\|\| sites.iter().any(\|site\| !context.established(site.relation))`, run the two suites, revert with the Edit tool | `a_same_layer_binding_relation_falls_back_to_the_dictionary` fails with `ComplementMismatch(0)` and `the_negation_corpus_agrees` fails. Exactly the two failures the report records, including the point that the corpus catches it only because of the `recursive-binding` shape |
| Parity: 230 cases, 484,293 canonical bytes, native and WASM byte-equal, SHA-256 `8ae389f4…9b856eba` | `nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py --output ~/.cache/ergodis/c1190-audit/portability-audit.json` (native and WASM, 3.9 s) | All four figures reproduce, and the regenerated receipt is byte-identical to the committed `analysis/rel-frontend/portability-v1.json`. The split 86 admit / 35 lower / 51 rejected / 144 not reached also reproduces |
| Parity baseline at milestone (b)'s close: 226 cases, 471,171 bytes, `91b007eb…` | `git show 73dd56b:analysis/rel-frontend/portability-v1.json` | Exact, with 31 lowered cases as the report says |
| Boundary bisection: `stratified` 153 at 23,182 facts, `columns` 302 at 22,577, `columns3` 84 at 21,938, first refused 154 / 304 / 87 at 1,054,530 / 1,049,798 / 1,142,025 bytes | `rel-lower --cohort <c> --definitions <n> --max-tuples 0` at the six points | Every fact count, every refusal byte count and every refusal budget name reproduce exactly |
| Arms: repository, revision, clean tree, rustc, retain recipe, measured hashes | `sha256sum` on the three retained binaries, the `.sha256` sidecars, and the `MANIFEST.tsv` rows | All three hashes match the report's table; all three rows say `clean`, `rustc 1.95.0 (59807616e 2026-04-14)`, `release`, no features. The receipts carry the same two hashes and the same toolchain string |
| Scan, parse and admit ratios, all seven cohorts and both scanner variants | `~/.cache/ergodis/c1190-audit/rederive.py` over the committed receipts | Every one of the 42 ratios matches the report's table to the printed digit |
| Lowering-stage ratios, candidate: 1.03442 / 1.03330 / 1.02811 / 1.04536 / 1.02337 on controls 6,074 / 6,091 / 1,832,782 / 1,309,369 / 2,217,375 | Same script, `lower` minus `admit`, instructions | Exact, including the `datalog` delta of 59,392 instructions and the −3 and 0 unreadable rows |
| Lowering-stage ratios, first candidate: 1.03445 / 1.03224 / 1.05444 / 1.08818 / 1.04844 | Same script over the `performance-v1-percolumn-*-ef358f8.json` receipts | Exact |
| A/A instruction nulls: 0.9999992, 1.0000001, 0.9999952, 0.9999958, 0.9999994, 0.9999912, 1.0000012, 1.0000003 | Same script, the `byte over byte (A/A null drift)` comparisons | Exact, all eight |
| My own interleaved A/B round pair against the two retained binaries | `choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py --binary …-606136e --control …-ebecae2 --rounds 2 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower --events instructions,cycles,branches,branch-misses,page-faults,minor-faults --out ~/.cache/ergodis/c1190-audit/ab-datalog-audit.json`, and the same for `--cohorts stratified` | `datalog` lowering ratio 1.04536 on both variants; control 1,309,375 against the receipt's 1,309,369 (5 ppm) and candidate 1,368,764 against 1,368,761 (2 ppm). `stratified` 1.02337, control 2,217,376 against 2,217,375. My A/A nulls 0.6 and 3.3 ppm. Load average 3.50 during the run |
| `columns` cohort stage counters: 717,695 / 1,712,643 / 2,070,037 / 4,860,279 instructions, 20,977 source bytes, 10,587 tokens, 7,870 nodes, 10 relations, 6 rules, 2,303 facts, 1,024 values, 8 strata, 2 binarized, fingerprint `4e25aa3a9aca2655` | The candidate-only receipt's `columns/*/byte` operations and the `lower` record | Every figure exact. The derived 2,790,242 instructions, 133.0 per source byte and 354 per node all recompute |
| `datalog` cohort freeze: the lowering fingerprint moved `aa9451450b65b83e` → `16adff1ed85f7e04` while the program stayed 14 relations, 96 rules, 8 auxiliaries, 8 binarized, 513 values | Both arms' `datalog/lower/byte` records | Exact, and the token/node representation fingerprint is `1c67273131487fa9` on both arms, so the freeze the measurement needs does hold |
| Bytes per complement fact at the three boundaries: 44.89, 45.88, 46.86 | Refused-layer bytes at the running point divided by facts | Exact at all three |
| Claim 4's tamper coverage: seven tampers, each refused | `tests/rel_lowering.rs:727` | Seven cases — digest, `facts`, `closure_tuples`, `closure_inside`, a popped domain value, `universe`, and a provenance naming the wrong column — each asserted to give `ComplementMismatch(0)` |
| Claim 7: nine sources under the counting allocator | `tests/rel_lowering.rs:1423` | Nine: `datalog`, `ascii`, `stratified`, `columns`, `columns3`, the unbound-variable source, the wide fact set, the disjunction expansion and the negation cycle. This closes milestone (a) audit defect 8 |
| The committed independent Python oracle | `python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json` | 13 fixtures agree |

## Soundness reading

The construction is exact, and the argument holds in the code as well as on paper.

For a negative literal `not R(t₁ … t_k)`, argument `i`'s domain is the singleton of the constant
when `tᵢ` is one; otherwise the union, over that variable's binding sites, of the values the named
column holds in the named relation's certified closure; and the whole dictionary when any binding
relation's closure is not yet final (`src/rel_stratified.rs`, `column_domains` at line 391 and
`LayerContext::established` at line 319). The complement is that product minus `R`'s closure,
enumerated in mixed-radix key order with column zero most significant, which over ascending
duplicate-free `Dᵢ` is ascending lexicographic order — the order milestone (b) fixed for the digest.

Why the narrowing loses nothing: range restriction has already established that every variable of
every non-positive literal occurs in some positive literal of the same rule
(`src/rel_frontend/lower/passes.rs:156`, which masks each non-positive literal's variables against
the union of the positive literals' masks and rejects any residue). So a derivation that reaches the
negative literal bound `tᵢ`'s variable through one of those positive literals, and the value it took
is a value that literal's column holds in the relation's closure — hence a member of `Dᵢ`. No tuple
outside ∏ᵢ Dᵢ is ever asked about, and a tuple never asked about cannot change the fixed point
whether the complement holds it or not. This is milestone (b)'s argument applied one column at a
time; the whole dictionary is simply the loosest `Dᵢ` the argument admits, which is why the
`stratified` cohort comes back bit-identical.

The union rather than the intersection is loose in the safe direction: a value must satisfy every
binding literal, so it lies in the intersection and a fortiori in the union. The report's remaining
gap 3 is right that the intersection is sound and tighter.

Three places where the construction could have been wrong and is not:

- **Binarization order.** `bind` runs between range restriction and stratification
  (`src/rel_frontend/lower.rs:1112`), before binarization, so a site names a relation the source
  wrote rather than an auxiliary whose values would depend on the join order. The synthetic rules
  binarization appends carry `vars: rule.vars` and `variables: rule.variables`
  (`src/rel_frontend/lower/passes.rs:673`), so `Rir::binding_sites` on a synthetic rule returns the
  parent's sites. Those sites are the parent's *positive* literals, which is a superset of what binds
  the variable inside the two-literal synthetic body, so the domain is wider than strictly necessary
  and the construction is still exact.
- **The empty-`Dᵢ` case.** `complement_over` returns an empty complement and `closure_inside` 0 when
  the product is zero, rather than the whole product. That is right rather than a special case: an
  empty binding column means no derivation binds the variable at all, so the rule fires for no
  assignment whatever the complement holds, and the record's invariant
  `facts + closure_inside = universe` degenerates to `0 + 0 = 0`. The fixture
  `an_empty_column_domain_gives_an_empty_complement` gates it.
- **Constants, and shared complements.** A constant argument gives `DomainSource::Constant` and a
  singleton domain, which is what collapses the module-member fixture from 22 complement facts to 1
  and the `46⁴` program to one tuple. Sharing is keyed on `(relation, materialized column domains)`,
  not on provenance, so two use sites whose binding literals differ but whose closures agree share
  one complement — which is what "the same complement" should mean, and which the layer's `built`
  list implements by linear search with an equality test on the domain vectors.

The `established` guard is what the construction actually turns on, and the mutation confirms it
discriminates. A relation the current layer derives has no final closure when the complement is
built — nothing has run yet — so reading it would take the domain to be empty and lose every
derivation through the literal. Dropping the guard is caught by `verify_records` itself, because
recomputing the domain against the *final* closure no longer gives the recorded values.

Two limits on what the evidence buys, neither of which is an unsoundness in the shipped code, are in
the defects below as items 9.

## Defects found

**1. Peak resident set and the workspace reservation are absent from the report. Moderate;
reporting.** Location: the "Measurements" section, which has no memory figure anywhere, against
`PERFORMANCE.md`'s required-validation list, which names peak RSS. The committed receipts carry
both numbers and they are not small: `retained_bytes` on the `datalog` cohort goes from 10,373,644
on the control to 11,045,388 on the candidate, +671,744 bytes and +6.5 per cent, and peak RSS rises
by 200 to 280 KiB on every cohort and every stage (`datalog/lower/byte` 5,980 → 6,232 KiB,
`comment-string/lower/byte` 5,992 → 6,232, `stratified/admit/byte` 5,992 → 6,276). *Repair*: add a
paragraph to "The lowering stage, which is what this change costs" giving the retained-bytes and
peak-RSS deltas, attributing them to the `bind` pass's two new pools and the type-range table, and
saying that they are reserved from `Limits` for every program including one with no negation — which
is the same "paid by every program" point the instruction figure already makes.

**2. The report contradicts itself about which placements the candidate carries, and never counts the
placement that did most of the work. Moderate; factual.** Location: the "Arms" paragraph
("the candidate adds the three placements instructive negatives 2 to 4 describe") against the
"Four readings" bullet ("That difference is the whole of instructive negatives 3 and 4"). The second
is right. `git show 3895dbc:src/rel_stratified.rs` has `complement_name(literal, &relations)` and
`git show ef358f8:src/rel_stratified.rs` has `complement_name(built.len(), &relations)`, so
instructive negative 2's fix is already in the first candidate; it also lives in `rel_stratified.rs`,
outside the measured `lower − admit` stage entirely, so it could not have moved those ratios under
any circumstances. Separately, `9b1371a` carries a change the report never lists as a placement: the
single-kind early return in `order_dictionary` (`src/rel_frontend/lower/passes.rs:1009`), which skips
the permutation and both remaps when the dictionary holds one typed-literal kind. `datalog` and
`stratified` intern integers only, so on exactly the two cohorts whose ratios the report quotes, that
unlisted change is the one that acts, not the ordering move — which saves a *refused* program and
those two cohorts lower successfully. *Repair*: in "Arms" say the candidate adds instructive
negatives 3 and 4 plus the single-kind dictionary skip; promote the single-kind skip from the
`ej` closeout to a fourth instructive negative with the two cohorts it acts on; and move instructive
negative 2 to a pre-first-candidate correction, noting it is a backend serialization effect and never
appeared in a lowering-stage ratio.

**3. The 60 per cent cost model is asserted with no arithmetic, and the receipts already support a
sharper decomposition. Moderate; reporting.** Location: instructive negative 5 and mystery ledger
item 6. The report names three components — the `bind` pass's per-variable scan, the dictionary
ordering and its two remaps, and the canonical form's extra bytes — and states "about 60 per cent"
with no unit cost, no counted unit and no component total, which is what the playbook's "Sizing a
candidate: count events, not shares" requires. As written the arithmetic cannot be checked, because
there is none. What the committed evidence does support, and the report does not use: the placements
removed 115,462 − 59,392 = 56,071 instructions on `datalog`, and dumping the canonical form from the
three retained binaries (`rel-lower --cohort datalog --definitions 512 --dump-canonical`) gives
22,904 bytes on the control, 25,828 on the first candidate and 22,948 on the candidate — so the
ungated binding-site block was 2,880 bytes of canonical form and the gating removed all but the 44
bytes of the per-type range table. At the five-instructions-per-byte sink cost milestone (a)'s audit
established, that is roughly 15,000 to 29,000 of the 56,071, leaving the rest to the single-kind
dictionary skip, which is consistent with two passes over 513 values plus remaps over 528 terms and
1,024 fact values. My own counted sizing of what remains in the candidate — the `bind` pass at about
88 rules by three variables by six terms — lands well under the residual 59,392, so if anything the
unattributed share is larger than 40 per cent, not smaller. *Answer to the question posed*: the gap
is a reporting gap on top of a measurement gap. The measurement gap the ledger names is real — only
a kernel-scoped profile bucketed by address range will split `bind` from the enlarged `Rir` move —
but the report has not spent the evidence already in hand, and the byte dump above is a five-minute
measurement that closes the largest single component. *Repair*: replace "about 60 per cent" with the
canonical-byte decomposition and the remaining residual stated as a number, and keep the profile in
the ledger for what is left.

**4. The two new cohorts' value kinds are described wrongly, and the consequence is stated backwards.
Minor; factual.** Location: "The two new cohorts" ("its second over `N` entity references") and "The
complement series" ("its second `N` entity references"), against the Fermi section, which correctly
says symbols. The committed generator (`src/rel_frontend/corpus.rs:180`) emits `:t1 … :tN`, and
`9d5bf64` corrected exactly this wording in the code's own doc comments. The same error makes
`columns3` "integers, entity references and strings"; in fact symbols and strings share the text
kind, so `columns3`'s dictionary has two typed-literal kinds, not three. I measured it:
`rel-lower --cohort columns3 --definitions 4` gives type ranges [0,4) for the integer column and
[4,12) for *both* text columns, while their domains are the disjoint symbol set and string set.
Claim 7 and the code comment above the `columns` source in `the_lowering_stage_does_not_allocate`
(`tests/rel_lowering.rs:1441`) both say "three typed-literal kinds at once" and are wrong for the
same reason. *Repair*: say symbols in both places; say `columns3` carries three disjoint value sets
over two kinds; and take the free strengthening — `columns3` is a better demonstration than the
report claims, because two of its three columns share one type sub-range and are still narrowed to
disjoint domains, which is deviation 1's argument in cohort form rather than in a single fixture.

**5. "Parse and admission are 1.000000" contradicts the table three lines above it. Minor; internal
contradiction.** Location: the paragraph under "Scan, parse and admission did not move". The same
report's table gives `comment-string` byte parse 1.000005 and admit 1.000012. *Repair*: "Parse and
admission are unity to within twelve parts per million, the largest being the `comment-string` byte
admission."

**6. The intermediate parity figure rests on an untracked cache file the report's own inventory does
not name. Minor; reproducibility.** Location: the "Parity" section's middle bullet, "226 cases,
473,349 canonical bytes". No committed revision produces it — the receipt at `3895dbc` is still
226 cases and 471,171 bytes, and the next committed value is 230 cases and 485,040 bytes at
`ac7f091`. The only evidence is `~/.cache/ergodis/c1190/portability-nocases.json`, which does carry
226 cases, 473,349 bytes and SHA-256 `3c7c07db4e3f0fa1b1eb948e568886931140bc0e399385748f59a08e89f4a3aa`
— and the report's "What this task left under `~/.cache/ergodis/`" section says that directory holds
"two throwaway driver scripts", omitting it. `notes/research-reproducibility-conventions.md` is
explicit that a local cache entry is never sole evidence for a paper-facing result. *Repair*: commit
that receipt beside the report, or mark the 473,349 figure as measured and not replayable from a
committed revision; and correct the cache inventory to three files.

**7. The bisection table's units are not the units its replay command takes. Minor; replay.**
Location: "Where the route runs out, measured by bisection". The table's column is "Largest
dictionary that runs" — 153, 302, 84 — while the replay loops below it pass `--definitions`, which is
the dictionary on `stratified` but half of it on `columns` and a third on `columns3`. Running
`--definitions 302` on `columns` builds a dictionary of 604 and is refused. *Repair*: give both
numbers per row, for instance "302 (`--definitions 151`)".

**8. The A/B replay block cannot be run end to end from a clean checkout. Minor; replay.** Location:
the "Replay commands" A/B block. It runs `../ergodis-dev/scripts/retain-bin.sh tasks/tools
ergodis-tools` once, which retains at whatever revision the tree carries — `3c0992f` today — and then
names `ergodis-tools-ebecae2` and `ergodis-tools-606136e`, neither of which that command produces.
*Repair*: say the retain runs once per arm at its own revision, and name the revision each retain
is taken at.

**9. Two limits on the independent re-check, neither declared. Minor; evidence scope and
robustness.** Location: claim 4 and `verify_records` (`src/rel_stratified.rs:523`). First, the check
recomputes each column's values from the *recorded* sites and the closures, but never re-derives the
sites from the rule that produced the record, so a record naming a wrong-but-established relation
column with values updated to match would verify. The shipped code cannot produce such a record and
the tamper test's seventh case catches the one-sided version, but the check is self-consistency
against the closures rather than an end-to-end check that the domains are the right ones for the
rule. Second, `verify_records` rebuilds ∏ᵢ Dᵢ with no `MAX_COMPLEMENT` bound, so a hand-built
`Stratified` — the function is public — makes `complement_over` allocate `vec![false; universe]`
without limit. *Repair*: say in claim 4 what the check does and does not cover, and add
`if record.universe > MAX_COMPLEMENT { return mismatch; }` before the rebuild.

**10. Two negation-shape counts are off. Trivial.** Location: "The four new negation shapes". The
report says `singleton-column` "about 40" and `recursive-binding` "about 35"; the census prints 33
and 38. *Repair*: use the printed numbers, which the same test prints on every run.

**11. The receipts carry no load average and no counter enabled fraction. Minor; playbook.**
Location: the "Method" paragraph, which asserts the six-event set is "non-multiplexing" without
citing a measured enabled fraction, and the receipts' `host` block, which has no load field. The
playbook's interleaved-A/B section requires both ("Record the load average during rounds",
"Confirm the enabled fraction in the receipt"), and the receipt's own method note hedges with "the
six hardware events may be multiplexed by perf". *Repair*: add both fields to `bench.py`'s receipt,
or state the omission in the method paragraph. For the record, the load average during my own re-run
was 3.50 and the ratios reproduced to parts per million regardless, so this bounds nothing in this
task's result.

## Verdict

The milestone's substance holds, and holds well. A complement is genuinely built over the product of
the domains its arguments can take; the exactness argument is correct and is enforced by the code
rather than only asserted, with range restriction supplying the premise and the pre-binarization
placement of `bind` keeping the domains tied to relations the source wrote. Every number I could
re-derive re-derived: three complement records rebuilt from scratch match their recorded counts and
SHA-256 digests; the closed-form complement count matches the measured series at every point; the
`stratified` cohort is bit-identical to milestone (b) on both fact counts and layer-program bytes,
on the binary as well as at HEAD; all three boundaries and all three refusal byte counts reproduce;
parity regenerates byte-identically to the committed receipt at 230 cases, 484,293 bytes and
`8ae389f4…`; every stage ratio, every A/A null and every control instruction count re-derives from
the committed receipts; and my own interleaved A/B against the two retained binaries reproduces the
+4.5 per cent and +2.3 per cent headlines to within five parts per million. The deliberate mutation
breaks in exactly the two places the report records, including the point that the 600-program corpus
catches it only because the `recursive-binding` shape was added in response.

The defects are all in the reporting layer, and none of them moves a result. Two are internal
contradictions the report could have caught by reading its own table (items 2 and 5); one is a
factual error about the new cohorts inherited from a code comment the task itself later fixed
(item 4); one is a cost model asserted without arithmetic where the receipts already support a
better answer (item 3); one is a figure whose only evidence is an untracked cache file (item 6);
and the rest are replay and scope hygiene. The one substantive omission is memory: the change raises
the reserved workspace by 6.5 per cent and peak RSS by about a quarter of a megabyte on every
program, including one with no negation, and the report — which is otherwise scrupulous about saying
that the lowering stage got more expensive — does not mention it at all.

On the question the brief asked about the unattributed 40 per cent of the lowering-stage increase:
it is both, and the reporting half is the one to fix first. The report shows no arithmetic for the
60 per cent it claims to attribute, so a reader cannot check it; and the single largest component is
measurable in one command that nobody ran. The measurement gap behind what remains is real, and the
kernel-scoped profile the ledger prescribes is the right instrument for it.
