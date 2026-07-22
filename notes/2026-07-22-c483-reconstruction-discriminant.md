# C483 — reconstruction discriminant and exceptional fibres

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete.

## Result

The source-side involution found in C482 is the classical **Gale association involution** on six
ordered points of `P2`.  This makes the four-view ambiguity intrinsic and completely factors its
branch divisor.  If `H` is the `3 x 6` parent matrix, the second sheet is represented by any Gale
dual matrix whose rows span `ker(H)`; changing bases or column representatives changes only the
allowed projective and edge-torus gauges.  Gale duality squares to the identity.

On the normalized chart

```text
h1=(1,0,0), h2=(0,1,0), h3=(0,0,1), h4=(1,1,1),
h5=(1,a,b), h6=(1,c,d),
```

put

```text
L0 = bc+a+d-ad-b-c,
L1 = abc+bcd+ad-abd-acd-bc.                            (1)
```

Then the kernel cubic from C482 factors exactly as

```text
Q(se+tz)=st(L0 s+L1 t),
q(s,t)=s(L0 s+L1 t),
Disc(q)=L1^2.                                           (2)
```

This identity is characteristic-free.  In characteristic two, `q` is separable exactly when its
middle coefficient `L1` is nonzero, so the same reduced ramification equation works without
dividing by two.  Intrinsically,

```text
L0 = -det(h4,h5,h6),
L1 = det(v2(h1),...,v2(h6)),                            (3)
```

where `v2` is the quadratic Veronese map and the second determinant uses any ordered basis of
ternary quadrics.  Therefore:

- `L1=0` is exactly the locus where the six points lie on a conic.  On the six-arc locus that conic
  is nonsingular.  It is the reduced source ramification/fixed divisor, and its image is the branch
  divisor on the Gale quotient.
- `L0=0` is not a second interior branch component: it is the boundary divisor where
  `h4,h5,h6` are collinear.  There the second residual root is the universal collision.
- `L0=L1=0` makes the whole kernel line product-compatible.  It is the explicit
  positive-dimensional degeneration, entirely outside the six-arc locus.

Thus pure four-projection reconstruction has degree two on the nonconic six-arc locus and degree
one with multiplicity two on the conic locus.  In particular, the GRS/conic specialization is the
ramification locus rather than a generic two-sheet fibre.

There is a stronger consequence: no number of additional **abstract** projected sextics selects a
Gale sheet.  Every compatibility row annihilates both `e` and `z`, hence also
`z#=L1 e-L0 z`.  On the unique-camera/deep open, every centre of `A` therefore has a corresponding
centre of `Gale(A)` producing the same labelled projected sextic.  Any `r>=4` tuple containing a
rank-four subtuple still has exactly the same Gale pair; only data retaining the common ambient
placement of the centres can break it.

In moduli language, let `M_arc` be the labelled six-arc moduli space and `iota` its Gale
involution.  On the rank-four unique-camera open, every pure `r>=4` reconstruction map factors as

```text
M_arc  ->  M_arc/<iota>  ->  image(Phi_r),
```

with the first arrow generically finite of degree two.  Its source ramification divisor is the
conic locus; the target branch divisor is the image of that locus.  This separates the intrinsic
geometric statement from the chart fact that the pulled-back quadratic discriminant is `L1^2`.

## 1. Identification with Gale association

A kernel basis for the normalized parent matrix gives Gale columns

```text
g1=(-1,-1,-1), g2=(-1,-a,-c), g3=(-1,-b,-d),
g4=(1,0,0),    g5=(0,1,0),    g6=(0,0,1).              (4)
```

Renormalizing `g1,...,g4` to the standard frame sends `g5,g6` to

```text
a# = (ad-bc)(d-1)/((b-d)(c-d)),
b# = (ad-bc)(c-1)/((a-c)(c-d)),
c# = (ad-bc)(b-1)/((a-b)(b-d)),
d# = (ad-bc)(a-1)/((a-b)(a-c)).                        (5)
```

