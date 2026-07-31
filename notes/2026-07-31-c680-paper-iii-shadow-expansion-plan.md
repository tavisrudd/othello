# C680 — Paper III shadow expansion plan

**Date:** 2026-07-31

**Lane:** `clebsch`

## Decision and boundary

Paper III is reopened for a substantial revision.  The new center is the
operator theorem anticipated by the existing conclusion: the Clebsch
orientation cubic is one invariant appearing as several exact shadows of the
same golden conference operator.

The revision owns the immediate shadow diagram:

- the middle-exterior diagonal cubic;
- the commutator Pfaffian and determinant;
- the determinant of the cross-golden block;
- the six outer conjugates on the Segre cubic and their centered-square Igusa
  polar coordinates;
- the literal Cartan-cubic restriction; and
- the comparison with Hitchin's restricted branch sextic and the existing
  degree-six harmonic realization.

The broader sister program is out of scope.  Small resolutions, Ulrich/MCM
sheaves, Coble and Burkhardt geometry, Pauli/Clifford refinements, Majorana
Hamiltonians, quantum measurements, code/lattice models, and tetrahedral or
octahedral analogues may be named in one restrained future-work paragraph but
will not contribute theorems, proofs, computations, or terminology to this
revision.  The full (27)-line and Hodge-comparison packages likewise remain
outside except for the standard Cartan formula needed to state the immediate
restriction.

## Proposed headline theorem arc

Let (C) be the oriented order-six conference operator recovered from the
golden six-axis configuration, so (C^2=5I), and put

\[
 K=*\Lambda^3C,\qquad
 Z_C(x)=\frac14\sum_{|S|=3}K_{SS}x_S,\qquad
 D_x=\operatorname{diag}(x).
\]

The expanded paper should have three main theorems.

1. **Arithmetic cover.**  Retain the current result that Hitchin's incidence
   field is \(\mathbf Q(\mathbf P(H))(\sqrt{5J_0})\), with complete reduced
   fibre \(\mathbf Q(\sqrt5)\) over \([xyz]\).
2. **Operator-shadow theorem.**  Prove, with normalization visible,
   \[
   \operatorname{Pf}[D_x,C]=4Z_C(x),\qquad
   \det[D_x,C]=16Z_C(x)^2.
   \]
   Over \(\mathbf Q(\sqrt5)\), if
   \(B_x=P_-D_xP_+:V_+\to V_-\), prove
   \[
   Z_C(x)=\pm10\sqrt5\det B_x.
   \]
   On the Clebsch chart this gives
   \(J_0=16Z_C^2=\det[D_x,C]\).  The same Pfaffian is the restriction of
   Cartan's cubic along
   \(x\mapsto(0,0,(C_{ij}(x_i-x_j)))\).
3. **Outer and harmonic shadows.**  For the six oriented outer conjugates
   \(C_T\), prove that \((Z_T)_T\) satisfies the Segre equations and that
   \(W_T=Z_T^2-\frac16\sum_UZ_U^2\) is the Segre--Igusa polar map.  State the
   five-syntheme comparison with its exact scalar.  Retain the degree-six
   spherical-harmonic theorem as an independent realization of the same
   normalized cubic line.

The abstract and introduction should lead with the operator-shadow theorem.
The arithmetic cover explains the golden descent, while the harmonic theorem
shows that the same cubic line also occurs in a geometrically independent
representation.  The conclusion should no longer promise the shadow
mechanism: it should summarize the proved diagram and end at the exact
boundary sentence ``The cubic that stood fixed is therefore itself a shadow,
one among several cast by the same golden return.''  It may point beyond that
sentence without developing the sister theories.

## Preliminary novelty disposition

The current evidence separates the classical layer cleanly from the likely new
operator layer.

Classical or already published:

- Hitchin's incidence cover, Clebsch chart, branch sextic, and restriction
  \(J_0=16\sigma_3^2\);
- the signed outer Joubert coordinates, their Segre equations, and the
  centered-square Segre--Igusa polar map;
- the Cartan cubic in the
  \((A\otimes U^\vee)\oplus\Lambda^2U\) model; and
- existence of Pfaffian representations for cubic threefolds in general.

Candidate paper-owned contribution:

- recovery of the signed cubic from
  \(\frac14\operatorname{diag}(*\Lambda^3C)\);
- the functorial outer-six lift from the golden conference operator;
- the exact commutator identities
  \(\operatorname{Pf}[D_x,C]=4Z_C\) and
  \(\det[D_x,C]=16Z_C^2\);
- the cross-golden determinant formula and its compatibility with golden
  conjugation; and
- the single commuting diagram identifying the restricted Hitchin sextic,
  Cartan restriction, Segre coordinates, Igusa polar coordinates, and the
  syntheme cubic as shadows of that operator.

This is a **provisional novelty boundary, not yet a priority claim**.  C704's
audit read one modern primary source in full and four partially; it treated the
Joubert and Coble originals through secondary sources.  The present review also
read the introduction and relevant theorem context of Gaia Comaschi,
*Pfaffian representations of cubic threefolds*, arXiv:2005.06593v1, at
`partial` depth from cache key `arXiv:2005.06593`, SHA-256
`a2f7e8cb0cabf68a35dff4bdb4b431d557bf58efe1b66304fd81dab5e3968984`.
Comaschi proves general existence, not the distinguished conference
commutator formula.

Before manuscript novelty wording, run a dedicated formula-level audit for
conference-matrix Pfaffians, canonical Pfaffian representations of the
six-nodal cubic, operator constructions of Joubert coordinates, and Cartan
linear sections.  Record all queries, read depths, cache hashes, inaccessible
sources, and the exact negative stopping rule.  Until that audit closes, use
descriptive wording and make no first/unique/novel claim.

