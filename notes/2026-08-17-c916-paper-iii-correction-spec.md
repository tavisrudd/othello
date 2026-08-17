# Clebsch III — fool-proof correction specification for Opus

**Target manuscript:** *Clebsch: Rigidity from Sparse Shadows — III: Golden descent and operator realizations of the Clebsch cubic*, August 2026 PDF supplied for referee review.

**Purpose:** apply only the mathematical repairs identified by the referee/red-team audit, with exact search anchors and replacement wording. This specification is intentionally conservative. It is designed to prevent an editing model from “improving” correct sign, scalar, representation, or arithmetic arguments while repairing the compact-versus-regular incidence issue and the small Stein-normality omission.

**Page-number convention:** every page number below refers to the **original 33-page PDF before any edits**. Once pagination moves, use the exact search strings, not the page number.

---

## 0. Non-negotiable editing protocol

1. **Make only the edits listed in this document.** Do not globally rewrite prose, notation, theorem statements, proofs, citations, or exposition.
2. Preserve all theorem/proposition numbering.
3. Preserve the notation \(H,J_0,\iota_t,\sigma_3,E,B,B_\pm,C_m,Z_m,\beta\) exactly as in the manuscript.
4. Introduce one new geometric invariant only: Hitchin's degree-ten discriminant \(\Delta\), and on the Clebsch chart its pullback \(\Delta_t:=\iota_t^*\Delta\), **only after base change to \(\mathbf C\)** when discussing regular versus degenerate compact incidence points.
5. **Do not choose or claim a scalar normalization for \(\Delta\).** Only its zero locus is used.
6. **Do not use the letter \(D\) for Hitchin's degenerate divisor.** The manuscript already uses \(D(\sigma_3)\) for principal opens and later uses \(D\) as a divisor in the square-class proof. Say “the degenerate divisor” or “Hitchin's degenerate divisor.”
7. Keep the degree-six invariant and the degree-ten invariant conceptually separate:
   - \(J_0=0\): the invariant **sextic** controlling the compact incidence trichotomy / branch divisor.
   - \(\Delta=0\): the degree-ten **degeneracy** locus where a compact incidence point can lie on the Mukai–Umemura boundary.
8. Use “regular icosahedral six-axis configuration” only for a point in the open \(SO(3,\mathbf C)/A_5\) orbit. Use “compact incidence point” or “isotropic three-plane” when the point may be degenerate.
9. Do not infer quasi-finiteness of the compact incidence map from a count of regular icosahedra. The repaired proof below uses Hitchin 2010's compact trichotomy.
10. After editing, run every checklist under **SANITY CHECKS TO RUN AFTER EDITING** and **FINAL REVIEW CHECKLIST FOR THE HUMAN AUTHOR** before accepting the patch.

---

## 1. Source facts the patch is allowed to use

No new bibliography item is needed: Hitchin 2010 is already reference [3]. The following are the exact upstream inputs.

### Hitchin [3], *Vector bundles and the icosahedron*

- **§§3–4:** for a harmonic cubic \(f\), zeros of the section of the universal rank-three dual bundle on the Mukai–Umemura threefold are exactly isotropic three-planes orthogonal to \(f\). The compact zero set has the trichotomy: two points, one point, or positive dimension.
- **§6, Proposition 2:** there is an \(SO(3,\mathbf C)\)-invariant degree-ten polynomial \(\Delta\) such that \(\Delta(f)=0\) iff \(f\) is orthogonal to a **degenerate** isotropic three-plane.
- **§8.2:** on a fixed Clebsch \(\mathbf P^3\), the restriction of \(\Delta\) cuts out the irreducible degree-ten trisecant surface; its points contain the fixed nondegenerate icosahedral set and a degenerate one.
- **§8.3, Theorem 4:** on the fixed Clebsch chart, the one-point / positive-dimensional cases lie on the Clebsch cubic; the positive-dimensional case is confined to a degree-six rational curve and six lines.
- **§9, Theorem 5:** globally, a harmonic cubic has one or infinitely many compact icosahedral/isotropic sets iff it lies on Hitchin's invariant sextic \(J_6=0\); off that sextic it is in the two-point case.

