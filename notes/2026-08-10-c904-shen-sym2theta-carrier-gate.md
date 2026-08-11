# C904 Shen carrier: the degree-15 matching gate and the degree-one support gate

> **Later status (2026-08-10).**  The degree-15 matching branch is dead, not
> open: `2026-08-10-c904-matching-mumford-obstruction.md` proves that the two
> matchings are generically not rationally equivalent.  The simpler
> unordered Fano-sum lift below is the successful fixed-fibre route.  Its
> remaining relative horizontality is audited in
> `2026-08-10-c904-shen-voisin-function-field-descent-audit.md`.

**Date:** 2026-08-10

**Status:** quarantined Annals research; no manuscript or Lean edits

**Scope:** Shen Proposition 5.7, the common-line normalization,
`Sym^2 F -> F+F`, the apparent degree-15 carrier, and the `D_{3,3}` relay

## Executive verdict

Two different questions had been conflated.

1. A five-dimensional cycle dominating the generic fibre of
   \(\operatorname {Sym}^2\Theta\to J\) can be built from Shen's minimal
   cycle on \(D_+=F+F\) and a second Fano pair.  Before the final matching
   choice its base degree is
   \[
      [\eta]\,[D_+]=\frac{\Theta^4}{4!}\,3\Theta=15.
   \]
   Two unordered pairs have two matchings.  The canonical correspondence
   contains both and has degree \(30\).  On the locus of distinct pairs the
   torsor choosing one matching is nontrivial, so the proposed construction
   does **not** canonically produce degree \(15\).

2. The relative Abel--Jacobi lifting problem needs much less.  Choose the
   common line \(\ell _0\), normalize
   \(a(\ell)=AJ(\ell-\ell _0)\), and put \(\Theta=F-F\).  Then
   \(0\in F\), hence
   \[
       F\subset\Theta,
       \qquad \operatorname {Sym}^2F\subset
          \operatorname {Sym}^2\Theta.
   \]
   If Shen's \(\eta\) has an integral lift
   \(\bar\eta\in CH_1(\operatorname {Sym}^2F)\), that lift already maps
   with degree one to \(\eta\) under addition.  No second pair and no
   matching are needed.

The exact provisional obstruction to this simpler lift is the class

\[
 \epsilon_\eta=[\eta]\in
 \operatorname {coker}\!\left(
 CH_1(\operatorname {Sym}^2F)\xrightarrow{\,b_*\,}CH_1(D_+)
 \right),
 \qquad 2\epsilon_\eta=0,
\]

where \(b:\operatorname {Sym}^2F\to D_+\) is the proper birational sum
map.  The equality \(2\epsilon_\eta=0\) is immediate from Shen:
if \(q:F\times F\to\operatorname {Sym}^2F\), then

\[
 b_*q_*\widetilde\theta
   =(\phi_+)_*\widetilde\theta=2\eta.
\]

Shen alone proves only that this obstruction has exponent at most two.
Beauville's blow-up model supplies the coprime second exponent:

\[
                         5\epsilon_\eta=0.
\]

Indeed, \(b\) is the restriction to the strict transform of \(D_+\) of
the blow-up of \(J_2(X)\) along the Fano surface \(F_2\).  It is an
isomorphism away from \(F_2\).  Its exceptional fibre over a line is the
plane-quintic discriminant of the conic bundle obtained by projecting the
cubic from that line.  A relative hyperplane cuts this plane quintic in
degree five.  Localization therefore shows that the entire cokernel of
\(b_*\) on one-cycles is killed by five.

Since \(2\epsilon_\eta=5\epsilon_\eta=0\), Bezout gives
\(\epsilon_\eta=0\).  Thus

> **Fano-sum lifting theorem.**  Shen's minimal cycle \(\eta\) admits an
> integral lift
> \(\bar\eta\in CH_1(\operatorname {Sym}^2F)\).  Under the common-line
> normalization, its image in \(\operatorname {Sym}^2\Theta\) maps with
> degree one to \(\eta\) under addition.

If \(\epsilon_\eta=0\), and the chosen lift meets Voisin's open locus where
\(D_{3,3}\to\operatorname {Sym}^2\Theta\) has fibre birational to
\(\operatorname {Sym}^2E_3\), the plane cubic supplies a degree-three
zero-cycle in the fibre.  Closing it gives a multiplier-three lift of
\(\eta\).  Combining this with the already available multiplier two gives
the identity by Bezout.  This is a valid conditional proof spine.

