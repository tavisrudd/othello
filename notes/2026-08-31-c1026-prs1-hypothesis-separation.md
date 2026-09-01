# C1026 — Do PRS-1's two hypotheses separate?

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** complete.  **The hypotheses separate** — each is independently
necessary, with an explicit witness — **and they collapse into the single
inequality `q ≥ max(16, r+3)`**, whose two branches are the two clauses.  Both
outcomes the task allowed for turn out to hold at once.

Predecessor: `notes/2026-08-31-c1025-prs1-falsification.md`, whose closeout
raised this question, and `notes/2026-08-31-c1018-prs-deephole-conjecture.md` §6
where Conjecture PRS-1 lives.  Notation is theirs.  The driver and its two
proved reductions (single-level, Sylvester) are C1025's and are reused unchanged.

## 0. The logical design, settled before any cell was run

Conjecture PRS-1 as it now stands: for `r ≥ 6`, `q ≥ 16`, and
`k = q+1-r ≥ 4`, the deep holes of `PRS_k(q)` are exactly `P_r ∪ M^max_{r,p}`.

Since `k = q+1-r`, the two clauses are not independent, and only cells where
they disagree carry any information.  Partitioning the carrier cells:

| quadrant | `q ≥ 16` | `k ≥ 4` | what a **firing** cell there would prove |
|---|:--:|:--:|---|
| **A** | yes | yes | PRS-1 is **false** |
| **B** | yes | no  | the `k ≥ 4` clause is **necessary** (`q ≥ 16` alone insufficient) |
| **C** | no  | yes | the `q ≥ 16` clause is **necessary** (`k ≥ 4` alone insufficient) |
| **D** | no  | no  | nothing |

So the separation question is decided entirely by quadrants **B** and **C**, and
a sweep of quadrant A — however large — says nothing about it.  That is the
selection rule used below: cells were chosen for which quadrant they sit in, not
for availability.

**The key observation, made before running anything.**  The scope of PRS-1 is

```text
q ≥ 16   and   k = q+1-r ≥ 4      ⟺      q ≥ 16   and   q ≥ r+3
                                  ⟺      q ≥ max(16, r+3).
```

So the two clauses are **the two branches of a single inequality**, crossing over
at `r = 13`: for `r ≤ 13` the binding constraint is the constant `16`, and for
`r ≥ 13` it is the linear `r+3`.  If both branches turn out to bind — i.e. if
both quadrant B and quadrant C contain a firing cell — then the hypotheses are
each necessary *and* they collapse into one condition.  Those are not
alternatives; both can hold at once, and §3 argues that is exactly what happens.

## 1. The discriminating cells, enumerated exhaustively

Quadrants B and C were enumerated with **no cost cap** first, so the searched
domain can be stated exactly rather than as "what we could afford".  Over all
`a = b = 1` carriers with `q ≤ 251`, `r ≤ 200`, `M ≤ 29`:

```text
quadrant B (q ≥ 16, k < 4):  56 cells exist,  5 affordable
quadrant C (q < 16, k ≥ 4):   8 cells exist,  8 affordable
```

**Quadrant C is therefore searched completely** — every cell that exists was
run.  Quadrant B is not: the 51 unaffordable cells all have `M ≥ 7` with strata
from `4.1·10^8` points (`(17,2)@17`) upward, and cost scales as
`q^{M-1}·q^2·d^2`; the smallest unaffordable one is already `3·10^{13}`
operations.  They are recorded as out of budget, not inferred.

All thirteen affordable cells, run with the C1025 driver:

