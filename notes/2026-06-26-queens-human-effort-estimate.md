# Queens solver — human-expert effort estimate (no AI assistance)

**Date:** 2026-06-26
**Question:** How long would a single human expert — fluent in (a) the math / combinatorial
game theory, (b) algorithms & data structures, and (c) low-level Rust + hardware performance
engineering — take to produce this work product *without* any AI assistance, working solo?
Counting both the final artifact **and** every round of profiling/optimization (including the
levers that were tried, measured-negative, and reverted).

## Method

Two reviewers (independent sub-agents) each:

- read the actual hot-path source — `dense.rs` (W_K / getK const-eval pext tower), `graph.rs`
  (WL + individualisation-refinement iso key), `tt.rs` (lockless/segmented/set-associative TT),
  `burr.rs` (from-scratch ribbon retrieval), `iso_flat.rs`, the CLI, the bench binaries — not
  just the `CLAUDE.md` summary;
- read the handoff record and the n=18 umbrella for the full lever inventory, dead ends included;
- inspected the Lean 4 + mathlib proof and the arXiv-style report.

**Timeline-stripped by construction.** Both were instructed to ignore every date, "session N"
marker, and any calendar signal in the handoffs, and to estimate purely from the *substance*:
the difficulty of the math, the novelty/volume of the code, and the number and sophistication
of the perf-engineering iterations. The dead ends were counted — a measured-negative lever still
cost the expert real design → implement → benchmark → analyze → decide time.

## Headline

| Reviewer       | Low      | **Central**           | High      |
|----------------|----------|-----------------------|-----------|
| Reviewer A     | ~14 p-mo | **~19 person-months** | ~26 p-mo  |
| Reviewer B     | ~11 p-mo | **~15 person-months** | ~22 p-mo  |
| **Synthesis**  | ~12 p-mo | **~15–19 person-months** | ~24 p-mo |

For one focused expert (~6 hrs/day, ~5 days/week) that is roughly **1.2–1.6 years of solo
full-time work**. The two estimates converge tightly at the high end (~22–26 mo) and diverge
most at the floor — the gap is almost entirely how aggressively a human would chase the
dead-end levers to full A/B rigor versus time-box and abandon them early.

## Where the effort sits (both reviewers agree)

The **performance-engineering campaign dominates** — about half the total in both estimates.

| Bucket                                   | Estimate (person-days) | Notes                                                                                                          |
|------------------------------------------|------------------------|--------------------------------------------------------------------------------------------------------------|
| Math / CGT foundation + lit-situating    | ~10–13                 | Sprague-Grundy / Node-Kayles / mex / component-XOR applied correctly; confirm n=18 genuinely open vs Jenrich + OEIS A344227. Standard CGT, not new theorems. |
| Lean 4 machine-checked recurrence        | ~12                    | Sorry-free over mathlib: well-founded recursion, mex/Grundy, iso/embedding lemmas, multiple review rounds. Lean fluency is itself rare. |
| Core algorithms + architecture           | ~38–45                 | WL + individualisation-refinement iso key (nauty-class); lockless/segmented/set-associative TT; **W_K dense tower + getK pext evaluator** — the original "math is cheaper than memory" contribution. |
| BuRR succinct-retrieval structure        | ~16                    | From-scratch impl of a 2022 paper (bumped ribbon retrieval, GF(2) on-the-fly Gaussian elimination, sharded RAM-bounded build); validated exact on 2+ billion keys. |
| Implementation labor (scaffolding/CLI)   | ~20–25                 | ~20–26K LOC of perf-grade Rust (const-eval pext tables, 192-bit codes, AVX-512) at ~100–150 net LOC/day, not CRUD rates; CLI, bench binaries, checkpoint/resume. |
| **Performance-engineering campaign**     | **~190–200**           | **The dominant bucket.** ~90–120 distinct lever investigations; ~35 measured-negative and reverted (work-stealing, ABDADA, sorted-frontier wave, set-assoc TT, component-nimber, PGO, modular reduction). Dead ends cost as much as wins. |
| Validation (ex-Lean)                     | ~15                    | Multi-solver lineage-vs-naive gate, exact distinct-counts, HLL sizing, per-layer scalar differentials, independent-oracle differential, Jenrich/A344227 reproduction, int-sizing audit, verdict-bug hunt. |
| Compute / ops / memory-debug / babysit   | ~18                    | OOM / huge-page / THP-misalign / zram / cross-CCX / thermal confound debugging (these repeatedly faked a "floor"); babysitting multiple long n=16 runs + the multi-hour n=18 solves. |
| Formal writeup (report)                  | ~8                     | The arXiv-style report; the design proposals fold into the campaign's design time.                          |

