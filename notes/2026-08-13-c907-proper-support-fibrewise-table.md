# C907 fibrewise proper-support table

**Lane:** `clebsch`

**Status:** positive conditional completion of the whole-fibre quantifier for
the protected ratio model, and a finite structural table reducing the full
proper-support audit to the already-isolated exterior chart descent.  The
residual ratios do *not* have unique limits at the double-marked central
locus.  Nevertheless every limiting direction in the full proper ratio fibre
is controlled, except precisely at the four residual Morse sections.  This
uses the ratio graph itself over `X_0`, rather than a diagonal correspondence
which could add unrelated exceptional lifts.

## Common proper maps and the two bad loci

Let `X_0` be the reduced coarse Cartier strict closure over the closed
parameter/value base.  Use the following two proper maps, each an isomorphism
on the same original graph `G^circ`.

1. `pi_ext:E -> X_0` is the intrinsic tropical strict closure, using the
   canonical map from its pair-of-pants toric ambient to the two marked
   projective lines and the fixed projective `y` ambient.  The common-ambient
   strict-closure comparison in the schön audit supplies this map.
   A diagonal strict closure always constructs a proper correspondence, but
   can add exceptional points over a controlled exterior chart; it is not a
   replacement for this direct map in the fibrewise table unless those points
   are separately audited.
2. `pi_rat:R -> X_0` is the reduced strict closure of the **same** open graph
   `G^circ` in a product of projective ratio lines, so
   `pi_rat^{-1}(G^circ)=G^circ`.  Locally on compact `y` it records
   
   \[
    Z=\frac{1-B+\delta^2Q/Y}{\delta},\quad
    W=\frac{1-C+\delta^2Q/Y}{\delta},
    \quad \delta Z,\ \delta W,\ ZW.
   \tag{1}
   \]

The indeterminacy of the first two ratios is respectively

\[
 I_Z=\{\delta=0,B=1\},\qquad
 I_W=\{\delta=0,C=1\};
 \tag{2}
\]

their simultaneous indeterminacy is the full double-marked locus, not just
the four Morse points.  The projective graph makes `pi_rat` proper and
retains all of these directions in its fibre.

Put

\[
 T_{11}=\{\delta=0,\ B=C=1,\ y\in T_y,\ L\in\overline\Omega\}
 \subset X_0,
\tag{3}
\]

where `T_y` is the compact dense `y` torus, and let

\[
 \mathscr C=\{y_1=y_2=y_3=a,\ a^4=Q,\ L=4a\}\subset T_{11}
\tag{4}
\]

be the four protected central sections.  The prospective bad loci have the
following structural meaning:

| model | controlled locus | only possible bad image relevant to the table |
| --- | --- | --- |
| `E` | horizontal faces, all nonprotected vertical exterior masks, and noncompact-`y` double-marked faces | (T_{11}) |
| `R` | bounded chart and both finite ratio charts, with actual boundary `r=0` or `h=0` and `v`/`w` retained | (mathscr C), over (T_{11}) |

The first row is conditional on the existing regular exterior-chart descent:
the 70 lifted unit derivations, two `L=0` exclusions, and free-`L` masks
must be realized on the indicated scheme charts.  The second row is proved
below without a common fan.

## Exterior bad-image lemma

Let `B_ext` be the closed complement in `E` of the certified exterior
controlled charts.  Conditional only on the same scheme-chart descent used
by the unit-initial tangent lemma,

\[
 \pi_{\rm ext}(B_{\rm ext})\subset T_{11}.
\tag{4a}
\]

**Proof.**  At a point of `B_ext`, take a flag chart of the supported
intrinsic tropical closure.  A horizontal (`t=0`) face has `L` as a split
coordinate by the horizontal Newton-face lemma.  A noncompact-`y` face is
positive-order/free-`L`, including the double-marked case.  At compact `y`,
every vertical pair-of-pants type other than `(1,1)` is one of the exterior
unit, `L=0`, or free-`L` records.  None can lie in `B_ext`.

