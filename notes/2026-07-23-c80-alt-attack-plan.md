# C80 — alt-attack plan (cold-start execution guide)

**Lane:** `cap`. **Date:** 2026-07-23. Owner task: **C80** (spine). This is a planning document,
not a state map; the live map is the [cap handoff](handoffs/2026-07-06-projective-cap-game-handoff.md).

## For the cold agent — read this first

You are picking up C80, the odd-`q` all-P kernel spine. Before touching anything, read the cap handoff
(`§ Conic Localization`, `§ Intrusion / Defect Program`, `§ C80 in the odd-q proof program`) and the
C80 report `2026-07-12-c80-bulk-exhaustion-probe.md`. The objective is unchanged:

> **(ON):** every size-3 residual grid position has a P-valued on-conic size-4 child.
> Equivalently C80(b): prove **bulk descent** into a proven-P packet (the `Y_NK0` guard).

**What is settled (do not re-run):**

- **C80(c) drain is proven+verified:** selecting a live conic point `t` deletes exactly `1+k_t` live
  conic points; `|L(S)|` is a well-founded decreasing measure but carries **no value**. Report +
  verifier `rust/scripts/c80_drain_rate.py`.
- **C80's exact P guard `Y_NK0`:** empty conic + capacity-2 lines + load-one conflict graph Grundy-0
  ⟹ Node-Kayles ⟹ P. Covers only 2,822 / 59,153 q17 three-intruder transitions; **rejects 108 q17
  `clean_empty` members (104 P, 4 N)** — the "missing triple semantics." This gap is Route 3.
- **A5 selector (measured, unproved):** the P on-conic child is the **smallest `Stab(frame)`-orbit** =
  largest point-stabilizer = most symmetric completion (q=11/13/17/19: 8/8, 12/12, 21/21, 27/27; 0
  N-singletons). The obvious mechanism ("P ⟺ point-stab has a mirror involution") is **refuted**
  (inverted across q=11 vs q=17). Report `2026-07-10-a5-symmetric-completion-anchor.md`.
- **Character routes are CLOSED (this session, 2026-07-23):**
  - depth-recursion of C496's `value = 1_live ⊗ χ(u)` — NOT stable; the factorization is a depth-0
    base fact, scaffold exists only at the size-4 escape layer
    (`2026-07-23-c496-recursion-stability-probe.md`);
  - escape-family generalization of `χ` — NO character law: no quadratic character of the 6-arc
    invariants (incl. the full-PGL cross-ratio / C520 discriminant) separates P/N at the mixed orders
    q=11, q=17 (`2026-07-23-c496-escape-family-character-probe.md`).

**Therefore:** stop hunting static P/N classifiers. All four routes below treat value as a
**dynamic / game-structural** object. Run them **cheap-first**; each cheap route can yield the descent
lemma outright, so do not commit to the heavy Route 1 before Routes 2 and 3 are attempted.

**Before starting a route:** reserve one C-ID via
`python3 notes/scripts/allocate_codex_task_ids.py reserve` and peg it `[cap]`; these routes are
**not yet allocated**. Do not reserve all four up front — reserve when you start one. Every
computational claim follows `notes/research-reproducibility-conventions.md` (report + script +
`--check` certificate + hashed inputs), the pattern used by both 2026-07-23 probes.

## Shared infrastructure (all routes)

- **Game engine:** `notes/2026-07-08-intrusion-census.py` — `PrimeGridGame(q)` (exact memoized minimax
  `value`; `value=False`⟺P, `True`⟺N), `legal_mask`, `conic_cell`/`conic_mask`/`is_conic_cell`,
  `sigma`/`sigma_perm` (the conic involution `σ_x`), `spectrum`, `dawson_xor`, `zone_graph`,
  `nk_grundy`, `state_features` (returns `spectrum`, `defxor`, `zone_size`, `zone_edges`,
  `zone_grundy`). `analyze_bucket` walks all intruder children and reply states.
- **Frozen escape census** (size-4 on-conic bucket → exact P/N): `notes/data/c68b-onconic-buckets-q{11,13,17,19}.txt`.
- **Frozen reply-state census** (per (root, opponent x, reply y): value + features): JSON
  `notes/data/c20-q13-q17.json`, `c20-q19.json`; per-state JSONL `c20-q13-q17-states.jsonl.gz`,
  `c20-q19-states.jsonl.gz`. State fields include `x_child_value`, `reply_state_value`,
  `winning_reply`, `y_kind`, `order`, `spectrum`, `defxor`, `zone_size`, `zone_grundy`, `kill_size`.
