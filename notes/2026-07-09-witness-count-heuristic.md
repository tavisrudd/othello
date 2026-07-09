# Witness-count heuristic for the odd-plane conjecture (the A3 test)

Date: 2026-07-09.

Purpose: apply a Tao-style first-moment / extreme-value heuristic to the size-3 escape data and
ask, quantitatively, whether the odd-`q` planar cap conjecture is *safe for a reason* or *heading
toward a counterexample* — separately for the main conjecture and for the conic-localized (ON)
proof route. This feeds the A3 row and §5 of
[`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md) and the
Odd-Plane Kernel / Conic Localization section of
[`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md).

## 1. The heuristic

By the proven reduction, `PG(2,q)` is P ⟺ every legal size-3 residual "escapes" = has ≥1 P-valued
size-4 child. The conjecture is false at `q` iff some size-3 class is **trapped** (zero P-children).

Model each size-3 class's P-child count as ~`Poisson(mu(q))`. With `N_canon(q)` canonical size-3
classes, the expected number of trapped (zero-count) classes is `N_canon(q)·exp(−mu(q))`, so the
min-over-classes count stays ≥1 as long as roughly

```text
mu(q) > ln N_canon(q)      (first-moment safety condition)
```

Two layers are tracked separately:

- **TOTAL** P-children per size-3 (on-conic OR off-conic) — margin for the **main conjecture**.
  Trapped iff total-min `m_total = 0`.
- **ON-conic** P-children per size-3 (`pos==on`) — margin for the intended **conic-localized
  (ON)/D3 route**. The handoff's knife edge: the `q=17` min-escape classes have exactly one
  on-conic witness. If `m_on → 0` but `m_total` stays ≥1, that is failure-mode **B4a** (route dies,
  conjecture survives); if `m_total → 0` that is the genuine **A3** counterexample signal.

## 2. Data and coverage

Source = the feat-mode per-size-3 census (`solve_feat` in
[`2026-07-06-grid-cap-solver.rs`](2026-07-06-grid-cap-solver.rs)), which emits per class a `CLS`
summary `escape=<total-P> onP onN extP extN intP intN` plus one `X … val= pos=` line per size-4
extension. `escape` = total P-children; on-conic children per class = `q−4` (asserted `legal_on`);
`pos==on|int|ext` split by conic membership / tangent count (int = 0 tangents, ext = 2).

| feat file                          | q  | coverage (pos values present) |
|------------------------------------|---:|-------------------------------|
| `notes/data/codex-feat5.out`       |  5 | on/int/ext (full census)      |
| `notes/data/codex-feat7.out`       |  7 | on/int/ext (full census)      |
| `notes/data/codex-feat9.out`       |  9 | on/int/ext (full census)      |
| `notes/data/codex-feat11-c15.out`  | 11 | on/int/ext (full census)      |
| `notes/data/codex-feat13-c15.out`  | 13 | on/int/ext (full census)      |
| `notes/data/codex-feat17.out`      | 17 | on/int/ext (full census)      |
| `notes/data/codex-feat19-c15.out`  | 19 | on/int/ext (full census)      |

**Every feat file is a full census** (the `-c15` suffix is a solver run tag, not an on-conic
filter — each contains `pos=int` and `pos=ext` lines). So the TOTAL layer is read directly from
`escape=`, no fallback to the escape logs is needed. The `q=5,7,9` anchors were regenerated this
session (single-core, seconds each); `q=11..19` are the pre-existing dumps.

Escape full logs (`notes/2026-07-07-escape-q{17,19}-full.log`) are used only for the cross-check.
There is no escape log for `q=11,13`; not needed (feat is full census). `q≥23` size-3 census is
memo-capped and expensive — **out of scope**; `mu/m` at the size-3 layer are not cheaply available
there.

## 3. Cross-check (data integrity)

For `q=17,19` (both a full-census feat file and an escape log exist), the feat `escape=` value
must equal the escape-log `escape=` value per class, matched by the `S3=[…]` cell list. Also, per
class the feat `escape` must equal the count of `X … val=P` lines. Both pass:

```text
CROSS-CHECK  feat escape (val==P over all pos)  vs  escape-log escape=
  q=17: matched 21/21 classes by S3  -> PASS
  q=19: matched 27/27 classes by S3  -> PASS
  internal X-line vs CLS-escape consistency: PASS
  CROSS-CHECK RESULT: PASS
```

## 4. Per-`q` witness distributions (verbatim)