### Hitchin [2], *Spherical harmonics and the icosahedron*

- The opening example and later chart calculations explicitly exhibit the two regular golden icosahedra on \(xyz=0\).
- The Clebsch chart restriction of the sextic is the source of the manuscript's normalized identity \(\iota_t^*J_0=16\sigma_3^2\).

**Do not import any stronger statement than these.** In particular, do not claim an explicit formula for \(\Delta_t\).

---

# REQUIRED EDITS

## 2. Original p. 7, §2.2 “A rational incidence model” — introduce the compact boundary and \(\Delta\)

### Search anchor

Find this exact paragraph fragment:

> Hitchin identifies \(X_{\mathbf C}\) with the Mukai–Umemura threefold [3, §§4–5]; in particular \(X\) is geometrically integral and smooth. The incidence scheme used here is

### Action

Insert the following text **between** “geometrically integral and smooth.” and “The incidence scheme used here is”.

### Insert exactly

> Over \(\mathbf C\), the open \(SO(3,\mathbf C)/A_5\)-orbit in \(X_{\mathbf C}\) parametrizes nondegenerate icosahedral configurations; its complement is Hitchin's degenerate divisor. By [3, §6, Proposition 2], there is an \(SO(3,\mathbf C)\)-invariant homogeneous polynomial \(\Delta\) of degree ten on \(H_{\mathbf C}\) such that a harmonic cubic \(f\) is orthogonal to a degenerate isotropic three-plane if and only if \(\Delta(f)=0\). We use \(\Delta\) only to distinguish regular points of the compact incidence space from boundary points; no normalization or arithmetic square class of \(\Delta\) is used below.

### Do not do

- Do **not** call \(\Delta=0\) the branch divisor.
- Do **not** identify \(\Delta\) with \(J_0\).
- Do **not** claim \(\Delta\) has a chosen rational normalization.
- Do **not** introduce a symbol for the degenerate divisor itself.

### Acceptance test

After the edit, §2.2 must make it explicit that \(X\) is a **compactification** and that some points of \(X_{\mathbf C}\) are degenerate, before the incidence scheme \(I\) is defined.

---

## 3. Original p. 8, §2.3 “The reduced branch cycle” — replace the regular-only quasi-finiteness argument

### Search anchor: replace the entire block

Start at:

> Hitchin proves that a general real point of \(J_0=0\) has exactly one incidence configuration, whereas either side has respectively two or zero real regular configurations [2, §9, Proposition 10 and Theorem 11].

Continue through and include:

> This scheme-theoretic conclusion is the paper-local ramification calculation; the cited real classification supplies the dense set of boundary points, not the finite-cover assertion.

### Replace that whole block with exactly

> Hitchin's compact trichotomy concerns the zero scheme of the section of the universal rank-three dual bundle on the Mukai–Umemura threefold itself [3, §§3–4, 8–9, especially Theorems 4–5]. Its geometric fibres have two points, one point, or positive dimension, and the one-or-positive-dimensional locus is the invariant sextic. The locus where \(\pi\) has positive-dimensional fibre is closed by upper semicontinuity and is not the whole sextic: on a fixed Clebsch chart, [3, §8.3, Theorem 4] gives one-point compact fibres at points of the Clebsch cubic away from a degree-six rational curve and six lines. Hence, after base change to \(\mathbf C\), a general smooth point of the irreducible sextic \(J_0=0\) has exactly one geometric point in the compact incidence fibre. At such a point \(\pi\) is quasi-finite, hence finite after shrinking the target. The source is smooth and the target regular of the same dimension, so miracle flatness makes this local finite map flat of degree two. Its fibre has only one geometric point and therefore is ramified. Thus the irreducible sextic \(J_0=0\) is a component of the branch cycle. Equation (2.1) shows that it exhausts that cycle, with multiplicity one. In particular the normal quadratic incidence field is branched exactly along the reduced divisor \(J_0=0\). This scheme-theoretic conclusion uses the compact incidence trichotomy to establish quasi-finiteness; no count of regular icosahedra is used to exclude hidden boundary points.

