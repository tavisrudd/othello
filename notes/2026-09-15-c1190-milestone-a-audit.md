# C1190 milestone (a) — independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: COMPLETE. Written incrementally from the start of the audit.

Target of the audit: `notes/2026-09-15-c1190-milestone-a.md` (C1190 milestone (a), the lowering of
admitted Rel programs into Ergodis rules end to end). Design it was meant to follow:
`notes/2026-09-15-c1190-lowering-architecture.md`. Task card:
`notes/2026-09-15-c1190-rel-lowering.md`. Code under audit: `~/src/ergodis-private` at
`5180507` (seven commits from `a90168b`), consuming `~/src/ergodis` read-only.

This audit is read-only: no tracked file in any of the three repositories was modified, nothing was
staged, committed or reset, and the only file written outside the session scratchpad is this
report.

## Verdict

The milestone's substance holds. An admitted Rel program in the positive fragment does become a
checked closure, the closures are right, the gates pass, the parity record reproduces bit for bit,
and every measurement in the report re-derives from its receipts and from my own re-run. What does
not hold is one named cause in the performance analysis, three counts in the equation-table
summary, and a handful of smaller statements. None of the errors changes what the milestone
delivers; the wrong cause does change what a successor should fix first.

**Confirmed.**

- The two retained binaries exist and hash to the values the report records as measured, and the
  receipts record rustc 1.95.0 (59807616e 2026-04-14) on both arms.
- The A/B receipt re-derives every claimed scan, parse and admit ratio (1.00000 to 1.00002) and
  every stage figure, including the 81.56 and 284.66 instructions per source byte; my own re-run
  under the playbook protocol reproduces all of them, with `prepare` at 3.97886 [3.97572, 3.98200]
  against the reported 3.97863 [3.97639, 3.98088].
- Tests pass at the current head (`rel_lowering` 24, `rel_frontend` 28, `rel_frontend_portability`
  1, no failures), Clippy is clean on a forced re-check of both crates, and `cargo fmt --check`
  passes.
- The zero-allocation gate is sound in construction — a counting global allocator over `alloc`,
  `alloc_zeroed` and `realloc` — and covers the four exit paths the report names; every pool push
  in the three lowering files is capacity-guarded.
- Parity reproduces exactly: 213 cases, 433,805 canonical bytes, native and WASM byte-equal,
  canonical SHA-256 `04b5ebdd72fb08184f3143e3ca8393d207b9a6109c549e9806e1bfae02bb23b0`, and the
  regenerated receipt is byte-identical to the committed one.
- All eight committed fixtures agree with an evaluator I wrote for this audit, and both the core
  derivation checker and the ranked checker accept every certificate. Five further positive-fragment
  programs of my own devising (a three-atom body with a shared variable, a disjunction with a
  constant, a module with a parameter and a member spine, a self-join, and rules with a repeated
  head variable) also agree, and thirteen out-of-fragment or ill-formed programs produce exactly the
  `REL05xx` codes, budgets and spans the contract states.
- The 35-equation table matches Addendum A's Figures 3 and 4 equation for equation and in order, and
  no positive-fragment equation is missing; nothing in "Semantics adopted" contradicts the paper.
- The five declared deviations from the architecture note are all real and all justified, the four
  literal signs are in the IR, and the passes run in the stated order with the stated join-order
  heuristic.
- The comment-string quadratic and the `admit::declare` probe chain are both real; I confirmed each
  by a scaling measurement (about 4× per doubling of the definition count) rather than by a profile
  share, which is stronger evidence than the report offers.
- The lowering stage's own cost on the `datalog` cohort is linear in the source (2.00× per
  doubling), so 81.56 instructions per source byte is a genuine per-byte figure.

**Contradicted.**

- The ASCII and Unicode rows do not pay "the declaring phase's quadratic scan over 512 relations";
  they reject in the *declare* phase at the second definition with one relation in the pool, and
  their cost is linear in the node count (11,450 / 21,122 / 40,478 / 79,204 instructions at 64 /
  128 / 256 / 512 definitions) and is `build::declare_modules`'s sweep of the whole node pool at
  about 6.4 instructions per node. The same wrong cause appears in the results table, the Fermi
  retrospective, Remaining gaps item 1, Mystery ledger item 5 and the second discovery-track entry.
- The paragraph summarizing the Figure 3/4 table miscounts it: the table has 14 lowered, 1
  backend-rejected and 16 `REL0504`, not 12, 2 and 17; and the two rows that are not parsed are
  `E where F` and the `&` higher-order application, not "the `&` and `?` sigils".
- "No `memcpy`, `memmove` or `memcmp` appears at any threshold" is false: at `--percent-limit 0` the
  same profile shows `__memcmp_evex_movbe` at 0.03 per cent and `__memmove_avx512_unaligned_erms`
  at 0.00 per cent.
- "1.41 instructions per cycle" is not in either receipt; the measured figures are 6.13 for the
  `lower` stage and 4.39 for the lowering-only difference.
- Two aggregation rows of the equation table record `REL0504` for `sum[…]` surrogates; the literal
  `reduce[&{…},&{…}]` and `reduce(&{…},&{…},…)` syntax gives `REL0101` at the `&`.
- "273 instructions per source byte against 40.68" compares a composed stage with an
  admission-only difference; like for like it is 199.95 against 29.27.

**Could not check.**

- The `REL0502` stratification path, because no source in the positive fragment reaches it — the
  report says the same, and my check is a reading of `passes::stratify`.
- Which callers the two sub-threshold libc symbols belong to, because the profile was recorded
  without call graphs.
- The 330-instructions-per-constant interning figure, which is a profile share divided by a counted
  unit; settling it needs the synthetic decomposition the report's own ledger names as the gap.
- The foreign-diff hash `a954fbdc…` recorded for both arms, because a concurrent session committed
  that work during this audit and the tree is now clean.

## Per-claim detail

### Repository state during the audit

At the start of the audit `~/src/ergodis-private` was at `5180507`, the C1190 tip, with fifteen
files reported as modified. Partway through, a concurrent session in another lane committed that
work: the repository is now at `4b8cfd7`, three commits further on (`7a8bc5a`, a formatting-drift
commit, then two C1130 commits for the threaded-provider runtime). `5180507` is an ancestor of the
current head, and `git diff --stat 5180507..HEAD` restricted to `src/rel_frontend`,
`src/rel_lowering.rs`, `tests/rel_lowering.rs`, `tasks/tools` and `analysis/rel-frontend` is empty,
so nothing in the audited surface moved. I re-ran the three test suites after the move and they
pass identically. I changed no git state; the only side effect of my own commands was `git status`
refreshing the index's stat cache, which writes no content and stages nothing.

