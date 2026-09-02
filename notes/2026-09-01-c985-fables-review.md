# C985 context: Fable architecture review of Ergodis, evolve capabilities, and targets

**Lane:** `complete-ports` (context for C985; no C985 work performed)

**Date:** 2026-09-01

Read-only review of the public crate `papers/complete-repair-ports/ergodis` and the
private crate `ergodis-private`, followed by capability and target suggestions
centred on `evolve`. Two Opus sub-agent reports are appended verbatim in Parts
B and C; Part A is the synthesis, which also draws on the C985 card and the
C1016 Hadamard order-2092 report.

No code was built, run, or edited.

---

## Part A: synthesis

### A.1 Public `ergodis`: what to tighten

1. **The public-core boundary is leaking.** `balanced.rs` (q=27 branch),
   `defect.rs` (q=27 defect-19), two `check-c98*` scripts, a C985 seed constant
   in `bench_kernels.rs`, and the tracked `evidence/` tree are campaign-specific
   code in the reusable crate. `Cargo.toml` `exclude` misses `scripts/`,
   `python/`, `bench_kernels.rs`. Move them to `ergodis-private`.
2. **Three files are a large fraction of the crate.** `observational.rs` (six
   separable concerns, eight tuple type-aliases standing in for structs),
   `css_distance.rs` (a five-width ladder copy-pasted four times plus dense
   `cfg(parallel)` sites), `control/evolution.rs` (zero public items, reached
   only through a very wide `Campaign`). Split into directory modules with
   `pub use` in `mod.rs`; generate the width ladder with a macro or a
   `const PULSED: bool` parameter.
3. **Two evolution engines.** `theorem_search::evolve_implications` (generic,
   runner-neutral) and `control/evolution.rs` (daemon, own grammar, mutators,
   evidence schema) share no code. Pick one as the engine and make the other a
   driver. This matters most for the evolve capabilities below.
4. **Two API conventions.** Hundreds of root re-exports next to `pub mod`s with
   none; four library files import through the root facade;
   `bp_osd::MatrixError` shadows `matrix::MatrixError`. Pick module paths as
   the API and add `#![warn(missing_docs)]`.
5. **Build hygiene.** Undeclared autobins (`css_distance_native` silently
   builds crippled without `large-css,parallel`); `clap` is a hard library
   dependency used only by binaries; the test allocator is compiled twice via
   `#[path]`; most examples hand-roll `env::args`.
6. **Hot-path invariant not provable.** `AlignmentSearchWorkspace` has
   `cfg(control-plane)` fields, so default and control-plane builds differ in
   layout. Make instrumentation a zero-sized generic parameter as `AGENTS.md`
   prescribes.

### A.2 `ergodis-private`: what to tighten

1. **The bin tree is the problem.** Nearly two hundred targets, a third of
   them the same short "call one library function, print JSON" shim; the
   build tree is 12 GB. Collapse the probes into one clap dispatcher over a
   registry table.
2. **No `[profile]` section**, so private benchmarks build without LTO at the
   default codegen-units while campaign reports cite cycle counts. Paste the
   public crate's `release`/`profiling`/`campaign` profiles, or make the two
   crates a workspace.
3. **Duplication clusters:** a verbatim `struct Field` over
   `ergodis::field::SmallField` plus `rref`/`gcd`/`factor_prime_power` in the
   c10xx bins; control-plane wait/ready boilerplate in five bins; sha256
   helpers re-rolled per file; cyclic sumset kernels reimplemented at several
   packed widths; three near-clone banked-evolve modules. Wanted:
   `campaign.rs`, `digest.rs`, one sumset kernel.
4. **Dead modules:** `g41_q174_joint_join`, `g41_crt_allocation`,
   `tactical_completion`, `semantic_theorems`; `bitset_sumset` duplicates the
   public bitset and has no users.
5. **The stated architecture does not hold.** Few `use ergodis::` sites for
   the code volume; many bins use neither crate; most binary code sits in
   untested fat bins; `certdist`/`certiis` are products living in a scratch
   crate; two `c1018-*` features silently change census results and are
   undocumented; `README.md` still describes the package as two adapters.

### A.3 Evolve: capabilities, measured against where C1016 is

Current state (from the C1016 report): the blind harness recovers all
fourteen reductions from theorem-derived residual coordinates and from opaque
paired scalars plus a pairwise-difference expander. It does not yet recover
them from raw orbit masks or counts. The C1016 public-core enhancement ledger
already names a relational grammar, counterexample-guided refinement with
presentation-version transitions, typed set-theorem templates, a persistent
typed feature DAG, and Pareto scope learning. The additions below sit on top of
that ledger; each is a sub-hour to half-day slice given the team's pace.

1. **Raw-orbit term DAG.** Hash-consed, costed terms of degree at most two
   over orbit counts, CRT residues modulo small `m`, and quadratic/Eisenstein
   norms, with the direct orbit evaluator supplying labels. This is the
   ledger's own "final raw gate" and the one change that would make "evolve
   invented the mathematics" defensible.
2. **Parametric templates across multiplier shards.** The g41/g53/g91/g133
   theorems are instances of one shape (CRT multiplier-orbit algebra, fixed-
   field norm equation, e.g. `13 n27 + 15 n29 = 34`). Evolve with `g` and the
   character orders as symbolic fields so one retained rule transfers across
   shards. The open item "affine multiplier classes beyond commuting
   translations remain uncompiled" is what this would cover systematically
   instead of shard by shard.
3. **Prune power in bits.** Rank candidates by exact log2 reduction against
   the current census (the reports compute such bit counts by hand), Pareto
   with evaluation cost and scope size. Replaces coverage counts with the
   number the campaign actually optimizes.
4. **Basin obstruction from the checkpoint corpus.** The exact q0--q3
   checkpoints collapse to eight q4--q9 residual templates and the
   special-block mask strongly predicts the basin. Feed that corpus to evolve
   with the q4-unreachability label. A sound rule there is the proof-level
   obstruction the report prefers over deeper annealing.
5. **Invariant-first proposer as default.** The q87 holdout failure showed
   constant-on-positive selection must precede any decision tree. Make that
   the standard proposer order in core, not a private adapter.
6. **Promote learned scope masks and the zero-conjunction proposer** into
   `theorem_search`, merging with `control/evolution.rs` at the same time
   (item A.1.3).
7. **Number-theoretic opcodes** (`Mod`, `Div`, `Gcd`, `PopCount`, `Parity`,
   Legendre symbol) in `PlanOp`. Minutes to add; the current grammar cannot
   express `x ≡ r (mod m)` although every private campaign is CRT-shaped.
8. **Aggregation over variable-length rows** (`Sum`/`Min`/`Max`/`All`/`Any`
   over an orbit or residue class), needed for statements about sequences and
   PAF profiles rather than scalar summaries.
9. **Sound decision lists.** Cover the positive set with disjoint sound rules
   (set cover), emitting a cascade the plan VM already evaluates.
10. **Sharded beams** reusing the CSS modulo shard partition and ledger for
    multi-hour evolve runs.
11. **Parameter evolve** (search, not theorem): candidate = construction
    parameters (BB polynomial pair, QC generator, sequence orbit), cheap
    fitness = BP+OSD upper bound or residual score, exact certification for
    survivors. The control daemon already has the loop shape.

### A.4 Targets

