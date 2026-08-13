# C907 audit: bounded-value schönness, regular DVR model, and the Rees subfan

**Lane:** `clebsch`

**Verdict:** the bounded-value absolute-schön route eliminates the need for an
explicit 97,709-chart *scheme* construction to obtain a proper regular model
of the marked graph over the original `delta` DVR.  The intrinsic theorem is
first proved on the smaller very-affine graph; the common-ambient strict-
transform lemma below restores `U=0,V=0`.  It must still be stated with the
qualification that
the certified initials are smooth as schemes with `L` allowed to vary.  This
proves regularity of the total graph by the full torus action; it does not
prove smoothness over the fixed value torus `S=G_m,L`.  The latter is exactly
the still-open Fitting/control gate.

The regular fan can be chosen in the original integral lattice, without a
Kummer base change, and can factor through the fixed residual blow-up
`Bl_(delta,U,V)`.  The Kummer atlas in
`2026-08-12-c907-kummer-pair-of-pants-refinement.md` remains a useful exact
chart/face certificate, but is no longer an existence prerequisite.

## 1. What the initial theorem actually proves

Let `T_7` be the torus in

\[
 (y_1,y_2,y_3,B,U,C,V),
\]

and let `S=G_{m,L}`.  For a valuation over `R x S`, `L` is a unit, so
`v(L)=0`; its residue still ranges over every point of `S`.  The 552 exact
nonvanishing records, together with the integral pair-of-pants initials,
show that the three displayed initial equations form the full initial ideal.
The circuit argument then proves that the resulting initial scheme in
`T_7 x S` is smooth or empty.

Here `T_7` inverts the auxiliary coordinates `U,V`, so this very-affine open
omits the retained translated divisors `B=1` and `C=1`.  The common ambient
comparison is nevertheless canonical.  The fan `Sigma_trop` refines the
product of the two tripod fans and the chosen `y` fan.  Its toric scheme
therefore maps to the product of the two standard pair-of-pants
compactifications and the `y` compactification.  The closure of
`B+U=1` in its toric pair-of-pants surface is the marked projective line;
its three toric points are exactly `B=0`, `U=0` (that is `B=1`), and
`B=infinity`, and similarly for `C`.

On the generic graph, eliminate `U=1-B` and `V=1-C`.  Its ring is a
localization of an integral Laurent polynomial ring, and `UV` is a
non-zero-divisor.  Thus the `UV!=0` graph is schematically dense in the
original graph which retains `U=0,V=0`.  Strict transform under the preceding
toric morphism is, by definition, closure of the inverse image of this common
dense open.  It is consequently the same scheme whether one starts from the
very-affine graph or from the original marked Cartier graph.  The translated
divisors reappear in this closure; they are not saturated away.  They are
toric boundary for construction purposes but are forgotten in the later
**actual** control partition.

The filtered-regular-sequence step is legitimate here directly on the
original very-affine graph.  It is not using a strict-transform chart: the
two pair-of-pants initials define an integral smooth base, and the certified
third initial is nonzero in that domain.  Consequently it is a regular
element, and the associated graded quotient is the quotient by the three
initial forms.  This is precisely the hypothesis needed for nonconstant
coefficient schönness of the graph itself.

There is one crucial non-consequence.  At order zero the graph is monic in
`L`; its total initial is smooth because `partial_L` is a unit.  After fixing
`L=l`, that derivative is unavailable.  Thus the same proof cannot claim
that every fixed-`l` initial, or the multiplication map relative to `S`, is
smooth.  The circuit note already isolates this point: graph smoothness is
not value-map submersivity.

## 2. Correct action for regularity of the total graph

Use the full acting torus

\[
 T=T_7\times S
\]

on `P_Sigma x S`; the fan has the zero cone in the `L` lattice direction,
so `L` remains uncompactified.  The multiplication map to use is

\[
 T\times \overline G\longrightarrow P_\Sigma\times S,
 \qquad
 (t_7,t_L;g,L)\longmapsto(t_7g,t_LL). \tag{1}
\]

Its orbit fibres are the certified **total** initial degenerations, with the
residue of `L` allowed to vary.  Hence the usual initial-degeneration proof
gives smoothness of (1).  If `P_Sigma` is regular, then the source of (1) is
regular; its smooth projection to `overline G` proves that `overline G` is
regular.  Pullback and smooth-local descent of the toric boundary give SNC
support for the central and horizontal boundary.

The tempting map

\[
 T_7\times\overline G\longrightarrow P_\Sigma\times S \tag{2}
\]

is stronger: its fibres fix `L`.  Smoothness of total initials does not prove
smoothness of (2), and no use of (2) is licensed before the coarse Fitting
ledger.  This is the only material repair needed to the new existence note's
relative-`G_m,L` paragraph.

