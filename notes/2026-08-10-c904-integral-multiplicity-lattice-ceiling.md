# C904: the integral multiplicity-lattice ceiling

**Scope.** Research note for the Paper-V Annals push.  No manuscript or Lean
source is changed.  This note isolates what is formal in the proposed
``multiplicity two + cyclic defect`` theorem, proves the exact level-three
lattice statements, specializes them to the Winger and cubic pencils, and
states the smallest remaining integral gates.

## Executive verdict

There is a rigorous general theorem here, but its honest hypothesis is sharper
than the first slogan.

> Multiplicity two produces a rank-two elliptic variation.  It does **not**
> produce level structure.  A monodromy-stable cyclic index-`N` defect in the
> rank-two multiplicity lattice produces `Gamma_0(N)`; a horizontal generator
> of the defect quotient upgrades this to `Gamma_1(N)`.

For `N=3`, a quadratic central twist changes the oriented lift
`Gamma_1(3)` into the unoriented lift

```text
<Gamma_1(3),-I> = Gamma_0(3),
```

without changing the projective period map.  This is exactly the
Winger/cubic distinction.  The Winger pencil has the oriented order-three
defect proved integrally by Looijenga--Zi.  The cubic Prym elliptic surface is
its quadratic central twist and hence has only the cyclic subgroup, not a
chosen nonzero point.

The strongest new reduction is integral rigidity.  Once the rational cubic
multiplicity local system is identified with the explicit Prym system and its
monodromy is `Gamma_0(3)`, every stable integral lattice is, up to rational
homothety, one of the two endpoints of a single `3`-adic lattice edge.  Away
from `3` there is no choice.  Thus the frightening ``audit the lattice at
2,3,5`` problem reduces to:

1. prove the rational `A_5`-equivariant comparison;
2. compute one primitive integral period or vanishing cycle to select one of
   two `3`-adic endpoints; and
3. determine the polarization scalar once.

This is a serious reduction, but not yet the missing proof.  The general
formal theorem alone is not an Annals theorem: Popov--Zarhin already own the
rational finite-group-lattice mechanism producing powers of elliptic curves.
The high-ceiling result is the **integral shadow-sister theorem** for the two
geometric pencils, together with the resulting degree `3^5` Fricke isogeny of
intermediate Jacobians or a general geometric criterion that constructs the
defect lattice.

## 1. The precise multiplicity theorem

Let `S` be a connected complex orbicurve, let `G` be a finite group, and let
`H_Z` be a polarized integral variation of Hodge structure of odd weight
`2k+1` on `S`, equipped with a fibrewise `G`-action preserving the
polarization.  Let `V` be an absolutely irreducible rational `G`-module such
that

```text
End_QG(V)=Q
```

and suppose `V` is of orthogonal type.  Fix a nonzero invariant symmetric form
`q_V` on `V`.

Assume the `V`-isotypic rational summand is

```text
H_Q[V] = V tensor M_Q
```

and, after the Tate twist by `k`, the multiplicity variation

```text
M_Q = Hom_QG(V,H_Q[V])(k)
```

has rank two and Hodge numbers `(1,1)`.

Rationally, Schur's lemma gives two forced factorizations:

```text
F^p H_C[V] = V_C tensor F^(p-k) M_C,

Q_H|H[V] = q_V tensor psi_M,
```

where `psi_M` is alternating.  In particular, `M_Q` is a polarized rational
elliptic variation.

The integral hypothesis must be stated separately.

### Definition (admissible multiplicity lattice)

An admissible multiplicity lattice is a monodromy-stable rank-two lattice
`M_Z` in `M_Q` for which a rational rescaling of `psi_M` is primitive and
integral.  Equivalently, after fixing that scale, `(M_Z,psi_M)` is a
unimodular symplectic local system.

This lattice is **not** supplied by the rational tensor decomposition alone.
Candidates such as `Hom_ZG(V_0,H_Z)`, its saturation, and the image of a
geometric cycle lattice can differ at primes dividing `|G|`.

### Theorem A (multiplicity-defect modularity)

Suppose `M_Z` is an admissible multiplicity lattice.  Then:

