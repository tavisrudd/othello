# C485 — all-field redundancy-three reconstruction synthesis

**Lane:** `reed-solomon`

## Result

Let `F` be a finite field, let `V` be three-dimensional over `F`, and let

```text
A=(P(h_1),...,P(h_6)) subset P(V)
```

be a labelled six-arc.  Write `U(A)` for the projective points on no secant of `A`.  For
`u in U(A)`, projection from `u` gives six distinct points of `P(V/Fu)`, and its coherent
determinant atlas is exactly that labelled projected sextic in `M_0,6(F)` by C481.

The reconstruction theorem has two deliberately separate clauses.

> **All-field redundancy-three reconstruction theorem.**
>
> 1. **Pure coherent projections.**  Given four labelled projected sextics with one diagonal
>    labelling, assume the six-arc/deep conditions, a projective-frame chart, four independent
>    compatibility rows, and unique recovery of every camera.  Then the compatible parent-centre
>    configurations form exactly a Gale pair off the conic divisor and one ramified Gale-fixed
>    sheet on the conic divisor.  The reconstruction is separable of degree two off that divisor
>    in every characteristic.  Every further abstract coherent projection preserves the same
>    Gale pair; it cannot select a sheet.
> 2. **Complete-child-relative recovery.**  Retain the literal complete child `L=U(A)` and a
>    selected set `T subset L` of at most three centres.  The parent is recovered exactly when the
>    child-relative signature map
>    `Sigma_T` is injective on the finite fixed-child parent fibre.  Equivalently, intersect the
>    explicit two-view cubic surface or three-view cubic curve with the common ambient incidence
>    condition `U(A')=L`; recovery holds exactly when the resulting fibre is a singleton.  This is
>    a necessary-and-sufficient conditional clause, not a claim that two or three centres work
>    uniformly over all fields and children.  Unconditionally, if `q>=16`, the complete child
>    already determines the unlabelled six-arc, so no selected centre is needed.
> 3. **Semilinear descent.**  All constructions commute with coefficientwise Frobenius.  Off the
>    conic divisor the only geometric field obstruction is the `C2` Gale-sheet cocycle: a Kummer
>    square class in odd characteristic and an Artin--Schreier trace bit in characteristic two.
>    Connected gauge groups add no obstruction.  After diagonal unlabelling, a Frobenius
>    transporter is effective exactly when its sheet bit lies in the image of the common diagonal
>    stabilizer on the Gale pair.  On the conic divisor the sheets coincide and there is no sheet
>    obstruction.

The first clause reconstructs an unordered parent pair from abstract views.  The second uses
information absent from those views—the common ambient placement of the centres and the complete
child—to cut a residual family or select one member of a pair.  Neither clause invokes matching,
Gram, or Sylow-module structure.

## 1. Atlas input and exact normalization

Choose a volume form `omega in det(V)^*`.  Projection from `u` carries the alternating form

```text
beta_u(bar(x),bar(y))=omega(u,x,y)
```

and hence brackets

```text
d_ij(u)=omega(u,h_i,h_j)=beta_u(bar(h_i),bar(h_j)).      (1)
```

The centre is deep exactly when all fifteen brackets are nonzero.  Modulo

```text
x_ij -> lambda a_i a_j x_ij,
```

their Pluecker array is the labelled projected sextic.  The thirty balanced ratios separate these
torus orbits over `F`; no square-root choice is hidden in the atlas.  After sending the first three
projected points to `infinity,0,1`, the remaining coordinates are recovered directly by

```text
t_m=1+R^2_123m,                  m=4,5,6.               (2)
```

Thus every input atlas canonically supplies a normalized triple `(A_s,B_s,C_s)`, after a single
diagonal choice of the six labels across all views.  Independent relabelling of the views is a
strictly coarser functor and is not an input to the reconstruction theorem.

## 2. Canonical pure reconstruction algorithm

Normalize the parent by a projective frame:

```text
h1=(1,0,0), h2=(0,1,0), h3=(0,0,1), h4=(1,1,1),
h5=(1,a,b), h6=(1,c,d).                                (3)
```

For each view form the compatibility row

```text
m_s=(-B_s(A_s-1), -A_s(1-B_s), C_s(A_s-1), A_s(1-C_s),
      C_s(1-B_s), -B_s(1-C_s))                         (4)
```

on `z=(a,b,c,d,X,Y)^T`, where `X=bc` and `Y=ad`.  The row equation is exactly the eliminated camera
compatibility equation, not merely a necessary condition.  Let `M_r` contain the selected rows.

