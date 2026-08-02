# C756 — primitive Jacobi collisions are exactly Frobenius collisions

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The primitive-character collision gate left by the fifth C756 pass is proved.
Let

\[
 q=p^n\equiv3\pmod4,\qquad m=(q-1)/2,
\]

and let \(\rho\) be a faithful character of the cyclic square group
\(S=(\mathbb F_q^*)^2\).  For the Paley first-subconstituent eigenvalue

\[
 \beta_\rho=\sum_{u\in S}\rho(u)\chi(u-1),
\]

one has

\[
 \beta_\sigma=\beta_\rho
 \quad\Longrightarrow\quad
 \sigma=\rho^{p^j}\quad(0\le j<n). \tag{1}
\]

Thus one faithful eigenspace has exactly its forced Frobenius collision class.
Combined with the one-block Sidon proposition in
`notes/2026-08-01-c756-paley-bispectral-reduction.md`, this forces every
signed matching permutation to be multiplication--Frobenius.  The preceding
coset Weil argument eliminates every nonidentity Frobenius power, and the
scalar Hasse argument plus covering leaves only the Clebsch hexagon at
\(q=11\).  The saturated-external branch is therefore closed uniformly.

The proof is not a generic distinctness theorem for Jacobi sums.  Its decisive
extra input is the special conductor identity \(2m=p^n-1\), which turns the
Stickelberger carry profile into base-\(p\) digit weight.

## 1. The carry profile

The case \(q=3\), where \(m=1\), has no nontrivial faithful character and is
vacuous.  Hence assume \(m>1\).  Since \(q\equiv3\pmod4\), both \(p\equiv3
\pmod4\) and \(n\) are odd.  The order of \(p\) modulo \(m\) is exactly \(n\):
it divides \(n\), while for \(d<n\),

\[
 p^d-1\le p^{n-1}-1 < (p^n-1)/2=m.
\]

Put \(H=\langle p\rangle\subset(\mathbb Z/m\mathbb Z)^*\), so \(|H|=n\).
For a residue \(a\pmod m\), define

\[
 h(a)=\#\left\{0\le j<n:
       [ap^j]_m>\frac m2\right\}, \tag{2}
\]

where \([x]_m\in\{0,\ldots,m-1\}\) is the least residue.

Choose a character \(\omega\) of order \(2m=q-1\), put
\(\chi=\omega^m\), and write

\[
 \theta_r=\omega^{-2r},\qquad
 X_r=J(\theta_r,\chi),\qquad
 Y_r=J(\theta_r\chi,\chi).
\]

If \(r\not\equiv0\pmod m\), the Gauss-sum product formula and
Stickelberger's factorization give

\[
 X_rY_r=-q,\qquad
 v_{\mathfrak p_t}(X_r)=h(tr),\qquad
 v_{\mathfrak p_t}(Y_r)=n-h(tr), \tag{3}
\]

as \(t\) ranges over \((\mathbb Z/m\mathbb Z)^*\).  Here
\(\mathfrak p_t\) are the conjugates of a fixed prime above \(p\), and the
prime-ideal valuation is normalized to have integral values.  The valuation
formula is just the carry form of Stickelberger: adding the exponent \(m\)
flips the two halves of \(\mathbb Z/2m\mathbb Z\), and the \(n\) Frobenius
digits give the count (2).

The remaining work is to prove that this carry profile has no multipliers
beyond \(H\).

## 2. Digit-weight rigidity

Let

\[
 S(a)=\sum_{j=0}^{n-1}[ap^j]_m.
\]

We first prove the exact elementary lemma needed below.

**Lemma (half-carry multiplier rigidity).**  Let \(b\) be a unit modulo \(m\)
and let \(a\) be a nonzero residue.  If

\[
 h(ta)=h(tb)\qquad\text{for every }t\in(\mathbb Z/m\mathbb Z)^*, \tag{4}
\]

then \(a\equiv bp^j\pmod m\) for some \(j\).

