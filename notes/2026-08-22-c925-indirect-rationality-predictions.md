# Indirect rationality predictions for cubic stabilization

## Question

Let \(B\subset \mathbf P^4_{\mathbf C}\) be a smooth cubic threefold.  For
\(m\geq 0\), write

\[
  R_m(B):\qquad B\times \mathbf P^m \dashrightarrow
  \mathbf P^{m+3}
\]

for the assertion that the displayed varieties are birational.  The direct
quantum proof tries to contradict \(R_m(B)\) after weak factorization.  This
note instead asks what \(R_m(B)\) predicts before choosing any factorization,
completion, Stokes sector, or wall comparison.

The main conclusion is clean but sharply limited:

* for a very general cubic, a parity theorem first posted in 2025 contradicts
  a necessary consequence of \(R_m(B)\) for every \(m\) at once;
* for an arbitrary smooth cubic, all classical obstructions audited here stop
  at universal \(\mathrm{CH}_0\)-triviality, which is known to hold on nonempty
  special loci and therefore cannot prove the desired theorem;
* ordinary intermediate-Jacobian, Hodge, categorical, and conic-bundle
  invariants are not stable enough.  Their failure is structural, not a
  problem of packaging.

## Which varieties are rational, and why?

Rational varieties usually come with one of a small number of geometric
mechanisms.

| Shape | Reason for rationality |
|---|---|
| \(\mathbf P^n\), affine space, and products of them | They are the parameter spaces themselves. |
| A split toric variety | Its dense torus is birational to affine space. |
| A Grassmannian, flag variety, or split projective homogeneous space \(G/P\) | Its big Bruhat cell is a dense affine open set. |
| A projective bundle over a rational base | It is birationally a product with projective space. |
| A fibration with rational generic fibre and a sufficiently explicit section/trivialization | The base parameters and fibre parameters give independent coordinates.  The section alone is not always enough; the generic fibre must be rational over the base field. |
| A blowup or blowdown of a rational variety | Blowup changes the model, not the function field. |
| A quadric with a rational point | Projection from the point gives a rational parametrization.  Over \(\mathbf C\), every smooth positive-dimensional quadric has a point. |
| A smooth cubic surface over \(\mathbf C\) | Its configuration of lines allows six disjoint lines to be contracted to \(\mathbf P^2\). |
| A cubic hypersurface with a double point | Projection from the double point is birational: a general line through it has only one residual intersection. |
| Some quotients, torsors, and conic bundles | A rational auxiliary torsor and a stably permutation resolution of its structural torus can produce a stable birational parametrization.  This is the principal mechanism behind known stably rational but nonrational complex examples. |

This table also explains why a smooth cubic threefold is difficult.  It has no
double point to project from.  Projection from a line produces a conic bundle
and a degree-two unirational parametrization, not a birational chart.

## Which irrational varieties become rational after stabilization?

The basic complex example is the Beauville--Colliot-Thélène--Sansuc--
Swinnerton-Dyer conic-bundle threefold.  A representative affine equation is

\[
  y^2-\delta(t)z^2=P(x,t),\qquad
  P(x,t)=x^3+p(t)x+q(t),\qquad
  \delta(t)=4p(t)^3+27q(t)^2.
\]

For suitable irreducible \(P\) with \(\deg \delta\geq5\), a smooth projective
model is not rational, as detected by its Prym/intermediate Jacobian, but is
stably rational.  The original Annals proof makes its product with
\(\mathbf P^3\) rational by a torsor computation under algebraic tori;
Shepherd-Barron observed that \(\mathbf P^2\) already suffices.  It is not
known whether the product with \(\mathbf P^1\) is rational.

The mechanism matters more than the equation.  Beauville--Colliot-Thélène--
Sansuc--Swinnerton-Dyer construct a rational auxiliary torsor total space and
use a stable-permutation resolution of the structural torus to obtain stable
rationality of the base.  This is not the assertion that a nontrivial torsor
class becomes trivial after adjoining independent transcendental variables.
The intermediate-Jacobian obstruction still proves that the threefold itself
is not rational.  Thus ordinary Clemens--Griffiths data can disappear at
exactly the \(m=2\) stabilization relevant here.

Over nonclosed fields there are many analogous shapes: Châtelet surfaces,
forms of tori, and quotient varieties whose Galois lattices become permutation
lattices after adding variables.  Over \(\mathbf C\), smooth nonrational but
stably rational examples are rare, and conic-bundle/torsor constructions are
the standard model.  No smooth cubic threefold is currently known to be
stably rational.

## First-order predictions of \(R_m(B)\)

These consequences use only the existence of the birational map.

