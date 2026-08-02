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

Combining zero- and defect-one closure below, every nonsaturated
conic-filling arc satisfies the uniform obstruction

\[
 \boxed{\binom{k-1}{2}\ge q+2.} \tag{3}
\]

This improves the spare-line bound by two for every \(k\). It does **not**
finish C756: residual slack \(\delta\ge2\) remains possible.

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

Let \(S_P=\{t:\mu_t\ge2\}\) and put \(s_P=|S_P|\). Since every root of
\(D_P\) is rational, the quotient is completely split:

\[
 E_P(T)=c\prod_{t\in S_P}(T-t)^{\mu_t-1}. \tag{5}
\]

Consequently

\[
 s_P\le\delta,\qquad
 \sum_{t\in S_P}\mu_t=\delta+s_P\le2\delta. \tag{6}
\]

Thus at least \(q-\delta\) directions are represented by a unique chord,
and all repeated directions together contain at most \(2\delta\) chords.
This is the **defect-localization lemma**: the positive slack is supported on
a degree-\(\delta\) effective rational divisor, rather than being dispersed
among the \(q\) forced directions. Hypothetically, for \(\delta=1\), exactly
one direction
contains exactly two (necessarily disjoint) chords and every other direction
contains exactly one; §3 excludes that arithmetic case globally.

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
 \qquad \deg R_{P,\ell}=\binom{k-1}{2}-q=\delta. \tag{7}
\]

The residual roots of \(R_{P,\ell}\) are exactly the excess chord
concurrences on \(\ell\setminus\{P\}\), with multiplicities \(\mu_X-1\). In the
affine coordinate used in §1, \(R_{P,\ell}\) is \(E_P\) up to a nonzero
scalar. Formula (7) is the coordinate-free form of (1), and it records the
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
vanish.

This arithmetic step is small but essential: the ordinary covering-line
count does not arithmetically exclude equality for arbitrary plane orders,
while the prime-power order and the fact that only \(q\), rather than
\(q+1\), directions are covered make
equality impossible here.

### Defect one is also impossible

Suppose \(\delta=1\). Then

\[
 q=\binom n2-1=\frac{(n-2)(n+1)}2. \tag{9}
\]

After dividing the even factor by \(2\), the two displayed factors have
greatest common divisor dividing \(3\). Since their product is the odd prime
power \(q=p^h\), either one factor is \(1\), or \(p=3\) and both factors
are powers of \(3\).

If \(n\) is even, put \(a=(n-2)/2\), so the other factor is
\(n+1=2a+3\). The unit-factor case gives \(a=1\), hence
\((q,n)=(5,4)\). Otherwise \(a=3^r\). For \(r\ge2\),
\((2a+3)/3=2\cdot3^{r-1}+1\) is congruent to \(1\pmod3\), so it cannot
be a positive power of \(3\); for \(r=1\) one gets
\((q,n)=(27,8)\).

If \(n\) is odd, put \(a=n-2\), so the other factor is
\((a+3)/2\). The unit-factor case gives only the even field \(q=2\). In
the remaining case \(a=3^r\); the same reduction modulo \(3\) forces
\(r=1\), giving \((q,n)=(9,5)\). Thus

\[
 \delta=1\quad\Longrightarrow\quad
 (q,k)\in\{(5,5),(9,6),(27,9)\}. \tag{10}
\]

The certified all-\(k\) classification through \(q=43\) excludes all three
cases. Hence defect one is impossible, \(\delta\ge2\), and (3) follows.

### Defect two is genuinely geometric

For \(\delta=2\),
\[
 q=\binom n2-2,\qquad (2n-1)^2-8q=17. \tag{11}
\]
Unlike (9), this is Pell-type and does not factor into two almost-coprime
integers. Already
\[
 (n,q)=(6,13),(7,19),(10,43),(11,53)
\]
gives four prime fields. The first three are excluded by the certified
classification through \(q=43\); the first presently unclassified
defect-two boundary is therefore
\[
 (q,k,\delta)=(53,12,2). \tag{12}
\]

Equations (5)--(6) leave exactly two local shapes on every spare line:
\[
 R_{P,\ell}=cL_X^2
 \quad\text{or}\quad
 R_{P,\ell}=cL_XL_Y\quad(X\ne Y). \tag{13}
\]
The first means one direction containing three disjoint chords; the second
means two directions, each containing two disjoint chords. Thus the residual
binary quadratic is split over \(\mathbb F_q\), and its discriminant is a
square or zero.

This exposes a sharper next gate than a generic degree-two Weil bound:
compute the discriminant square class of \(R_{P,\ell}\) from Segre's
tangent-product relation and the anisotropic quadratic \(Q|_\ell\). If that
comparison forces the nonsquare class of \(Q|_\ell\), complete splitting in
(13) gives the contradiction immediately.

One exploratory parameter sweep was discarded because its output exceeded
the repository command-hygiene bound. No statement here relies on it; the
four displayed substitutions in (11) are direct.

## 4. What the reduction does and does not solve

The reduction isolates the exact remaining object. For every spare external
line through every arc point, the pair directions of the other \(k-1\) points
cover \(\mathbb F_q\), and all repeated directions are encoded by one
degree-\(\delta\) polynomial \(E_P\). The conic-external condition adds that
every one of the corresponding affine secants is external to the fixed
conic.

