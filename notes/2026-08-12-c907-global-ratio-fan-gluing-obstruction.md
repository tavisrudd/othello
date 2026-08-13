# C907 global ratio-fan gluing obstruction

**Lane:** `clebsch`

**Status:** decisive negative result for the proposed global
residue-admissible *toroidal fan* gluing.  The compact finite-ratio chart is
safe as a local non-toroidal control chart, but it is not an unsplit cone of
the marked pair-of-pants valuation fan.  Any common fan which records the
pair-of-pants valuation must introduce the dangerous `(h,v)` (and
symmetrically `(k,w)`) exceptional divisor.  Filtered Koszul and Cartier
uniqueness do not remove this obstruction.

## The interior bend of the ratio-to-tripod map

At the `Z`-infinity ratio chart write

\[
Z=r^{-1},\qquad W=rv,\qquad\delta=rh,
\]

and let `A=Q/Y` be a unit on compact `y`.  The exact pair-of-pants equations
are

\[
1-B=h(1-r^2hA),\qquad
1-C=r^2h(v-hA).\tag{1}
\]

For valuations

\[
\alpha=\operatorname{ord}r,\qquad
k=\operatorname{ord}h,\qquad
\ell=\operatorname{ord}v
\]

in the relative interior of the finite-ratio cone, one has, away from
leading-coefficient cancellation,

\[
t=\alpha+k,\qquad
\beta=k,\qquad
\gamma=2\alpha+k+\min\{\ell,k\}.\tag{2}
\]

The equality `ell=k` is therefore an interior bend of the map from the
coordinate cone

\[
C_Z=\mathbb R_{\geq0}\langle e_r,e_h,e_v\rangle\tag{3}
\]

to the `(t,beta,gamma)` marked support complex.  It is not a graph-support
wall: the product graph weight is

\[
2t-\beta-\gamma=-\min\{\ell,k\}\leq0.\tag{4}
\]

But it *is* a required wall for any common rational polyhedral complex which
maps toroidally to the pair-of-pants tropicalization, because (2) is not
linear on the whole of (3).  On the coefficient locus where the two leading
terms in `v-hA` cancel, `gamma` is larger; this is an additional residue
stratum over the same wall, not a reason to omit the wall.

The two linearity cones are

\[
\langle e_r,e_h,e_h+e_v\rangle,qquad
\langle e_r,e_v,e_h+e_v\rangle.\tag{5}
\]

Thus the requisite subdivision inserts `e_h+e_v`.  In the ratio affine
chart this is the toric star subdivision, equivalently the blow-up, of the
center `(h,v)`.  It subdivides the interior of `C_Z`; hence `C_Z` cannot be
fixed as a regular common subfan.  The symmetric `W`-infinity calculation
inserts `e_k+e_w` and blows up `(k,w)`.

## The forced exceptional divisor is polar-bad

On the `h` chart of the blow-up write

\[
h=h_1,\qquad v=h_1q,\qquad\delta=rh_1.\tag{6}
\]

The exact finite-ratio potential becomes

\[
\begin{aligned}
B&=1-h_1+r^2h_1^2A,\\
C&=1+r^2h_1^2(A-q),\\
F&=S+\frac A{BC}+h_1q-h_1A-r^2h_1^2Aq+r^2h_1^2A^2.
\end{aligned}\tag{7}
\]

The exceptional divisor `h_1=0` is contained in the total transform of
`delta=0`; it is therefore an **actual** central-boundary component, not an
auxiliary translated divisor that coarse control may forget.  Its restricted
value map is

\[
F|_{h_1=0}=S+A=f_Q,\tag{8}
\]

independent of the new residue `q`.  Its relative critical scheme contains

\[
y_1=y_2=y_3=a,\qquad a^4=Q,\qquad L=4a,\qquad q\text{ free}.\tag{9}
\]

Thus it is four positive-dimensional critical families, not the four Morse
points of the bounded core.  This is worse than a fine-face artefact: it is
critical for the value map on a genuine new actual-boundary divisor.  The
same obstruction occurs on the symmetric `(k,w)` blow-up.

## Why the proposed formal shortcuts do not repair it

The filtered-Koszul theorem proves equality of full initials and smoothness
or emptiness for the **very-affine graph** on its supported tropical
compactification.  The ratio maps use `v-hA`, a nonmonomial expression with
a residue-dependent cancellation locus.  They are not a toric subdivision of
that very-affine fan.  Consequently filtered Koszul does not identify the
strict graph on the ratio blow-up or on (6).  The finite ratio chart has a
separate exact cleared equation, but the pole/exterior overlaps and (6) still
need their own strict-transform calculation.

Likewise, global Cartier closure implies only that two already identified
strict-transform generators of the same effective Cartier divisor differ by
a unit.  It does not show that a pullback divided by a proposed exceptional
monomial has the certified initial equation, nor that it is flat after the
non-toric ratio modification.  Cartier uniqueness cannot turn (8) into a
unit tangent derivative.

Finally, the exterior unit-initial tangent lemma applies after a genuine
regular scheme chart supplies a regular tangent lift.  The logarithmic
residue pivots descend through a unimodular toric chart, but the ordinary
type-`1` derivatives require precisely the chartwise scheme descent that the
global ratio construction has not supplied.  This is an attachment issue
independent of the obstruction (5)--(9).

## Exact conclusion

There is no theorem that simultaneously asserts all of the following from
the present certificates:

1. one common toroidal fan dominates the marked support fan and both ratio
   modifications;
2. the full compact cones `C_Z,C_W` remain fixed subfans; and
3. the protected coarse Fitting ledger retains the `v,w` unit directions.

Items 1 and 2 force (5), while (5) contradicts item 3 by (8)--(9).  The
valid local result is the ratio-chart valuative carrier theorem before this
toroidal common-fan demand.  A future positive global theorem needs a
different non-toroidal gluing/control mechanism, or a new argument killing
the four families (9); ordinary relative toric desingularization cannot
supply it.

## EJ/TT

- **EJ:** graph-support safety and toroidal compatibility are different.
  The graph sees no wall at `ell=k`; the pair-of-pants valuation map does.
- **TT:** resolving that missing valuation wall creates an actual exceptional
  divisor on which the value map is (f_Q), so no amount of coarse forgetting
  can preserve the local imbalanced unit argument.
