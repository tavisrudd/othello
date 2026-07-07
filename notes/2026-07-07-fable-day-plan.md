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
