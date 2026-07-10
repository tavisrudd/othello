# C44 item-7 rider — off-conic escape margin at the arc-depleted orders

**Reported 2026-07-10 (Claude).** The fallback-quantification rider of C44 item 7 (the
(ON)-bifurcation pre-registration). Cheap post-processing of the existing feat dumps; no new
solves, single-core, seconds. Sibling to C68 (`2026-07-09-codex-depletion-fraction.md`, the
on-conic side) — this records the OFF-conic side that the (ON)-failure branch pivots to.

Task spec: `notes/2026-07-07-codex-task-queue.md` §C44 item 7, final bullet.

## What this quantifies

C44 item-7 branch (ii): a size-3 class with **zero on-conic P completions** (min-witness 0,
`maxonN = q-4`) kills the **conic-localized (ON) route only**, not the conjecture — the plane can
still be P through **off-conic** escapes. The pre-registered response is a pivot to the off-conic
escape layer. This rider puts that layer's safety margin on record before q=25 forces the question.

For each canonical legal size-3 residual class, from the feat `CLS` line
`escape=<total-P> onP onN extP extN intP intN`:

```text
total P-children      = escape
on-conic  P-children  = onP
off-conic P-children  = escape - onP  =  extP + intP        (int = 0 tangents, ext = 2)
```

The identity `escape - onP == extP + intP` is asserted per class in the script — it holds for
every class at every q (no assertion fired), which is the parse cross-check.

## Result (verbatim)

```text
  q      kind root  #cls  off min  off max       off distribution (off:count)  min onP
--------------------------------------------------------------------------------------
  5    anchor    P     1        0        0                                0:1        1
  7    anchor    P     3        4        4                                4:3        3
  9    anchor    P     5        8       16                           8:3 16:2        5
 11  DEPLETED    P     8        8       16                           8:6 16:2        2
 13   control    P    12       37       40                     37:3 38:6 40:3        9
 17  DEPLETED    P    21        4        8                       4:3 7:12 8:6        1
 19   control    P    27      196      196                             196:27       15
```

`worst-class off-conic` = min over classes of the off-conic P-escape count = the thinnest fallback
margin. `min onP` = the on-conic min-witness (C68), reproduced here for alignment.

### The depleted orders in detail

**q = 11** (8 classes, on-conic capacity q−4 = 7). Off-conic distribution `8:6  16:2`:

```text
  WORST class (fewest off-conic escapes): cls=0 off=8  (escape=13 onP=5 onN=2 extP=5 intP=3)
  knife-edge classes (min onP = 2):
      cls= 4  onP=2 onN=5  escape(total P)=18  OFF-conic P=16 (extP=11 intP=5)
      cls= 7  onP=2 onN=5  escape(total P)=18  OFF-conic P=16 (extP=11 intP=5)
```

At q=11 the two axes **anti-align**: the knife-edge (thinnest on-conic, onP=2) classes are the
*most* off-conic-rich (off=16), while the worst off-conic class (off=8) has abundant on-conic
supply (onP=5). The fallback layer is robust at every class (off ≥ 8).

**q = 17** (21 classes, on-conic capacity q−4 = 13). Off-conic distribution `4:3  7:12  8:6`:

```text
  WORST class (fewest off-conic escapes): cls=2 off=4  (escape=5 onP=1 onN=12 extP=2 intP=2)
  knife-edge classes (min onP = 1):
      cls= 2  onP=1 onN=12  escape(total P)=5  OFF-conic P=4 (extP=2 intP=2)
      cls=17  onP=1 onN=12  escape(total P)=5  OFF-conic P=4 (extP=2 intP=2)
      cls=19  onP=1 onN=12  escape(total P)=5  OFF-conic P=4 (extP=2 intP=2)
```

At q=17 the two axes **align**: the three knife-edge (thinnest on-conic, onP=1) classes are
*exactly* the three worst off-conic classes (off=4). **The datum in the C44 spec is verified**:
the q=17 knife-edge class has escape=5 total P children, of which onP=1 on-conic and **4
off-conic** (extP=2 + intP=2). The pivot layer is thinnest exactly where the primary layer is
thinnest.

## Headline — the quantified fallback

Worst-class off-conic escape count (the (ON)-failure-branch safety margin), per depleted order:

| q  | kind         | worst-class off-conic | off-conic at knife-edge class | on-conic min-witness (C68) |
|---:|:-------------|----------------------:|------------------------------:|---------------------------:|
| 11 | arc-DEPLETED | **8**                 | 16                            | 2                          |
| 17 | arc-DEPLETED | **4**                 | **4**                         | 1                          |
| 13 | control      | 37                    | 37..40                        | 9 (= q−4, no depletion)    |
| 19 | control      | 196                   | 196                           | 15 (= q−4, no depletion)   |

At both depleted orders the off-conic fallback is nonzero: the (ii)-pivot layer *exists*. The
worst-class off-conic count runs `8 → 4` from q=11 to q=17.

## Verdict — comfortable or thin, and the trend

**Modest, not comfortable, and trending adverse.** The off-conic margin is larger than the
on-conic min-witness at each depleted order (roughly 4× at q=17: off 4 vs onP 1), so the fallback
layer does carry more escape supply than the layer it backstops. But:

1. **It is not ≫1 at q=17.** The worst class has **4** off-conic escapes — clearly positive, but
   small. This is the same order of magnitude as the total escape (5) at that class, i.e. almost
   all of the plane's escape margin there is off-conic, and there are only 4 of them.
2. **It trends the wrong way along the depleted subsequence**, mirroring the on-conic side:
   worst-class off-conic `8 → 4` (halving) and knife-edge off-conic `16 → 4` (quartering) from
   q=11 to q=17 — the same downward direction as on-conic min-witness `2 → 1`. Both depletion axes
   are shrinking as depleted q grows. (The controls trend strongly *up* — 37, 196 — but that is
   just off-conic density scaling with q at non-depleted orders; the meaningful comparison is
   depleted-to-depleted, and that is downward.)
3. **The two layers co-deplete at q=17.** At q=11 the knife-edge on-conic class is off-conic-rich
   (16), so a hypothetical zero-on-conic class there would still have a large off-conic fallback.
   At q=17 the alignment flips: the thinnest-on-conic classes are *also* the thinnest-off-conic
   classes. If this alignment persists to a larger depleted order, the class that first hits
   min-witness 0 is exactly the class most likely to be off-conic-thin as well — the adverse case
   for the pivot.

**Net:** the (ii)-pivot has a real, nonzero fallback layer at the known depleted orders (worst-class
off-conic = 8 at q=11, **4 at q=17**), so an (ON)-route failure at q=11/17 would not be a program
failure. But the fallback is **thin at q=17 and trending down**, and at q=17 it is thinnest exactly
where the on-conic route is thinnest. Two depleted points cannot decide bounded-vs-→0 (same caveat
as C68's `2 → 1 → ?`); the off-conic margin is on the same knife edge as the on-conic one, just one
notch back. q=25 (C44 census) is the datum that extends both trends — a size-3 class there with few
on-conic *and* few off-conic P escapes is the case this rider flags as pre-registered risk.

## Reproduce

```bash
cd rust
python3 scripts/c44_offconic_escape_margin.py
```

Reads `notes/data/codex-feat{5,7,9,11,13,17,19}*.out` (the same feat dumps C68 uses). Pure
parse + integer arithmetic; the feat solves are the exact P/N oracle. No new solves, no binary
built, RSS negligible. The q=25 s4arena census was not touched.
