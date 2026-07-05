# Handoff — Node-Kayles / impartial games on arithmetic structures

**Date:** 2026-07-04
**Mode:** collaborative (session --2 ran under `mi` / intent-based)

Umbrella + entry point for the Node-Kayles open-problem thread. Detailed notes:
- [open-problem targets](../2026-07-04-node-kayles-open-problem-targets.md) — ranked targets, scout survey.
- [game (a) Cay⁺(Z_n,S) outcome law](../2026-07-04-cayley-nodekayles-outcome-law.md)
- [game (b) sum-free / cap-set](../2026-07-04-sumfree-capset-game.md) — detailed working log.
- [★ sum-free theorem (clean write-up)](../2026-07-04-sumfree-game-theorem.md)
- [OEIS submission draft](../2026-07-04-sumfree-oeis-draft.md) + `../2026-07-04-sumfree-bfile.txt`
- Banked scripts: `../2026-07-04-cayley-*.py`, `../2026-07-04-sumfree-*.py`, `../2026-07-04-improved-sumfree.py`, `../2026-07-04-cayley-path-power.py`; Rust solvers in `../sumfree-solver/` (binaries gitignored).

## Progress

- [x] **Game (a): Cay⁺(Z_n,S) Node-Kayles outcome-law MAP.** P-side pairing / N-side gap asymmetry;
  L1 (translation) / L2 (negation-steal) sound; component-parity reduction d=gcd(n,S); odd-n
  P-positions un-pairable; Paley p≡5 mod 8 conjecture located in the N-side gap. (A method/positioning
  result — no open problem moved.)
- [x] **Interval family C_n^k = octal `0.[1×k][3×k]7`** (verified 2 ways). k=1 = Dawson 0.137
  (period 34); **k≥2 UNBOUNDED nimbers, no period → open octal games** (Guy-conjecture instances).
- [x] **★ Game (b): sum-free achievement game on Z_n — SOLVED, theorem PROVEN.**
  `G(Z_n)=0 (2nd player wins) iff n≡0,1,5 (mod 6)`, all six residues (obstruction-counting via
  negation + translation mirrors; Lemmas 1–4 symbolic, no load-bearing machine step). New OEIS-absent
  sequence to **n=65** (banked Rust multiplier-quotient solver). **OEIS submission DRAFT ready — USER
  submits, do NOT submit.**
- [x] **Cap-set game on F₃ᵈ = P for d=1..4** (validated full-AGL(4,3)-quotient solver, dual-verified,
  2 binaries). d=5 unfinished (canon bottleneck).
- [x] **Prior art (web-verified):** both games appear-novel; general-position achievement game does
  NOT scoop the cap game; **Impartial SET confirmed a *removal* game** (ours *builds*); neighbours
  cited (Anti-Set, Sieben, Benesh–Ernst, Wong; extremal cap = A090245).
- [x] **Game (a) lemma bundle write-up** (R0 + L1 + L2 + odd-n impossibility) — DONE
  ([nodekayles-pairing-lemmas](../2026-07-04-nodekayles-pairing-lemmas.md)): master pairing lemma
  P0 (graph-general) + P0′ move-and-mirror + odd-order impossibility, then abelian-Cayley R0/L1/L2,
  all generalized from `Z_n` to arbitrary finite abelian `Γ` (reusable for torus/kings/Petersen),
  machine-corroborated with zero violations through `|Γ| ≤ 16` incl. non-cyclic groups.
- [ ] Cap-set "always P" proof + d=5.
- [ ] Interval octals k≥2 periodicity decision.

## Next steps (priority order)

1. **Submit the sum-free sequence to OEIS** (user action) — package + b-file ready in the draft note.
   Optionally the outcome-indicator companion + the Paley-graph-game sequence.
2. ~~**Write up the game-(a) lemma bundle**~~ — **DONE** 2026-07-04--3
   ([nodekayles-pairing-lemmas](../2026-07-04-nodekayles-pairing-lemmas.md)). Reusable abelian-Cayley
   core (R0/L1/L2/odd-n) + graph-general master pairing lemma.
