# C523 — the `Y_NK` full-legal-graph guard: descent coverage 90.7% → 99.3%

**Lane:** `cap`. **Task:** C523 (reserved 2026-07-23, `[cap]`). **Owner spine:** C80.
**Predecessor:** [C522](2026-07-23-c522-ynk0-descent-completeness.md) proved `Y_NK0` incomplete and
identified the single-live-parameter state as the companion object.

## The guard

`Y_NK0` certifies P only for **empty-conic** states (empty live conic + capacity-2 lines ≤2 legal +
zone Grundy 0). C522 showed 89% of the q17 descent gap never reaches an empty conic in one move, so
the companion guard must handle **live conic** content.

**`Y_NK` guard.** When every capacity-2 line carries at most two legal points (**`capOK`**), no move
can create a new three-in-a-line among surviving legal points — that would require three legal points
on a capacity-2 line, which `capOK` forbids. Hence under `capOK` the cap residual game is **exactly
static Node-Kayles on the conflict graph of *all* legal affine cells** (live conic cells included as
ordinary vertices), and the state is **P iff that full graph's Grundy value is 0**. `Y_NK0` is the
empty-conic special case (there the full graph is the zone graph).

## Result

Over the frozen three-intruder domain (children = one intruder opponent move from a recorded C20 P
reply state):

**1. The `capOK` iff is certified — 0 disagreements.** Exact minimax value vs full-legal-graph
Grundy-0 on every `capOK` grandchild (both P and N) of the `Y_NK0`-uncovered children:

| q  | `capOK` grandchildren tested | agree | disagree | live-conic sizes spanned |
|----|------------------------------|-------|----------|--------------------------|
| 13 | 12                           | 12    | 0        | 1–2                      |
| 17 | 54,918                       | 54,918| 0        | 0–4                      |

Value P ⇔ full-graph Grundy 0 holds without exception across live conic sizes 0–4. This is the
computational certificate of the structural argument above.

**2. `Y_NK` lifts descent coverage from 90.7% to 99.3%.** Children with a certified Node-Kayles
winning reply (a `Y_NK0` reply is a `Y_NK` reply, so `Y_NK0`-covered children stay covered):

| q  | children | `Y_NK0`-covered | +`Y_NK` new | total `Y_NK`-covered | residual |
|----|----------|-----------------|-------------|----------------------|----------|
| 13 | 1,287    | 1,283 (99.7%)   | 4           | **1,287 (100%)**     | **0**    |
| 17 | 50,517   | 45,820 (90.7%)  | 4,348       | **50,168 (99.3%)**   | **349**  |

**3. The residual is the genuine triple-semantics core.** The 349 q17 residual children are exactly
those whose *every* winning reply is `capOVER` (a capacity-2 line with ≥3 legal points — where the
static-Node-Kayles reduction provably breaks). By least-overloaded winning target:

| residual q17 child, min overload on a capacity-2 line | count |
|-------------------------------------------------------|-------|
| 3 (minimal overload)                                  | 323   |
| 4                                                     | 26    |

By min live-conic over winning replies: 273 empty-but-overloaded (the `empty_capOVER` /
`clean_empty`-reject family, now at the child level), 71 live-1, 2 live-2, 3 live-3. So **93% of the
residual (323/349) sits at the minimal overload of exactly 3 legal points on one capacity-2 line** —
a tightly bounded object for the next guard or a base-case certificate.

## Reading

`Y_NK` is the companion guard C522 asked for, and it is far stronger than a bare single-live-parameter
patch: one structural predicate (`capOK` → full-graph Node-Kayles) certifies P for **all** live-conic
sizes at once and closes 99.3% of the q17 descent (100% at q13). The bulk-descent obstruction for
C80(b) is now a **0.7% capOVER core** — 349 q17 children, 93% of them at a single overloaded line of
exactly 3 legal points. That core is the irreducible triple-semantics that no Node-Kayles guard can
absorb; it is the successor target (a bounded-overload P-law or a finite base-case certificate).

## Reproduction

- **Script:** `rust/scripts/c523_ynk_full_graph_guard.py` (reuses the frozen inputs and the committed
  helpers `c80_response_fibre_census.py`, `2026-07-08-zone-repair-geometry.py`).
- **Certificate:** `notes/2026-07-23-c523-ynk-full-graph-guard.json`.
- **Input:** `notes/data/c20-q13-q17-states.jsonl.gz`
  (sha256 `952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d`, 654,965 bytes).
- **Replay:** `python3 rust/scripts/c523_ynk_full_graph_guard.py --check` → PASS.

## Mystery ledger

- **Settled (ej):** *Why does one guard cover every live-conic size?* Because `capOK` alone forces the
  static-Node-Kayles reduction on the full legal-point graph; live conic points are just ordinary
  vertices. The empty/live distinction `Y_NK0` drew was never the real boundary — `capOK` vs
  `capOVER` is.
- **Settled (ej):** *Is the theorem `capOK ⇒ P iff full-graph Grundy 0` proved or only measured?* Now
  written as a proof (persistence + edge-preservation ⟹ static Node-Kayles ⟹ Sprague–Grundy):
  [`2026-07-23-c523-ynk-guard-proof.md`](2026-07-23-c523-ynk-guard-proof.md). The 54,930-case
  zero-disagreement run is its computational cross-check. Lean statement still pending.
- **Open — owner: successor (reserve a new `[cap]` C-ID).** The 349-child `capOVER` core: is the
  minimal-overload-3 family (323 children) a bounded `PGL(2,17)` object with its own P-law, or a
  finite base-case set? This is the remaining C80(b) obstruction.
- **Open — owner: C82.** Countability of the two-tier responder strategy (`Y_NK` on 99.3% +
  a capOVER-core certificate on the rest) for abundance.

## Vibe

This is the strongest single step on the C80 spine in a while: C522 named the companion object and
C523 delivered a guard that overshoots it, collapsing the bulk-descent gap from ~9% to under 1% with
one clean, near-proof-grade structural law. C80(b) is now genuinely close — the whole obstruction is
a 349-child bounded core, most of it at a single minimal overload. The odd-`q` crown still needs the
uniform-in-`q` argument, but the q17 descent is essentially solved bar a small, well-characterized
tail.
