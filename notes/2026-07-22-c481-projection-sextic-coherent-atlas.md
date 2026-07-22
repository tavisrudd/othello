# C481 — projection-sextic and coherent-atlas theorem

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete.

## Result

Let `F` be a field, let `V` be three-dimensional over `F`, and let

```text
A=(P(h_1),...,P(h_6)) subset P(V)
```

be a labelled six-arc.  A point `P(u)` is deep for `A` when it lies on no secant of `A`.  Put
`W_u=V/Fu` and let `bar(h_i)` be the image of `h_i` in `W_u`.

The determinant atlas has a coordinate-free interpretation valid in every characteristic:

> **Projection-sextic theorem.**  A volume form `omega in det(V)^*` induces the nondegenerate
> alternating form
>
> ```text
> beta_u(bar(x),bar(y)) = omega(u,x,y)                  (1)
> ```
>
> on `W_u`.  The point `P(u)` is deep exactly when the six projected points
> `P(bar(h_i))` are defined and pairwise distinct.  On that locus,
>
> ```text
> d_ij(u)=omega(u,h_i,h_j)=beta_u(bar(h_i),bar(h_j))    (2)
> ```
>
> and the thirty balanced determinant ratios are exactly the projective moduli coordinates of
> the labelled projected sextic in `P(W_u)`.  More precisely, the bracket-array quotient is
> naturally and explicitly isomorphic to labelled `M_0,6(F)`:
>
> ```text
> {nonzero rank-two Pluecker arrays (x_ij)}
> ---------------------------------------------------  =  Conf_6(P1(F))/PGL_2(F).       (3)
> x_ij -> lambda*a_i*a_j*x_ij
> ```
>
> The isomorphism, its inverse, the diagonal `S6` action, and every semilinear transporter are
> defined over the prime field.  No division by two occurs.

After quotienting by diagonal `S6`, (3) is the moduli point of the associated split squarefree
binary sextic.  Independent `S6` quotienting in each syndrome fibre is a different, strictly
coarser functor.

## 1. The quotient-line alternating form

Define (1) using arbitrary lifts `x,y in V`.  If `x` is replaced by `x+c u`, alternation of the
volume form gives

```text
omega(u,x+c u,y)=omega(u,x,y),
```

and similarly in the second argument, so `beta_u` is well-defined on `W_u`.  If
`beta_u(bar(x),-)` vanishes, then `omega(u,x,y)=0` for every `y`.  Hence `u,x` are linearly
dependent and `bar(x)=0`; thus `beta_u` is nondegenerate.  Replacing `u` or `omega` by a nonzero
scalar only rescales `beta_u`.

The projected point `P(bar(h_i))` is undefined exactly when `P(u)=P(h_i)`.  For distinct `i,j`,

```text
P(bar(h_i))=P(bar(h_j))
iff u,h_i,h_j are linearly dependent
iff P(u) lies on the secant P(<h_i,h_j>).               (4)
```

Since the six-arc has at least two points, the undefined case is already contained in the secant
condition.  Equation (4) proves the exact equivalence between deepestness and six distinct
quotient-line points.  Equation (2) is then the definition of `beta_u`, not a coordinate
factorization.

This argument also explains the characteristic-two case.  There, an alternating form is symmetric
as a bilinear form, but it still satisfies `beta(x,x)=0`; the quotient, nondegeneracy, and secant
arguments above are unchanged.

## 2. Exact identification with labelled `M_0,6`

Let `B_6(F)` be the set of arrays `x_ij in F^*`, for `1 <= i < j <= 6`, satisfying the rank-two
Pluecker relations

```text
x_ij*x_kl - x_ik*x_jl + x_il*x_jk = 0                 (5)
```

for all `i<j<k<l`.  Extend by `x_ji=-x_ij` and `x_ii=0`.  Let

```text
T=(G_m x G_m^6),
(lambda,a_1,...,a_6).x_ij=lambda*a_i*a_j*x_ij.         (6)
```

Six nonzero vectors `q_i in F^2` with distinct projective classes give an element of `B_6(F)` by
`x_ij=det(q_i,q_j)`.  Rescaling the six lifts gives the factors `a_i`; changing the common basis
of `F^2` gives the factor `lambda=det(g)`.  Therefore brackets define a map