```text
q=5  N_canon=1  total-extensions(q^2-9q+21)=1  on-conic-capacity(q-4)=1
  TOTAL P : mu=1.000 min=1 max=1  hist(P:classes)= 1:1
  ON    P : mu=1.000 min=1 max=1  hist= 1:1
  INT   P : mu=0.000 min=0 max=0  hist= 0:1
  EXT   P : mu=0.000 min=0 max=0  hist= 0:1

q=7  N_canon=3  total-extensions=7  on-conic-capacity(q-4)=3
  TOTAL P : mu=7.000 min=7 max=7  hist= 7:3
  ON    P : mu=3.000 min=3 max=3  hist= 3:3
  INT   P : mu=0.000 min=0 max=0  hist= 0:3
  EXT   P : mu=4.000 min=4 max=4  hist= 4:3

q=9  N_canon=5  total-extensions=21  on-conic-capacity(q-4)=5
  TOTAL P : mu=16.200 min=13 max=21  hist= 13:3 21:2
  ON    P : mu=5.000 min=5 max=5  hist= 5:5
  INT   P : mu=4.800 min=4 max=6  hist= 4:3 6:2
  EXT   P : mu=6.400 min=4 max=10  hist= 4:3 10:2

q=11  N_canon=8  total-extensions=43  on-conic-capacity(q-4)=7
  TOTAL P : mu=14.250 min=13 max=18  hist= 13:6 18:2
  ON    P : mu=4.250 min=2 max=5  hist= 2:2 5:6
  INT   P : mu=3.500 min=3 max=5  hist= 3:6 5:2
  EXT   P : mu=6.500 min=5 max=11  hist= 5:6 11:2

q=13  N_canon=12  total-extensions=73  on-conic-capacity(q-4)=9
  TOTAL P : mu=47.250 min=46 max=49  hist= 46:3 47:6 49:3
  ON    P : mu=9.000 min=9 max=9  hist= 9:12
  INT   P : mu=14.250 min=13 max=16  hist= 13:6 15:3 16:3
  EXT   P : mu=24.000 min=22 max=25  hist= 22:3 24:3 25:6

q=17  N_canon=21  total-extensions=157  on-conic-capacity(q-4)=13
  TOTAL P : mu=9.571 min=5 max=11  hist= 5:3 10:12 11:6
  ON    P : mu=2.714 min=1 max=3  hist= 1:3 3:18
  INT   P : mu=3.429 min=2 max=6  hist= 2:9 3:6 6:6
  EXT   P : mu=3.429 min=1 max=5  hist= 1:6 2:3 5:12

q=19  N_canon=27  total-extensions=211  on-conic-capacity(q-4)=15
  TOTAL P : mu=211.000 min=211 max=211  hist= 211:27
  ON    P : mu=15.000 min=15 max=15  hist= 15:27
  INT   P : mu=88.815 min=86 max=90  hist= 86:8 90:19
  EXT   P : mu=107.185 min=106 max=110  hist= 106:19 110:8
```

The TOTAL-layer `m_total = 1,7,13,13,46,5,211` reproduces the min-escape column of
[`2026-07-06-escape-margin-erratic.md`](2026-07-06-escape-margin-erratic.md) exactly.

## 5. The heuristic table

```text
   q    N_can      lnN     2lnq   mu_tot    m_tot    mu_on     m_on  tot-lnN   on-lnN    E0_tot    E0_on
   5        1    0.000    3.219    1.000        1    1.000        1   +1.000   +1.000  3.68e-01    0.368
   7        3    1.099    3.892    7.000        7    3.000        3   +5.901   +1.901  2.74e-03    0.149
   9        5    1.609    4.394   16.200       13    5.000        5  +14.591   +3.391  4.61e-07    0.034
  11        8    2.079    4.796   14.250       13    4.250        2  +12.171   +2.171  5.18e-06    0.114
  13       12    2.485    5.130   47.250       46    9.000        9  +44.765   +6.515  3.62e-20    0.001
  17       21    3.045    5.666    9.571        5    2.714        1   +6.527   -0.330  1.46e-03    1.391
  19       27    3.296    5.889  211.000      211   15.000       15 +207.704  +11.704  6.24e-91    0.000
```

`E0_x = N_canon·exp(−mu_x)` = Poisson-null expected number of trapped (zero-witness) classes.
`on-conic fill fraction` `mu_on/(q−4)` = `1.00, 1.00, 1.00, 0.61, 1.00, 0.21, 1.00`.

Readings:

