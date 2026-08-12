# C907 v1: direct generic-QDM proof audit

Date: 2026-08-11

Status: **superseded HOLD**; useful failed-route audit.  The replacement is the
numerical framed small-QDM proof in
`2026-08-11-c907-v1-framed-fractional-support.md`.

## Reason for the replacement

The current manuscript tries to descend primitive-sixth formal monodromy
through the connected-component equivalence in KKPYY Definition 5.21.  Its
bulk gauge lives in an iterated ring such as
`K((u))[[t-t0]]`; unbounded negative `u`-orders prevent specialization of
that gauge at an arbitrary neighboring analytic point.  The printed argument
therefore does not presently prove atomwise HLT-support descent.

The one-step theorem does not need that quotient.  Weak factorization can be
followed directly with the full big quantum differential modules and the
blow-up/projective-bundle isomorphisms.

## Generic formal spectrum

For a smooth projective variety `Z`, let `K_Z` be an algebraic closure of the
meromorphic coefficient field of the irreducible maximal A-model base
`B_Z`, including its Novikov field.  Restrict the full maximal big quantum
connection to the generic point:

\[
 D_Z=(H_Z\otimes K_Z((u)),\nabla_u).
\]

After minimal Levelt--Turrittin ramification, let
`FM_gen(Z)` be the eigenvalue multiset of descended formal monodromy on the
original `u`-disc.  Define the boolean

\[
 s_6(Z)=1
 \quad\Longleftrightarrow\quad
 e^{\pi i/3}\text{ or }e^{-\pi i/3}\text{ occurs in }FM_{gen}(Z).
\]

Scalar extension in the coefficient field, with `u` fixed, does not alter
this support.  Direct sum takes union of formal spectra.

KKPYY Theorems 4.5 and 4.11 identify maximal F-bundle germs after invertible
mirror-coordinate changes and coefficient extensions.  Passing from any
nonempty germ in the irreducible base to its meromorphic field therefore
gives, over common coefficient extensions,

\[
 D_{\operatorname{Bl}_C Z}\cong
 D_Z\oplus D_C^{\oplus(c-1)},
 \qquad
 D_{\mathbf P(V)}\cong D_Z^{\oplus r},
\]

where `c=codim_Z C` and `r=rank(V)`.  Consequently

\[
 s_6(\operatorname{Bl}_C Z)=s_6(Z)\vee s_6(C),
 \qquad
 s_6(\mathbf P(V))=s_6(Z).
\]

This is a statement about entire generic differential modules.  It neither
uses nor implies constancy of HLT support on every connected component in
KKPYY Definition 5.21.

## Low-dimensional endpoint

For every smooth projective `T` of dimension at most two,

\[
 s_6(T)=0.
\]

Indeed:

1. A point has trivial formal monodromy, and projective spaces reduce to
   point modules by the projective-bundle formula.
2. If a curve has nef canonical class, KKPYY Claim 6.15 makes the full
   connection regular singular after the integral grading and half-parity
   correction.  The original formal-monodromy eigenvalues are only `1` and
   `-1`.  The remaining curve is `P^1`.
3. The same claim treats every minimal surface with nef canonical class.
   A minimal surface of Kodaira dimension `-infinity` is `P^2` or ruled and
   reduces to points or curves.  Point blow-ups and KKPYY Theorem 4.5 then
   treat every nonminimal surface.

No connected-component support descent is used: Claim 6.15 is applied at
the generic big-quantum point, and the remaining cases use module
isomorphisms.

## Cubic input and one-step theorem

Cai Proposition 6 works over the fraction field of the full formal big
Novikov ring.  It places factors with exponents

\[
 \rho\equiv -\frac16,-\frac56\pmod{\mathbf Z}
\]

in the even cubic module, hence

\[
 s_6(X)=1
\]

for every smooth cubic threefold `X`.  The full module contains the even
module, so adding the odd summand cannot remove this support.  The
projective-bundle formula gives

\[
 s_6(X\times\mathbf P^1)=1.
\]

If the fourfold `X x P^1` were rational, weak factorization of a birational
map to `P^4` would express it through blow-ups and blow-downs with smooth
centers of dimension at most two.  The low-dimensional endpoint and the
blow-up identity make `s_6` constant along the factorization.  But
`s_6(P^4)=0`, a contradiction.

Thus, conditional on the four gates below,

\[
 \boxed{X\times\mathbf P^1\text{ is irrational for every smooth cubic
 threefold }X.}
\]

## Sharp second-stabilization boundary

For the fivefold `X x P^2`, weak-factorization centers may have dimension
three.  The value `s_6=1` is already carried by the allowed center `X`
itself.  Hence no invariant retaining only the ordinary generic formal
spectrum and its direct-sum multiplicity can prove the `m=2` theorem.
An operation-framed Stokes/Rees placement is genuinely new data and belongs
to v2.

## Independent audit: exact missing gates

The bypass is logically valid, but the cited sources do not establish its
premises.

1. **Generic cubic HLT gate.**  Cai works over the algebraic closure of the
   fraction field of `C((u))[[q,t]]`, not over
   `Frac(C[[q,t]])bar((u))`.  His Remark 5 explicitly distinguishes the
   resulting solution ring from the universal Picard--Vessiot ring of the
   latter ordinary formal differential field.  Proposition 6 therefore does
   not by itself prove primitive-sixth formal monodromy for `D_X` as defined
   above.
2. **Generic comparison gate.**  KKPYY Theorems 4.5 and 4.11 give canonical
   isomorphisms on nonempty analytic domains.  One must still prove that they
   induce the displayed full generic-module isomorphisms after a common
   `u`-preserving differential-field extension.
3. **Generic low-dimensional gate.**  KKPYY Claim 6.15 is stated at a rigid
   even point with vanishing `H^0` coordinate.  Its promotion to the entire
   generic module, after separating the unit-coordinate exponential factor,
   is not printed.
4. **Odd-part gate.**  Cai uses even cohomology.  The full-module formulation
   must either show that the even module embeds as a differential summand or
   treat the odd part without relying on cancellation language.

Under these four gates, the direct weak-factorization proof above is valid
and completely bypasses Definition 5.21 support descent.  At present it is a
research route, not an unconditional proof.

## Manuscript consequence after the gates pass

Replace the atomwise formal-isomonodromy lemma, `nu_6` descent corollary, and
atom-value proposition by:

1. generic formal-spectrum definition and operation lemma;
2. low-dimensional vanishing lemma;
3. the direct weak-factorization proof above.

Keep only a terminal sentence recording the sharp `P^2` ceiling.  Do not put
the double-suspension pilot, pole channels, or an enriched-carrier conjecture
in v1.
