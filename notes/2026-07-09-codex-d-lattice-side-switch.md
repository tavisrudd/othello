# C55 — d-lattice side-switch diagnostic for the arc-depleted-order dichotomy

Date: 2026-07-10 (Claude).  Task: [`2026-07-07-codex-task-queue.md`](2026-07-07-codex-task-queue.md) §C55.
Companion extremal-side test: C64 (completion poset,
[`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md)).

## Verdict

**NEGATIVE.  H-side-switch is dead.**  The 119 cross-q value flips (on-conic size-4
children that are **N at q ∈ {11,17}** and **P at q ∈ {13,19}**) are **not** mediated by a
shared-lattice product order `d` realised split at 13/19 (`d | q−1`) and elliptic at 11/17
(`d | q+1`).  On both instruments the spec names — the abstract involution-product dictionary
(C18) and the actual legal-intruder secant skeleton (Lemma VI) — the split↔elliptic
side-switch structure is **statistically indistinguishable between flipping and non-flipping
matched configurations**, and its one clean within-order test **reverses** the prediction.

Consequence: the arc-depleted-orders dichotomy still has no group-side mechanism.  The A5
arc-depletion arithmetic remains without a candidate from this lane.  **C56 stays gated**
(it required a C55 positive — do not start it).  If C64 is also negative, promote sweep **S1**
(Segre-style envelope invariants) as the remaining mechanism candidate.

## The hypothesis (H-side-switch)

The flip pairs share a divisor lattice: `11+1 = 13−1 = 12` and `17+1 = 19−1 = 18`.  By Lemma VI
([`2026-07-08-nk-involution-residual.md`](2026-07-08-nk-involution-residual.md) §2) the two-intruder
`xx'`-secant `K₂` is **present iff `d = ord(σ_x σ_{x'}) | q−1`** (split) and **absent iff
`d | q+1`** (elliptic).  So the same shared-lattice `d` can be realised split at the full order
and elliptic at the depleted order, and the defect skeleton of the "same" configuration would then
genuinely differ (secant present ↔ absent) — a candidate cause for the N↔P flip.  Directional form:
a flipping configuration should **gain** secants (split share up) going depleted → full, more than a
matched non-flipping control.  This is a **paired contrast on matched configurations**, which C18
never ran (C18 pooled bucket values across q and fit static laws).

## Method and gate

Corpus: the on-disk feat censuses `notes/data/codex-feat{5,7,11,13,17,19}.out`, 852 on-conic
children, reusing the vetted reconstruction/PGL machinery of
[`onconic_child_type_alignment.py`](../rust/scripts/onconic_child_type_alignment.py) verbatim.
Each config is an integral type `(sorted signed S3 params, signed child)` — the same signed
integers at every q, so cross-ratios are identical rationals across the fields.

**Gate (PASS):** the corpus reproduces the alignment report exactly.

```text
integral types total=614  appear at >=2 q=169  aligned=50  OBSTRUCTIONS=119
obstructions N@q=11: 16   N@q=17: 105   N at a full order (13 or 19): 0
```

Paired cohorts (integral types present at BOTH orders of a pair):

```text
pair 11/13 (depleted q=11 elliptic-side, full q=13 split-side, lattice=12): flip=11  control=17
pair 17/19 (depleted q=17 elliptic-side, full q=19 split-side, lattice=18): flip=100 control=30
```

`flip` = N at the depleted order, P at the full order.  `control` = matched shared configuration
with the SAME value at both orders.  (`P@depleted, N@full` never occurs, consistent with the
report's one-directional flip.)

Scripts (committed): [`c55_side_switch.py`](../rust/scripts/c55_side_switch.py) (instrument 1 +
gate + cohorts), [`c55_intruder_skeleton.py`](../rust/scripts/c55_intruder_skeleton.py)
(instrument 2 + minimal-witness solve).

## Instrument 1 — abstract involution-product dictionary (C18)

For each of the 15 point-pair involutions of the 6-subset, form all products; **60 of the 105
share a fixed point and are parabolic at every q** (product fixes the shared point — inert), so the
meaningful objects are the **45 disjoint-pair products**.  Each product's side at q is
`χ_q(δ)` for a fixed integer discriminant δ, so a side-switch across the pair is a paired
quadratic-residue event.  Aligned across each pair by role label so the same abstract product is
compared at both orders.

Result — **no differential**.  The mechanism's crisp prediction (flip configs carry a **net**
`ell→split` excess) fails: the per-config net (`#ell→split − #split→ell`) is ≈ 0 for flip and, if
anything, **larger for control**; the aggregate `ell→spl` / `spl→ell` shares are symmetric within
each cohort and near-identical across cohorts; the per-`d` switch rates match.