One consequence for the report's evidence: the working tree is now clean, so the combined foreign
diff whose SHA-256 the report records as
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` can no longer be recomputed —
`git diff` is empty and hashes to the empty string. That is a property of when I looked, not a
defect in the report, but it means the dirty-tree provenance of the two retained binaries is now
unverifiable from the repository alone.

### Foreign uncommitted edits do not touch the audited files

The working tree of `~/src/ergodis-private` carries fifteen modified files that belong to other
work: five under `analysis/campaign-console/mockups/`, three under `analysis/interface-review/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Comparing that list against the twenty-four files the
C1190 range `a90168b..HEAD` changed gives an empty intersection, so nothing uncommitted overlaps
the code, fixtures or receipts under audit. The report's own inventory of the foreign files is
exactly this list.

```sh
git status --short --porcelain | awk '{print $2}' | sort > foreign.txt
git diff --name-only a90168b..HEAD | sort > c1190.txt
comm -12 foreign.txt c1190.txt     # empty
```

The decision record the report cites, `docs/adr/0004-rel-lowering-ir.md`, exists and was committed
at `a90168b`, the base of the range, so it is not part of the seven commits but it is present.

### Gates at the C1190 tip (`5180507`), and again after the lane-foreign commits

Every gate the report lists reproduces at `5180507`, one commit later than the `c8e5344` the report
ran them at, and the three test suites were re-run after the concurrent C1130 commits landed and
gave the same counts.

```sh
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_lowering --test rel_frontend --test rel_frontend_portability -j 8
# rel_frontend: 28 passed, 0 failed
# rel_frontend_portability: 1 passed, 0 failed
# rel_lowering: 24 passed, 0 failed
```

Clippy was re-run with `RUSTFLAGS="--cfg auditc1190"` so the cached fingerprints could not satisfy
it and the crates were genuinely re-checked; the log shows `Checking ergodis-private` and
`Checking ergodis-tools` rather than a cache hit.

```sh
RUSTFLAGS="--cfg auditc1190" nix develop ~/src/ergodis --command \
    cargo clippy -p ergodis-private --lib --tests -j 8 -- -D warnings      # exit 0, no diagnostics
RUSTFLAGS="--cfg auditc1190" nix develop ~/src/ergodis --command \
    cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings               # exit 0, no diagnostics
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
                                                                           # exit 0
python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json
# 8 fixtures agree with the committed expectations
```

### Retained binaries, and the A/B re-run

Both retained executables are present with their sidecar hashes, and both hashes are the ones the
report records as measured.

```sh
sha256sum ~/.cache/ergodis/bin/ergodis-tools-e8b4c7c ~/.cache/ergodis/bin/ergodis-tools-41553c9
# 7431e0e83236a850081204b5310786d8570073ba127a731f7435ca2bf06b6ecb  ergodis-tools-e8b4c7c
# f1b5d079e4ac1d82406d73f76ea8ffeb5adc942bff551e32e9f9a5709f4ed2fb  ergodis-tools-41553c9
```

The `.sha256` sidecars agree with the files. The committed receipt
`analysis/rel-frontend/performance-v1-lower-41553c9.json` records the same two hashes, rustc
1.95.0 (59807616e 2026-04-14), `perf` 7.2.4, an AMD Ryzen AI 9 HX 370 host on kernel 7.2.4, CPU 5
pinned, seven rounds, the non-multiplexing event set and `control_skipped_operations` of
`["lower"]`. The receipt's `repository_commit` is `37b2713`, which is the revision after the
candidate `41553c9` and before the two closeout commits; that is consistent with the report's own
statement that the two later commits change no measured loop, but the receipt is therefore not
literally a receipt taken at the candidate revision, only against the candidate binary.

Re-deriving the report's numbers from the committed receipts reproduces every figure. The
scan/parse/admit candidate-over-control instruction ratios come out 1.00000 everywhere except the
comment-string cohort's byte variant (scan 1.00002, parse 1.00002, admit 1.00001) and the
malformed-early admit (1.00001), exactly the table the report prints. The A/A instruction nulls
recompute as 1.000001, 1.000000, 0.999998, 1.000002 and 1.000001, again exactly as printed. The
`lower` minus `admit` differences recompute as 79,208, 79,977, 18,676,502, −1 and 0 instructions,
giving 1.84, 1.29 and 284.66 instructions per source byte on the three cohorts that reach the
stage. On the `datalog` receipt the four stages recompute as 497,221 / 1,164,192 / 4,350,195 /
5,649,690 instructions and 69,452 / 183,932 / 626,234 / 922,033 cycles, the stage difference as
1,299,495 instructions, 81.56 per source byte and 255.0 per node, and the A/A null as 0.999996 —
all as reported. The `prepare` comparison in the receipt is instruction ratio 3.97863 with the
interval [3.97639, 3.98088], the figure the report quotes. The cache receipt reproduces the
supplementary table (L1 data-cache loads 1,545,515 and 1,974,825; L1 load misses 13,693 and
24,914; cache references 14,778 and 28,217; cache misses 14 and 24).

I then re-ran both measurements myself under the playbook protocol, writing the receipts into the
scratchpad so no tracked file was touched.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-41553c9 \
    --control ~/.cache/ergodis/bin/ergodis-tools-e8b4c7c --control-skip lower \
    --rounds 7 --cpu 5 --stages scan,parse,admit,lower --events $E \
    --out <scratchpad>/ab-audit.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-41553c9 --rounds 7 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower --events $E --out <scratchpad>/ab-datalog-audit.json
