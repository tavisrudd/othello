# C46 report: the t-ply conic-depletion ladder

Date: 2026-07-09.

## Result

The two-ply incidence count extends cleanly and, before truncation at zero, is independent of play
order.

Start from a normalized on-conic S4 root.  After `t` further legal plies, let

```text
a = number of those plies played on the root conic,
b = number played off the root conic,
t = a + b.
```

Then

```text
live_on >= max(0, q - 5 - D(a,b)),
D(a,b) = a + 5b + ab + b^2.
```

Maximizing the charged loss over `a+b=t` gives the q-uniform ladder

```text
live_on >= max(0, q - c(t)),
c(t) = t^2 + 5t + 5.
```

The inverse constraint—the first depth at which this incidence bound no longer excludes an empty
conic—is

```text
T(q) = ceil((sqrt(4q + 5) - 5) / 2).
```

Thus every legal continuation from an on-conic S4 root has a live conic at every depth `t<T(q)`.
The bound does **not** say that emptying occurs at `T(q)`; it says only that this counting argument
stops excluding it there.

## 1. Play window and proof

The affine root conic is

```text
C = {(u,u^-1) : u in F_q^*}.
```

The S4 root selects four of its `q-1` affine points.  Its two burned projective direction points
also lie on the completed projective conic, but their grid effects are the row/column exclusions.
At depth zero,

```text
live_on = q - 5.
```

Suppose the current continuation prefix contains `A` new on-conic moves and `B` off-conic moves.
Charge only possible *new* losses of live affine-conic cells.

### Adding an on-conic move

It costs at most

```text
1 + B.
```

The `1` is the selected cell itself.  Each of the `B` previous off-conic points defines one line
through the new conic point, and that line has at most one further conic intersection.  Rows,
columns, and lines between two selected conic points kill no additional affine-conic cell.

### Adding an off-conic move

It costs at most

```text
2 + (4 + A) + 2B = 6 + A + 2B.
```

- its row and column meet the affine conic once each: at most `2`;
- its lines to the four root conic points and the `A` later-selected conic points have at most one
  other conic intersection each: at most `4+A`;
- its line to each of the `B` earlier off-conic points has at most two conic intersections: at most
  `2B`.

Tangencies, external lines, repeated target cells, and cells already dead only reduce the number of
*new* losses, so the charge is a sound upper bound over every odd prime power, not only prime q.

### Summing the charges

Across the whole history:

```text
a                 own-cell charge of the on-conic moves
6b                base charge of the off-conic moves
ab                one charge for each on/off pair, whichever member is played second
2 * binom(b,2)    two charges for each off/off pair
```

Therefore

```text
D(a,b) = a + 6b + ab + b(b-1)
       = a + 5b + ab + b^2.
```

This is the useful order-independence: play order changes which move receives an on/off pair's
charge, but not the total charge.  Substituting `a=t-b` gives

```text
D(t-b,b) = t + (t+4)b,
```

which increases with `b`.  The worst pattern is therefore all-off (`b=t`), yielding

```text
c(t) = 5 + D(0,t) = t^2 + 5t + 5.
```

This is sharp as an optimization of the incidence charges.  Simultaneous geometric attainability
for every `(q,t,a,b)` is not asserted; the data below shows much stronger sharpness than expected.

### The t=2 gate

The pattern formula reproduces all three old constants exactly:

```text
(a,b)=(0,2): D=14, live_on >= max(0,q-19),
(a,b)=(1,1): D= 8, live_on >= max(0,q-13),
(a,b)=(2,0): D= 2, live_on  =       q-7.
```

For `b=0`, equality holds at every depth: on-conic moves merely select their own conic cells, so
`live_on=q-5-a`.

### Lean-statement granularity

A useful formal split is:

```text
normalized_liveOn_ge_of_counts
  (hseq : LegalExtensionSequence root moves)
  (ha : countOn moves = a)
  (hb : countOff moves = b) :
  liveOn (play root moves) >= q - 5 - (a + 5*b + a*b + b*b)

normalized_liveOn_ge_of_length
  (hseq : LegalExtensionSequence root moves)
  (ht : moves.length = t) :
  liveOn (play root moves) >= q - (t*t + 5*t + 5)
```

