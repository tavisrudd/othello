# AME--LU two-cold-read research frontier

**Date:** 2026-07-25

**Lane:** `ame-lu`

**Status:** durable synthesis; successor tasks C622--C624 queued

## Question put to the readers

Two independent readers were given the manuscript only and asked:

> What questions does this paper beg?  What does it imply that you would go
> check on or try to prove?  What strong connections does it miss?

They were not shown the task ledger, prior audit reports, or each other's
answers.  This note records their convergence, separates conjectural
strengthenings from proved manuscript results, and fixes the next-task
ordering.

## Independent convergence

The readers independently selected the same three main frontiers.

### 1. Replace GRS versus non-GRS by diagonal isoduality

For an odd-prime linear \([2m,m,m+1]_q\) MDS code, the manuscript's GRS
propagation construction uses a nonsingular diagonal map
\[
  S C=C^\perp
\]
rather than the evaluation formula itself.  Conversely, the distance
argument controlling the off-diagonal symplectic blocks appears to force
such a diagonal equivalence whenever a nondiagonal fixed-party action
exists.

The proposed length-generic theorem is
\[
 G_{\mathrm{fixed}}^{\mathrm{proj}}(C)=
 \begin{cases}
 \mathbb F_q^2\rtimes\mathrm{SL}_2(q),
   & C\text{ is diagonally isodual},\\
 \mathbb F_q^2\rtimes T,
   & C\text{ is not diagonally isodual}.
 \end{cases}
\]
Here \(T\) is the diagonal split torus.  The six-party conic/nonconic phase
would then be the first geometric instance of the intrinsic
diagonally-isodual/non-isodual dichotomy.

This is a conjectural strengthening until the block equations, propagation,
translation fiber, and converse are checked for arbitrary \(m\).  Priority
or novelty language also requires a bounded audit of isodual-MDS and
transversal-gate literature.

### 2. Classify extension-field Clifford equivalence

For \(q=p^e\), the full one-site Clifford action is
\(\mathrm{Sp}_{2e}(\mathbb F_p)\), not merely
\(\mathrm{SL}_2(\mathbb F_q)\).  Frobenius already shows that equality of
the pencil scalar \(z\) is too fine.  The sharp question is whether the
overlapping shortened planes canonically reconstruct the Desarguesian
\(\mathbb F_q\)-spread inside the additive \(\mathbb F_p\) phase space.

The first falsifier is a full local-Clifford orbit and fixed-party-kernel
census for \(q=9,25,27\):

- if every identification is semilinear, test whether the invariant is
  exactly the Galois orbit of \(z\);
- if not, exhibit the first genuinely non-semilinear
  \(\mathbb F_p\)-symplectic identification and determine what structure it
  preserves.

Only after that finite gate should one attempt a general reconstruction
theorem, plausibly using finite projective geometry.

### 3. Compute the party-moving extension in actual examples

The paper constructs the section-free outer action and normalized
nonabelian factor set for
\[
  1\longrightarrow\Gamma\longrightarrow\widetilde\Gamma
  \longrightarrow\Pi\longrightarrow1,
\]
but it computes no code-specific factor set.  The immediate cases are the
\(q=11\) pencil classes, the \(q=17,31\) enhanced-symmetry examples, GRS
evaluation sets, and the H3 configurations.  For each, determine
\(\Gamma,\Pi,\widetilde\Gamma\), the outer action, factor-set
trivializability, and whether party-moving symmetries enlarge \(T\) to
\(N(T)\).

This extension is independent of both the split odd-field Weil lift over
the linear \(\mathrm{SL}_2(q)\) factor and the nonsplit Heisenberg extension
over translations.

## Other questions begged

- For arbitrary prime-field six-arcs, is
  \[
    \Psi_C\sim_{\mathrm{LC}}\Psi_D
    \quad\Longleftrightarrow\quad
    C\sim_{\mathrm{mon}}D
    \ \text{or}\ C\sim_{\mathrm{mon}}D^\perp?
  \]
  If true, the natural moduli space is projective six-arcs modulo Gale
  association.  Mixed local-symplectic blocks are the main proof risk.
- Which non-GRS MDS codes are diagonally isodual?
- What is the least scalar-copy degree \(r(q)\) separating the pencil
  classes, and must it grow with \(q\)?
- Do the exceptional divisors \(z=2,4/9\) belong to a systematic hierarchy
  of determinantal rank-jump strata?
- Which stabilizer states satisfy the full-Weyl marginal-cover criterion?
  A small stabilizer-Lagrangian census could precede a symplectic-matroid
  characterization.
- Can rank-one axis recovery be made quantitative, so approximate product-LU
  equivalence forces the local factors close to Cliffords?

## Strong underdeveloped connections

These are connections to investigate, not novelty claims.

1. **Higher-dimensional Gale self-association and GIT.**  Diagonal
   isoduality is self-association of \(2m\) points in
   \(\mathbb P^{m-1}\); the six-point conic theorem is only its first case.
2. **Tensor identifiability and tomography.**  The full-Weyl marginal is an
   orthogonally decomposable operator tensor whose rank-one axes are
   intrinsically recoverable.
3. **Perfect tensors, quantum secret sharing, and holographic codes.**
   Fixed-leg logical mobility and minimum-support operator pushing should
   have a tensor-network interpretation.
4. **Schur--Weyl and partition-diagram invariant theory.**  This is the
   natural setting for fixed-copy contractions and their determinantal
   degeneracy loci.
5. **Symplectic matroids and discrete holonomy.**  Shortened-plane transition
   data may yield intrinsic LC invariants beyond the admitted pencil.
6. **Approximate rigidity and self-testing.**  A stable tensor-axis theorem
   could connect exact LU rigidity to robust fault tolerance and
   approximate Eastin--Knill bounds.

The manuscript already cites or explicitly discusses Coble/Gale
association, Eastin--Knill, finite-field Weil lifting, and extension-field
Frobenius.  Those themes are underexploited, not absent.

## EV disposition

| Rank | Task | EV assessment |
|---|---|---|
| 1 | C622: all-length diagonal-isoduality dichotomy | **Very high.** It appears to be a short strengthening of the core theorem, replaces a presentation-dependent GRS boundary by the intrinsic condition, and has immediate manuscript and Lean consequences. |
| 2 | C624: concrete party-extension computations | **High per unit cost.** It cashes out C618's machinery, corrects an explicit example gap, and is falsifier-friendly; the likely theorem upside is lower than C622. |
| 3 | C623: extension-field classification | **High upside, medium expected value.** The finite census is bounded, but a positive result opens a deep reconstruction problem and a negative may require a new invariant. |

C581 is narrowed to quantitative approximate rigidity after C623 resolves
the exact extension-field reconstruction question.  It should not duplicate
C623's finite-field spread gate.

## Concrete manuscript repair noticed during synthesis

Section 8 still says that the party-permutation theorem “does not construct
an extension class or a cohomological obstruction.”  That sentence became
stale after C618: Section 3 now constructs the outer action and normalized
nonabelian factor set and proves its trivializability equivalent to
splitting.  The verification-boundary sentence should be synchronized in
the next manuscript-editing task.

