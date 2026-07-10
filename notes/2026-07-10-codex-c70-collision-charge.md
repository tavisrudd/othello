# C70: exact reservoir-slack collision charge

Date: 2026-07-10 (Codex).

Reads first: `2026-07-09-codex-potential-lp-dual.md` (the `Psi` definition, q=19 Correction-2),
`2026-07-10-codex-q19-psi-selector-hard-surface.md` (the 12-row hard surface),
`2026-07-09-codex-reply-automaton.md` (the six forced q=17/q=19 conflicts).

## Verdict (one line)

The untruncated collision charge is a **genuine, proven incidence quantity (item 1 positive)**, but
as a potential coordinate it is **negative**: untruncating the reservoir slack is arithmetically
identical to re-adding a *deterministic function of `(q, ply)`* on top of `zone_v`, carrying no new
per-state discriminating information. It does not resolve the q=17/q=19 selector splits (it
*relocates* the q=19 hard surface `12 -> 10` across four other parents) and adds no averaging power.
The `max(0, .)` was not hiding a q-sensitive incidence identity that discriminates states or replies;
it was hiding a forced, deterministic collision-count drift.

## Setup and the current term

The board is `AG(2,q)` (q prime here: 13/17/19). Playing a cell forbids its whole row, its whole
column (`rc_mask`), and every secant line to each previously played cell (`line_mask`). So a legal
cap is a partial permutation (<=1 played point per row and per column) with no three collinear.
The root conic is the hyperbola `{(r, r^{-1}) : r != 0}` (`is_on_root_conic`): `q-1` points, one per
nonzero row and per nonzero column; row 0 and column 0 carry none. `zone_v` counts the live
off-conic cells; every live cell lies in one of the `q-k` unoccupied columns (`k = |S|`).

The C63 code (`s4_potential_features`) computes

```text
per_line_floor    = max(0, q - k - C(k,2) - 1)
reservoir_floor   = (q-k) * per_line_floor
reservoir_slack_total (= R_code) = max(0, zone_v - reservoir_floor)   # two truncations
```

## Item 1 -- exact untruncated collision-multiplicity formula (POSITIVE)

Define the untruncated charge

```text
M(S) = zone_v - (q-k) * (q - k - C(k,2) - 1)          # inner and outer max(0,.) removed
```

Rowwise decomposition over the `q-k` unoccupied columns: cells there number `(q-k)*q`; the
**nominal blocker incidences** are `k` (played rows, one hit per unused column) `+ C(k,2)` (secants,
each crosses every unused column once; no secant is axis-parallel because played points share no
row/column) `+ 1` (the conic trace, one point per column). Hence
`(q-k)(q-k-C(k,2)-1) = (cells in unused columns) - (nominal incidences)`, and

```text
M(S) = (nominal incidences) - (distinct non-live cells)
     = sum over unused-column cells of max(0, mult(cell) - 1)   [= collision surplus E]
       + delta0col
```

where `mult(cell)` counts nominal blockers claiming the cell and `delta0col = 1` iff column 0 is
unoccupied (column 0 carries no conic point, so the "one conic per column" nominal over-counts there
by exactly 1 -- the q-boundary term, the two points at infinity of the hyperbola). Every nominal
incidence lands on a genuinely non-live cell and every non-live cell is claimed, so the identity is
exact:

```text
M(S) = E(S) + delta0col(S),      E(S) = exact collision multiplicity surplus >= 0.
```

Because `M = E + delta0col >= 0` always, and near the root the reservoir floor is a true lower bound
(`zone_v >= floor`), `R_code = M` when `per_line_floor > 0`; away from the root `R_code = zone_v`
clips the collision content to zero.

**Relation to `R_code`, machine-verified on 935,702 states (q13 + q17-partial):**

```text
python3 scripts/c70_collision_charge.py verify --limit 8000
C70-VERIFY states=50462 zone_mismatch=0 identity_mismatch=0 delta0col_hist={0: 17772, 1: 32690}
  PASS: geometry and collision identity hold on all sampled states.
```

(reconstructed `zone_v` == solver `zone_v`, and `M == E + delta0col`, on every state) and the exact
divergence identity:

```text
# over 935,702 parent+child states of q13 + q17 buckets 00-03
checked=935702 bad_rcode(formula)=0 bad_offset(M-slack==det)=0
(q,k) with NON-constant M-slack offset: []  count=0
```

