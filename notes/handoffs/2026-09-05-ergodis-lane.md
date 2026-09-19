# Ergodis compiled exact-optimization engine

**Lane**: `ergodis`

**Purpose:** current routing only. Closed dispositions, measurements, proof summaries and
correction trails live in dated reports and the append-only
[`2026-09-05-ergodis-lane-archive.md`](2026-09-05-ergodis-lane-archive.md).

**Date**: 2026-09-18
**Mode**: intent-based.
**Status**: ACTIVE. Immediate engineering frontier is C1190 (Rel lowering; milestones a, b, per-column domains, c and the C1191 direct constructor done and audited; C1192 sparse index and C1188 done and audited; C1198 lazy workspace done, audited (C1199) and repaired (C1200) 2026-09-17; C1193 n-ary bodies done and vetted 2026-09-17; C1201 static index build cost done, audited and repaired 2026-09-17; C1202 probe-count rule, mask demotion and per-link counter done, audited and repaired 2026-09-18; C1203 growing-index crossover done 2026-09-18; C1194–C1196 queued; C1170 frontend closed 2026-09-16 with C1197 queued later; C1189 oracle closed); the
rule-contract programme C1172–C1177 and the Datalog evaluation tasks C1179/C1182–C1186 are closed. C1143, C1130, C1016,
C1017, C1061 and C985 remain in progress. C1062 and C1070 await Tavis's close call.

**Discovery companion**: [ergodis discovery track](../ergodis-discovery-track.md).

**Architecture context**: for architecture, shared API/schema, execution, model/query or
portability work, read `notes/ergodis-architecture-context.md` after this handoff. It is private,
not-to-ship contributor guidance. Narrow UI/admin work does not require the full context.

**Performance context (required)**: `~/src/ergodis-dev/PERFORMANCE.md` is the always-on rules
layer for any Ergodis Rust edit. Before a hot-path edit, benchmark, A/B, profiling or
measurement-stage task, also read `~/src/ergodis-dev/performance-playbook.md` in full (contract
detail plus the A/B, event-set, profiling, cold-start and reporting method on this host), and
restate its binding items in every sub-agent prompt.

## Identity and boundaries

- **Ergodis software**: private `main` of `~/src/ergodis`, with sibling checkouts
  `~/src/ergodis-private`, `~/src/ergodis-evidence` and `~/src/ergodis-dev`, each governed by
  its own `AGENTS.md`. The software left this monorepo at tag `ergodis-split-base` (`aa49d68c3`).
- C1175 validates the regenerated 472-row filtered export manifest and a lint-clean filtered
  tree. Nothing has been published to GitHub. Evidence-publication, paper-deposit,
  copyright/contact, product-scope and public-CI decisions remain with Tavis.
- The [`complete-ports`](2026-07-17-complete-ports-paper.md) lane owns the motivating *Exact
  Compositional Transfer of Bounded Linear Recovery* manuscript. This lane owns the private
  engine, its performance contract, benchmarks, capabilities, tooling and C985 paper.

## Immediate frontiers

### C1170 — owned Rel-rich frontend (closed 2026-09-16; micro-optimization queued as C1197)

