# C68 — The depletion-fraction extremal sequence D(q) (sweep E2)

**Reported 2026-07-10 (Claude).** First concrete A5 (arc-depletion arithmetic) task; the config
mechanism sweep (static C55/C64/C69 + dynamic Correction 3) is complete/negative, so A5 is the sole
live (ON) mechanism route and `D(q)` is its first named quantity.

Task spec: `notes/2026-07-07-codex-task-queue.md` §C68; E2 spec in
`notes/2026-07-09-mathematician-lens-sweep.md` §2.

## Definitions

For a size-3 residual grid class, its **on-conic children** are the `q-4` legal on-conic size-4
extensions (all on-conic cells are legal — confirmed uniform, `onP+onN = q-4` for every class at
every q). Each on-conic child is P or N.

- `D(q)` = max over size-3 classes of the N-fraction among on-conic children = `max_class onN/(q-4)`.
- **min-witness(q)** = min over size-3 classes of `onP` = the fewest on-conic P escapes any class
  has. Equivalently `min-witness(q) = (q-4) - maxonN(q)`, where `maxonN(q) = max_class onN`.

The (ON) route needs **min-witness(q) ≥ 1** (every size-3 class keeps at least one on-conic P
escape). Erdős's stronger E2 conjecture asks for `D(q) ≤ 1-c` (bounded away from 1).

## Verdict (short)

1. **`D(q) = 0` at every non-arc-depleted order** in `5..23` (q = 5, 7, 9, 13, 19, 23): every
   on-conic child of every size-3 class is P, and min-witness = `q-4` (full). Depletion is **zero**
   off the depleted orders.
2. **`D(q) > 0` exactly at the arc-depleted orders `{11, 17}`** — the same orders where the 119
   configs flip N. `D(11) = 5/7 ≈ 0.714`, `D(17) = 12/13 ≈ 0.923`.
3. **The knife edge sharpens along the depleted subsequence, it does not relax.** min-witness is
   `2` at q=11 and `1` at q=17; the safety margin `(q-4) - maxonN` shrinks `2 → 1`. min-witness
   "recovers" to `q-4` only at the *non-depleted* orders (13, 19, 23) — trivial recovery, since
   `maxonN = 0` there.
4. **The strong E2 form "`D(q) ≤ 1-c` bounded away from 1" is not supported by the data.** The two
   depleted points climb toward 1 (`0.714 → 0.923`) with min-witness falling `2 → 1`. As a fraction
   the trend is the wrong direction; a fixed `c` is not visible in a two-point depleted subsequence.
5. **Correction to the E2 estimate.** E2 guessed `D(17) ≈ 0.79`; the exact recompute is
   `12/13 ≈ 0.923`. (The `0.79` was a mean-flavored guess; the extremal class is worse.)
6. **The proof-usable anchor target is min-witness, not D.** The A5 statement the (ON) route
   actually needs is **`maxonN(q) ≤ q-5` (min-witness ≥ 1) at every arc-depleted order** — no size-3
   class has all `q-4` on-conic children N-valued. This is weaker than "D bounded away from 1"
   (which the data argues against) and is exactly what escape survival requires. The shrinking
   `2 → 1` margin is the sharpest open-question signal in the corpus.

## Main result

| q  | root | #cls | q−4 | D(q)          | worst onP/onN | min-witness (min onP) | maxonN | margin (q−4)−maxonN |
|---:|:----:|-----:|----:|:-------------:|:-------------:|----------------------:|-------:|--------------------:|
| 5  | P    | 1    | 1   | 0             | 1 / 0         | 1                     | 0      | 1                   |
| 7  | P    | 3    | 3   | 0             | 3 / 0         | 3                     | 0      | 3                   |
| 9  | P    | 5    | 5   | 0             | 5 / 0         | 5                     | 0      | 5                   |
| **11** | P | 8    | 7   | **5/7 ≈ 0.714** | 2 / 5     | **2**                 | 5      | **2**               |
| 13 | P    | 12   | 9   | 0             | 9 / 0         | 9                     | 0      | 9                   |
| **17** | P | 21   | 13  | **12/13 ≈ 0.923** | 1 / 12  | **1**                 | 12     | **1**               |
| 19 | P    | 27   | 15  | 0             | 15 / 0        | 15                    | 0      | 15                  |
| 23 | P    | —    | 19  | 0             | 19 / 0        | 19                    | 0      | 19                  |

- q = 5..19 exact from the `feat`-mode `CLS` summaries (`notes/data/codex-feat*.out`).
- q = 23 from C54: all 22 full-`PGL(2,23)` on-conic S4 buckets are P (C53 bridge ⇒ every on-conic
  child of every size-3 class is P ⇒ `onN = 0` everywhere). This is the bucket layer, not a size-3
  census; the D and min-witness entries follow immediately (`maxonN = 0`, min-witness = `q-4`).

Machine-readable trajectory:

```text
q= 5  D=0.0000  min_wit=1   (= q-4)
q= 7  D=0.0000  min_wit=3   (= q-4)
q= 9  D=0.0000  min_wit=5   (= q-4)
q=11  D=0.7143  min_wit=2       DEPLETED   margin 2
q=13  D=0.0000  min_wit=9   (= q-4)
q=17  D=0.9231  min_wit=1       DEPLETED   margin 1
q=19  D=0.0000  min_wit=15  (= q-4)
q=23  D=0.0000  min_wit=19  (= q-4, bucket layer)
```

## The two depleted orders in detail

**q = 11** (8 classes, `q-4 = 7` on-conic children each). Bimodal:

```text
onP histogram (escapes:count):    2:2   5:6
onN histogram (n-children:count): 2:6   5:2
```