```

My run reproduces the claim. Every scan, parse and admit ratio is 1.00000 except the
comment-string byte variant, where I measured scan 1.00003, parse 1.00002 and admit 1.00002 —
one part in a hundred thousand above the report's figures and inside the protocol's own noise
floor, which the nulls put at about two parts per million but which the comment-string cohort's
byte scanner has consistently sat slightly above. The load average during my run was around 1.2 on
a 24-thread box, and the A/A nulls of my run are 1.000000 to 1.000006, so the protocol carried its
noise floor as claimed. The lowering stage differences are 79,210, 79,979, 18,676,502, 3 and 1
instructions, giving the same 1.84, 1.29 and 284.66 per source byte. The `prepare` ratio came out
3.97886 with interval [3.97572, 3.98200], overlapping the report's [3.97639, 3.98088]. On the
`datalog` cohort I measured the stage difference at 1,299,496 instructions, 81.55 per source byte
and 255.0 per node, with the lowering summary identical field for field (14 relations, 1 input, 5
derived, 8 auxiliaries, 96 rules, 272 literals, 528 terms, 512 facts, 513 values, 6 strata, domain
513, 16 distributed, 8 binarized, canonical fingerprint `aa9451450b65b83e`). Peak resident set
came out 6,072 KiB against the reported 5,956 KiB, which is run-to-run variation in the driver's
own footprint and is not a per-stage figure.

**One derived figure in the report is wrong.** The report closes the cache paragraph with "which
is what the 1.41 instructions per cycle implies as well". No instructions-per-cycle ratio in
either receipt is 1.41. The `lower` stage as measured is 5,649,690 instructions over 922,033
cycles, which is 6.13 instructions per cycle; the lowering-only difference is 1,299,495
instructions over 295,799 cycles, which is 4.39. My own re-run gives 6.17 and 4.34. The
conclusion the sentence supports — that the stage is instruction-bound rather than memory-bound —
is if anything strengthened by the true figure, so this is a wrong number attached to a right
conclusion rather than a wrong conclusion.

### The kernel-scoped profile, and the call-free claim

Rendering the retained profile reproduces the report's table symbol for symbol and share for
share.

```sh
nix develop ~/src/ergodis --command perf report \
    -i ~/.cache/ergodis/perf-c1190/lower-datalog-41553c9.data --stdio -g none --percent-limit 0.05
```

The thirteen lowering symbols the report lists do sum to 22.22 per cent (`lower::run` 9.32,
`build::intern` 5.99, `Rir::fingerprint` 2.20, `build::constant` 0.98, `build::formula` 0.92,
`build::copy_literal` 0.80, `build::atom` 0.57, `build::term` 0.52, `build::distribute` 0.50,
`build::resolve_name` 0.11, `passes::clone_literal` 0.11, `build::record_column_types` 0.10,
`build::leading_columns` 0.10), and the stage-difference method puts the lowering at 23.00 per
cent of the composed stage, so the report's "agree to eight tenths of a point" is right.
`admit::declare` is 50.58 per cent, as reported.

Two problems with the profile section, neither of which moves a conclusion.

First, the report's table is not the complete list of symbols above a tenth of a per cent that the
playbook's kernel-scoped-profiling rule asks for. Four symbols in that range are missing from it:
`parser::Parser::item` at 0.62 per cent, `admit::bind_list` at 0.14 per cent,
`core::str::converts::from_utf8` at 0.11 per cent and `parser::parse` at 0.06 per cent. Three are
the parser's and admission's, and the fourth, `from_utf8`, is the one-shot UTF-8 validation at
`src/rel_frontend/mod.rs:596` that runs once per operation over the whole source and sits outside
every traversal — so the omission does not hide a call inside a lowering loop, but the list as
printed is a filtered list presented as a complete one.

Second, the sentence "No `memcpy`, `memmove` or `memcmp` appears at any threshold" is false as
written. Re-rendering the same profile with `--percent-limit 0` shows
`__memcmp_evex_movbe` at 0.03 per cent and `__memmove_avx512_unaligned_erms` at 0.00 per cent,
alongside `_int_free_chunk`, `core::fmt::Formatter::pad_integral` and the `clap` and dynamic
loader symbols of the driver's own startup. The claim is true at the 0.05 per cent threshold the
report's own command uses and is almost certainly true of the loops themselves — the profile was
recorded without call graphs, so nothing in this data attributes the two libc symbols to a caller,
and the lowering's own spelling comparison is an explicit byte loop
(`src/rel_frontend/lower/build.rs:43`, `fn same`, a `while` over single bytes), while no
`copy_from_slice`, `extend_from_slice`, `clone()` or `to_vec()` appears anywhere in
`lower.rs`, `lower/build.rs` or `lower/passes.rs`. What is wrong is the quantifier "at any
threshold", which the playbook explicitly warns against: "'No libc symbol at any threshold' is a
statement about a profile, not about the compiled code."

### The zero-allocation gate

`the_lowering_stage_does_not_allocate` (`tests/rel_lowering.rs:846`) is sound in construction. The
counting allocator in `src/allocation_test.rs` is a `#[global_allocator]` that increments on
`alloc`, `alloc_zeroed` and `realloc` while a thread-local flag is set, so a pool that grew would
be seen. The test warms every first-use-sized pool, records `retained_bytes()`, then runs eight
rounds over four sources inside the tracked region and asserts both zero allocations and unchanged
retained bytes.

The four sources are the `datalog` cohort at 256 definitions (the complete-lowering path), the
ASCII cohort at 64 (rejected `REL0504` as out of fragment), `def e = {(1, 2)}\ndef bad(x, y) =
e(x, x)` (rejected `REL0501` by range restriction) and `def wide = {(1, 2, 3, 4, 5)}` (rejected
`REL0503` on relation arity). That is exactly the set the report describes. The report's phrase
"the stage's four exit paths" undercounts, though: `REL0505`, the disjunction expansion bound, is
a fifth exit and has its own fixture elsewhere in the file but is not driven under the allocator,
and `REL0502` is the sixth, which the report separately and correctly says no source can reach.
The `REL0505` path runs `distribute`, which writes the conjunct and member pools, and those pools
are reserved from `Limits` like every other, so the gap is a coverage gap in the gate rather than
a suspected allocation.

Reading the reservation block confirms the report's deviation 2: `Rir::new`
(`src/rel_frontend/lower.rs:515`) takes `Limits` and reserves every pool with
`try_reserve_exact` from `limits.relations`, `limits.rules`, `limits.literals`, `limits.terms`,
`limits.values`, `limits.depth` and `limits.binders`, with no reference to the `Admission` counts.
The count of reserved pools is 34, not the "thirty" the report says twice; `retained_bytes()`
sums the same 34 capacities. Every push-side capacity test I read returns `REL0503` rather than
growing, and the one unguarded-looking pair in the stratifier — `edge_offsets.resize(count + 1,
0)` and `components.resize(count, …)` at `src/rel_frontend/lower/passes.rs:195` and `:197` — is
safe because both are reserved at `limits.relations` and `count` is `rir.relations.len()`, which
the relation pool's own capacity test bounds by `limits.relations`. The third resize, of `edges`,
is explicitly guarded by a capacity check that returns a `Budget::Literals` failure.

