# C756 — local Paley proof consolidation and primitive-Jacobi audit

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** human proof
consolidation and referee-risk audit; no manuscript or Lean edits

## Verdict

The standalone theorem survives a line-by-line proof audit:

\[
 \operatorname{Aut}(P(q)[S])
 =
 \{s\mapsto cs^{p^j}:c\in S,\ 0\le j<n\}
 \cong S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p),
 \qquad q=p^n\equiv3\pmod4.
\]

No counterexample, missing case, or circular step was found.  The audit did
find one major exposition/trust defect: the old collision report asserted the
load-bearing Stickelberger half-carry valuation in a sentence without naming
the cyclotomic field, the primes, or the ramification normalization.  That seam
is now repaired in
notes/2026-08-01-c756-primitive-jacobi-collisions.md, equations (3a)--(3b).
The repaired text derives the half-carry count from the standard base-\(p\)
digit-sum valuation rather than treating it as a black-box variant.

The local theorem is now consolidated below into a five-step proof.  Its only
external arithmetic input is the standard Stickelberger valuation of Gauss
sums; Gauss/Jacobi products are elementary identities.  The flat-Sidon step is
proved inline.  This passes the mathematical proof gate for the local theorem.
It does not by itself release the full exterior-arc companion: the geometric
proof still needs a single-document consolidation and final citation
installation.

## 1. Statement and Cayley model

Let \(P(q)\) be the tournament on \(\mathbb F_q\) with
\(x\to y\) when \(\chi(y-x)=1\), where \(\chi\) is the quadratic character.
Because \(q\equiv3\pmod4\), this is a tournament.  The out-neighbourhood of
\(0\) is

\[
 S=(\mathbb F_q^*)^2,\qquad |S|=m=(q-1)/2.
\]

On \(S\), multiplication by every \(c\in S\) and every Frobenius map
\(s\mapsto s^{p^j}\) preserves the tournament.  Hence
\[
 S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p)
 \le \operatorname{Aut}(P(q)[S]).
\]

The Cayley description itself is not the novelty: for prime \(q\), it is
Javier--Llano--Zuazua, Proposition 4.4.  The task is the reverse inclusion.

## 2. One faithful eigenblock

Let \(B\) be the signed adjacency convolution on the cyclic group \(S\),
with kernel \(u\mapsto\chi(u-1)\).  Every character
\(\rho\in\widehat S\) is an eigenvector, with

\[
 \beta_\rho=\sum_{u\in S}\rho(u)\chi(u-1).
\]

If \(f\) is a tournament automorphism and \(P_f\) its permutation operator,
then \(P_fB=BP_f\).  Choose a faithful character \(\rho=\rho_r\), with
\(r\in(\mathbb Z/m\mathbb Z)^*\).  Once the collision theorem in Section 3
is proved, \(P_f\rho\) belongs to

\[
 \operatorname{span}\{\rho^{p^j}:0\le j<n\}.
\]

This uses only one eigenvalue block.  It neither assumes simple spectrum nor
classifies any other collision class.

## 3. Exact primitive Jacobi collisions

Choose a character \(\omega\) of order \(2m=q-1\), put
\(\chi=\omega^m\), and set

\[
 \theta_r=\omega^{-2r},\quad
 X_r=J(\theta_r,\chi),\quad
 Y_r=J(\theta_r\chi,\chi).
\]

For nontrivial \(\rho_r\),

\[
 \beta_{\rho_r}=-(X_r+Y_r)/2,\qquad X_rY_r=-q. \tag{1}
\]

The repaired Stickelberger calculation gives, at the primes
\(\mathfrak p_t\) of \(K=\mathbb Q(\zeta_m)\) above \(p\),

\[
 v_{\mathfrak p_t}(X_r)=h(tr),\qquad
 v_{\mathfrak p_t}(Y_r)=n-h(tr), \tag{2}
\]

where
\[
 h(a)=\#\{0\le j<n:[ap^j]_m>m/2\}.
\]

The normalization is now explicit.  In
\(K(\zeta_p)\), Stickelberger gives the Gauss-sum valuation as a base-\(p\)
digit sum.  Restriction to \(K\) divides it by the ramification index
\(p-1\).  Writing \(N=2m\) and \(A=[2tr]_N\), the Jacobi quotient gives

\[
 (p-1)v_{\mathfrak p_t}(X_r)
 =s_p(A)+s_p(m)-s_p([A+m]_N).
\]

