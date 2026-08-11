# C904: EFS, Shen, and the symmetric-theta index gate

Date: 2026-08-11  
Scope: bounded primary-source audit; no manuscript or Lean edit  
Read depth: zero sources newly read cover-to-cover; six primary sources read at the partial depths recorded below  
Verdict: **the very-general theta-supported curve lattice is exactly even, but no theorem found computes the generic index of \(\operatorname{Sym}^2\Theta\to J\), and none transfers the parity obstruction to the special \(A_5\) locus**

## 1. Strongest exact consequence of EFS

Let \(X\) be a very general cubic threefold, \(J=J(X)\), and let
\(i:\Theta\hookrightarrow J\) be its theta divisor. Write

\[
                  c=\frac{\Theta^4}{4!}\in H_2(J,\mathbf Z)
\]

for the minimal curve class. Engel--de Gaay Fortman--Schreieder,
Theorem 1.3, proves that the class of every algebraic curve on \(J\) is an
even multiple of \(c\). Since \(J\) has Picard rank one at the very general
point, this gives

\[
 \operatorname{cl}\bigl(i_*CH_1(\Theta)\bigr)\subseteq 2\mathbf Zc.
\]

The reverse inclusion is geometric. For a line \(s\) on \(X\), the
translated incidence curve

\[
       C_s-s\subset F-F=\Theta
\]

has class \(2c\). In the classical normalization
\(a^*\Theta=2C_s\) and \(C_s^2=5\), hence

\[
 \Theta\cdot a_*C_s=10= \Theta\cdot 2c.
\]

Thus the exact cohomological image is

\[
 \boxed{\;
 \operatorname{cl}\bigl(i_*CH_1(\Theta)\bigr)=2\mathbf Zc
 \quad\text{for a very general cubic threefold.}\;}
\]

This says nothing about the homologically trivial kernel or the full Chow
group. It is nonetheless the sharp integral answer to the
curve-supported-on-theta question at a very general point.

## 2. Why this does not compute the theta-sum index

Put

\[
 f:\operatorname{Sym}^2\Theta\longrightarrow J,
 \qquad \{x,y\}\longmapsto x+y.
\]

An odd multisection is a codimension-three cycle on
\(\operatorname{Sym}^2\Theta\). Its pullback to
\(\Theta\times\Theta\) can have:

- \(H^4(\Theta)\otimes H^2(\Theta)\) and its transpose;
- \(H^3(\Theta)\otimes H^3(\Theta)\);
- intrinsic primal-middle components.

There is no source-backed operation taking every such odd-degree class to
an odd curve class on \(J\) or to an odd curve supported on \(\Theta\).
Cupping a multisection with \(f^*\Theta^4\) only produces the algebraic
class \(4!\,d\,c\), which is even regardless of the degree \(d\). Dividing
by \(4!\) is precisely the unavailable integral-algebraicity step.

Consequently EFS does **not** imply
\(\operatorname{ind}(f_\eta)=2\). It eliminates the simplest
theta-supported-curve route to index one, but leaves the middle-theta and
correspondence routes untouched. This agrees with the earlier
Nakaoka--Gugnin/Chow-descent audit.

## 3. Exact EFS hypothesis failure on the \(A_5\) family

EFS prove Theorem 1.3 by taking a ten-parameter universal smoothing of the
ten-nodal Segre cubic. Gwena's monodromy identifies the resulting
matroidal family with the non-cographic regular matroid \(R_{10}\). Their
Theorems 1.6, 1.8, and 1.9 then force the coefficient of the minimal curve
class to be even on a **very general** fibre.

The proof requires:

1. a curve on a very general fibre, so that after a generically finite base
   change it spreads over an open subset of the full family;
2. all monodromy operators of the multivariable degeneration;
3. the non-cographic \(R_{10}\) matroid.

None survives automatically after restriction to the one-dimensional
\(A_5\)-invariant cubic family. The ten smoothing parameters collapse to
their \(A_5\)-invariant combinations, so the \(R_{10}\) coloured-monodromy
input is lost. A one-parameter degeneration does not satisfy the stated
non-cographic matroidal hypothesis merely because its ambient universal
deformation does.

There is an independent Hodge-theoretic reason not to specialize the
conclusion blindly. The generic \(A_5\)-cubic has the extra \(A_5\)
endomorphism structure and \(J\sim E^5\); it lies in a proper special
subvariety of the cubic locus and is not a very general cubic. EFS do not
mention the \(A_5\) family and prove no parity statement on it.

### Specialization direction

Beckmann--de Gaay Fortman, Corollary 4.3, proves that in a principally
polarized abelian scheme over a proper smooth connected complex base, the
locus where the integral Hodge conjecture for one-cycles holds is a
countable union of closed algebraic subvarieties. In particular, a
positive result on a nonempty open specializes to all fibres.

