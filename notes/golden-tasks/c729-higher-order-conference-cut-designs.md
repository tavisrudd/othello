# C729 — Higher-order extremal conference-cut designs

**Lane:** `golden`

**Status:** active; Naimark reflection and full integral outer-action bridge
proved; moment/literature gates next

**Opening report:**
`notes/2026-07-31-c729-simplex-conference-factorization.md`

## Objective

Start from the exact Naimark--Gram lift from the order-six syndrome matrix to
the Petersen/Paley order-ten conference operator, and determine whether it is
the first step of a functorial conference tower.  Explain what replaces the
order-six all-cut maximum-determinant theorem at later stages by classifying
extremal balanced cross blocks, group orbits, and any canonical block design
or association scheme they carry.

## Structural split

The opening theorem must separate three logically different statements.

1. **Simplex linear algebra.**  A sign matrix satisfying
   \(RR^{\mathsf T}=12(I-J/6)\) has rank five; its normalized columns form
   an \(\operatorname{ETF}(5,10)\), and its column Gram matrix yields a
   symmetric order-ten conference operator.
2. **Golden rigidity.**  The six balanced-cut fingerprints of the golden
   order-six family satisfy that row-simplex identity.  The zero-centroid
   relation supplies the null line, while outer two-transitivity forces the
   common off-diagonal inner product.
3. **Functorial descent.**  Row reversals do not change the column Gram
   matrix; cut reorientation and relabelling change the output only by
   conference switching and permutation.  Thus the first intrinsic target
   is an order-ten switching class.  Any stronger canonicity statement must
   identify and remove the residual markings explicitly.

The first inverse question is correspondingly precise: classify the
order-ten conference switching classes admitting a \(\{\pm1\}\)-valued
simplex factor \(R\), and determine whether such a factor recovers the six
golden sisters uniquely up to row reversal, row permutation, column
switching, and column permutation.  This reverse-factorization problem is
the prospective \(6\leftrightarrow10\) theorem; the forward Gram identity
alone does not establish a conference tower.

The first two stages now share a more general invariant than the conference
identity: their tight-frame Gram projectors give constant-diagonal Naimark
reflections.  The \((5,10)\) stage has diagonal zero and hence a conference
operator; the \((9,36)\) extremal-cut stage has diagonal \(-1/2\) and an
integral weighted form with off-diagonal magnitudes \(1,3\).  C729 therefore
tests a reflection hierarchy, with conference matrices as the
redundancy-two specialization, rather than presupposing a conference tower.

## Gates

1. Reproduce the exact factorization
   \[
   R_{6\times10}R_{6\times10}^{\mathsf T}=12(I-J/6),
   \qquad
   R_{6\times10}^{\mathsf T}R_{6\times10}=6I+2S_{10},
   \]
   prove \(S_{10}^2=9I\), and identify \(S_{10}\) intrinsically as the
   Petersen/Paley conference switching class with eigenspaces \(5\) and
   \(1+4\).  Prove the general simplex-to-conference lemma first, then
   isolate the sign-integrality input supplied by the golden fingerprints.
2. Prove covariance of \(R\mapsto[S_{10}]\) under every row and column
   ambiguity, and classify the reverse sign factorizations of the resulting
   order-ten Gram matrix up to those actions.
3. Explain why the lift preserves the conference identity but loses universal
   cut extremality: among the 126 balanced
   \(5\times5\) cross blocks, 90 are singular and 36 have determinant
   magnitude 48.
4. Determine whether the extremal 36 cuts form a canonical orbit, block
   design, code, or another incidence object inherited from the \(6\to10\)
   lift.
5. Compute exact cut-determinant distributions for the next feasible
   conference orders and split them by automorphism-group orbit, with compact
   reproducible certificates.
6. Derive representation-theoretic or Cauchy--Binet moment identities for
   the distribution; distinguish universal constraints from Paley-specific
   arithmetic.
7. Formulate and test stability/inverse statements: how many extremal or
   near-extremal cuts force proximity to a conference signing?
8. Run a focused conference-matrix, ETF/Naimark, Petersen-Seidel, and
   maximal-minor literature audit before
   claiming a new higher-order principle.

## Acceptance

- An intrinsic theorem explaining the \(6\to10\) lift and at least one
  higher-order cut distribution or design, not merely tables.
- A sharp statement of why order six is exceptional.
- Exact scripts, compact certificates, independent replay, and human proof.

## Boundary

This is a sequel direction.  It enters the Golden paper only if it produces a
short theorem that clarifies the order-six mechanism; otherwise the paper
records only the explicit order-ten counterexample.

## Dependencies

C720 supplies the order-six theorem and order-ten boundary test.  The task is
otherwise independent of C715--C719 and C728.
