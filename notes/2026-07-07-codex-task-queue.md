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

## C5. Test the PGL(2)-orbit value-invariance prediction (q=17 feat data)

Lemma I of [onconic intrusion calculus](2026-07-07-onconic-intrusion-calculus.md) predicts: two
on-conic size-4 positions whose 6-point parameter sets `{∞, 0, t₁, t₂, t₃, t₄} ⊂ P¹(F_17)` are
equivalent under the FULL `PGL(2,17)` must have equal game values. Test it against the q=17
`feat` data: regenerate the per-class per-extension `pos=on` value lines
(`2026-07-06-grid-cap-solver.rs` feat mode, q=17, ~minutes, small memory), reconstruct each
on-conic S₄'s parameter 6-subset (the conic reconstruction recipe is in
`2026-07-07-conic-localization-onconic-escape.md` §4), bucket the 6-subsets by
`PGL(2,17)`-canonical form (orbit of the 6-set under all Möbius maps; brute-force canonicalize —
|PGL(2,17)| = 4896, ≤ 273 subsets, trivial compute), and check value-constancy per bucket. Any
violation REFUTES Lemma I (report it verbatim — it would mean an error in the uniformization
argument); constancy + the bucket count is the payoff either way (how much the moduli collapse).

Report file: `notes/2026-07-07-codex-pgl2-orbit-check.md`.

## C6. Fix the latent GF(49) reducible-polynomial bug + field self-check (AFTER C3 completes)