As the spare line varies through a fixed arc point \(P\), formula (7) gives a
canonical divisor-valued defect map

\[
 \ell\longmapsto \operatorname{div}(R_{P,\ell}). \tag{8}
\]

Its support consists of intersections of disjoint chords of
\(A\setminus\{P\}\). Before defect-one closure, every spare line would contain
a unique such diagonal point, and distinct spare lines would give distinct
points. The same divisor map in degree at least two is now the smallest
geometric carrier on which Segre's tangent-product relation can act.

The direction factorization alone cannot finish the theorem. Small arcs
covering a line are a classical and constructible phenomenon; Ng--Wild's
line-cover framework supplies the adjacent counting theory. The additional
load-bearing input here is the quadratic-character condition on the *line
intercepts*, not merely on the direction roots of \(D_P\). Van de Voorde's
exterior-set analysis and the Blokhuis--Seress--Wilbrink classification
concern the saturated half-size exterior-point setting and do not supply this
nonsaturated direction--intercept coupling.

The next viable gate is therefore precise:

> combine Segre's tangent-product relation with (7) to force a character
> condition on the completely split divisor \(R_{P,\ell}\), then use a Weil
> bound whose degree is \(\delta\)
> rather than \(\binom{k-1}{2}\).

A direct character sum on the unreduced chord product has degree about \(q\)
and is too weak. The Moore quotient is the mechanism that removes those
forced \(q\) roots before any character estimate.

Relevant adjacent sources:

- S.-L. Ng and P. R. Wild, *On k-arcs covering a line in finite projective
  planes*, Ars Combinatoria 58 (2001), 289--300.
- G. Van de Voorde, *On sets without tangents and exterior sets of a conic*,
  arXiv:1201.0484; cached bytes SHA-256
  `45891ed7688d6ab3677a57060ac69c876007104b7479944744724e69fc46f9a7`.
- A. Blokhuis, Á. Seress, and H. A. Wilbrink, *Characterization of complete
  exterior sets of conics*, Combinatorica 12 (1992), 143--147; authoritative
  page scans are in the shared `bsw-1992` cache.

No novelty or priority claim is made, and no manuscript files were edited.

## 5. EJ + TT closeout

The first cheap upgrade is the coordinate-free factorization (7): it shows that
the spare-line inequality is not merely a count but the degree statement for
a canonical residual concurrence divisor. The Tao compression is to divide
out the forced Moore form before applying any character sum. This changes
the relevant degree from roughly \(q\) to the actual slack \(\delta\), and it
identifies the only regime in which Weil can plausibly beat the trivial
estimate.

The second cheap upgrade is defect localization (5)--(6). A future character
argument need not control all chord directions: at most \(\delta\)
exceptional directions and \(2\delta\) participating chords carry every
deviation from a one-factor-per-direction cover. The divisor map (8),
now of degree at least two, is the natural finite-geometric input for the next
Segre comparison.

The third cheap upgrade is the factorization (9). Prime-power arithmetic
reduces defect one to exactly \(q=5,9,27\), so the existing certified bounded
classification closes it globally. The new first arithmetic frontier is
\(\delta=2\), equivalently
\[
 (2n-1)^2-8q=17,
\]
a generalized Ramanujan--Nagell shape rather than another consecutive-factor
identity.

The fourth cheap upgrade is the split-quadratic dichotomy (13). Arithmetic
cannot close this layer: the first unclassified case is already \(q=53\).
But defect two carries a new binary invariant, the discriminant of
\(R_{P,\ell}\). Its forced square class is the most economical possible
target for the Segre--conic comparison.

The acceptance check is internal and exact: the roots and their
multiplicities on both sides of (7) agree point by point, their degrees agree,
and the zero-slack arithmetic uses only coprimality of consecutive integers.
Defect-one closure uses the already certified all-\(k\) classification at
exactly \(q=5,9,27\); no new computational claim is introduced.

## 6. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Why a spare line forces all \(q\) remaining directions | settled | deleting its arc point leaves the direction-cover in §1 |
| Equality \(\binom{k-1}{2}=q\) | settled negatively | only the arithmetic pair \((q,k)=(3,4)\) survives, and the existing exact classification removes it |
| Meaning of the slack \(\delta\) | settled | degree and total multiplicity of the residual concurrence divisor \(R_{P,\ell}\) |
| Distribution of positive slack | settled | at most \(\delta\) exceptional directions and \(2\delta\) chords; \(E_P\) is completely split as in (5) |
| Defect one | settled negatively | prime-power arithmetic leaves only \(q=5,9,27\), all excluded by the certified bounded classification |
| Defect two | open, sharply reduced | \(R_{P,\ell}\) is either \(2X\) or \(X+Y\), hence has square/zero discriminant; compare this with the nonsquare discriminant of \(Q|_\ell\). First unclassified case: \((q,k)=(53,12)\) |
| Residual slack \(\delta\ge3\) | open | derive the general character constraint on the completely split divisor \(R_{P,\ell}\) |
| A raw general-position character sum | settled as the wrong scale | it retains the \(q\) forced direction roots; divide out the Moore form first |