### Parity: 213 cases and the canonical hash reproduce exactly

Regenerating the parity record into the scratchpad rather than over the tracked receipt gives a
file that is byte-identical to the committed `analysis/rel-frontend/portability-v1.json`.

```sh
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output <scratchpad>/portability-audit.json
# 213 cases, 433805 canonical bytes, native/WASM exact equality
diff <(python3 -m json.tool analysis/rel-frontend/portability-v1.json) \
     <(python3 -m json.tool <scratchpad>/portability-audit.json)    # no differences
```

The regenerated receipt carries `cases` 213, `canonical_bytes` 433805, `native_wasm_byte_equal`
true and `canonical_sha256`
`04b5ebdd72fb08184f3143e3ca8393d207b9a6109c549e9806e1bfae02bb23b0`, all three matching the
report. The per-outcome split in `record_summary` is `admitted_cases` 69, `lowered_cases` 24,
`lowering_rejected_cases` 45 and `lowering_not_reached_cases` 144, which is the split the report
states. The pre-C1190 baseline the report quotes also checks out: `git show
a90168b:analysis/rel-frontend/portability-v1.json` has 193 cases, 369,710 canonical bytes and
canonical SHA-256 `c5d836251b8b24e2b58c513a89a7726acc8f922533e9df681fc24ec3ca9aafba`. Both
libraries' SHA-256 values are recorded in the receipt, and the compiler string in it is rustc
1.95.0 (59807616e 2026-04-14), the pin the report names.

### End-to-end correctness, against an evaluator written for this audit

I wrote a small naive Datalog evaluator in the scratchpad (`audit_eval.py`) that has no connection
to `tests/support/rel_closure_oracle.py`: it takes hand-transcribed facts and rules, matches atoms
against a snapshot of the database, and iterates full passes to a fixed point. A driver
(`run_fixtures.py`) writes each program to a file, runs the committed chain through the
`rel-lower` subcommand of a release `ergodis-tools` built at the current head, and compares the
decoded readout against my evaluator's closure.

```sh
nix develop ~/src/ergodis --command cargo build --release -p ergodis-tools --bin ergodis-tools -j 8
python3 <scratchpad>/run_fixtures.py
```

All eight committed fixtures agree with my evaluator, and every one reports `verified` true,
`ranked_verified` true and `checkers_agree` true, so both the core derivation checker and the
ranked checker accept each certificate.

```text
transitive_closure:          AGREE  path=6   verified=True ranked=True agree=True
same_generation:             AGREE  sg=9     verified=True ranked=True agree=True
three_atom_body:             AGREE  four=2   verified=True ranked=True agree=True
disjunctive_rule:            AGREE  any=3    verified=True ranked=True agree=True
module_parameter:            AGREE  reach=1  verified=True ranked=True agree=True
domain_restricted_parameter: AGREE  kept=2   verified=True ranked=True agree=True
anonymous_projection:        AGREE  firsts=2 verified=True ranked=True agree=True
constant_argument:           AGREE  twos=2   verified=True ranked=True agree=True
```

I also checked the eight expected closures by hand against the textbook least-fixed-point
semantics before running anything, and they are right. The same-generation case is worth naming:
with `root = {(1,1)}` as the base and `sg(x,y) = root(x,y) or exists(a,b: parent(a,x) and sg(a,b)
and parent(b,y))`, the closure is the nine pairs `(1,1)`, `(2,2)`, `(2,3)`, `(3,2)`, `(3,3)`,
`(4,4)`, `(4,5)`, `(5,4)`, `(5,5)`, which is what the fixture records. The report's instructive
negative about `(4,2)` refers to an earlier base case that the committed fixture no longer uses, so
`(4,2)` is correctly absent from what is committed.

Five further programs of my own devising, all inside the positive fragment, also agree with my
evaluator and are accepted by both checkers: a three-atom body with a variable shared cyclically
(`tri(x) = exists(y,z: e(x,y) and e(y,z) and e(z,x))`, three triangle nodes); a disjunction one of
whose branches carries a constant literal (`sel(x) = p(x,2) or (q(x) and r(8))`, four tuples); a
module with a parameter and a two-definition member spine used from outside at two different
parameter values (`N[k]` with `step` and `two`, read out as `N[1]:two` and `N[2]:step`); a
self-join (`two(x,z) = exists(y: r(x,y) and r(y,z))`, three tuples); and a set of rules exercising
a repeated variable in the head and in the body, including the literally repeated head parameter
`def selfpair(x, x) = e(x, x)`, which lowers and produces the one expected tuple. A sixth program
I wrote deliberately outside range restriction, `def sel(x) = p(x, 2) or q(8)`, is rejected with
`REL0501` and a primary span of bytes 56..57, the `x` in `sel`'s own head, which is the contract.

Thirteen further programs probe the rejection surface; every code and span is what the report's
contract says.

| Program                                                | Stage   | Code      | Span and payload                               |
|--------------------------------------------------------|---------|-----------|------------------------------------------------|
| `not e(y, x)` in a body                                | backend | `REL0504` | bytes 57..64, the negated literal itself       |
| `forall((y) \| …)` in a body                            | lower   | `REL0504` | bytes 42..63, the `forall` construct           |
| `exists(y in d: …)`                                    | lower   | `REL0504` | bytes 52..58, the restricted binder            |
| five-column fact set                                   | lower   | `REL0503` | budget "relation arity", found 5, limit 4      |
| seven nested two-way disjunctions                      | lower   | `REL0505` | budget "disjuncts of one definition", 128 / 64 |
| anonymous head column `def bad(_, y) = …`              | lower   | `REL0501` | bytes 25..26, the `_`                          |
| `M:f(x, y)` from outside a parameterized module        | lower   | `REL0501` | bytes 85..88                                   |
| empty source                                           | lower   | `REL0504` | bytes 0..0                                     |
| unclosed `{`                                           | parse   | `REL0204` | bytes 16..16                                   |
| two `def` clauses of one relation disagreeing on arity | lower   | `REL0504` | bytes 40..41                                   |
| a relation name in a term position                     | lower   | `REL0504` | bytes 52..53                                   |
| `{}` as a body conjunct                                | lower   | `REL0504` | bytes 42..44                                   |
| `reduce(&{+}, &{e}, x)`                                | parse   | `REL0101` | bytes 37..38, the `&`                          |

