# Relconic live-frontier session archive

**Lane**: `relconic`

**Status**: append-only session index.  This file records substantial active-
frontier landings and points to their dated research reports.  It is not the
proof authority and must not grow copies of long derivations.  The live map is
`2026-07-17-c210.md`; closed pre-2026-08-15 programs remain in
`done/2026-07-17-c210-archive.md`.

## How to use this archive

- Start a session from `2026-07-17-c210.md`, not this file.
- Follow a dated report only when its branch is selected by the live map.
- Append one compact entry after a substantial session: outcome, exact scope,
  remaining gate, commits, and report/artifact links.
- Corrections replace the claim in the live map and append a correction here;
  do not rewrite older entries.

## 2026-08-22 to 2026-08-25 — inherited sharp lower bound

C945 and C970 established the field-uniform lower-bound side for complete
`(2q/3+1)`-arcs:

```text
t_(2q/3+1)(2,q) >= q^2/3+5q/3-o(q).
```

The centered shell forces at least three line-code generators and the signed
norm/cap estimate forces displacement at least `q/3-o(q)`.  This is the
current proved asymptotic lower bound, not a matching construction.

Reports and artifacts:

- `notes/2026-08-22-c945-higher-arc-defect.md`
- `notes/2026-08-25-c970-integral-secants-25-18-upgrade.md`
- `notes/2026-08-25-c949-sharp-linear-coefficient-audit.json`
- `papers/integral_secant_arcs/`

## 2026-08-24 to 2026-08-25 — C949 inverse reduction

C949 eliminated the exact `5/3` endpoint for sufficiently large ternary
fields and reduced sublinear repair to nine structural signatures: seven
concurrent rows and triangular `(4,-3),(5,-1)`.  Bruen--Fisher supplies the
adjacent signed core but its overloaded pencils force linear repair, so it is
not a near-sharp mechanism.

The concurrent branch became a two-permutation Rédei problem.  Its seven
infinity signatures compress to three affine ghost types `m_0 in {1,4,7}`.
The first uncontrolled forbidden coefficient is
`E_(q+4)=Phi_dir Q_3`; low/high Newton reciprocity does not kill its cubic
quotient.  This is a proved method boundary, not a classification.

The triangular `(4,-3)` branch became the balanced carrier problem with four
special directions, Witt carries, reciprocal norms, a four-partite incidence
system, and the top-coefficient package `SR24-WittK`.  The `(5,-1)` branch is
different: even `eta=o(q)` requires a linear high-secant trade and is not
covered by the exact balanced carrier lemma.

Primary snapshot:

- `notes/2026-08-24-c949-sharp-higher-arc-asymptotics.md`

Representative foundation commits:

- `379aba899` — inverse branch to free blocking arrangement
- `d6677dcf1` — eliminate balanced carrier nullity
- `b978cdb2b` — structural sharpness advance

## 2026-08-25 to 2026-08-26 — finite carrier compiler and symbolic target

C962 supplied the finite `q=27` carrier interface.  All 714 fixed-mapping
tasks retain affine rank 102; useful compression is nonlinear/high-incidence.
A high cell gives a cofactor-free linear equation in 18 carrier coefficients.
Eight double-high rows determine the carrier; seven leave at most a
one-dimensional Möbius defect, so a terminal has normally one carrier and at
most 27 in the exceptional case.

The intended computation is a high-incidence DFS with rollback linear bases,
immediate inconsistency rejection, bounded Möbius terminals, fourth-Witt/
reciprocal-norm/mapping gates, and canonical minimal rejection cores.  The
field-uniform objective is not merely `q=27` rejection: classify the 714
cores under symmetry and extract a bounded symbolic cross-ratio/Möbius
certificate valid for `q=3^h`.

The C962 implementation later gained parallel search in its owning work, but
the parallel balanced-DFS path was not present in this checkout at the C949
closeout and therefore was not reviewed here.

Reports and private implementation context:

- `notes/2026-08-25-c962-application-opportunities-memo.md`
- `notes/2026-08-25-c962-recovery-algorithms-and-bounds.md`
- `papers/complete-repair-ports/algorithms/` (private; never publish)

## 2026-08-26 — carrier/conductor compression and no-go boundary

The dual high-line arrangement has `2q+4` rational lines with
`t_2=3q-3`, `t_3=3`, and `t_4=q(q+2)/3`.  Every local joining-line product
has the uniform residue

