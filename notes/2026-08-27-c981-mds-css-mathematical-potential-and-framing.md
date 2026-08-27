# C981 MDS--CSS mathematical potential and framing

**Lane:** `ame-lu`

**Status:** completed 2026-08-27

## Goal

Determine which mathematical and publication opportunities become visible once
*Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS Codes* is read
as a theorem-driven quantum-coding paper.  The task is exploratory but must end
in bounded, evidence-backed recommendations rather than a general research
programme.

This task follows the exposition revision in C979 but does not replace it and
does not authorize closing it.

## Questions

1. **Portability of the multiplier method.**  Identify exactly where the MDS
   hypotheses force
   \(\dim \mathcal D(C,C^\perp)\leq 1\), and determine what useful statement
   survives for broader CSS code families.  Distinguish a direct generalization,
   a conditional theorem, and a genuinely new conjecture.
2. **Structure beyond the dichotomy.**  Examine what local symplectic groups
   can arise when the relevant coordinatewise-multiplier spaces have dimension
   greater than one.  Decide whether the present block-equation argument gives
   a reusable classification framework or only an MDS-specific shortcut.
3. **Six-point follow-up potential.**  Assess whether the conic criterion,
   rational pencil quotient, transition invariants, and extension-field caveat
   support a coherent independent theorem or paper.  Do not promote bulk finite
   calculations unless they serve a conceptual statement.
4. **Invariant limitation.**  Test whether the generic constancy of fixed-copy
   scalar invariants can be stated as a broader negative result relevant to
   stabilizer tensors or code equivalence, and identify the minimum hypotheses
   needed for a defensible theorem.
5. **Publication framing and novelty.**  Compare the exact theorem, method, and
   convention against current primary literature on transversal gates,
   stabilizer-code automorphisms, MDS/CSS constructions, and coordinatewise
   code equivalence.  State precisely what is new, what is imported, and what
   would interest a quantum-information referee.

## Method and safeguards

- Begin from the proved block equations and dependency ledger; do not infer a
  broader theorem from analogy alone.
- Use current primary literature for novelty claims and record exact search
  scope and stop conditions.
- Use standard quantum-information and coding-theory terms and notation.  Flag
  any manuscript-local term that still obscures comparison with the literature.
- Keep fixed-coordinate, site-dependent transversality distinct from uniform
  transversality and from coordinate-permuting automorphisms throughout.
- Preserve the boundary between paper-local proofs and imported rigidity.
- Do not edit the manuscript merely because an idea is attractive.  Rank each
  proposed change by confidence, expected value, proof cost, and scope risk.

## Deliverables

1. A theorem-dependency diagram showing which conclusions use CSS structure,
   MDS rigidity, equal dimension, fixed coordinates, and Clifford rigidity.
2. A portability memo with the strongest proved extension available cheaply,
   counterexamples or obstructions where appropriate, and clearly labelled
   conjectures.
3. A current novelty/framing audit based on primary sources.
4. A ranked recommendation table with four possible dispositions: adopt in the
   present paper, state as an outlook question, queue as a successor, or drop.
5. If a successor is justified, a bounded proposed task description; allocate
   no further task ID without explicit instruction.

## Acceptance gate

- Every proposed theorem is either proved, supported by a reproducible finite
  experiment with stated scope, or labelled conjectural.
- The analysis identifies the exact step that fails outside the MDS setting.
- At least one skeptical-referee pass tests novelty, convention, and imported
  dependencies.
- Recommendations do not blur the main paper's exact scope or turn it back into
  a multi-field survey.

## Executive conclusion

The cleanup exposed one immediate mathematical upgrade and one genuine
successor problem.

The immediate upgrade is to identify the manuscript's multiplier space with
the standard **conductor of codes**:
\[
 \operatorname{Cond}(E,F)
 =\{s:s\star E\subseteq F\}
 =(E\star F^\perp)^\perp .
\]
Consequently,
\[
 \mathcal D(C,C^\perp)
 =\operatorname{Cond}(C,C^\perp)
 =(C^{\star2})^\perp,
 \qquad
 \dim\mathcal D(C,C^\perp)
 =n-\dim C^{\star2}.
\]
Thus the headline theorem is equivalently a full-rank versus codimension-one
Schur-square test.  This is standard coding-theory language, makes the test
easier to recognize and compute, and situates the result at the exceptional
half-rate boundary of the theory of Schur squares of MDS codes.

