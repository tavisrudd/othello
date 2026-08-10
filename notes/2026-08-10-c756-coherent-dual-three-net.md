# C756 coherent supports are dual 3-nets

**Lane:** `clebsch` · **Date:** 2026-08-10 · **Scope:** structural
saturated-internal theorem; no manuscript edit

## Verdict

The coherent saturated branch has a uniform incidence structure that was
hidden by the Paley-eigenvector presentation.  If
\(Z=\{z_1,\ldots,z_k\}\subset\mathbb F_{q^2}\),
\(k=(q+3)/2\), is the oriented support of a hypothetical saturated-internal
arc, then
\[
 \mathcal A=Z,\qquad \mathcal B=Z^q,
 \qquad
 \mathcal C=\{\text{directions of character }-c\}\cup\{d_0\},
 \quad c=(-1)^{(q+1)/2},                                      \tag{1}
\]
is a dual 3-net of order \(k\) in \(PG(2,q)\).  Here
\(d_0=\ker\operatorname{Tr}_{q^2/q}\) is the trace-zero direction and
the quadratic character of a direction means the common
\(\chi_{q^2}\)-value of its nonzero vectors.

This immediately proves the saturated-internal classification over every
odd **prime** field:
\[
 \boxed{q\text{ prime and }q>5\quad\Longrightarrow\quad
        \text{no saturated-internal conic-filling arc}.}       \tag{2}
\]
Indeed, the collinear-component theorem of Blokhuis--Korchmaros--Mazzocca
puts \(Z\cup Z^q\) on a conic when the net order is at most the
characteristic.  The conic must split into two lines; the two components
occupy one line each.  They are then cosets of an additive or multiplicative
subgroup.  Over \(\mathbb F_q\) with \(q\) prime, the additive case is
impossible and the multiplicative case requires
\(k\mid(q-1)=2k-4\), hence \(k\mid4\).  The only saturated endpoint is
\(k=4,q=5\).

The extension-field seam is now exact rather than philosophical: for
\(q=p^e\), \(e>1\), the net order \((q+3)/2\) exceeds the characteristic,
so the cited conic theorem does not apply.  The next all-\(q\) target is to
extend that theorem for this special quadratic-character direction
component, not to census another fixed size.

## 1. The three components

Identify the affine plane \(AG(2,q)\) with the two-dimensional
\(\mathbb F_q\)-space \(\mathbb F_{q^2}\).  Sign coherence gives, for
\(i\ne j\),
\[
 \chi_{q^2}(z_i-z_j)=c,
 \qquad
 \chi_{q^2}(z_i-z_j^q)=-c,                                  \tag{3}
\]
while the diagonal conjugate difference satisfies
\[
 \chi_{q^2}(z_i-z_i^q)=c.                                  \tag{4}
\]
Every nonzero element of \(\mathbb F_q\) is a square in
\(\mathbb F_{q^2}\), so quadratic character is constant on each affine
direction.  Exactly \((q+1)/2=k-1\) directions have character \(-c\).
Moreover \(z-z^q\) is trace-zero for every \(z\), and a nonzero trace-zero
vector \(\delta\) has
\[
 \chi_{q^2}(\delta)=
 \delta^{(q^2-1)/2}=(-1)^{(q+1)/2}=c.                       \tag{5}
\]
Thus the trace-zero direction \(d_0\) is distinct from the \(k-1\)
directions of character \(-c\), and (1) has size \(k\).

For every pair \((z_i,z_j^q)\), its joining line meets \(\mathcal C\):
it has a character-\(-c\) direction if \(i\ne j\), and direction \(d_0\)
if \(i=j\).  Such a line contains no second point of either affine
component.  For a character-\(-c\) line this follows because the difference
of two points of \(Z\), or of two points of \(Z^q\), has character \(c\).
For a trace-zero line, a second point of (say) \(Z\) together with the
original conjugate point in \(Z^q\) would give an off-diagonal cross
difference of character \(c\), contradicting (3).  Hence any line meeting
two of the three components meets all three, once each.  This proves that
\(\{\mathcal A,\mathcal B,\mathcal C\}\) is a dual 3-net of order \(k\).

This deduction uses the full coherent sign pattern, but neither a bounded
census nor the Paley balance theorem.  The Paley eigenvector is a spectral
shadow of the net's parallel classes.

## 2. Prime-field conic forcing

Theorem 5.1 of Blokhuis--Korchmaros--Mazzocca states that a dual 3-net of
order \(n\), with one component on a line, has its other two components on a
conic, provided \(n\le p\) in positive characteristic \(p\).  In the present
dual net, \(\mathcal C\) lies on the line at infinity.  If \(q=p\) is prime,
then
\[
 n=k=(q+3)/2\le q=p,                                        \tag{6}
\]
so a conic over \(\mathbb F_q\) contains \(Z\cup Z^q\).

There are \(2k=q+3\) distinct affine points in this union.  A nonsingular
conic over \(\mathbb F_q\) has at most \(q+1\) rational points, and a conic
that splits only over \(\mathbb F_{q^2}\) has at most one rational point.
Consequently the conic is the union of two \(\mathbb F_q\)-lines
\(L_1\cup L_2\).  The lines are distinct, since a single projective line
contains only \(q+1<q+3\) rational points.