These are exactly C482's `rho(L1 e-L0 z)` coordinates.  Indeed the six unscaled numerators
`L1-L0 z_i`, for `z=(a,b,c,d,bc,ad)`, factor as

```text
(a-b)(a-c)(d-1),       (a-b)(b-d)(c-1),
(a-c)(b-1)(c-d),       (b-d)(c-d)(a-1),
(b-1)(c-1)(ad-bc),     (a-1)(d-1)(ad-bc).              (6)
```

Every factor in (5)--(6) is a parent triple minor on this chart.  Consequently Gale association
is regular on the ordered six-arc moduli space; its apparent poles are precisely boundary
collinearities, not hidden interior exceptions.  Taking the Gale dual twice recovers the original
row space, so (5) is intrinsically involutive.  Finally, (3) proves directly that its fixed locus
is the conic locus: in (2), a known sheet and its partner coincide exactly when `L1=0`, while
`L0!=0` on every six-arc.

Indeed, if a normalized projected sextic has compatibility row `m`, then `m e=m z=0` implies
`m z#=m(L1 e-L0 z)=0`.  Where camera recovery is unique, this pairs its centre for `A` with a
centre for `Gale(A)` having the identical labelled `M_0,6` point.  Applying association again
reverses the pairing.  Thus the two parents have the same abstract projected-sextic image on a
dense open; four views expose the global quotient by Gale association rather than an ambiguity
that a fifth view could remove.

The second-order closeout also produces a chart-local sheet-orientation coordinate.  Put

```text
rho=(ad-bc)/((a-b)(a-c)(b-d)(c-d)),     tau=L1/L0^2.
```

Direct substitution of (5) gives

```text
L0#=-rho L0^2,       L1#=-rho^2 L0^2 L1,       tau#=-tau.   (7)
```

Thus in odd characteristic `tau` is a local trivialization of the anti-invariant Gale sheet line
and the target remembers its square; ramification is `tau=0`.  A change of frame changes this
trivialization, so C484 must glue the local anti-invariant lines rather than treat `tau` as a global
scalar.  In characteristic two the sign character collapses even though the cover remains
generically separable.  Consequently the q=8 `C3` colour orientation cannot be the Gale `C2` sheet
character: C484 must treat it as a distinct Frobenius-colour descent class.

The third-order closeout gives the missing additive coordinate explicitly.  On the overlap where
`L0+L0#` is nonzero, define

```text
eta=L0/(L0+L0#)=1/(1-rho L0).
```

Involutivity alone gives

```text
eta#=1-eta.                                             (8)
```

In characteristic two this is `eta#=eta+1`, and `kappa=eta^2+eta` is target-invariant.  Thus the
same Gale cover is locally Kummer/sign-linearized in odd characteristic and
Artin--Schreier/translation-linearized in characteristic two.  On the conic ramification locus the
odd-characteristic coordinate specializes to `eta=1/2`, while in characteristic two this affine
Artin--Schreier chart develops a pole.  C484 owns only the overlap cocycle and global descent of
these local coordinates, not their existence.

The fourth-order closeout identifies the overlap data without choosing a global trivialization.
For two frame charts `i,j`, odd-characteristic anti-invariant coordinates satisfy

```text
r_ij=tau_i/tau_j,       r_ij#=r_ij,       r_ij r_jk=r_ik.
```

Thus the `tau_i` glue as a line over the Gale quotient.  In characteristic two, two additive
coordinates satisfy

```text
a_ij=eta_i+eta_j,       a_ij#=a_ij,       a_ij+a_jk=a_ik,
kappa_j-kappa_i=a_ij^2+a_ij.                              (9)
```

These are exactly multiplicative/Kummer and additive/Artin--Schreier Cech transition laws.  They
reduce C484's geometric descent input to an explicit quotient-line bundle/torsor cocycle.  They
also prevent an attractive but invalid shortcut: the numerical q=8 factorization `6=2*3` does not
by itself make the fixed-child fibre a product of a Gale `C2` and colour `C3` torsor.  Gale acts on
parent moduli, whereas `U(A)=L` is an additional embedded-child cut that need not preserve a raw
Gale pair.

