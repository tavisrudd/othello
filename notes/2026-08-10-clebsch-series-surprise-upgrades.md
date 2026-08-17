# Clebsch series — surprise upgrades and applications

**Date:** 2026-08-10  
**Status:** successor prospects; none is licensed for the numbered papers
without its stated proof and literature gates  
**Author priority:** 1, then 6

## Proposed series punchline

> Sparse shadows recover the hidden carrier and expose the symmetry of what
> they forget.

This is stronger than saying that coarse data retain structure.  Paper IV has
zero residual ambiguity: weighted pair data recover the marked plane and
polarity.  In the upper companion branch, the residual ambiguity is exactly
the outer \(C_2\): the conference package recovers the unordered chordal pair,
and one marked chordal line removes precisely that obstruction.

## Ranked upgrades

### 1. Reconstruction thresholds and residual symmetry

Organize the five papers as a theorem about minimal sufficient invariants:

- quadratic data recover a carrier or unordered sheets;
- cubic data recover orientation;
- weighted pair data can recover an entire marked plane;
- any remaining ambiguity is an explicit automorphism torsor.

The target is not a slogan but a reconstruction-profile theorem.  For every
passage, specify the source groupoid, shadow functor, exact reconstructed
output, fibre, residual symmetry group, and a sharpness witness showing why
weaker data cannot choose more.  The upper branch should exhibit a genuine
\(C_2\)-torsor.  Paper IV should exhibit a trivial **structural** fibre after
passing to the declared isomorphism groupoid; an unavoidable
\(\operatorname{PGL}_2(13)\)-torsor remains if one insists on a coordinate
normalization of the reconstructed conic.

**Unexpected application.**  This gives a design principle for inverse
problems: determine not only whether an invariant reconstructs its source,
but its exact fibre.  The fibre identifies both the minimal extra measurement
and the mathematical reason no weaker measurement can work.

**Gates.**

1. Audit the theorem statements of Papers I--V without importing reviewer
   dossiers.
2. Separate proved minimality from mere sufficiency at every level.
3. Prove that all proposed fibres and torsor actions are intrinsic and
   functorial under the declared equivalences.
4. Produce one compact reconstruction-profile table and one theorem whose
   hypotheses genuinely cover every included row.
5. Run a literature audit for reconstruction degree, separating invariants,
   and residual automorphism torsors before claiming a general principle.

### 2. The full \(A_5\)-invariant cubic pencil

Classify every singular member of the invariant pencil, its stabilizer,
singular scheme, arithmetic splitting type, and reconstruction power.  This
would turn “the carrier stands fixed while their shadows move” into a literal
family theorem.

**Unexpected application.**  A discriminant and monodromy description would
give a canonical recognition algorithm for marked icosahedral cubics across
fields and reductions.

**Gates.**  Compute the pencil discriminant scheme, prove the classification
over a declared base, identify every bad characteristic, and audit the
classical invariant-pencil literature.

### 3. The tame icosahedral tower

Promote the extension-field prospect to the quotient theorem
\[
 R\longrightarrow R/A_5
\]
with inertia signature \((2,3,5)\), disjoint strata of degrees \(30,20,12\),
and free complement.  Frobenius split types then give every finite-extension
orbit count and the zeta function.

**Unexpected application.**  The result supplies exact orbit enumerators and
descent characters for icosahedral actions over finite fields, rather than a
single characteristic-eleven census.

**Gates.**  Complete the classical priority audit, print the scheme-level
tame stabilizer proof, and extend the certificate to record quadratic
Frobenius and an odd-extension check.

### 4. Weighted two-sections as complete invariants

Generalize Paper IV's theorem that weighted pair concurrences of minimum
supports reconstruct the code, association scheme, plane, conic, and
polarity.

**Unexpected application.**  High-arity incidence structures could admit
complete edge-coloured-graph fingerprints, giving canonical labeling and
isomorphism tests without triple data.

**Gates.**  Determine whether the phenomenon persists for other odd \(q\) or
other code families; distinguish a uniform theorem from an isolated
\(q=13\) rigidity accident; audit reconstruction from graph sections and
designs.

### 5. Hidden operator fields from binary shadows

