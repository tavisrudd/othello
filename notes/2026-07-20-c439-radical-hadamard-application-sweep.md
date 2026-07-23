# C439 radical--Hadamard application sweep

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `COMPLETE — FORCED-CONTRACTION NATURALITY THEOREM; EXACT ARITHMETIC/MODULAR
NORMALIZATION OBSTRUCTION; B3 INTEGRAL-BLOCK GATE STOPS`

## Result

The sweep exports one positive naturality theorem and two exact stops.

First, C433's contraction is automatically functorial.  In any fibre let

```text
F²=0,  im(F)=ker(F)=L,  V=P direct_sum L,  F|P:P -> L an isomorphism.
```

There is a unique map `h` that is zero on `P` and equals `(F|P)^-1` on `L`.  Hence any isomorphism
transporting `F` and `P` transports `L`, `h`, the projectors `hF,Fh`, the grading `hF-Fh`, and the
full matrix-unit algebra `{hF,h,F,Fh}`.  On the based-golden-pair groupoid of C434/C492, the
minimal extra transport data are therefore the divided Fourier operator, the depth plane, the
valency pairing, and the ordered doubled/residual flag.  The contraction and all its algebraic
decorations are forced, not additional choices.

Second, C429's arithmetic line has a sharp normalization obstruction at `q=11`.  Its specialization
is canonically

```text
Z(2tau-1) tensor F_11  =  ker(D)
```

on the outer-odd fixed slice: the one-dimensional sheet-sign/projective-cover socle killed by the
depth map.  It is **not** C433's Fourier radical `L_F=im(F)`, which is a two-dimensional
Lagrangian plane.  The arithmetic quadratic line has rank one and `<5>=<1>` over `F_11`, whereas
the valency form restricts to rank zero on `L_F`.  Dimension and metric rank are invariant under
rescaling, so no integral/Frobenius normalization can identify the two.  The correct natural chain
is

```text
arithmetic sign line = ker(D) -> U_odd/ker(D) = P_depth --F-> L_F,
```

not an equality of the first and last terms.

There is nevertheless a canonical determinant-level bridge.  C433's second exact row is

```text
0 -> s -> U_odd --FD-> L_F -> 0,
```

where `s` is C429's specialized arithmetic sign line.  Taking determinants gives, functorially,

```text
det(U_odd) = s tensor det(L_F),
s = det(U_odd) tensor det(L_F)^(-1).                 (*)
```

Thus the arithmetic orientation line is exactly the **relative determinant line** of the depth
source and the Fourier Lagrangian.  This is the correct line-to-plane comparison: the direct
metric normalization is impossible, but the determinant defect is canonical.  Formula `(*)`
transports automatically with the exact row.  It carries the line and its outer character, not
C429's integral discriminant quadratic form; the isotropic restriction of the valency pairing to
`L_F` cannot supply that form.

Third, the gated B3 analogue stops before computation.  C414 freezes a canonical cyclotomic
four-dimensional odd Fourier core at both `S3` and `D8` seams, but explicitly leaves the integral
defining-characteristic lattice/modular comparison open.  There is no frozen B3 integral odd
block, no square-zero mod-7 operator, and no canonical contraction to test.  The queue's gate
therefore forbids manufacturing a new scheme or field census.

## Forced-contraction naturality theorem

Let an object over a field `k` consist of `(V,F,P,G,lambda_d,lambda_r)` where:

1. `F²=0`, `im(F)=ker(F)=L`, and `V=P direct_sum L`;
2. `F|P:P -> L` is an isomorphism;
3. `G` makes `F` self-adjoint, `L` is Lagrangian, and `P` is nondegenerate; and
4. `(lambda_d,lambda_r)` is an ordered pair of lines in `P` or `P*`.

Define `h|P=0` and `h|L=(F|P)^-1`.  If `T:V->V'` satisfies

```text
TF=F'T,  T(P)=P',  T*G'=cG (c != 0),
T(lambda_d,lambda_r)=(lambda'_d,lambda'_r),
```

then

```text
Th=h'T,
T(hF,Fh,h,F,hF-Fh)T^-1=(h'F',F'h',h',F',h'F'-F'h').
```

Indeed `ThT^-1` vanishes on `P'` and inverts `F'|P'` on `L'`, so uniqueness gives
`ThT^-1=h'`; every other identity follows by composition.  Conversely, the metric and ordered
flag are genuinely additional: C433's joint commutant of `(F,h)` is `GL_2`, the metric reduces it
projectively to `C2`, and the ordered flag kills that last involution.

If the object also comes from an exact depth row
`0 -> s -> U -> P -> 0`, composition with `F|P` gives
`0 -> s -> U -> L -> 0`.  Determinant functoriality then forces
`s=det(U) tensor det(L)^(-1)`.  Hence transport of the exact row also transports the arithmetic
relative-determinant line; it is not a fifth independent decoration.

