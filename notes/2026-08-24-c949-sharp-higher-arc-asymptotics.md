# C949 live frontier — sharp asymptotics for complete higher arcs

**Lane:** `relconic`

**Date:** 2026-08-26

> **START HERE FOR C949.** This is the live task card and routing document.
> Do not preload the proof snapshot or archive. Read only the focused source
> named by the selected frontier below.

## Goal and honest status

For `q=3^h`, determine the sharp asymptotics of the minimum size of a complete
`(2q/3+1)`-arc in `PG(2,q)`.

Established:

```text
t_(2q/3+1)(2,q) >= q^2/3+5q/3-o(q),
```

and the exact `5/3` endpoint is absent for all sufficiently large ternary
fields.  A matching near-base construction and classification of all
near-extremizers remain open.

Current honest completion estimate: about **75% of the structural program**,
but materially less than 75% of a finished asymptotic theorem because the
remaining steps are a matching construction and the global inverse/stability
classification.

## Read routing

- Detailed theorem statements and derivations through 2026-08-26:
  `notes/2026-08-26-c949-structural-proof-snapshot.md`.
- Focused bounded transverse-core proof:
  `notes/2026-08-26-c949-redei-transverse-core.md`.
- Minimal-blocker variance and Mason-attraction boundary:
  `notes/2026-08-26-c949-minimal-blocker-variance.md`.
- Chronological session log and links to focused snapshots:
  `notes/2026-08-24-c949-sharp-higher-arc-asymptotics-archive.md`.
- C962 finite-carrier application memo:
  `notes/2026-08-25-c962-application-opportunities-memo.md`.
- C962 recovery/algorithm bounds:
  `notes/2026-08-25-c962-recovery-algorithms-and-bounds.md`.

Load the long proof snapshot only by theorem label.  The labels most relevant
to the live frontiers are listed below.

## Landed theorem state

### 1. Nine-signature inverse reduction

Every hypothetical sublinear repair reduces to nine SR11 signatures:

- seven concurrent rows, compressed to ghost types `m_0 in {1,4,7}`;
- triangular `(4,-3)`, the balanced carrier branch;
- triangular `(5,-1)`, which necessarily carries a linear high-secant trade.

The concurrent branch has a two-permutation Redei normal form.  Its first
uncontrolled forbidden coefficient is

```text
E_(q+4)=Phi_dir Q_3,
```

where `Q_3` is a projective cubic.  Ordinary Newton reciprocity does not
determine it.

### 1a. Capacity-safe augmentation boundary

The non-tight line variance gives at most `10-j` fragile `(r+1)` lines and
all but `O(1)` tight lines contain linearly many safe degree-one blocker
donors.  Exchanging a typical degree-four arc point with four
capacity-compatible donors preserves completeness and raises the arc size
by three.  This is a valid replacement move, but it runs in the wrong
direction for `t_n(2,q)`, which minimizes the size of a complete arc.  It
does not turn the known lower bound into a construction upper bound and does
not normalize a candidate near-minimizer downward.  See `(MV6)--(MV9)` in
the focused variance note.

The exact reverse move would lower repair by three, but it needs a safe
blocker point of tight degree four and four arc-labeled degree-one donors.
The balanced `(4,-3)` arm is automatically reverse-free at `eta=1,2`: at
`eta=1` it has `b_4=0`, and at `eta=2` there is at most one such center and
at most one degree-one donor.  This closes the switch route for the main
constant-repair branch.

### 2. Mason-relative quadratic separation

Let `B` be a near-sharp minimal `q/3`-fold blocking complement and `S` any
Mason generalized-KM large root.  If `|B\S|=q-3+e`, then

```text
liminf e/q^2 >= c_*=0.0171413259... > 1/60,
|B triangle S| >= (2c_*-o(1))q^2,
```

where `c_*=x_*^2` and

```text
216x_*^3-72x_*^2+21x_*-2=0.
```

Key labels:

```text
(SR24a-Mason-U-pairs)
(SR24a-Mason-quantitative-gap)
(SR24a-Mason-mixed)
```

