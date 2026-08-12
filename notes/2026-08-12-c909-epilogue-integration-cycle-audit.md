# C909 — hostile cycle-side audit of the epilogue integration blueprint

Date: 2026-08-12

Status: **GO with mandatory theorem-scope and proof-surface repairs.**  This
audits `c42079dd` against the current complete epilogue.  It makes no
manuscript, PDF, mirror, Lean, or blueprint edit.

## Executive verdict

The proposed cycle replacement is mathematically coherent and materially
better than the current Section 3 ladder.  It gives one reusable positive
criterion, one genuinely exceptional geometric realization, and one nearby
sharp counterpattern:

\[
 \text{finite-etale marked graph packet}
 \Longrightarrow \operatorname{PDDef}^{*}=0,
 \qquad
 \text{but}\qquad
 \operatorname{Hdg}^{2*}/P^*\text{ need not vanish}.
\]

For the actual six-axis packet the second quotient does vanish on the
non-CM locus.  For the equal-depth, five-distinct-root packet it is exactly
\((\mathbf Z/p^a)^5\) in codimensions two and three.  Thus the proposed
``repeated roots versus distinct roots'' contrast is correct, provided the
paper keeps the two quotient problems separate.

The blueprint must not be implemented verbatim until it repairs the four
scope seams below.  None invalidates the intended result; the first is the
only theorem-statement seam, and the next two are the load-bearing printed
proof obligations.

## 1. The finite-etale theorem: exact safe statement

The phrase

> a marked polarized elliptic-power quotient whose local graph spectral
> packet is block-respecting, self-adjoint, and finite etale at every bad
> prime

is good shorthand for an introduction, but is not yet a theorem hypothesis.
The printed theorem must retain all of the following data.

* A **marked polarized elliptic-power presentation**, not a bare ppav: an
  elliptic tensor ruling, the source coefficient lattice, and the specified
  self-dual kernel.
* At every bad prime, an orthogonal depth decomposition
  \(G=PB=\perp_a p^aB_a\), with every \(B_a\) unimodular, and a graph
  transverse to the elliptic ruling that preserves the depth summands.
* Self-adjointness in the \(B_a\)-bilinear convention.  After a
  non-orthonormal split, divisor coefficients are symmetric bilinear forms
  (equivalently \(B\)-self-adjoint endomorphisms), not naively
  transpose-symmetric matrices.
* Finite etaleness of the slope algebra on every **positive-depth** block.
  The depth-zero block needs no etale condition.  After finite unramified
  splitting, the theorem uses blocks
  \(T_i=t_i+p^{a_i}S_i\), not literal diagonalization of the unimodular
  forms.

With these hypotheses, the graph calculation has the exact coefficient
lattice
\[
 A=A^{\mathsf t},\qquad P^{-1}A\in M_g(R),\qquad
 P^{-1}(AT^{\mathsf t}-TA)P^{-1}\in M_g(R),
\]
and on two split blocks its cross ideal is
\[
 p^{e_{ij}},\qquad
 e_{ij}=\max\{a_i,a_j,a_i+a_j-v_p(t_j-t_i)\}.
\tag{1}
\]
The integral conclusion follows from
\(e_{ij}\ge\max(a_i,a_j)\ge\lceil(a_i+a_j)/2\rceil\), the signed
three-rank-one straightening identity, and square-zero pullback.  This is
valid at two; it never divides by two.

The object is chart-independent only on this **marked elliptic gluing
groupoid**.  A change of transverse elliptic ruling acts projectively on the
packet and preserves finite etaleness.  An arbitrary symplectic change of
coordinates on the finite Lagrangian does not.  The manuscript must not
shorten the statement to a condition on an unmarked ppav or an arbitrary
finite symplectic chart.

For non-CM \(E\), this coefficient lattice is the full local
\(\NS(A)\).  At a CM fibre it should instead be denoted
\(N_{\rm gr}\subseteq\NS(A)\).  The unconditional all-degree conclusion is
\[
 \operatorname{PD}\langle N_{\rm gr}\rangle^k
 =\operatorname{im}(\operatorname{Sym}^kN_{\rm gr}\to H^{2k}),
 \qquad \Theta^{[k]}\in P^k_{\rm gr}.
\tag{2}
\]
Only on the stated non-CM locus may the notation be simplified to the full
Neron--Severi lattice.  This also keeps the all-fibre minimal-class corollary
correct: (2) already supplies \(\Theta^{[4]}\), while extra CM divisors can
only enlarge the ordinary product image.  It does not assert full CM Hodge
equality.

