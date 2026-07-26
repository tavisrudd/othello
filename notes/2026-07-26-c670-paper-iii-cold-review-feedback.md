# C670 Paper III cold-review feedback

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Paper:** `papers/clebsch-passages/`

## Verdict

Four independent read-only reviews converged on `NO-GO` or major revision
for the manuscript under its present three-way-bridge thesis.  Two readers
were directed respectively toward arithmetic and harmonic structure, one
received only the prompt “Referee this” with access limited to the paper
root and `lean/`, and one was asked to stress-test whether the paper proves
one bridge rather than three parallel appearances of the unique
\(A_5\)-invariant cubic.

The strongest results actually supported are:

1. the rational square-class theorem
   \[
   \mathbf Q(\mathbf P(H))(\sqrt{5J_0}),\qquad
   J_0|_V=16\sigma_3^2,
   \]
   and the resulting constant golden torsor on \(D(\sigma_3)\); and
2. the exact Petersen-channel harmonic realization
   \[
   \frac1{4\pi}\int_{S^2}F_y^3
   =-\frac{784000}{1247103}\sigma_3(y),
   \]
   after repairing the Gram normalization and displaying enough axis data
   to make the calculation recoverable.

The current finite matching result gives a parallel occurrence of the
unique invariant cubic after a noncanonical representation isomorphism.  It
does not yet supply the advertised canonical, arithmetic, or integral
specialization bridge.

Vibe check: three handsome realizations are being rhetorically welded into a
bridge that the current mathematics does not construct; removing the weak
weld exposes a strong focused note.

## Blocking correctness and trust findings

### 1. The Section 3 group action is impossible as written

`sections/03-clebsch-cubic.tex` defines an order-\(60\) group \(G\) and then
calls \(\Omega\) its \(22\)-element orbit.  Orbit--stabilizer forbids this.
The likely intended definition is a \(22\)-element
\(\operatorname{PGL}_2(11)\)-orbit with an order-\(60\) stabilizer, split
into two \(11\)-element \(\operatorname{PSL}_2(11)\)-orbits.  Until this is
stated and checked, \(W\), the sheet signs, and \(T\) rest on a malformed
definition.

### 2. The intertwiner and coefficient \(4\) are noncanonical

The pair module and matching quotient decompose as
\[
\mathbf1\oplus V_4\oplus V_5.
\]
Consequently the space of equivariant intertwiners has three independent
irreducible scalings.  Solving the equivariance equations does not fix those
scalings.  Rescaling the \(V_4\)-block rescales the transported cubic by a
cube; over \(\mathbf F_{11}\), the cube map on
\(\mathbf F_{11}^{\times}\) is bijective.  The displayed coefficient \(4\)
can therefore be changed to any nonzero coefficient unless additional
geometric or integral normalization is supplied.

What survives without such a normalization is only that a nonzero invariant
cubic on an abstract \(V_4\) spans the unique invariant line.  That is a
valid representation-theoretic statement, but it is not a canonical
specialization theorem.

### 3. No arithmetic-to-matching correspondence is proved

The arithmetic section proves that the reduced exchanger \(R\) has
nontrivial spinor class in
\(\operatorname{PGL}_2(11)/\operatorname{PSL}_2(11)\).  The finite section
separately constructs two matching sheets.  The manuscript supplies no
equivariant correspondence proving that this particular \(R\) exchanges
the particular two matching orbits used in \(T\), or that
\(\epsilon(RM)=-\epsilon(M)\).  Nontriviality in an abstract quotient does
not establish compatibility of these actions.

### 4. The common integral line is not constructed

No common \(A_5\)-stable integral module or primitive rank-one invariant
submodule is defined whose characteristic-zero and characteristic-\(11\)
base changes are respectively the Gaunt and matching cubics.  The fact that
the rational Gaunt scalar has denominator divisible by \(11\) prevents
reduction of that normalized element; it does not itself construct a
line-level integral comparison.

### 5. The finite bridge is not auditable from the release package

