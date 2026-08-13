# C907 logarithmic exterior chart descent

**Lane:** `clebsch`

**Verdict:** the direct supported regular tropical model closes the exterior
scheme-chart/control descent.  The prior ordinary `partial_b` and
`partial_c` pivots can all be replaced by logarithmic residue-character
fields.  Together with filtered-Koszul full-initial equality, this gives a
regular actual-boundary tangent field with unit `L` derivative on every
exterior vertical unit chart.  The two `L=0` charts are absent over the value
disk in `G_m`, and every remaining exterior chart has `L` as a product
coordinate.  A regular refinement can moreover be chosen relative to the
compact-`y`, `t=0`, `g/1` subcomplex, so its direct proper map is an
isomorphism on the original graph, including the retained divisors `U=0` and
`V=0`.

This is an exterior statement.  It does not replace the protected `(1,1)`
whole-fibre ratio theorem, and it makes no collar, Gamma, or common-fan claim.

## 1. The all-logarithmic certificate

The six formerly ordinary exterior pivots are replaced as follows.  Here the
displayed `b` and `c` are residue-torus units in the named chart, and `U` or
`V` is already a unit wherever it occurs.

| ordered type and mask | logarithmic field | initial unit |
| --- | --- | --- |
| `(g,1),012345` | `dlog_c` | `cU` |
| `(0,1),012345` | `dlog_c` | `c` |
| `(1,g),012345` | `dlog_b` | `bV` |
| `(1,0),012345` | `dlog_b` | `b` |
| `(1,infinity)`, a mask containing `R` | `dlog_b` | `-bc` |
| `(infinity,1)`, a mask containing `R` | `dlog_c` | `-bc` |

For example, the fifth line is `b partial_b H=-bc`, not the former
`partial_b H=-c`.  The rest of the exterior unit table already used a
logarithmic `x_i`, `b`, or `c` field.  The protected `(1,1)` entries are
deliberately not changed: they are not exterior witnesses.

The updated deterministic replay
`2026-08-12-c907-l-mask-coarse-polar.py` recomputes all 81,367 `t=1` support
cells and now refuses any nonlogarithmic exterior unit pivot.  Its canonical
certificate has exactly 72 exterior records: 70 logarithmic unit records and
two `L=0` records.  It retains the two `(1,1)` records as protected.

Reproduce from the repository root:

```sh
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-l-mask-coarse-polar.py --check
```

The independent JSON invariant used for this update checks the partition
`72 = 70 + 2`, that every unit pivot begins `dlog_`, and that none contains
`partial_`.  The `.sha256` manifest covers the generator and canonical JSON.
This finite certificate only classifies the supported positive-order masks; it
does not by itself prove a scheme-chart statement.

## 2. Logarithmic chart lemma

Let `Sigma` be a regular integral refinement of the supported marked
pair-of-pants tropical complex, and let `E` be the direct strict closure of
the original graph.  At a flag face `F`, the completed *ambient marked
toroidal chart* splits into exceptional monomials and residue-torus
characters:

\[
 \widehat{\mathcal O}_{F}
 = k[\rho_1^{\pm1},\ldots,\rho_q^{\pm1}]
   [[z_1,\ldots,z_r]] . \tag{1}
\]

The marked `b,c,x_i` in a certificate record are among the `rho_j`.  Indeed,
for a unimodular cone its ray lattice is a direct summand, so each residue
cocharacter lifts integrally.  The resulting field
`D_rho=rho partial_rho` is regular on (1), fixes every `z_i`, and is tangent
to every union of actual boundary components.  In particular it fixes the
monomial `delta` and preserves the weight filtration.  The marked-line maps
are compatible with this statement: at a type-`1` face, for example,

\[
 B=1-\epsilon_Bb,\qquad U=\epsilon_Bb,
\]

so `b partial_b` is regular and tangent even though `partial_B` is not.

The direct-chart special fibre is the full initial scheme: filtered Koszul
strictness identifies it with the three initial equations, not merely a
quotient by a selected strict-transform equation.  Thus for any of the 70
certificate records, `D(in_w h)` is the displayed residue unit.  The filtered
tangent lemma applies to (1), so `D h` is a unit in the actual strict graph
chart.  On `L-h=0`, this makes `dL` surjective on the actual coarse stratum.

Forgetting the auxiliary conditions `B=1` and `C=1` causes no loss here.
The fields preserve all genuine exceptional and horizontal divisor ideals;
they are only required locally on the residue-unit open containing the point.
Where a residue unit becomes zero or infinity, that point belongs to a
different flag face and receives its own certified record.  Hence the unit
Fitting minor is local on the *coarse* stratum, not a falsely base-changed
fine-face calculation.