- **TOTAL layer safe over the computed range.** `mu_total > ln N_canon` at every `q`; the margin is
  smallest at the degenerate single-class `q=5` (`+1.0`) and `q=7` (`+5.9`), then `≥ +6.5` for
  `q ≥ 9` (tightest interior `+6.53` at `q=17`). `E0_total ≤ 2.7e-3` for `q≥7` (the `0.37` at `q=5` is the
  degenerate single-class case). The Poisson null never predicts a total-trapped class over
  `q ≤ 19`. `m_total` never approaches 0 and *recovers* after its `q=17` dip (5 → 211 at `q=19`).
- **ON layer is a knife edge and dips BELOW the safety line at `q=17`.** `mu_on − ln N_canon` is
  positive everywhere except `q=17`, where it is **−0.33**. There `E0_on = 1.39`: the first-moment
  heuristic actively *predicts ≈1.4 trapped on-conic classes*. Observed `m_on = 1` — the handoff's
  "exactly one on-conic witness" — so no class is actually trapped, but the on-conic margin has
  gone negative. This is the intruder-depletion regime: the on-conic fill fraction collapses to
  0.21 (only 21% of the conic's extensions are P at `q=17`), matching `11 ≤ q ≤ 19` "conic can be
  emptied" in the falsification-map regime table.

## 6. Growth fits, dispersion, extrapolation

**Both layers are erratic, not monotone.** Linear and log fits are weak:

```text
Pearson r (linear in q):  mu_tot=0.691  mu_on=0.701  m_tot=0.677  m_on=0.599
Pearson r (vs ln q):      mu_tot=0.616  mu_on=0.683  m_tot=0.602  m_on=0.572
fit mu_on ~ q:     slope=+0.656  R^2=0.491
fit mu_on ~ ln q:  slope=+6.863  R^2=0.467
fit mu_tot ~ q:    slope=+10.14  R^2=0.477
fit mu_tot ~ ln q: slope=+97.04  R^2=0.380
```

No growth law fits (`R² ≈ 0.4–0.5`). The dominant signal is not a trend but the **arc-driven
dips**: `mu_on` collapses exactly at the two computed `q` where the conic is partly N-depleted
(`onN > 0`, i.e. `q = 11, 17`; `mu_on/(q−4) = 0.61, 0.21`), and sits at full capacity `q−4`
everywhere else (`q = 5,7,9,13,19`). Which `q` deplete is governed by the (number-theoretically
irregular) abundance of odd complete arcs, exactly the conclusion of the erratic-margin note.

**The witness count is massively UNDER-dispersed** (variance/mean ≪ 1; Poisson = 1):

```text
on-conic dispersion (var/mean):  q=5:0.00  7:0.00  9:0.00  11:0.40  13:0.00  17:0.18  19:0.00
```

At `q = 5,7,9,13,19` every class has the *same* on-conic P-count (a point mass, dispersion 0); even
the two depleted `q` are far below Poisson. This is the load-bearing subtlety: **the Poisson null
over-predicts zeros** because the true counts are concentrated, not spread. Concentration is
*protective* — it is why `m_on = 1 > 0` survives at `q=17` even though the first-moment margin is
negative and `E0_on = 1.39`. The conjecture (and the (ON) route, so far) is held up by
**low variance**, not by a growing **mean margin**.

**Extrapolated zero-crossing.**
- TOTAL: `E0_total` never approaches 1 over `q ≤ 19` (max `2.7e-3` for `q≥7`); with no downward
  trend in `mu_total` there is no near-term extrapolated `q` at which the null predicts a total
  trap. The erratic dip at `q=17` still leaves `E0_total = 1.5e-3 ≪ 1`.
- ON: the null already crosses `E0_on > 1` at `q=17` itself. Because `mu_on` is erratic (not
  monotone), there is no single extrapolated crossing `q`; the null predicts a zero *whenever* the
  conic arc-depletes below `mu_on < ln N_canon`, which recurs unpredictably. The observed data does
  not realize the predicted zero (under-dispersion), so the null **over-predicts** on this layer.

## 7. Verdict (two-layer)

- **Main conjecture (TOTAL layer): (b) safe over the computed range, but not "safe for a
  provable reason."** `mu_total` clears `ln N_canon` at every computed `q` (margin `+1.0` at the
  degenerate `q=5`, `+5.9` at `q=7`, then `≥ +6.5` for `q ≥ 9`), and the Poisson null predicts effectively no total-trapped class
  (`E0_total ≤ 2.7e-3`, `q≥7`). Nothing trends toward 0 — so this is **not** a (c) counterexample
  signal. But the margin is erratic (`R² ≈ 0.48`, arc-driven), so the first-moment heuristic
  supplies **no monotone bound** and cannot upgrade the main conjecture past "computed P through
  `q=19`." It does not, on its own, discharge A3.
