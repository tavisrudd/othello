# Codex task queue — delegated by Fable (2026-07-07)

Protocol: each task lists a **report file**. Codex does the work, writes findings to the report
file (create it; plain markdown; include verbatim commands/outputs for any machine check), and
leaves the queue entry below marked `[REPORTED <date>]`. Fable reads the report files at day-end
wrap. Do not edit other WIP notes; do not touch the queens tmux panes.

**Box update 2026-07-07 evening:** the z5 run was killed and G(17) is done — the RAM/core
constraint is LIFTED. Compute up to ~8 GB / multi-core is fine; still no q ≥ 23 grid-cap
campaigns and no n=20 queens runs without an explicit gate.

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

## C3. Discharge the esc-mode validation gate (q=17 + q=19) [REPORTED 2026-07-07]

O2 implemented the `esc` mode in `notes/2026-07-06-grid-cap-solver.rs` (uncommitted working
tree) and validated q=11/q=13 byte-identical to `escape` mode, but the mandated q=17/q=19
exact-match gate was interrupted at 6/21 q=17 classes (all matching so far). Everything needed —
build line, run commands, required-empty diffs against `2026-07-06-escape-q17.log` /
`-q19.log`, caveats — is in [O2's handoff](2026-07-07-esc23-o2-handoff.md). Run the gate to
completion (single-core, ~23 s/class at q=17, RSS ~80 MB — safe under the box constraint).
PASS = empty diffs on both q. Do NOT start any q=23 campaign.

Report file: `notes/2026-07-07-codex-esc-gate-report.md`.

## C4. Fill the arc-census paywalled gaps (q=23, q=25; q=31 full classification) [REPORTED 2026-07-07]

O1's census ([2026-07-07-arc-census-o1.md](2026-07-07-arc-census-o1.md)) fully sourced q=27/29
and all six minimum sizes, but the complete size spectra/counts for q=23 and q=25 live in
paywalled papers (Coolsaet–Sticker JCD 17 (2009); Marcugini et al. Discrete Math 307 (2007);
Faina et al. Ars Comb 47 (1997)), plus Coolsaet JCD 23 (2015) for the full q=31 classification
and Kéri JCD 14 (2006) for large-size counts. The note's GAPS section lists the exact (q, cell)
→ paper+table map. If you have library/alternate access, extract those tables into the census
note's format (append a `## C4 fill` section; tabulation only, per-claim citations, no
interpretation). If access also fails, record that and stop.

Report file: `notes/2026-07-07-codex-arc-census-fill.md`.

## C5. Test the PGL(2)-orbit value-invariance prediction (q=17 feat data) [REPORTED 2026-07-07]

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

## C6. Fix the latent GF(49) reducible-polynomial bug + field self-check (AFTER C3 completes) [REPORTED 2026-07-07]

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

## C7. Machine-check + write up the automorphism-exhaustiveness lemma [REPORTED 2026-07-07]

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

## C8. Exact-canon cross-validation of the fingerprint canon (q=11, q=13 + q=17 witnesses) [REPORTED 2026-07-07]

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

## C9. Lean statement scaffold — tau-mirror + exception-table certificate format (n=20 lucky plan) [REPORTED 2026-07-07]

Statement-level only (no proof obligation), after WP-1/WP-2 and C1–C8 work. Target: the Phase-3
artifact format of [`2026-07-04-n20-lucky-first-win-plan.md`](2026-07-04-n20-lucky-first-win-plan.md)
— extend the reply-book kernel in `lean/NodeKayles/Certificate.lean` toward
`Queens.N20J10LuckyTarget`: a certificate datatype of (automatic tau rule on the paired core +
border/scar exception table + terminal claims: closed pairing / tau-symmetric leaf / solved
leaf) and a checker-statement `certificate valid → position is P`. Fable is writing the
extractor design spec in window 2 (day plan W2-3) — match its decomposition if it exists when
you start; otherwise state the pieces against the n20 plan's §Soundness-boundaries list.

Report file: `notes/2026-07-07-codex-cert-format-scaffold.md`.

## C10. P0a border-signature census/valtest probe (n=20 lucky plan, Phase 0a) [REPORTED 2026-07-07]

Implement + run the probe EXACTLY per **Appendix P0a of `2026-07-07-fable-day-plan.md`**
(spec is self-contained there: modes `census`/`valtest`, signature v0/v1 definitions, gates,
guardrails). Reassigned from Opus to Codex per the standing delegation rule. Single-core,
≤1 GB, no n=20 runs. Deliverable = the report file with the census tables (n=12,14,16,18) and
valtest violations verbatim. This gates C11.

Report file: `notes/2026-07-07-p0a-border-signature-report.md`.

## C11. Central-child certificate extractor build (GATED on C10) [NO-GO 2026-07-07]

Build per **`2026-07-07-central-child-certificate-spec.md`** (the soundness contract — do not
weaken any obligation; signatures organize, never certify; separate checker pass + mutation
gate). START ONLY IF C10's census shows #v1-signatures growing clearly slower than #border
subsets at n=18 (depth ≥ 3) AND valtest violations are zero or obviously structured; if the
result is ambiguous, STOP and wait for Fable's window-3 calibration call. Work the gates in
order (G1 n=6..12, G2 mutation, G3 n=18 I9 Phase 0); report compression stats per G3. The n=18
Phase-0 run may continue past your session — checkpoint the exception book.

NO-GO note: C10 found mixed-value valtest buckets at n=8/n=10, n=12 valtest exceeds the
original 1 GB cap, and n=18 has only a 10 GB diagnostic depth-2 row (no depth ≥3 evidence).
Do not start C11 from the current P0a data.

Report file: `notes/2026-07-07-codex-cert-extractor-report.md`.

## C12. Per-q escape certificate emitter — Rust `cert` mode (route C, phase 1) [REPORTED 2026-07-07 (opus delegate)]

Context: the odd-side Lean compositions are done and conditional only on
`OddEscapeGameStatement`/`OnConicEscapeStatement` (see `lean/ProjectiveCap/PlaneOutcome.lean`;
the parity/pairing hypotheses are marked FALSE-universally in-file — do not proof-search them).
Route C of `2026-07-07-projcap-open-math-plan.md` turns the computed ladder into formal per-q
theorems via certificates. Your C3 gate PASSED (esc mode validated q=17/q=19 per-class), so the
class-private subtree machinery is the trusted substrate; C8 validated the canon at the needed
scale; C5's PGL(2,17) collapse (273 on-conic children → 10 orbit buckets, value-constant) says
orbit-level books compress well.

Task — add a `cert` mode to `notes/2026-07-06-grid-cap-solver.rs` (single-core, ≤1 GB, q ≤ 13
first; q=17/19 only if the private-memo peak allows — C3 measured q=19 peak ~32.3M entries):
1. Per canonical size-3 class of GF(q): emit the class representative `S₃`, one witness escape
   cell `p` (prefer an ON-conic witness when one exists — record on/off), and a **P-certificate
   of `insert p S₃`**: a reply book mapping every legal move `x` from the size-4 position to a
   reply `y` such that the book is closed and terminals are even (the shape
   `FiniteBuildGame.PairReplyBook` / `PCert` expects — see `lean/CapGame/BuildGame.lean`; depth
   is bounded by max cap size, so a DAG book with explicit terminal parity rows is fine).