For four views with `rank(M_4)=4`, the following finite procedure is canonical after fixing the
ordered field representation and taking the first nonzero maximal minor.

1. Compute the projective kernel line of `M_4`.  It contains
   `e=(1,1,1,1,1,1)`; obtain a second vector `k` by Cramer's rule.
2. Put `z(s,t)=s e+t k` and

   ```text
   Q_k(s,t)=z_X z_a z_d-z_Y z_b z_c,
   q_k(s,t)=Q_k(s,t)/t.                                (5)
   ```

   The removed factor `t` is the universal collision `h5=h6=h4`; `q_k` is homogeneous quadratic.
3. For every retained root, rescale by `rho=z_X/(z_b z_c)`, recover `(a,b,c,d)`, and recover each
   camera parameter from

   ```text
   beta_s=(A_s-1+(1-B_s)b)/(B_s a-A_s),
   alpha_s=A_s(beta_s+1)-1,
   u_s=(beta_s,alpha_s,-alpha_s beta_s).                (6)
   ```

   Use the symmetric `C_s` formula when its denominator is the available one.
4. Reject a candidate unless all twenty parent triple determinants and every relevant
   centre-secant determinant are nonzero and direct reprojection returns all input sextics.
5. Return the surviving configurations in canonical projective normal form, either as a labelled
   list or after enumeration of the permitted diagonal permutations and Frobenius powers.

Changing the Cramer minor, kernel complement, frame chart, or quotient-line lifts changes only
coordinates on the same output orbit.  The algorithm solves one quadratic and no equation of
higher degree.

If one sheet is already known, the partner is given rationally by

```text
L0=bc+a+d-ad-b-c,
L1=abc+bcd+ad-abd-acd-bc,
z#=L1 e-L0 z,                                           (7)
```

followed by the same product rescaling.  This is Gale association and squares to the identity.

## 3. Discriminant and complete exceptional-fibre classification

On (3), the kernel cubic factors as

```text
Q(s e+t z)=s t(L0 s+L1 t),
Disc(q)=L1^2,                                           (8)
```

with the intrinsic identifications

```text
L0=-det(h4,h5,h6),
L1=det(v2(h1),...,v2(h6)).                              (9)
```

Therefore `L1=0` is exactly the conic locus.  On the six-arc locus the conic is nonsingular, and
this is the reduced ramification divisor in every characteristic.  In characteristic two,
separability is the nonvanishing of the middle coefficient `L1`, so (8) uses no division by two.
The equation `L0=0` is instead the boundary where `h4,h5,h6` are collinear; the putative partner
there is the universal collision.  If `L0=L1=0`, the whole kernel line is product-compatible, but
this positive-dimensional degeneration lies outside the six-arc locus.

All residual and exceptional fibres are accounted for by

```text
K_r=P(ker M_r),
F=x_X x_a x_d-x_Y x_b x_c,
R_r=K_r intersect V(F),                                (10)
```

with the collision removed and the arc/deep open imposed:

| `rank(M_r)` | residual section | generic residual dimension | exact effect |
|---:|---|---:|---|
| 4 | line cubic | 0 | collision plus two sheets; one double sheet on the conic |
| 3 | plane cubic | 1 | the three-centre residual curve |
| 2 | cubic surface in `P3` | 2 | the two-centre residual surface |
| 1 | cubic threefold in `P4` | 3 | one independent projected sextic |
| 0 | cubic in `P5` | 4 | no compatibility information |

For rank at most three the dimension is `4-rank(M_r)` unless `K_r subset V(F)`, when it jumps by
one and the residual component is exactly `K_r`.  Vanishing maximal minors classify dependent or
repeated views.  Vanishing parent triple minors is the boundary of six-arc moduli; vanishing
centre-secant determinants is precisely failure of the deep condition.  These are excluded domain
components, not extra branches of the Gale cover.

Camera recovery has no unclassified denominator case.  For a view put

```text
D5=B a-A,  N5=A-1+(1-B)b,
D6=C c-A,  N6=A-1+(1-C)d.                              (11)
```

If some `D` is nonzero the camera is unique; if both vanish but some `N` does not, no camera exists;
if all four vanish, that view has a one-dimensional camera fibre.  A nontrivial common diagonal
`S6` stabilizer is the remaining stacky exception after unlabelling: it identifies the two Gale
sheets exactly when one of its elements carries one sheet to the other.

## 4. Complete-child sheet selection

