# C907 L-mask coarse partial-Rees polar certificate

**Lane:** `clebsch`

**Status:** exact support-level polar reduction, conditional only on the
remaining coarse partial-Rees attachment/strictness records.  All 72
*exterior* order-zero `L` masks have a displayed coarse tangent derivative
which is a unit, or force `L=0` and so miss the fixed value torus.  The two
`(1,1)` masks are deliberately quarantined: their residue-torus opens are
free, but their closure contains the genuine bounded residual Rees star and
is not an exterior certificate.

This does not prove that a chosen regular tropical model attaches each support
cell to the displayed partial Rees chart, nor that its Fitting module is
strict under that attachment.  It makes those the only remaining algebraic
records for the order-zero polar gate.

## Exact domain and replay

The six graph terms have fixed labels

\[
 0=L,\quad1,2,3=x_1,x_2,x_3,\quad
 4=P=\frac{Q}{x_1x_2x_3BC},\quad5=R=UV.
\tag{1}
\]

`2026-08-12-c907-l-mask-coarse-polar.py` recomputes every upper-envelope
mask directly from the fifteen-sign vectors of the exact 81,367-cell tripod
refinement.  It finds precisely 74 `L`-containing ordered-type/mask records:

| ordered algebraic types | allowed `L` masks | records | control use |
| --- | --- | ---: | --- |
| `(g,1)`, `(0,1)`, `(1,g)`, `(1,0)` | `01234`, `012345` | 8 | exterior |
| `(1,infinity)`, `(infinity,1)` | every `0` plus a subset of `1,...,5` | 64 | exterior |
| `(1,1)` | `01234`, `012345` | 2 | protected residual star |

The first two rows are the 72 exterior records.  The exact replay is

```sh
cd /home/tavis/src/othello
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-l-mask-coarse-polar.py --check
```

It checks its script, canonical JSON output, and SHA-256 manifest.  As an
independent support cross-check, the older cleared-polynomial replay derives
the same seven-type classification while proving nonvanishing on every
pair-of-pants base initial:

```sh
cd /home/tavis/src/othello
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-pair-of-pants-initial-nonvanishing.py --check
```

The new replay uses only the raw hyperplane-refinement signs and elementary
case analysis; the independent replay uses a different polynomial normal-form
calculation.  Both pin the same input refinement by SHA-256.

## Coarse partial convention

At a marked type `1`, write the pair-of-pants relation as `B+U=1` or
`C+V=1`.  Its equation `B=1` or `C=1` is an auxiliary algebraic face, not an
actual control boundary.  Exterior witnesses are nevertheless required to
be regular tangent derivations on the genuine coarse boundary.  A formal
`d_B` normal to a type-`1` face is not such a derivation; the exhaustive
table below instead uses the independent infinity residue.

All residue factors named below are inverted in the associated residue
torus.  A unit witness is therefore a literal row/column minor of the coarse
polar Jacobian; it makes the corresponding Fitting ideal the unit ideal.
The certification remains conditional on the chart attachment identifying
the globally defined coarse cotangent module with this partial initial.

## Symbolic exterior reduction

Write `H` for the selected non-`L` part of the strict graph equation
`L-H=0`.  Criticality of `L` on the graph is equivalently vanishing of the
allowed coarse derivatives of `H`.

For the four two-mask types, the following table is exact after the standard
pair-of-pants residue substitutions:

| type | mask `01234` | mask `012345` |
| --- | --- | --- |
| `(g,1)` | `dlog_b H=-P` | `partial_c H=U=1-b` |
| `(0,1)` | `dlog_b H=-P` | `partial_c H=1` |
| `(1,g)` | `dlog_c H=-P` | `partial_b H=V=1-c` |
| `(1,0)` | `dlog_c H=-P` | `partial_b H=1` |

For example, `(g,1)` has

\[
B=b,\quad U=1-b,\quad C=1,\quad V=c.
\tag{2}
\]

The full mask has `R=(1-b)c`, so its `c` derivative is the residue unit
`U`; without `R`, the reciprocal term has logarithmic `b` derivative `-P`.
The other three rows are identical after the stated substitutions.  Hence
all eight records are polar-free on their coarse partial initials.

For `(1,infinity)`, use

