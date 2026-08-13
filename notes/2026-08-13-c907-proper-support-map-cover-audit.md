# C907 proper-support map-cover audit

**Lane:** `clebsch`

**Status:** the proposed finite proper maps and the resulting *pointwise*
bounded-boundary image cover are valid after canonical diagonal strict
closure.  Curve selection and the ratio trichotomy do **not** prove the
stronger fibrewise local-acyclicity statement needed to conclude that only
the four residual Morse sections contribute.  The exact missing record is a
finite bad-image avoidance, equivalently a fibrewise controlled-lift table.

This audits the map-cover step in
`2026-08-13-c907-proper-support-modification-descent.md`; it does not alter
that note or any manuscript source.

## Canonical proper maps to one coarse closure

Let

\[
  B=\overline D\times\overline\Omega,
  \qquad G^\circ\xrightarrow{j_0}X_0\xrightarrow{a_0}B
\tag{1}
\]

be the reduced strict closure of the original graph in the common
multihomogeneous Cartier ambient.  Thus `a_0` is proper and `G^circ` is dense
in `X_0`; the translated loci `B=1,C=1` belong to the open graph whenever
`delta != 0`.

Suppose `M_i -> B` is any one of the proper compactifications used by the
local analysis: the intrinsic tropical exterior model, the `Z` ratio graph,
or the symmetric `W` ratio graph.  It is identified with `G^circ` over the
same open.  Even when no morphism `M_i -> X_0` has been written, there is a
canonical proper strict-closure correspondence

\[
 H_i=\overline{\Delta_{G^\circ}}^{\,(M_i\times_BX_0)_{\rm red}},
 \qquad
 p_i:H_i\longrightarrow X_0.
\tag{2}
\]

The projection is proper because it is the restriction of the proper base
change `M_i x_B X_0 -> X_0`.  It is an isomorphism over `G^circ`.  Moreover
`p_i` is surjective: its image is closed and contains the dense open
`G^circ` in `X_0`.  Hence (2) supplies the required proper maps without a
common fan or a direct map from one local compactification to another.

For `j_i:G^circ -> H_i`, proper-modification descent gives

\[
 Rp_{i*}j_{i!}A\simeq j_{0!}A.
\tag{3}
\]

This validates the map part of the proper-support route.  It does not say
that the pullback to `H_i` of a controlled chart of `M_i` remains a regular
or `L`-submersive chart: diagonal strict closure can introduce further
boundary over that chart.  That distinction matters below.

## What curve selection and the trichotomy do prove

Write `C` for the four protected residual sections in the bounded chart.
Let `U_ext`, `U_Z`, and `U_W` denote respectively the controlled exterior
charts and the two finite protected ratio charts, pulled back where defined
to the corresponding `H_i`.

**Arc-image proposition.**  Subject to the existing exterior chart-coverage
and ratio-graph constructions, every point of

\[
 (X_0\setminus G^\circ)\cap a_0^{-1}(B)\setminus C
\tag{4}
\]

is the image under at least one `p_i` of a point in one of
\(U_{\rm ext},U_Z,U_W\).  In symbols,

\[
 \partial_{\rm bd}X_0\setminus C
 \subset
 p_{\rm ext}(U_{\rm ext})\cup p_Z(U_Z)\cup p_W(U_W).
\tag{5}
\]

**Proof.**  Complex curve selection at a boundary point gives a holomorphic
arc in `X_0` with central value that point and punctured arc in `G^circ`.
All projective `y,B,C` coordinates along this arc are meromorphic, and
`delta` is either a unit or has positive order.

If `delta` is a unit, the horizontal Newton-face lemma puts the arc in an
exterior free-`L` chart.  If `ord(delta)>0` and compact `y` holds, the exact
ratio trichotomy puts each `Z` or `W` residual end in its finite ratio chart,
makes `L` unbounded, or sends the arc to a marked exterior type.  At double
residual infinity the product ratio has a pole, so it is in the latter two
cases and needs no third protected chart.  For noncompact `y`, the joint
support theorem gives positive order/free `L` while double marked; after a
marked-line exit the arc is exterior.  The finite residual alternative is
the bounded chart, whose only critical sections are `C`.

