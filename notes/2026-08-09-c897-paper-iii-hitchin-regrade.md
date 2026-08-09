# C897 Paper III sealed Hitchin regrade

**Persona:** Nigel Hitchin

**Artifact:** standalone commit `9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`; `clebsch_passages.pdf` SHA-256 `a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`

**Categorical verdict:** `PASS`

## PDF-only assessment (frozen before supplements)

The strongest coherent package proved by the paper is the following.  The rational incidence model of harmonic cubics and Mukai--Umemura isotropic three-planes has quadratic generic field

\[
  \mathbf Q(\mathbf P(H))(\sqrt{5J_0}),
\]

where the internally normalized rational branch equation satisfies
\(\iota_t^*J_0=16\sigma_3^2\).  Its finite Stein normalization has algebra
\(\mathcal O\oplus\mathcal O(-3)\), with multiplication \(z^2=5J_0\), and the fibre over \([xyz]\) is the complete reduced closed point with residue algebra \(\mathbf Q(\sqrt5)\).  After a full marking is fixed, the selected sheet supplies the relative sign used by the conference, classical-cubic, and Petersen/Gaunt realizations.  The paper additionally proves the stated exchange-spectrum rigidity and sharp aligned-two-graph reconstruction theorem.

The causal arithmetic proof is sound.

1. The three rational skew forms define a rational Grassmannian zero locus \(X\).  Hitchin's complex identification makes \(X\) geometrically smooth and integral by descent.  The incidence scheme \(I=\mathbf P_X(F)\) is consequently smooth and integral, and the top Chern count gives its generic projection degree two.
2. Adjunction gives \(K_X=\mathcal O_X(-1)\).  Since \(\det F=\mathcal O_X(-1)\), the projective-bundle formula gives \(K_I=\pi^*\mathcal O_{\mathbf P(H)}(-4)\).  Therefore the determinant of \(d\pi\) has divisor class \(3h\), and projection in generic degree two gives \(\pi_*R=6h\).
3. At a general real smooth point of Hitchin's irreducible sextic there is one real incidence configuration.  After excluding the proper non-quasi-finite locus, properness makes the map finite near such a point; smooth source and regular target then give finite flat degree two.  A degree-two real fibre containing exactly one real geometric configuration cannot be a split reduced fibre, hence it is ramified.  These real points are Zariski dense.  Thus \(J_0=0\) occurs in the branch cycle.  Its degree already equals the full effective cycle \(6h\), so there is no further divisorial branch component and its coefficient is exactly one.  Tame quadratic ramification supplies the same multiplicity-one conclusion valuation-theoretically.
4. Since \(\operatorname{Pic}(\mathbf P(H))\simeq\mathbf Z\) has no two-torsion, a quadratic extension branched exactly on that reduced sextic is \(K(\sqrt{cJ_0})\) for a unique constant square class \(c\in\mathbf Q^\times/\mathbf Q^{\times2}\).
5. At \([xyz]\), Hitchin's classification gives the two distinct conjugate configurations \(I_t\) and \(I_{1-t}\).  The point lies off \(J_0=0\).  On a finite neighbourhood the normal incidence model is the normalization in the quadratic field; deleting the branch divisor makes it finite étale of rank two.  The two displayed geometric points therefore exhaust the fibre and are reduced.  Their Galois orbit is a single closed point with residue algebra \(\mathbf Q(\sqrt5)\).  Since \(J_0(xyz)=(16/25)^2\), specialization forces \(c=5\).
6. The involution splits the finite normalization algebra into invariant and anti-invariant summands.  Normality makes the latter rank-one reflexive, hence a line bundle on projective space.  Its multiplication divisor is the reduced sextic, forcing \(\mathcal O(-3)\); the fibre calculation fixes the coefficient to \(5\) up to a rational square, which is absorbed by the generator.