This rules out every subquadratic Mason switch, across all nine signatures.
It does **not** prove that an arbitrary near-sharp blocker is close to any
Mason root.  That missing mixed-correlation theorem would itself be a major
global classification input.

It also closes the tempting Mason-completion construction.  If
`K_0=PG(2,q)\(S union L_3)` is the canonical Mason complement, then for any
near-base target `A`

```text
|A triangle K_0| >= (2c_*-o(1))q^2-(q+1).
```

Consequently both directions of the exchange are `Omega(q^2)`.  No greedy
completion, bounded repair, or `O(q)` chain of local switches can construct
the missing near-sharp family from `K_0`; a Mason-seeded construction would
have to be a genuinely quadratic global trade.

### 3. Balanced blocking geometry

The balanced `(4,-3), eta=1` branch dualizes to a minimal blocking
`(2q+4,4)`-arc `D` with exact secant spectrum

```text
t_1=(2q^2-8q+3)/3,  t_2=3q-3,
t_3=3,              t_4=q(q+2)/3.
```

Its high-line arrangement has only double, triple, and quadruple points.
The arc/blocker selector is not determined by that unweighted spectrum.  In
the exact balanced `eta=1` labeling, the blocker degree split is

```text
(b_1,b_2,b_3,b_4)=(2q(q-4)/3,2q,0,0).
```

Local jets, scalar cocycles, freeness/Saito, and automatic cube-root gluing
are all proved no-go routes.  A quartic carrier would contradict blocking for
`q>=81`, but no quartic-carrier implication is proved.

### 4. Exact low-pencil and bounded Redei certificate

Let `V_1,V_2,V_3` be the zero-triangle vertices.  Weight each `D`-bisecant by
one and each trisecant by two.  Exact second-moment saturation and incidence
inversion prove

```text
1_(2-secants)+2 1_(3-secants)
 =sum_(i=1)^3 1_(pencil(V_i)).              (SR24a-low-pencils)
```

Thus the three connector lines are precisely the trisecants and every other
line in those pencils is a bisecant.  Every tangent is clean.

In any tangent chart, with

```text
B_0(X,M)=product_(i=1)^3(X-b_i+Ma_i),
```

the global quotient has the exact field-uniform form

```text
Q(X,M)=B_0(X,M)C_0(X^3,M)+(M^q-M)E(X,M),
deg_X E<3,  deg E<=3.                       (SR24a-Redei-cubic)
```

All failure of the field fibers to assemble into the displayed global cube
channel is therefore confined to the **nine coefficients** of one cubic
`E`; the large cube quotient `C_0` itself remains q-scale.

The split-product companion quotient compresses further.  If
`R=(X^q-X)Q+(M^q-M)H`, canonical division of `H` by `B_0`, followed by the
three connector interpolations, gives

```text
H=B_0D+P_good I_E+(M^q-M)U,
deg_X U<3, deg U<=3.
```

Hence the two canonical quotient remainders form a genuine bounded
**nine-plus-nine** state `(E,U)`.  See the focused transverse-core snapshot.

The reciprocal transition is exact.  In a tangent-point-adapted flag chart,
one may normalize

```text
V_1=(0,0), V_2=(1,0), V_3=(s,1),
B_0=X(X+M)(X-1+sM),  s notin {0,1}.
```

The standard reciprocal remainder exists iff the three homogeneous-cubic
coefficients vanish:

```text
e_03=e_12=e_21=0.                         (SR24a-Redei-recip-gate)
```

Finite directional fibers cannot see `E`: adding `(M^q-M)E'` preserves all
of them.  The values of `E` are exactly the transverse derivatives of `Q`
along the three moving low-pencil roots.  Hence the next proof must use a
pre-specialization split-product, reciprocal-norm, or Witt identity.

The selector has one further exact graph compression already proved in the
frozen snapshot.  Make a graph on the `2q+4` points of `D`, with one edge for
each bisecant.  At `eta=1` its nine exceptional vertices have degree one and
the other `2q-5` vertices degree three.  The unique selected tangent meets a
generic vertex `v_0`; the selected `A_2` bisecants form a perfect matching on
the `2q-6` other generic vertices and avoid both `v_0` and the exceptional
vertices.  Equivalently the complementary blocker graph has degree sequence