The manuscript invokes a “recorded” or “displayed” invertible intertwiner,
but the PDF does not display it.  The HC-3 trust row points to files under
`notes/`, outside the paper package.  The Lean terminal imports literal
tensor and contraction data and explicitly does not derive them from the
matching orbit, verify the group action, or prove equivariance.  Thus the
essential finite theorem is not carried by the claimed human proof and is
not reconstructible from the paper release surface.

### 6. The harmonic Gram matrix has a factor-\(13\) defect

For the standard normalized spherical inner product
\[
\langle f,g\rangle=\frac1{4\pi}\int_{S^2}fg,
\]
a zonal \(P_6\) has squared norm \(1/13\), whereas the displayed matrix has
diagonal \(1\).  The displayed matrix is the kernel matrix
\(P_6(u_e\cdot u_f)\), or the Gram matrix for the rescaled inner product
\(13(4\pi)^{-1}\int\).  Either divide the matrix and its eigenvalues by
\(13\), or define and consistently use the rescaled inner product.  The
later quadratic moment already uses the missing \(1/13\).

### 7. Two different notions of oddness are conflated

On the Hitchin pullback, the deck-odd coordinate is \(w\), or
\(w/(4\sigma_3)=\pm\sqrt5\) over the nonbranch chart.  The polynomial
\(\sigma_3\) is a base function and is fixed over each fibre.  Its oddness
under the separate twisted \(S_5\)-involution on the Clebsch parameter
space is not identified with the incidence deck involution.  Claims that
\(\sigma_3\) itself records which ordered icosahedron was forgotten must be
deleted or replaced by a theorem making this identification.

## Preferred publication plan

The high-EV route is a focused arithmetic--harmonic note rather than trying
to repair the bridge inside this release.

### Preserve as the two principal theorems

1. The square class of Hitchin's degree-two incidence extension is
   \(5J_0\).
2. Its restriction to the Clebsch chart is the constant golden torsor,
   with the explicit golden fibre supplying the constant \(5\).
3. The displayed golden exchanger and its spinor class modulo \(11\), stated
   as a self-contained arithmetic specialization without identifying it
   with the matching-sheet involution.
4. The exact degree-six face-axis harmonic restriction to
   \(\langle\sigma_3\rangle\), after the normalization and reproducibility
   repairs.
5. One precise statement of the integral/geometric-incidence boundary.

### Remove from Paper III

1. Remove Section 3, the finite tensor bridge, and preserve it for a
   separate result once its definitions, normalization, evidence bundle,
   and arithmetic correspondence are repaired.
2. Remove every clause in the abstract, main theorem, introduction, and
   conclusion that calls the mod-\(11\) matching tensor a specialization of
   the arithmetic or harmonic cubic.
3. Delete Section 6, “The common cubic line”; it repeats the unsupported
   bridge and normalization caveats without adding a theorem.
4. Remove manuscript-facing claim identifiers such as `MAIN-1`, `HC-3`,
   and `PH-1`.
5. Reduce “Verification and trust” to a short, honest reproducibility and
   data-availability statement.  Move runner commands, ledger mechanics,
   hashes, and build assertions to the artifact documentation.

This disposition leaves a shorter paper with an honest common base object:
both the arithmetic restriction and the harmonic invariant are expressed
on the same Clebsch four-space using \(\sigma_3\).  It does not claim that a
matching tensor is their canonical finite specialization.

## Smaller fixes

### Mandatory local repairs

- Correct the harmonic Gram normalization and its three eigenvalues.
- Display normalized coordinates for the ten face axes, or give a compact
  coordinate convention from which they are recoverable.
- Explain why the axes are labeled by two-subsets and why Petersen adjacency
  is the relevant geometric relation.
- Replace “the displayed axes” where no axes are displayed.
- Rephrase “the two configurations over \(\mathbf Q\) are therefore defined
  over \(\mathbf Q(\sqrt5)\)” as two conjugate geometric configurations
  defined over the quadratic extension.
- Define “ordered icosahedron” precisely.
- Define “four-channel,” or replace it by “four-dimensional \(V_4\)
  summand.”
- State exactly which inner product and spherical-harmonic normalization are
  in force.

### Compression and exposition