The `REL0503` case reports exactly the budget name and the two numbers the report claims
("relation arity", found 5, limit 4). The last row is the scanner gap the report records, and it
matters for the equation table below.

The module-shadowing fixture behaves exactly as described. `module M[x]\n  def f(x) = e(x)\nend`
is rejected with `REL0501` whose primary span is bytes 9..10 — the module parameter's own `x` at
byte 9 — with the body's parameter named as the construct that opened, which is the discriminator
the 2026-09-15 admission audit could not build.

### The Figure 3 and Figure 4 equation table

The paper's own equations check out. The cached PDF is `arxiv:2504.10323` with SHA-256
`6e1371160602b1df77d9e5a647369bcd747aec3e8a97e36d2e99f04c219194b6`, the hash the report cites.
Counting the bullets in the extraction gives twenty equations in Figure 3 (constants, variables,
tuple variables, `_`, `_...`, `{E1;E2}`, `(E1,E2)`, `where`, the five abstraction forms,
`(Bindings):Formula`, the three projection forms, `?{}` and `&{}` application, and
`reduce[&{},&{}]`) and fifteen in Figure 4 (`{()}`, `{}`, application, nullary application, `or`,
`and`, `not`, parentheses, three `exists` forms, three `forall` forms, and the `reduce` formula) —
thirty-five in total, in exactly the order the committed table lists them. No equation of Figures 3
or 4 is missing from the table, and none of the missing-but-relevant candidates exists: every
positive-fragment construct the milestone claims (constants, variables, wildcards, union,
product-as-conjunction, restricted abstraction, `exists`, application, `and`, `or`, parentheses,
true) has its own row.

Three problems with how the table is summarized and with three of its fixtures.

First, **the prose summary under the table miscounts the table**. Parsing the committed Rust table
in `tests/rel_lowering.rs` and the markdown table in the report both give 14 lowered, 16
`REL0504`, 2 not parsed, 2 admission-rejected and 1 backend-rejected. The report's sentence says
"Twelve of the 35 equations are lowered and executed; two are represented in the relational IR and
rejected by backend v1; seventeen are rejected by the lowering with `REL0504`". Three of those five
counts are wrong; the table itself is right.

Second, **the sentence naming the unparsed rows is wrong**. The two `NotParsed` rows are
`[[E where F]]` and `[[{E1}[&{E2}]]]`. The report says "The two that are not parsed are the `&` and
`?` argument-disambiguation sigils", but the `?` row, `[[{E1}[?{E2}]]]`, is recorded as lowered and
its fixture is `def e = {(1, 2)}\ndef p(x, y) = e(x, y)` — an ordinary application with no `?` in
it. Feeding the literal form `e[?{y}](x)` gives `REL0101` at the `?`.

Third, **two rows record an outcome their own equation cannot reach**. The aggregation rows
`[[reduce[&{E1},&{E2}]]]` and `[[reduce(&{E1},&{E2},E3)]]` are recorded as `REL0504`, but their
fixtures are `sum[v: w(k, v)]` and `s = sum[v: w(k, v)]`, not `reduce` with `&`. The literal
Addendum A syntax gives `REL0101` at the `&` in both cases, as I measured. The outcome the table
records is therefore the outcome of a surrogate construct. The `?` row has a partial defence the
report does not make: the paper itself says the annotations "can be dropped if the engine can
figure out whether the argument should be passed as first-order or as higher-order", so an
unannotated application is a sanctioned spelling of that equation. No such defence covers the two
`reduce` rows, since `reduce` is not `sum` and `&` is mandatory there.

Against Figures 2 to 4 nothing in the report's "Semantics adopted" section is wrong. Reading `,` in
a formula position as conjunction is justified exactly as the report justifies it: Figure 3 gives
`(Expr1,Expr2)` the product, formulas denote either `{⟨⟩}` or `∅`, and the product of two such
relations is their intersection. Reading `()` as the true formula and `{}` as the false one
follows Figure 4's `[[{()}]] = {⟨⟩}` and `[[{}]] = ∅` directly, and rejecting a false body is a
declared coverage gap rather than an approximation. The paper's program semantics is described as
"much like in recursive Datalog programs … propagated in an iterative fashion until no new facts
can be inferred", which is the least fixed point the milestone computes. The paper has no module
construct, as the report says, so the module rules are the frontend's own contract and cannot
conflict with the paper.

### Fidelity to the architecture note

All four literal signs exist in the IR as `SIGN_POSITIVE`, `SIGN_NEGATIVE`, `SIGN_COMPARISON` and
`SIGN_AGGREGATE` (`src/rel_frontend/lower.rs:72`), with the comparison operator carried in its own
field. The passes run in the note's order: `src/rel_frontend/lower.rs:903` calls `build::build`,
then `passes::project`, `passes::range_restrict`, `passes::stratify`, `passes::binarize` and
`passes::close`. The note's first two passes, flattening modules and distributing disjunction, are
inside `build` rather than separate entries (`build::declare_modules`, `build::distribute`), which
is a packaging difference, not a missing pass.

Binarization does what the note asks. `passes::binarize` rewrites every body of more than two
literals whose literals are all positive, and after the rewrite it records each rule's body
sequence into `rir.order` and stamps `Rule::order`, so every rule carries its join order.
`order_positives` (`src/rel_frontend/lower/passes.rs:371`) is a selection sort on the key the
report describes: most variables already bound first, then the narrower variable mask, then source
order, since ties keep the earlier candidate. Auxiliary relations are created with
`kind: REL_AUXILIARY` and the head's stratum.

Two things in the note are not in the code and are not in the report's list of deviations.

The value dictionary is typed per entry — `Value` carries a `kind` of `TYPE_INT`, `TYPE_TEXT`,
`TYPE_ENTITY`, `TYPE_BOOL`, `TYPE_MIXED` or `TYPE_UNKNOWN`, and relations carry per-column types —
but there is **no per-type sub-range**. The note asks for "a per-type sub-range so a column type
can later select its own domain"; ids are assigned in interning order, so one type's ids are not
contiguous and no range structure exists. The report's own Remaining gaps item 7 names the
consequence but frames it as a backend limitation rather than as a missing piece of the IR.