The field is tangent to the actual boundary and has unit `L` derivative, so
the holomorphic constant-rank/flow argument supplies a local `L`-product of
the extension-by-zero pair.  This is the stronger local statement needed for
`j_!`-local acyclicity, not just an empty critical Fitting ideal.

## 3. Coverage of all direct exterior faces

There are three disjoint cases.

1. Every proper horizontal Newton face omits `L`, by the strict-convex-hull
   horizontal lemma.  Its graph is a product with the `L` line, and a
   factorwise regular refinement keeps that coordinate free.
2. At positive parameter order, the full-initial theorem applies on every
   supported cell and every face.  If `L` is absent from the full mask, it is
   again a product coordinate.  If the mask is `{L}`, the strict boundary
   equation is `L=0`, hence the chart has no point over the chosen value disk
   in `G_m`.  The 70 remaining nonprotected masks are precisely the records
   of Section 1 and are controlled by Section 2.
3. A noncompact-`y` double-marked face is already free in `L` by positive
   normalization; the remaining compact double-marked type is `(1,1)` and is
   excluded from the exterior assertion.

Subdividing a supported cone does not create an unlisted case: the new cone
lies in one certified support cell, and a new face is a face of its full
initial.  The filtered-Koszul theorem supplies the exact scheme initial for
that cell, while the certificate includes all realized faces.  Therefore the
direct exterior bad-image lemma in
`2026-08-13-c907-proper-support-fibrewise-table.md` is now unconditional:

\[
 \pi_{\rm ext}(B_{\rm ext})\subset
 T_{11}=\{\delta=0,B=C=1,y\in T_y,L\in\overline\Omega\}. \tag{2}
\]

## 4. Keeping the original open unchanged

There is one necessary choice in the regular refinement.  Let `K_0` be the
compact-`y`, `t=0` marked-line subcomplex with both ordered types in
`{g,1}`.  In the six-weight convention of the tripod replay, on this
subcomplex

\[
 (w_0,w_1,w_2,w_3,w_4,w_5)
 =(0,0,0,0,0,-s_B\beta-s_C\gamma),
 \qquad s_g=0,\ s_1=1. \tag{3}
\]

Thus the first five weights agree identically; `R` is strictly lower away
from the `(g,g)` zero face and agrees there as well.  No graph equality wall
cuts the relative interior of a cone of `K_0`.  Those cones are products of
coordinate tripod cones and are unimodular.

Choose the standard toroidal desingularization *relative to the regular
subcomplex* `K_0`: first take the supported graph/Rees common refinement and
then star-subdivide only cones outside `K_0`.  Relative toric resolution keeps
a regular subfan fixed, so no ray is introduced inside a cone of `K_0`.  The
Rees modification is also trivial there because `t=0` makes `delta` a unit.
Consequently the induced proper direct map is the identity over the original
compact-`y`, parameter-unit open, including the type-`1` loci
`U=0` and `V=0`.  This is the required statement

\[
 \pi_{\rm ext}^{-1}(G^\circ)=G^\circ, \tag{4}
\]

with the translated divisors retained rather than inadvertently deleted by
the very-affine calculation.  The common-ambient strict-closure lemma then
extends (4) to the direct map `pi_ext:E -> X_0` used in the proper-support
table.

## 5. Exact scope after this repair

The exterior branch no longer needs an ordinary-derivative/Kummer-descent
claim or an unenumerated strict-transform attachment.  The protected `(1,1)`
proper ratio fibre is separately covered by its bounded and imbalanced charts,
leaving exactly the four Morse sections.  Combining that whole-fibre theorem
with (2) gives
the proper-support cover, but Whitney--Thom collar topology and the
tame compact-support-to-rapid-decay comparison remain later analytic gates.

## EJ/TT and mystery ledger

- **EJ:** logarithmic rather than ordinary residue pivots make the exterior
  proof intrinsic to every direct unimodular chart.
- **TT:** the only potential false positive was to infer fixed-value control
  from total graph smoothness.  The unit field above is relative to `delta`
  and survives the actual-boundary coarsening, so it is the required extra
  datum.
- **Settled:** all 70 exterior unit charts, both excluded `L=0` charts,
  horizontal/noncompact free charts, and preservation of the original open.
- **Open:** protected whole-fibre assembly and the subsequent topological
  comparison; no genuine mystery remains inside the exterior descent.