i.e. `R_code = max(0, zone_v - (q-k)*max(0, q-k-C(k,2)-1))` reproduces the code exactly, and

```text
M(S) - R_code(S) = max(0, (q-k)*(C(k,2)+1+k-q)) =: g(q,k)      # DETERMINISTIC in (q,k)
```

on every state, zero exceptions, constant within each `(q,k)` bucket. **This is the load-bearing
fact of the whole task:** untruncation adds only the deterministic `(q,ply)` potential `g(q,k)`.
At high ply `zone_v` collapses (e.g. q17 has a single `zone_v=0` value for every `k>=11` state), so
`M` there is essentially `g(q,k)` alone; the per-state fluctuation of `M` equals that of `zone_v`.

## Item 2 -- exact move-pair delta formula (no values, no Z, no truncation)

Let `F(k) = (q-k)(q-k-C(k,2)-1)`. Adding a cell `w` removes from the live off-conic set exactly the
currently-live off-conic cells lying on `w`'s new blocker lines
`N(w) = row(w) union col(w) union (union over played p of line(w,p))`. For one (opponent `u`,
reply `v`) pair from a state `S` with `k = |S|`,

```text
Delta zone_v = -|K_u union K_v|,
  K_u = live off-conic cells of S hit by N(u),
  K_v = live off-conic cells of S+u hit by N(v)  (includes the new secant v--u),
Delta M(u,v) = Delta zone_v - [F(k+2) - F(k)]
             = -|K_u union K_v| - [F(k+2) - F(k)].
```

The move-dependent part is entirely `-|K_u union K_v|` (a pure incidence count of live cells the two
cells jointly kill); `F(k+2)-F(k)` is a deterministic polynomial in `(q,k)`. Equivalently in
collision terms `Delta E = Delta M - Delta delta0col`, with `Delta delta0col in {-1,0}` iff `u` or
`v` occupies column 0. `zone_v` is monotone non-increasing (forbidding is monotone), verified:

```text
ITEM2-MONOTONE transitions=467851 zone_v_increases=0 max_kill=|K_u∪K_v|_max=51
```

so `|K_u union K_v| = -Delta zone_v >= 0` on every transition. Because all replies at one obligation
produce children at the same ply `k+2`, `F(k+2)-F(k)` is identical across the whole reply set --
`Delta M` reorders replies **only** through `-|K_u union K_v|`, i.e. through `Delta zone_v`; the
untruncation contributes a reply-independent constant (this drives items 4 and 5).

## Item 3 -- replay the exact charge over the C63 corpora

`Psi_exact` substitutes `M` for `reservoir_slack_total` in
`Psi = R + 6*defect_components - 4*interface_intruders - 2*conic_xor_zero`.

**Naive substitution (unchanged weight 1 on `M`) -- catastrophic**, because `M = R_code + g(q,k)`
re-adds the deterministic ply/order drift with weight 1:

```text
python3 scripts/c70_collision_charge.py replay --q 13 17
C70-REPLAY q=13 rows=3144
  original Psi : failures=0     delta_range=[-70,-9]
  exact   Psi : failures=2290   delta_range=[-75,48]
C70-REPLAY q=17 rows=1052204
  original Psi : failures=0     delta_range=[-92,-4]
  exact   Psi : failures=1048881 delta_range=[-159,109]

python3 scripts/c70_collision_charge.py q19
C70-Q19 rows=2622214
  [item3] original  Psi failures=12       range=[-124,12]
  [item3] naive-exact Psi (w=1 on M) failures=2621674 range=[-213,132]
```

(the original `Psi` reproduces C63 exactly -- 0/0/12 failures and the same ranges -- confirming the
extractor/parse.)