Let `L=U(A)` be retained as a literal subset of `PG(2,F)`, and let `T={ell_s}` be selected centres.
A reconstructed configuration `(A',(u'_s))` passes the complete-child cut exactly when one
`g in PGL_3(F)` satisfies

```text
g(ell_s)=u'_s for all s,                 g(L)=U(A').    (12)
```

Over a finite field the second equality is the exact finite incidence system

```text
det(g ell,h'_i,h'_j) != 0                  (ell in L, i<j),
product_{i<j} det(g x,h'_i,h'_j) = 0       (x outside L).   (13)
```

For four views, exactly one passing sheet gives sheet-selected recovery; two passing sheets leave
the ambiguity unresolved.  For two or three views, apply (12)--(13) to every point of the explicit
surface or curve (10).  Equivalently, for the fixed-child fibre `P_L` of unlabelled parents modulo
the allowed ambient child stabilizer, define

```text
Sigma_T:P_L -> {coherent projected-sextic tuples on T}/S6_diag.   (14)
```

Then child-relative reconstruction is exact if and only if `Sigma_T` is injective.  This is both
the canonical algorithm and the exact equality criterion: two fixed-child parents represent the
same output precisely when their signatures agree after one diagonal relabelling and the allowed
ambient semilinear transporter.

There is a uniform large-field base-size-zero theorem which follows directly from the child.

> **Secant-union rigidity lemma.**  If `A` and `B` are six-arcs in `PG(2,q)`, `q>=16`, and
> `U(A)=U(B)`, then `A=B` as unlabelled point sets.

Indeed, the complement of `U(A)` is the union of the fifteen distinct secant lines of `A`.  Every
secant line `ell` of `A` has `q+1>15` rational points.  If no secant of `B` equalled `ell`, the
fifteen secants of `B` could cover at most fifteen points of `ell`, one per line, contradicting
equality of the two complements.  Thus the two secant-line sets agree.  Each point of `A` is
incident with five of these lines.  A point outside `A` is incident with at most three: distinct
secants through it use disjoint pairs of the six arc points and hence form a matching in `K_6`.
Therefore `A` is exactly the set of points incident with five lines of the recovered arrangement.

Consequently the unlabelled fixed-child fibre `P_L` is a singleton for `q>=16`, and its
empty-signature map is injective.  Labels themselves are of course not recovered from an empty
set of views.  Any genuinely uniform at-most-three problem is confined to the finite range
`q<=13`; this reduction is theorem-derived and uses no field census.

The same arrangement gives an exact child-cardinality formula.  Let `tau(A)` be the number of
points outside `A` at which three secants concur.  The three secants at such a point use disjoint
pairs of the six arc points, so `tau(A)` counts concurrent perfect matchings of `K_6` and satisfies
`0<=tau(A)<=15`.  Among the `binom(15,2)=105` pairs of secant lines, the six arc vertices account
for `6 binom(5,2)=60`; the remaining `45` pairs meet in external double or triple points.  The
line-union inclusion count is therefore

```text
|union Sec(A)|=15(q+1)-6(5-1)-(45-tau(A))=15q-54+tau(A),
|U(A)|=q^2-14q+55-tau(A).                              (14a)
```

Thus the complete child's cardinality remembers exactly the number of concurrent perfect
matchings, though not their arrangement.  For the four frozen C478 children, (14a) gives
`tau=3,4,3,10` from the sizes `4,6,7,12` at `q=8,9,9,11` respectively.

The frozen C478 controls give sharp, bounded instances:

| fixed child | parent fibre | last failing restriction | first recovering restriction |
|---|---:|---|---|
| q=8, four-point child | 6 | every pair: three fibres of size two | every triple: six singletons |
| q=9 cube | 8 | best pair: `1,1,1,1,2,2` | one triple orbit: eight singletons |
| q=9 seven-locus | 2 | every singleton: one pair | a distinguished pair: two singletons |
| q=11 full conic child | 22 | pairs: `2,10,10` | every triple: 22 singletons |

Hence the exact frozen thresholds are `3/3/2/3`.  They prove no uniform at-most-three theorem
beyond these four fixed-child fibres.  At q=8 the conclusion uses the Galois-equivariant colour
action; quotienting each colour separately by Frobenius erases the orientation and leaves `3+3`.

## 5. Semilinear and orbit criterion

Frobenius acts coefficientwise on (2)--(14), and Gale association commutes with it.  On an
unramified labelled geometric pair, a chosen sheet `x` has cocycle