## 2. Exceptional-fibre table

Let

```text
F(x_a,x_b,x_c,x_d,x_X,x_Y)=x_X x_a x_d-x_Y x_b x_c,
K_r=P(ker M_r) subset P5.                              (10)
```

The exact algebraic residual family is `K_r intersect V(F)`, with the universal collision removed
and then the arc/deep open conditions imposed.  This description also covers every rank drop; no
unnamed residual component remains.

| effective rank `rho` | kernel section | generic residual dimension | exact exceptional behaviour |
|---:|---|---:|---|
| 4 | line cubic | 0 | collision plus two residual roots; nonconic: two sheets; conic: one double sheet; `L0=0`: partner is collision; `L0=L1=0`: the whole line lies in `V(F)` |
| 3 | plane cubic | 1 | the three-centre residual curve; four views with dependent compatibility rows have the same curve |
| 2 | cubic surface in `P3` | 2 | the two-centre residual surface; repeated/dependent views do not cut it further |
| 1 | cubic threefold in `P4` | 3 | only one independent projected sextic remains |
| 0 | `V(F) subset P5` | 4 | no compatibility information |

For `rho<=3`, the stated dimension is `4-rho` unless `K_r subset V(F)`, in which case it jumps by
one and the residual component is exactly `K_r`.  Containment is checked by the vanishing of all
coefficients of `F|K_r`.  For `rho=4` and a known compatible parent, this criterion reduces to
`L0=L1=0` by (2).

The remaining exceptional strata separate cleanly:

| stratum | intrinsic meaning | effect |
|---|---|---|
| all `4 x 4` minors of `M_4` vanish | compatibility hyperplanes are dependent | positive-dimensional residual family as above |
| two normalized projected sextics coincide | two rows of `M_r` coincide | a visible sublocus of the rank-drop ideal |
| a parent triple minor vanishes | boundary of the six-arc moduli space | formulas (5)--(6) may acquire a pole or collision |
| `det(u_s,h_i,h_j)=0` | centre lies on a parent secant | projected sextic has a collision; outside the deep domain |
| nontrivial common diagonal `S6` stabilizer | stack/orbifold locus of the unlabelled target | it identifies the two sheets exactly when some stabilizer element carries `A` to `Gale(A)` |

The cubic `V(F)` itself has singular locus equal to the nine coordinate lines obtained by choosing
at most one nonzero coordinate from each triple `(x_a,x_d,x_X)` and `(x_b,x_c,x_Y)`.  Formula (6)
shows that its intersection with the reconstruction chart is again accounted for by parent-minor
boundary factors.

Camera recovery has one additional, explicit linear trichotomy.  For one view write

```text
D5=B a-A,  N5=A-1+(1-B)b,
D6=C c-A,  N6=A-1+(1-C)d.                             (11)
```

If either `D5` or `D6` is nonzero, compatibility gives the unique camera parameter.  If both
denominators vanish and some numerator does not, there is no camera.  If all four quantities
vanish, the camera parameter is free and that view contributes a one-dimensional camera fibre.
This exhausts the recovery-denominator cases.  The remaining factors in C482 Section 6 are exactly
frame-chart choices, parent collinearities, or centre-secant incidences and are covered by another
chart or excluded by the geometric domain.

## 3. Complete-child side information

Pure projected sextics forget the relative placement of their centres.  Retaining a complete
ambient child `L=U(A)` supplies an exact sheet cut, not another scalar discriminant.  For a selected
labelled subset `T={ell_s} subset L`, a reconstructed sheet `(A',(u'_s))` passes the child cut when
there is a single `g in PGL_3(F)` such that

```text
g(ell_s)=u'_s for every s,       and       g(L)=U(A').  (12)
```

