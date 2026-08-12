# C907 rank-four hypergeometric support bound

**Lane:** `clebsch`

**Status:** theorem-grade conditional structural bound.

## Theorem

Let `X` be a smooth Picard-rank-one Fano threefold with primitive ample
class `H` and index `r`, and assume all of the following.

1. `H^even(X)` is the ambient rank-four space
   `span(1,H,H^2,H^3)`.
2. The small-even quantum D-module is cyclic from the unit and is identified
   by the weighted complete-intersection mirror theorem with a reduced
   factorial hypergeometric scalar operator, with `q` the primitive
   `H`-Novikov variable.
3. After the usual index-one reconstruction normalization, that operator is
   
   \[
   L=\theta^4-C sP(\theta),\qquad s=q/z^r,
   \tag{1}
   \]
   
   where `C!=0`, `deg(P)=4-r`, and the roots of `P` occur as
   `P(theta)=prod_a(theta+a)` with the multiset of `a` invariant under
   `a mapsto 1-a`.

Then the framed small-even connection has

\[
 \nu_6(X)\le2.
\]

This applies to any smooth weighted complete intersection whose
*full small-even* QDM has the rank-four ambient hypergeometric presentation
(1).  It is not a claim about a raw stacky `I`-series of larger order.

## Proof

The factorial numerator for a degree `d` contributes the fractional set
`{1/d,...,(d-1)/d}`, and a weight `w` contributes the same set in the
denominator.  Each set is invariant under `a mapsto1-a`.  After reduction,
the surviving right-hand fractional factors in (1) are therefore paired in
that involution, so

\[
 \sum_a a=\frac{\deg P}{2}.
 \tag{2}
\]

The index is the difference of the unreduced denominator and numerator
degrees.  Reduction preserves it, hence `deg(P)=4-r`.  At `s=infinity`, (1)
has exactly `4-r` zero-exponential branches

\[
 s^{-a}\quad(a\text{ a root parameter of }P),
\]

and `r` irregular branches.  For the latter put `t=s^(1/r)` and insert
`exp(lambda t)t^alpha`.  With `p=4-r` and `A=sum_a a`, comparison of the
`t^3` coefficient after the leading equation gives

\[
 \alpha=A+\frac{p(p-1)/2-6}{r}.
\]

By (2), this is `alpha=-3/2`.  The threefold cyclic lift shifts a scalar
residue by `-3/2`.  Since `t^alpha=q^(alpha/r)z^(-alpha)`, the scalar
`z`-residue of an irregular branch is `-alpha=3/2`, so its framed residue is
zero.  All primitive-sixth support consequently lies among the
`p=4-r<=3` zero-exponential branches.  (For a zero branch `s^(-a)`, the
framed residue is `ra-3/2`.)

More explicitly, the cyclic companion lift has components
`z^(j-3/2) theta^j Phi`, up to constant basis rescaling, so a zero branch
`s^(-a)` has framed residue `ra-3/2`.  In index one the mirror coordinate
replaces `h` by `h+cq`; this adds `cq Id` to `K`, altering an irregular
exponential but not the framed residues.

The involution in (2) pairs the framed residues of `a` and `1-a`: their sum
is `r-3`, hence their formal-monodromy eigenvalues are inverse.  The only
fixed parameter is `a=1/2`; for `1<=r<=4` its framed residue
`r/2-3/2` is integral or half-integral, never primitive sixth.  Thus
primitive-sixth roots occur in pairs.  Hence `nu_6` is even.  An even number
bounded by three is at most two, proving the claim.

## Exact boundary

The index alone does not imply the theorem.  The formal candidate
`X_(3,6) subset P(1,1,1,1,2,4)` has index one but its raw hypergeometric
operator has rank seven, six zero-exponential branches, and a would-be
four-packet; it is non-quasismooth, so there is no smooth QDM.  Thus the
rank-four/full-small-even hypothesis cannot be replaced by a count from an
unreduced weighted `I`-series.

Nor does this control twisted sectors, an odd-sector connection, a
non-hypergeometric Fano, or the operation-framed carrier length.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: weighted
  projective `I`-functions.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz and
  reconstruction normalization.
- Cai, arXiv:2608.01577, Sections 2--3: the framed threefold connection and
  its scalar-to-cyclic convention.

## Mystery ledger

- **Settled:** rank four plus hypergeometric self-duality makes the ordinary
  threefold rank cap a real `nu_6<=2` theorem.
- **Open:** whether every smooth weighted Fano complete intersection with
  ambient rank four satisfies the stated scalar presentation without a hidden
  twisted-sector enlargement.