\[
B=1,\quad U=b,\quad C=c,\quad V=-c,
\tag{3}
\]

and use the symmetric substitution for `(infinity,1)`.  Each of its 32 masks
falls into exactly one of these cases:

1. `0` alone: `H=0`, so `L=0`, excluded because the value base is
   \(\mathbb G_{m,L}\).
2. `5` occurs: `partial_bH=-c` (symmetrically `partial_cH=-b`), a unit.
3. `5` is absent and `4` is absent: some `x_i` occurs, and
   `dlog_xi H=x_i` is a unit.
4. `4` occurs but an `x_j` is absent: `dlog_xj H=-P` is a unit.
5. exactly `01234`: `dlog_c H=-P` for `(1,infinity)`, and symmetrically
   `dlog_b H=-P` for `(infinity,1)`; the infinity residue is a genuine tangent
   unit coordinate.

This exhaustive partition proves the other 64 records using regular tangent
derivations.  No derivative normal to the auxiliary `B=1` or `C=1` face is
used.

Every order-zero support mask *without* `L` is automatic once the partial
Rees/Fitting strictness is attached: its graph initial is independent of the
uncompactified base coordinate `L`, so `dL` is a free cotangent direction.
Consequently, this certificate reduces the full support-level polar question
to the 72 displayed exterior records and the single protected star.

## The protected `(1,1)` star

On the open `(1,1)` residue torus, `01234` has the coarse-unmarked witness
`d_BH=-P`, while for `012345` the fine residue expression

\[
B=C=1,\qquad U=b,\quad V=c,qquad H=x_1+x_2+x_3+Q/(x_1x_2x_3)+bc
\tag{4}
\]

has `partial_bH=c`, a unit after localizing that residue torus.  Neither
fact applies at its residue closure `b=c=0`.  That closure is exactly where
the bounded residual Rees chart must remain visible.  Its central polar model
is

\[
 L=f_Q+ZW,qquad
 Z=W=0,\quad y_1=y_2=y_3=a,\quad a^4=Q,\quad L=4a,
\tag{5}
\]

the four genuine Morse points.  The certificate records the two `(1,1)`
open masks as `protected_open_unit` rather than `unit`, and makes no
elimination claim on their closure.  In particular, it cannot repeat the
invalid move of treating the residual core as an exterior translated face.

## Conditional polar consequence

**Proposition.**  Suppose every regular cone/face/residue chart is attached
to its saturated strict graph generator and its reduced coarse partial Rees
cotangent module satisfies coarse log-polar strictness.  Suppose further that
the only chart closures assigned to the `(1,1)` residue closure are the
bounded residual core and its controlled interface.  Then all exterior
partial initials are `L`-submersive over every bounded
\(\Omega\Subset\mathbb C^*\).  The sole remaining polar scheme is the
four-section residual Morse family in the bounded core.

**Proof.**  A mask without `L` leaves `L` free.  For a mask with `L`, the
replay gives one of the unit rows above or `L=0`, except for `(1,1)`.
The assumed closure assignment quarantines the latter in (5).  Coarse
log-polar strictness lifts each unit initial minor and identifies every
critical specialization with its partial initial.  The relative log-polar
compactification theorem then gives the claimed coarse Fitting conclusion.
\(\square\)

The nontrivial hypotheses are intentionally visible: this proposition does
not convert the finite support calculation into an unconstructed global chart
attachment or a Whitney--Thom collar.

## EJ/TT and mystery ledger

- **EJ:** the 81,367-cell support is no longer a polar-elimination burden.
  It has 72 exterior order-zero witnesses, one protected residual star, and
  automatic `L`-free masks.
- **TT:** the only difficult `L` mask is not a large combinatorial family;
  it is the closure of an auxiliary `1/1` residue torus.  The correct move is
  to preserve that closure as the Morse core, not to make the auxiliary
  marking into a control boundary.
- **Settled:** exact seven-type `L` support classification; all exterior
  symbolic polar pivots; the necessary coarse-unmark pivot; and the residual
  exception.
- **Open:** partial Rees chart/overlap attachment and coarse polar strictness
  for a regular refinement; assignment of every `(1,1)` closure face to the
  bounded core or its interface; then the proper Whitney--Thom collar.