```text
Conf_6(P1(F))/PGL_2(F) --> B_6(F)/T(F).                 (7)
```

It has an explicit inverse.  Given `x in B_6(F)`, set

```text
q_1=(1,0),             q_2=(0,x_12),
q_k=(-x_2k/x_12,x_1k),  3 <= k <= 6.                  (8)
```

Then `det(q_1,q_k)=x_1k`, `det(q_2,q_k)=x_2k`, and (5) for `(1,2,i,j)` gives

```text
det(q_i,q_j)
  =(x_1i*x_2j-x_2i*x_1j)/x_12
  =x_ij.                                                   (9)
```

Every pair is distinct because every `x_ij` is nonzero.  Replacing `x` by its `T(F)` orbit changes
only the six lifts and a common `GL_2(F)` basis, while two presentations of the same projective
configuration differ in exactly that way.  Thus (7) and (8) are mutually inverse on `F`-points.
They are also natural under field extension, so (3) is an isomorphism of orbit functors, not just a
counting coincidence.

For each `i<j<k<l`, write

```text
R^1_ijkl = x_ij*x_kl/(x_ik*x_jl),
R^2_ijkl = x_ij*x_kl/(x_il*x_jk).                       (10)
```

These are the two stored coordinates for each of the fifteen four-subsets.  C475 proves
integrally that their four-cycle exponent vectors generate the complete invariant Laurent lattice
of (6), and gives a field-rational reconstruction of a torus transporter.  Consequently the full
thirty-coordinate list separates `T(F)` orbits exactly over every field; no square root or hidden
descent choice is required.

There is also a direct moduli inverse from the stored ratios.  Normalize the first three projected
points to

```text
p_1=infinity=(0:1),   p_2=0=(1:0),   p_3=1=(1:1).
```

If `p_m=(1:t_m)` for `m=4,5,6`, then the universal bracket calculation gives

```text
R^1_123m=(t_m-1)/t_m,      R^2_123m=t_m-1,
t_m=1+R^2_123m.                                         (11)
```

Formula (11) works unchanged in characteristic two and reconstructs the labelled moduli point.
The other twenty-seven stored values are its symmetric, coordinate-free redundancy.  Thus the
phrase “the determinant atlas is a projected sextic” is an equality of moduli objects with an
explicit inverse, not an analogy.

Forgetting the labels replaces the six roots by the split squarefree binary form

```text
f_A,u(X,Y)=product_i ell_i(X,Y),                         (12)
```

where `ell_i` vanishes at `p_i`.  Its scalar class is independent of the choices, and its
`PGL_2` class is exactly the diagonal-`S6` quotient of (3).

## 3. The four atlas functors

Let

```text
C_6(F)=Conf_6(P1(F))/PGL_2(F)
```

be the labelled colour space.  The symmetric group acts by relabelling, with
`(pi.c)_i=c_(pi^-1(i))`; `Aut(F)` acts coefficientwise.  These actions commute.  For a labelled
parent `A`, let `L(A)` be its deep-centre set and define

```text
c_A : L(A) -> C_6(F),
u |-> [P(bar(h_1)),...,P(bar(h_6))].                    (13)
```

Equations (2), (7), and (10) identify `c_A(u)` with the determinant atlas.  The following
constructions are therefore unambiguous:

1. **Pointwise unlabelling** retains the function

   ```text
   c_A^pt : L(A) -> C_6(F)/S6,    u |-> S6.c_A(u).       (14)
   ```

   The relabelling in (14) may be chosen independently at every centre.

2. **Diagonal coherence** retains

   ```text
   c_A^coh in Map(L(A),C_6(F))/S6_diag,                 (15)
   ```

   where one permutation acts simultaneously on every value.  This is the intrinsic datum of one
   unlabelled parent set projected from several centres.

3. **Frobenius colour-orbits** apply, for `F=F_(p^e)` and `G=Gal(F/F_p)`, the pointwise map

   ```text
   c_A^col(u)=G.c_A(u) in C_6(F)/G.                     (16)
   ```

   Since `G` commutes with `S6`, (16) may also be applied after pointwise unlabelling.  Crucially,
   the point `u` in the domain is held fixed while only its colour is quotiented.

