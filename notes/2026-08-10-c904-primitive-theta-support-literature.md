# C904 primitive-theta support gate: literature and exact lattice audit

> **Later status (2026-08-10).**  Odd support directly on `Theta` remains an
> interesting primitive-Chow question, but it is no longer needed for the
> fixed-fibre `Sym^2 Theta` index: the common-line unordered Fano lift and
> exceptional plane-quintic `2/5` Bezout argument close that index at one.
> Natural Fano/genus-two and universal-sheaf tautological attempts to hit
> this theta-support bit have since been proved even.

Date: 2026-08-10
Status: quarantined Annals research; no manuscript or Lean edits
Scope: the image of `CH_1(Theta) -> CH_1(J)`, support of the minimal
class, and the generic index of `Sym^2 Theta -> J`

## Executive verdict

The primary literature reaches exactly the even class and stops there.

Let `(J,Theta)` be the intermediate Jacobian of a smooth cubic threefold,
`dim J=5`, and put

\[
                         c=\frac{\Theta^4}{4!}.
\]

Clemens--Griffiths identify `Theta` with the image of the difference map
`F x F -> J`, generically of degree six.  For a cubic with universally
trivial `CH_0`, Shen proves:

1. `c` is represented by a signed one-cycle supported on the image `D_+`
   of the sum map `F x F -> J`; this divisor has class `3 Theta` and the
   sum map has generic degree two;
2. `2c` is represented by a symmetric signed one-cycle supported on
   `Theta`.

For the marked `A_5` cubic in C904, the certified divisor identity makes
`c` algebraic.  Voisin's theorem therefore gives universal `CH_0`
triviality, so Shen's proposition applies without an additional conjecture.
It does **not** put `c` on `Theta`: `D_+` is the wrong divisor.

A bounded forward-citation and discriminator search found no later theorem
upgrading Shen's `2c` to `c` on the cubic theta divisor.  The 2024 moduli
resolution of Bayer--Beentjes--Feyzbakhsh--Hein--Martinelli--Rezaee--Schmidt
gives a very useful reformulation, but does not compute the relevant Chow
image.

The exact C904 lattice calculation sharpens the missing statement.  On the
exotic marked fibre,

\[
 \operatorname {coker}\!\left(
 \Theta\smile-:\operatorname {Hdg}^6(J,\mathbf Z)
       \longrightarrow\operatorname {Hdg}^8(J,\mathbf Z)
 \right)\cong\mathbf Z/2,
\]

and `c` generates the quotient.  Thus the primitive-theta question is a
single bit:

> Does the cycle-class image of `CH_1(Theta)` hit the nonzero coset?

Equivalently on this marked fibre, does `Theta` support a **signed**
one-cycle of odd theta degree?  If yes, subtracting a theta-supported
divisor-product cycle gives a representative of `c` supported on `Theta`.

Such a representative would immediately close the symmetric-theta index:
if `Z` is supported on `Theta` with `[Z]=c`, then

\[
 q_*\bigl(Z\times\Theta\bigr)\subset\operatorname {Sym}^2\Theta
\]

has degree

\[
                     \int_J c\Theta=5
\]

over `J`.  Together with the already certified degree-two carrier, this
forces the geometric generic index of `Sym^2 Theta -> J` to be one.

This is a sufficient route, not a converse for the full index problem:
an odd cycle on `Sym^2 Theta` could use middle-degree correspondence terms
and need not be of product form.

Finally, `c` cannot be sought as an effective curve.  By the
Matsusaka--Ran minimal-class criterion, an effective minimal-class curve on
an indecomposable ppav forces Jacobian geometry, incompatible with a smooth
cubic intermediate Jacobian.  Any successful primitive theta lift must be
a signed Chow cycle.

## 1. Exact primary results

### 1.1 Difference and sum maps of the Fano surface

Let `F` be the Fano surface of lines and let `phi:F->J` be its Abel--Jacobi
embedding, with a fixed normalization.  The two maps are

\[
 \phi_-(u,v)=\phi(u)-\phi(v),\qquad
 \phi_+(u,v)=\phi(u)+\phi(v).
\]

Clemens--Griffiths, Theorem 13.4 and its proof, give

\[
       \operatorname {im}(\phi_-)=\Theta,
       \qquad \deg(\phi_-:F\times F\to\Theta)=6.
\]