The note also says "the RIR reserves a symmetry table per program so source-declared or discovered
symmetries can be forwarded later". There is no symmetry table anywhere in the IR; the backend
emits `symmetries: Vec::new()` (`src/rel_lowering.rs:241`). Both omissions are forward-looking
scaffolding rather than milestone-(a) function, and both are cheap to add later, but neither is
declared.

The five deviations the report does declare are all real and all justified.

1. The backend really cannot live under `src/rel_frontend/`. `analysis/rel-frontend/portability.py`
   compiles `src/rel_frontend/mod.rs` and its submodules with a bare `rustc --crate-type=cdylib`
   invocation and no Cargo graph, once natively and once for `wasm32-unknown-unknown`, so a module
   in that tree cannot name `ergodis-verify`. `src/rel_lowering.rs` is the sibling projection.
2. `Rir::new` takes `Limits` and reserves every pool with `try_reserve_exact` from
   `limits.relations`, `rules`, `literals`, `terms`, `values`, `depth` and `binders`, with no
   reference to the `Admission` counts.
3. `passes::binarize` counts the positive literals and skips the rule when any literal is not
   positive (`src/rel_frontend/lower/passes.rs:411`), exactly as described.
4. `Rule::order` is filled for every rule from the post-binarization body.
5. `exists(x in D: F)` is `REL0504`, which I confirmed by running it.

### The zero-allocation contract in the code, not only in the gate

Beyond the regression test, I read the push sites. Every pool push in `lower.rs`,
`lower/build.rs` and `lower/passes.rs` is either behind a `push_*` helper that tests capacity and
returns a bounded failure, or preceded by an explicit `len() == capacity()` or
`len() + n > capacity()` test that returns `REL0503` with the budget and the two numbers. The
pools reserved but written by index rather than pushed — the value index and the stratifier's
`edge_offsets`, `components` and `edges` — are sized at `Limits`-derived capacities that the
relation and value budgets bound, and the one that can exceed its bound, `edges`, has its own
capacity test before the resize.

### The Fermi miss and the cost attributions

This is where the report is weakest, and where one named cause is wrong.

**The `datalog` stage cost and its linearity are real.** I measured the lowering stage
(`lower` minus `admit`, two-point differenced at repeat 200 and 400, pinned to CPU 7, the retained
candidate binary) at four definition counts.

```sh
# scratchpad/stage_scale.sh: perf stat -x, -e instructions:u on
# taskset -c 7 <binary> rel-frontend-bench --cohort C --stage S --definitions D --repeat R,
# differenced between R and 2R.
```

| Definitions | `datalog` lower − admit | Ratio to previous |
|------------:|------------------------:|------------------:|
|          64 |                 163,007 |                 — |
|         128 |                 323,130 |              1.98 |
|         256 |                 648,592 |              2.01 |
|         512 |               1,299,491 |              2.00 |

That is linear in the source, and the 512 figure matches the receipt's 1,299,495 to four parts in
a million, so 81.56 instructions per source byte is a genuine per-byte cost and not a disguised
quadratic.

**The comment-string quadratic is real, and I confirmed it by counted events rather than by a
share.** The same protocol on the comment-string cohort gives 468,393 / 1,397,718 / 4,748,879 /
18,676,568 instructions at 64 / 128 / 256 / 512 definitions, ratios 2.98, 3.40 and 3.93,
converging on the 4× per doubling a quadratic demands. The relation count there is 112 / 224 / 448
/ 896, which follows from the cohort's four templates (one relation each for `label`, `doc` and
`raw`, four for `mixed` with its three free names). The arithmetic also closes: 896²/2 ≈ 401,000
spelling comparisons against 18,676,502 instructions is about 46 instructions per comparison, which
is what `same`'s explicit byte loop over a six-to-nine-byte spelling plus the pool load costs. The
report's headline attribution for that row is sound.

**The ASCII and Unicode attribution is wrong.** The report says: "Both reject in the *body* phase,
which runs only after every definition has been declared, so their 79,208 and 79,977 instructions
are almost entirely the declaring phase's quadratic scan over 512 relations (512²/2 ≈ 131,000
spelling comparisons)." Three independent checks refute this.

The first is arithmetic the report could have done itself: 79,208 instructions over 131,000
spelling comparisons is 0.6 instructions per comparison, and no comparison that loads a relation
record and tests a span can cost less than one instruction.

The second is the span. The receipt records the ASCII failure as `REL0504` at bytes 76..82. Those
bytes are `score1`, the relation name of the *second* top-level definition, and `build::declare`
rejects a bracketed head at `src/rel_frontend/lower/build.rs:617` — `if head.bracketed { return
Err(fragment(nodes[head.name])) }` — before the body phase is reached at all. The declare loop
returns on its first error, so exactly one relation is in the pool when the failure fires. The
report's own results table says the ASCII row "declared 512 relations"; it declared one.

The third is a scaling measurement. On the ASCII cohort the lowering stage difference is

| Definitions | ASCII lower − admit | Ratio to previous |
|------------:|--------------------:|------------------:|
|          64 |              11,450 |                 — |
|         128 |              21,122 |              1.84 |
|         256 |              40,478 |              1.92 |
|         512 |              79,204 |              1.96 |

which is linear, not quadratic, and whose 512 value matches the receipt's 79,208.

The cause that does fit is `build::declare_modules`
(`src/rel_frontend/lower/build.rs:470`), which sweeps the entire node pool looking for module
nodes before any definition is declared. ASCII has 12,288 nodes and pays 79,208 instructions, 6.45
per node; Unicode has 12,416 nodes and pays 79,977, 6.44 per node; and the 769-instruction gap
between the two cohorts over their 128-node gap is 6.0 instructions per extra node. A model in
which the cost is the relation-count quadratic predicts no difference at all between them, since
both would declare 512; a per-node sweep predicts exactly the difference observed. This also means
the Fermi retrospective's stated cause — "the model priced a rejection as a walk up to the first
out-of-fragment construct and missed that the stage declares every relation in the source before it
builds the first body" — is wrong, even though the Fermi was indeed off by about forty. The right
statement is that the model missed a full sweep of the node pool that every lowering pays before
the first declaration, which on the `datalog` cohort costs about 32,000 of the 1,299,495
instructions, or two and a half per cent.

