# A5 lane — N-bucket density ν(q) and the min-witness suppression (C68 follow-on)

**2026-07-10 (Claude).** Independent theory pass while the q=25 census is gated. C68 measured
`D(q)` / min-witness per size-3 **class**; this measures the **global on-conic S4 bucket structure**
that drives them, and it sharpens the A5 anchor from "min-witness ≥ 1 (observed through q=19)" to a
quantified, adverse-trending risk.

Script `rust/scripts/c68b_nbucket_density.py`; data from `s4arena <q> --all` (exact, seconds/order).

## The N-bucket density ν(q)

`ν(q)` = fraction of on-conic S4 **states** that are N, weighting each full-PGL bucket by its fiber
(the number of raw 4-subset completions `{t1,t2,t3,t4}` canonicalizing into it; fibers sum to `C(q-1,4)`).

| q  | buckets | #P | #N | states `C(q-1,4)` | N-states | **ν(q)** | onP class-types | min-wit | null `E[fully-N]` | obs fully-N |
|---:|--------:|---:|---:|------------------:|---------:|:--------:|:---------------:|:-------:|:-----------------:|:-----------:|
| 5  | 1       | 1  | 0  | 1                 | 0        | 0        | 1×1             | 1       | 0                 | 0           |
| 7  | 1       | 1  | 0  | 15                | 0        | 0        | 3×3             | 3       | 0                 | 0           |
| 9  | 2       | 2  | 0  | 70                | 0        | 0        | 5×5             | 5       | 0                 | 0           |
| **11** | 4   | 3  | 1  | 210               | 75       | **0.357**| 2×2, 5×6        | 2       | 0.006             | 0           |
| 13 | 5       | 5  | 0  | 495               | 0        | 0        | 9×12            | 9       | 0                 | 0           |
| **17** | 10  | 5  | 5  | 1820              | 1440     | **0.791**| 1×3, 3×18       | 1       | **1.000**         | 0           |
| 19 | 13      | 13 | 0  | 3060              | 0        | 0        | 15×27           | 15      | 0                 | 0           |

(`onP class-types`: `onP-value × #classes` — the number of on-conic P escapes per size-3 class.)

## Four findings

**1. ν(q) = 0 off the depleted orders; positive and ~doubling across them.** Every non-depleted
order (5,7,9,13,19) has **no** N on-conic bucket at all — every on-conic S4 state is P. The depleted
orders {11,17} carry all the N-buckets, and the density jumps `0.357 → 0.791` from q=11 to q=17
(#N-buckets `1 → 5`). This is the bucket-level image of C68's `D(q)`, and it climbs faster.

**2. min-witness ≥ 1 is a MARGINAL suppression at q=17, not a robust bound.** Null model: if a size-3
class's `q−4` on-conic completions were N independently with prob. `ν(q)`, the expected number of
**fully-N classes** (min-witness 0 — the (ON)-route failure) is `#classes · ν^(q−4)`. At q=11 that is
`0.006` (safe). **At q=17 it is `1.000`** — a random model predicts ~one fully-N class, i.e. the
(ON) route *should* fail by the null. The geometry delivers **0**. So through q=17 the on-conic
escape survives by essentially exactly the margin a random model expects it to fail by — the knife
edge is real and the trend (`ν` doubling) is adverse. (The null is crude — the true onP
distribution is bimodal, not binomial, see #3 — but it fixes the order of magnitude: the N-density
is now high enough that fully-N classes are plausible, and only structure prevents them.)

**3. Size-3 classes fall into a few PGL orbit-types; min-witness is an extremal-type count.** The
onP distribution is not spread — it is bimodal: exactly two class-types per depleted order
(q=11: `onP ∈ {2,5}`; q=17: `onP ∈ {1,3}`). So `min-witness(q) = min over the (few) class orbit-types
of onP`, an exact finite object, and the A5 target `maxonN ≤ q−5` is a statement about the single
**extremal class-type** (the `onP=1` type at q=17), not an average.

**4. Value ↔ fiber-size clean separation: escapes are the rare/special completions.** Within each
depleted order the P/N split is cleanly separated by bucket fiber size:

- q=17: **P-buckets have fiber ≤ 120** (`120,120,80,20,40`); **N-buckets have fiber ≥ 240**
  (`240,480,240,240,240`). A clean gap `120 < 240`.
- q=11: P fibers `{60,50,25}` ≤ 60; the single N fiber `= 75`. Gap `60 < 75`.

So the N on-conic states are the *generic* (large-fiber) completions and the P escapes are the
*rare/special* (small-fiber, higher-symmetry) ones. This is a **within-q** separator, orthogonal to
the failed *cross-q* config dictionaries (C18/C55/C64/C69) — those hunted a q-independent
config→value law; this is a per-order genericity split.

## Consequence for A5

The A5 anchor `maxonN(q) ≤ q−5` should be proved as: **every size-3 class's fan contains at least one
special (small-fiber / higher-symmetry) on-conic completion, and those are P.** Finding #4 gives the
existence target a shape — a symmetric/special completion always exists — and reduces A5 to (i) a
covering lemma (every 5-point frame `{∞,0,t1,t2,t3}` admits a special 6th point) plus (ii) the
special-completion ⇒ P direction. Finding #2 gives the urgency: the bound is marginal at q=17 and
`ν(q)` is climbing, so A5 is *not* a formality — it must actually bound the extremal class-type
against a rising N-density, and it cannot lean on "no fully-N class observed through q=19."

This also re-weights q=25: **if q=25 is depleted with `ν(25)` above ~0.85, the null model predicts
multiple fully-N classes**, and the marginal geometric suppression seen at q=17 would have to hold
against a stronger adversary. That is the sharpest reason the q=25 depletion measurement matters.

## Reproduction

```bash
cd rust
for q in 5 7 9 11 13 17 19; do ./target/gridcap-arena s4arena $q --all --log2 24 \
  | grep S4ARENA-BUCKET > /tmp/buckets-q$q.txt; done   # (script reads the scratchpad copies)
python3 scripts/c68b_nbucket_density.py
```

All on-conic bucket labels are exact `s4arena` solves (validated byte-identical to FnvMap + C54).
The null-model `E[fully-N]` is a heuristic order-of-magnitude, not a proof input.
