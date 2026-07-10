# Odd-plane conjecture: falsification modes and the proof-by-elimination scaffold

Date: 2026-07-09.

Purpose: state, once, *exactly what would make the odd-`q` planar cap conjecture false*, and organize
the ways it could fail into a proof-by-elimination structure. This is framing, not a task list — it
feeds D1 (§why-a-conjecture) and D3 (the conic-localization scaffold) in
[`2026-07-09-stepping-stone-deliverables-proposal.md`](2026-07-09-stepping-stone-deliverables-proposal.md).
It does not restate the dead routes (handoff §What Is Dead), the two open obligations, or the
de-risking queue items; it is a lens over them.

Program map: [`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md).

## 1. The falsification target (one equivalence)

**Conjecture.** For every odd prime power `q`, `PG(2,q)` is P.

The **escape reduction is now Lean-proven bidirectionally**: escape everywhere ⇔ `PG(2,q)` is P
(`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`; the forward direction is
`GridMirror.initialPStatement_of_oddEscapeStatement_finrank`, and C41 supplies the trap converse via
frame transitivity and value transport). Its contrapositive is exactly what a falsification lives in:

```text
every legal size-3 residual "escapes" (has a P-valued size-4 child)   ⇔   PG(2,q) is P   [Lean-proven]
PG(2,q) is N   ⇔   a trapped size-3 exists (all q²−9q+21 size-4 children N)              [contrapositive]
```

Consequence for the program: eliminating every trap proves the conjecture, and a computationally
found trap is a certified projective counterexample once its residual game facts are trusted by the
same solver/certificate tier. The remaining meta-risk is the usual Lean/spec-match issue (B6), not
the frame-transport link.

Two facts fix the shape of any counterexample:

- The game is finite (`≤ q+1` moves) and impartial ⇒ no draws. "Wrong" means *precisely* one thing:
  some odd `q` admits a trapped size-3 position.
- Every size-3 has exactly `q² − 9q + 21` size-4 extensions, and that count is always positive
  (discriminant `81 − 84 < 0`). So a trap is always **"all children N," never "no children."** No
  size-3 is ever terminal; the failure is a value failure, not an extension-count failure.

This is the statement to lead the paper with: the conjecture *is* "no trapped size-3, uniformly in
`q`."

## 2. Why elimination-over-`q` is a category error

There are infinitely many odd `q`. Computing more `q` **pushes the frontier; it can never close the
conjecture.** Every per-`q` solve is elimination of one point; the tail is infinite. The only
elimination that closes it is over a **`q`-uniform, finite list of structural *shapes*** a trapped
position could take. This is the reason the program is a conjecture and not a theorem, and it decides
which failure modes below are eliminable at all:

- Modes that are one specific `q` (or a computed range) are finite-checkable but never class-closing.
- Modes that are "eventual" or "for a whole arithmetic family" are eliminable **only** by a uniform
  argument — no amount of computation touches them.

## 3. Proof-by-elimination scaffold: kill trapped-position shapes by intruder regime

The difficulty is entirely in the `q ≥ 11` unconfined-intruder regime, and `q ≥ 23` is a distinct
sub-regime. The clean elimination axis is the local intruder structure above an on-conic size-4
child.  C46 extends the old two-ply depletion bound to
`live_on >= max(0,q-(t^2+5t+5))` after `t` further plies, with inverse threshold
`T(q)=ceil((sqrt(4q+5)-5)/2)`
([C46 report](2026-07-09-codex-depletion-ladder.md)).

| Regime        | Intruder structure above on-conic S4                       | Trap eliminated?                          |
|---------------|------------------------------------------------------------|-------------------------------------------|
| `q ≤ 7`       | no legal intruder ⇒ pure conic endgame                     | yes — Lean (IntrusionCalculus, `q=5,7`)   |
| `q = 9`       | intruders confined, each kills the whole conic             | yes — computed (C13); Lean kernel open    |
| `11 ≤ q ≤ 19` | unconfined; `live_on` can reach 0 (witnessed at `q=17`)   | computed P; not uniform                   |
| `q ≥ 23`      | unconfined; conic stays live for every depth `t<T(q)` (`T(23)=3`, asymptotically `sqrt(q)+O(1)`) | q=23 computed modulo solver; uniform proof open — needs positive-live-conic steering |

The `q ≥ 23` row includes the old two-ply bound `live_on ≥ q − 19 > 0` as the `t=2` instance.
More generally, conic-emptying is excluded at every depth `t<T(q)`; it is not asserted to occur at
`T(q)`.  Thus a *two-ply* empty-conic argument does not extend past `q = 19`
(later emptying is not excluded, and `q ≤ 19` was not itself *closed* by an empty-conic law —
q=11/13 are certificates, q=17/19 computed; the empty-conic law is the proposed q=17-mined target).
That is why the frontier proof must be a positive-live `Good`-closure argument in the sense of
`FiniteBuildGame.isP_of_replyStrategy`, not a separate "preserve plus terminate" track.  The
obligation is:

```text
Good S and opponent plays legal x
    => some legal reply y has Good (S+x+y).
```

The reservoir bound `q − k − C(k,2) − 1` (vacuous by `k = 7` at `q = 23`) underwrites only the
*availability* of legal off-conic cells in base layers; it does not by itself prove that an
available cell returns to `Good`.  That closure is the missing mining/proof target.

## 4. The two categories of failure

### A. The math is genuinely false (a counterexample odd `q`)

| #  | Mode                                                        | Eliminable?                                                                 |
|----|------------------------------------------------------------|----------------------------------------------------------------------------|
| A1 | sporadic trap at a small computed `q`                      | yes — `q=5,7,11,13` Lean-unconditional; `q=9,17,19` computed (mod solver); `q=3` trivial (no legal size-3 in AG(2,3)) |
| A2 | trap at a specific uncomputed `q` (25, 29, 31, …)          | per-`q` only, by computing it — never class-closing                         |
| A3 | **eventual failure** (holds small `q`, fails large `q`)    | **no — the central risk; uniform argument only.** Signals: `Z = 2,9,16`; §6 heuristic — no main-layer counterexample signal, but erratic (no monotone bound) |
| A4 | arithmetic sub-family, esp. **square `q` (Baer subplanes)** | partly — mod-3 refuted as predictor (C29); `q=25,49` under-tested (`q=27` is char-3, separate) |
| A5 | complete-arc-size spectrum forces odd terminals            | not by arc-counting (area/parity refuted); needs the game-value argument    |

A3 is the mode that most deserves a uniform bound: the recursive steering ceiling `Z` grows
(`2 → 9 → 16` at `q = 13,17,19`) even as the raw zone collapses hugely into it. Bounded `Z` keeps the
"steering + bounded-zone terminal law" shape alive; unbounded `Z` kills that route (not necessarily
the conjecture). A4-squares is the highest-value **falsification watch**: a square order `q = p^{2k}`
carries a Baer subplane (extra dense collinearity) — `q = 9` is the smallest and is already
computed-P (reassuring), leaving `q = 25, 49` as the untested squares, the least-computed lane and
where the GF field-arithmetic bugs have lived. `q = 27 = 3³` is not square (no Baer) and belongs to
the char-3 regime, not here.

### B. The math is true but our belief/route is invalid ("invalidated")

| #  | Mode                                                        | Status                                                                       |
|----|------------------------------------------------------------|------------------------------------------------------------------------------|
| B1 | solver bug → wrong P/N on COMPUTED rows (`canon()` collide) | eliminable — C8 at `q=11/13`, C37 scaled shared-key check, certcheck; Lean rows immune |
| B2 | a false link in the reduction chain                        | escape ⇔ root-P is now Lean-proven by C41 (`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`), and 5-arc non-degeneracy is a Lean theorem (`uniqueConicThroughFiveArc…`); the remaining watch is spec-match B6, not the reduction link |
| B3 | `q=23` **orbit-invariance bridge** unsound                 | eliminated — Lemma I/full-PGL conic-projectivity transport is **now a verified Lean theorem** (`ProjectiveCap.Sym2Bridge.onconic_value_bridge`, C53 parts 1–2; see `2026-07-09-codex-full-pgl-bridge.md`) |
| B4 | the intended route can't close it even if true             | on-conic route (B4a), missing positive-live `Good` closure (B4b), coupling non-decomposition (B4c, **measured by C35: confirmed** — no conic⊕zone sum at S5/S6, `g = g_conic XOR g_zone` fails on most rows even where zone Grundy is fully computable), static-pairing dead (B4d) |
| B5 | normal-play vs misère inversion / ruleset conflation       | eliminated in practice (cross-engine tests + Lean pin the ruleset)           |
| B6 | **spec mismatch** — Lean's endpoint definitions formalize a subtly different game than intended | Lean cannot self-certify this; B5 and A1's "Lean rows immune" use Lean as the oracle, so it is circular if the spec is off. Mitigated by `q=5,7` Lean-vs-computed agreement + a raw-bitmask legality spotcheck, not eliminated |

The former B3 concern is no longer a reason to downgrade `q=23`.  The key correction is that an
on-conic S4 follower is determined by the unordered six played projective points on the conic; the
two burned/pre-played points are selected points, not residual labels.  A conic-stabilizing
projectivity induced by full `PGL(2,q)` therefore transports the entire follower game.  This bridge
is **now a verified Lean theorem** (C53 parts 1–2, `Sym2Bridge.onconic_value_bridge`); what remains
is to certify the 22 computed bucket labels themselves (C54), not to solve duplicate stabilizer
representatives.

## 5. Verdict

- **Eliminated unconditionally:** `q=5,7,11,13` (Lean); the `q ≤ 7` and `q = 9` regime shapes.
- **Eliminated modulo solver:** `q=9,17,19` (`q=3` trivial) — B1/B6 are the residual risks, hardened by C37.
- **Finite-checkable, not class-closing:** A2 per-`q`; A4 squares (`q=25,49`) — the top falsification watch (queued: **C44** for q=25).
- **Former conditional now removed:** B3 (`q=23` orbit bridge) is settled by the full-PGL bridge
  argument, **now a verified Lean theorem** (C53 parts 1–2); q=23 may be cited as a computed row
  modulo the ordinary solver/certificate trust chain, with C54 assigned to strengthen that
  certificate tier.
- **Irreducible open core:** A3 (eventual failure). It is a *truth*-mode, distinct from — not equal
  to — the *route*-modes B4b/B4c (`Good` closure + coupling); they share instruments, not a definition.
  No per-`q` computation eliminates A3; the §6 witness-count heuristic is the one instrument that
  *predicts* on it — currently no main-layer counterexample signal, but erratic, so A3 stays open. A
  uniform `Z`-bound (or a coupling-residual law from C35) would close it; the finite-type route to
  the class-stability lower-bound (§6) is now **closed negative** (the type-alignment test; **C42**'s fixed-`q` census half then also reported
  **negative** — every size-3 class has a distinct census vector even at the all-P orders, so no
  propagation mechanism exists either), so the on-conic
  concentration must be attacked through the arc-depletion arithmetic (A5), not a `q`-uniform type
  census.

Net: falsity has exactly one shape (trapped size-3), the easy proof routes are provably dead, and the
only closure is a `q`-uniform shape-elimination — concretely a positive-live `Good`-closure lemma
plus finite obstruction lists (C36's cross-`q` nonconstant types; the alignment test's
depletion-flip set). The finite-type *collapse* is refuted, C42 supplies no propagation mechanism,
the localization survives, and the on-conic anchor must come from arc-depletion arithmetic (A5) or
another direct closure argument.

## 6. The A3 test: witness-count heuristic

First-moment (Tao-style) test of A3. Model each size-3 class's P-child count as `Poisson(mu(q))`;
with `N_canon(q)` classes the expected trapped count is `N_canon·exp(−mu)`, so escape survives as
long as `mu(q) > ln N_canon(q)`. Measured over `q = 5,7,9,11,13,17,19` (feat-mode full census,
[`2026-07-09-witness-count-heuristic.md`](2026-07-09-witness-count-heuristic.md)), on two layers —
TOTAL P-children (main conjecture) and ON-conic P-children (the (ON)/D3 route):

- **TOTAL** clears the line at every `q` (margin `+1.0` at the degenerate single-class `q=5`, `+5.9`
  at `q=7`, then `≥ +6.5` for `q ≥ 9`, tightest interior at `q=17`; Poisson-null
  `E0_total ≤ 2.7e-3` for `q ≥ 7`). No trend toward a trap — not a counterexample signal.
- **ON** dips *below* the line at `q=17` (`mu_on = 2.71 < ln N_canon = 3.05`, margin `−0.33`,
  `E0_on = 1.39`): the first moment predicts ≈1.4 trapped on-conic classes, yet the observed
  minimum is `m_on = 1` (the "one on-conic witness" knife edge). It survives only because the
  on-conic count is a near-point-mass (dispersion `≤ 0.4 ≪ 1`), i.e. protected by **concentration,
  not by a growing mean**.

Both `mu` are erratic (`R² ≈ 0.48` for any linear/log fit; the dips are **value-depletion** — fewer
P-valued among the `q−4` legal on-conic cells at `q = 11, 17` — not loss of legal cells, so this is
distinct from the `live_on` legal-cell bound), so the heuristic yields **no monotone margin** and
does not by itself discharge A3. Reading: the main conjecture is safe over the computed range but not
"safe for a reason"; the (ON) route is safe-but-tight with a genuine **B4a** warning at `q=17`.

The counts are deterministic — there is no randomness, so neither *moment* is the proof target. The
on-conic P-count is nearly a **function of `q`** (point masses, dispersion `≤ 0.4`). The uniform (ON)
target is therefore a **class-stability lemma** (the P-count varies by `≤` a small constant `C`
across classes at fixed `q`) plus an **anchor lower-bound** (some class `≥ C+1`), giving min `≥ 1`;
`q=17` sits exactly at that edge (on-conic max `= 3 = C+1`, `C ≈ 2`). Bounding a *mean* (a
character-sum / Weil estimate) attacks the right quantity with an empirically false main term — the
depletion is macroscopic (`≈ 0.21·(q−4)` at `q=17`), not an `O(√q)` defect.

The factorization attack on this concentration (queued as **C42**) has now been RUN — the
on-conic-child type-alignment test
([`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md)).
Verdict: **the cross-`q` half is refuted.** *Within* a fixed `q`, value IS a function of the exact
stabilizer orbit (self-consistency 0 violations, reproducing the C5/C15 PGL buckets), so the
concentration is genuinely type-determined at each `q`. But the type→value map is **not
`q`-independent**: 119 integral configuration types flip value across `q`, and the flip is perfectly
systematic — **N at an arc-depleted order, P everywhere else** (all flips at the depleted `q=11,17`;
zero at the full `q=13,19`; minimal witness `{∞,0,−4,−3,−2,1}`). So the point mass is
**arc-depletion (arithmetic)-driven, not a `q`-uniform type function**: the finite type→value table
does not exist, the finite-type route to a uniform (ON) bound is **closed negative**, and the
full-PGL bridge is only a fixed-q transport: a `q=17` solve cannot predict `q=19/23`. The uniform (ON) argument must
engage the arc-depletion arithmetic — i.e. this route merges into **A5** (the complete-arc
spectrum), not a combinatorial type census.