- **Feat logs** (size-3 class → on-conic extension values): `notes/data/codex-feat{11,13,17,19}*.out`,
  parsed by `intrusion-census.parse_logs`.
- **s4arena / s4mine tooling** for deeper/larger runs: manual `2026-07-08-s4-memo-dump-query-manual.md`.

---

## Route 3 (cheapest, most concrete) — descent into the `Y_NK0` guard

**RUN — C522, 2026-07-23. Verdict: `Y_NK0` is NOT a complete bulk-descent certificate.** Asked at
the child level over ALL legal replies, 9.3% of q17 three-intruder children (4,697 / 50,517) have
no `Y_NK0` reply (q13: 4 / 1,287); all are responder wins. 89% of the gap cannot reach an empty
conic in one move, so the companion guard must be a **single-live-parameter** law, not a second
empty-conic packet. See [`2026-07-23-c522-ynk0-descent-completeness.md`](2026-07-23-c522-ynk0-descent-completeness.md).
The successor is to build that single-live-parameter P-guard (reserve a new `[cap]` C-ID). The
original objective below is retained for provenance.

**Objective.** Prove bulk descent: from an arbitrary member of the marked packet, a responder move
reaches a `Y_NK0` state (proven P). Characterize the finite obstruction where it fails.

**Method.** Combinatorial-game exchange/pairing lemma into a proven base predicate — no new invariant.

**Steps.**
1. Reproduce the frozen q17 census exactly (as C497 did: 59,153 / 17,954 / 3,048) via
   `analyze_bucket` on the q17 feat log; isolate the **108 `clean_empty` members `Y_NK0` rejects**
   (104 P, 4 N).
2. Classify the **4 N exceptions** under `PGL(2,17)`: their orbit count, the triple-configuration
   (three-intruder incidence) that flips them N, and whether they share a bounded obstruction.
3. For the 104 P `clean_empty` members, search for a **single responder move** that lands in `Y_NK0`
   (empty conic, load-one, Grundy-0). If one always exists, that is the exchange lemma; state it as a
   move existence + `Y_NK0` closure theorem.
4. If a uniform move fails, refine the guard: identify the exact triple-term that `Y_NK0` omits
   (C497 warns the full marked residual state — including selected conic content — is required; the
   centre configuration alone is provably insufficient).

**Cheap probe / gate.** The 4 N exceptions are a finite, fully-specified object — classify them in
one pass. If they collapse to a small bounded family, the theorem is "descent into `Y_NK0` except a
bounded obstruction set," which feeds C82 directly.

**Output.** `Y_NK0`-descent lemma (or the exact refined guard) + the N-exception classification.
**Risk:** the triple semantics may need full-state data (C497). **Confidence:** medium-high.

---

## Route 2 (cheap) — solve the reduced 1-D involution game on `P¹`

**Objective.** Give the abstract conic-parameter-line game its own Sprague-Grundy theory and show the
grid game inherits value by the established transport.

**Method.** Impartial combinatorial game theory on `P¹(F_q)` + involutions, geometry discarded.

**Steps.**
1. From `2026-07-07-onconic-intrusion-calculus.md` and `2026-07-08-nk-involution-residual.md`, extract
   the exact reduced game: points on `P¹(F_q)`; each off-conic center `x` contributes the involution
   `σ_x` (already in the engine, `PrimeGridGame.sigma`); conic-restricted play is Node-Kayles on the
   union of involution matchings; even cycles are Grundy-0.
2. Implement the abstract game standalone (state = live parameter set + active involutions) and
   **exhaustively Grundy-solve** it for q ≤ 19.
3. Compare its value to the grid census (`c68b` + reply-state JSONL). If they agree, the descent
   lemma is a **CGT statement** (misère/normal Grundy of an involution-Node-Kayles game), not a
   geometric one — attack it with standard CGT (Grundy values, misère quotients, cycle/path
   decomposition already in `spectrum`/`dawson_xor`).

**Cheap probe / gate.** The abstract game is tiny; solve q ≤ 19 in minutes. The decisive check is
whether "even cycles cancel + defect skeletons" **fully** reproduces value or leaks (the `Y_NK0`
triple gap suggests a residual three-body term — quantify it here).