### Why this exact replacement

The old paragraph counted **regular** configurations and then inferred a property of the **compact** incidence fibre. The new paragraph works directly on Hitchin's compact Mukai–Umemura threefold.

### Logical sanity check

The order must remain:

1. canonical-class calculation gives \(\pi_*R=6h\);
2. compact trichotomy gives a general one-point fibre on the sextic;
3. proper + quasi-finite gives local finiteness;
4. miracle flatness gives local degree-two flatness;
5. one geometric support point implies ramification;
6. degree \(6\) forces the sextic to exhaust the branch cycle.

**Do not** use the already-desired conclusion “\(J_0=0\) is the branch divisor” to establish quasi-finiteness. That would be circular.

---

## 4. Original p. 9, §2.3 “The local comparison at \(xyz\)” — prove compact completeness before using étaleness

### Search anchor

Find these two sentences:

> Hitchin's classification gives exactly the two distinct configurations \(I_t\) and \(I_{1-t}\) over \([xyz]\) [2, §§3, 7–9]. Thus \(\pi\) is quasi-finite over this point.

### Replace only those two sentences with exactly

> Because \(J_0\) is a scalar-normalized equation of Hitchin's invariant sextic and \(J_0(xyz)=(16/25)^2\ne0\), Hitchin's compact trichotomy [3, §§3–4, 9, Theorem 5] puts \([xyz]\) in the two-point case for the section on the Mukai–Umemura threefold. The two points are the regular configurations \(I_t\) and \(I_{1-t}\) exhibited in [2, §§3, 7–9], so they exhaust the compact geometric fibre. In particular \(\pi\) is quasi-finite over this point.

### Leave the following existing argument unchanged

Starting with:

> Because \(\pi\) is proper, there is a Zariski neighborhood \(B\) of \([xyz]\) on which \(\pi\) is finite.

and continuing through the conclusion that the complete reduced fibre has residue algebra \(E=\mathbf Q(\sqrt5)\).

### Important logic

The repaired order is:

- \(J_0(xyz)\ne0\) + Hitchin compact trichotomy ⇒ **exactly two compact geometric points**;
- the already-known regular golden points are those two points ⇒ **complete fibre**;
- properness ⇒ local finiteness;
- the branch calculation and \(J_0(xyz)\ne0\) ⇒ finite normalization is étale near \(xyz\);
- therefore the two geometric points are reduced;
- Galois conjugacy ⇒ residue algebra \(\mathbf Q(\sqrt5)\);
- only then specialize the square class to obtain \(c=5\).

Do not reverse these dependencies.

---

## 5. Original p. 10, §2.3 “The Stein algebra” — add the missing codimension-one normality lemma

### Search anchor

Find:

> Multiplication on the anti-invariant summand is a section of \(M^{-2}\simeq\mathcal O(2d)\). Its zero divisor is the branch divisor, which is the sextic \(J_0=0\); hence \(d=3\), and multiplication is \(cJ_0\) for some \(c\in\mathbf Q^\times\).

### Replace with exactly

> Multiplication on the anti-invariant summand is a section \(a\) of \(M^{-2}\simeq\mathcal O(2d)\). At a codimension-one point of the regular base \(\mathbf P(H)\), trivialize \(M\) over the corresponding DVR \(R\), with uniformizer \(\varpi\). The quadratic algebra is then \(R[z]/(z^2-a)\). Since \(N\) is normal, \(v(a)\) cannot be at least two: otherwise \(z/\varpi\) is integral, because \((z/\varpi)^2=a/\varpi^2\in R\), but \(z/\varpi\notin R\oplus Rz\). Thus every height-one zero of \(a\) has multiplicity one, so the zero divisor of the multiplication section is exactly the reduced branch divisor \(J_0=0\). Hence \(2d=6\), so \(d=3\), and multiplication is \(cJ_0\) for some \(c\in\mathbf Q^\times\).

### Leave unchanged immediately after it

The existing sentences beginning

