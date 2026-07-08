# Fable day plan — 2026-07-07 (one day of Fable 5; Opus subs + Codex available)

Allocation rule: Fable tokens go ONLY where the capability differential is real — novel proof
construction, convention-trap correctness, calibration calls, soundness auditing. Everything
executable against a written spec goes to Opus subagents; all Lean goes to Codex (its standing
workstream). Box constraint all day: the G(17) queens nimber run owns RAM ⇒ subs stay
small-memory/single-core; no q=23 runs today.

## Done this morning (session 8 + lit pass)

Conic localization lemma + (ON) refinement (committed `cabb90c`, `7a42e16`); nofil prior-art
discovery, doc corrections incl. the REVISED novelty verdict (committed `d1ccb5f`).

## Status (updated end of Fable session 1, ~mid-day)

- **F1 DONE** (commit `6b4f57f`): four kernels written — `2026-07-07-kernel-{sumfree-zn,
  affine-cap, nofil-corollaries, conic-localization}.md`. En route: **sum-free Lemma 4 was
  FALSE as stated** (breaker family `z = t + n/2`; theorem uses safe); corrected + banner on
  the 2026-07-04 note + Codex-confirmed to n ≤ 120 (C1 report).
- **F2 DONE** (commit `99fb6f4`): [intrusion calculus](2026-07-07-onconic-intrusion-calculus.md)
  — (ON) PROVED q=5,7; PGL(2) uniformization; one-intruder parity solved; multi-intruder
  dihedral core isolated. Machine-verified.
- **O1–O4 all delivered**: arc census (q=27/29 full, q=23/25 gaps → C4); esc mode (q=11/13
  gates PASS byte-identical, q=17/19 gate → C3); LaTeX scaffold (compiles, kernels as \input
  slots); related-work pulls (Szőnyi–Weiner vs Ball–Lavrauw scoping catch).
- **Codex queue** ([tasks](2026-07-07-codex-task-queue.md)): C1 REPORTED, C2 REPORTED,
  C3 in progress (q=19 gate), C4–C5 pending, **C6–C8 added by F3** (GF(49) fix, automorphism-
  exhaustiveness lemma + check, exact-canon cross-validation). Per user: further delegation
  goes to Codex, not Opus subs.
- **F3 DONE (Fable session 2):** [soundness audit](2026-07-07-f3-soundness-audit.md) — all four
  referee-probe targets audited from scratch and SOUND (frame chain incl. terminal edge case +
  quantifier step; resym reply reconstruction/memoization + enumeration; canon min-image
  invariance; escape/esc/feat memo reuse + enumerate orbit-BFS). One latent bug found:
  `irred(49)` is reducible over F₇ (unreachable today, → C6). Three doc gaps ranked (D1
  automorphism-exhaustiveness lemma unwritten → C7; D2 fingerprint caveat → C8 + paper text;
  D3 crux-quantifier sentence → kernel text).
- **F4 (wrap/review of C-reports) → remaining.**

## Fable blocks (rest of day, in order)

- **F1. Paper math kernels (~2–3h).** Write the load-bearing mathematics paper-ready, one note
  per theorem: (a) sum-free Z_n theorem, (b) affine cap theorem, (c) the nofil corollaries —
  the AG(n,3) infinite-family statement and the PG(m,2)/mod-6 observation, with the convention
  equivalence proved carefully (the one place a silent error kills the paper), (d) conic
  localization + ψ_u lemmas in publishable form. These are the sections Opus must NOT draft.
- **F2. (ON) attempt, hard time-box 2–3h.** Armed with Szőnyi–Weiner stability / polynomial
  method inputs (O4 pulls the papers). Success = any partial lemma or a precise obstruction
  statement; failure mode to avoid = unbounded wandering. Written outcome either way.
- **F3. Soundness audit (~1–2h).** Adversarial pass over the chain a referee will probe:
  frame-chain hypotheses (sizes 1–4 single-orbit argument), resym exhaustiveness claim, the
  canon min-image invariance argument in the Rust solver, escape/feat-mode memo reuse. Verdict
  note with any holes ranked.
- **F4. Wrap.** Review sub outputs, t-done, final handoff updates, leave the post-Fable agenda
  (`2026-07-07-post-fable-agenda.md`) as the standing plan.

## Later windows (2 × 5hr remaining) — F4 + n=20 lucky-plan ramp

