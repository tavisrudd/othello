# C642: AME--LU referee and proof repair

**Date:** 2026-07-25

**Lane:** `ame-lu`

**Status:** mathematics, manuscript, Lean, and deterministic replay closed;
public deposit remains an author action

## Result

The blind-referee and eight-commit copy-review findings were repaired without
weakening the headline LU-to-LC rigidity theorem.

The only false displayed group statement was the claim
\(N(T)=T\rtimes C_2\) inside \(\mathrm{SL}_2(q)\) in odd characteristic.
The corrected statement is
\[
  N(T)=\langle T,J\rangle,\qquad
  J=\begin{pmatrix}0&-1\\1&0\end{pmatrix},\qquad
  J^2=-I,\qquad N(T)/T\cong C_2.
\]
Thus the linear torus-normalizer extension is nonsplit, while its
projectivization splits.  This does not change the twelve computed
party-permutation splittings: those are splittings of a different,
projective party-extension sequence.

## Proof repairs

1. The product-Clifford phase lift is now explicit.  A Clifford preserving
   the stabilizer-label Lagrangian may introduce a linear stabilizer
   character.  Nondegeneracy of the symplectic pairing represents its
   exponent by an ambient Pauli label, and conjugation by the corresponding
   product Pauli cancels the character.
2. The conic six-bound in the uniform \(H_3\)/GRS separator is now a
   standalone lemma.  Projection from a concurrency point gives a
   fixed-point-free involution of the conic, the converse recovers its
   center, and the finite-subgroup cases are tabulated with separate
   characteristic-three and characteristic-five treatment.
3. Generic constancy now produces a dense open subscheme defined over the
   base field and states constancy on its rational points; if there are no
   such points the rational-point clause is vacuous.  The complex FFT is
   applied pointwise after embedding each code state in
   \((\mathbb C^q)^{\otimes n}\).
4. The convention-sensitive classical phase bridge is now the standalone
   fixed-label self-association lemma.  It writes
   \(SC=C^\perp\) as \(AGS=H\) for generator and parity-check matrices and
   cites the exact branch-locus/Veronese-determinant discussion in
   Howard--Millson--Snowden--Vakil, Section 2.3.

The abstract now states the exact admitted non-GRS and odd-prime scope of
the \(z\)-classification.  Fixed-party, party-moving, and transversal
conventions are explicit.  The computed splitting census is marked as a
finite application rather than part of the uniform proof spine.

## Lean additions

`RelativeConicArcs.AMELU.LogicalPhase` now proves:

- `splitTorusWeylBlock_isSpecialLinear`;
- `splitTorusWeylBlock_mul_self`;
- `splitTorusWeylBlock_mul_splitTorusBlock`.

`RelativeConicArcs.AMELU.StabilizerDictionary` now proves:

- `pauliSymplecticToDual_injective`;
- `exists_pauliLabel_pairing_eq_dual`.

The latter theorem is stronger than the phase-repair use: every linear
functional on every Pauli-label subspace is induced by symplectic pairing
with an ambient label.  All five declarations report only `propext`,
`Classical.choice`, and `Quot.sound`.

## Current literature comparison

Three 2026 sources were cached and read at abstract, introduction, and
main-contribution level:

- Tansuwannont--Chan--Takagi, arXiv:2602.09788v3, constructs a generating
  set for the full logical Clifford group of high-rate quantum Reed--Muller
  codes using transversal and fold-transversal layers.
- Holmes, arXiv:2606.13521v1, constructs high-rate code families with a
  complete constant-depth \(2\)-local transversal logical Clifford
  instruction set.
- Chakraborty--Gottesman, arXiv:2602.13395v3 / PRX Quantum
  DOI `10.1103/y14y-7kp3`, proves that a fully transversal full Clifford
  group is impossible for more than one logical qubit and gives stronger
  \(k\)-fold bounds.

