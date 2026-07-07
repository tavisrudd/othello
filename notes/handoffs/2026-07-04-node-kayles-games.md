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

## Current Lean status (2026-07-07)

Lean cross-references should point to the current files under [`../../lean/`](../../lean/); do not
rename Lean files to match older prose names.

**Build-green Lean coverage now includes:**
- Node-Kayles recurrence, certificates, and Grundy/component-XOR layer:
  [`../../lean/NodeKayles/Basic.lean`](../../lean/NodeKayles/Basic.lean),
  [`../../lean/NodeKayles/Certificate.lean`](../../lean/NodeKayles/Certificate.lean), and
  [`../../lean/NodeKayles/Grundy.lean`](../../lean/NodeKayles/Grundy.lean);
- shared finite building-game semantics:
  [`../../lean/CapGame/BuildGame.lean`](../../lean/CapGame/BuildGame.lean);
- sum-free formal endpoints `F_3^n = N` and `ZMod 2 x F_3^b = P`:
  [`../../lean/Sumfree/Game.lean`](../../lean/Sumfree/Game.lean),
  [`../../lean/Sumfree/Z2F3Labels.lean`](../../lean/Sumfree/Z2F3Labels.lean),
  [`../../lean/Sumfree/Z2F3Bridge.lean`](../../lean/Sumfree/Z2F3Bridge.lean),
  [`../../lean/Sumfree/Z2F3Game.lean`](../../lean/Sumfree/Z2F3Game.lean), and wrappers under
  [`../../lean/Sumfree/Almost/`](../../lean/Sumfree/Almost/);
- abstract SumFree mirror theorem layer in [`../../lean/Sumfree/Game.lean`](../../lean/Sumfree/Game.lean):
  no-obstruction negation mirror, spare-order-two P theorem, order-two singleton reduction, and
  order-two/no-other-negation-obstruction N theorem, plus finite obstruction wrappers
  (`NonzeroOrderTwoElements`, `NonzeroOrderThreeElements`,
  `initial_isP_of_no_nonzero_orderTwo_or_three`,
  `initial_win_of_unique_orderTwo_no_nonzero_orderThree`, and
  `initial_win_of_one_nonzero_orderTwo_no_nonzero_orderThree`,
  `initial_isP_of_two_nonzero_orderTwo`, and
  `initial_isP_of_at_least_two_nonzero_orderTwo`);
- anchored order-three mirror layer:
  `anchored_neg_mirror_legal` in [`../../lean/Sumfree/MirrorLemmas.lean`](../../lean/Sumfree/MirrorLemmas.lean)
  and the finite-game wrappers `AnchoredNegGood`, `anchoredNegGood_isP_of_live_obstructions`, and
  `initial_win_of_orderThree_anchor` in [`../../lean/Sumfree/Game.lean`](../../lean/Sumfree/Game.lean),
  plus the even-branch blocker invariant `AnchoredNegGoodWith`;
- cyclic `ZMod n` bridge in normal-form branches:
  [`../../lean/Sumfree/CyclicZMod.lean`](../../lean/Sumfree/CyclicZMod.lean), including the odd,
  `3 ∤ n` P cases via `initial_isP_of_odd_of_not_three_dvd` and the even, `3 ∤ n` N cases via
  `initial_win_of_even_of_not_three_dvd`, plus `initial_win_of_three_mul_odd` for `n = 3*k`, `k` odd
  and `initial_isP_of_six_mul` for `n = 6*k`, with arbitrary-`n` wrappers `initial_isP_of_six_dvd`
  and `initial_win_of_eq_three_mul_odd`, residue wrappers
  `initial_isP_of_mod_six_eq_zero`, `initial_isP_of_mod_six_eq_one`,
  `initial_isP_of_mod_six_eq_five`, `initial_win_of_mod_six_eq_two`,
  `initial_win_of_mod_six_eq_three`, and `initial_win_of_mod_six_eq_four`, and
  combined branch statements `initial_isP_of_mod_six_zero_or_one_or_five` and
  `initial_win_of_mod_six_two_or_three_or_four`, packaged as biconditionals
  `initial_isP_iff_mod_six_zero_or_one_or_five` and
  `initial_win_iff_mod_six_two_or_three_or_four`;
- Queens coordinate/game bridge targets:
  [`../../lean/Queens/Basic.lean`](../../lean/Queens/Basic.lean) and
  [`../../lean/Queens/CentralChild.lean`](../../lean/Queens/CentralChild.lean).

**Still text/computation only, not Lean theorems:** the full finite-abelian rank/cardinality
bookkeeping needed for the full `r3 <= 1` abelian theorem; the affine cap all-`q` theorem; the
projective odd-plane escape theorem; and the Queens `N20J10LuckyTarget`.

## ▶ RESUME HERE — the SOCLE REDUCTION is FALSE (updated 2026-07-05, session `2bf7abb3`)

**★★★ `Z3²×Z7 = P` — the socle reduction is disproven.** Full note:
[`../2026-07-05-socle-reduction-FALSE.md`](../2026-07-05-socle-reduction-FALSE.md).
The book route (`strategy_book_miner`, `socle-book-*`) is **moot — do NOT resume it.**