The genuine successor problem is the exact extension-field classification.
Over \(\mathbb F_{p^e}\), the field-linear conductor calculation still gives a
large subgroup, but the full local Clifford group is trace-symplectic over
\(\mathbb F_p\) and includes Frobenius-semilinear sectors.  Completing that
classification would unlock recent isometry-dual elliptic MDS constructions
that naturally live over extension fields.

The all-CSS dichotomy does **not** survive.  The block equations generalize
exactly, but non-MDS codes can have partial-support conductor vectors.  Those
vectors produce intermediate unipotent and Borel logical images.  The MDS
hypothesis is precisely what excludes this third behavior.

The six-point quotient and fixed-copy scalar-invariant result should remain
applications or limitations in the present paper.  Neither currently has a
large enough independent conceptual crown for a separate paper.

## Theorem-dependency map

| Step | Exact input | Consequence | What fails without it |
|---|---|---|---|
| Product unitary to local Clifford | imported stabilizer-AME rigidity | arbitrary fixed-coordinate product unitaries may be classified through Pauli labels | the calculation classifies only the local-Clifford subgroup |
| Local Clifford to \(2\)-by-\(2\) field matrices | odd prime local dimension | each site acts through \(\mathrm{SL}_2(q)\) | for \(q=p^e\), the full group acts through \(\mathrm{Sp}_{2e}(p)\) and has semilinear sectors |
| Fixed coordinates | no coordinate permutation | matrix entries assemble into diagonal coefficient vectors | coordinate motion replaces diagonal maps by monomial transport and is a separate extension problem |
| CSS form | label space \(C_X\oplus C_Z^\perp\) | preservation becomes four conductor inclusions | a general stabilizer needs Rains's full invariance algebra rather than the CSS block form |
| Half dimension | \(n=2m\), \(\dim C=m\) | a nonsingular conductor sends \(C\) onto \(C^\perp\); every encoder view carries one logical qudit | an injective cross-map need not be onto, and the logical symplectic group has a different rank |
| MDS rigidity | \(d(C)=d(C^\perp)=m+1\) | self-conductors are scalar and every nonzero cross-conductor has full support | partial-support conductors and decomposable self-conductors give intermediate groups |
| Stabilizer-character correction | imported Pauli correction | a label-space symmetry lifts to a symmetry of the chosen state ray | label preservation alone need not preserve stabilizer phases |
| Choi/AME dictionary | every one-party marginal is maximally mixed | an input-site block is the projective logical action of the associated \([[2m-1,1,m]]_q\) encoder | a general CSS state need not define the same one-qudit quantum MDS encoder |

The theorem's proof architecture is therefore
\[
 \text{product unitary}
 \xrightarrow{\text{imported rigidity}}
 \text{local Clifford}
 \xrightarrow{\text{CSS + fixed coordinates}}
 \text{conductor block equations}
 \xrightarrow{\text{MDS}}
 \{T,\mathrm{SL}_2(q)\}.
\]
Only the last arrow is the MDS collapse; only the first arrow makes the answer
exact among arbitrary product unitaries.

## Portable conductor formulation

Let \(C\leq\mathbb F_q^n\), write \(A\star B\) for the span of all
coordinatewise products, and put
\[
 \operatorname{Cond}(A,B)=\{s\in\mathbb F_q^n:s\star A\subseteq B\}.
\]
For \(s\in\mathbb F_q^n\), the condition \(s\star A\subseteq B\) is
equivalent to
\[
 \langle s,a\star h\rangle=0
 \quad(a\in A,\ h\in B^\perp),
\]
which proves
\[
 \operatorname{Cond}(A,B)=(A\star B^\perp)^\perp.
\]
In particular, the diagonal stabilizer algebra
\[
 \operatorname{St}(C):=\operatorname{Cond}(C,C)
 =(C\star C^\perp)^\perp
\]
satisfies \(\operatorname{St}(C)=\operatorname{St}(C^\perp)\).

For the CSS stabilizer state with label space
\(L_C=C_X\oplus C_Z^\perp\), the fixed-coordinate, field-linear local
symplectic stabilizer is exactly
\[
 \mathcal K_C=
 \left\{
 (F_i)_{i=1}^n\in\mathrm{SL}_2(q)^n:
 \begin{array}{l}
  \alpha,\delta\in\operatorname{St}(C),\\
  \gamma\in\operatorname{Cond}(C,C^\perp),\\
  \beta\in\operatorname{Cond}(C^\perp,C)
 \end{array}
 \right\},
\]
where
\(F_i=\left(\begin{smallmatrix}\alpha_i&\beta_i\\
\gamma_i&\delta_i\end{smallmatrix}\right)\).  The coordinatewise determinant
condition \(\alpha\star\delta-\beta\star\gamma=\mathbf1\) is implicit.
This is the reusable content of the block equations.  It needs neither MDS nor
equal dimension, but it should be presented as the CSS specialization of the
existing invariance-algebra framework, not as a new general classification.