Hence a bad point is vertical, compact-`y`, and of pair-of-pants type
`(1,1)`.  In its actual chart map,

\[
 B=1-\epsilon_Bb,\qquad C=1-\epsilon_Cc,
 \qquad
 \delta=\prod z_F^{t(q_F)}.
\tag{4b}
\]

At such a vertical face the positive `t`, `beta`, and `gamma` exponents
force the relevant exceptional factors of `delta`, `epsilon_B`, and
`epsilon_C` to vanish.  Thus its image has
`delta=0,B=C=1`; compactness of `y` gives `y in T_y`.  This is exactly (3).
The direct common-ambient map preserves these coordinates, so no new image
point is introduced. \(\square\)

This is the complementary inclusion that an arcwise cover could not supply:
it controls **all** exterior lifts over the complement of `T_11`.

## Whole-fibre protected ratio theorem

**Theorem.**  For every

\[
 x\in T_{11}\setminus\mathscr C,
\tag{5}
\]

the entire proper fibre \(\pi_{\rm rat}^{-1}(x)\) is covered by the bounded
residual chart and the two finite imbalanced ratio charts.  On a neighborhood
of each point of that fibre, the actual-boundary coarsening has a regular
`L`-tangent unit; hence `j_!A` is `L`-locally acyclic there.  Consequently

\[
 \operatorname{Supp}\bigl(\phi_{L-u}(j_!A)\text{ on }R\bigr)
 \cap\pi_{\rm rat}^{-1}(T_{11})
 \subset\pi_{\rm rat}^{-1}(\mathscr C).
\tag{6}
\]

**Proof.**  Let `z` be any point of the strict ratio closure over `x`.
Because `R` is the strict closure of `G^circ`, complex curve selection at
`z` supplies an arc in `R` through `z` whose punctured part is in the
original graph.  Its `delta` order is positive, its `B,C` limits are both
one, its `y` limit remains in `T_y`, and its `L` limit lies in
\(\overline\Omega\).

If `Z` or `W` has a pole, the exact ratio valuative trichotomy says that the
arc has a center in the relevant finite imbalanced ratio chart, has unbounded
`L`, or exits through an actual exterior marked-line type.  The latter two
alternatives are impossible over (5): a pole of `L` conflicts with
`L in overline Omega`, while an exterior marked-line limit conflicts with the
fixed coarse equalities `B=C=1`.  If neither ratio has a pole, the arc is in the bounded residual
chart.  Double residual infinity is included in the pole alternative and
cannot occur over bounded `L`.  Thus the three displayed charts cover every
point of the whole fibre, not merely one selected lift.

Near this fibre the original open has no `y`, `B`, or `C` boundary: `y` is a
torus point and `B=C=1` are retained translated divisors.  In the finite `Z`
ratio chart, with

\[
 Z=r^{-1},\quad W=rv,\quad\delta=rh,
\tag{7}
\]

the only actual central coordinates are `r,h`; `v` remains tangent and the
cleared strict equation has the unit derivative

\[
 \left.\partial_vE\right|_{r=0}=-(1-h),\qquad
 \left.\partial_vE\right|_{h=0}=-1.
\tag{8}
\]

The apparent `r=0,h=1` locus is empty.  The symmetric chart has the same
`w` unit.  The only local extension-by-zero boundary is the actual divisor
`rh=0`; `v=0` (or `w=0`) is interior.  The regular `v` or `w` field is tangent
to this labelled pair and has unit `L` derivative, so its local flow supplies
an `L`-product of the pair and proves `phi_(L-u)(j_!A)=0`, not merely a
Fitting statement.

In the bounded chart the central potential is `f_Q+ZW`.  Its full critical
scheme, with `Z,W` retained as tangent coordinates, is exactly (4).  Hence
there is no remaining critical germ over (5); a tangent derivative gives the
same pair-product statement there.  These local acyclicity
neighborhoods cover the compact proper fibre, proving (6).  More explicitly,
the needed local-product input is the usual regular-coordinate lemma: the
fields `partial_v`, `partial_w`, and the bounded-chart noncritical field are
tangent to the *actual* boundary components after the translated `v=0,w=0`
divisors are forgotten.  Thus this step still requires the same
constructibility/actual-boundary convention as every other C907 unit-field
certificate; it does not use a bare derivative on a fictitious marked
stratum. \(\square\)