1. `M_Z` with its Hodge line is a polarized integral VHS of elliptic type and
   defines a holomorphic family of elliptic curves, equivalently a period map
   to the analytic modular stack `M_1,1`.
2. If `M_0` is a monodromy-stable sublocal system of `M_Z` with
   `M_Z/M_0` cyclic of order `N`, the period map factors through the moduli of
   cyclic `N`-isogenies and the monodromy is conjugate into `Gamma_0(N)`.
3. If `M_Z/M_0` has a horizontal generator, the period map factors through
   the moduli of a point of exact order `N` and the monodromy is conjugate
   into `Gamma_1(N)`.
4. If the relevant local monodromies generate the indicated congruence group
   and the extended period map between completed smooth orbicurves is finite
   of degree one, then the completed base is the corresponding modular curve.

#### Proof

The factorization of the Hodge filtration and polarization follows from
`End_QG(V)=Q`: the only `G`-endomorphisms of `V` are scalars, and an
alternating form on `V tensor M` is the symmetric invariant form on `V`
times an alternating form on `M`.  The stated Hodge numbers make `M` a
rank-two weight-one VHS after twisting.  A primitive symplectic integral
lattice gives its elliptic torus fibrewise.

Choose a symplectic basis `(e,f)` of `M_Z` with

```text
M_0 = Z e + N Z f.
```

An element of `SL(M_Z)` preserves `M_0` exactly when its lower-left entry is
zero modulo `N`, which is `Gamma_0(N)`.  It acts trivially on the quotient,
whose generator is the class of `f`, exactly when its lower-right entry is
one modulo `N`; the determinant condition then also makes the upper-left
entry one modulo `N`.  This is `Gamma_1(N)`.  The final assertion is the
degree-one criterion for a finite map of smooth proper curves.  No
finite-group representation theory beyond the extraction of `M` is hidden in
the level statement.

### Central twists

Let `chi:pi_1(S)->{+/-1}` be a quadratic character.  The twist

```text
M_Z(chi)=M_Z tensor chi
```

has the same projectivized local system and the same coarse period map.  It
preserves the cyclic defect but multiplies its generator by `chi`.  Hence an
oriented defect becomes an unoriented one.

For `N=3`, the only units modulo three are `+/-1`, so

```text
+/- Gamma_1(3) = Gamma_0(3).
```

If `chi` is nontrivial and independent of the original image, the twisted
monodromy is exactly `Gamma_0(3)`.  For general `N`, one must say
`+/-Gamma_1(N)`, not `Gamma_0(N)`; the equality is a genuinely small-level
feature.

### Theorem A' (the two-cusp construction of the defect)

The defect need not be guessed if it is visible in two degenerations.  Let
`(M_Z,psi)` be a primitive rank-two symplectic local system, and suppose two
boundary monodromies are

```text
T_1 = tau_e,             T_3 = tau_f^3,
```

where `e,f` are primitive and `psi(e,f)=+/-1`.  Then

```text
im(T_1-I) + im(T_3-I) = Z e + 3 Z f
```

is a canonical cyclic index-three defect lattice.  Both local monodromies act
trivially on its quotient.  In the basis `(e,f)` they are, up to simultaneous
sign and orientation conventions,

```text
[1 -1]                 [1 0]
[0  1]       and       [3 1].
```

These matrices generate `Gamma_1(3)`.  Thus two primitive cusp widths `1,3`
with transverse vanishing cycles construct the oriented level-three datum;
it is not an extra moduli decoration.  A nontrivial central quadratic twist
then gives `Gamma_0(3)`.

This is the geometric version of Theorem A most worth generalizing.  In a
new family, the load-bearing work is to prove primitivity, the intersection
`+/-1`, and that the two displayed local operators act on the **intrinsic**
multiplicity lattice.  Once those are known, the congruence group is forced.

## 2. Integral rigidity at level three

The following elementary lemma is the main new reduction of the integral
problem.

### Theorem B (the two endpoint lemma)