| quad | `r` | `m` | `M` | `q` | `k` | stratum points | deep | exceptional | |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| B | 15 | 2 | 7 | 17 | 3 | 25,646,167 | 14 | **4** | FIRES |
| B | 15 | 3 | 5 | 16 | 2 | 69,905 | 2,863 | **2,861** | FIRES |
| B | 15 | 4 | 4 | 17 | 3 | 5,220 | 6 | **4** | FIRES |
| B | 18 | 3 | 6 | 19 | 2 | 2,613,660 | 49,316 | **49,314** | FIRES |
| B | 23 | 4 | 6 | 25 | 3 | 10,172,526 | 2 | 0 | clean |
| C | 6 | 3 | 2 | 13 | 8 | 14 | 2 | 0 | clean |
| C | 7 | 2 | 3 | 11 | 5 | 133 | 7 | 0 | clean |
| C | 7 | 2 | 3 | 13 | 7 | 183 | 8 | 0 | clean |
| C | 7 | 4 | 2 | 13 | 7 | 14 | 2 | 0 | clean |
| C | 8 | 5 | 2 | 11 | 4 | 12 | 6 | **4** | FIRES |
| C | 9 | 2 | 4 | 13 | 5 | 2,380 | 8 | 0 | clean |
| C | 9 | 3 | 3 | 13 | 5 | 183 | 6 | **4** | FIRES |
| C | 9 | 6 | 2 | 13 | 5 | 14 | 2 | 0 | clean |

**Gate re-run.**  Four of these have committed answers from C1018 and C1025 and
serve as the agreement gate in this new parameter region rather than assuming
C1025's gate transfers: `(9,3)@13` → 6 deep / 4 exceptional ✓, `(8,5)@11` →
6 / 4 ✓, `(15,4)@17` → 6 / 4 ✓, `(15,3)@16` → 2,863 / 2,861 ✓.  All match.

### Quadrant C is stronger than the stratum table shows

A stratum sweep can only see carriers.  For `r ≤ 10` the committed **censuses**
decide the whole cell, and they put more cells in quadrant C:

| `r` | `q` | `k` | quadrant | committed | fires |
|---:|---:|---:|---|---|:--:|
| 6 | 9  | 4 | C | `9 ∈ X(6)`  | yes |
| 6 | 11 | 6 | C | `11 ∈ X(6)` | yes |
| 6 | 13 | 8 | C | `13 ∈ X(6)` | yes |
| 7 | 11 | 5 | C | `11 ∈ X(7)` | yes |
| 8 | 11 | 4 | C | `11 ∈ X(8)` | yes |
| 9 | 13 | 5 | C | `13 ∈ X(9)` | yes |
| 10| 13 | 4 | C | `13 ∈ X(10)`| yes |

Note `(6,13)` is clean on its `m = 3` carrier stratum yet fires as a cell — its
exceptional orbit is not a cyclic carrier.  That is a reminder that the stratum
sweeps give a *lower* bound on firing, so quadrant C's evidence is stronger than
the stratum table alone, and quadrant B's four firing cells are genuine
regardless (a firing stratum point is an exceptional deep hole of the cell).

## 2. Verdict: the hypotheses separate — each is independently necessary

* **Quadrant B fires** (four cells: `(15,·)@16`, `(15,·)@17` twice, `(18,3)@19`).
  So `q ≥ 16` **alone is not sufficient**, and the `k ≥ 4` clause is necessary.
  Cleanest witness: `(r,m) = (15,4)` over `F_17`, `k = 3`, four exceptional deep
  points, `q = 17 ≥ 16`.
* **Quadrant C fires** (two carrier cells and seven census cells).  So `k ≥ 4`
  **alone is not sufficient**, and the `q ≥ 16` clause is necessary.  Cleanest
  witness: `(r,q) = (9,13)`, `k = 5 ≥ 4`, four exceptional deep points,
  `q = 13 < 16`.

Neither clause can be dropped.  **The hypotheses separate.**

## 3. …and they nevertheless collapse into one inequality

Separation and collapse are not alternatives.  As noted in §0,

```text
scope of PRS-1  =  { q ≥ 16 }  ∩  { k ≥ 4 }  =  { q ≥ 16 }  ∩  { q ≥ r+3 }
                =  { q ≥ max(16, r+3) },
```

a **single** condition on the pair, with a crossover at `r = 13`.  What §2 shows
is that *both branches of the max are attained*: `(9,13)` violates only the
constant branch and fires, `(15,17)` violates only the linear branch and fires.
A conjecture stated with either branch alone is false, which is exactly why both
clauses looked necessary — they are one condition seen from two sides.