The load-bearing fact behind the perf number: the project's own benchmarking discipline
("single n=16 runs lie ±18% → interleaved A/B only", box-hygiene before every run, perf-TMA
attribution) means each *conclusive* measurement — and especially each *negative* — genuinely
consumed multiple build-bench-analyze cycles on a thermally-throttling, memory-tight box, not
hours. That is what pushes the campaign toward ~200 person-days rather than ~120.

## Two caveats both reviewers raised plainly

- The **n=18 result is genuinely novel** (first-player win, witness I9, 15-ply PV; extends
  Jenrich arXiv:1312.5135 / OEIS A344227) and the validation is unusually rigorous (two
  independent getK configs agreeing on verdict + winning move + a byte-identical PV at 2×
  different node counts). **But** the enabler that actually closed it was *simple* — `skip[18,25]`
  + a 17 GB flat TT. A large fraction of the heaviest n=18 machinery (disk-DDD, io_uring,
  locality-preserving TT key, deep-TT ranking) was explored and not used on the critical path.
  That exploration still cost real time and is included in the estimate.
- The result rests on **two-config cross-agreement, not a formal end-to-end board-level
  certificate.** The Lean proof verifies the abstract recurrence, not the n=18 board run; the
  independent game-rules-only proof-tree checker is still pending. This does not move the effort
  number but it bounds how much "verification" is fully banked.

## Largest uncertainty (both named the same one)

**The per-lever cost inside the perf campaign.** It is ~half the total and swings roughly ±40%.
At ~1.5 days/lever the campaign is ~120 person-days; at ~3 days/lever it is ~270. Both reviewers
leaned toward the higher end because correct, noise-free benchmarking on this box is expensive
and because the AI-driven process pursued levers (and tuned/reverted them) more exhaustively than
a time-boxed human likely would. Secondary swing: whether the expert is a fluent Lean user — if
not, the proof bucket can roughly double.

## On the "single tri-domain expert" assumption

Both reviewers called it close to a unicorn, and argued the work is really **five** specialties,
not three:

1. research-level combinatorial game theory **plus Lean 4 proof engineering**;
2. graph-isomorphism canonicalization (WL / individualisation-refinement — a niche of its own);
3. succinct / retrieval data structures (BuRR, a 2022 research result reimplemented and scaled);
4. elite x86 microarchitecture perf (Zen5 TMA, BMI2/AVX-512, cache/TLB/huge-pages, lockless
   concurrency);
5. external-memory / async-I/O algorithms (DDD, io_uring, ZFS tuning).

Realistically this is a **2–4 person team**. A coordinated team *compresses calendar time*
(a trio could finish the ~15–19 person-months in ~5–9 calendar months by running the Lean proof,
the perf grind, and the writeup in parallel) but leaves the **person-month total roughly
invariant** — coordination overhead offsets the parallelism, and the multi-hour n=18 compute
wall-clock is irreducible regardless. The person-month figure is the domain-independent quantity
and the one both reviewers would defend.

## Bottom line

Two independent bottom-up estimates put this at **~15–19 person-months of solo expert effort
(range ~12–24)** — well over a year of full-time work for someone simultaneously fluent in
combinatorial game theory, research-grade algorithms, low-level Rust / microarchitecture
performance engineering, and Lean proof. The **performance-optimization campaign — including all
the reverted negatives — is the single largest driver**, not the final artifact. This is not
derivative make-work: while each individual technique is known, the W_K-tower-over-getK synthesis
is an original contribution, the n=18 verdict is a new entry on a previously open board, and the
validation stack is unusually rigorous for a computational result.