- **(ON)/D3 route (ON-conic layer): (b) safe-but-tight, with a genuine warning.** `mu_on` drops
  *below* `ln N_canon` at `q=17` (margin `−0.33`, `E0_on = 1.39`), the single point where the
  first-moment heuristic predicts an on-conic trap. Observed `m_on = 1` (the knife edge) means no
  actual trap — the route survives only because the on-conic count is a near-point-mass
  (dispersion `≤ 0.4`). Since `mu_on ≤ q−4` and dips whenever the conic depletes, the on-conic
  first-moment margin is **not reliably positive**; this is a live warning for failure-mode **B4a**
  (the conic-localized route can fail even though the conjecture holds), *not* for A3. The
  `m_total` layer staying ≥5 at `q=17` confirms off-conic (int/ext) witnesses carry the escape
  where the conic nearly empties.

Net: the heuristic does **not** find an approaching counterexample (both `m_total` and `m_on` stay
≥1 and recover after the `q=17` dip), and it does **not** certify safety-for-a-reason (no growing
mean margin; the fits are noise). Since the counts are deterministic, neither *moment* is itself the
proof target: what the heuristic localizes is that the on-conic P-count is nearly a **function of
`q`** (concentration is the protection), and that the intended (ON) route runs through a negative
first-moment margin at `q=17`. So a uniform (ON) argument should target a **class-stability lemma**
(the on-conic P-count varies by ≤ a small constant across classes at fixed `q`) plus an **anchor
lower-bound** (some class ≥ 2), giving min ≥ 1 — not a mean or variance moment bound. This is
**P-value** depletion of the `q−4` legal on-conic cells, distinct from the `live_on` legal-cell bound
of the `q≥23` row (both track the same conic-arc pressure, but they are not the same quantity).

## 8. Reproduce

Parser: [`rust/scripts/witness_count_heuristic.py`](../rust/scripts/witness_count_heuristic.py)
(reads the feat files + escape logs, does the cross-check, prints §4/§5/§6). Run from repo root:

```bash
python3 rust/scripts/witness_count_heuristic.py
```

Small-`q` anchor regeneration (single-core, seconds), run from `rust/`:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
./target/gridcap feat 5 7 9      # CLS lines saved to notes/data/codex-feat{5,7,9}.out
./target/gridcap escape 5 7 9    # summary check (min-escape 1,7,13; matches feat)
```

`q=9` is GF(9) and runs without field error. `q≥23` is deliberately not attempted (memo-capped,
expensive; out of scope).

---

Drafted insert for `2026-07-09-odd-plane-falsification-map.md` as **§6 The A3 test: witness-count
heuristic** (parent to apply/commit — not edited here):

```markdown
## 6. The A3 test: witness-count heuristic

First-moment (Tao-style) test of A3. Model each size-3 class's P-child count as `Poisson(mu(q))`;
with `N_canon(q)` classes the expected trapped count is `N_canon·exp(−mu)`, so escape survives as
long as `mu(q) > ln N_canon(q)`. Measured over `q = 5,7,9,11,13,17,19` (feat-mode full census,
`notes/2026-07-09-witness-count-heuristic.md`), on two layers — TOTAL P-children (main conjecture)
and ON-conic P-children (the (ON)/D3 route):

- **TOTAL** clears the line everywhere with room to spare (`mu_total − ln N_canon ≥ +6.5`, min at
  `q=17`; Poisson-null `E0_total ≤ 2.7e-3`). No trend toward a trap — not a counterexample signal.
- **ON** dips *below* the line at `q=17` (`mu_on = 2.71 < ln N_canon = 3.05`, margin `−0.33`,
  `E0_on = 1.39`): the first moment predicts ≈1.4 trapped on-conic classes, yet the observed
  minimum is `m_on = 1` (the "one on-conic witness" knife edge). It survives only because the
  on-conic count is a near-point-mass (dispersion `≤ 0.4 ≪ 1`), i.e. protected by **concentration,
  not by a growing mean**.

Both `mu` are erratic (`R² ≈ 0.48` for any linear/log fit; the dips coincide with arc-depletion of
the conic, `q = 11, 17`), so the heuristic yields **no monotone margin** and does not by itself
discharge A3. Reading: the main conjecture is safe over the computed range but not "safe for a
reason"; the (ON) route is safe-but-tight with a genuine **B4a** warning at `q=17` — a uniform
(ON) argument must bound the on-conic **variance / depletion** (the same `live_on ≥ q−19` object as
the `q≥23` row), not the mean.
```