The natural-number statements should use truncated subtraction or an equivalent integer
inequality.  The proof needs only: row/column uniqueness on `C`, a line-conic intersection bound of
two, and the partition of later moves into on/off types.  No step is play-order-dependent after
the pair charges are summed.

## 2. Inverse constraint

Conic-emptying is excluded while

```text
q - (t^2 + 5t + 5) > 0.
```

Solving the quadratic gives

```text
T(q) = min {t : t^2 + 5t + 5 >= q}
     = ceil((sqrt(4q+5)-5)/2).
```

For the requested odd prime-power range:

| q | `T(q)` | unconditional meaning |
|---:|-------:|-----------------------|
| 11 | 1 | the all-off bound can become zero after one further ply |
| 13 | 2 | every depth-0/1 continuation retains a live conic |
| 17 | 2 | every depth-0/1 continuation retains a live conic |
| 19 | 2 | every depth-0/1 continuation retains a live conic |
| 23 | 3 | every continuation through depth 2 retains a live conic |
| 25 | 3 | every continuation through depth 2 retains a live conic |
| 27 | 3 | every continuation through depth 2 retains a live conic |
| 29 | 3 | every continuation through depth 2 retains a live conic |
| 31 | 4 | every continuation through depth 3 retains a live conic |

Asymptotically, `T(q)=sqrt(q)+O(1)`.  This is a genuine counterexample constraint but not a
strategy: it guarantees move availability on the conic before `T(q)`, not a P-valued reply or a
return to the conjectured `Good` set.

## 3. Sharpness and existing-data gate

Added the lightweight checker:

```text
rust/scripts/depletion_ladder_check.py
```

It reads only already-distilled telemetry:

- the 1.9 KB two-ply summary covering q=9,11,13,17,19,23,25;
- the 10 MB C38 forced-node table (all its q=9/13/17 rows);
- a bounded 100,000-row prefix of the existing q=19 forced-move file.

It neither traverses the large raw memo dumps nor calls the solver.  Before/after move states are
checked separately.  For prime q it also independently reclassifies every sampled cell as
on/internal/external and checks the conical-arc-theory boundary below.

Command:

```bash
python3 scripts/depletion_ladder_check.py \
  --forced-tsv s4-dumps/2026-07-09/c38-forced/forced_nodes.tsv \
  --two-ply-tsv s4-dumps/2026-07-08/ml/conic-bound-report.tsv \
  --forced-prefix s4-dumps/2026-07-09/c38-forced/q19-root-1234.forced.rows \
  --max-prefix-rows 100000 --compact
```

Output:

```text
TWO_PLY groups=54 failures=0
LADDER states=288802 groups=56 failures=0 geometry_failures=0 typeI_failures=0
SHARPNESS positive_groups=14 positive_sharp=14 all_groups_sharp=54/56
LITERATURE q kind internal external rows
13 E 0 2 34
13 M 1 1 48
13 M 1 2 36
13 below-E 0 2 60
13 below-E 0 3 36
17 E 0 2 43
17 I 2 0 55
17 M 1 1 261
17 M 1 2 142
17 below-E 0 2 228
17 below-E 0 3 95
```

Interpretation:

- The complete two-ply summary has **54/54 passing geometry groups**, and every group's observed
  minimum equals its bound.  In particular q=23 off/off attains `live_on=4=q-19`, so the large-q
  two-ply constant cannot be improved by this style of unconditioned counting.
- Across 288,802 deeper state observations, all 56 `(q,t,a,b)` groups pass.  Every one of the 14
  groups with a positive pattern-specific lower bound attains it exactly.  The only two groups not
  sharp have a truncated bound of zero but sampled minimum one.
- The q=17 empty-conic witnesses are consistent: `T(17)=2`, and the full two-ply telemetry contains
  legal off/off positions (including mixed internal/external off-point types) with `live_on=0`.
  The ladder excludes emptying only before depth 2 there.
- q=19 likewise has `T(19)=2` and exact two-ply empty-conic rows.  The deeper q=19 prefix passes
  through depth 5.
- q=23 has exact, sharp depth-2 telemetry but no geometry-bearing deeper state table in the light
  artifacts.  Its raw keys do not reconstruct positions by themselves.  Therefore `T(23)=3` is
  proof-side only: this task did not launch a new depth-3 campaign merely to seek an empty witness.