The manuscript comparison now says exactly that the present theorem
classifies a depth-one fixed-party product group for one logical qudit.
The constructive high-rate papers use additional fold-transversal or
\(2\)-local layers, while the multiple-logical-qubit no-go places the
one-logical-qudit positive theorem on the permitted boundary.

## Fresh frontier reads

Two independent post-repair cold readers converged on the following
follow-up targets.  These are not adopted in the current paper.

1. **General stabilizer-AME rigidity.**  For a stabilizer
   \(\operatorname{AME}(2m,q)\) state, the stabilizer subspace supported on
   any \(m+1\) parties appears to have local dimension exactly two (or
   \(2e\) after restriction of scalars), by a dimension lower bound and the
   absence of stabilizers on at most \(m\) parties.  This would feed the
   existing full-Weyl axis theorem and extend LU-to-LC rigidity beyond CSS.
2. **Global prime-field MDS--CSS orbit theorem.**  The inter-code block
   equations plus the multiplier-line proposition may imply
   \[
     \Psi_C\sim_{\mathrm{LU}}\Psi_D
     \quad\Longleftrightarrow\quad
     C\sim_{\mathrm{mon}}D
     \ \text{or}\ C\sim_{\mathrm{mon}}D^\perp
   \]
   over prime fields, allowing party permutations.  Mixed block patterns
   and the exact converse are the proof gates.
3. **Higher-dimensional phase geometry.**  Diagonal isoduality is the
   full-support dependence
   \(\sum_i s_i g_i g_i^{\mathsf T}=0\) among quadratic Veronese images of
   the \(2m\) projective columns.  The expected phase-locus codimension is
   \((m-1)(m-2)/2\); the six-point conic divisor is the \(m=3\) case.

Both readers also prioritized the already-recorded extension-field common-
Frobenius problem, quantitative rigidity, and unbounded scalar-copy-degree
questions.  They identified tensor identifiability, Schur-product
conductors, the syntheme--pentad model of the outer automorphism of \(S_6\),
and determinantal/matroid stratification as strong organizing connections.

## Independent grade

A final fresh evaluator found no broken proof after the repairs and returned
an overall score of **8.4/10**, with **8.8** for correctness/rigor, **8.4**
for significance, **9.0** for conceptual depth, **9.3** for reproducibility,
and **8.3** for publication readiness.  The recommendation was
**accept after minor revision** in a strong specialized quantum
information/coding/finite-geometry venue band.  Its remaining weaknesses
were theorem hierarchy, the self-association citation bridge, and public
artifact deposit.  The self-association issue was repaired immediately as
described above; moving finite applications to a supplement is an editorial
choice, and public deposit remains an author action.

## Validation

- Guarded elaboration passed for the modified Lean source modules.
- `RelativeConicArcs.Gates.AMELUAggregate` passed in 82.41 seconds.
- `RelativeConicArcs.Gates.AMELUAggregateAxioms` passed in 13.69 seconds.
- `make check` passed without TeX warnings.
- `python3 supplement/verify.py --replay` verified 17 artifacts and replayed
  all eight evidence bundles.
- The final PDF has 25 pages and SHA-256
  `664c9d49519904042d82060987ea9985d7db50bd870619c325fb6e59657de62a`.
- Pages 1, 17, 19, and 20 were visually inspected.
- The release verifier reports 37 public artifacts with tree
  `9c9c8a561c406cb8e0075d34866c70ef62b14337945bd830d1a18abff97512ab`
  and 80 formal artifacts with tree
  `a8db1c01b5578b30a55ae333f531ed16be3e01dc724ceccaa26adf6700fbae41`.

## Remaining release boundary

No mathematical blocker remains from the two reviews.  A public DOI or
archive URL still requires author action.  The formal companion also retains
two disclosed foreign-owned prose defects:
`RelativeConicArcs/Plane.lean` reverse-references another paper directory,
and `FiniteGeom/Code.lean` cites an internal handoff/work phase.  They do not
change an elaborated theorem or axiom dependency, but the companion should
not be called referee-prose clean until their owners repair them.
