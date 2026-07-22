# C475: Veronese determinant atlas and balanced-cycle quotient

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** complete; the four-cycle ratios generate the full edge-label torus quotient, reconstruct
every nondegenerate syndrome on a support of at least five points, and contract exactly the
rank-one conic locus, whose missing datum is its radical point.

## Result

Let `F` be a finite field, let `V=F^2`, and use

```text
nu(x,y)=(x^2,xy,y^2),                 [v,w]=xY-yX
```

for `v=(x,y)` and `w=(X,Y)`.  For `u=(u_0,u_1,u_2)`, define the symmetric bilinear form

```text
beta_u(v,w)=u_2*x*X-u_1*(x*Y+X*y)+u_0*y*Y.              (1)
```

Then, over every characteristic,

```text
det(u,nu(v),nu(w))=[v,w] beta_u(v,w).                    (2)
```

Thus a labelled conic support `S={p_i}` with lifts `v_i`, columns
`h_i=c_i nu(v_i)`, and edge determinants `d_ij(u)=det(u,h_i,h_j)` has

```text
d_ij(u)=c_i*c_j*[v_i,v_j]*beta_u(v_i,v_j).               (3)
```

For a deepest syndrome every factor in (3) is nonzero.  After division by the known support
brackets, the intrinsic balanced coordinates are

```text
A_ijkl(u)
 = (d_ij*d_kl/(d_ik*d_jl))
   /([v_i,v_j]*[v_k,v_l]/([v_i,v_k]*[v_j,v_l]))
 = beta_ij*beta_kl/(beta_ik*beta_jl),                    (4)
```

for distinct ordered indices, where `beta_ij=beta_u(v_i,v_j)`.  They are independent of all
column and lift scalings.

The exact conclusions are:

1. For the torus of arbitrary nonzero edge labels on `K_n`, the `A_ijkl` generate the complete
   rational invariant field under common and vertex scaling.  In fact they separate rational
   point orbits over `F`; there is no square-class obstruction.
2. For `n>=5`, on the open `det(beta_u)!=0`, the labelled collection (4) reconstructs `[u]`
   exactly.
3. On `det(beta_u)=0`, every coordinate (4) equals one.  All rank-one syndromes are therefore
   contracted by the edge-label quotient.  The minimal stratified datum restoring exact
   reconstruction is the radical point `rad(beta_u) in P(V)\S`.
4. Consequently, for the six-point supports used by C476 and C478, four-cycles are a complete
   generic atlas, and the sole global correction is the radical marker on the conic/rank-one
   stratum.  No higher-degree edge monomial is missing.

The last distinction matters: four-cycles generate the full rational torus quotient, but that
quotient itself deliberately forgets which rank-one bilinear form produced a decomposable edge
array.

## 1. Affine chart, infinity, and characteristic two

For `v=(1,s)` and `w=(1,t)`, (1)--(2) give

```text
h(t)=(1,t,t^2),
det(u,h(s),h(t))
 =(t-s)*(u_0*s*t-u_1*(s+t)+u_2).                         (5)
```

For the point at infinity take `v_infinity=(0,1)` and
`h(infinity)=(0,0,1)`.  Then

```text
det(u,h(s),h(infinity))=u_0*s-u_1
                       =[v_s,v_infinity] beta_u(v_s,v_infinity).  (6)
```

Reversing the two support points changes both the determinant and bracket by a sign and leaves
`beta_u` fixed.  In characteristic two the two signs coincide, but the alternating determinant
and bracket identities remain valid.  No division by two, diagonalization, or separability
assumption occurs anywhere in (1)--(6).

For completeness, direct expansion of the left side of (2) is

```text
u_0*y*Y*(x*Y-y*X)
-u_1*(x*Y+y*X)*(x*Y-y*X)
+u_2*x*X*(x*Y-y*X),
```

which is exactly `[v,w] beta_u(v,w)`.  This also proves the homogeneous identity rather than
inferring the infinity case from an affine limit.

## 2. Scaling weights and the exact torus quotient

Under

```text
u -> b*g*u,                    h_i -> a_i*g*h_i,
```

