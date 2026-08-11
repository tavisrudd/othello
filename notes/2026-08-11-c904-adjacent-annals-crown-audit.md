# C904 adjacent Annals-crown audit

Date: 2026-08-11

Status: bounded high-EV synthesis and primary-source audit; no manuscript or
Lean edits

## Executive verdict

The strongest genuinely new adjacent crown is the **intrinsic p-typical
classification of integral divisor-product defects for principally polarized
elliptic-power gluings**, not an integral projector on the C904 theta
resolution and not rational simple connectedness of the charge-three fibre.

The current indecomposable dyadic fivefold already proves that a second-stage
order-four defect occurs on a polarized-indecomposable ppav.  All exact data
support the regular-primary formula

\[
 v_p\!\left(\operatorname {ord}
  (\gamma_{g-1}(\Theta)\bmod P^{g-1})\right)
 =\min\left\{v_p((g-1)!),\lfloor\log_p h\rfloor\right\},
 \tag{A}
\]

where \(h\) is the nilpotent height of a cyclic primary self-adjoint slope.
Formula (A) is not proved beyond the certified boundaries.  If proved for
regular-primary blocks, it would already give polarized-indecomposable ppav's
with unbounded exact defects.  If extended to every self-dual gluing, with the
full elementary divisors determined intrinsically by orthogonal primary type,
it is plausibly an Annals-level classification theorem.

The primary proof engine is modular representation theory of exterior powers
of cyclic p-group modules, coupled to the already proved integral
commutator/carry description of the Neron--Severi lattice.  Almkvist--Fossum
and Himstedt--Symonds provide the exterior/symmetric-power recurrences;
Korhonen gives closed regular-nilpotent formulas in the first nonlinear
degree.  Van Geemen--Marrani supply the spinor/principal-minor geometry needed
to remove graph-chart dependence at two.  None of these sources makes the
bridge to the integral divisor-product saturation quotient, so that bridge is
the new mathematics.

The theta-projector and charge-three RSC routes remain important, but neither
currently has a source-matched proof engine reaching its first load-bearing
gate.

## 1. Crown statement and theorem ladder

Let \(E\) be a non-CM elliptic curve and let \((A,\Theta)\) be a principally
polarized quotient of \(E^g\) by a maximal isotropic p-torsion gluing.  Write

\[
 P_A^k=\langle D_1\cdots D_k:D_i\in\operatorname {NS}(A)\rangle
 \subset H^{2k}(A,\mathbf Z),
\]

and let \(S_A^k\) be its saturation in the integral Hodge lattice.  The
minimal-class defect is the order of
\(\gamma_{g-1}(\Theta)=\Theta^{g-1}/(g-1)!\) in
\(S_A^{g-1}/P_A^{g-1}\).

### Stage I: regular-primary theorem

For a graph slope whose self-adjoint module is cyclic primary of radical
height \(h\), prove or correct (A), and compute the elementary divisors of
the full degree-\(g-1\) product quotient.  This would upgrade the present
order-four example to exact unbounded families: a regular block of height at
least \(p^r\), once the factorial ceiling permits, should have defect
\(p^r\).  The existing cyclic-primary idempotent lemma then makes every such
example polarized-indecomposable.

Ceiling: Inventiones/JAMS level if the proof is conceptual and gives all
regular-primary elementary divisors; below that if it proves only the order
of the distinguished minimal class.

### Stage II: orthogonal-primary classification

Replace the maximum-height conjecture by an exact theorem in terms of the
full self-adjoint primary module: irreducible polynomial, Jordan partition,
and bilinear type.  The expected structural form is a p-typical filtration

\[
 F^1\supset F^2\supset\cdots,
\]

whose \(r\)-th boundary depends only on the local algebra modulo radical
height \(p^r\).  Etale primary factors should contribute no defect.  This
form remains meaningful if the simple height-only formula fails.

Ceiling: Inventiones/Annals-adjacent, because it classifies rather than merely
constructs the integral failures.