This is an unconditional fixed-fibre theorem under Shen's stated
universal-`CH_0` hypothesis.  It is not yet an unconditional relative
theorem: one still needs a horizontal relative \(\eta\) and avoidance of
the special `D_{3,3}` locus.  Shen's theorem is fixed-fibre and does not
globalize these choices.

## 1. Exact normalization and the direct support lift

Let \(X\) be a smooth cubic threefold, \(F=F(X)\), and choose
\(\ell_0\in F\).  With

\[
                 a(\ell)=AJ(\ell-\ell_0),
\]

one has \(a(\ell_0)=0\).  Clemens--Griffiths identify the image of the
difference morphism with a theta divisor.  We choose that representative:

\[
                         \Theta=F-F.
\]

It follows set-theoretically and scheme-theoretically that \(F\subset
\Theta\), by \(x=x-0\).  Hence the closed immersion \(F\hookrightarrow
\Theta\) induces

\[
              j:\operatorname {Sym}^2F\hookrightarrow
                 \operatorname {Sym}^2\Theta.
\]

Let

\[
 b:\operatorname {Sym}^2F\longrightarrow D_+=F+F
\]

be addition.  Shen Lemma 5.6 says that \(F\times F\to D_+\) has generic
degree two.  Since factor exchange already accounts for those two sheets,
\(b\) is proper birational.

For any \(\bar\eta\in CH_1(\operatorname {Sym}^2F)\), addition on
\(\operatorname {Sym}^2\Theta\) restricts to \(b\).  Therefore

\[
              b_*\bar\eta=\eta
 \quad\Longrightarrow\quad
 f_*j_*\bar\eta=\eta,
\]

where \(f:\operatorname {Sym}^2\Theta\to J\) is addition.  This is an
integral degree-one lift over the support cycle \(\eta\).  It is unrelated
to choosing an ordering of the two lines: points of
\(\operatorname {Sym}^2F\) are already the required unordered pairs.

This does **not** by itself give a cycle dominating all of \(J\).  The lift
has dimension one and maps onto the one-dimensional support of \(\eta\).
That is sufficient for lifting the relative minimal cycle componentwise,
but not for proving directly that the geometric generic fibre of
\(\operatorname {Sym}^2\Theta\to J\) has index one.

## 2. The exact `2`--`5` Chow lifting theorem

Define

\[
 Q_b=\operatorname {coker}\!\left(
 CH_1(\operatorname {Sym}^2F)\xrightarrow{b_*}CH_1(D_+)
 \right).
\]

Shen Proposition 5.7 constructs an integral symmetric cycle
\(\widetilde\theta\in CH_1(F\times F)\) and an integral cycle
\(\eta\in CH_1(D_+)\) such that

\[
    (\phi_+)_*\widetilde\theta=2\eta,
    \qquad -[\eta]=\frac{\Theta^4}{4!}
\]

in his sign convention.  Since \(\phi_+=bq\), the integral cycle
\(q_*\widetilde\theta\) on \(\operatorname {Sym}^2F\) maps to
\(2\eta\).  Hence

\[
                         \epsilon_\eta:=[\eta]\in Q_b[2].
\]

By definition,

\[
 \epsilon_\eta=0
 \quad\Longleftrightarrow\quad
 \exists\bar\eta\in CH_1(\operatorname {Sym}^2F)
       \text{ with }b_*\bar\eta=\eta.
\]

This is the precise necessary-and-sufficient integral datum.  It is a Chow
cokernel class, not the ordering cover of a chosen strict transform.  Shen
proves that it is killed by two; Beauville's boundary geometry proves that
the whole cokernel is killed by five.

Beauville identifies the compact charge-two moduli space with

\[
       \pi:\overline M_2\simeq
       \operatorname {Bl}_{F_2}J_2(X)\longrightarrow J_2(X).
\]

His boundary divisor \(B\) of split sheaves
\(I_{\ell_1}\oplus I_{\ell_2}\) is \(\operatorname {Sym}^2F\), and
\(\pi|_B=b\) maps it onto \(D_+=F+F\).  Thus \(B\) is the strict
transform of \(D_+\), and

\[
 b:B\setminus b^{-1}(F_2)\xrightarrow{\sim}D_+\setminus F_2.
\]