**Output.** Grundy theory of the reduced game + a faithfulness certificate vs the grid census.
**Risk:** faithfulness — the reduction may drop a triple term. **Confidence:** high value if faithful.

---

## Route 1 (heaviest, highest ceiling) — amortized potential / Lyapunov

**Objective.** A responder-controlled potential `Φ(S)` with: (a) a legal responder move keeps `Φ` in a
P-certifying band; (b) `Φ`-in-band ⟹ P. This is the C61-successor amortized-selector lane, sharpened.

**Method.** Combinatorial-game potential theory. `Φ` = termination term (C80(c) drain `|L|`) + a
**Grundy/deficiency** value term (NOT arithmetic — the character routes are dead).

**Steps.**
1. Assemble the joint feature table from the frozen reply-state census (`c20-*-states.jsonl.gz`):
   per P reply-state, `(|L|, defxor, zone_size, zone_grundy, kill_size, matching-deficiency of the
   live-conic involution graph)`.
2. Test whether a **monotone band** in these jointly separates P/N where no single character did
   (regression / decision region over q=13/17/19). The A5 smallest-orbit child should be the
   `Φ`-extremal move — verify it is.
3. If a band exists, promote it to a **lemma**: responder can always move to keep `Φ` in-band, and
   in-band ⟹ P (base case = `Y_NK0` / small-zone `Z≤2`). This is the descent theorem.

**Cheap probe / gate.** Step 2 is a few hours on frozen data. If NO joint monotone band separates,
record the exact failing feature set and stop — do not hand-tune indefinitely.

**Output.** A Lyapunov potential + responder-control lemma (the descent theorem) or a bounded negative.
**Risk:** highest (search space); **Confidence:** highest ceiling — it consumes the proven drain and
the A5 selector rather than fighting them. Run **after** Routes 2/3.

---

## Route 4 (gated, parallel) — escalate q=29, reshape the theorem

**Objective.** Decide whether the depleted set is **finite**. Depletion is sporadic: only `{11,17}`,
no residue predicts it, and it is **not** a single exceptional-subgroup condition —
`A5 ⊂ PSL(2,q)` gives `{5,11,19,…}`, `S4 ⊂ PSL(2,q)` gives `{7,9,17,23,25,…}`; `{11,17}` splits across
them. A finite depleted set collapses the target from "all odd `q`" to **"generic `q` (Weil/abundance)
+ finitely many base cases."**

**Method.** Direct S4-rooted on-conic census at q=29 (computation), then Weil/abundance for generic `q`.

**Steps.**
1. **Requires an explicit user launch decision** (>8 GB RAM — needs 16 GB arena or `s4xormine`
   per-bucket splitting; ~15–25 h wall single-core). Sizing done: 42 on-conic buckets, bucket list
   `notes/data/c44-q29-onconic-buckets-sizing.txt`.
2. Run the `s4arena` on-conic bucket census at q=29 (unattended, disk-backed status; see the s4 manual).
3. **If q=29 non-depleted:** `{11,17}` is (so far) the whole corpus → pursue the finite-exceptions
   theorem shape (generic Weil abundance + `{11,17}` certificates). **If depleted:** the subsequence
   extends past `{11,17}` and the sporadic-arithmetic question reopens.

**Cheap probe / gate.** None cheaper than the run itself; sizing is already done. Launch in parallel
with Routes 2/3 since it reshapes the target regardless of their outcome.

**Output.** q=29 depletion verdict + (if non-depleted) the reduced theorem shape. **Confidence:**
medium; high leverage if finite.

---

## Sequencing and decision gates

1. **Start Route 3 and Route 2 (both cheap).** Either can yield the descent lemma outright. Gate: does
   a `Y_NK0`-descent move exist for the 104 P members (R3) / does the reduced game reproduce value
   faithfully (R2)?
2. **If 2/3 stall, run Route 1** (potential search) on the frozen joint feature table. Gate: joint
   monotone band exists?
3. **Ask the user to launch Route 4 (q=29) in parallel** at any point — it is gated and reshapes the
   theorem independently.
4. On any success, hand the resulting packet/lemma to **C82** (abundance counting; C520's Weil route
   is now constrained to carry more than one cross-ratio character — see the escape-family probe).

Whichever route closes C80(b), the deliverable is the **bulk-descent theorem into a proven-P packet**;
that is what unblocks C82 and the odd-`q` all-P crown.