with `b,a_i in F^*` and `g in GL_3(F)`, multilinearity gives

```text
d_ij -> b*a_i*a_j*det(g)*d_ij.                            (7)
```

Thus all common factors can be written as one `lambda in G_m`, and the effective edge action is

```text
(lambda,(a_i)) . x_ij = lambda*a_i*a_j*x_ij.             (8)
```

Let `E` be the edge set of `K_n`.  An exponent vector `m in Z^E` defines an invariant Laurent
monomial exactly when

```text
sum_(j!=i) m_ij=0                 for every vertex i.     (9)
```

The common-scaling equation `sum_E m_e=0` follows integrally by summing (9), which gives
`2 sum_E m_e=0`.  Hence the invariant lattice is

```text
L_n=ker(Z^E -> Z^n),             e_ij |-> e_i+e_j,
rank(L_n)=binom(n,2)-n            (n>=3).                 (10)
```

For four distinct vertices put

```text
C_ijkl=e_ij+e_kl-e_ik-e_jl.                              (11)
```

These vectors generate `L_n` over `Z`, not merely over `Q`.  To see this, take `m in L_n` and a
last vertex `n`.  Its incident coefficients sum to zero.  A vector
`C_nijk=e_ni+e_jk-e_nj-e_ik`, with `i,j,k` distinct, changes the incidences at `n` by
`e_ni-e_nj`.  Integral combinations therefore kill all edges incident to `n`.  What remains lies
in `L_(n-1)`, and induction ends at `L_3=0`.  This proof also covers `n=4` without a saturation
step.

It follows that

```text
F[(G_m)^E]^(G_m^(n+1)) = F[L_n]
```

is generated as a Laurent algebra by the four-cycle monomials and their inverses, and its fraction
field is generated by the ratios in (4).

There is also exact `F`-point orbit separation.  If two nonzero edge arrays have quotient
`z_ij=y_ij/x_ij` and all four-cycle monomials of `z` equal one, choose vertices `1,2,3` and set

```text
lambda=z_12*z_13/z_23,       a_1=1,       a_i=z_1i/lambda.  (12)
```

The four-cycle equations give `z_ij=lambda*a_i*a_j` for every edge.  Formula (12) uses only field
operations, so it introduces no square-root or finite-field descent obstruction.  For `n=3` the
same formula works directly, and there are no invariants.

This proves that four-cycles are the exact answer to the edge-torus question.  A larger monomial
list cannot repair any later collision, because such a collision is already one orbit of (8).

## 3. Raw labelled reconstruction

The linear map

```text
u |-> beta_u
```

is an isomorphism from `F^3` to the symmetric bilinear forms on `V`.  Evaluations on the three
pairs of any three distinct projective points are again an isomorphism.  Indeed, projectively
normalize the three points to

```text
0=(1,0),        infinity=(0,1),        1=(1,1).
```

If

```text
x=beta(0,infinity),       y=beta(0,1),       z=beta(infinity,1),
```

then the syndrome in the coordinate convention (1) is

```text
u=(z-x,-x,y-x).                                           (13)
```

Thus the support-normalized raw edge labels reconstruct the labelled projective syndrome from
one triangle.  This is the lossless coefficient chart.  The balanced quotient studied next is
smaller because it intentionally removes independent vertex gauges.

## 4. Four-cycle reconstruction and its exact exceptional divisor

Write `Delta=det(beta_u)=u_0*u_2-u_1^2`.  For every symmetric bilinear form `beta` on a
two-dimensional space, the two-by-two determinant identity is

```text
beta(a,b)*beta(c,d)-beta(a,d)*beta(c,b)
   =det(beta)*[a,c]*[b,d].                               (14)
```

This is a coordinate identity and is valid in characteristic two.  Applied with four support
points, it gives

```text
beta_ij*beta_kl-beta_ik*beta_jl
   =Delta*[v_i,v_l]*[v_j,v_k].                           (15)
```

Suppose first that `Delta!=0`.  Since the support points are distinct and all `beta_ij` are
nonzero, (15) implies `A_ijkl!=1` and recovers the normalized disjoint-edge product