```text
Delta_P=R_P^3(PV_X)(PV_Y)(PV_Z),   deg R_P=2q/3.
```

Branchwise roots glue exactly when a degree-`2q/3` plane form passes through
the quadruple set.  The conductor conditions are explicit: value matching at
double nodes; two values and one first jet at triple nodes; and two first-jet
plus one second-jet conditions at quadruple nodes after zero values.  A
solution saturates Bezout and is a strong high-degree complete-intersection
carrier.

Several tempting shortcuts were closed:

- all finite pointwise torus jets are Koszul-formal and yield no new local
  invariant;
- cubing loses precisely the conductor data needed to descend roots;
- Saito/Yoshinaga freeness is universal for rational covering arrangements
  and does not produce the carrier;
- Segre-pencil propagation is a tautological sign cocycle;
- a scalar low-node cocycle cannot see first/second jets at quadruple nodes.

If a global mechanism forces a degree-at-most-four carrier, the quartic
blocking argument excludes it for `q>=81`, including geometrically reducible
quartics.  That remains conditional and covers only triangular `(4,-3)`.

Primary snapshot:

- `notes/2026-08-24-c949-sharp-higher-arc-asymptotics.md`

## 2026-08-26 — Mason stability upgraded to a quantitative gap

For a near-sharp complement `B`, put `r=q/3`, compare with any Mason large
root `S`, and write

```text
P=B\S,  N=S\B,  |P|=q-3+e.
```

Mason's `2q-2` `r`-secants partition `S`.  Deficient partition blocks create
orphaned surviving points; minimality forces their essential `r`-secants to
be converted old `2r`-secants.  Pair counting and inclusion--exclusion bound
the converted lines, while four-block incidence bounds the deficient blocks.
The resulting field-uniform theorem is

```text
eta=o(q) => e>=q^(3/2)/104 eventually,
             |B triangle S|=Omega(q^(3/2)).
```

This holds across all nine SR11 signatures but is Mason-relative: it does not
classify arbitrary minimal `r`-fold blockers.

The exponent-loss object is the Mason concurrence hypergraph on `2q-2`
`r`-secants.  It is regular, four-uniform, and linear; its pair leave is three
perfect matchings.  For `U` deficient blocks,

```text
binom(|U|,2)=e_leave(U)+6F_4(U)+3F_3(U)+F_2(U).
```

Generic design data cannot improve the quadratic full-block bound.  An
explicit four-group affine-design family has the same parameter relations
and a quadratic induced subdesign, while deleting one vertex from Mason
itself leaves dense full blocks but creates many partial triples.  Any
improvement must use Mason-specific coordinates/additive structure in the
small-set regime `|U|=o(q)`.

Commit chain:

- `d0490206f`, `85a6e62ec`, `6bc57572d` — initial stability gaps
- `959c990d7`, `cada29be1` — exclude linear switches and prove the
  `q^(3/2)` scale
- `87396e58c` — conservative constant `1/104`
- `6a963b868`, `9c9a65371`, `6900e024d`, `13a10d6f2` — concurrence
  hypergraph, generic no-go, and normalized induced-block defect

## 2026-08-26 — TT closeout and corrected frontier

The strongest unifying observation is that both the balanced SR11 core and
the Mason comparison produce a near-Steiner `3/4`-block geometry with a
three-matching pair leave.  The next theorem should target this shared
structure rather than treat all branches independently.

Highest-EV frontier:

1. Prove a robust defect dichotomy: either the embedded block system
   linearizes/Masonizes within `o(q^(3/2))`, or accumulated pair-completion
   defect forces `eta>=c q`.
2. In the Mason small-set regime, `|U|~sqrt(q)` and `F_4(U)~|U|^2`, so the
   additive energy is genuinely high.  Parameterize `r`-secants by their
   zero-triangle intersections and apply a BSG/Freiman or cross-ratio inverse
   theorem.  The earlier global BSG attempt had insufficient energy; this
   localized one does not.
3. Treat the carrier as a generalized-Picard/conductor obstruction and use
   canonical `q=27` rejection cores to guess a bounded left-kernel or
   cross-ratio certificate.
4. Do not assume Mason attraction from scalar moments.  The exact missing
   mixed correlation is
   `q|B intersect S|=sum_ell |B intersect ell||S intersect ell|-|B||S|`.