4. **Galois-equivariant atlases** retain the coloured map together with simultaneous Galois
   transport on its domain and codomain.  For `tau in G`,

   ```text
   tau.(L,c)=(tau L, u' |-> tau_C(c(tau^-1 u'))).       (17)
   ```

   One may then take the orbit of the whole object under `G`, or retain it as a `G`-object.  One
   does not replace each colour separately by (16).

Thus (16) and (17) are different functors.  The former erases relative Frobenius orientation; the
latter transports that orientation coherently.

## 4. Projective-semilinear transporter law

Fix coordinates compatible with `omega`, and let the semilinear map be

```text
g(x)=M*tau(x),       M in GL_3(F), tau in Aut(F).        (18)
```

Suppose lifts for a target labelled configuration satisfy

```text
g(u)=b*u',        g(h_i)=a_i*h'_(pi(i)).                (19)
```

Then

```text
d'_(pi(i),pi(j))(u')
 =det(M)*b^-1*a_i^-1*a_j^-1*tau(d_ij(u)).               (20)
```

The common and vertex factors in (20) vanish in (10), giving

```text
R^s_(pi(i),pi(j),pi(k),pi(l))(u')
 =tau(R^s_ijkl(u)),                 s=1,2.              (21)
```

Equivalently, `g` induces a `tau`-semilinear isomorphism `W_u -> W_u'` carrying the six projected
points and their labels as stated.  On a whole family,

```text
c_(gA)(g u)=pi.tau_C(c_A(u)).                           (22)
```

Equations (20)--(22) prove covariance of all four functors.  They also show exactly where the
permutation, field automorphism, common determinant factor, and six lift gauges occur; none is
silently absorbed into another quotient.

## 5. Stabilizer criterion and the C478 specialization

Fix a literal child `L` and let `Gamma=Stab_PGammaL(V)(L)`.  Let `S(A)` be any one of the
pointwise, coherent, colour-orbit, or equivariant signatures above, with the domain transported as
in (17).  Covariance gives

```text
S(gA)=g.S(A),              g in Gamma,                  (23)
```

and hence

```text
Stab_Gamma(A) subset Stab_Gamma(S(A)).                  (24)
```

The induced orbit map

```text
Gamma/Stab_Gamma(A) -> Gamma/Stab_Gamma(S(A))           (25)
```

is bijective exactly when

```text
Stab_Gamma(S(A))=Stab_Gamma(A).                         (26)
```

This is the exact parent-recovery criterion.  It applies equally to (14) and (15), but their
stabilizers can be radically different.

C478 is now a direct specialization rather than a determinant-specific phenomenon.  Its frozen
certificate proves:

| fixed-child family | pointwise signatures | coherent equivariant signatures | least selected fibres |
|---|---:|---:|---:|
| q=8, `|L|=4` | 1 | 6 | 3 |
| q=9 cube, `|L|=6` | 1 | 8 | 3 |
| q=9, `|L|=7` | 1 | 2 | 2 |
| q=11 matching, `|L|=12` | 1 | 22 | 3 |

For the pointwise quotient, the colour fibres are precisely child point-orbit partitions, so its
stabilizer is all of `Gamma` and (26) fails maximally.  For the coherent Galois-equivariant
signature, the certificate's `6/8/2/22` singleton parent signatures say exactly that (26) holds.
At q=8, additionally applying the colour-only quotient (16) changes six signatures to two fibres
of size three; retaining (17) leaves six singletons.  The lost datum is exactly the
`Gal(F_8/F_2)=C3` orientation.

This corollary consumes C478's already-frozen enumeration; it does not extend its four finite
classification domains.  Conversely, the theorem above is proved algebraically and does not rely
on those counts.

## 6. Boundaries and downstream consequence

The theorem identifies one syndrome fibre and every quotient operation on families of such
fibres.  It does not reconstruct an ambient six-arc from several abstract projections.  The C482
generic-degree preflight shows why that distinction matters: two and three abstract projections
have generic residual dimensions two and one, while four are the first dimensionally possible
pure reconstruction input.  C478's smaller thresholds are child-relative and retain the complete
ambient child as side information.