F3 audit finding B1 (`2026-07-07-f3-soundness-audit.md`): `irred(49)` in
`2026-07-06-grid-cap-solver.rs` returns `x²+3` over F₇, which is REDUCIBLE (−3 ≡ 4 = 2² mod 7;
the comment tested `c` nonsquare instead of `−c`). Latent only — MAXW caps q ≤ 32 and a q=49
run panics on mask width first; no existing result touched. **Wait until your C3 gate is done
before editing the file** (don't rebuild under your own running gate). Then:
1. Replace the entry with `x²+1` over F₇ (irreducible: −1 nonsquare, 7 ≡ 3 mod 4); fix the
   comment.
2. Add a startup self-check in `GF::new`: assert no zero divisors / every nonzero element got
   an inverse (cheap O(q²) table scan), so any future bad `irred` entry fails loudly instead of
   silently computing over a ring.
3. Add an explicit `assert!(q * q <= 64 * MAXW, ...)` at `Board::new` entry with a clear
   message (today's failure mode is an index panic deep in `set_bit`).
4. Verify: rebuild, re-run one small validation (`escape 7` or the q=11 esc class 0) and
   confirm byte-identical output to before the edit.

Report file: `notes/2026-07-07-codex-gf49-fix.md`.

## C7. Machine-check + write up the automorphism-exhaustiveness lemma

F3 audit finding D1: the resym NO verdicts (q=11,13,17) rest on "the semilinear monomial
affine maps (both coordinate orders) are ALL automorphisms of the grid game hypergraph" —
true, but the proof is nowhere in the notes. Two deliverables:
1. **Prose lemma note** with the two-step argument (sketch in the audit note §2(b)): a
   legality-preserving cell bijection (i) preserves illegal pairs ⇒ rook's-graph automorphism
   ⇒ (row perm × col perm) ⋊ swap for q ≠ 4 (cite Aut(K_q□K_q)); (ii) preserves collinear
   triples with distinct rows/cols ⇒ collineation of AG(2,q) ⇒ monomial semilinear with a
   SINGLE field automorphism σ on both coordinates (show the σ ≠ τ twisted form breaks
   collinearity explicitly). Conclude: the `all_autos` enumeration is the full group.
2. **Brute-force check at q=5 (and q=7 if it fits the box budget):** enumerate all
   (row perm × col perm) ⋊ swap maps (2·(q!)² — 28,800 at q=5), filter those preserving the
   set of non-axis collinear triples, and confirm the survivors are EXACTLY the 2(q−1)²q²·e
   maps `all_autos` builds (compare as permutation sets, not counts). Single-core, tiny RAM.

Report file: `notes/2026-07-07-codex-autgroup-check.md`.

## C8. Exact-canon cross-validation of the fingerprint canon (q=11, q=13 + q=17 witnesses)

F3 audit finding D2: `canon()` is a 128-bit additive fingerprint (min over anchor images of a
sum-of-cell-hashes), not an exact canonical form — a collision would silently merge classes.
Collision odds are negligible and small-q class counts were validated, but the paper-grade
claims should rest on an explicit check:
1. Implement (or port from the Python `2026-07-06-grid-canon2.py` canon if it is exact) an
   EXACT canonical form: min over the same anchor images of the *sorted cell list itself*
   (lexicographic), no hashing.
2. For q=11 and q=13: recount all canonical classes per size (full expansion) under both keys;
   confirm identical counts per size. For q=17: re-canonicalize just the size-3 classes and
   each min-escape class's size-4 children under the exact key; confirm the escape histogram
   (5:3 10:12 11:6) is reproduced.
3. Report the counts verbatim; any mismatch is a MAJOR finding (report and stop — do not
   "fix").
Memory note: full q=13 expansion fits the ≤1 GB budget; q=17 full expansion does NOT — use the
esc-mode private-memo machinery for the q=17 step (class-by-class), or skip to size-3/size-4
re-canonicalization only.

Report file: `notes/2026-07-07-codex-exact-canon-check.md`.

## C9. Lean statement scaffold — tau-mirror + exception-table certificate format (n=20 lucky plan)

Statement-level only (no proof obligation), after WP-1/WP-2 and C1–C8 work. Target: the Phase-3
artifact format of [`2026-07-04-n20-lucky-first-win-plan.md`](2026-07-04-n20-lucky-first-win-plan.md)
— extend the reply-book kernel in `lean/NodeKayles/Certificate.lean` toward
`Queens.N20J10LuckyTarget`: a certificate datatype of (automatic tau rule on the paired core +
border/scar exception table + terminal claims: closed pairing / tau-symmetric leaf / solved
leaf) and a checker-statement `certificate valid → position is P`. Fable is writing the
extractor design spec in window 2 (day plan W2-3) — match its decomposition if it exists when
you start; otherwise state the pieces against the n20 plan's §Soundness-boundaries list.

Report file: `notes/2026-07-07-codex-cert-format-scaffold.md`.

## C10. P0a border-signature census/valtest probe (n=20 lucky plan, Phase 0a)

Implement + run the probe EXACTLY per **Appendix P0a of `2026-07-07-fable-day-plan.md`**
(spec is self-contained there: modes `census`/`valtest`, signature v0/v1 definitions, gates,
guardrails). Reassigned from Opus to Codex per the standing delegation rule. Single-core,
≤1 GB, no n=20 runs. Deliverable = the report file with the census tables (n=12,14,16,18) and
valtest violations verbatim. This gates C11.

Report file: `notes/2026-07-07-p0a-border-signature-report.md`.

## C11. Central-child certificate extractor build (GATED on C10)

Build per **`2026-07-07-central-child-certificate-spec.md`** (the soundness contract — do not
weaken any obligation; signatures organize, never certify; separate checker pass + mutation
gate). START ONLY IF C10's census shows #v1-signatures growing clearly slower than #border
subsets at n=18 (depth ≥ 3) AND valtest violations are zero or obviously structured; if the
result is ambiguous, STOP and wait for Fable's window-3 calibration call. Work the gates in
order (G1 n=6..12, G2 mutation, G3 n=18 I9 Phase 0); report compression stats per G3. The n=18
Phase-0 run may continue past your session — checkpoint the exception book.

Report file: `notes/2026-07-07-codex-cert-extractor-report.md`.

## Standing (unchanged)

WP-1 (frame⇄grid bridge) then WP-2 (q-even theorem) per
[named-expert personas](2026-07-07-named-expert-personas-context.md).