Let `rho` be the standard rational representation of `Gamma_0(3)` on `Q^2`.
Every full `rho(Gamma_0(3))`-stable lattice in `Q^2` is, up to multiplication
by an element of `Q^x`, one of

```text
L_0 = Z e + Z f,
L_1 = Z e + 3 Z f.
```

The two classes are the endpoints of the edge fixed by the `3`-adic Iwahori.
They are exchanged by the Fricke matrix

```text
w_3 = [ 0 -1 ]
      [ 3  0 ],          w_3^2=-3 I.
```

The same two homothety classes are stable under `Gamma_1(3)`, since the two
groups have the same image in `PGL_2`.

#### Elementary proof

For a prime `p != 3`, the closure of `Gamma_0(3)` in `SL_2(Z_p)` is the full
group: the congruence condition at `3` is independent of reduction modulo
`p`, by the Chinese remainder theorem.  A lattice stable under
`SL_2(Z_p)` is homothetic to `Z_p^2`.

At `p=3`, scale a stable lattice `L` so that

```text
L subset Z_3^2,        L not subset 3 Z_3^2.
```

The reduction of the Iwahori is the upper triangular Borel.  The image of
`L` in `F_3^2` is therefore either the invariant line `<e>`, or the whole
space.  In the second case Nakayama gives `L=Z_3^2`.  In the first case `L`
is contained in `Z_3 e+3Z_3 f`; invariance under the two elementary
unipotents and the normalization above force equality.  These are the only
two local classes.  Gluing the local statements over `Q` gives `L_0,L_1`.
The displayed action of `w_3` exchanges them directly.

### Corollary (one-fibre integral test)

Suppose a geometric rank-two rational local system has monodromy exactly
`Gamma_0(3)`.  To identify any geometric integral lattice in it, it is enough
to:

1. fix the overall rational scale using one primitive polarization pairing;
2. decide at one fibre whether the lattice is the `L_0` or `L_1` endpoint.

There is no independent lattice choice at `2` or `5`.  Indeed, reduction of
`Gamma_0(3)` modulo every prime different from `3` is the full natural
`SL_2`, which has no invariant line.  Modulo `3` the image is a Borel and has
one invariant line.  For `Gamma_1(3)` that line has a fixed nonzero vector;
for `Gamma_0(3)` only the line is fixed.

This is the precise sense in which level three is the only multiplicity-level
prime.

### Why the universal Fricke sign is `-3`

The endpoint exchanger also conceptually explains the sign that the exact
Weierstrass calculation detected.  The Fricke matrix is a symplectic
similitude of multiplier three and

```text
w_3^2=-3I.
```

Thus the coarse Fricke operation is an involution only after projectivizing.
On an oriented rank-two lattice its square is the central scalar `-3`.  This
is precisely why the Velu quotient at `T` matches the standard Tate model at
`729/T` only after the quadratic twist by `-3`, rather than by `+3`.

More generally `w_N=[[0,-1],[N,0]]` satisfies `w_N^2=-NI`.  This lattice
identity does not by itself determine the twist of every chosen Weierstrass
model, but it predicts the central square class that an integral Fricke lift
must account for.  At level three the symbolic `c_6` and trace computations
confirm it exactly.

## 3. Exact representation lattices: what they do and do not say

The integral models in the two pencils are deleted permutation lattices, but
their discriminants do not explain the modular level.

### Winger's four-dimensional representation

Looijenga--Zi use

```text
V_0 = Z^5 / Z(1,1,1,1,1).
```

Its dual is the root lattice `A_4`.  On the quotient, the primitive invariant
integral Gram matrix is

```text
5 I_4 - J_4,
```

with determinant `5^3` and Smith form

```text
diag(1,5,5,5).
```

Nevertheless the geometric defect has order `3`, not `5`.

### The cubic five-dimensional representation

For the nonstandard transitive action of `A_5` on the six `D_5` axes, take

```text
W_0 = Z^6 / Z(1,1,1,1,1,1).
```

Its dual is the root lattice

```text
W_0^vee = A_5 = {x in Z^6 : sum x_i=0}.
```

For the rational orthogonal form

```text
b([x],[y]) = x.y - (sum x_i)(sum y_i)/6,
```