**Fable scope caution.**  The quotient template in Sections 3 and 5 measures finite discrete
losses: independent permutations, diagonal permutations, and finite Frobenius colour orbits.
C482's positive-dimensional pure-reconstruction fibres are a different, geometric loss type.  An
RS instantiation of the finite template applies to the child-relative clause, where the ambient
child cuts the candidate set to a finite fibre; it is never a substitute for C482's source/target
dimension counts or its residual-family theorem.

No conic equation, binary-form discriminant formula, finite-field census, matching decoration,
Gram calculation, or modular carrier enters C481.

## Evidence boundary

The general result is a proof from multilinear algebra, the Pluecker relations, and C475's proved
integral edge-torus quotient; it has no computational acceptance premise.  The only numerical
specialization is the already-committed C478 certificate.  From `/home/tavis/src/othello`, its
paper-facing evidence replays with

```bash
python3 notes/2026-07-22-c478-exceptional-family-controls.py --check
python3 notes/2026-07-22-c478-exceptional-family-controls-replay.py
sha256sum -c notes/2026-07-22-c478-exceptional-family-controls.sha256
```

Those artifacts certify only the four fixed-child rows quoted above.  They do not certify the
general theorem, whose proof is given in Sections 1--5.

## Extra-juice closeout

Three useful consequences cost no additional hypothesis or computation.

First, the arc condition is needed for the coding-theoretic word “deep,” but not for the moduli
identity.  Sections 1--4 apply to any six distinct ambient projective points and any centre outside
all fifteen joining lines.  Collinear triples among the six parent points do not affect the
quotient-line bracket proof.  Thus C481 is a projection theorem for arbitrary point
configurations on its natural open locus, with six-arcs as the required coding specialization.

Second, (11) gives a global minimal labelled coordinate model

```text
M_0,6(F) = {(t_4,t_5,t_6) in F^3 :
            t_m notin {0,1}, t_m != t_n for m != n},    (27)
```

after the unique normalization of labels `1,2,3` to `infinity,0,1`.  Hence each fibre contributes
exactly three independent moduli coordinates.  The thirty-coordinate atlas is preferable for a
symmetric certificate, but C482 may use the three `R^2_123m` values for elimination without losing
information.

Third, the forgetful maps

```text
Map(L,C_6)/S6_diag  -->  Map(L,C_6/S6),
Galois-equivariant family --> pointwise Frobenius-colour orbit       (28)
```

are `Gamma`-equivariant.  Therefore

```text
Stab_Gamma(A)
 subset Stab_Gamma(coherent signature)
 subset Stab_Gamma(pointwise signature),              (29)
```

with the analogous inclusion after erasing Frobenius colours.  Coherence cannot lose information
relative to independent fibrewise unlabelling, and a colour-only quotient cannot gain it.  The
strict inclusions measured by C478 are instances of this general quotient lattice.

## Mystery ledger

- **Settled:** the determinant atlas has no extra hidden datum beyond the projected labelled
  sextic; (8) and (11) give explicit inverses.
- **Settled:** characteristic two creates no exceptional atlas geometry; the construction is
  exterior-algebraic and integral.
- **Settled:** q=8's `3+3` collapse is not a failure of the projected-sextic identification; it is
  caused by applying the lossy colour-only functor (16).
- **Settled by the extra-juice pass:** the symmetric thirty-coordinate record contains exactly
  three independent labelled moduli parameters, and every information-loss operation factors
  through the equivariant quotient maps (28).
- **Settled by the Fable scope check:** finite quotient blindness and positive-dimensional
  reconstruction failure are distinct mechanisms; only the child-relative clause fits the finite
  template.
- **Open, owned by C482:** determine the generic degree and rational inverse of the first possible
  four-centre projection map in every characteristic.  The preflight proves full differential rank
  only at exact characteristic-zero/101 and characteristic-two witnesses.
- **Open, owned by C483:** characterize geometrically when ambient-child side information cuts a
  two- or three-centre residual family to a point.

## Vibe check

Strong.  The atlas now has a standard moduli identity, an explicit inverse, and exact functorial
bookkeeping.  The main downstream risk is no longer ambiguity about the invariant; it is the
genuine four-centre birationality and exceptional-divisor problem isolated by C482--C483.