**Refit (this satisfies C63's reopen condition: a new proof-admissible coordinate).** LP fit on
q13+q17 (`minimize ||w||_1 s.t. Delta.w <= -1`, HiGHS, cached SciPy env), 5,520 unique constraints,
frozen q19 transfer:

```text
.uv-cache/environments-v2/s4-ml-mine-c62c2f326ce38a36/bin/python \
  scripts/c70_collision_charge.py refit --data s4-dumps/2026-07-10
C70-REFIT fit=q13+q17 unique_constraints=5520 aug_features=15
  span A_baseline_slack: feasible=True  w=[reservoir_slack_total=0.1429, defect_components=1.0714, interface_intruders=-0.8214, conic_xor_zero=-0.3929]
  span B_exact_M: feasible=True  w=[M=-0.0103, defect_components=1.2577, interface_intruders=-1.2784, conic_xor_zero=-0.0825]
  span C_collision_E: feasible=True  w=[E=-0.0103, defect_components=1.2577, interface_intruders=-1.2784, conic_xor_zero=-0.0825]
  span D_v2_plus_M: feasible=True  w=[reservoir_slack_total=0.1858, defect_components=1.0204, interface_intruders=-0.2894, M=-0.0071]
  span E_v2_plus_M_E: feasible=True  w=[..., M=-0.0071]
C70-REFIT-Q19-TRANSFER (frozen fitted weights on q=19 fixed-selector)
  span A_baseline_slack: q19 rows=2622214 failures=12 delta_range=[-20.786,1.286]  worst parent=0b7a91f6...
  span B_exact_M:        q19 rows=2622214 failures=10 delta_range=[-19.598,0.052]  worst parent=04184223...
  span C_collision_E:    q19 rows=2622214 failures=10 delta_range=[-19.598,0.052]
  span D_v2_plus_M:      q19 rows=2622214 failures=12 delta_range=[-21.814,1.973]
  span E_v2_plus_M_E:    q19 rows=2622214 failures=12 delta_range=[-21.814,1.973]
```

All spans are feasible on the fit corpus. The exact charge shaves the frozen q19 transfer only
marginally (`12 -> 10`). The LP assigns `M`/`E` near-zero weight (`-0.0103`), but that term is
load-bearing, not decorative: zeroing it in the fitted span-B blows q19 up to 319 failures. (`M`
and `E` give identical fits: they differ by `delta0col in {0,1}`, absorbed by the weight.)

## Item 4 -- the split cases

**The 12 q19 fixed-C31 failures (all at parent `0b7a91f6...`) VANISH under the exact charge but are
REPLACED by 10 new failures at four different ply-6 parents** -- relocation, not resolution:

```text
ORIGINAL integer Psi fails by parent: {'0b7a91f6...': 12}                       total 12
span-A refit  (slack reweighted)    : {'0b7a91f6...': 12}                       total 12
span-B refit  (exact M)             : {'04184223...':2,'0296fc49...':3,
                                       '00d6817f...':3,'00f2a4aa...':2}          total 10
span-B, M-coeff ZEROED              : 319 failures across ~180 parents
```

The re-weighted slack span (A) keeps all 12 on the same hard surface, so the hard surface is
intrinsic to the truncated slack. The exact charge dissolves it -- but produces its own smaller,
more diffuse hard surface. Per-obligation, the shift is a reply-independent constant (item 2): every
one of the hard parent's 148 obligations has `dPsi_exact_naive = dPsi_orig + 39`:

```text
[item4] hard-parent per-obligation offset (dPsi_exact - dPsi_orig) distinct values: [39]
[item4] original failures at hard parent = 12:
   opp=5,4  reply=12,8  dPsi_orig=+10 dPsi_exact_naive=+49
   opp=7,11 reply=13,3  dPsi_orig=+12 dPsi_exact_naive=+51
   ... (all 12 shifted by exactly +39)
```

**The six C61 forced q=17/q=19 conflicts.** Reconstructed each conflict N-node at both orders
(root `t4=1,2,3,4` plus the normalized C36 cells; solver `s4potentialprobe`). The exact charge
takes distinct values at all six q17/q19 pairs and so dissolves every collision -- but the
separation is dominated by the deterministic floor polynomial (the `g(q,k)` term), i.e. it separates
*by order*, which is exactly the "q-dependent realization rule" C61 already permits, not a uniform
mechanism. The sharpest case is C6, where `zone_v` and `reservoir_slack_total` are **identical**
(`1 = 1`) yet `M` still separates purely through the incidence-count polynomial:

```text
conflict  ply  q17: zone_v M_exact (dc,ii,xz)   q19: zone_v M_exact (dc,ii,xz)
C1         8         3    183  (1,4,0)                9    207  (1,4,0)
C2         8         1    181  (2,3,1)                9    207  (2,3,1)
C3         8         2    182  (1,2,0)                8    206  (1,2,0)
C4         8         2    182  (1,4,0)                6    204  (1,4,0)
C5         8         1    181  (0,2,1)                7    205  (0,2,1)
C6         9         1    233  (0,5,1)                1    271  (0,5,1)   <- zone_v identical, M separates
```

Crucially (item 2), within any single obligation `M` adds only a reply-independent constant, so it
cannot change the reply RANKING -- it cannot supply the reply-discrimination coordinate C61's
automaton needs, only shift each obligation's pass/fail threshold. Separates states by order; does
not choose replies.

## Item 5 -- the averaging question

Within any obligation `Delta Psi_exact = Delta Psi_truncated + c(q, parent_ply)` with `c` reply-
independent (item 2; empirically the hard-parent offset is the single value `39`). Hence **averaging
`Delta Psi_exact` over any reply family = (truncated family-mean) + c -- the exact charge adds no new
averaging/existence power.** Concretely on q19:

```text
[item5] parents=388124  mean(dPsi_orig)>=0: 0   mean(dPsi_exact_naive)>=0: 388010
[item5] hard parent mean dPsi_orig=-42.459  mean dPsi_exact_naive=-3.459  n=148
```

Under the truncated `Psi` every one of the 388,124 q19 parents already has a strictly negative
response-family mean -- averaging over the response family already forces a descending reply (this is
the standing C62 existence result). The naive unit-weight exact charge *breaks* that (`388,010`
parents flip to mean `>= 0`) because it re-adds `g(q,ply)`; refitting only rescales the same constant.
No new candidate lemma emerges: any averaging bridge lives in the truncated charge, not in the
untruncation.

## Route verdict

**Item 1: positive** -- the exact per-cell collision-multiplicity formula `M = E + delta0col` is
derived and machine-verified (935,702 states, zero exceptions), and its exact relation to the code
term is `R_code = max(0, M - g(q,k))` with `g(q,k) = max(0, (q-k)(C(k,2)+1+k-q))` deterministic.
**Item 2: positive** -- exact move-pair `Delta M = -|K_u union K_v| - [F(k+2)-F(k)]`, verified
`|K_u union K_v| = -Delta zone_v >= 0`.
**Items 3-5: negative** -- the untruncation contributes only the deterministic `(q,ply)` potential
`g(q,k)`; its per-state signal equals `zone_v`'s (which C63 excluded as trivially monotone /
proof-circular). Naive substitution is catastrophic; refit is feasible but only relocates the q19
hard surface (`12 -> 10`, four new parents) and cannot change reply ranking within an obligation, so
it neither resolves the C61 conflicts (it separates by order, as already permitted) nor adds
averaging power.

