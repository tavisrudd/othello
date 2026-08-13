# C907 protected residual ratio-cover audit

**Lane:** `clebsch`

**Status:** exact local valuation theorem, with a sharp obstruction to the
stronger claim that an arbitrary common regular refinement preserves its
coarse value-submersivity.  It validates the bounded/imbalanced/exterior
carrier trichotomy, not a full Fitting ledger without an admissibility
condition on further centers.

## The finite ratio chart is exact

Put `A=Q/Y`, `S=y_1+y_2+y_3` and

\[
B=1-\delta Z+\delta^2A,\qquad
C=1-\delta W+\delta^2A.\tag{1}
\]

At the `Z`-infinity end set

\[
r=Z^{-1},\qquad v=ZW,\qquad h=\delta Z,
\]

so `W=rv` and `delta=rh`.  The finite chart of the simultaneous ratio graph
`[W:r]` and `[delta:r]` has

\[
\begin{aligned}
B&=1-h+r^2h^2A,\\
C&=1-r^2hv+r^2h^2A,\\
F&=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
\end{aligned}\tag{2}
\]

It is important to use the cleared strict equation, rather than apply the
displayed rational derivative at `B=0` or `C=0`:

\[
E=BC(L-S-v+hA+r^2hAv-r^2h^2A^2)-A.\tag{3}
\]

On `r=0`,

\[
E=(1-h)(L-S-v+hA)-A,\qquad D_vE=-(1-h),\tag{4}
\]

and on `h=0`, `D_vE=-1`.  The apparent locus `r=0,h=1` has `B=0` and
`E=-A`, hence is empty.  Therefore every nonempty actual central component
or intersection in this finite-ratio chart has a regular tangent unit in
the `v` direction.  The symmetric assertion holds at `W` infinity.

## Exact valuative trichotomy

Assume `y` is compact, so `A` and `S` have order zero.  For an arc at
`Z=infinity` write

\[
a=\operatorname{ord}r>0,\qquad b=\operatorname{ord}W,\qquad
t=\operatorname{ord}\delta>0.\tag{5}
\]

The three comparisons

\[
(b\geq a\text{ and }t\geq a),\qquad
(b<a\text{ and }t\geq a),\qquad t<a\tag{6}
\]

are exhaustive.

1. In the first case `v=W/r` and `h=delta/r` are regular, and the arc has a
   center in (2).
2. In the second case
   \[
   \operatorname{ord}v=b-a<0,\quad
   \operatorname{ord}h=t-a\geq0,\quad
   \operatorname{ord}(r^2hAv)=t+b=(b-a)+(t+a)>b-a.\tag{7}
   \]
   If `B,C` are generic units, `S` and `A/(BC)` have order zero and every
   remaining term in (2) has order strictly bigger than `b-a`.  Thus `v` is
   the unique leading term, so no cancellation is possible and
   \(operatorname{ord}L=b-a<0\).  If `B` or `C` is not a generic unit, the
   arc has instead reached an exterior marked-line type.  More explicitly,
   `B` is finite in this case; a negative `t+b` makes `C=infinity`, and a
   zero residue of either finite factor gives type `0`.
3. In the third case `h` is the unique negative-order term in
   \(
   B=1-h+\delta^2A
   \), so `B=infinity`, again an exterior type.  There is no cancellation in
   this conclusion; `C` may have any exterior or generic type.

Thus every compact-`y`, bounded-value center at this end lies in the finite
ratio chart or in an exterior chart.  At double infinity, applying the same
test at either end gives the same result.  The symmetric argument handles
`W` infinity.  A noncompact-`y` arc must first be sorted by its marked-line
limit: it is covered by the joint `(1,1)` positive-order/free-`L` theorem
only when it remains double marked; after a marked-line exit it belongs to
the corresponding exterior support theorem.  This is the correct form of
the noncompact import.

## Why arbitrary further refinement is not allowed

The statement that `v=0` is not an actual boundary divisor holds in the
finite-ratio chart: it is the strict transform of the retained translated
divisor.  It is not stable under arbitrary modifications over the central
fibre.  Blow up the vertical center `(r,v)`.  On the chart

\[
r=r_1,\qquad v=r_1q,\qquad\delta=r_1h,\tag{8}
\]

the exceptional divisor `r_1=0` lies in the total transform of `delta=0`,
so it is an actual boundary component.  Restricting (2) to it gives

\[
F_0=S+\frac A{1-h}-hA,\tag{9}
\]

which is independent of `q`.  Its restricted tangent equation contains
the old factor `h(2-h)`; it has the artificial four-point packets at `h=0`
and `h=2`.  They are now critical for the map restricted to this new actual
exceptional divisor.  Coarsening cannot forget this divisor, because it
lies over `delta=0`.

Consequently neither a generic common toroidal subdivision nor the phrase
“pull back only the actual boundary” guarantees that the unit `D_vE` survives.
The ratio cover supplies a valid local control chart only for a refinement
which is **residue-admissible** at this end: no center whose ideal contains
both an actual central coordinate and the retained translated-residue
coordinate `v` (and symmetrically `w`) may be used, unless a new tangent-unit
calculation is supplied for its exceptional divisor.

## Exact conclusion

The ratio construction establishes the carrier statement

\[
\boxed{\text{bounded core}}\ \cup\
\boxed{\text{finite `Z`/`W` ratio chart}}\ \cup\
\boxed{\text{exterior marked-line chart}}.\tag{10}
\]

It also supplies the compact-`y` unit direction on the middle boxes and the
unbounded-value proof for their pole complements.  To deduce the coarse
Fitting ledger, one still needs a residue-admissible common refinement and
the local strict-transform attachment on its noncompact/exterior pieces.
The trichotomy alone does not prove either requirement.

## EJ/TT

- **EJ:** the only possible pole cancellation is excluded by the strict
  inequality in (7); the ratio chart really does cover all compact bounded
  residual ends.
- **TT:** `v=0` may be an interior divisor before resolution but a center
  using it creates a new actual vertical divisor.  “Forget the translated
  divisor” is therefore a condition on the chosen modification, not a
  consequence of coarsening.
