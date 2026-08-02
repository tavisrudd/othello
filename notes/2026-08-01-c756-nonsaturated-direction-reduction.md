# C756 — nonsaturated direction-cover obstruction

**Lane**: \`clebsch\` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The nonsaturated branch has a uniform algebraic normal form, and its first
case is impossible. Let \(A\) be a conic-filling \(k\)-arc over an odd
prime-power field, let \(P\in A\), and let \(\ell\) be an external line through
\(P\) which is not a chord. Put \(B=A\setminus\{P\}\) and \(n=k-1\). After
taking \(\ell\) as the line at infinity and \(P\) as the vertical direction,
write

\[
 B=\{(x_i,y_i):1\le i\le n\},\qquad x_i\ne x_j,
\]

and define the direction discriminant

\[
 D_P(T)=\prod_{i<j}
 \bigl((x_i-x_j)T-(y_i-y_j)\bigr).
\]

Then

\[
 \boxed{D_P(T)=(T^q-T)E_P(T)},\qquad
 \deg E_P=\delta:=\binom{k-1}{2}-q. \tag{1}
\]

At a direction \(t\in\mathbb F_q\), if \(\mu_t\) chords of \(B\) have that
direction, then they form a matching and

\[
 \operatorname{ord}_t E_P=\mu_t-1. \tag{2}
\]

Consequently every nonsaturated conic-filling arc with \(q>3\) satisfies the
strict uniform obstruction

\[
 \boxed{\binom{k-1}{2}\ge q+1.} \tag{3}
\]

This strictly improves the spare-line bound for every \(k\). It does **not**
finish C756: positive slack \(\delta\ge1\) remains possible, and the first
\(k=9\) boundary has \(\delta=1\) at \((q,k)=(27,9)\). The existing
exhaustive classification rules that field
out, but no all-field contradiction for \(E_P\ne1\) is proved here.

## 1. The direction-cover lemma

Every point of \(\ell\) is off the conic and hence is covered by a chord of
\(A\). A chord through \(P\) meets \(\ell\) only at \(P\). Therefore every
point of \(\ell\setminus\{P\}\) lies on a chord whose two endpoints belong to
\(B\). Conversely no chord of \(B\) meets \(\ell\) at \(P\), since that would
make \(P\) and its two endpoints collinear. Thus \(B\), viewed in the affine
plane with line at infinity \(\ell\), determines exactly the \(q\) directions
other than \(P\).

Choose affine coordinates in which \(P\) is the vertical direction. No two
points of \(B\) have the same first coordinate. The factor indexed by
\(i<j\) in \(D_P\) vanishes precisely at the direction of the chord \(P_iP_j\).
Hence \(D_P(t)=0\) for every \(t\in\mathbb F_q\). The roots of \(T^q-T\) are
simple, so \(T^q-T\) divides \(D_P\), proving (1).

If two chords with the same direction shared an endpoint, they would be the
same affine line and three points of \(B\) would be collinear. The chords of
any one direction therefore form a matching. Since each chord contributes
one distinct linear factor of \(D_P\), its root multiplicity is \(\mu_t\);
division by \(T^q-T\) proves (2). In particular

\[
 1\le\mu_t\le\left\lfloor\frac{k-1}{2}\right\rfloor,
 \qquad
 \sum_{t\in\mathbb F_q}(\mu_t-1)=\delta. \tag{4}
\]

The argument is projective: changing the affine coordinate on
\(\ell\setminus\{P\}\) changes (1) only by the corresponding binary-form
coordinate change and a nonzero scalar.

## 2. The chord-product form

Let

\[
 H_A=\prod_{1\le i<j\le k} L_{ij}
\]

be the product of equations of all chord lines of \(A\), and restrict it to
the spare line \(\ell\). Its degree is \(b=\binom{k}{2}\). At \(P\) it has
multiplicity \(k-1\), contributed by the chords through \(P\). At every other
rational point \(X\in\ell\), its multiplicity is the number \(\mu_X\) of
chords of \(B\) through \(X\), which is at least one by covering.

The binary Moore form

\[
 M_\ell(U,V)=U^qV-UV^q
\]

is, up to scalar, the product of the \(q+1\) rational point factors on
\(\ell\). Therefore

\[
 H_A|_\ell=M_\ell\,L_P^{\,k-2}\,R_{P,\ell},
 \qquad \deg R_{P,\ell}=\binom{k-1}{2}-q=\delta. \tag{5}
\]

The residual roots of \(R_{P,\ell}\) are exactly the excess chord
concurrences on \(\ell\setminus\{P\}\), with multiplicities \(\mu_X-1\). In the
affine coordinate used in §1, \(R_{P,\ell}\) is \(E_P\) up to a nonzero
scalar. Formula (5) is the coordinate-free form of (1), and it records the
full information left after the crude inequality
\(\binom{k-1}{2}\ge q\).

## 3. Zero slack is impossible

Suppose \(\delta=0\). Then

\[
 q=\binom{k-1}{2}=\frac{n(n-1)}2.
\]

Since \(q=p^h\) is odd, \(n(n-1)=2p^h\). If \(n\) is even, the coprime
integers \(n/2\) and \(n-1\) have product \(p^h\); one must be \(1\), giving
only the degenerate \(n=2\) case. If \(n\) is odd, the coprime integers \(n\)
and \((n-1)/2\) have product \(p^h\); one must be \(1\), and the only
nondegenerate possibility is \(n=3,q=3\). The first C756 pass already
classifies \(q=3\) and finds no conic-filling arc. Hence \(\delta\) cannot
vanish, which proves (3).

This arithmetic step is small but essential: the ordinary covering-line
count does not arithmetically exclude equality for arbitrary plane orders,
while the prime-power order and
the fact that only \(q\), rather than \(q+1\), directions are covered make
equality impossible here.

## 4. What the reduction does and does not solve

The reduction isolates the exact remaining object. For every spare external
line through every arc point, the pair directions of the other \(k-1\) points
cover \(\mathbb F_q\), and all repeated directions are encoded by one
degree-\(\delta\) polynomial \(E_P\). The conic-external condition adds that
every one of the corresponding affine secants is external to the fixed
conic.

The direction factorization alone cannot finish the theorem. Small arcs
covering a line are a classical and constructible phenomenon; Ng--Wild's
line-cover framework supplies the adjacent counting theory. The additional
load-bearing input here is the quadratic-character condition on the *line
intercepts*, not merely on the direction roots of \(D_P\). Van de Voorde's
exterior-set analysis and the Blokhuis--Seress--Wilbrink classification
concern the saturated half-size exterior-point setting and do not supply this
nonsaturated direction--intercept coupling.

The next viable gate is therefore precise:

> combine Segre's tangent-product relation with (5) to force a character
> condition on \(R_{P,\ell}\), then use a Weil bound whose degree is \(\delta\)
> rather than \(\binom{k-1}{2}\).

A direct character sum on the unreduced chord product has degree about \(q\)
and is too weak. The Moore quotient is the mechanism that removes those
forced \(q\) roots before any character estimate.

Relevant adjacent sources:

- S.-L. Ng and P. R. Wild, *On k-arcs covering a line in finite projective
  planes*, Ars Combinatoria 58 (2001), 289--300.
- G. Van de Voorde, *On sets without tangents and exterior sets of a conic*,
  arXiv:1201.0484; cached bytes SHA-256
  \`45891ed7688d6ab3677a57060ac69c876007104b7479944744724e69fc46f9a7\`.
- A. Blokhuis, Á. Seress, and H. A. Wilbrink, *Characterization of complete
  exterior sets of conics*, Combinatorica 12 (1992), 143--147; authoritative
  page scans are in the shared \`bsw-1992\` cache.

No novelty or priority claim is made, and no manuscript files were edited.

## 5. EJ + TT closeout

The cheap upgrade is the coordinate-free factorization (5): it shows that
the spare-line inequality is not merely a count but the degree statement for
a canonical residual concurrence divisor. The Tao compression is to divide
out the forced Moore form before applying any character sum. This changes
the relevant degree from roughly \(q\) to the actual slack \(\delta\), and it
identifies the only regime in which Weil can plausibly beat the trivial
estimate.

The acceptance check is internal and exact: the roots and their
multiplicities on both sides of (5) agree point by point, their degrees agree,
and the zero-slack arithmetic uses only coprimality of consecutive integers.
No computational claim is used.

## 6. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Why a spare line forces all \(q\) remaining directions | settled | deleting its arc point leaves the direction-cover in §1 |
| Equality \(\binom{k-1}{2}=q\) | settled negatively | only the arithmetic pair \((q,k)=(3,4)\) survives, and the existing exact classification removes it |
| Meaning of the slack \(\delta\) | settled | degree and total multiplicity of the residual concurrence divisor \(R_{P,\ell}\) |
| Positive slack, including the first \(k=9\) boundary \((q,k,\delta)=(27,9,1)\) | open | derive a character constraint on \(R_{P,\ell}\) from Segre tangent products and conic externality |
| A raw general-position character sum | settled as the wrong scale | it retains the \(q\) forced direction roots; divide out the Moore form first |