> The function-field calculation and the golden fibre give \(c=5\) modulo a rational square.

through the exact algebra

\[
\mathcal O\oplus\mathcal O(-3),\qquad z^2=5J_0
\]

must remain unchanged.

### Acceptance test

The proof must now explicitly explain why the multiplication section has **no extra even divisor** away from the reduced branch locus.

---

## 6. Original p. 4, Proposition 1.2 — correct the geometric interpretation of \(D(\sigma_3)\)

### Search anchor

Find:

> On \(D(\sigma_3)\) they are the two distinct icosahedral configurations; on the Clebsch cubic the unnormalized branches meet, while the normalization remains disjoint.

### Replace with exactly

> On \(D(\sigma_3)\) the pulled-back finite cover is split étale and has two distinct compact incidence points. Away from Hitchin's degree-ten degeneracy locus (defined in Section 2.2), both are regular icosahedral six-axis configurations; on that degeneracy locus with \(\sigma_3\ne0\), the fixed \(U_t\)-branch is regular and the other compact incidence point is degenerate. On the Clebsch cubic the unnormalized branches meet, while the normalization remains disjoint.

### Critical distinction

- “pulled-back finite cover is split étale on \(D(\sigma_3)\)” is correct;
- “normalization \(B_+\sqcup B_-\) is disjoint” is true **everywhere**, including \(\sigma_3=0\);
- “two regular six-axis configurations” is true only away from both \(\sigma_3=0\) and the degree-ten degeneracy locus.

Do not rewrite the equations \(z=\pm4\sqrt5\,\sigma_3\).

---

## 7. Original p. 11, §3.1 “Normalization over the Clebsch chart” — define \(\Delta_t\) and state the exact regular locus

### Search anchor

Find this sentence:

> Hitchin's chart classification identifies \(D(\sigma_3)\) as exactly the locus of two distinct regular configurations.

### Replace that one sentence with exactly

> After base change to \(\mathbf C\), write \(\Delta_t=\iota_t^*\Delta\) for the pullback of Hitchin's degree-ten discriminant introduced in Section 2.2; only its zero locus is used. The algebra above shows that on \(D(\sigma_3)\) the pulled-back finite cover is already split étale, while its normalization \(B_+\sqcup B_-\) remains disjoint everywhere. Hitchin [3, §8.2] identifies \(\{\Delta_t=0\}\) with the locus where a cubic in the fixed Clebsch chart is also orthogonal to a degenerate isotropic three-plane. Hence the literal interpretation by two regular six-axis configurations is valid precisely on \(D(\sigma_3\Delta_t)\). On \(D(\sigma_3)\cap\{\Delta_t=0\}\), the \(U_t\)-branch is regular and the other compact incidence point is degenerate.

### Notation rules for \(\Delta_t\)

- \(\Delta_t\) is **not** a newly normalized invariant; it is only a name for the pullback zero locus.
- Do not write \(\Delta_t=\prod_{i<j}(y_i-y_j)\).
- Do not identify \(\Delta_t\) with \(\sigma_3\), \(J_0\), or any power/product of them.
- Do not use \(\Delta_t\) in the arithmetic square-class argument.

### Keep the next sentence unchanged

> The magnitude \(4\sqrt5\) is forced by the product of the descent class \(5\) and the chart factor \(16\); choosing its sign is precisely choosing one normalized component.

---

## 8. Original p. 12, §3.2 “The golden involution” — correct the boundary sentence

### Search anchor

Find:

> Since the normalized components remain disjoint above \(\sigma_3=0\), the two relative source labels extend there even though the literal two-configuration interpretation fails.

### Replace with exactly

> These relative source labels are attached to the normalized components, not to a pointwise regular-six-axis marking. They therefore extend across both \(\sigma_3=0\) and, after base change to \(\mathbf C\), \(\Delta_t=0\); the literal interpretation by two regular icosahedral six-axis configurations is valid only on \(D(\sigma_3\Delta_t)\).

### Preserve the surrounding warning

