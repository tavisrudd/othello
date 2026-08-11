# C904: Beckmann--de Gaay Fortman does not exhaust the p15 Chow lattice

Date: 2026-08-11

Status: claim-specific primary-source audit; no manuscript or Lean edits

## Verdict

**No.**  Algebraicity of the minimal class does not imply, by the
Beckmann--de Gaay Fortman theorem, that the full integral algebraic or Hodge
lattice on every power of the abelian variety is the divided-power envelope
of its Neron--Severi lattice.

Their result proves three different, weaker statements:

1. the Fourier transform preserves the lattice of already algebraic
   integral cohomology classes;
2. the positive-degree ideal of that already algebraic lattice is closed
   under divided powers;
3. every integral Hodge **one-cycle** class is algebraic when the minimal
   class is algebraic.

None is a generation theorem.  In particular, the exact C904 calculation

\[
  \mathcal L^{\mathrm{PD(NS)}}_{15}=2\operatorname {End}(J)
\]

is exhaustive only for the divisor-generated divided-power subring that was
actually enumerated.  Beckmann--de Gaay Fortman does not identify that
subring with the image of all algebraic codimension-three cycles.  A
genuinely non-divisor-generated integral p15 inverse-Lefschetz class remains
logically possible.

This audit consulted **one primary source at partial read depth and zero at
full-text depth**.  The load-bearing source is the final published 2023
paper, not a distinct 2025/26 Beckmann--de Gaay Fortman theorem.

## 1. Exact source statements

Let \(A\) be a principally polarized complex abelian variety of dimension
\(g\), with minimal class \(\gamma_\theta=\theta^{g-1}/(g-1)!\).

Beckmann--de Gaay Fortman Theorem 1.1 says that algebraicity of
\(\gamma_\theta\) is equivalent to each of the following relevant
conditions:

- algebraicity of \(\operatorname {ch}(\mathcal P_A)\) on
  \(A\times\widehat A\);
- the integral Hodge conjecture for **one-cycles** on
  \(A\times\widehat A\);
- algebraicity of \(\alpha^i/i!\) for every integral cohomology class
  \(\alpha\) that is **already algebraic**.

The quantifier in the last condition is decisive.  It says

\[
       \alpha\in H^{>0}(A,\mathbf Z)_{\mathrm{alg}}
       \Longrightarrow
       \alpha^i/i!\in H^*(A,\mathbf Z)_{\mathrm{alg}}.
\]

It does not say that every element of
\(H^*(A,\mathbf Z)_{\mathrm{alg}}\) is generated from
\(H^2(A,\mathbf Z)_{\mathrm{alg}}=\operatorname {NS}(A)\).

Theorem 3.8 is the Chow-level version.  Its condition (viii) gives a
PD-structure on the whole positive-codimension ideal

\[
       CH^{>0}(A)/\mathrm{torsion}
       \subset CH(A)/\mathrm{torsion}
\]

when the minimal cycle lifts.  This is closure under operations on every
existing Chow class, not generation of that ideal by divisors.  An abstract
PD-ring may have independent generators in every degree; existence of its
PD operations does not remove them.

Proposition 3.11, conditions (vii)--(viii), makes the same distinction after
passing to integral algebraic cohomology: Fourier preserves the image of the
cycle-class map, and that image carries a PD-structure.  Again the object on
which the operations act is the full pre-existing algebraic image.  The
proposition supplies no reverse containment in the PD subalgebra generated
by divisor classes.

Finally, Lemma 3.2(ii) identifies algebraicity defects in complementary
degrees under an integral Fourier correspondence:

\[
  Z^{2i}(A)\simeq Z^{2g-2i}(\widehat A).
\]

This is an isomorphism of the full defect groups, not a reduction of every
degree to divisors.

## 2. Why the one-cycle proof does not extend to p15

The proof of Theorem 1.1 uses the Lefschetz \((1,1)\) theorem in exactly one
place.  The integral Poincare correspondence carries

\[
       H^2(A,\mathbf Z)\longrightarrow H^{2g-2}(\widehat A,\mathbf Z),
\]

so algebraicity of every divisor class proves algebraicity of every Hodge
one-cycle class.  Their diagram (12) prints this argument.

Remark 4.2(iii), formula (13), accordingly gives an explicit expression for
every integral Hodge one-cycle using an arbitrary divisor \(D\), theta
divided powers, addition, pullback, product, and pushforward.  This is the
strongest generation statement in the relevant part of the paper, and it
is degree-specific.

For the C904 ambient variety

\[
                         X=J\times J,
       \qquad \dim X=10,
\]