Over a finite field the second equality is exactly the following finite incidence system:

```text
det(g ell,h'_i,h'_j) != 0                    for ell in L and all i<j,
product_{i<j} det(g x,h'_i,h'_j) = 0         for x in PG(2,F)\L.    (13)
```

Thus a four-view unordered pair is sheet-selected precisely when exactly one member satisfies
(12)--(13).  If both pass, the complete child alone does not choose between them.  For two or three
views, the exact answer is the intersection of the C482 surface or curve with (12)--(13); it is
finite only when these child equations cut the positive-dimensional residual family.

Equivalently, for the finite fixed-child fibre `P_L`, define

```text
Sigma_T : P_L -> {coherent projected-sextic tuples on T}/diagonal S6.   (14)
```

The weakest exact recovery hypothesis is simply that `Sigma_T` is injective, with Frobenius acting
equivariantly on both `L` and the field-coloured target.  This criterion is necessary and
sufficient; cardinality or generic-position language is not.

The frozen C478 controls give the following sharp instances of (14):

| child | fixed-child parents | last failing restriction | first recovering restriction |
|---|---:|---|---|
| q=8, `|L|=4` | 6 | every pair gives `3` fibres of size `2` | every triple gives `6` singletons |
| q=9 cube, `|L|=6` | 8 | the best pair orbit gives fibres `1,1,1,1,2,2` | one triple orbit gives `8` singletons; the other gives `7` signatures |
| q=9 seven-locus, `|L|=7` | 2 | every singleton has one fibre of size `2` | a distinguished pair orbit gives `2` singletons |
| q=11 full conic, `|L|=12` | 22 | pairs give fibres `2,10,10` | all `220` triples give `22` singletons |

This explains the frozen `3 / 3 / 2 / 3` thresholds structurally: they are the minimum sizes for
which the child-relative cut (11) separates the finite fixed-child parent fibre.  They do **not**
contradict C482's residual dimensions `2 / 1`, because C482 omits the common embedding of the
centres and the full incidence condition `U(A)=L`.  At q=8 the conclusion requires the
Galois-equivariant colour action; quotienting colours by Frobenius leaves the known `3+3`
orientation collapse.

## 4. Weakest theorem domains

The reconstruction clauses needed by C485 can now be stated without overlap.

1. **Pure labelled recovery.**  Require at least four distinct normalized projected sextics, a
   rank-four four-view subtuple, the six-arc/deep open conditions, and unique camera recovery.  The
   answer is a Gale pair off the conic ramification divisor and one ramified sheet on it; every additional
   abstract view preserves the same pair.
2. **Diagonal-unlabelled recovery.**  Add the exact stabilizer condition that no common diagonal
   permutation carries one Gale sheet to the other.  Trivial common stabilizer is sufficient but
   not necessary.
3. **Child-relative four-view selection.**  Add a complete child and require exactly one Gale sheet
   to pass (12)--(13).
4. **Child-relative two/three-view recovery.**  Intersect the explicit C482 surface/curve with
   (12)--(13), and require the resulting `Sigma_T` fibre to be a singleton.  There is no generic
   all-field claim that two or three centres suffice.

These clauses isolate all semilinear descent questions for C484; no Frobenius quotient is taken in
the present theorem.

## Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c483-reconstruction-discriminant.md
notes/2026-07-22-c483-reconstruction-discriminant.py
notes/2026-07-22-c483-reconstruction-discriminant-replay.py
notes/2026-07-22-c483-reconstruction-discriminant.json
notes/2026-07-22-c483-reconstruction-discriminant.sha256
```

Replay from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c483-reconstruction-discriminant.py --check
python3 notes/2026-07-22-c483-reconstruction-discriminant-replay.py
sha256sum -c notes/2026-07-22-c483-reconstruction-discriminant.sha256
```