The preceding sentences saying that no global marking of the varying configurations on \(B_-\) is needed or asserted, and that the calculation at \([xyz]\) is not used to infer pointwise conference labeling elsewhere, are **correct and should not be weakened or removed**.

---

## 9. Original p. 4, Introduction/source-attribution paragraph — citation hygiene

This edit is recommended because the repaired proof now separates “two regular golden configurations” from “complete compact fibre.”

### Search anchor

Find:

> Hitchin proves the generic degree, identifies the branch sextic, constructs the Clebsch chart, computes its restriction, and classifies the fibre over \(xyz\) [2, §§2–4, 7–10] [3, §§4–5].

### Replace with exactly

> Hitchin proves the generic degree and compact isotropic-subspace trichotomy, identifies the sextic locus, constructs the Clebsch chart, computes its restriction, and exhibits the two regular configurations over \(xyz\) [2, §§2–4, 7–10; 3, §§3–9]. The compact completeness of the \(xyz\)-fibre used here is deduced in Section 2.3 from [3, Theorem 5] together with \(J_0(xyz)\ne0\).

### Do not change

The next claims about the arithmetic theorem fixing the rational constant and computing the spinor class are unaffected.

---

# OPTIONAL / NON-MATHEMATICAL EDIT

## 10. Original pp. 29–30, Appendix B — immutable archive locator

The referee audit could not replay the claimed exact-arithmetic / Lean archive because no immutable public locator was supplied with the PDF.

### Search anchor

> The top-level `verification/` directory in the distributed source archive contains the exact programs, canonical certificates, checksums, toolchain requirements, and aggregate replay command.

### Action

**Only if an actual immutable locator exists**, add it here or in the bibliography/data-availability paragraph: e.g. a Zenodo DOI or an immutable repository commit.

### Absolute prohibition

**Do not invent a DOI, URL, commit hash, repository name, archive version, checksum, or citation.** If no immutable locator exists, make no textual change for this item.

---

# GLOBAL PROHIBITIONS — THINGS OPUS MUST NOT CHANGE

The referee audit found no defect in the following. Do not “clean them up,” renormalize them, change signs, or replace them with alternate conventions.

1. **Theorem 1.1 statement** and its headline result:
   \[
   \mathbf Q(\mathbf P(H))(\sqrt{5J_0}),\qquad
   \mathcal O\oplus\mathcal O(-3),\qquad z^2=5J_0.
   \]
2. \(\iota_t^*J_0=16\sigma_3^2\).
3. \(J_0(xyz)=(16/25)^2\).
4. The pulled-back equation
   \[
   z^2=80\sigma_3^2=(z-4\sqrt5\,\sigma_3)(z+4\sqrt5\,\sigma_3).
   \]
5. The normalization \(B_+\sqcup B_-\) and the choice \(z=+4\sqrt5\sigma_3\) on the \(U_t\)-component.
6. The golden exchanger and its sign transport \(C\mapsto-C,\ Z_C\mapsto-Z_C\).
7. The statement that the sheet alone does **not** determine the marking \(m\).
8. The chart-lift sign convention and the warning that there is no ambient \(SO(3)\)-equivariant linear map from harmonic degree \(3\) to harmonic degree \(6\).
9. Every Hodge-star sign and middle-degree convention in §5.1.
10. \(\operatorname{Pf}[D_x,C]=4Z\) and \(\det[D_x,C]=16Z^2\).
11. \(Z=10\sqrt5\det B\) and the field-norm sign.
12. Theorem 5.2.
13. Theorem 5.3, including the exchange spectrum \(\{1/5,4/5,4/5\}\).
14. Theorem 5.4, its seven-point bound, decoder, and query count \(3n^2-23n+45\).
15. The Petersen labeling, pair-sum map \(\beta(y)_{ij}=y_i+y_j\), and its inverse.
16. The kernel/Gram distinction in §6 and all Petersen eigenvalues.
17. The harmonic coefficient
    \[
    -\frac{784000}{1247103}
    \]
    and its Wigner/Gaunt factorization.