The theorem makes clear why uniqueness is the wrong target.  Over a point of
`T_11` the ratio fibre can contain whole projective families of directions;
the statement is that all of them lie in one of three controlled charts.

## Finite bad-image avoidance table

Let `B_ext` and `B_rat` be the closed complements of the controlled loci in
the two proper models.  With the exterior descent hypothesis in the first
row, the preceding theorem gives the exact inclusions

\[
 \pi_{\rm ext}(B_{\rm ext})\subset T_{11},
 \qquad
 \pi_{\rm rat}(B_{\rm rat})\cap T_{11}\subset\mathscr C.
\tag{9}
\]

Here is the complete coarse assignment.

| coarse bounded boundary subset | selected map | whole-fibre reason |
| --- | --- | --- |
| `delta != 0` horizontal actual boundary | `pi_ext` | every proper horizontal Newton face omits `L` |
| `delta=0`, not compact double marked | `pi_ext` | nonprotected vertical masks have free `L`, a lifted unit derivative, or `L=0`; noncompact double-marked directions are positive-order/free-`L` |
| `T_11 minus C` | `pi_rat` | whole-fibre theorem above |
| `C` | `pi_rat` | the four intended Morse sections |

In particular, away from `C`,

\[
 \partial_{\rm bd}X_0\setminus\mathscr C
 \subset
 \bigl(X_0\setminus\pi_{\rm ext}(B_{\rm ext})\bigr)
 \cup
 \bigl(X_0\setminus\pi_{\rm rat}(B_{\rm rat})\bigr).
\tag{10}
\]

Since each bad image is closed under a proper map, (10) supplies a
neighborhood of every noncore coarse boundary point on which the selected
model is controlled on its **entire** inverse image.  This is precisely the
whole-fibre condition missing from the earlier arc-image cover.  Proper
pushforward descent then proves the corresponding noncore vanishing-cycle
stalk is zero, subject to the exterior scheme-chart descent stated above.

## Scope and remaining certificate

This table removes the bad-quantifier obstruction for the protected row.
It does not silently promote the exterior row: its only remaining data are
finite and explicit.

1. Serialize the actual scheme charts on the direct exterior strict closure
   that realize the 70 tangent lifts, the two `L=0` exclusions, and the
   free-`L` fields, together with their extension-by-zero product structure.
2. Check that these charts cover every compact vertical exterior type other
   than `(1,1)`.  Formula (4a) then gives the first bad-image inclusion;
   components over `T_11` need not be controlled by the exterior model,
   because the ratio theorem controls that entire coarse locus away from
   `mathscr C`.
3. Apply proper pushforward to `phi_(L-u)` and then the labelled iterated
   `psi_delta` comparison.  The latter is still needed for thimbles,
   directions, and pairing.

The first two items are an exterior chart-descent table, not a global
Fitting, common-fan, or chart-gluing theorem.  A forced `(h,v)` exceptional
belongs only to an optional common marked refinement; it is absent from the
unblown ratio graph used in the second row and therefore cannot spoil its
whole-fibre calculation.

## EJ/TT and mystery ledger

- **EJ:** the protected ratio map has many central lifts, but they are all
  good.  This converts the trichotomy from an arcwise statement into the
  required proper-fibre result on the one locus where the fan obstruction
  lives.
- **TT:** nonunique compactification limits are harmless only after every
  point of the fibre is classified.  The strict-closure curve-selection
  argument supplies exactly that missing quantifier.
- **Settled:** ratio indeterminacy locus; whole-fibre protected coverage;
  protected bad-image inclusion; and the two-row finite bad-image table.
- **Open:** exterior scheme-chart descent (which turns (4a) into the first
  certified bad-image inclusion), then iterated labelled vanishing cycles and
  the Gamma/Orlov seed.