### P1. The rational indices form an upper set

If \(R_m(B)\) holds, then \(R_{m+k}(B)\) holds for every \(k\geq0\): take a
product with \(\mathbf P^k\) and use the rationality of
\(\mathbf P^m\times\mathbf P^k\).  Therefore irrationality at an unbounded set
of indices implies irrationality at every index.  Irrationality at \(m=1\)
alone says nothing about \(m=2\).

### P2. Universal \(\mathrm{CH}_0\)-triviality

For every field extension \(L/\mathbf C\), projective-bundle invariance gives

\[
  \mathrm{CH}_0(B_L\times\mathbf P^m)=\mathrm{CH}_0(B_L).
\]

Since projective space is universally \(\mathrm{CH}_0\)-trivial, \(R_m(B)\)
forces universal \(\mathrm{CH}_0\)-triviality of \(B\).

### P3. An integral decomposition of the diagonal

Universal \(\mathrm{CH}_0\)-triviality is equivalent to an equality

\[
 [\Delta_B]=[B\times b]+Z
 \quad\text{in }\mathrm{CH}^3(B\times B),
\]

where \(Z\) is supported on \(D\times B\) for a proper closed subset
\(D\subsetneq B\).  Integral coefficients and the support condition are both
essential.  A rational-coefficient equality is too weak.

### P4. Algebraicity of the minimal theta class

Voisin proves for every smooth cubic threefold that the preceding conditions
are equivalent to algebraicity of

\[
  \frac{\theta^4}{4!}\in H^8(J(B),\mathbf Z)
\]

as the class of a signed integral one-cycle on the intermediate Jacobian.
Thus \(R_m(B)\) predicts this algebraicity for every \(m\).

### P5. Vanishing of stable unramified invariants

Every unramified invariant attached to a cycle module must take its rational
value.  The elementary tests do not help here: the smooth complex cubic has
torsion-free \(H^3\), trivial Brauer obstruction, and no currently known
ordinary unramified class separating every smooth cubic.  Universal
degree-three statements return to the same diagonal/universal-cycle complex.

### P6. A rational surface fibration after choosing the parametrization

The field isomorphism behind \(R_2(B)\) gives a rational map
\(\mathbf P^5\dashrightarrow B\) whose generic fibre is a rational surface
over \(\mathbf C(B)\).  It does not make that map a projective bundle, a Mori
fibre space, or a conic bundle compatible with a chosen line projection of
\(B\).

### P7. Birational symmetries embed in the Cremona group

Conjugation by the hypothetical parametrization embeds
\(\operatorname{Bir}(B)\) into \(\operatorname{Cr}_{m+3}\).  The transported
actions need not be regular, linear, or simultaneously linearizable.  Hence
fixed loci and equivariant Burnside symbols obstruct a proposed
linearization, not nonequivariant rationality.

## Second-order predictions and their exact limits

### S1. Very general cubics give an immediate contradiction

Engel, de Gaay Fortman, and Schreieder prove that every curve class on the
intermediate Jacobian of a very general cubic threefold is an even multiple
of the minimal class.  Consequently \(\theta^4/4!\) is not algebraic, so P4
contradicts \(R_m(B)\) for every \(m\geq0\).

This is a complete all-stabilizations proof for a very general cubic.  It is
not a proof for every smooth cubic.

### S2. Algebraic does not mean effective

The Clemens--Griffiths rationality criterion requires an effective minimal
curve class, or equivalently a product-of-Jacobians decomposition of the
principally polarized intermediate Jacobian.  Stable rationality predicts
only a signed integral cycle.  The passage from signed to effective is false
formally and false as a proposed proof step.  The Lean countermodel uses
classes two and three: \(1=3-2\) is a signed class, while no nonnegative
combination \(2a+3b\) equals one.

This is why the ordinary intermediate-Jacobian proof does not automatically
survive stabilization.

### S3. Universal \(\mathrm{CH}_0\)-triviality is not enough on special loci

Voisin constructs a nonempty countable union of proper loci in the moduli of
smooth cubic threefolds on which the minimal class is algebraic and
universal \(\mathrm{CH}_0\)-triviality holds.  These cubics are not thereby
known to be stably rational; they simply pass this necessary test.  Any proof
for every smooth cubic must separate them by a stronger invariant.

### S4. Ordinary Hodge and intermediate-Jacobian ledgers leak through centres

Weak factorization gives

\[
 H^k(\operatorname{Bl}_Z Y)
 =H^k(Y)\oplus\bigoplus_{i=1}^{c-1}H^{k-2i}(Z)(-i).
\]