The primary checker performs exact sparse-polynomial arithmetic over `Z`: it verifies (2)--(3),
all six factorizations (6), and the discriminant, then hash-pins and extracts the frozen C478
child-relative profiles.  The independent replay does not import the primary implementation.  It
constructs Gale duals by modular matrix inversion and exhausts all normalized six-arcs over
`F_5,F_7,F_11`, finding respectively

```text
all arcs:       6, 140, 3096;
conic/fixed:    6,  60,  504;
nonconic pairs: 0,  80, 2592.
```

It verifies on every arc that association preserves the arc locus, squares to the identity, and
is fixed exactly when the independent `6 x 6` conic-evaluation determinant vanishes.  These finite
counts are regression checks, not an all-field census.  The all-characteristic theorem is the
integral algebra above.  The frozen `3/3/2/3` controls retain their original primary and independent
C478 replay, both rerun for this task.

Trusted boundary: Python integer/JSON correctness, exact modular arithmetic, the frozen C478
certificate and its independently replayed field conventions, and C481's proved identification of
each atlas with a projected labelled `M_0,6` point.  The report does not prove semilinear descent or
extend the C478 field/support domain.

## Extra-juice closeout

The free upgrade is stronger than a factorization: the deck swap is not a new ad hoc involution at
all, but Gale association.  This immediately makes it projective, permutation-covariant,
characteristic-free, involutive, and regular on six-arcs.  It also identifies the source
ramification divisor with the classical self-associated/conic locus and the target branch with its
Gale-quotient image, while turning every apparent denominator in the chart formula into a visible
triple-minor boundary factor.

The requested further pass adds a programme-level negative and its repair: a fifth, sixth, or
arbitrary further abstract view cannot choose a sheet, because every compatibility row is
simultaneously orthogonal to `z` and `z#`.  The degree-two ambiguity is the global Gale quotient,
not underdetermination from too few cameras.  Complete-child placement is therefore logically
essential to every sheet-selected clause, not merely a convenient small-field discriminator.

The requested second-order pass extracts the first usable descent coordinate: `tau=L1/L0^2` changes
sign under Gale association.  This linearizes sheet exchange in odd characteristic and cleanly
separates it from q=8's order-three Frobenius-colour orientation.  Characteristic two therefore
needs an additive sheet coordinate; forcing the q=8 `C3` phenomenon into the Gale `C2` torsor would
conflate two different descent mechanisms.

The requested third-order pass supplies that coordinate: `eta=L0/(L0+L0#)` satisfies
`eta#=eta+1` in characteristic two, with invariant `eta^2+eta`.  This turns the local double cover
into exact Artin--Schreier form and leaves only transition/gluing data for C484.

The requested fourth-order pass computes those transitions: odd coordinates differ by invariant
units, while characteristic-two coordinates differ by invariant translations whose
Artin--Schreier parameters change by `a^2+a`.  It also blocks the unsupported inference that q=8's
six fixed-child parents automatically form a `C2 x C3` torsor; the embedded-child cut and the Gale
quotient are different operations.

The requested fifth-order pass gives the exact downstream proof ledger.

- **Already supplied to C484.**  Frobenius acts coefficientwise on
  `(a,b,c,d,X,Y)`, `(A_s,B_s,C_s)`, `M_r`, `L0,L1`, and the camera gauges; all defining formulas
  have prime-field coefficients.  Hence kernels, Gale association, the conic ramification divisor,
  and the child-incidence cut commute with Frobenius.  On the unramified locus a rational target has
  a two-point geometric fibre with a cocycle
  `epsilon_y(Frob) in C2`, trivial exactly when a sheet is rational.  Locally, in odd
  characteristic this is the Kummer square test for the descended square of `tau`; in
  characteristic two it is the Artin--Schreier trace test
  `Tr_{F_q/F_2}(kappa)=0` for `T^2+T=kappa`.  Connected `PGL_2/PGL_3` gauge torsors over a finite
  field contribute no separate obstruction; diagonal-label stabilizers remain a distinct finite
  cocycle.  The q=8 `3+3` is therefore not Hilbert--90 failure: the six parents are already
  `F_8`-rational, and the collapse is the deliberate coequalizer of the order-three Frobenius action
  on colours recorded by C478.