2. Output format: line-oriented plain text, one file per q (`notes/certs/gridcap-q<q>.cert`),
   self-describing header (q, class count, field poly for q=9), cells as `r,c` integers. Keep it
   trivially parseable — a Lean elaborator will consume it (WP-3); no serde, no JSON nesting.
3. Validate: an independent `certcheck` mode that re-verifies every book row against the game
   rules ONLY (no game values): legality of moves/replies, closure, terminal parity. Then
   cross-check per-class witness escape counts against the `esc`/`escape` histograms.
4. Report: format spec, per-q class/book/row counts, certcheck output verbatim, wall/RSS.

Do NOT start the Lean checker side (WP-3) — Fable is scoping it; the deliverable here is the
emitter + self-check + format spec for the checker to target.

Report file: `notes/2026-07-07-codex-cert-emitter-report.md`.

## C13. q=9 intrusion-structure probe (the next odd-plane Lean target)

Context: PG(2,5) and PG(2,7) are now Lean theorems via the intrusion calculus
(`lean/ProjectiveCap/IntrusionCalculus.lean`, commits `96746ab`/`ae1a346`): at q ≤ 7 no
off-conic intruder is ever legal above an on-conic S₄. At q = 9 intruders EXIST but the
intrusion note (§3 of `2026-07-07-onconic-intrusion-calculus.md`) predicts they are confined:
Lemma III(4) with c=6 gives `τ_x ≤ 2·τ_played − 2`, so only external points with BOTH
tangencies at played points can intrude, they lie on pairwise intersections of played tangent
lines, and after any such intrusion `M = 0` (the conic is dead) — the residual is a tiny
intruder-only game. Machine-check this structure exhaustively at q = 9 to pin the Lean proof
design (feat data already says every on-conic S₄ is P at q=9).

Task (Python or a private solver build; GF(9) tables exist in `2026-07-06-grid-cap-solver.rs`;
small compute):
1. For every conic (or one per symmetry class, state which) and every legal on-conic size-4
   position: enumerate ALL legal off-conic intruders x; record `(τ_x, τ_played)`; confirm the
   census matches the bound (no `(0,·)` or `(2,0/1)` types), and that each intruder kills the
   whole surviving conic (verify the exact kill-set σ_x(played) as in the note's verifier
   `2026-07-07-onconic-intrusion-check.py` — reuse/extend it if convenient).
2. For each intruded child, solve the residual game EXACTLY (it should be intruder-only and
   shallow): report max residual depth, max branching, and the outcome pattern; confirm every
   on-conic S₄ is P and identify WHY (does P2 always have a mirror/second intrusion reply, or
   does the intruder zone die immediately?).
3. Tabulate: #on-conic S₄ classes, #legal intruders per class, residual game sizes. The
   deliverable is the structure table a Lean `noIntrusionAboveFour`-style q=9 statement (or its
   replacement — the kernel is NOT no-intrusion at q=9) would need.

Report file: `notes/2026-07-07-codex-q9-intrusion-probe.md`.

## C14. WP-3 Lean certificate checker scaffold (GATED on C12's report existing)

Do NOT start until `notes/2026-07-07-codex-cert-emitter-report.md` exists (an Opus delegate is
building the emitter). Then: statement-level Lean scaffold for the route-C checker consuming
the C12 cert format — target `FiniteBuildGame.PairReplyBook`/`PCert` in
`lean/CapGame/BuildGame.lean`. Concretely: (1) a Lean datatype mirroring the C12 file format
(class rep, witness cell, reply-book rows); (2) a checker statement
`bookValid → GridGame.IsP (insert p S₃)` and the per-class assembly toward
`Almost.OddEscapeGameStatement (K := ZMod p)` for prime q (skip GF(9) in the scaffold; note
what it needs); (3) if cheap, an end-to-end q=5 instantiation attempt (the q=5 book is tiny) —
but statement-level for the rest is fine. Match the C2/C9 report style: names, proved vs
stated vs deferred, build transcript.

Report file: `notes/2026-07-07-codex-wp3-checker-scaffold.md`.

## C15. PGL(2,q) orbit-collapse census at q = 11, 13, 19 (extends C5)

Rerun your C5 methodology at q = 11, 13, 19: regenerate feat data, reconstruct each on-conic
S₄'s 6-point parameter set, bucket by PGL(2,q)-canonical form, check value-constancy per
bucket, and report raw-children → orbit-bucket collapse ratios per q. Purpose: (i) more
falsification pressure on Lemma I (any mixed-value bucket REFUTES it — report verbatim and
stop); (ii) the collapse ratio decides whether route-C certificate books (C12/C14) should be
emitted per-orbit instead of per-class (C5 saw 273 → 10 at q=17). Same guardrails as C5.

Report file: `notes/2026-07-07-codex-pgl2-orbit-census-q11-19.md`.

## C16. Sum-free Tactic 2 — induction on `r` (activated by the z5 kill)

The `Z3³×Z5` brute run was killed 2026-07-07 with no verdict (flat 1.07× redundancy at 106M
nodes — same compute-infeasible bucket as p=11; datapoint + rationale in
`handoffs/2026-07-05-sumfree-compute-parallel-codex.md`). The `r = 3` outcome now rests
entirely on your Tactic 2 lane: the monotone-resource law **"`Z3^r × Z_p` is N iff r = 1"**
(the proven r=1→r=2 mechanism: each extra `F₃` factor hands Bob one more `O₃` pair). Work the
induction step r → r+1 directly (the handoff's `--6` block has the structural facts: the win
is adaptive, backbone-less, obstruction on the `⟨socle-line⟩` fibers). Do NOT relaunch any
brute-force solve. Partial results welcome: even a clean statement of the induction invariant
that survives the known q=5-exception structure is progress — report what breaks if it breaks.

Report file: `notes/2026-07-07-codex-sumfree-induction-r.md`.

## C17. Anchored certificate family — the constructive `represents` bridge (route C, phase 2) [REPORTED 2026-07-08]

C14's scaffold is sound and its one open gap is the `GridOddEscapeBookCertificate.represents`
selector (canonical-class → every position). Fable's design decision: **replace full-canon
orbits by ANCHOR NORMALIZATION, which makes coverage true by construction** — no orbit
enumeration proof ever needed. Every size-3 grid cap `{p₁,p₂,p₃}` has `p₁,p₂` in distinct
rows AND columns (partial permutation), so the affine map
`φ(r,c) = ((r−r₁)·(r₂−r₁)⁻¹, (c−c₁)·(c₂−c₁)⁻¹)` — a translation composed with two axis
scalings, each a `GridSymmetry` in the proven `psi_gridSymmetry` sense — sends `p₁ ↦ (0,0)`,
`p₂ ↦ (1,1)`. So a book family indexed by the THIRD cell of anchored positions
`{(0,0),(1,1),(r,c)}` (~(q−2)(q−3) minus collinear/attacking, ≈ 70 at q=11) covers all
positions via `gridSymmetry_isP_image` transport. Task:
1. **Emitter**: add `cert --anchored <q>` to `notes/2026-07-06-grid-cap-solver.rs` — same
   book format, one CLASS per legal anchored S₃ (third-cell-indexed), certcheck must pass.
   Also print the anchored-class count per q (5,7,11,13 — skip 9/GF(9) for now).