```text
beta_ik*beta_jl/Delta
   =[v_i,v_l]*[v_j,v_k]/(A_ijkl-1).                      (16)
```

For `n>=5`, these products recover every ratio of edge evaluations.  If two edges share a vertex,
choose an edge on the two remaining vertices, disjoint from both, and divide the corresponding
instances of (16).  If two edges are disjoint, connect them through a third edge and apply the
same argument twice.  Hence (4) determines the projective edge vector `[beta_ij]`; (13) then
determines `[beta]` and `[u]`.

Now suppose `Delta=0`.  The nonzero form `beta` has rank one, so

```text
beta(v,w)=c*ell(v)*ell(w)                                (17)
```

for a nonzero linear form `ell`.  Deepness is exactly `ell(v_i)!=0` for every support point.
Every four-cycle ratio in (4) is therefore one.  Conversely, if one four-cycle ratio is one, (15)
and distinctness of its four points force `Delta=0`.  Thus, when `n>=4`, the rank-one divisor is
detected exactly by the condition that all atlas entries are one.

The missing datum in (17) is the unique point

```text
r(u)=rad(beta_u)=P(ker(ell)) in P(V)\S.                  (18)
```

It transforms covariantly under every conic projectivity, and `[beta]` is reconstructed from it
on the rank-one stratum.  Therefore `(rank flag, four-cycle atlas, radical when rank one)` is an
exact global labelled invariant for `n>=5`.

For `n=4`, the torus theorem remains exact, but the balanced atlas need not reconstruct a
nondegenerate bilinear form; for `n=3` the quotient has no coordinates.  These small-support
exceptions do not enter the six-point C476/C478 domain.

## 5. Projective and semilinear descent

Every projectivity of the nonsingular conic is induced on `V` by some `M in GL_2(F)`.  In the
chosen coordinates its action on the conic is `Sym^2(M)`, and

```text
det(Sym^2(M))=det(M)^3.                                  (19)
```

Allow an immaterial ambient scalar `rho`, and put

```text
u'=rho*Sym^2(M)*u.
```

Equations (2) and (19) give the precise covariance law

```text
beta_u'(M*v,M*w)=rho*det(M)^2*beta_u(v,w).               (20)
```

For a field automorphism `sigma`, apply `sigma` to every coefficient before `M`; then the
right-hand side of (20) is
`rho*det(M)^2*sigma(beta_u(v,w))`.

Let the semilinear map stabilize the support and write

```text
M*sigma(v_i)=r_i*v_(pi(i)).
```

Then

```text
beta_u'(v_(pi(i)),v_(pi(j)))
 =rho*det(M)^2*r_i^-1*r_j^-1*sigma(beta_u(v_i,v_j)),     (21)

A_(pi(i)pi(j)pi(k)pi(l))(u')=sigma(A_ijkl(u)),           (22)

r(u')=M*sigma(r(u))                    on rank one.      (23)
```

Equation (21) separates the common factor, lift gauges, permutation, and Frobenius action;
equation (22) is the promised descent.

For a labelled support of size at least five, the exact equality criteria are consequently:

- **raw labelled equality:** three normalized edge evaluations agree projectively, equivalently
  the reconstructed vectors from (13) agree;
- **balanced labelled equality, rank two:** all four-cycle coordinates agree, equivalently the
  projective syndromes agree;
- **balanced labelled equality, rank one:** the four-cycle coordinates agree automatically, and
  projective syndromes agree exactly when their radical points agree;
- **support-stabilizer equality:** apply the finite permutations induced by `PGL_2(F)_S` to the
  preceding labelled criterion;
- **semilinear equality:** additionally allow the Frobenius powering in (22), with the radical
  transported as in (23).

In particular, two rank-two syndromes are in the same projective-semilinear code-automorphism
orbit exactly when one atlas is obtained from the other by a support-stabilizer permutation and a
common Frobenius power.  For rank one, replace the vacuous atlas comparison by the orbit comparison
of the two radical points in `P^1(F)\S`.

## 6. Canonical comparison procedure and export schema