```text
epsilon_x(gamma) in C2,       gamma(x)=Gale^epsilon_x(gamma)(x).   (15)
```

A labelled sheet is defined over `F_q` exactly when the `q`-Frobenius value is zero.  If it is one,
the sheets are exchanged and become individually rational over `F_(q^2)`.  Locally this is tested
by a chart-independent square class in odd characteristic or a chart-independent absolute trace
of an Artin--Schreier parameter in characteristic two.  Hilbert 90 and Lang descent remove the
multiplicative, additive, quotient-line, and projective camera gauges; they do not remove (15).

For a diagonally unlabelled target, let `H` be the common diagonal stabilizer and
`chi:H -> C2` its action on the Gale pair.  If `pi` is a Frobenius label transporter, the exact
effectivity test is

```text
epsilon_(pi,x) in chi(H).                                (16)
```

When `chi(H)=0`, this is the ordinary Kummer/Artin--Schreier test.  When `chi(H)=C2`, the quotient
descends but the stabilizer itself identifies the sheets, so reconstruction is not sheet-unique.
On the conic divisor the two sheets coincide and (15)--(16) are vacuous.

For an `F_q`-rational pure target this gives the complete geometric fibre trichotomy:

1. on the conic branch, one `F_q`-rational ramified parent;
2. off the branch with trivial sheet bit, two `F_q`-rational Gale-associated parents; or
3. off the branch with nontrivial sheet bit, no labelled `F_q`-parent and one conjugate pair over
   `F_(q^2)`.

Over `F_(q^m)` the sheet bit is multiplied by `m`; hence a nonsplit pair remains nonsplit for odd
`m` and splits for even `m`.  Diagonal stabilizers modify only the quotient-effectivity statement
through (16), not this geometric trichotomy.

Thus two coherent inputs have the same pure reconstruction orbit exactly when, after a single
diagonal permutation and a field automorphism, their normalized rows (4) define the same
Gale-unordered output and satisfy (16).  For a fixed child, add (12), or equivalently compare in the
injective fibre of (14).

## 6. Standard GRS specialization

For a six-point standard GRS support, write the conic columns as `h_i=c_i nu(v_i)`, where

```text
nu(x,y)=(x^2,xy,y^2).
```

For a projective syndrome `u`, C475 gives in every characteristic

```text
det(u,nu(v_i),nu(v_j))=[v_i,v_j] beta_u(v_i,v_j).       (17)
```

After division by the known support brackets, the balanced atlas is

```text
A_ijkl(u)=beta_ij beta_kl/(beta_ik beta_jl).            (18)
```

The synthesis has two compatible consequences.

- Because the parent six-arc lies on a conic, pure four-projection **parent** reconstruction lies
  on the Gale ramification divisor and returns one sheet with multiplicity two.
- For the fixed conic support, the syndrome atlas (18) reconstructs every rank-two syndrome when
  the support has at least five points.  On the rank-one stratum every coordinate equals one and
  the quotient deliberately contracts the syndrome; the unique missing datum is
  `rad(beta_u) in P1(F)\S`.

Accordingly, the canonical GRS record consists of the ordered support, the thirty ratios, the rank,
and—only in rank one—the radical marker.  Two rank-two syndromes are in the same
projective-semilinear code-automorphism orbit exactly when their atlases agree after a support
stabilizer permutation and a common Frobenius power.  Two rank-one syndromes are equivalent exactly
when their radical points lie in the same support-stabilizer/Frobenius orbit.  No higher balanced
edge monomial repairs the rank-one contraction.

This separates two notions that would otherwise be easy to conflate: the conic parent is fixed by
Gale association, while a rank-one syndrome on that parent still requires its radical marker.

## 7. Evidence, replay, and claim boundary

This synthesis is a proof-only assembly of C475 and C481--C484.  Its algebraic proof consists of:

1. the projection-sextic/edge-torus equivalence and explicit inverse from C481;
2. the exact compatibility equations, kernel cubic, and quadratic algorithm from C482;
3. the integral factorization, Gale identification, complete exceptional table, and child cut from
   C483;
4. the Frobenius cocycle and finite-stabilizer criterion from C484; and
5. the all-characteristic Veronese factorization and rank-one radical correction from C475.

No new computational claim is introduced.  The inherited atomic bundles replay from
`/home/tavis/src/othello` with:

```bash
python3 notes/2026-07-22-c482-three-centre-synchronization.py --check
python3 notes/2026-07-22-c483-reconstruction-discriminant.py --check
python3 notes/2026-07-22-c483-reconstruction-discriminant-replay.py
python3 notes/2026-07-22-c484-coherent-semilinear-descent.py --check
python3 notes/2026-07-22-c478-exceptional-family-controls.py --check
python3 notes/2026-07-22-c478-exceptional-family-controls-replay.py
sha256sum -c notes/2026-07-22-c483-reconstruction-discriminant.sha256
sha256sum -c notes/2026-07-22-c484-coherent-semilinear-descent.sha256
sha256sum -c notes/2026-07-22-c478-exceptional-family-controls.sha256
```

The C482 checksum manifest is exceptionally basename-relative; replay it from the notes directory:

```bash
(cd notes && sha256sum -c 2026-07-22-c482-three-centre-synchronization.sha256)
```

C482's finite witnesses certify that the separable degree-two open is nonempty in odd and even
characteristic.  C483's independent Gale replay checks the involution and conic fixed locus over
`F_5,F_7,F_11`.  C478's independent replay certifies only the four frozen child-relative rows, and
C484 extracts only the q=8 Frobenius action from those hash-pinned inputs.  The all-field theorem
is the algebraic argument, not an extrapolation from those finite checks.

No external novelty or priority wording is made, so no literature-absence claim is required by
this task.  The result concerns six-column redundancy-three MDS systems.  It does not prove the
general Reed--Solomon deep-hole conjecture, extend to higher redundancy, give a uniform
at-most-three child base-size theorem, enlarge the frozen field/support census, or derive any
matching, Gram, Sylow, modular-category, or list-decoding consequence.

## Extra-juice closeout

The assembly exposes one free conceptual upgrade: the GRS specialization is not merely an example
of the generic theorem.  It is exactly the branch stratum of parent reconstruction, while C475's
rank-one syndrome stratum is a different contraction inside the fixed-parent atlas.  Recording
both strata in one package prevents the Gale ambiguity and the radical-marker ambiguity from being
mistaken for one another.

The canonical algorithm also makes the verification layers independent: atlas decoding checks
edge-torus invariance, the kernel cubic checks pure reconstruction, direct reprojection checks the
cameras, the incidence cut checks child-relative selection, and (16) checks semilinear
effectivity.  No new artifact is needed because each computational layer is already an atomic,
hash-pinned predecessor bundle.

## Requested extra-juice pass

Two further consequences are now explicit.

First, complete-child rigidity is automatic for `q>=16`: equality of children gives equality of
the fifteen rational secant-line unions, and the five-fold incidence points recover the arc.  This
is a base-size-zero theorem, stronger than the requested at-most-three conclusion, and it confines
the unresolved base-size question to `q<=13`.  The promising route to a full theorem is therefore
not a general-purpose permutation-group bound.  It is secant-arrangement rigidity for the large
fields, followed by a proof or bounded classification of the genuinely small residual fields.

Second, the descent criterion yields a sharp three-way finite-field output—ramified rational,
split rational Gale pair, or nonsplit conjugate Gale pair—and the nonsplit case is killed by exactly
the even-degree extensions.  This makes the meaning of “reconstruction over `F_q`” explicit and
prevents quotient effectivity from being confused with existence of a labelled rational parent.

## Requested second-order extra-juice pass

The residual `q<=13` base-size problem admits a sharper reduction which identifies where a theorem
could come from.

For a literal child `L`, put `Z=PG(2,q)\L`.  Every parent in `P_L` is equivalently a decomposition
of `Z` as the union of fifteen distinct lines whose points incident with five selected lines are
exactly six and form a six-arc.
Thus one need not enumerate all six-arcs: compute the lines contained in `Z`, enumerate only the
admissible fifteen-line decompositions, and recover each parent as the six points incident with
five selected lines.  For `q>=16` the rigidity lemma says this decomposition is unique.  For
`q<=13`, every ambiguity is precisely an alternative decomposition of the same finite line union.

The at-most-three question is then an exact hitting-set problem.  For distinct fixed-child parents
`A,B` and each allowed single diagonal label transporter `pi` (and, when comparing child orbits,
each allowed child stabilizer transporter), define the collision set

```text
E_(A,B,pi)={ell in L : c_A(ell)=pi.c_B(ell)},
D_(A,B,pi)=L\E_(A,B,pi).                               (19)
```