2. **Lean data generator**: a script (any language) translating an anchored `.cert` into
   `lean/ProjectiveCap/CertData/Q<q>.lean` — `GridClassCert (ZMod q)` terms + `Valid` proofs.
   Validity obligations are small decidable props over `ZMod q`; try `by decide` per
   obligation first (NO `native_decide` — project trust policy). PROTOTYPE ON q=5 THEN q=7
   ONLY and measure elaboration wall time; report the per-class cost so Fable can go/no-go
   q=11. If kernel `decide` is too slow, report where it chokes (Move quantifier? AffineCap?)
   and STOP — do not brute-force.
3. (Statement-level, optional) The anchor-transport lemmas in Lean:
   `gridSymmetry` for translations/axis-scalings + the legality/IsP transport that turns an
   anchored family into `GridOddEscapeBookCertificate.represents`. Follow the
   `psi_gridSymmetry` proof shape in `ConicLocalization.lean`; statement-level is fine,
   proofs welcome.

Report file: `notes/2026-07-07-codex-anchored-cert-report.md`.

## C18. ML feature attribution on the on-conic value moduli (GATED on C15's report) [REPORTED 2026-07-08]

Do NOT start until `notes/2026-07-07-codex-pgl2-orbit-census-q11-19.md` exists — its per-q
orbit-bucket tables ARE the training data. Purpose: a disciplined, interpretable-models pass
over the (ON) value function to generate a falsifiable cross-q law candidate for the
two-plus-intruder residual (session-9 §6). This is the knot-theory template: train → attribute
→ extract candidate invariant → hand it to the proof lane. **Total compute budget: hard 8h
wall; phase 1 should be well under 1h.**

Phase 1 (the deliverable):
1. Build one table: every PGL-orbit bucket of on-conic S₄ 6-subsets `{∞,0,t₁..t₄}` for
   q ∈ {11,13,17,19} (from C15 + the C5 q=17 data), label = game value.
2. Feature dictionary — MUST include arithmetic-of-q features, not just configuration
   features (the character-law falsification in `2026-07-07-conic-localization-onconic-escape.md`
   §3.3 says configuration-only formulas are dead): cross-ratio invariants of the 6-subset;
   quadratic-character vector; tangency data; and the §6 order-theoretic features —
   `ord(σ σ')` in PGL(2,q) for canonical involution pairs fixing 2-subsets of the 6 points,
   gcd/divisibility of those orders against q−1 and q+1, internal/external type counts.
3. Models: decision trees (depth ≤ 3), sparse logistic/L1, small symbolic regression over the
   dictionary. **Protocol: fit on q ∈ {11,13}, test on {17,19} — NEVER fit on all four.**
   Also report the reverse split. Any candidate must correctly place the q=17 min-escape
   classes (onP=1) and the q ∈ {13,19} all-P columns.
4. Report: the table (verbatim), feature rankings, every candidate law with its held-out
   accuracy, and explicit falsifications. A null result ("no small law separates") is a
   valid deliverable — report it plainly.

Phase 2 (OPTIONAL, only inside the remaining budget): witness/reply priority heuristic from
the phase-1 features, then ONE q=23 size-3 class per-class escape probe with a 1h wall cap;
extrapolate total q=23 cost from that single class and STOP — report the projection, do not
run the campaign. If the single-class probe exceeds its 1h cap, kill it and report where it
was (this is itself the sizing datum).

Report file: `notes/2026-07-07-codex-ml-moduli-attribution.md`.

## C19. Verified boolean book-checker + reflection (route C, phase 3 — the C17 fix) [REPORTED 2026-07-08]

C17's STOP diagnosis is confirmed and the fix direction it proposed is approved: do NOT raise
`maxRecDepth`, do NOT use `native_decide`. Build the reflection route — a computable `Bool`
checker over concrete list data + a soundness theorem into C14's semantic layer, so per-class
validity proofs become `by decide` on `checker data = true` (ONE `Decidable Eq Bool` instance;
the kernel evaluates the checker — no typeclass search, no new axioms).

1. **Lean checker** (new file, e.g. `lean/ProjectiveCap/CertCheck.lean`): concrete cert data
   as `List`-based structures over `ZMod p` cells; `checkCap : List (GridPoint K) → Bool`
   (pairwise distinct rows/cols + no collinear triple), `checkMove`, and per-node closure by
   enumerating all q² cells (a `List.all` over the cell grid: if legal from the node, a row
   must match). Reflection theorems: `checkCap l = true → GridCap l.toFinset`, up to
   `checkBook c = true → GridClassCert.Valid c` (route through C17's
   `validFor_of_finiteRows` bridge). Soundness direction only (`= true → Prop`) is enough —
   no completeness needed.
2. **Generator v2**: update `notes/2026-07-07-anchored-cert-to-lean.py` to emit the list
   data + one-line `by decide` proofs per class into `lean/ProjectiveCap/CertData/Q<q>.lean`.
3. **Elaboration ladder with measurement**: q=5, then 7, then 11. Report per-q kernel-eval
   wall time. STOP if q=11 projects past ~30 min single file (split per-class files is an
   acceptable mitigation — report either way). q=13 only if q=11 is comfortable.
4. **Transport lemmas** (C17 part 3, still open): the anchor-normalization grid symmetries
   (translation + axis scalings, `psi_gridSymmetry` proof shape) and the
   legality/IsP transport assembling an anchored family into
   `GridOddEscapeBookCertificate.represents`. Statement-level minimum; proofs welcome.
   With 1–4 done, `OddEscapeGameStatement (ZMod 11)` — hence unconditional PG(2,11) via
   `initialPStatement_of_oddEscapeStatement_finrank` — is the assembly payoff.

Report file: `notes/2026-07-07-codex-certcheck-reflection.md`.

## C20. Winning-intrusion census on the on-conic buckets (intrusion calculus, attack option (i)) [REPORTED 2026-07-08; REVIEWED 2026-07-08 — SOUND]

C18's null (reviewed, sound) killed shallow laws over STATIC features of the 6-subset. The
surviving hypothesis (session-9 §6 of `2026-07-07-onconic-intrusion-calculus.md`) is that the
law lives in the game-labeled intruder census, which C18 never computed. Build it.

1. **Data:** for q ∈ {11, 13, 17} (q=19 optional if cheap), for one representative on-conic S₄
   per full-PGL orbit bucket (the C15 32-bucket table): enumerate ALL legal off-conic intruders
   `x`, and label each with the exact value of `S₄ + x` (P/N) by a private-memo subtree solve
   (pattern: the C13 q=9 probe / esc-mode `esc_g`; size-5 starts are small — the q=17 full
   size-3-class solves ran ~30s/class).