```text
pair 11/13 (45 disjoint products/config)
  flip    n= 11  mean ell->split =  9.00   mean NET (ell->spl − spl->ell) = +0.09
  control n= 17  mean ell->split = 10.18   mean NET (ell->spl − spl->ell) = +1.12
  aggregate side-pair census (share of 45*n disjoint products):
    flip     ell->ell 0.311  spl->spl 0.291  ell->spl 0.200  spl->ell 0.198
    control  ell->ell 0.353  ell->spl 0.226  spl->spl 0.220  spl->ell 0.201

pair 17/19 (45 disjoint products/config)
  flip    n=100  mean ell->split = 11.86   mean NET (ell->spl − spl->ell) = +0.14
  control n= 30  mean ell->split = 12.43   mean NET (ell->spl − spl->ell) = +0.87
  aggregate side-pair census (share of 45*n disjoint products):
    flip     ell->ell 0.270  ell->spl 0.264  spl->ell 0.260  spl->spl 0.206
    control  ell->spl 0.276  spl->ell 0.257  ell->ell 0.257  spl->spl 0.210
  ell->split switches by order d at the full order (per config):
    flip     d=3: 4.29/cfg  d=9: 7.57/cfg
    control  d=3: 4.63/cfg  d=9: 7.80/cfg
```

The net asymmetry the mechanism needs is present for neither cohort (≈ 0), and control ≥ flip on
every summary — the opposite of the prediction.  The shared-lattice `d` values (divisors of 12 /
18) do switch side, but at the **same rate** for flip and control.

## Instrument 2 — actual legal-intruder secant skeleton (Lemma VI proper)

The abstract dictionary is a proxy; the geometrically faithful object is the **actual off-conic
intruders** of the S4 follower.  Using the self-contained hyperbola model (`r·c=1`, burned pair at
infinity, on-conic S4 = the 4 params), for each config at both orders I enumerate every
simultaneously-legal intruder pair `(x,x')` and classify `ρ = σ_x σ_{x'}` by its fixed-param count
(2 = split / secant present, 0 = elliptic / absent, 1 = parabolic / tangent — the Lemma VI, NK2-verified
criterion).

**Paired (full cohort) — no differential:**

```text
pair 11/13   flip    n= 11  secant(split) share depleted=0.029 full=0.067  delta=+0.038
             control n= 17  secant(split) share depleted=0.015 full=0.080  delta=+0.065
pair 17/19   flip    n=100  secant(split) share depleted=0.183 full=0.227  delta=+0.044
             control n= 30  secant(split) share depleted=0.186 full=0.227  delta=+0.041
```

The secant share rises going depleted → full by the **same amount for flip and control**
(17/19: +0.044 vs +0.041, over 100 vs 30 configs) — a generic q-effect (larger q ⇒ more secants),
not a flip-specific swap.

**Within-order discriminator (q held constant — controls for the generic q-effect):** the
mechanism predicts N-valued on-conic children have a **lower** secant share than P-valued ones at
the same q.

```text
q=11  P: n= 34 secant share=0.015    N: n= 22 secant share=0.029   -> N > P  (prediction REVERSED)
q=13  P: n=108 secant share=0.074    N: n=  0                       (all-P full order)
q=17  P: n= 57 secant share=0.188    N: n=216 secant share=0.183   -> N ≈ P  (Δ=0.005; not a discriminator)
q=19  P: n=405 secant share=0.225    N: n=  0                       (all-P full order)
```

At q=11 the prediction is **reversed** (N children carry *more* secants than P); at q=17 the
difference is negligible.  Secant/split-elliptic structure does not separate N from P at fixed q.

**Minimal-witness full-game solve** (config S3 `{−4,−3,−2}`, child `1`; the alignment report's
minimal witness) grounds the picture — value flips N,P,N,P while the secant share is a **smooth
monotone function of q with no discrete signature at the flips**:

```text
q=11 value=N  winning moves: conic=0 intruder=4  | secant(split)share=0.029
q=13 value=P  winning moves: conic=0 intruder=0  | secant(split)share=0.061
q=17 value=N  winning moves: conic=0 intruder=4  | secant(split)share=0.178
q=19 value=P  winning moves: conic=0 intruder=0  | secant(split)share=0.224
```

(The `conic=0` winning-move counts reproduce the session-11 NK4 law — an N-valued on-conic S4 wins
only by intruding.)  The N-valued q=17 order has a *higher* secant share (0.178) than the P-valued
q=13 order (0.061): secant presence does not even correlate with value in the predicted direction.

## Scope / what was and was not tested

- Tested exhaustively: the **secant-`K₂` swap** — the sharp, named prediction of H-side-switch —
  on both the abstract dictionary and the actual intruder residual, paired and within-order.
  Negative on all cuts.
- Not separately isolated: a subtler tangency-path / full Dawson-XOR defect correlate.  That is
  not what H-side-switch predicts (it names the secant), and testing a *value-relevant* defect XOR
  requires selecting value-defined follower states — the standing "value-defined witnesses"
  blocker — so it is not a clean geometric diagnostic and is out of C55's scope.
- q = 9 (non-prime) and q = 23/25 are outside the feat cross-q corpus, as in the alignment report.

## Step-4 prediction (H-side-switch positive) — not emitted

The step-4 deliverable was a list of q=23/q=25 configs the mechanism predicts to flip
(`23+1 = 25−1 = 24`).  Since the mechanism is negative, **no such prediction is made** — the
secant share is a smooth increasing function of q and makes no discrete flip prediction.

## Reproduce

```bash
python3 rust/scripts/c55_side_switch.py             # gate + cohorts + instrument 1
python3 rust/scripts/c55_intruder_skeleton.py --all # instrument 2 (paired + within-q)
python3 rust/scripts/c55_intruder_skeleton.py --witness   # minimal-witness full-game solve
```