an algebraic codimension-three class lies in \(H^6(X,\mathbf Z)\).  Fourier
duality sends it to \(H^{14}(\widehat X,\mathbf Z)\), a codimension-seven
class, not to \(H^2\).  Thus neither Lefschetz \((1,1)\) nor the one-cycle
surjectivity theorem classifies this lattice.  Applying Theorem 1.1 to
\(X\) proves the integral Hodge conjecture in \(H^{18}(X,\mathbf Z)\), not
in \(H^6(X,\mathbf Z)\).

The same limitation survives restriction to the theta resolution
\(M\times M\).  Beckmann--de Gaay Fortman's theorem is a theorem about an
abelian variety and its Chow/cohomology lattices; it gives no generation or
surjectivity theorem for \(CH^3(M\times M)\).

## 3. Consequence for the certified \(2\operatorname {End}(J)\) image

The existing C904 certificate computes the p15 action of all ordinary
divisor cubes and of the mixed divided classes furnished by the PD
structure, including every divisor and cross-endomorphism direction in
\(\operatorname {NS}(J^2)\).  Its conclusion

\[
        \mathcal L^{\mathrm{PD(NS)}}_{15}
        =2\operatorname {End}(J)
\]

is therefore complete **inside that explicitly defined source lattice**.

To promote it to a theorem about all algebraic codimension-three cycles one
would need an additional statement such as

\[
 \operatorname {pr}_{15}!left(
    \operatorname {cl}CH^3(J^2)
 \right)
 =
 \operatorname {pr}_{15}!left(
    \mathrm {PD}\langle\operatorname {NS}(J^2)\rangle^3
 \right).                                                \tag{3.1}
\]

No implication in Theorem 1.1, Theorem 3.8, Proposition 3.11, or Lemma 3.2
is (3.1).  The source proves the inclusion from right to left: the relevant
divided divisor classes are algebraic.  It does not prove the reverse
inclusion.

Indeed, the surviving p15 identity is exactly the kind of class that the
source leaves undecided.  It is an integral Hodge class outside the
certified divisor-PD image.  Beckmann--de Gaay Fortman neither algebraizes
it nor proves it nonalgebraic.

Consequently:

- the exact factor-two calculation is a complete **divisor-PD no-go**;
- it is not a complete algebraic-cycle no-go;
- the direct algebraization gate remains a genuinely non-divisor-generated
  integral inverse-Lefschetz correspondence, or an independent theorem
  proving (3.1) for this special \(A_5\) power.

## 4. Source record and date correction

Thorsten Beckmann and Olivier de Gaay Fortman, *Integral Fourier transforms
and the integral Hodge conjecture for one-cycles on abelian varieties*,
Compositio Mathematica 159 (2023), DOI
`10.1112/S0010437X23007133`.

- **Read depth:** partial: Introduction and Theorem 1.1;
  Section 3.1, especially Lemma 3.2; Section 3.3, especially Theorems
  3.7--3.8 and Propositions 3.11--3.12; Section 4.1 and Remark 4.2(iii).
- **Access/version:** final publisher PDF, cached under
  `10.1112/S0010437X23007133`.
- **SHA-256:**
  `f866906d17ba67a72ab6e03786df6caa4ce440e96fec0e2136e133ed4c60afca`.

The exact theorem used throughout C904 is the published 2023 result.  A
bounded author/title check located no distinct 2025/26
Beckmann--de Gaay Fortman paper asserting a stronger exhaustiveness theorem.
This is source disambiguation, not a comprehensive priority negative.

Queries used for that disambiguation:

- `Thorsten Beckmann Olivier de Gaay Fortman 2025 integral Poincare duality Fourier theorem abelian varieties`
- `site:arxiv.org Beckmann "Poincare duality" "integral" abelian 2025`
- `site:arxiv.org "de Gaay Fortman" Fourier integral Chow 2025 2026`

Coverage did not include MathSciNet, zbMATH, or a forward-citation graph,
because the task was to determine the exact implication of the named
source, not to assert global novelty.

## 5. EJ + TT closeout and mystery ledger

- **Settled:** the source supplies PD closure, not generation by NS.
- **Settled:** its IHC conclusion is for one-cycles; on \(J^2\), codimension
  three is not Fourier-dual to divisors.
- **Settled:** the certified \(2\operatorname {End}(J)\) image is exhaustive
  for the full divisor-PD source lattice and no larger class of cycles.
- **Open:** whether the p15 identity is algebraic by a genuinely
  non-divisor construction.  Exact gate: an integral inverse-Lefschetz
  correspondence on the theta resolution.
- **Open:** whether some special theorem for this \(A_5\) elliptic-power
  motive proves the reverse containment (3.1).  Beckmann--de Gaay Fortman
  is not such a theorem.

Vibe: decisive negative for the proposed shortcut.  The factor-two wall is
real for every divisor-generated PD construction, but the source gives no
license to promote it to a wall for all algebraic cycles.