2. **Features per intruder:** `(τ_x, τ_played)` type, internal/external, `M = (q−11+τ_x)/2`
   parity, kill-set size. For each N-valued intruded child (mover-after-x wins), classify the
   winning replies: conic cell vs second intruder `x'`; for second-intruder winning replies
   record `ord(σ_x σ_{x'})` and its divisor class vs q−1 / q+1.
   **AMENDED 2026-07-08 (session 11, `2026-07-08-nk-involution-residual.md`): also compute,
   per reply state, the Node-Kayles DEFECT SPECTRUM** — the component path-length multiset of
   the union-matching graph on live conic params (free even cycles are Grundy-0, droppable),
   and the restricted-Grundy XOR (Dawson A002187 path values over the spectrum). Reference
   implementation: `spectrum`/`dawson_tables` in `2026-07-08-nk-involution-check.py`
   (machine-validated NK1–NK3). The upgraded question (a): does (defect-XOR, intruder-zone
   size/parity) decide the full-game value of the reply state? This is the leading
   hypothesis — test it FIRST.
   **SECOND AMENDMENT (session-11 addendum, q=11 spot-test done by Fable — do not redo
   q=11; extend to q=13, 17):** the necessity law `P ⇒ defXOR = 0 ∧ zone even` held
   381/381 at q=11, and the residual mixed bucket was fully explained by the zone conflict
   graph (empty-conic zone-2 endgame, 328/328). Your primary deliverables become:
   (a′) test the necessity law at q = 13 and 17 (any violation verbatim — it kills the
   joint-snapshot hypothesis); (b′) in the (defXOR=0, zone-even) bucket at q = 13/17 —
   where the conic will NOT be empty — hunt the discriminator among: zone conflict-graph
   NK value, zone size, conic path spectrum × zone coupling. Features to emit per state:
   defect spectrum, defXOR, zone size, zone conflict-edge count, zone conflict-graph NK
   Grundy (zones are small; exact NK on the snapshot is affordable).
3. **The discriminating questions (report tables + verdicts, null is a valid deliverable):**
   (a) does `(τ_x, τ_played, M parity)` alone decide P/N of `S₄+x` within a bucket? across
   buckets? across q? (b) if not, does the `ord(σ_x σ_{x'})` census decide it? (c) do the
   N-buckets of q = 11/17 differ from the P-buckets in their winning-intrusion profile in any
   way visible to these features? Per Lemma III(3), M-parity is position-independent given
   type — so (a) failing WITHIN a type is itself a sharp negative worth reporting verbatim.
4. **Gates before any q ≥ 11 report:** (i) reproduce the C13 q=9 census exactly (only
   `(τ_x, τ_played) = (2,2)` intruders; every intruded child has exactly one legal reply,
   terminal); (ii) per-bucket onP counts derived from your labels must match the C15/C5 feat
   data byte-for-byte where they overlap.
5. Budget: hard 8h wall; single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-intrusion-census.md`.

**Review (Fable, 2026-07-08): SOUND — the joint-snapshot necessity law is dead beyond q=11.**
All reported numbers reproduce from the raw states jsonl (violations 468 @ q13 / 3455 @ q17,
every table, the first counterexample verbatim). The review added the gate the amendment
removed: re-running the census script at q=11 against `/tmp/codex-feat11-c15.out` reproduces
Fable's session-11 ground truth exactly (0 necessity violations; slice zoneG=0 ⟺ P), so the
new defect/zone feature code is cross-validated and the q=13 counterexample stands. Findings
beyond the report + program consequences: projcap handoff session-block item 16. The
ord(σ_xσ_x') census (question 3b, deprioritized by the second amendment) was never analyzed,
but the per-state `order` field IS in the states jsonl — durable copy
`notes/data/c20-q13-q17-states.jsonl.gz` (feat-log inputs also in `notes/data/`;
regenerable in ~67s via the report's Main-run command).

## C21. q=23 esc single-class sizing probe (route D; C18 phase-2 leftover) [REPORTED 2026-07-08]

The esc-mode q=17/q=19 validation gate is DISCHARGED (C3) and the box is free (queens G(17)
done; sum-free z5 terminated). Size the q=23 campaign — do NOT run it.

1. Build the committed solver (`rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs`),
   report the q=23 canonical size-3 class count (enumeration is cheap).
2. Run `esc 23 --cap 200000000 0` (class 0 only) under a **1h wall cap**. If it completes,
   run further classes within the same hour. Report per-class escape/bad/peak-memo/wall
   verbatim, or where it died (cap vs timeout) — either outcome is the sizing datum.
3. Extrapolate the full q=23 per-class campaign cost (classes × per-class wall, peak memory)
   and STOP. The campaign itself is a user launch decision. Note in the report whether the
   extrapolated peak-memo fits the box without the global arena.
4. Motivation to carry in the report: a q=23 column adds a potentially MIXED-value training
   column for the moduli law hunt (mixed exists only at q = 11, 17 so far), and min-escape at
   q=23 is the live falsification watch (any class at 0 falsifies the conjecture).

Report file: `notes/2026-07-08-codex-esc23-sizing.md`.

## C22. Transport lemmas + represents assembly (route C, phase 4 — the C19 open half)

C19 is reviewed and sound (commit `cac2875`; axiom profile verified clean in review). What
remains for unconditional PG(2,11) is exactly C19's deferred item 4:

1. **Anchor-normalization grid symmetries:** every legal size-3 grid cap maps to its
   anchored form (first two cells ↦ `{(0,0),(1,1)}`) by an explicit translation + axis
   scalings composite; formalize these as grid-game symmetries (the `psi_gridSymmetry`
   proof shape; `gridSymmetry_isP_image` is already proven) with the partial-permutation
   argument that the scalings are nonzero.
2. **`represents` assembly:** the anchored family (the Q11 `CertData` classes) covers every
   size-3 position via 1's transport — discharge
   `GridOddEscapeBookCertificate.represents`, then assemble
   `OddEscapeGameStatement (ZMod 11)` and the payoff theorem via
   `initialPStatement_of_oddEscapeStatement_finrank` (unconditional PG(2,11)).
3. **Axiom gate:** `#print axioms` on the final PG(2,11) theorem must show only
   `[propext, Classical.choice, Quot.sound]` — include it verbatim in the report.
4. DONE 2026-07-08: the q=13 generator split + staged build landed.  Per-class files built
   far under the 30-min gate and the final theorem is
   `ProjectiveCap.Certificate.CertData.Q13.initialPStatement_finrank`.

Report file: `notes/2026-07-08-codex-transport-assembly.md`.

## C23. TEXT visualizations of winning cap-game lines, odd q (study artifact for the strategy hunt)

No cap-game line visualizations exist anywhere in the repo (queens has them; projcap has
none). Post-C20 the odd-q proof hunt is STRATEGY-level (response schemes, not snapshot
invariants) — so we want to *look at* optimal play. Text only: markdown with fenced
unicode/ASCII board diagrams (greppable, diffable, terminal-renderable). No HTML/SVG.