**Consequence for the queue.** The `max(0, .)` was not masking a q-sensitive incidence *discriminator*
-- it was masking a forced deterministic collision drift. The collision multiplicity is a real,
now-explicit incidence quantity, but as a potential coordinate it is `zone_v` plus a ply potential,
not the order-sensitive *reply*-discriminating coordinate C61 asked for. The C61 successor target
(an existential, q-varying admissible-reply set, top-of-queue item 7) is not advanced by this
charge; a reply-discriminating coordinate must vary *across replies at a fixed obligation*, which
`M` provably does not. Do not promote `Psi_exact`; keep the truncated `Psi` as the empirical charge.

## Reproduction and artifacts

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs -o rust/target/gridcap-c70
cd rust
python3 scripts/c70_collision_charge.py verify --limit 8000            # item 1
python3 scripts/c70_collision_charge.py replay --q 13 17               # item 3 (q13/q17)
python3 scripts/c70_collision_charge.py q19                            # items 3/4/5 (q19)
.uv-cache/environments-v2/s4-ml-mine-c62c2f326ce38a36/bin/python \
  scripts/c70_collision_charge.py refit --data s4-dumps/2026-07-10     # item 3 LP refit
# item 4 six-conflict reconstruction: ./target/gridcap-c70 s4potentialprobe <q> 1,2,3,4 <cells...>
```

Durable:
- `notes/2026-07-06-grid-cap-solver.rs` -- `s4potential`/`s4potentialprobe` (unchanged; used as-is).
- `rust/scripts/c70_collision_charge.py` -- verify/replay/q19/refit; geometry reconstruction,
  the `M = E + delta0col` identity check, exact-charge replay, LP refit + frozen q19 transfer.

Ignored bulk-data (reproducible from the exact Grundy dumps):
- `rust/s4-dumps/2026-07-10/c70/refit-results.json` -- LP weights, feasibility, q19 transfer.
- `rust/s4-dumps/2026-07-10/c70/conflict6-features.json` -- the six-conflict N-node feature table.
- q13/q17/q19 transition TSVs under `rust/s4-dumps/2026-07-10/c63` and `.../c63-q19` (from C63).