### Stage III: intrinsic all-Lagrangian theorem

Remove the graph-chart choice.  Attach the p-typical complex and its defect
functorially to any maximal isotropic gluing, prove invariance under the
integral symplectic group, and identify its characteristic-two first layer
in spinor/principal-minor coordinates.  Prove realization of every allowable
p-power and provide indecomposable representatives.

This is the Annals-shaped statement:

> **Integral Lefschetz stratification theorem.**  The p-primary saturation
> quotient of the integral divisor-generated cohomology of a principally
> polarized elliptic-power gluing is the homology of an intrinsic p-typical
> divided-power complex attached to its self-dual finite gluing module.  Its
> strata are determined by orthogonal primary type; the etale stratum is
> primitive, and every permitted p-power defect occurs on a
> polarized-indecomposable ppav.

The classification must concern the full finite quotient, not only one
element's order, to sustain the highest venue claim.

## 2. Primary proof engine

The proof should be local at p and separate into five modules.

### 2.1 Integral gluing and carry

Use the proved graph-lattice formula

\[
 \Omega_D=
 \begin{pmatrix}
  (DT-TD)/p&D\\-D&0
 \end{pmatrix},
 \qquad D=D^t,\quad DT=TD\pmod p.
\]

The quotient \((DT-TD)/p\bmod p\) is load-bearing: it is the first carry and
cannot be discarded in favor of the reduced centralizer.  Higher defect
layers should be organized by its successive Witt/p-adic lifts.

### 2.2 Etale/nilpotent splitting

For squarefree minimal polynomial, Hensel-lift the primary idempotents and
use the perfect trace pairing of the unramified factors.  The missing lemma
is an integral trace/norm identity expressing the minimal cofactor class in
the divisor-product lattice without multiplying by the residue degree.

For a primary block, pass to the local self-adjoint algebra
\(R=\mathbf F_{p^d}[u]/(u^h)\), with its involution and trace pairing.  The
radical filtration is the natural source of the thresholds
\(h=p,p^2,\ldots\).

### 2.3 Modular exterior-power recursion

The regular nilpotent block is the indecomposable module \(V_h\) for a
cyclic p-group.  Almkvist--Fossum describe exterior and symmetric powers for
cyclic groups of prime order.  Himstedt--Symonds give recursive formulas for
all cyclic 2-groups using a Koszul complex, and Korhonen gives closed formulas
for regular nilpotents on exterior and symmetric squares in characteristic
two.

These results should compute the associated-graded linear algebra of the
product span.  They do not see the integral carry.  The new bridge must lift
their Koszul recursion to the p-adic divided-power comparison and identify
its connecting homology with \(S_A^k/P_A^k\).

### 2.4 Divided-power/Tor comparison

The internal class already called a divided-power Bockstein should be treated
as the connecting class for the inclusion of the ordinary product lattice in
its saturation.  At higher levels one needs a genuine filtered complex, not
an informal sequence of Bocksteins.  A successful proof should show that the
\(r\)-th connecting layer vanishes below radical height \(p^r\), and compute
it on a regular block.

Moonen--Polishchuk, Beckmann--de Gaay Fortman, Hasan et al., and Kahn explain
the factorial and divided-power ceilings but do not compute this ordinary
divisor-generated sublattice.  Their results are boundary conditions, not a
substitute for the local calculation.

### 2.5 Chart-free geometry

At p=2 the principal-minor map from the Lagrangian Grassmannian to the spinor
variety, proved by van Geemen--Marrani, is the best available language for
the first layer.  An all-Lagrangian theorem should express the carry-enhanced
complex in these coordinates and then prove symplectic-chart invariance.
For odd p, ordinary Plucker coordinates and self-dual module classification
are the likely replacement.