1. **Line extraction.** Reuse the exhaustive solver (`2026-07-05-proj-cap-fast.py`) and the
   C20 census machinery (`2026-07-08-intrusion-census.py`: legality, σ_x, spectrum, zone).
   Extract optimal (win-preserving) lines to terminal:
   (a) **The second-player defense from the empty board**, q ∈ {3, 5, 7, 9, 11}: for each
   first move up to symmetry (frame reduction makes this a short list), one optimal P-side
   reply line to the terminal maximal cap. This is the "defense book" we have never seen.
   (b) **q=11 N-bucket S4 winning-intrusion lines** (win only by intruding, session 11):
   the full line from the intrusion to terminal.
   (c) **q=17 winning intrusions**: one line per N bucket from the C20 representatives
   (feat logs + labeled data in `notes/data/`; the 28 winning first moves are in the jsonl).
2. **Rendering spec (per ply).** The anchored affine grid (q×q + the infinity row), one
   diagram per ply or per move-pair: conic cells `·`, first player's stones odd move
   numbers, second player's even, cells dead (kill-scars / cap-blocked) `x`, current
   intruder-zone cells marked. Alongside each diagram print the NK snapshot: defect
   spectrum, defXOR, zone size/parity, zone NK Grundy — so the picture and the C20 feature
   vocabulary can be read against each other.
3. **The analytical questions to eyeball (state observations, no proof burden):**
   (a) does the P-side defense visibly PAIR cells (mirror/involution structure — the thing
   every landed proof in this project used)? Same pairing across q or per-q ad hoc?
   (b) in the multi-intruder defense (q=11/17), what does the defense do to the zone —
   does it steer zone size back to the O(1) endgame regime where the session-11 laws hold?
   (c) do winning intrusion lines share a recognizable shape across buckets/q (tangency
   structure, σ-scar geometry)?
4. **Gates:** every printed line re-checked move-by-move by an independent legality checker
   (determinant-based, not the solver's own); terminal position verified maximal (no legal
   extension); line values must match the known verdicts (initial P for all q here; the
   S4-rooted lines must match the C20/C15 bucket labels).