```text
1^9, 2^(2q-6), 3^1.
```

Thus the marked selector relative to `D` reduces to `(v_0, tangent,
perfect matching)`.  This is necessary, not sufficient: it does not yet
enforce Tutte feasibility, the fourfold/mapping gates, or identify the 714
q=27 carrier tasks.

The three side colours do not supply that matching automatically: each
colour restricts to a matching on the generic vertices with exactly three
generic defects.  After deleting `v_0`, feasibility is exactly Tutte's
odd-component condition on the remaining `2q-6` generic vertices.  The
current spectra control degrees but not odd cuts.

There is, however, an exact constant-defect theorem.  For a side colour
`c`, let `D_c` be its three generic vertices paired to exceptional vertices.
The colour is a perfect matching on `G\D_c`.  Marking any `v_0 in D_c`
leaves only the other two vertices of `D_c` unmatched, so the selector graph
after deleting `v_0` has matching deficiency at most two.  Every such
generic vertex supports a tangent marker.  The missing matching theorem is
therefore precisely a **two-monomer augmenting-path lemma** through the other
two colours.  This gives a cheap exact preprocessing gate for q=27 and a
clean field-uniform projective expansion target.

Pairwise alternating-path analysis compresses failure of a direct
two-colour augmentation to a bounded defect wiring: intersections among the
three 3-sets and three cross-colour bijections.  The third-colour chords
through the long paths remain q-scale, so this is a routing certificate, not
a full bounded selector.

### 5. q=27 finite carrier boundary

C962 supplies a 714-task high-incidence DFS interface.  Each high cell gives

```text
C(x)-yA(x)=-y^2
```

in the 18 coefficients of the degree-eight pair `(A,C)`.  Seven double-high
rows leave at most a one-dimensional fractional-linear defect; every
completed carrier has full rank 18.  The finite search is useful for
extracting bounded rejection cores, but no completed exhaustive rejection is
being claimed here.

The numerical resemblance between the nine coefficients of `E` and one half
of the 18-variable carrier is not structural: the reciprocal transform of
`E` is the same nine-dimensional object, not a second cubic.  A theorem
identifying those coordinates directly is still missing.  However the
focused transverse-core snapshot now gives an exact carrier-to-Chow product
`(TR14)--(TR16)`, so `(A,C)` determines `(Q,H,E,U,L)` algorithmically in both
the extendable and nonextendable branches.  The remaining gap is a bounded
coefficient extraction, not existence of a map.

## Live frontiers, in EV order

### EV1 — bounded transverse-derivative theorem

Relate or contradict the bounded pair `(E,U)`, preferably beginning with the
three reciprocal obstructions `e_03,e_12,e_21`, from one of:

1. the globally split point product before specialization;
2. the reciprocal norm as a polynomial identity that constrains the quartic
   two-tangent transition `L` from `(TR12)`;
3. a Witt lift that evaluates
   `(partial_M-a_i partial_X)Q` on the moving pencil root;
4. a bounded symbolic rejection core extracted from the q=27 gates.

The carrier-to-point-product map is explicit in `(TR14)--(TR16)`.  The
leading tangent-direction layer now extracts `E_3` and `L_4` exactly, but
the original affine leading product is carrier-blind.  The highest-EV
calculation is therefore to transport the existing fourth-Witt top-carrier
coefficient through the actual tangent reflagging.  The required four
carrier coefficients are now located explicitly and linearly in the first
lower homogeneous Chow layer `(TR21)` and form a marked tail catalecticant
of a binary cube root `(TR23)--(TR24)`; `C` starts only one layer later.
An origin gauge cannot expose this normal polar, and every actual tangent
restriction mixes all normal layers as in `(TR25)`.
Moreover the current Chow/`(E,U)` state is unweighted: it omits the
arc/blocker selector and non-tight slack required by a downward trade.
The exact marked rational divisor does compress to the cube of the
degree-`q-2` tangent-plus-matching product, but `dlog` kills that cube in
characteristic three.  The next carrier bridge must therefore be a mixed
marked norm identity, not merely another unweighted coefficient extraction.

