# C904: cusp/tropical theta specialization parity audit

Date: 2026-08-11  
Status: sharp quarantined reduction; no parity verdict from present cusp data  
Scope: no manuscript or Lean edits; no commit

## Verdict

The existing exotic marked lattice, cusp-width, log one-motive, and smooth
theta-rigidification results do **not** determine the index of the special
generic fibre of

\[
             \operatorname{Sym}^2\Theta\longrightarrow J.
\]

They determine the semiabelian group and its monodromy/component lattices,
but not the vertical theta support or the closure of the addition graph in a
stable semiabelic compactification.  A direct claim of an odd tropical
component, or of special index exactly two, would therefore be an
overreach.

There is nevertheless a sharp exact parity signal.  At all four marked
cusps the exotic cubic component group has one and only one two-primary bit:

\[
 \Phi=({\bf Z}/3)^3\oplus {\bf Z}/6
 \quad\hbox{or}\quad
 \Phi={\bf Z}/6,
\]

and in both cases

\[
                  \Phi/2\Phi\cong\Phi[2]\cong {\bf Z}/2.
\]

For a target component label not divisible by two, the full-support label
model has respectively `81` or `3` free unordered pairs, both odd.  But the
parity changes when one changes the inversion-stable theta support while
keeping the same component group.  The replay gives explicit generating
supports in `Z/6` with quotient-pair parities one and zero.  Thus the log
component group alone cannot certify the desired parity.

The exact remaining theorem is geometric: construct the actual Mumford/
Alexeev--Nakamura theta pair for the four C904 cusp lattices and compute the
flat closure of the addition graph on it.  Without that theorem the cusp
attack remains quarantined.

## 1. Exact cusp input

After the common exotic marking, the four primitive widths are

\[
                            2,2,6,6.
\]

The nilpotent monodromy has rank five, so every cusp is totally degenerate.
The log scalar-two comparison has constant degree `2^10`.  On the exotic
cubic side the component groups are

| marked width | exotic component group |
|---:|---|
| `2` | `(Z/3)^3 + Z/6` |
| `2` | `(Z/3)^3 + Z/6` |
| `6` | `Z/6` |
| `6` | `Z/6` |

The smooth marked-base theta result supplies a unique symmetric theta
rigidification and proves that every local mod-two theta residue is zero.
This is enough to remove a finite theta-characteristic twist.  It does not
construct the vertical Cartier divisor in a chosen toroidal model, nor does
it extend the relative primitive Chow cycle across the cusp.

Multiplying a monodromy form by the ramification index changes the width but
not its Delaunay decomposition.  The four root/weight shapes still need to
be treated separately; their Smith groups do not encode their Delaunay
cells.

## 2. Correct semistable model of the addition fibre

Let `R` be the completed DVR at one marked cusp and let

\[
                         (P,\Theta_P)/R
\]

be a chosen stable semiabelic extension of the principally polarized
generic fibre.  The special semiabelic variety `P_0` is not a group.  Hence
there is no automatic morphism

\[
                         P\times_RP\longrightarrow P
\]

extending addition.

The correct object is the schematic closure `Gamma_+` of the generic graph
of addition in `P x_R P x_R P`.  The ordered theta correspondence is

\[
 Z_R=\Gamma_+\cap
       (\Theta_P\times_R\Theta_P\times_RP),
\]

followed by the transposition quotient on the first two factors.  Its
generic fibre is the desired ordered/unordered theta addition family.
Its special fibre can contain vertical and excess components unless one
proves flatness and compatibility of the graph closure with the Delaunay
stratification.

For any proper flat model `Y_R` of the generic unordered fibre, specialization
only gives

\[
                       \operatorname{ind}(Y_0)mid
                       \operatorname{ind}(Y_K)mid2.
\]

Thus a proof that `ind(Y_0)=2` would settle the generic gate negatively.
A proof that `ind(Y_0)=1` would not by itself settle it positively; an odd
special component must additionally be shown horizontal or liftable.

## 3. Exact component-label parity

Let `S` be the set of component labels actually met by the special theta
divisor.  For a target label `alpha`, the ordered label count is

\[
 N_\alpha(S)=\#\{x\in S:\alpha-x\in S\}.
\]

When `alpha` is not divisible by two, there is no fixed label `2x=alpha`, so
the unordered count is `N_alpha(S)/2`.  If one assumes the full-support model
`S=Phi`, this is

\[
                       |\Phi|/2=81\quad\hbox{or}\quad3,
\]

which is odd.  This is a useful fishing signal, not a theorem about theta.

