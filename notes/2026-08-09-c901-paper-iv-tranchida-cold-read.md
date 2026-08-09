# C901 Paper IV round-1 Tranchida cold read

## Evidence boundary and scope

I read this as a group/incidence-geometry referee, beginning with the unlabeled
group recovered from the minimum-word geometry.  The frozen manuscript was

- `papers/q13-passant-code/passant_code_q13.pdf`, SHA-256
  `715fdb6500c34386f92f61ba6fd328da8fd95a60e657c644e9e5a097e0b73fce`;
- textual authority (PDF extraction was unavailable):
  `papers/q13-passant-code/passant_code_q13.tex`, SHA-256
  `12e19dd0c2f4a83e25f2a023ebd23b35bdb8415649cbac993853a0488a2ec033`.

I reviewed only the automorphism argument in “The hidden field, spanning, and
automorphisms” and “Recovery of the ambient conic plane.”  The assigned
comparison source was Philippe Tranchida, *Triples of involutions in
PGL(2,q) and their incidence geometries*, Sections 2.1, 2.2, and 3 through
Proposition 3.2, cached as `arXiv:2411.10299`, SHA-256
`3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.
I did not inspect the handoff, prior reviews, verification source, or excluded
C-task material.

## Strongest theorem supported in this scope

Subject to the stated finite matrix identities and rank/profile calculations,
the manuscript proves that the coordinate-permutation automorphism group of
the minimum-word geometry is \(\PGL(2,13)\), and that this unlabeled group,
through its Sylow-\(13\) subgroups and involutions, intrinsically defines a
conic-polarized incidence structure isomorphic to \(\PG(2,13)\).  The original
78 coordinates are recovered equivariantly as the involution class with
centralizer order 28, hence as the internal points, and the original matrix is
the internal--internal polarity block.

Here “intrinsically” is justified at the level of the construction: the sets
\(\Omega=\operatorname{Syl}_{13}(G)\), \(\mathcal I\), the three incidence
predicates, and the centralizer-order class involve no coordinate choice.  A
chosen standard representation is used to prove what that already-defined
object is.

## Causal proof spine

1. The six pair relations give adjacency operators.  The displayed mod-2
   identities make \(B=A_9\) invertible on the binary code \(K\), and the
   rank calculation for \(B+I\) forces the irreducible cubic
   \(B^3+B^2+I=0\).  Thus \(K\) acquires an operator-field structure
   \(K\cong\mathbb F_8^{12}\).
2. For each minimum-word orbit, the asserted identity
   \(N_i^{\mathsf T}N_i\in\{A_9,A_{10},A_{12}\}\) is multiplication by a
   nonzero element of that field.  Hence every orbit spans \(K\), so the whole
   minimum-word geometry spans \(K\).
3. An explicit ordered triple of relation type \((10,3,9)\) has trivial
   stabilizer in the exhibited \(\PGL(2,13)\).  Its orbit has size 2184, equal
   to the number of all such ordered triples.  A uniquely characterized fourth
   anchor, followed by injectivity of four relation signatures on all 78
   points, shows that every scheme automorphism lies in this
   \(\PGL(2,13)\).  Spanning then identifies the automorphism groups of the
   code and of the minimum-word geometry.
4. Starting afresh from the resulting unlabeled group \(G\), its 14
   Sylow-13 subgroups form \(\Omega\), and its 169 involutions form
   \(\mathcal I\).  The manuscript defines 183 point labels and 183 polar-line
   labels by \(\Pi=\Omega\sqcup\mathcal I\), with incidence detected by
   equality on \(\Omega\), normalization between the two types, and the
   involutory-product test on distinct involutions.
5. Transport through the standard adjoint representation identifies
   \(\Omega\) with the nilpotent conic in
   \(\mathbf P(\mathfrak{sl}_2(\mathbb F_{13}))\), \(\mathcal I\) with the
   nonsingular traceless lines, and all three predicates with orthogonality for
   \(\operatorname{tr}(AB)\).  This proves that the intrinsic incidence
   structure is the conic-polarized projective plane.
6. A coordinate stabilizer is a nonsplit-torus normalizer \(D_{28}\).  Its
   central involution has centralizer of order 28; equality of the relevant
   orbit sizes gives the equivariant identification of the 78 coordinates with
   that involution class.  Tranchida's center/axis dictionary then agrees with
   the manuscript's internal-point/polar-line interpretation, but it is used
   only after the plane has been reconstructed.

## Chosen standard representations: audit

| Use | What is chosen | What it establishes |
|---|---|---|
| Anchor rigidity | Four coordinates in the standard 78-point conic model and the symmetric-square \(\PGL(2,13)\)-action | A verification in one labeled model.  Because the relations are already defined and the exhibited group acts on them, orbit transport proves the intrinsic upper bound on the scheme automorphism group. |
| Sylow action | The usual action of \(\PGL(2,13)\) on \(\mathbf P^1(\mathbb F_{13})\) | A standard-model verification that conjugation on the intrinsically defined set \(\Omega\) is sharply three-transitive.  An abstract isomorphism transfers the property; it does not label \(\Omega\) canonically. |
| Plane identification | \(\mathbf P(\mathfrak{sl}_2(\mathbb F_{13}))\), determinant conic, and trace form | A one-model verification of all three incidence cases.  Since \(\Pi\) and the predicates were defined before the choice, this is enough to prove intrinsic recovery of an abstract marked plane, not a preferred coordinate frame. |
| Original coordinates | The standard classification of internal-point stabilizers as nonsplit-torus normalizers \(D_{28}\) | A model verification of the stabilizer type.  The resulting map is intrinsic only after one observes that the unique central involution has centralizer exactly the same \(D_{28}\), so the equivariant map between the two 78-element orbits is bijective. |

For the three incidence cases themselves: two nilpotent conic lines are trace
orthogonal exactly when equal; a nilpotent line is orthogonal to a nonsingular
traceless line exactly when the corresponding involution normalizes its
Sylow-13 subgroup; and, for two distinct nonsingular traceless lines,
\(\operatorname{tr}(AB)=0\) exactly when the projective product is an
involution.  These checks are consistent with Tranchida's distinction between
center, axis, polar, and pole.

## Earliest unsupported implication

The earliest implication I cannot independently justify from the scoped text
is the displayed mod-2 Bose--Mesner multiplication table, beginning with
\(A_0^2=I+A_9+A_{10}+A_{12}\).  It is described as a reduction of integral
intersection numbers, and transitivity explains how a representative check
would propagate, but neither the relevant intersection numbers nor the six
representative calculations are shown here.  The subsequent injectivity of
\(B\) on \(K\), the operator field, orbit spanning, and therefore the final
identification of the two automorphism groups all depend causally on this
input.

For the exact finite steps in this scope, the mathematical domains are in
principle complete: 78 internal points for the adjacency and anchor checks,
the four 91-by-78 orbit support matrices, and all ordered triples of the given
relation pattern.  The anchor step states its orbit quotient, counts,
uniqueness criterion, and local-to-global transport adequately.  By contrast,
the multiplication-table, rank, and \(N_i^{\mathsf T}N_i\) steps state their
outputs but do not display the representative data, elimination witness, or
entrywise counting that supplies the rejection criterion.  Deduplication is
not a substantive issue for these fixed matrices, but the audit trail in the
scoped proof is too compressed to repeat the calculations from the prose
alone.

## Ranked findings

1. **Unexplained computation (effect: automorphism theorem).**  The mod-2
   multiplication identities are the first load-bearing unproved input, and
   the rank of \(B+I\) and the four support-matrix products are likewise
   reported as outputs.  Add a compact intersection-number table or explicit
   representative-count lemma, plus an elimination/certificate pointer at the
   exact claims.
2. **Convention mismatch (effect: literal plane definition).**  Mixed
   incidence is written only as \(U\in j^\perp\).  Since points and polar lines
   are separately indexed by \(\Pi\), the reverse ordered incidence
   \(j\in U^\perp\) must also be declared, or the text must say that (ii) defines
   both by polarity reciprocity.  The trace form proves symmetry, but the
   current literal definition omits half of the mixed block.
3. **Proof compression (effect: intrinsic-recovery claim).**  The adjoint-model
   argument is valid transport, but the manuscript should introduce an
   arbitrary isomorphism \(G\to\PGL(2,13)\), define the two bijections to
   nilpotent and nonsingular lines, and conclude explicitly that the
   choice-free predicates are thereby identified with trace orthogonality.
   This would prevent a reader from mistaking verification in a preferred
   model for the construction itself.
4. **Proof compression (effect: recovery of the 78 coordinates).**  State that
   the unique central involution of a coordinate stabilizer \(D_{28}\) has
   centralizer containing that stabilizer and of order 28, hence equal to it;
   the resulting equivariant map between two transitive 78-element sets is a
   bijection.  The current conclusion is correct but skips this intrinsic
   bridge.

## Verdict

**MINOR.**  I find no structural defect in the abstract group-to-plane
reconstruction: the standard adjoint model legitimately verifies the
choice-free incidence object, and the three group predicates have the claimed
geometric meanings.  The necessary revisions are a literal repair of mixed
incidence, explicit transport/canonicity sentences, the short centralizer
argument for the 78 coordinates, and a more inspectable presentation of the
finite inputs supporting the automorphism proof.

## Novelty relative to the packet

Relative to Tranchida's packet, which begins with a conic already embedded in
\(\PG(2,q)\), the genuine new point is that Paper IV starts from the unlabeled
recovered group and defines the conic points, all remaining plane points, the
polarity incidences, and the original 78 internal coordinates by intrinsic
Sylow, involution, normalization, product, and centralizer data.