Properness remains relative to `R x S`.  In its valuative criterion, a map to
`S` forces `L` to be a unit, hence gives exactly `v(L)=0`.  Valuations with
`v(L) != 0` are not missing boundary directions of this relative problem;
they are degenerations leaving the value torus and would matter only after
compactifying the value line.

## 3. The filtered-Koszul shortcut is valid

This supplies the missing formal bridge from the finite initial calculation to
bounded-value schönness of the **very-affine graph**; no strict-transform chart
attachment is needed for that conclusion.

Fix a rational weight `w` and multiply the graph equation by the Laurent
unit `XBC`.  Scale `w` to an integral filtration and give the valued Laurent
ring the good separated exhaustive weight filtration combining character
weight with the `delta`-adic coefficient valuation.  Write

\[
 A=K[y_1^{\pm1},y_2^{\pm1},y_3^{\pm1},B^{\pm1},U^{\pm1},
             C^{\pm1},V^{\pm1},L^{\pm1}],
\]

with equations `f_B=B+U-1`, `f_C=C+V-1`, and the cleared graph equation
`H`.  Let bars denote symbols in `gr_w A`.  The four pair-of-pants forms give

\[
 D_w=\operatorname{gr}_wA/(\bar f_B,\bar f_C), \tag{3}
\]

which is an integral smooth product of two linear pair-of-pants domains.
The normal-form certificate says precisely that `bar H` has nonzero image in
`D_w`.  Therefore

\[
 \bar f_B,\ \bar f_C,\ \bar H \tag{4}
\]

is a regular sequence.

For coverage, every weight in the tropicalization of the two
pair-of-pants equations lies in one of the sixteen ordered products of the
four tripod cones.  At positive `delta` order, the fifteen pairwise graph-
weight walls cut each such cone into exactly the cells serialized by the
`t=1` replay; its 552 ordered-type/mask records therefore contain the record
for this `w`.  The horizontal case is supplied separately below.  Thus the
regular-sequence premise is quantified over every bounded-value tropical
weight, not merely over the stored representatives.

The filtered Koszul complex on `f_B,f_C,H` has associated graded the Koszul
complex on (4).  The latter is exact in positive degrees.  The elementary
filtered-complex lifting argument (take the highest surviving filtration
symbol of a cycle and lift a Koszul preimage), equivalently the standard-basis
lemma for a regular sequence of symbols, makes the original Koszul complex
strict.  This uses goodness, separatedness, and exhaustiveness of the weight
filtration, not adic completeness.  In degree zero it gives the exact equality

\[
 \operatorname{in}_w(f_B,f_C,H)
   =(\bar f_B,\bar f_C,\bar H),\qquad
 \operatorname{gr}_w A/(f_B,f_C,H)
   =D_w/(\bar H). \tag{5}
\]

Thus the displayed three equations are a standard basis at every `w`: there
is no uncomputed S-polynomial, torsion, or embedded initial component.  This
is stronger and cleaner than a chartwise strict-transform identification, but
only on the original Laurent graph.  It says neither which exceptional
monomial a chosen compactification contributes nor what happens to `dL` on a
boundary restriction.

### Horizontal (`t=0`) check

The 81,367-cell replay takes the slice `t=1`, so it should not itself be
quoted as a certificate for a face lying wholly in `t=0`.  Fortunately the
nonvanishing part of (4) has a direct uniform proof.  After eliminating the
two pair-of-pants initials and localizing residue factors, every nonempty
graph mask is a subsum of

\[
 XBC L,\quad -XBCx_1,\quad-XBCx_2,\quad-XBCx_3,
 \quad-Q,\quad-XBCUV. \tag{6}
\]

The six summands have pairwise distinct exponent vectors in `(L,x_1,x_2,x_3)`:
the first is the unique `L` term, the next three have distinct `x` exponents,
the fifth is constant, and the last has exponent `X`.  Their coefficients
are nonzero residue units (with `Q in k^*`).  Hence **every nonempty mask**
in (6), including one first appearing on a horizontal face, is nonzero in the
pair-of-pants domain.  More precisely, a singleton mask is a Laurent unit
and its initial hypersurface is empty, whereas every mask with at least two
terms is a nonunit Laurent polynomial and has a geometric torus zero.  This
is the conceptual content underlying the 552 normal-form replay.

The circuit lemma is likewise independent of `t>0`.  Its sole generic/generic
five-term risk without `L` has equal `x_i` and reciprocal weights; with
`r_B=r_C=0` this forces `3m=-m`, hence `m=0`, contradicting omission of the
weight-zero `L` term.  If a factor is `0`, `1`, or `infinity`, the residue
derivative has the unit coefficients `1,4,5`.  It follows that the same
filtered-Koszul argument proves smooth-or-empty full initials at horizontal
directions too.