- **Still required in C484.**  Write the preceding statements globally with the overlap laws (9),
  include the finite diagonal-stabilizer cocycle, and extract the exact q=8 cycle type from the
  frozen C478 certificate/replay.  No new field enumeration or new local coordinate is needed.
- **Already supplied to C485.**  The pure map for every `r>=4` with a rank-four subtuple is the Gale
  quotient; its ramification, rank drops, camera failures, stabilizer criterion, canonical
  reconstruction steps, and complete-child incidence cut are explicit.  The conic/GRS parent is
  the fixed/ramified specialization, while C475 separately supplies rank-two syndrome recovery and
  the radical marker on rank one.
- **The genuine remaining C485 theorem gap.**  Nothing proved so far implies that at most three
  child-relative centres make `Sigma_T` injective for every finite field and every complete child.
  The exact `3/3/2/3` statement is only the four frozen C478 fibres.  A full theorem as currently
  worded therefore needs either (i) a new uniform base-size/injectivity theorem for the embedded
  fixed-child fibre, or (ii) an explicitly conditional clause, “for any `T` with injective
  `Sigma_T`,” plus the certified at-most-three specialization only for the frozen controls.  No
  synthesis argument may silently promote the finite controls to option (i).

### Larger-conjecture bridge exposed by the fifth-order pass

This is a structural research map, not a novelty or current-literature-status audit.  For an
`[n,n-r]` GRS code, a projective syndrome is deepest exactly when it lies in no span of `r-1`
parity-check columns, equivalently when adjoining it to the `n` columns on the degree-`r-1`
normal rational curve gives an `(n+1)`-arc in `PG(r-1,q)`.  For the full affine support `n=q`, the
standard deep-hole problem is therefore a **unique-completion problem for the punctured normal
rational curve**.

This identifies what the present programme can and cannot supply.

1. **Immediate redundancy-three base theorem.**  Here the normal rational curve is a conic.  A
   `q`-point affine support is the conic with one point removed.  In odd characteristic its only
   arc-completion point is the missing conic point.  In even characteristic the conic nucleus is
   the additional completion point, matching the familiar exceptional shape.  C475's
   radical-point clause and C483's Gale-fixed conic specialization can package this uniformly.  It
   would be a clean base case and geometric dictionary, not by itself a new proof of the general
   conjecture.
2. **The arbitrary-redundancy theorem actually needed.**  Replace the conic by the degree-`r-1`
   normal rational curve and prove that its `q` affine points have only the prescribed completion
   points, with every small-characteristic exception explicit.  Equivalently, prove that every
   other point lies in an `(r-2)`-flat spanned by `r-1` support points.  This incidence/unique-
   completion statement—not multi-view reconstruction—is the direct geometric core of the
   standard RS deep-hole conjecture.
3. **Why C483 does not automatically scale.**  Gale duality sends `n` points in `P^{r-1}` to `n`
   points in `P^{n-r-1}` and is a self-involution only when `n=2r`.  The present quadratic cover is
   the special self-dual case `n=6,r=3`.  A higher-redundancy programme needs a new
   symmetric-power/Grassmannian atlas and its secant-span discriminant; copying the six-point Gale
   involution would be false.
4. **Arithmetic ingredient missing from reconstruction.**  In polynomial language, excluding a
   nontrivial deep hole requires producing `k+1` distinct agreement roots with prescribed leading
   symmetric data.  That needs an existence theorem—explicit construction, additive-combinatorial
   argument, or rational-point/character-sum bound—uniform enough to avoid the diagonals.
   Reconstruction invariants classify a configuration once it exists; they do not supply this
   rational point.
5. **Projective RS covering/deep-hole direction.**  The analogous target is a classification of
   tangent, osculating, and secant completions of the full normal rational curve, including the even
   characteristic exceptional arcs.  C481's quotient-line functor is a rank-three shadow only; a
   full proof needs the higher-dimensional tangent-developable/osculating-strata theorem.