3. **Cap-set:** d=5 needs a nauty-style canonical labeling (the "restrict + exhaustive-tail" canon
   degrades on near-maximal symmetric caps); then attempt a proof of "always P" (must differ from the
   Z_n mirror — F₃ᵈ has no order-2 element).
4. **Interval octals** k≥2: extend `g_path_k` far + k-kernel/period test (or accept as open octals).
5. **Definitional variants** of the sum-free game (strong sum-free a≠b; {1..n} vs Z_n; F₂ⁿ/F₃ⁿ).

## Handoff Note — session 2026-07-04--2 (`f78c95d1-3c01-49d4-9f4b-fec58d939cd0`)

- **Landed:** everything in Progress above. Headline = the sum-free mod-6 theorem (fully proven) +
  the OEIS package. Commits (on `main`): `15f1256` (game a), `724d5f6` (interval octals), `97a6a6f`
  → `19d9f4b` (sum-free prototype → full proof), `6105021` (theorem + OEIS draft), `ec542ea` (cap-set
  d=4), `1b271ad` (Lemma 4 closes the proof), `59d63b1`/`1bbef27`/`acbeb52` (cap-set framing tightened
  + prior art + Impartial-SET verified), `9551cd8` (finalize n=65 + bank solvers). CLAUDE.md pointer
  updated (`06d4cd6`).
- **Key correction banked:** an early "n≡0 mod 6 is deep / S2 dead / defect ~2n/9" call was WRONG —
  it measured the *negation* reference; the winning symmetry is *translation* z↦z+n/2 (zero defect).
  Lesson: try the other reflection before declaring a wall.
- **Not this thread:** **G(17) nimber = *2** (A344227 new term, breaks odd→1) was computed by the
  *parallel nimber thread* (commit `6c3f146`, `~/src/othello-n18` worktree), **pending its k=1
  confidence re-run** — owned by that session, not here.
- **Do NOT touch:** the pre-existing `M rust/src/queens/solver/iso_flat.rs` (not mine) and the
  untracked `notes/*.html` queens-report files.
- **Method notes:** small-memory Python probes ran under `ulimit -Sv ~900MB` while the G(17) run held
  the box; once it freed RAM, the Rust quotient solvers + cap-set AGL quotient became feasible.

## Handoff Note — session 2026-07-04--3 (`4de57ec0-7625-488b-8b7b-209e783bac6a`)

- **Landed (next-step #2):** the **game-(a) lemma bundle**
  [`2026-07-04-nodekayles-pairing-lemmas.md`](../2026-07-04-nodekayles-pairing-lemmas.md). Structure:
  master pairing lemma **P0** (closed pairing ⇒ P) stated at full graph generality (reusable for any
  vertex-transitive graph, incl. non-Cayley like Petersen) + **P0′** move-and-mirror (⇒ N) + the
  odd-order impossibility, then the abelian-Cayley specializations **R0** (index-parity reduction),
  **L1** (involution-translation pairing, even order), **L2** (negation steal, odd + doubling-closed).
  All proof-on-write, no load-bearing machine step.
- **Generalization beyond `Z_n`:** the outcome-law note proved R0/L1/L2 for circulants; I lifted them
  to **arbitrary finite abelian `Γ`** (so they cover the torus `Z_m×Z_n`, king/rook graphs) and
  machine-corroborated with a brute Grundy solver — **zero certificate violations through `|Γ| ≤ 16`
  including non-cyclic groups** (`Z_3×Z_3`, `Z_2×Z_4`, `Z_2×Z_2×Z_2`, `Z_4×Z_4`, …). Script banked:
  `../2026-07-04-abelian-nodekayles-verify.py`.
- **Cross-refs updated:** outcome-law note next-steps #1/#4 marked DONE; Progress checkbox + next-step
  #2 here checked off.
- **Ran under `mi`** (intent-based); low-stakes reversible write-up on the handoff's own lever
  sequence. Left `iso_flat.rs` + `notes/*.html` untouched (flagged not-this-thread by session --2).
- **Next open (unchanged priority):** #1 OEIS submission (USER), then cap-set d=5 / "always P" proof,
  interval octals k≥2, sum-free definitional variants.