**The admission probe-chain finding is real and I strengthened it.** The `admit` minus `parse`
difference on the `datalog` cohort is 97,626 / 279,711 / 902,976 / 3,185,977 instructions at
64 / 128 / 256 / 512 definitions, ratios 2.87, 3.23 and 3.53, converging on 4× per doubling. The
mechanism the report and the discovery track read out of `admit::insert` — 512 clauses of one
spelling sharing one home slot in an open-addressed index — is confirmed by that scaling, not just
by the 50.58 per cent profile share. The one flaw is the comparison: "Admission on that cohort
costs 273 instructions per source byte against 40.68 on the ASCII cohort" puts the `datalog`
*composed* stage (4,350,195 instructions over 15,934 bytes) beside the ASCII *admission-only*
difference from the C1170 census. Like for like, the admission difference is 199.95 instructions
per byte on `datalog` against 29.27 on ASCII in this same receipt — a factor of 6.8, which is still
a strong finding.

**The interning and fingerprint splits are share-based, and the report partly admits it.** The
"42 per cent / 27 per cent / 10 per cent" split inside the lowering is `lower::run` 9.32,
`build::intern` 5.99 and `Rir::fingerprint` 2.20, each divided by the 22.22 per cent the thirteen
lowering symbols sum to. The cross-check the report offers — 22.22 per cent from the profile
against 23.00 per cent from the stage difference — validates the *total*, not the split inside it,
and the playbook is explicit that a symbol's share is not its cost. The claim that interning costs
about 330 instructions per constant is 5.99 per cent of 5,649,690 divided by the 1,024 constant
occurrences the `datalog` generator emits (512 clauses of `def edge = {(i, i+1)}`), so it is a
share divided by a counted unit. The report's mystery ledger item 3 says as much and names the
per-class decomposition as the evidence gap, which is the right disposition.

The fingerprint attribution, by contrast, survives an independent sizing that the report did not
do. Dumping the canonical bytes of the lowered `datalog` program gives 22,904 bytes
(`rel-lower --cohort datalog --definitions 512 --dump-canonical`), and a byte-at-a-time FNV-1a sink
costs about five instructions per byte, so the fingerprint should cost roughly 115,000 instructions.
The 2.20 per cent share implies 124,293. Those agree closely enough that the fingerprint's place in
the cost model is established by counting rather than by the profile, and the structural half of
the claim is plain in the code: `passes::close` calls `rir.fingerprint()` at
`src/rel_frontend/lower/passes.rs:773`, inside the measured stage, over a canonical form that
serializes the 512 facts and 513 dictionary entries.

### Mystery ledger, remaining gaps and the discovery track

Ledger item 1, the module-parameter shadowing, is settled correctly: I reproduced the `REL0501`
with its primary span at byte 9 on the module parameter's own spelling.

Ledger item 2 is right about the sevenfold Fermi miss and about the fingerprint, and repeats the
unverified 330-per-constant figure that item 3 then correctly opens.

Ledger item 4 is right about the mechanism and overstates the contrast, as above.

Ledger item 5 carries the same wrong sentence as the results table: "the ASCII and Unicode cohorts
pay 79,000 before they even reach a body" attributes a per-node sweep to relation resolution.

Ledger item 6 is exactly right, and I verified it in the code:
`build::distribute` materializes the whole cross product through `push_conjunct` and `push_member`,
each of which returns `REL0503` on capacity exhaustion, and only afterwards compares
`last - first > bound` to raise `REL0505`. A deeply nested conjunction of disjunctions can
therefore report the pool budget before the declared disjunct bound.

Ledger item 7 is a fair statement of what the three arguments do and do not establish, and I can
add that both checkers accepted all thirteen programs I ran.

Ledger item 8 holds: I found nothing in "Semantics adopted" that contradicts Figures 2 to 4.

Remaining gaps 2 through 8 are accurate as far as I checked them. Gap 3 in particular is right that
no source in the positive fragment can build a non-monotone cycle, so `REL0502` has no source-level
fixture; I did not find a way to reach it either. Gap 1 is correct about the mechanism and about
the comment-string cohort, and wrong in the clause about the ASCII and Unicode cohorts.

The coverage manifest claim checks out: `analysis/rel-frontend/coverage-v1.json` has a `lowering`
family with 26 construct rows, each carrying `parsed`, `admitted`, `lowered`, `executed` and
`certified` as separate boolean columns plus a note.

Of the two discovery-track entries appended on 2026-09-15, the first, on admission's probe chain,
is correctly scoped — it is genuinely incidental to a profile taken for another purpose, the
mechanism is read from the source, the remedy is marked unmeasured, and no C-ID is claimed. Its one
flaw is the 273-versus-40.68 comparison inherited from the report. The second entry, on the
lowering's linear relation scan, is correctly scoped and correct about the comment-string cohort
and about `find_relation`, but its sentence "the ASCII and Unicode cohorts pay 512²/2 before they
reject" is the same refuted claim and should be removed or replaced.

## Defects, ranked

1. **The ASCII and Unicode cost attribution is wrong, in four places.** The report's results table
   ("declared 512 relations"), the paragraph beginning "The ascii and unicode rows have the same
   cause at a smaller scale", the Fermi retrospective in the same paragraph, Remaining gaps item 1,
   Mystery ledger item 5 and the second discovery-track entry all say those two cohorts pay a
   quadratic scan over 512 relations before rejecting in the body phase. They reject in the declare
   phase at the second definition with one relation in the pool, and the cost is linear in the node
   count. *Fix*: replace the claim with the measured one — the ASCII and Unicode lowering
   differences are `build::declare_modules`'s sweep of the whole node pool, about 6.4 instructions
   per node, which every lowering pays before the first declaration; keep the quadratic claim for
   the comment-string row, where it is right and now confirmed by a scaling measurement; and note
   that the node-pool sweep is its own small candidate, since a module index built during
   admission would remove it from every lowering.
2. **The Figure 3/4 summary paragraph miscounts its own table and misnames the unparsed rows.**
   *Fix*: change the counts to 14 lowered, 1 backend-rejected and 16 `REL0504` (2 admission, 2 not
   parsed unchanged), and say that the two not-parsed rows are `E where F` and the `&` higher-order
   application; state separately that the `&` and `?` sigils have no token, that the `?` row's
   fixture uses the paper's sanctioned unannotated spelling, and that the two `reduce` rows record
   the outcome of a `sum[…]` surrogate because the literal syntax does not scan.