Shen's Lemma 5.6 proves

\[
       \operatorname {im}(\phi_+)=D_+,
       \qquad [D_+]=3\Theta,
       \qquad \deg(\phi_+:F\times F\to D_+)=2.
\]

The degree-two assertion is not a formal symmetry count.  Shen uses the
six presentations of a general difference of two lines on the cubic
surface spanned by them, and shows that only the factor swap survives for a
general sum.

The modern theta-resolution paper also records the classical difference
description explicitly: its Remark 2.3 states that `F x F -> Theta` is
generically six-to-one.  It also gives a second birational parametrization
of `Theta` using twisted cubics.

### 1.2 What Shen proves about the minimal class

Shen's Proposition 5.7 assumes universal triviality of `CH_0(X)`.  Starting
from the symmetric cycle on `F x F` constructed in his Theorem 5.1, he
subtracts its two marginal cycles and obtains a corrected symmetric cycle
`tilde theta`.  The two pushforwards satisfy

\[
  [\phi_{+*}\widetilde\theta]=-2c,
  \qquad
  [\phi_{-*}\widetilde\theta]=2c
\]

up to his sign convention for the principal polarization.  Symmetry makes
the first pushforward divisible by two as a Chow cycle.  Consequently:

- `c` has a signed representative supported on `D_+`;
- `2c` has a symmetric signed representative supported on `Theta`.

There is no division by two in the second statement.  The fact that
`phi_-` has degree six does not supply such a division either.

There is also a classical geometric representative of the same even
multiplier.  If `a:F->J` is the Albanese embedding and `C_s` is an incidence
curve, the Clemens--Griffiths/Hoering identities are

\[
        a_*[F]=\frac{\Theta^3}{3!},
        \qquad a^*\Theta\equiv_{\rm num}2C_s.
\]

Hence

\[
                        a_*[C_s]=2c.
\]

After translating by the fixed line `s`, the surface `F-s` is contained in
`F-F=Theta`, so this also realizes the even class on the theta divisor.
Again the factor two is exact.

### 1.3 Why Shen applies to the C904 cubic

Voisin's Theorem 1.7/Corollary 4.4 says for a smooth cubic threefold:

\[
 X\text{ has universally trivial }CH_0
 \quad\Longleftrightarrow\quad
 c\text{ is algebraic on }J(X).
\]

The C904 six-axis/divisor certificate constructs `c` integrally as a signed
combination of fourfold divisor products.  Subject to that already checked
certificate, the hypothesis of Shen's Proposition 5.7 is therefore met.

This is the strongest source-backed implication currently available.  It
must not be paraphrased as "Shen puts the minimal class on theta": he puts
the primitive class on `D_+` and only its double on `Theta`.

## 2. The singular theta Chow target

The cubic theta divisor is normal, smooth away from the origin, and has its
unique singularity at the origin.  Bayer et al., Theorem 7.1 and Lemma 7.5,
construct a smooth projective fourfold

\[
                    \pi:M_X(v)=\operatorname {Bl}_0\Theta\longrightarrow\Theta
\]

whose exceptional divisor is the cubic threefold `X` itself.  Composing
with `Theta -> J` is the Abel--Jacobi morphism of their moduli space.

Chow localization gives the exact reduction

\[
 CH_1(X)\longrightarrow CH_1(M_X(v))
       \longrightarrow CH_1(\Theta)\longrightarrow0.
\]

Curves in the exceptional cubic are contracted to the origin and have zero
pushforward in `CH_1(J)`.  Therefore

\[
 \operatorname {im}\bigl(CH_1(\Theta)\to CH_1(J)\bigr)
 =\operatorname {im}\bigl(CH_1(M_X(v))\to CH_1(J)\bigr).
\]

This is a concrete alternative attack: compute the Abel--Jacobi image of
one-cycles on the smooth moduli fourfold.  The Bayer et al. paper computes
the birational contraction but not `CH_1(M_X(v))`, this pushforward image,
or the primitive integral curve class.  Its bounded citation neighbourhood
is dominated by stability conditions and categorical Torelli results; no
Chow-image computation was found.

The theta-support issue is not topological.  Put `U=J\setminus Theta`.
Since `Theta` is ample, `U` is a smooth affine complex fivefold.  By
Andreotti--Frankel, `U` has the homotopy type of a CW complex of real
dimension at most five.  Lefschetz duality for `(J,Theta)` therefore gives

