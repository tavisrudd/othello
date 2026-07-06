# PG(2,q) cap game: the escape margin is ERRATIC, and `bad ≈ total` at q=17 (2026-07-06)

Route (A) data extension past the pure-Python q=11 wall (handoff "push the escape/parity table
… Rust solver + a per-size-3 escape mode"). Result is a **significant negative** that corrects
the over-optimistic framing in `2026-07-06-escape-count-lemma.md` and `-frame-reduction.md`:
the **escape margin does not grow and is not bounded-below by a monotone trend** — it is
erratic, tracking the (number-theoretically irregular) abundance of odd complete arcs. At q=17
the "escape" collapses to **5 of 157** (`bad ≈ total`), so the crux `escape ≥ 1` is a *delicate
near-cancellation of two Θ(q²) quantities*, not a comfortable area margin.

## The tool

Added an `escape` mode to `2026-07-06-grid-cap-solver.rs` (single-threaded, light footprint):
full-expansion P/N memo, then over **all canonical size-3 grid classes** it reports, per the
frame reduction / total lemma,

- `total = q²−9q+21` (the total lemma constant),
- `escape(S₃)` = # **P** size-4 children (a class invariant),
- `bad(S₃) = total − escape` (# N size-4 children = extensions embedding in an odd maximal cap),
- `min/max escape`, the escape histogram, and the count of **even-escape** classes (= `bad` odd,
  where the parity proof breaks), plus a representative cell-list for the min-escape class.

Invoke: `gridcap escape <q> [q2 …]`.

**Validation (exact, independent code path).** `2026-07-06-escape-spotcheck.py` is a
self-contained *raw-bitmask* solver (no grid-automorphism canon, no shared memo) that counts the
escape of one explicit S₃. It matches the Rust `escape` mode **exactly** on the min-escape
representatives:

| q | min-escape S₃ (Rust) | Rust escape/total | raw-solver escape/total |
|---:|---|---:|---:|
| 11 | `(0,0),(1,1),(2,3)` | 13 / 43 | **13 / 43** ✓ |
| 13 | `(0,0),(1,1),(3,4)` | 46 / 73 | **46 / 73** ✓ |
| 17 | `(0,0),(1,1),(2,5)` | 5 / 157 | **5 / 157** ✓ |

(q=11's min rep `(0,0),(1,1),(2,3)` also matches the escape-margin note's min-triangle.) The
Rust class-level histograms also reproduce the pure-Python `escape-margin.py` results at q≤11.

## The data (all root = P; crux `escape ≥ 1` holds every case)

| q | total (q²−9q+21) | min-escape | max-escape | **max-bad** (=total−min) | bad-odd classes | `bad/total` (max) |
|---:|---:|---:|---:|---:|---:|---:|
| 5 | 1 | 1 | 1 | 0 | 0/1 | 0.00 |
| 7 | 7 | 7 | 7 | 0 | 0/3 | 0.00 |
| 9 | 21 | 13 | 21 | 8 | 0/5 | 0.38 |
| 11 | 43 | 13 | 18 | 30 | 2/8 | 0.70 |
| 13 | 73 | 46 | 49 | 27 | 3/12 | 0.37 |
| 17 | 157 | **5** | 11 | **152** | 12/21 | **0.97** |
| 19 | 211 | **211** | 211 | **0** | 0/27 | 0.00 |

Escape histograms (escape:classes): q=9 `13:3 21:2`; q=11 `13:6 18:2`; q=13 `46:3 47:6 49:3`;
q=17 `5:3 10:12 11:6`.

## What this refutes

**1. "total (O(q²)) outgrows bad" is FALSE beyond small q.** `escape-count-lemma.md` argued the
crux holds because `total ≈ area` grows while `bad` (odd-maximal-cap cover) stays small — the
min-escape triangle table (0, 0, 8 bad at q=5,7,9) looked bounded. **At q=17, `bad = 152` of
`total = 157` — odd maximal caps cover 97% of a 3-cap's legal extensions.** So `bad` is **Θ(q²)**,
nearly equal to `total`; **sub-attack 1 (bound `bad = o(q²)` by arc theory) is dead** — there is
no room for a crude area bound. The margin `escape = total − bad` is a fine cancellation.

**2. The escape margin is ERRATIC, not monotone.** min-escape `= 1, 7, 13, 13, 46, 5` for
`q = 5,7,9,11,13,17`. It jumps up (46 at q=13) then crashes to 5 at q=17. The
frame-reduction note's "the tight q=5 case relaxes as q grows" and the escape-count-lemma's
implied floor are **both wrong**. The margin is governed by the abundance/coverage of **odd
complete arcs** through the burned pair, which is irregular in `q` (a hard finite-geometry
quantity), so the margin has no monotone trend.

**3. Parity (sub-attack 2) also weakens.** `bad`-odd (even-escape) class fraction:
0, 0, 0, 25%, 25%, **57%**, 0% for q=5,7,9,11,13,17,19. The parity proof (`escape ≡ 1 − bad mod
2`, needs `bad` even) works only where `bad` is even; at q=17 `bad` is **odd on the majority** of
size-3 classes, so parity covers a minority. (q=19 is back to 0% — `bad = 0` everywhere, pure
parity — underscoring the irregularity.)

## The min-dev-size / escape link (cross-validation, and a second correction)

`min-dev-size` (the `defect` mode's smallest parity-deviating size) and `min-escape` are two
readings of the **same** root condition, via the frame chain:

> root = P  ⟺  every size-3 class is N  ⟺  **min-escape ≥ 1**  ⟺  **min-dev-size ≥ 4**.

Sizes 0,1,2 are single orbits whose values are forced by the chain `P→N→P` from the root, so a
deviation can only first appear at size 0 (root itself N) or size ≥ 4. Hence
**min-dev-size ∈ {0} ∪ {4,5,6,…}** — it jumps from 0 (root N, a counterexample) straight to ≥4.
The value **4 vs 6 measures endgame defect depth, not a root-safety buffer**: the root is equally
P whether min-dev-size is 4 or 6. So the gridcap-ladder note's "margin grows 4→6 ⇒ the root gets
safer" is a **misreading** — the rigorous content is just "root P, confirmed exhaustively through
q=19"; the finer, *accurate* safety measure is the erratic min-escape, and it does **not** grow.

The link gives a clean cross-check between two independent code paths (escape mode vs defect mode):

- min-dev-size = 4 (defect mode, q=9,11,13,17) ⟺ some size-4 class is N ⟺ some size-3 has
  `bad > 0` ⟺ **min-escape < total**. ✓ (escape mode: 13<21, 13<43, 46<73, 5<157).
- min-dev-size = 6 (defect mode, q=19) ⟺ **no** size-4/5 defect ⟺ **every** size-4 class is P
  ⟺ `bad = 0` for all size-3 ⟺ **min-escape = total = 211**, all `bad` even (parity holds).
  → **CONFIRMED**: the escape run gives q=19 `min-escape = max-escape = 211`, histogram `211:27`,
  `bad`-odd `0/27`, parity HOLDS. Two independent code paths (escape vs defect) agree exactly.

So q=19 is **pure parity at low sizes** — min-escape jumps back to the maximum 211 (`bad = 0`
everywhere) — while q=17 is the thinnest margin seen (5, `bad ≈ total`). The margin swinging from
**5 (q=17) to 211 (q=19)** is the sharpest statement that it is arc-driven and unpredictable,
**not** a monotone buffer.

## Implications for the proof (route A reassessment)

- **Counting/area route of (A) is closed.** `bad` is Θ(q²) (≈ total at q=17), so no upper bound
  of the form `bad = o(q²)` exists; and parity covers only a shrinking minority. Proving
  `escape ≥ 1` requires the *fine* structure of the near-cancellation, not a size bound.
- **The falsification test is genuinely LIVE.** min-escape is small (5) and erratic; nothing in
  the data forces it `≥ 1` asymptotically. The conjecture `PG(2,q)=P` is *not* protected by any
  margin — only by exhaustive verification, which is walled at q=19 on this box. A counterexample
  at larger `q` is not excluded by any trend.
- **Live routes now:** (i) a **direct strategy** (adaptive re-symmetrisation — the relaxed form
  reaches a symmetric position at q≤13 per `-adaptive-resym-test.py`; needs a maintainable
  invariant), or (ii) a **finer invariant** than mod-2 parity that survives when `bad` is odd and
  explains the persistent `escape ≥ 1` despite `bad ≈ total`. (iii) Pushing exhaustive
  falsification past q=19 needs a bigger box or a tighter key.
- A geometric shortcut: **if** the boundary characterization "size-4 N ⟺ embeds in an odd
  maximal cap" (validated q≤9) still holds at q=13,17, then `bad` is computable from *arc
  geometry alone* (no game recursion), which could push the falsification watch past q=19 far
  more cheaply. Worth testing the characterization at q=13,17 next.

## Artifacts

- `2026-07-06-grid-cap-solver.rs` — new `escape` mode (per-size-3 escape/bad-parity + min rep).
- `2026-07-06-escape-spotcheck.py` — independent raw-bitmask escape count for one S₃ (validation).
- `2026-07-06-escape-q17.log`, `-escape-q19.log` — escape-mode run logs.