5. A full theorem still needs the concurrent split-permutation coupling, the
   triangular `(5,-1)` global trade, or one robust inverse theorem that
   subsumes both, plus the matching sharpness/construction side.

The honest closeout estimate was roughly 60% of the full C949 program:
structural reduction is substantially further along than the actual sharp
asymptotic closeout.

Primary authority:

- `notes/2026-08-24-c949-sharp-higher-arc-asymptotics.md`

Final session commits:

- `0e93feb41` — isolate the missing Mason-attraction/mixed-correlation theorem
- `03abc4d38` — relax the sufficient attraction scale to `o(q^(3/2))`
- `9c9a65371`, `6900e024d`, `13a10d6f2` — red-team the hypergraph frontier

## Preserved closed-program literature boundary

For a fixed relative-conic parameter specialization, prefer normalization
plus Hasse--Weil with an explicit genus bound.  The historical sources are
H. Stichtenoth, *Algebraic Function Fields and Codes*, second edition,
Proposition 3.7.8 for Artin--Schreier ramification/genus and Theorem 5.2.3 for
Hasse--Weil, DOI `10.1007/978-3-540-76878-4`.  Use Aubry--Perret, *A Weil
theorem for singular curves*, DOI `10.1515/9783110811056.1`, only for direct
point counts on a singular projective model rather than its normalization.

