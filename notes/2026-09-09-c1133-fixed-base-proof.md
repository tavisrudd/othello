# C1133 — fixed-base transport and proof obligations

**Date:** 2026-09-09. **Lane:** `cubic-threefolds`.
**Status:** written audit proof of the fixed-base adaptation; the complete
geometric and literature acceptance gates remain open.

The packet's comparison section at standalone revision `b156ec6` is byte-identical
to the current authority's `sections/02-qdm-marker.tex`. Its SHA-256 is
`ef2bd45dfcb1a679270c2432b4c8696724539bef7ca88c8c9166632f6d457fd2`.
Thus this audit addresses the current coefficient argument, not a superseded
manuscript. No manuscript edits are made here.

## Fixed-base faithfulness

Fix a smooth connected center Z in a smooth projective Y and one occurrence j.
Let G be a common reductive quotient of the universal Hodge group acting on the
cohomology of the blowup, ambient variety and center, in the Tate-periodized
convention. The following argument proves the fixed-base version of the
baseline coefficient lemma using its same numerical and graded completions.

Write V_Z^G for the invariant cohomology. It is purely even. Choose its unit,
degree-two, and higher-degree summands separately. Take numerical curve classes
in the effective integral numerical lattice and retain the combined variables
X_d = Q_Z^d exp(sigma^(2) . d). There are no independent source divisor variables.
The other fixed bulk variables, denoted u, have strictly negative grading;
the unit variable v is polynomial as in the reduced source. Work in

    R_Z^G = C[[X_d, u]]_gr[v].

This is the reduced ring constructed directly on the fixed base. We are not
deducing injection by quotienting a previously injective homomorphism.

The initial shifts tau^circ and varsigma_j^circ in Iritani's reconstruction are
G-fixed. The combined coordinate change and its inverse are equivariant. Hence
they restrict to inverse changes of coordinates on the fixed loci. In the
external direct sum, the coordinates t and all s_j range independently over
the corresponding fixed vector spaces. The fixed tangent Jacobian is invertible:
the inverse of an equivariant linear isomorphism restricts to its invariant
subspaces. In particular, no fixed unit or divisor direction is lost.

The occurrence map on reduced generators is

    X_d -> Q^(i_* d) q_exc^(-rho_Z . d/(c-1))
           exp((varsigma_j^circ,(2) + s_j^(2)) . d),

with the fixed higher-degree and unit variables translated by the corresponding
fixed initial shifts. Its existence and continuity use the same reduced-ring
String/Divisor equations as the baseline. The group fixes the numerical Novikov
and ramification parameters; there is no new noninjective specialization here.

To prove injection, filter numerical effective classes by the degree of the
restriction of an ample divisor from Y. Every bounded slice is finite. For a
fixed class d, a source coefficient is a polynomial in u and v: the source has
only finitely many total graded degrees and bounded unit degree, while every
coordinate in u has strictly negative degree. Consequently translating these
coefficients by fixed constants is injective, even if those constants lie in
the external Laurent coefficient field.

If a nonzero source element were killed, take its least nonzero ample degree
and group that finite part by the untagged target monomials. The target divisor
variables occur only in the exponentials, not in their coefficients. Integral
algebraic divisors D_k separating numerical curve classes are G-fixed, so their
independent coordinates x_k survive on the fixed target. A nonzero group would
give a relation

    sum_d a_d exp(sum_k (D_k . d) x_k) = 0,

with distinct exponent vectors and coefficients independent of the x_k.
Choose an integral one-parameter direction separating this finite set of
vectors. Derivatives of orders zero through one less than the number of terms
give an invertible Vandermonde matrix. All a_d would vanish, a contradiction.
This proves injection and hence the corresponding fraction-field embedding.

The argument is unchanged for a disconnected center after treating its
components as separate occurrences. It does not assert equality of generic
primary decompositions on the full even base and the fixed base.

## What equivariance supplies, and what must still be matched