Let \(A=\mathbf P(N_{F_2/J_2})\) be the exceptional divisor of the
blow-up.  It is a \(\mathbf P^2\)-bundle over \(F_2\).  The fibre over the
point indexed by a line \(\ell\) parametrizes the residual conics in the
planes through \(\ell\).  Its intersection with \(B\) parametrizes the
singular residual conics, hence the unordered pairs of their two line
components.  Projection from \(\ell\) identifies this intersection with
the plane-quintic discriminant \(\Delta_\ell\subset\mathbf P^2\).

Consequently, if \(H=c_1(\mathcal O_A(1))\), the divisor \(A\cap B\) has
relative degree five.  For every integral curve \(C\subset F_2\), the
one-cycle

\[
       \Gamma_C=H\cdot[A\cap B]|_C
\]

is generically finite of degree five over \(C\), and therefore

\[
                         b_*[\Gamma_C]=5[C].
\]

Now apply localization.  Given \(z\in CH_1(D_+)\), lift its restriction
to \(D_+\setminus F_2\) through the displayed isomorphism and close that
lift in \(B\).  The difference from \(z\) is the pushforward of a
one-cycle on \(F_2\).  The preceding relative-hyperplane construction
lifts five times that difference.  Hence

\[
                         5Q_b=0.
\]

Combining this with Shen's \(2\epsilon_\eta=0\) gives
\(\epsilon_\eta=0\).  More explicitly, put

\[
       \alpha=q_*\widetilde\theta,
       \qquad b_*\alpha=2\eta.
\]

The five-torsion argument supplies \(\lambda\in CH_1(B)\) with
\(b_*\lambda=5\eta\).  Then

\[
                 \bar\eta=3\alpha-\lambda,
                 \qquad b_*\bar\eta=\eta.
\]

This is an integral signed cycle, exactly the kind allowed by Shen's
minimal-class statement.  No effectivity is claimed or needed.

The localization proof also reconciles the two earlier shorthand
statements:

- “\(D_+\) is birational to \(\operatorname {Sym}^2F\)” proves the lift on
  the birational locus;
- “Shen provides only \(2\eta\) upstairs” records the possible exceptional
  two-torsion class before Beauville's plane-quintic fibre is used.

The odd degree-five exceptional cut kills that last class.

## 3. Why the absolute degree-15 matching still fails

Suppose temporarily that \(\bar\eta\) exists.  Pair its unordered Fano pair
with a second unordered pair in \(\operatorname {Sym}^2F\).  On the open
locus of distinct pairs, write

\[
             z=\{a,b\},\qquad t=\{c,d\}.
\]

The difference of the sums is represented in
\(\operatorname {Sym}^2\Theta\) in two ways:

\[
 \{a-c,b-d\},\qquad \{a-d,b-c\}.
\]

Both have addition value \(a+b-c-d\).  They are distinct away from the two
diagonals: equality of the unordered pairs forces either \(a=b\) or
\(c=d\).

Let

\[
 O=(F\times F\setminus\Delta_F)\longrightarrow
 S^\circ=(\operatorname {Sym}^2F)\setminus\Delta_F
\]

be the ordering double cover, with class
\(e\in H^1_{\mathrm{et}}(S^\circ,\mathbf Z/2)\).  It is connected and
nontrivial.  If \(C^\circ\) is a non-diagonal component of
\(\bar\eta\), the torsor of matchings on
\(C^\circ\times S^\circ\) is the contracted product of the two ordering
torsors.  Its class is

\[
       m_C=\operatorname {pr}_1^*(e|_{C^\circ})+
              \operatorname {pr}_2^*e.
\]

This class is nonzero.  Pulling it back to \(\{c\}\times S^\circ\), for a
complex point \(c\in C^\circ\), gives \(e\ne0\).  Consequently the matching
cover has no rational section.  A coefficient-one selection of one of the
two matchings is impossible on this product.

The base map

\[
       \eta\times D_+\longrightarrow J,
       \qquad (z,t)\longmapsto z-t,
\]

has signed degree

\[
  \int_J[\eta][D_+]
     =\int_J\frac{\Theta^4}{4!}\,3\Theta=15.
\]

The full matching correspondence is a double cover of this base and has
degree \(30\).  Thus the naïve absolute carrier is even.

There is one apparent branch loophole.  If a component comes from the
diagonal \(F\subset\operatorname {Sym}^2F\), the two matchings coincide.
It cannot change parity.  For a curve \(C\subset F\), its sum image is
\([2]_*a_*C\), and Hoering's identity \(a^*\Theta\equiv2C_s\) gives

