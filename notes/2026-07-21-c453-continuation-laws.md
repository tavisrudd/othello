# C453 / T6 — conditional continuation-law evaluations at 13, 19, and 31

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN AS A PREDICTION BOUND — 13 BLOCKED, 19 SPLIT/DISTINCT, 31 SPLIT/FUSED; NO CONTINUATION CONSTRUCTED`

Every conclusion below is conditional in the literal sense required by T6.  The arithmetic predicts
what a supplied parent/marker/spin-field package would do; it does not produce such a package.

## Conditional prediction table

The frozen H3 hypothesis is:

1. the marker is a golden `A5` over `K=Q(sqrt(5))`;
2. the two sheets are the reductions at the two primes of `K` above `p`; and
3. their rational transporter is the frozen `Rz`, of spinor squareclass `delta=2`.

Under exactly those hypotheses, splitting is controlled by `(5/p)` and, after splitting, PSL sheet
visibility is controlled by `(2/p)`.

| `p` | golden arithmetic | `(2/p)` | conditional H3-marker prediction | exact obstruction/control |
|:---:|:---|:---:|:---|:---|
| 13 | inert: `(5/13)=-1`; no roots of `phi^2-phi-1` in `F_13` | `-1` | no two `F_13` golden reductions, so the `(2/p)` sheet test is not reached | `|PSL_2(13)|=1092`, not divisible by `60`; a golden `A5` marker cannot occur |
| 19 | split: `(19)=(19,phi-5)(19,phi-15)` | `-1` | the two golden `A5` reductions are PSL-distinct | `|PSL_2(19)|=3420`; the natural 20-point action of either `A5` is transitive with point stabilizer `C3` |
| 31 | split: `(31)=(31,phi-13)(31,phi-19)` | `+1` | the two golden `A5` reductions are PSL-fused | `|PSL_2(31)|=14880`; the natural 32-point action of the fused marker `A5` has forced orbits `12+20` |

Thus the requested cliffhanger is sharp: `31 congruent 1 mod 5` really does split in `Z[phi]`, but
the H3 sheet bit degenerates because `2` is a square mod 31 (`8^2=2`).  Split is necessary for two
golden reductions; it is not sufficient for a PSL-visible bit.

At 13, the bare value `(2/13)=-1` must not be reported as a two-sheet prediction.  There are no two
golden primes to compare, and even the order-60 marker is excluded inside `PSL_2(13)`.

### Post-close free upgrade: the law is exactly mod 40

For every odd prime `p != 5`, the composite splitting/visibility law is already a complete
congruence table:

| outcome | reduced residue classes mod 40 |
|:---|:---|
| golden split and PSL-visible | `11,19,21,29` |
| golden split and PSL-fused | `1,9,31,39` |
| golden inert (so visibility test is not reached) | `3,7,13,17,23,27,33,37` |

Thus the visible and fused cases each occupy four of the sixteen reduced classes mod 40.  By
Dirichlet equidistribution they each have prime density `1/4`; conditional on golden splitting,
visibility and fusion each have density `1/2`.  In particular, 31 is not an isolated fusion
accident: it represents one entire half of the split-prime law.  The three test primes are clean
representatives of the three logical outcomes: 13 is inert despite `(2/13)=-1`, 19 is
split/visible, and 31 is split/fused.

## What parent and spin-field data are actually required

The numerology `q=h+1` does not determine a Coxeter parent.  Among exceptional types, `h=12`
allows `F4` or `E6`, `h=18` allows `E7`, and `h=30` allows `H4` or `E8`; classical and dihedral
types share each of these Coxeter numbers as well.  Therefore the prime alone supplies no
continuation law.

- **At 13 (conditional):** a proposal must first choose the parent and marker action, then exhibit
  a genuinely nontrivial quadratic spin/label field `K_13`, a transporter spinor squareclass
  `delta_13`, splitting of `K_13` at 13, and the required subgroup of `PSL_2(13)`.  The standard
  crystallographic `F4/E6` root data are rational and do not supply such a two-sheet field by
  themselves.  The frozen golden choice `K_13=Q(sqrt(5))` fails both splitting and marker order.

- **At 19 (conditional):** the exceptional `h=18` name is `E7`, whose standard root datum is again
  rational; a non-golden proposal must supply its own `K_19` and `delta_19`.  If instead the marker
  is explicitly the frozen golden H3 `A5`, then `K=Q(sqrt(5))`, `delta=2` give the split/distinct
  prediction in the table.  This certifies a possible H3 marker shadow, not an E7 parent.

- **At 31 (conditional):** `H4` canonically supplies the relevant golden field `Q(sqrt(5))`, and the
  frozen H3 marker transporter supplies `delta=2`.  `E8` is another exceptional `h=30` parent, but
  its rational root datum does not by itself inherit the H4 golden sheet law.  C395's independent
  characteristic-31 `A5` enhancement is an overlapping control only; no identification of that
  six-arc stabilizer with an H4 marker is asserted here.

These are input requirements, not invitations to construct the missing parents in this task.

## Exact bound on “H4 marker stabilizer in `PSL_2(31)`”

The relevant orders are

```text
|W(H4)| = 14400,
|W+(H4)| = 7200,
|W+(H4)/{+-I}| = 3600,
|PSL_2(31)| = 14880.
```

None of `14400`, `7200`, or `3600` divides `14880`.  Consequently `PSL_2(31)` cannot contain the
full, orientation-preserving, or projective-orientation H4 group.  The canonical local stabilizer
of an oriented H4 vertex is the orientation-preserving H3 group `A5`, of order 60; this order does
divide `14880`.  Hence “H4 marker stabilizer” can mean at most this local `A5` shadow here.  It
cannot mean that an H4 parent action has been embedded.

The natural `PSL_2(31)` action makes the bound still more explicit.  On the five `A5` classes
`1A,2A,3A,5A,5B`, its restricted permutation character is

```text
(32, 0, 2, 2, 2).
```

The values follow from split-torus arithmetic: order 2 divides `(31+1)/2=16` and has no rational
eigenlines, while orders 3 and 5 divide `(31-1)/2=15` and have two each.  With class sizes
`1,15,20,12,12`, Burnside gives exactly two orbits.  Since an involution fixes no point, point
stabilizers have odd order; the possible `A5` orbit sizes are `60,20,12`, so degree 32 forces
`12+20`, with stabilizers `C5` and `C3`.  Character decomposition independently gives

```text
2 * (1 + 3 + 3' + 4 + 5).
```

Thus this `A5` sees the familiar icosahedral `12+20` pair inside the 32 conic points, not the 60
projective vertex axes of an H4 object.  Moreover `(2/31)=+1` fuses the two golden-conjugate marker
sheets inside PSL.  No residual H3 sheet label is available to distinguish a hypothetical H4
marker.

For comparison only, at 19 the restricted character is `(20,0,2,0,0)`, Burnside gives one orbit,
and the point stabilizer has order 3.  This is consistent with the split/distinct golden sheets but
does not construct a parent for either one.

## Evidence, replay, and boundary

The deterministic standard-library checker recomputes Euler symbols, enumerates the roots of
`phi^2-phi-1`, factors all relevant group orders, performs exact `Q(sqrt(5))` A5-character inner
products, recovers orbit counts by Burnside, and checks the H4 order bounds.  It hashes every frozen
input named by the card.  The adjacent manifest records exact byte counts and SHA-256 hashes for
the report, checker, and canonical JSON.

Replay from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-21-c453-continuation-laws.py --check
sha256sum -c notes/2026-07-21-c453-continuation-laws.sha256
```

Independent internal checks: direct root enumeration agrees with Euler's criterion; Burnside orbit
counts agree with the forced odd-stabilizer orbit sizes; exact divisibility and gcd calculations
independently exclude every H4 parent group order.  No second implementation is needed for these
elementary exact calculations.  The trusted mathematical boundary is the frozen C440/C442
spin-field/transporter theorem, the exact A5 character table encoded in the checker, and the
standard split/nonsplit semisimple fixed-point criterion for `PSL_2(p)` on `P^1(F_p)`.
The mod-40 class partition is finite arithmetic; only its prime-density corollary invokes
Dirichlet equidistribution in reduced residue classes.

This bundle certifies no H4/E8/E7/E6/F4 construction, no new `PSL_2(p)` subgroup construction, no
existence theorem from `q=h+1`, and no continuation beyond the conditional table.  No novelty or
priority claim is made.