Do not invoke Lang--Weil as a bare label: record the constant field, absolute
irreducibility, genus/degree, removed points, and the resulting extension
threshold.  The full geometric baseline remains in
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`.

## 2026-08-26 — startup and card compression

The live relconic handoff had grown to 789 lines by duplicating C949's dated
proof report.  It was replaced by a 195-line routing map containing only the
current theorem state, five ordered frontiers, source routing, other live
cards, and ownership.  This append-only file now owns session summaries and
links; the dated C949 report remains the detailed authority.  The C949 queue
row was reduced from a historical card dump to a short index entry pointing
at the live map, proof report, and this archive.

Exact prior handoff prose remains recoverable from Git history; it was not
copied here because that would recreate the startup problem this split fixes.

## 2026-08-26 — converted-line dichotomy and Mason torus model

The Mason-relative quantitative theorem was sharpened.  For deficient old
`r=q/3` blocks `U`, off-triangle additions give the pair-incidence inequality

```text
q+e+f-8-eta <= binom(|U|,2)+3|U|.
```

If at most `r` former `2r`-secants become tight, union and orphan capacity
force `e=Omega(q^2)`.  If more than `r` become tight, deleted-point pair
counting gives `|N|>r sqrt(r-1)` and hence

```text
e >= (1/(3sqrt(3))-o(1))q^(3/2).
```

This supersedes the earlier constant `1/104` and invalidates the routing
heuristic that the decisive object must have `|U|~sqrt(q)`.  The live
frontier now targets near-Steiner stability of the more than `q/3` converted
lines.

An exact Mason coordinate interface was also extracted without assuming an
unavailable formula for Mason's construction.  After normalizing the zero
triangle, the dual `r`-secants are two permutation graphs on the torus,
`{(a,f_0(a)),(a,f_1(a))}`, and each of `a,b,a/b` is two-to-one.  Fourfold
concurrences are four-point intersections with noncoordinate affine lines.
The consulted Csajbok--Weiner source authenticates Mason's incidence
parameters but does not provide formulas for the permutations; additive
rigidity remains a new theorem, not imported structure.

### Immediate TT/EJ upgrade

The `q^(3/2)` statement above was itself superseded in the same session.
For `m` converted lines, the exact projective identity

```text
sum_X d_X^2=m(q+m)
```

and Cauchy--Schwarz give `|N|>=m r^2/(q+m)`, so `m>r` already forces
`e>=q^2/36-O(q)`.  When `m<=r`, the new pair-incidence inequality, union,
and orphan capacity force a positive quadratic constant.  Optimizing their
limiting ledger gives

```text
liminf e/q^2 >= c_*=0.0171413259... > 1/60,
216sqrt(c_*)^3-72c_*+21sqrt(c_*)-2=0.
```

Thus the durable conclusion is quadratic separation from every Mason root;
the intervening `q^(3/2)` bound is retained here only as the chronological
route by which the stronger second-moment argument was found.

## 2026-08-26 — balanced Redei rank-one/cubic certificate

The balanced `(4,-3)`, `eta=1` blocker selection has exact tight-degree
counts

```text
(b_1,b_2,b_3,b_4)=(2q(q-4)/3,2q,0,0).
```

Its `2q` double-tight points form a graph on the `2q+4` tight lines with
degree sequence `1^9 2^(2q-6) 3^1`; the remaining blocker points are private.
This makes the `O(q)` partition defect explicit, but also shows why a direct
six-line Mason repair is not forced by the moment ledger.

For the dual minimal blocking `(2q+4,4)`-arc, define at an external point
`V` the cube-free pencil defect `b(V)=a_2(V)+2a_3(V)`.  It is a nonnegative
multiple of three, and its sum along the external points of any tangent is
`3q`.  Hence either every tangent meets a zero-defect point, in which case
there are at least `q-3` such points globally, or there is a clean tangent on
which every finite slope has defect three.

In the clean branch, global Redei division and differentiation turn the
degree-three cube-free slope residues into proportional coefficient vectors.
Total-degree interpolation leaves only

```text
Delta_j=0 (j>=2),
Delta_1=c(M^q-M),
Delta_0=(M^q-M)C_3(M), deg C_3<=3.
```

This is an exact field-uniform rank-one/cubic defect certificate.  It is not
yet a Mobius certificate because the top ratio has degree bounds `(2,1)`;
the possible quadratic coefficient remains to be killed.  The complementary
dirty branch and this residual cubic are now the two arrangement-level
frontiers.

The immediate projective-infinity shortcut was red-teamed and rejected.  At
the omitted tangent direction, `D_aff` has `r-3` or `r-2` empty intercept
fibers.  Completing them raises the quotient degree to `4r` or `4r+1`.
Moreover the clean certificate's top pair is exactly the first two affine
elementary moments, which the local fiber multiplicities do not determine.
Thus the tangent-at-infinity profile cannot force the constant `c` to vanish
or reduce the residual cubic without an additional bivariate identity.

### Dirty branch eliminated by norm saturation

The clean/dirty dichotomy collapsed further.  Weight every `D`-bisecant by
one and every trisecant by two.  Unique projective line intersections give
an exact second moment for the resulting point degrees `b(X)`.  After
subtracting the points of `D`,

```text
sum_(X notin D)(b(X)/3-1)^2=q^2/3.
```

The three zero-triangle vertices have `q-1` bisecants and two trisecants
through each, so each contributes `(q/3)^2`; together they exhaust the norm.
Every other external point therefore has `b=3`.  There are no zero-defect
points, every tangent is clean, and the rank-one/cubic Redei certificate is
unconditional.  The remaining balanced obstruction is only the possible
quadratic top coefficient and residual cubic, not a second dirty geometry.

### Exact nine-coefficient Redei remainder

Norm saturation also determines the low-line geometry itself.  Inverting the
projective incidence matrix shows that the bisecant indicator plus twice the
trisecant indicator is exactly the sum of the three zero-triangle pencil
indicators.  Hence the three connector lines are precisely the trisecants and
all other lines in those pencils are bisecants.

Writing `B_0(X,M)` for the moving cubic through the three pencil vertices,
global monic division and field-fibre interpolation give

```text
Q(X,M)=B_0(X,M)C_0(X^3,M)+(M^q-M)E(X,M),
deg_X E<3, deg E<=3.
```

Thus all field-size ambiguity is confined to nine coefficients of one cubic.
Two independent audits checked the incidence inversion, connector
multiplicities, filtered degree bounds, and cube-coefficient interpolation.
The identity does not yet kill `E`; the remaining target is to couple it to
the split point product, reciprocal chart, fourth-Witt, and mapping gates.

The immediate reciprocal audit isolates, but does not eliminate, three of
the nine coefficients.  Under `N=M^(-1),Y=-X/M`, the transformed identity has
remainder `(N^(q-1)-1)E_tilde`; it becomes the standard
`(N^q-N)E_rec` form iff the three homogeneous-cubic coefficients
`e_03,e_12,e_21` vanish.  The reciprocal cubic is a transform of `E`, not a
second independent cubic, so its apparent `9+9` match with C962's 18
degree-eight carrier coefficients is only numerical.

The red-team boundary is exact: adding `(M^q-M)E'` preserves every finite
directional fiber.  The values of `E` are the transverse derivatives of `Q`
along the three moving low-pencil roots.  Therefore only a globally split
point-product identity, a reciprocal norm before field specialization, or a
Witt lift that computes those derivatives can close the branch.