6. **Higher-order MDS/list-decoding direction.**  One-column deep holes must be replaced by the
   simultaneous-extension complex: which several syndrome columns can be adjoined while all
   required minors remain nonzero.  The missing objects are a coherent Grassmannian/Chow-form
   invariant, an exact intersection-rank theorem, and a finite-field existence bound.  C478's
   matching/Gram/Sylow machinery is downstream decoration and cannot substitute for these gates.

The most realistic next larger theorem we can supply is therefore the all-field redundancy-three
punctured-conic completion theorem plus its syndrome/deep-hole translation, followed by a carefully
scoped higher-symmetric-power task.  The general RS conjecture would still require item 2 or item 4;
neither follows from the current reconstruction cover.

## Mystery ledger

| Feature | Closeout status | Exact remaining gap / owner |
|---|---|---|
| Intrinsic meaning of the deck involution | settled | It is Gale association of the `3 x 6` parent matrix. |
| Ramification/branch divisor in odd and even characteristic | settled | Source ramification is the conic determinant `L1=0`; target branch is its Gale-quotient image; the pulled-back discriminant is `L1^2`. |
| Apparent collision/degree-loss divisor | settled | `L0=-det(h4,h5,h6)` is an arc-boundary component, not interior branching. |
| Rank drops and positive-dimensional fibres | settled | They are the explicit cubic sections `K_r intersect V(F)`, with containment criterion `F|K_r=0`. |
| Why C478 needs only `3/3/2/3` centres | settled | The complete-child cut makes the finite restriction map `Sigma_T` injective at exactly those thresholds. |
| Whether a fifth or later pure view selects a sheet | settled in the requested extra-juice pass | No: every additional compatibility row annihilates both Gale sheets; a rank-four subtuple already fixes the pair. |
| A rational sheet-orientation coordinate | settled locally in odd characteristic by the requested second-order pass | `tau=L1/L0^2` satisfies `tau#=-tau`; C484 owns the frame-overlap gluing, and the sign collapses in characteristic two. |
| Characteristic-two additive sheet coordinate | settled locally in the requested third-order pass | `eta=L0/(L0+L0#)` satisfies `eta#=eta+1`; C484 owns overlap gluing and descent. |
| Frame-chart transition law | settled in the requested fourth-order pass | Odd ratios are invariant units; characteristic-two differences are invariant translations with `kappa_j-kappa_i=a_ij^2+a_ij`. |
| Whether q=8's `6=2*3` signatures are automatically a Gale-by-Frobenius product | settled negatively as an inference | Cardinality alone is insufficient because the fixed-child incidence cut need not preserve raw Gale pairs; C484 must compute the actual colour cocycle. |
| Semilinear sheet effectivity criterion | supplied for C484 by the fifth-order pass | Odd characteristic uses the local Kummer square class; characteristic two uses `Tr(kappa)=0`; C484 must globalize with stabilizers. |
| Uniform child-relative at-most-three theorem | genuinely open | C485 must prove a new base-size theorem or state the reconstruction clause conditionally and keep `3/3/2/3` frozen. |
| Standard RS deep-hole conjecture beyond redundancy three | unallocated larger theorem | Needs punctured-normal-rational-curve unique completion or an equivalent distinct-root existence theorem; the six-point Gale cover is not enough. |
| Frobenius-equivariant descent of the Gale pair and q=8 orientation | open | C484 owns the descent cocycle and structural `C3` explanation. |
| All-field synthesis and GRS specialization | open | C485 owns assembly after C484. |

No other C483 mystery remains.

## Vibe check

Excellent: the quadratic ambiguity has collapsed to a classical, rigid involution with a single
meaningful interior ramification divisor.  The exceptional fibres and the small-field child thresholds
now fit one clean picture, leaving descent—not reconstruction geometry—as the next real risk.
