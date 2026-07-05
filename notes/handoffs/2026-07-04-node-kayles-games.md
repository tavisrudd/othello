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
- [x] **★★★ Cap-set game on F₃ᵈ = P for ALL d — THEOREM PROVEN** (session --3;
  [capset-game-theorem](../2026-07-04-capset-game-theorem.md)). Move-then-mirror: P1's opening `a` is
  a wasted tempo, P2 replies any `b≠a` and mirrors through the affine point reflection `σ_c`,
  `c=−(a+b)` the third point of the opening line — `c` self-blocks (it's on `{a,b,c}`), dodging the
  odd-order "no fixed-point-free involution" barrier (P0′, not whole-board pairing); `AGL(d,3)`
  2-transitivity ⇒ no residue case-split. **Settles d=5 (and all d) with no computation.** Earlier
  status was d=1..4 by AGL(4,3) solver; the heavy d=5 canon is now moot. Validated: brute G(1,2,3)=0
  + P2 strategy beats all P1 play d=1,2,3 (`../2026-07-04-capset-proof.py`); d=4 outcome from AGL solver.
- [x] **Prior art (web-verified):** both games appear-novel; general-position achievement game does
  NOT scoop the cap game; **Impartial SET confirmed a *removal* game** (ours *builds*); neighbours
  cited (Anti-Set, Sieben, Benesh–Ernst, Wong; extremal cap = A090245).
- [x] **Game (a) lemma bundle write-up** (R0 + L1 + L2 + odd-n impossibility) — DONE
  ([nodekayles-pairing-lemmas](../2026-07-04-nodekayles-pairing-lemmas.md)): master pairing lemma
  P0 (graph-general) + P0′ move-and-mirror + odd-order impossibility, then abelian-Cayley R0/L1/L2,
  all generalized from `Z_n` to arbitrary finite abelian `Γ` (reusable for torus/kings/Petersen),
  machine-corroborated with zero violations through `|Γ| ≤ 16` incl. non-cyclic groups.
- [x] **Cap-set "always P" proof + d=5 — DONE** (theorem above; d=5 settled = P, no compute needed).
- [ ] Interval octals k≥2 periodicity decision — advanced to m=2·10⁶ (no period p≤60000; growth
  ≈m^0.66 for k=3, ~log for k=2); periodicity itself is Guy's-conjecture-open.

## Next steps (priority order)

1. **Submit the sum-free sequence to OEIS** (user action) — package + b-file ready in the draft note.
   Optionally the outcome-indicator companion + the Paley-graph-game sequence.
2. ~~**Write up the game-(a) lemma bundle**~~ — **DONE** 2026-07-04--3
   ([nodekayles-pairing-lemmas](../2026-07-04-nodekayles-pairing-lemmas.md)). Reusable abelian-Cayley
   core (R0/L1/L2/odd-n) + graph-general master pairing lemma.
3. ~~**Cap-set:** d=5 + "always P" proof~~ — **DONE + FULLY GENERALIZED 2026-07-04--3**
   ([capset-game-theorem](../2026-07-04-capset-game-theorem.md)): proven `G(n,q)=0` for **all `n` and
   EVERY prime power `q`, both parities**. `q` odd ⇒ move-then-mirror reflection σ_c (odd board, burn
   opening, midpoint center self-blocks); `q` even/char 2 ⇒ whole-board translation mirror τ_v (which
   IS a fpf involution since 2v=0). Shared parity lemma (symmetric cap meets the mirror line in an
   even count ⇒ 0). d=5 settled = P. Corroborated AG(2,{4,5,7,8,9}) incl non-prime q=9 & char-2 q=4,8;
   both strategies beat all P1 play. *Open follow-on:* projective `PG(n,q)`; "no t collinear" t>3.
4. ~~**Interval octals** k≥2~~ — **piece (a) DONE 2026-07-04--3** (m=2·10⁶, no period p≤60000; k=3
   ≈m^0.66, k=2 ~log; last path zeros m=16168 / m=827062). Remaining: push k=2 to 10⁷ (needs a
   sub-O(m²) split) or accept as an open octal family.
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

**HEADLINE:** proved the **cap achievement game on `AG(n,q)` is a second-player win (P) for EVERY
prime power `q` and every `n`** — subsuming and settling the cap-set (`q=3`) "always P" conjecture,
so `d=5` and all `d` are resolved with no computation. Ran the whole session under `mi` (intent-based).
Commits `efedbc5`→`24d33e4` on `main`. Everything below is landed + banked + committed.

- **★★★ Landed (next-step #3): the cap-game theorem, all q.**
  [`capset-game-theorem`](../2026-07-04-capset-game-theorem.md). Two mirrors by parity of the board
  `qⁿ`, unified by one **parity lemma** (a σ-symmetric cap meets the mirror's invariant line in an
  even count; the just-played legal move forces it to 0):
  - `q` **odd** (board odd, no fpf involution) ⇒ **move-then-mirror** (P0′): P1's opening is a wasted
    tempo, P2 replies any `b`, mirrors via the point reflection `σ_c`, center `c=(a+b)/2` (midpoint)
    self-blocks (collinear with the opening pair).
  - `q` **even/char 2** (board even) ⇒ **whole-board translation mirror** (P0): `τ_v(x)=x+v` IS a fpf
    involution since `2v=0`.
  Commits `d774307` (q=3), `624ddb7` (odd q), `a2d487b` (all q + char-2 discovery via AG(2,4)/(2,8)).
  Verified: brute outcome P for AG(2,{3,4,5,7,8,9}) incl. **non-prime q=9** and char-2 q=4,8; both
  strategies beat ALL P1 play (`../2026-07-04-{capset-proof,ag-strategy,validate-all,cap-agnq,cap-gf,gf}.py`).
- **Cap follow-ons (conjectures, banked):** the **projective** cap game `PG(m,q)` is also P in all
  small cases (PG(1/2/3,2), PG(1/2,3), PG(1,4/5); `../2026-07-04-proj-cap.py`) — but the affine proof
  does NOT transfer (no translations, board parity varies), so **open**. `F₂ᵏ` sum-free game **=**
  `PG(k−1,2)` cap game. Commit `24d33e4`.
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
- **Landed (next-step #4, piece a):** extended the **interval-family octals** `0.[1×k][3×k]7` from
  the old m≤8000 probe to **m=2·10⁶** (fast C solver `../2026-07-04-octal.c`, validated on k=1 =
  Dawson period 34). Commit `f4e17dc`. Findings: **no period** (pure/arithmetic) for p≤60000 on the
  10⁶-wide tail `[10⁶,2·10⁶]`, both k. **Growth splits by k** — k=3 ≈ m^0.66 (record 4947, strong
  unbounded); k=2 ~log (record 1314, records still rise but slowly ⇒ plausible-not-firm unbounded).
  **Correction:** the note's "k=3 no path P beyond m=824" was an m≤8000 artifact — actual last path
  zero is **m=827062** (k=2's is m=16168), so the k=2 cycle "2nd-player-for-large-n" conjecture is
  well-supported and the k=3 one is weak (role reversal from the old note). Prior art: k=1=Dawson
  textbook; octal-games-on-graphs (arXiv:1612.05772) studies fixed octals on trees, not powers of
  paths ⇒ identification appears-novel. Method note: solver is O(m²) (the single split digit);
  m~10⁷ needs a faster nim-convolution or accept the octal as open.
- **Info-theory fishing (user request) — DONE, verdict banked**
  ([it-connections-scout](../2026-07-04-it-connections-scout.md)): **mostly C, two structural B's, no
  substantive A.** Decisive framing negative (worth keeping so nobody re-fishes): our program computes
  **game values** (nimbers/outcomes) while every open IT problem on the shared substrate (independent
  sets in graphs/powers) is about **extremal size or asymptotic rate** — orthogonal invariants. Made
  precise: the Grundy value is provably **not** a point of Strassen/Zuiddam's *asymptotic spectrum of
  graphs* (arXiv:1807.00169) — not monotone under homomorphism, not multiplicative under strong
  product, "additive" only as nim-XOR — so it cannot bound Shannon capacity via the one theory built
  for that. Only actionable item is **B1**: aim our circulant/Cayley independent-set + symmetry-quotient
  *compute stack* (not our theorems) at the Θ(C₇) Shannon-capacity lower-bound record (α(C₇^⊠5) ≥ 350)
  — a compute-forward side quest in a competitive arena, no clear edge. B2 = a framing note only.
- **Sum-free definitional variants (next-step #5) — EXPLORED**
  ([sumfree-variants](../2026-07-04-sumfree-variants.md)). New OEIS-absent sequences: `Z_n`-strong
  (irregular) and `{1..n}` Schur (outcome near-law "P iff n≡3,4,5 mod6" that BREAKS at n=17).
  Vector-space split: **`F₂ᵏ`=P (k≥2), `F₃ᵏ`=N (k≥1)** — both conjectural, neither has a clean
  proof (parity of maximal sets forces only k≤3/k≤2; no mirror: F₃'s negation is broken everywhere by
  `2(−x)=x`, F₂'s char-2 has no fpf linear involution). Nice contrast to the cap game (same F₃ᵏ, but
  `a+b+c=0` → P vs `a+b=c` → N). Scripts banked.
- **★ 3-AP-free (cyclic cap) game on Z_n — the cleanest new variant**
  ([ap-free-game](../2026-07-04-ap-free-game.md)). The proper cyclic analog of the cap game
  (cap = no 3 collinear = no 3-AP). **P for every n through 47 except the sporadic `{1,7,19,47}`**
  (all odd; not centered-hexagonal — 37 is P). **Even n ⇒ P is PROVEN** (τ_{n/2} translation mirror;
  the 4∣n gap closes because x+n/4∈A would make x illegal via {x+n/4,x,x+3n/4}). Odd n: mostly P but
  no uniform certificate (midpoint reflection works only n=3,5,9,15; 7,19,47 genuinely N). **Isolates
  why the cap theorem is clean:** its center needs 3c=0 (every c in char p; only {0,n/3,2n/3} in Z_n),
  so Z_n's extra AP-completions (3y−2c,4c−3y) break the mirror sporadically. New OEIS-absent sequence.
- **Next open (priority):** #1 OEIS submission (USER; possibly + the new variant sequences); a formula
  for the AP-free exception set `{1,7,19,47,…}`; interval octals k=2→10⁷ (sub-O(m²) split); projective
  `PG(n,q)` cap "always P" proof; `F₂ᵏ`/`F₃ᵏ` conjectures (non-mirror argument); game-(a) N-side cert.