5. Deliverables: the markdown study document + the committed generator script
   (deterministic, seeded choices documented). Budget: 4h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-winline-viz.md`.

## Standing

~~WP-1 (frame⇄grid bridge) then WP-2 (q-even theorem)~~ — **both DONE** (the q-even plane
theorem is unconditional: `PlaneOutcome.initialPStatement_of_even_card_finrank`). Current
proof-side context loads per [named-expert personas](2026-07-07-named-expert-personas-context.md);
projective status lives in `handoffs/2026-07-06-projective-cap-game-handoff.md` (session-10
block: order-5 and order-7 planes proven, dead-hypothesis routes guarded).

## C24. Binary projective nofil theorem in Lean: `PG(n,2)=P` for every `n ≥ 1` [REPORTED 2026-07-08]

Goal: close the whole q=2 projective column by proof, not computation.

Target theorem:

```lean
Projective.InitialPStatement (K := ZMod 2) (V := V)
```

from `[AddCommGroup V] [Module (ZMod 2) V] [Fintype V] [DecidableEq V]` and
`2 ≤ Module.finrank (ZMod 2) V`.  This is `PG(n,2)` for projective dimension
`n ≥ 1`; rank 1 / `PG(0,2)` is correctly excluded.

Proof route:

1. Prove the binary projective bridge: `Projectivization (ZMod 2) V` is equivalent to
   `{v : V // v ≠ 0}` via `p ↦ p.rep`; each projective point has a unique nonzero vector
   representative because `(ZMod 2)ˣ` is trivial.
2. Prove the validity bridge: projective caps over `ZMod 2` correspond to sum-free subsets
   of the nonzero vector model, since binary projective lines are exactly
   `{x, y, x + y}`.
3. Transport the game through the bridge. Reuse the already-proved sum-free theorem:
   `Sumfree.Game.initial_isP_of_at_least_two_nonzero_orderTwo` (or the rank wrapper
   `initial_isP_of_rank_count_P_cases`) supplies the strategy. Informal strategy: after
   P1 plays `a`, P2 chooses `b ≠ a`; `a+b` is blocked, and translation by `a+b` pairs the
   remaining live nonzero vectors. This is a non-linear board pairing, not a linear
   projective collineation.
4. Add a small nofil-facing corollary/note: the impartial shared nofil game on the projective
   binary STS family `STS(2^{n+1}-1)` is P for all `n ≥ 1`.

Prior-art guard: Clark--Mancini--Van Hook study a different game according to the accessible
abstract: partizan colored misere tic-tac-toe / avoidance, first player to complete a
monochromatic block loses. Verify the full paper before writing novelty language, but do not
cite it as covering impartial nofil.

Report: [`2026-07-08-codex-binary-projective-lean.md`](2026-07-08-codex-binary-projective-lean.md).
Lean status: **DONE** in `ProjectiveCap/Binary.lean`. Main theorem names:
`Projective.initialPStatement_binary_of_finrank_ge_two` and
`Projective.initialPStatement_binary_of_projectiveDim_ge_one`; support bridge:
`binaryPointEquivNonzero`, `binary_nonzeroValid_iff_cap`, and
`Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`.

## C25. Elliptic-involution theorem in Lean: `PG(2m−1,q)=P` for odd `q` [REPORTED 2026-07-08]

Goal: formalize the new closed projective family.

Semi-formal proof kernel: [`2026-07-08-projective-mirror-proof-kernels.md`](2026-07-08-projective-mirror-proof-kernels.md)
§2-§3.

Target theorem shape:

```lean
Projective.InitialPStatement (K := K) (V := V)
```

from `[Field K] [Fintype K] [DecidableEq K]`, `Odd (Fintype.card K)`, and
`Even (Module.finrank K V)` with positive even rank (`2 ≤ Module.finrank K V`), equivalently
`PG(2m−1,q)` for odd `q`.

Proof route:

1. **DONE 2026-07-08.** Add a reusable finite-building-game mirror theorem: if an involutive board equivalence `σ`
   preserves validity, has no fixed points, and the hypergraph legality condition is collineation-like
   as in projective caps, then the empty position is P. For projective caps the direct lemma should
   say: for any `σ`-invariant cap `S`, if `x` is legal then `σ x` is legal after `x`.
2. **DONE 2026-07-08.** Prove the projective cap mirror lemma for any fixed-point-free involutive collineation:
   lines through old-old pairs pull back under `σ`; the only extra case `x, σx, z` is killed by
   `σ`-invariance because `z, σz` are an old pair on the same invariant line.
3. **COORDINATE MODEL DONE 2026-07-08.** Construct the nonsplit involution. Pick a nonsquare `d ∈ K`; on `Fin 2 × Fin m → K` use block
   matrix `A(e_i)=f_i`, `A(f_i)=d e_i`, so `A²=dI`. The induced projective map has order 2 and no
   fixed points because a fixed point would give an eigenvalue `λ` with `λ²=d`.
4. **DONE 2026-07-08.** Transport from the coordinate even-rank model to an arbitrary `V` by `LinearEquiv.ofFinrankEq`.

Lean status: `lean/CapGame/Mirror.lean`, `lean/ProjectiveCap/Mirror.lean`, and
`lean/ProjectiveCap/EllipticMirror.lean` now check.  Important theorem names:
`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`,
`Projective.initialPStatement_of_linearEquiv_sq_scalar_nonsquare`,
`Projective.initialPStatement_ellipticBlock_of_nonsquare`, and
`Projective.initialPStatement_of_odd_card_finrank_eq_two_mul`.  Verification details are in
[`2026-07-08-codex-residual-mirror-lemma.md`](2026-07-08-codex-residual-mirror-lemma.md).

This supersedes the old false handoff claim that projective spaces never have fpf involutions.

## C26. Bibliography-grade novelty audit for projective Nofil/cap theorem [REPORTED 2026-07-08]

Goal: validate public wording for the claim that the odd-dimensional projective cap theorem is new
in the Nofil / impartial hypergraph-avoidance context.

Current conservative position, recorded in
[`2026-07-07-nofil-connection.md`](2026-07-07-nofil-connection.md): Nofil as a hypergraph game,
pairing strategies, and elliptic projective involutions are all prior art. What appears new is the
application to the 3-uniform collinearity-triple hypergraph of `PG(d,q)` for `q > 2`, especially
the theorem `PG(2m−1,q)=P` for odd `q` by a fixed-point-free projective collineation and
whole-board mirror.

Task:

1. Search MathSciNet/Zentralblatt/Google Scholar/arXiv for exact and variant phrases:
   `Nofil projective space`, `Nofil PG`, `projective cap game`, `cap avoidance game`,
   `impartial misere tic-tac-toe finite geometry`, `Notakto finite geometry`,
   `fixed-point-free involution projective game`, and `Steiner triple system Nofil projective`.
2. Retrieve/verify Clark--Mancini--Van Hook if accessible. Classify precisely whether it is
   partizan colored avoidance, impartial shared avoidance, or both; record whether it contains
   any theorem implying `PG(n,2)` nofil/cap is P.
3. Check HHS 2022 and the 2025 HHS follow-up for any projective-space family theorem beyond
   STS(7)/STS(9), vertex-transitivity `G ∈ {0,1}`, and graph-embedding/hardness.
4. Produce a citable wording recommendation with three tiers:
   "proved here", "standard ingredient", and "adjacent colored/positional-game prior art."

Report file: `notes/2026-07-08-codex-projective-nofil-novelty-audit.md`.

Status: report written. Recommended public wording is conservative: HHS owns the Nofil ruleset
and STS prior art; colored finite-geometry tic-tac-toe is adjacent but different; the apparently
new content is the projective-family outcome theorem in this impartial shared cap/Nofil game,
using standard projective involutions/pairing ingredients.

## C27. Correct residual mirror lemma for cap games [REPORTED 2026-07-08]

Goal: formalize the reusable mirror principle in the form that is actually sound for cap/Nofil
positions.

Semi-formal proof kernel: [`2026-07-08-projective-mirror-proof-kernels.md`](2026-07-08-projective-mirror-proof-kernels.md)
§1 and §6.

Adopted statement shape:

- `σ` is an involutive board equivalence preserving validity/collinearity.
- `S` is a valid position and `σ`-invariant.
- For every legal move `x` from `S`, `σ x ≠ x`, `σ x ∉ S`, and the **two-move extension**
  `S ∪ {x, σ x}` is valid.
- Then `S` is a P-position by replying to `x` with `σ x`.

Important non-statement: do **not** prove or use the weaker claim "legal moves are σ-invariant and
σ has no fixed legal point." That misses the mirror-chord obstruction: a selected point can lie on
the line `xσx`, making the reply illegal after `x` even though `σx` was legal before `x`.

Use cases:

1. Whole-board fixed-point-free collineation lemma for C25, where the chord obstruction is killed
   by `σ`-invariance: if `z ∈ S` lies on `xσx`, then `σz ∈ S` lies on the same line, so `x` was
   already illegal.
2. Characteristic-2 residual translation mirrors, where the chosen translation direction avoids
   the two burned directions and therefore `x,τx` never form a burned pair.
3. Any future fixed-locus-complement residual, but only after separately proving the pair-extension
   condition. "Fixed locus dead" alone is not a certificate.

Report file: `notes/2026-07-08-codex-residual-mirror-lemma.md`.

## C28. MirrorStep/MirrorClosed census and certificate-compression probe [REPORTED 2026-07-08]

Goal: measure whether the corrected residual mirror lemma is useful in the computed odd-plane
ladder, and prepare a terminal certificate rule for future Lean books.

Definitions:

- `MirrorStepGood(S,τ)`: `τ` is an involutive automorphism of the residual game, `S` is
  `τ`-invariant, and every legal move `x` satisfies `τx ≠ x`, `τx ∉ S`, and
  `S ∪ {x,τx}` is valid.
- `MirrorClosed(S,τ)`: every mirror-pair follower above `S` satisfies `MirrorStepGood`; this is the
  terminal P-certificate condition.
- `Obs_τ(S)`: legal moves `x` for which the mirror reply fails the pair-extension test. Geometric
  meaning: the mirror chord `xτx` hits selected/problem structure.

Task:

1. Add a diagnostic mode to the grid solver or a small standalone script that, for a residual
   position `S`, enumerates all residual-game involutions already supported by `all_autos` and
   reports whether any are one-step `MirrorStepGood`; if not, report the minimum `|Obs_τ(S)|` and
   the obstruction type histogram (burned row/col chord, ordinary collinear chord through selected
   point, fixed legal point). If `MirrorStepGood` holds, continue through mirror-pair followers to
   test `MirrorClosed`.
2. Run it on:
   - all canonical size-4 P escape witnesses for q=11 and q=13;
   - all P leaves/subtrees visited by the q=11 certificate book if cheap;
   - a sample of q=17 min-escape classes.
3. Report how many P followers can be closed immediately by a `MirrorClosed` certificate and how
   deep into the reply tree mirror leaves begin to appear.
4. If the hit rate is nontrivial, sketch the certificate format extension: a `PCert` leaf carrying
   `(τ, proof/check of MirrorClosed(S,τ))` instead of an explicit reply subtree.

Non-goal: do not restart the fixed-involution proof route for odd planes. This is certificate
compression and obstruction measurement only.

Report file: `notes/2026-07-08-codex-mirrorgood-census.md`.

Status: diagnostic mode `mir` added to `2026-07-06-grid-cap-solver.rs`.  Size-4 escape-layer
probe was negative: q=11 all P escape children, q=13 all P escape children, and q=17 min-escape
sample all had zero `MirrorStepGood` hits.  Keep `MirrorClosed` as a formal/deep-leaf tool, not as
an immediate size-4 certificate compressor.

## C29. Mixed-column mod-3 law + inverted bucket census at q = 23, 25, 29, 31 [REPORTED 2026-07-08]

Context: C18's null killed bucket-level laws over static features, but it never isolated the
COLUMN-level existence question "does q admit any N-valued on-conic bucket at all". On that
coarser question the data is clean: among unconfined-intruder columns (q ≥ 11), the mixed
columns are exactly `q ≡ 2 (mod 3)` — q = 11, 17 mixed; q = 13, 19 all-P (C15/C20 tables).
Arithmetic meaning: `3 | q+1` ⟺ order-3 elements of PGL(2,q) are elliptic (fixed-point-free
on P¹) ⟺ order-3 products `σ_x σ_x'` sit in free C₆ cycles of the Lemma-VI spectrum
(Grundy-dead by Cor. VII); for `3 | q−1` they are split (two fixed points on P¹) and surface
as tangency-ended path defects carrying nonzero Dawson values. Four data points = a
conjecture generator, nothing more; the predictions are the content: q=23 mixed, q=25 all-P,
q=29 mixed, q=31 all-P. char-3 columns (q=9, 27) are their own regime (q=9 is all-P by
intruder confinement, C13). Any miss REFUTES the law — report verbatim either way; a
refutation is a full-value deliverable.

1. **Mechanism check on EXISTING data first (no game compute):** the per-state `ord(σ_xσ_x')`
   field in `notes/data/c20-q13-q17-states.jsonl.gz` is unanalyzed (C20 review, handoff item
   16). q=17 has elliptic order-3 products (3 | 18), q=13 split (3 | 12). Tabulate ord=3
   occurrences × spectrum component type (free C₆ cycle vs tangency-ended path) ×
   reply-state P/N, per q. Report the table regardless of what the census finds.
2. **Invert the census pipeline so new q are cheap:** bucket FIRST (enumerate on-conic S₄
   parameter 6-subsets up to PGL(2,q) — pure group theory, no solves; C15 recipe), then solve
   ONE representative per bucket (S₄-rooted private-memo solve — orders of magnitude smaller
   than C21's size-3-rooted esc solves; do NOT rerun those). Solve 2–3 extra members of any
   N bucket found, so Lemma I keeps taking falsification pressure instead of being assumed.
3. **Gate before any new q:** rerun the inverted pipeline at q=17 and confirm bucket count
   (10) and labels (5 P / 5 N) byte-identical to the C15/C20 tables.
4. **Sizing gate at q=23:** one S₄-rooted solve under a 30-min wall cap; if exceeded, kill it
   and report where it was — that IS the sizing datum; stop the census.
5. Then q = 25, 29, 31 in that order within budget (GF(25) uses the C6-fixed irred entries;
   the `GF::new` self-check must pass); q=27 optional, flagged as char-3 regime.
6. Report: per-q bucket tables verbatim, the column-law verdict per q, the ord=3 mechanism
   table, and — if any column refutes — the counterexample bucket + representative verbatim.

Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-mod3-column-law.md`.

Status: the mod-3 column law was refuted at q=23.  The bucket-first pipeline validated q=17
against C15/C20 (10 buckets, 5 P / 5 N), then solved all 22 full-PGL on-conic q=23 buckets; every
bucket was P.  q=23 is therefore not a mixed-column case despite `23 == 2 mod 3`.  The report stops
there rather than spending time on q=25/29/31; the next proof-direction task is C31 zone steering,
not further residue-class speculation.

## C30. Route C phase 5 — certificate books for q = 17 and q = 19

Context: the status-table gap "cert book unbuilt" for q=17/19 is pure engineering now — every
feasibility gate is measured: the emitter's private-memo peak fits (C3: q=19 ≈ 32.3M entries),
every q=17 class has escapes (min-escape histogram 5:3 10:12 11:6), C19's reflected checker +
obligation splitting beat the elaboration wall, and C22's transport assembly generalizes over
prime q. Mixed buckets are irrelevant here — books certify size-3 escapes, not the uniform
mechanism. Payoff: the whole computed prime ladder ≤ 19 becomes unconditional in Lean.
Expected anchored class counts: (q−2)(q−3) = 210 at q=17, 272 at q=19 (matches 72/110 at
q=11/13).

1. **Prerequisite — the q=13 staged build: DONE 2026-07-08.**  The split Q13 cert data +
   assembly (`2026-07-08-q13-split-to-lean.py`) built with `nix_lake_build_each` (class leaves
   first, aggregate last), and the final axiom gate is `[propext, Classical.choice,
   Quot.sound]`.  Its per-class-file layout is the template for q=17/19 scale.  Keep the
   CLAUDE.md OOM note: the naive aggregate build OOM'd the box.
2. Emit anchored books for q=17 and q=19 (`cert --anchored`); certcheck PASS mandatory;
   cross-check per-class witness escape counts against the esc histograms.
3. Generate per-class Lean files from the start (generalize the q=13 splitter). Measure
   per-class elaboration on the first ~5 classes and extrapolate; STOP and report if any
   single file projects past the 30-min gate or a per-q total projects past ~10 h — the full
   build at that scale is a user launch decision.
4. Assembly per q: `OddEscapeGameStatement (ZMod 17)` / `(ZMod 19)` →
   `initialPStatement_finrank`; `#print axioms` verbatim, must be
   `[propext, Classical.choice, Quot.sound]` only.
5. Optional if trivial: q=3 (closes the last small prime row). q=9 stays OUT OF SCOPE here
   (GF(9) ≠ `ZMod`; the intruder terminal-reply kernel `218b1ac` is the better lane for it).

Report file: `notes/2026-07-08-codex-route-c-phase5.md`.

## C31. Zone-steering ceiling census (the C20 review's surviving proof shape, made precise) [REPORTED 2026-07-08]

Context: the C20 review's structural reading is that the session-11 snapshot laws hold exactly
while the intruder zone is an O(1) endgame (max zone 2 at q=11 vs 10 at q=13 / 38 at q=17), and
C23 §3(b) asks "does the defense steer the zone back to the small regime?" as an eyeball
question only. Make it a machine-checked quantity. If P2 can *hold* the zone below a small
uniform bound, the proof shape becomes "steering lemma + the small-zone endgame law as
terminal certificate" — the only role the dead snapshot laws validly play. If no bound
exists, that kills the steering picture before proof effort goes in. Either verdict is the
deliverable.

1. **The right object is recursive, not one-ply:** define the steering ceiling
   `Z(S)` for a P-state `S` = 0 if the mover is stuck, else
   `max over opponent moves m of min over winning (P) replies r of max(zone(S+m+r), Z(S+m+r))`
   — the zone size P2 can guarantee never exceeding from `S` under optimal steering. A
   one-ply census can mislead (small now, forced large later); subtrees above size-6 states
   are shallow, so the full recursion is affordable.
2. **Data:** the C20 reply states (`notes/data/c20-q13-q17-states.jsonl.gz`, regenerable
   ~67s), q=13 first, then q=17. Compute `Z(S)` for every P reply-state; solves are
   private-memo, size ≥ 6-rooted (much smaller than the C20 size-5 solves).
3. **Gates:** child P/N labels must reproduce the C20 parent labels where they overlap;
   spot-check ≥ 10 `Z` values by an independent hand-rolled minimax on the smallest states.
4. **Report:** the distribution of `Z` over P reply-states per q (verbatim table); the law
   candidate `Z ≤ B` with the smallest B that holds, or the counterexample state where every
   winning reply blows the zone (verbatim, with its defect spectrum + zone features); zone
   trajectories along one optimal line per bucket, cross-referenced against the C23 diagrams.
5. Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-zone-steering-census.md`.

Status: positive for the steering route through q=17.  Reconstructed C20 P reply-states gave
recursive ceilings `max Z = 2` at q=13 and `max Z = 9` at q=17, despite initial off-conic zones up
to 10 and 38 respectively.  Independent outcome+Z recursion spot-checked 10 states at q=13 and
10 states at q=17.  This keeps the dynamic "steering lemma + bounded-zone terminal law" proof shape
alive; the next math target is to state/prove the bounded-zone family rather than hunt another
static feature law.

Follow-up 2026-07-08: `notes/2026-07-08-codex-zone-descent-target.md` sharpens this.  For every
tested C20 P reply-state at q=13/q=17 and every legal opponent move, a score-optimal winning reply
lands in a grandchild with `Z <= 2`.  At q=17 the `max Z = 9` ceiling is an immediate-zone cost, not
persistent recursion.  The proof target should be a one-pair descent/repair lemma plus a small-zone
`Z <= 2` base law.

Repair-mining follow-up 2026-07-08: `notes/2026-07-08-codex-zone-descent-repair-mining.md` and
`notes/2026-07-08-zone-descent-miner.py` show that q=17's score-9 repairs are all intruder ->
intruder replies that empty the conic residual and leave `defxor = 0`, zone Grundy 0.  The next
math target should be a repair-intruder existence lemma plus the empty-conic/small-Z base law.

Geometry follow-up 2026-07-08: `notes/2026-07-08-codex-zone-repair-geometry.md` and
`notes/2026-07-08-zone-repair-geometry.py` sharpen the worst case: every q=17 score-9 repair has
one live conic parameter before the reply, and the selected reply is the unique legal internal
intruder that kills that last live parameter and leaves a clean P-valued empty-conic state.  The
same guard intruder answers both score-9 opponent moves from a state and is already legal/internal
before those moves.  No single line-type/product-order rule explains the repair.

Follow-up checks: replacing the argmin by "legal internal conic-emptying P reply" works for all
28 score-9 transitions but fails outside that stratum.  The polarity guesses are false
(guard-on-live-polar, guard-as-chord-pole, and live-as-opponent-tangency are all 0/28).  The 14
score-9 states form only two conic-preserving `PGL(2,17)` orbits, even after adding the guard and
the two worst opponent moves, so this layer is a finite-certificate target.

q=19 extension 2026-07-08: `notes/2026-07-08-codex-q19-q25-mining.md` extends the C20/C31
pipeline.  The C20 miner now supports bucket-level `--jobs`; q=19 has 13/13 P buckets, all 1747
legal first intrusions are N-valued, and recursive steering over 63,479 unique P reply states gives
`max Z = 16` with raw zones up to 57.  Durable data: `notes/data/c20-q19.json`,
`notes/data/c20-q19-states.jsonl.gz`, and `notes/data/c31-q19.json`.  The same report adds a Rust
`s4` sizing mode; q=25's first normalized representative is P but takes about 26.3M private memo
entries, so GF(25) broad mining needs a dedicated prime-power path.

## C32. Composite-mirror stuck-free probe — plane variant first, then PG(4,3) (v2)

**READ FIRST: [`2026-07-08-evendim-composite-mirror-design.md`](2026-07-08-evendim-composite-mirror-design.md)**
— the v2 design analysis. It corrects the v1 spec (translations are NOT involutions for odd
q — order p; the affine component is FORCED to be point-reflection/tower shape since no fpf
affine involution exists on the odd-count affine part), derives the poison structure (a
selected `h ∈ H` poisons the pencil line through the center `c` in direction `h`; ρ-invariance
of `S ∩ H` makes poisoned pencils come in ρ-pairs), and specifies the **double-pencil-burn
exception rule** (first entry into the `h`-pencil is answered in the `ρh`-pencil; both lines
die whole — even, σ-invariant removal). H-internal soundness is C25 restricted to H. What
remains open is a finite list of LOCAL escape-like obligations (design note §4), chiefly
exception-cell existence — the probe measures exactly those.

Context: with `PG(2m−1,q)` closed (C25) and even q closed, the open boards are the odd-q even
dimensions: planes AND `PG(2m,q)`, m ≥ 2 (the latter in no plan before this). Both have odd
point count and no fpf collineation involution (R0), so the composite (elliptic `ρ` on a
hyperplane `H` + adaptive point reflection `σ_c` on the affine complement + double-burn
exceptions) is the natural — and per the design note, essentially forced — mirror shape. The
**plane variant is genuinely untried**: the 2026-07-05 σ_c failure was post-frame-reduction
(burned opening pair, partial-permutation row/col constraints); this composite never burns an
opening pair (P2 seeds `c` with its own reply, midpoint trick) and `|S ∩ ℓ| ≤ 2` caps the
poison at two pencils. If ANY candidate verifies stuck-free at PG(4,3), that is a theorem
candidate for ALL even dimensions at odd q; if the plane variant verifies at q = 11/13, it is
a candidate uniform odd-plane mechanism. A failure's obstruction histogram is the C28 `Obs`
methodology in the sharper pencil vocabulary. Cheap compute either way.

1. **Plane first (q = 9, 11, 13):** implement the composite as a P2 POLICY (bulk mirror +
   seed rule + ℓ-reply rule + double-burn exceptions + adaptive `ℓ`/`c`/`h'` choices — design
   note §7), verify stuck-freeness against ALL P1 play. Ground truth is known (all P), so a
   failure is an exact counterexample trace. **Mandatory reporting: the diff against
   `2026-07-05-qodd-central-symmetry-findings.md`** — what the grid σ_c patch lacked that
   this has, and whether the failure (if any) is the same mechanism.
2. **Then PG(4,3)** (121 points, max cap 20): same policy with `ρ` = C25's elliptic involution
   on `H ≅ PG(3,3)`, verified fpf + involutive by enumeration. Memoize on reachable
   positions; **sizing gate:** abort + report if reachable distinct positions exceed ~10⁸ or
   wall exceeds 2h per candidate — partial verification is NOT a proof, say so plainly.
3. **Candidate family (document each precisely):** (i) point-reflection composite +
   double-burn (primary); (ii) reflection towers (design note §1 — per-level confined chord
   directions, per-level self-blocking); (iii) variations of the adaptive choices and
   exception-cell selection heuristics. Add better candidates if the failures suggest them —
   record all.
4. **Report per candidate:** stuck-free verdict; obligation failures (design note §4) as
   first-class outcomes with the obstruction histogram by type (poisoned-pencil entry with no
   legal exception cell, ℓ/H-reply nonexistence, seed failure, in-H chord, invariance break)
   + the minimal failing line verbatim; if ANY candidate is stuck-free, the full strategy
   spec + the proof-kernel sketch in the C27 pair-extension vocabulary (do NOT start Lean —
   that would be its own task).
5. Cross-checks: point/line counts against closed forms; the cap checker against an
   independent rank-based collinearity test; plane runs cross-checked against the solved
   ladder values.
6. Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-evendim-composite-mirror.md`.