A second bounded certificate now exists in the connector-at-infinity chart:

```text
partial_X Q=A(X^3,M)+X P_reg(M)p(M).
```

The two vertex fibers prescribe its values at both vertex slopes.  Homogeneous
evaluation at the omitted vertical boundary forces `deg p<=2`, because its
fiber product `(Y-s)C(Y)^3` has no `Y^(q+2)` coefficient.

The two free values are now explicit.  In either finite boundary direction,
with missing-root factor `A_b` and triple-root factor `C_b`,

```text
p(b)=-[X^2]quo(C_b^2,A_b)/P_reg(b).
```

Together with the two vertex values, these four values must lie on one
quadratic.  Equivalently their cubic Lagrange coefficient vanishes.  This is
the first overdetermining field-uniform quotient gate.  The sharpest current
target is to identify that scalar relation with a marked functional of
`(E,U)`, fourth Witt, or the mapping gate; the q-scale cube channels remain.

In its sharpest form, subtract the linear interpolant through the two vertex
values: both boundary quotients must then give the same coefficient of
`(M-v_1)(M-v_2)`.  Equivalently the affine point coordinates satisfy
`e_(q-1)(a)=0`; at q=27 this is the constant-time normalized filter
`e_26(a)=0`.  Transporting that filter into the 714 carrier gauges is now a
precise compiler task, not a search for an unspecified invariant.

Do not evaluate it on the original carrier top form: that chart's analogous
coefficient is `1`.  The full boundary reflag must mix lower Chow layers and
completion factors to produce zero.  This `1 -> 0` cancellation is a sharp
unit test for the missing carrier compiler, not a contradiction.

Repeating the calculation in all three bad boundary directions gives three
necessary `e_(q-1)=0` projection gates.  Equivalently the degree-`q-1`
binary form `Psi(alpha,beta)=e_(q-1)(alpha u+beta t)` is divisible by the
dual boundary-direction cubic.  More explicitly, for

```text
C_B(U,V,W)=product_(P in B_aff)(Uu_P+Vt_P+W),
```

one has `Psi=[W^(q+2)]C_B` and `B_R^vee divides Psi`.  At q=27 this extracts
the binary degree-26 form `[W^29]C_B` from the full 55-point affine core.
The carrier-to-Chow map `(TR14)--(TR16)` therefore makes this a valid cheap
post-terminal compiler gate once the mapping and boundary frame are resolved.
If starting from `Chow_D`, first remove its three known infinity factors;
raw carrier rows remain insufficient.  Independence from the existing gates
is not yet proved.

In the concrete `(TR16h)` variables the abstract affine Chow coordinates are
`(U,V,W_aff)=(M,-W,Z)`.  Thus the q=27 compiler extracts `[Z^29]`, as a
binary form in `(M,-W)`, after removing the infinity factors.  Extracting
`[W^29]` from `(TR16h)` is a different, unsupported coefficient.  The three
scalar recurrences below avoid this coordinate trap entirely.

The q=27 compiler need not construct that full product.  At each boundary
normal covector, the two carrier roots over `u` give an explicit quadratic
generating factor whose coefficients use only `A(u^3),C(u^3),w,u`; the three
axis points give three linears.  Multiplying 26 quadratics and three linears
only through `z^26` evaluates the required `e_26` directly.  Thus `(TR43)` is
an exact cheap post-terminal filter once the resolved mapping has been
converted to the `(TR13)` boundary frame.  Whether it rejects anything not
already rejected by fourth Witt, reciprocal norm, or mapping remains open.

The verdict is invariant under the existing **joint** semilinear quotient:
Frobenius transport cubes the three outputs and permutes their boundary
labels.  Hence one exact evaluation per 714 carrier--mapping representative
suffices; transporting the mapping without its carrier and boundary frame is
not allowed.

The whole binary form has the sharper normal form

```text
psi(m)=-1-P_reg(m)p(m),       deg p<=2.             (TR45)
```

It equals `-1` on every regular direction, `1` at both vertex directions,
and zero at the three boundary directions.  Homogeneously,
`hat psi+N^(q-1)=-N hat P_reg hat p`.  This gives a stronger post-terminal
quadratic-quotient check after the cheap three-root test.  It also proves
that this coefficient is blind to the 64 labelled residual patterns: all
regular directions have the same value.  Cross-slope propagation must use
a lower Chow/projection coefficient.