Added end of Fable session 2 (~19:00). Target: [n=20 lucky-first-win plan](2026-07-04-n20-lucky-first-win-plan.md).
**Box status (user-corrected 2026-07-07 evening): the queens G(17) run is DONE — G(17) = 2
VERIFIED** (recorded in the nimber handoff; G(18) remains). But the **sum-free z5 run
(`z3cubed-z5` lineage) is still running** and owns part of the box, so the ≤1 GB single-core
sub constraint HOLDS for both remaining windows. ~~Record the G(17) revalidation config/log
pointer in the nimber handoff when its pane is read back.~~ **DONE 2026-07-08**: the run is
recorded in claude session `08073bd4` (`asg +show 08073bd4`); pointer + verbatim round log
now in the nimber handoff. (Also stale by 2026-07-08: the z5 run was terminated without a
verdict — see the sumfree handoff — so the box constraint is lifted.)

### Window 2 (next 5hr)

- **W2-1. F4-lite (~30min):** read any landed C-reports (C3 gate is the blocker for O2's q=23
  campaign), mark queue entries, fold findings.
- **W2-2. P0a probe → Codex C10 (reassigned):** implement + run the
  border-signature census/valtest probe per **Appendix P0a** below. This is the n=20 plan's
  load-bearing unknown (does the border state compress to a small signature?) measured BEFORE
  building the full certificate extractor — a day of build effort gated on a hours-scale probe.
  Standard sub guardrails + exact-match gates (in the appendix).
