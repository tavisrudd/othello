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

By the proven reduction (frame reduction `initialPStatement_iff_isP_frame_of_finrank` + escape crux
`SizeThreeExtensionCountStatement` / `OddEscapeGameStatement`):

```text
PG(2,q) is P  ⟺  every legal size-3 residual grid position "escapes"
                 (has at least one P-valued size-4 child).
```

Equivalently, the conjecture is **false at `q`** iff there is a **trapped size-3 position**: a legal
3-cell residual cap all of whose size-4 children are N.

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
child (depletion bounds:
[`2026-07-08-s4-two-ply-conic-depletion.md`](2026-07-08-s4-two-ply-conic-depletion.md)).

| Regime        | Intruder structure above on-conic S4                       | Trap eliminated?                          |
|---------------|------------------------------------------------------------|-------------------------------------------|
| `q ≤ 7`       | no legal intruder ⇒ pure conic endgame                     | yes — Lean (IntrusionCalculus, `q=5,7`)   |
| `q = 9`       | intruders confined, each kills the whole conic             | yes — computed (C13); Lean kernel open    |
| `11 ≤ q ≤ 19` | unconfined; conic **can** be emptied (`live_on` reaches 0) | computed P; not uniform                   |
| `q ≥ 23`      | unconfined; conic **cannot** be emptied at the S4-layer    | open — needs positive-live-conic steering |

The `q ≥ 23` row is forced by `live_on ≥ q − 19 > 0`: empty-conic base laws that closed `q ≤ 19`
**provably cannot exist** for `q ≥ 23`. That is why the frontier proof must be a *maintenance*
argument on a positive live conic, with two obligations (review
[`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md) §2):

1. **Preservability** — a re-zeroing off-conic intruder always exists. Underwritten as a base-layer
   fact by the reservoir bound `q − k − C(k,2) − 1` (vacuous by `k = 7` at `q = 23`, so a base fact,
   not a recursion).
2. **Termination in P2's favour** — a Nim-value invariant, not an SDR and not a zone matching (the
   matching route is dead below `q ≥ 38`; the static pairing route is the object C28 refuted).

## 4. The two categories of failure

### A. The math is genuinely false (a counterexample odd `q`)

| #  | Mode                                                        | Eliminable?                                                                 |
|----|------------------------------------------------------------|----------------------------------------------------------------------------|
| A1 | sporadic trap at a small computed `q`                      | yes — `q=5,7,11,13` Lean-unconditional; `q=3,9,17,19` computed (mod solver) |
| A2 | trap at a specific uncomputed `q` (25, 29, 31, …)          | per-`q` only, by computing it — never class-closing                         |
| A3 | **eventual failure** (holds small `q`, fails large `q`)    | **no — the central risk; uniform argument only.** Signal: `Z = 2,9,16`     |
| A4 | arithmetic sub-family, esp. **prime-power `q` (Baer)**     | partly — mod-3 refuted as predictor (C29); `q=25,27,49` under-tested        |
| A5 | complete-arc-size spectrum forces odd terminals            | not by arc-counting (area/parity refuted); needs the game-value argument    |

A3 is the mode that most deserves a uniform bound: the recursive steering ceiling `Z` grows
(`2 → 9 → 16` at `q = 13,17,19`) even as the raw zone collapses hugely into it. Bounded `Z` keeps the
"steering + bounded-zone terminal law" shape alive; unbounded `Z` kills that route (not necessarily
the conjecture). A4-prime-powers is the highest-value **falsification watch**: `q = p^{2k}` carries
Baer subplanes (extra dense collinearity), it is the least-computed lane, and it is where the GF
field-arithmetic bugs have lived.

### B. The math is true but our belief/route is invalid ("invalidated")

| #  | Mode                                                        | Status                                                                       |
|----|------------------------------------------------------------|------------------------------------------------------------------------------|
| B1 | solver bug → wrong P/N on COMPUTED rows (`canon()` collide) | eliminable — C8 at `q=11/13`, C37 scaled shared-key check, certcheck; Lean rows immune |
| B2 | a false link in the reduction chain                        | mostly Lean-proven; watch the escape ⇒ root-P direction + 5-arc non-degeneracy |
| B3 | `q=23` **orbit-invariance bridge** unsound                 | not eliminated — residual symmetry ⊊ full `PGL(2,q)`; C36 self-consistency gate tests it |
| B4 | the intended route can't close it even if true             | on-conic route (B4a), termination (B4b), coupling non-decomposition (B4c, C35 measures it), static-pairing dead (B4d) |
| B5 | normal-play vs misère inversion / ruleset conflation       | eliminated in practice (cross-engine tests + Lean pin the ruleset)           |

B3 is the one to discharge before `q=23` is cited as anything but conditional evidence: solving one
bucket representative certifies the whole bucket **only if** value is constant on the conic's
`PGL(2,q)` orbit, and the residual game's actual symmetry group is the stabilizer of the burned
structure, which is smaller. The joint-snapshot necessity law already failed beyond `q=11`, which is
the warning that snapshot invariants over-promise here.

## 5. Verdict

- **Eliminated unconditionally:** `q=5,7,11,13` (Lean); the `q ≤ 7` and `q = 9` regime shapes.
- **Eliminated modulo solver:** `q=3,9,17,19` — B1 is the residual risk, hardened by C37.
- **Finite-checkable, not class-closing:** A2 per-`q`; A4 prime-powers (`q=25,27,49`) — the top
  falsification watch.
- **Conditional, discharge before citing:** B3 (`q=23` orbit bridge) — C36 is the test.
- **Irreducible open core, no computation touches it:** A3 (eventual failure) ≡ B4b/B4c (termination
  + coupling of the maintenance strategy). The growing `Z` is the single empirical signal pointing at
  it, and a uniform `Z`-bound (or a coupling-residual law from C35) is what would close it.

Net: falsity has exactly one shape (trapped size-3), the easy proof routes are provably dead, and the
only closure is a `q`-uniform shape-elimination — concretely the preservability/termination pair plus
C36's finite-type collapse.
