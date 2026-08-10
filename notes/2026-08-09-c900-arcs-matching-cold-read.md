# C900 sealed matching-design cold read

**Date:** 2026-08-09  
**Reviewer stance:** Ian Wanless/Brian Alspach design-theory reader  
**Verdict:** **MINOR**

## Scope and evidence boundary

This is a first-round cold read of only the prescribed-hole defect identity, its equality and stability consequences, the concurrency-design and one-block-short arguments, and the rank-three equality-classification appendix of `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`. I did not inspect the reviewer dossier, proof audits, trust manifest, previous reports, conic specializations, finite-field witnesses, or formal-verification discussion. I reviewed the human proofs and their exposition, not the computer-assisted elimination.

The matching-design reference was Brian Alspach and Katherine Heinrich, *Matching Designs*, cached as `dblp:journals/ajc/AlspachH90`, SHA-256 `1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`, checked against the authoritative scan. Their convention allows repeated blocks: a `MATCH(n,k,lambda)` is a collection of (k)-matchings of (K_n) in which every pair of independent edges occurs in exactly (lambda) members. Their two necessary counts are

\[
 b=\frac{\lambda\,\binom n2\binom{n-2}2}{2\binom k2}∈\mathbb Z,
 \qquad
 \rho=\frac{\lambda\binom{n-2}2}{k-1}∈\mathbb Z.
\]

They call the perfect-matching case a hyperfactorization and call a design nontrivial when the multiplicity is not constant over all possible (k)-matchings. They record that `MATCH(6,3,1)` is uniquely the trivial design, `MATCH(7,3,1)`, `MATCH(8,4,1)`, and `MATCH(12,6,1)` do not exist, and that Mathon found exactly two nonisomorphic `MATCH(10,5,1)` designs.

I also checked Reichard--Woldar's convention directly. Their `pg(K,R,T)` has (K) points on each line and (R) lines through each point. Thus their `pg(5,7,3)` is the common `pg(s,t,alpha)=pg(4,6,3)`.

## Strongest theorem and causal spine

The strongest fully human, field-free result in this packet is the prescribed-hole defect identity. For any (k)-arc and arbitrary prescribed hole set, it turns the two classical secant moments into an exact sum of nonnegative local terms. This simultaneously gives the coverage bound, characterizes equality, and supplies quantitative stability.

The causal spine is clean:

1. Count secant--external-point incidences and pairs of secants through an external point.
2. Split both moments between required points and holes, then factor the residual quadratic pointwise.
3. At zero defect, every nontrivial concurrence has maximum index (m=\lfloor k/2\rfloor).
4. Unique intersection of two disjoint secants partitions (E(KG(k,2))) into concurrence cliques. At equality these are (K_m)'s, hence a `MATCH(k,m,1)` design.
5. If a full design does not exist, a packing missing exactly one block would have a leave with \(\binom m2\) edges and all positive degrees divisible by (m-1). Its support must have exactly (m) vertices, so the leave is (K_m) and can be filled. Therefore nonexistence forces the two-unit defect gap.
6. For six points, the concurrence condition forces characteristic two and an ℔₄ frame by a complete-quadrangle calculation. For seven points, abstract nonexistence already forces defect at least two. For ten points, the manuscript then invokes the external two-class classification before applying its separate rank-three realization test.

## Count, divisibility, and edge-case audit

All load-bearing counts and divisions in the human argument check out.

- (E(KG(k,2))) has (3\binom k4) edges. Hence an equality design has
  \[
  b=\frac{3\binom k4}{\binom m2}
  =\begin{cases}(k-1)(k-3),&k\text{ even},\\ k(k-2),&k\text{ odd},\end{cases}
  \]
  and an individual secant lies in
  \[
  \rho=\frac{\binom{k-2}2}{m-1}
  =\begin{cases}k-3,&k\text{ even},\\ k-2,&k\text{ odd}.\end{cases}
  \]
- The small values used later are correct: ((k,m,b,\rho)=(6,3,15,3),(7,3,35,5),(10,5,63,7)).
- At λ=1 a repeated matching repeats every pair among its edges, so simplicity is automatic for (m\ge2). The manuscript invokes this only where (k\ge4), so there is no degenerate one-edge exception.
- The ambient assumptions (q\ge3,k\ge3) make (m\ge1), so the defect formula never divides by zero. Quantitative stability separately assumes (m\ge3). The matching theorem assumes (k\ge4), and the gap argument remains valid at (m=2), although its nonexistence premise is then vacuous in the cases at hand.
- In the one-block-short argument, the leave has degree sum (m(m-1)). Divisibility by (m-1) gives at most (m) nonisolated vertices; \(\binom m2\) edges require at least (m). Equality forces every possible edge on those (m) vertices, so the leave really is a (K_m), whose vertices are pairwise independent edges of (K_k). The completion step is sound.
- The abstract-design, partial-geometry, and projective-realization layers are mathematically distinct in the manuscript's definitions. The convention translation `pg(5,7,3)` to common `pg(4,6,3)` is correct.

