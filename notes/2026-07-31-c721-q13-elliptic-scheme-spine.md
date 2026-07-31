# C721 report — q13 elliptic-scheme spine

**Lane:** `clebsch`

**Date:** 2026-07-31

**Verdict:** complete; both targeted computational conclusions now have
structural proofs, while the original computations remain independent checks.

## Orbit-span proof

For internal points of the conic `XZ-Y^2=0`, set

```text
Delta(P) = y_P^2 - x_P z_P,
beta(P,Q) = 2 y_P y_Q - x_P z_Q - z_P x_Q,
rho(P,Q) = beta(P,Q)^2 / (Delta(P) Delta(Q)).
```

The six off-diagonal rho values are `0,1,3,9,10,12`.  If `A_r` denotes the
corresponding elliptic-scheme adjacency matrix, conic polarity identifies
`A_0` with the passant/internal incidence matrix `M`, up to row order.  Exact
intersection counts give over `F_2`

```text
A0^2 = I + A9 + A10 + A12,
A0 Ar = 0                 for r = 9,10,12,
A9^2 = A10,  A10^2 = A12,  A12^2 = A9.
```

Put `B=A9`.  Then `im(B)` lies in `K=ker(A0)`.  If `x` lies in `K` and
`Bx=0`, the first identity gives

```text
0 = A0^2 x = (I+B+B^2+B^4)x = x.
```

Thus `B` is injective on the known 36-dimensional code `K`; consequently
`im(B)=K`, and `B,B^2,B^4` all have rank 36.  The four 91-word orbit support
matrices have Grams

```text
(N1^T N1, N2^T N2, N3^T N3, N4^T N4)
    = (A9, A9, A12, A10).
```

Their rows already lie in `K`, so every orbit spans `K`.  Binary rank
elimination is no longer part of this proof.

## Automorphism proof

The pair/triple concurrence colors recover the six rho relations exactly.
Use the anchors

```text
P0=(1:0:2), P1=(1:1:7), P2=(1:0:7), P3=(1:1:3).
```

The first triple has relation pattern `(10,3,9)`.  There are
`78*14*2=2184` ordered triples of this type: `A10` has valency 14 and
`p^(10)_(3,9)=2`.  Its stabilizer in `PGL(2,13)` is trivial, so the group acts
simply transitively on these triples.  Relative to a fixed triple, `P3` is the
unique point with signature `(3,1,9)`, and the four anchor relations resolve
all 78 internal points.  Hence an association-scheme automorphism can be
normalized to fix the first triple, after which it fixes `P3` and every point.
The full group is therefore `PGL(2,13)`.

The source audit found that Hollmann--Xiang supplies the elliptic association
scheme and its relation language, but not the exact automorphism conclusion
needed here.  The manuscript therefore uses the self-contained anchor proof
rather than attributing that conclusion to the citation.

## Changed proof and trust surface

- `papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex`
  now contains the scheme algebra, span proof, and anchor rigidity proof.
- `papers/clebsch-rigidity/check_q13_tangent_code.py` now verifies the full
  rho/concurrence dictionary, integer intersection rows, four Gram identities,
  polarity identification, anchor counts, unique fourth anchor, and resolving
  signatures.  The old rank and stabilizer-chain checks remain.
- `verification/computational_companion_trust.json` separates the finite q13
  distance/minimum-layer classification from the structural span/automorphism
  claim; its verifier accepts the split claim surface.

The aggregate companion replay passed.  The standalone q13 checker passed,
the Python sources compile, JSON validation passed, and the warning-free
XeLaTeX build produced an 11-page PDF.

The global trust-manifest constructor currently stops on a concurrent C712
axiom-audit terminal mismatch in Paper III Lean files.  This does not affect
the C721 proof or companion replay; C726 owns the final aggregate trust refresh
after the intervening phases freeze their statement surfaces.

## Handoff

C722 may use the rho dictionary, the exact intersection rows, and the
mod-two relation algebra directly.  C724 may use the same relation names when
compressing orbit and concurrence certificates.  Neither successor should
recompute the four orbit spans or the automorphism group.