- **W2-3. DONE (session 2): extractor design spec** written — `2026-07-07-central-child-certificate-spec.md`; build queued as C11 (gated on C10). Original scope: write the certificate extractor's
  soundness-critical design as a spec note ready for a window-3 build sub: the certification
  invariant ("paired core + border state", per the n20 plan's automatic-tau scope note), the
  exception-table format, the four opponent-move classes and their handlers, the endgame parity
  case (core-thin positions where live border cells decide who moves last — must be explicit in
  the coverage argument), terminal claims (S1 pairing / tau-symmetric leaf / dense exact leaf /
  solved leaf), and the small-n validation gates. This is convention-trap work — Fable only.
- **W2-4. Codex C9 (queued):** Lean statement-level scaffold for the tau-mirror + exception-table
  reply-book certificate format targeting `Queens.N20J10LuckyTarget` (extends
  `NodeKayles/Certificate.lean`'s reply-book kernel). Statement shape must match W2-3's spec.

### Window 3 (last 5hr)

- **W3-1. Calibration call (Fable):** read the P0a probe report. GO test = v1-signature count
  grows far slower than border-subset count at n=18 depth ≥ 3 AND valtest shows 0 (or structured,
  explainable) bucket violations at n ≤ 12. NO-GO = signatures ≈ subsets (no compression) or
  valtest violations are unstructured — then per the n20 plan §Phase 0, do NOT start n=20; write
  the redirect (improve certificate vocabulary on n=18) and stop the lucky-plan ramp.
- **W3-2. If GO: greenlight Codex C11 (extractor build)** (spec = the committed W2-3 note; calibrate on n ≤ 12
  gates in-window; the full n=18 I9 Phase-0 run continues past the window — overnight-safe,
  small-memory by design, checkpointed per exception-book growth).
- **W3-3. F4 full wrap:** review all C-reports (C1–C9), t-done, day-plan + n20-plan status
  updates, post-Fable agenda (`2026-07-07-post-fable-agenda.md`) as the standing plan, incl. the
  n=20 next step for whoever picks it up (Phase 0 completion criteria are in the n20 plan).

## Appendix P0a: border-signature census/valtest probe (for the W2-2 Opus sub)

Standalone single-file Rust probe (pattern: `2026-07-06-grid-cap-solver.rs`; `rustc -O`, no
crates needed, single-core, ≤1 GB). Board: flat n×n queens, central-diagonal strike
`c* = (n/2−1, n/2−1)` (I9 at n=18, J10 at n=20), residual `R_n`; `S = [0..n−3]²`,
`tau(x) = (n−3−x_r, n−3−x_c)` on live core cells, `L = row n−1 ∪ col n−1` (the two clique arms).
Opponent moves first in `R_n`.

- **Mode `census <n> <max-exchanges>`:** explore `R_n` under the FORCED-TAU rule — every
  opponent core move `x` with `tau(x)` live is answered `tau(x)` immediately (one reply, no
  branching); opponent border moves and scar moves (core `x` with `tau(x)` dead) branch fully;
  our replies to border/scar moves branch fully (this over-approximates any reply book's
  reachable set). Depth = number of non-mirror events (border moves + scar moves), capped at
  `max-exchanges` (run 2, 3, 4). At each reached state record: (a) the exact border live subset,
  (b) signature v0 = (row-arm live count, col-arm live count), (c) signature v1 = v0 + per-arm
  sorted multiset of live-border-cell core-incidence counts (# live core cells each live border
  cell attacks). Report per depth: #states, #distinct border subsets, #distinct v0, #distinct
  v1. Run n = 12, 14, 16, 18. **The compression hypothesis predicts #v1 ≪ #subsets, flattening
  with depth.**
- **Mode `valtest <n>`:** n ≤ 12 only. Exact memoized solver for residual positions (plain
  HashMap memo on the live-set bitboard, no symmetry needed; n=12 residual fits easily). For
  every state reached by `census` at ≤ 3 exchanges, bucket by (canonical scarred-core class,
  v1 signature) where the core class is the tau-folded live-core multiset — document the exact
  key — and report any bucket whose members have differing P/N values, verbatim. 0 violations =
  v1 is a sufficient exception-table index at small n (evidence, not proof — the extractor's
  soundness never rests on this; compression forecasting only).
- **Gates (must pass before any n=18 census is reported):** (1) the probe's own solver on the
  FULL board (empty position, no strike) reproduces the known outcomes for n = 4..9 — cross-check
  against `queens solve <n> naive` verdicts; (2) `valtest` at n=8: the probe's residual verdict
  for the central child matches the sign implied by the full-board solve + first-move search done
  by the probe itself (self-consistency); (3) census at n=12 with max-exchanges=0 must show
  exactly 1 state (all-mirror line, no events).
- **Guardrails:** no novelty/interpretation in the report — tables + violations verbatim; no
  n=20 runs; don't touch the queens tmux panes; report file
  `notes/2026-07-07-p0a-border-signature-report.md`.

## Opus subagent tasks (launch in background; Fable reviews outputs)

- **O1. Arc-data pull.** From the complete-arc classification literature (arXiv 1005.3412,
  1011.3347, 1312.2155 + JCD versions): extract for q = 23, 25, 27, 29, 31, 32 the complete-arc
  size spectra, odd-size counts, and data/code availability. Deliverable: a census note. No
  interpretation beyond tabulation.
- **O2. `esc23` subtree mode.** Implement per Fable's spec (appendix of this note): per-S₃
  escape solve with a private memo, no global arena. Validation gate: reproduce the q=17 and
  q=19 escape tables EXACTLY (5/10/11 histogram; 211 uniform). Dry-run only; the q=23 campaign
  waits for the box.
- **O3. LaTeX scaffold** for the sum-free + affine-cap paper: structure, bib (nofil, Sieben,
  Benesh–Ernst–Sieben, Anti-Set, Impartial SET, Lampis–Mitsou, capset refs), non-proof sections
  drafted from the notes, `\input` slots for F1 kernels.
- **O4. Related-work pulls:** Szőnyi–Weiner stability + Kim–Vu small arcs (for F2), and
  Benesh–Ernst–Sieben + saturation-games summaries (for the paper's related work). Summaries
  only — no novelty claims, no synthesis.

**Sub guardrails (bake into every prompt):** no novelty verdicts, no proof "simplifications",
no claim upgrades (computed ≠ proven), exact-match validation gates before reporting success,
report negatives verbatim, small-memory only, don't touch the queens tmux panes.

## Codex (user-driven, parallel)

Lean WP-1 (frame⇄grid bridge) via the named-expert persona protocol, then WP-2 (q-even theorem).
Optional third: statement-level scaffold for the conic localization lemma (vocabulary exists in
`ProjectiveCap/GridCounting.lean`; the Möbius/hyperbola normal form is new content).

## Appendix: esc23 spec (for O2)

New mode `esc <q> [class-index...]` in `2026-07-06-grid-cap-solver.rs`: enumerate canonical
size-3 classes (existing `enumerate`); for each, solve every size-4 child's subtree with the
existing `Solver::g` full-expansion recursion but a memo PRIVATE to the class (drop it after);
report the escape/bad line exactly as `escape` mode does, plus peak memo size. Per-class memo
keyed by the existing global canon (sound: it merges more, never less, within one subtree).
Memory bound: report and abort the class if the memo exceeds a `--cap` slot count. Accept a
class-index filter so the q=23 campaign can be resumed class-by-class.