**Proof.**  Replacing \(a\) by \(ab^{-1}\), it is enough to treat \(b=1\).
For \(x\in(0,1)\) with odd denominator, the indicator

\[
 \mathbf1_{\{2^e x\}>1/2}
\]

is the \((e+1)\)-st binary digit of \(x\).  Because \(m\) is odd,
\(2^e t\) is a unit for every \(e\ge0\).  Applying (4) to \(2^e t\) for all
\(e\), and then summing the equal binary digit counts with weights
\(2^{-e-1}\), gives

\[
 S(ta)=S(t)\qquad(t\in(\mathbb Z/m\mathbb Z)^*). \tag{5}
\]

Set \(N=p^n-1=2m\) and \(R=N/(p-1)\).  The residues
\([2tp^j]_N\) are twice the residues \([tp^j]_m\).  Multiplication by \(p\)
cyclically rotates the \(n\) base-\(p\) digits modulo \(N\), so, if
\(s_p(x)\) denotes base-\(p\) digit sum,

\[
 2S(t)=R\,s_p(2[t]_m). \tag{6}
\]

Taking \(t=1\) in (5) and using (6) yields

\[
 s_p(2[a]_m)=s_p(2)=2. \tag{7}
\]

Since \(p\) is odd, an integer with base-\(p\) digit sum two has one of the
two forms

\[
 2[a]_m=2p^i
 \quad\text{or}\quad
 2[a]_m=p^i+p^j\quad(i\ne j). \tag{8}
\]

The first form gives \(a\equiv p^i\pmod m\), as required.  In the second,
cyclically rotating digits lets us assume

\[
 a\equiv(1+p^r)/2\pmod m,qquad 1\le r<n. \tag{9}
\]

Now take \(t_0=(p+1)/2\).  Since \(n\) is odd,

\[
 \gcd(p+1,p^n-1)=2,
\]

so \(t_0\) is a unit modulo \(m\).  But

\[
 s_p(2t_0)=s_p(p+1)=2,
\]

whereas the two distinct digits of

\[
 2[t_0a]_m\equiv t_0(1+p^r)\pmod N
\]

are both \(t_0<p\), and hence its digit sum is \(2t_0=p+1\).  (For
\(n>1\), the displayed representative is already between \(0\) and \(N\).)
This contradicts (5)--(6).  Thus the two-digit form is impossible. ∎

There is an immediate complementary form.  Since

\[
 h(-x)=n-h(x) \tag{10}
\]

for every nonzero residue \(x\), the identity

\[
 h(ta)=n-h(tb)\quad\text{for all units }t
\]

forces \(a\equiv-bp^j\pmod m\).

## 3. Jacobi pairs and collision closure

Let \(\rho_r\) be the restriction of \(\theta_r\) to \(S\).  For every
nontrivial \(\rho_r\), the Fourier/Jacobi calculation from the fifth pass is

\[
 \beta_{\rho_r}=-\frac{X_r+Y_r}{2},\qquad X_rY_r=-q. \tag{11}
\]

Suppose \(\rho_r\) is faithful and
\(\beta_{\rho_s}=\beta_{\rho_r}\).  The trivial character has eigenvalue
zero; it cannot collide with \(\rho_r\), as verified below.  Thus (11)
applies to both characters.  Their Jacobi pairs are the roots of the same
quadratic

\[
 T^2+2\beta_{\rho_r}T-q,
\]

and therefore

\[
 \{X_s,Y_s\}=\{X_r,Y_r\}. \tag{12}
\]

If \(X_s=X_r\), the valuations in (3) and the lemma give
\(s\equiv rp^j\pmod m\).  If \(X_s=Y_r\), equations (3), (10), and the
complementary lemma give \(s\equiv-rp^j\pmod m\).  Hence the only candidates
are

\[
 \rho_s=\rho_r^{p^j}
 \quad\text{or}\quad
 \rho_s=\rho_r^{-p^j}. \tag{13}
\]

Frobenius substitution in the defining character sum gives
\(\beta_{\rho^{p^j}}=\beta_\rho\).  On the other hand, the Paley convolution
kernel satisfies