A subset `T subset L` makes `Sigma_T` injective exactly when it meets every disagreement set
`D_(A,B,pi)`.  The use of one global `pi` in (19) is essential: allowing a different permutation
at each centre would revert to the pointwise quotient and lose coherent recovery.

This gives an immediate sufficient three-centre criterion:

```text
sum_(A,B,pi) binom(|E_(A,B,pi)|,3) < binom(|L|,3).      (20)
```

Indeed, the left side union-bounds the triples contained in at least one collision set, while the
right side counts all triples.  A stronger proof can exploit child-stabilizer orbits of triples
rather than the union bound.  Either route produces a compact certificate consisting of the
alternative line decompositions, transporter-orbit representatives, collision-set sizes, and one
separating triple; it avoids an unstructured field census.

So the likely source of a complete base-size theorem is a two-stage argument:

1. secant-line-union rigidity handles every `q>=16` with base size zero; and
2. exact-cover rigidity plus the collision hypergraph (19) handles the finitely many residual
   prime powers `q<=13`, analytically where possible and by a bounded, independently replayed
   certificate only for the genuinely exceptional decompositions.

General primitive-group base-size bounds may organize the child-stabilizer orbits, but by
themselves they do not see the atlas colours or the single-diagonal coherence in (19).  The
line-arrangement and collision-hypergraph formulation does.

## Requested third-order extra-juice pass

There is also an algebraic route to bounding the collision hyperedges, potentially avoiding most
of the residual exact-cover enumeration.  For two candidate parents `A,B` and a fixed diagonal
permutation `pi`, put

```text
d^A_ij(u)=det(u,h^A_i,h^A_j),
d^B_ij(u)=det(u,h^B_i,h^B_j).
```

Equality of one balanced four-cycle coordinate at `u` is the vanishing of the homogeneous quartic

```text
G_ijkl^(A,B,pi)(u)
 =d^A_ij d^A_kl d^B_(pi(i)pi(k)) d^B_(pi(j)pi(l))
 -d^B_(pi(i)pi(j)) d^B_(pi(k)pi(l)) d^A_ik d^A_jl.     (21)
```

The collision set `E_(A,B,pi)` is exactly the deep-child part of the common zero locus of these
quartics (using both stored coordinates for every four-subset).  Hence:

- if two members of (21) have no common component, Bezout gives `|E_(A,B,pi)|<=16` over any field;
- positive-dimensional collision sets can occur only when the quartics share a component, so a
  complete proof reduces to classifying those common factors; and
- the factors supported on parent secants are irrelevant after restriction to `L`, leaving only
  genuine coherent-atlas coincidences to classify.

This suggests a proof ladder for the residual fields: factor the collision ideal for each orbit of
alternative secant decompositions, classify its positive-dimensional components geometrically,
then feed the resulting exact `|E|` bounds into (20).  A certificate need store only orbit
representatives, factor data, and a separating triple.  The approach is stronger than raw
triple enumeration because it explains why three centres work and isolates any exceptional curve
on which they cannot.

Three ambient centres do not by themselves permit naive triangulation: each projected sextic is
remembered only modulo its own `PGL_2` quotient-line gauge.  Formula (21) is the gauge-invariant
replacement for that invalid shortcut.  Any uniform geometric proof must synchronize those gauges
or work with their balanced quartics.

## Terence Tao stress test

Four points deserve explicit protection against plausible shortcuts.

1. **The large-field lemma uses the whole child.**  Equality on a selected subset of deep points
   does not identify the complements and cannot recover the secant-line union.
2. **Base size zero is unlabelled.**  The child recovers the six-point set for `q>=16`, not an
   ordering of its points.  Diagonal `S6` is therefore part of the statement, not a cosmetic
   quotient.
3. **Three views are not ordinary triangulation.**  Their quotient-line `PGL_2` gauges are
   independent.  Ignoring them would contradict C482's one-dimensional three-view residual curve;
   the balanced equations (21) are the correct objects.
4. **Bezout is conditional.**  The bound `16` applies only after producing two nonzero quartics
   without a common component.  Shared components are exactly the hard exceptional case and must
   be classified, not discarded as nongeneric.

The stress test also checks the finite-field trichotomy against C482: if one off-branch parent is
already `F_q`-rational, formula (7) makes its Gale partner rational too.  Hence the only nonsplit
case is a rational target whose two geometric parents are Frobenius-conjugate; there is no fibre
with exactly one rational off-branch sheet.

## Requested fourth-order extra-juice pass

Formula (14a) turns child cardinality into a free secant-concurrency invariant:

```text
tau(A)=q^2-14q+55-|U(A)|.                              (22)
```

Any two parents with the same literal child therefore have the same number of concurrent perfect
matchings before a single atlas coordinate is computed.  This stratifies the alternative
line-decomposition search for free and gives the exact denominator in the three-centre union bound
(20).  In particular, at `q=13` every six-arc has `27<=|U(A)|<=42`, so the largest residual field—
one step beyond the frozen controls' largest field—already has a comparatively large pool of
candidate centres.

The four frozen child sizes are no longer unrelated numerical inputs: they are the concurrency
profiles `tau=3,4,3,10`.  The q=11 matching fibre's twelve-point child is small precisely because
ten of the fifteen perfect matchings are realized as triple-secant concurrence points.  This does
not by itself prove base size three, but it identifies a concrete geometric statistic whose orbit
structure can make the collision hypergraph small.

## Requested fifth-order extra-juice pass

The line-cover argument sharpens further in the two largest residual fields.  Suppose distinct
six-arcs `A,B` have the same child, and let `C` be their common secant lines, regarded as an edge
set on the six vertices of `A`.

If `q>=11`, every vertex of `A` lies on a common secant.  Indeed, a noncommon secant of `B` through
an `A`-vertex meets five `A`-secants at that one vertex and the other ten at at most ten further
points, so the union of the `A`-secants covers at most eleven of its `q+1>=12` points.  This is
impossible.  Since every `A`-vertex belongs to the common secant union, `C` is an edge cover of the
six vertices.  The same statement holds with `A,B` reversed.

Let `d_i` be the degree of vertex `i` in `C`.  On a noncommon `A`-secant `ij`, the common lines
through `i` and `j` force at least `(d_i-1)+(d_j-1)` repeated intersections among the fifteen
`B`-secants.  Covering all `q+1` points therefore requires

```text
d_i+d_j <= 16-q                                      (23)
```

for every nonedge `ij` of `C`.

At `q=13`, (23) says `d_i+d_j<=3` on every nonedge, while every degree is positive.  This classifies
the common-secant graph completely.  If some vertex has degree at least three, it can have no
nonneighbor and hence has degree five; among its leaves there is at most one extra edge.  If all
degrees are at most two, the degree-two vertices must be pairwise adjacent, and parity leaves only
zero or two of them.  Consequently a distinct q=13 pair has exactly one of four common-secant
skeletons:

```text
3 edges: perfect matching,
4 edges: P4 disjoint-union K2,
5 edges: K1,5,
6 edges: K1,5 plus one leaf edge.                       (24)
```

Thus q=13 no longer calls for an unrestricted alternative-decomposition search.  A successor can
analyze the four skeletons (24), factor their collision quartics, and either prove a three-centre
transversal or exhibit the precise exception.  At q=11 the same argument gives an edge cover and
the weaker nonedge bound `d_i+d_j<=5`, already compatible with the richer frozen matching fibre.

## Requested sixth-order extra-juice pass

At q=13, a noncommon secant cannot pass through a triple-secant concurrence point of the other
parent: three lines meeting there already create two repeated intersections, while a fourteen-point
line covered by fifteen lines permits only one.  Hence the common-edge set must meet every
concurrent perfect matching, on both the `A` and `B` vertex labellings.

An edge of `K_6` belongs to three perfect matchings.  More exactly, the four skeletons in (24) meet
respectively

```text
3K2:                  7 of the 15 perfect matchings,
P4 disjoint-union K2: 9 of the 15 perfect matchings,
K1,5:                all 15 perfect matchings,
K1,5 plus one edge:  all 15 perfect matchings.          (25)
```

The first two counts follow by inclusion--exclusion: three disjoint edges have union size
`3*3-3+1=7`, while the four edges of `P4 disjoint-union K2` have four disjoint edge-pairs and one
perfect-matching triple, giving `4*3-4+1=9`.  Every perfect matching contains exactly one edge at
the centre of a five-star.

Combining (22) and (25), child cardinality alone removes skeletons before any collision-ideal
calculation:

- a perfect-matching common skeleton forces `tau<=7`, hence `|U(A)|>=35`;
- `P4 disjoint-union K2` forces `tau<=9`, hence `|U(A)|>=33`; and
- if `|U(A)|<=32` (`tau>=10`), both parents' common-edge graphs must be a five-star, possibly with
  one extra leaf edge.

This is the first direct bridge from a child-only scalar to the shape of every alternative parent.
It reduces the densest q=13 concurrency strata to two star geometries.

