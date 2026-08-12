# C909 — orbit-axis relative isogeny theorem

Date: 2026-08-12

Status: conditional structural theorem candidate under hostile audit; no
manuscript, PDF, mirror, or Lean edit

## The theorem

Let `A/S` be a polarized abelian scheme over a connected normal
characteristic-zero base, with an action of a finite group `G` by polarized
automorphisms.  Let `V` be an absolutely irreducible rational `G`-module with
`End_QG(V)=Q`, and suppose

```text
 H_1(A_s,Q)[V] = V tensor M_s
```

for a rank-two elliptic-type variation `M`.  Let `Omega` be a transitive
`G`-set of subgroups `H` such that:

1. `dim_Q V^H=1` for every `H in Omega`;
2. the fixed lines `V^H` span `V`; and
3. the stabilizer `H` acts trivially on its fixed line (automatic) and the
   orbit map has no residual character on the corresponding abelian image.

Put `n_H=sum_{h in H}h` and let `E_H=(im n_H)^0`.  Then:

* each `E_H/S` is an elliptic abelian subscheme;
* conjugation canonically transports `E_H` to `E_{gHg^-1}`; after fixing one
  subgroup, the transports are independent of coset representatives;
* if `H_1,...,H_d` are axes whose fixed lines form a basis of `V`, the sum of
  inclusions gives a relative isogeny

```text
                     f:E^d --> A[V];
```

* once primitive geometric inclusions of the norm images are supplied, its
  pulled polarization is their integral Rosati Gram matrix, constant over
  `S`; and
* its finite kernel is therefore constructed as a subgroup scheme before
  any torsion-level trivialization.

If the whole rational homology of `A` is the `V`-isotypic part, then
`A[V]=A`.  The construction is functorial under base change and requires no
choice of periods or rational idempotent denominators.

## Proof

The norm `n_H` is an integral endomorphism of the abelian scheme and is
Rosati self-adjoint.  On rational homology it is `|H|` times projection to

```text
                     V^H tensor M_s,
```

which has dimension two.  The image dimension is therefore constantly one.
The identity component of the scheme-theoretic image of a homomorphism of
abelian schemes of constant rank is an abelian subscheme and commutes with
base change; this gives `E_H`.

The image inclusion is primitive: the quotient `A/E_H` is an abelian scheme,
so `H_1(A,Z)/H_1(E_H,Z)` is torsion-free fibrewise.  The raw norm need not be
the primitive Rosati projector; in the cubic specialization it is twice the
primitive endomorphism.  Only the connected image and transporter
identifications are taken from the norm.

Conjugation sends `n_H` to `n_{gHg^-1}`.  If `g'=gh` gives the same coset,
then `h n_H=n_H`, so `h` is the identity on the image and the induced
transport is unchanged.  Thus the orbit supplies canonical identifications
with a fixed `E`.

On rational homology the sum map from the selected copies of `E` is the
tensor product of `M_s` with the map from the selected fixed lines to `V`.
The latter is an isomorphism by the basis hypothesis.  Hence `f` is a
fibrewise isogeny.  A homomorphism of abelian schemes which is a fibrewise
isogeny has finite flat kernel and is an isogeny over `S`.

The Rosati pairing between two inclusions is an endomorphism of `E`.  On the
generic non-CM locus it is an integer.  Its value is locally constant in the
integral endomorphism local system, hence constant on `S`; equality extends
over special fibres.  This gives the pulled polarization matrix integrally.
The kernel and its self-duality follow from the equality of polarization
homomorphisms.

## Six-axis specialization

For `G=A_5`, `V=W_5`, and `Omega` the six conjugate `D_5` subgroups,
`dim W_5^H=1`; the six lines are the augmentation axes and any five form a
basis.  Roulleau's intersection calculation identifies the primitive
elliptic inclusions' Gram matrix as `6I-J`.  The theorem therefore constructs

```text
              f:E^5 --> J,       f^*Theta=6I_5-J_5
```

relatively over the smooth cubic pencil.  Its kernel is the actual geometric
finite subgroup scheme to which the exotic/scalar graph classification
applies.

The last sentence is conditional on identifying the Rosati adjoint quotient
of the norm-image inclusion with Roulleau's relative `D_5` elliptic fibration;
that lemma fixes the primitive scalar and makes `D_H|_S=F_H` applicable.

## Exact normalization issue

The norm `n_H` itself restricts as multiplication by `|H|` on the invariant
rational subspace, while the primitive Rosati endomorphism `i_H q_H` may
restrict by a smaller integer (five in the cubic normalization).  This does
not affect the image abelian subscheme `E_H`, but it means the Gram matrix
must be computed from the **primitive inclusion** `i_H:E_H-->A`, not from the
raw norm endomorphism.  The theorem therefore separates two jobs:

1. the integral norm constructs and coherently identifies the image; and
2. the geometric quotient/polarization computation fixes the primitive
   inclusion and its Gram scalar.

For the cubic family, Roulleau's elliptic fibration and the Albanese dual map
provide that primitive inclusion fibrewise.  Publication requires stating
that these maps globalize over the smooth base and agree with the norm-image
subschemes; no period integral is needed.

## Reach

This theorem is independent of the cubic minimal-class criterion.  It is a
general bridge from finite-group orbit geometry to integral elliptic-power
families.  Combined with finite-etale graph saturation it gives a two-step
machine:

```text
 subgroup fixed-line orbit
      => relative integral elliptic-power isogeny and actual kernel
      => finite-etale spectral packet
      => saturated Lefschetz divided powers.
```

This is a more intrinsic and reusable mechanism than starting with an
assumed coefficient isogeny.  It should be stated separately only if the
constant-rank image and primitive-inclusion hypotheses are printed cleanly.

## Hostile gates

1. Pinpoint the abelian-scheme image theorem and its base-change hypotheses.
2. In a family with CM fibres, use the generic integer Rosati matrix and
   extension in the homomorphism scheme; do not delete an alleged finite CM
   locus.
3. Prove the geometric quotient supplies primitive inclusions globally.
4. The fixed lines must form a rational basis, not merely span after an
   inseparable or torsion specialization.
5. This constructs the kernel but does not automatically identify its graph
   chart; the finite packet classification supplies that second step.