### Conditional extension beyond MDS

Assume \(n=2\dim C\) and \(\operatorname{St}(C)=\mathbb F_q\mathbf1\).
If \(\operatorname{Cond}(C,C^\perp)\) contains a full-support vector \(s\),
then
\[
 s\star C=C^\perp,
 \qquad
 \operatorname{Cond}(C,C^\perp)=\mathbb F_qs.
\]
Indeed, multiplication by \(s\) is invertible and the inclusion is an equality
by equal dimension.  For any other conductor vector \(t\), multiplication by
\(s^{-1}\star t\) preserves \(C\); scalarity of the stabilizer algebra gives
\(t\in\mathbb F_qs\).  The reverse conductor is then
\(\mathbb F_qs^{-1}\), and the same upper and lower shear construction gives
the propagated \(\mathrm{SL}_2(q)\) field-linear subgroup.

Thus MDS is stronger than needed on the isometry-dual branch.  What MDS adds is
the assertion that **every nonzero cross-conductor has full support** and that
the stabilizer algebra is scalar.

### Exact obstruction outside MDS

For \(s\in(C^{\star2})^\perp\) with support \(S\), the puncturing of \(C\)
to \(S\) is self-orthogonal for the nondegenerate weighted form
\[
 (x,y)\longmapsto\sum_{i\in S}s_ix_iy_i.
\]
For an \([2m,m,m+1]_q\) MDS code, puncturing to \(S\) has dimension
\(\min\{m,|S|\}\).  A self-orthogonal subspace of the nondegenerate space
\(\mathbb F_q^S\) has dimension at most \(|S|/2\).  These inequalities force
\(|S|=2m\).  This is a direct explanation of the MDS step: an MDS code has no
proper puncturing that can be weighted self-orthogonal.

Outside MDS, a proper puncturing can have that property.  Its conductor vector
gives a supported lower or upper shear, so intermediate local symplectic groups
appear.

### Minimal intermediate example

Over \(\mathbb F_3\), let
\[
 C=\operatorname{rowspan}
 \begin{pmatrix}
 1&0&0&1\\
 0&1&1&1
 \end{pmatrix}.
\]
Then \(d(C)=d(C^\perp)=2\), so the associated four-qutrit CSS state has
maximally mixed one-party marginals, but it is not AME.  Direct row-space
calculation gives
\[
 \begin{aligned}
 \operatorname{St}(C)&=\mathbb F_3(1,1,1,1),\\
 \operatorname{Cond}(C,C^\perp)&=\mathbb F_3(0,1,2,0),\\
 \operatorname{Cond}(C^\perp,C)&=\mathbb F_3(1,0,0,2).
 \end{aligned}
\]
The two cross-conductors have disjoint support.  Hence \(\mathcal K_C\)
contains, and the displayed conductor formula shows that it equals, the group
with
\[
 \alpha=a\mathbf1,
 \quad\delta=a^{-1}\mathbf1,
 \quad\gamma=c(0,1,2,0),
 \quad\beta=b(1,0,0,2),
\]
for \(a\in\mathbb F_3^\times\) and \(b,c\in\mathbb F_3\).  At the first input
coordinate the field-linear logical image is a Borel subgroup of
\(\mathrm{SL}_2(3)\), strictly between the split torus and the full group.
This proves that the MDS dichotomy cannot be extended to all half-dimensional
CSS states.

## Geometric interpretation of the conductor

If the columns of a generator matrix for \(C\) are points in
\(\mathbb P^{m-1}\), then \(C^{\star2}\) is the quadratic evaluation code of
those points.  The cross-conductor \((C^{\star2})^\perp\) is the space of
linear relations among their quadratic Veronese images.  Proposition 3.1 says
that the \(2m\) Veronese images of an MDS arc are either independent or form a
single full-support circuit.

For \(m=3\), a defect-one quadratic evaluation matrix is exactly the conic
condition used in the manuscript.  For larger \(m\), defect one is the
standard self-association/arithmetic-Gorenstein phenomenon and does not force
the arc onto a rational normal curve.  This explains why the six-point
conic/GRS equivalence is special and why non-GRS codes occur on the isometry-
dual branch at length eight and beyond.

