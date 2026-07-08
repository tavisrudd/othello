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

## C18. ML feature attribution on the on-conic value moduli (GATED on C15's report)

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

## Standing

~~WP-1 (frame⇄grid bridge) then WP-2 (q-even theorem)~~ — **both DONE** (the q-even plane
theorem is unconditional: `PlaneOutcome.initialPStatement_of_even_card_finrank`). Current
proof-side context loads per [named-expert personas](2026-07-07-named-expert-personas-context.md);
projective status lives in `handoffs/2026-07-06-projective-cap-game-handoff.md` (session-10
block: order-5 and order-7 planes proven, dead-hypothesis routes guarded).