The components segregate between the two lines.  Since \(k\ge4\), one of
the lines contains two points of \(Z\).  Its direction therefore has
character \(c\).  It cannot also contain a point of \(Z^q\): among two
points of \(Z\), at least one pairing with that point is off-diagonal, whose
difference would have character \(-c\).  Thus all of \(Z^q\) lies on the
other line.  Applying the same argument there shows that all of \(Z\) lies
on the first line.

For completeness, the standard two-line classification is elementary.
If the component lines are parallel, affine normalization to \(X=0\) and
\(X=1\) shows that the two coordinate sets are cosets of an additive
subgroup of \(\mathbb F_q\).  If they meet, normalization to the coordinate
axes shows that they are cosets of a multiplicative subgroup of
\(\mathbb F_q^*\).  For prime \(q>5\), an additive subgroup cannot have
order \(k\), while the multiplicative case requires
\[
 k\mid q-1=2k-4,
 \quad\text{so}\quad k\mid4,                               \tag{7}
\]
which is impossible for \(k\ge5\).  At \(q=5,k=4\), the multiplicative
case is exactly arithmetically possible, matching the projective
four-frame endpoint.

## 3. Why this does not yet settle extension fields

For \(q=p^e\) with \(e>1\), one has \(k=(q+3)/2>p\), so the hypothesis of
the conic-forcing theorem fails.  Its proof compares the two Redei
polynomials attached to the affine components and converts equality of
elementary symmetric functions into equality of power sums through degree
\(n-1\).  The restriction \(n\le p\) is used exactly when Newton identities
would otherwise divide by zero in characteristic \(p\).

This is a real boundary: the same paper constructs irregular collinear-
component dual 3-nets above the characteristic threshold.  Those examples
do not automatically realize (1), whose line-at-infinity component is the
quadratic-character half of all directions plus the trace-zero direction
and whose affine components are Frobenius conjugate.  Those two extra
features are the unused structure for the extension-field theorem.

A useful next lemma can therefore be stated sharply:

> **Special-direction conic lemma.**  Let a dual 3-net of order
> \((q+3)/2\) in \(PG(2,q)\) have collinear component equal, after affine
> normalization, to all directions of one quadratic-character class plus
> the trace-zero direction, and let its affine components be exchanged by
> Frobenius.  Then the affine components lie on a conic.

This lemma would finish the saturated-internal branch for every odd prime
power by the same splitting and subgroup arithmetic, now with subgroup
orders: the additive case would require \(k\) to be a power of \(p\).  For
\(p\ne3\), even \(p\nmid k\); for \(p=3\) and \(e>1\),
\(k=3(3^{e-1}+1)/2\) is not a power of three.  The multiplicative case
would again require \(k\mid q-1=2k-4\), hence \(k\mid4\).

## 4. Literature and trust boundary

Primary source:

- A. Blokhuis, G. Korchmaros, F. Mazzocca, *On the structure of 3-nets
  embedded in a projective plane*, arXiv:0911.4100, especially Theorem 5.1
  and its two-line discussion.  Cached PDF SHA-256
  `68b6203956bfa0e5eaa4279f8b6c497f29e3fe8e85f6f1d5f2449c3e0f80b289`.

The dual-3-net construction in Section 1 and the prime-field deduction in
Section 2 are new deductions here from the already proved C756 coherence
relations.  The cited paper supplies the conic theorem and the standard
two-line classification.  No claim is made for extension fields until the
special-direction conic lemma is proved.

## EJ + TT closeout

**EJ.**  The exceptional \(q=5\) object now has a second structural
description: besides being the \(A_3\) matching frame, it is the unique
arithmetic endpoint of a collinear-component dual 3-net, where the affine
components are multiplicative cosets of order four.  The same mechanism
eliminates every larger prime field at once.

**TT.**  Do not return to fixed-\(q\) coherent-support census.  The saturated
problem has become a characteristic-threshold problem for a highly special
dual 3-net.  The next proof attempt should repair Newton/Redei at the
degrees divisible by \(p\), using the Frobenius exchange of the two affine
components and the prescribed quadratic-character direction set.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does coherence have a standard incidence model? | settled | it is the dual 3-net (1) |
| Why is \(q=5\) exceptional over prime fields? | settled | two-line net classification and \(k\mid4\) |
| Are all prime \(q>5\) excluded structurally? | yes | equation (2) |
| Why does the cited conic theorem stop for extensions? | settled | Newton identities cross characteristic at degree \(p\) |
| Do known irregular nets refute the desired special lemma? | not shown | they need not have the character-half direction component or Frobenius exchange |
| What is the next all-\(q\) theorem? | open | prove the special-direction conic lemma |

## Next action

Write the two Redei polynomials of this dual 3-net and isolate the
coefficients at indices divisible by \(p\).  Test whether Frobenius exchange
and the explicit direction polynomial recover those missing Newton moments.