The next coefficient is now audited as well:

```text
e_(q-2)(b-Ma)=-[X^3]Q
             =d_m([X]G_m)^3       on regular slopes.  (TR46)
```

It vanishes at the two vertex slopes, but lies in the unrestricted q-scale
cube-sector of `Q`, not the bounded quadratic defect.  It is not determined
by the 64 missing-root labels and changes with the fixed intercept frame.
Thus “go one coefficient lower” is not itself a bounded solution: the new
input must relate each labelled missing polynomial to `G_m`, or control the
global cube-sector `B_0`.  Its degree nevertheless gives two exact compiler
checksums, the unweighted and slope-weighted sums of the regular scalars plus
the boundary/vertical quotient values `(TR46a)`.

Do not return to finite-fiber interpolation, the omitted tangent slope,
pointwise torus jets, scalar holonomy, or automatic cube-root gluing.

### EV2 — non-Mason marked-core construction

The balanced branch now has an exact sufficient construction mechanism.
Seek a `2q+4` dual blocking four-arc `D` with the local spectra above, mark a
generic tangent vertex `v_0`, and choose the required perfect matching of
the remaining generic bisecant graph.  Select the tangent, the `q-3`
matching bisecants, all three trisecants, and all `q(q+2)/3` four-secants.
The count is exactly

```text
1+(q-3)+3+q(q+2)/3=q^2/3+5q/3+1.
```

The local selector ledger makes every core point tight.  If the remaining
global off-core concurrency is at most `2q/3+1`, duality gives the desired
complete arc.  This is a rigorous conditional mechanism, not an existence
proof: neither the three-colour matching nor the torus fibers enforce that
last cap.  It is necessarily quadratic-far from every Mason seed.

The simplest non-Mason formula is now closed.  The inverse duplex
`b=a^(-1)` or `b=g a^(-1)` has an explicit valid three-cell transversal and
a raw marked matching, but that matching violates the colour cap.  More
fundamentally, a quadratic-character count produces four retained generic
lines plus one forced boundary line through a point for every ternary
`q>=27`.  Thus the whole inverse two-conic family fails the fourfold cap; a
viable duplex must be genuinely non-inverse.

The extendable branch is already known to require linear algebraic
complexity.  The carry-free moment ledger makes the completed duplex moments

```text
mu_i=sum_(t=1)^3 b_t^(q/3)a_t^i,   1<=i<=2q/3-2,
```

a rank-three Prony sequence with no `000`, `00100`, or `001010` pattern.
Therefore at least `q/3-2` of these moments are nonzero; intrinsically, the
two-permutation trace has multiplicative Fourier support at least `q/3-2`
and interpolation degree at least `q-8` in every torus chart.  In particular
all bounded-degree and two-monomial duplex families are excluded for
`q>=27`.  See `(SR24d)--(SR24j)`.  A successful formula must be genuinely
nonlinear in all three charts, not merely a different low-degree ansatz.

At the same time `(SR23)` leaves only a bounded residual in every ordinary
direction.  If `z_m<=6` intercepts are missing, the Redei remainder is the
occupied-root product times a polynomial of degree at most `z_m-1<=5`.
Globally, the collision ledger has only `O(q)` total defect from the
ones-plus-fours packing maximum, despite `Theta(q^2)` high collisions.  The
construction frontier is therefore a sharp tension: linear Fourier
complexity in each chart, but degree-five directional residuals.  A
cross-direction synchronization theorem for those residuals is now the
highest-EV structural route.

The residual roots are not arbitrary: each missing-intercept polynomial is
a squarefree divisor of the fixed six-boundary intercept product.  Outside
15 collision directions this leaves only 64 labelled patterns, and every
boundary label occurs in `Omega(q)` ordinary directions.  The unresolved
quantity is their pairwise intersection geometry; individual label counts
and pigeonhole alone remain below the required interpolation threshold.