Engel--de Gaay Fortman--Schreieder are the closest high-level priority
boundary.  Their matroidal degeneration theory obstructs odd algebraic
multiples of minimal classes on very general ppav's.  It does not compute the
ordinary divisor-product saturation quotient of a fixed elliptic-power
isogeny lattice.  Their Corollary 1.5 shows that an odd-degree isogeny to a
product of Jacobians yields some odd algebraic multiple of the minimal class;
it does not make the primitive class an ordinary divisor product.  Thus the
new theorem must be advertised as a static integral-Lefschetz classification,
not as a new general matroid obstruction to algebraicity.

## 3. Hostile audit of formula (A)

The formula is a strong conjecture, not yet a theorem.  Five hazards can
change it.

1. **Integral data exceed Jordan type.**  The defect depends on commutator
   carries modulo \(p^2,p^3,\ldots\).  Two slopes with the same reduction and
   Jordan type may have different higher lifts.
2. **Bilinear type matters.**  Similarity to Jordan form is not orthogonal
   congruence.  In characteristic two, alternating/nonalternating refinements
   can change the self-adjoint module.
3. **Several blocks can interact.**  Mixed divisor products may cancel or
   create layers not predicted by maximum height.  The full partition may
   replace \(h\).
4. **The first unseen threshold is large.**  The next dyadic value eight
   requires height at least eight; existing exact exterior-monomial routines
   do not reach it.  No induction is licensed by the order-four case.
5. **Graph charts are not intrinsic.**  Fractional-linear changes of slope
   can leave a graph chart.  A classification stated only for matrices in one
   chart is not yet a classification of ppav gluings.

The safe next proof statement is consequently weaker than (A): the
\(r\)-th layer depends only on the carry-enhanced local algebra through
radical height \(p^r\), and it vanishes for regular-primary height below
\(p^r\).  Exact nonvanishing on the regular block is the remaining half.

There is also a scope hazard.  These are cohomological integral
divisor-product defects.  Algebraicity of the primitive minimal class is a
separate question in dimensions at least four.  The theorem must not claim a
Chow-ring separation unless an actual integral minimal cycle is supplied.

## 4. Why the theta-resolution projector is not the best adjacent crown

The desired theorem would be a \(\mathbf Z_{(2)}\) Chow--Kunneth or at least
inverse-Lefschetz projector for
\(M=\operatorname {Bl}_0\Theta\), isolating the p15 and p24 channels.  Such a
projector would directly close the symmetric-theta parity gate.

The surrounding sources reach only disjoint halves:

- Kunnemann and Diaz construct rational motivic Lefschetz/Chow--Kunneth
  projectors for abelian varieties and smooth theta divisors;
- the C904 theta divisor is singular, and its resolution is not the smooth
  theta setting of Diaz;
- Rosas-Soto and Kahn construct integral etale-motivic projectors, the latter
  modulo two-torsion;
- Hasan--Hassan--Lin--Manivel--McBeath--Moonen obtain relative ordinary-Chow
  Fourier and Lefschetz decompositions only after inverting
  \((2g+d+1)!\), which discards the dyadic gate;
- Li--Lin--Pertusi--Zhao generate rational cohomology by universal-family
  components, not integral Chow projectors.

The topology is encouraging: the exceptional cubic contributes only a
three-primary local defect, so the unresolved twos are not created by the
ordinary triple point.  But a topological or etale splitting does not produce
an ordinary algebraic correspondence.  Kahn's Question B.8 leaves ordinary
integrality of the corresponding projectors open even for Jacobians.  A broad
two-local theorem for theta resolutions would therefore have to cross a
known open comparison boundary before using the favorable local topology.

Verdict: potentially Annals-level if proved in a general form, and the most
direct C904 closure, but currently lower EV than the gluing classification.
The honest next target is one explicit p15 or p24 projector on this M, not a
premature general CK theorem.

## 5. Why charge-three RSC is not the best adjacent crown

De Jong--He--Starr Corollary 12.2 is dimensionally applicable after the C904
reduction to finitely many surface components.  It would give sections if a
proper polarized charge-three model satisfied their precise one-point and
two-point free-line hypotheses and admitted a very twisting surface.

