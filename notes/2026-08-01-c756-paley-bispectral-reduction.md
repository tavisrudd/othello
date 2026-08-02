# C756 — bispectral reduction of the Paley anticommutator

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The signed-monomial classification is not yet complete.  It now has a sharper
linear-algebraic form, however, and the prime-field branch reduces to one exact
Jacobi-spectrum statement.

Let \(q\equiv3\pmod4\), let \(S=(\mathbb F_q^*)^2\), and index matrices by
\(S\).  Define

\[
 B_{s,t}=\chi(t-s),\qquad C_{s,t}=\chi(s+t).
\]

If \(f:S\to S\) is the permutation encoded by a signed matching solution of
the preceding Paley anticommutator, and \(P e_t=e_{f(t)}\), then

\[
 BP=PB,\qquad P^T C+CP=-2I. \tag{1}
\]

The new point is that the two fixed Paley matrices satisfy

\[
 BC=CB,\qquad C^2-B^2=qI-2J. \tag{2}
\]

Consequently

\[
 K:=CP+I
\]

is a regular skew tournament matrix satisfying

\[
 [B,K]=0,\qquad
 K^2=-B^2-(q-1)I+2J. \tag{3}
\]

Thus a signed matching is not an arbitrary monomial point in the large
continuous anticommutator space: it is a \(\{0,\pm1\}\)-valued skew square root
of one fixed polynomial in the first-subconstituent Paley matrix.

This closes every field for which \(B\) has simple complex spectrum.  In that
case \(K\) is a polynomial in \(B\), hence is multiplicatively circulant; (1)
then forces \(P\) itself to be a circulant permutation, so

\[
 f(s)=cs\qquad(c\in S).
\]

The genus-one argument in the saturated-matching report therefore gives
\(q\in\{3,7,11\}\), and covering leaves only the Clebsch hexagon at \(q=11\).
The remaining prime-field gate is to prove that the Fourier eigenvalues of
\(B\) are distinct.  In extension fields Frobenius necessarily creates
eigenvalue blocks, so the needed generalization is that every sign-valued
square root in (3) acts semilinearly inside those blocks.

## 1. From the signed matching to two matrix equations

Write the matching as

\[
 \{s,-f(s)\}\qquad(s\in S).
\]

The two forced vector equations from the preceding report determine every
nonzero monomial entry: if \(\tau\) is the matching involution, then

\[
 M_{x,\tau(x)}=\chi(x).
\]

The off-diagonal entries of \(AM+MA=-2I\), first with both indices in \(S\)
and then with one index in each character class, are exactly

\[
 \chi(f(t)-f(s))=\chi(t-s), \tag{4}
\]

and

\[
 \chi(s+f(t))=-\chi(t+f(s))\quad(s\ne t). \tag{5}
\]

The diagonal entries give

\[
 \chi(s+f(s))=-1. \tag{6}
\]

Equation (4) is \(P^TBP=B\), equivalently \(BP=PB\).  Equations (5)--(6)
say that \(CP\) has diagonal \(-1\) and skew off-diagonal part, which is the
second equation in (1).  This also proves that the signs in \(M\) contain no
residual freedom once the matching permutation is fixed.

## 2. The fixed bispectral identity

Both \(B\) and \(C\) are convolution matrices on the multiplicative group
\(S\): after dividing the column index by the row index, their kernels are

\[
 b(u)=\chi(u-1),\qquad c(u)=\chi(u+1).
\]

They therefore commute.  Also \(B\mathbf1=0\) and \(C\mathbf1=-\mathbf1\).

For \(s,t\in S\), the \((s,t)\)-entry of \(C^2-B^2\) is

\[
 \sum_{u\in S}
 \left[
  \chi((u+s)(u+t))+\chi((u-s)(u-t))
 \right]. \tag{7}
\]

The bracketed function is even in \(u\).  Since \(\chi(-1)=-1\), its product
with \(\chi(u)\) is odd, so the character-weighted half of the indicator of
\(S\) cancels.  Two elementary quadratic-character sums then give \(-2\)
when \(s\ne t\), and \(q-2\) when \(s=t\).  This proves (2).

Now put \(K=CP+I\).  Equation (1) gives \(K^T=-K\), while the convolution
commutation and \(BP=PB\) give \([B,K]=0\).  Finally,

\[
 KK^T=(CP+I)(P^TC+I)=C^2-I.
\]

Since \(K^T=-K\), equations (2) and the last display give (3).  Moreover
\(K\mathbf1=0\), and every off-diagonal entry of \(K\) is \(\pm1\), so \(K\)
is the skew adjacency matrix of a regular tournament on the odd set \(S\).

## 3. Simple spectrum forces the scalar branch