Contract: `../2026-09-12-c1170-owned-rel-frontend.md`; source study:
`../2026-09-12-c1169-datalog-frontends.md`; measurements, cost model and bounded recovery:
`../2026-09-13-c1170-frontend-measurements.md` (private `99281a2` … `f820daf`); Pratt-loop A/B
(16-byte frame, operand/infix fast path: ASCII parse instructions 0.788 of control, scanner now
56 % of the stage): `../2026-09-13-c1170-pratt-loop-ab.md` (private `2efeccb` … `b5416b0`).
Keyword lookup and reserved-word gap: `../2026-09-14-c1170-keyword-lookup.md` (private
`2840757` … `fcd7d1a`): reserved words are now exactly the reference keyword table plus `_`,
with `doc`/`value`/`type`/`declare` contextual at item start; the packed keyword compare is a
measured wash against a clean-checkout control (the profiler share was call-entry skid), kept
as the explicit form. The native/WASM parity gate carries 151 cases; it is a finite parity
gate, not a grammar oracle or complete syntax/admission claim. Instruction counts are the
decision metric on this shared box; cycle ratios are reported only with intervals.
Cold start and scanner attribution: `../2026-09-14-c1170-prepare-touch-scan-attribution.md`
(private `c526b3f` … `9f1e57e`): the `prepare-touch` and scan-only stages exist; a fresh
workspace costs 1,536 minor faults / 1.13 ms under bench limits (kernel time, invisible to the
user-only instruction metric); `lexer::scan` is attributed by two agreeing methods and
punctuation dispatch, not identifiers, is about half the scanner. Two measurement caveats now
bind: the six-event `perf stat` set multiplexes and must not be used for small operations, and
the shared toolchain moved to rustc 1.95.0, so every retained control predating 2026-09-14 is
toolchain-mismatched.
Punctuation fast path: `../2026-09-14-c1170-punctuation-fast-path.md` (private `6ed6ff9` …
`cfe4893`, kept shape `598426f`): against a rustc 1.95.0 control at `9f1e57e`, ASCII parse stage
0.8010 (19.9 % removed), faster on every cohort in the byte variant, scalar variant exactly 1.0000;
the first-byte compound index with slice `starts_with` was an instructive negative (libc `memcmp`
in the loop). Lane protocol change: A/B with
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` (non-multiplexing, A/A null
two parts per million); cache events in a separate run. The parser is now the majority of the
ASCII parse stage (48 %).
Token store and first semantic admission: `../2026-09-14-c1170-token-store-and-admission.md`
(private `35f4484` … `32a18c6`): the token-store bookkeeping cursor is kept at exactly five
instructions per token (ASCII parse 0.9709); wide stores lose by codegen probe and are recorded
as rejected. Scanner performance work is closed for now. Admission (name binding, arity;
`REL04xx`; free names admitted as external base relations, escaped binders rejected) is a
separate zero-allocation stage with its own cost budget: 40.68 instructions per source byte on
ASCII, two thirds of parsing, unattributed below the symbol. Parity corpus now records admission
outcomes (159 cases, canonical `5a350e1f…`). Toolchain is now pinned through the core flake:
`retain-bin.sh` re-execs under `nix develop ~/src/ergodis` (rustc 1.95.0) when not in a nix
shell, and gates for a report run under the same shell. The 1.93.1 control `ergodis-tools-cfe4893`
and candidates `35f4484`/`49493a3` are toolchain-stale; `ergodis-tools-32a18c6` (1.95.0) is the
control for the next A/B.
Admission decomposition: `../2026-09-14-c1170-admission-decomposition.md` (private `52d48eb` …
`45df44c`, no kernel change): twenty per-unit costs from thirty synthetic sources, census replayed
over the dumped node pool, prediction closes on the ASCII cohort at −0.32 % out of sample (other
cohorts −0.09 % / +0.81 %). Cost carriers: traversal bookkeeping 19 %, fixed per-reference 14 %,
first-sight `BUILTINS` walk plus insert 14 %, two node-kind pool scans 12 %, name hashing 12 % (1,545
names hashed twice); the index clear is 0.1 %. Two recorded limits: the model interpolates
cohort-like mixtures and does not extrapolate to pure shapes (singular design matrix), and a
driver-only commit moved the parse stage 1.7 % through ThinLTO, so stage differences, not stages,
carry the measurement. The control for the next A/B is `ergodis-tools-185015e` (rustc 1.95.0; the
commits after it touch only scripts, receipts and README).

Admission optimizations: `../2026-09-14-c1170-admission-optimizations.md` (private `7817627` …
`6d27015`): hash each name once (0.9525, `insert` became inlinable), compile-time first-byte/length
gate on the `BUILTINS` walk (0.8676), one node-pool scan with definition ids in a bounded pool
(0.9350); composed ASCII admission **0.7727** against `ergodis-tools-185015e`, non-interacting,
parity hash unchanged, no gate failed. `prepare` is 12.7 % dearer for the new pool. Lesson: the
fitted model finds candidates, the disassembly prices them, and a signature change can move
inlining. Retained as `ergodis-tools-49bbb9a` (rustc 1.95.0).

Traversal cursor and scan hoist: `../2026-09-14-c1170-traversal-cursor.md` (private `5578357` …
`11fc4d0`): the visits and node pools leave the workspace for the scan and body checks and the
traversal carries its stack length by value (0.9614), the declaring scan iterates the local slice
(0.9619); composed ASCII admission **0.9247** against `ergodis-tools-49bbb9a`, non-interacting,
parity hash unchanged, no gate failed, `prepare` unchanged. Both Fermis were priced from the
compiled loop and landed inside that reading. The stage stands at 0.7145 of `185015e`. The
control for the next A/B is `ergodis-tools-db47ee1` (rustc 1.95.0).

Census at `db47ee1`: `../2026-09-14-c1170-admission-census-db47ee1.md` (private `1210f29`,
`63d6fca`, no kernel change): the census replays the current kernel, the unit list gained
`builtin_iters` (the gate made the `BUILTINS` walk a variable unit) and `bind_one_nodes`, lost
the redundant `probe_slot_reads`, and a `mixed-k` family separates the per-definition cost from
inert literal visits. Cohorts predict at +0.91 / +0.81 / +1.98 per cent out of sample, every
synthetic row inside 1.1 per cent. ASCII ranking: traversal 21.2 per cent (31.98 per visit),
reference fixed part 20.0 (71.49), hashing 11.5 (7.89 per byte), `declare` 8.9 (194); first sight
is 64 instructions, 4.6 per cent. The model ranks; a saving under about five per cent of the stage
needs its own A/B, a floor set by the unidentified per-unit splits (withheld-family residuals of
+43.69 on `header` and +30.77 on `qualified`) and not by the cohort residual, which is about one
per cent.

Scopes pool and annotate: `../2026-09-14-c1170-scopes-pool-and-annotate.md` (private `3bd5e38`,
`0dc1814`): the dead `scopes` pool is gone (`prepare` 0.9050, `prepare-touch` 0.9680 with faults
unchanged, admission 0.9995, retained bytes −2,048); `admit::reference` and `admit::declare` are
bucketed by address range (`annotate-buckets.py`, region map validated on four single-class
sources). Shares are skid-shaped (2.2× on the entry region, 0.2× on a one-byte loop) and do not
price; the disassembly path times the census does, and it says the call shape of `reference`
(caller marshaling, prologue, epilogue: about 50 of the 71.49 fixed instructions per reference) is
14 % of the stage. `declare` has no region above 1 %. No precise sampling on this host
(`instructions:upp` and `ibs_op` refused at `perf_event_paranoid = 2`). The control for the next
A/B is `ergodis-tools-3bd5e38` (rustc 1.95.0).

Inline `reference`: `../2026-09-14-c1170-inline-reference.md` (private `93bb343`, `9c8dac3`):
`#[inline(always)]` on `admit::reference`, ASCII admission **0.9120** against
`ergodis-tools-3bd5e38` (109,600 removed, 31 per reference, inside the Fermi band at its shallow
end); parity hash unchanged, no gate failed, peak RSS down 12 KiB. The two inlined copies pay
unequally (about 40 per reference at the `Atom` site, 9 at the `Apply` site, which spills), and
`is_builtin` became an out-of-line call on the first-sight path. The stage stands at 0.6513 of
`185015e`.

Module scopes: `../2026-09-14-c1170-module-scopes.md` (private `7b38c65`, `4b02031`, `9bfe19d`,
receipts `5710a77`): definitions are owned by their innermost module and visible only on the
body's module chain (innermost first), module parameters are binders in every body the module
owns, `M:x` / `M:N:x` / `M[a]:x` resolve members with arity checks and `REL0406 UnknownMember`;
base relations and builtins stay global; qualification of a non-module is symbol-keyed access.
Semantics are the stage's stated contract (report section "Semantics adopted"), not a Rel claim.
Parity corpus 166 cases, canonical `f3d83752…`. Composed ASCII admission cost **1.0976** against
`ergodis-tools-93bb343` after two shape repairs (the lean probe loop with insert-time shadow
flagging, then `insert` force-inlined); `prepare` 1.21 and retained bytes +67,588 for the two new
pools. The shadow-flagging walk in `insert` (35 per symbol) is half the cost and is the first
candidate if micro-optimization resumes. **That cost prices the guards, not the paths they guard**:
`admit::shadowed`, `admit::qualified` and `admit::member` execute on no bench cohort at all, since
no cohort declares a spelling at two owner levels or writes a member spine, so the level-aware
resolution path is covered only by the parity cases and the unit tests. A corpus variant with
shadowed spellings and member spines is the outstanding evidence gap. The control for
any later frontend A/B is `ergodis-tools-9bfe19d` (rustc 1.95.0).

Syntax gaps by manifest family: `../2026-09-14-c1170-syntax-gaps.md` (private `80f3305` …
`b51f627`, manifest citation `6f0e9ec`): caret entity references (power operator after an operand,
entity reference elsewhere; a global name whose spelling includes the caret, never a binder),
string interpolation (`%name`, `%(expr)`, nested, scanned as parts through one continuation frame;
`REL0105`/`REL0106`), and reference identifier/whitespace/operator-block boundaries (Alphabetic
starts, ASCII-digit continuations, `U+FEFF` space, `U+2200`–`U+22FF` operators). Parity corpus 193
cases, canonical `c5d83625…`; zero-allocation gate holds. Cost, measured and unrepaired: composed
ASCII parse **1.0651** and scan-only 1.0956 against `ergodis-tools-9bfe19d`. The caret and
interpolation share, +148,906 of the +163,302, is not the features executing — no cohort holds an
entity reference or an interpolation — but loop shape, `lexer::scan` having left the inliner at the
interpolation commit; the Unicode family's +14,274 mixes shape with executed work, and the executed
part is what the kept byte-order-mark repair removed. Two arm merges were measured losses and
reverted; the byte-order-mark move is kept. Recorded divergences: `Other_Alphabetic` marks start identifiers (no
category table without a crate in the bare-`rustc` parity harness); `doc "100% sure"` rejects. The
control for the next frontend A/B is `ergodis-tools-e8b4c7c` (rustc 1.95.0). The formal semantics of
Rel's logical core is Aref et al., arXiv:2504.10323, Addendum A (lit cache `arxiv:2504.10323`).
Independent audits (2026-09-15, Opus, read-only replay): `../2026-09-15-c1170-syntax-gaps-audit.md`
and `../2026-09-15-c1170-admission-chain-audit.md`. Every retained-binary hash, receipt ratio and
interval across the seven reports from `185015e` to `e8b4c7c` re-derives; two A/Bs re-run reproduce
within three parts per million; the census fit reproduces bit for bit. The defects were prose and
fixtures only and are repaired in the reports, this map and private `837c441`/`fb69af8`; the
published formal semantics has no module construct, so the module-scope rules remain this stage's
contract. Note for the lowering work: at the admission stage the two shadowing directions between a
body parameter and a module parameter are observationally identical, so that fixture cannot exist
until lowering distinguishes them.