Generalize Paper IV's recovery of the \(\mathbf F_8\) operator field from
binary pair data.  The target would characterize when low-order codeword
statistics recover the commutant field and extension-field linearity of a
binary module.

**Unexpected application.**  This could provide structural tests for code
equivalence, hidden scalar multiplication, and field-reduced modules using
only combinatorial statistics.

**Gates.**  Isolate hypotheses on the association algebra and module,
separate irreducibility from explicit field marking, and test non-Clebsch
examples before formulating a general theorem.

### 6. Reconstruction into the existing \(E_6\)-and-beyond tower

This is not a blank-slate proposal.  The program already contains exact work
on a tower through \(E_6\) and beyond:

- C870 proves the rank-generic root-link antipodal fold for plus-type quadric
  codes; the \(E_6,E_7,E_8,E_{10}\) objects are its small exceptional levels,
  while the structure map is uniform in rank;
- C865 constructs the affine-\(E_9\) level code and its exact fold through
  \(E_8,E_7,E_6\), including the Plotkin-sum boundary where unrestricted
  optimality first fails;
- C705 constructs an affine-\(E_8\) operator parent for the Segre--Igusa
  shadow sisters and isolates the still-open strict marked comparison with a
  genuine Lie-\(E_8\) ambient model.

Existing bundles: notes/2026-08-05-c870-fold-tower-judo.md,
notes/2026-08-05-c865-e9-affine-level-code.md, and
notes/2026-07-30-c705-common-e8-parent.md.

The possible new move is therefore priority judo, not a claim that the
exceptional tower itself is new.  Classical work and the existing program
supply the levels.  The new question is whether a sparse Clebsch shadow
canonically reconstructs the correct marked entry object, places it inside
the tower, and determines the structure maps and their exact fibres.

At the \(E_6\) level, prove that the oriented six-axis golden carrier
canonically determines the \(27\)-dimensional minuscule geometry and Cartan
cubic, and that the grading reconstructs the original carrier:
\[
 \text{sparse code or incidence data}
 \longrightarrow
 \text{oriented six-axis carrier}
 \longrightarrow
 \text{graded }6|15|6\text{ Cartan cubic}
 \longrightarrow
 \text{carrier recovered}.
\]

Then ask how that reconstructed entry propagates through the already proved
fold tower and affine/operator parents.  This is the second author priority,
but it follows upgrade 1: the reconstruction-profile theorem must first state
exactly which marked carrier and residual symmetry the tower consumes, and
what information each upward or downward structure map forgets.

**Unexpected application.**  It would give an elementary entrance into
\(E_6\), the \(27\) lines, and the \(45\) tritangents from a six-by-six sign
operator reconstructed from sparse coding or incidence data.  More strongly,
it could turn a classical list of exceptional levels into a navigable
reconstruction tower whose maps have measured information defect.

**Gates.**

1. Reconcile the C705, C865, and C870 interfaces: objects, markings, fold
   maps, and coefficient bases must agree exactly.
2. Construct the graded Cartan tensor from the marked carrier with exact
   coefficients.
3. Prove tensor equality with the classical \(E_6\) Cartan cubic, not merely
   matching support or orbit counts.
4. Prove canonical uniqueness under the declared marking group.
5. Recover the six-axis carrier and its orientation from the graded cubic.
6. Compute the exact fibre or residual symmetry of every tower map used;
   do not call a noninvertible fold a round trip.
7. Audit both the classical \(27\)-line/double-six/Jordan/minuscule/Cartan
   literature and the general two-weight-family fold literature.  The
   defensible new spin is the sparse-input recognition, functorial structure
   maps, and reverse recovery—not the classical exceptional objects.
8. Keep quantum, lattice, anomaly, doily, and matrix-factorization
   consequences out until each is separately proved and cited.

## Execution order

1. Prove or sharply delimit the reconstruction-profile theorem.
2. Use its exact carrier interface as the input specification for the
   \(E_6\) closure problem.
3. Treat upgrades 2--5 as independent successor opportunities; the tame
   tower is the cheapest near-term theorem, while weighted two-sections and
   hidden-field recovery have the clearest algorithmic applications.