## 4. Finite-endgame branch: exact scope of conical-arc theory

Reference: Coolsaet--Sticker,
[*Arcs with Large Conical Subsets*](https://doi.org/10.37236/384), EJC 17 (2010), #R112.

In projective variables, after the S4 root and the additional `(a,b)` moves,

```text
selected points on the completed projective conic: |T| = 6 + a,
supplementary/off-conic points (the excess):        e = b.
```

The paper's word **large** means equality at one of two thresholds, not an interval:

| paper type | supplementary points | paper threshold | game threshold |
|------------|----------------------|-----------------|----------------|
| I | all internal to C | `|T|=(q+1)/2` | `a=(q-11)/2` |
| M | at least one internal and one external | `|T|=(q+1)/2` | `a=(q-11)/2` |
| E | all external to C | `|T|=(q+3)/2` | `a=(q-9)/2` |

The threshold difference is forced by tangent structure: an internal point has `(q+1)/2`
secants and no tangents; an external point has `(q-1)/2` secants and two tangents.  Below these
equalities the paper's large-subset classifications do not apply.  In particular, an all-external
state with `|T|=(q+1)/2` is **one conic point short of type E**, not type M; the checker records
such rows as `below-E` to prevent this translation error.

### What becomes finite

At excess two the orbital-index graph `Gamma(C,U)` gives the complete classical skeletons:

- type I: disjoint even cycles of a common length;
- type E: even cycles plus two equal odd-order paths;
- type M: even cycles plus one even-order path.

These are exactly the path/cycle objects behind the conic-localized Node-Kayles reduction.

For **pure-internal type I only**, the paper proves a uniform higher-excess bound:

```text
e <= 4.
```

The remaining internal skeletons are therefore genuinely finite by excess:

- `e=2`: the cyclic normal forms above;
- `e=3`: the dihedral/pole extension described by their Theorem 10 and Lemma 12;
- `e=4`: the exceptional `S4/A4` orbit form, possible only when `q == -1 (mod 24)`.

The sampled large-threshold rows contain q=17 type-I excess two and no violation of either the
`e<=4` bound or the excess-4 congruence gate.

No qualifying large-threshold row occurs in the bounded q=19 prefix, and the light q=23 telemetry
ends at depth two, before its type-I/type-M threshold `a=6`.  These are coverage gaps, not claimed
passes; checking them exhaustively would require scanning the large forced-state corpus or creating
new geometry-bearing q=23 telemetry, neither of which was needed to validate the theorem.

### What does not become finite

The cited paper does **not** prove a corresponding uniform excess bound for type E or type M.
It gives exact excess-two classifications and computational extension tables, including examples
with larger external/mixed excess.  Consequently the queue's hoped-for "bounded off-conic
skeletons left in that regime" is valid as a theorem only on the pure-internal type-I branch.
External or mixed game states at their large thresholds still need a separate argument; the
incidence ladder remains the unconditional fallback outside type I.

This boundary also explains why the classical result is a finite-endgame component rather than a
replacement for the ladder.  It activates late—when `6+a` reaches roughly `q/2`—whereas the
universal ladder becomes nonpositive after only about `sqrt(q)` mostly-off plies.

## 5. Falsification-map consequence

The old q>=23 row was just the `t=2` instance.  The corrected general statement is:

```text
after t further plies from an on-conic S4 root,
live_on >= max(0, q - (t^2+5t+5));
therefore conic-emptying is impossible for every t<T(q).
```

For q>=23 this retains the old conclusion through two plies and adds a growing depth constraint:
`T(23)=T(25)=T(27)=T(29)=3`, `T(31)=4`, and `T(q)=sqrt(q)+O(1)`.  This still does not eliminate a
trap, because live legal conic cells need not be P-valued and the bound supplies no `Good`-closure
reply.

## Verdict

C46 is positive as a publishable constraint:

- the general pattern-sensitive inequality is explicit and order-independent;
- the q-only closed form and inverse `T(q)` are proved;
- `c(2)` exactly recovers the old lemma;
- the existing telemetry shows zero violations and empirical sharpness;
- the conical-arc branch is translated precisely, including the important negative boundary that
  only type I has a proven uniform excess cap.

No new solve, raw-dump traversal, certificate generation, or Lean build was run.