The converse is false: a special fibre can acquire extra algebraic cycles
which do not deform. EFS explicitly work with very general fibres, and
their introduction notes that cubic threefolds with decomposition of the
diagonal form a nonempty countable union of special subvarieties.
Therefore:

- an odd minimal curve on an \(A_5\) fibre would not contradict EFS;
- algebraicity of \(c\) on the generic \(A_5\) fibre could spread within
  that family, but would not spread to the full cubic moduli space;
- failure at the very general cubic gives no specialization obstruction to
  the \(A_5\) family.

The same one-way rule applies more strongly to support on \(\Theta\): a
relative theta-supported curve specializes, but a curve appearing on a
special theta divisor need not deform.

## 4. What Shen proves, exactly

Shen's Proposition 5.7 assumes that the cubic threefold has universally
trivial \(CH_0\), equivalently the relevant Chow-theoretic decomposition of
the diagonal. Under that hypothesis he proves:

1. \(c\) is algebraic and supported on
   \(D_+=\operatorname{im}(F\times F\xrightarrow{+}J)\), a divisor of
   class \(3\Theta\);
2. \(2c\) is represented by a symmetric one-cycle supported on
   \(\Theta=\operatorname{im}(F\times F\xrightarrow{-}J)\).

The exact degrees are

\[
 \deg(F\times F\to D_+)=2,\qquad
 \deg(F\times F\to\Theta)=6.
\]

Shen does **not** prove that \(c\) is supported on \(\Theta\), compute
\(i_*CH_1(\Theta)\), construct an odd multisection of
\(\operatorname{Sym}^2\Theta\to J\), or compute its generic index.
Moreover Proposition 5.7 cannot be used to prove its own universal-\(CH_0\)
hypothesis.

On an \(A_5\)-cubic, even an independent proof that \(c\) is algebraic
would not upgrade Shen's second statement from \(2c\) to \(c\). The
factor two is the unresolved gate, not a wording artefact.

## 5. Degeneration and index specialization

For a proper flat model over a DVR, specialization of zero-cycles preserves
degree. In a compatible family of theta-sum maps this gives the useful
one-way principle

\[
 \operatorname{ind}(\text{special generic theta-sum fibre})
 \mid
 \operatorname{ind}(\text{generic theta-sum fibre}).
\]

Thus an actual index-two computation on a special member of the \(A_5\)
pencil could obstruct index one on its generic member. Conversely an
index-one special fibre says nothing about the generic fibre.

No audited source performs such a computation. Two technical warnings
make a boundary argument non-formal:

1. **The theta divisor does not extend naively over moduli.** Botero,
   Burgos Gil, Holmes, and de Jong show that the stack of theta choices is
   an \(A[2]\)-torsor over \(\mathcal A_g\), and on their toroidal
   compactification only \(8\overline\Theta\) is canonically Cartier.
   Their pure extension is an adelic/log \(b\)-divisor. The paper computes
   no Chow group or zero-cycle index. The factor \(8\) makes it unusable
   for a two-primary argument without a separately chosen integral
   relative theta model.
2. **Boundary multiplicities are not the ordinary index.**
   Kesteloot--Nicaise define the specialization index and exhibit proper
   varieties whose ordinary index is one while their specialization index
   is larger. A gcd extracted from an snc boundary can therefore obstruct
   rational points without proving that the zero-cycle index is even.

EFS construct a Mumford/matroidal degeneration of abelian varieties over a
punctured polydisc. They do not construct the relative
\(\operatorname{Sym}^2\Theta\) addition map, a flat compactification of its
generic fibre, or a specialization map for its degree ideal. Their
degeneration cannot be cited for the missing index statement.

## 6. Other nearby Chow results do not close the gate

Banerjee and collaborators prove injectivity results for pushforward from
smooth ample theta divisors in Jacobians, generally with rational
coefficients or under Jacobian/embedding hypotheses. These results:

- concern the kernel, not the image, of Chow pushforward;
- do not establish surjectivity onto a primitive minimal curve;
- do not cover the singular theta divisor of a cubic intermediate
  Jacobian in the required integral form.

Markman's rational Hodge results and Beckmann--de Gaay Fortman's integral
Fourier criteria concern algebraicity on \(J\), not support on \(\Theta\).
Neither computes the codimension-three Chow descent lattice of
\(\operatorname{Sym}^2\Theta\).

## 7. Exact status and best theorem target

### Forced today

- For a very general cubic,
  \[
  \operatorname{cl}(i_*CH_1(\Theta))=2\mathbf Zc.
  \]
- EFS therefore rules out an odd theta-supported minimal curve at the very
  general point.
- Shen supplies \(2c\) on theta under his stated hypothesis, not \(c\).

### Not forced

- index one or index two for the generic fibre of
  \(\operatorname{Sym}^2\Theta\to J\), even for a very general cubic;
