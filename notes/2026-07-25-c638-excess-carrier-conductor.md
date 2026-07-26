# C638: external carrier conductor after secant subtraction

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete negative.  Removing the universally nonzero conductor
triples supported on arc secants does not expose a defect-sensitive remainder.
For every even prime power \(q\), the regular hyperoval in
\(\operatorname{PG}(2,q)\) has defect zero and an explicit family of \(q/2\)
external lines, each containing \(q+1\) maximum centres, on which every
carrier triple has nonzero first conductor.  Thus even the external
first-conductor mass is at least
\[
 \frac q2\binom{q+1}{3}
\]
at defect zero.  No nonnegative external-line or higher-jet excess which
retains this first layer can be bounded by the prescribed-hole defect.

No manuscript or Lean file is changed.

## The renormalized first layer

Let \(K\) be perfect of characteristic two, let \(A\) be an even arc, and use
the square-root carrier notation of C626.  For a primal line \(\ell\), put
\[
 n_\ell=|X_A\cap\ell|,\qquad p=\ell^*.
\]
When \(\ell\) is external to \(A\), \(F_A(p)\ne0\).  If \(n_\ell\ge2\), the
restrictions of \(F_A\) to two distinct carrier directions through \(p\) are
squares, so the ordinary differential of \(F_A\) vanishes at \(p\).  After
dividing by \(F_A(p)\), write the local expansion as
\[
 \frac{F_A(p+w)}{F_A(p)}=1+Q_p(w)+O(w^3),
\]
where \(Q_p\) is the quadratic Hasse term.  Its polarization
\[
 \beta_p(u,v)=Q_p(u+v)+Q_p(u)+Q_p(v)
\]
is an alternating bilinear form on the two-dimensional tangent space.

For three distinct carrier directions \(w_1,w_2,w_3\), choose the standard
relation coefficients
\[
 c_1=[23],\qquad c_2=[31],\qquad c_3=[12].
\]
The C626 conductor satisfies
\[
 \boxed{\quad
 \Omega_p(w_1,w_2,w_3)^2
 =\beta_p(w_1,w_2)[12][23][31].\quad}
\]
Indeed, write \(w_3=\alpha w_1+\gamma w_2\) and expand the quadratic form.
The square terms cancel against the squared relation coefficients, leaving
the polar term.  In particular, if \(\beta_p\ne0\), every triple of distinct
carrier directions through \(p\) has nonzero conductor.

This suggests the genuinely secant-subtracted statistic
\[
 E_{\mathrm{ext}}(A)=
 \sum_{\substack{\ell\text{ external to }A\\ \beta_{\ell^*}\ne0}}
 \binom{n_\ell}{3}.
\]
It is projectively intrinsic: rescaling the Chow product or changing local
coordinates rescales \(\beta_p\) by a nonzero scalar and does not change its
support.  Unlike C627's raw conductor mass, it contains no triple lying on an
arc secant.

## Regular-hyperoval falsifier

Let \(q\) be a power of two and let
\[
 H=\{(t^2,t,1):t\in\mathbf F_q\}
   \cup\{(1,0,0),(0,1,0)\}
\]
be the regular hyperoval.  Every point outside \(H\) is a maximum centre:
each line through it meets \(H\) in zero or two points, and the \(q+2\)
hyperoval points therefore form exactly
\[
 m=\frac{q+2}{2}
\]
secant pairs through the point.  Hence
\[
 X_H=\operatorname{PG}(2,q)\setminus H.
\]

For every \(c\in\mathbf F_q\) with absolute trace one, consider
\[
 \ell_c:\ X+Y+cZ=0.
\]
The line avoids the two points at infinity of \(H\), and its affine
intersection equation
\[
 t^2+t+c=0
\]
has no root in \(\mathbf F_q\).  Thus \(\ell_c\) is external to \(H\), and all
of its \(q+1\) points are maximum centres.  There are \(q/2\) such values of
\(c\).