C492 already proves that a based-golden-pair morphism canonically transports `K`, `K\\Omega`, the
sheet map, and the swap involution.  Thus a geometric realization of `D` whose image is `P` needs
only transport the four displayed tensors.  No choice of swap is involved: all swaps induce the
same involution on `K\\Omega`.

## Hypothesis and stop matrix

| target | restriction/radical input | verdict |
|:--|:--|:--|
| C418 Pasch/common-core | ranks `3,3`; radical dimension `0` | C430 separator fails; named generator work was correctly allowed |
| C418 four-endpoint/incidence-2 | ranks `1,1`; radical dimension `0` | same exact failure |
| C419 frozen generic stratum | ranks `1,1`; centered/second-moment rank `1`; radical dimension `0` throughout | uniform failure, hence no rank/radical splitting locus |
| C433 target | `rank(F)=rank(h)=rank(D)=2`, `F²=h²=0`, `Fh+hF=I` | positive forced-contraction object |
| C412/C526 source bridge | source flag cross-pairing `0`; target `2` (dually `5`) | terminal isometry obstruction |
| C429 at `q=11` | one-dimensional nondegenerate sign line versus two-dimensional isotropic `L_F` | terminal normalization obstruction |
| C434/C492 native fields | degrees `3,4` at B3 and `5,6` at H3 | semisimple at `7,11`; no native incidence degeneration |
| B3 modular Fourier | cyclotomic odd core exists; integral defining-characteristic block does not | gated negative stop |

The C492 bad-prime ledgers remain exact: `{2,3}` for B3 and `{2,3,5}` for H3.  At every bad prime
one of the consecutive component degrees vanishes and the other does not, producing its oriented
one-sided augmentation extension.  Native characteristics `7` and `11` divide neither the group
orders nor component degrees.  Consequently neither C433's defining-characteristic ambient
extension nor a hypothetical B3 analogue can be attributed to the small `S4/A5` Mackey incidence
modules.

## C433/C526 modular seam

The exact H3 matrices reconfirm

```text
F²=h²=0,  Fh+hF=I,  F^T G=GF,
im(F)=ker(F)=L_F,  P_depth intersect L_F=0.
```

The forced-contraction theorem packages the positive part, but it cannot repair the source bridge.
C526's complete polarized source-pairing space makes the ordered source flag orthogonal.  C433's
valency metric gives target cross-pairing `2`, or `5` in the dual convention.  Thus the source
retains a projective reflection while the metric-plus-flag target has trivial projective
stabilizer.  This obstruction is functorial under the C492 `A5` restriction and ends the modular
seam without fitted maps or another decomposition census.

## Arithmetic seam

For `R=Z[tau]/(tau²-tau-1)` and `delta=2tau-1`, C429 proves

```text
R^(sigma=-1)=Z delta,  delta²=5,
SNF(m_delta)=SNF(trace pairing)=(1,5).
```

At `11`, `5=4²`, so the fibre remembers only the split square class.  C430 identifies its sign
line with the outer-odd combination of the two projective-cover socles.  C433 then identifies that
line with `ker(D)=<[1,1,1]>`; quotienting by it produces the two-dimensional depth plane, and only
then does `F` reach the Fourier radical.  This pins the exact functorial relationship while ruling
out the stronger proposed specialization.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13.12:

```bash
python3 notes/2026-07-20-c439-radical-hadamard-application-sweep.py --check
python3 notes/2026-07-20-c439-radical-hadamard-application-sweep-replay.py
(cd notes && sha256sum -c 2026-07-20-c439-radical-hadamard-application-sweep.sha256)
```

Intentional regeneration is the primary command with `--write`.  The canonical JSON hash-pins all
sixteen load-bearing upstream reports/certificates.  The primary checker recomputes the C433
matrix identities, transversality, C526 cross-pairings, C429 Smith determinants and `q=11` square
class, and emits the complete hypothesis matrix.  The independent replay imports no primary code
and separately checks the modular identities and obstruction values.

The upstream C418/C419, C429, C430, C433, C434, C492, and C526 bundles already have independent
replays for their finite claims.  C439 adds no field enumeration.  Its new theorem is elementary
linear algebra and is proved above, not machine-checked.  The B3 negative is exactly the absence of
the task's required frozen input; it is not a nonexistence claim about possible future integral
models.

## Mystery ledger (`ej` + Tao closeout)

- **Settled — where the arithmetic line lands.** It is the depth-map kernel/socle, not the Fourier
  Lagrangian.  The quotient-and-contraction chain explains why the two had appeared adjacent.
- **Settled by the `ej` determinant pass — the strongest valid line-to-plane bridge.** The exact
  row canonically gives
  `s=det(U_odd) tensor det(L_F)^(-1)`.  This retains the orientation line and outer character while
  correctly refusing an unsupported quadratic-form identification.