- either index on the generic \(A_5\)-cubic;
- a specialization obstruction from the Segre/\(R_{10}\) degeneration;
- surjectivity of \(CH_1(\Theta)\to CH_1(J)\) on the \(A_5\) locus.

The strongest still-unpreempted target is therefore unchanged:

> Compute the integral degree ideal of the geometric generic fibre of
> \(\operatorname{Sym}^2\Theta\to J\), by controlling the algebraic
> \(H^4(\Theta)\otimes H^2(\Theta)\) and
> \(H^3(\Theta)\otimes H^3(\Theta)\) descent classes.

For the \(A_5\) fibre, the most plausible specialized replacement is:

> Compute the \(A_5\)-equivariant algebraic Gysin image
> \(i_*CH_1(\Theta)\subset CH_1(J)\) and the middle-theta correspondence
> lattice using the marked \(E^5\) operators.

The second problem is not answered by a degeneration theorem currently in
the audit.

## 8. Search boundary and read-depth ledger

- **Partial, load-bearing:** Philip Engel, Olivier de Gaay Fortman, Stefan
  Schreieder, *Matroids and the integral Hodge conjecture for abelian
  varieties*, arXiv:2507.15704, current cached version; Introduction,
  Sections 1.2--1.4, 2.5, and 8.4. Cache SHA-256
  f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee.
- **Partial, load-bearing:** Mingmin Shen, *Rationality, universal
  generation and the integral Hodge conjecture*, arXiv:1602.07331,
  Section 5.3, Lemma 5.6 and Proposition 5.7. Cache SHA-256
  2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c.
- **Partial, specialization direction:** Thorsten Beckmann and Olivier de
  Gaay Fortman, *Integral Fourier transforms and the integral Hodge
  conjecture for one-cycles on abelian varieties*, arXiv:2202.05230,
  Corollary 4.3 and Lemma 4.4. Cache SHA-256
  ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc.
- **Partial, degeneration warning:** Ana María Botero, José Ignacio Burgos
  Gil, David Holmes, Robin de Jong, *Pure extension of the theta divisor
  over the moduli space of abelian varieties*, arXiv:2602.22162,
  Introduction and main theorem statement. Cache SHA-256
  1b9294ac5111e45929f4dd0c4074b49394cb216d546548e359e0d0b993dec611.
- **Partial, index warning:** Lore Kesteloot and Johannes Nicaise, *The
  specialization index of a variety over a discretely valued field*,
  arXiv:1505.08018, Introduction and Section 2 through Definition 2.1
  and paragraph 2.2. Cache SHA-256
  6addc2cd225e555d2fdbcde1c8b1aaa7fbb72ae15fe0a82b323043db24cc275c.
- **Partial, \(A_5\) boundary:** Roulleau, arXiv:1002.4467, Theorem 11
  and the \(A_5,D_5\) sections; Hartlieb, arXiv:2304.03214, Section 5.3
  and Remark 5.8. Cache SHA-256 respectively
  c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd
  and
  3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01.
- **Abstract/metadata only, dismissed:** Kalyan Banerjee and collaborators,
  arXiv:1609.03636, 1504.07887, and 1805.03461; the retrieved
  abstracts state injectivity results under Jacobian/smooth-divisor
  hypotheses, not image or index results.

The exact bounded search page used:

    "CH_1" "theta divisor" abelian variety pushforward
    "Chow group" "theta divisor" "one-cycles" abelian
    "CH_1(Theta)" "CH_1(A)"
    "theta divisor" "minimal class" supported curve cubic threefold

It returned seventeen title/snippet records; all were screened. The
promoted primary sources are listed above. Exact searches coupling
Sym2 Theta, generic index, A5 cubic, specialization, and zero-cycle found
no theorem beyond the sources already recorded in the earlier
symmetric-theta audit. MathSciNet was not covered. This is a bounded
negative, not a claim of global absence.

## Mystery ledger: \(ej+tt\) closeout

- **Settled:** EFS gives the exact very-general cohomological image of
  theta-supported curves once combined with the classical incidence curve.
- **Settled:** this does not control the middle Künneth components governing
  the theta-sum degree.
- **Settled:** the \(R_{10}\) degeneration cannot simply be restricted to
  the one-dimensional \(A_5\) locus.
- **Settled:** Shen's theorem retains the factor two on theta.
- **Open:** the full algebraic middle-theta descent lattice.
- **Open:** any good-reduction member inside the \(A_5\) pencil whose
  theta-sum index can be independently computed and used as a
  specialization obstruction.
- **Open:** whether the marked \(E^5\) operator algebra makes the
  \(A_5\)-equivariant Gysin image computable.
- **Dead route:** using the factor-\(8\) pure boundary theta or an snc
  specialization-index gcd as if it were an integral parity computation
  for the ordinary generic-fibre index.