\[
              H_2(\Theta,\mathbf Z)\xrightarrow{\sim}H_2(J,\mathbf Z).
\]

Thus the homology class `c` has a unique integral lift supported on theta.
The open question is whether that lift is the class of an algebraic signed
one-cycle.  Rational hard Lefschetz does not settle this integral question;
the exact remaining defect is two-primary.

The Banerjee and Banerjee--Iyer--Lewis results on theta pushforwards concern
injectivity, principally for theta divisors in Jacobians or smooth ample
divisors.  They do not prove the surjectivity/support statement needed here,
and they do not compute the singular cubic-theta image.

## 3. Exact primitive lattice

Let

\[
                  L=\Theta\smile-:\bigwedge^6H^1(J,\mathbf Z)
                         \longrightarrow\bigwedge^8H^1(J,\mathbf Z).
\]

In a symplectic basis, the nonzero Smith factors of `L` are

\[
                          (1^{44},2).
\]

Hence

\[
 \operatorname {coker}L\cong\mathbf Z/2,
 \qquad c\notin\operatorname {im}L,
 \qquad 2c\in\operatorname {im}L.
\]

There is an elementary witness for the last assertion.  Write
`e_i=a_i wedge b_i`, `1<=i<=5`, so

\[
       \Theta=\sum_i e_i,
       \qquad c=\sum_{|I|=4}e_I.
\]

Take a five-cycle on the index set and put

\[
 z=\sum_{\{i,j\}\in C_5}e_{\{1,\ldots,5\}\setminus\{i,j\}}.
\]

Every vertex of the five-cycle has degree two, so `Theta z=2c`.  Modulo two,
the sum of the five target equations is zero on every input triple but one
on `c`; this proves that `c` has no integral preimage.

For the marked `A_5` Hodge lattices, the existing C904 divisor certificates
give the sharper restricted calculation

\[
 \begin{aligned}
  \operatorname {rank}\operatorname {Hdg}^6(J,\mathbf Z)&=50,\\
  \operatorname {rank}\operatorname {Hdg}^8(J,\mathbf Z)&=15,\\
  \operatorname {coker}\bigl(
    \Theta:\operatorname {Hdg}^6_{\mathbf Z}
      \to\operatorname {Hdg}^8_{\mathbf Z}\bigr)&\cong\mathbf Z/2.
 \end{aligned}
\]

Both Hodge lattices are saturated and generated by algebraic divisor
products.  An in-memory exact replay from the existing lattice routines
returned

```text
ranks 50 15 15
theta(Hdg6) index in Hdg8 2
quotient invariants (2)
c in Hdg8 True; c in theta(Hdg6) False; 2c in theta(Hdg6) True
```

Therefore the following are equivalent on this marked fibre:

1. `c` is represented by a signed cycle supported on `Theta`;
2. `Theta` supports a signed one-cycle `Z` whose class has odd theta degree;
3. the cycle-class image of `CH_1(Theta)` in `H^8(J,Z)` meets the nonzero
   coset of `Hdg^8/theta Hdg^6`.

Indeed, if `[Z]` is in the odd coset, then
`[Z]-c=Theta z` for an integral Hodge class `z`.  The full Hodge-lattice
certificate represents `z` algebraically by divisor triples, and
`Theta z` is supported on `Theta`.  Subtracting it from `Z` gives a
theta-supported representative of `c`.

This equivalence is special to the certified marked Hodge lattice.  It
should not be advertised for an arbitrary ppav fivefold without the
integral Hodge and algebraicity inputs.

## 4. Consequence for the unordered theta fibre

Let

\[
 q:\Theta\times\Theta\to\operatorname {Sym}^2\Theta,
 \qquad
 f:\operatorname {Sym}^2\Theta\to J
\]

be the quotient and addition maps.  If `Z` is a signed one-cycle on `Theta`,
then the actual cycle

\[
                         W=q_*(Z\times\Theta)
\]

is codimension three on `Sym^2 Theta`.  Its generic degree is

\[
                         \deg_fW=\int_J[Z]\Theta.
\]

For `[Z]=c`, this is

\[
                     \int_J\frac{\Theta^5}{4!}=5.
\]

