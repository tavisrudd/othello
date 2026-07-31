# C704 — Functorial operator shadows and Clebsch sisters

**Lane:** `clebsch`

**Opened:** 2026-07-30

**Status:** complete; positive Segre--Igusa and Cartan gates, bounded
later-slice obstruction, and positive tetrahedral/octahedral feasibility
gates.  Full report:
[`../2026-07-30-c704-functorial-operator-shadows.md`](../2026-07-30-c704-functorial-operator-shadows.md).

## Objective

Determine whether the functorial paired-\(E_8\) golden return has further
classical invariant-theoretic shadows, beginning with the Segre--Igusa
correspondence in which the Clebsch diagonal cubic is a distinguished
hyperplane section.  Separate exact operator consequences from analogy and
from classical identities already present in the literature.

## Primary gate: Segre--Igusa

1. Freeze C682's all-degree restriction-of-scalars operator
   \((\widehat\Delta,J)\), its degree-ten conference specialization, and the
   existing syntheme/Joubert coordinate maps.
2. Lift the Clebsch four-space calculation to the full \(S_6\) augmentation
   and syntheme carriers.
3. Compute the lowest determinant, polar, or golden-odd invariant naturally
   produced by the return and test whether it gives:
   - the Segre cubic;
   - its polar map to the Igusa quartic; or
   - C682's exact centered identity
     \(125W_T=4\,\operatorname{center}(\sigma_3(q_T))\).
4. Prove or disprove functorial compatibility intrinsically.  A coordinate
   match alone is not acceptance.
5. Audit the exact result against Joubert, Coble, Segre--Igusa duality, and
   the closest modern invariant-theoretic treatments before making any
   novelty or priority claim.

## Gated secondary branches

Open these only after the primary gate has a crisp positive or negative
verdict.

### Cartan cubic

Test whether C695/C697's explicit \(6|15|6\) minuscule carrier makes the
Clebsch cubic a literal restriction of the Cartan \(E_6\) cubic compatible
with the degree-ten golden return.  Distinguish the already known Cartan
tensor and 27-line configuration from any new commuting operator diagram.

### Later balanced slices

Run one bounded census of balanced paired-McKay degrees.  For each selected
slice, decompose the first determinant-pencil or golden-odd invariant,
record its singular scheme and symmetry, and stop at one representative of
each eventual degree pattern.  Do not launch an unbounded name-matching
sweep.

### Platonic sisters

Perform only a feasibility gate for binary tetrahedral/\(E_6\) and binary
octahedral/\(E_7\): identify the relevant character field, conjugate tower,
minimal transvectant, and first balanced slice.  Promote a full sister
classification only through a separately allocated task.

### Arithmetic fibres

Inventory, without automatically promoting, the geometric shadows of the
known defects at \(2,5,11,23\).  A special-fibre configuration must come
with its exact integral model and normalization boundary.

## Acceptance

A positive primary result requires:

- a coordinate-free commuting diagram from the golden return to the
  Segre--Igusa polar system;
- exact primary and independent replay artifacts;
- a proportional literature audit;
- an explicit statement of what is new beyond classical Segre--Igusa
  duality; and
- a paper-disposition recommendation that does not automatically reopen
  Papers I--III.

A negative result requires an exact obstruction identifying which map,
equivariance, degree, or polarization fails, followed by the bounded
adjacent-crown extraction required by the lane conventions.

## Closeout

The six outer conjugates of the degree-ten middle-exterior operator are
the signed Joubert coordinates.  They satisfy the Segre equations, and
centered squaring is exactly the Segre--Igusa polar map.  The
five-syntheme/Clebsch expression supplies the other face of a
coordinate-free commuting diagram.

The same conference operator gives the literal Cartan restriction
\[
\operatorname{Pf}\bigl(C_{ij}(x_i-x_j)\bigr)=4Z_T(x).
\]
Writing \(D_x=\operatorname{diag}(x)\), the skew matrix is
\([D_x,C]\), so
\[
\det[D_x,C]=16Z_T(x)^2.
\]
Thus the Segre coordinate, restricted Hitchin branch sextic, and Igusa
polar coordinate are Pfaffian, determinant, and centered-determinant
shadows of one return operator.  Over \(\mathbf Q(\sqrt5)\), the
cross-eigenspace block \(B_x=P_-D_xP_+\) satisfies
\[
Z_T=\pm10\sqrt5\det B_x.
\]
It and its scaled adjugate form a \(3\times3\) linear--quadratic matrix
factorization.  The right- and left-kernel incidences are the two
determinantal small resolutions of the six-node cubic, exchanged by
golden conjugation.
Later balanced \(E_8\) slices lack the degree-ten distinguished support
lattice; the bounded census through degree \(50\) therefore stops at an
exact functoriality obstruction.  Binary tetrahedral \(E_6\) and binary
octahedral \(E_7\) pass feasibility through their first exact conjugate
transvectant separators, but no sister classification is promoted.

## Boundaries

- C704 is an exploration, not a release gate and not a license to enlarge
  Paper III.
- The fixed multiplicity-free
  \(\mathbf3\oplus\mathbf3'\) degree-ten slice cannot yield a genuinely new
  equivariant return outside \(\langle I,C\rangle\); new sisters must use a
  nonlinear shadow, another balanced slice, or another group.
- Do not conflate binary-polyhedral affine \(E_6,E_7,E_8\) McKay types with
  exceptional Lie-group invariant forms without an explicit construction.
- Do not claim a single torsor functor across the trilogy unless Paper II's
  matching-sheet involution is included in a proved commuting diagram.