The normalization of \(J_0\) is exact in the sense claimed.  The paper does not identify Hitchin's opening analytic moment scale with the conveniently rescaled operator in his appendix.  It instead chooses the unique rational equation whose Clebsch-chart restriction is the appendix identity \(16\sigma_3^2\).  Galois conjugation, orthogonal invariance, and the fixed lift make that scalar rational; evaluation at \(y^\circ=(4,-1,-1,-1,-1)/5\) then gives \(J_0(xyz)=(16/25)^2\).  This is precisely the scale needed in the specialization argument and avoids a false analytic normalization claim.

The earliest place at which Hitchin's cited geometry alone would fail to imply the headline rational scheme assertion is the passage from the complex top-Chern count to a rational normal quadratic cover with a reduced branch divisor.  The manuscript does not make that passage by citation: its rational Grassmannian model, canonical-bundle computation, ramification cycle, local finite-flat argument, and Stein normalization supply it.  I therefore find no unsupported implication in the headline chain.

The full-paper scan found no further `MAJOR` or `MINOR`.  In particular, the marking appendix correctly keeps switching, relabelling, chart scaling, Galois conjugation, and deck exchange distinct; the operator identities separate formal Hodge/Pfaffian facts from the conference-specific triangle-minor identity; and the degree-six theorem states an \(A_5\)-intertwiner on the marked four-space rather than an impossible ambient \(SO(3)\)-equivariant map.

Relative to Hitchin's papers, the contribution is the rational descent and exact quadratic twist of the incidence cover, joined through an explicitly marked orientation source to the conference/classical-cubic and degree-six harmonic realizations.

Assuming the displayed proofs, the article meets an *Advances in Mathematics* significance bar: it combines a genuine arithmetic refinement of the incidence geometry with independent structural results and makes the boundaries between real, complex, rational, and marked constructions unusually explicit.

## Supplement check

After freezing the preceding assessment, I read the permitted standalone overview, artifact boundary, literature boundary, and trust manifest, and inspected only the non-Lean arithmetic-cover certificate and independent replay.  Both exact checks passed, as did their checksum manifest.  They independently confirm the canonical degrees \((-7,-1,-4)\), ramification class \(3h\), branch-cycle degree \(6\), all twenty nonzero golden three-point determinants, the conjugate exchanger, and its mod-11 spinor representative.

The supplement is appropriately non-circular.  It explicitly says that the geometric identification of the reduced branch cycle with \(J_0=0\), the local normalization comparison, and the Clebsch-chart invariant identity are *not* checked by that certificate; those remain the human arguments audited above.  The claim/evidence ledger likewise assigns the rational incidence, reduced ramification, exact \(J_0\) normalization, and Stein algebra to the manuscript proof rather than to computation or formalization.  No supplemental item changes the `PASS` verdict.

## Mystery ledger

- **Reduced multiplicity-one branch:** settled.  The potentially delicate upgrade from Hitchin's real boundary to a scheme-theoretic reduced branch divisor is supplied by the paper's canonical-cycle degree, local finite-flat argument, tame quadratic ramification, and density; the supplement neither assumes nor simulates it.
- **Two printed sextic scales in Hitchin:** settled for the theorem actually stated.  The paper fixes an internal rational normalization by \(\iota_t^*J_0=16\sigma_3^2\) and expressly declines to equate it with the opening analytic scale.
- **Exact integral exceptional set:** genuinely open but correctly fenced off.  Determining the integer \(N\) for which the geometric incidence comparison spreads out requires an integral Mukai--Umemura identification, flatness and normality, and Stein/chart base change.  The paper claims only an unspecified cofinite set, so this is an advertised research boundary rather than a defect.
- **Formal-companion publication state:** the artifact metadata records that an immutable release containing the supplemental golden-return sources is still required for submission.  No complete geometric manuscript claim uses that formal material as a premise, so this is a release-management blocker, not a mathematical finding against the paper.

## Unresolved findings

No unresolved mathematical review finding.  The only open items are the expressly delimited integral-model problem and the external formal-companion release step recorded above; neither changes the verdict.