The finite replay proves the limitation sharply.  In `Phi=Z/6`, both

\[
 S_1=\{0,1,5\},
 \qquad
 S_2=\{0,1,2,4,5\}
\]

are inversion-stable and generate `Phi`, but over `alpha=1` their unordered
pair counts are respectively one and two.  The same log group therefore
supports both parities.

There is a second reason not to identify `Phi` with the stable-theta
components: the Neron component group and the irreducible components of the
Alexeev stable semiabelic fibre are different invariants.  Already for a Tate
elliptic curve, stable reduction contracts the Neron polygon.  Pairing Neron
labels without the Delaunay theta model is not a computation of the stable
theta fibre.

## 4. What a decisive finite computation requires

A theorem-grade cusp computation needs the following inputs, none of which
is presently packaged in C904:

1. the actual integral positive-definite monodromy form on the character
   lattice at each of the four exotic cusps, not only its Smith invariants;
2. the affine theta characteristic/cubical trivialization fixed by the
   symmetric marking;
3. the periodic Delaunay decomposition and the initial theta equations on
   every cell orbit;
4. the initial ideal of the graph-closure equations for
   `theta(x)=theta(a-x)=0` over the function field of each target stratum;
5. saturation away from vertical, diagonal, and non-flat components;
6. residue-field degrees and multiplicities after the transposition
   quotient.

With those data the calculation is finite: enumerate cell orbits, form the
binomial/toric initial ideals, compute their Smith lattices and residue
extensions, and take the gcd of multiplicity times residue degree.  The
output would be either an explicit odd horizontal component or a proof that
the special-fibre index is exactly two.

## 5. Missing geometric theorem

The principal missing statement can be isolated as follows.

> **Cusp addition-flatness theorem needed.**  For the C904 totally
> degenerate ppav and its marked symmetric theta divisor, the closure of the
> generic addition graph in the canonical stable semiabelic pair is flat on
> the theta-by-theta incidence over a dense open of every target stratum;
> its special components and multiplicities are exactly those given by the
> corresponding Delaunay/binomial model, and the transposition quotient
> commutes with this specialization.

Alexeev--Nakamura supplies the stable semiabelic pair and canonical theta
divisor from full degeneration data.  The existing C904 log-one-motive
calculation does not supply the theorem above, and stable semiabelic
compactification is not functorial for the group law in the form needed
here.

The highest-EV next step is therefore not a larger Smith census.  It is to
export one actual cusp monodromy pairing and theta Fourier expansion, build
the graph closure on its finite Delaunay quotient, and test flatness there.
The width-six cusp with component group `Z/6` is the smallest exact test.

## 6. `ej` + `tt` closeout and mystery ledger

The closeout pass tested the tempting shortcut of reading parity directly
from the unique two-primary bit of the Neron component group.  The explicit
`Z/6` countermodels kill that shortcut.  The useful extra value is the
full-support signal `81/3`: it tells the future Delaunay computation exactly
where an odd component could appear, without promoting it prematurely.

- **Settled:** all four component groups have exactly one doubling defect.
  **Mystery:** which Neron labels, if any, correspond to theta strata in the
  stable model.  This is not encoded by the Smith table.
- **Settled:** component-group support data can realize either parity.
  **Mystery:** the actual affine theta support and its multiplicities.  The
  missing evidence is a Fourier--Jacobi/Delaunay export.
- **Settled:** the stable semiabelic fibre is not itself a group.
  **Mystery:** whether the addition-graph closure is flat on theta-by-theta
  incidence.  This is the named cusp addition-flatness theorem above.
- **Open:** special index one versus two.  No further lattice-only mystery
  remains; the residual is geometric and belongs to the width-six explicit
  Mumford-model successor.

## 7. Replay

```bash
cd /home/tavis/src/othello

diff -u notes/2026-08-11-c904-cusp-theta-component-parity.out \
  <(uv run python \
    notes/2026-08-11-c904-cusp-theta-component-parity.py)
```

The replay enumerates both cusp component groups, verifies their doubling
kernel/cokernel and full-support pair counts, and gives the two explicit
`Z/6` theta-support countermodels.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-cusp-theta-component-parity.py` | 2,557 | `fd68eedcb9736c132b089032c38bc7f5cd9348ac88369e9a2c3badc84742c3ec` |
| `2026-08-11-c904-cusp-theta-component-parity.out` | 499 | `f5778ff4206f98262d3d85a7ae64d4e8feddb38b33ec5e9a10fdc96eddac910d` |
