# C898 — Paper I cold read, round 1: cubic geometry

**Frozen PDF:** `papers/clebsch-rigidity/clebsch_rigidity.pdf`  
**PDF SHA-256:** `95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`  
**Persona packet:** Packet C — Zhang/Hassett cubic read; algebraic geometer familiar with singular and determinantal cubic threefolds  
**Verdict:** **MAJOR**

## Initial human-proof report (frozen before supplement inspection)

### Strongest theorem I believe the paper proves

Starting from the reconstructed Clebsch syndrome geometry, the two support orbits determine an unordered balanced switching class represented by a symmetric sign matrix \(B\) with \(B^2=5I\). Its triangle products define a translation-invariant cubic \(C\) on \(\mathbf Q^6/\mathbf Q\mathbf 1\), and the diagonal determinant pencil recovers exactly the same cubic. Conditional on the singular-locus exhaustion asserted in the node-frame paragraph, \(C=0\) is the known six-nodal cubic threefold with projective automorphism group \(S_5\), while the chosen orientation cuts this to \(A_5\); the same operator gives the integral commutant \(\mathbf Z[B]\cong\mathbf Z[\sqrt5]\).

### Causal proof reconstruction

1. The twelve syndrome points form the \(A_5/C_5\) cover of the six axes \(A_5/D_5\). Either five-valent orbital acts on the fibre-odd lattice as a switched symmetric sign matrix \(B\).
2. After fixing one lift, the \(C_5\)-action puts the other five axes on a pentagon. Its side and diagonal signs are opposite, which gives \(B^2=5I\).
3. Triangle holonomy \(B_{ij}B_{jk}B_{ki}\) is switching-invariant. It is constant with opposite signs on the two complementary \(A_5\)-orbits of triples, hence gives the support cubic. The four-point identities recover the switching class from these coefficients, and pair balance recovers \(B^2=5I\).
4. The size-three principal minors are \(2B_{ij}B_{jk}B_{ki}\). Together with \(B^{-1}=B/5\), \(\det B=-125\), and Jacobi's identity, this determines every layer of \(\det(B+\operatorname{diag}x)\); the only nonsymmetric layer is \(-2C(x)\). Thus the pencil explains the cubic rather than merely renaming a polynomial check.
5. Splitting \(B\) over \(\mathbf Q(\sqrt5)\) gives the cross-golden \(3\times3\) family \(\Phi_x\) with \(\det\Phi_x=-C(x)\), paired by trace with a four-space defining a smooth Clebsch cubic surface. The manuscript then asserts that the five gradient quadrics have only the six axis classes as common projective zeros.
6. At each asserted axis point, the Hessian reduces to a switched \(5\times5\) principal minor \(M\) of \(B\). The identities \(Mu=0\) and \(M^2=5I-uu^T\) give rank four on the projective tangent space, so each such singularity is an ordinary double point.
7. Once the singular locus is exactly the six-point projective frame, every projective automorphism permutes it. The normalizer of the five matchings is \(S_5\), and its index-two \(A_5\) preserves the signed cubic rather than only its zero locus. Schur's lemma and Galois descent then give the rational and integral commutants.

### Earliest unsupported implication

The first load-bearing implication I cannot justify from the PDF is on page 21: after identifying derivatives of \(\det(\Phi_x)\) with the five gradient quadrics of \(C\), the text says that those quadrics vanish simultaneously only on the six centered axis vectors. The quadrics, an elimination, and a conceptual rank argument are all omitted. This is precisely the step that upgrades six exhibited singularities to the full geometric singular locus over an algebraic closure. The later Hessian calculation proves that the six exhibited points are ordinary nodes, but it does not exclude further singular points.

### Controlling findings

1. **Proof — major gap.** Singular-locus completeness is asserted rather than proved in human-readable mathematics. Because exact exhaustion is needed before the node frame can control all projective automorphisms, this gap propagates to the proof of \(\operatorname{Aut}_{\mathrm{proj}}(C=0)\cong S_5\). The statement is geometric over an algebraic closure in characteristic zero, not merely a claim about rational points, so checking six rational candidates is insufficient.
2. **Computation — trust boundary.** Section 8 labels the missing elimination “kernel-checked,” and Section 9 names formal declarations, yet Section 9 also says that no preceding conclusion is imported from the formal development. As written, singular-locus completeness is in fact dependent on that external check unless the omitted elimination is supplied. The paper should either make the formal theorem an explicit proof dependency or include a compact algebraic exhaustion in the text.
3. **Proof — satisfactory conditional node analysis.** Given completeness, the ordinary-double-point calculation is visible and convincing: the Hessian has only the translation and radial kernels before passage to projective augmentation space, hence induces a nondegenerate quadratic form of rank four. The six classes \([\mathbf1-6e_a]\) are rational and form a projective frame, so they satisfy the linear-general-position hypothesis used in the cited classification literature.
4. **Citation — hypotheses correctly fenced.** Cheltsov–Tschinkel–Zhang start with a cubic already known to be six-nodal in general linear position; the manuscript uses their \(S_5\)-equation only for model identification and does not reason backward from Proposition 7.3. Hassett–Tschinkel Proposition 10 is likewise presented as context: its smoothness/transversality equivalence is not silently used to prove the six nodes.
5. **Proof/exposition — determinant mechanism works.** The determinant pencil is explanatory: triangle holonomy supplies the size-three principal minors, while \(B^2=5I\) and complementary-minor duality force the symmetric degrees. This cleanly distinguishes preservation of the cubic hypersurface (\(S_5\)) from preservation of its oriented defining line (\(A_5\)); the paper is also clear that code automorphisms preserve the support orientation more rigidly than the full cubic automorphism group.

### Novelty relative to Packet C

Relative to the known six-nodal \(S_5\)-cubic and the Hassett–Tschinkel trace-dual determinantal construction, the new point is the intrinsic recovery of that cubic, its oriented \(A_5\)-subgroup, and its golden determinant pencil from decoder-support and syndrome data, not a new abstract cubic threefold or automorphism classification.

## Supplement postscript

After freezing the report above, I inspected and ran only the allowed public supplement, `papers/clebsch-rigidity/check_orientation_two_graph.py` (SHA-256 `fa6f415debda3fc5963b55933371ffcba8e1cd32a825581d6fe0b0d09a2b2c3b`). It completed successfully and reported `projective_nodes=6 ordinary_nodes=6 frame=ok aut_projective=120`.

The checker resolves the mathematical correctness concern about singular-locus completeness. It works over exact rational arithmetic, takes the unique quotient representative with \(x_0=0\), and covers projective space by five disjoint normalized strata according to the last nonzero coordinate. The resulting Gröbner bases are, successively, the empty basis in the zero-variable chart; the coordinate ideals in the next three charts; and


\[
y_1-y_4,\qquad y_2-y_4,\qquad y_3-y_4,\qquad y_4^2-y_4
\]

in the final chart. Thus the common gradient zeroes over an algebraic closure are the five coordinate points and the all-ones point, exactly the six axis classes. Independent exact-rank assertions then verify Hessian rank four, projective-frame general position, and stabilizer orders \(60\) and \(120\).

What remains is a defect of the human exposition and trust statement, not evidence that the theorem is false. The short chartwise Gröbner-basis certificate above would close the gap in a few lines if included in the paper. Until the PDF either includes that exhaustion or explicitly treats the checker/formal declaration as a load-bearing proof source, the initial **MAJOR** verdict remains unchanged.