the weight lattice `W_0` has discriminant `1/6`, the root lattice has
discriminant `6`, and

```text
W_0/W_0^vee = Z/6.
```

The primitive integral form on `W_0` is `6b`, with Gram matrix

```text
6 I_5 - J_5,
```

determinant `6^4` and Smith form

```text
diag(1,6,6,6,6).
```

The axis projectors introduce a further denominator `5`, through

```text
sum P_i=(6/5)I,       P_i P_j P_i=(1/25)P_i,
```

but that denominator belongs to the representation-factor maps, not to the
rank-two modular local system.

These exact numbers falsify a tempting general theorem: neither the
discriminant of `V_0` nor that of `W_0` determines the level.  Winger has
representation discriminant supported at `5` and level `3`; the cubic has
representation phenomena at `2,3,5` but again only level `3`.

### Symplectic determinant constraint

If an integral orthogonal lattice `(Lambda,q)` of rank `d` and a symplectic
lattice `(M,psi)` of rank two really tensor into a polarized lattice, then

```text
det(q tensor psi) = det(q)^2 det(psi)^d.
```

If `psi` has elementary divisor `m`, this is

```text
disc(Lambda)^2 m^(2d).
```

Thus, if `Lambda tensor M` embeds isometrically with finite index `I` into a
unimodular symplectic lattice of the same rank,

```text
I = |disc(Lambda)| m^d.
```

For the root lattice `A_5` with its root form and a primitive elliptic
lattice this naive index is `6`.  Its discriminant group is `(Z/6)^2`, and a
self-dual overlattice would choose a maximal isotropic subgroup of order six.
In particular it would choose a line modulo two.  Exact `Gamma_0(3)`
monodromy is surjective modulo two and preserves no such line.  Therefore the
cubic integral lattice cannot be obtained by silently tensoring the primitive
`A_5` root form with the elliptic lattice and choosing a monodromy-stable
gluing line.  The two-primary part must be absorbed by the actual polarization
scalar or by a non-split integral `A_5` module.

This is an obstruction to a common shortcut, not an obstruction to the
desired theorem.

## 4. Winger specialization: all integral hypotheses are present

Let `I=A_5` and let `V_0=Z^5/Z1` be the reflection lattice above.  For a
smooth Winger curve `C`, Looijenga--Zi take

```text
M_Z = Hom_ZI(V_0,H_1(C,Z)).
```

They prove that it is free on

```text
U_edge=(1/3)u_edge,       U_trc=u_trc.
```

The geometric cycle lattice is

```text
M_0 = Z u_edge + Z u_trc
    = 3Z U_edge + Z U_trc,
```

so `M_Z/M_0=Z/3`.  Intersection numbers make `(U_edge,U_trc)` a primitive
symplectic basis after the unique positive rescaling.

In the basis used in their Corollary 4.6 the two nodal monodromies are

```text
rho_edge = [1  0],       rho_trc = [1 -3].
           [1  1]                 [0  1]
```

After changing to `(U_trc,-U_edge)`, the defect has the standard form
`Ze+3Zf`, its quotient generator is fixed, and the two matrices generate
`Gamma_1(3)`.  The triple conic supplies the order-three elliptic point; the
two nodal fibres supply cusps of widths one and three.  Looijenga--Zi then
prove the completed period map is the modular isomorphism.

Thus Winger is a theorem-level instance of Theorem A, including the integral
lattice, oriented defect, exact monodromy, and degree-one period map.

## 5. Cubic specialization: exact rational picture, one integral bit open

Let `f:X->B` be the smooth part of the nonstandard `A_5` cubic pencil and put

```text
H_Z = R^3 f_* Z(1).
```

It is a rank-ten unimodular symplectic local system.  Hartlieb's rational
representation argument gives

```text
H_Q = W_5 tensor M_Q,       rank M_Q=2,
```

and hence `J(X)` is isogenous to `E^5`.  The explicit
van Geemen--Yamauchi Prym calculation on this line gives

```text
j(T)=(T+27)(T+3)^3/T,
```

