# C1039 planted theorem-gap corpus and admission measurement

**Lane:** `complete-ports`

**Date:** 2026-09-02

**Status:** complete, uncommitted and awaiting review; all task gates pass, two workspace gates are
blocked by another lane's uncommitted work (section 8)

**Scope limit.** This is tooling and local evidence only. Nothing here claims that the Ergodis
admission boundary is sound in general, that the measured behaviour transfers to corpora that were
not planted by this generator, or that evolve discovered any mathematics. The planted corpus is a
test of one boundary on one deterministic family.

## 1. What is measured

The C985 admission architecture separates an untrusted proposer from a semantic verifier: a
candidate that is perfect on the corpus the proposer saw has no pruning authority until admission
replays it against the complete authoritative model. This task builds a corpus family where that
distinction has teeth by construction: several typed predicates are indistinguishable on the
training view, and only one of them is a valid reduction on the direct model. The measurement is
the count of candidates that pass the corpus-perfection screen versus the count that survive
admission, plus a replayable counterexample for every rejection.

## 2. Corpus construction

### 2.1 Latent model

A latent state is a residual tuple `r = (r0, r1, r2, r3, r4)` with each `r_i` in `{-2,-1,0,1,2}`.
The ground-truth reduction predicate — the *direct model* — is

```text
survives(r)  :=  (r0 == 0) and (r1 == 0)
```

`r2`, `r3`, `r4` are diagnostic coordinates: they do not enter the truth.

### 2.2 The two views

Both views enumerate latent states deterministically in lexicographic order over
`{-2,-1,0,1,2}` per coordinate; there is no sampling and no rejection.

- **Direct-model (verification) view.** The complete enumeration of all `5^5 = 3125` latent
  tuples. This is the authoritative model admission replays against.
- **Training view.** The sublattice defined by the planted tie `r1 == r2 == r3`, with `r0` and
  `r4` free: `5 * 5 * 5 = 125` tuples. The tie is the whole planted gap. On the training view the
  coordinates `r1`, `r2`, `r3` are indistinguishable, so a predicate that tests `r2` or `r3`
  instead of `r1` is exactly as perfect as the true one.

### 2.3 Presentation

Neither view exposes residuals. For each coordinate `i` the generator emits two raw scalars
`a_i` and `b_i` with `a_i - b_i = r_i`, where `a_i` is drawn from a seeded SplitMix64 stream over
`[-1000, 1000]`. The ten raw scalars are then expanded by the existing theorem-agnostic
pairwise-difference expander (`ergodis_private::raw_feature_evolve::expand_pairwise_differences`),
giving `10 + 45 = 55` fields. Fields are renamed `f000..f054` and permuted by a hidden
digest-seeded permutation shared by both views, so field indices carry no provenance. The
residual `r_i` is recoverable only as the single expanded field `a_i - b_i`, whose presented index
is permuted.

Seeds: the training view uses one fixed seed and the direct-model view a different fixed seed, so
the two views share no base scalars; only the latent semantics is shared.

### 2.4 The planted predicate family

Write `d_i` for the presented field carrying `a_i - b_i` (that is, `d_i == r_i` in every row of
every view). The declared planted predicates are:

| Name | Predicate | Training view | Direct model |
|---|---|---|---|
| `P0` | `d0 == 0 and d1 == 0` | exact | exact — sound |
| `P1` | `d0 == 0 and d2 == 0` | exact | unsound |
| `P2` | `d0 == 0 and d3 == 0` | exact | unsound |
| `P3` | `d0 == 0 and d2 == 0 and d3 == 0` | exact | unsound |

**Soundness argument for `P0`.** By construction `d_i` equals `r_i` in every row of every view,
because the generator emits `b_i = a_i - r_i` and the expander emits the difference `a_i - b_i`
verbatim. The truth is `survives(r) = (r0 == 0) and (r1 == 0)`. Therefore `P0` and `survives`
are the same function of the latent state, so `P0` has zero false positives and zero false
negatives on any set of latent tuples whatsoever, in particular on the complete direct-model
enumeration. This is a statement about the planted family only.

**Counterexample families for the unsound predicates.** All three fail on latent tuples with
`r0 == 0`, `r1 != 0`, and the tested diagnostic coordinates zero:

- `P1` is claimed but false on every `r = (0, r1, 0, r3, r4)` with `r1 != 0`; that family has
  `4 * 5 * 5 = 100` members in the direct-model view.