Allowed centres can reproduce the cubic \(H^3\) atom.  Already the Fano
surface of lines has Albanese isomorphic to \(J(B)\).  In dimension five, a
threefold centre can carry the full length-three Tate string required by
\(B\times\mathbf P^2\).  Dimension bounds alone therefore do not exclude
correction cancellation.

### S5. Derived and motivic refinements have the same first-order leakage

Orlov's formula adds copies of \(D^b(Z)\); the blowup formula for Chow motives
adds shifted centre motives.  Without a positive or cancellation-reflecting
character that vanishes on every allowable centre, these identities do not
force the cubic component to disappear.  The quotient
\(K_0(\mathrm{Var})/(\mathbb L)\) records stable-birational classes, so proving
\([B]\ne1\) there restates the desired theorem rather than computes a new
obstruction.

### S6. A rational total space need not split a chosen conic

For \(K=\mathbf C(x,y)\), the conic

\[
 U^2-xV^2-yW^2=0
\]

has nontrivial quaternion class \((x,y)\) over \(K\), while its total function
field is rational after solving for \(y\) on \(W=1\).  Thus a hypothetical
rationalization of \(B\times\mathbf P^2\) may mix base and fibre variables and
need not split the generic conic arising from projection from a line.

### S7. Cancellation and coefficient multiplication require certificates

Weak-factorization formulas often produce an equality after multiplication
by \(m+1\).  A nonzero integer cannot be cancelled in an arbitrary target
group.  Over \(\mathbf Z/(m+1)\), multiplication by \(m+1\) is zero.  The Lean
interface therefore consumes an explicit injectivity certificate and checks
the red cases \(m=1,2,3,4,13\).

## Source dossier

### Claire Voisin, 2017 — refereed

*On the universal \(\mathrm{CH}_0\) group of cubic hypersurfaces*, Journal of the
European Mathematical Society 19 (2017), DOI 10.4171/JEMS/702,
arXiv:1407.7261.

Used results:

* Theorem 1.1: for odd-dimensional smooth cubics, cohomological and
  Chow-theoretic decompositions of the diagonal are equivalent.
* Corollary 4.4: for a smooth cubic threefold, diagonal decomposition is
  equivalent to algebraicity of \(\theta^4/4!\).
* Theorem 4.5: a nonempty countable union of special loci satisfies the
  condition.

This source provides the exact global consumer, but not nonalgebraicity for
every cubic.

### Engel--de Gaay Fortman--Schreieder, 2025 — preprint

*Matroids and the integral Hodge conjecture for abelian varieties*,
arXiv:2507.15704v3.

Used results:

* Theorem 1.3: every curve class on \(J(B)\) is an even multiple of the
  minimal class for very general \(B\).
* Corollary 1.4: a very general cubic has no diagonal decomposition and is
  neither stably rational nor retract rational.

The finite combinatorial core includes Propositions 7.5 and 7.6: certain
solution spaces for the \(K_{3,3}\), \(K_5\), and \(R_{10}\) matroids have no
2-indivisible solution.  The authors supply Sage computations.  The tracked
independent checker reconstructs the \(R_{10}\) graph from the displayed
matrix and finds 32 vertices, 160 edges, constraint rank 125, and kernel
dimension 35.  More strongly, it gives an explicit expression of each of the
ten colour-profile rows in the span of the 160 constraint rows.  The Lean
module checks all 1,600 coefficients of those expressions and proves the
symbolic implication from admissibility to profile vanishing.  The
degeneration, monodromy, regular-matroid, and specialization arguments remain
geometric inputs.

The exact replay command, from the repository root, is

```sh
python3 papers/cubic-stabilization-irrationality/verification/check_r10_albanese_parity.py --check
```

The generator/checker is
`papers/cubic-stabilization-irrationality/verification/check_r10_albanese_parity.py`;
its canonical output is the adjacent
`r10_albanese_parity_certificate.json`.  The input is the displayed integral
\(5\times10\) representation of \(R_{10}\), reduced modulo two, with the
reduced \(p=2\) orientation convention of Proposition 7.6.  The checker uses
right-pivot elimination with explicit row witnesses, and independently
recomputes both ranks by left-to-right elimination.  The replay is
deterministic, uses only the Python standard library, and was checked with
Python 3.13.12.  The certificate pins the
authors' code commit `6305aa878949d17e793e99cd6cb7203f30dbf64c` and records
the packed row hashes.  The replay also parses the Lean module and checks its
dual-column, component-support, and combination masks against the independent
reconstruction.  The adjacent checksum manifest records byte counts and
SHA-256 hashes for the checker, certificate, and Lean module.