18. The finite-field spinor class \([2]\) and the separate golden discriminant class \([5]\).
19. The manuscript's caution that the geometric integral incidence comparison is only known after inverting an unspecified finite set of primes.
20. The statement that the explicit golden data at \(11\) do **not** establish a global integral incidence theorem at \(11\).

Also do not change the abstract or conclusion merely to mention \(\Delta\). The headline arithmetic theorem is unchanged; \(\Delta\) repairs the **interpretation of compact points as regular configurations**, not the main result.

---

# TERMINOLOGY RULES AFTER THE PATCH

Use these phrases consistently:

- **compact incidence point** = a point \(U\in X_{\mathbf C}\) orthogonal to \(f\), possibly degenerate;
- **regular / nondegenerate icosahedral six-axis configuration** = a compact incidence point in the open \(SO(3,\mathbf C)/A_5\) orbit;
- **degenerate isotropic three-plane / degenerate compact incidence point** = a point on Hitchin's boundary divisor;
- **pulled-back finite cover** = the base change of the finite Stein cover before normalizing the chart pullback;
- **normalization of the chart pullback** = \(B_+\sqcup B_-\), disjoint everywhere;
- **split étale locus of the pulled-back finite cover** = \(D(\sigma_3)\);
- **two-regular-configuration locus on the chart** = geometrically \(D(\sigma_3\Delta_t)\).

Never use “configuration” without qualification in a sentence whose truth depends on whether boundary points are allowed.

---

# SANITY CHECKS TO RUN AFTER EDITING

These are not optional. They are designed to catch the most likely Opus-induced regressions.

## A. Compactness / regularity checks

- [ ] §2.2 explicitly says the Mukai–Umemura threefold contains a degenerate divisor.
- [ ] \(\Delta=0\) is described only as the locus of orthogonality to a degenerate isotropic three-plane.
- [ ] \(J_0=0\) remains the sextic branch/trichotomy locus.
- [ ] Nowhere does the edited manuscript say \(D(\sigma_3)\) is exactly the locus of two regular configurations.
- [ ] The chart's two-regular locus is stated as \(D(\sigma_3\Delta_t)\), after base change to \(\mathbf C\).
- [ ] The normalized components \(B_+,B_-\) remain disjoint even at \(\sigma_3=0\).
- [ ] The **unnormalized/pulled-back finite cover**, not its normalization, is what is described as split étale on \(D(\sigma_3)\).

## B. Branch-proof checks

- [ ] The proof of quasi-finiteness at a general branch point invokes Hitchin [3]'s compact trichotomy, not merely the real regular-icosahedron count in [2].
- [ ] The positive-dimensional case is explicitly noted to be non-generic.
- [ ] \(\pi_*R=6h\) is unchanged.
- [ ] The proof does not assume the sextic is already the branch divisor before proving it.
- [ ] A one-point flat degree-two fibre is called ramified; it is **not** called reduced.

## C. Golden-fibre checks

- [ ] The argument first proves the compact fibre over \(xyz\) has exactly two geometric points from \(J_0(xyz)\ne0\) and Hitchin [3, Theorem 5].
- [ ] It then identifies those two points with \(I_t,I_{1-t}\) from [2].
- [ ] Only after local finiteness and the branch calculation does it conclude the fibre is étale/reduced.
- [ ] The residue algebra remains \(\mathbf Q(\sqrt5)\).
- [ ] The square-class conclusion remains \(c=5\) modulo squares.

## D. Stein-algebra checks

- [ ] The new DVR argument occurs after \(M\simeq\mathcal O(-d)\) is established.
- [ ] The contradiction uses normality of \(N\).
- [ ] The local algebra is \(R[z]/(z^2-a)\).
- [ ] The argument concludes \(v(a)\in\{0,1\}\) at height one.
- [ ] Therefore the multiplication divisor is the **reduced** sextic and \(2d=6\), hence \(d=3\).
- [ ] The exact equation \(z^2=5J_0\) remains unchanged.

## E. Sign / scalar regression checks

Verify these literal constants still occur unchanged:

- [ ] \(16\sigma_3^2\)
- [ ] \(80\sigma_3^2\)
- [ ] \(4\sqrt5\,\sigma_3\)
- [ ] \(C^2=5I\)
- [ ] \(C\mapsto-C\)
- [ ] \(Z_C\mapsto-Z_C\)
- [ ] \(\operatorname{Pf}[D_x,C]=4Z\)
- [ ] \(\det[D_x,C]=16Z^2\)
- [ ] \(Z=10\sqrt5\det B\)
- [ ] \(-784000/1247103\)

---

# INDEPENDENT SANITY CHECK AT \(xyz\) — DO NOT SUBSTITUTE THIS FOR THE MAIN REPAIR

This calculation is useful for review but need not be inserted into the manuscript unless the author wants an additional one-line check.

The null conic is
\[
Q:\ x^2+y^2+z^2=0.
\]
The cubic \(xyz=0\) meets \(Q\) at the six distinct points
\[
[0:1:\pm i],\qquad [1:0:\pm i],\qquad [1:\pm i:0].
\]
At, for example, \([0:1:i]\),
\[
\nabla(xyz)=(i,0,0),\qquad \nabla Q=(0,2,2i),
\]
which are linearly independent; the other five points are identical by symmetry. Thus all six intersections are transverse. Hitchin [3, §6, Proposition 2] therefore gives \(\Delta(xyz)\ne0\): there is no degenerate compact incidence point above \(xyz\).

This independently agrees with the main compact-trichotomy repair. **Do not claim transversality alone proves there are exactly two points**; it only excludes degenerate boundary points. Completeness still comes from the compact trichotomy plus the two known regular golden points.

---

# FINAL REVIEW CHECKLIST FOR THE HUMAN AUTHOR

Before accepting Opus's patch, answer every item “yes”.

- [ ] Did Opus make only the specified edits?
- [ ] Is reference [3] still Hitchin 2010 and reference [2] still Hitchin 2009/2007?
- [ ] Is \(\Delta\) introduced only as a degree-ten geometric degeneracy invariant, with no normalization?
- [ ] Is \(\Delta_t\) only a pullback zero-locus notation after base change to \(\mathbf C\)?
- [ ] Did Opus avoid identifying \(\Delta_t\) with the Vandermonde \(\prod_{i<j}(y_i-y_j)\) or any other explicit polynomial?
- [ ] Did Opus keep \(J_0\) and \(\Delta\) entirely separate?
- [ ] Is the main branch proof now about compact incidence fibres?
- [ ] Is the \(xyz\) fibre proven complete before it is proven reduced/étale?
- [ ] Is there no circular use of the branch theorem in proving the branch theorem?
- [ ] Is the DVR normality argument present and correctly placed?
- [ ] Does Proposition 1.2 no longer assert two regular configurations on all of \(D(\sigma_3)\)?
- [ ] Does §3.1 say two regular configurations only on \(D(\sigma_3\Delta_t)\)?
- [ ] Does §3.2 say the source labels live on normalized components and are not pointwise regular markings?
- [ ] Are all signs and constants listed in sanity check E unchanged?
- [ ] Are Theorems 5.1–5.4 and 6.1 mathematically untouched apart from any pagination caused by earlier insertions?
- [ ] Is the integral/finite-field caveat untouched?
- [ ] If an archive locator was added, is it a real immutable locator supplied by the author rather than invented by the editing model?

If any answer is “no,” reject the automated patch and correct that item before proceeding.

---

# Minimal diff summary

The intended mathematical diff is deliberately small:

1. acknowledge Hitchin's compact degenerate boundary and degree-ten \(\Delta\);
2. use Hitchin 2010's compact trichotomy for the branch point and \(xyz\) fibre;
3. replace “two regular configurations on \(D(\sigma_3)\)” with the correct split-cover / \(D(\sigma_3\Delta_t)\) distinction;
4. make the relative source labels explicitly independent of pointwise regular six-axis markings on the degeneracy locus;
5. add the height-one normality argument in the Stein algebra;
6. optionally provide an immutable verification-archive locator, but only if one actually exists.

Nothing else in the paper should move mathematically.