Geometrically, a `t=0` ray of the fan is a recession direction.  Its orbit
fibre is the iterated initial along `w_0+M r` for `M>>0`, or equivalently the
trivial-base initial of the generic fibre.  The preceding all-mask argument
applies directly to that iterated initial.  Thus the regular compactification
does not silently omit horizontal boundary smoothness.

## 4. Integral fan over the original DVR

Let `Sigma_trop` be the rational nonconstant-coefficient tropical complex of
the graph with `v(L)=0`.  It is obtained by retaining exactly the cells whose
tie masks have cardinality at least two: the 57 non-singleton masks.  The
extended replay records this nonemptiness bit for every realized
ordered-type/mask pair.  We use this explicitly constructed supported
complex, so no separate rigidity-based existence theorem is invoked.  A
regular fan in the **same** lattice

\[
 N=\mathbb Z\langle t,p_1,p_2,p_3,\beta,\gamma\rangle
\]

can be constructed as follows.

1. At the `(1,1)` cone first take the star fan of the regular sequence
   `(delta,U,V)`.  Its new primitive ray is
   
   \[
   e_R=(1,0,0,0,1,1),
   \]
   
   and its three cones are the `delta`, `U`, and `V` charts, respectively
   `t<=beta,gamma`, `beta<=t,gamma`, and `gamma<=t,beta`.
2. Take the common refinement of `Sigma_trop` and this Rees fan.  Equivalently
   in the exact support certificate add only
   
   \[
   t=\beta,\quad t=\gamma,\quad\beta=\gamma
   \]
   
   in the `(1,1)` cone.  This is finite, integral, and still supported in
   the original lattice.
3. Apply toric desingularization by stellar subdivisions along primitive
   lattice points, relative to this common refinement.  Each subdivision is
   in `N`, so no ramification `delta=r^e` occurs.  Standard determinant
   descent terminates: in a nonunimodular simplicial cone choose a nonzero
   lattice point in its half-open fundamental parallelepiped and star
   subdivide; its positive-coordinate child determinants are strictly
   smaller.  First barycentrically subdivide non-simplicial cones.  There are
   finitely many cones and the determinant multiset decreases lexicographically.

The Rees star is already regular: each of its three cones has determinant
one in `Z<e_delta,e_U,e_V>`.  Relative toric resolution therefore preserves
it as a target subfan.  The resulting regular fan may subdivide its charts,
but the final model factors through the chosen `Bl_(delta,U,V)` and retains
the three named Rees maps.  No Kummer cover is needed for regularity; only a
reduced semistable central fibre would require a ramified/Kummer alteration.

The fan used for the tropical pair is supported **exactly** on
`Sigma_trop`; its multiplication map is smooth and surjective over precisely
those toric orbits.  If a complete ambient toric scheme is desired, embed
this supported regular fan in a regular completion afterwards.  The already
proper tropical closure remains closed in that completion.  Extra completion
orbits are not declared part of the tropical pair and no surjectivity claim is
made over them.

The incidence transition agrees with this geometry.  The equation

\[
 s b_0+t b_1=1
\]

cannot be a simultaneous `0/1` special chart when `s=delta^a,t=delta^b` with
`a,b>0`, since it makes `delta` invertible.  It is a generic overlap or a
face with one coefficient a unit, not a fourth Rees cone.  Thus it imposes no
obstruction to the integral fan above and must not be used to merge the two
tripod rays.

## 5. What this closes and what it cannot close

The corrected theorem and common-ambient lemma supply for the marked graph:

- a proper regular compactification over `R x S`;
- SNC total boundary support;
- preservation under any further integral regular subdivision; and
- a model factoring through the fixed residual Rees blow-up with no change to
  the parameter loop.

It does not supply:

- strict `L`-submersivity on actual boundary strata;
- a finite list of those *coarse* strata after auxiliary translated divisors
  are forgotten;
- a fixed value neighbourhood excluding genuine boundary critical values; or
- collar/thimble/Gamma transport.

Indeed an arbitrary further subdivision can create an `L`-constant boundary
component even for a globally submersive map.  The regular-model theorem is
therefore a real algebraic simplification, not a replacement for the Fitting
or topology gates.

## EJ/TT and mystery ledger

- **EJ:** use a relative regular fan only for proper regular graph existence;
  it removes an enormous chart-attachment burden without spending a Kummer
  base change or changing the Stokes loop.
- **TT:** distinguish total graph smoothness from smoothness over the value
  torus.  The unit `partial_L` is a legitimate regularity pivot and an
  illegitimate Fitting pivot.
- **Settled:** a regular original-DVR fan can preserve the residual Rees
  blow-up as a factor; no explicit fan dump or Kummer alteration is needed.
- **Open:** fixed-value initial smoothness/submersivity on genuine coarse
  boundary strata and every topological consequence of it.
