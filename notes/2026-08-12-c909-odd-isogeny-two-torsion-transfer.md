# C909 — odd-isogeny transfer of the exotic two-torsion cover

Date: 2026-08-12

Status: focused repair route under source/degree audit; no manuscript edit

## Lemma

Let `phi:E-->E'` be an isogeny of elliptic schemes over a characteristic-zero
base.  If `deg(phi)` is odd, then

```text
                       phi:E[2] ~= E'[2]
```

as finite etale symplectic local systems.  Indeed the kernel has odd order,
so it meets `E[2]` trivially; both sides have rank four, hence restriction is
an isomorphism.  Consequently their projective nonzero two-torsion packets,
their `S_3` monodromy, and the sign/discriminant quadratic covers agree.

Quadratic twisting also preserves the two-torsion local system: the twisting
involution is `[-1]`, which acts trivially on `E[2]`.

## Application target

Van Geemen--Yamauchi construct an explicit elliptic Prym/quotient curve from
the order-five quotient diagram of the cubic discriminant cover and prove it
is isogenous to the elliptic factor of the intermediate Jacobian.  If their
geometric correspondence yields an isogeny of odd degree (as the degree-five
quotient geometry suggests), then the norm-axis elliptic scheme and the
explicit Tate/Prym elliptic scheme have canonically isomorphic two-torsion
local systems after the finite base refinement on which the correspondence
is defined.  No integral isomorphism of elliptic schemes or 3-adic endpoint
calculation is then needed to identify the exotic two-cover.

Under that odd-degree hypothesis, the actual two-primary kernel packet of
the relative six-axis isogeny has the same sign cover as the explicit Tate
model:

```text
                         r^2=T.
```

Since `T=81t^2`, the signed cubic line selects its sheet by `r=9t`.

## Exact source gate

The cited proposition currently visible in the cached source states only
“isogenous”; it does not print the degree in the proposition.  The quotient
diagram has degree five, but Prym functoriality can introduce powers of two
through polarization kernels.  Therefore the oddness of the induced
elliptic isogeny must be computed from the explicit correspondence or cited
from a source before using this transfer.

If its degree is even, the correct fallback is to compare the two-division
polynomials or the induced map on `H^1(-,F_2)` directly.  Equality of
`j`-invariants up to isogeny is insufficient.

## Gain

This isolates exactly how much of the hard integral Prym comparison the
epilogue needs.  The relative graph kernel is constructed by the norm-axis
theorem.  To attach the explicit modular name to its exotic marking, it is
enough to control the parity of one elliptic isogeny, not to identify the
entire integral multiplicity lattice or the Fricke endpoint.