## Human-proof obligations

No admitted headline may rest on a certificate alone.  Write one proof
companion, later absorbed into the manuscript, with the following lemmas.

C711 owns the sub-700 inputs in items 1--2 together with the C682
return-to-conference and paired-descent interface that precedes item 3.  C712
is its Lean successor.  Human proofs and formalization for items 3--7 and other
C704/C709-and-later identities are separately owned and must not be duplicated
by C711/C712.

1. **Golden operator.**  Construct (C) from the signed golden Gram matrix;
   prove symmetry, switching covariance, (C^2=5I), and the effect of golden
   conjugation.
2. **Middle exterior.**  Prove (K^2=125I) from the Hodge complementary-minor
   identity and prove
   (K_{SS}=4C_{ij}C_{jk}C_{ki}).  Explain why the distinguished support
   lattice, not a bare rational conjugacy class, makes the diagonal intrinsic.
3. **Pfaffian shadow.**  Expand the Pfaffian by complementary triples and
   identify each squarefree coefficient with (K_{SS}).  This yields the
   commutator Pfaffian without polynomial interpolation.
4. **Cross-golden determinant.**  Block-decompose the commutator under
   (V_+\oplus V_-) and derive the determinant and normalization from the
   (3\times3) block formula.  Fix the determinant-line sign convention.
5. **Cartan restriction.**  Substitute the commutator skew form into the
   standard mixed-plus-Pfaffian Cartan formula and state exactly what is and is
   not being identified.
6. **Outer six.**  Construct the six conjugates and prove signed
   outer-(S_6) covariance.  Derive the Segre relations from the relevant
   invariant-line multiplicities plus one normalized evaluation, rather than
   from a 720-element checker.
7. **Polar and syntheme faces.**  Derive centered squaring as the projective
   differential of the Segre equation.  Prove the Igusa equation by a stated
   symmetric-polynomial identity.  Prove the five-syntheme comparison by
   equivariance and one exact scalar evaluation; the checker remains an audit.
8. **Paper bridges.**  Combine the existing Hitchin restriction
   (J_0=16\sigma_3^2) with (Z_C=\sigma_3), and state the harmonic result as
   a separate realization of that normalized cubic line.
9. **Boundaries.**  Keep the rational/integral comparison, bad-prime scope,
   sign/orientation choices, and absence of a global determinant-cover claim
   explicit.

The C709 human-proof companion already supplies a clean proof of the
commutator Pfaffian, determinant, covariance, and rank stratification.  C680
should reuse only the algebraic portions relevant to items 2--4, with the
Majorana interpretation omitted.

## Lean formalization plan

Formalization follows the human proofs and does not replace them.

1. **Finite conference algebra.**  Define the explicit integral (6\times6)
   conference matrix, triangle cubic, six-variable augmentation quotient, and
   explicit six-dimensional Pfaffian.  Prove (C^2=5I), the middle-exterior
   diagonal formula, and
   \(\operatorname{pf}_6[D_x,C]=4Z_C\) over a suitable commutative ring.
2. **Determinant and golden splitting.**  Prove
   \(\det[D_x,C]=\operatorname{pf}_6[D_x,C]^2\).  Over
   \(\mathbf Q(\sqrt5)\), define (P_\pm), the cross block (B_x), and prove
   the determinant scalar with its stated orientation convention.
3. **Outer-six polynomial package.**  Define the six conference conjugates and
   prove covariance, the two Segre relations, centered-square polar formula,
   Igusa equation, and five-syntheme scalar identity as polynomial identities.
4. **Cartan and Hitchin interfaces.**  Define the restricted Cartan cubic and
   prove it equals the same Pfaffian.  Add an interface theorem that combines
   the already paper-proved chart identity (J_0=16\sigma_3^2) with the
   formal operator identity; do not pretend to formalize Hitchin's global
   incidence theorem unless that geometry is actually developed.
5. **Trust report.**  Record theorem names, toolchain, axioms, admissions,
   native evaluation, generated data, and exact correspondence with manuscript
   statements.  The target gate is no `sorry`, no unreported axiom, and a
   paper-local replay that checks the pinned Lean artifact.

Use general ring proofs where they reveal the mechanism.  Generated finite
tables may fix the six outer conjugates, but their theorem statements must be
small, reviewable, and independently regenerated.  Lean work begins only after
the human lemma statements and normalizations are frozen.

## Execution order and gates

1. **Novelty gate:** complete the dedicated formula-level audit and settle the
   exact language licensed for the abstract and introduction.
2. **Human-proof gate:** write and cold-read the nine-lemma companion; every
   exact scalar must be derived in prose and independently checked.
3. **Theorem-architecture gate:** rewrite the abstract, introduction, theorem
   statements, and conclusion before expanding body sections.  A theorem-only
   read must expose one coherent arithmetic--operator--harmonic story.
4. **Lean gate:** formalize precisely the admitted operator theorem surface and
   add the claim-to-theorem trust map.
5. **Artifact gate:** update the exact-arithmetic bundle atomically with the
   report, generators, canonical certificates, hashes, and independent replay.
6. **Release gate:** run the ordinary and isolated paper replays, inspect the
   warning-free PDF, commission a fresh direct-access cold read, synchronize any
   release mirror if one is created, and only then return to immutable locator
   and author metadata.

The first work product is the novelty audit.  Manuscript edits wait until its
claim boundary and the human-proof lemma statements are stable.