At q=27, use the Tutte test as preprocessing, then route surviving marked
cores into the parallel C962 carrier/mapping gates.  Field-uniformly, the
highest-EV construction theorem is an odd-cut plus off-core concurrency
bound for this embedded marked torus graph.

### EV3 — all-signature mixed-correlation inverse theorem

Prove that a near-sharp minimal `q/3`-fold blocker either has

```text
|B triangle S|=o(q^2)
```

for some Mason root `S`, contradicting the quadratic separation theorem, or
directly incurs `eta>=c q`.  Scalar line moments and essentiality alone have
formal countermodels and cannot establish this.

The exact variance reinterpretation `(MV1)` supplies a sharper starting
normal form: the `2q+O(1)` tight lines partition `B` and cover `A` fourfold
outside an `O(q)` weighted point defect.  The missing theorem is now an
embedded stability/classification theorem for that approximate design,
coupled to the three-line residue core.  Off that core every exceptional
degree costs nine units of the variance budget, but this alone still permits
`O(q)` exceptional pencils.

The embedded pencil identity `(MV4)--(MV5)` is exact, but a local relabeling
switch preserves the tight-line/residue ledger while exchanging high
degrees.  Therefore a pointwise cap must use non-tight-line slack or the
carrier/mapping equations, not further optimization of the same moments.
The non-tight variance `(MV6)--(MV9)` now supplies a first such input: there
are at most `10-j` fragile `(r+1)` lines, and all but `O(1)` tight lines have
at least `r/2` individually safe degree-one donors.  Every fixed-degree
exceptional pencil avoiding the bounded bad set admits a capacity-compatible
directed switch.  What remains is to turn those switches into a contradiction
or normal form at the target `eta`.

### EV4 — concurrent cubic coupling

Couple the projective cubic `Q_3` controlling the first forbidden concurrent
coefficient to the two permutation root factorizations.  Directional data
alone permits arbitrary `Phi_dir Q_3`; the missing input is splitness or an
offset-sensitive correlation.

### EV5 — triangular `(5,-1)` trade theorem

This signature has `Omega(q)` high-secant trade even when `eta=o(q)`.  It is
not governed by the constant-repair balanced carrier lemma and needs a
separate global trade obstruction or construction.

## Closed routes

- exact `5/3` endpoint;
- bounded/local Mason repair and every subquadratic Mason switch;
- Segre-pencil sign cocycle and cube-class propagation;
- local second/third/all finite torus jets;
- Saito/freeness alone;
- scalar cube-root gluing and scalar low-node cocycles;
- automatic quartic extraction from Bezout or Hilbert count;
- generic BSG/Freiman energy from the incidence ledger;
- treating the missing tangent direction as another clean fiber;
- identifying the reciprocal `E` as an independent second nine variables.

## Mystery ledger (`ej` + `tt`)

- **Settled:** the dirty tangent branch is impossible; the three
  zero-triangle vertices exhaust the weighted norm.
- **Settled:** the weighted low lines are exactly three pencils, not merely a
  matching-like count.
- **Settled:** both canonical Redei quotient defects compress to the bounded
  nine-plus-nine cubic state `(E,U)`.
- **Settled:** reciprocal conversion fails on exactly three homogeneous
  coefficients.
- **Settled/no-go:** finite slope fibers cannot constrain `E`; they are
  invariant under `Q -> Q+(M^q-M)E'`.
- **Settled/no-go:** two-tangent transpose gives an exact bounded quartic
  transition, but coordinate covariance alone absorbs `(E,U)` into its high
  quotient and supplies no self-relation.
- **Settled:** the leading tangent-direction Chow form extracts the three
  reciprocal obstructions and the quartic top layer exactly.
- **Settled/no-go:** the original affine leading carrier product is
  universal, so fourth Witt must enter through lower layers and tangent
  reflagging.
- **Settled:** the first lower Chow layer contains all coefficients of `A`
  lacunarily and linearly, including exactly the four used by fourth Witt.
- **Settled/no-go:** that fourth-Witt tail minor is flag-marked rather than
  projectively covariant; actual tangent restrictions mix every Chow layer.
- **Settled:** the minimal-blocker variance identity makes every SR11
  signature an `O(q)`-defect one/four tight-line design.