No audited charge-three source supplies the prerequisite geometry:

- Voisin's classical \(M_9\) has a four-dimensional generic Abel--Jacobi
  fibre, but no proper compactification, Picard group, anticanonical class,
  or line class is computed;
- the primitive Li--Lin--Pertusi--Zhao theorems do not apply: the projected
  charge-three class is divisible by three and has the wrong moduli/fibre
  dimensions;
- Harris--Roth--Starr prove geometric unirationality for the degree-five
  Hilbert-scheme fibre over \(\mathbf C\), after choices that are circular
  for the required function-field section; they do not prove RSC of the
  charge-three fourfold.

The source engine would be de Jong--He--Starr plus a new Hecke-line geometry
on a proper compactification.  But the construction of that compactification
and polarization precedes the RSC calculation.  Rational connectedness or
unirationality alone is insufficient.

Verdict: JEMS/Inventiones potential if one first identifies a Fano model and
then proves RSC; Annals potential only if the result becomes a general theorem
for Abel--Jacobi fibres and yields new section/Chow consequences.  It is not
the highest-EV present route.

## 6. Ranking and acceptance gates

| Crown | Novelty | Readiness | Realistic ceiling | First decisive gate |
|---|---:|---:|---|---|
| all-Lagrangian p-typical defect classification | very high | medium | Annals-plausible | prove regular-primary layer theorem |
| regular-primary formula and unbounded indecomposable defects | high | medium-high | Inventiones/JAMS | prove exact p-adic Koszul/PD comparison |
| two-local theta-resolution CK/projector | very high | low | Annals-plausible | construct one ordinary algebraic p15/p24 projector |
| RSC charge-three Abel--Jacobi fourfold | high | low | JEMS/Inventiones | construct proper polarized model and line space |

For an Annals claim, the gluing theorem should pass all four gates:

1. an intrinsic, chart-independent invariant;
2. a full quotient or elementary-divisor classification, not only an upper
   bound or distinguished order;
3. unbounded exact p-power realizations on polarized-indecomposable ppav's;
4. a conceptual proof replacing finite Smith computations.

Without gates 1 and 2, the regular-primary theorem is still a strong paper
but not an Annals crown.

## 7. Primary-source ledger and bounded search

Primary sources newly or specifically checked for this synthesis:

1. Humberto A. Diaz, *The motive of a smooth Theta divisor*,
   arXiv:1603.04345.  Read depth: claim-specific partial, Theorems 1.1,
   2.1--2.2 and the displayed projector construction in Section 3.  The
   construction uses the rational motivic Lefschetz operator and assumes a
   smooth theta divisor.
2. Ivan Rosas-Soto, *Chow Kunneth decomposition for etale motives*,
   arXiv:2403.00159.  Read depth: abstract and stated main results only.
   Claim used: integral etale-motivic, not ordinary-Chow, projectors.
3. Junaid Hasan, Hazem Hassan, Milton Lin, Marcella Manivel, Lily McBeath and
   Ben Moonen, *Integral aspects of Fourier duality for abelian varieties*,
   arXiv:2407.06184 / Manuscripta Math. 176 (2025), article 64.  Read depth:
   abstract, introduction and stated coefficient theorem.  Claim used:
   relative ordinary-Chow Fourier/Lefschetz theory over
   \(\mathbf Z[1/(2g+d+1)!]\).
4. Frank Himstedt and Peter Symonds, *Exterior and Symmetric Powers of
   Modules for Cyclic 2-Groups*, J. Algebra 410 (2014), 393--420,
   arXiv:1510.02370.  Read depth inherited from the preceding priority audit:
   introduction, Theorems 1.1--1.2 and the Koszul proof strategy.
5. Mikko Korhonen, *Decomposition of exterior and symmetric squares in
   characteristic two*, Linear Algebra Appl. 624 (2021), 349--363,
   arXiv:2101.01365.  Read depth inherited: introduction and Theorems
   1.1--1.9.