**Next (Tavis, 2026-09-14): end-to-end features, not micro-optimization.** C1170 was closed on
2026-09-16; the remaining priced candidates (the `Apply`-site spills, the hash loop's bounds check,
`same()`'s bounds checks, the pop's field loads, pricing `is_builtin`, the `insert` shadow walk) are
queued as **C1197** (`../2026-09-16-c1197-frontend-micro-optimization.md`, later). The syntax-gap report adds one
larger untaken lever: a feature-presence prepass that monomorphizes the scanner on the lexical
features a source actually contains, so sources without interpolation pay no per-token guard. Not
built, not queued. Feature order now: lowering of admitted programs into Ergodis rules end to end,
allocated as **C1190** (`../2026-09-15-c1190-rel-lowering.md`). Tavis took the card's two
recommendations (positive fragment first, per-program literal dictionary over the `u32` term) and
asked for architectural planning ahead: design `../2026-09-15-c1190-lowering-architecture.md` and
private ADR 0004 (`a90168b`) put an owned relational IR (four literal signs, typed dictionary,
column types, strata, auxiliaries) between the frontend and the rule contract, with fixed routes
for stratified negation (per-stratum projection with complement facts), aggregation at stratum
boundaries and per-column domains. **Milestone (a) is complete and audited**:
`../2026-09-15-c1190-milestone-a.md` (private `2543802` … `5180507`), audit
`../2026-09-15-c1190-milestone-a-audit.md` (Opus, read-only replay: eight fixtures plus five
further programs agree with an independent evaluator, both checkers accept every certificate,
thirteen negative programs give the contracted `REL05xx`, parity 213 cases at `04b5ebdd…`
reproduces, A/B reproduces; the wrong cost attribution for the ASCII/Unicode cohorts was
corrected in the report and discovery track). Source → parse → admit → lower → `Demand` →
certificate → core and ranked checkers works on native and WASM; scan/parse/admit stages unchanged
against `ergodis-tools-e8b4c7c`. Lowering cost is far above its Fermi and has two measured causes,
priced for the successor: `find_relation`'s linear scan (quadratic in relation count; the
comment-string cohort at 896 relations pays 284.66 instructions per byte) and
`declare_modules`'s whole-node-pool sweep (linear, about 6.4 per node; the ASCII/Unicode cohorts).
Recorded deviations: backend as sibling `src/rel_lowering.rs` (the bare-`rustc` parity harness
cannot depend on `ergodis-verify`), capacity from `Limits` not `Admission`, `exists(x in D: F)`
rejected. **Lowering kernel candidates done** (`../2026-09-15-c1190-lowering-kernel-candidates.md`,
private `d8d9308` … `a93ae96`, Opus, vetted): relation-resolution index, module list recorded by
admission's existing sweep, and a third candidate the first one's measurement exposed, a
mangled-name index in the closing pass that also removed a libc `bcmp` from a hot loop; all kept.
Composed against `ergodis-tools-4b8cfd7`: comment-string `lower`−`admit` 0.0982 and now linear
across three doublings, ascii/unicode 0.078, `datalog` a bounded 1.0107 loss kept as design
evidence; parity hash unchanged. The vetting pass found and fixed a milestone (a) defect (private
`b7c26e5`): `resolve_name` probed the top level before the module chain, so a top-level definition
shadowed a module's own member inside that module; now innermost owner first with a closure fixture.
Control for the next frontend A/B: `ergodis-tools-b7c26e5` (rustc 1.95.0; receipt commit `e028f15`). Unallocated candidates
the report ranks: admission's repeated-spelling quadratic in `admit::insert` (now the only quadratic
in the frontend, half the composed stage on `datalog`), the source bounds check inside the spelling
hash and comparison loops, the nine-store `Value` push, and `qualified`'s linear module scan.
**C1189 reference evaluator done** (`../2026-09-15-c1189-reference-evaluator.md`, private `19f9d71`
… `2d260a1`, Opus, vetted): a test-only naive evaluator over the admitted AST (Figure 3/4 contract
plus range restriction, no backend bound, an enumeration cross-check) and a seeded differential
harness against the lowered rules, the demand evaluator and both checkers, over the committed
fixtures, all 35 Addendum A equations, surface-construct and rejection tables, 1,200 generated
programs and 400 near-misses. It found and the task repaired three lowering defects: `qualified`
resolved the top level before the module chain (the `resolve_name` defect one function away), a
variables-budget failure leaked a variable mapping into the next lowering on the same workspace, and
binarization built a nullary auxiliary whenever a join carried nothing forward (a fifth of the
generated corpus refused). The paper is pinned in the coverage manifest, and milestone (a)'s gap 4 is
corrected (`REL0502` has a source fixture). Both decisions Tavis then took are implemented:
`order_positives` prefers a literal whose join leaves a column the head or an unplaced literal still
needs, so ground atoms sort last and the nullary auxiliary is unreachable, and if it were reached it
is now `REL0504` naming the shape rather than a `REL0503` budget with a zero; all 1,200 generated
programs lower and the in-fragment divergence class is empty. Lowering-stage A/B against
`ergodis-tools-3eee87c`: `datalog` is the only cohort that reaches binarization and none of its eight
binarized rules changed order; the canonical parity hash did not move, because no parity case has a
body where the tiebreak decides. Control for the next frontend A/B: `ergodis-tools-c67e8d5`
(rustc 1.95.0).
**Milestone (b) done** (`../2026-09-15-c1190-milestone-b.md`, private `4b058ae` … `73dd56b`, Opus,
vetted): stratified negation and `forall` through per-layer projection with complement facts, one
contract `Program` and certificate per layer, complement records independently rebuilt and
digest-checked; the reference evaluator computes the stratified fixed point and the differential
covers 600 negation programs with zero disagreements (two deliberate mutations confirm the corpora
discriminate); parity 226 cases at `91b007eb…`; allocation gate over all seven exits; scan/parse/admit
unchanged against `ergodis-tools-c67e8d5`. Three recorded deviations: layers (negation boundaries)
rather than Tarjan strata are the programs, `ergodis-rules` is now a real dependency of the private
crate for the shared driver `src/rel_stratified.rs`, and `forall` introduces a witness relation.
**The ADR 0004 size question has its number**: the complement is quadratic in the dictionary and the
binding bound is the core's `MAX_BYTES` on the layer program, so the route affords one negated binary
relation over about 150 dictionary entries (arity 3 about 28). **Tavis's decision (2026-09-15):
per-column domains** in the value dictionary and the complement construction (the step the ADR left
between), **done** (`../2026-09-15-c1190-per-column-domains.md`, private `3895dbc` … `3c0992f`, Opus)
and audited (`../2026-09-15-c1190-per-column-domains-audit.md`: every number reproduces, A/B within
parts per million, eleven reporting defects being repaired). The complement is built over the values
each argument of the negative literal can take (constants, binding columns of the same rule's
positive literals); the column-type sub-range is recorded but deliberately not a filter, since an
entity-typed column reached by an integer binding shows filtering is unsound. Boundary at arity two
moves from a 153-entry dictionary to 302 with disjoint columns, arity three from 28 to 84; the
~22,000-fact ceiling itself is the JSON encoding (96 % of a complement fact is relation name and
punctuation), so the direct constructor into the evaluator's prepared form that ADR 0004 names is
worth about 10× on the same bound and is the recommended next lever after milestone (c). `Negative`
atoms in the core `Rule` stay the recorded fallback. Lowering stage +4.5 % on positive sources, +2.3 %
with negation, partly unattributed. Control for the next frontend A/B: `ergodis-tools-606136e`
(rustc 1.95.0).
**Milestone (c) done and audited** (`../2026-09-15-c1190-milestone-c.md`, private `79e9c52` …
`4554a52`, Opus; audit `../2026-09-15-c1190-milestone-c-audit.md`, every record, corpus, boundary
and A/B reproduces; eight findings repaired, two in code: synthesized `ag{n}`/`cf{n}` names now take
the `nc{n}` collision guard, and the reference evaluator refuses a non-integer aggregated column
where the lowering does, with a near-miss shape deciding it). `count`/`min`/`max`/`sum` are computed
at layer boundaries into digest-checked, independently rebuildable records; comparisons are
materialized filter relations (the contract has no filter atom); an ordering comparison on a
non-integer is false, not refused, so `<` and `>=` do not partition a mixed column (recorded
reading); min-plus carrier selection is structurally deferred, since the fragment has no
term-level arithmetic. Parity 243 cases at `f0e2b581…`; scan/parse/admit unity within 11 ppm;
reserved workspace byte-identical. Cost shape: constructs that reduce a closure (aggregates) are
free, constructs that need a product over one (negation, comparison) hit the ~22,000-fact
encoding ceiling. Control for the next frontend A/B: `ergodis-tools-b7c624d` (rustc 1.95.0).
**C1191 direct constructor done and audited** (`../2026-09-16-c1191-direct-constructor-report.md`,
core `2517852`, private `3778763` … `e0e7331`, Opus; audit
`../2026-09-16-c1191-direct-constructor-audit.md`: every record reproduces, no code defect, one RSS
figure and prose repaired, one code repair moved the aggregate's tuple-budget check before
enumeration). A second core constructor builds `Demand` from resolved relations, resolved rules and
flat tuple slices with a core-computed streamed binary identity (domain-separated from the JSON
identity, which is unchanged with `rule_contract.rs` byte-identical); every layer goes through it.
The 1 MiB JSON ceiling is gone: product-shaped layers now stop at the route's own
`MAX_LAYER_TUPLES` (4,194,304) or the core's `MAX_INDEX_KEYS`; arity-two dictionary reach 153 →
2,047 (`stratified`) and 302 → 4,092 (`columns`), arity three 84 → 255, aggregation 618 → 4,096.
Backend stage 0.52/0.52/0.43 (`datalog` 0.99) against `ergodis-tools-3778763`, peak RSS −28/−29/
−11 %, scan/parse/admit/lower unity within 42 ppm; the old route encoded each layer four times.
Parity hash unchanged at 243 cases; C1189 differential zero disagreements; the two routes yield
identical admitted forms differing only in identity. Recorded: core `Admitted` holds a flat fact
pool, both checkers gained `check_admitted` (wire path re-admits twice, prepared once),
`Demand::source()` is an `Option`, `rel-lower` gained `--values`; `datalog`'s repeated-loop wall
loss is minor faults once the old `Fact` allocations stop pinning the heap (arms tie under a pinned
trim threshold); `--max-rows 16777216` alone reserves about 1.6 GB of eager row store on an
arity-three cohort. Control for the next frontend A/B: `ergodis-tools-e0e7331` (rustc 1.95.0; the
repair commit was not re-measured).
**C1192 sparse join index and C1188 done and audited** (`../2026-09-16-c1192-sparse-join-index-report.md`,
core `84ed62c` … `6ab0dd5`, `24e399e` (C1188), `460ca32`; private `25cf4ed` … `3ed2043`, `c3eda9a`; Opus,
audit `../2026-09-16-c1192-sparse-join-index-audit.md`: every value re-derives, no code defect, two
measurement records and prose repaired). Both direct-addressed structures (join index, membership
test) have a sparse kind chosen once at preparation; the dynamic index crosses over at density 48
(cycle-decided, with counted cache events: sparse issues 0.36–0.38 of direct's references and L1
misses), the bitmap and input CSR stay direct wherever they fit. `MAX_UNIVERSE`/`MAX_INDEX_KEYS`
are policy ceilings now; refusals are row capacity and `MAX_WORKSPACE_BYTES`. Closure at
N = 65,536 over a 2^32 universe runs (221 ms, 239 MB) where admission refused it; quadratic
closures are bound by the 2^24 row capacity. Direct path 0.907–0.982 instructions; C1188's
`memmove` removal 0.893–0.895 instructions on all eight cohorts. No Rel cohort is stopped by an
addressing bound (`columns3` 255 → 483, `aggregate` 1,412 → 2,046). **Soufflé 2.5 on closure/blocks
at 4,096/16,384/65,536: 0.98/0.81/0.95 of compiled with a sized row bound, 3.24/1.56/1.25 at the
default bound** — the eager workspace reservation, closed by C1198 below. Parity digest moved to
`349333d4…` (lowering pass edited; parity holds at 243 cases). Controls for the next A/B: superseded by C1198's, below. Open for Tavis: the public `Policy::{Direct,Sparse,SparseIndexes,SparseMembership}` knobs on a
core type (keep public or feature-gate); cache-gc lists eight old unreferenced entries (largest
`datalog-comparison` 281 MB) — deletion is Tavis's call.
**C1198 lazy workspace done 2026-09-17, audited by C1199** (`../2026-09-16-c1198-workspace-sized-from-rows-report.md`; core `3eaaacf` … `2be1e68`; private `b3994fc` … `1f2fe44`; Opus). Every workspace table is an anonymous `MAP_NORESERVE` mapping with zero as the empty sentinel, reset by the rows the previous evaluation wrote; the eager commit was `calloc`'s memset, not the `fill(NONE)` the card named. Peak RSS ×3.1–29.6 lower at the default row bound; the row bound is no longer a memory decision (`cycle` 4,096: 47× the sized bound → 1.7×). Soufflé 2.5 on closure/blocks at the **default** bound 0.852/0.819/1.172 (was 3.24/1.56/1.25), so C1195's default-bound rows are now meaningful. Direct path 0.982–0.984 instructions. Controls for the next A/B: `closure_ballpark-ed99963` (derivation loop) and `ergodis-tools-ed99963` (frontend/backend), rustc 1.95.0, both from clean trees; a driver edit to `closure_ballpark` needs its own retain (ThinLTO moved the kernel 0.8 % through an untimed mode). Audit `../2026-09-17-c1199-c1198-audit.md` (vetted): every value re-derives; `shape()` missed a domain check that the row-walking reset needs; the fill rule and `Drop` had no binding gate; the stagger's credit for the 9 % dense-closure cycle regression was unisolated. **C1200 repair pass done and vetted** (`../2026-09-17-c1200-c1198-repair-pass.md`; core `e7116ba`, private `aa04358`, `193ebd1`; Opus): `shape()` records and compares the domain (`Error::Source`, test-bound), a test binds the fill-versus-walk rule (the first evaluation's commit delta is the discriminator, not the audit's second), a `VmSize` test binds `Pages::drop`, the `SAFETY` premise is repaired, all thirteen record repairs are applied to the C1198 report. The isolating probe (private `356fce6` + core `271d648`) settles the regression's attribution against both earlier accounts: the stagger **commit** repairs it (cycles 0.913/0.913 against `356fce6`, readable nulls) but the rotating offset does not (the no-stagger probe gives 0.906/0.904), and the `--cold` driver edit contributes nothing; what changes is the recompiled `evaluate_into` body (7,741 → 7,701 instructions, 27 fewer `mov`). STLF counters run against the 4 KiB-aliasing story. The domain repair recompiles the kernel again (7,701 → 7,788, +0.67–0.85 % instructions on the six direct-path cohorts, kept as a correctness gate). **Controls for the next A/B: `closure_ballpark-aa04358`** (derivation loop) and `ergodis-tools-ed99963` (frontend/backend; re-retain before measuring the Rel route, since `e7116ba` changes the kernel it calls). Open, unallocated: why semantically irrelevant source changes recompile `evaluate_into` by 0.8–1.7 % of instructions and up to 9 % of cycles (three reports now: C1170's driver edit, the stagger commit, the domain field) — a build-configuration and PGO sweep against the retained controls is the proposed lever (discovery track, 2026-09-17); the stagger pair on the remaining direct-path and memory cohorts (one `ab.py` run). Open frontiers, unallocated: the checkers' `crates/verify/src/datalog_store.rs` has the same `calloc` commit and is now up to 7.8× the evaluator's memory, blocked on `implementation_identity()` hashing the checker sources; the N = 65,536 default-bound residual is hash-table locality, not memory (report remaining gap 2); the reset walk could track touched slots instead of recomputing keys (gap 3). `MADV_HUGEPAGE` measured and rejected. cache-gc still lists 15 old unreferenced entries, plus C1200's `bin/c1198-stagger-probe` (no manifest row, cited by both reports) and `c1200/` (4.1 MB); deletion is Tavis's call.
**C1193 n-ary bodies done 2026-09-17, vetted** (`../2026-09-17-c1193-nary-bodies-report.md`; core `d677a8b` … `09a5c2b`; private `c3135f8` … `26d2468`; Opus; audit `../2026-09-17-c1193-nary-bodies-audit.md`). The core contract admits bodies of up to four atoms (`MAX_BODY` = 4); the demand evaluator joins them by a left-deep nested index join over the C1192 index kinds on a presized frame stack, no auxiliary relation, one premise per body atom in the certificate (`premise_stride`), both checkers extended; the two-atom kernel is unchanged in code and its plan. The lowering's binarization is now `BodyPolicy::{Binarize, Nary}` (`--body-policy`); **default flipped to `Nary` on Tavis's call 2026-09-17** (private `3c8499d`, `../2026-09-17-c1193-body-policy-default-flip.md`: milestone (a) suite pinned to `Binarize`, parity digest moved `349333d4…` → `5f9600ef…` at 243 cases, `datalog` fingerprint `16adff1e…` → `06aa82af…`; replay commands in the C1190/C1192/C1198/C1193 reports that take no `--body-policy` flag now need `--body-policy binarize` to reproduce their receipts). Triangle at 4,096/16,384: 0.52/0.61 of the binarized chain's instructions, derived tuples 36,912 → 48 and 147,471 → 15, peak RSS 192 → 71 MB and 146 → 15 MB; path3/path4 0.93–0.96 instructions but 0.74–0.78 L1 misses; Soufflé triangle gap 4.39 → 1.92; `datalog` cohort backend 0.993. Two-atom path **1.017–1.021 instructions against `closure_ballpark-193ebd1`** (identical to `aa04358`), stated as a loss; first landing was 1.116, two mechanisms repaired; two "free" variants measured worse and rejected. Free Join not built (priced by its trie build; no cohort where it pays). C1189 differential runs every source under both policies: zero disagreements, generated corpus now 1,329 three-atom and 1,134 four-atom bodies against a floor. Seven mutations all discriminate. Controls: superseded by C1201's, below. cache-gc applied 2026-09-17 on Tavis's call (18 entries removed). Its largest finding was allocated as C1201 (done, below). Other candidates in the report's closeout: shrink `Op` to four bytes, an `Evaluation::matches` counter, `mutual`/`cycle` Soufflé rows.
**C1201 static index build cost done 2026-09-17, audited and repaired** (`../2026-09-17-c1201-static-index-build-cost-report.md`; audit `../2026-09-17-c1201-static-index-build-cost-audit.md`, no code defect, nine record repairs applied; core `676f513`, `5c9d1b3`; private `8c04b7a` … `ab6be13`; Opus). `Policy::Auto` applies a measured static density rule `DIRECT_STATIC_DENSITY = 64` beside the ceiling, forced policies unchanged; `Index::csr` keeps its counting-sort cursor staggered, so the `keys`-entry `memmove` is gone. `triangle` 4,096: preparation 0.094, peak RSS 71.5 → 5.9 MB, whole process 0.193, compiled Soufflé 1.903 → 0.896; thirteen unchanged-kind cohorts within the A/A null, digests and work counters equal on all seventeen. **Unmet criterion, stated**: the two cohorts that change kind pay 1.41–1.45× in the derivation loop because the direct probe wins at every density (Fermi 2 refuted); "evaluation at the direct row" needs a third static representation, with mask demotion (index a fully bound atom on one column, verify the rest per row through the existing `join::<VERIFY>`) priced cheapest and a plan-owned hashed static kind second. **Closeout finding**: a density is a proxy — `mutual:blocks:4096` and `triangle:blocks:4096` share key space, rows and density with opposite right answers; `key_space <= 23 · probes` fits three families, and a per-link probe counter is the instrument every successor needs; `DIRECT_INDEX_DENSITY = 48` for growing indexes may carry the same defect, unmeasured. Preparation is now admission-bound at 164–283 ns per fact on every cohort (50 ms on `closure:blocks:16384`), the new leading term. Controls: superseded by C1202's, below. Tavis allocated the recommended shape as C1202 (done, below); the remaining C1201 candidates without IDs are the plan-owned hash kind (now less attractive), preparation's per-fact cost, and the cache-event run on `triangle:sparse:4096` that closes C1201 open item 2 and C1193 open item 3 together (C1202 took the `blocks` cohorts and the receipt fields).
**C1202 probe-count rule, mask demotion and per-link counter done 2026-09-18, audited and repaired** (`../2026-09-18-c1202-probe-count-index-rule-report.md`; audit `../2026-09-18-c1202-probe-count-index-rule-audit.md`, no code defect, sixteen record/prose repairs applied; core `2904489` … `9edc07b` and repair `ca0609f`; private `83bff0a` … `b47ade4`; Opus). The per-link probe counter is monomorphized on a `COUNT` const (`evaluate_counted_into`, `Demand::index_lookups`); carried unconditionally it cost up to 2.6 % of instructions, so the production loop carries neither. Mask demotion for a fully bound static atom is `OP_KEY → OP_CHECK` plus one mask bit and **changes no kernel line** (`OP_CHECK` pre-existed as the repeated-variable check, compared unconditionally at both join sites), guarded by the measured bucket crossover `DEMOTE_BUCKET_ROWS = 7` and measured against the new `Policy::AutoUndemoted` corner; the demoted key is usually a prefix an existing index already carries, so `triangle` drops from three indexes to two. `DIRECT_STATIC_PROBES = 23` replaces `DIRECT_STATIC_DENSITY = 64` as `key_space <= 23 · estimated_probes` floored by the rows; `DIRECT_INDEX_DENSITY = 48` is kept by measurement (the growing index's right answer does not move with its probe count). `triangle:sparse:4096` loop **0.604** cycles (1.30 instructions: a dependent binary search traded for independent row reads, stated as a cost), whole process 0.887, preparation and RSS unmoved; `triangle:sparse:16384` loop 0.469; `mutual:blocks:4096` and `triangle:blocks:4096` get opposite kinds from one constant (61,440 vs 921,600 measured lookups); fifteen unchanged-kind cohorts inside the A/A null with byte-identical plans; digests, work counters, both checkers, C1189 differential and parity digest unmoved. Two instructive negatives kept (the rule before the rows floor sent an unprobed index to the larger build; the demotion pass paid per link). **Controls for the next A/B: `closure_ballpark-5217cdb` (derivation loop) and `ergodis-tools-ab6be13` (frontend/backend)**, rustc 1.95.0, both `clean`; the repair commit `ca0609f` touches docstrings and the allocation test only (`AutoUndemoted` now in that gate), so re-retain before the next kernel A/B. **Decided (Tavis, 2026-09-18): `DIRECT_STATIC_PROBES` stays 23**, so `triangle:blocks:4096` keeps the direct kind (4.4× peak RSS, 19 → 83 MB, for a 0.420 loop and 0.965 whole process). Open, unallocated (report closeout): the generic step loop is 0.4–1.6 % cheaper on seventeen of eighteen cohorts for no controlled reason (discovery track, 2026-09-18; same family as the 2026-09-17 recompilation entry, PGO/build-configuration sweep is the proposed owner); `DEMOTE_BUCKET_ROWS` should grow with `log2(distinct)` (two sweep invocations); do not build an index no live step probes; a `matches` counter beside the lookups counter for selectivity. cache-gc dry run listed nothing removable; `c1202/` is 23 MB and `bin/` is 706 MB across the manifest, which is where the cache grows; deletion is Tavis's call.
**C1203 growing-index crossover done 2026-09-18, reviewed** (`../2026-09-18-c1203-growing-index-crossover-report.md`; core `ae3a043` … `d56f748`, docstring only; private `16fa25e` … `1500dc2`; Opus). `DIRECT_INDEX_DENSITY = 48` kept: the crossover it was fitted on is gone, the warm loop and the first evaluation cross an order of magnitude apart on either side of it. **Open for Tavis**: allocate the recommended successor, a growing-index rule on committed pages against probes with an expected evaluation count; evidence gaps are a uniform-key cohort and a second program with a large growing index.
**Source-comment standard (Tavis, 2026-09-18)**: Ergodis source carries professional comments only — no task IDs, notes paths or process narrative. Inventory `../2026-09-18-ergodis-core-task-reference-sweep.md`; core clean-up and lint in progress (`../2026-09-18-ergodis-core-comment-cleanup-report.md`); private/dev inventory `../2026-09-18-ergodis-private-dev-task-reference-sweep.md` (dev source clean; private fix not yet run).
**C1204 architecture review done 2026-09-18** (`../2026-09-18-c1204-datalog-rel-architecture-review-report.md`): read-only review of the Datalog/Rel functionality across core and private; ranked findings, a "do first" list and unallocated candidates await Tavis's allocation. Its first recommendation is allocated as **C1205** transferable evidence for the Rel route (`../2026-09-18-c1205-rel-transferable-evidence.md`, queued); its refusal finding as **C1206** structured refusals (`../2026-09-18-c1206-structured-refusals.md`, queued), with the wider **C1207** error reporting and error UI audit and design session (`../2026-09-18-c1207-error-reporting-audit-and-design.md`, queued; C1206 does not wait for it); everything else in the review is disposed of by **C1208** triage (`../2026-09-18-c1208-c1204-findings-triage.md`, queued). Read its C1194 finding before scoping C1194 and its domain-ceiling and refusal findings before C1195 fixes cohort sizes.
**Programme review and next steps (2026-09-16)**: `../2026-09-16-ergodis-datalog-programme-review.md`
ranks the gaps against the programme goal and allocates, in EV order: **C1192** (done, above),
**C1193** bodies of more than two atoms (done, above),
**C1194** min-plus carrier and term arithmetic through the lowering (`../2026-09-16-c1194-min-plus-lowering.md`),
**C1195** end-to-end benchmark suite from Rel source against Soufflé
(`../2026-09-16-c1195-end-to-end-benchmark-suite.md`, after C1192 and C1198; min-plus rows after C1194),
**C1196** rank-run and round-block certificate encoding (`../2026-09-16-c1196-certificate-encoding.md`).
Still unallocated: a memory model for a layer (`MAX_LAYER_TUPLES` as a byte bound, eager row
reservation as input); the kernel-scoped profile of `lower::run` closing the two unattributed
lowering-stage swings; the coverage rows (`exists(x in D: F)`, `not (F and G)`); the `Prepared`
name clash in `ergodis_rules`. Ergodis retains lowering, rules, joins and execution; no external
evaluator or backend is adopted. Tree-sitter and a PLT Redex model remain deferred.

### Datalog evaluation — C1179, C1182 and C1183 closed

C1179 (`../2026-09-13-c1179-datalog-closure-ballpark.md`) found the grounded rules path capped
at N≈24 by the grounding budget. C1182 (`../2026-09-13-c1182-demand-driven-datalog.md`) added
the demand-driven semi-naive evaluator (`Demand`, core `crates/rules/src/demand.rs`), admission
without grounding and the derivation-certificate checker (core `crates/verify`), and a matched
single-core comparison with Soufflé 2.5 through the private harness and
`analysis/datalog-comparison/`. C1183 (`../2026-09-13-c1183-ranked-certificate.md`) added the
ranked-relation certificate (relation plus one byte per tuple, searching checker, core
`crates/verify/src/ranked.rs`) and measured representation cost. C1184
(`../2026-09-13-c1184-direct-checker.md`) rebuilt both checkers and the shared closed-world pass
on direct-addressed stores (core `crates/verify/src/datalog_store.rs`): trace checking is now at
the order of evaluation on closure, ranked checking 3–9× evaluation. C1186
(`../2026-09-13-c1186-presence-bitmap.md`) added the presence bitmap: large sparse rows 1.2–1.7×
faster again (worst row, sparse same generation, now 4.3× evaluation for the trace checker and
7.7× for the ranked one), checker-only peak RSS measured. The checker profile is now bucket
enumeration and unification, not membership. C1185
(`../2026-09-13-c1185-certificate-size-exploration.md`) profiled generation and measured eight
candidate encodings: ranks as runs are a free strict win on the existing format; a binary
round-block form reaches 0.25–1.06 bytes per derived tuple; no core format changed. C1188 (queued) removes the runtime-length tuple `memmove` from the demand derivation loop
(discovery track, 2026-09-13; about a fifth of dense-closure evaluation). Unallocated
successors, in the order C1185 rates them: implement rank runs and the round-block certificate in core with its checker; a key-indexed rank
structure for the ranked checker's fully bound probes; a
bit-parallel closure kernel for dense inputs. Bodies with more than two atoms are done (C1193, above).

### Rule-contract programme — closed

Programme and sequencing: `../2026-09-12-ergodis-rule-contract-programme.md`; audit:
`../2026-09-12-c1171-rule-programme-review.md`.

- C1172: guarded Lean axiom audit and `WeightedRules` root target, with the documented
  separate/default-target caveat (`../2026-09-13-c1172-lean-audit-gate.md`, core `801e732`).
- C1173: one-pass support-witness least-fixedness certificates versus replay, including raw scalar
  and cyclic-program coverage (`../2026-09-13-c1173-support-certificate.md`, core `eead07b`).
- C1174: generic ordered-inflationary convergence with min-plus and Boolean instantiations
  (`../2026-09-13-c1174-generic-carrier.md`, core `c351eb9`).
- C1175: filtered-export manifest/lint, evidence lint, remote/tag/binary checks and pinned Rust
  toolchain (`../2026-09-13-c1175-release-hygiene.md`, core `b63c6dc`).
- C1176: `certificate.rounds` settled as a claimed bound admitted up to `min(N, M+1)`,
  symmetry invariance checked in verification, algebra laws gated, incremental grounding
  rebind, dense negative control where the frontier loses, fifteen review properties
  (`../2026-09-13-c1176-contract-semantics.md`, `../2026-09-13-c1176-core-properties.md`,
  core `2074025`). Open decisions for Tavis are in the report: identity/ownership
  redesign for per-update cost, evaluator policy, and the `Invariance` ABI code.

- C1177: sparse-frame dispatch asserted and property-tested, native 10^5–10^6-detector
  measurement (sparse frame 6–41× faster; external 60M→12M still unattributed), construction-time
  `parallel_workers`, single `Table` enum without `unreachable!`, count-axis parallelism measured
  and left serial, Domain parallel=serial and privacy property tests
  (`../2026-09-13-c1177-private-kernels.md`, private `051f734`).

Earlier C1154–C1168 increments and exact boundaries are indexed by the programme report; do not
reproduce their history here. Open programme follow-ups need allocation: the C1176 decisions for
Tavis (identity/ownership redesign, evaluator policy, `Invariance` ABI code) and, only if count-axis
parallelism is ever wanted, a merge-free core tile kernel (discovery track, 2026-09-13).
Foreign issues: private workspace Clippy was repaired under C1170 (2026-09-13); the `cargo fmt`
drift is committed (private `7a8bc5a`, 2026-09-15; `fmt --check` is clean); three uncommitted
interface-review edits from 2026-09-10 (a "Layered dynamic programs" ADR section and `scheduling`
in two family lists) and five campaign-console mockups remain foreign C1130 work awaiting Tavis;
the shared Cargo target directory produced a stale-rlib build failure under
concurrent checkouts during C1176; the worktree `~/.cache/ergodis/worktrees/c1176-props` holds
regenerated tracked `__pycache__` files.

### C1149 — public-release readiness

C1187 public-audience documentation cleanup is complete (core `5f537e6`), including
public contributor guidance in `docs/dev/` and the Python flake entry point:
`../2026-09-13-c1187-public-documentation.md`. No export or push was made.

Gap assessment and six-phase plan: `../2026-09-11-c1149-ergodis-public-release-review.md`.
Evidence remediation is complete. Both repositories hold a matched, validated snapshot at
`v0.1.0-preview3`: the crate (core `86b07c7`, public root `5dd74c0`) and the evidence repository
(evidence `581cc79`, public `036f593`), with the crate's benchmark prose linking into the evidence
snapshot at that tag. Each published branch is a single root commit, so neither history carries
anything earlier; the crate's earlier snapshots and preview tags were deleted on 2026-09-13 because
the first shipped tracked bytecode with local paths, and `EXPORTS.md` records the discard. That class
is now refused on the path alone by the publication lint's `generated` rule and by `hooks/pre-commit`
on every branch (core `14768a6`). Nothing has been pushed; both staging pushurls remain parked.
First phase-1 packaging pass is done (core `a7d033a`, `f8b4114`): every cited evidence file is named
in full rather than by brace or wildcard shorthand, and the twelve families no document named are
now documented in `BENCHMARKS.md` — the gross `[[144,12,12]]` searches with their Gurobi controls,
the rule-frontier A/B with the negative control where the frontier loses, the L2 dominance A/B, the
rank-envelope probe, the six-application no-regression record, and one structured CNF instance with
its selection manifest. Nothing was dropped. Staging holds the matched `v0.1.0-preview4` pair from
that work — crate (core `564ad08`, public `b464490`) and evidence (evidence `6d3fce7`, public
`d90fe31`), both validated, all 83 evidence URLs resolving. That pair is now stale: on Tavis's call
core `d407310` removed the compiled-rule-replay section and its five evidence files, and a wider
curation of `BENCHMARKS.md` to a few benchmarks of public interest is pending Tavis's choice of
sections. **Do not cut a snapshot until that lands.** Two items it must carry: the evidence
repository still tracks the five deleted files, because the refresh never deletes, so they need an
explicit `git rm` there first; and `2026-09-12-recursive-runtime-transcript.json` is uncited again.
Also open: the Gurobi licence blocker is stale — both families reproduce locally, so the
private-tier import can be fixed and that evidence regenerated (report has the numbers and the
shape decision it needs). Open for Tavis: phase-0 publication/product decisions; remaining phase-1
through phase-5 work is unallocated.

### C1143 — BB circuit-distance external benchmark (in progress)

Programme/protocol: `../2026-09-11-ergodis-external-benchmark-programme.md`; initial gate:
`../2026-09-11-c1143-bb-circuit-input-gate.md`; private current evidence:
`analysis/external-benchmarks/2026-09-11-coordinate-retraction.md` and adjacent reports.
Sparse/indexed native search, checked coordinate retractions and an independently replayed
weight-six witness are retained. This is exhaustive replay, not a succinct or formally verified
proof. No Gurobi timing exists under the restricted local licence, and no completed comparator
exclusion is claimed.

**Next:** matched proof-mode comparison, declared deeper hold-outs, deterministic subtree
parallelism, cost-aware provider/Evolve integration and matched published comparisons. C1144–C1147
remain later external workloads. C1148 certificate interoperability is queued; it does not imply
universal VIPR compatibility.

### C1130 — native/JS/WASM capability and workflow parity (in progress)

Current authority: `../2026-09-09-c1130-js-wasm-parity-review.md`; requirements:
`../2026-09-08-c1130-wasm-feature-completeness.md`; parameterization checkpoint:
`../2026-09-11-c1130-parameterization-checkpoint.md`. Detailed implementation and browser evidence
remain in dated reports and private `analysis/interface-review/`.

Delivered slices include shared native/WASM provider boundaries, checked active representation
admission, source-bound domain reuse, conditional family substitution, count/resource envelopes
and bounded batch readout (core `1127126`, private `5774a94`). This does not establish universal
representation switching, state conversion or cross-worker plan sharing. The generic partitioned
Hadamard join remains a native experiment pending WASM/Evolve integration; shared-memory telemetry,
broader plan contracts, Safari/Firefox coverage and complete workflow parity remain open.

**Next:** integrate the partitioned strategy with explicit cold compile-next boundaries; add a
sequential solve-time-versus-order view; continue calibrated admission, sparse envelopes/active
state conversion and certificate serialization/replay. Preserve one canonical engine, typed native
kernels and matched performance/conformance gates. Do not infer backend adoption.

### C1016 — order-2092 Hadamard reduction and search

Resume from the authoritative
[task card](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md) and its
[archive](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis-archive.md). Current structure map:
`../2026-09-11-c1016-inferred-repair-structure.md`; evidence gate:
`../2026-09-11-c1016-kick-retention.md`. Orders 668/716/2092 remain unsolved and the separate
strict-margin 14,800 recovery gate remains open.

**Next:** coverage-aware region proposals, cost-aware exact local representations and richer
invariant-preserving repair schedules. Before resuming, read `ergodis-dev/PERFORMANCE.md` and
the shared performance playbook. Proved/exact reductions grant negative coverage; heuristic
predicates do not.

### C1017 — whole-core performance-contract remediation

Current report: `../2026-08-30-c1017-ergodis-core-performance-contract-remediation.md`.
Allocation-counted hot loops, iterative traversal, Tiger layouts, worker ownership and retained
single/parallel counter gates remain the contract. The filtered export is lint-clean; the inherited
deferred-verification artifact still lacks an unverified marker.

### C1061 — compiled dynamic decision engines / TigerBlossom

Current exploration log: `../2026-09-03-c1061-exploration-log.md`; certificate-authority migration:
`../2026-09-07-c1098-certificate-authority-migration.md`. Legacy generic/specialized root-only
checkers are replay paths, not independent evidence authority. Surface-family results predating the
2026-09-04 constructor correction are invalid.

**Open:** third-family crossover test, queue-struct borrow split, non-observable stabilizer
compile-time split and latency tail beyond p99. Tavis owns the unspecialized graph routing,
C1066 queue-discipline tradeoff and PyMatching working-set-asymmetry calls.

### C1062 — structural causal models as a context language

Probes 0–8 and adversarial reviews are complete; closeout recommends dropping probe 9. Awaiting
Tavis's close call. Authority: `../2026-09-05-c1062-closeout-synthesis.md`; brief:
`../2026-09-04-c1062-ergodis-causal-brief.md`. Possible successors require allocation:
compositional counterfactual crossover and certificate emission without carrier compilation.

### C1070 — compositional leakage analysis

All probes are complete and reviewed; awaiting Tavis's close call. Authority:
`../2026-09-06-c1070-closeout-synthesis.md`; brief:
`../2026-09-06-c1070-ergodis-compositional-leakage-brief.md`. Schema migration, certified
incremental mode and a paper carve-out are separate future decisions.

### C985 — exact algebraic optimization paper

In progress as the optimization-facing sequel; it does not block complete-ports. Current gate is
the algebraically deduplicated weight-six discovery sweep with direct-sum rejection, seeking a
Pareto survivor with `k d^2 / n > 19.2`. Reports:
`../2026-08-30-c985-completion-compression-and-wide-search.md` and
`../2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md`.

C1178 framing complete: `../2026-09-13-c1178-ergodis-framing.md` leads with a spectrum from
Evolve discovery to optional static specialized kernels; ranked alternatives, drafts,
source register and paper-evidence gaps are retained there. On paper resume, C985 should
resolve the precise integrated contribution and coupling evidence before a novelty claim;
the separate optimization manuscript's location remains unconfirmed. No public prose changed.

## Additional routed work

- C1180 categorical lift–fold–lower and general equivalent-representation recognition are
  queued, including checked semantic reuse and C1139 AME frames as a workload-gated candidate;
  C1181 cross-domain pilot and
  resumed Evolve are gated on its memo and Tavis's architecture choice. Queue audit, contracts
  and gates: `../2026-09-13-c1180-c1181-categorical-structure-folding.md`. Reuse C1155's
  existing quotient/normalization results and C1162's lowering checker; coordinate C1157
  plan rewriting and C1156 proposal policy without treating either as the complete loop.
- C1111/C1112 reconstruction-driven representation discovery remains a bounded private spike;
  C1113 is gated on native end-to-end benefit. Reports:
  `../2026-09-07-c1111-reconstruction-contract-corpus.md`,
  `../2026-09-07-c1112-autonomous-representation-discovery.md` and
  `../2026-09-07-continuation-ergodis-reconstruction-plan.md`.
- C1072–C1074 are queued finite-geometry instance-family leads. Read their exact queue rows and the
  linked `../2026-07-16-relconic-discovery-track.md` entries only when selected.
- C1031–C1033, C1040–C1048, C1052, C1156–C1157 and remaining tooling/capability work retain their
  exact queue/task-report status; none is implicitly resumed by this map.
- Closed C1080–C1129 portable runtime, verification, repository and UI work is indexed by its dated
  task reports and summarized in the companion archive. Do not treat those delivered slices as
  universal host, mathematical-authority or execution-support claims.

## Workspace rules

`ergodis-private` is a library-only Cargo workspace with task crates under `tasks/`; no `src/bin`.
Builds use `~/.cache/ergodis/target/`, retained A/B binaries use `retain-bin.sh`, and task close uses
`cache-gc.sh`. Follow each sibling repository's `AGENTS.md` and the contributor performance guides.
Preserve the public/private source partition and never publish private paths, reports or capabilities.

The bounded-recovery manuscript tasks C325, C953, C955 and C964 remain owned by `complete-ports`.