the standard coarse `X_0(3)` map.  The untwisted Tate curve

```text
E_T: y^2+(T+27)xy+(T+27)^2 y=x^3
```

has the point `(0,0)` of order three.  The actual Prym factor is the quadratic
twist by

```text
D(T)=(T+27)(T-729/5).
```

Consequently the point is no longer rational after descent, but its cyclic
subgroup is.  The twist adds `-I` around the order-three boundary and the
chordal boundary.  Projectively the system is still the Winger system; its
integral elliptic model has `Gamma_0(3)` monodromy.

What is not yet proved is the integral comparison

```text
Hom_QA5(W_5,H_Q)  =  H_1(E_T^D,Q)
```

with a specified integral lattice and polarization.  A `j`-identity or a
Picard--Fuchs identity cannot prove that comparison integrally.

Theorem B makes the remaining task small.  Once the rational comparison is
proved, the intrinsic multiplicity lattice inside `M_Q` is, up to scale, one
of the two endpoints `L_0,L_1`.  One primitive intersection calculation at a
single smooth fibre decides which.  The Fricke operator exchanges the
endpoints.

### The degree `3^5` consequence

Let `phi:M_T->M_{729/T}` be the cyclic degree-three map on the elliptic
multiplicity lattices.  If the integral tensor functor is proved compatible
with `phi`, then

```text
id_W5 tensor phi
```

has index `3^5` on the rank-ten cubic lattice.  It therefore induces an
isogeny of intermediate Jacobians of degree `3^5`; compatibility with the
principal polarizations should read

```text
Phi^* lambda_(729/T) = 3 lambda_T.
```

Both the degree and the multiplier are forced once the integral map exists.
They are not consequences of the rational `j`-map alone.

## 6. The Winger--cubic shadow-sister theorem

Put the Winger parameter `w` and cubic parameter `T` in the common coordinate

```text
T=5w-27.
```

On the base with the union of both geometric boundary sets removed, the
strongest justified target is:

> **Integral shadow-sister target.**  The cubic `W_5` multiplicity VHS is the
> Winger `V_4` multiplicity VHS twisted by the quadratic character of
> `D(T)`.  The Winger defect quotient has a horizontal generator and
> monodromy `Gamma_1(3)`; the cubic twist remembers only its cyclic subgroup
> and has monodromy `Gamma_0(3)`.  Their projective period maps are the same
> isomorphism to the common coarse modular curve.

The differential equations, boundary signs, and explicit elliptic curves
already prove the statement for the auxiliary rank-two elliptic systems.
The missing word is **multiplicity**: both auxiliary systems must be compared
to the integral Hom-lattices extracted from the original cohomologies.

### A necessary negative statement

There can be no nonzero direct `A_5`-equivariant correspondence between the
raw relevant cohomologies that identifies their representation factors:

```text
Hom_A5(V_4,W_5)=0.
```

Even after balancing dimensions,

```text
4 W_5  is not isomorphic to  5 V_4
```

as an `A_5`-module.  Therefore a geometric shadow-sister correspondence must
act on the **extracted multiplicity motives** (using group-algebra projectors),
forget the `A_5` action, or introduce an additional carrier.  A claimed
direct equivariant cycle between the total spaces is the wrong target.

This negative result sharpens the algebraic-correspondence gate rather than
weakening the shadow-sister theorem.

## 7. Minimal proof gates

### Gate I: rational multiplicity comparison

Construct the family-level isomorphism

```text
Hom_QA5(W_5,R^3f_*Q(1))
    ~= R^1 pi_*Q tensor chi_D
```

where `pi` is the universal Tate/Prym elliptic family.  The clean routes are a
group-algebra projector on the Prym realization or an `A_5`-equivariant
algebraic correspondence.  Equality of `j` and of scalar differential
equations is strong evidence but is not the desired motivic statement.

### Gate II: one primitive integral comparison

Choose explicitly between

```text
L_0=Ze+Zf,       L_1=Ze+3Zf
```

at one smooth cubic.  It is enough to compute one of:

- a primitive pair of `A_5`-equivariant vanishing cycles and their
  intersection;