- **Settled — which transport data are independent.** Once `F` and the depth plane move, `h` and
  the matrix units move uniquely.  The valency pairing and ordered flag remain the two genuine
  decorations.
- **Settled — whether the C526 mismatch is a normalization issue.** Zero versus nonzero
  cross-pairing, equivalently residual `C2` versus trivial projective stabilizer, is invariant
  under every scalar normalization.
- **Settled — whether B3 should be run now.** No: a cyclotomic odd core is weaker than the required
  integral defining-characteristic block.  The stated gate stops exactly there.
- **No unexplained task-owned mystery remains.** Constructing a B3 integral/Rees block would be
  new work outside C439's permitted gate, while an integral code invariant recovering the golden
  discriminant is already a separately unallocated C429 frontier.

## Goal

Apply C430's restriction/radical/product-algebra test across the crowns problems for which it is a
genuine structural pretest. Export a theorem, a sharp obstruction, or an exact rank-defect locus to
each owning task; do not replace those tasks with a field-by-field census.

The common input is

```text
sheet restrictions = zero-sum hyperplanes
+ one-dimensional separating second-moment radical
=> degree-two evaluation algebra = equal-sheet-sum hyperplane
=> signed-trade kernel = sheet-sign line.
```

For H3, also consume the proved identification

```text
affine radical = soc(P(1)_+) direct_sum soc(P(1)_-),
outer-odd radical line = C412 depth socle = C430 trade line.
```

## Sweep order and gates

1. **C418/C419 trade and moduli pretest.** Apply the three C430 hypotheses to every named
   seven/eight-point generator family before generating trades. A passing family closes at the
   rigidity theorem. A failing family exports only its exact restriction-rank defect, radical
   level partition, and quotient trade kernel to C418/C419; search nowhere else.
2. **C433 modular seam — closed input.** Consume C433's two exact quotient rows, transverse
   profile/Fourier planes, and canonical contraction `h²=0`, `Fh+hF=I`; equivalently use its
   matrix units `{hF,h,F,Fh}`. Its four-dimensional joint commutant is the sharp falsifier:
   recovering C412's binary flag requires an additional intrinsic tensor, not more decomposition
   data. The Tao metric refinement is also solved input: Fourier radical is Lagrangian, depth is
   nondegenerate, and the valency-isometric commutant is projectively `C2`, killed by the ordered
   cubic flag. Do not rerun the odd-block placement or a decomposition census.
3. **C429 arithmetic seam.** Lift the radical separator to the integral `Z[tau]` model, compute its
   Smith/Fitting data, and test Frobenius on the resulting line in split, inert, and ramified
   fibres. Continue only if one datum controls the already-certified arc/code/scheme chiralities;
   stop on a q=11-only reconstruction.
4. **C434 information lattice.** Formulate the coordinatewise-product construction functorially
   on the relevant `K\G/H` permutation modules. Require the radical-to-sheet-to-sign chain to imply
   decorated inversion or another recovery statement. Abstract subgroup bookkeeping is a negative
   stop.
5. **Native-prime portability battery.** Group the remaining small uses rather than spawning
   separate tasks:

   - verify that C429's q=11 integral/Frobenius radical line specializes to C433's
     valency-self-adjoint Lagrangian line, or record the exact normalization obstruction;
   - test the B3/q=7 analogue only if the frozen B3 scheme data already provide a canonical
     integral odd Fourier block; absence of that input is a negative stop, not permission for a
     new scheme census;
   - state the minimal functorial criterion under which a based-golden-pair morphism transports
     `D`, `F`, `h`, the valency pairing, and the ordered flag.

   Continue only if this yields one reconstruction or naturality theorem. A list of matching ranks
   is not an exit.

## Boundaries

- C424 consumes the abstract lemma and small certificates but remains `clebsch`-owned; this sweep
  does not edit Lean or claim its release gate.
- C406's classical matching/design ownership and bounded priority verdict are unchanged.
- C430 proves a conditional portable theorem and the exact B3/H3 hypotheses, not an unconditional
  theorem for every index-two orbit.
- Do not broaden fields, enumerate arbitrary arrangements, or launch a general modular character
  census after a failed named gate.
- C526 separately owns the source-Tate pairing yes/no bridge. Consume its disposition; do not fit
  the ten C412 flag maps here.

## Deliverable

Commit one same-stem report/script/JSON/checksum bundle recording the hypothesis matrix for every
tested target, exact checked counts and conventions, direct replay, and per-target export/stop
verdicts. Update each owning problem card with only its durable consequence; a target that receives
no theorem or obstruction remains unchanged.

Primary inputs:

- `notes/2026-07-20-c430-conceptual-balanced-half-rigidity.md`
- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`
- `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.md`
- `notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.md`
- `notes/2026-07-20-c418-c419-c410-successors.md`
- `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`
