# Codex task queue — delegated by Fable (2026-07-07)

Protocol: each task lists a **report file**. Codex does the work, writes findings to the report
file (create it; plain markdown; include verbatim commands/outputs for any machine check), and
leaves the queue entry below marked `[REPORTED <date>]`. Fable reads the report files at day-end
wrap. Do not edit other WIP notes; do not touch the queens tmux panes; box is RAM-constrained
(G(17) run) — keep any compute ≤1 GB, single-core.

## C1. Machine-check the Lemma-4 correction (sum-free Z_n mirror lemma) — PRIORITY [REPORTED 2026-07-07]

Context: `2026-07-04-sumfree-game-theorem.md` Lemma 4 (negation mirror with fixed extras) is
**false as stated**. Counterexample found by hand 2026-07-07: `n=12`, `t=n/3=4`, `E={t}`,
`C={4}` (S=∅), move `z=10`: `C∪{z}={4,10}` is sum-free and `z ∉ {0, n/2, t, 2t} = {0,6,4,8}`,
but the mirror reply `w=−z=2` gives `{2,4,10}` with `2+2=4` — not sum-free. The breaker family
is `z = t + n/2` (needs `n` even AND `n/2 ∉ E`; never reachable in the theorem's strategy, which
is why the reachable-position check missed it). Corrected hypothesis: add `z ≠ t + n/2`.

Task:
1. Exhaustive breaker search for the lemma AS STATED, over all `n ≡ 0 (mod 6)`, `n ≤ 120` (plus
   `n ≡ 3 (mod 6)` as control): all sum-free `C = E ∪ S`, `E ⊆ {n/2, t}`, `S = −S` (bound |S|
   by feasibility, document the bound), all legal `z ∉ {0, n/2, t, 2t}`; check `C ∪ {z, −z}`
   sum-free. Confirm: every breaker has `z = t + n/2` (and `E ∌ n/2`).
2. Re-run with the corrected hypothesis (`z ≠ t + n/2`): confirm 0 breakers.
3. Audit `2026-07-05-sumfree-abelian-theorem.md` for the analogous gap in its lifted lemma
   (the `r₃ ≤ 1` case reuses Lemmas 1–4 "verbatim" — does its statement inherit the same missing
   hypothesis? Does any abelian case use `E = {t}` with an order-2 element present?). Report
   what the note claims and whether it needs the same fix; do NOT rewrite the note.

Report file: `notes/2026-07-07-codex-lemma4-check.md`.

## C2. Lean statement scaffold — conic localization lemma (optional, after WP-1/WP-2) [REPORTED 2026-07-07]

Per the day plan's Codex section: statement-level scaffold only (no proof obligation) for the
conic localization lemma of `2026-07-07-conic-localization-onconic-escape.md` §1 — the unique
conic through the 5-arc, hyperbola normal form `(r−ρ)(c−A)=B`, the `q−4` on-conic legal
extensions, and the `ψ_u` involution. Vocabulary exists in `lean/ProjectiveCap/GridCounting.lean`;
the Möbius/hyperbola normal form is new content. A paper-ready prose version is being written in
parallel as `notes/2026-07-07-kernel-conic-localization.md` — match its statement decomposition
if it exists when you start.

Report file: `notes/2026-07-07-codex-conic-scaffold-report.md` (list of Lean names + file, what
is stated vs sorry-free vs deferred).

## C3. Discharge the esc-mode validation gate (q=17 + q=19)

O2 implemented the `esc` mode in `notes/2026-07-06-grid-cap-solver.rs` (uncommitted working
tree) and validated q=11/q=13 byte-identical to `escape` mode, but the mandated q=17/q=19
exact-match gate was interrupted at 6/21 q=17 classes (all matching so far). Everything needed —
build line, run commands, required-empty diffs against `2026-07-06-escape-q17.log` /
`-q19.log`, caveats — is in [O2's handoff](2026-07-07-esc23-o2-handoff.md). Run the gate to
completion (single-core, ~23 s/class at q=17, RSS ~80 MB — safe under the box constraint).
PASS = empty diffs on both q. Do NOT start any q=23 campaign.

Report file: `notes/2026-07-07-codex-esc-gate-report.md`.

## C4. Fill the arc-census paywalled gaps (q=23, q=25; q=31 full classification)

O1's census ([2026-07-07-arc-census-o1.md](2026-07-07-arc-census-o1.md)) fully sourced q=27/29
and all six minimum sizes, but the complete size spectra/counts for q=23 and q=25 live in
paywalled papers (Coolsaet–Sticker JCD 17 (2009); Marcugini et al. Discrete Math 307 (2007);
Faina et al. Ars Comb 47 (1997)), plus Coolsaet JCD 23 (2015) for the full q=31 classification
and Kéri JCD 14 (2006) for large-size counts. The note's GAPS section lists the exact (q, cell)
→ paper+table map. If you have library/alternate access, extract those tables into the census
note's format (append a `## C4 fill` section; tabulation only, per-claim citations, no
interpretation). If access also fails, record that and stop.

Report file: `notes/2026-07-07-codex-arc-census-fill.md`.

## Standing (unchanged)

WP-1 (frame⇄grid bridge) then WP-2 (q-even theorem) per
[named-expert personas](2026-07-07-named-expert-personas-context.md).