- the saturation index of `Hom_ZA5(W_0,H^3)` inside the Prym lattice;
- the kernel and polarization type of one explicit group-algebra isogeny.

No all-parameter integral census is needed after Theorem B.

### Gate III: polarization scalar

Determine the scalar in

```text
Q_H = q_W tensor psi_M
```

for a declared integral `W_5` lattice, and show `psi_M` is primitive on the
selected endpoint.  This simultaneously fixes the product-isogeny degree and
prevents the root/weight lattice shortcut rejected in Section 3.

### Gate IV: Fricke integrality

Prove that the elliptic `3`-isogeny sends the selected cubic endpoint to the
endpoint selected at `729/T`, and that `id_W5 tensor phi` respects the
integral cohomology and principal polarizations.  The payoff is the canonical
degree `3^5` isogeny.

### Gate V: algebraicity

For the highest ceiling, realize the rational comparison by algebraic
correspondences between the extracted idempotent motives.  Do not require or
claim a direct `A_5`-equivariant map `V_4->W_5`, which is impossible.

## 8. What is theorem-grade now

The following can safely be used as proved research statements before the
integral gates close:

1. Theorem A, with the defect lattice as an explicit hypothesis.
2. Theorem B and its one-fibre corollary.
3. The complete Winger specialization, by Looijenga--Zi.
4. The cubic auxiliary elliptic system, its order-three cyclic subgroup,
   quadratic loss of orientation, and `Gamma_0(3)` monodromy.
5. The exact `A_4` and `A_5` lattice discriminants and Smith forms.
6. The obstruction to deriving level from the representation discriminant.
7. The absence of a direct `A_5`-equivariant `V_4`--`W_5` comparison.

The following remain targets:

1. the cubic rational multiplicity/motive comparison;
2. the cubic integral endpoint and polarization scalar;
3. the degree `3^5` intermediate-Jacobian Fricke isogeny;
4. the integral Winger--cubic shadow-sister theorem;
5. an algebraic correspondence between the extracted motives.

## 9. Literature and priority boundary

This note uses four primary sources.  One was read at full text for this
audit; three were read at the stated partial depth.  No global firstness claim
is licensed: MathSciNet was not covered, and the proposed general theorem is
partly a formal packaging of standard representation, VHS, and modular-curve
facts.

1. **Eduard Looijenga and Yunpeng Zi, _Monodromy and period map of the Winger
   pencil_.**  Read depth: **full text**, arXiv version `2109.01810`, shared
   cache key `arXiv:2109.01810`, SHA-256
   `d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`.
   Sections 2--5 are load-bearing.  They own the integral reflection lattice,
   the exact index-three cycle defect, the two Picard--Lefschetz matrices,
   `Gamma_1(3)`, and the degree-one Winger period map.

2. **Vladimir L. Popov and Yuri G. Zarhin, _Finite linear groups, lattices,
   and products of elliptic curves_.**  Read depth: **partial**, arXiv v3
   `math/0505571`, Introduction, Lemma 2.15, and Theorem 3.1; shared cache key
   `arXiv:math/0505571`, SHA-256
   `0a506a0df4a88e9e95a0a72bcc2d395fdbf5d72323baff07e34ea4a05934c4db`.
   They pre-empt the broad rational slogan: for Schur-index-one irreducible
   finite-group lattices, the associated torus is isogenous to a self-product
   of an elliptic curve under their hypotheses.  The Paper-V crown must be the
   canonical integral defect, exact modular group, and geometric comparison,
   not merely `E^n`.

3. **Moritz Hartlieb, _Special subvarieties in the locus of intermediate
   Jacobians of cubic threefolds_.**  Read depth: **partial**, arXiv preprint
   `2304.03214`, Section 5.3, especially Proposition 5.7 and Remark 5.8;
   shared cache key `arXiv:2304.03214`, SHA-256
   `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.
   Hartlieb owns the one-dimensional `A_5` PEL-special locus and the rational
   conclusion `J(X)~E^5`; no integral level or named modular curve is supplied
   there.

4. **Bert van Geemen and Takuya Yamauchi, _On intermediate Jacobians of cubic
   threefolds admitting an automorphism of order five_.**  Read depth:
   **partial**, arXiv `1506.05346`, Sections 1.4 and 2.5--2.6; shared cache key
   `arXiv:1506.05346`, SHA-256
   `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
   They own the Prym realization and the order-five isogeny decomposition from
   which the explicit elliptic model is specialized.  They do not state the
   `A_5` line as `X_0(3)` or identify the integral `A_5` multiplicity lattice.