The generic lift of the punctured arc to the relevant `M_i` has a limit by
properness.  Its paired limit with the chosen point of `X_0` lies in (2),
which proves (5). \(\square\)

The proposition is a genuine finite coverage compression: the 81,367 support
cells are used only through the exterior `free L`/unit/`L=0` trichotomy, and
the protected end uses the three valuation alternatives.

## Why (5) is not a local-acyclicity proof

The stalk of a proper direct image sees the **whole** proper fibre.  A point
`x` lying in `p_i(U_i)` says only that one lift is controlled; it says nothing
about the other points of `p_i^{-1}(x)`.  Therefore (5) does not supply the
hypothesis of the modification-local acyclicity criterion, which needs an
open `V` of `x` for which the relevant entire inverse image
`p_i^{-1}(V)` is controlled.

This is not a technicality.  Let

\[
 q:\operatorname{Bl}_0\mathbb A^2\longrightarrow\mathbb A^2
\tag{6}
\]

be the blowup and let `e` be one point of its exceptional projective line.
An open chart `U` containing a different exceptional point has `0 in q(U)`,
but the fibre `q^{-1}(0)` still contains `e`.  A sheaf supported at `e` has
nonzero proper pushforward stalk at `0`, despite vanishing on `U`.

The forced `Bl_(h,v)` exceptional is the C907 version of (6): the unblown
ratio chart has a good `v` derivative, while a different lift can display a
polar-bad exceptional family.  Proper-support descent makes the total
pushforward intrinsic, but it does not let one discard an uncontrolled part
of a proper fibre because another lift is good.

Taking the disjoint union of the three `H_i` does not repair this.  It is a
proper surjection to `X_0`, but over `G^circ` it has three copies, so it is
not a modification and its direct image is three copies of (3), not the
intrinsic extension-by-zero object.

## The minimum valid replacement

For each model choose an open controlled locus `Q_i` on which its
extension-by-zero complex is `L`-locally acyclic, and put

\[
 B_i=H_i\setminus Q_i.
\tag{7}
\]

After shrinking to closed controlled charts, `B_i` is closed and
`p_i(B_i)` is closed by properness.  The needed finite table is

\[
 \partial_{\rm bd}X_0\setminus C
 \subset\bigcup_i\bigl(X_0\setminus p_i(B_i)\bigr).
\tag{8}
\]

For `x` in the `i`-th term of (8), choose a neighborhood `V` disjoint from
the closed set `p_i(B_i)`.  Then

\[
 p_i^{-1}(V)\subset Q_i,
\tag{9}
\]

so the modification-local acyclicity criterion applies and proves the
downstairs vanishing-cycle stalk is zero on `V`.

Equivalently, (8) can be certified by the following fibrewise arc condition:
for each assigned coarse subset and one fixed `i`, **every** arc in `H_i`
through a point over that subset whose punctured part lies in `G^circ` has
central point in `Q_i`.  If a point of `B_i` lay over the subset, curve
selection in the strict closure `H_i` would give a contradictory such arc.
This is the exact form in which valuation analysis can prove the desired
bad-image exclusion.

Existing C907 trichotomy is not yet this table: it assigns a model after
seeing an individual arc, and it does not analyze all lifts in one `H_i` or
the images `p_i(B_i)`.  The finite map-image cover (5) is therefore valid
but insufficient.  The new required audit is smaller and sharper than a
common-fan Fitting ledger: enumerate the bad loci of the three proper strict
closures and show their images avoid the coarse subset assigned to the other
model.

## EJ/TT and mystery ledger

- **EJ:** diagonal strict closure supplies every proper map to `X_0`
  canonically.  The actual remaining object is the image of the *bad* locus,
  not another compactification or fan.
- **TT:** a curve proves existence of one good valuation, whereas proper
  pushforward integrates over every valuation in the fibre.  The two
  quantifiers cannot be exchanged.
- **Settled:** proper-map construction; pointwise bounded-boundary image
  cover; the precise logical limit of curve selection/trichotomy.
- **Open:** the finite bad-image avoidance table (8), or an equivalent
  same-model fibrewise arc theorem; then iterated nearby/vanishing-cycle
  labels and the Gamma/Orlov seed.