The finite unramified extension in this proof is coefficient extension of
the finite free lattices.  The rank-one summands after splitting are not
being claimed to be newly descended geometric line bundles.  Equality after
extension descends by faithful flatness of the quotient module, not by trace
or averaging.  This sentence is worth printing because it eliminates the
only plausible residue-degree denominator objection.

## 2. Independent audit of the actual six-axis four-slot calculation

Put the depth-zero slot first.  At each of two and three the local source is
\[
 U_0\perp pU_1,\qquad \operatorname{rk}U_0=1,quad
 \operatorname{rk}U_1=4.
\tag{3}
\]
This is the integral orthogonal decomposition already used in the current
Lemma 3.6; it is stronger than the Smith form alone.  The kernel is trivial
on \(U_0\).

After the unramified quadratic extension at two, write the four depth-one
slots as \(A_1,A_2,B_1,B_2\), with roots \(\omega\) on the two \(A\)'s and
\(\omega^2\) on the two \(B\)'s.  The exact graph ideals are
\[
 e_{0i}=1,\qquad e_{A_iA_j}=e_{B_iB_j}=1,\qquad
 e_{A_iB_j}=2.                                             \tag{4}
\]
The rank-two root blocks need not be integrally diagonal forms at two: any
integral basis of each unimodular block gives the same scalar-root
calculation and the same coefficient ideals.

There are only the following four-slot types.

| prime and support | two matching directions | integral scales |
| --- | --- | --- |
| \(p=2\), \(A_1A_2B_1B_2\) | \(r_{AA\mid BB}\), \(r_{AB\mid AB}\) | \(p^2,p^4\) |
| \(p=2\), \(0A_iB_1B_2\) | \(r_{0A\mid BB}\), \(r_{0B\mid AB}\) | \(p^2,p^3\) |
| \(p=2\), \(0B_iA_1A_2\) | symmetric to the preceding row | \(p^2,p^3\) |
| \(p=3\), four primary slots or \(0\) plus three primary slots | either two matchings | \(p^2,p^2\) |

Here a scale is the least multiplier making that matching direction integral.
The entries in the last column are both the Hodge scales and the ordinary
divisor-product scales.

For completeness, the hostile point is the possible hidden Plucker
cancellation.  In the first dyadic row, the same-root matching
\(r_{AA\mid BB}\) has no all-\(X\) coefficient and is integral precisely
at \(p^2\).  The other matching has a nonzero all-\(X\) coefficient of
denominator \(p^4\), while the first one has none; it is therefore forced
to scale \(p^4\) even after adding the first direction.  The integral
Plucker relation has unit coefficients, so these two directions are an
integral basis and there is no third lower-scale class.  In the second row
the same argument has denominators \(p^2\) and \(p^3\).  At three, two
one-\(Y\) coefficient rows give a unit triangular minor at scale \(p^2\),
including when the depth-zero slope has the same residual lift as the scalar
depth-one slope.  Thus no all-\(X\) argument is being silently used at
three.  This proves, without a certificate,
\[
 I_J=P_J\quad\hbox{for every four-slot support }J
\tag{5}
\]
at both bad primes.  Faithful-flat descent returns (5) from the dyadic split
ring to \(\Z_2\).

This passes the requested red-team check.  The phrase ``each support has a
same-root pair'' is a useful mnemonic but is not a proof; the displayed
weighted two-matching basis and its leading coefficient must appear in the
paper.

## 3. From four slots to all degrees in dimension five

For a non-CM power, the rational Hodge tensors are the diagonal
\(\mathrm{SL}_2\)-invariants.  In degree four the only potentially
nonsaturated multidegree is \((1,1,1,1)\), hence (5) proves \(Q^2=0\).
In degree six, the multidegrees are
\[
 (2,2,2),\qquad(2,2,1,1),\qquad(2,1,1,1,1).
\]
The first two are one-dimensional and their primitive diagonal factors and
one cross factor are already ordinary products.  The last is the primitive
volume factor of a four-slot matching module: multiplication by the integral
diagonal class in the complementary slot sends (5) into the product image.
Therefore \(Q^3=0\).  This is the correct degree-three proof; it neither
uses Poincare duality nor assumes equal depths.

In degrees four and five, the only multidegrees are respectively
\((2,2,2,2)\), \((2,2,2,1,1)\), and the top class.  They are products of
primitive diagonal factors and at most one primitive cross factor; they are
already saturated.  At primes away from six the isogeny is integral-locally
an isomorphism, and the literal non-CM elliptic power has its integral
\(\mathrm{SL}_2\)-invariant algebra generated by contraction divisors.
The last assertion needs either a short integral first-fundamental-theorem
lemma or an explicit standard-monomial citation in the manuscript.