**Proposition.**  If \(B\) has simple spectrum over \(\mathbb C\), every signed
matching solution of (1) has \(f(s)=cs\) for some \(c\in S\).

**Proof.**  A complex matrix commuting with a simple-spectrum matrix is a
polynomial in that matrix.  By (3), \(K\) commutes with \(B\), so \(K\) is a
polynomial in \(B\).  Since \(B\) is multiplicatively circulant, \(K\) is
also circulant.  Hence

\[
 CP=K-I
\]

is circulant.  The real skew matrix \(K\) has only purely imaginary
eigenvalues, so \(K-I\) is invertible.  Thus \(C\) is invertible as well, and

\[
 P=C^{-1}(K-I)
\]

is circulant.  A circulant permutation matrix is a translation of the
underlying group \(S\), which in multiplicative notation is
\(f(s)=cs\). ∎

The scalar matching is precisely the branch already treated by the elliptic
character sum in `notes/2026-08-01-c756-saturated-matching-attack.md`.
Therefore the proposition plus simple spectrum excludes every saturated
external solution except the \(q=7,11\) scalar arcs, and covering excludes
\(q=7\).

## 4. Fourier/Jacobi form of the remaining gate

For a character \(\rho\in\widehat S\), let

\[
 \beta_\rho=\sum_{u\in S}\rho(u)\chi(u-1),\qquad
 \gamma_\rho=\sum_{u\in S}\rho(u)\chi(u+1).
\]

These are the simultaneous eigenvalues of \(B\) and \(C\).  If \(\theta\) is
either extension of \(\rho\) to \(\mathbb F_q^*\), put

\[
 X=J(\theta,\chi),\qquad Y=J(\theta\chi,\chi).
\]

Up to the harmless choice of extension,

\[
 \beta_\rho=-\frac{X+Y}{2},\qquad
 \gamma_\rho=\frac{\theta(-1)(X-Y)}2,
\]

and the Gauss-sum product formula gives \(XY=-q\).  Hence

\[
 \gamma_\rho^2=\beta_\rho^2+q
\]

for every nontrivial character; the trivial character accounts for the
\(-2J\) correction in (2).

For a prime field there are no nontrivial Frobenius identifications on
\(\widehat S\).  The exact missing prime-field statement is therefore

> the Jacobi sums above give pairwise distinct values
> \(\beta_\rho\) as \(\rho\) ranges over \(\widehat S\).

This is strictly weaker than classifying the full automorphism group of the
first subconstituent.  A proof by Stickelberger valuations would suffice: an
equality of two \(\beta\)'s makes the corresponding unordered Jacobi pairs
\(\{X,Y\}\) equal, and their prime-ideal valuation patterns should recover the
character up to inversion; skew-symmetry then separates the inverse pair.
That valuation-recovery step has not yet been proved here.

For \(q=p^n\) with \(n>1\), the values are constant on Frobenius orbits, so
simple spectrum is false for structural reasons.  Equation (3) nevertheless
reduces the all-field problem to a finite-dimensional block statement:
inside every Frobenius Jacobi block, a sign-valued skew square root with
\(CP+I\) monomially induced must be the Frobenius action composed with a
multiplicative translation.  The coset Weil argument in the Segre report
then excludes every nonidentity Frobenius power.

## 5. EJ + TT closeout

The cheap extra value is that one no longer needs the complete automorphism
group of the first Paley subconstituent.  It is enough to control the much
smaller intersection of its commutant with the fixed skew-square-root locus
(3).  In prime fields, simple spectrum collapses that intersection
immediately to circulants; in extension fields, only the forced Frobenius
blocks survive as possible hiding places.

The Tao-style next question is not “which permutations preserve the local
tournament?” but “can a nonsemilinear permutation produce a sign-valued
square root of the fixed operator in (3)?”  The latter remembers both Paley
sign systems simultaneously and is stronger than the former automorphism
problem.

No manuscript files were edited.  No unrestricted novelty claim is made.

## 6. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| The matching signs are forced by the involution | settled | the two vector equations give \(M_{x,\tau(x)}=\chi(x)\) |
| Every solution produces a commuting regular tournament square root \(K\) | settled | equations (1)--(3) |
| Simple spectrum forces the scalar branch | settled | polynomial commutant plus circulant-permutation rigidity |
| The local Paley spectrum appears simple in prime fields | open uniformly | prove distinctness of the Jacobi values \(\beta_\rho\), likely by Stickelberger valuation recovery |
| Frobenius is the only forced source of spectral multiplicity in extension fields | expected, not proved | classify sign-valued square roots inside each Jacobi block |
| Whether a nonsemilinear signed matching solution exists | open | exact owner: the next C756 pass |