For C476 and C478, fix a canonical ordering of the support and any nonzero lifts `v_i`.  Store two
coordinates for each four-subset `i<j<k<l`:

```text
A1_ijkl=beta_ij*beta_kl/(beta_ik*beta_jl),
A2_ijkl=beta_ij*beta_kl/(beta_il*beta_jk).                (24)
```

Either compute them directly from `beta_u`, or from determinants by dividing by the identical
bracket ratios as in (4).  The redundant full list is preferable to a lattice basis in a finite
certificate: it is canonical, symmetric under relabeling, and still constant size for six
points.

The exported record is

```text
field:                 canonical finite-field descriptor
support:               canonical ordered projective P1 coordinates
atlas:                 ordered list of (A1_ijkl,A2_ijkl)
rank:                  1 or 2
radical:               canonical projective P1 coordinate, only when rank=1
support_action:         induced support permutation
frobenius_power:        semilinear comparison exponent
```

Comparison is exact and does not require a field census:

1. compare field and support records;
2. enumerate only the already-defined support stabilizer and Frobenius actions;
3. for rank two, compare the transformed atlas lists;
4. for rank one, compare the transformed radical points.

The `rank` field is redundant when at least one four-subset exists—rank one is exactly the all-one
atlas—but retaining it prevents a downstream implementation from silently treating that divisor
as an ordinary collision fibre.  A raw three-edge reconstruction witness from (13) may be stored
for checking, but is not part of the invariant record.

## 7. Boundaries and downstream consequences

The theorem uses the plane-arc/codimension-three MDS syndrome dictionary only to identify deep
syndromes with the nonvanishing domain of (3).  The quotient calculation itself is an exact
split-torus calculation.  Projective equivalence, lift/column gauge, support permutation, and
semilinear equivalence are kept separate throughout, following the quotient discipline of C314.
The scaling law (7) is also the precise reason raw recovery coefficients cannot be treated as
monomial invariants.

No finite field or support has been enumerated.  The theorem does not assert that the support
stabilizer is transitive on the omitted conic points; C476 must compute those radical-point orbits
as part of its bounded six-support atlas.  C478 may use the same schema on the frozen controls.
Higher-order-MDS, cocycle, Weil-roof, and modular/Picard discriminators remain gated: the only
collision exposed here is the elementary rank-one contraction, and its exact missing datum is
already (18).

## Evidence boundary

This is a proof-only result.  The load-bearing inputs are the determinant expansions (2), (5),
and (6); the integral lattice induction (9)--(11); the explicit rational-point transporter (12);
the two-dimensional determinant identity (14); and the reconstruction formulas (13) and (16).
No CAS output, finite census, or untracked computational artifact supports any claim.

## Extra-juice closeout and mystery ledger

- **Settled — whether four-cycles miss an edge-lattice generator.**  They do not: (11) generates
  the full integral kernel, and (12) proves exact finite-field orbit separation without a square
  class.
- **Settled — whether quotient equality reconstructs the syndrome.**  It does on the rank-two
  open for every support of size at least five, by (16) and the three-edge inverse (13).
- **Settled — the exceptional divisor.**  The full rank-one/conic locus contracts to the all-one
  atlas.  Its unique missing datum is the radical point outside the support; no higher-degree edge
  monomial can distinguish points already identified by the torus quotient.
- **Settled — characteristic two and infinity.**  Both are included directly in the homogeneous
  identities; there is no parity exception or omitted affine boundary.
- **Open for C476 — radical-point orbit profiles.**  The theorem reduces the exceptional fibre for
  each six-point support to the action of its semilinear stabilizer on `P^1(F)\S`.  C476 owns those
  bounded orbit computations.
- **No other genuine C475 mystery remains.**  The quotient lattice, reconstruction threshold,
  degeneracy divisor, and semilinear descent are exact.

## Vibe check

Strong: the proposed four-cycle atlas is exactly right generically, and its sole failure is cleaner
than a mysterious scalar-atlas collision.  It contracts the omitted conic points for a structural
rank-one reason, with a one-point radical correction that is cheap and canonical downstream.