## Red-team audit

The synthesis and all extra-juice additions were checked against the following failure modes.

1. **Literal child versus sampled centres.**  Secant-union equality follows only from equality of
   the full sets `U(A)=U(B)`.  None of the line-rigidity conclusions is asserted for a sampled
   subset or for independently Frobenius-quotiented colours.
2. **Unlabelled versus labelled recovery.**  The secant arrangement recovers the six-point set,
   not its ordering.  The base-size-zero statement therefore lives only after diagonal `S6`; any
   labelled output still needs view data or an explicit label choice.
3. **Line-arrangement multiplicities.**  Fifteen secants are distinct because the parent is an arc.
   A nonvertex lies on at most three of them because their endpoint pairs are disjoint.  This
   justifies both the `tau` formula and the recovery of vertices as exactly the five-fold points.
4. **q=13 cover count.**  A noncommon line has fourteen points and receives fifteen line
   intersections, so it permits at most one lost distinct point.  The vertex, degree, triple-point,
   and skeleton arguments use only forced repetitions and remain valid when further accidental
   repetitions occur—they would strengthen the contradiction.
5. **Two parent labellings of common lines.**  A common geometric secant defines an edge on each
   parent, but the two edge graphs need not be isomorphic.  The edge-cover, four-skeleton, and
   perfect-matching-hitting arguments apply separately on both vertex sets; no endpoint
   identification is assumed.
6. **Bezout overreach.**  The bound `16` is used only when two nonzero quartics have no common
   component.  The report leaves shared components as the explicit successor gate.
7. **Gauge overreach.**  Three projected sextics are not triangulated as literal rays.  Equality is
   imposed only through balanced determinant ratios, preserving each view's quotient-line gauge
   and the single diagonal label transporter.
8. **Finite-field descent.**  The split/nonsplit trichotomy is for the labelled geometric Gale
   cover.  A diagonal stabilizer may make the quotient effective while destroying sheet uniqueness;
   it does not create exactly one rational off-branch labelled sheet.
9. **Evidence boundary.**  The new rigidity, counting, skeleton, and hitting statements are proved
   combinatorially in the report.  Frozen numerical profiles remain supported only by the inherited
   C478 replay.  No finite check is promoted to an all-field assertion.
10. **Scope.**  Nothing here extends beyond six-column redundancy three, proves a uniform q<=13
    three-centre bound, or imports the separate matching/Gram/Sylow machinery.

One notation defect was removed during the audit: `P_L` already denotes the unlabelled fixed-child
fibre, so no second quotient `P_L/S6` is taken.

## Mystery ledger

- **Settled — why four views do not give uniqueness.**  The surviving involution is intrinsic Gale
  association, not a missing compatibility equation or gauge.
- **Settled — why GRS behaves differently.**  Six conic points are exactly the reduced Gale branch
  divisor, so the pure pair ramifies to one sheet.
- **Settled — why the GRS all-one atlas can still be ambiguous.**  This is C475's separate rank-one
  edge-torus contraction; the radical point is precisely the missing datum.
- **Settled — why the frozen thresholds can be below four.**  The complete ambient child supplies
  incidence equations absent from abstract projections.
- **Partly settled — uniform at-most-three recovery.**  For `q>=16`, secant-union rigidity proves
  the stronger base-size-zero statement.  The remaining evidence gap is confined to `q<=13`, where
  one must prove that the collision hypergraph (19) has transversal number at most three or
  classify the common-component exceptions of (21); the present theorem retains injectivity as the
  exact hypothesis there.
- **Exposed — exceptional concurrence profiles.**  Child size is exactly equivalent to the count
  `tau` of concurrent perfect matchings, giving frozen values `3,4,3,10`; what remains unexplained
  is which secant-arrangement symmetries force those particular concurrence sets and how directly
  they control the collision-ideal components.
- **Sharpened — q=13 alternative parents.**  Their common secants must form one of the four graphs
  in (24), and child size at most 32 leaves only the two star types.  What remains is a stratified
  collision-ideal analysis, not a field-wide six-arc census.
- **Open, outside this lane step — higher redundancy.**  The six-point Gale self-duality uses
  `n=2r` and supplies no higher-symmetric-power reconstruction theorem.

## Vibe check

The programme-level theorem is clean and strong: all characteristic and descent loose ends close,
and the two genuine ambiguities are now sharply separated.  The only important disappointment is
also well localized—three child centres are not uniformly sufficient without a new base-size
theorem.