\[
 \begin{aligned}
 D_+\cdot[2]_*a_*C
 &=3[2]^*\Theta\cdot a_*C\\
 &=12a^*\Theta\cdot C\\
 =24C_s\cdot C.
 \end{aligned}
\]

Every diagonal correction therefore has even, in fact `24`-divisible,
base degree.

This proves that the canonical two-matching construction is even.  It does
not prove that no unrelated degree-15 cycle exists, nor that the pushforward
cycle could never be divisible by two for an accidental Chow-theoretic
reason.  Those would be stronger statements about
\(CH^3(\operatorname {Sym}^2\Theta)\), not consequences of the matching
torsor.

## 4. Conditional `D_{3,3}` closure

Voisin constructs a surjective morphism

\[
             \chi:D_{3,3}\longrightarrow
                    \operatorname {Sym}^2\Theta
\]

whose general fibre is birational to \(\operatorname {Sym}^2E_3\), with
\(E_3\) a plane cubic.  The plane hyperplane class gives a zero-cycle of
degree three on \(E_3\).  After passing to a smooth proper model, this gives

\[
             \operatorname {ind}(\operatorname {Sym}^2E_3)\mid3.
\]

The `2`--`5` theorem supplies \(\bar\eta\).  Assume in addition that every
component used in this signed lift meets the open where the above fibre
description and the rational map \(D_{3,3}\dashrightarrow M_9\) are valid.

Then the generic fibre over each component has an odd zero-cycle of degree
dividing three.  Taking degree three uniformly and closing the resulting
generic cycles produces an integral cycle over \(\bar\eta\) of degree
three.  Since \(\eta\) has the minimal cohomology class, its image in the
fine charge-three moduli construction induces \(\pm[3]\) on the intermediate
Jacobian.  The Fano incidence construction independently induces \([2]\).
A signed Bezout combination of these two correspondences induces the
identity.

This is the promised odd closure.  The remaining fixed-fibre condition is
good-locus incidence for the actual signed lift; the plane-cubic relay
itself is odd and causes no two-primary loss.

## 5. Why the plane-quintic five-cover is not an independent `[5]`

The `2`--`5` proof constructs a natural surface

\[
              \Gamma=H\cdot[A\cap B]
                  \longrightarrow F_2
\]

of generic degree five.  Its points carry unordered pairs of lines, and
their Abel--Jacobi sum is the corresponding point of \(F_2\).  On Albanese
varieties, pullback followed by norm therefore satisfies

\[
        \operatorname {Nm}_{\Gamma/F_2}\circ p^*=[5]
              \quad\text{on }\operatorname {Alb}(F_2)\simeq J.
\]

This is an odd Albanese correspondence.  It is **not** a universal cubic
cycle on \(J\times X\).  The family of line pairs is parametrized by the
surface \(\Gamma\), not by its Albanese variety.  Extending it from
\(\Gamma\) to \(\operatorname {Alb}(\Gamma)\), and then transporting it
through the displayed Albanese map, is exactly a universal-generation
problem.  An Albanese homomorphism records the Abel--Jacobi values of a
given family; it does not manufacture a family of algebraic one-cycles over
every point of the Albanese.

The only source-backed composition with the existing relative machinery
pulls the Fano incidence `[2]` correspondence through the degree-five
cover.  Norm then gives

\[
                              5\cdot[2]=[10],
\]

not `[5]`.  Cutting the plane-quintic surface over a curve in \(F_2\) does
not help: every curve \(C\subset F_2\), a translate of the Fano surface,
has

\[
                         \Theta\cdot C=2C_s\cdot C\in2\mathbf Z.
\]

Thus the boundary five-cover kills the exceptional Chow obstruction to
lifting an already existing minimal \(\eta\), but it does not independently
provide an odd minimal one-cycle or an odd universal correspondence.  If it
did, the same construction would solve the universal-cycle problem for
every smooth cubic threefold, without Shen's hypothesis; neither
Beauville's theorem nor the construction contains that missing extension.

## 6. The two matching points are generically not rationally equivalent

Return to four ordered Fano points \((a,b,c,d)\).  The two matching points
of \(\operatorname {Sym}^2\Theta\) are

\[
       m_0=\{a-c,b-d\},\qquad
       m_1=\{a-d,b-c\}.
\]

If \(m_0\) and \(m_1\) were rationally equivalent, the universal
degree-two cycle on the symmetric square and proper pushforward to \(J\)
would give

