# C1149 — Ergodis public-release readiness review

**Lane**: `ergodis`
**Date**: 2026-09-11
**Status**: REVIEW COMPLETE; remediation not started

## Scope

Assess `~/src/ergodis` (private `main`, AGPL-3.0-only core with `verify`, `runtime`,
`repository-native`, `modules` crates and `wasm/`) for a public GitHub release as a library
and CLI with documentation and demos. Deliverable: gap assessment and a remediation plan.
Read-only review; no source edits. Builds and lint run against a filtered snapshot of
`main` at the review revision, never against the working tree.

## Baseline facts (main agent, verified)

| Item | State |
|---|---|
| Review revision | `~/src/ergodis` main `c59bf67` |
| License | `LICENSE` is AGPL-3.0; `Cargo.toml` `license = "AGPL-3.0-only"`, `publish = false` |
| Public branch | `public` at `9ed76b3`; 465 private commits since the last export |
| Export pipeline | `scripts/export-public.sh` → `public` → staging clone `~/src/ergodis-public` → GitHub; guards in `hooks/`, `scripts/public-lint.sh`, `tests/publication-guards.sh` |
| Filtered-tree lint | 2 findings (down from the 67 recorded in the lane handoff): `private-path` tokens in `scripts/check-verifier-dependencies.py:45` and `scripts/check-runtime-dependencies.py:42` (the strings `"ergodis-private"` inside forbidden-dependency lists) |
| Unfiltered lint on `main` | 83 findings, all in paths `.publicignore` drops (`evidence/`, process docs) |
| Bin targets | `ergodis`, `ergodis-rpc`, `ergodis-campaign`, `ergodisctl`, plus benchmark/probe bins (`css_distance_random`, `scheduler_locality`, `defect_augmentation`, `balanced_frontend`, `parallel_kernels`, `balanced_parallel`, …) |
| Working tree | Foreign uncommitted edits present in `~/src/ergodis` (allocation-surface parallel work from another session); untracked `python/__pycache__/` |
| Release checklist | `docs-private/RELEASE-CHECKLIST.md` exists; `.publicignore` work-in-progress hold section is empty |
| CI | `.github/workflows/public-lint.yml` only; no build/test CI on the public branch |

## Review sections

Sections below are sub-agent reports, included verbatim.

### Documentation

Scope: the filtered public tree at
`/tmp/claude-1000/-home-tavis-src-othello-rust/315af775-8ba9-4191-9fe8-4f4079bcd2be/scratchpad/filtered`,
read as a stranger would. Gate: `~/src/ergodis/docs-private/RELEASE-CHECKLIST.md`.
All paths below are relative to the filtered tree unless stated otherwise.

Headline: the prose is unusually well written and the replay targets all exist, but the
release fails its own gate on four counts — a dead link to the companion paper, an
evidence-link scheme that corrupts shell commands, headline numbers that contradict each
other across three shipped documents, and a missing changelog. Separately, the crate's
rustdoc front page and its core module (`composition`) are effectively undocumented, and
the README carries a large block of optimization-diary prose that does not belong in a
user-facing document.

---

## Blockers