Iritani's Hodge refinement, Proposition 8, supplies equivariance of the full
blowup maps; its Lemma 10 supplies fixed initial shifts. The central Hodge-group
element acting by cohomological parity then gives parity preservation after
odd bulk variables are set to zero. The fibers remain full cohomology fibers.
The same parity conclusion in the projective-bundle construction is compatible
with its algebraic pull/push, characteristic-class and reconstruction operations.
It should be written explicitly when integrating the full-super statement.

The source comparison theorems give isomorphisms over graded z-polynomial
completed rings, and Iritani–Koto Remark 5.3 spells out their coefficientwise
embedding in a power-series ring in z. This supports preservation of the
original z-lattices, with regular inverse. A degree assigned to a ramified
Novikov scalar is not permission to shift individual z-eigenlines.

On each separated even rank-two block, a regular comparison transports both
the leading nilpotent N and its line im(N). It therefore carries the lattice
of sections whose reduction lies in im(N) to the corresponding lattice. In
modified frames the comparison and inverse are regular, so their constant
terms conjugate modified residues. No nonresonance is needed. This explains
why the resonant delta = 1 calculations are relevant, provided the precise
source-to-target coefficient identification has been retained throughout.

For the Hodge construction, keep the full even rank of a primary factor and
apply the numerical selector before taking its odd G-representation. On a
connected fixed-base germ, an equivariant idempotent has locally constant ranks
on multiplicity spaces of irreducible representations. These ranks are constant
on that germ. This is continuation of a separated projector, not transport
through a locus of merging eigenvalues.

Independent fixed unit coordinates shift distinct occurrence spectra by
independent scalars. Their characteristic-polynomial resultant is nonzero as
a polynomial in the shift difference. Thus these occurrences remain distinct
at the generic comparison point. Together with the fixed-base injection above,
this gives the needed mechanism for the fixed-base operation formulas.

The remaining audit work is to finish the source-level comparison across both
operations, all numerical Fano inputs and all-member deformation statements,
and the novelty/forward-citation coverage. The paper-facing theorem must include
the exact ring conventions above; this note is not a claim that the packet's
placeholder Proposition 24.1 has already been integrated or independently
refereed in a manuscript.

## Downstream cancellation checks

On each proposed detected Picard-rank-one Fano endpoint, full even cohomology
is Tate and odd cohomology is H^3. The even-rank-one Frobenius lemma puts all
odd cohomology in the unique repeated primary factor. The proposed safe Hodge
selector therefore recovers the periodized class of H^3 at that endpoint.

If the operation and vanishing formulas hold, one-stable birationality gives
2[H^3(X)] = 2[H^3(Y)]. The semisimple representation Grothendieck group has no
torsion, so the classes cancel. Pure weight three removes nonzero Tate shifts
between constituents. Scalar-extension descent follows because the determinant
on the rational space of equivariant homomorphisms is a polynomial: if it is
nonzero after extension, it is nonzero at a rational point over the infinite
field Q. Thus the desired conclusion is a rational Hodge isomorphism, without
a specified principal polarization or integral lattice.

Voisin's introductory formulation, Theorem 0.2 and Remarks 0.1/0.3, explicitly
have the rational, unpolarized, very-general-source/arbitrary-smooth-target
quantifiers used for cubic and quartic hypersurfaces in P^4. Orr's corrected v4
Theorem 5.1 explicitly allows a finitely generated characteristic-zero ground
field and a target over a bounded-degree extension. Achter's Theorem B supplies
the arithmetic intermediate-Jacobian construction. These source statements
support the proposed deductions once Hodge conservation has passed its gate.
Original principal-polarization finiteness still needs a primary-text check;
the packet currently points to a secondary recollection.

Read-depth, pinned versions, cache hashes and exact consulted sections are
recorded in `2026-09-09-c1133-literature-sources.json` and the literature report.

## Mystery ledger

- Fixed-base injection is settled by reconstructing the reduced map on that
  base, not by assuming injections survive restriction.
- Resonant residue transport requires the original lattice; the local algebra
  and source regularity support it. Final integration must preserve that data.
- No equality of the full-even and fixed-base invariants for arbitrary varieties
  is needed. The endpoint equality follows from Tate even cohomology.
- The all-member Fano input, remaining source scope and priority coverage remain
  C1133 gates. The new framing-source counterexample is handled in its own report.