\[
 \begin{aligned}
 R(a,b,c,d)
   &=[a-c]+[b-d]-[a-d]-[b-c]\\
   &=([a]-[b])*([-c]-[-d])=0
       \quad\text{in }CH_0(J),
 \end{aligned}
\]

where `*` is Pontryagin product.

This rectangle is generically nonzero.  Mumford's induced-form theorem says
that a family of rationally equivalent zero-cycles annihilates every
induced holomorphic form.  Let \(\omega\in H^0(J,\Omega_J^2)\) be invariant.
For the four-map correspondence defining \(R\), the pure-factor terms
cancel and the induced form is the cross term

\[
       R^*\omega
        =-K_\omega\bigl(d(a-b),d(c-d)\bigr),
\]

where \(K_\omega\) is the bilinear polarization of \(\omega\) between the
two factor pairs.  The Fano Albanese embedding induces an isomorphism on
holomorphic one-forms, and the difference map \(F\times F\to\Theta\) is
generically finite.  Hence this cross form is nonzero for a suitable
\(\omega\).  Mumford's theorem therefore forbids a generic rational
equivalence \(m_0\sim m_1\), even with rational coefficients.

The restriction to Shen's carrier has one possible degeneracy.  On a curve
of Fano pairs for which \(a-b=r\) is constant, the induced two-form above
vanishes.  Such a component cannot carry the odd part of the degree-15
intersection by itself: its sum image is \(2a-r\), and

\[
      D_+\cdot[2]_*a_*C=24C_s\cdot C.
\]

Thus every constant-difference component contributes an even, in fact
`24`-divisible, degree.  Since the total base degree is `15`, some
nonconstant-difference component carries odd degree, and on that component
the Mumford cross-form obstruction applies.

Voisin's \(\operatorname {Sym}^2E_3\) geometry does not alter this result.
Those ruled surfaces are fibres of
\(\chi:D_{3,3}\to\operatorname {Sym}^2\Theta\) over a **fixed** matching
point.  They provide odd vertical zero-cycles, but do not connect two
distinct points \(m_0,m_1\) of the base.  Any rational equivalence upstairs
connecting their lifts would push forward to a nonzero multiple of
\(m_0-m_1\) downstairs, contradicting the rectangle calculation on the
nonconstant-difference component.

Therefore the two-matching degree-30 correspondence cannot be halved to
degree `15` by componentwise rational equivalence.  A wholly different
global Chow cancellation is not excluded, but neither the matching
geometry nor `D_{3,3}` supplies one.

## 7. Relative status and circularity

The common line globalizes the normalization on the marked pencil:
\(\mathcal F\subset\Theta_B\) and
\(\operatorname {Sym}^2\mathcal F\subset
\operatorname {Sym}^2\Theta_B\) after shrinking the smooth base.  Voisin's
rational-cubic theta is defined only up to translation; the common line
trivializes the degree torsors, and translating the degree-three target and
twice that amount in degree six aligns her additive diagram with
\(\Theta_B=\mathcal F-\mathcal F\).

Shen Proposition 5.7 is nevertheless a fixed-fibre theorem.  It assumes
universal `CH_0`-triviality and makes noncanonical auxiliary choices.  It
does not construct a horizontal cycle
\(\eta_B\in CH_1(D_{+,B}/B)\), much less prove vanishing of the relative
version of \(\epsilon_\eta\).

For C904 there is a useful distinction:

- **fixed fibre:** the independently constructed algebraic minimal class,
  together with Voisin's equivalence, supplies Shen's hypothesis.  Using
  Shen here is not a logical circle, although it recovers a consequence
  already implicit in the fixed-fibre theory;
- **relative identity:** fibrewise existence does not yield a cycle over
  the marked base.  Spreading may require a finite base change, and norm
  back multiplies by its uncontrolled degree.  This is the genuine parity
  and descent gap.

Thus the noncircular positive target is explicit:

> Construct a horizontal \(\bar\eta_B\) in
> \(CH_1(\operatorname {Sym}^2\mathcal F/B)\) whose addition pushforward is
> the relative minimal cycle, and verify that its components meet Voisin's
> good `D_{3,3}` locus.

That theorem would close the odd relative Abel--Jacobi gate.  Neither Shen's
paper nor the current divisor certificate supplies it automatically.

## 8. Primary sources and read depth