\[
 \chi(u^{-1}-1)=-\chi(u-1)\qquad(u\in S),
\]

so

\[
 \beta_{\rho^{-1}}=-\beta_\rho. \tag{14}
\]

Finally \(\beta_\rho\ne0\).  Otherwise (11) would give \(Y_r=-X_r\), so
their principal ideals and all valuations would agree.  Equation (3) would
then force \(h(tr)=n-h(tr)\), impossible because \(n\) is odd.  Thus the
inverse alternative in (13) cannot satisfy the original equality, proving
(1).

## 4. Consequence for the saturated matching

The one-block rigidity proposition of the fifth report now applies without a
conditional hypothesis.  If \(P\) is a local Paley automorphism arising from
a signed saturated matching, then a faithful character is carried into the
span of its Frobenius conjugates.  The Frobenius exponents are Sidon modulo
\(m\), and the image has pointwise modulus one, so its Fourier support has one
term.  Therefore

\[
 f(s)=c s^{p^j}.
\]

The Segre-coherence report's coset Weil bound forces \(j=0\).  Its scalar
genus-one argument leaves \(q\in\{3,7,11\}\), and the covering condition
leaves only \(q=11\).  Consequently every saturated-external conic-filling
arc is the Clebsch hexagon.

This completes the last open saturated collision class.  It does **not**
complete C756: the nonsaturated branch still needs a uniform obstruction.

## 5. Literature boundary

The proof above is self-contained apart from the standard Gauss/Jacobi
product and Stickelberger valuation formula.  The character-theoretic
nonvanishing criterion for half-interval sums in Pomerance--Ulmer,
[*On balanced subgroups of the multiplicative group*](https://arxiv.org/abs/1204.6705),
is a useful neighboring framework, but it is not needed: imprimitive
characters can make individual half-interval Fourier coefficients vanish,
whereas the base-\(p\) digit argument proves the exact multiplier statement
directly.  Hoshi's
[*A note on fields generated by Jacobi sums*](https://www.math.okayama-u.ac.jp/mjou/mjou65/_06_hoshi.pdf)
explains the decomposition-field viewpoint for prime-power cyclotomic
conductors; the conductor here is the generally composite number
\((p^n-1)/2\), so that theorem is not substituted for the argument above.

No unrestricted novelty claim is made.  No manuscript files were edited.

## 6. EJ + TT closeout

The cheap extra value is the digit-weight lemma itself.  It is stronger than
the needed unit-stabilizer assertion: the competing exponent \(a\) need not
be a unit initially.  Thus a primitive Jacobi value cannot collide with an
imprimitive character either; faithfulness is recovered by the proof rather
than assumed on both sides.

The Tao compression is that no class-number, nonvanishing, or full Jacobi-field
generation theorem is necessary.  Stickelberger is used only to obtain the
binary half-carry profile.  Summing its dyadic iterates recovers a digit sum,
and two test units, \(1\) and \((p+1)/2\), finish the multiplier classification.

The resulting proof also explains why the Frobenius orbit is the exact
collision class: powers of \(p\) are precisely the cyclic rotations of the
base-\(p\) digits of \(2a\).

## 7. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Primitive Jacobi eigenvalue collisions | settled | exactly the Frobenius orbit by (1) |
| Possible collision with an imprimitive character | settled negatively | digit-weight rigidity first forces the competing exponent to be a power of \(p\) |
| Inverse-Frobenius ideal collision | settled negatively for eigenvalues | skewness gives \(\beta_{\rho^{-1}}=-\beta_\rho\), and \(\beta_\rho\ne0\) |
| Two-digit weight-two impostors | settled negatively | the unit \((p+1)/2\) changes digit weight from \(2\) to \(p+1\) |
| Signed saturated-external matchings | settled | one-block Sidon rigidity, then the prior Weil and Hasse arguments |
| Nonsaturated conic-filling arcs | open | exact remaining C756 gate: a type-aware spare-line or other \(k\)-uniform obstruction |