## Ranked findings

### 1. MISSING CITATION — the partial-geometry equivalence is asserted too quickly, and the pinpoint is inaccurate

In the ten-point proof, the sentence beginning “Equivalently, these are the two partial geometries” does not show how a `MATCH(10,5,1)` becomes a `pg(5,7,3)`, nor what is required for the converse. The claimed Reichard--Woldar pinpoints also do not perform the jobs assigned to them: Proposition 5.1.4 proves their construction is a `pg(5,7,3)`; Proposition 5.1.5 computes its automorphism group; Corollary 5.1.6 distinguishes the two constructed geometries. Completeness is Mathon's external classification, reported by Reichard--Woldar, rather than proved by those two pinpointed results.

This does not damage the rank-three theorem's two-class input, because Alspach--Heinrich already explicitly report Mathon's classification of `MATCH(10,5,1)` designs. It does blur the important separation among matching designs, abstract partial geometries, and projective realizations.

**Small repair:** replace “Equivalently” by a short incidence calculation: take points (E(K_{10})) and lines the 63 matching blocks; each point lies on seven lines, and an edge outside a perfect matching is disjoint from exactly three of its members, giving (T=3). Then cite Reichard--Woldar Proposition 5.1.4 for the two models, Proposition 5.1.5 and Corollary 5.1.6 for their inequivalence, and their historical paragraph (or Mathon's original result) for completeness. If the converse from arbitrary `pg(5,7,3)` is retained, cite or state the point-graph identification with the complement of (T(10)).

### 2. EXPOSITION — “regular-hyperoval design” is never defined

The ten-point theorem names one abstract class the “regular-hyperoval design,” but this phrase first appears in the theorem itself. The reader is not told whether this means the matching design obtained from the regular hyperoval by the Alspach--Heinrich construction, nor why that construction selects one of Mathon's two classes.

**Small repair:** define the term in one sentence immediately before the theorem and cite Alspach--Heinrich Theorem 1.2 specialized to (2^3+2=10). State that its 63 perfect matchings form one of Mathon's two classes.

### 3. EXPOSITION — the converse in the six-point classification is compressed past the natural verification point

The forward coordinate calculation is persuasive and correct, but “Direct substitution verifies all required concurrences” leaves the reader to reconstruct which of the fifteen perfect matchings have been checked. This is a human classification statement, so a symmetry reduction or a compact determinant identity would make the converse self-contained without adding much length.

**Small repair:** give one sentence identifying a group action reducing the fifteen matchings to the displayed cases, or state the uniform determinant identity for a partition into three pairs.

## Earliest unsupported implication

Within the assigned material, the first unsupported implication is not in the defect or leave arguments; those are complete. It occurs in the ten-point classification paragraph when the two `MATCH(10,5,1)` classes are called “equivalently” the two `pg(5,7,3)` classes without the incidence-map/α argument and with mismatched proposition pinpoints. The repair is local and does not change any theorem statement.

## Verdict and smallest repair

**MINOR.** The exact defect identity, equality criterion, matching-design extraction, block and replication counts, simplicity implication, stability estimates, and one-block-short leave argument are correct. No FALSE finding emerged in the human design-theoretic core. The smallest adequate repair is one paragraph in the ten-point proof correcting the Reichard--Woldar pinpoints and explicitly separating:

\[
\text{MATCH design}\longrightarrow\text{abstract partial geometry}
\longrightarrow\text{rank-three projective realization}.
\]

Add the one-sentence definition/citation for the regular-hyperoval design; the six-point converse expansion is desirable but not verdict-changing.

## Mystery ledger (`ej` + `tt` closeout)

- **Settled:** the apparent one-block-short loophole is not a loophole; leave-degree divisibility plus the exact edge count forces a fillable (K_m).
- **Settled:** λ=1 removes repeated-block ambiguity for every matching size used in the paper.
- **Settled:** the `pg(5,7,3)`/`pg(4,6,3)` discrepancy is purely convention.
- **Open only as exposition:** the manuscript does not identify the regular-hyperoval class combinatorially before naming it. The owning repair is the local definition and Alspach--Heinrich citation above.
- **No further genuine mystery remains** in the assigned human-proof packet. The finite-field elimination was outside this review's evidence boundary.