- **Settled/no-go:** capacity-safe four-donor switches are genuine, but they
  increase arc size and therefore do not improve the minimum-size
  construction sought by `t_n(2,q)`.
- **Settled/no-go:** the reverse switch is absent in the balanced
  `eta=1,2` arm, and unweighted Chow data omit the selector labels needed to
  detect it.
- **Settled:** at `eta=1` the marked low selector is exactly a generic
  vertex, its tangent, and a perfect matching of the remaining generic
  bisecant graph.
- **Settled/no-go:** the canonical inverse duplex has a valid transversal
  but a forced fivefold boundary concurrence for every ternary `q>=27`.
- **Settled:** every ordinary projection has a degree-at-most-five Redei
  residual, and their total collision-packing defect is only `O(q)`.
- **Settled:** the global affine quotient derivative has only a cubic
  noncube defect with at most two scalar freedoms after the vertex fibers.
- **Settled:** the vertical boundary forces `deg p<=2`; the two vertex and
  two finite-boundary values satisfy an explicit Lagrange compatibility.
- **Settled:** the same gate is `e_(q-1)(a)=0` in the boundary-normalized
  affine flag (`e_26(a)=0` at q=27).
- **Open:** determine whether this gate is independent of the existing
  fourth-Witt, reciprocal-norm, and mapping gates after carrier transport.
- **Settled:** all three boundary directions give such gates, packaged by a
  boundary-cubic divisibility of one binary elementary-symmetric form.
- **Settled:** the affine-core Chow coefficient `[W^(q+2)]C_B` is exactly
  that binary form, so the cyclic gate has a precise post-terminal compiler;
  the direction cubic must be dualized and the three infinity factors removed.
- **Settled/no-go:** under the `(TR16h)` variable names this is `[Z^(q+2)]`,
  not `[W^(q+2)]`; red-team caught the wrong-flag extraction before coding.
- **Settled:** a truncated univariate quadratic recurrence evaluates the
  three q=27 roots directly from a completed carrier and resolved mapping.
- **Settled:** the verdict is invariant on the 714 joint semilinear work
  orbits, so no unquotienting is needed.
- **Settled:** the full directional form has a quadratic quotient normal
  form and is constant on every regular direction.
- **Settled/no-go:** the cyclic gate cannot see which of the 64 labelled
  residual patterns occurs; residual synchronization needs a lower
  projection coefficient.
- **Settled/no-go:** the immediately lower coefficient does see detailed
  fibre data, but sits in the q-scale cube-sector and has no current map from
  the missing-label subset.
- **Open:** determine whether this compiler rejects any surviving q=27
  terminal independently of fourth Witt, reciprocal norm, and mapping.
- **Open:** synchronize those residuals across slopes; fiberwise boundedness
  alone does not give a common carrier.
- **Open:** prove or refute the corresponding geometric Tutte/odd-cut
  condition; after a suitable marking it is exactly a two-monomer
  augmenting-path problem, and side-colour degrees alone do not solve it.
- **Open:** compute the transverse pencil derivatives from split/Witt/norm
  data.
- **Open:** connect any resulting bounded identity to C962's `(A,C)` carrier
  variables without relying on the numerical `9+9=18` coincidence; the full
  product map and first-polar coefficient extraction exist, but no bounded
  transition to `(E,U,L)` is proved.
- **Open and global:** classify all nine inverse signatures or construct a
  matching near-sharp family.

## Next checkpoint

Implement the post-terminal `(TR43)` recurrence in the C962 normalization
and compare its rejection cores with fourth Witt, reciprocal norm, and
mapping, once per joint orbit.  On survivors, test the full `(TR45)`
quadratic quotient.  For the field-uniform residual frontier, prove a bridge
from the labelled missing polynomial `A_m` to the cube-sector `G_m` in
`(TR46)`; coefficient descent alone has now been exhausted.
In parallel, use the two-monomer matching gate and degree-five labelled
residuals as q=27 prefilters before the carrier DFS.  Field-uniformly, prove
cross-slope propagation for those residuals or construct a genuinely
non-inverse core satisfying the off-core cap.