- 6 classes: `onP=5, onN=2` (N-frac `2/7 ≈ 0.286`) — mild.
- 2 classes: `onP=2, onN=5` (N-frac `5/7 ≈ 0.714`) — the worst; min-witness = 2.
- Even the *best* class still has 2 N on-conic children.

**q = 17** (21 classes, `q-4 = 13` on-conic children each). Bimodal, and severe **across the whole
order**:

```text
onP histogram (escapes:count):    1:3    3:18
onN histogram (n-children:count): 10:18  12:3
```

- 18 classes: `onP=3, onN=10` (N-frac `10/13 ≈ 0.769`).
- 3 classes: `onP=1, onN=12` (N-frac `12/13 ≈ 0.923`) — the knife-edge classes; min-witness = 1.
- **Every** class at q=17 has `onN ≥ 10`: the *least*-depleted class at q=17 (N-frac 0.769) is worse
  than the *worst* class at q=11 (0.714). Depletion is class-wide at q=17, not a worst-class outlier.

The 3 knife-edge (`onP=1`) classes are exactly the min-escape (`escape=5`) classes documented in the
handoff; the q=17 total-escape histogram reproduces byte-exact as a parse cross-check:

```text
q=17 escape (total P children) histogram:  5:3  10:12  11:6     (handoff value; reproduced)
     escape=5  ⟺ onP=1   (the 3 knife-edge classes)
```

Note the two depletion axes anti-align at q=11 but align at q=17: at q=11 the worst on-conic class
(`onP=2`) is the *most* total-escape-rich class (`escape=18`); at q=17 the worst on-conic classes are
also the min-total-escape classes (`escape=5`). This is a detail, not a law.

## Interpretation and the A5 handoff

**The conjecture is safe; the (ON) route is what is on the knife edge.** At q=17's worst class the
root still has `escape = 5` total P children — 4 of them off-conic. The plane root is P with wide
margin everywhere. What depletes is specifically the **on-conic** escape supply, i.e. the (ON)
route's own margin, not the conjecture's.

**Depletion is confined to arithmetic orders, with full recovery between them.** `D(q) = 0` and
min-witness = `q-4` at every non-depleted order (5,7,9,13,19,23). The nonzero D lives exactly at the
arc-depleted `{11, 17}`. This is the size-3-class / on-conic-child image of the same dichotomy the
119 flipping configs live in (an N on-conic child *is* an N-valued on-conic S4 config); C68 makes it
quantitative and one level up (class-extremal, not per-config).

**But the depleted subsequence trends the wrong way.** Restricted to depleted orders:
`D: 0.714 → 0.923`, min-witness `2 → 1`, margin `2 → 1`. If read as "min-witness recovers after the
q=17 dip," the answer is **only for non-depleted orders** — at depleted orders the escape supply is
getting scarcer, not recovering. So the optimistic E2 reading ("small-q accident, `D(q)` bounded")
holds for the *non-depleted* skeleton but **not** for the depleted subsequence, and the strong
"`D(q)` bounded away from 1" form is not the right anchor.

**Concrete quantity handed to the A5 lane** (satisfies re-entry condition (a) — a named quantity):

> `maxonN(q) = max over size-3 classes of the number of N on-conic children`
> (equivalently `min-witness(q) = (q-4) - maxonN(q)`).
>
> **A5 target: `maxonN(q) ≤ q-5` (min-witness ≥ 1) at every arc-depleted order** — no size-3 class
> has all `q-4` on-conic children N. Observed margin `(q-4) - maxonN`: `2` (q=11), `1` (q=17). The
> open question is whether the arc-depletion arithmetic keeps this margin `≥ 1` as depleted `q` grows,
> or whether some larger depleted order leaves a size-3 class with zero on-conic escapes (which would
> break the (ON) route at that order, though not necessarily the conjecture — an off-conic escape
> could survive).

Re-entry note for Cluster-1: `maxonN` is a **class-level extremal count**, not a per-config static
invariant, so it does not directly re-open the C55/C64/C69 config-invariant search. The proof-side
consumer is the A5 arithmetic (how many on-conic S4 configs are N at order q, and can they cover a
single size-3 class's entire on-conic fan).

## Follow-ups

- **The decisive missing datum is `D` at the *next* arc-depleted order** (> 23). The depleted set
  observed is `{11, 17}`; 13, 19, 23 are not depleted. Extending the depleted subsequence past q=17
  is what settles margin `2 → 1 → ?`. This needs the GF(25) path / q=25 Baer census (C44) if 25 is
  depleted, or a larger prime census. Two depleted points cannot decide "bounded vs → 1."
- No simple residue characterizes `{11,17}` (mod 3 killed by C29; mod 6 fails — 5, 23 ≡ 5 mod 6 have
  D=0 while 11, 17 ≡ 5 mod 6 have D>0). The characterization is the A5 arithmetic itself
  (second-largest-complete-arc / oval-incidence level, per C58's Desargues-independence and C59's
  arc bounds).
- The full per-class distributions at the depleted orders are bimodal (two escape counts only). If a
  bimodality law holds at the next depleted order it is a candidate structural fact for A5.

## Reproduction

```bash
cd rust
python3 scripts/c68_depletion_fraction.py
```

Reads `notes/data/codex-feat{5,7,9,11,13,17,19}*.out`; q=23 from the C54 report
(`notes/2026-07-09-codex-q23-bucket-certification.md`, 22/22 buckets P). Pure parse + exact
rational arithmetic — the underlying `feat` solves are the exact P/N oracle; the script does no
solving. Parse cross-check: the reproduced q=17 escape histogram (`5:3 10:12 11:6`) matches the
handoff.

The feat dumps themselves (if regeneration is wanted) come from the grid-cap solver:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
target/gridcap feat 5 7 9 11 13 17 19       # emits the CLS summary lines parsed here
```