Bounded web searches on 2026-08-10 used these queries verbatim:

```text
A5 cubic threefold integral cohomology lattice H^3 symplectic representation
icosahedral cubic threefold intermediate Jacobian polarization lattice A5
multiplicity lattice finite group polarized Hodge structure elliptic curve level structure
Winger pencil integral lattice Gamma_1(3) multiplicity
"multiplicity two" "modular curve" finite group Jacobian
"isogeny lattice" modular curve finite group
finite group action polarized variation Hodge structure rank two multiplicity space modular curve
group algebra decomposition Jacobian elliptic factor level structure monodromy
```

They located the sources above, standard group-algebra decomposition papers,
and unrelated modular-level material.  No source located a general theorem
combining a finite-group multiplicity lattice, a cyclic defect, the
`Gamma_1/Gamma_0` central-twist dichotomy, and a degree-one period passport.
This is only a bounded negative.  zbMATH/OpenAlex/Crossref/Semantic Scholar
forward graphs and MathSciNet were not screened, so any future manuscript
novelty sentence needs the full paper-owned audit.

## 10. Recommended theorem ladder

1. **Prove Gate I and Gate II first.**  Together with Theorem B they give the
   integral cubic modular theorem with only one local computation.
2. **Then prove Gate IV.**  The degree `3^5` polarized Fricke isogeny is the
   highest-value concrete consequence and is much stronger than another
   formula for `j`.
3. **State the shadow-sister theorem at the extracted multiplicity level.**
   This is bidirectional and avoids the impossible raw `A_5` comparison.
4. **Only then pursue Gate V.**  An algebraic idempotent-motive
   correspondence would be the Annals-level crown.
5. **For a genuinely general Annals theorem**, replace the assumed defect
   lattice in Theorem A by a geometric construction from two degeneration
   complexes and prove a criterion forcing the two endpoint lattice and the
   modular passport.  Without that construction, Theorem A is a clean
   organizing lemma, not the headline advance.

## Mystery ledger

- **Settled:** multiplicity two and level three are logically independent.
- **Settled:** an index-three defect gives `Gamma_0(3)`; orienting its quotient
  gives `Gamma_1(3)`.
- **Settled:** the Winger/cubic difference is exactly a central quadratic
  twist at the auxiliary elliptic level.
- **Settled:** exact `Gamma_0(3)` monodromy leaves only two integral lattice
  endpoints and no separate `2`- or `5`-adic choice.
- **Settled:** the universal Fricke twist sign `-3` is the central square
  `w_3^2=-3I` of the endpoint exchanger, confirmed by the Weierstrass
  calculation.
- **Settled negatively:** the primitive `A_5` root-tensor shortcut would force
  a forbidden mod-two line.
- **Settled negatively:** no direct `A_5`-equivariant `V_4`--`W_5`
  correspondence can realize the shadow-sister bridge.
- **Open, Gate I:** prove the auxiliary cubic Prym local system is the
  intrinsic `W_5` multiplicity local system as a rational VHS/motive.
- **Open, Gates II--III:** identify one cubic endpoint and the exact
  polarization scalar.
- **Open, Gate IV:** lift Fricke to the polarized degree `3^5` isogeny of
  intermediate Jacobians.
- **Open, Gate V:** construct an algebraic correspondence between the
  extracted multiplicity motives.

**Vibe.**  The integral ceiling is materially lower than it looked: it is one
motivic comparison, one primitive pairing, and one `3`-adic endpoint bit.
That is a plausible hard theorem.  The formal generalization is useful, but
the Annals claim lives in constructing the defect geometrically, not in naming
the congruence subgroup after assuming it.