It follows that for every non-CM fibre of the actual six-axis presentation,
\[
 \operatorname{Hdg}^{2k}(J,\Z)=P_J^k\qquad(0\le k\le5). \tag{6}
\]
This has the exact intended scope.  It is not an assertion at CM fibres and
it does not follow from all-degree PD saturation alone.

## 4. The distinct-root sharpness theorem

The proposed comparison theorem is correct in the following precise form.
Let \(E\) be non-CM and let a one-depth rank-five graph over \(\Z_p\) have
depth \(a\) and five roots that become pairwise distinct modulo \(p\) after
a finite unramified split.  Then
\[
 \frac{\operatorname{Hdg}^{4}}{P^2}
 \cong
 \frac{\operatorname{Hdg}^{6}}{P^3}
 \cong(\Z/p^a)^5,
 \qquad
 \frac{\operatorname{Hdg}^{2k}}{P^k}=0\quad(k=0,1,4,5). \tag{7}
\]
For a four-set \(J\), its two-matching module has Hodge lattice
\[
 R p^{3a}h_J+R p^{4a}r_J,
\]
and product lattice
\[
 R p^{4a}h_J+R p^{4a}r_J.
\]
The weighted Plucker relation produces the first generator, and a one-\(Y\)
coefficient with unit root difference proves exactness.  There are five
four-subsets.  Multiplication by the principal polarization gives the
canonical map on the quotient; after splitting it is the complement map,
and the direct calculation—not Poincare duality—shows that it is an
isomorphism in (7).

The final manuscript wording must say ``one-depth, pairwise residually
distinct'' and ``after unramified splitting.''  It must not call this tower
the cubic packet, and it must not suggest that the formula classifies
unequal-depth or colliding-root packets.

## 5. Required manuscript repairs and realistic proof budget

1. **Replace the present Section 3 from its first graph chart onward.**  Its
   current elementary formula assumes \(pI_g\) and ordinary symmetric
   slopes; it cannot serve as a proof of the arbitrary-depth theorem.  Print
   the normalization leading to (1), with the \(B\)-self-adjoint convention,
   before invoking rank-one straightening.
2. **Define both lattices once.**  Write \(P^k\) for ordinary products and
   \(\operatorname{PD}\langle N\rangle^k\) for the divided-power envelope.
   State explicitly that (2) does not imply \(P^k=\operatorname{Hdg}^{2k}\).
   The present paper's cofactor language hides precisely this distinction.
3. **Print the four-row support table and its two-basis proof.**  A claim that
   two audits have passed cannot replace this one-page local argument.  This
   is the minimal proof of the new six-axis full-Hodge assertion.
4. **Add the literal-power integral-invariant lemma.**  It is needed at
   primes away from six for (6), and it makes the degree-four/five conclusion
   self-contained.
5. **Retire the phrase ``scalar Jordan mechanism.''**  The cubic three-primary
   slope is a scalar, one-point finite-etale block; no non-etale Jordan claim
   belongs in the new proof.
6. **Repair the existing unused three-primary selection assertion.**
   Proposition 2.4 states that \(\Gamma_0(3)\) monodromy selects a graph,
   but its printed proof establishes only scalarity.  Since the cycle proof
   uses only scalarity, delete the selection clause unless it receives an
   exact cited proof.
7. **Keep CM and relative boundaries visible.**  State (6) only on the
   non-CM locus.  For all smooth fibres retain only the ordinary-product
   minimal class and Voisin's fibrewise conclusion; neither a horizontal
   cycle nor full CM Hodge equality follows.

With (1)--(7) printed, the new Section 3 can replace rather than append to
the current cofactor ladder.  The page target of 18--20 is plausible only if
the old mixed-adjugate repetition is removed, the indecomposable tower is
reduced to one sentence or omitted, and the four-slot proof is kept to its
essential two-matching table.  The 21-page ceiling is not compatible with
adding a construction of the tower or ancillary Smith tables.

## Final grade

**Cycle integration: GO after the seven repairs.**  The new structural
theorem is stronger and cleaner than the present Section 3, and the actual
six-axis equality is now supported by a direct repeated-root calculation.
The only unacceptable versions are: finite etaleness on an unmarked ppav,
``PD saturation implies Hodge equality,'' or a certificate-only assertion of
the repeated-root calculation.

## Mystery ledger

* **Settled:** all four local support types of the actual packet have no
  hidden Plucker denominator; the dyadic \(2+2\) root multiplicity and the
  three-primary scalar block are both product-saturated.
* **Settled:** the actual packet and the five-distinct-root tower have
  opposite ambient-Hodge behavior while both satisfy finite-etale PD
  saturation.
* **Open but excluded from this integration:** the weighted Smith quotient
  for general unequal-depth/colliding-root packets and the all-rank
  filtered-web formula.