1. **Mingmin Shen, _Rationality, universal generation and the integral
   Hodge conjecture_.**  Read depth: **claim-specific partial**, Theorem
   5.1, Lemma 5.6, Proposition 5.7 and their proofs, arXiv:`1602.07331`.
   Cache SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.
2. **C. Herbert Clemens and Phillip A. Griffiths, _The intermediate
   Jacobian of the cubic threefold_.**  Read depth: **claim-specific
   partial**, Section 13 and Theorem 13.4.  Cache key `10.2307/1970801`,
   SHA-256
   `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.
3. **Claire Voisin, _Abel--Jacobi map, integral Hodge classes and
   decomposition of the diagonal_.**  Read depth: **claim-specific
   partial**, Section 2 at the construction of
   \(D_{3,3}\to\operatorname {Sym}^2\Theta\), Lemma 2.4, and the general
   \(\operatorname {Sym}^2E_3\) fibre, arXiv:`1005.5621`.  Cache SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
4. **Andreas Hoering, _M-regularity of the Fano surface_.**  Read depth:
   **full text** (five pages), especially equation (1.5)
   \(a^*\Theta\equiv2C_s\), arXiv:`0704.0558`.  Cache SHA-256
   `c7640b02600b5c64a54d97689c7e9d4012449720133261e1faaa1e10afeeba08`.
5. **Arnaud Beauville, _Vector bundles on the cubic threefold_.**  Read
   depth: **claim-specific partial**, the conic-bundle discriminant in
   Section 3.2 and Theorem 6.3, Corollary 6.4, and Remark 6.5 in Section 6,
   arXiv:`math/0005017`.  Cache SHA-256
   `18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f`.
6. **Joe Harris, Mike Roth, and Jason Starr, _Abel--Jacobi maps associated
   to smooth cubic threefolds_.**  Reused from the C904 normalization
   audit at the base-cycle translation rule and the rational-cubic theta
   translate.  Cache SHA-256
   `fae17135016e77425060e8c0860c9938facda3144ac1cd091a853d34c337d3ec`.
7. **David Mumford, _Rational equivalence of 0-cycles on surfaces_.**
   Read depth: **full text** (eight-page translation), especially Section 1
   on induced differentials and the main theorem in Section 2 that a family
   of rationally equivalent zero-cycles has zero induced two-form.  DOI
   `10.1215/kjm/1250523940`.  Cache SHA-256
   `23b980e0d0e9b14867ddb7ae897f3e29c60daa90fa48ad5fc526c0101fe598bb`.

This report made two full-text reads and five claim-specific partial reads
(one reused).  The bounded search found no primary theorem computing
the `2`--`5` Chow combination above or globalizing Shen's \(\eta\) in a
family.  The two load-bearing geometric inputs are printed by Shen and
Beauville; their coprime combination is the project-specific deduction.

## 9. Mystery ledger

- **Settled:** the common-line normalization gives
  \(\operatorname {Sym}^2F\subset\operatorname {Sym}^2\Theta\).
- **Settled:** an integral unordered lift of \(\eta\) maps degree one over
  its support; no matching is needed for the relative lifting problem.
- **Settled positively:** Shen gives \(2\epsilon_\eta=0\), Beauville's
  plane-quintic exceptional fibre gives \(5Q_b=0\), and hence
  \(\epsilon_\eta=0\).
- **Settled negatively:** the absolute `15` construction has a nontrivial
  matching torsor and canonically gives degree `30`; diagonal degeneracies
  cannot change parity.
- **Settled negatively:** Beauville's degree-five exceptional surface gives
  `[5]` only on Albanese after pullback/norm; promoting its line-pair family
  to `J` is the missing universal-generation problem.  The licensed
  incidence composition is `[10]`.
- **Settled negatively:** the two matching points have a generically
  nonzero Pontryagin rectangle in `CH_0(J)`, detected by Mumford's induced
  two-form.  `D_{3,3}` is vertical over them and does not rationally identify
  them.
- **Conditionally settled:** avoidance of Voisin's bad locus for the lifted
  signed components gives a multiplier-three lift and closes against the
  existing multiplier two.
- **Open:** construct the lift horizontally on the marked base.
- **Open:** verify good-locus intersection for the actual signed
  components, rather than for a generic auxiliary curve.

**Vibe:** the common-line observation plus Beauville's odd exceptional
plane quintic closes the fixed-fibre support lift.  The old degree-15
matching route is still even; the surviving high-value work is relative
globalization and `D_{3,3}` good-locus control.