This geometric translation is useful as a short remark, but it should not be
inserted into the first-pass quantum-information narrative.

## Current literature and novelty audit

### Search scope

The audit searched primary arXiv or journal records through 2026-08-27 in five
clusters:

1. transversal Clifford classifications and stabilizer-code automorphisms;
2. quantum MDS/CSS transversal gates under uniform and site-dependent
   conventions;
3. Schur products, conductors, stabilizer algebras, and half-rate MDS squares;
4. isometry-dual MDS and algebraic-geometry code constructions;
5. Gale self-association and fixed-degree local-unitary invariant theory.

The search stopped after the current papers cited by the manuscript and their
most relevant forward/related primary papers had been checked, and after
targeted searches for the conjunctions “MDS--CSS + transversal Clifford,”
“code conductor + transversal gate,” and “Schur square + transversal
Clifford” returned no direct predecessor.  This is evidence for a scoped
novelty statement, not proof of priority; the manuscript should continue to
avoid an unqualified firstness claim.

### Closest results and exact distinction

- Rains's *Nonbinary Quantum Codes* (1999) supplies the broad symplectic
  invariance-algebra viewpoint.  The general conductor block matrix should be
  credited as a CSS specialization of that framework.
- Tansuwannont--Takada--Fujii (2025) give necessary and sufficient conditions
  for uniform physical Hadamard and site-signed phase implementations on
  self-dual CSS codes.  They do not compute the present odd-prime,
  site-dependent exact group for the quantum MDS family.
- Dasu--Burton (2025) classify diagonal transversal Clifford groups for qubit
  stabilizer codes using Rains-style endomorphism algebras.  The alphabet,
  multiblock diagonal convention, and classification target differ.
- Sayginel et al. (2025) construct logical Clifford gates from code
  automorphisms and ZX dualities.  Coordinate-moving automorphisms are outside
  the manuscript's headline fixed-coordinate group.
- Holmes (2026) constructs high-rate codes with complete transversal Clifford
  instruction sets, and Albert (2026) gives normal forms for Clifford circuits
  preserving CSS codes.  These strengthen the motivation for exact logical
  images but do not subsume the MDS nullity classification.
- The conductor identity is standard in code-based cryptography; Couvreur,
  Márquez-Corbella, and Pellikaan give
  \(\operatorname{Cond}(A,B)=(A\star B^\perp)^\perp\).  The manuscript should
  use and cite this terminology rather than present \(\mathcal D\) as an
  isolated new object.
- Mirandola--Zémor (2015) place Schur squares of MDS codes in the product-
  Singleton/Kneser framework.  They explicitly identify \(\dim C=n/2\) as the
  boundary where codimension-one squares need not characterize GRS codes, and
  identify \(C_{11,8,8}\) and \(C_{13,8,21}\) as non-GRS examples.  The original
  classification of Betsumiya--Georgiou--Gulliver--Harada--Koukouvinos lists
  both generator matrices and verifies minimum distance five, so these examples
  have now been checked at the primary construction rather than inherited from
  a secondary citation.
- Rodríguez-Pajares--Ruano--Salizzoni (2025) relate the Schur-square defect of
  self-dual codes to indecomposability and arithmetically Gorenstein
  self-associated point sets.  This is the right neighboring reference for
  the all-length geometric interpretation, not a result the quantum paper
  should claim as new.
- Zhu--Zhao (2026) construct isometry-dual MDS codes from elliptic curves,
  including explicit extension-field examples.  Their fixed-order scaling
  relation is exactly the classical input needed for the manuscript's
  full-\(\mathrm{SL}_2(q)\) field-linear branch, but full Clifford exactness over
  extension fields remains outside the present theorem.
- Howard--Millson--Snowden--Vakil and the classical Gale literature already
  own the six-point self-association geometry.  The manuscript's novelty there
  is the quantum transversal-group consequence and the explicit finite pencil
  analysis, not the conic criterion by itself.
- General local-unitary invariant theory provides finite separating invariant
  sets in each fixed tensor format.  The manuscript's generic-constancy result
  is a special statement about fixed-degree contractions along finite-field
  code charts; it should not be advertised as a general obstruction to LU
  classification.

