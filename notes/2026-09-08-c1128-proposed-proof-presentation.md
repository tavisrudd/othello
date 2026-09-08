# C1128: proposed first-reading presentation

Status: reviewable proposal only, 2026-09-08. No manuscript changes applied.
Mathematical justification and source audit:
`2026-09-08-c1128-comparison-rigidity-audit.md`.

## Decision proposed

Keep the original exponent count and cubic headline on the first reading.
Use the intrinsic scalar operation formulas already proved later in the
paper, and make their proof precede the motivic/spectral generalization.
Keep the prospective I_lat theorem separate until the author decides on
the audit and the additional Fano input is checked. Neither the genus-two
family nor a new quantum-matrix calculation is needed for these changes.

## 1. Replacement introduction paragraph

Replace the occurrence-dependent blowup paragraph, rather than adding a
second proof summary:

> We construct an integer-valued invariant from selected rank-two primary
> summands of the even quantum connection. It vanishes on smooth projective
> varieties of dimension at most two and satisfies
>
> \[
> I_{\mathrm{exp}}(\operatorname{Bl}_Z Y)
> =I_{\mathrm{exp}}(Y)+(c-1)I_{\mathrm{exp}}(Z),\qquad
> I_{\mathrm{exp}}(\mathbf P_Y(V))
> =\operatorname{rk}(V)I_{\mathrm{exp}}(Y),
> \]
>
> where c is the codimension of the smooth center Z. For a cubic threefold
> X its value is one, so its value on X times P1 is two. Its value on P4 is
> zero. Weak factorization between smooth projective fourfolds uses only
> nontrivial centers of dimension at most two. The blowup formula therefore
> makes the invariant unchanged along the factorization and rules out
> rationality of X times P1.

Retain the existing explanation that “generic” means quantum parameters,
not a generic cubic in moduli. Retain the existing attribution paragraph and
the distinction between the uniform lower bound and sharp examples. Keep a
single sentence explaining the dimension-five limit after the contradiction.

## 2. Section 2 order

Proposed sequence:

1. Define the numerical reduced coefficients, even QDM, and whole primary
   connection summands. Keep the normalized spectral-splitting proposition.
2. Give the rank-two model, pairing-induced elementary modification,
   persistence statement, and regularity/Lax statement. Define I_exp.
3. Establish the common comparison proposition: exact coefficient table,
   faithful-center proof, canonical-lattice transport, and independent-unit
   separation of summands. State the intrinsic scalar operation formulas here.
4. Prove low-dimensional vanishing, carry out the cubic computation, and
   finish with the projective endpoint and weak-factorization contradiction.
   Cubic computation and vanishing may be interchanged if page flow improves.
5. Put the free-monoid formulation and general additive criterion in a short
   subsection leading into the existing additive/spectral section. The two
   formal diagrams are redundant once these scalar formulas are explicit;
   remove them or retain only one if it serves a separate generalization.

This changes exposition, not logical dependencies. In particular, the
intrinsic scalar formulas depend on faithful maps, regular lattice transport,
and generic separation. They do not need the later fixed-complex-target
lemma or Grothendieck-group construction. The current proof of
`prop:intrinsic-spectrum-formulas` already contains the scalar argument.
Extract that argument before moving its statement; do not leave an overview
that silently invokes an unproved stronger formula.

Preserve stable labels and formal terminal names where their statements are
unchanged. Any changed or split annotated statement requires the separate
annotation/provenance workflow at implementation time. C978 and C910 retain
their existing coverage and review obligations.

## 3. Table and toy model before faithful-center base change

Suggested orientation paragraph:

> The untagged map on Novikov monomials can identify different curve classes.
> The reduced coefficient ring retains each monomial together with its
> divisor exponential, while the comparison target has independent divisor
> coordinates. The distinction is modeled by x,y mapping to q, compared with
> x mapping to q exp(s) and y mapping to q exp(t). The coefficients in the
> source do not involve the new target variables s,t. This is what makes the
> exponential characters distinguish classes in a collision fibre.

| Object | Required convention |
|---|---|
| Intrinsic source | Numerical, even, divisor-equation-reduced graded ring; unit polynomial; divisor coordinates absorbed in X_d. |
| Common target | Independent ambient and center-copy bulk coordinates, with every center divisor direction retained. |
| Scalar extensions | Specified exceptional/fibre q inversion and q ramification; z-free fraction fields followed by algebraic closure. |
| z-lattices | The graded completed z-enhancements embed in the common field's formal power series ring; both comparison and inverse are regular there. |
| Derivations | Bulk partials, numerical Novikov logarithmic derivations, and the actual z-connection with the displayed chain-rule terms. |
| Centering and grading | Center scalar Euler exponentials consistently; homogeneous degrees do not permit separate residue eigenline shifts. |
| Generic blocks | Whole primary summands formed after algebraic closure; independent unit shifts keep different comparison copies disjoint. |

The table should include the explicit R_Z, A_c, and iota_j formulas from the
audit beside it. It must not replace those definitions with prose alone.
Use “graded completed z-enhancement” rather than an ambiguous ordinary
“C[z]-extension.”

## 4. Two separately named local statements

**Persistence of a cyclic double-primary cluster.**
Over a characteristic-zero formal bulk germ, a separated rank-two cluster
whose centered leading operator is a nonzero rank-one nilpotent at the
closed point remains cyclic and nonzero square-zero throughout the germ.
The hypotheses include the flat QDM base equations with at most a simple
z-pole. Prove cyclicity before replacing its commutant by O I + O N;
then display the homogeneous differential equation for N squared.

**Regularity and conjugacy of the modified residue.**
For that rank-two block with its nondegenerate horizontal pairing, the
canonical modification is regular singular in z and regular in the base
directions. Its residue satisfies the Lax equation. A regular lattice
comparison with regular inverse carries the canonical modification to the
corresponding one and conjugates the residue.

Retain the existing separate pairing lemma. The second proof should point
to the diagonal entries ±nu*k that kill the base pole; this shows immediately
that nonresonance has not entered. The first statement is not currently
proved by the Lean terminals attached to the second, so their coverage
descriptions must remain separate at implementation time.

## 5. Replace the ambiguous separation sentence

> The condition delta-sharp not equal to zero says that the two eigenvalues
> of the canonical modified residue are distinct. The condition that
> delta-sharp is not an integer square says that their classes modulo the
> integers are distinct. We use the latter condition for I_exp. The former
> defines a different count whose transport requires preservation of the
> canonical modified lattice.

This accurately distinguishes two quantities. It does not silently assert
that every discriminant is determined by exponent classes, and it does not
describe a resonant block as an error in a separately defined lattice count.

## Acceptance if the author adopts this proposal

- The scalar proof can be read through the contradiction without the monoid
  notation, motivic extension, or proposed new Fano families.
- Source maps, completions, derivations, inverse regularity, and the two
  rank-two steps remain fully auditable in the main mathematical text.
- Every moved or split statement preserves its hypotheses and provenance;
  applicable source/annotation and PDF checks pass after implementation.
- No new theorem, title change, or claim of stronger formal coverage is
  introduced by an editorial move alone.