- `P2` is claimed but false on every `r = (0, r1, r2, 0, r4)` with `r1 != 0`: 100 members.
- `P3` is claimed but false on every `r = (0, r1, 0, 0, r4)` with `r1 != 0`: 20 members.

None of these families intersects the training view, because every member has `r1 != 0` while at
least one of `r2`, `r3` is zero, which violates the planted tie `r1 == r2 == r3`.

## 3. What the command does

`hadamard evolve theorem-gap --output-dir <dir>` is a new subcommand of the hadamard-2092 tier-2
binary, alongside the other evolve controls. It is not a lane-neutral operator tool: it reuses the
blind-holdout harness functions and the opaque-corpus conventions that live in this task crate, and
it produces task evidence rather than a reusable operator utility, so `tasks/tools` is the wrong
home. The generic corpus generator is tier 1
(`ergodis-private/src/planted_gap_corpus.rs`, no task identifier in its name); the driver is tier 2
(`tasks/hadamard-2092/src/evolve/theorem_gap.rs`), with a `clap::Args` struct and a `pub fn run`,
and no new `src/bin` file.

Reuse rather than forking:

- the raw-feature expander `expand_pairwise_differences`, the opaque field naming, and the hidden
  digest-seeded field permutation come from `raw_feature_evolve` unchanged;
- the corpus reader, the blind constant-conjunction proposer, and the campaign start/poll/shutdown
  helpers come from `evolve::blind_holdout`, widened to `pub(crate)`;
- candidate evaluation is the campaign's own compiled plan virtual machine
  (`CompiledPlan::compile` plus `evaluate_row`), so no second plan interpreter exists;
- admission is `ergodis::theorem_search::SoundTheoremArchive::admit`, which rejects any candidate
  whose direct-model coverage leaves the truth bitmap.

One deliberate difference from `blind_holdout::run`: that harness's counterexample-guided
refinement reads the holdout view while proposing. Here the direct model must not reach the
proposer at all, so only the training-view proposer is used and the direct model appears solely as
an admission input.

Candidate scoring loops use caller-owned bitmaps sized once from the row counts; the sweep
allocates one bitmap per live literal and reuses two scratch bitmaps for the pair and triple
intersections.

## 4. Searched domain and stop condition

The declared domain is every conjunction of one, two, or three literals of the form
`f == c`, where `f` ranges over all 55 presented fields and `c` over the nine constants
`{-4, ..., 4}`: **20,214,975 conjunctions**. A candidate counts as *corpus-perfect* when it has
zero false positives on the training view and claims at least one training row.

The enumeration is exhaustive, not sampled, and prunes soundly: conjunction coverage is monotone
decreasing in the literal set, so any conjunction containing a literal that claims no training row
claims no training row itself and cannot be corpus-perfect. Only **50 of the 495 literals** claim a
training row, which is why **20,875 conjunctions** were materialized; the remainder are excluded by
that argument, not by a budget. **125** conjunctions are corpus-perfect. The stop condition is
exhaustion of the declared domain: there is no timeout, no candidate budget, and no sampling step.