6. Bert van Geemen and Alessio Marrani, *Lagrangian Grassmannians and Spinor
   Varieties in Characteristic Two*, arXiv:1903.01228.  Read depth inherited:
   Sections 4.2--4.5, Proposition 4.2 and Section 5.3.
7. A. J. de Jong, Xuhua He and Jason Michael Starr, *Families of rationally
   simply connected varieties over surfaces and torsors for semisimple
   groups*, arXiv:0809.5224.  Read depth inherited: Introduction,
   Corollaries 1.1/12.2, Hypothesis 6.8 and the very-twisting-surface input.
8. Joe Harris, Mike Roth and Jason Starr, *Abel--Jacobi maps associated to
   smooth cubic threefolds*, arXiv:math/0202080.  Read depth inherited:
   introduction and Corollary 8.6 with proof.
9. Philip Engel, Olivier de Gaay Fortman and Stefan Schreieder, *Matroids and
   the integral Hodge conjecture for abelian varieties*,
   arXiv:2507.15704v3.  Read depth inherited and refreshed by targeted
   full-text reading of Corollary 1.5 and its proof in Section 8.4.  Claim
   used: odd-degree isogeny gives an odd algebraic multiple, not a
   divisor-product classification.

The following already audited primary sources remain load-bearing:
Moonen--Polishchuk arXiv:0904.3995; Beckmann--de Gaay Fortman
arXiv:2202.05230; Kahn arXiv:2602.11135v2; Li--Lin--Pertusi--Zhao
arXiv:2406.09124; Voisin arXiv:1005.5621 and arXiv:1407.7261; and
Engel--de Gaay Fortman--Schreieder arXiv:2507.15704v3.

Direct searches, recorded verbatim:

- `theta divisor resolution Chow motive integral Chow Kunneth projector abelian variety`
- `integral inverse Lefschetz abelian variety Chow correspondence`
- `abelian type motives integral coefficients Chow Kunneth`
- `decomposition theorem integral coefficients isolated singularity intersection form Chow motive`
- `cubic threefold charge 3 instanton moduli rational curves rational connectedness`
- `Abel-Jacobi fibre elliptic sextics cubic threefold rationally simply connected`
- `moduli stable sheaves rationally simply connected Hecke curves`
- `principally polarized abelian varieties isogenous elliptic power Neron Severi graph gluing classification`
- `divided power obstruction local algebra Jordan block exterior powers Smith normal form`

The bounded search covered arXiv primary records and the already cached
forward literature through August 2026.  It did not include a complete
MathSciNet, zbMATH, or citation-graph census.  No global absence claim is
made.

## 8. EJ/TT closeout and mystery ledger

- **Settled:** the indecomposable order-four result is real and supports a
  higher-layer theorem; it is not merely inherited from product
  stabilization.
- **Settled:** modular exterior-power theory is a genuine proof engine, but
  it supplies only the associated-graded characteristic-p calculation.  The
  p-adic carry/divided-power bridge is new and indispensable.
- **Highest-EV mystery:** does regular-primary height \(p^r\) force a nonzero
  \(r\)-th layer?  Exact evidence ends at \(r=2\).
- **Classification mystery:** are height and factorial valuation sufficient,
  or do orthogonal type and the full Jordan partition alter the formula?
- **Theta mystery:** favorable two-local topology does not explain how to
  algebraize the p15/p24 projector in ordinary Chow.
- **RSC mystery:** the charge-three fourfold lacks the proper polarized model
  on which “lines” and very twisting surfaces could even be formulated.

**Vibe:** the direct C904 crowns are still blocked by genuinely algebraic
two-primary descent.  The gluing branch is the one adjacent direction where
we already possess a nontrivial infinite theorem, an indecomposable
second-stage example, a precise conjectural classification, and a matching
primary proof engine.  It is the strongest Annals push available from the
current mathematics.