> **PRS-1, restated.**  For every redundancy `r ≥ 6` and every prime power
> `q ≥ max(16, r+3)`, the deep holes of `PRS_{q+1-r}(q)` are exactly
> `P_r ∪ M^max_{r,p}`.

This is simpler than the two-clause form, it makes the `r = 13` crossover
explicit, and it removes the temptation to quote one clause without the other.

### What the data do *not* pin: the linear branch is not tight

`(23,4)@25` has `k = 3` — it violates the linear branch — and it is **clean**.
So `k ≥ 4` is not sharp at `r = 23`: at `q = 25` a dimension of 3 already
suffices.  Comparing the `k = 3` cells:

| `r` | `q` | `k` | verdict |
|---:|---:|---:|---|
| 15 | 17 | 3 | fires |
| 18 | 19 | 3 | fires (`k = 2` there) |
| 23 | 25 | 3 | **clean** |

so at fixed `k = 3` the behaviour changes somewhere in `17 < q < 25`.  The
constant `+3` in `max(16, r+3)` is therefore an upper bound on what is needed,
not a measured boundary; the true region may be bounded by a curve that flattens
back toward the constant 16 as `r` grows.  Deciding that needs the `k = 3` cells
between `r = 18` and `r = 23`, namely `(17,2)@19` and `(21,2)@23`, both of which
are in the out-of-budget list (`8·10^{13}` and `4·10^{17}` operations).  **This
is the exact remaining gap and it is recorded, not inferred.**

## 4. Out of budget, with estimates

| region | cells | why | smallest cost |
|---|---:|---|---|
| quadrant B with `M ≥ 7` | 51 | stratum `q^{M-1}` with `M-1 ≥ 6` | `(17,2)@17`: `4.1·10^8` points, `3·10^{13}` ops |
| `(17,2)@19`, `k=3` | 1 | the first cell in the `17 < q < 25` gap | `8.9·10^8` points, `8·10^{13}` ops |
| `(21,2)@23`, `k=3` | 1 | the second | `1.8·10^{12}` points, `4·10^{17}` ops |

No verdict is inferred for any of them.  The `q^{M+1}` scaling is the binding
limit and the known fix is still C1023's σ-elimination (a `q^2` speedup on
phase 1), unbuilt.

## 5. `ej` + `tt` closeout

**`tt` — the interesting object is the boundary curve, not either clause.**  §3
shows `max(16, r+3)` is an upper bound whose linear branch is already slack at
`r = 23`.  The natural question is what the true boundary of the firing region
looks like in the `(r, q)` plane.  Three data points bound it: it passes above
`(15,17)` and `(18,19)` and below `(23,25)`.  If it flattens back to a constant,
PRS-1's linear clause is an artifact of small `r` and the conjecture is really
`q ≥ 16` plus finitely many exceptions; if it keeps rising, the conjecture is
genuinely two-dimensional.  **That is a sharper and more tractable question than
the one this task started with**, and the cells that decide it are exactly the
two in the out-of-budget table — so σ-elimination is now on the critical path
rather than a nicety.

A second `tt` point: `(6,13)` is clean on its only carrier stratum yet the cell
fires by census.  Every stratum-based conclusion in this campaign is therefore a
*lower* bound on firing, and the quadrant-B result — which is stratum-only —
would only get stronger with censuses.  The asymmetry is worth keeping in view:
stratum evidence proves firing, never cleanliness of a cell.

**`ej` — cheap and in reach.**

1. Build σ-elimination.  It is now the gating item for the boundary-curve
   question, not a speed nicety.  Estimated `q^2` speedup lifts `(17,2)@19`
   from `8·10^{13}` to `10^{11}` operations, i.e. minutes.
2. Census the `k = 3` cells at `r ≤ 10` — there are none, since `k < 4` and
   `r ≤ 10` forces `q ≤ 12 < 16`.  So no cheap census route into quadrant B
   exists; this is worth recording so nobody looks for one.
3. *Done, see ledger item 4:* `(15,3)@16`'s exceptional points are **not**
   modular-carrier artifacts.

**Surprising and unexplained:** `(15,17)` fires at `k = 3` while `(23,25)` is
clean at the same `k = 3`.  Whatever distinguishes them is the boundary curve of
§3, and nothing here identifies it.