3. **"No `memcpy`, `memmove` or `memcmp` appears at any threshold" is false at threshold zero.**
   The same profile at `--percent-limit 0` shows `__memcmp_evex_movbe` at 0.03 per cent and
   `__memmove_avx512_unaligned_erms` at 0.00 per cent. *Fix*: say "none appears above 0.05 per
   cent, and the two that appear below it are not attributable from this profile because it carries
   no call graphs", then keep the strong part of the claim, which is the code evidence: `build::same`
   is an explicit byte loop and no slice copy, clone or `to_vec` exists in the three lowering files.
4. **The profile table is presented as complete and is not.** Four symbols at or above the
   playbook's tenth-of-a-per-cent threshold are missing: `parser::Parser::item` 0.62,
   `admit::bind_list` 0.14, `core::str::converts::from_utf8` 0.11 and `parser::parse` 0.06. *Fix*:
   add the four rows and say that `from_utf8` is the one-shot UTF-8 validation at
   `src/rel_frontend/mod.rs:596`, outside every traversal.
5. **The "1.41 instructions per cycle" figure is not in the data.** The `lower` stage retires 6.13
   instructions per cycle and the lowering-only difference 4.39; my re-run gives 6.17 and 4.34.
   *Fix*: use the measured figure, which supports the instruction-bound conclusion more strongly
   than the quoted one.
6. **The admission comparison is not like for like.** "273 instructions per source byte against
   40.68" puts a composed stage beside an admission-only difference, in both the report and the
   discovery-track entry. *Fix*: use 199.95 against 29.27, both admission differences from the same
   receipts, and say so.
7. **Two architecture-note features are absent and undeclared.** The value dictionary has no
   per-type sub-range and the IR reserves no symmetry table. *Fix*: add both to the deviations list
   with the reason (neither is needed by backend v1, and per-value kinds plus per-relation column
   types make the ranges derivable when per-column domains arrive).
8. **"The stage's four exit paths" undercounts.** `REL0505` is a fifth exit and is not driven under
   the counting allocator, although its pools are reserved like every other. *Fix*: add the nested
   disjunction source to `the_lowering_stage_does_not_allocate` and say five, noting that `REL0502`
   remains unreachable from a source.
9. **"Thirty more reserved pools" is 34.** *Fix*: say "every pool" or give the right number; the
   `retained_bytes` sum and the `reserve` call count both give 34.

## What I could not verify, and why

The `REL0502` stratification rejection has no source-level fixture and I did not find a program in
the positive fragment that reaches it, so my check of that path is a reading of
`passes::stratify`, not an execution of it. The report says the same.

The two libc symbols in the profile cannot be attributed to a caller: `perf record` was run without
call-graph collection, so the data carries no chain for `__memcmp_evex_movbe` or
`__memmove_avx512_unaligned_erms`. Ruling them out of the lowering loops rests on reading the three
lowering source files, which is what I did.

The claim that interning costs about 330 instructions per constant remains share-derived. Settling
it needs the synthetic single-constant decomposition the report's own ledger names, which I did not
run because it would require a new bench mode rather than an existing one.

I did not rebuild either arm from its revision, so the retained binaries' provenance rests on their
recorded hashes, which match, and on the receipts. The foreign-diff hash the report records can no
longer be recomputed, because a concurrent session committed that work during my audit and the
working tree is now clean.

I did not attempt to verify the report's statements about work in other lanes, about the C1189
reference evaluator, or about what milestones (b) and (c) will need, since none of those is
evidenced by the code under audit.

## Repairs applied

All nine defects are repaired. Nothing under `~/src/ergodis-private` or `~/src/ergodis` was
touched, no code or fixture changed, and nothing was committed anywhere; the repairs are
documentation only, in two files of this repository.

The task report is `notes/2026-09-15-c1190-milestone-a.md` and the log is
`notes/ergodis-discovery-track.md`; the table names the place inside each.

| # | Defect                                                                  | Repaired in                                                                         |
|---|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| 1 | ASCII and Unicode cost attributed to a quadratic relation scan          | Report: the results table's outcome cells, the paragraph after it (rewritten around |
|   |                                                                         | `build::declare_modules` and separating the two cohorts' causes), the Fermi         |
|   |                                                                         | retrospective, and Mystery ledger 5                                                 |
| 1 | The successor ordering that followed from that cause                    | Report: Remaining gaps, gap 1 now scoped to the comment-string cohort and a new     |
|   |                                                                         | gap 2 for the node-pool sweep, later items renumbered                               |
| 1 | The same claim in the append-only log                                   | Log: a new dated correction entry after the two C1190 entries, originals intact     |
| 2 | Figure 3/4 summary miscounts its table and misnames the unparsed rows   | Report: the paragraph under the equation table, now also naming the three           |
|   |                                                                         | surrogate-source rows, and the Remaining gaps item on the sigils                    |
| 3 | "No `memcpy`, `memmove` or `memcmp` at any threshold"                   | Report: the out-of-line-call paragraph of the kernel-scoped profile section         |
| 4 | Profile table filtered but presented as complete                        | Report: four rows added in share order, with a note on what each one is             |
| 5 | "1.41 instructions per cycle"                                           | Report: the cache-behaviour paragraph, now 6.13 and 4.39                            |
| 6 | Admission comparison not like for like                                  | Report: Mystery ledger 4. Log: the correction entry                                 |
| 7 | Per-type dictionary range and symmetry table absent and undeclared      | Report: new deviations 6 and 7, and Remaining gaps 8 and 9                          |
| 8 | "The stage's four exit paths"                                           | Report: the allocation paragraph, claims list, gates table, and Remaining gaps 4    |
| 9 | "Thirty more reserved pools"                                            | Report: the `datalog` stage paragraph and the `prepare` paragraph, both now 34      |

Two additions strengthen claims that were already right rather than repairing a defect: the
comment-string quadratic and the `admit::declare` probe chain now carry the fourfold-per-doubling
scaling runs from this audit, in the report and in the discovery-track correction, so both rest on
counted events instead of on a profile share.

Files edited in this repair pass: `notes/2026-09-15-c1190-milestone-a.md`,
`notes/ergodis-discovery-track.md` and this file. None is committed; that is the coordinator's.