- `Z3²×Z5=N` but `Z3²×Z7=P`, even though both have `G[6]=Z3²` (=N). So `𝒢(G)=𝒢(G[6])` and the
  sharpening **"odd `G` w/ 3-torsion ⟹ N" are FALSE** (`Z3²×Z7` is odd with 3-torsion, yet P).
  The coprime factor's *size* flips the outcome.
- **Confirmed ×2** (canon-independent ⇒ sound): the **new Go solver**
  [`../sumfree-go/sumfree.go`](../sumfree-go/sumfree.go) (full-`Aut` canon, `P`, 0 openings) **and**
  the existing Python `sumfree_solver.py` (`canon=coordinate-subgroup`, `P`, 5.2M nodes). The
  book-miner's *"no winning move in N-position"* crash on p=7 was the same signal.
- **Why it was missed:** `../2026-07-05-socle-book-scaling.py` never solved the outcome — it starts
  from `{socle opening}` and only counts a *heuristic* strategy's local fails; "socle-fail=1, constant
  in p" was misread as "uniformly N." `Z3²×Z7`'s true outcome was never soundly checked until now.

**What SURVIVES (direct theorems, re-confirmed by the Go solver):** `F₃ⁿ=N`, `Z₂×F₃ᵇ=P`, `s₂≥2⟹P`,
the `s₂=1` reduction, `r₃≤1⟹N` (`Z3×Z_p`). **What DIES:** the socle reduction / whole book program.
The classification is **not** nearly complete — the open slice (`s₂≤1, r₃≥2`) is genuinely non-uniform.

**★ New Go solvers = the tool** (`../sumfree-go/`, single files, `go build`, no deps, memory-light
compile — no rustc OOM): `sumfree.go` (sequential, negamax + full-`Aut(G)` canonical TT) +
`cmd_par/sumfree_par.go` (sharded-TT parallel, ~5×, + a `--pairing` mirror verifier). Validated on all
cyclic `Z_n`, `Z3²×Z5=N` (8 socle openings exact), `Z3³=N`, `Z2×Z3²=P`, `r₃=1` peels all N. N-cases
fast (cutoff at first winning opening); **P-cases explode** (no boolean cutoff): `Z3²×Z11` blew past
**100M nodes / 8 GB without converging** ⇒ brute outcome is infeasible past `p=7` on this box.

**Two sharper facts this session:** (1) `Z3²×Z7=P` is a **non-pairing / adaptive** P-position — the
`--pairing` verifier finds **no** negation-bulk+socle-repair mirror (0/60) for any `p`, and odd `|G|`
rules out a translation mirror. So neither standard mirror proves it. (2) **Leading conjecture:
`Z3²×Z_p = N` iff `p=5`, else P** (`p=5→N`, `p=7→P` rigorous; `p=11` strongly P; NOT a `p mod 3`
split, so `p=5` is sporadic).

**▶ CONCRETE NEXT STEP:** settle the conjecture. Brute is out ⇒ **extract + characterize the adaptive
2nd-player winning strategy for `Z3²×Z7`** (the method that cracked `F3ⁿ`/`Z2×F3ᵇ`) and generalize to
`p≥7` — look for an *invariant*, not a pairing. Secondary: a compact 2-word-mask solver to push a couple
more `p`; explain the `p=5` exception (max-sum-free-set parity?). OEIS submission still pending (USER).

Full session log: **Handoff Note — session 2026-07-05--4** + **--2/--3** below.

## Progress

- [x] **Game (a): Cay⁺(Z_n,S) Node-Kayles outcome-law MAP.** P-side pairing / N-side gap asymmetry;
  L1 (translation) / L2 (negation-steal) sound; component-parity reduction d=gcd(n,S); odd-n
  P-positions un-pairable; Paley p≡5 mod 8 conjecture located in the N-side gap. (A method/positioning
  result — no open problem moved.)
- [x] **Interval family C_n^k = octal `0.[1×k][3×k]7`** (verified 2 ways). k=1 = Dawson 0.137
  (period 34); **k≥2 UNBOUNDED nimbers, no period → open octal games** (Guy-conjecture instances).
