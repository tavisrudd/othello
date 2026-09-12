# Reconstruction, Rigidity, and Rationality in Geometry, Coding, and Quantum Information

*Sparse shadows, persistent defects, and the recovery of hidden structure*

- [selected headline results](#selected-headline-results)
- [research frontiers and conditional extensions](#research-frontiers-and-conditional-extensions)
- [theorems over infinite families](#theorems-over-infinite-families)
- [papers and entry points](#papers-and-entry-points)
- [abstracts and non-specialist guides](#abstracts-and-non-specialist-guides)
- [verification philosophy](#verification-philosophy)
- [contact and disclosure](#contact-and-disclosure)

This programme studies **what survives information loss**. Across geometry,
coding theory, and quantum information, a rich object is replaced by a sparse
shadow. Examples include deep-hole loci, minimum-word layers, recovery equations,
marginal transition systems, and marked spectral packets. The central question is whether
the shadow still determines its source, or whether failure of generic behaviour
forces the source onto a **rigid exceptional carrier**.

A recurring method is to identify the exact ambiguity left by the coarse
shadow, then retain the **smallest extra datum that removes it**. Coefficients
refine supports, coherent views replace independent quotients, and markings
restore information lost by unordered or saturated invariants. The resulting
theorems reconstruct hidden objects, classify exceptional loci, and turn
approximate agreement into exact algebraic rigidity.

A second theme is **persistence**. Once a marked obstruction has been isolated,
the papers determine whether it survives operations such as concatenation,
stabilization, wall crossing, or change of coefficients. The common principle
is to find a **minimally enriched shadow** that remembers the hidden structure
and can be transported without losing the feature that matters.

> **Status.** These manuscripts have not been externally refereed. Each paper
> is intended to stand on its own mathematically. Verification is claim-specific
> and generally not end-to-end. Each repository
> distinguishes prose proofs, cited inputs, kernel-checked formalizations,
> certificate-checked computations, and trusted executions. See
> [VERIFICATION.md](VERIFICATION.md) for the paper-level evidence maps.

## Selected headline results

These are selected headlines grouped by area. Within each area, their order
reflects the present assessment of theorem strength, breadth, and reusability;
closely related facets of one theorem complex are not counted as separate
results.

### Algebraic geometry and rationality

- **One-stabilization irrationality and Hodge conservation.** Every smooth
  complex cubic threefold remains irrational after multiplication by `P¹`.
  More generally, for every smooth complex Fano threefold of Picard rank one,
  `X × P¹` is rational if and only if `X` is rational. This covers all
  seventeen families: nine remain irrational and eight are rational.
  The numerical proof uses two counts on whole quantum primary factors:
  canonical rank-two residues and full odd dimension in even rank three.
  Points, curves and surfaces contribute zero, so weak factorization gives
  birational invariance. A separate Hodge refinement shows that birational
  first stabilizations of members of the nine irrational families force an
  isomorphism of their rational third cohomology as Hodge structures.
  It gives neither an integral lattice nor a polarization identification.
  The numerical proof is independent of the Hodge refinement; both use the
  specialized projective-line argument. General projective-bundle machinery
  is confined to optional extensions.
  [One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf).

- **Sharpness at the next stabilization.** A three-parameter family of smooth
  cubic threefolds has exact stabilization level two over every extension of
  its characteristic-zero ground field. The independent surface theorem
  rationalizes every stably rational smooth quartic del Pezzo surface after
  two variables. In an explicit rational pencil, potential toric ranks of
  intermediate Jacobians distinguish a positive-density squarefree integer
  family. Hodge conservation gives pairwise nonbirational irrational
  fourfolds whose products with one further projective line are all rational.
  [Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf).
  [Literature ledger, N1–N4](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/LITERATURE.md)
  records the contribution against prior families and the audit's coverage gaps.

- **Integral divisor products on the nonstandard `A₅` cubic pencil.** An
  all-degree graph-saturation theorem makes the primitive minimal class of
  the intermediate Jacobian an integral divisor product for every smooth
  member of this non-isotrivial pencil. Consequently every member is
  universally `CH₀`-trivial. Combined with the one-stabilization theorem,
  this gives an explicit family whose products with `P¹` are both universally
  `CH₀`-trivial and irrational.
  [Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf).

- **Integral and modular decomposition for the cubic-threefold theta
  divisor.** For the theta divisor of every smooth complex cubic threefold,
  the integral middle lattice is free of rank `130` with Lefschetz saturation
  quotient `(Z/2)^10`.  The resolution has two integral outer point summands
  and a residual perverse factor with central map `Z --(-3)--> Z`; modulo
  three that factor is uniserial with successive factors
  `delta_0`, `IC`, `delta_0`.  The same factor three makes relative hard
  Lefschetz fail modulo three, while an infinite-order Fano class lifts the
  local order-three link class.
  [Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf).

### Finite geometry and reconstruction

- **Universal lower bound and secant-defect identity.** Even after any
  prescribed `q + 1` points are exempted from coverage, a complete-outside arc
  has size at least `√(2q) + 3/2 − 8/√(2q)`. The first two secant moments give
  the exact pointwise-nonnegative defect behind this bound; zero defect forces
  a simple maximum-matching design, and the remainder gives deletion
  stability. The cap version of the identity gives
  `√2·q + 1/2 + 3/√2 − o(1)` for complete caps in `PG(3,q)`. [Secant defects with prescribed holes: arcs, caps, and matching designs](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf).

- **Integer secant distributions expose arithmetic hidden by spectral
  mixing.** For complete `(k,n)`-arcs, exact integer degree distributions of
  the full `n`-secant family sharpen the classical design incidence bound on
  every rational equality family with integral limiting degrees. On
  characteristic-compatible branches, modular stability reduces near
  equality to a bounded correction, and completeness charges each support
  point a linear secant excess. A centered ternary line-code word then forces
  three generator lines and another `q/3 − o(q)` points. In particular, over
  `q = 3^h`, `t_{2q/3+1}(2,q) ≥ q²/3 + 5q/3 − o(q)`.
  [Integral Secant Distributions and Line-Code Obstructions for Complete (k,n)-Arcs](https://github.com/tavisrudd/integral-secant-arcs/blob/main/integral_secant_arcs.pdf).

- **Pairwise conflicts recover a projective frame.** For every prime power
  `q ≥ 13`, the uncoloured continuation graph of a four-point frame determines
  `q`, and every graph isomorphism extends uniquely to a semilinear equivalence
  of the planes carrying one frame to the other. Recovering tangent traces,
  their four centre classes, and the field action also gives polynomial-time
  recognition over a supplied field with a checkable coordinate certificate.
  An independent finite census finds extra automorphisms at `q = 5,8` and
  semilinear rigidity at `q = 7,9,11`.
  [Reconstructing projective frames from their continuation graphs](https://github.com/tavisrudd/continuation-graph-rigidity/blob/main/continuation_graph_rigidity.pdf).

- **Sparse data recover marked finite geometry.** In the Clebsch case, a
  conic-containing deep-hole syndrome locus recognizes the non-GRS
  `[6,3,4]₁₁` code and recovers its conic, polarity, and conference matrix up
  to switching and global negation;
  a companion classification proves that `q = 11` is the only field order
  admitting a conic-filling six-arc. In the q=13 case, weighted pair
  concurrences of the 364 minimum words recover the binary code and the marked
  plane `PG(2,13)`, including its conic and polarity. [Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf),
  [Reconstructing PG(2,13), its conic, and polarity from the minimum words of a binary conic code](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf).

- **Quadratic trades recognize exceptional matching geometries.** Within full
  `PGL₂(q)`-orbits of perfect matchings over odd fields, a two-valued
  strength-two trade occurs only for the `B₃/F₇` and `H₃/F₁₁` geometries.
  The trade recovers their unordered sheets, and the first nonzero signed
  cubic orients them. This carrier condition is sharp: off the matching locus,
  `q − 2` nonmatching orbits retain the same trade.
  [Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf).

- **Arithmetic of Hitchin's incidence cover determines its quadratic twist.** Hitchin's
  harmonic-cubic incidence cover has function field `Q(P(H))(√(5J₀))` and
  finite Stein equation `z² = 5J₀`. After a marking datum is fixed, a chosen
  sheet selects a marked conference pair whose cubic has four equivalent operator
  descriptions and returns as the exact degree-six Gaunt multiple
  `−784000σ₃/1247103`. The same carrier independently yields exchange-spectrum
  rigidity and sharp reconstruction of two-graphs from aligned four-sets.
  [The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and Conference-Matrix Rigidity](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

- **Distinct cubic shadows recover one marked carrier.** The signed residue in
  *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients*
  is a chordal Hankel cubic, not the conference cubic of *Reconstructing the
  Clebsch Code from Its Deep-Hole Syndrome Locus*
  and *The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and
  Conference-Matrix Rigidity*. Its singular quartic recovers the original six axes
  by exact stabilizer pairs. Selecting a chordal line and a conference sign
  gives mutually inverse reconstruction maps. Forgetting the chordal line
  gives a residual `C₂`-torsor distinct from the global-negation torsor
  `{[B],[-B]}`.
  [Chordal and Conference Cubics: Reconstruction and a Residual C₂-Torsor](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf).

### Coding theory and quantum information

- **High-weight cosets of generalized and extended Reed–Solomon codes.** For
  every redundancy `r ≥ 6`, any prescribed finite deletion from the projective
  line, and arbitrary nonzero coordinate multipliers, the paper classifies all
  cosets of weight at least `r−1` in an explicit field range in odd
  characteristic and in characteristic two for `r ≥ 8`.  At binary
  redundancies six and seven the full-support classification is complete, and
  the point-deleted case is confined to an explicit carrier.  The paper also
  determines the corresponding MDS/NMDS one-column extensions, family-wise
  minimum-support counts, and aggregate weight enumerators.  Exact R5–R7
  theorems give sharper small-field and modular refinements.
  [High-Weight Cosets of Generalized and Extended Reed–Solomon Codes](https://github.com/tavisrudd/high-weight-grs-cosets/blob/main/high-weight-grs-cosets.pdf).

- **Exact and quantitative AME rigidity.** Every product-unitary intertwiner
  between additive stabilizer `AME(2m,q)` states is Clifford on each party,
  for prime powers `q` and `m≥2`. Robust rigidity has certified radius
  `min{1/(4 sqrt(2q)),1/(8π sqrt(2m))}`; the dimension exponent is order-sharp
  on existing families with `2m≤Cq` when the stated spectral-spread and
  collective bounds are retained. In prime dimension, recognition reduces to
  four variables and costs `O(m³+log q)` field operations. The proof is
  deterministic for decision; exact witness construction has that expected
  cost. [Robust Local-Unitary Rigidity](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf).

- **A Schur-square test determines MDS–CSS transversal groups.** For odd-prime
  `[2m,m,m+1]q` MDS codes, the code conductor `Cond(C,C⊥)=(C^(star 2))⊥` has
  dimension zero or one. Its dimension determines whether the projective
  transversal group is `Fq² ⋊ SL₂(q)` or the smaller split-torus branch.
  [Exact Transversal Logical Groups of Quantum MDS–CSS Codes](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf).

- **Labelled recovery costs compose, while equations and minimal repairs have different confinement conditions.**
  Labelled recovery costs determine the exact first equation escape cost and compose associatively; retaining minimizing lifts reconstructs coefficient witnesses. If every outer dual word touching the target
  block has weight greater than `r+1`, every inclusion-minimal recovery support of size
  at most `r` is local. This requires no inner-dual-distance condition and transfers
  reliability under availability laws with the same local marginal, as well as
  fractional and integral support allocations.
  [Exact Compositional Transfer of Bounded Linear Recovery](https://github.com/tavisrudd/compositional-recovery/blob/main/compositional_recovery.pdf).

- **Order six is the unique nontrivial cut-rigid symmetric conference
  order.** For a balanced half (Y) of a symmetric conference matrix, the
  normalized cross-block Gram spectrum is independent of (Y) exactly in the
  trivial order-two case and at order six. In the Hermitian order-six problem,
  squared real triangle holonomy parametrizes the complete degree-three Pareto
  frontier; cutwise constancy of any one sector characterizes the real
  switching class, with a quantitative stability bound.
  [Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf).

## Research frontiers and conditional extensions

- **Framed formal monodromy.** The numerical small even quantum connection has
  the unconditional primitive-sixth counts `ν₆(X) = 2` and
  `ν₆(X × P¹) = 4`. Its blow-up formulas and birational invariance through
  dimension four depend on explicit reconstruction-tail and residual
  divisor-tagging hypotheses. [Framed Formal Monodromy of Cubic Threefolds](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf).

## Theorems over infinite families

The following table records selected infinite-family statements from the
major papers. When a statement is conditional, its hypothesis is displayed in
the theorem column.

| Paper | General theorem | Quantifier range |
|---|---|---|
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | `X × P¹` is irrational, detected by a rank-two generic-even-QDM block with distinct formal exponent classes modulo the integers. | Every smooth complex cubic threefold `X`. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | A smooth projective threefold with positive exponent count remains irrational after multiplication by `P¹`. | Every smooth projective complex threefold. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | `X × P¹` is rational if and only if `X` is rational. | Every smooth complex Fano threefold of Picard rank one, across all seventeen families. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | Birational first stabilizations imply `H³(X,Q) ≅ H³(Y,Q)` as rational Hodge structures. | Any two smooth members of the nine irrational Picard-rank-one Fano families. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | Birational first stabilizations imply `X ≅ Y`. | A very general complex cubic or quartic threefold `X` and any smooth threefold `Y` of the same degree. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | Finitely many geometric cubic partner classes after first stabilization. | A fixed cubic over a finitely generated characteristic-zero field and partners over extensions of bounded degree; no finiteness of twists asserted. |
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | The exponent count and residue spectrum extend to additive homomorphisms on `K₀(Var_C)/(L − 1)`. | All complex varieties, via the smooth-projective blow-up relations; no multiplicativity asserted. |
| Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds | `S × A²`, equivalently `S × P²`, is rational. | Every smooth quartic del Pezzo surface over a characteristic-zero field with a rational point and stably permutation geometric Picard lattice. |
| Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds | `X_{j,r} × P²` is rational over `Q`. | Both Tschinkel--Zhang cubic series, for every `r ≥ 0` and `j ∈ {1,3}`. |
| Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds | The smooth three-parameter cubic family has exact stabilization level two. | Every extension of the characteristic-zero coefficient field; smoothness is required. |
| Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds | A lattice index `d` gives a dominant rational parametrization of degree dividing `d`; coprime admissible indices imply universal `CH₀`-triviality of a smooth proper model. | Torus quotients satisfying all the stated descent, tangent-projection and transversality hypotheses, in characteristic zero. |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Finite-etale graph slopes make every divided power of the marked graph divisor lattice an ordinary integral divisor product. | Every marked finite-etale graph quotient of an elliptic power satisfying the stated local depth and self-adjointness hypotheses, in every degree. |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Every smooth pencil member is universally `CH₀`-trivial; after multiplication by `P¹`, it remains universally `CH₀`-trivial and is irrational. | Every smooth member of the nonstandard `A₅`-invariant cubic pencil. |
| Framed Formal Monodromy of Cubic Threefolds | The primitive-sixth framed-monodromy count of the numerical small even quantum connection equals two. | Every smooth complex cubic threefold `X`. |
| Framed Formal Monodromy of Cubic Threefolds | The primitive-sixth count of a product with projective space is that of the factor times one more than the dimension. | Every smooth projective variety and every projective space. |
| Framed Formal Monodromy of Cubic Threefolds | Assuming the reconstruction-tail and residual divisor-tagging hypotheses, the primitive-sixth count is birationally invariant. | All smooth projective varieties of dimension at most four. |
| Reconstructing projective frames from their continuation graphs | Every isomorphism between the uncoloured continuation graphs extends uniquely to a semilinear equivalence of the frames; the graph determines the field order. | All four-point projective frames in `PG(2,q)` and `PG(2,q′)`, for prime powers `q,q′ ≥ 13`. |
| Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus | If an arc's uncovered locus is a nonsingular conic, then `q` is odd and `2k − 3 ≤ q ≤ (k(k − 1) + 3)/3`. | Every `k`-arc with `k ≥ 4`, over every finite field order `q`. |
| Computational Strengthenings of Clebsch Syndrome Rigidity | `q = 11` is the only field order admitting a conic-filling six-arc. | Every field order. |
| Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients | The strength-two trade space is one-dimensional and generated by a two-valued vector if and only if the orbit is `B₃/F₇` or `H₃/F₁₁`. | Full `PGL₂(q)`-orbits of perfect matchings, for every odd prime power `q`. |
| The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and Conference-Matrix Rigidity | Aligned four-sets reconstruct the two-graph up to complement, and seven is sharp. | Every two-graph on at least seven vertices. |
| Secant defects with prescribed holes: arcs, caps, and matching designs | The first two secant moments give an exact defect identity with pointwise nonnegative remainder. | Every `k`-arc with `k ≥ 3` in every finite projective plane, and every prescribed hole set disjoint from the arc. |
| Integral Secant Distributions and Line-Code Obstructions for Complete `(k,n)`-Arcs | Exact integer envelopes for the internal and external maximal-secant degrees give a positive linear correction to the real incidence bound. | Every ordered factorization `lambda = uv` in positive integers, with `q = (u+v+1)m`, `n = (u+1)m+1`, and the stated external coverage hypothesis. |
| Integral Secant Distributions and Line-Code Obstructions for Complete `(k,n)`-Arcs | The full dual maximal-secant set can be changed at `O(1)` support points into an exact `lambda mod p` multiset. | Every fixed factor pair `lambda=uv` with `u+v+1` a power of `p`, along `q=p^e`, for arcs at the leading equality density with the stated external coverage. |
| Integral Secant Distributions and Line-Code Obstructions for Complete `(k,n)`-Arcs | `t_{2q/3+1}(2,q) ≥ q²/3 + 5q/3 − o(q)`; every asymptotically matching family has a centered residue word generated by exactly three lines. | `q = 3^h` as `h` tends to infinity. |
| High-Weight Cosets of Generalized and Extended Reed–Solomon Codes | In the complete-classification range, every projective syndrome direction of weight at least `r−1` is classified: omitted curve points form the weight-`r` shell, while tangents, conjugate secants, and deleted-point-incident split secants form the weight-`r−1` shell. | `r ≥ 6`, arbitrary multipliers and finite deletion set `A`, and the paper's explicit field bound, with odd characteristic or characteristic two and `r ≥ 8`; at binary `r ∈ {6,7}` the full-support classification is complete. |
| High-Weight Cosets of Generalized and Extended Reed–Solomon Codes | The two shells classify all MDS and NMDS one-column extensions; exact family-wise minimum-support counts determine their aggregate weight enumerators. | The same point-deleted GRS/EGRS family and field range. |
| High-Weight Cosets of Generalized and Extended Reed–Solomon Codes | Outside the catalecticant rank-two locus—and, only at binary `r ∈ {6,7}`, the stated linear carrier—every syndrome has weight at most `r−2`; the paper also proves `#Y = 6N + 3d₂ + d₃` for the terminal cubic pencil. | Carrier containment for every characteristic and `r ≥ 6` in the stated field range; the terminal identity holds in every characteristic. |
| Robust Local-Unitary Rigidity of Stabilizer AME States | Every product-unitary intertwiner between stabilizer `AME(2m,q)` states is Clifford on each party. | Every prime power `q = pᵉ` and `m ≥ 2`. |
| Exact Transversal Logical Groups of Quantum MDS–CSS Codes | The code-conductor dimension fixes the transversal logical group. | All `[2m,m,m+1]q` MDS codes over odd prime fields. |
| Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy | Order six is the unique nontrivial realized symmetric conference order whose normalized balanced cross-block Gram spectrum is cut-independent. | Every symmetric conference matrix and every balanced half. |
| Exact Compositional Transfer of Bounded Linear Recovery | For `u=min(k,\|P\|)`, `b=min(k,\|J\|)`, and `ell=u+b-k`, an MDS inner code has `M_t(D_P,K_P)=k-u+t` at every recoverable rank; helper-span gives equality in the global ceiling, and rank-one ceiling equality is rigid. | Every proper MDS inner code and every target/helper split with `1 ≤ t ≤ ell`. |
| Exact Compositional Transfer of Bounded Linear Recovery | Labelled recovery costs determine the exact first equation escape cost and compose associatively; retaining minimizing lifts reconstructs coefficient witnesses. If every outer dual word touching the target block has weight greater than `r+1`, every inclusion-minimal recovery support of size at most `r` is local. This requires no inner-dual-distance condition and transfers reliability under availability laws with the same local marginal, as well as fractional and integral support allocations. | Represented inner encoders, compatible outer codes, and a fixed nonzero helper-recoverable target space. The exact equation formula assumes at least two outer blocks and nonzero target-block projection; the radius counts scalar helper coordinates. |
| Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold | The integral middle lattice has rank `130` and saturation quotient `(Z/2)^10`; the integral resolution complex has central Smith factor three, a length-three mod-three Loewy chain, and modular relative-hard-Lefschetz failure. | The theta divisor of every smooth complex cubic threefold. |

## Papers and entry points

Each link below points to the public PDF file and repository on GitHub. Each
repository README gives the paper's scope, current status, formalization
boundary, and reproducible entry points.

| Paper | Area | Central result | Public entry |
|---|---|---|---|
| One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds | Algebraic geometry / birational geometry | Every smooth cubic remains irrational after `P¹`; one stabilization preserves rationality across all seventeen Picard-rank-one Fano families, and birational first stabilizations in the nine irrational families conserve rational `H³`. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds | Algebraic geometry / birational geometry | A three-parameter smooth cubic family has exact level two; an explicit pencil gives pairwise nonbirational first stabilizations on a positive-density integer set, while all second stabilizations are rational. | [PDF](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-irrationality) |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Algebraic geometry / algebraic cycles | Every smooth member of the non-isotrivial pencil is universally `CH₀`-trivial; after multiplication by `P¹`, it remains universally `CH₀`-trivial and is irrational. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| Framed Formal Monodromy of Cubic Threefolds | Algebraic geometry / quantum cohomology | The unconditional count is `ν₆(X) = 2` and satisfies the projective-space product formula; its operation formulas and birational invariance remain conditional on two explicit hypotheses. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| High-Weight Cosets of Generalized and Extended Reed–Solomon Codes | Coding theory | Arbitrary-redundancy classification of the top two coset-weight shells for point-deleted GRS/EGRS codes, with exact deep-hole, MDS/NMDS extension, and aggregate enumerator consequences. | [PDF](https://github.com/tavisrudd/high-weight-grs-cosets/blob/main/high-weight-grs-cosets.pdf) · [repo](https://github.com/tavisrudd/high-weight-grs-cosets) |
| Robust Local-Unitary Rigidity of Stabilizer AME States | Quantum information | Exact and robust factorwise rigidity; prime-field recognition and marginal verification. | [PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [repo](https://github.com/tavisrudd/ame-lu) |
| Reconstructing projective frames from their continuation graphs | Finite geometry / graph reconstruction | Pairwise incompatibility determines a projective frame up to unique semilinear extension for `q ≥ 13`, with polynomial recognition and exact small-field exceptions. | [PDF](https://github.com/tavisrudd/continuation-graph-rigidity/blob/main/continuation_graph_rigidity.pdf) · [repo](https://github.com/tavisrudd/continuation-graph-rigidity) |
| Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus | Finite geometry / coding | Deep-hole data recognize the Clebsch code and recover its conference matrix up to switching and global negation. | [PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [repo](https://github.com/tavisrudd/clebsch-rigidity) |
| Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients | Algebraic combinatorics | On the matching carrier, a two-valued quadratic trade classifies two exceptional geometries and a cubic orients their sheets. | [PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [repo](https://github.com/tavisrudd/clebsch-factorization) |
| The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and Conference-Matrix Rigidity | Algebraic geometry / combinatorics | An exact arithmetic incidence cover labels its sheets by opposite marked conference pairs; cubic realizations, exchange rigidity, and two-graph reconstruction follow. | [PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [repo](https://github.com/tavisrudd/clebsch-passages) |
| Reconstructing PG(2,13), its conic, and polarity from the minimum words of a binary conic code | Coding / finite geometry | Weighted pair data on minimum words recover a marked projective plane, conic, and polarity. | [PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [repo](https://github.com/tavisrudd/q13-passant-code) |
| Chordal and Conference Cubics: Reconstruction and a Residual C₂-Torsor | Invariant theory / algebraic combinatorics | Distinct chordal and conference cubics recover one marked six-axis carrier; the residual chordal-line torsor is distinct from the global-negation/Frobenius torsor. | [PDF](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf) · [repo](https://github.com/tavisrudd/chordal-conference-reconstruction) |
| Hodge Atoms as Occurrence-Indexed Marker Ledgers | Algebraic geometry / quantum cohomology | The standard abstract Hodge-atom chemical formula is the Hodge specialization of an occurrence-indexed categorical marker ledger, with an effective weak-factorization quotient and a strictly one-step rank-two obstruction. | [PDF](https://github.com/tavisrudd/hodge-atom-marker-ledger/blob/main/hodge_atom_marker_ledger.pdf) · [repo](https://github.com/tavisrudd/hodge-atom-marker-ledger) |
| Standard Flips of Discrepancy One: Extremal J-Normalization and the Meijer Aperture at ν=1 | Algebraic geometry / quantum cohomology | An exact `z`-order count and the `ν=1` Barnes sector complete the discrepancy-one range in Shen--Shoemaker's extremal flip theorem. | [PDF](https://github.com/tavisrudd/discrepancy-one-flips/blob/main/discrepancy_one_flips.pdf) · [repo](https://github.com/tavisrudd/discrepancy-one-flips) |
| Secant defects with prescribed holes: arcs, caps, and matching designs | Finite geometry / designs | A universal pointwise defect identity gives matching-design rigidity, stability, conic-relative bounds, and a `PG(3,q)` cap bound. | [PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [repo](https://github.com/tavisrudd/arcs-complete-outside-conic) |
| Integral Secant Distributions and Line-Code Obstructions for Complete `(k,n)`-Arcs | Finite geometry / designs / coding theory | Integer maximal-secant distributions and a ternary three-line obstruction give `t_{2q/3+1}(2,q) ≥ q²/3+5q/3-o(q)`. | [PDF](https://github.com/tavisrudd/integral-secant-arcs/blob/main/integral_secant_arcs.pdf) · [repo](https://github.com/tavisrudd/integral-secant-arcs) |
| Exact Transversal Logical Groups of Quantum MDS–CSS Codes | Quantum coding / finite geometry | The code-conductor dimension, equivalently the codimension of the Schur square, determines the projective transversal group. | [PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [repo](https://github.com/tavisrudd/mds-css-transversal-groups) |
| Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy | Matrix theory / algebraic combinatorics / mathematical physics | Order six is the unique nontrivial cut-independent case; Hermitian triangle holonomy controls the degree-three frontier and rigidity. | [PDF](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf) · [repo](https://github.com/tavisrudd/conference-cut-spectra) |
| Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold | Algebraic geometry / topology | The rank-130 integral middle lattice has canonical mod-two glue, while the same resolution carries a factor-three integral perverse attachment, a length-three modular Loewy chain, and failure of relative hard Lefschetz modulo three. | [PDF](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf) · [repo](https://github.com/tavisrudd/blown-up-theta-lattice) |
| Frobenius-equivariant Pair Extension and Robust Repair of Eight-Arcs | Finite geometry / coding theory | Fixed mate-line carriers and exact collision corrections give Frobenius-compatible paired MDS extensions, including the exact two-fixed-point minimum over F₂₅. | [PDF](https://github.com/tavisrudd/equivariant-robust-completion/blob/main/equivariant-robust-completion.pdf) · [repo](https://github.com/tavisrudd/equivariant-robust-completion) |
| Exact Compositional Transfer of Bounded Linear Recovery | Coding theory / distributed storage | Exact labelled composition reconstructs recovery witnesses; target-touching outer dual distance confines bounded minimal repair supports even when equations can escape. | [PDF](https://github.com/tavisrudd/compositional-recovery/blob/main/compositional_recovery.pdf) · [repo](https://github.com/tavisrudd/compositional-recovery) · [Ergodis](https://github.com/tavisrudd/ergodis) |
| Strength-two trades and transversal cubic gates: the Clebsch cubic-phase codes and their magic | Quantum coding / finite geometry | Strength-two signed trades give high-rate error-detecting qudit codes whose surviving third moment is a transversal logical cubic phase; the ten-qudit `F₁₁` resource has no Clifford-product decomposition across any bipartition, and joint preparation of the six-qudit `F₇` resource beats the specified independent distillation menu. | [PDF](https://github.com/tavisrudd/clebsch-cubic-phase/blob/main/companion.pdf) · [repo](https://github.com/tavisrudd/clebsch-cubic-phase) |

The repository for *Reconstructing the Clebsch Code from Its Deep-Hole
Syndrome Locus* also contains the computational companion
*Computational Strengthenings of Clebsch Syndrome Rigidity*. It supplies exact
finite classifications and replayable evidence for the main paper rather than
a separate series paper.

## Research software

### ergodis — Exact Recovery, Global Optimization, and Invariant Synthesis

[Source, installation, and CLI guide](https://github.com/tavisrudd/ergodis) ·
[software documentation and evidence](https://github.com/tavisrudd/ergodis) ·
[mathematical paper](https://github.com/tavisrudd/compositional-recovery/blob/main/compositional_recovery.pdf)

ergodis is a standalone Rust finite-domain compiler and exact solver for
structured linear-recovery problems. It synthesizes quotient spaces,
functional labels, generated-span states, graded load shells, and compressed
support families before invoking a specialized exact engine or a residual
CP-SAT model. It computes prescribed-coset costs, composes them through finite
concatenation towers, returns coefficient-level witnesses, analyzes bounded
reliability, and schedules simultaneous repairs under heterogeneous
capacities.

Bundled application examples cover recursive XOR repair, LRC batching, repair
DAGs, QC-LDPC search, vector repair, and GPU MDS checkpoint recovery. Matched
bounded controls include Graphillion, HiGHS, OR-Tools max-flow, CryptoMiniSat,
and CP-SAT. The recorded gains range from `8x` to `344,300x`; the largest
comparison isolates the theorem-driven compositional reduction. These are
declared-instance results, not a universal solver ranking, and none is used as
evidence for a mathematical theorem.

## Abstracts and non-specialist guides

The abstracts below are the papers' own abstract text, with local LaTeX macros
rendered in plain Markdown notation. Each is followed by a non-specialist
guide: what the paper delivers, who may care, and why it matters. If you are
new to the subject, use those three guide paragraphs as the orientation and
then read the abstract for the paper's technical statement.

### Highlights

#### One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout results.** Every smooth complex cubic threefold stays irrational
after multiplication by `P¹`. The numerical classification covers all
seventeen smooth complex Picard-rank-one Fano families. Among the nine
irrational families, birational first stabilizations conserve the entire
rational third Hodge structure.

> *Abstract* We prove that X × P¹ is irrational for every smooth complex cubic threefold X. More generally, for every smooth complex Fano threefold of Picard rank one, X × P¹ is rational if and only if X is rational. The proof constructs numerical birational invariants of fourfolds from selected generalized eigenspaces of quantum multiplication. The key step is to show that points, curves, and surfaces contribute zero to these invariants in the quantum blowup formula. Weak factorization then gives birational invariance, and quantum product calculations determine the invariants after product with P¹. For the nine irrational families, a refinement retaining Hodge structures shows that birationality of X × P¹ and Y × P¹ forces an isomorphism of their rational third cohomology as Hodge structures. The numerical irrationality proofs are independent of this refinement.

**Delivers.** An unconditional cubic theorem, an all-member Fano rationality
classification after one stabilization, and a separate rational-Hodge
conservation theorem. Consequences include cancellation for a very general
cubic or quartic source against any smooth target of the same degree, and
finitely many geometric cubic partner classes over extensions of bounded
degree of a fixed finitely generated characteristic-zero field.

**Who cares.** Algebraic geometers working on rationality, stable rationality,
intermediate Jacobians, algebraic cycles, quantum connections, or weak
factorization.

**Why it matters.** The first stabilization allows surface centers in weak
factorization, so classical threefold obstructions do not directly settle
it. The numerical selectors isolate contributions that every such center
misses. Hodge conservation then recovers information about the original
threefolds from a birational map between their fourfold products. The cubic
proof can be read on its own; the numerical classification precedes the
Hodge argument and its consequences.

**Attribution boundary.** The paper's claim ledger records “Ordinary irrationality, quantum spectral methods and much of the
underlying Fano data are prior work” and “Exact whole-H³ one-stable
conservation priority comparison remains open.”

**Verification.** Exact finite checks and a partial Lean companion support
specified steps. Geometric comparison maps and endpoint realizations remain
written proofs or cited inputs; this is not an end-to-end Lean proof.

---

#### Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds

[PDF](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-irrationality)

**Standout result.** A three-parameter family has exact stabilization level
 two. An explicit pencil gives infinitely many pairwise nonbirational
 irrational fourfolds, each rational after one further projective-line factor.

> *Abstract.* We construct a three-parameter family of smooth cubic threefolds whose least rational stabilization has dimension two over every extension of their characteristic-zero ground field. The construction rests on a surface theorem: every stably rational smooth quartic del Pezzo surface becomes rational after multiplication by the affine plane. A saturated rank-three subtorus of the projective Cox model has rational quotient, and equivariant torsor splitting leaves a rational two-dimensional torus. The cubic lower bound is supplied by the one-stabilization irrationality theorem. In an explicit rational pencil, we decompose intermediate Jacobians up to geometric isogeny into five elliptic factors and compute their potential toric ranks. These ranks separate a positive-density set of squarefree integral parameters. Hodge conservation then gives infinitely many pairwise nonbirational irrational fourfolds, each rational after one further projective-line factor. The rationalization and arithmetic calculations are independent of the two companion obstruction theorems.

**Delivers.** Uniform two-variable rationalization, exact cubic stabilization
levels, geometric isogeny separation and finite rational pencil partner sets.
The appendices retain finite-index quotient and torus-action consequences.

**Who cares.** Researchers in cubic hypersurfaces, birational geometry,
quartic del Pezzo surfaces, universal torsors and arithmetic Jacobians.

**Why it matters.** The family identifies the first rational stabilization;
its arithmetic subfamily exhibits infinitely many birational distinctions
that disappear after one further projective-line factor.

---

#### Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout result.** Every smooth member of the nonstandard
`A₅`-invariant cubic pencil is universally `CH₀`-trivial. Combined with the
one-stabilization theorem, this gives a non-isotrivial family whose products
with `P¹` are universally `CH₀`-trivial and irrational.

> *Abstract* We study the nonstandard A₅-invariant pencil of smooth cubic threefolds. A six-axis polarization identifies its exotic two-primary gluing packet and constrains odd-degree product decompositions of the intermediate Jacobian. An all-degree integral graph-saturation theorem then proves algebraicity of the primitive minimal class for every smooth member. Consequently every member is universally CH₀-trivial. The family is non-isotrivial, and all but its Fermat point lie outside both the separated-variable locus and the explicit coprime-degree family of Yang–Yu–Zhu. Combined with the one-stabilization theorem for cubic threefolds, this gives a non-isotrivial family whose products with P¹ are universally CH₀-trivial and irrational.

**Delivers.** A six-axis description of the intermediate-Jacobian
polarization, an all-degree integral divisor-product theorem, universal
`CH₀`-triviality for the pencil, and its separation from stabilized
irrationality.

**Who cares.** Algebraic geometers working on cubic threefolds, algebraic
cycles, intermediate Jacobians, and universal `CH₀`-triviality.

**Why it matters.** Universal `CH₀`-triviality is necessary for stable
rationality but does not provide a parametrization. This family shows that it
can coexist with irrationality after an actual projective-line
stabilization.

---

#### Framed Formal Monodromy of Cubic Threefolds

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout result.** The framed primitive-sixth count satisfies
`ν₆(X) = 2` and `ν₆(X × P¹) = 4` for every smooth cubic threefold. These
computations are unconditional; the operation formulas and birational
invariance are conditional on two explicit hypotheses.

> *Abstract* We define a framed formal-monodromy count ν₆ for the numerical small even quantum connection and compute ν₆(X) = 2 and ν₆(X × P¹) = 4 for every smooth cubic threefold. The calculation and product formula are unconditional. Under an explicit reconstruction-tail hypothesis, the count satisfies blowup and projective-bundle formulas; under a separate residual divisor-tagging hypothesis for the remaining surface centers, it is birationally invariant through dimension four. These hypotheses give a conditional second proof of one-step irrationality and the conditional identity ν₆(V) = 2 for prime Fano threefolds of genus eight. We isolate the exact comparison statements still needed to make the refinement unconditional.

**Delivers.** The unconditional cubic and product computations, explicit
conditional operation formulas, and a precise statement of the remaining
comparison hypotheses.

**Who cares.** Researchers in quantum cohomology, formal monodromy, and
birational geometry.

**Why it matters.** The framed count retains more small-point information than
the primary paper's generic formal-exponent marker. The companion keeps that
refinement and its unresolved provider assumptions separate from the
unconditional one-stabilization proof.

---

#### High-Weight Cosets of Generalized and Extended Reed–Solomon Codes

[PDF](https://github.com/tavisrudd/high-weight-grs-cosets/blob/main/high-weight-grs-cosets.pdf) · [Repository](https://github.com/tavisrudd/high-weight-grs-cosets) · [![Version 1 concept DOI](https://img.shields.io/badge/Version_1_concept_DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

**Standout results.** For every redundancy `r ≥ 6`, arbitrary multipliers, and
any prescribed finite deletion from the projective line, the main theorem
classifies every coset of weight at least `r−1` under one explicit field bound.
It gives the exact deep-hole shells, all MDS and NMDS appended columns,
family-wise minimum-support counts, and aggregate weight enumerators.  The
proof's all-characteristic layer confines every remaining high-weight syndrome
to the catalecticant rank-two locus or one explicit Lucas carrier.  Exact
R5–R7 results provide sharper fixed-level refinements; R8–R10 remain companion
records rather than claims of the submission.

> *Abstract* Let a redundancy-`r` generalized Reed–Solomon code have evaluation set `S = P¹(F_q) \ A`, where `|A|=s`, and arbitrary nonzero column multipliers. For `r ≥ 6`, `char F_q > r−1`, and `q ≥ 6(r+s)−16+floor(2 sqrt(6(r+s)−18))`, we classify every coset of weight at least `r−1`. If `s=0`, the covering radius is `r−1`, and its maximum-weight directions are the tangent and conjugate-secant points of the normal rational curve. If `s>0`, the radius is `r`: omitted curve points have weight `r`, while tangents, conjugate secants, and rational secants incident with `A` give exactly weight `r−1`. We count both shells and classify their MDS and NMDS one-column extensions and family-aggregate weight enumerators.
>
> The proof contracts all `r−5` markers at once. Outside the catalecticant rank-two locus and one explicit Lucas carrier, a degree-six selector reaches a terminal cubic pencil; an exact genus-one count supplies a split cubic avoiding the markers and `A`. This gives arbitrary-redundancy carrier containment in every characteristic, a sharper binary threshold, and many witnesses of weight at most `r−2`. Exact R5–R7 results supply small-field and modular refinements; public artifacts record the trust boundaries.
>
**Literature boundary.** “To our knowledge, no earlier result classifies, for
arbitrary redundancy, every projective syndrome direction of a generalized or
extended Reed–Solomon code supported on a projective line with finitely many
prescribed points deleted that has coset weight at least `r−1`.”  This wording
is quoted from the paper's claim-specific novelty ledger.

**Delivers.** An exact top-of-distance-partition theorem for a broad GRS/EGRS
family, together with its deep-hole, code-extension, and enumerative outputs.

**Who cares.** Coding theorists working on Reed–Solomon codes, covering radius,
and polynomial interpolation.

**Why it matters.** “Deep holes” are maximally far from every codeword.  Their
classification clarifies the codes' worst-case distance geometry and turns the
same syndrome geometry into exact MDS/NMDS extension data.

---

#### Robust Local-Unitary Rigidity of Stabilizer AME States

[PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [Repository](https://github.com/tavisrudd/ame-lu) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21681856-blue.svg)](https://doi.org/10.5281/zenodo.21681856)

**Standout results.** Every product-unitary equivalence between additive
stabilizer `AME(2m,q)` states, `m≥2`, has Clifford factors. Approximate product
symmetries admit an exact-symmetry decomposition with an explicit collective
residual bound. The radius is a uniform two-parameter statement; the length
restriction `2m≤2(q²−1)` excludes unbounded fixed-`q` families.

The half-set invariant gives deterministic prime-field recognition in
`O(m³+log q)` field operations and exact randomized witnesses with the same
expected cost. In prime dimension, four-party endomorphism algebras are
`M_2(F_q)`, with compatible group `SL_2(q)`; six-party algebras are nonscalar.
Complementary marginal tests give optimal uniform verification gap
`(m+1)/(2m)`, also for nonstabilizer AME targets. Weighted exact tradeoffs
remain stabilizer-specific. Independent repetitions give an explicit
confidence-based entry rule for robust rigidity under a product-unitary
preparation promise.

> *Abstract.* Let q=pᵉ and m≥2. We prove that every product unitary mapping
> one stabilizer AME(2m,q) state to another is Clifford on each party, also
> when party relabelling is allowed. The result covers arbitrary additive
> stabilizers: local Clifford actions lie in Sp₂ₑ(Fₚ), with no Fq-linearity
> assumption. The proof is a support count. Stabilizers contained in any
> (m+1)-party set project bijectively onto every retained party's Weyl labels,
> so the reduced operator determines all local Weyl axes.
>
> We also prove robust rigidity. Below an explicit state-vector defect
> threshold of order min{q⁻¹ᐟ²,(2m)⁻¹ᐟ²}, a product unitary decomposes into an
> exact symmetry and a residual whose collective generator norm is at most
> π√q ε. Each local factor first rounds to a Clifford within normalized
> Hilbert–Schmidt distance 8ε. Three-region cleaning and Weyl–Fourier
> concentration give these frames; quantized stabilizer overlaps and a
> balanced-cut estimate control the residual.
>
> The exact proof also gives a complete finite transition-map invariant and
> factorwise Clifford rigidity for transversal encoder conversions. For
> promised stabilizer-AME check matrices, fixed-label recognition returns
> compact symplectic witnesses with an explicit field-operation bound; in
> prime dimension, a four-variable quadratic reduction gives deterministic
> decision in O(m³+log q) field operations and exact witnesses with the same
> expected cost. Stabilizer phases determine a Clifford–Pauli conversion.
> Selected marginal tests give fidelity certificates and an observable
> sufficient condition for the robust theorem.

**Delivers.** An exact classification, a quantitative rounding theorem,
and marginal tests linking measured rejection to certified fidelity. The
[reference implementation](https://github.com/tavisrudd/ame-lu/tree/main/software/prime-recognition)
returns compact prime-field symplectic witnesses and includes independent
small-field test oracles. The theorems have manuscript proofs; these tests
and the partial formalizations do not constitute end-to-end formal coverage.

**Who cares.** Quantum-information theorists, stabilizer-code researchers, and
people studying robust classifications of entangled states.

**Why it matters.** The result gives both an exact classification and a
noise-tolerant version, which is essential when experiments and numerical
models produce near-symmetries rather than perfect ones.

---

### Clebsch: Rigidity from Sparse Shadows

#### Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus

[PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [Repository](https://github.com/tavisrudd/clebsch-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Standout result.** Deep-hole data recover the non-GRS Clebsch code, its
conic and polarity, and a conference matrix up to switching and global
negation, with `B² = 5I`; and eleven is not an arbitrary choice of field, because a
Sylvester-graph obstruction in the computational companion shows that q = 11
is the only field order admitting a conic-filling six-arc at all.

> *Abstract* Let A be a six-arc in PG(2,11) and let U(A) be the projective points on no chord of A: the projective deep-hole syndrome locus of its [6,3,4]₁₁ MDS code. We prove that U(A) lies on a conic if and only if A is projectively equivalent to the Clebsch hexagon, and then U(A) is exactly a nonsingular conic. The deep-hole locus is thus a recognition invariant for the non-GRS Clebsch code up to monomial equivalence: from this locus we recover the parity-check geometry, the conic then determines its polarity, and Dye's theorem identifies the stabilizer as A₅. From the decoder multiplicities we recover the Brianchon points, the self-polar triangles, and an intrinsic bipartition of the three-coordinate supports.
>
> From nearest-codeword ambiguity we reconstruct a complementary pair of conference two-graphs, equivalently a conference matrix up to switching and global negation. Either signed orbital representative satisfies B² = 5I, and the switching-invariant triangle products cᵢⱼₖ = BᵢⱼBⱼₖBₖᵢ give the support cubic, the sole nonsymmetric term in the diagonal determinant pencil of B. The decoder data thus yield incidence, symmetry, the conference structure, and the integral quadratic order Z[B] ≃ Z[√5].
>
> We prove rigidity from a universal chord-defect identity and a partial-cover bound, and deduce one uniform consequence: any k-arc whose uncovered locus is a nonsingular conic has q odd and 2k − 3 ≤ q ≤ (k(k − 1) + 3)/3, so for each fixed k the all-field conic-filling existence problem reduces to finitely many field orders.
>
**Delivers.** The pattern of the errors farthest from every valid codeword
identifies the code, its conference structure, and the integral quadratic
order `Z[B] ≃ Z[√5]`.

**Who cares.** Coding theorists, finite geometers, and researchers interested
in inverse problems or in what can be learned from failures.

**Why it matters.** Error-pattern data can expose a code's underlying geometry
even when the code is not given directly.  The result turns indirect evidence
into a complete reconstruction theorem, and it is not confined to one field:
the same chord-defect argument gives a field window for every k-arc, and the
companion shows that eleven is the only field order where a conic-filling
six-arc exists.  The chord-defect identity used here is the special case, for
one arc in PG(2,q), of the all-planes secant-moment identity proved in *Arcs
complete outside a conic* below.

---

#### Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients

[PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [Repository](https://github.com/tavisrudd/clebsch-factorization) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682217-blue.svg)](https://doi.org/10.5281/zenodo.21682217)

**Standout result.** Within the full matching carrier, a two-valued quadratic
trade singles out the B₃/F₇ and H₃/F₁₁ geometries and recovers their unordered
sheets; the first nonzero signed cubic orients them. Off the carrier, `q − 2`
nonmatching orbits retain the same trade.

> *Abstract* A perfect matching of marked points on a conic determines a product of secant lines; restricting that product to the conic forgets the pairing. Among full PGL₂(q)-orbits of such matchings over odd finite fields, we classify those whose conic-quotient evaluation space has a one-dimensional strength-two trade—a signed relation annihilating all quadratic coordinate products—generated by a two-valued vector: exactly two such orbits occur, the balanced B₃/F₇ and H₃/F₁₁ orbits. Targeted modular detectors, made exhaustive by Faber's tame subgroup theorem, exclude every other orbit without a field census. From the trade we reconstruct the two complementary sheets up to interchange, assuming neither self-association nor Gorensteinness, and we orient them by the first nonzero signed moment: the signed moments vanish through degree two, and that first survivor is an anti-invariant cubic.
>
> We prove the matching hypothesis sharp. For either surviving stabilizer the fixed locus in the ambient conic-product fiber is an affine line of q pairwise nonconjugate rational points: q − 2 of them are nonmatching orbits satisfying the same trade condition, one is the coalescence parameter, and only the matching point splits completely into linear factors. The exceptional one-factorizations are classical; the boundary we isolate is that fixed line and its unique completely split point.
>
> The 14- and 22-point homogenizations are self-associated and arithmetically Gorenstein, with the cubic as the Macaulay inverse system of an Artinian reduction—a consequence of general self-dual-code criteria for the Schur square, not a hypothesis.
>
**Delivers.** On the matching carrier, a two-level balancing pattern forces one
of two exceptional pairing geometries and recovers its unordered sheets; a
signed cubic then supplies their orientation.

**Who cares.** Finite geometers, combinatorialists, and researchers studying
designs, matchings, or symmetry-breaking invariants.

**Why it matters.** Local counting rules can recover pairing information that
has been deliberately erased.  A signed cubic invariant supplies the missing
orientation information.

---

#### The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and Conference-Matrix Rigidity

[PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [Repository](https://github.com/tavisrudd/clebsch-passages) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Standout results.** Hitchin's incidence cover has exact function field
Q(P(H))(√(5J₀)) and finite Stein equation z² = 5J₀. Relative to a marking
datum, its marked conference pair has four equivalent operator descriptions
and returns as the degree-six Gaunt multiple −784000σ₃/1247103. Exchange
rigidity and sharp two-graph reconstruction are independent consequences.

> *Abstract* Let H be the rational seven-space of harmonic cubics. Hitchin's icosahedral incidence variety is generically a degree-two cover of P(H). We prove three groups of results. First, its function field is Q(P(H))(√(5J₀)), where J₀ is the rational equation of the reduced branch sextic normalized by ιₜ*J₀ = 16σ₃² on the Clebsch chart. The complete reduced fibre over [xyz] has residue algebra Q(√5) and determines the twist; the finite Stein algebra is O ⊕ O(−3) with multiplication z² = 5J₀.
>
> Second, after an ordering, chart lift, outer labels, and Petersen labels are fixed as a marking datum, the two sheets correspond to the marked conference pairs (C,Z) and (−C,−Z); the sheet alone supplies none of that marking. The triangle-product cubic and its six outer translates admit four equivalent descriptions—triangle-product formula, middle-exterior diagonal, commutator Pfaffian, and oriented spectral-block determinant—giving the signed Joubert–Segre–Igusa–Clebsch chain. For a real symmetric zero-diagonal matrix with nonzero off-diagonal entries, nonzero proportionality of its commutator Pfaffian to its triangle cubic forces n = 6 and A² = λI. In the equal-modulus case this identifies the pentagon conference class up to scale, switching, and relabelling. Under the marked Petersen pair-sum comparison, the degree-six zonal-harmonic cubic restricts exactly to −784000σ₃/1247103: a relative sign comparison between cubics on different spaces, not an identification of their ambient harmonic representations.
>
> Third, independently of Hitchin's cover, cut-independence of the balanced exchange spectrum singles out order six. For n ≥ 7, the single bit recording whether each four-set is aligned reconstructs every two-graph up to complement, and the bound is sharp; hence the determinant-(−3) four-blocks recover every symmetric conference signing of order at least ten up to switching and global negation. The characteristic-zero incidence theorem is independent of the unresolved problem of determining the exact finite set of primes over which the geometric incidence comparison spreads out.
>
**Delivers.** The exact arithmetic incidence cover selects a relative marked
conference pair, whose cubic is tracked through triangle products, exterior algebra,
Pfaffians, determinants, classical invariant theory, and degree-six harmonics.
Exchange rigidity and two-graph reconstruction remain complete independent
consequences of the same carrier.

**Who cares.** Algebraic geometers, representation theorists, finite
geometers, and mathematical physicists.

**Why it matters.** Complementary descriptions make different aspects of the
same structured calculation visible. *Chordal and Conference Cubics:
Reconstruction and a Residual C₂-Torsor* determines their precise relation:
the cubic from *Quadratic Trade Rigidity and Cubic Orientation in Conic
Matching Quotients* is a distinct chordal companion of the conference cubic,
not the same cubic in different coordinates.

---

#### Reconstructing PG(2,13), its conic, and polarity from the minimum words of a binary conic code

[PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [Repository](https://github.com/tavisrudd/q13-passant-code) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21783970-blue.svg)](https://doi.org/10.5281/zenodo.21783970)

**Standout result.** The 364 minimum words of the [78,36,12]₂ passant-line
code reconstruct the marked projective plane PG(2,13), including its conic
and polarity.

> *Abstract* Let C be a nonsingular conic in PG(2,13), and let K be the binary column nullspace of its passant-by-internal incidence matrix: vectors on internal points annihilated by that matrix. We prove that the code has parameters [78,36,12]₂ and exactly 364 minimum words. Their weighted pair concurrences alone reconstruct the passant incidence matrix, the code, and the six-class elliptic association scheme. The resulting group action then reconstructs all points and lines of PG(2,13), the distinguished conic, and its polarity; no coordinates or triple concurrence are required. Equivalently, the weighted 2-section of the minimum-support hypergraph is a complete invariant of this marked conic-plane presentation. The four minimum-word families are one octahedral family and three chord-indexed punctured-conic families, and each spans the code. The binary relation algebra acts on the code through a scalar field F₈, making it twelve-dimensional over that field; the four orbit Grams are nonzero scalars. This marked action is recovered from pair data. An exact positive semidefinite certificate excludes weight eight; a line moment followed by exact stabilizer exhaustion excludes weight ten.
>
**Delivers.** The minimum-weight codewords of a binary code built from the
passant lines of a conic over the field with thirteen elements reconstruct the
code and the marked projective plane that produced it.  The paper also
determines the code's minimum distance and coordinate symmetries.

**Who cares.** Coding theorists and finite geometers interested in inverse
problems, minimum-weight structure, and the information retained by a code.

**Why it matters.** A small layer of codewords retains enough incidence data to
recover a much richer geometric object.  The result supplies a q=13
reconstruction counterpart to *Reconstructing the Clebsch Code from Its
Deep-Hole Syndrome Locus*.

---

#### Chordal and Conference Cubics: Reconstruction and a Residual C₂-Torsor

[PDF](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf) · [Repository](https://github.com/tavisrudd/chordal-conference-reconstruction) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21895530-blue.svg)](https://doi.org/10.5281/zenodo.21895530)

**Standout result.** The signed cubic from *Quadratic Trade Rigidity and Cubic
Orientation in Conic Matching Quotients* is a chordal Hankel companion, not
the conference cubic of *Reconstructing the Clebsch Code from Its Deep-Hole
Syndrome Locus* and *The Clebsch Cubic: Hitchin’s Icosahedral Double Cover and
Conference-Matrix Rigidity*. Its singular quartic recovers the original
six axes. Selecting one chordal line and one conference sign gives mutually
inverse reconstruction maps; forgetting the chordal line is a residual
`C₂`-torsor distinct from the global-negation torsor `{[B],[-B]}`.

> *Abstract* Different lossy invariants of the same source need not have the same geometry. Let Ω be the six Sylow-5 subgroups of A₅ and V the five-dimensional augmentation module of F₁₁^Ω with its standard quadratic form. The A₅-invariant cubic pencil in P(V) contains a conference cubic with exactly six isolated nodes and two chordal cubics, each singular along a rational normal quartic; over the algebraic closure of F₁₁ the conference cubic is not projectively isomorphic to either chordal cubic. We prove that they nevertheless recover the same marked six-axis carrier. From the singular quartic we recover the constant double cover A₅/C₅ → Ω = A₅/D₁₀. If either chordal line L of the invariant pencil is selected, we construct from the outer involution q mutually inverse reconstruction functors between a normalized chordal generator h ∈ L and a chosen-sign conference generator c over every neutral scalar extension of F₁₁. Forgetting L is exactly the free quotient (L,h,c) ↦ (qL,−qh,c), which fixes c: a residual C₂-torsor distinct from the global-negation torsor {[B],[-B]}.
>
> We also prove an intrinsic six-point recognition criterion. If a Seidel matrix S represents a two-graph Δ on a six-set, with triple signs σ(xyz) = SxySyzSzx, pair defects m(xy) = ∑z∉{x,y} σ(xyz), and A(Δ) the family of four-sets with constant triple sign, then 16|A(Δ)| = ∑{x,y} m(xy)², so A(Δ) is empty exactly when S² = 5I.
>
> Finally, for every normalized symmetric conference matrix B of order n ≡ 2 (mod 4), we determine the least φ = (I+B)/2-stable lattice containing Zⁿ, namely Dₙ∨ = Zⁿ + Z1/2, and the algebra F₂[φ̄] it induces on Dₙ∨/2Dₙ∨: F₄ for n ≡ 6 (mod 8) and F₂ × F₂ for n ≡ 2 (mod 8). At n = 6 the binary heart is the natural F₄A₅-module H; the map [B] ↦ φ̄|H identifies {[B],[-B]} with {ω,ω²} ⊂ F₄, and global negation acts by Frobenius, an equivariant identification of principal C₂-torsors.

**Delivers.** The nonisomorphic chordal and conference cubics recover the same
six-axis carrier. A selected chordal line and conference sign give reversible
reconstruction, while the residual chordal-line torsor and the separate
global-negation/Frobenius torsor are determined explicitly.

**Who cares.** Invariant theorists, algebraic combinatorialists,
representation theorists, and readers interested in reconstruction from
singular loci.

**Why it matters.** Nonisomorphic cubic singular loci can recover the same
carrier, and the exact residual markings can themselves be identified.

---

#### Computational Strengthenings of Clebsch Syndrome Rigidity — companion

[PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity_computational_companion.pdf) · [Repository](https://github.com/tavisrudd/clebsch-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Standout result.** An exact finite classification finds only the F₅
four-frame and the F₁₁ Clebsch six-arc among conic-filling arcs through eight
points.

**Delivers.** Exact finite computations and strengthened census results support
*Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus*, with
reproducible verification material.

**Who cares.** Readers checking finite classifications, computational
geometers, and anyone who wants independently replayable evidence.

**Why it matters.** The companion separates structural arguments from
exhaustive checks and makes delicate finite claims inspectable.

It is housed in the `clebsch-rigidity` repository rather than in a separate
public mirror.

*Companion abstract.* For a projective arc A ⊂ PG(2,q), let U(A) be the points on no chord of A. The geometric paper proves, without an exhaustive classification of six-arcs over F₁₁, that a six-arc in PG(2,11) whose uncovered locus lies on a conic is the Clebsch hexagon. Here exact finite computation sharpens and extends that result. There are fifteen projective classes of six-arcs over F₁₁; the Clebsch class is the unique one whose uncovered locus is contained in a cubic, and it is separated from every other class by a four-point gap in uncovered-set size. A Sylvester-graph obstruction shows that q = 11 is the only field order admitting a conic-filling six-arc. Exhaustive orbit searches then classify all conic-filling arcs through eight points: only the projective four-frame over F₅ and the Clebsch six-arc over F₁₁ occur. The companion also preserves the original q = 13 computations underlying *Reconstructing PG(2,13), its conic, and polarity from the minimum words of a binary conic code*, which gives the passant-code reconstruction theorem a standalone structural and reproducible account. The finite claims are accompanied by exact replay routes and a claim-by-claim trust ledger.

---

### Further Geometry, Coding Theory, and Quantum Information Papers

#### Reconstructing projective frames from their continuation graphs

[PDF](https://github.com/tavisrudd/continuation-graph-rigidity/blob/main/continuation_graph_rigidity.pdf) · [Repository](https://github.com/tavisrudd/continuation-graph-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22651105-blue.svg)](https://doi.org/10.5281/zenodo.22651105)

**Standout result.** For every prime power `q ≥ 13`, every isomorphism between
four-frame continuation graphs extends uniquely to a semilinear equivalence
of the underlying planes carrying one frame to the other. The graph determines
`q`; recognition over a supplied finite field is polynomial-time and returns
an independently checkable coordinate certificate.

> *Abstract* Four points with no three collinear in the projective plane PG(2,q) determine a graph on the points that can be adjoined without creating three collinear points; two vertices are adjacent when they cannot be adjoined together. For q ≥ 13, we prove that every isomorphism between these uncoloured graphs extends uniquely to a semilinear equivalence of the frames. The graph also determines q. The proof recovers the legal points on each tangent line, groups these lines by their selected point, then uses compatibility between multiplication and translation to recover the field action. Completing a punctured division table makes the reconstruction algorithmic and gives polynomial-time recognition over a supplied finite field, with an independently checkable coordinate certificate. An exhaustive finite computation closes the range 5 ≤ q < 13: semilinear rigidity holds at q = 7,9,11, whereas q = 5,8 each have exactly two resolutions into four parallel classes of cliques, and the semilinear subgroup has index two in the full automorphism group. The stable-range proof is independent of this computation.

**Delivers.** Reconstruction of the plane and its four-point frame from
pairwise conflicts, unique extension of each graph isomorphism, a recognition
algorithm with coordinate certificates, and exact small-field exceptions.
The uniform proof is written mathematics; the finite census is independently
replayed computation, and no Lean formalization is claimed.

**Who cares.** Finite geometers, algebraic combinatorialists, and coding
theorists studying graph recognition, incidence reconstruction, or isometries
of nonlinear codes.

**Why it matters.** Erasing the points' coordinates and retaining only which
pairs cannot coexist still leaves enough information to recover the plane
and the selected frame in this family. The small-field exceptions identify
precisely how extra graph symmetries can survive. The coordinate certificate
makes a proposed reconstruction easy to check independently of how it was
found.

---

#### Frobenius-equivariant Pair Extension and Robust Repair of Eight-Arcs

[PDF](https://github.com/tavisrudd/equivariant-robust-completion/blob/main/equivariant-robust-completion.pdf) · [Repository](https://github.com/tavisrudd/equivariant-robust-completion) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051735-blue.svg)](https://doi.org/10.5281/zenodo.22051735)

**Standout result.** Every Frobenius-invariant eight-arc over every prime-power
base order `s ≥ 5` admits a fresh nonfixed conjugate-pair extension. Over
`F₂₅` there are at least four legal pairs, and the exceptional two-fixed-point
profile has exact minimum 32; for `s ≥ 7` there are at least 319 legal pairs.

> *Abstract* Let φ be the quadratic Frobenius involution of PG(2,s²). We study
> extensions of φ-invariant arcs by fresh nonfixed conjugate pairs, or
> equivalently Frobenius-compatible two-column extensions of the associated
> dimension-three MDS codes. Every pair lies on a unique fixed mate line.
> Counting pairs carrier by carrier gives a uniform lower bound, and an exact
> correction records secant orbits that disappear at fixed centers and visible
> orbits that collide on one candidate.
>
> Every invariant eight-arc over every prime-power base order s ≥ 5 admits
> such an extension. Over F₂₅ there are at least four legal pairs; the
> exceptional two-fixed-point profile has exact minimum 32. For s ≥ 7 there
> are at least 319 legal pairs. These bounds yield alternate repairs after
> deletion of a selected orbit, and a parameterized criterion gives the
> corresponding result for invariant (k+2)-arcs. The structural reductions
> have human-scale Lean support. A separate Mathlib-only certificate checks
> the normalized exceptional census; the projective normalizations and
> semantic transport are manuscript arguments.

**Delivers.** A carrierwise theory of Frobenius-compatible paired extension,
an exact invisible-center and collision correction, uniform extension and
alternate-repair bounds, and an exact normalized classification of the
exceptional two-fixed-point minimum over `F₂₅`.

**Who cares.** Finite geometers, coding theorists studying MDS extension and
puncturing, and researchers interested in symmetry-constrained completion or
formally checked finite classifications.

**Why it matters.** Ordinary point extension does not ensure that a point and
its Frobenius conjugate are jointly legal. The mate-line quotient exposes the
extra obstruction, while the correction terms measure exactly where a naive
first-order count loses information. The resulting multiplicity bounds give
robust replacement of generator-column pairs rather than erasure decoding in
a fixed code.

---

#### Exact Compositional Transfer of Bounded Linear Recovery

[PDF](https://github.com/tavisrudd/compositional-recovery/blob/main/compositional_recovery.pdf) · [Repository](https://github.com/tavisrudd/compositional-recovery) · [ergodis](https://github.com/tavisrudd/ergodis) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

**Standout result.** Labelled recovery costs determine the exact first equation escape cost and compose associatively; retaining minimizing lifts reconstructs coefficient witnesses. If every outer dual word touching the target
block has weight greater than `r+1`, every inclusion-minimal recovery support of size at
most `r` is local. This requires no inner-dual-distance condition and transfers
reliability under availability laws with the same local marginal, as well as fractional
and integral support allocations.

> *Abstract* We study which local recovery information suffices to compose bounded
> linear repairs through concatenated codes. The least helper count alone is
> insufficient: composition also requires the functional supplied by each local choice.
> We determine the exact minimum helper cost of a recovery system that leaves its target
> block, and prove an associative composition law that reconstructs coefficient
> witnesses from local choices. Equation escape need not create a new repair option,
> because external coefficients can be dispensable. If every outer dual word touching
> the target block has weight greater than `r+1`, all inclusion-minimal recovery
> supports of size at most `r` remain local, without an inner-dual-distance condition.
> This preserves the available bounded repair choices and transfers reliability under
> arbitrary availability laws with the same local marginal, as well as fractional and
> integral support allocations. Equation confinement and confinement of minimal repairs
> therefore have different requirements.

**Delivers.** An exact equation escape cost, associative labelled composition
with recovery witnesses, and a sufficient condition confining every bounded
minimal repair support. A complete multilevel example follows local labels
through helper failure and reconstruction. The paper-local Lean companion
covers only the associated-pair exact sequence; the confinement and composition
results have human proofs and remain outside its formal coverage.

**Who cares.** Coding theorists studying concatenation and local recovery;
distributed-storage researchers choosing repairs under failures or shared helper
capacities; and optimization researchers working with structured linear repairs.

**Why it matters.** An equation can use external helpers without creating a
useful new repair. Distinguishing equations, support alternatives, and their
minimum costs identifies which information must survive composition and which
locality guarantees preserve the available repair choices.

---

#### Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold

[PDF](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf) · [Repository](https://github.com/tavisrudd/blown-up-theta-lattice) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22036585-blue.svg)](https://doi.org/10.5281/zenodo.22036585)

**Standout result.** The blow-up resolution of the cubic-threefold theta
divisor exhibits two distinct integral coefficient defects.  Its rank-130
middle lattice has a canonical `(Z/2)^10` saturation quotient, while its
integral direct image has central map `Z --(-3)--> Z`.  Modulo three the
residual perverse factor is uniserial of length three, and relative hard
Lefschetz fails.

> *Abstract* Let Θ be the theta divisor of the intermediate Jacobian of a
> smooth complex cubic threefold, and let σ: M = Bl₀Θ → Θ be its resolution.
> We compute the integral middle lattice IH³(Θ,Z): it is free of rank 130,
> and its Lefschetz saturation quotient is (Z/2)¹⁰. The Fano difference map
> identifies the glue and its dual escape lattice. We determine Rσ_*Z_M[4],
> split off two point objects over Z and prove that the residual perverse
> factor has central map Z → Z given by multiplication by −3. It acquires a
> third point summand after inverting three, but none integrally; modulo three
> it becomes length-three uniserial. Finally, we lift the local order-three
> link class to an infinite-order Fano class and prove that ordinary and
> intersection cohomology agree in degrees at least four. The factor three
> also forces relative hard Lefschetz to fail modulo three.

**Delivers.** An integral middle-lattice theorem with geometric Fano-labelled
glue; the complete integral point-summand decomposition and central
attachment of the resolution complex; the exact mod-three Loewy chain; a
modular relative-hard-Lefschetz counterexample; and the global fate of the
local order-three link class.

**Who cares.** Algebraic geometers and topologists working on cubic
threefolds, intermediate Jacobians, theta divisors, integral intersection
cohomology, perverse sheaves, or modular decomposition phenomena.

**Priority boundary.** The paper's claim ledger records “cubic-theta integral
object and central Smith factor retained,” “canonical `delta_0`--`IC`--
`delta_0` filtration and both nonsplit extensions retained,” and “explicit
multiplier three and failure over `F_3` retained.”  The manuscript separately
credits the general rational intersection-form, modular rank, and
small-extension frameworks on which the example-specific calculation sits.

---

#### Standard Flips of Discrepancy One: Extremal J-Normalization and the Meijer Aperture at ν=1

[PDF](https://github.com/tavisrudd/discrepancy-one-flips/blob/main/discrepancy_one_flips.pdf) · [Repository](https://github.com/tavisrudd/discrepancy-one-flips) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21924798-blue.svg)](https://doi.org/10.5281/zenodo.21924798)

**Standout result.** Shen and Shoemaker's extremal quantum-spectrum and
Gamma-class argument extends through the omitted discrepancy-one range
`r = s + 1`, `s ≥ 1`, including every codimension-two blow-up.

> *Abstract* Shen and Shoemaker compute the extremal quantum spectrum of a standard flip `X ⇢ X'` with exceptional locus `P(V) ⊂ X`, `rank V = r`, `rank V' = s`, and show that the Gamma-class decomposition of `H*(X)` attached to the Belmans--Fu--Raedschelders semiorthogonal decomposition is a decomposition into asymptotic classes. Their Theorem 4.4, which identifies an explicit hypergeometric series with the extremal `J`-function of the local model, assumes `r-s>1`; their Remark 4.5(3) asserts that for `r-s≤1` the series is not `J`-normalized; and the Barnes asymptotic expansion of their Section 7 is applied under the same inequality. Their Theorem 1.2 is printed only for `r-s>1`, while their Theorems 1.4, 9.9 and 9.14 and their Corollary 1.5 are stated in a range that includes blow-ups. The printed proof chain for these later statements does not reach the discrepancy-one case `r=s+1`, `s≥1`, which contains every codimension-two blow-up.
>
> We supply the two missing steps. First, the degree-`d` summand of their formula (35) has `z`-order at most `1-s-(r-s)d`; for `r=s+1` and `s≥1` this is at most `-1` for every `d≥1`, so the series is `z1+t̄+O(z⁻¹)`, with `1` the unit class and `t̄ = t + ln(q)c₁(T)` the extremal parameter; no mirror-map correction arises, and uniqueness of the `J`-slice of Givental's cone identifies the series with the extremal `J`-function. We prove the cone membership that this uses instead of quoting Remark 4.5(3) for it, whose printed attribution passes through a lemma of their Section 9 that presupposes Theorem 4.4: for split bundles it follows from Brown's toric-fibration theorem together with the twisted theory of Coates and Givental, and the general case follows by a flag-bundle pullback and a deformation to the associated graded. None of these inputs restricts `r-s`. The only remaining formal failure of the normalization is the degenerate endpoint `(r,s)=(1,0)`, whose point fibres contain no extremal line. Second, at `ν:=r-s=1` the sector printed after their Lemma 7.4 is unavailable: their own Theorem A.1 is valid on `|arg t|<(ν+ε)π` with `ε=1` only for `ν>1` and `ε=1/2` at `ν=1`, and the correct `ε=1/2` sector still meets the sector of their Proposition 8.2 in an open sector of opening `2π` that contains both the nonzero-eigenvalue ray and the tame ray. Once these repaired inputs are supplied, their Sections 9.1--9.4 impose no further restriction on the discrepancy, and Theorems 1.2, 1.4, 9.9 and 9.14 and Corollary 1.5 extend to every standard flip with `r=s+1` and `s≥1`. No other part of the standard-flip argument is altered: the correction is confined to the `J`-normalization of the extremal hypergeometric series and to the Barnes aperture at `ν=1`.

**Delivers.** A source-local correction: the missing `I`-to-`J`
normalization, a proof of the cone membership the source only asserts, the
correct Meijer aperture at `ν=1`, and a precise account of the formal
rank-one projective-bundle endpoint, whose fibres contain no extremal line.

**Who cares.** Algebraic geometers working on quantum cohomology, standard
flips and blow-ups, Gamma classes, semiorthogonal decompositions, or Meijer
asymptotics.

**Why it matters.** The omitted range is geometrically basic: it includes
every codimension-two blow-up. The repair proves the cone membership that
the source only asserts, uses the source's own Appendix A for the sector, and
changes no higher-discrepancy statement.

---

#### Hodge Atoms as Occurrence-Indexed Marker Ledgers

[PDF](https://github.com/tavisrudd/hodge-atom-marker-ledger/blob/main/hodge_atom_marker_ledger.pdf) · [Repository](https://github.com/tavisrudd/hodge-atom-marker-ledger) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22036390-blue.svg)](https://doi.org/10.5281/zenodo.22036390)

**Standout result.** The standard abstract Hodge-atom chemical formula is the
universal fold of an occurrence-indexed thin groupoid.  Killing atom classes
carried in dimension at most `d - 2` produces an effective quotient that is
birationally invariant by weak factorization, and the resulting obstruction
is stated only for one rank-two projective-bundle step.

> *Abstract* Hodge atoms are defined from connected components of the reduced unramified Euler spectral cover of a maximal non-archimedean A-model F-bundle, followed by elementary identifications supplied by disjoint unions, blowups, and projective bundles. We isolate the categorical mechanism behind this construction. Expanding the degree of each spectral component into labelled occurrences, we form the thin groupoid generated by the elementary correspondences and the free commutative monoid on its connected components. Its universal fold recovers the Hodge-atom chemical formula, makes the three operation laws formal, and separates the abstract atom quotient from the generally coarser quotient by isomorphism of geometric atomic F-bundles. Killing the generators carried in dimension at most d − 2 gives an effective quotient in which weak factorization makes the ledger birationally invariant for smooth projective d-folds. As a one-step consequence, if an atom of a smooth n-fold cannot be carried in dimension at most n − 1, then every rank-two projective bundle carrying that occurrence is irrational. All quantum-cohomological comparison results enter only through an explicit provider record.

**Delivers.** A compact categorical proof spine for standard Hodge atoms,
including the occurrence carrier, effective monoid, operation folds,
dimension filtration, and exact abstract-to-geometric type boundary.

**Who cares.** Algebraic geometers working on Hodge-theoretic birational
invariants, quantum cohomology, weak factorization, or stabilization problems.

**Why it matters.** It makes multiplicity and effectivity explicit, isolates
the cited quantum-cohomological providers from the formal ledger argument, and
shows exactly what the standard atom construction proves after one rank-two
projective-bundle step.

---

#### Secant defects with prescribed holes: arcs, caps, and matching designs

[PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [Repository](https://github.com/tavisrudd/arcs-complete-outside-conic) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682567-blue.svg)](https://doi.org/10.5281/zenodo.21682567)

**Standout result.** A universal pointwise secant-defect identity turns zero
defect into maximum-matching-design rigidity and gives explicit stability; its
principal conic application yields a quantitative lower bound and exact small
orders.

> *Abstract* We prove that if H is any prescribed set of q + 1 points in a finite projective plane of order q, then every arc A disjoint from H whose secants cover all points outside A ∪ H satisfies |A| ≥ √(2q) + 3/2 − 8/√(2q). Thus even after exempting q + 1 points from coverage, the bound retains the classical √(2q) scale with additive term 3/2 − o(1). More generally, the first two secant moments yield an exact defect identity with nonnegative local summands. At zero defect, each concurrency class containing at least two secants is a maximum matching, and these classes form a simple MATCH(k,⌊k/2⌋,1) design. In Desarguesian planes, the arc realizes this design by concurrent chord families; the defect also gives quantitative deletion stability.
>
> For a nonsingular conic C ⊂ PG(2,q), let ρC(q) denote the corresponding minimum. In characteristic two, a C-complete zero-defect arc with odd k ≥ 7 is an oval of size q + 1 whose nucleus lies on C, while even k ≥ 6 forces k = q + 2, hence a hyperoval. A kernel-checked classification gives ρC(16) = 9; exhaustive classifications with kernel-checked attaining witnesses give ρC(13) = 8, ρC(17) = 9, and ρC(19) = 10. The defect identity, equality criterion, and deletion stability are independently formalized in Lean.
>
**Delivers.** An exact counting identity governs arcs relative to any prescribed
set of points allowed to remain uncovered.  It gives matching-design rigidity
and stability in every finite projective plane, a conic-relative lower bound,
and several exact small-field values.

**Who cares.** Finite geometers, design theorists, and researchers studying
projective planes or extremal configurations.

**Why it matters.** A visual covering problem becomes a sharp defect
calculation, with zero defect forcing rigid exceptional cases.  The
secant-moment identity proved here, valid in every finite projective plane and
for every prescribed hole set, is the general form of the chord-defect identity
used in the rigidity theorem of *Reconstructing the Clebsch Code from Its
Deep-Hole Syndrome Locus* above. That relationship is a
specialization of the identity, not a claim that the Clebsch hexagon has zero
defect in the present paper's matching-design sense.

---

#### Integral Secant Distributions and Line-Code Obstructions for Complete (k,n)-Arcs

[PDF](https://github.com/tavisrudd/integral-secant-arcs/blob/main/integral_secant_arcs.pdf) · [Repository](https://github.com/tavisrudd/integral-secant-arcs) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22087679-blue.svg)](https://doi.org/10.5281/zenodo.22087679)

**Standout result.** Exact integer degree envelopes for all maximal secants
give a divisor-indexed linear improvement over the classical incidence bound.
On characteristic-compatible branches, modular stability and completeness
yield further linear terms. Centering at that bound produces a ternary
line-code word; two shell inequalities force the three-line phase boundary
and give `t_{2q/3+1}(2,q) ≥ q²/3 + 5q/3 − o(q)` over `q = 3^h`.

> *Abstract* We study complete `(k,n)`-arcs through the numbers of maximal secants incident with each point. Splitting the exact block-pair count between the arc and its complement gives sharp integer bounds for both degree sequences; their real relaxation recovers the classical incidence bound. On every rational equality family with integral limiting degrees, the integer remainders give a positive linear improvement. For each factorization `lambda=uv`, we make this improvement explicit when every external point lies on at least `lambda` maximal secants. On characteristic-compatible families, near equality forces bounded modular repair, and completeness converts each repair point into further linear excess. In characteristic three, exact moment identities produce a small-weight word in the projective-plane line code. Its short line representation and two integer-shell inequalities prove `t_{2q/3+1}(2,q) ≥ q²/3+5q/3-o(q)` for `q=3^h`. An analogous parity argument improves the characteristic-two bound under double maximal-secant coverage. The integer theorem also applies to selected blocks of symmetric designs and to minimal multiple blocking sets and nonextendible projective codes.

**Delivers.** A general integer incidence theorem for selected blocks of a
symmetric design, its maximal-secant specialization, the complete
factor-pair classification of the integral rational equality families, a
bounded-edit modular stability theorem for every characteristic-compatible
family, a ternary three-line phase boundary and near-extremal rigidity, and a
characteristic-two modular-lift bound.

**Who cares.** Finite geometers studying complete higher arcs and multiple
blocking sets, design theorists working with incidence inequalities, and
coding theorists studying nonextendible projective codes.

**Why it matters.** The usual quadratic incidence estimate is the real
relaxation of an exact integer problem. Retaining both degree distributions
reveals arithmetic penalties that the real estimate discards. A classical
two-character duality corollary also reconstructs an exact arc and its full
maximal-secant family from the high-character lines.

---


#### Exact Transversal Logical Groups of Quantum MDS–CSS Codes

[PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [Repository](https://github.com/tavisrudd/mds-css-transversal-groups) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766797-blue.svg)](https://doi.org/10.5281/zenodo.21766797)

**Standout result.** A zero-or-one-dimensional code-conductor test determines which
projective transversal logical group an odd-prime MDS–CSS code supports.

> *Abstract* Transversal gates implement encoded operations by tensor products of single-qudit unitaries. We determine the exact projective transversal logical group for the quantum MDS–CSS codes associated with linear [2m,m,m+1]q maximum distance separable codes over odd prime fields, allowing the one-qudit gate to depend on the coordinate. The classification reduces to the code conductor Cond(C,C⊥) = {s ∈ Fq²ᵐ : s⋆C ⊆ C⊥} = (C^(⋆2))⊥, where ⋆ denotes coordinatewise multiplication and code products are linearly spanned. The half-rate MDS hypotheses force this space to have dimension zero or one. The exact logical group is Fq² ⋊ T in the zero-dimensional case and Fq² ⋊ SL₂(q) in the one-dimensional case, where T = {diag(a,a⁻¹) : a ∈ Fq×} is the diagonal determinant-one subgroup, also called a split torus. Thus the codimension of the Schur square determines all transversal logical unitaries. The corresponding coordinatewise CSS endomorphism algebra is Fq×Fq or M₂(Fq). The construction is explicit, and an imported rigidity theorem for stabilizer absolutely maximally entangled states excludes non-Clifford product implementations.
>
> For length six, the nonzero-conductor branch is equivalent to the six parity-check points lying on a conic. On a stated regular locus of an explicit non-GRS pencil, a degree-eight invariant classifies projective and monomial-code equivalence over odd fields and local-Clifford and local-unitary equivalence over odd prime fields. These geometric applications are independent of the all-length proof.
>
**Delivers.** A classification of the diagonal rescalings that make a code
match its dual, together with the logical operations that can then be performed
independently across its physical locations.

**Who cares.** Quantum-information and quantum-coding specialists studying
stabilizer codes, transversal gates, and logical symmetries.

**Why it matters.** Transversal operations are valuable because they act
independently on separate physical systems.  The result identifies exactly
when the larger symmetry group is available and when only a smaller subgroup
survives.

---

#### Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy

[PDF](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf) · [Repository](https://github.com/tavisrudd/conference-cut-spectra) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766747-blue.svg)](https://doi.org/10.5281/zenodo.21766747)

**Standout result.** Order six is the unique nontrivial symmetric conference
order whose normalized balanced cross-block Gram spectrum is independent of the
cut. In the Hermitian order-six problem, squared real triangle holonomy
parametrizes the complete degree-three Pareto frontier and quantitatively
controls rigidity relative to the real switching class.

> *Abstract* Let C be a symmetric conference matrix of order 2d, put q = 2d − 1, and for a balanced half Y write R = C[Y,Yᶜ]. We study the exchange spectrum spec(RRᵀ/q) and prove that it is independent of Y exactly when d ≤ 3. Since the order-two case is trivial and no symmetric conference matrix of order four exists, order six is the unique nontrivial case; its spectrum is {1/5, 4/5, 4/5}. For the associated diagonal-control transfer, the twenty balanced sign vectors in {±1}⁶ are exactly the maximizers of each degree-three Schur sector over [−1,1]⁶.
>
> For Hermitian conference matrices of order six, the conference identities fix the first two exchange moments, while squared real triangle holonomy parametrizes the complete Pareto frontier of the three degree-three sectors. Cutwise constancy of any one sector holds exactly for matrices equivalent, under switching and permutation, to a real symmetric conference matrix. An averaged squared-holonomy defect bounds the Frobenius distance from that class globally from below and locally from above. We interpret the order-six transfer through a conference interferometer, separating intrinsic, oriented, and calibrated observables and identifying the external resource required for direct three-fermion emulation; this is a theory and design-limit analysis, not a report of a built device. In arbitrary real dimension, singular values classify unframed port transfers; for invertible transfers, orientation adds exactly the determinant sign, and the determinant is, up to scale, the unique minimal-degree orientation-covariant polynomial.
>
**Delivers.** A classification of symmetric conference matrices with
cut-independent balanced cross-block spectrum; an exact continuous-control
optimum at order six; a Hermitian holonomy parametrization of the complete
degree-three Pareto frontier; and quantitative rigidity relative to the real
switching class. The conference interferometer is an application of these
matrix results.

**Who cares.** Matrix theorists, algebraic combinatorialists, frame theorists,
mathematical physicists, and quantum-information researchers studying
structured transfer spectra.

**Why it matters.** Uniformity over every balanced cut is rigid rather than a
generic conference-matrix phenomenon. At the exceptional order, triangle
holonomy becomes an exact deformation coordinate: it controls the exchange
tradeoff, detects the real switching class, and supplies a metric defect. The
interferometric model shows how the same hierarchy separates intrinsic,
oriented, and calibrated observables.

---

#### Strength-two trades and transversal cubic gates: the Clebsch cubic-phase codes and their magic

[PDF](https://github.com/tavisrudd/clebsch-cubic-phase/blob/main/companion.pdf) · [Repository](https://github.com/tavisrudd/clebsch-cubic-phase) · [![Concept DOI](https://img.shields.io/badge/Concept_DOI-10.5281%2Fzenodo.22666172-blue.svg)](https://doi.org/10.5281/zenodo.22666172)

**Standout result.** Two signed point sets that agree on every quadratic
polynomial define an error-detecting qudit code whose surviving third moment is
a transversal logical cubic phase. The ten-qudit phase state of the
`[[22,10,2]]₁₁` conic code is not Clifford-equivalent to a product state across
any bipartition, and for the `[[14,6,2]]₇` conic code joint preparation of the
whole block costs fewer than `16.116` raw inputs per accepted block against
lower bounds of `54`, or `36` when all weighted cubic types have unit cost.

> *Abstract* Can a symmetric point configuration define a multiqudit phase resource whose structure and preparation cost can both be certified? We study this question through strength-two signed trades: cancellation of their quadratic moments makes the third moment a transversal logical phase. Conic matchings give error-detecting codes with binary-invariant logical cubics, while an elementary translation trade supplies the same [[2p,p−1,2]]_p parameters at every prime p ≥ 5. Exact Hessian-rank censuses identify the conic resources through their Pauli spectra. The ten-qudit example over F₁₁ is not Clifford-equivalent to a product across any bipartition. For the six-qudit example over F₇, joint preparation beats a specified independent primitive-distillation menu at the same target block infidelity: fewer than 16.116 raw inputs versus a lower bound of 54, or 36 when all weighted cubic types have unit cost. This comparison assumes independent uniform Z noise, ideal Clifford operations, and input error at most 1%. A chordal restriction of the logical phase explains how geometric sign choices act as gate inversion and changes of logical frame.

**Delivers.** A dictionary from strength-two signed trades to high-rate
error-detecting codes with transversal cubic logical gates; a translation
family realizing `[[2p,p−1,2]]_p` at every prime `p ≥ 5`; exact Hessian-rank
and Pauli spectra for the conic examples; a product-state fourth-moment
exclusion for the ten-qudit resource; a rational interval comparison of joint
preparation against a specified distillation menu; and an exact chordal
restriction identifying the Clifford action of the geometric sign choices.

**Who cares.** Quantum-coding theorists working on transversal gates and magic
resources, magic-state distillation researchers, and finite geometers
interested in configurations that carry logical structure.

**Why it matters.** The logical phase is specified by geometry rather than
chosen by hand, so the same finite data fix the code, its transversal gate, and
its Pauli spectrum. The resource comparison is stated with its model boundary
intact: it assumes independent uniform Z noise, ideal Clifford operations, and
input error at most one percent, and it is not an unrestricted protocol lower
bound. The preparation advantage shows that preparing a structured block
directly can beat assembling it from separately purified pieces.

---


## Verification philosophy

Verification is claim-level, not a single project-wide badge. A paper may use
several evidence modes at once:

1. an ordinary prose proof;
2. a cited result checked against its hypotheses and conventions;
3. a Lean kernel-checked component;
4. a certificate-checked finite computation; or
5. a trusted program execution or symbolic experiment.

These categories support one another but do not collapse into one another. A
certificate checks an output, not necessarily search completeness; Lean checks
the formal statement, not automatically its correspondence with prose; and a
computation can discover a pattern without proving it. The individual paper
repositories state these boundaries and retain exact replay information where
finite computation is essential. [VERIFICATION.md](VERIFICATION.md) routes
readers to each repository's claim-level evidence map.

## Contact and disclosure

I am an independent researcher without institutional affiliation. Specialist
review would be especially valuable for literature checks, classical-priority
questions, technical corrections, and identifying suitable arXiv endorsers.
An endorsement would mean informed support for making a manuscript available
for public scrutiny, not a substitute for peer review. Contact is welcome via
[my GitHub profile](https://github.com/tavisrudd).

This project was developed with extensive assistance from OpenAI Codex and
Anthropic Claude. Under my direction, the systems assisted with proof
exploration, literature research, symbolic and finite computation, code and
formal-proof development, verification, and manuscript drafting and revision.
I checked the resulting arguments, computations, code, and cited sources,
reviewed and edited AI-assisted material, and assume responsibility for the
content.