Primary checkpoints for the coding-theory conclusions are Couvreur--Márquez-
Corbella--Pellikaan, [*Cryptanalysis of McEliece Cryptosystems Based on
Algebraic Geometry Codes*](https://doi.org/10.1109/TIT.2017.2712636), for the
conductor identity; Mirandola--Zémor,
[*Critical Pairs for the Product Singleton Bound*](https://arxiv.org/abs/1501.06419),
for the half-rate Schur-square boundary and the non-GRS identifications;
Betsumiya et al., [*On Self-Dual Codes over Some Prime
Fields*](https://doi.org/10.1016/S0012-365X(02)00520-4), for the original
prime-field classifications; Rodríguez-Pajares--Ruano--Salizzoni,
[*Self-Dual Codes and Schur Square Defect*](https://arxiv.org/abs/2512.16766),
for the modern self-associated-point interpretation; and Zhu--Zhao,
[*Isometry-Dual MDS Codes from Elliptic
Curves*](https://arxiv.org/abs/2502.02033), for the extension-field successor
direction.

The defensible novelty statement is therefore:

> For odd-prime one-logical-qudit quantum MDS--CSS codes, under the
> fixed-coordinate convention allowing different one-qudit gates at different
> sites, the paper computes the exact projective transversal logical group.
> The new step is the MDS collapse of the CSS conductor equations to a
> zero/one-dimensional Schur-square defect, combined with imported AME
> rigidity to exclude all additional product unitaries.

## Publication framing

For a quantum-information venue, the standard first-pass title should lead
with the object and result, for example

> **Exact Transversal Clifford Groups of Quantum MDS--CSS Codes**.

“Diagonal isoduality” is not established standard terminology.  In the body,
prefer either “\(C\) is diagonally equivalent to \(C^\perp\)” or
“the isometry-dual property with fixed coordinate order,” followed by the
precise equation \(s\star C=C^\perp\).  If a short noun is needed after that,
“fixed-order isometry-duality” is closer to the current coding literature than
“diagonal isoduality.”

The main significance sentence should become:

> A potentially large site-dependent local-Clifford calculation reduces to
> the codimension of the classical Schur square \(C^{\star2}\), which MDS
> rigidity forces to be zero or one.

The paper should also state explicitly that the full-Clifford branch is not a
GRS-only phenomenon.  The codes \(C_{11,8,8}\) and \(C_{13,8,21}\) in the
classification of Betsumiya et al. are self-dual \([8,4,5]\) MDS codes, and
Mirandola--Zémor verify that they are not GRS.  They therefore give explicit
non-GRS quantum MDS encoder examples in the theorem's prime-field scope.  This
is a more compelling all-length application than adding further six-point
calculations.

## Ranked recommendations

| Rank | Recommendation | Disposition | Confidence | Expected value | Proof cost | Scope risk |
|---|---|---|---|---|---|---|
| 1 | Rename \(\mathcal D(E,F)\) as the code conductor, record \(\operatorname{Cond}(E,F)=(E\star F^\perp)^\perp\), and restate the test as Schur-square codimension | adopt in present paper | proved | very high | low | low |
| 2 | Replace “diagonal isoduality” in the title/first-pass prose by standard fixed-order isometry-dual or diagonal-equivalence language | adopt in present paper | high | high | low | low |
| 3 | Add \(C_{11,8,8}\) and \(C_{13,8,21}\) as explicit non-GRS self-dual MDS examples | adopt in present paper | checked in the original classification and Mirandola--Zémor | high | low | low |
| 4 | Add one compact remark giving the general conductor block equations and naming partial-support conductors as the obstruction outside MDS | adopt or place in outlook | proved | medium-high | low | medium |
| 5 | Mention the Veronese-circuit interpretation after Proposition 3.1, with the six-point conic as its \(m=3\) specialization | optional present-paper remark | proved | medium | low | medium |
| 6 | Complete the odd-prime-power trace-symplectic/Frobenius classification and apply it to isometry-dual elliptic MDS codes | unallocated successor | open | very high | high | low if separate |
| 7 | Classify intermediate groups from partial-support conductors via punctured weighted self-orthogonality | outlook or later successor | open | medium | high | high in present paper |
| 8 | Split the six-point pencil into a separate paper now | drop | high | low | high | very high |
| 9 | Promote generic constancy of fixed-copy invariants to a standalone general LU no-go theorem | drop | high | low | high | very high |

## Proposed successor, not allocated

**Prime-power semilinear completion.**  For \(q=p^e\) with odd \(p\), compute
the exact fixed-coordinate projective transversal logical group of the
MDS--CSS family inside the full trace-symplectic local Clifford group.  Express
the answer through field-linear conductors and Frobenius-twisted conductors,
prove completeness of the sector decomposition, and test the result on
isometry-dual elliptic MDS codes.  The gate is an all-length conceptual theorem
with exact prime-power scope; a census of the existing pencil is not enough.

## Skeptical-referee pass

1. **“The conductor equations are already known.”**  Correct.  Credit Rains's
   invariance algebra and the coding-theory conductor identity.  Claim only
   the MDS collapse and exact quantum group as the paper-local result.
2. **“Full transversal Clifford groups are already constructed for many CSS
   codes.”**  Distinguish construction from exact classification, qubits from
   odd-prime qudits, uniform gates from site-dependent gates, and
   coordinate-moving automorphisms from the fixed-coordinate group.
3. **“The theorem's exactness is outsourced.”**  Say in the theorem roadmap
   and verification table that arbitrary-product-unitary exactness uses the
   imported stabilizer-AME rigidity theorem.  The conductor calculation alone
   proves the exact local-Clifford image.
4. **“Isometry-dual MDS codes are not new.”**  Agreed.  They are inputs and
   examples; the new conclusion is their exact transversal logical group.
5. **“Why restrict to prime fields?”**  Because full local Clifford labels over
   \(\mathbb F_{p^e}\) are trace-symplectic over \(\mathbb F_p\), not merely
   \(\mathrm{SL}_2(q)\).  Do not imply that the current Frobenius-sector
   calculation is complete.
6. **“The scalar-invariant section sounds stronger than it is.”**  Keep the
   fixed-degree, chartwise, and finite-field-point qualifications adjacent to
   the claim; do not use it as a headline novelty statement.
7. **“The six-point applications dominate the paper.”**  Keep them visibly
   downstream.  The length-eight non-GRS example is the cheapest way to show
   that the all-length theorem has content beyond the conic/GRS case.

The core novelty and scope survive this pass.  The main avoidable referee risk
is continuing to use manuscript-local terminology where “conductor,” “Schur
square,” and “isometry-dual with fixed coordinate order” already exist.

## Extra-value and Tao-style closeout

The most useful conceptual compression is the Veronese-circuit viewpoint.
The half-rate MDS theorem does not merely say that a matrix has nullity at most
one: it says that the quadratic Veronese images of the arc are independent or
form one full-support circuit.  This simultaneously explains the conductor
nullity, the special six-point conic criterion, the existence of higher-length
non-GRS examples, and the precise non-MDS failure through proper supported
circuits.  It is the right optional geometric remark after the core coding-
theory proof.

The cheapest genuinely new application is now fully pinned down.  The original
prime-field classification gives generator matrices and minimum distance five
for \(C_{11,8,8}\) and \(C_{13,8,21}\); the Schur-product literature proves that
these two self-dual MDS codes are not GRS.  No new calculation is needed to
obtain non-GRS \([[7,1,4]]_{11}\) and \([[7,1,4]]_{13}\) encoders with the full
projective transversal Clifford group covered by the manuscript theorem.

No incidental discovery-track entry is required: every finding above answers
an explicit C981 deliverable.

## Mystery ledger

### Settled here

- The all-CSS torus/full-\(\mathrm{SL}_2\) dichotomy is false; the displayed
  four-qutrit example has a Borel logical image.
- The standard object replacing the manuscript-local multiplier-space language
  is the code conductor, equivalently the orthogonal complement of the Schur
  square in the cross-dual case.
- The full-group branch is nonempty beyond GRS codes within the present
  prime-field theorem: \(C_{11,8,8}\) and \(C_{13,8,21}\) are explicit examples.

### Open but bounded

- **Prime-power exactness:** classify the Frobenius-semilinear sectors of the
  full trace-symplectic local Clifford group.  This is the recommended
  unallocated successor and needs a new proof, not finite sampling.
- **Elliptic-code payoff:** determine which isometry-dual elliptic MDS families
  yield useful infinite prime-field subfamilies.  The checked explicit examples
  in the recent construction are over extension fields, so the present report
  makes no prime-field-family claim.
- **Intermediate-group taxonomy:** describe local logical images generated by
  several partial-support conductors.  The conductor equations give the right
  framework, but a useful classification requires hypotheses on the support
  arrangement and is low priority for this paper.
- **Priority boundary:** the literature search found no direct predecessor for
  the exact fixed-coordinate, site-dependent odd-prime MDS--CSS group theorem,
  but an exhaustive firstness claim remains unjustified.  Keep the scoped
  comparison above.

There is no unresolved issue that blocks the recommended present-paper edits.