The currently certified ambient carrier has degree two.  Hence a primitive
theta lift gives degree ideal containing `(2,5)=1`, so the generic quotient

\[
       \bigl(\Theta\cap(a-\Theta)\bigr)/(x\mapsto a-x)
\]

has index one.

The already known class `2c` only gives degree ten and preserves the parity
obstruction.  Shen's `D_+`-supported representative of `c` cannot be used:
the first factor of the product must lie on `Theta`.

Failure to put `c` on theta would not prove index two.  The Chow group of
`Sym^2 Theta` also contains possible middle Kunneth/correspondence terms.
The primitive support theorem closes the `(6,0)+(0,6)` product channel; it
does not exhaust all intrinsic codimension-three cycles.

## 5. Reconciliation with Nakaoka--Gugnin

There is no conflict between the primitive-theta escape and the exact
ambient descent obstruction.

For

\[
 q_A:J\times J\to\operatorname {Sym}^2J,
 \qquad r_a(x)=(x,a-x),
\]

Gugnin's Nakaoka basis says that the pullback of the torsion-free integral
degree-six cohomology is the saturated swap-invariant lattice in
`H^6(J x J,Z)`.  The repeated-even-factorial generator does not occur in
total degree six: an equal split would be `3+3`, and degree-three classes
are odd.

Saturation before restriction is not saturation after restriction.  On a
Nakaoka generator,

\[
 \begin{aligned}
  r_a^*(u\times1+1\times u)&=2u,\\
  r_a^*\bigl(u\times v+(-1)^{|u||v|}v\times u\bigr)
     &=\pm2uv.
 \end{aligned}
\]

The classes of the first type show that the image is exactly

\[
 r_a^*q_A^*H^6(\operatorname {Sym}^2J,\mathbf Z)/\mathrm {tors}
                         =2H^6(J,\mathbf Z).
\]

Pairing with `Theta^2`, whose integral image on `H^6(J,Z)` is `2Z`, gives
ordered ambient degree ideal `4Z` and unordered degree ideal `2Z`.

The primitive cycle `q_*(Z x Theta)` does not contradict this theorem.  It
is intrinsic codimension three on `Sym^2 Theta`; it is not the restriction
of a codimension-three class from `Sym^2 J`.  Pushed into `Sym^2 J`, its
codimension is five.  The exact factor-two ambient theorem and the proposed
odd intrinsic theta class live in different restriction lattices.

This also corrects the tempting but false shorthand:

> "Nakaoka's degree-six pullback is saturated invariants, so no factor two
> occurs."

The first clause is correct in the product.  The factor two appears when
those invariants are restricted to the anti-diagonal addition fibre.

## 6. Red-team and theorem ceiling

### Preempted

- `Theta=F-F` and generic difference degree six: Clemens--Griffiths.
- The sum divisor `D_+`, class `3Theta`, and sum degree two: Shen.
- `c` on `D_+` and `2c` on `Theta`, under universal `CH_0`: Shen.
- Algebraicity of `c` iff universal `CH_0` for a cubic threefold: Voisin.
- The smooth resolution `M_X(v)=Bl_0 Theta` with exceptional cubic: Bayer
  et al.
- The integral symmetric-square pullback lattice: Nakaoka--Gugnin.
- An effective primitive curve is impossible for the cubic ppav by the
  minimal-class/Jacobian criterion.

### Not found / apparently unpreempted

- A signed representative of `c` supported on the cubic theta divisor.
- A computation of
  `im(CH_1(Theta)->CH_1(J))` modulo `Theta Hdg^6`.
- A computation of `CH_1(M_X(v))->CH_1(J)` at the primitive integral class.
- The exact generic index of `Sym^2 Theta -> J`.
- A theorem that every intrinsic codimension-three class on
  `Sym^2 Theta` has even addition degree.

### Strongest honest theorem target

> **Primitive theta-support theorem for the marked `A_5` cubic.**  The
> generator of
> `Hdg^8(J,Z)/(Theta Hdg^6(J,Z)) = Z/2` is algebraic on `Theta`; equivalently,
> `c=Theta^4/4!` has a signed representative supported on `Theta`.

Immediate corollary:

> The geometric generic fibre of `Sym^2 Theta -> J` has index one, witnessed
> by degree two and degree five cycles.