### Beauville--Colliot-Thélène--Sansuc--Swinnerton-Dyer, 1985 — refereed

*Variétés stablement rationnelles non rationnelles*, Annals of Mathematics
121 (1985), DOI 10.2307/1971174.

This is the mandatory warning model: a conic-bundle threefold over a rational
surface is irrational by Prym/intermediate-Jacobian methods but becomes
rational after projective stabilization through a torus-torsor construction.

### N. I. Shepherd-Barron, 2004

*Stably rational irrational varieties*, in *The Fano Conference*,
pp. 693--700.

This supplies the exact level-two refinement: the Beauville--Colliot-Thélène--
Sansuc--Swinnerton-Dyer threefold becomes rational after multiplication by
\(\mathbf P^2\).  The original Annals paper proves the \(\mathbf P^3\) level.

### Ze Xu, 2013 — published claim with a known incorrect proof

*A remark on the Abel--Jacobi morphism for the cubic threefold*, Comptes
Rendus Mathématique 351 (2013), DOI 10.1016/j.crma.2012.12.002,
arXiv:1212.6790.

The paper claims a universal codimension-two cycle for every smooth cubic.
A direct correction of Theorem 2.3 shows the issue: it writes
\(\operatorname{ch}(\mathcal O_X(1))=1+h+\tfrac32l\), omitting
\(\tfrac12[\mathrm{pt}]\).  The relevant Euler characteristic is therefore
six rather than five, and the resulting gcd is two rather than one.  The
claimed fine-moduli criterion does not follow.  The claim is not used here.

### Kalyan Banerjee, 2025 — preprint

*Universal codimension two cycle on a very general cubic threefold*,
arXiv:2509.06013.

The paper separately claims nonexistence of a universal codimension-two cycle
for a very general cubic.  It is not needed once the Engel--de Gaay
Fortman--Schreieder parity theorem is used, and it is not treated as an
independent established route here.

## Where rationality is visible in the Lean development

The existing quantum modules begin after most of the global birational
geometry has already been converted into a path.  Rationality is therefore
visible at several distinct layers.

1. `StableRationalityConsequences.StableInvariant` consumes one global
   birational certificate and a genuinely stable invariant.  It never opens a
   weak factorization.
2. `StableRationalityConsequences.StableWitness` consumes one global
   birational certificate, a projective-space witness, and a separately typed
   projective-factor cancellation theorem.  An integral decomposition of the
   diagonal is the intended external instance.  The generic interface does
   not itself encode integral coefficients or the support condition; an actual
   `DiagWitness` adapter must carry both rather than expose a bare proposition.
3. `StableRationalityConsequences.StabilizationProfile` packages the geometric
   fact that rational indices are upward closed and proves that an unbounded
   set of irrational indices rules out every stabilization.
4. `RowedProjectorPath` and `TwoLayerDescentPacket` see rationality only after
   weak factorization has supplied an oriented path and comparison data.
5. `CubicBlockCertificate` sees the cubic local quantum marker, not
   rationality.  It becomes an obstruction only after a path theorem proves
   that the marker cannot be absorbed by corrections.
6. `HirzebruchSurfaceAugmentation` is a red test: the legal blowup
   \(B\times F_1\to B\times\mathbf P^2\) shows that the raw augmentation row
   leaks on a marked correction.

The module checks two abstract countermodels to common illicit upgrades:

* cancellation from a bare nonzero multiplicity fails over
  \(\mathbf Z/(m+1)\) for \(m=1,2,3,4,13\);
* membership in a group generated by two abstract classes does not formally
  imply membership in their positive monoid.

## Frontier

There are now two disjoint proof domains.

* **Very general cubic:** the global diagonal/minimal-class route gives an
  all-\(m\) proof after importing the currently unrefereed theorem in
  arXiv:2507.15704v3.  `R10AlbaneseParity` independently checks the finite
  \(R_{10}\) row-span calculation used in Proposition 7.6; it does not check
  the degeneration, monodromy, regular-matroid, or theta-class arguments.
* **Every smooth cubic:** the global classical route stops on the special
  universally-\(\mathrm{CH}_0\)-trivial loci.  The live quantum frontier remains
  the row-free, occurrence-coherent loop-stabilizer exclusion for correction
  packets.  No classical invariant audited here replaces that theorem.

The highest-value indirect next test is therefore not another wall-row
consumer.  It is a search for a stable invariant that remains nonzero on the
special universally-\(\mathrm{CH}_0\)-trivial cubics.  Any candidate must pass
the conic-bundle stable-rational example, the Fano-surface centre, the
\(B\times F_1\) correction, and the signed-versus-effective countermodel.