Using
\[
 s_p(x)=\frac{p-1}{N}\sum_{j=0}^{n-1}[xp^j]_N
\]
shows that the right side is \(p-1\) times the number of indices for which
\([Ap^j]_N>m\), exactly the count \(h(tr)\).

It remains to identify the stabilizer of this profile.  If \(b\) is a unit
modulo \(m\) and
\[
 h(ta)=h(tb)\qquad\text{for every unit }t,
\]
normalize \(b=1\).  Apply the equality to every \(2^e t\).  The successive
half-interval indicators are the binary digits of
\([tap^j]_m/m\), so their weighted sum yields
\[
 \sum_j[tap^j]_m=\sum_j[tp^j]_m.
\]
The base-\(p\) rotation identity then gives
\[
 s_p(2[a]_m)=s_p(2)=2.
\]
Thus \(2[a]_m\) is either \(2p^i\) or \(p^i+p^j\).  The first case gives
\(a=p^i\pmod m\).  In the second, rotate to
\[
 a=(1+p^r)/2\pmod m,\qquad1\le r<n.
\]
The test unit \(t_0=(p+1)/2\) is invertible modulo \(m\), because
\(\gcd(p+1,p^n-1)=2\).  Its original digit weight is two, while
\[
 2[t_0a]_m=t_0(1+p^r)
\]
has two distinct base-\(p\) digits, both \(t_0\), and hence digit weight
\(p+1\), a contradiction.  There is no hidden wrap: for \(n>1\), necessarily
\(n\ge3\), and
\[
 (p+1)(1+p^{n-1})<2(p^n-1).
\]
Therefore the profile stabilizer is exactly
\(\langle p\rangle\).  Since \(h(-x)=n-h(x)\), the complementary profile has
exactly the coset \(-\langle p\rangle\).

Now suppose \(\beta_{\rho_s}=\beta_{\rho_r}\), with \(\rho_r\) faithful.
The trivial character cannot collide because the nonvanishing argument below
shows \(\beta_{\rho_r}\ne0\).  By (1), the two Jacobi pairs are roots of the
same quadratic:
\[
 \{X_s,Y_s\}=\{X_r,Y_r\}.
\]
Equation (2) and profile rigidity give
\[
 s=rp^j\quad\text{or}\quad s=-rp^j\pmod m.
\]
Frobenius gives equality in the first case.  Inversion gives
\[
 \beta_{\rho^{-1}}=-\beta_\rho,
\]
because
\(\chi(u^{-1}-1)=-\chi(u-1)\) on \(S\).  Finally
\(\beta_\rho\ne0\): otherwise \(Y_r=-X_r\), so (2) would force
\(h(tr)=n-h(tr)\), impossible for odd \(n\).  Hence
\[
 \beta_{\rho_s}=\beta_{\rho_r}
 \Longleftrightarrow
 \rho_s=\rho_r^{p^j}. \tag{3}
\]

This also excludes imprimitive competitors: \(s\) was not assumed to be a
unit before profile rigidity forced it into \(r\langle p\rangle\).

## 4. Flat-Sidon collapse

Write
\[
 P_f\rho=\sum_{j=0}^{n-1}a_j\rho^{p^j}.
\]
The left side has pointwise modulus one.  The Frobenius exponents form a
Sidon set modulo \(m\): for \(n>1\),
\[
 |p^i-p^j|<p^{n-1}<m,
\]
so equality of two ordered differences modulo \(m\) is equality as integers;
the \(p\)-adic valuation fixes the lower exponent and the quotient fixes the
upper exponent.

Every nontrivial Fourier coefficient of \(|P_f\rho|^2\) is therefore one
product \(a_i\overline{a_j}\).  Constancy of the modulus makes all such
products zero.  Exactly one \(a_j\) survives, and faithfulness of \(\rho\)
gives
\[
 f(s)=cs^{p^j}
\]
after harmlessly inverting the convention for the permutation action.  This
proves the reverse inclusion in the automorphism formula.

## 5. Unique local-to-global extension and corollaries

The map \(s\mapsto cs^{p^j}\) extends to
\[
 x\mapsto cx^{p^j}
\]
on the full field.  It fixes \(0\) and preserves the Paley tournament.
The extension is unique.  If two parameter pairs have the same restriction
to \(S\), evaluation at \(1\) gives the same \(c\), and then
\(p^j=p^k\pmod m\).  The order of \(p\) modulo \(m\) is exactly \(n\), since
for \(d<n\),
\[
 0<p^d-1<m.
\]
Thus \(j=k\).  The singleton case \(q=3\) is immediate.