**B1. The companion paper is a dead link in three places, and it is the project's
central reference.**
`OPTIMIZATION.md:13` (`[Exact Compositional Transfer of Bounded Linear Recovery](../compositional_recovery.pdf)`),
`OPTIMIZATION.md:447`, `README.md:579`. The target resolves only inside the private
monorepo layout: the file is at
`/home/tavis/src/othello/papers/complete-repair-ports/compositional_recovery.pdf`, i.e.
one directory above the crate root. In a standalone public repository `../` is outside
the repository, so all three links are dead, and no arXiv identifier or DOI for this
paper appears anywhere in the tree. `scripts/export-public.sh:104-107` rewrites the
monorepo path prefixes but has no rule for this relative `../` form, so the export does
not repair it. A reader is told the mathematics is proved in a document they cannot
obtain. (The one arXiv link that does resolve, `BENCHMARKS.md:888`
`https://arxiv.org/abs/2605.04618`, is Jin and Fu's paper, not this one.)

**B2. The evidence-URL rewrite runs over fenced code blocks and turns replay commands
into nonsense.**
`scripts/export-public.sh:112` applies `s{\bevidence/}{$ERGODIS_EVIDENCE_BASE_URL/}g` to
every `.md` file. Its own comment at lines 95-98 claims the rewrite is "confined to prose
(Markdown)" so that "a script that regenerates evidence must keep writing to its own
relative directory" — but Markdown files contain the replay commands, so the rewrite hits
them too. Affected sites in the filtered tree:

| site | text before export | text after export (default base URL) |
|---|---|---|
| `BENCHMARKS.md:249` | `--raw-jsonl evidence/repair-dag-contended-ab.raw.jsonl \` | `--raw-jsonl https://evidence.invalid/ergodis-evidence/repair-dag-contended-ab.raw.jsonl \` |
| `BENCHMARKS.md:250` | `--output evidence/repair-dag-contended-ab.json` | `--output https://evidence.invalid/ergodis-evidence/...` |
| `BENCHMARKS.md:481` | `> evidence/w3-demand-scaling.tsv` | `> https://evidence.invalid/...tsv` (shell redirect to a URL) |
| `BENCHMARKS.md:574` | `> evidence/l2-dominance-scaling.tsv` | same |
| `CONTROL_PROTOCOL.md:71` | "writes each record ... to a create-only JSONL file under `evidence/`" | "under `https://evidence.invalid/ergodis-evidence/`" — a false statement about where the daemon writes |

**B3. `ERGODIS_EVIDENCE_BASE_URL` defaults to a non-resolving placeholder and every
evidence reference in the shipped docs will 404.**
`scripts/export-public.sh:39` defaults to `https://evidence.invalid/ergodis-evidence`.
The string `ERGODIS_EVIDENCE_BASE_URL` appears nowhere in the filtered tree, so a public
reader gets no explanation of why the links are dead. There are evidence references in
`README.md:574-575`, `OPTIMIZATION.md:380`, `CONTROL_PROTOCOL.md:71`, and fifteen in
`BENCHMARKS.md` (lines 108, 186, 240, 249, 250, 320, 462, 481, 574, 581, 626, 665, 693,
729, 881). The release checklist requires "Every evidence reference resolves at the
evidence repository tag that matches this release". Either the `ergodis-evidence`
repository is published and the variable is set at export time, or every one of these
references has to be reworded to say the evidence is not public.

**B4. `OPTIMIZATION.md`'s headline performance table quotes superseded numbers that
contradict `README.md` and `BENCHMARKS.md` on all four rows.**
`OPTIMIZATION.md:365-370` versus `README.md:558-563` and `BENCHMARKS.md:77-84`:

| workload | `OPTIMIZATION.md:367-370` | `README.md` / `BENCHMARKS.md` |
|---|---|---|
| XOR repair sets, 256 supports | 102 us vs Graphillion 864 us, **8x** | 3.014 ms vs 101.628 ms, **33.71x** (`BENCHMARKS.md:79`) |
| six-level tower, 4,096 leaves | 766 us vs direct CP-SAT 263.76 s, **344,300x** | 4.559 ms vs >400 s, **>87,743x** (`BENCHMARKS.md:865`) |
| local-code batch `[4095,2718]` | 231 ms vs direct CP-SAT 100 s, **432x** | 442.573 ms vs 270.939 s, **657.88x** (`BENCHMARKS.md:920-921`) |
| checkpoint repair, 10,000 shards | 100 us vs OR-Tools flow 103,061 us, **1,029x** | 3.803 ms vs 393.213 ms, **102.42x** (`BENCHMARKS.md:84`) |

`BENCHMARKS.md:98-103` explains the cause: a "corrected protocol" that starts a fresh
process per sample and includes model construction replaced an earlier amortized
in-process protocol. `OPTIMIZATION.md` was never updated. The checklist item "Numbers
quoted in prose match the evidence they cite" fails, and the two documents a reader is
told to read first disagree by up to a factor of ten.

**B5. `docs/ergodis-shape-classifier.md` contradicts `BENCHMARKS.md` on the two numbers
that carry the negative-control tier.**
`docs/ergodis-shape-classifier.md:165-166` says the counted-type reduction "raised W3
from 2.35x to 1,648.75x and W2 from 19.52x to 111.59x". `BENCHMARKS.md:439` says "from
2.35x to 1,368.75x. W2 gains too, from 19.52x to 82.51x", and the measured table at
`BENCHMARKS.md:302-303` records 82.51x and 1,368.75x. `BENCHMARKS.md:261` sends the
reader to the classifier page for exactly this material, so the two documents a reader
compares are the two that disagree.

**B6. No changelog exists, and the checklist requires one for the release.**
`RELEASE-CHECKLIST.md:20-21` requires "The changelog entry for this release is written
for readers". There is no `CHANGELOG.md` in the filtered tree, none in the private repo,
and no `.publicignore` entry holding one back. A first public release of a versioned
crate with no changelog and no release notes in-tree.

**B7. No copyright holder is named anywhere, while the README offers commercial
licensing.**
`README.md:605-607` says "distributed under the GNU Affero General Public License,
version 3.0 (AGPL-3.0); see `LICENSE` in this directory. Contact the author for
commercial licensing." `LICENSE` is the unmodified FSF text — its template line
`LICENSE:633` still reads `Copyright (C) <year>  <name of author>`, and no copyright
notice was added. `Cargo.toml` has no `authors` field. So the public tree names no
copyright holder and gives no contact address for the commercial-licensing offer it
makes. For an AGPL release with a dual-licensing intent this has to be fixed before
publication.

---

## Should-fix

**S1. `cargo doc` presents an incoherent front page, and the crate's core module is
undocumented.**
`src/lib.rs:1-4` is the whole crate-level doc:

```
//! Rust-native exact recovery kernels.
//!
//! The crate is organized around compact state representations and replayable
//! arena witnesses.  It intentionally does not mirror the Python module tree.
```

Four lines, then a flat list of 74 `pub mod` declarations with no grouping, no example,
no link to the README, and a closing sentence that only makes sense to someone who knows
the private Python tree. Thirteen of those modules have no module-level `//!` at all —
`bitset`, `composition`, `confinement`, `field`, `incidence`, `matrix`, `orbit`,
`orbit_compile`, `packed_ternary`, `projective`, `scheduler`, `span`, `witness` — and
they include most of the ones `README.md:90-101` sends a library user to. Worst case is
`src/composition.rs`: 43 public items, zero `///` doc comments on any of them, including
`CostTable` (`src/composition.rs:55`), `CompositionTower` (`:206`) and `CompositionTable`
(`:257`), which are the three types in the README's first working example. `README.md:103`
and `OPTIMIZATION.md:450` both tell the reader to run `cargo doc` as the way to learn the
API. (`src/matrix.rs` 4 of 24 documented, `src/applications.rs` 9 of 38,
`src/scheduler.rs` 16 of 44.)

**S2. `README.md:380-423` is an optimization diary, not user documentation.**
Forty-odd lines of A/B history inside the CLI section: "the retained 16-worker median
improved from 0.255602 to 0.234717 seconds (1.089x, Welch t = 6.37 over independent
11-round samples)", then five more successive medians (`0.177196`, `0.169677`,
`0.164733`, `0.153666`) each with its own t-statistic and speedup against the previous
one. It reads as a commit log pasted into the README, it duplicates material that belongs
in `BENCHMARKS.md`, and it buries the CSS-distance usage information around it. It also
ends (`README.md:420-423`) with a Gurobi comparison ("more than 282x faster in time to
proof on this protocol") in a section that is otherwise about command-line flags.

**S3. Two shipped CLI subcommands are documented nowhere.**
`src/bin/ergodis.rs:90` (`Hall`, "Decide a finite Hall restriction graph and emit an exact
obstruction or matching") and `src/bin/ergodis.rs:99` (`VerifyHall`, "Independently replay
a streamed Hall certificate"). The string `hall` appears in no Markdown file in the tree,
yet `examples/data/hall-projective-q11.json` ships as its input and `verify-hall` is the
only certificate-replay path the main CLI exposes. `README.md:184-191` lists six commands;
`ergodis --help` shows eight. `examples/data/compose.json` and
`examples/data/compose-gf4.json` likewise have no sample invocation, though `compose` is
in the table.

**S4. The README never mentions the demos.**
`wasm/` ships a complete browser demo — `wasm/www/index.html`, `campaign.html`,
`bundle.html`, its own `wasm/README.md`, and a headless-Chromium smoke driver — and
`README.md` does not mention `wasm` once. The only pointer from a top-level document is
`DESIGN.md:83-84` ("The browser adapter under `wasm/` is sequential and is not a general
extension host"), which reads as a limitation, not an invitation. `examples/` (41 Rust
examples) is referenced only as `examples/data/` for CLI inputs; the one example the
README names, `library_composition` (`README.md:86`), does exist and matches the snippet
verbatim. Note also that `Cargo.toml:4` excludes `wasm` from the workspace, so a root
`cargo build` does not build the demo and nothing says how to.

**S5. `docs/` is effectively unreachable from the README, and part of it is unreachable
from anywhere.**
`README.md` links to exactly one thing under `docs/`: the image `docs/pipeline.svg`
(`README.md:43`). No `docs/*.md` is linked from the README at all. Complete inbound-link
graph for the nineteen `docs/*.md`:

- Linked from a top-level document: `docs/ergodis-shape-classifier.md` (`BENCHMARKS.md:261`),
  `docs/admission.md` and `docs/language-semantics.md` (both `DESIGN.md:82`).
- Reachable only by following two or three hops from `DESIGN.md:82`: `glossary.md`,
  `scalar-plan-semantics.md`, `verification.md`, `campaign-semantics.md`,
  `runtime-service.md`, `browser-control.md`, `observable-admission.md`,
  `summary-transitions.md`.
- **Orphans — zero inbound references anywhere in the tree:**
  `docs/allocation-specializations.md`, `docs/composition-admission.md`,
  `docs/module-execution-checkpoints.md`, `docs/run-records.md`.
- Reachable only from an orphan or from `wasm/README.md`: `docs/run-bundles.md`,
  `docs/run-repository.md`.

There is no `docs/README.md` or index. A reader who does not open `DESIGN.md` and read to
the middle of a paragraph will never learn `docs/` exists.

**S6. `docs/glossary.md` is an internal naming-policy document, and 29 of its terms are
marked as not implemented.**
`docs/glossary.md:4` states up front that "Terms marked **planned** describe architectural
contracts, not current capabilities", and `planned` then appears 29 times — `Campaign
record`, `Run`, `Execution attempt`, `Workspace/repository`, `Run snapshot`, `Branch`,
`Lineage DAG`, `Annotation`, `Session host`, `Execution host`, `Control service`,
`Autonomous driver`, `Disclosure policy`, `Attach`, `Continuation`, `Interrupted`, and
more. The surrounding prose is addressed to the project's own developers, not to users:
"Choose names for the people who use Ergodis" (`:10`), "These are ownership and
translation boundaries, not an instruction to create six crates, services or class
hierarchies" (`:30-31`), "Use these names in new schemas and client-facing text"
(`:208`), and a `## Maintenance` section (`:206`). Published as-is it advertises an
architecture that does not exist and reads as a style guide that escaped.

**S7. Benchmark replay commands contain placeholders that the public tree never defines.**
`BENCHMARKS.md:246`, `:480`, `:573` use `<shared-target-dir>/release/examples/...` and
`BENCHMARKS.md:247` uses `<application-ab-venv>/bin/python`. Neither placeholder is
explained in any shipped document. They are residue of the private `.cargo/config.toml`
out-of-tree build directory, which `.publicignore` strips — so for a public user the
correct value is simply `target`, and the virtualenv is created by
`scripts/negative-control-tier.sh:18` under `$HOME/.cache/ergodis`. Copy-pasting the
command as printed fails. `BENCHMARKS.md:689` has the same shape with
`MATA_ROOT NFA_BENCH_ROOT MATA_COMPARISON_ROOT` (those at least match the script's own
usage line, `scripts/mata-official-ab.sh:5`).

**S8. Missing standard repository files.** None of the following exist in the filtered
tree or in the private repo: `CHANGELOG.md` (see B6), `CONTRIBUTING.md`,
`CODE_OF_CONDUCT.md`, `SECURITY.md`, `CITATION.cff`. The citation gap matters more than
the others here: the project is research software with a companion paper, an evidence
repository, and benchmark results people are meant to cite, and it gives a reader no
citation form at all. `CONTRIBUTING.md` is a deliberate hold — the public lint at
`.github/workflows/public-lint.yml:38-52` actively rejects "contributor or process
documents" — but the AGPL repository will still receive issues and pull requests and says
nothing about how they are handled. `SECURITY.md` is cheap and expected on a public
GitHub repository.

**S9. `docs/ergodis-shape-classifier.md:160` points a public reader at a private
document.** "both are recorded in `BENCHMARKS.md` and the task report rather than edited
into the table". "The task report" is an internal artifact that does not ship.
`RELEASE-CHECKLIST.md:14-16` covers exactly this case: "where an older document cites
one, rewrite it to the dated report title before export". No `C\d+` task identifier
survives anywhere in the shipped Markdown — that part of the gate passes cleanly — but
this reference to the internal report does not.

---

## Nice-to-have

**N1. The product name is capitalized inconsistently across the doc set.** `README.md`
(32 lowercase `ergodis` against 3 `Ergodis`) and `OPTIMIZATION.md` (20 / 0) and
`BENCHMARKS.md` (73 / 1) use lowercase; `DESIGN.md` (1 / 4), `docs/glossary.md` (1 / 3),
`wasm/README.md` (1 / 4) and `CONTROL_PROTOCOL.md` use capitalized. The H1 headings
disagree with each other: `# ergodis` (`README.md:1`), `# ergodis benchmarks`
(`BENCHMARKS.md:1`), `# Ergodis architecture and design boundaries` (`DESIGN.md:1`),
`# Ergodis glossary` (`docs/glossary.md:1`). Pick one and sweep.

**N2. `docs/glossary.md:142` forbids vocabulary the rest of the documentation is built
on.** "Avoid unqualified **verified**, **exact**, **complete**, **safe**, and
**trusted**." "Exact" is the crate's core positioning — `Cargo.toml:13` describes it as a
"Structure compiler and exact solver", `README.md:10` as "a compiler and exact solver",
and the word appears hundreds of times in `BENCHMARKS.md`. Either scope the rule to
schema and API identifiers (which is plainly what it was written for) or drop it; as
published it reads as the project contradicting itself.

**N3. `OPTIMIZATION.md:426` labels the paper's proofs as "human proofs"** ("The paper
proves the transfer and composition statements with human proofs"). The distinction the
sentence wants is between a structural proof and a machine-checked certificate; the label
adds nothing and invites the reading that some other proofs here are not. Same section,
`:424`, already makes the point cleanly ("The mathematical theorems do not depend on
ergodis or its benchmarks").

**N4. `BENCHMARKS.md:519` uses the adjective the project's own writing rules forbid** —
"the h—— reading is that the cap, not the algorithm, is what the L3 row measures". Drop
the word; the sentence is stronger as "the reading this supports is...".

**N5. Row labels `L1`-`L3`, `W1`-`W3`, `C1`-`C8` are opaque.** `BENCHMARKS.md:277-303`,
`:496-503`, and `docs/ergodis-shape-classifier.md:125-130`. A reader tracking the
negative-control tier across two documents has to hold six letter-number pairs in their
head with no mnemonic. The classifier reuses `C1`-`C6` for *criteria*
(`docs/ergodis-shape-classifier.md:26-50`) while `BENCHMARKS.md:496-503` uses `C1`-`C8`
for crossover-ladder *instances* — same labels, different meaning, adjacent documents.

**N6. `CONTROL_PROTOCOL.md` reads as an accumulated change log rather than a protocol
spec.** The wire format is 40 lines (`:15-53`); the remaining 450 are implementation
narrative in the register of "X is now part of that same durable snapshot" (`:247`), "The
first concrete projection is..." (`:270`), "Request/context delivery now mirrors result
delivery" (`:279`). For a feature the document itself calls experimental v0 (`:8`) this
is a large surface of internal detail with no summary, no operation table, and no worked
client example beyond the fixture pointer at `:48`.

**N7. `DESIGN.md:58-73` is a roadmap section in a released document.** "Live
snapshot/scorecard ingestion and durable evolution checkpoint/resume are accepted design
but are not yet implemented" (`:71-73`). `RELEASE-CHECKLIST.md:11-13` forbids "no 'in
progress' or 'next steps' sections, no references to work that does not exist yet" —
but names only `README.md`, `OPTIMIZATION.md` and `BENCHMARKS.md`, so `DESIGN.md`,
`CONTROL_PROTOCOL.md` and all of `docs/` escape that gate by wording. A status section in
an architecture document is defensible; the gate not covering the documents where the
problem actually lives is the thing to fix. Same class: `wasm/README.md:6` "Module
loading is not implemented", `wasm/README.md:114` "No Rust kernel or WASM binary change
is needed for this presentation layer" (a commit message, in a README).

**N8. Private-repository crate names appear in shipped source.**
`scripts/check-runtime-dependencies.py:42` and `scripts/check-verifier-dependencies.py:45`
list `ergodis-private` and `ergodis-host-native` as forbidden dependencies, and
`python/check_bb_native.py:71` matches a schema literal
`ergodis-private-css-bp-osd-spike-v2`. `~/src/ergodis/AGENTS.md:19-21` says this crate
"must not depend on or name private adapters". Harmless in effect — a reader learns only
that a private companion exists — but it is the sort of thing the export filter is meant
to catch.

**N9. Tracked Python bytecode ships in the export.** `python/recovery_algorithms/__pycache__/`
contains `.pyc` files that are tracked in git (`git ls-files` in the private repo lists
them) and are present in the filtered tree. Outside my area but it lands in the public
tree; flagging for the packaging reviewer.

---

## Verified: replay commands and doc-referenced targets

Every named script, example, bench, and binary in `BENCHMARKS.md` and `README.md` exists
in the filtered tree. Twenty-four rows checked, all pass:

| # | `BENCHMARKS.md` line | named target | exists |
|---|---|---|---|
| 1 | 189 | `python/run_benchmarks.py --write --applications-only` | yes; flag present |
| 2 | 190 | `python/run_benchmarks.py --application-sota-only` | yes; flag present |
| 3 | 193 | `python/verify_baseline_encodings.py` | yes |
| 4 | 244 | `cargo build --release --example repair_dag_contended` | `examples/repair_dag_contended.rs` |
| 5 | 245-250 | `python/run_repair_dag_contended_ab.py` + 9 flags | yes; all flags present |
| 6 | 461 | `scripts/counted-type-ab.sh` | yes |
| 7 | 479 | `--example negative_control_w3_probe` | `examples/negative_control_w3_probe.rs` |
| 8 | 572 | `--example negative_control_l2_probe` | `examples/negative_control_l2_probe.rs` |
| 9 | 585 | `scripts/negative-control-tier.sh` | yes |
| 10 | 589 | `scripts/check-negative-control-evidence.sh` | yes |
| 11 | 623 | `scripts/contextual-ab.sh` | yes |
| 12 | 624 | `scripts/contextual-memory-ab.sh` | yes |
| 13 | 627 | `python/summarize_contextual_ab.py` | yes |
| 14 | 666 | `run_benchmarks.py --jin-fu-contextual-only` | yes; flag present |
| 15 | 689 | `scripts/mata-official-ab.sh` | yes; argument names match `:5` |
| 16 | 907 | `run_benchmarks.py --jin-fu-only` | yes; flag present |
| 17 | 950 | `run_benchmarks.py --ergodis-limits-only` | yes; flag present |
| 18 | 968 / 988 / 1006 / 1021 | `--tma-large-only` / `--tower-stream-only` / `--streaming-input-only` / `--ergodis-thread-sweep-only` | yes; all four flags present |
| 19 | 1194 | `cargo bench --bench balanced_frontend` | `benches/balanced_frontend.rs`, `Cargo.toml:84-86` |
| 20 | 1249 | `--example gf27_balanced_dfs` | `examples/gf27_balanced_dfs.rs` |
| 21 | 1265 | `--bin bench_kernels` | `src/bin/bench_kernels.rs` |
| 22 | 1269-1284 | `--scheduler-tuning-only`, `--phase-only`, `--nonuniform-phase-only`, `--workspace-only`, `--locality-only`, `--baseline-binary`, `--tuning-only` | yes; all flags present |
| 23 | 1280 | `cargo bench --bench scheduler_locality` | `benches/scheduler_locality.rs`, `Cargo.toml:76-78` |
| 24 | 1282 | `cargo bench --features parallel --bench parallel_kernels` | `benches/parallel_kernels.rs`, `Cargo.toml:88-91`, `required-features = ["parallel"]` matches |

`README.md` targets also verified: `examples/library_composition.rs` (snippet at
`README.md:65-84` matches the file line for line), all ten `examples/data/*.json` inputs
named at `README.md:145-157` and `:518-522`, `scripts/check-css-feature-matrix.sh`
(`README.md:321`), `python/generate_fixtures.py` (`README.md:591`),
`tests/fixtures/control_protocol_v0.json` (`CONTROL_PROTOCOL.md:48`),
`benches/defect_augmentation.rs` (`BENCHMARKS.md:1108`),
`examples/gf27_prefix_probe.rs` (`BENCHMARKS.md:1122`),
`examples/gf27_balanced_probe.rs` (`BENCHMARKS.md:1195`),
`benches/character_sum.rs` (`BENCHMARKS.md:1297`),
`docs/pipeline.svg`, `docs/benchmark-highlights.svg`, `docs/parallel-scaling.svg`.

Also clean, and worth recording: no `C\d+` task identifier anywhere in the shipped
Markdown; no absolute `/home/tavis`, `src/othello`, or `papers/complete-repair-ports`
path anywhere in the filtered tree; no `TODO`/`FIXME`/`XXX`/`WIP` marker in any shipped
document; `Cargo.toml` metadata (version 0.1.0, `rust-version = "1.87"`, description,
repository, license, exclude list) is consistent with `README.md:109` and `README.md:119`.

---

## Remediation

| # | Action | Effort |
|---|---|---|
| 1 | Resolve the companion paper (B1): deposit it with a DOI or arXiv identifier and cite that, or bundle the PDF in the repository; then fix `OPTIMIZATION.md:13`, `:447`, `README.md:579`. | 1 h in-tree, plus the deposit |
| 2 | Fix the evidence rewrite (B2): make `scripts/export-public.sh:112` skip fenced code blocks, or restrict it to an explicit link syntax, and re-export. | 2 h |
| 3 | Decide the evidence-repository story (B3): publish `ergodis-evidence` and set `ERGODIS_EVIDENCE_BASE_URL` at export, or reword all nineteen references to state the evidence is not public. | 1-3 h depending on the choice |
| 4 | Rerun or retire the `OPTIMIZATION.md:365-370` table under the corrected protocol (B4), and reconcile `docs/ergodis-shape-classifier.md:165-166` with `BENCHMARKS.md:302-303`, `:439` (B5). | 2 h |
| 5 | Write `CHANGELOG.md` for 0.1.0 (B6); add a copyright notice to `LICENSE`, `authors` to `Cargo.toml`, and a real contact to `README.md:605-607` (B7). | 2 h |
| 6 | Add `CITATION.cff` and a "How to cite" section; add `SECURITY.md`; decide whether a minimal `CONTRIBUTING.md` can coexist with the public lint's process-document rule (S8). | 2 h |
| 7 | Rustdoc pass (S1): rewrite the crate-level doc in `src/lib.rs:1-4` with a module map and the README example, add `//!` to the thirteen bare modules, and document the public items of `src/composition.rs` — `CostTable`, `CompositionTable`, `CompositionTower` first. | 8-12 h |
| 8 | README surgery (S2-S4): move `README.md:380-423` into `BENCHMARKS.md`, document `hall` and `verify-hall`, add a "Demos" section pointing at `wasm/` and `examples/`, add a `docs/` index link. | 4 h |
| 9 | Add `docs/README.md` as an index and decide the fate of the four orphans (S5); resolve the `<shared-target-dir>` and `<application-ab-venv>` placeholders (S7); rewrite `docs/ergodis-shape-classifier.md:160` (S9). | 3 h |
| 10 | Triage `docs/glossary.md` (S6): split the implemented vocabulary from the 29 `planned` contracts, and move the naming policy out of the public tree or retitle the page as a naming guide. | 3 h |
| 11 | Sweep the nice-to-haves: name capitalization (N1), the `exact`-vocabulary rule (N2), `OPTIMIZATION.md:426` (N3), `BENCHMARKS.md:519` (N4), row labels (N5), `wasm/README.md:6`, `:114` (N7). | 2-3 h |
| 12 | Extend `RELEASE-CHECKLIST.md:11-13` to cover `DESIGN.md`, `CONTROL_PROTOCOL.md`, and `docs/`, and add gate items for link resolution inside the filtered tree and for cross-document number agreement (N7, B4, B5). | 1 h |

Blockers B1-B7 total roughly 10-14 hours plus whatever the paper deposit and the
evidence-repository decision cost externally. The full list lands near 35-45 hours, of
which the rustdoc pass (item 7) is the single largest and the one that most changes what
a stranger evaluating the library actually experiences.

### Library and CLI surface

Scope: the `ergodis` library API and CLI as a downstream user meets them, reviewed in the
filtered public tree (FILTERED =
`/tmp/claude-1000/-home-tavis-src-othello-rust/315af775-8ba9-4191-9fe8-4f4079bcd2be/scratchpad/filtered`).
All cargo invocations used `CARGO_TARGET_DIR=$HOME/.cache/ergodis/target/c1149-api` (or
`.../c1149-missing`) with the PATH toolchain, cargo 1.93.1. No writes to `~/src/ergodis`.

Verdict: the CLI works end to end exactly as the README describes — every one of the five
quickstart commands ran clean — but the installed-binary set and the rustdoc surface are not
release-ready.

---

## Blockers

**B1. `cargo install` ships six undocumented research binaries onto the user's PATH.**
`Cargo.toml` declares five `[[bin]]` targets (lines 53-75) but leaves `autobins` at its edition-2021
default of `true`, so every file in `src/bin/` also becomes an installable target. `cargo metadata`
on the `ergodis` package reports eleven bins:

```
bench_kernels, binary_linear_distance, css_automorphism_adapter, css_distance_native,
css_distance_random, css_distance_shard_ledger, css_isomorphism_adapter,
ergodis, ergodis-campaign, ergodis-rpc, ergodisctl
```

The README's install line (`README.md:122`) is `cargo install --path . --features parallel`. With
that feature set, `ergodis-campaign` and `ergodisctl` are gated out by `required-features =
["control-plane"]`, but the six auto-discovered bins plus `css_distance_random` are not gated at
all. I confirmed they all build in that configuration:

```
$ cargo build --features parallel --bins     # exit 0, 14.3s
$ ls $CARGO_TARGET_DIR/debug/*.d
bench_kernels binary_linear_distance css_automorphism_adapter css_distance_native
css_distance_random css_distance_shard_ledger css_isomorphism_adapter ergodis-campaign
ergodisctl ergodis ergodis-rpc
```

So the documented install puts **eight** executables in `~/.cargo/bin`, six of which appear in no
public document. The worst is `bench_kernels`, a 2553-line benchmark harness with a name generic
enough to collide with anything, which panics on `--help`:

```
$ bench_kernels --help
thread 'main' panicked at src/bin/bench_kernels.rs:1129:10:
repetitions are required
exit=101
```

`bench_kernels` with no arguments also exits 101. The five CSS/linear-distance bins do have clap
help and are coherent tools, but they are snake_case (inconsistent with the `ergodis-*` naming of
the shipped CLI) and unmentioned anywhere a user would look.

Fix: set `autobins = false` in `[package]`, then decide per binary whether it is a product
(rename to `ergodis-css-distance` etc. and document it) or research tooling (move under
`examples/`, or out of the public tree entirely). `bench_kernels` should not ship as an installed
binary under any name.

**B2. The README routes users to `cargo doc`, and `cargo doc` produces a 547-name list with almost
no prose.** `README.md:103-107` says "Generate the complete API documentation with `cargo doc
--all-features --open`". What that generates:

- `src/lib.rs` exposes 74 `pub mod`s and re-exports 547 names at the crate root.
- Crate-level doc is two sentences (`src/lib.rs:1-4`) and does not describe the compile → solve →
  certificate → verify pipeline that `DESIGN.md`/`OPTIMIZATION.md` explain. There is no `prelude`,
  no grouping, and no "start here" pointer in the rustdoc itself.
- With `RUSTDOCFLAGS="-W missing_docs" cargo doc --no-deps --all-features --workspace`:
  **4301 missing-documentation warnings** — 3720 in `ergodis`, 462 in `ergodis-runtime`, 64 in
  `ergodis-verify`, 47 in `ergodis-modules`, 9 in `ergodis-repository-native`. Breakdown for the
  main lib: 1549 struct fields, 1024 enum variants, 882 methods, 329 structs, 180 enums, 162
  associated functions, 97 constants, 39 free functions, 13 modules.
- 13 of the 74 public modules have no module-level doc at all, and they are among the most central:
  `bitset` (`src/lib.rs:23`), `composition` (:29), `confinement` (:32), `field` (:44), `incidence`
  (:52), `matrix` (:57), `orbit` (:62), `orbit_compile` (:63), `packed_ternary` (:65), `projective`
  (:69), `scheduler` (:79), `span` (:85), `witness` (:89). `composition`, `field`, `matrix`,
  `scheduler` and `span` are exactly the modules the README's own API table (README:90-101) tells
  the reader to use.
- 36 of the 74 public modules are never named by module path in any public document
  (`README.md`, `OPTIMIZATION.md`, `DESIGN.md`, `BENCHMARKS.md`, `CONTROL_PROTOCOL.md`, `docs/*.md`).

Nine broken intra-doc links also emit warnings on the ordinary `cargo doc --no-deps --all-features
--workspace` run (exit 0, 12.7s): unresolved `two_adic`, `subgroup`, `xor_sumset`, `bitmap` (all
from the `arithmetic` module doc at `src/lib.rs:15`), `alternating_deficiency`
(`src/hall.rs:471:47`), `ClaimStatus::Candidate` (`src/predicate_cover.rs:12:26`),
`Self::prepare_layer` twice (`src/scheduler_dominance.rs:306:32` and `:338:42`), and a public-item
link to the private `SPARSE_DENSITY_DIVISOR` (`src/hall.rs:70:53`).

Fixing 4301 items is not a release-gate task. The release gate should be: a real crate-level
overview that names the pipeline stages and points at the ~12 entry APIs; module-level docs for all
74 modules; and the nine broken links. Everything below that can ratchet.

---

## Should-fix

**S1. `ergodis-rpc` is an installed, user-facing binary with no help, no exit-code contract, and no
top-level documentation.** `src/bin/ergodis_rpc.rs` is 12 lines that hand stdin/stdout straight to
`ergodis::rpc::serve_jsonl`. Argument handling does not exist:

```
$ ergodis-rpc --help
(no output)
EXIT=0
```

It silently ignores its arguments and exits 0 on EOF. `ergodis-rpc` appears in no top-level
document — grepping `README.md`, `docs/`, `CONTROL_PROTOCOL.md`, `DESIGN.md`, `OPTIMIZATION.md`
returns nothing; only `python/README.md` mentions it. The `rpc` module itself has a good module doc
(`src/rpc.rs:1-5`) but the wire protocol has no public spec comparable to `CONTROL_PROTOCOL.md`.
Either give it clap with `--help`/`--version` and a README section describing the JSON-RPC framing,
or stop installing it as a bin and let the Python layer build it explicitly.

**S2. README command table is out of date with the CLI.** `ergodis --help` lists eight subcommands;
`README.md:184-191` lists six, omitting `hall` and `verify-hall`. Both work:

```
$ ergodis hall --input examples/data/hall-projective-q11.json --certificate $T/cert.bin
{"saturated": true, "cardinality": 2, "deficiency": 0, ...}          exit=0
$ ergodis verify-hall --input examples/data/hall-projective-q11.json --certificate $T/cert.bin
{"verified": true}                                                    exit=0
```

The generate-then-independently-replay-a-certificate round trip is the single best demonstration of
the project's stated value proposition, and it is missing from the command table and from the
"Start here" block.

**S3. No `--help` path from a subcommand to its input schema.** Every command takes `--input <FILE>`
JSON with no schema in `--help` and no `after_help`. `ergodis application --help` does not list the
valid `kind` tags (`ceph-xor`, `azure-lrc`, `repair-dag`, `qc-ldpc`, `vector-repair`,
`gpu-checkpoint`) even though README:506-513 tabulates them. A one-line `after_help` per subcommand
naming the matching `examples/data/*.json` file closes this; there are 13 such files for 8
subcommands.

**S4. No API-stability statement and zero `#[non_exhaustive]`.** The only stability language in the
tree is `README.md:109`: "The crate is at version 0.1.0; lower-level interfaces may still evolve."
`grep -r non_exhaustive src crates --include=*.rs` returns 0 hits against 114 public `*Error` enums
(and 180 public enums overall, with 1024 undocumented variants). Every added variant or added public
struct field is therefore a breaking change. Recommended policy line for the README and each crate
root:

> ergodis is 0.x. The CLI JSON input and output schemas, and the items re-exported from the crate
> root, are the supported surface; breaking changes to them bump the minor version and are listed in
> `CHANGELOG.md`. Everything reachable only through a module path may change in any release. Public
> error enums are `#[non_exhaustive]`; match with a wildcard arm.

Then actually mark the error enums `#[non_exhaustive]` before the first public tag, since doing it
later is itself the breaking change. There is no `CHANGELOG.md` in the tree.

**S5. `crates/modules` has no `license` and no `repository`.** `crates/modules/Cargo.toml` carries
`name`, `version = "0.0.0"`, `edition`, `rust-version`, `publish = false`, `description` — but no
`license` field, while the root, `verify`, `runtime`, `repository-native` and `wasm` all declare
`AGPL-3.0-only`. In an AGPL release every crate directory should state its license. `runtime`,
`verify` and `repository-native` additionally lack `description` and `repository`. `modules` is also
absent from `default-members` (`Cargo.toml:3`), so the routine `cargo build` / `cargo test` at the
workspace root never compiles it; only `--workspace` does.

**S6. Public docs cite `evidence/`, which the filter strips.** `BENCHMARKS.md` has 15 references to
`evidence/` paths, `README.md` 2 (e.g. `README.md:573-575` cites
`evidence/application-readme-ab*` and `evidence/application-long-{cold,warm}*`), `OPTIMIZATION.md`
1. `evidence/`, `proptest-regressions/` and `.cargo/` are all absent from FILTERED. `README.md:579`
also cites `../compositional_recovery.pdf`, a path outside the repository. A public reader cannot
resolve any of them. (This likely overlaps the docs/release reviewer; flagged here only because it
lands in the README quickstart and the performance table a first-time user reads.)

---

## Nice-to-have

**N1. `ergodisctl` has 37 subcommands, two with an empty description.** `ergodisctl --help` renders
`status` and `shutdown` with blank `about` text; every other subcommand has one. Also, 37
subcommands in one flat list is hard to scan — clap `help_heading` groups (campaign lifecycle,
plan/evolution, target profile, proposal broker) would help. Note that `ergodisctl` and
`ergodis-campaign` are gated behind `control-plane`, which the README install line does not enable,
so they are opt-in as intended. `ergodis-campaign --help` is clean.

**N2. README's sample scheduling output is stale.** `README.md:168-180` shows a JSON body without
the `unmatched_demands` and `peak_pareto_states` fields the binary actually emits.

**N3. Several modules are `pub` only to serve a bin or an A/B example.** Tracing consumers outside
`src/`:
- `root_execution` — only consumer is `src/bin/bench_kernels.rs` (the bin that should not ship).
- `allocation_surface` — only consumer is `examples/allocation_surface_probe.rs`.
- `scheduler_dominance` — only consumers are `examples/negative_control_tier.rs` and
  `examples/dominance_l2_ab.rs`; it also owns two of the nine broken doc links.
- `bitset` — no consumer in `src/bin`, `examples`, `benches`, `tests`, or `crates`, and no module
  doc.
`composition_io` is genuinely shared (`src/bin/ergodis.rs` and `tests/composition_io.rs`) and should
stay public. Demoting the four above to `pub(crate)` — after the example triage in N4 — removes four
undocumented modules from the public surface for free.

**N4. `examples/` is 40 files, of which one is a teaching example.** Only `library_composition.rs`
(18 lines) is referenced from `README.md:86`. Four are cited in `BENCHMARKS.md`
(`gf27_balanced_dfs`, `gf27_balanced_probe`, `gf27_prefix_probe`, `negative_control_l2_probe`,
`negative_control_w3_probe`, `repair_dag_contended`); about ten are driven by `scripts/*.sh` or
`python/*.py` A/B harnesses; the rest are named nowhere. Several are not examples in any normal
sense: `fork_join_cost_regular.rs` is 1042 lines, `resource_constrained_shortest_path.rs` 955,
`observational_hierarchy_driver.rs` 771, `negative_control_tier.rs` 549. Recommendation:

| action | files |
| :----- | :---- |
| keep as teaching examples | `library_composition`, `resource_interface`, `bounded_subset_sum_kernel`, `vlsat_clique_certificate`, `vlsat_coloring_certificate`, `mata_official_dfa` |
| promote to teaching examples with a doc-comment header and a README mention | `resource_constrained_shortest_path`, `fork_join_cost_regular` (both are real, self-contained modelling walkthroughs once documented) |
| move to `benches/` or a `research/` directory excluded from the public tree | every `*_ab.rs` and `*_probe.rs` (`arithmetic_lift_ab`, `dominance_l2_ab`, `envelope6_ab`, `frozen_pareto_ab`, `gl_consuming_ab`, `gl_rref_ab`, `selector_ab`, `allocation_surface_probe`, `commutant_field_probe`, `gf27_balanced_probe`, `gf27_prefix_probe`, `negative_control_l2_probe`, `negative_control_w3_probe`, `binary_margin_lift_counters`) |
| hold — cited by `BENCHMARKS.md` or a shipped script, so moving them breaks a replay command | `gf27_balanced_dfs`, `negative_control_tier`, `repair_dag_contended`, `observational_hierarchy_driver`, `observational_sota_driver`, `layered_dag_driver`, `mata_weighted_trace`, `scheduler_l2_layer_census`, `alignment_*`, `azure_counted_subsumption`, `cnf_theorem_or_kissat`, `legendre333_compression` |

Every example is compiled by `cargo clippy --all-targets` and `cargo test --all-targets`, so this is
also build-time cost on every contributor's machine.

**N5. `python/` is correctly positioned but not installable as shipped.** `python/README.md:3-6`
states the role plainly — reference algorithms, differential-oracle fixtures, benchmark controls,
evidence generators, secondary to Rust — and that framing is right for the public tree. Problems:
- `python/pyproject.toml` sets `requires-python = ">=3.14"`, which excludes essentially every
  current user; nothing in `python/ergodis/` obviously needs 3.14 beyond PEP 695 generics
  (`def call[T]` in `_rpc.py:89`, which is 3.12).
- The flit package is only `python/ergodis/`; the ~60 top-level research drivers
  (`run_*.py`, `check_*.py`, `fetch_*.py`, Gurobi/Z3/kissat/SATComp harnesses) and
  `recovery_algorithms/` sit beside it and are not part of the distribution, so `pip install
  ./python` gives a client library and nothing else. That is defensible, but it should be stated.
- `python/ergodis/_rpc.py:68-77` resolves the worker binary from `ERGODIS_RPC_BIN`, else
  `Path(__file__).parents[2]/"target"/"release"/"ergodis-rpc"`. There is no `shutil.which(
  "ergodis-rpc")` fallback, so an installed package outside the source checkout fails with a
  confusing `FileNotFoundError`.
- `python/recovery_algorithms/__pycache__/` (13 `*.cpython-313.pyc` files) is present in FILTERED,
  and `.gitignore` contains only `/target/`. Byte-compiled artifacts should not reach the public
  repository.

**N6. CI checks nothing about the code.** `.github/workflows/public-lint.yml` is the only workflow
and runs two greps (no internal identifier tokens, no process documents). There is no
build/test/clippy/doc job on the public branch, so a downstream contributor gets no signal and the
repository has no green badge. A minimal `cargo build --all-features --workspace` +
`cargo test --all-features` + `cargo doc --no-deps` job would close this without exposing the
private validation gate.

**N7. Nothing is publishable to crates.io, by design.** All five workspace packages plus `wasm` set
`publish = false`, and every internal dependency is a path dependency, so the README's git-dependency
instruction (`README.md:53-56`) is the only integration route. That is a legitimate choice; it just
means "add ergodis to your Cargo.toml" costs a downstream user a git revision pin and no
`cargo add ergodis`. If publishing is ever wanted: path deps need versions, `crates/modules` needs a
license, and the root `[package] exclude` (`Cargo.toml:19`) would want `python/` and `wasm/` added —
`exclude = ["wasm"]` on `[workspace]` (`Cargo.toml:4`) only removes it from the workspace, not from a
package tarball. `wasm/` is a separate workspace with its own `Cargo.lock`, so it is never touched by
the root `cargo build --workspace`, `clippy --all-targets`, or the doc build.

**N8. `rust-version = "1.87"` is declared consistently** across the root and all four member crates
plus `wasm/`, and `src/lib.rs:6-8` documents one MSRV-driven lint allowance. Not verified against an
actual 1.87 toolchain (I built with 1.93.1); a `cargo +1.87 check` in CI would make the claim real.

**N9. `[profile.release]` sets `panic = "abort"` (`Cargo.toml:127`).** Cargo does not propagate
profiles to dependencies, so a library consumer is unaffected; but the shipped `ergodis` CLI aborts
on any internal panic rather than unwinding. Error paths I exercised are typed and clean, so this is
informational.

---

## What works

Every README quickstart command ran successfully against the bundled inputs, from the filtered tree,
with no additional setup:

```
$ ergodis --help                                                              exit=0, 8 subcommands
$ ergodis -V                                                                  ergodis 0.1.0
$ ergodis schedule --input examples/data/schedule.json                        exit=0
$ ergodis transfer --input examples/data/f4-scalar-separation.json            exit=0, 5878 bytes
$ ergodis transfer-subspace --input examples/data/transfer-subspace.json      exit=0, 12694 bytes
$ ergodis transfer-tower --input examples/data/transfer-tower.json            exit=0, 3394 bytes
$ ergodis application --input examples/data/ceph-repair.json                  exit=0, 146 bytes
$ echo '{"garbage":1}' | ergodis schedule --input -                           exit=1
    Error: invalid JSON input
    Caused by: unknown field `garbage`, expected one of `capacities`, `families`, `positive_grading`
$ ergodis schedule --input /nonexistent.json                                  exit=1
    Error: failed to read input file /nonexistent.json
    Caused by: No such file or directory (os error 2)
```

Subcommand `--help` output is uniform and well-written; `--input -` for stdin is consistent across
commands; `--parallel`/`--threads` appear only on the commands that support them; failures go to
stderr with a typed cause chain and exit 1. A first-time user can solve an example end to end from
README text alone. All four library crates have crate-level docs (`crates/verify/src/lib.rs:1-5`,
`crates/runtime/src/lib.rs:1-4`, `crates/repository-native/src/lib.rs:1-3`,
`crates/modules/src/lib.rs:1-2`), and each states its trust boundary crisply — `verify` declares it
has no dependency on the optimization kernels, `repository-native` enumerates what it does not
claim, `modules` states "no stability promise". Feature defaults are right for a library:
`default = []`, with `parallel`, `large-css` and `control-plane` all opt-in, and the feature-gated
re-exports in `src/lib.rs:35-36, 95-96, 179-182` are correctly `cfg`-guarded.

---

## Remediation list

| # | item | effort |
| :-- | :--- | :----- |
| 1 | `autobins = false`; move or rename the six auto-discovered research bins; delete `bench_kernels` from the shipped set (B1) | 2h |
| 2 | Crate-level overview naming the compile → solve → certificate → verify stages and the ~12 entry APIs; module docs for the 13 bare modules (B2) | 6h |
| 3 | Fix the 9 broken intra-doc links (B2) | 1h |
| 4 | Ratchet: `#![warn(missing_docs)]` on `ergodis-verify` (64 warnings) and `ergodis-repository-native` (9) now, with the main lib left as a tracked backlog (B2) | 2h |
| 5 | clap `--help`/`--version` for `ergodis-rpc` plus a README section on the JSON-RPC framing, or stop installing it (S1) | 2h |
| 6 | Add `hall`/`verify-hall` to the README command table and the certificate round trip to "Start here" (S2) | 0.5h |
| 7 | `after_help` on each subcommand naming its `examples/data/*.json` schema example; list the `application` `kind` tags (S3) | 1h |
| 8 | Stability section + `#[non_exhaustive]` on the 114 public error enums + `CHANGELOG.md` (S4) | 4h |
| 9 | `license`/`repository` on `crates/modules`; `description`/`repository` on `runtime`, `verify`, `repository-native` (S5) | 0.25h |
| 10 | Resolve or remove the 18 `evidence/` references and the `../compositional_recovery.pdf` link (S6) | 1h, overlaps docs review |
| 11 | Fill the two empty `ergodisctl` subcommand descriptions; add clap `help_heading` groups (N1) | 1h |
| 12 | Examples triage per the N4 table; demote `root_execution`, `allocation_surface`, `scheduler_dominance`, `bitset` to `pub(crate)` afterwards (N3, N4) | 4h |
| 13 | Python: `shutil.which` fallback in `_rpc.py`, lower `requires-python`, add `__pycache__/` to `.gitignore` and strip the committed `.pyc` files, state what the package does and does not include (N5) | 1.5h |
| 14 | CI job: `cargo build --all-features --workspace`, `cargo test --all-features`, `cargo doc --no-deps`, `cargo +1.87 check` (N6, N8) | 2h |

### Demos

Scope: browser/WASM demos, runnable examples, hosted-demo readiness. Reviewed the filtered
public tree (FILTERED =
`/tmp/claude-1000/-home-tavis-src-othello-rust/315af775-8ba9-4191-9fe8-4f4079bcd2be/scratchpad/filtered`),
with the private sibling `~/src/ergodis-private` read only for the private-demo inventory.

**Headline: the public demo is in far better shape than its discoverability suggests.** The
browser demo builds, runs and passes its own headless-Chromium gate from FILTERED alone, with no
private dependency, no network dependency and no `SharedArrayBuffer`. It is one README paragraph
and one CI job away from being a live GitHub Pages showcase. The blockers are all packaging and
signposting, not engineering.

#### Inventory

| Demo | Location | Public/Private | Runnable from FILTERED | What it shows |
|---|---|---|---|---|
| First-visit introduction (`index.html`)     | `wasm/www/index.html`, `introduction.js`, `learning-example.js`  | public  | yes (verified) | Switch/lamp problem, 16 settings; real `CampaignSession` WASM returns exact minimum + the choices achieving it |
| Guided campaign (`campaign.html`)           | `wasm/www/campaign.html`, `campaign.js`                          | public  | yes (verified) | Two proposed search restrictions; the checker admits one, refutes the other and renders the actual lost setting |
| Offline run-bundle inspector (`bundle.html`)| `wasm/www/bundle.html`, `bundle.js`, `example.bundle`            | public  | yes (verified) | One-click example run, evidence check, IndexedDB save/reopen, UUIDv7 child-bundle fork |
| Composition API playground                  | inside `index.html` (`<details>`), `worker.js`, `main.js`        | public  | yes            | Raw composition-request JSON in/out through the original Worker |
| `AllocationKernel` capacity kernel           | `wasm/src/allocation.rs`, `www/allocation-client.js`, `allocation-worker.js` | public | kernel yes, **no page** | Allocation-surface minimum + per-capacity query; reachable only from `wasm/scripts/allocation-client.test.mjs` |
| Module host / loader plumbing               | `www/module-host.js`, `module-worker.js`, `execution-loop.js`, `compiled-module.js` | public | tests only, **no page** | Public half of the private module-loading ABI; no public page consumes it |
| `library_composition` native example        | `examples/library_composition.rs`                                 | public  | yes (53 s cold) | 18-line library quickstart mirrored in `README.md:62-86` |
| 38 other native examples                    | `examples/*.rs`                                                   | public  | build yes, meaning no | Research A/B drivers and probes; only `gf27_balanced_dfs` is referenced (in `BENCHMARKS.md:1249`) |
| Campaign console (operator workspace)       | `~/src/ergodis-private/analysis/campaign-console/`                | private | no | Lineage/Archive/Space/Cascade/Replay over a real order-2092 Hadamard q2 corpus; needs the native daemon, `ergodisctl --features control-plane` and private research data |
| Application workspace: QEC + LRC recovery   | `~/src/ergodis-private/analysis/campaign-console/mockups/`        | private | no | Stim d5/r5 memory-Z decoding and Azure LRC(12,2,2) capacity design with a 2-D capacity map; needs private WASM providers and hash-named module payloads |
| Evolve / live-fit / code-distance mockups   | `.../mockups/evolve.html`, `live-fit.html`, `code-distance.html`  | private | no | Presentation mockups over private campaign data |
| Race/scheduling UIs (ports 8767/8769/8770/8772) | `.../mockups/` + `analysis/module-loading/`                   | private | no | Cross-provider race timing, scheduling profiles, FT10 view; private module packages |

#### Verification performed

All from FILTERED, `CARGO_TARGET_DIR` under `~/.cache/ergodis/target/`:

1. `wasm-pack build wasm --target web --release --out-dir www/pkg` (the exact command at
   `wasm/README.md:11`) — **exit 0, 76 s**. Output `ergodis_wasm_bg.wasm` is 1,360,621 bytes raw,
   **312,036 bytes gzipped**, plus 25 KB of JS glue.
2. `node wasm/scripts/browser-smoke.mjs` under `nix shell nixpkgs#nodejs nixpkgs#chromium` —
   **exit 0, 8.5 s**: `browser-smoke: passed (composition, reduction/runtime corpora, campaign
   UI/Worker checkpoints, offline bundle inspection)` plus `repository-smoke: prepare/recover passed`.
3. `cargo test --manifest-path wasm/Cargo.toml` — exit 0. `python3 wasm/scripts/check-python-parity.py`
   — exit 0, `8 exact cost/witness/work cases`.
4. Served `wasm/www` on a local static server and screenshotted `index.html` in headless Chromium:
   the page renders correctly (dark theme, lamp board, controller panels, working CTA). Screenshot at
   `.../scratchpad/shots/index.png`.
5. `cargo run --release --example library_composition` from a cold target dir — exit 0 in **53 s**,
   prints `cost=1 local_labels=[...]`.

Not verified: interactive click-through by a human (the smoke driver asserts the semantics instead),
and the private demos (not run; inventory taken from their READMEs).

Note for other reviewers: my build left an untracked, `.gitignore`d `wasm/www/pkg/` in FILTERED
(`wasm/.gitignore:3`). It is a build artifact, not shipped content.

#### Findings

**Blocker 1 — the README never mentions the browser demo.** `rg -c -i 'wasm' README.md` returns no
matches across all 607 lines. A visitor to the GitHub landing page has no way to learn that an
interactive WASM demo exists; it is reachable only by noticing the `wasm/` directory in the file
listing. This is the single highest-leverage defect in the whole demos area: the best asset in the
repository is invisible.

**Blocker 2 — no hosted demo, and no CI that builds one.** The only workflow is
`.github/workflows/public-lint.yml`, which greps for leaked internal identifiers and process
documents (lines 22-53). Nothing builds the crate, runs the tests, builds the WASM package, or
deploys to Pages. Consequence beyond the missing hosted demo: because `Cargo.toml:4` sets
`exclude = ["wasm"]`, the wasm crate is outside the workspace, so a root `cargo test` never touches
it — the demo can break without anything noticing.

**Should-fix 1 — no `docs/` page is linked from anywhere a visitor will look.** The only
`docs/`-targeted links in the top-level documents are the three images: `README.md:43`
(`pipeline.svg`), `BENCHMARKS.md:75` and `BENCHMARKS.md:1080`. All 19 `docs/*.md` files, including the
demo walkthrough `docs/browser-control.md`, are orphaned. (The three SVGs are all referenced, so
item 5 of the brief is clean — but none of them illustrates the demo.)

**Should-fix 2 — "serve `wasm/www` over HTTP" is not a command.** `wasm/README.md:14` and
`docs/browser-control.md:9` both tell the reader to serve the directory without saying how. There is
no Makefile, justfile or serve script anywhere in the public tree (`find . -name Makefile` is empty),
while the private repo has `analysis/campaign-console/Makefile` and `serve.py`. A one-line
`python3 -m http.server` next to the build command removes the last step where a stranger can stall.

**Should-fix 3 — `examples/` is 39 files of which 2 are documented and 1 is a demo.** Only
`library_composition` (README.md:86) and `gf27_balanced_dfs` (BENCHMARKS.md:1249) appear in public
docs. The other 37 are research drivers — `negative_control_l2_probe`, `gf27_prefix_probe`,
`azure_counted_subsumption`, `alignment_*` — configured through undocumented `ERGODIS_*` environment
variables (`examples/alignment_attachment.rs:7-88` reads eight of them; `examples/negative_control_tier.rs:343,463`
two more). `examples/cnf_theorem_or_kissat.rs:54` shells out to an external `kissat` binary that is
not listed as an optional dependency anywhere. A stranger opening `examples/` cannot tell which file
is the front door.

**Should-fix 4 — `library_composition` prints raw `Debug` output.** It emits
`local_labels=[Matrix { data: [0], rows: 1, cols: 1, _pad: 0, field: FieldPresentation(4995133302714204160) }, ...]`.
The flagship two-minute demo's one line of output exposes a padding field and an opaque 64-bit field
encoding. A `Display` impl, or just printing the entries, makes the first impression match the
quality of the browser demo.

**Nice-to-have 1 — `AllocationKernel` ships with no page.** `wasm/src/allocation.rs` exports a
domain-neutral allocation-surface kernel (`independentMinimumJson`, `queryJson(capacities)`,
`buildSurface`), `www/allocation-client.js` wraps it, and `docs/allocation-specializations.md`
documents it — but the only consumer in the public tree is
`wasm/scripts/allocation-client.test.mjs`. Same for `module-host.js`/`module-worker.js`, whose only
referent is `wasm/scripts/module-worker-transfer.test.mjs`. These read as dead code unless a page or
a README sentence explains that they are the public half of a loader the private workspace consumes.

**Nice-to-have 2 — no screenshot or GIF of the demo anywhere.** The three shipped SVGs are a
pipeline diagram and two benchmark charts. Nothing in the public tree shows what the demo looks like,
which matters because the README currently has to sell an optimizer with no picture of it working.

**Nice-to-have 3 — stale ignore entry.** `wasm/.gitignore:2` ignores `/www/LICENSE`, but nothing in
either repository creates that file. Under AGPL-3.0, serving the JS/WASM bundle is a distribution,
so a `LICENSE` copy (or a source link in the page footer) alongside the served assets is the
conservative call; the ignore entry suggests that was once the intent.

#### Hosted demo on GitHub Pages: what it takes

The public demo is unusually well suited to static hosting, and nothing blocks it technically:

- **No cross-origin isolation needed.** `rg 'SharedArrayBuffer|crossOriginIsolated'` over `wasm/www`
  and `wasm/scripts` returns nothing. The pages use dedicated module Workers only, so **no COOP/COEP
  headers are required** — which matters because GitHub Pages cannot set them. The public wasm crate
  builds without `parallel`/`control-plane`; threading stays native-only.
- **No absolute paths and no external requests.** `rg 'href="/|src="/|from "/|127\.0\.0\.1|localhost'`
  and `rg 'https?://'` over `wasm/www/*.{html,js,css}` both return nothing. Everything resolves through
  `new URL('./x', import.meta.url)`, so the site works unchanged under a `/ergodis/` project subpath.
- **Size is a non-issue**: 1.6 MB for `www` including the built package; 312 KB gzipped for the wasm
  binary, which Pages serves compressed.
- **CI shape**: `nix shell nixpkgs#{cargo,rustc,wasm-pack,lld} --command env RUSTFLAGS="-C linker=wasm-ld"
  wasm-pack build wasm --target web --release --out-dir www/pkg`, then upload `wasm/www` via
  `actions/upload-pages-artifact` + `actions/deploy-pages`. One caveat observed in my run: wasm-pack
  logs `Installing wasm-bindgen...`, i.e. it downloads a matching `wasm-bindgen-cli` at build time.
  Pin it from nixpkgs (`nixpkgs#wasm-bindgen-cli`) or cache it so the job is not a silent network
  dependency. Gate the deploy on `node wasm/scripts/browser-smoke.mjs`, which already runs headless
  Chromium in 8.5 s and asserts exact costs and witness counts.
- **No `.nojekyll` needed** (no underscore-prefixed paths), though adding one is free insurance.

**Best private demo to promote, and what extraction costs.** The Azure LRC(12,2,2) recovery/capacity
demo from `~/src/ergodis-private/analysis/campaign-console/mockups/` is the right showcase
candidate, for three reasons: it matches the public README's storage-recovery framing, the public
core already ships the native side (`ergodis application --input examples/data/azure-repair-batch.json`,
`ceph-repair.json`, `vector-repair.json` at README.md:515-522), and the generic kernel is already
compiled into the public WASM package as `AllocationKernel`. What must stay behind: the Stim-derived
QEC demo (domain-specific research fixtures and a private decoder provider), the Hadamard corpus and
lineage views (research data), the module-payload packaging, and the private capacity-upgrade readout
described in `mockups/README.md:118-129`. What would need writing: one static page plus a view over
the existing `allocation-client.js`, driven by a checked-in synthetic capacity input — the same
pattern `bundle.html` already uses with `example.bundle`. That is a new presentation layer over
already-public exports, not an extraction of private code.

The campaign console itself should not be promoted: it requires a running native daemon, the
control-plane `ergodisctl`, and a preserved research corpus, none of which a public visitor has.

#### Remediation, with rough effort

| # | Action | Effort |
|---|---|---|
| 1 | Add a "Try it in your browser" section to `README.md` with the demo link, a screenshot, and the build + serve commands | 1 h |
| 2 | Add a serve one-liner to `wasm/README.md:14` and `docs/browser-control.md:9`, plus a top-level Makefile with `wasm`, `serve`, `smoke` targets | 1 h |
| 3 | GitHub Pages workflow: wasm-pack build with a pinned `wasm-bindgen-cli`, run `browser-smoke.mjs`, deploy `wasm/www` | 3-4 h |
| 4 | Add a documentation index to `README.md` linking the 19 `docs/*.md` pages, `browser-control.md` first | 1 h |
| 5 | Add `examples/README.md` separating the one quickstart from the research drivers; document the `ERGODIS_*` variables of any example kept as public, and the optional `kissat` dependency | 2-3 h |
| 6 | Give `library_composition` a `//!` header and human-readable output | 0.5 h |
| 7 | Capture desktop + mobile screenshots of all three pages into `docs/` and reference them | 1 h |
| 8 | Build CI (fmt, clippy, `cargo test`, and a `cargo test --manifest-path wasm/Cargo.toml` that the workspace exclusion currently skips) | 2 h |
| 9 | Optional showcase: a public capacity/allocation demo page over the existing `AllocationKernel` and a checked-in synthetic input | 1-2 days |
| 10 | Resolve `wasm/.gitignore:2` — either ship a `www/LICENSE` copy and a source link in the page footer, or drop the entry | 0.5 h |

Items 1-3 are what stand between the current state and a link a stranger can click. Everything else
is polish on an asset that already works.

### Build, CI, licensing and hygiene

Toolchain: nixpkgs `cargo 1.95.0` / `rustc 1.95.0` / `clippy 0.1.95` / `rustfmt 1.9.0`
(`~/src/ergodis` has no flake, `shell.nix`, or `rust-toolchain*`). All cargo runs used
`CARGO_TARGET_DIR=$HOME/.cache/ergodis/target/c1149-build`, cwd = FILTERED.

**FILTERED is not byte-identical to a real export.** Two deviations, both verified:

1. It contains 7 untracked files that `git archive` would never ship
   (`wasm/www/pkg/{ergodis_wasm_bg.wasm,ergodis_wasm_bg.wasm.d.ts,ergodis_wasm.d.ts,ergodis_wasm.js,.gitignore,package.json,README.md}`
   — local `wasm-pack` output). Everything else (485 files) equals tracked-minus-`.publicignore`.
2. It has *not* had the markdown `evidence/` → URL rewrite of `scripts/export-public.sh:110-113`
   applied, so the `evidence/` strings I quote below are still literal here.

#### 1–5. Command results

| # | Command (in FILTERED)                                                   | Outcome | Duration | First error |
|---|-------------------------------------------------------------------------|---------|----------|-------------|
| 1 | `cargo fmt --check`                                                     | pass    | 1.0 s    | — |
| 2 | `cargo build --release`                                                 | pass    | 1 m 27 s | — (0 warnings; cold dep compile) |
| 3 | `cargo test --all-features`                                             | pass    | 1 m 55 s | — (886 passed, 0 failed, 1 ignored, 50 suites; 0 warnings) |
| 4 | `cargo clippy --all-targets --all-features -- -D warnings`              | pass    | 20.8 s   | — (warm target dir) |
| 5a | `cargo check --all-targets --no-default-features`                      | pass    | 9.2 s    | — |
| 5b | `cargo check --all-targets --no-default-features --features parallel`  | pass    | 9.2 s    | — |
| 5c | `cargo check --all-targets --no-default-features --features large-css` | pass    | 8.9 s    | — |
| 5d | `cargo check --all-targets --no-default-features --features control-plane` | pass | 11.3 s | — |
| 5e | `cargo check -p ergodis-modules --all-targets` (non-default member)     | pass    | 0.4 s    | — |
| 5f | `cargo check --manifest-path wasm/Cargo.toml --all-targets` (host target) | pass  | 14.4 s   | — |
| — | `cargo check --locked --all-features --all-targets`; same for `wasm/`   | pass    | 12.1 s / 0.3 s | — (both lockfiles current) |
| — | `cargo doc --no-deps --all-features`                                    | pass with 9 warnings | 5.4 s | — |
| — | `RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features`            | **fail** | 9.8 s   | `error: unresolved link to \`two_adic\`` (9 errors total) |
| — | `scripts/public-lint.sh FILTERED`                                       | 3 findings | 1 s   | see item 11 + N5 |

`~/src/ergodis/staging/validate-release.sh` runs exactly four steps: (1) `public-lint.sh HEAD`,
(2) existence of `scripts/`, `--example`, `--bench` replay targets named in `BENCHMARKS.md`,
(3) `cargo build --release`, (4) `cargo test --all-features`. It does **not** run `cargo fmt`,
clippy, the Python fixture check, the dependency-boundary guards, or any `wasm/` test.
I ran its steps 1, 3, 4 above.

#### 6. Python oracle parity gate

Public entry point exists and is cheap: **`python/generate_fixtures.py --check`**, documented at
`README.md:591`. Run in FILTERED under `nix shell nixpkgs#python3`: **exit 0 in 1.4 s**, silent on
success. It regenerates the oracle payload from `python/recovery_algorithms/*` and byte-compares it
to `tests/fixtures/python_span_cases.json`, which `tests/python_parity.rs:906` `include_str!`s — so
`cargo test` consumes the same bytes the oracle just reproduced. Stdlib-only, no `uv`/venv needed.

Second public parity entry point: `wasm/scripts/check-python-parity.py` — exit 0,
`python-parity: passed (8 exact cost/witness/work cases)`.

Both dependency-boundary guards also run clean in FILTERED:
`scripts/check-verifier-dependencies.py` (exit 0, "24 packages in normal/build closure") and
`scripts/check-runtime-dependencies.py` (exit 0).

The *other* public Python gate is broken in the public tree — see Blocker B2:
`python/generate_evidence.py --check` exits 1 with `evidence/results.json is stale` because
`evidence/` is removed by `.publicignore`.

#### 7. Dependency license audit

`cargo license --all-features` (nixpkgs `cargo-license` 0.7.0), full normal+dev closure:

| License family | Count | Notes |
|---------------------------------------------|----|-----------------------------------------------|
| `Apache-2.0 OR MIT`                         | 86 | clap, serde, rayon, criterion, proptest, libc, … |
| `MIT`                                       | 5  | crunchy, generic-array, oorandom, strsim, zmij |
| `MIT OR Unlicense`                          | 5  | aho-corasick, memchr, same-file, walkdir, winapi-util |
| `Apache-2.0 OR Apache-2.0 WITH LLVM-exception OR MIT` | 4 | linux-raw-sys, rustix, wasip2, wit-bindgen |
| `Apache-2.0`                                | 3  | ciborium, ciborium-io, ciborium-ll |
| `Apache-2.0 OR BSD-2-Clause OR MIT`         | 2  | zerocopy, zerocopy-derive |
| `Apache-2.0 OR LGPL-2.1-or-later OR MIT`    | 2  | r-efi (×2) — take the Apache/MIT option |
| `Apache-2.0 OR MIT OR Zlib`                 | 1  | bytemuck |
| `Apache-2.0 OR Apache-2.0 WITH LLVM-exception OR CC0-1.0` | 1 | blake3 |
| `Apache-2.0 OR CC0-1.0 OR MIT-0`            | 1  | constant_time_eq |
| `(Apache-2.0 OR MIT) AND Unicode-3.0`       | 1  | unicode-ident |
| `AGPL-3.0`                                  | 2  | `ergodis`, `ergodis-verify` (the workspace itself) |

**Nothing is incompatible with AGPL-3.0-only distribution.** Every third-party crate is permissive
(MIT/Apache-2.0/BSD-2/Zlib/CC0/Unlicense/MIT-0/Unicode-3.0), all one-way compatible into AGPLv3.
`r-efi`'s triple licence includes LGPL-2.1-or-later but the Apache/MIT options are selectable, so
no copyleft mixing. Attribution: source distribution is covered by `LICENSE` + the lockfile, but
**binary** releases of `ergodis`/`ergodis-rpc` need a third-party notices file (MIT and Apache-2.0
both require carrying their notices). Neither `deny.toml` nor `about.toml` exists in FILTERED or in
`~/src/ergodis`.

#### 8. Licensing hygiene

- `LICENSE`: full AGPL-3.0 text, 661 lines, intact.
- SPDX headers: **zero** of 145 `.rs` files under `src/`, `crates/`, `wasm/` carry
  `SPDX-License-Identifier`.
- `license` field: present and `AGPL-3.0-only` in the root `Cargo.toml:14`,
  `crates/verify`, `crates/runtime`, `crates/repository-native`, `wasm/Cargo.toml:8`,
  and `python/pyproject.toml`. **Missing in `crates/modules/Cargo.toml`** (it also has no
  `repository` or `license`; version `0.0.0`).
- Vendored / adapted code: none found. The one third-party lineage is declared correctly —
  `src/bp_osd.rs:8-11` cites Roffe et al. (arXiv:2005.07016) and states it is a Rust
  reimplementation whose behaviour was checked against the MIT-licensed `quantumgizmos/ldpc`.
  `benches/boa-kernel-timing.patch` is a 6-line diff against a third-party `src/main.rs`
  (consumed by `scripts/observational-boa-ab.sh:13`) with no upstream name/version/licence header.
- Grep for `Copyright|MIT|BSD-|derived from|adapted from|ported from` over `src/`, `crates/`,
  `wasm/src/`, `python/` returns no copyright notices at all — only the private-kernel provenance
  comments flagged as S1.

#### 9. CI

FILTERED `.github/` contains exactly one file: `workflows/public-lint.yml` (as intended).
It re-checks two rules on `push` to `main`, `pull_request`, and `workflow_dispatch`: no
`\bC[0-9]{2,4}\b` tokens, and no process documents.

Where the public/private line should sit: the private rule *lists* (private path fragments,
the size cap, `.public-lint-allow`) are process and must stay in `scripts/public-lint.sh`, which
is not exported. A **build** CI is not process — it is the product's claim that a stranger's clone
compiles, and it is the only mechanical evidence a downstream user has that the release checklist's
"builds as a stranger sees it" item was honoured. Publishing `cargo fmt/clippy/test/doc` jobs leaks
nothing that `README.md:586-598` does not already print verbatim. What a public CI should add:

- `build+test` on `ubuntu-latest` (and ideally `macos-latest`) — `cargo build --release`,
  `cargo test --all-features --locked`.
- `fmt` + `clippy --all-targets --all-features -- -D warnings`.
- Feature matrix: `--no-default-features` and each of `parallel`, `large-css`, `control-plane`.
- MSRV job pinned to 1.87 with `--locked` (currently the declared MSRV is never exercised).
- `cargo doc --no-deps --all-features` with `RUSTDOCFLAGS=-Dwarnings` (fails today, S4).
- `wasm-pack build wasm --target web --release` plus `cargo test --manifest-path wasm/Cargo.toml`.
- The Python gates: `python/generate_fixtures.py --check` and `wasm/scripts/check-python-parity.py`
  (stdlib-only; a plain `actions/setup-python` suffices).
- Optional: `cargo deny check licenses` once `deny.toml` exists.

#### 10. Repository hygiene in FILTERED

- Tree: 9.4 MB, 492 files — 8.0 MB / 485 files once the leaked `wasm/www/pkg` build output is
  excluded. Largest *tracked* files: `src/observational.rs` 352,353 B,
  `tests/fixtures/python_span_cases.json` 305,713 B, `src/css_distance.rs` 261,511 B — all
  comfortably under the 1 MiB `PUBLIC_LINT_MAX_BYTES` cap (3× headroom).
- `.gitignore` is a single line, `/target/`. It does not cover `__pycache__/`, `*.pyc`, `.venv`,
  or `wasm/target/` (a second, separate workspace root). See B1.
- `Cargo.lock` committed at the root and in `wasm/` — correct for a binary-shipping repo; both
  verified current by `cargo check --locked`.
- `python/__pycache__` risk is not hypothetical: 12 `.pyc` files are **tracked** and ship
  (`python/recovery_algorithms/__pycache__/costs.cpython-313.pyc`, 83,767 B, largest). Two further
  `__pycache__` dirs currently sit untracked-and-unignored in `~/src/ergodis` working tree.
- `proptest-regressions/` dropped by the filter: **no test fails** as a result (886/886 pass).
  The cost is silent — known-failing seeds are no longer replayed downstream. `SHA256SUMS` still
  references `proptest-regressions/scheduler.txt`, which does not exist in the export.
- `tests/data/` (19 KB, untracked WIP in the private tree) correctly does **not** ship.
- Stray artifacts: `benches/disable_composition_reduction.patch` (449 B) and
  `benches/boa-kernel-timing.patch` (882 B) look stray but are referenced by
  `scripts/observational-composition-ab.sh` and `scripts/observational-boa-ab.sh` — keep them.
- No `rust-toolchain.toml`, no flake, no `rustfmt.toml`/`clippy.toml`, no `CHANGELOG.md`,
  no `CONTRIBUTING.md`/`SECURITY.md`.
- `edition = "2021"` in all six manifests, `rust-version = "1.87"` in all six.
- `publish = false` everywhere and path deps carry no `version`, so crates.io publication is
  impossible today; `README.md:52-56` correctly documents a git dependency instead, so this is
  consistent rather than broken.

#### 11. The two `private-path` lint findings

Verified exactly as described — `scripts/public-lint.sh FILTERED` reports:

```
scripts/check-verifier-dependencies.py:45: private-path:  "ergodis", "ergodis-runtime", "ergodis-host-native", "ergodis-private",
scripts/check-runtime-dependencies.py:42: private-path:   forbidden = {"tokio", "wasm-bindgen", "web-sys", "ergodis-private", …
```

Both occurrences are inside a *deny*-set: the guards fail if such a package appears in the
dependency closure. Rewording by deleting the literal would silently disable exactly the invariant
that keeps a private-tier crate out of the public verifier/runtime boundary, so that is the wrong
fix as stated.

**Recommendation — two allowlist entries, with a reason comment, matching the existing precedent.**
`.public-lint-allow` already carries `python/check_bb_native.py:ergodis-private` under a comment
explaining why. The private-path rule only honours the `PATH:MARKER` form
(`scripts/public-lint.sh:120-128`), so an entry cannot widen the rule beyond that one file. Add:

```
# The verifier and runtime boundary guards name the private-tier crate in a
# forbidden-dependency set. The string is a negative assertion — the check fails
# if such a package is reachable — not a path into a private tree.
scripts/check-verifier-dependencies.py:ergodis-private
scripts/check-runtime-dependencies.py:ergodis-private
```

**Follow-up worth doing separately (not required now):** invert both guards from a deny-list of
named packages to an allow-list of approved package names, rejecting any reachable
`ergodis-*` crate outside the approved set. That is strictly stronger (it catches a future private
crate under a different name), and it removes the literal, making both allowlist entries
unnecessary. Do not do the inversion as a lint workaround alone — do it because the guard is
better, and keep the allowlist entries until it lands.

---

### Findings

#### Blocker

**B1. Byte-compiled Python ships in the public release; `.gitignore` cannot prevent it.**
`git ls-files -- 'python/**/__pycache__/*'` → 12 tracked `.pyc` files, present in FILTERED
(`python/recovery_algorithms/__pycache__/costs.cpython-313.pyc`, 83,767 B). `.gitignore` contains
only `/target/`. Consequences: build artifacts in a source release, a stale-`.pyc` hazard for the
oracle that the parity gate depends on, and `git status` noise for every cloner (two more
untracked `__pycache__` dirs already sit in the private working tree). Untrack the 12 files and
extend `.gitignore` with `__pycache__/`, `*.py[cod]`, `.venv/`, `wasm/target/`, `/target/`.

**B2. `SHA256SUMS` ships broken and cannot be regenerated by a public user.**
125 entries; 40 name `evidence/*` or `proptest-regressions/*` paths that `.publicignore` removes,
so `sha256sum -c SHA256SUMS` reports them missing. Of the 85 whose files do exist, the hashes are
stale even against committed `HEAD`: the manifest says `2cc1900cdfcd3b40…` for `Cargo.toml` while
`git show HEAD:Cargo.toml | sha256sum` is `03d37d99b15b094b…`; `src/lib.rs` `8c2c0af76d71c89d…`
vs `eba53f1c679346bb…`. Its only generator, `python/generate_evidence.py`
(`CHECKSUMS = ROOT / "SHA256SUMS"`, line 88), aborts publicly with
`evidence/results.json is stale` because `evidence/` is not exported. A published integrity
manifest that fails verification on its own tree is worse than none. Either add `SHA256SUMS` to
`.publicignore`, or split it into an export-scoped manifest regenerated at export time over the
filtered file set only.

**B3. The markdown `evidence/` rewrite corrupts runnable replay commands at export time.**
`scripts/export-public.sh:110-113` rewrites `\bevidence/` → `$ERGODIS_EVIDENCE_BASE_URL/` in
*every* `*.md`, and the comment at lines 96-99 says the rewrite is "confined to prose" — but
`BENCHMARKS.md` carries shell commands inside fenced blocks, e.g. lines 249-250
`--raw-jsonl evidence/repair-dag-contended-ab.raw.jsonl` / `--output evidence/repair-dag-contended-ab.json`,
which become URLs passed as output paths. `BENCHMARKS.md` has 15 `evidence/` occurrences.
Compounding it, the default base URL is `https://evidence.invalid/ergodis-evidence`
(`export-public.sh:39`) whenever `ERGODIS_EVIDENCE_BASE_URL` is unset, and
`staging/validate-release.sh`'s replay-target check inspects only `scripts/`, `--example` and
`--bench` references, so it cannot catch this. Restrict the rewrite to prose lines outside fenced
code blocks (or to link targets), and make `export-public.sh` refuse to run with the
`evidence.invalid` placeholder for a real release.

#### Should-fix

**S1. Shipped doc comments advertise a private tier.** Ten occurrences of "Ported from the private
kernel's …": `src/arithmetic/two_adic.rs:303,359,389,434,468,481`,
`src/arithmetic/subgroup.rs:258,340,355`, `src/hall.rs`. Plus `src/automata.rs:31`
"A total deterministic presentation imported from `@NFA-explicit`", an internal reference a reader
cannot resolve. `public-lint.sh` does not catch these (its marker list is `othello`,
`ergodis-private`, `ergodis-contrib`, `notes/`, `/home/`). Rewrite each to say what the test
checks, not where it came from; optionally add `private kernel` to the private-path marker list.

**S2. `crates/modules/Cargo.toml` has no `license` field** (lines 2-7: name, version `0.0.0`,
edition, rust-version, publish, description only) while the other four crates and `wasm/` all
carry `license = "AGPL-3.0-only"`. No `.rs` file anywhere carries an SPDX header (0/145).

**S3. No dependency-licence policy in the repo.** No `deny.toml`, no `about.toml`. Every dependency
is permissive today (item 7), but nothing prevents drift, and a released binary carries no
third-party notices file.

**S4. Nine broken rustdoc links on a library-first release.** `RUSTDOCFLAGS=-Dwarnings cargo doc`
exits 101; plain `cargo doc` succeeds with the same 9 as warnings. Unresolved: `two_adic`,
`subgroup`, `xor_sumset`, `bitmap`, `alternating_deficiency`, `ClaimStatus::Candidate`,
`Self::prepare_layer` (`src/scheduler_dominance.rs:338` and one more), plus
"public documentation for `Auto` links to private item `SPARSE_DENSITY_DIVISOR`".

**S5. `public-lint.yml`'s token filter is line-scoped and its allowlist is a fork.**
`.github/workflows/public-lint.yml:28` pipes matches through `grep -vE '\bC(99|11|17)\b'`, which
discards the whole *line*, so a real identifier sharing a line with `C99` is missed; and the
allowlist is hardcoded there while the authority is `.public-lint-allow` (unexported). Filter
tokens, not lines, and generate the exempt list from `.public-lint-allow` at export time.

**S6. The release gate never exercises two shipped crates.** `cargo clippy`/`cargo test` bind to
`default-members = [".", "crates/verify", "crates/runtime", "crates/repository-native"]`
(`Cargo.toml:3`), so `crates/modules` is never linted or tested, and `wasm/` is excluded from the
workspace entirely (`Cargo.toml:4`). Both compile when asked explicitly (items 5e, 5f).
`staging/validate-release.sh` additionally omits fmt, clippy, the Python fixture check, and the
two dependency-boundary guards that AGENTS.md treats as gates.

**S7. MSRV 1.87 is declared six times and verified nowhere.** Everything reported here was built
on 1.95.0. Add a pinned-1.87 CI job or drop the claim.

**S8. No `CHANGELOG.md`,** although `docs-private/RELEASE-CHECKLIST.md:21-22` requires a
written-for-readers changelog entry per release. The changelog is a product artifact, not process,
and should ship.

**S9. Reproducible-build story is thin.** No `rust-toolchain.toml` and no flake in the exported
tree; `README.md:586-598` tells users `nix shell nixpkgs#cargo nixpkgs#rustc`, which resolves
against whatever nixpkgs the reader's registry points at. A `rust-toolchain.toml` pinning 1.87 (or
a small `flake.nix`) would make the MSRV claim and the build self-describing.

#### Nice-to-have

**N1.** `edition = "2021"` everywhere while `rust-version = "1.87"` already permits edition 2024.

**N2.** `python/pyproject.toml` sets `requires-python = ">=3.14"`, but the documented validation
path runs on nixpkgs `python3` 3.13.15 (and passed). The pyproject packages only `python/ergodis`;
the oracle package `python/recovery_algorithms` that the parity gate depends on is outside it.

**N3.** `benches/boa-kernel-timing.patch` carries no header naming the upstream project, revision,
or licence of the `src/main.rs` it patches.

**N4.** `publish = false` + version-less path deps make crates.io publication impossible; the
README's git-dependency instructions are consistent with that, so this is only a note in case
crates.io is ever wanted.

**N5.** The FILTERED materialization leaked local `wasm-pack` output: `public-lint.sh` on it
reports `wasm/www/pkg/ergodis_wasm_bg.wasm:0: oversize: 1360621 bytes exceeds cap of 1048576`.
A real `git archive` export excludes it (the directory self-ignores via its generated
`.gitignore`), and `wasm/README.md:11` documents building it — so no shipped artifact is affected.
Worth confirming that whatever produced FILTERED is not the release path.

---

### Remediation

| # | Action | Effort |
|---|--------|--------|
| B1 | `git rm --cached` the 12 tracked `.pyc`; extend `.gitignore` to `__pycache__/`, `*.py[cod]`, `.venv/`, `wasm/target/` | 0.25 h |
| B2 | Decide the role of `SHA256SUMS`: either `.publicignore` it, or make `generate_evidence.py` emit an export-scoped manifest and regenerate | 1–2 h |
| B3 | Confine the `evidence/` rewrite to non-fenced markdown (or link targets only); make `export-public.sh` refuse the `evidence.invalid` default for a tagged release; extend `validate-release.sh`'s replay check to reject URL-valued `--output`/`--raw-jsonl` | 2–3 h |
| 11 | Two `.public-lint-allow` entries with a reason comment | 0.25 h |
| S1 | Rewrite 10 "private kernel" doc comments and `src/automata.rs:31`; optionally add `private kernel` as a lint marker | 0.5–1 h |
| S2 | Add `license`/`repository` to `crates/modules/Cargo.toml`; optionally SPDX headers in the five crate roots | 0.25 h |
| S3 | Add `deny.toml` (allow the observed permissive set, deny unknown/copyleft) and a `cargo deny check licenses` CI step; generate a third-party notices file for binary releases via `cargo-about` | 1–2 h |
| S4 | Fix 9 rustdoc links; add `RUSTDOCFLAGS=-Dwarnings cargo doc` to the gate | 1 h |
| S5 | Token-scope the workflow's allowlist filter; generate the exempt tokens from `.public-lint-allow` during export | 0.5 h |
| S6 | Add `crates/modules` to the linted set (or `--workspace` in clippy) and a `wasm/` test step; extend `validate-release.sh` with fmt, clippy, `generate_fixtures.py --check`, and both dependency guards | 1 h |
| S7 + S9 | `rust-toolchain.toml` pinned to 1.87 plus a CI MSRV job with `--locked` | 0.5–1 h |
| S8 | Write `CHANGELOG.md` with the 0.1.0 entry | 0.5 h |
| 9 | New `.github/workflows/ci.yml`: fmt, clippy, build, test, feature matrix, MSRV, doc, wasm, Python gates | 2–3 h |
| N1–N4 | Edition bump, pyproject `requires-python`, patch header, crates.io metadata note | 0.5–1 h |

Blockers total roughly 4–6 hours; the full list, including a public build CI, roughly 12–18 hours.


## Gap assessment (main agent synthesis)

Verdict: **the engineering is release-grade; the packaging is not.** From the filtered tree a
stranger gets a clean `cargo fmt`/`build --release`/`test --all-features`/`clippy -D warnings`,
every feature permutation compiles, the Python oracle gate passes, every replay target named in
`BENCHMARKS.md` exists, no task identifier or private path survives in shipped Markdown, all
third-party licenses are permissive and AGPL-compatible, the CLI quickstart runs end to end, and
the browser demo builds and passes its headless-Chromium gate with no private or network
dependency and no need for cross-origin isolation. What fails is the release gate's own
"content is finished" and "evidence resolves" items, the installed-binary set, the rustdoc
surface, discoverability of the demo, and the absence of build CI.

### Release-critical gaps (must close before the first public tag)

1. **Export pipeline corrupts and dangles.** The Markdown `evidence/` → URL rewrite in
   `scripts/export-public.sh` runs inside fenced shell blocks (turning `--output evidence/x.json`
   and `> evidence/x.tsv` into URLs) and defaults to the placeholder host `evidence.invalid`;
   `SHA256SUMS` ships stale with 40 entries pointing at filtered-out paths and no public
   regenerator; 12 tracked `.pyc` files ship; the two remaining lint findings need
   `PATH:MARKER` allowlist entries (the strings are deny-set assertions, not leaks).
2. **Shipped documents contradict each other and dangle.** The companion paper is a dead
   `../compositional_recovery.pdf` link in three places with no DOI or arXiv id anywhere;
   `OPTIMIZATION.md`'s headline table quotes the superseded protocol and disagrees with
   `README.md`/`BENCHMARKS.md` on all four rows by up to a factor of ten; the shape-classifier page
   disagrees with `BENCHMARKS.md` on the two negative-control ratios; no `CHANGELOG.md`; no
   copyright holder in `LICENSE`, no `authors`, and no contact while the README offers commercial
   licensing.
3. **`cargo install` ships eight executables, six undocumented.** `autobins` is on, so every
   `src/bin/*.rs` installs; `bench_kernels` panics on `--help`; `ergodis-rpc` ignores `--help` and
   exits 0 silently and is documented only in `python/README.md`.
4. **Rustdoc is the README's recommended API reference and is empty where it matters.** Crate
   front page is four lines over 74 modules and 547 root re-exports; 13 central modules
   (`composition`, `field`, `matrix`, `scheduler`, `span`, …) have no module doc; `composition.rs`
   has zero doc comments on the three types in the README's first example; 9 broken intra-doc
   links fail `-D warnings`.
5. **API stability is undeclared and unpreparable later.** No stability statement beyond one
   README sentence; zero `#[non_exhaustive]` across the public error enums. Marking them after
   the first tag is itself the breaking change.
6. **The demo is invisible and unhosted.** `README.md` never mentions `wasm/`; no `docs/*.md` is
   linked from the README (four are orphaned from everywhere); the only CI is the identifier lint,
   so nothing builds, tests, or deploys the demo, and `wasm/` is outside the workspace so root
   `cargo test` never exercises it.

### Product-scope gap (Tavis decision, not a defect)

The public core's `crates/modules` is a bare experimental provider ABI. All family providers
(LRC, QEC, scheduling, CSS, Hadamard, repair) and every rich browser workspace (campaign console,
race UIs, Evolve, code-distance) live in `ergodis-private` and depend on private data, the native
daemon, or private module payloads. The public product today is: the engine library, the `ergodis`
CLI (including the public `application` kinds `ceph-xor`, `azure-lrc`, `repair-dag`, `qc-ldpc`,
`vector-repair`, `gpu-checkpoint`), the Python oracle/client layer, and a generic first-visit
browser demo (lamp problem, guided campaign, run-bundle inspector). The demos review recommends
the Azure LRC recovery/capacity demo as the one showcase worth promoting, and notes it can be
built as a new static page over the already-public `AllocationKernel` WASM export with a
checked-in synthetic input, with no private code crossing the boundary. The private campaign
console should not be promoted.

### Should-fix before or shortly after release

README surgery (move the optimization diary at `README.md:380-423` to `BENCHMARKS.md`; document
`hall`/`verify-hall` and lead with the certificate round trip; add Demos and docs-index sections;
fix the stale scheduling sample output); `examples/README.md` and triage of the 40 examples (one
teaching example, the rest research drivers with undocumented `ERGODIS_*` variables and an
undeclared `kissat` dependency); `docs/glossary.md` split (29 `planned` terms and a naming policy
addressed to developers); ten "Ported from the private kernel" doc comments and one
`@NFA-explicit` reference; `crates/modules` license/repository metadata; `deny.toml` plus a
third-party notices file for binary releases; MSRV 1.87 never exercised (`rust-toolchain.toml`
or CI job); `crates/modules` and `wasm/` outside the validation gate; `validate-release.sh` omits
fmt, clippy, the Python fixture check and both dependency guards; the public-lint workflow's
allowlist filter is line-scoped and a hardcoded fork of `.public-lint-allow`; `python`
`requires-python = ">=3.14"` and no `shutil.which` fallback for `ergodis-rpc`; `SECURITY.md`,
`CITATION.cff`, a minimal `CONTRIBUTING.md` policy line.

### Effort

| Area | Release-critical | Full list |
|---|---|---|
| Documentation | 10–14 h (+ paper deposit, evidence decision) | 35–45 h |
| Library and CLI | ~9 h | ~28 h |
| Demos | ~5 h (README section, serve one-liner, Pages workflow) | ~12 h + optional showcase 1–2 days |
| Build, CI, licensing, hygiene | 4–6 h | 12–18 h |
| Overlap (CI, changelog, evidence refs counted twice) | −4 h | −8 h |
| **Total** | **~25–30 h** | **~75–95 h** (+ showcase) |

## Remediation plan

### Phase 0 — decisions taken on 2026-09-11

- **Companion paper (item 2)**: link the public repository
  `https://github.com/tavisrudd/compositional-recovery`. Applied: ergodis `c36eded` replaces
  all three `../compositional_recovery.pdf` links. Docs blocker B1 closed.
- **Copyright holder, authors, contact (item 3)**: Tavis Rudd <tavis@damnsimple.com>. Applied:
  ergodis `8f278a4` adds the copyright line and contact to the README license section,
  `authors` to all six Cargo manifests and `pyproject.toml`, and `license`/`repository` to
  `crates/modules`. Docs blocker B7 and API should-fix S5 closed.
- **Product scope (item 4)**: engine + CLI + demo, where the demo ships **compiled WASM
  payloads of the private family providers with no source access to them**. Consequences for
  the plan:
  - The public tree (or its release assets) carries binary module payloads that are not
    AGPL-licensed. Tavis is the sole copyright holder, so distributing a combined AGPL core +
    proprietary payload is his to license; but the public repository must carry a separate,
    explicit license notice for the payloads (demo use only, no redistribution, no source
    offer) so that AGPL recipients do not assume the payloads are covered by `LICENSE`. The
    private payloads already carry embedded proprietary markers; the demo directory must
    additionally state this in plain text, as a notice file placed beside the payloads (for
    example `wasm/www/modules/NOTICE`) and a sentence in the README license section listing
    which paths are proprietary. The notice file is written when the payloads land (Phase 5,
    demo agent's territory); the README sentence is a Phase 2 item.
  - Payloads exceed the public lint's 1 MiB size cap (the public wasm alone is 1.36 MB raw), so
    either the cap is raised per path or payloads ship as GitHub release assets fetched by the
    page. Decide in Phase 4.
  - **Artifact snapshots only.** The public tree receives built payload artifacts (compiled
    WASM and whatever glue the loader needs), produced privately and committed as opaque
    snapshots. No private source, build script, packaging tool, Makefile, or fixture crosses
    the boundary; the private build step stays in `ergodis-private` and is never exported. The
    loader half is already public (`module-host.js`, `module-worker.js`; see the demos section)
    but no public page consumes it yet. That is demo work.
  - **Demo files are owned by another active agent. No demo file is moved, renamed, or edited
    by C1149 or its successors without that agent's lane finishing first.** The demos section's
    recommendations (README Demos section, serve one-liner, Pages workflow, showcase page) are
    routed to that agent, not executed here.
- Still open: item 1 (evidence publication vs. rewording) and item 5 (public build CI and Pages
  deploy on the `public` branch).

### Phase 0 — decisions (original list)

1. Evidence: publish `ergodis-evidence` and set `ERGODIS_EVIDENCE_BASE_URL` at export, or reword
   all evidence references as not public.
2. Companion paper: arXiv/DOI deposit to cite, or bundle the PDF.
3. Copyright holder string, `authors`, and the commercial-licensing contact address.
4. Public product scope: engine + CLI + generic browser demo (recommended for 0.1.0), with the
   Azure LRC capacity showcase as a follow-up slice, versus extracting a family module now.
5. Confirm a public build/test/doc/wasm CI and a GitHub Pages deploy are acceptable on the
   `public` branch (the review argues they are product artifacts, not process).

### Phase 1 — export and hygiene (~6 h, one task)

Confine the evidence rewrite to prose outside fenced blocks and refuse the `evidence.invalid`
default for tagged exports; `.publicignore` or export-scope `SHA256SUMS`; untrack the `.pyc` files
and extend `.gitignore`; two `.public-lint-allow` entries; rewrite the private-kernel doc comments;
`crates/modules` metadata; extend `validate-release.sh` (fmt, clippy `--workspace`, `wasm/` tests,
Python gates, dependency guards, `RUSTDOCFLAGS=-Dwarnings cargo doc`); extend the release
checklist to cover `DESIGN.md`, `CONTROL_PROTOCOL.md`, `docs/`, in-tree link resolution and
cross-document number agreement.

### Phase 2 — shipped surface (~10 h, one task)

`autobins = false` and per-binary keep/rename/move decisions (`bench_kernels` never installs);
clap `--help`/`--version` for `ergodis-rpc` plus a README section on its framing; stability
statement and `#[non_exhaustive]` on public error enums; `CHANGELOG.md` 0.1.0; `LICENSE`
copyright line, `authors`, contact; `CITATION.cff`, `SECURITY.md`; reconcile the
`OPTIMIZATION.md` table and the shape-classifier numbers with `BENCHMARKS.md`; fix the paper link;
resolve the `<shared-target-dir>` / `<application-ab-venv>` placeholders.

### Phase 3 — documentation (~20 h, one or two tasks)

Rustdoc: crate-level overview naming the compile → solve → certificate → verify stages and the
entry APIs, module docs for the 13 bare modules, `composition.rs` public items, the 9 broken
links, `#![warn(missing_docs)]` ratchet on `verify` and `repository-native`. README: Demos
section with screenshot and build/serve commands, `hall`/`verify-hall` and the certificate round
trip in "Start here", diary moved out, docs index, stale sample output, `after_help` per
subcommand naming its `examples/data` file. `examples/README.md` and the keep/promote/move/hold
triage, then demote `root_execution`, `allocation_surface`, `scheduler_dominance`, `bitset` to
`pub(crate)`. `docs/README.md` index; glossary split; capitalization sweep.

### Phase 4 — CI and hosted demo (~8 h, one task)

`ci.yml`: fmt, clippy, build, test, feature matrix, MSRV 1.87 with `--locked`, doc with
`-Dwarnings`, `wasm-pack build` with a pinned `wasm-bindgen-cli` from nixpkgs, `wasm/` tests, Python
gates, `cargo deny check licenses`. Pages workflow gated on `browser-smoke.mjs`. Top-level
Makefile with `wasm`, `serve`, `smoke` targets. `www/LICENSE` copy or footer source link.

### Phase 5 — private-provider demo payloads (own task, after the demo agent's lane)

Private side: release-build the family providers to WASM payloads and package them hash-named
for the public `module-host.js` loader. Public side receives only the built artifact snapshots
plus the separate payload license notice; no private source, scripts, or packaging tooling is
exported, and the export filter must keep it that way. Settle the size-cap or release-asset
delivery. The earlier optional `AllocationKernel` showcase page is subsumed.

### Phase 6 — release

Bump version, tag, run the extended checklist, `export-public.sh`, validate in the staging clone,
then Tavis publishes. Agents export and stop.

### Successor allocation

Phases 1–4 are four allocatable tasks; phase 5 a fifth. None is allocated here. Recommended
order: 1 → 2 → 4 → 3 (CI before the long documentation pass so the doc build gate is live while
the rustdoc work lands).

## Foreign issues noted

- `~/src/ergodis` working tree carries uncommitted allocation-surface parallel work from another
  session (`src/allocation_surface/parallel.rs`, two new tests, `tests/data/`); untouched.
- Two untracked `__pycache__` directories sit in that working tree in addition to the 12 tracked
  `.pyc` files.

## Method

Four Opus reviewers (documentation; library and CLI; demos; build, CI, licensing, hygiene) read
the filtered tree materialized from `main` `c59bf67` with `.publicignore` applied, ran builds
with `CARGO_TARGET_DIR` under `~/.cache/ergodis/target/c1149-*`, and wrote the sections above
verbatim. The filtered tree was not passed through the export script's rewrite step, so the
rewrite defects were established by reading the script and the affected lines, not by observing
an export. Nothing under `~/src/ergodis*` or the staging clone was modified.
