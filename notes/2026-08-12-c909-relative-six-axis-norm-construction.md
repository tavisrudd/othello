# C909 — relative six-axis isogeny from group-algebra norms

Date: 2026-08-12

Status: proposed structural repair under hostile audit; no manuscript edit

## Setup

Let `B` be the smooth locus of the nonstandard `A_5` cubic pencil, let
`J/B` be its relative intermediate Jacobian with principal polarization, and
let `G=A_5` act on `J/B`.  Let `Omega` be the six conjugate subgroups
`H~=D_5` (order ten).  On `R^1 J_* Q` the `G`-representation is the
five-dimensional augmentation constituent tensored with a rank-two
multiplicity variation.  In particular the `H`-fixed part has multiplicity
rank two, hence defines an elliptic factor.

## 1. Relative elliptic axes

For `H in Omega`, define the integral group-algebra norm endomorphism

```text
                         n_H=sum_{h in H} h in End_B(J).
```

It is Rosati self-adjoint because the group preserves the principal
polarization and `H=H^{-1}`.  Its image has constant relative dimension one:
on rational homology it is `|H|` times the projector onto the one-dimensional
`H`-fixed coefficient axis, tensored with the rank-two elliptic variation.
Therefore

```text
             E_H=(im n_H)^0 subset J
```

is an elliptic abelian subscheme over `B`, conditional on the standard
constant-rank image theorem for a homomorphism of abelian schemes.  A
pinpoint source or printed proof that the identity component commutes with
base change is required before promotion.

For the primitive inclusion `i_H:E_H-->J` and its Rosati adjoint `q_H`, the
Roulleau normalization gives `q_H i_H=[5]`.  Hence, on rational homology,

```text
 n_H=10 P_H,       i_H q_H=5 P_H,       n_H=2 i_H q_H.
```

The factor two does not change the connected image, but it must be printed:
the norm constructs the axis, while the Albanese-dual quotient supplies its
primitive polarization normalization.

The subgroup `H` acts trivially on `E_H`: it acts trivially on `n_H(J)` by
left multiplication of the norm.  For `g in G`, conjugation sends `n_H` to
`n_{gHg^-1}` and restricts to an isomorphism

```text
                   g:E_H --> E_{gHg^-1}.
```

Fix `H_0` and put `E=E_{H_0}`.  If two elements `g,g'` carry `H_0` to the
same conjugate, then `g'=gh` for `h in H_0`, and `h` acts trivially on `E`.
Consequently the six transports `E~=E_H` are independent of coset
representatives.  This is the coherent relative identification needed by
the fibrewise Gram calculation; it is produced by the group action, not by
choosing periods.

## 2. The integral relative isogeny

Let `i_H:E_H-->J` be inclusion, transported to a map from `E`.  Choose any
five axes and define

```text
 f:E^5 --> J,       f=sum i_H.
```

This is a homomorphism of abelian schemes over `B`.  Fibrewise, the five
coefficient axes form a basis of the augmentation representation, hence
`f` is an isogeny on every fibre and therefore a finite flat isogeny over
the connected base.

The Rosati matrix is constant and `G`-invariant.  Conditional on proving that
the Rosati adjoint of the primitive norm-image inclusion agrees, through the
unique quotient isomorphism, with Roulleau's `D_5` fibration quotient, the
identity `D_H|_S=F_H` and Roulleau intersection calculation
applied on one (equivalently every) fibre, gives diagonal `5`
and off-diagonal `-1`.  Hence as a relative polarization homomorphism

```text
                    f^* Theta_J = 6I_5-J_5.
```

This is an equality of integral homomorphisms to the dual abelian scheme,
not merely rational VHS data.  In particular

```text
                    K=ker(f) subset E^5[6]
```

is a finite etale subgroup scheme of order `6^4` on the complex base, and
is a maximal isotropic half of the discriminant group of the displayed
source polarization.

## 3. Relative graph type

The coefficient matrix `6I-J` is constant.  At `p=2,3` choose once and for
all the integral Jordan chart consisting of a unit line and a rank-four
`p`-block.  The subgroup schemes `K[p^infinity]` form finite sub-local
systems of the corresponding discriminant local systems.

At two, the `A_5`-stable graph choices form

```text
 P^1(F4)=P^1(F2) disjoint_union {omega,omega^2}.
```

The rational triple and exotic pair are distinguished by their stabilizers,
so they are monodromy-stable subsets.  Generic Torelli excludes the rational
triple; connectedness forces `K[2^infinity]` to remain in the exotic pair on
all fibres.  The action on that pair is the sign of the elliptic mod-two
monodromy.  Thus the finite cover selecting its member is the discriminant
cover `r^2=T`; on the signed cubic line `r=9t` selects it.

At three, the simple coefficient heart has scalar commutant, hence the graph
is scalar.  After a finite level cover its scalar label is constant.  Adding
full finite level at two and three therefore gives an algebraic lift of the
signed pencil to one fixed marked finite-etale presentation stack.

No CM deletion is required for existence of `f`; special fibres may acquire
additional endomorphisms or divisor classes but the constructed maps and
kernel remain defined.

## 4. What this closes

If the image-of-norm and relative polarization assertions above pass hostile
audit, this closes the exact gap isolated in the prior normalization audit:

* `f` is constructed integrally from relative automorphisms;
* its polarization is the constant integral Gram form;
* its actual finite kernel is available before adding level;
* the sign cover then marks the actual exotic graph; and
* the signed `A_5` pencil is a shared component of the fixed-data modular
  separation stack, with normalized coarse base the stated open of
  `X_0(3)`.

It still does not automatically construct kernel-linearized relative line
bundles for every rank-one coefficient divisor.  Thus a horizontal minimal
cycle remains behind the separate theta-group/Picard descent gate.

## Hostile gates

1. Verify the integral `A_5` action exists on the relative intermediate
   Jacobian abelian scheme, not only on its rational VHS.
2. Cite the constant-rank image theorem for `n_H` and check that the identity
   component has relative dimension one at every smooth fibre.
3. Check the norm image matches Roulleau's elliptic quotient with the
   normalization used in the Gram `5,-1`; a scalar factor in `n_H` must not
   change the inclusion `i_H`.
4. Prove the five transported inclusions are primitive enough that `f` has
   exactly the asserted pullback polarization, rather than an isogenous
   multiple.
5. Check that `K subset E^5[6]` follows from the polarization homomorphism in
   the chosen convention and that its order is `6^4`.
6. The generic exoticity argument uses the actual `K`, but identifying its
   deck character with the displayed elliptic discriminant still needs the
   monodromy comparison already present in the exact Tate model.