## 6. Mystery ledger

1. **Do PRS-1's two hypotheses separate?**  *Settled: yes.*  Quadrant B fires
   (four cells, cleanest `(15,4)@17`), so `q ≥ 16` alone is insufficient;
   quadrant C fires (two carrier cells plus seven census cells, cleanest
   `(9,13)`), so `k ≥ 4` alone is insufficient.  Each clause is independently
   necessary with an explicit witness.  Nothing open.
2. **Are they one condition or two?**  *Settled: one.*  The scope is exactly
   `q ≥ max(16, r+3)`, and both branches are attained.  PRS-1 restated in §3.
3. **Is the linear branch tight?**  *Open, and newly raised.*  `(23,25)` is
   clean at `k = 3`, so `k ≥ 4` is slack by `r = 23`.  The boundary curve
   between `(18,19)` firing and `(23,25)` clean is undetermined.  Evidence gap:
   `(17,2)@19` and `(21,2)@23`, both out of budget by one `q^2` factor.  Owner:
   whoever builds σ-elimination.
4. **Is quadrant B's evidence weakened by modular carriers?**  *Settled: no.*
   `M^max_{15,2} = P⟨e_i : i odd⟩`, since `14 = 1110₂` makes `C(14,i)` odd
   exactly on the submasks of 14, i.e. the even `i`.  Of the 64 emitted
   exceptional points at `(15,3)@16`, **one** has support inside `M^max`; the
   other 63 do not.  So the cell is not a modular artifact.  It does still carry
   C1025's Seroussi–Roth caveat — `q` even with `k = 2` puts it in the `ρ = r`
   case, where this driver's `w ≥ d` test over-counts — so it is not leaned on.
   The verdict rests on `(15,17)` and `(18,19)`, both with `p > d` (17 > 14,
   19 > 17) and both free of either caveat.
5. **Nothing anomalous in the validation layer.**  The four cells with committed
   answers reproduced exactly in a parameter region the gate had not previously
   covered, and quadrant C was enumerated exhaustively rather than sampled.

## 7. Evidence bundle

```text
notes/2026-08-31-c1026-prs1-hypothesis-separation.md   this report
notes/2026-08-31-c1026-certificate.json                13-cell certificate, per-file SHA-256
notes/2026-08-31-c1025-certificate.py                  builder (reused unchanged)
ergodis-private/src/bin/c1025_prs_stratum.rs           driver (reused unchanged)
```

Bulk per-cell JSON is outside the repository at `~/.cache/ergodis/c1026/`.

```bash
# out-of-tree build (ergodis-private's lib does not compile; see below)
cd ~/.cache/ergodis/c1025-build && cargo build --release --bin c1025_prs_stratum
R=~/.cache/ergodis/c1025-build/target/release/c1025_prs_stratum
C=~/.cache/ergodis/c1026 && mkdir -p $C

# the two cleanest witnesses, one per quadrant
$R --r 15 --q 17 --stratum-mod 4 --stratum-class 1 --threads 20 --out $C/r15-m4-c1-q17.json
$R --r 9  --q 13 --stratum-mod 3 --stratum-class 1 --threads 20 --out $C/r9-m3-c1-q13.json

cd ~/src/othello
python3 notes/2026-08-31-c1025-certificate.py build $C notes/2026-08-31-c1026-certificate.json
python3 notes/2026-08-31-c1025-certificate.py check $C notes/2026-08-31-c1026-certificate.json
```

**Independent cross-check.**  Four of the thirteen cells have answers committed
from C1018 and C1025, produced by drivers sharing no code with this one, and all
four agree.  Beyond that every "not deep" verdict carries an explicit split
squarefree annihilator verified against the Hankel system, and every "deep"
verdict comes from Sylvester's `O(q)` test or the complete `C(q+1,d-1)`
enumeration; `phase2_points` records the split.

**What this certifies:** for each listed cell, the exact deep and exceptional
counts on the named stratum, and the exhaustive enumeration of quadrant C.
**What it does not:** the 51 unaffordable quadrant-B cells; the boundary curve of
§3; and anything about orbits with trivial stabilizer, which meet no stratum.