It remains to check that the external conductor has not disappeared.  At
\(p_c=\ell_c^*\), use the tangent perturbations \(M=X\) and \(N=Y\), and
normalize each Chow factor by its nonzero value on \(\ell_c\).  The two
points at infinity contribute zero to the polar coefficient, while the
affine points give
\[
 \beta_{p_c}(M,N)
 =\sum_{t\in\mathbf F_q}
   \frac{t^3}{(t^2+t+c)^2}.
\]
Choose a root \(r\in\mathbf F_{q^2}\) of
\(r^2+r+c=0\).  Since \(\operatorname{Tr}(c)=1\),
\(r^q=r+1\).  With \(x=t+r\), the exact partial fraction identity is
\[
 \frac{t^3}{(t^2+t+c)^2}
 =
 \frac{r^2}{x}
 \frac{r^3}{x^2}
 \frac{1+r^2}{x+1}
 \frac{(r+1)^3}{(x+1)^2}.
\]
For \(a=r,r+1\),
\[
 \sum_{t\in\mathbf F_q}\frac1{t+a}
 =\frac1{a^q+a}=1,
 \qquad
 \sum_{t\in\mathbf F_q}\frac1{(t+a)^2}=1.
\]
Summing the partial fractions therefore gives
\[
 \beta_{p_c}(M,N)
 =r^2+r=c\ne0.
\]
The external-line polar form is nonzero.  By the local identity above, every
one of the
\(\binom{q+1}{3}\) carrier triples on \(\ell_c\) has nonzero first
conductor.  Distinct lines support distinct collinear triples, so
\[
 \boxed{\quad
 E_{\mathrm{ext}}(H)
 \ge \frac q2\binom{q+1}{3},
 \qquad
 \Delta_{\mathcal H}(H)=0.\quad}
\]

The calculation includes \(q=2\).  It uses only the regular conic and its
nucleus, so the falsifier already respects the strongest available
conic-polarity structure rather than evading it through a nonclassical
hyperoval.

## Outcome and boundary

C638 closes negatively for the proposed excess-conductor route:

- subtracting all secant-supported conductor triples leaves an unbounded
  external contribution at zero defect;
- conic polarity does not upper-bound that contribution by defect, because
  the regular conic--nucleus hyperoval itself supplies the falsifier; and
- passing to the higher local conductor hierarchy cannot repair any
  nonnegative mass which retains the first conductor layer.

Consequently there is no inequality of the form
\[
 E_{\mathrm{ext}}(A)\le C(k,q)\Delta_{\mathcal H}(A)
\]
with finite \(C(k,q)\), nor any positive-defect criterion based only on
vanishing or bounded support of the secant-subtracted first conductor.

The result does not exclude a more selective invariant which subtracts the
regular-hyperoval external baseline as well, uses signed cancellation between
external lines, or compares the conductor to a separate prescribed conic.
Such an invariant would be a new normalization with a new acceptance gate,
not the C638 excess proposed by C627.  C639's odd tangent-twisted carrier is
unaffected.

No novelty or literature-absence claim is made.  The falsifier is an exact
coordinate calculation and has no computational trust dependency.

## `ej` + `tt` closeout

The cheap upgrade is quantitative.  A single external line would already
falsify conductor vanishing at zero defect, but the trace-one pencil gives
\(q/2\) explicit external lines and
\(\frac q2\binom{q+1}{3}\) nonzero external triples.  The obstruction is
therefore not a bounded exceptional residue: it grows through the entire
regular-hyperoval family.

The Tao-style stress test asks whether the failure comes from forgetting the
prescribed conic.  It does not.  The example is the standard conic plus its
nucleus, and the external lines are cut out by the irreducible conic
equations \(t^2+t+c\).  What remains conceivable is not a polarity upper
bound on external mass, but a second renormalization relative to this exact
conic baseline or a signed global reciprocity law.  Neither is free, and
neither is implied by the C626/C627 carrier formalism.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Is there an intrinsic secant-subtracted first-conductor statistic? | **Settled positively:** \(E_{\mathrm{ext}}\) counts precisely the external rich lines with nonzero polarized quadratic Hasse term. |
| Does it vanish or stay bounded at defect zero? | **Settled negatively:** regular hyperovals give at least \(\frac q2\binom{q+1}{3}\) nonzero external triples. |
| Can conic polarity force a defect-sensitive upper bound? | **Settled negatively for this statistic:** the falsifier is itself the regular conic plus nucleus. |
| Can higher jets rescue a nonnegative excess retaining the first layer? | **No:** its first coordinate is already unbounded at zero defect. |
| Could a twice-renormalized or signed invariant still work? | **Open but outside C638:** it would need an explicit regular-hyperoval baseline or a global cancellation law and a new task gate. |
| Does C638 affect the odd-size program? | **No:** C639 remains the next allocated carrier question. |