- Replace the localized odd-generator lemma and proof by one sentence unless
  the paper proves a precise minimal-degree theorem from it.
- Compress the nonmodular invariant-ring paragraph to the facts actually
  used for the square-class theorem.
- Remove the section-by-section roadmap from the eleven-page paper.
- Consolidate the repeated integral-boundary warnings into one dedicated
  remark and one conclusion sentence.
- Move the raw \(M_4,M_8\) matrices and substitution audit to an appendix if
  they remain after the finite bridge is removed.
- Move the full \(W_6\) conversion formula from the main theorem to a remark
  unless the paper develops the Steinhardt connection further.
- Shorten the abstract and conclusion after the bridge language is removed.
- Do not restore speculative physical applications, the marked Mathieu
  carrier, the research inventory, the \(S_6\) outer-automorphism story, or
  Landau-language discussion.  These enlarge the audience problem without
  repairing the theorem.
- Eight references remain thin for the retained range.  Add only targeted
  primary context for the Clebsch diagonal cubic, the relevant
  invariant/descent formulation, and the Petersen/icosahedral harmonic
  mechanism; do not rebuild the deleted literature branches.

## Questions and follow-up theorems

These are future work, not requirements for the focused release.

1. **Scheme-theoretic pullback.** Determine the normalization, conductor,
   and singular/branch behavior of
   \[
   w^2=80\sigma_3^2
   \]
   across \(\sigma_3=0\), and interpret
   \(J_0|_V=16\sigma_3^2\) as tangency or intersection multiplicity.
2. **Canonical specialization.** Construct a geometric correspondence
   taking the golden deck exchange to matching-sheet exchange and normalize
   the matching intertwiner canonically.
3. **Primitive integral comparison.** Construct natural \(A_5\)-stable
   lattices and a primitive invariant cubic module whose base changes give
   the matching and harmonic lines; determine the \(11\)-adic defect.
4. **Uniform Frobenius--spinor statement.** Over an explicit set of good
   primes, compare Frobenius on ordered-icosahedron fibres, the spinor
   character, and any matching-sheet character.
5. **All-degree harmonic channels.** For every even \(\ell\), diagonalize
   the face-axis zonal map on
   \(\mathbf1\oplus V_4\oplus V_5\), determine when \(V_4\) survives, and
   compute the restricted Gaunt coefficient and its bad primes.

## Fresh-session execution order

1. Read this report and the live clebsch handoff; do not preload the older
   candidate reports except when a retained proof or evidence route points
   to one.
2. Snapshot the seven current theorem statements and nine trust rows before
   editing, solely to account for their disposition.
3. Remove the finite tensor section and all dependent bridge language.
4. Restructure the page-one theorem into separate arithmetic and harmonic
   statements.
5. Repair the factor-\(13\) Gram normalization and add exact axis/labeling
   data.
6. Consolidate boundaries, shorten verification prose, remove internal
   claim IDs, and perform the smaller copy edits above.
7. Regenerate the statement identity and claim/evidence map from the reduced
   theorem surface; remove HC-3 rather than leaving a dead or externally
   supported row.
8. Run the paper-local exact replays, bibliography checks, aggregate gate,
   and warning-free PDF build.
9. Obtain a new context-free PDF-only referee read.  The acceptance question
   is whether the two-theorem focused note is correct, self-contained, and
   worth publishing—not whether the deleted three-way bridge can be
   rhetorically recovered.

## Alternative if the finite bridge is retained

Retaining Section 3 is not an editorial alternative.  It requires new
mathematics and a new evidence bundle:

1. repair the \(\operatorname{PGL}_2/\operatorname{PSL}_2\) orbit
   definition;
2. prove \(\dim W=10\), the character calculation, \(T\)-invariance, and
   independence from the base matching;
3. construct and display a geometrically normalized intertwiner;
4. prove that the golden exchanger reverses the matching sheets;
5. define the common integral lattice and primitive cubic line;
6. bundle primary and independent finite evidence inside the paper release;
7. state honestly what Lean checks and does not check.

Until all seven items are complete, the three-way-bridge version remains
`NO-GO`.