Consequently:

1. restriction from the stabilizer of \(0\) in the full Paley group to
   \(\operatorname{Aut}(P(q)[S])\) is an isomorphism;
2. \(P(q)[S]\) is a normal cyclic Cayley tournament;
3. its automorphism group has order \(n(q-1)/2\);
4. for prime \(q\), it is a cyclic directed regular representation.

These are corollaries of one theorem, not four independent novelty claims.

## 6. Referee audit ledger

| seam | verdict | action |
|---|---|---|
| parity \(q\equiv3\pmod4\), odd \(n\), and \(\operatorname{ord}_m(p)=n\) | pass | the strict inequality for every \(d<n\) is explicit |
| Jacobi sum/product formula (1) | pass | both extensions of a character of \(S\) are exactly the displayed pair |
| Stickelberger normalization and half-carry formula (2) | **major prose defect repaired** | fields, primes, ramification factor, digit formula, and wrap count are now explicit |
| dyadic recovery of orbit sums | pass | odd \(m\) makes every \(2^e t\) a unit and gives nonterminating ambiguity-free binary expansions |
| digit-weight-two classification | pass | covers digit \(2\) and two digit-\(1\) positions, including \(p=3\) |
| test multiplier \((p+1)/2\) | pass | unit property, absence of carry, and representative bound checked |
| imprimitive collision | pass, excluded | the competing exponent becomes a power of \(p\) without a unit assumption |
| inverse-Frobenius collision | pass, excluded | skew inversion plus odd-\(n\) nonvanishing |
| one-block to monomial map | pass | flat-Sidon lemma is inline and does not require simple spectrum |
| uniqueness of extension | pass | follows from \(\operatorname{ord}_m(p)=n\) |

## 7. Citation installation

The following sources match the exact classical statements used by the
eventual companion:

1. **Stickelberger digit valuation:** Evans--Hollmann--Krattenthaler--Xiang,
   Theorem 3.4 and formula (3.2), DOI 10.1006/JCTA.1998.2950.  The cached
   arXiv:math/9807029 bytes have SHA-256
   369f5a6c5bbc7544b6a0c133e01a0c6501dcfa20f2d55b61c2adcdecee7bb215.
2. **Scaled Segre lemma of tangents:** Ball--Lavrauw, *Planar arcs*,
   Lemma 11, DOI 10.1016/j.jcta.2018.06.015.
3. **Three-support multiplicative Weil bound:** Lidl--Niederreiter,
   *Finite Fields*, second edition, Theorem 5.41, book DOI
   10.1017/CBO9780511525926.  In the C756 application, combine the three
   factors into one character of their common cyclic character group; the
   two quadratic roots have exponent half the character order, so the
   polynomial is not a perfect power and the bound is \(2\sqrt q\).
4. **Elliptic endpoint:** Hasse's bound
   \(|\#E(\mathbb F_q)-(q+1)|\le2\sqrt q\); a version-of-record historical
   locator is DOI 10.1515/crll.1936.175.55.  The C756 cubic has roots
   \(0,n,n^{-1}\); the separately handled \(n=-1\) case and nonsquareness of
   \(n\) make them distinct.

The Weil citation should name Theorem 5.41, not the neighboring Theorem 5.40,
for which a published counterexample exists.

## 8. EJ + TT closeout

**EJ.**  The repaired valuation proof is stronger and cleaner than a citation
alone: it isolates a general half-carry multiplier lemma in which the
competitor need not be primitive.  This is the precise reason imprimitive
Jacobi collisions disappear.

**TT.**  Present the theorem as “restriction is an isomorphism.”  The proof
then has one input per layer: one faithful eigenblock, one exact valuation
profile, one flatness lemma.  Normality, DRR, and coordinate reconstruction
should not interrupt that spine.

## 9. Mystery ledger

| mystery | status | exact remaining gate |
|---|---|---|
| Is the primitive-Jacobi proof arithmetically sound? | settled positive after repair | no mathematical gap found |
| Was the Stickelberger normalization publication-ready? | settled negative, then repaired | equations (3a)--(3b) now carry the missing descent |
| Can an imprimitive character collide? | settled negative | multiplier rigidity forces a Frobenius exponent |
| Is the local theorem ready to consolidate into the companion proof? | yes | use Sections 1--5 as the engine |
| Is the full companion ready for manuscript allocation? | not yet | consolidate the exterior geometry and install the four citations; retain the human MathSciNet/Scopus novelty qualifier |