- [x] **★ Game (b): sum-free achievement game on Z_n — SOLVED, theorem PROVEN.**
  `G(Z_n)=0 (2nd player wins) iff n≡0,1,5 (mod 6)`, all six residues (text proof; not yet a
  top-level Lean theorem; obstruction-counting via
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

## Handoff Note — session 2026-07-05--4 (`2bf7abb3-c0ff-48a2-9c80-e08a4acfe74f`)

**HEADLINE: the SOCLE REDUCTION is FALSE — `Z3²×Z7 = P`.** Ran under `mi`. Full note:
[`2026-07-05-socle-reduction-FALSE.md`](../2026-07-05-socle-reduction-FALSE.md).

- **What happened:** the user asked for a fast small solver (Go, no rustc — OOM risk from the live G(17)
  queens run). Built `notes/sumfree-go/sumfree.go` (sequential, full-`Aut(G)` canonical negamax). While
  running the handoff's "concrete next step" (201-book coprime-independence on `Z3²×Z7`), the generalized
  `strategy_book_miner` **crashed with "no winning move in N-position"** — because `Z3²×Z7` is not N.
- **`Z3²×Z7 = P`, confirmed ×2:** the Go solver (`|Aut|=288`, `P`, 0 openings, 837K nodes) **and** the
  existing Python `sumfree_solver.py` (`canon=coordinate-subgroup`, `P`, 5.2M nodes). Two different sound
  canons agreeing ⇒ sound. This falsifies `𝒢(G)=𝒢(G[6])` and "odd `G` w/ 3-torsion ⟹ N": `G[6]=Z3²`
  is N but `Z3²×Z7` is P. **`Z3²×Z5=N` but `Z3²×Z7=P`** — the coprime factor's size flips the outcome.
- **Why it was missed:** `2026-07-05-socle-book-scaling.py` never solved the outcome — its `book()`
  starts from `{socle opening}` and only counts a *heuristic* strategy's local fails. "socle-fail=1,
  constant in p" was misread as "uniformly N"; the true outcome of `Z3²×Z7` was never soundly checked.
- **Solver validation** (all pass): cyclic `Z_n` = mod-6 theorem; `Z3²×Z5=N` w/ the 8 socle openings
  exact; `Z3³=N`, `Z2×Z3²=P`; `r₃=1` peels `Z3×Z5/7/11/13` all N.
- **Parallel solver** `cmd_par/sumfree_par.go` (sharded TT + worker pool, ~5×, + `--pairing` verifier).
  Brute P-proofs explode: `Z3²×Z11` > **100M nodes / 8 GB, no convergence** ⇒ killed (protect G(17)).
  Brute outcome is infeasible past `p=7` here.
- **`Z3²×Z7=P` is NON-PAIRING/adaptive:** `--pairing` finds no negation-bulk+socle-repair mirror (0/60,
  every p); odd `|G|` ⇒ no translation mirror. Verifier validated (`Z5/Z7/Z25` negation ✓, `Z3` none,
  `Z2×Z3²` no *negation* pairing — it wins by translation). Leading **conjecture: `Z3²×Z_p=N` iff `p=5`,
  else P** (not a `p mod 3` split; `p=5` sporadic; `p=11` strongly P — 100M nodes, no winning opening).
- **What survives:** all direct theorems (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`, `s₂≥2⟹P`, `s₂=1` reduction, `r₃≤1⟹N`).
  **What dies:** the socle reduction + the whole book program (`socle-book-*`, `strategy_book_miner`).
  The classification is NOT nearly complete — the `s₂≤1, r₃≥2` slice is genuinely non-uniform.
- **Scripts banked:** `notes/sumfree-go/` (Go solvers), `2026-07-05-socle-book-coprime.py` (generalized
  miner, superseded), `2026-07-05-sumfree-z3sq-pairing.py` (Python pairing search — too slow, Go version
  used instead). **Next:** extract/characterize the adaptive `Z3²×Z7` P-strategy; a compact solver for a
  couple more `p`; explain the `p=5` exception. OEIS submission still pending (USER-only).
- **Did NOT commit** (awaiting user go-ahead under `mi`).

## Handoff Note — session 2026-07-05--2 (`2d451ba6-8ddd-40c9-9def-aa1aaecd68a8`)

**HEADLINE: `Z₂×F₃ᵇ = P` for all `b≥1` is now a THEOREM** — the last open endpoint of the abelian
socle family. So **the entire finite-abelian sum-free classification is proven modulo ONLY the socle
reduction** (both its endpoints `F₃ⁿ=N` and `Z₂×F₃ᵇ=P` are now theorems). Ran under `mi`. Full proof +
verification: [`2026-07-05-sumfree-zmf3b-theorem.md`](../2026-07-05-sumfree-zmf3b-theorem.md).

- **The strategy is ChatGPT's** (delivered mid-session): from `{m}` (`m=(1,0)`) reply `p=(0,a)` (any
  `a≠0`), then mirror through the affine involution `σ(x)=(m+p)−x`, i.e. `σ(ε,v)=(1−ε,a−v)`. It
  *pairs* the obstruction `m` with the reply `p` instead of trying to *fix* `m` (which is what every
  earlier single-involution mover-mirror did — all failed on the m-coset O₃ doubling). `σ` flips `Z₂`
  ⟹ **fixed-point-free** (dodges O₂); it's an affine `V`-reflection whose `+a` defect is repaired by a
  **char-3 label flip** (dodges O₃, exactly like the `F₃ⁿ` proof); `k=m+p` **self-blocks**. It is the
  "strictly-matched fpf involution" the lit search flagged as the canonical P-tool.
- **My contribution:** (i) the clean **`(★)` reframing** — after `m`, the residual is a `Z₂`-labelled
  game on `F₃ᵇ` where sum-free ⟺ *every additive triple `v+w=u` has odd label-sum `ε_v+ε_w+ε_u=1`*
  (unifies all the ad-hoc constraints the mover-mirror attempts juggled); (ii) **exhaustive
  verification** (no-symmetry brute `b≤2`; exhaustive local-invariant sweep over ALL σ-sym sum-free
  positions `b≤3` = 0 lemma violations = complete proof for those `b`; adversarial all-lines; sampled
  `b=4,5,6`); (iii) the **dimension-uniform proof of the pair-completion lemma** — every triple
  containing the reply reduces, via one M-image `d↦a−d`, to a triple in `D∪{y}` whose (★)-legality
  gives the needed label condition; the doubling cases close by an *always-present* triple
  "(D-slot)`+y=`its M-mate" that pins `ℓ=0` (the char-3 analogue of "the center self-blocks").
- **Codex flagged a solver bug** (relevant): `2026-07-05-sumfree-fast.py` reduces under full `Aut(G)`,
  sound only when `Aut(G)` is transitive on legal first moves — true for pure `F₃ⁿ`, **false for `Z₈`,
  `Z₁₀`, `Z₂×F₃ᵇ`** (wrong outcomes). Every check in the new note is brute or σ-pairing-only, immune.
  Codex is building the corrected sound solver.
- **Scripts banked:** `2026-07-05-sigma-verify.py`, `-sigma-t3.py`, `-sigma-residual-check.py`,
  `-sigma-sampled.py`. Notes updated: the dedicated theorem note + the abelian-theorem note (both
  socle endpoints now theorems) + the Codex assignment (primary closed → socle reduction is next).
- **Next:** (1) the **socle reduction** is now the sole open piece — Codex's new primary (prove
  `𝒢(G)=𝒢(G[6])`; the σ-mirror lesson = "pair the obstruction, don't fix it, mirror through an affine
  center that flips a torsion coord" may attack the non-elementary 3-groups `Z₉,Z₂₇,…=N` and the
  coprime collapse). (2) corrected solver + `Z₂×F₃⁴`/`F₃⁴,⁵` as canonicalizer checks. (3) OEIS (USER).

**Codex round 1 — DONE (integrated, sound solver independently re-checked here).** Codex delivered the
corrected solver + strategy verifier + socle probe (`notes/{sumfree_solver,verify_strategy,
socle_reduction_probe}.py`, findings `notes/2026-07-05-codex-findings-sumfree.md`). I ran its selftest
(legality vs brute Schur scan ✓) and the previously-**wrong** cases: `Z8=N` (move 4), `Z10=N`
(move 5) — **now correct**; `Z2×F3²=P`. **The root-transitivity fix overturned NO theorem** (ours were
brute/σ-verified, immune); it only corrected the buggy cyclic outcomes. Codex also independently
re-ran the σ-theorem sweeps (b≤3, 0 violations) and re-killed the hyperplane candidates (superseded).
- **★ Sharpening (important):** the socle reduction's *needed* content is only the open slice
  `s₂≤1 ∧ r₃≥2` — for `r₃≤1`/`s₂≥2` the reduction is automatic (both endpoints already decided by the
  proven theorems). Most of Codex's 12 test groups are already-proven `r₃≤1`/`s₂≥2` (e.g. `Z9` is
  `r₃=1`, cyclic Sylow-3; `Z5×Z3`, `Z30`, `Z2×Z5×Z3` all `r₃≤1`) — so the genuinely-open data was thin.
- **Genuinely-open (`r₃≥2`) confirmations I added** (sound solver, all match socle): **higher-3-power**
  `Z9×Z3=N` (=`Z3²`; move `(0,1)`); **coprime** `Z5×Z3²=N` (=`Z3²`; move `(0,0,1)`); **higher-2-power**
  `Z4×Z3²=P` (=`Z2×Z3²`). Plus `Z3³=N`. So the reduction holds across **all three collapse types** on
  open-slice groups. The needed reduction = **"coprime + higher-power parts are outcome-neutral for
  `s₂≤1, r₃≥2` groups"**, with both pure-socle endpoints now theorems.
- **ρ-obstruction pinned (Codex):** the naive "negate coprime, fix `{2,3}`-part" mirror fails exactly
  when the fixed part has 3-torsion, via the bad triple `a+y=ρ(y)`, `a=(ρ−1)y` (a pure-coprime
  `−2·(coprime part)` already in the ρ-symmetric set); full negation dodges it via `A=−A`, partial
  mirror loses that link. So the reduction needs a non-global-mirror idea.
- **Sharpened next attack (the method that cracked `F₃ⁿ` AND `Z₂×F₃ᵇ` — reverse-engineer the solver
  strategy):** extract the full winning reply-function for the cleanest genuinely-open N-case
  **`Z9×Z3=N`** (self-contained higher-3-power, no coprime coupling; the combined B-game+negation
  strategy is known to fail here — 48 illegal replies — so its strategy is something new) via
  `verify_strategy.py`, and pattern-match for a move-then-mirror / invariant. Do the same for
  `Z5×Z3²`. Possibly split the reduction into R1 (2-power), R2 (3-power), R3 (coprime) — they may need
  distinct mechanisms.

**Round 2 (I ran the above) — the mirror method is OUT for the socle reduction (solid negative +
5 parallel attacks queued for Codex).** Reverse-engineered `Z9×Z3=N`
([`2026-07-05-socle-reduction-not-a-mirror.md`](../2026-07-05-socle-reduction-not-a-mirror.md)):
- **Winning first moves = EXACTLY the 8 socle order-3 elements**; on socle moves the reply is the
  `F₃²` reflection `σ(y)=−o−y` (forced for `(3,1),(6,1)`). So the socle sub-play *is* elementary `F₃²`.
- **`Z9×Z3=N` is NOT a pairing/mirror position:** `σ`, `−y`, and **every** adaptive combination
  (`σ else −y`, `−y else σ`, socle:σ/order-9:−y, both fallbacks) FAIL; the only reflection with the
  played center `o` fixed is `σ=−o−y` (as `2o=−o`), which dies on order-9 (`2y=σy⟹3y=0` fails). The
  win is genuinely adaptive. **`Z₂×(Z9×Z3)`: ChatGPT's σ-mirror fails for EVERY `a`** (socle+order-9).
- **Interpretation:** the two proven socle endpoints are char-3-pure phenomena; the socle *reduction*
  (elementary ← general) is a separate NON-mirror problem. Stop trying mirror variants on
  non-elementary 3-groups. Scripts banked `2026-07-05-socle-{z9z3-strategy,z9z3-adaptive,z2z9z3-sigma}.py`.
- **5 parallel attacks written into the Codex brief** (`2026-07-05-codex-assignment-sumfree-socle.md`
  top section): (1) atomize into peels `P_cop(p)/P_2(k)/P_3(k)` + locate the hard core (3-torsion
  coupling); (2) full-nimber law under peeling (`𝒢(G)↔𝒢(G[6])`, stronger than outcome); (3) quotient
  game-morphism `outcome(G)=outcome(G/K)`; (4) bounded-local-repair strategy for `Z3²×Z5` (the smallest
  hard coprime peel — the σ-lesson applied non-globally); (5) LMSF terminal-parity invariant.

**Round 3 — Attack 4 (coprime peel) resolved NEGATIVE + a structural sharpening** (extends the
not-a-mirror note; scripts `2026-07-05-socle-coprime-{sigma-obstruction,mirror-search,fibered}.py`).
Codex's parallel round: all 5 attacks probed — peels all hold (A1); no nimber law (A2); `G→G/6G`
preserves outcome but is not a game morphism on positions (A3); `Z3²×Z5=N` first move `(0,1,0)` socle,
combined strategy fails 1284× (A4); LMSF `Z5×Z3` already mixed-parity (A5).
- **★ Structural sharpening (I derived):** the socle reduction / classification's whole open content is
  only **`s₂=0, τ₃=1`** (odd, 3-torsion) plus **`s₂=1` non-elementary `{m}` N**. `s₂≥2` is done (Part-1
  translation `τ_v`, group-general, any 3-structure); `s₂=1` rides `τ_m`; `s₂=0,τ₃=0` is negation. So
  non-socle parts are outcome-neutral **except through 3-torsion coupling**; the irreducible statement
  is essentially **"odd `G` with 3-torsion ⟹ N"** (⊇ `F₃ⁿ=N`).
- **★ Attack 4 = dead for mirrors (my focused work).** The coprime peel is NOT a mirror/fibered
  strategy even for elementary `H`: global `σ_G`, combined, ALL structured single involutions
  `(σ_H or −h, c−i)` incl. order-15 openings, and the fibered "pin `H`-projection to `σ_H`, free `Z_p`"
  all FAIL (adversarial, `Z3×Z5/Z3×Z7/Z3²×Z5/Z3²×Z7`). `σ_G` obstruction pinned: char-3 (`−2i=i`, `3i=0`)
  fails off-base, blocker `p=o+2y∈A`. So the win is genuinely adaptive (like `Z9×Z3`); the socle
  reduction is not a pairing phenomenon in ANY case. **Redirect: pursue structural/invariant routes
  (A2/A3/A5 refined) or a novel technique, targeting "odd `G` w/ 3-torsion ⟹ N".**

**Round 4 — the bounded-exception BOOK genuinely shrinks the residue** (positive result,
[`2026-07-05-socle-book-residue-shrink.md`](../2026-07-05-socle-book-residue-shrink.md); scripts
`2026-07-05-socle-book-{residue,investigate,scaling}.py`). Base = negation mirror; its only exceptions
are the **order-3 (socle) elements** — set size `3^{r₃}−1`, depending only on `r₃`, NOT on `|G|`.
Parity reformulation: bulk negation-paired ⟹ even ⟹ outcome = socle-move parity.
- **Bulk reply always LEGAL** (0 genuine bulk-fails, every group / any coprime part) — the
  coprime/higher-power part adds no *illegal* obstruction.
- **`r₃≤1` PROVEN outright:** `Z3×Z_p` (any `p`), `Z3³` all WIN under negation-bulk + socle-book — a
  clean uniform proof of the coprime + higher-power peel for cyclic-Sylow-3 groups.
- **`r₃≥2` limit (brute-verified, corrected mid-round):** fixed negation-bulk **loses** — the `Z9×Z3`
  book position `{o}∪`(two bulk pairs) is an opponent-win; the stuck node is a genuine hero-loss (NOT a
  one-move repair). So the hero must pair the bulk **adaptively**, coupled to the socle. The failure is
  **coprime-independent** (socle-fail = 1 for `Z5,Z7,Z11,Z9` alike).
- **Net shrink:** open problem drops from a 2-parameter family (`r₃` × arbitrary bulk) to **`r₃≥2` + a
  coprime-independent adaptive-bulk-pairing requirement**; `r₃≤1` closed, bulk-legality proven all `r₃`.
  **Next:** an *adaptive* bulk pairing that shifts with the socle center so the socle-σ reply is never
  blocked (a "matched involution coupled to the socle game").

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

## Handoff Note — session 2026-07-05--1 (`749a01ab-5976-4db1-99eb-f2d4e1bb9ea5`)

**HEADLINE:** upgraded the abelian sum-free criterion from conjecture (verified ~25 groups) to a
**THEOREM for all finite abelian `G` with 3-rank ≤ 1 or 2-rank ≥ 2**
([abelian-theorem](../2026-07-05-sumfree-abelian-theorem.md)). Collaborative mode. Landed +
committed on `main`.

- **★★ `s₂ ≥ 2 ⟹ P` for every `G`** (the note's flagged "new phenomenon") — **clean proof**:
  translation mirror with a *spare* order-2 element (`|G[2]\{0}| ≥ 3` ⟹ some order-2 `v ≠ x` for
  every opening `x`; reply `x+v`, then `τ_v`-mirror, which is O₃-immune). Rests on the cyclic
  Lemmas 2–3 (they lift verbatim). Covers an infinite family with **no cyclic analogue** (cyclic
  ⟹ `s₂ ≤ 1`), incl. `Z2²×Z9 = P` though `Z9 = N`.
- **★ Clean `s₂=1` reduction:** `∅` P ⟺ `{m}` N (unique order-2 `m`); `τ_m` handles every non-`m`
  opening for **all** 3-ranks. Isolates the whole `s₂=1` difficulty into one position.
- **`r₃ ≤ 1` cases:** the mod-6 Lemmas 1–4 lift verbatim (one order-3 pair) ⟹ criterion proven for
  every group with cyclic Sylow-3.
- **Open slice pinned:** `s₂ ≤ 1 AND r₃ ≥ 2` (multiple order-3 pairs — never occurs in `Z_n`);
  solver-confirmed (Z3²,Z9×Z3,Z3³,Z2×Z3²,Z2²×Z3²), reduced to **Lemma R** (`{m}`/`∅` is N under
  `τ₃=1`). Ruled OUT the easy mechanisms (measured, banked so nobody re-tries): affine reflection
  `σ_c` preserves sum-freeness **only on pure `F₃ᵏ`** (360 viol. Z9×Z3, 104 Z2×Z3², 36 Z7×Z3);
  parity forces only small groups (`r₃≥2` games are mixed-parity). Scripts banked
  (`../2026-07-05-sumfree-{strat,probe2,verify-local}.py`); local mirror invariants machine-checked
  0-violation on 16 groups.
- **Cross-refs updated:** cyclic theorem note's "Generalization" section + variants note's
  conjecture line now point to the partial theorem.

**Parallel (queens thread, not this umbrella):** launched the **G(17)=2 revalidation** — the deferred
k=1 differential (`queens nimber 17 --min-k 1 --max-k 1` at `QUEENS_TT_BITS=30`, fresh 8.6 GB TT =
independent fingerprint route from the bits=31 run) on the `queens-n18` worktree, tmux
`queens:13` (`g17-k1-reval`, marker `G17_K1_REVAL_DONE`). Overnight run; k=1=WIN reconfirms G(17)=2
and unblocks the A344227 paper/OEIS edits. Rebuilt the stale n18 binary first (`--min-k` postdated
it). See [queens-nimber handoff](handoffs/2026-07-01-queens-nimber-a344227.md).

**Lemma R attacked hard — NOT closed, but a CLEANER REFRAMING found (all banked).**
- **★ Master reduction (new conjecture, strongly supported):** `outcome(G) = outcome(G₆)`, `G₆ =`
  the {2,3}-Sylow — **the 6′-part (order coprime to 6) is outcome-irrelevant.** Solver-verified on
  even+odd groups (`Z10,Z14,Z22,Z2²×Z5,Z30,Z2×Z5×Z3,Z35,Z5×Z3²,…`), 0 mismatches. It is an
  **OUTCOME identity, not a nimber identity** (`G(Z14)=*2` vs `G(Z2)=*1` — only zero-ness preserved
  ⇒ NOT a disjunctive sum). Reframes the whole criterion as a statement about **2-and-3-groups**;
  for odd `G` it becomes "**every nonzero abelian 3-group is N**" (⊇ the `F₃ᵏ=N` conjecture). Same
  difficulty as Lemma R but far cleaner.
- **Mirror-method family CLOSED with a reason:** the combined B-game+negation strategy fails off pure
  `F₃ʳ` (interference); the twisted automorphism mirror `ρ` (negate 6′-part, fix `G₆`) is sum-clean
  **iff `G₆` has no 3-torsion** — the bad term `(ρ−1)z=−2z′` is excluded only by full negation's
  `A=−A` link, which any partial mirror loses. **So full negation is the only sum-clean order-2
  automorphism mirror; its obstruction is inescapably O₂∪O₃.** Mirrors cannot crack `r₃≥2`.
- Scripts: `../2026-07-05-sumfree-{lemmaR,rho,redu}.py`. Details in the abelian-theorem note.

**★ SHARPEST form — the SOCLE reduction (S2-framing payoff):** `outcome(G) = outcome(G[6])`,
`G[6] = (Z₂)^{s₂}×(Z₃)^{r₃}` = the socle — **the outcome depends ONLY on `(2-rank, 3-rank)`.**
Solver-verified on general `G` (`Z9→Z3`, `Z4→Z2`, 6′-parts all collapse; 0 mismatches). It came from
the S2 lens: negation is sum-clean on *every* non-socle element (order-4/8/9/27/coprime all clean),
so the exceptions are exactly the bounded socle `O₂∪O₃`. **Collapses the whole open core to two small
elementary families:** `(Z₃)^b, b≥2` (= the `F₃ᵇ` game, conj. N; solver b≤3 N) and `Z₂×(Z₃)^b, b≥2`
(conj. P; the `Z₂` flips the 3-group outcome). So — modulo the socle reduction — the entire abelian
game reduces to **`F₃ᵇ=N` + the `Z₂`-flip**. Script `../2026-07-05-sumfree-socle.py`.

**Lit + solver sweep of the socle core (3 subagents, 2026-07-05).**
- **Novelty CONFIRMED + no shortcut.** Game-type = Sieben's `AVD` (Node-Kayles on a hypergraph, EJC
  2023); Schur/sum-free instance unpublished, no `F₃ⁿ`/abelian outcome anywhere, OEIS empty.
  **Strategy-stealing is INVALID** (monotonicity fails), no general first-player tool ⇒ `F₃ᵇ=N` needs
  compute or a bespoke first-player strategy. Second-player `Z₂×Z₃ᵇ=P` fits the strictly-matched-
  involution frame. Terminals = "locally maximal sum-free sets" (LMSF).
- **LMSF structure in `F₃ⁿ`** (Green–Ruzsa, Lev JCTA 2005, Giudici–Hart): `μ=3ⁿ⁻¹` (hyperplane
  cosets), **Lev gap** — sizes in `{Ω(3^{n/2})…5·3ⁿ⁻³}∪{3ⁿ⁻¹}`, empty gap `(5·3ⁿ⁻³,3ⁿ⁻¹)`, top two
  odd, small mixed; not well-covered `n≥3`; **no classification below the gap** (where the game
  lives). No parity shortcut.
- **Solver** (`../2026-07-05-sumfree-fast.py`, GL(n,3)-canonical memo): **`Z₂×Z₃³ = P` CONFIRMED**
  (P family verified to b=3); **`F₃⁴` COMPUTE-WALLED** (35M+ nodes/600s, mem-safe) — needs *full*
  `GL(4,3)` min-image (BSGS/partition-backtrack), pure-Python monomial symmetry insufficient. `F₃ᵇ=N`
  verified b≤3.

**★★ THEOREM `F₃ⁿ = N` for all `n` — PROVEN (move-then-mirror).** Reverse-engineered from the
solver's `F₃³` strategy (every reply `= −(x₀+y)`): P1 opens center `o`, then answers each `y` with
the **affine point-reflection `σ(y)=−o−y`** (unique fixed point `o`, already played ⇒ P1 keeps the
one-move lead). Lemma (σ-mirror sum-clean on `F₃ⁿ`) proved algebraically — every new violation
reduces to a violation of `A∪{y}`; the crux `2y=w` sub-case dies by `3y=0` (char 3 essential, matches
why `σ` fails off pure `F₃ⁿ`). Machine-checked 0 violations exhaustive `n≤3` + 1.39M sampled `n=4`
(`../2026-07-05-sumfree-mirror-check.py`). **Resolves `F₃⁴=N`** (which the search solver
compute-walled) by construction. This closes the crux of the socle reduction's `s₂=0` side (with the
socle reduction: `s₂=0 ⟹ N ⟺ r₃≥1`); and it is the bespoke first-player strategy the lit search said
was the *only* route (strategy-stealing invalid). Standalone-novel (lit-confirmed unpublished).

**`Z₂×(Z₃)ᵇ = P` (r₃≥2) — attacked, NOT closed (banked).** Via the proven `s₂=1` reduction ⟺ "`{m}`
is N". Three mover-mirrors FAIL for `b≥2` (`../2026-07-05-sumfree-zm-mover.py`): glide
`γ(ε,h)=(ε+1,−h)`, negation-on-`H`, and `ψ` (fix `m`+center) — all break on the **m-coset** via an O₃
doubling. Structural tension: fixing `m` needs an origin-centered `H`-reflection (= negation, O₃
doubling); off-origin centers move `m`. Unlike pure `F₃ⁿ` (clean) and `r₃=1` (Lemma 4), `{m}` N for
`r₃≥2` has **no clean single-involution mover-mirror** — the last open piece, likely two-phase/
inductive. The solver's `{m}`-strategy is correspondingly not an involution.

**Update (ChatGPT-suggested attacks tried):** two more V-reflection mirrors fail — `ρ(ε,v)=(ε,−o−v)`
(affine σ on V, Z₂ fixed: center `o≠0` moves `m`, and `(0,2o)↦0` since no center is *played* to
self-block it) and e-coord negation `μ` (automorphism ⇒ O₃ doubling on the ⟨e⟩-axis). **5+ involutions
now fail on the same m-obstruction**, structurally pinned: *fixing `m` needs an origin-centered
V-automorphism (= negation, O₃ doubling); any off-origin affine center (which dodges O₃ via char 3)
moves `m`.* The label-rescue pairing also fails directly (answering `(0,v)` on `−v`: `(0,v)+(0,v)=(0,−v)`
doubling, or `(0,v)+(1,−v)=m`). So `{m}` N has **no single-involution mirror** — a real barrier.
**Untried lead = ChatGPT #4 hyperplane induction** (`b→b−1`): split `V=H⊕⟨e⟩`, run the inductive
`Z₂×F₃^{b−1}` strategy on the `e=0` slice `S₀`, pair the `e=1,e=2` slices, handle the ⟨e⟩-axis; a
multi-part (non-involution) argument, the genuine open crux.

**Next:** (1) `Z₂×(Z₃)ᵇ = P` via the ChatGPT-#4 hyperplane induction (`e=0` slice by induction +
`e=1↔e=2` pairing + ⟨e⟩-axis handling) — the open crux, **queued for a dedicated new session**; a
self-contained brief for an external agent (Codex) is written at
[../2026-07-05-codex-assignment-sumfree-socle.md](../2026-07-05-codex-assignment-sumfree-socle.md)
(fast GL(n,3) canonicalizing solver + strategy-verification harness + the #4 attempt + socle
reduction);
(2) prove the socle reduction (still meets the interference wall on the *reduction*, though its two
endpoints `F₃ⁿ=N`/`s₂≥2=P` are now theorems); optional: a BSGS GL(n,3) canonicalizer is no longer
needed for `F₃ᵇ` (proved) but still useful for `Z₂×Z₃ᵇ`. Then OEIS submission (USER); projective
`PG(n,q)` cap; interval octals.

## Handoff Note — session 2026-07-04--3 (`4de57ec0-7625-488b-8b7b-209e783bac6a`)

**HEADLINE:** proved the **cap achievement game on `AG(n,q)` is a second-player win (P) for EVERY
prime power `q` and every `n`** — subsuming and settling the cap-set (`q=3`) "always P" conjecture,
so `d=5` and all `d` are resolved with no computation. Ran the whole session under `mi` (intent-based).
Commits `efedbc5`→`ffddf42` on `main`. Everything below is landed + banked + committed.

**Results index (session --3), by strength:**
1. **THEOREM** — cap game on `AG(n,q)` = P, all `n`, all prime powers `q` (both parities). ★★★
2. **THEOREM** — 3-AP-free (cyclic cap) game: P on **any even-order abelian group** (τ_t mirror,
   `t` order 2); on `Z_n` overall P except sporadic `{1,7,19,47,49}`. New sequence.
3. **Lemma bundle** — graph-general pairing certificates P0/P0′ + abelian-Cayley R0/L1/L2 + odd-order
   impossibility (proof-on-write, generalized past `Z_n`, machine-checked `|Γ|≤16`).
4. **Data + correction** — interval octals `0.[1×k][3×k]7` to m=2·10⁶: no period p≤60000; k=3 ≈m^0.66,
   k=2 ~log; corrected the k=3 last-zero (824→827062).
5. **★ Conjecture (clean, verified ~25 groups)** — the sum-free mod-6 law **generalizes to all finite
   abelian `G`**: P iff 2-rank ≥ 2, or (2-rank ≤ 1 and 2-rank matches 3-torsion-presence). Reproduces
   mod-6 for cyclic. Candidate companion to the `Z_n` sum-free theorem.
6. **New OEIS-absent sequences / conjectures** — sum-free variants (`F₂ᵏ`=P, `F₃ᵏ`=N, Z_n-strong,
   Schur, zero-sum, interval-AP), projective cap game (P in small cases). `F₂ᵏ` = `PG(k−1,2)` cap.
6. **Negative (banked)** — info-theory fishing: no theorem bridge (game value ∉ Strassen/Zuiddam
   spectrum).
Key meta-lesson: "cap-type" (3-AP / a+b+c=0) achievement games are **P-leaning**; the mirror is clean
exactly when the reflection center's identity `3c=0` holds everywhere = char-`p` vector spaces (`F₃ᵈ`),
and degrades to sporadic exceptions over `Z_n`.

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
  `a+b+c=0` → P vs `a+b=c` → N). **★ Also found: the mod-6 law GENERALIZES to all finite abelian `G`**
  — clean criterion (P iff 2-rank≥2, or 2-rank≤1 matching 3-torsion-presence), zero mismatches on ~25
  groups, a candidate companion theorem to the `Z_n` result. Scripts banked.
- **★ 3-AP-free (cyclic cap) game on Z_n — the cleanest new variant**
  ([ap-free-game](../2026-07-04-ap-free-game.md)). The proper cyclic analog of the cap game
  (cap = no 3 collinear = no 3-AP). **P for every n through 55 except the sporadic `{1,7,19,47,49}`**
  (all odd; irregular — 47,49 adjacent, 49=7²; not centered-hexagonal — 37 is P). **Even-order
  abelian ⇒ P is PROVEN** (τ_t translation mirror, `t` order 2 — generalizes even-n `Z_n`;
  the 4∣n gap closes because x+n/4∈A would make x illegal via {x+n/4,x,x+3n/4}). Odd n: mostly P but
  no uniform certificate (midpoint reflection works only n=3,5,9,15; 7,19,47 genuinely N). **Isolates
  why the cap theorem is clean:** its center needs 3c=0 (every c in char p; only {0,n/3,2n/3} in Z_n),
  so Z_n's extra AP-completions (3y−2c,4c−3y) break the mirror sporadically. New OEIS-absent sequence.
- **Next open (priority):** #1 OEIS submission (USER; possibly + the new variant sequences); a formula
  for the AP-free exception set `{1,7,19,47,…}`; interval octals k=2→10⁷ (sub-O(m²) split); projective
  `PG(n,q)` cap "always P" proof; `F₂ᵏ`/`F₃ᵏ` conjectures (non-mirror argument); game-(a) N-side cert.