The support theorem is a clean new integral-Chow statement.  The index
corollary is strong but should not be presented as equivalent until the
other Kunneth channels are controlled.

### EJ / TT failure modes

1. **Divide Shen's theta cycle by two.**  Not licensed in Chow; the exact
   cohomology and Hodge cokernels are both `Z/2`.
2. **Replace `D_+` by a translate of `Theta`.**  No source or divisor
   identity does this; `D_+` has class `3Theta`.
3. **Use effectivity.**  This would contradict Matsusaka--Ran.  The target
   is necessarily signed.
4. **Invoke topological Lefschetz.**  Topological support is automatic and
   therefore cannot solve algebraic support.
5. **Invoke the theta resolution without computing its integral curve
   lattice.**  Birational resolution alone gives no primitive Chow lift.
6. **Claim that failure of primitive support proves index two.**  Middle
   correspondence classes on `Theta x Theta` remain a distinct escape.
7. **Claim Nakaoka forbids the intrinsic cycle.**  It forbids the ambient
   codimension-three restriction; the intrinsic class has ambient
   codimension five.

## 7. Source and search ledger

All full texts below were read partially at the named load-bearing passages,
not cover-to-cover.

- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Annals of Mathematics 95 (1972), Theorem 13.4 and proof for
  the degree-six difference map; section 10 equation (10.9) and Lemma 11.27
  for the Fano/incidence polarization identities. DOI `10.2307/1970801`;
  cached PDF SHA-256
  `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.

- Mingmin Shen, *Rationality, universal generation and the integral Hodge
  conjecture*, Geometry & Topology 23 (2019), Section 5.3, especially Lemma
  5.6 and Proposition 5.7. arXiv:`1602.07331`; cached PDF SHA-256
  `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.

- Claire Voisin, *On the universal `CH_0` group of cubic hypersurfaces*,
  Journal of the European Mathematical Society 19 (2017), Theorem 1.7 and
  Corollary 4.4. arXiv:`1407.7261`; cached PDF SHA-256
  `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.

- Arend Bayer, Sjoerd Beentjes, Soheyla Feyzbakhsh, Georg Hein, Diletta
  Martinelli, Fatemeh Rezaee, and Benjamin Schmidt, *The desingularization
  of the theta divisor of a cubic threefold as a moduli space*, Geometry &
  Topology 28 (2024), Proposition 2.2, Remark 2.3, Theorem 7.1, and Lemma
  7.5. arXiv:`2011.12240`; cached PDF SHA-256
  `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.

- Dmitry V. Gugnin, *On Integral Cohomology Ring of Symmetric Products*,
  arXiv:`1502.01862`, Integrality Lemma and Theorem 1. Cached PDF SHA-256
  `74c1d9704d7ddd24f76f314162a44c05727db9770648f6d285679e23b67b4107`.

- Andreas Hoering, *M-regularity of the Fano surface*, arXiv:`0704.0558`,
  equations (1.5)--(1.7), as a modern checked formulation of the incidence
  identities. Cached PDF SHA-256
  `c7640b02600b5c64a54d97689c7e9d4012449720133261e1faaa1e10afeeba08`.

- Kalyan Banerjee, *Theta divisors of abelian varieties and push-forward
  homomorphism at the level of Chow groups*, arXiv:`1609.03636`, abstract
  and theorem scope only; and Banerjee--Iyer--Lewis, *Push-forwards of Chow
  groups of smooth ample divisors*, arXiv:`1805.03461`, abstract and theorem
  scope only.  These are injectivity-side boundary checks, not load-bearing
  support results.

Bounded searches combined `minimal class`, `supported on theta`, `cubic
threefold`, `CH_1(theta)`, `Gysin`, `desingularization`, `moduli`, and
`symmetric square theta`.  OpenAlex listed six citing works for Shen and
nineteen for the 2024 moduli paper.  Their titles and available abstracts
were screened; Shen's citing neighbourhood concerns real integral Hodge
theory, approximation, coniveau, geometric representability, and cylinder
maps, while the moduli-paper neighbourhood is dominated by Bridgeland
moduli and categorical Torelli.  No primitive theta-support or generic
index computation was found.  This is a bounded novelty audit, not a proof
of absence from all literature; a publication-stage audit should add
MathSciNet, zbMATH, and expert citation chasing.