Alongside the sweep, the run screens the four declared planted predicates and every predicate the
evolve campaign proposed: 991 distinct plans (one blind-proposer seed and 990 evolved descendants
recovered from the campaign's own evidence file), from a run of four generations, beam 32, at most
1,000 candidates, of which the campaign tested 979 and rated 36 perfect on the training view.

## 5. Fingerprints

| Item | SHA-256 |
|---|---|
| planted source digest | `1bff77e9c2b5e61da5edc9c6583c9d726778f98150fc80a041cac6f8cdee9a43` |
| training view (`planted-gap-training.jsonl`) | `2b8ced2fbdc75996eb42f361294329b270b1c970e420c3fa606df9bea3e99949` |
| direct-model view (`planted-gap-direct-model.jsonl`) | `4cc9f4bbbdfe1d30edcd922bb894f40b5407b55e1b7c6bdd851c93399932da4b` |
| certificate (`certificate.json`) | `53051b4881b228e1edd61b92a73699291ff81937440defea9f63ef50e903b1d9` |
| `planted-gap-training.jsonl.gz` | `28ceb1dbc971b59fc91ee09a69f0daa5698b32e6abe8d8e440689366b6cdac6b` |
| `planted-gap-direct-model.jsonl.gz` | `ff8df16f1b2050ad2945de5ace428d162cd68bbeda5b3442aa43499bf085bc47` |

The two view digests are computed inside the generator as it writes and are reproduced exactly by
`sha256sum` on the resulting files, so they check the generator against the bytes on disk. Both
views are fingerprinted separately; the training view is 125 rows with 5 positives, the
direct-model view 3,125 rows with 125 positives.

The generator independently reports which presented fields are constant across the positive rows of
each view. On the training view that set is exactly the four fields carrying `r0`, `r1`, `r2`, `r3`
(presented indices 35, 36, 49, 50 after the hidden permutation); on the direct-model view it is
exactly the two fields carrying `r0` and `r1` (35, 36). That is the planted gap made visible as a
measurement rather than an assertion.

## 6. Results

### 6.1 The planted predicates

| Predicate | Training false positives | Training rows claimed | Direct-model false positives | Admission | Smallest counterexample |
|---|---:|---:|---:|---|---|
| `P0` `d0 == 0 and d1 == 0` | 0 | 5 | 0 | **admitted**, 125 novel rows | — |
| `P1` `d0 == 0 and d2 == 0` | 0 | 5 | 100 | rejected-unsound | row 1300, `r = (0, -2, 0, -2, -2)` |
| `P2` `d0 == 0 and d3 == 0` | 0 | 5 | 100 | rejected-unsound | row 1260, `r = (0, -2, -2, 0, -2)` |
| `P3` `d0 == 0 and d2 == 0 and d3 == 0` | 0 | 5 | 20 | rejected-unsound | row 1310, `r = (0, -2, 0, 0, -2)` |

All four are indistinguishable on the training view — same zero false positives, same five claimed
rows — and admission separates them. The measured false-positive counts, 100, 100 and 20, are
exactly the counterexample-family sizes derived in section 2.4, and each recorded counterexample
lies in its predicted family.

A counterexample replays without the corpus file: the row index feeds
`planted_residuals(PlantedView::DirectModel, row)`, which recomputes the latent tuple, and
`planted_truth` recomputes its label. The command also re-derives every direct-model label from
that oracle before admission runs and fails closed on any disagreement, so the labels in the file
and the labels admission uses come from two separate code paths.

### 6.2 The whole run

| Origin | Screened | Admitted | Rejected unsound | Rejected for another reason |
|---|---:|---:|---:|---:|
| planted predicates | 4 | 1 | 3 | 0 |
| evolve proposals | 991 | 0 | 598 | 393 |
| exhaustive domain sweep | 125 | 0 | 19 | 106 |
| **total** | **1,120** | **1** | **620** | **499** |

Exactly one candidate out of 1,120 was admitted across the whole run: the sound planted predicate
`P0`, which claims all 125 direct-model positives. Every one of the 620 unsound candidates carries
a recorded direct-model counterexample row. The 499 remaining rejections are the archive's
dominance and novel-coverage rules refusing candidates that are sound but add nothing once `P0`
holds the full truth set; they are not soundness failures.

Restricting to corpus-perfect candidates — the ones that pass the training screen with nonempty
coverage, which is the population this task is about — 87 evolve proposals and 125 swept
conjunctions qualify; 32 of the 87 and 19 of the 125 are refused as unsound, with false-positive
counts from 1 to 100. Two of the evolved proposals rediscovered the `P1`/`P2` shape and were
refused with 100 false positives each. A further 383 proposals had no training false positive only
because they claim no training row; the certificate counts them separately and never treats vacuity
as perfection.

The certificate retains in full the four planted predicates, the 87 corpus-perfect evolve
proposals, and the first 64 unsound sweep rejections (19 occurred, so all of them); the remaining
proposals appear as per-origin counts. No proposal failed to compile as a predicate plan.

## 7. Replay

```sh
cd ergodis-private
cargo build -p hadamard-2092 --release
rm -rf ~/.cache/ergodis/c1039-replay
~/.cache/ergodis/target/ergodis-private/release/hadamard evolve theorem-gap \
  --output-dir ~/.cache/ergodis/c1039-replay > /tmp/c1039-certificate.json
sha256sum /tmp/c1039-certificate.json
```

The certificate carries no wall-clock, path, host, or process field, so nothing has to be dropped
before comparing. Two consecutive invocations into different output directories produced
byte-identical stdout, digest
`53051b4881b228e1edd61b92a73699291ff81937440defea9f63ef50e903b1d9`. The only nondeterminism in the
run tree is the run-unique suffix the campaign appends to its evidence file name; the file's
contents are deterministic and the driver locates it by prefix.

Evidence bundle: `ergodis-private/evidence/c1039-theorem-gap/` holds `certificate.json`, both views
gzipped, `REPLAY.md`, and `SHA256SUMS`.

## 8. Gate output

| Gate | Result |
|---|---|
| sound predicate admitted | pass — `P0` admitted with 125 novel rows |
| every unsound planted predicate rejected with a replayable counterexample | pass — `P1`, `P2`, `P3` all rejected-unsound with recorded rows 1300, 1260, 1310 |
| two invocations byte-identical after dropping wall-clock fields | pass — identical digests, no wall-clock field exists |
| training and verification views separately fingerprinted | pass — two distinct SHA-256 view digests, generator-computed and file-verified |
| `cargo fmt --all --check` | pass, `exit=0` |
| `cargo check --workspace --all-targets` | pass, `exit=0` |
| `cargo clippy --workspace --all-targets -- -D warnings` | **fails on foreign in-flight work**, `exit=101`; see below |
| `cargo test --workspace` | **fails to build foreign in-flight work**, `exit=101`; see below |
| `cargo test --workspace --exclude ergodis-tools` | pass, `exit=0` — `575 passed; 0 failed`, plus `13`, `4`, `2`, `1`, `1`, `0` in the integration targets, all `ok` |

Both failing gates fail entirely outside this task's files, in another lane's uncommitted work that
is being edited concurrently:

- clippy stops on `ergodis-private/src/repr_grammar.rs` (untracked) with
  `unnecessary_min_or_max` at `let low = target as u64 & ((1_u64 << low_width) - 1).max(0);`. Its
  line number moved between two runs minutes apart, so the file is live. Rerunning the same
  workspace clippy command with only that one lint allowed,
  `cargo clippy --workspace --all-targets -- -D warnings -A clippy::unnecessary_min_or_max`,
  exits 0, which isolates the failure to that foreign line.
- `cargo test --workspace` fails to build `ergodis-tools` with
  `cannot define multiple global allocators` at `tasks/tools/src/main.rs:119`, also foreign and
  uncommitted. Excluding only that crate, the same command exits 0 with every test passing.

The concurrent lane's uncommitted files are `ergodis-private/src/repr_grammar.rs`,
`ergodis-private/tasks/tools/src/repr_search/`, `ergodis-private/tasks/tools/src/main.rs`, and two
`c1051-*` evidence files; `ergodis-private/src/lib.rs` carries one module line from each lane.

These are raised, not fixed; the C1039 changes are not staged or committed.

## 9. Mystery ledger

- **Why 393 evolve proposals are rejected for a non-soundness reason.** Settled by the closeout
  pass: the archive holds `P0`, which covers every direct-model positive, so any later sound
  candidate adds no novel row and is refused as dominated or non-novel. This is the Dalmatian
  admission rule working as designed, not a near-miss on soundness, and the certificate reports the
  two classes separately so the distinction stays visible.
- **Why 383 proposals show zero training false positives yet claim nothing.** Settled: evolve
  mutation produces plans testing a field against a constant no training row takes. They are
  vacuously perfect. The certificate counts them apart from the 87 genuinely corpus-perfect
  proposals, and vacuity never reaches the admitted count.
- **Whether the declared cost function changes what is admitted.** Partly open. Candidate cost is
  the plan's program length, so a shorter plan with the same coverage displaces a longer one. In
  this run nothing displaced `P0`, but an earlier version that gave every evolved proposal cost 1
  admitted two of them by displacing `P0` on cost alone with identical coverage. The archive's
  behaviour was correct in both cases; what changed was the cost declaration. The gap is that no
  gate here pins cost semantics, so a future adapter could reintroduce the same artefact. Owner: the
  common proposal envelope work in the C985 architecture, where declared cost belongs.
- **Whether the sweep's 106 non-unsound rejections contain anything sound and independent.** Open,
  and bounded by the same dominance rule as above: once `P0` covers the full truth set, no
  conjunction can add novel coverage, so the sweep cannot exhibit an independent sound reduction
  even if one existed. Measuring that would need the archive seeded without `P0`, which is a
  different experiment.

Nothing here is a mystery about the admission boundary itself: the planted separation behaved
exactly as the construction predicts, with the measured false-positive counts equal to the
counterexample-family sizes derived in advance.