- **Order 2092, current shard.** The g41 fine-lift tablebase is the
  runtime-critical item: 1,498 canonical block specifications, a few ideal
  hours on four workers, blocked only on refining the table key through the
  common q174 quotient. Nearest closable step.
- **Order 2092, the wall.** Every result so far is multiplier-assumed
  bordered Goethals--Seidel; shard negatives never decide existence. The
  publishable outcomes are either a witness or a structural nonexistence for
  the whole multiplier-assumed class, which needs A.3.2 to enumerate
  multiplier classes rather than pick them.
- **Order 668.** Smallest open Hadamard order and the headline target; 167 is
  prime like 523, so the same pipeline applies with blocks of size 166. Check
  which 668 classes Đoković and Kotsireas have already excluded before
  committing a campaign.
- **Open Legendre-pair lengths** (77, 85, 87, 115, 117, 129, 133, ...).
  Two-circulant PAF with fixed sums; the `Z/18`-style quotient-PAF synthesis
  transfers directly, and 133 = 7·19 has rich quotients.
- **Circulant weighing matrices and D-optimal designs.** Same cyclic-orbit and
  quotient kernels, open table entries at moderate orders.
- **BB/qLDPC distance table.** Certify BB756 `[[756,16,<=34]]` and the
  remaining open QDistSAT rows exactly, then run A.3.11 to hunt codes beating
  `k d^2 / n = 19.2` (the C985 card's own successor).
- **Best-known linear codes.** Quasi-cyclic/quasi-twisted search at moderate
  length with the Gray/Brouwer--Zimmermann exact distance kernel; the tables
  are regularly improved by exactly this loop.
- **Hyperovals and complete caps.** Classification of hyperovals in PG(2,32)
  and PG(2,64), small open complete-cap and second-largest-arc sizes; ties
  into the cap lane and the projective/orbit modules.
- **Trapping-set spectra** for 5G NR and DVB-S2 base graphs via
  `applications::search_trapping_set` with evolved pruning theorems.
- **Public CP benchmarks** (MDD/CostRegular, OR-Library RCSP) for the paper's
  breadth gate.

### A.5 Vibe

The library is strong and the campaign side is fast; the drag is the three
oversized files and the split between the two evolve engines. Evolve is real
discovery infrastructure but still only finds what human-built coordinates
present to it. The raw-orbit term DAG plus parametric templates is the step
that turns it into a theorem generator for the whole multiplier family.

---

## Part B: sub-agent report, public `ergodis` (verbatim)

### Architecture review — `papers/complete-repair-ports/ergodis`

Read-only review, 2026-09-01. No builds run. All paths relative to
`/home/tavis/src/othello/papers/complete-repair-ports/ergodis`.

#### (a) The crate as it is

`ergodis` is a ~60k-line single-crate flat library (`src/*.rs`, 58 top-level modules plus
one `src/control/` subdirectory) that compiles finite algebraic presentations into exact,
replayably-certified answers, with a CLI (`src/bin/ergodis.rs`), a JSON-RPC server, and an
optional `control-plane` campaign daemon. `src/lib.rs` (259 lines) is a flat facade: every
module is `pub mod`, and 43 `pub use` blocks additionally re-export ~450 names at the crate
root, so most types are reachable by two paths. The module graph is shallow and mostly
tree-shaped with two hubs and almost no depth:

```
                 field ── matrix ─┬─ projective ──┬── balanced
                                  │               └── defect
                                  ├─ composition ─┬── transfer
                                  │               ├── confinement
                                  │               └── contextual
                                  ├─ commutant
                                  └─ span, applications, css_distance

  observational (8.6k, zero crate deps) ──┬── group_action ── semantic_symmetry
                                          │                └── cyclic_action
                                          ├── ordered_resource ── frozen_shortest_path
                                          ├── provenance, continuation, automata
                                          └── interface

  isolated leaves (no `use crate::`): scheduler, alignment, zdd, sat, bp_osd,
      parametric_certificate, linear_code, query_design, residual_hitting,
      orbit_compile, theorem_search, modular_power, multiset, fibre

  control/  (cfg control-plane): mod.rs (3.4k) ─ evolution.rs (5.3k) ─ vm.rs ─ synthesis ─ text ─ client
```

Notably `observational.rs` and `css_distance.rs` alone are 14.7k lines — a quarter of the
crate — and `src/control/` is another 11.3k. `arena` and `zdd` are the only private modules.
`bin/` (7.1k), `examples/` (5.5k, 27 files), `benches/` (11 criterion targets plus C++/Python/patch
files), `python/` (30 check scripts), `scripts/` (46 shell drivers) and a tracked
`evidence/` (108 files) surround it.

#### (b) Findings, ordered by impact

##### 1. Domain-specific research kernels sit in the public core, contradicting the crate's own boundary rule

`DESIGN.md` "Public-core boundary" and `AGENTS.md` both state that domain-specific,
task-specific, or experimental code must live in `ergodis-private/`. Several modules
violate this in their own doc comments:

- `src/balanced.rs:1` — "Normalized exact front end for the **Gf27 balanced `q=27` branch**" (3444 lines).
- `src/defect.rs:1` — "Exact arithmetic pruning for the **open q=27, |D|=54 defect-19 branch**" (1218 lines).
- `scripts/check-c983-observational-mata-evidence.sh`, `scripts/check-c987-observational-hierarchy-evidence.sh` — private monorepo C-task IDs named inside the public core.
- `src/bin/bench_kernels.rs:309` — `let mut state = 0xC985_10A6_7A11_5EED_u64;` encodes a private C-task ID in a seed constant.
- `evidence/` (108 git-tracked files, e.g. `c985-bb288-native-deepsplit-t4.jsonl`) is C-task-labelled campaign output living in the reusable package.

Why it hurts: the boundary is the crate's stated trust and export contract, and it is
already leaking. `Cargo.toml:13` excludes `AGENTS.md`, `PERFORMANCE.md`, `evidence/`, and
`proptest-regressions/` from packaging, but not `scripts/`, `python/`, or `src/bin/bench_kernels.rs`,
so a `cargo package` today ships the C-task-named research tooling.

Change: move `balanced.rs`, `defect.rs`, the C-task-named scripts, and `bench_kernels.rs`
to `ergodis-private/`, keeping only the domain-neutral primitives they rest on
(`projective`, `field`, `matrix`). Rename the seed constant. Extend `Cargo.toml`'s
`exclude` to `scripts/`, `python/`, `benches/*.cc`, `benches/*.py`, `benches/*.patch`.

##### 2. `src/observational.rs` at 8626 lines is a compiler, a certificate format, a file format, and a scheduler in one file

`rg '^pub (fn|struct|enum)' src/observational.rs` returns 53 items spanning four distinct
concerns, and the file's line ranges show them cleanly separated already:

| lines | concern |
|:------|:--------|
| 65–800 | presentation model + partition refinement core (`FinitePresentation:157`, `SplitRecord:770`) |
| 2169–2360 | weighted generator words/plans (`WeightedGeneratorPlan:2196`) |
| 2452–2660 | frozen-observation storage and limits (`FrozenObservation:2470`) |
| 2669–3182 | layered scheduling and audited layered compilation (`plan_layered_greedy_schedule:2669`) |
| 3872–4380 | binary file I/O and audit verification (`write_frozen_observation:3872`, `verify_frozen_layered_dag_audit:4380`) |
| 6534–6882 | separator streaming (`stream_exhaustive_separators:6534`) |
| 7117–8626 | inline `mod tests` (~1500 lines) |

Why it hurts: this is the crate's most-depended-on module (six modules import it) but
compiles, links, and re-tests as a unit; incremental rebuild cost and review surface are both
maximal. The eight tuple `type` aliases at `src/observational.rs:22-38` (`Partition`,
`WorklistPartition`, `MultiwayPartition`, `SplitWorkspace`, …) are a symptom: functions are
returning 4-tuples of boxed slices because there is no place to put a proper struct.

Change: split into `observational/{mod,presentation,refine,frozen,layered,codec,separator}.rs`,
keeping `pub use` in `mod.rs` so no downstream import changes. Promote the tuple aliases to
named structs while doing it. Move the inline tests to `tests/observational_*.rs` or per-submodule
`mod tests`.

##### 3. `src/css_distance.rs` (6082 lines) hard-codes a five-way width ladder by copy-paste

`src/css_distance.rs:949-966` defines five type aliases over one generic
`CompiledWideCssDistanceImpl<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>`
(`Wide`, `ExtraWide`, `Large`, `Huge`, `Colossal`), and then each width gets its own
hand-written monomorphizing wrapper pair:

```
src/css_distance.rs:1740  search_syndrome_branch_partition_wide
              :1763        …_extra_wide
              :1787        …_large
              :1811        …_huge
              :1840        …_colossal
              :1868        …_wide_unpulsed          (the same five again)
              …:1987-2148  five near-identical `impl WidePartitionKernel for …` blocks
```

plus five `impl WideSyndrome for PackedSyndrome<{3,6,11,13}>` blocks at
`:404,:449,:494,:539` and five per-width `impl CompiledWideCssDistanceImpl<…>` blocks at
`:2849,:2890,:2932,:2974,:3016`. The file also carries 78 `cfg(feature = "parallel")`
sites — more than the rest of the crate combined (`composition` 15, `scheduler` 12) — and
20 `large-css` sites.

Why it hurts: a change to the partition kernel must be replicated five to ten times, and the
feature-cfg density means the module has 4 distinct compiled shapes that only
`--all-features` ever exercises together. `scripts/check-css-feature-matrix.sh` exists
precisely because of this.

Change: generate the width ladder with a `macro_rules!` (or push the `unpulsed` variant to a
const-generic `PULSED: bool` parameter, which the compiler will monomorphize identically);
lift the parallel/serial split into one `fn drive(…)` seam so `cfg(parallel)` appears at a
handful of sites instead of 78. Split the module into
`css_distance/{mod,packed,filters,compile,search,artifact}.rs`.

##### 4. The crate root is a second, redundant public API, and 14 `pub mod`s are outside it

`src/lib.rs` re-exports ~450 names at the root while leaving every module `pub`. Fourteen
`pub mod`s have no root re-export at all — `balanced`, `bitset`, `bp_osd`, `control`,
`defect`, `incidence`, `observational`, `packed_ternary`, `projective`, `provenance`,
`root_execution`, `rpc`, `sat`, `witness` — so the "root facade" is not actually the API;
consumers must know which of the two conventions applies per module. The confusion has already
leaked back into the library: four modules import their own crate through the root facade
rather than the owning module —

```
src/linear_code.rs:8   use crate::{Matrix, MatrixError};
src/commutant.rs:9     use crate::Matrix;
src/rpc.rs:16          use crate::PrimeQuadraticCharacter;
src/orbit_compile.rs:1 use crate::{OrbitError, OrbitOption};
```

and `tests/contextual_allocations.rs:1-13` has to mix both styles in one test
(`use ergodis::observational::{…}` next to `use ergodis::{Matrix, …}`).

Also leaking: `src/bitset.rs` is a 62-line `pub mod` used by exactly one module
(`src/incidence.rs`); `src/packed_ternary.rs` (135 lines) is used only by `src/orbit.rs`;
`src/witness.rs` (61 lines) only by `src/span.rs`; `src/arena.rs` and `src/zdd.rs` are
correctly private already.

Change: pick one convention. Recommended: keep modules `pub`, delete the root `pub use`
blocks (or reduce them to a `prelude`), and demote `bitset`, `packed_ternary`, `witness`,
`incidence`, `root_execution` to `pub(crate)`. Fix the four root-facade self-imports to
name their owning module.

##### 5. `src/control/` is a god-object with a 5276-line module that exports nothing

`src/control/evolution.rs` is the largest file in the crate after `observational.rs` and
`css_distance.rs`, yet `rg '^\s*pub (enum|struct|fn)'` finds **zero** public items — it is
reached only through 24 `pub(crate)`/`pub(super)` items and `Campaign` in
`src/control/mod.rs:227`, which carries 63 methods. `src/control/mod.rs` also holds the
constants, `Manifest`, `Request`, `Response`, the socket client (`send_request:1922`), and
the campaign state machine.

Separately, the crate already has a **runner-neutral** generic evolution engine at
`src/theorem_search.rs:68` (`evolve_implications`, `evolve_implications_streaming`,
`EvolutionConfig`, `CandidateTrial`) which `DESIGN.md` describes as the generic
seed/mutate/test/rank loop. `control/evolution.rs` implements its own competing
candidate/mutation/ranking machinery with its own `EVOLUTION_EVIDENCE_SCHEMA` and constants
(`src/control/evolution.rs:14-32`). Two evolution engines, one generic and unused by the daemon.

Change: split `control/mod.rs` into `protocol.rs` (constants, `Request`/`Response`,
`Manifest`), `client.rs` (already exists, 115 lines — move `send_request` there), and
`campaign.rs` (the state machine). Then either re-express `control/evolution.rs`'s search on
top of `theorem_search`'s traits, or state in `DESIGN.md` why they are deliberately separate
and mark `theorem_search` as the offline-replay engine.

##### 6. Feature-conditional fields inside the search workspace break the "no measurable effect" invariant

`DESIGN.md` ("Hot-path invariant") says an inactive controller must have no measurable
search effect. But `src/alignment.rs:814-818` puts three `#[cfg(feature = "control-plane")]`
fields *inside* `AlignmentSearchWorkspace`, allocated unconditionally in `new`
(`src/alignment.rs:843-845`: `vec![[u8::MAX; 56]; budget+1]`), and 13 further cfg sites through
the module including the search function itself (`:1137`, `:1412`, `:1422`).

Why it hurts: the struct has two layouts and the hot search has two shapes, so a
`control-plane` build is not the same binary as a default build even when no controller is
attached — the invariant can only be checked by A/B-ing two builds, not by toggling a
runtime flag, and `benches/steering_gate.rs` can only measure one of them per compile.

Change: make the control-order buffers a runtime `Option`-shaped side table owned by the
caller (or a zero-sized generic `Instr: Instrumentation` parameter, as `AGENTS.md` prescribes
— "prefer const-generic monomorphization for … instrumentation"), so a default build is
provably the same code path.

##### 7. Four binaries are auto-discovered with no `[[bin]]` entry and no `required-features`

`Cargo.toml:41-64` declares five binaries. `src/bin/` contains nine:

```
src/bin/css_distance_native.rs        865 lines, 42 large-css/parallel cfg sites — undeclared
src/bin/css_distance_shard_ledger.rs  607 lines — undeclared
src/bin/bench_kernels.rs             2338 lines, 9 cfg sites — undeclared
src/bin/binary_linear_distance.rs     110 lines — undeclared
```

Why it hurts: cargo's autobins picks these up on every build, so they are compiled by
`cargo test` and shipped by `cargo package`, and the two that need features get their gating
only from internal `#[cfg]` (so a default-feature `css_distance_native` silently builds a
crippled binary rather than failing to build). `README.md:203-225` documents
`css_distance_native` extensively as though it were a declared target.

Change: add explicit `[[bin]]` entries with `required-features = ["large-css", "parallel"]`
for `css_distance_native` and the shard ledger; move `bench_kernels.rs` to
`ergodis-private/` (see finding 1) or set `autobins = false` and declare the survivors.

##### 8. `bench_kernels.rs` duplicates the criterion bench suite

`src/bin/bench_kernels.rs` is a 2338-line hand-rolled harness with its own LCG
(`advance_lcg`, `src/bin/bench_kernels.rs:39`), `Instant` timing, and `black_box`, importing
~25 kernels across the crate. `benches/` already holds 11 criterion targets covering
`scheduler_locality`, `defect_augmentation`, `balanced_frontend`, `parallel_kernels`,
`balanced_parallel`, `contextual_state`, `observational_compiler`, `ordered_resource`,
`gl_probe`, `steering_gate`, `character_sum`.

Why it hurts: two measurement stacks with different statistics means `BENCHMARKS.md` (57 KB)
mixes numbers that are not comparable, and the validation gate in `AGENTS.md` (interleaved
A/B with hardware counters) has no single owner.

Change: fold whatever `bench_kernels` measures that criterion does not into criterion
targets, and delete it. `benches/` should hold only Rust bench targets — move
`benches/mata_observational_driver.cc`, `benches/mata_official_dfa_driver.cc`,
`benches/boa_observational_fixture.py`, `benches/boa-kernel-timing.patch` and
`benches/disable_composition_reduction.patch` to `ergodis-private/` or a `third_party/` dir.

##### 9. The allocation-probe allocator is compiled twice via a `#[path]` hack

`src/lib.rs:60-61` declares `#[cfg(test)] mod test_alloc;` — a `GlobalAlloc` shim
(`src/test_alloc.rs:1`) used by 13 modules' unit tests. Because it is `cfg(test)`, the
integration test at `tests/contextual_allocations.rs:16-17` cannot reach it and instead does:

```rust
#[path = "../src/test_alloc.rs"]
mod test_alloc;
```

Why it hurts: two independent copies of a *global allocator* across two test binaries, with
no compiler check that they agree; any change to the probe silently applies to one and not
the other until someone notices.

Change: expose it as `#[cfg(any(test, feature = "alloc-probe"))] pub mod test_alloc;` behind
a non-default `alloc-probe` feature, add that feature to the dev profile, and delete the
`#[path]` line.

##### 10. 72 unrelated error enums, one duplicated name, and no crate error contract

`rg '^pub enum ([A-Za-z]+Error)' src/ src/control/` yields 72 distinct error types with only
45 `#[from]` conversions between them and no crate-level union or shared trait. Two of them
collide by name: `src/matrix.rs:6` and `src/bp_osd.rs:141` both define `pub enum MatrixError`
(only the former is re-exported at the root, `src/lib.rs`), so `bp_osd`'s is silently
shadowed for anyone reading the root API.

Why it hurts: a caller composing three kernels writes three `From` impls by hand; the
duplicate name is an outright trap.

Change: rename `bp_osd::MatrixError` to `BpOsdMatrixError` (or reuse `matrix::MatrixError`
if the variants are compatible), and add a crate-level `ErgodisError` enum with `#[from]`
arms for the ~20 error types that actually cross module boundaries. Leave the rest module-local.

##### 11. `clap` and `anyhow` are non-optional library dependencies used only outside the library

`Cargo.toml:24` lists `clap = { version = "4.5", features = ["derive"] }` as a hard
dependency, but `rg -l clap src/*.rs src/control/*.rs` returns **nothing** — only
`src/bin/*.rs` uses it. `anyhow` (`Cargo.toml:19`) appears in exactly one library file,
`src/rpc.rs:9` (`use anyhow::Result;`), while every other module uses `thiserror`.

Why it hurts: every downstream library consumer of `ergodis` pays clap's compile time and
dependency tree for binaries they do not build; `rpc`'s use of `anyhow::Result` in a library
API erases error types for that one module against the crate's own convention.

Change: move `clap` to `[dev-dependencies]` or gate it behind a `cli` feature that the
`[[bin]]` targets `required-features`; replace `anyhow::Result` in `src/rpc.rs` with a
`thiserror`-derived `RpcError`.

##### 12. 22 of 27 examples hand-roll argument parsing

`rg -l 'std::env::args' examples/` matches 22 files (`fork_join_cost_regular.rs` 1036 lines,
`resource_constrained_shortest_path.rs` 955, `observational_hierarchy_driver.rs` 771, …)
while `clap` is already an unconditional dependency and every `src/bin/` target uses it.
Only one example carries any `cfg(feature)` guard (`examples/gf27_balanced_dfs.rs`), and
`Cargo.toml` declares no `[[example]]` `required-features` at all.

Why it hurts: each example invents its own flag names and error messages, so the shell
drivers in `scripts/` (46 of them) encode 22 different CLI conventions; and the several
1000-line "examples" are really unlisted research binaries.

Change: examples over ~200 lines are drivers, not examples — move them to `ergodis-private/`
with proper `clap` interfaces (finding 1 applies: `gf27_*`, `legendre333_*`, `vlsat_*` are
domain-specific). Keep a handful of short, doc-quality examples in the public core and give
them `clap`-derived args.

##### 13. Documentation drift

- `README.md:181-190` "Commands" table lists six CLI subcommands. `src/bin/ergodis.rs` defines eight — `hall` (`src/bin/ergodis.rs:88`) and `verify-hall` (`:97`) are undocumented.
- `CONTROL_PROTOCOL.md` has six sections and documents no request opcodes; `src/bin/ergodisctl.rs:39-259` implements ~30 subcommands (`GroupSynthesize`, `AgentBrief`, `TargetProfileEdge`, `EvolveProfileRefresh`, `Obstruction`, `Exceptional`, `Trace`, …). The wire protocol document does not enumerate the wire messages.
- `DESIGN.md` "Documentation map" lists README, OPTIMIZATION, CONTROL_PROTOCOL, BENCHMARKS; it does not mention `PERFORMANCE.md` (14.7 KB) or `AGENTS.md`, which `AGENTS.md` itself makes mandatory reading before any `src/` edit.
- `README.md:284` is the only mention of `bp_osd`, which is a 636-line `pub mod` with no root re-export and no entry in the design docs.
- 15 modules have no `//!` doc comment at all, including public ones: `src/projective.rs`, `src/matrix.rs`, `src/field.rs`, `src/scheduler.rs`, `src/composition.rs`, `src/confinement.rs`, `src/span.rs`, `src/orbit.rs`, `src/orbit_compile.rs`, `src/bitset.rs`, `src/incidence.rs`, `src/packed_ternary.rs`, `src/witness.rs`, plus private `arena.rs`, `zdd.rs`. `src/lib.rs` sets no crate lints — no `#![warn(missing_docs)]`.

Change: regenerate the README command table from `ergodis --help`; add a wire-message table
to `CONTROL_PROTOCOL.md` derived from the `Request` enum; add `#![warn(missing_docs)]` to
`src/lib.rs` and fill the 15 module headers (this is cheap and mechanical).

##### 14. Inline tests inflate the largest modules; `tests/` mirrors nothing

Roughly 4.5k lines of the crate are inline `mod tests` inside the seven largest modules
(`src/observational.rs:7118` → 1508 lines; `src/css_distance.rs:4926` → 1156;
`src/control/evolution.rs:3864` → 1412; plus `balanced:2603`, `scheduler:2422`,
`ordered_resource:1922`, `contextual:2119`, `applications:1633`). Meanwhile `tests/` holds
seven files whose names do not follow the module tree (`bp_osd.rs`, `cli.rs`,
`contextual_allocations.rs`, `observational_compiler.rs`, `python_parity.rs` (951 lines),
`parametric_certificate_python_parity.rs`, `rpc_jsonl.rs`) and one fixture.

Why it hurts: it is not discoverable which behaviour is covered where — `python_parity.rs`
is a single 951-line file covering an unknown span of modules, while `bp_osd` (which has no
inline tests) is the only module with a same-named integration file.

Change: adopt one rule — unit tests inline stay under ~200 lines and cover private
invariants; everything exercising the public API moves to `tests/<module>.rs`. Split
`tests/python_parity.rs` by oracle domain so a failure names its subject.

#### (c) Do first

1. **Enforce the public-core boundary** (finding 1): move `balanced.rs`, `defect.rs`,
   `bench_kernels.rs`, the two `check-c98*` scripts and the C-task seed constant out to
   `ergodis-private/`, and extend `Cargo.toml`'s `exclude`. This is the crate's own stated
   contract and it is currently violated in code that ships.
2. **Declare the four undeclared binaries with `required-features`** (finding 7) — a
   one-screen `Cargo.toml` change that removes a real "silently builds the wrong thing"
   failure mode for `css_distance_native`.
3. **Rename `bp_osd::MatrixError` and move `clap` off the library's hard dependencies**
   (findings 10, 11) — both are small, mechanical, and each removes an active trap for
   downstream consumers.
4. **Split `src/observational.rs` into a directory module** (finding 2), keeping `pub use`
   in `mod.rs` so no import changes downstream. It is the crate's most-depended-on module
   and the split lines are already visible in the file's structure.
5. **Pick one public-API convention and add `#![warn(missing_docs)]`** (findings 4, 13) —
   decide whether the root facade or the module paths are the API, fix the four
   root-facade self-imports, demote the five single-consumer `pub mod`s to `pub(crate)`,
   and fill the 15 missing module doc headers.

---

## Part C: sub-agent report, `ergodis-private` (verbatim)

### Architecture review — `ergodis-private`

Read-only review, 2026-09-01. Root: `/home/tavis/src/othello/ergodis-private`.

#### (a) Map

`ergodis-private` is a single non-published package (`version = "0.0.0"`, `publish = false`) holding
83 library modules (60,324 lines) and 197 binaries (30,943 lines), all in two flat directories with
no submodule hierarchy. Naming is by research family: `g41_*` (30 modules / 100 bins), `g53_*`
(16 / 25), `g133_*` (5 / 27), plus one-off `c1018_*`/`c1020_*`/`c1025_*`/`c1028_*`/`c1029_*`/`c80_*`/
`c985_*` bins that carry their logic entirely inside `src/bin`. The library is well-disciplined —
81 of 83 modules carry `#[cfg(test)]` blocks, most have real doc headers, and the four dedicated
allocation-tracking integration tests in `tests/` match the zero-allocation contract stated in
`AGENTS.md`. The binary tree is the opposite: it is a mix of 8-line JSON-printing shims and
2,500-line unshared services, only 13 of 197 have any tests, and 26 never touch the library at all.
Coupling to the public core at `../papers/complete-repair-ports/ergodis` is remarkably thin — about
60 `use ergodis::` sites across 91k lines, dominated by `ergodis::control` (21), `ergodis::projective`
(10) and `ergodis::root_execution` (7) — so the private crate is mostly a parallel universe rather
than an adapter layer over the public core, which is what `README.md` claims it is.

#### (b) Findings, by impact

##### 1. The `src/bin` tree is the real architectural problem: 197 targets, 12 GB of build output

Evidence: `ls src/bin | wc -l` = 197; `du -sh target` = **12 GB**; bin size distribution is
p25 = 23 lines, median = 54, p75 = 127. 44 bins are ≤ 20 lines, 67 are ≤ 30, 92 are ≤ 50.
The dominant shape is verbatim, e.g. `src/bin/g41_q29_orbit_signature.rs` in full (8 lines):

```rust
use anyhow::Result;
use ergodis_private::g41_q29_exact_tablebase::g41_q29_orbit_signature;

fn main() -> Result<()> {
    serde_json::to_writer(std::io::stdout(), &g41_q29_orbit_signature()?)?;
    println!();
    Ok(())
}
```

`src/bin/g53_mod343_scout.rs` and `src/bin/g133_sparse_exact_q2_pair_shape.rs` are character-for-
character the same modulo the imported function name. 30 bins match the "no clap, print one
`serde_json::to_writer(std::io::stdout(), ...)`" shape exactly.

Why it hurts: every one of those targets is a separate link of the whole 60k-line library plus the
public core, which is where the 12 GB comes from, and a full `cargo build` of the package is
dominated by linking rather than compiling. It also makes discovery hopeless — there is no way to
learn what probes exist except `ls`.

Concrete change: add one dispatcher binary, `src/bin/probe.rs`, with a `clap` subcommand enum
generated from a registry table `pub const PROBES: &[(&str, fn() -> anyhow::Result<serde_json::Value>)]`
living in a new `src/probe_registry.rs`. Each family module exports its zero-argument entry points
(they already do — 271 `ergodis_private::<mod>::<fn>` call sites from bins), so the registry is a
mechanical list. Delete every ≤ 30-line bin (67 targets) in favour of `probe <name>`. Keep bins only
where the target genuinely needs its own `clap` argument surface or a distinct build profile. That
alone should cut the target directory by most of its size and turn 67 files into one table.

##### 2. Explicit `[[bin]]` entries coexist with autodiscovery, so naming is inconsistent

Evidence: `Cargo.toml:23-...` declares 12 `[[bin]]` sections (e.g. `name = "projective-grid-scout"`,
`path = "src/bin/projective_grid_scout.rs"`), but `autobins` is never disabled, so the other 185
files are auto-discovered under their snake_case file names.

Why it hurts: 12 targets are invoked as `cargo run --bin g53-search` and 185 as
`cargo run --bin g53_joint_q29_scout`, with no rule distinguishing them. `g53-search` and
`g53_search.rs` differ only in a hyphen, which is a live foot-gun in replay commands recorded in
evidence files.

Concrete change: pick one convention. Either delete all 12 `[[bin]]` sections and let every target
keep its snake_case file name, or set `autobins = false` and declare targets explicitly. Given
finding 1 collapses most of them anyway, deleting the 12 sections is the cheap move.

##### 3. No `[profile]` section at all, despite `AGENTS.md` claiming public-core performance discipline

Evidence: `Cargo.toml` has `[package]`, `[features]`, `[dependencies]` and twelve `[[bin]]` sections
and nothing else — no `[profile.release]`, no `[profile.campaign]`, and no `[workspace]` membership.
The public core at `../papers/complete-repair-ports/ergodis/Cargo.toml` defines
`[profile.release] opt-level = 3, lto = "thin", codegen-units = 1, panic = "abort"`,
`[profile.profiling] inherits = "release", debug = true`, and
`[profile.campaign] inherits = "release", overflow-checks = true`.

Why it hurts: `ergodis-private` is its own root package, so profile settings come from *its*
manifest, not the dependency's. Every private benchmark and hot-loop measurement — including the
`scripts/benchmark_overflow_profile_ab.sh` and `scripts/benchmark_projective_grid_parallel.sh`
harnesses — is being built at `codegen-units = 16`, no LTO, and unwinding panics, while `AGENTS.md`
asserts that "private solve adapters follow the same zero-allocation, iterative-search, Tiger-style
hot-record, contention-free parallelism … discipline as the public core". Any A/B number produced
here is not comparable to a public-core number, and the `overflow-checks` campaign profile the
scripts name does not exist in this package.

Concrete change: copy the public core's `[profile.release]`, `[profile.profiling]` and
`[profile.campaign]` blocks into this manifest verbatim; better, make the two packages a Cargo
workspace so profiles are defined once at the root. Re-run any perf claim recorded in `evidence/`
that was produced before the fix.

##### 4. `Field` and `rref` are copy-pasted across the c10xx bins although the public core exports both

Evidence: `src/bin/c1018_prs_deephole.rs:68` and `src/bin/c1025_prs_stratum.rs:83` both define

```rust
struct Field { p: usize, h: usize, q: usize, inner: SmallField }
```

with identical `new`/`a`/`m`/`n`/`i` wrappers over `ergodis::field::SmallField` (the only textual
difference is struct-literal vs named-binding construction). `src/bin/c1018_prs_census.rs:118` has a
third copy. `fn factor_prime_power` appears in 4 bins, `fn gcd` in 4, `fn lcm` in 3, `fn rref` in 3
(`c1018_transversal_css.rs:47`, `c1018_level_census.rs:60` as a GF(2) `Vec<Word>` variant, and
`c1018_prs_census.rs:248` as a `&Field` variant), `fn smith_normal_form` in 2, `fn dual_basis` in 2,
`fn reed_muller` in 2, `fn binom` in 2, and `type Word = u64` in 2. Meanwhile `ergodis::matrix::Matrix`
exists and `src/bin/c1018_prs_deephole.rs:472 fn ergodis_rank` already routes rank through the core —
so one bin in the family knows the core has this and the others do not.

Why it hurts: these are the newest bins (August/September 2026) and they are diverging copies of
number-theory primitives whose bugs would not be caught by the library's test suite, because bins are
untested (finding 6). A wrong `factor_prime_power` in one of four copies is an undetectable evidence
corruption.

Concrete change: create `src/small_field_ops.rs` in this crate holding the `Field` newtype,
`factor_prime_power`, `gcd`, `lcm`, `binom`, and both `rref` variants (GF(2)-packed and
`&Field`-generic), with the usual `#[cfg(test)]` block; port the seven c10xx/c80/c985 bins onto it.
Then promote the two `rref` kernels and `factor_prime_power` into the public core next to
`ergodis::matrix` and `ergodis::field` — they are domain-neutral and meet the `AGENTS.md` bar of
"domain-neutral kernel, contract, tests, and documentation".

##### 5. Campaign control-plane driver boilerplate is duplicated five times

Evidence: `fn wait_until_ready`, `fn wait_for_evolution` and `fn require_ok` each appear in exactly
five bins — `src/bin/blind_evolve_harness.rs:55`, `src/bin/blind_raw_holdout_harness.rs`,
`src/bin/banked_rule_evolve_audit.rs`, `src/bin/banked_semantic_evolve_audit.rs`,
`src/bin/target_strategy_audit.rs`. The body is a bounded 10,000-iteration 1 ms poll loop against
`ergodis::control::send_request`. The same three files also each rebuild the
`"seeds": [tree["plan"].clone()]` evidence envelope
(`blind_evolve_harness.rs:146`, `banked_semantic_evolve_audit.rs:155`, `banked_rule_evolve_audit.rs:136`)
and each derive a `<slug>.jsonl` data path from an `--data-dir`
(`banked_semantic_evolve_audit.rs:106`, `banked_rule_evolve_audit.rs:93`).

Why it hurts: the poll bound, the readiness predicate, and the evidence envelope schema are
protocol-level facts about the campaign control plane. Five independent copies means the schema can
silently fork per campaign, which is exactly the failure mode the reproducibility conventions are
meant to prevent.

Concrete change: add `src/campaign.rs` exporting `wait_until_ready(&Manifest)`,
`wait_for_evolution(&Manifest)`, `require_ok(Result<Response>)`, a `CampaignData::open(dir, slug)`
JSONL loader, and an `EvidenceEnvelope` serde struct that owns the `seeds`/`schema`/provenance
fields. If the poll loop proves stable, promote `wait_until_ready` and `require_ok` into
`ergodis::control` itself — the public core already owns `send_request`, `read_manifest` and
`Manifest`, so the readiness handshake belongs beside them, not in five private bins.

##### 6. 18.5k lines — 60% of the binary code — sits in 20 fat, untested bins

Evidence: 20 bins exceed 300 lines and together hold 18,505 of the 30,943 bin lines. The largest are
`src/bin/certdist.rs` (2,537), `src/bin/certiis.rs` (2,368), `src/bin/c1018_prs_census.rs` (1,832),
`src/bin/c1028_chain_ring.rs` (1,294), `src/bin/c1020_exterior_sets.rs` (1,128),
`src/bin/c80_hall_rematch.rs` (1,001). Only 13 of 197 bins contain `#[cfg(test)]`, against 81 of 83
library modules.

Why it hurts: logic in a binary cannot be imported, so it cannot be unit-tested, cannot be reused by
the next campaign, and cannot be covered by the allocation-tracking harness in `tests/` (which can
only see `pub` library items). The library's excellent test discipline stops at the `src/bin`
boundary, and that is where the newest and least-reviewed mathematics lives.

Concrete change: for each bin over ~300 lines, move everything except `fn main` and the `clap`
`Args` struct into a sibling library module (`src/c1018_prs_census.rs`, etc.), exactly as the g41/g53
families already do. This is mechanical and unblocks tests for the c10xx work.

##### 7. `certdist` and `certiis` are products, not research probes, and should leave this package

Evidence: `src/bin/certdist.rs:1` — "a certified exact minimum-distance *service prototype* … a
job-level driver around the Ergodis CSS distance tools"; it spawns `css_distance_native` as a
subprocess (`certdist.rs:363 std::thread::spawn`, `:647 std::thread::scope`) and implements its own
information-set decoder. `src/bin/certiis.rs:1` — "explainable infeasibility for assignment and
scheduling instances", a CLI tool over `ergodis_private::hall_core::HallWorkspace`. Together they are
4,905 lines, 16% of all bin code, and both have user-facing CLIs and their own evidence-publication
logic (`certiis.rs:2342 fn evidence_publication_is_create_only`).

Why it hurts: `AGENTS.md` defines this package as the home for work that is "domain-specific,
task-specific, experimental, private, or not yet demonstrably reusable". These two are the opposite:
general-purpose tools with stable interfaces that happen to live in the scratch crate. They inflate
every build of the research probes and they inherit the scratch crate's missing release profile
(finding 3), which matters because `certdist` is a performance-sensitive exhaustion driver.

Concrete change: split them into their own packages (`tools/certdist`, `tools/certiis`) depending on
the public core, with `hall_core` promoted into `ergodis::hall` (the public core already has a `hall`
module) so `certiis` no longer needs the private crate at all. Do this as a workspace, per finding 3.

##### 8. Four modules are dead; `bitset_sumset` duplicates a public-core module and has no bin users

Evidence: a per-module scan for `ergodis_private::<mod>` in `src/bin/*.rs` plus `<mod>::` in
`src/*.rs` and `tests/` finds zero references anywhere for:

| Module | Lines | Bin users | Lib users |
|---------------------------|------:|----------:|----------:|
| `src/g41_q174_joint_join.rs` | 446 | 0 | 0 |
| `src/g41_crt_allocation.rs` | 325 | 0 | 0 |
| `src/tactical_completion.rs` | 187 | 0 | 0 |
| `src/semantic_theorems.rs` | 86 | 0 | 0 |

That is 1,044 lines compiled into every one of the 197 binaries for nothing. Separately,
`src/bitset_sumset.rs` (78 lines, `xor_sumset_256_into` and `bitset_256_contains`) has no bin users
and only two internal users (`src/g133_sparse_defect.rs`, `src/g41_q29_evolve.rs`), while the public
core exports `ergodis::bitset`.

Why it hurts: dead modules with tests look maintained and mislead the next reader about what the
current attack surface is. `g41_q174_joint_join` in particular sits beside three live siblings
(`g41_q174_joint`, `g41_q174_grouped_join`, `g41_q174_full_q87_join`), so it reads as part of the
family.

Concrete change: delete the four dead modules and their `pub mod` lines in `src/lib.rs:1-80` — git
history is the archive. For `bitset_sumset`, check whether `ergodis::bitset` already provides the
XOR-sumset kernel; if it does, delete the private copy, and if it does not, promote these two
allocation-free functions into it (they are exactly the "domain-neutral kernel" `AGENTS.md` describes).

##### 9. Sumset and residue arithmetic is reimplemented at least eight times across families

Evidence: `src/g41_q29_q58_energy.rs:323 fn cyclic_sumset`, `src/g53_mod28_reduction.rs:135 fn sumset`,
`src/g53_mod49_high_scout.rs:330 fn sumset`, `src/g133_sparse_defect.rs:1652 fn energy_sumset`,
`:2376 fn or_shifted_q2_bitset`, `:2865 fn residue_sumset64`, `:4898 fn residue_sumset11`,
`:5666 fn oracle_residue_sumset11`, plus `src/bitset_sumset.rs:6 fn xor_sumset_256_into`. Residue
machinery is similarly scattered: `fn residue_state`/`add_residue_states`/`complement_residue_state`/
`compile_residue_domain`/`compile_residue_pair` at `src/g41_joint_quotient_search.rs:403-513`,
`fn three_cycle_affine_residue` at `src/g133_sparse_defect.rs:1315`, `fn affine_residue` and
`fn scoped_affine_residue_masks` at `src/feature_synthesis.rs:622,704`.

Why it hurts: each is a cyclic-group sumset over a differently-packed bitset (`u16`, `u32`, `u64`,
`u128`, `[u64; 4]`, `[u64; 256]`, `&[u64]`). Six of the nine already have oracle tests, which is good,
but the *fastest* implementation cannot be shared with the other five families, so a per-node win in
one family (the "levers compound" effect) never propagates.

Concrete change: define one `src/cyclic_sumset.rs` with a `trait ResidueBits` implemented for the
packed widths in use and generic `sumset_into` / `shift_or_into` kernels, keeping every existing
oracle test as a conformance test on the trait. This is the single highest-leverage consolidation for
future performance work, and the resulting kernel is domain-neutral enough to promote later.

##### 10. Thread-pool and worker-count handling is ad hoc across 15 bins

Evidence: 15 files use `std::thread::scope` directly (`src/bin/certdist.rs:647`,
`src/bin/c1018_prs_census.rs:1145`, and 13 more). A `threads: usize` `clap` field is redeclared in
at least `c1018_level_census.rs:52`, `c80_hall_rematch.rs:812`, `css_bp_osd_spike.rs:15`,
`c1018_plane12_hyperoval.rs:67`, `g41_joint_quotient_search.rs:8`,
`g41_joint_projection_rootwise.rs:10`, with the `available_parallelism` fallback re-derived in
`c1018_plane12.rs:322` and `c1018_plane12_hyperoval.rs:490` and a hard-coded ceiling in
`css_bp_osd_spike.rs:185` (`bail!("--threads must be in 1..=12")`). The manifest enables
`ergodis`'s `parallel` feature (which pulls in rayon transitively) but `ergodis-private` has no direct
rayon dependency and no `use rayon` anywhere — the one mention is a stale comment at
`src/bin/certdist.rs:2326` describing "rayon workers" in code that uses `std::thread::scope`.

Why it hurts: worker-count policy, the `available_parallelism` fallback, and the host-wide one-heavy-
build constraint should be one decision, not fifteen. The stale rayon comment will mislead the next
person tuning `certdist`.

Concrete change: put a `#[derive(clap::Args)] pub struct Workers { #[arg(long)] pub threads: Option<usize> }`
with a `resolve()` method into the new `src/campaign.rs` (finding 5) and `#[command(flatten)]` it into
every parallel bin. Fix the `certdist.rs:2326` comment.

##### 11. `sha256` and digest helpers are re-rolled per file

Evidence: `fn sha256(path: &Path) -> Result<String>` appears verbatim in
`src/bin/alignment_root_corpus.rs:117`, `src/bin/routing_policy_audit.rs:82`,
`src/bin/target_strategy_audit.rs:144`; `fn sha256_hex(data: &[u8])` at
`src/bin/c1029_parametric_cert.rs:46`; `fn digest(bytes: &[u8]) -> String` at `src/bin/certiis.rs:515`;
`fn hex_digest(bytes: &[u8])` at `src/bin/certdist.rs:219`; and `fn digest_hex([u8; 32]) -> String` is
duplicated in `src/banked_rule_evolve.rs:265`, `src/banked_semantic_evolve.rs:311`,
`src/g133_evolve_adapter.rs:167`, `src/raw_feature_evolve.rs:153`.

Why it hurts: the reproducibility conventions make SHA-256 of inputs a load-bearing artifact. Ten
independent hex encoders is ten chances for a case or byte-order discrepancy between an evidence file
and a replay check. It is a small amount of code but a high-consequence one.

Concrete change: one `src/digest.rs` with `pub fn file_sha256(&Path) -> Result<String>`,
`pub fn bytes_sha256(&[u8]) -> [u8; 32]`, `pub fn hex(&[u8; 32]) -> String`. Port all ten call sites.

##### 12. The banked-evolve modules are three near-clones of one search loop

Evidence: `src/banked_rule_evolve.rs` (379 lines), `src/banked_semantic_evolve.rs` (421),
`src/raw_feature_evolve.rs` (307) and `src/g133_evolve_adapter.rs` (289). A diff of their top-level
function names shows the same skeleton — `digest`, `digest_hex`, `write_*_campaign` — with
`write_banked_rule_campaign` vs `write_banked_semantic_campaign` the paired names, and the semantic
variant adding only `row_count` and `fill_ternary_row`. Each has a matching pair of bins
(`*_adapter.rs` + `*_audit.rs`), and the two audit bins are themselves near-clones (finding 5).

Why it hurts: four copies of one campaign-emission pipeline means four places to update when the
campaign data schema in `docs/CAMPAIGNS.md` changes, and that schema is already declared
`experimental-v0`, i.e. expected to change.

Concrete change: extract `pub trait BankedSystem { fn slug(&self) -> &str; fn digest(&self) -> [u8; 32];
fn rows(&self, out: &mut RowSink); }` into `src/campaign.rs` and reduce each of the four modules to an
impl plus its domain-specific row generator. The two audit bins then collapse into one generic
`banked_audit` bin parameterised by system.

##### 13. Nested scratch crates carry untracked build trees inside the package

Evidence: `find . -name Cargo.toml` finds `./controls/query-design-c1011/Cargo.toml`,
`./experiments/c985_native_bp/Cargo.toml`, `./experiments/c985_bp_order/probe/Cargo.toml` in
addition to the root manifest. `controls/query-design-c1011/target` is 42 MB and is untracked and
un-ignored: the repository `.gitignore:30` covers only `ergodis-private/target/`, not nested ones —
which is why `controls/query-design-c1011/target/` shows up as an untracked path in `git status`.

Why it hurts: it is the same failure the "no build trees in notes/" rule exists for. It also means
three sibling crates exist outside the main manifest with no relationship to it, so they get no
profile, no shared dependency versions, and no visibility.

Concrete change: add `ergodis-private/**/target/` to the repository `.gitignore`, and point the
nested crates' `.cargo/config.toml` at a `build.target-dir` under `~/.cache/`. Longer term, fold
these three into the workspace from finding 3 so they share a lock file and profiles.

##### 14. Feature flags are undocumented and change results, not just code paths

Evidence: `Cargo.toml:10-11` declares `c1018-sparse-action` and `c1018-lane-action`. Both are used in
exactly one file, `src/bin/c1018_prs_census.rs:47-59`, as a three-way `cfg` selection over what looks
like the projective action pack (`#[cfg(feature = "c1018-lane-action")]`,
`#[cfg(not(any(...)))]`, `#[cfg(all(not(lane), sparse))]`). Neither `README.md` nor `docs/CAMPAIGNS.md`
mentions them; `docs/CAMPAIGNS.md` documents only the public core's `control-plane` feature.

Why it hurts: a census result recorded in `evidence/` (188 files) depends on which of three
mutually-exclusive action packs was compiled in, and nothing in the evidence envelope necessarily
records that. This is a reproducibility hazard under
`notes/research-reproducibility-conventions.md`, which requires the exact replay command.

Concrete change: either make the choice a runtime `--action-pack {dense,sparse,lane}` argument (all
three packs exist in `ergodis::projective`, so there is no code-size argument for `cfg`), or, if the
`cfg` is there for monomorphisation performance, emit the active feature name into the census
report's provenance field and document all three in `docs/CAMPAIGNS.md`.

##### 15. The public core is barely used, contradicting the stated architecture

Evidence: `README.md` describes this package as "research adapters … over the public Ergodis core",
but `use ergodis::` appears roughly 60 times total across 91k lines, concentrated in
`ergodis::control` (21), `ergodis::projective` (10), `ergodis::root_execution` (7),
`ergodis::field` (6), `ergodis::matrix` (4), with single uses of `theorem_search`, `observational`,
`group_action`, `linear_code`, `bp_osd`. 26 of 197 bins import nothing from `ergodis_private` either,
i.e. they are fully standalone programs that happen to live here. Meanwhile the public core exports
55+ modules including `bitset`, `hall`, `multiset`, `orbit`, `span`, `cyclic_action`, `defect`,
`incidence` and `modular_power`, several of which name exactly the things being hand-rolled above
(findings 4, 8, 9).

Why it hurts: the value of maintaining a public core is that private research gets faster because the
kernels are already there and already tested. That is not happening; the private tree is
re-deriving `rref`, sumsets, bitsets, Hall matching and digests. Each re-derivation is also a missed
promotion opportunity that `AGENTS.md` explicitly asks for.

Concrete change: run one audit pass mapping each private helper cluster (findings 4, 8, 9, 11, and
`src/hall_core.rs` against `ergodis::hall`) to the public module that already covers it, and record
the verdicts. Where the core covers it, delete the private copy; where the core does not, promote per
the `AGENTS.md` procedure (read the core `AGENTS.md` and `PERFORMANCE.md` first, promote only the
domain-neutral kernel plus contract, tests and docs).

##### 16. Documentation conventions are stated but under-followed

Evidence: `AGENTS.md` mandates "zero-allocation, iterative-search, Tiger-style hot-record,
contention-free parallelism, and single-/parallel A/B counter discipline" for private solve adapters,
and points at the core `PERFORMANCE.md`. The allocation discipline is real but narrow — `tests/` holds
three allocation-tracking suites (`g41_pair_workspace_allocations.rs`,
`hadamard_2092_allocations.rs`, `proof_synthesis_allocations.rs`, 450 lines) covering 3 of 83 modules,
with the counting global allocator itself living in `src/lib.rs:82-136` under `#[cfg(test)]`. The
single/parallel A/B counter discipline has no visible harness in this package at all. `README.md`
still describes the package as containing "the projective grid-game scout and the live
alignment-attachment campaign controller" as its "current adapters" — an accurate description of
maybe 800 of 91,000 lines.

Why it hurts: `README.md` is now actively misleading about what is here, and a stated discipline that
covers 3 of 83 modules reads as universal to anyone who has not counted.

Concrete change: rewrite `README.md`'s "current adapters" paragraph as a short table of the live
research families (g41, g53, g133, c10xx, cert tools) with one line each. In `AGENTS.md`, scope the
zero-allocation claim to the modules that actually have allocation tests, and state the rule for when
a new module must add one (proposal: any module with a hot loop invoked from a campaign bin).

#### (c) Do first

1. **Add the profile blocks** (finding 3). One paste from the public core's `Cargo.toml`. Every
   performance number produced in this package is currently untrustworthy without it, and it is
   five minutes of work. Do this before any further benchmarking.
2. **Delete the four dead modules and drop the redundant `[[bin]]` sections** (findings 8, 2).
   Pure subtraction, 1,044 lines and one naming hazard gone, no behaviour change.
3. **Collapse the ≤ 30-line probe bins into one `probe` dispatcher** (finding 1). 67 targets to one,
   which is where the 12 GB target directory and most of the link time comes from. Mechanical, and
   the registry doubles as the discovery index the tree currently lacks.
4. **Create `src/campaign.rs` and `src/digest.rs`** (findings 5, 11). These are the two duplications
   with reproducibility consequences — a forked poll/envelope schema and ten hex encoders both
   corrupt evidence silently rather than loudly.
5. **Lift the c10xx `Field`/`rref`/`factor_prime_power` cluster into one private module, then promote
   the domain-neutral half into the public core** (finding 4). This is the newest and least-tested
   code in the tree, and it is where a copy-paste divergence would do the most damage to a
   paper-facing claim.

Deferred but queued: extracting `certdist`/`certiis` into their own packages (finding 7), unifying
the cyclic sumset kernels behind one trait (finding 9), and moving fat-bin logic into testable library
modules (finding 6) — all three want the workspace from finding 3 to exist first.
