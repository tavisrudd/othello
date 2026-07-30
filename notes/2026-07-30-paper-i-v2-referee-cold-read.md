# Paper I v2 referee cold read

**Date:** 2026-07-30

**Artifact read:** `papers/clebsch-rigidity/clebsch_rigidity.pdf`, 18 pages,
built from authoritative source commit `67a5a249`

**Companion inspected:** `clebsch_rigidity_computational_companion.tex`,
especially the q13 tangent-code theorem and trust statement

**Recommendation:** major revision, with a favorable view of the result

## Summary assessment

The paper has a strong specialist theorem and a coherent mathematical
mechanism.  Its best contribution is not the finite Clebsch configuration
by itself, nor the already known six-nodal cubic.  It is the inverse
reconstruction chain
\[
\text{deep-hole syndrome locus}
\longrightarrow \text{Clebsch code and polarity}
\longrightarrow \text{support orientation}
\longrightarrow \text{signed two-graph and golden operator}.
\]
The universal chord-defect identity and conic-filling window give the
paper useful scope beyond the exceptional example.  The decoder
reconstruction and the identity
\[
\det(B+\operatorname{diag}x)
=e_6-e_4+5e_2-125-2C
\]
are the memorable results.

The proof of the rigidity theorem is short, intelligible, and convincing.
The line bound is especially effective: it isolates the only elementary
geometric obstruction needed before Dye's equality theorem applies.  The
code/syndrome dictionary is introduced carefully enough for finite
geometers and coding theorists to read the same paper.

The current manuscript is not ready for submission.  One
representation-theoretic statement needs correction, the computational
boundary of the orientation theorem is described too strongly, and the
closest literature around the q13 code and association scheme is not yet
integrated.  These are repairable without changing the central theorem.

## Major comments

### 1. Correct the rational representation statement

The proof of Theorem 9.1 writes
\[
L^-\otimes\mathbf Q\cong\mathbf3\oplus\mathbf3'.
\]
The two 3-dimensional irreducible characters of \(A_5\) have values in
\(\mathbf Q(\sqrt5)\) and are not individually representations over
\(\mathbf Q\).  Over \(\mathbf Q\), their Galois pair forms one
6-dimensional irreducible module.

The intended conclusion is plausible and should be stated by descent:
\[
L^-\otimes_{\mathbf Q}\mathbf Q(\sqrt5)
\cong V_3\oplus V_{3'},
\qquad
\operatorname{End}_{\mathbf Q A_5}(L^-\otimes\mathbf Q)
\cong\mathbf Q(\sqrt5)=\mathbf Q[B].
\]
Then the diagonal/off-diagonal integrality argument identifies the order
\(\mathbf Z[B]\).  As written, the field of definition is ambiguous at the
exact point where the integral commutant is concluded.

### 2. State the orientation theorem's computational boundary accurately

Section 11 says that the orientation two-graph theorem is “proved in the
text.”  Its singular-locus completeness and automorphism conclusions
currently use:

- exact Buchberger reductions of five gradient ideals;
- six Hessian-rank calculations; and
- a signed-permutation stabilizer calculation.

The displayed outputs make the route inspectable, but they are
load-bearing finite algebra, not a conventional hand proof.  The text
should call the theorem computer-assisted at those three clauses and say
which checker or Lean terminal certifies each one.  Once C698 lands, the
right presentation is a short conceptual proof plus a precise formal
coverage sentence; “proved in the text” remains too broad even then.

The q13 companion has the same issue more strongly.  The two weight-ten
profile exclusions, the 364-word completeness statement, six-class
reconstruction, and order-2184 automorphism computation are executable
proof obligations.  C701 can turn them into certificate-checked claims,
but the paper must continue to distinguish the mathematical reductions
from their finite leaves.

### 3. Complete the closest-literature account

The new Cheltsov--Tschinkel--Zhang paragraph correctly distinguishes the
published six-nodal \(S_5\)-model from the paper's syndrome reconstruction.
The coordinate identification should ideally be displayed as a one-line
polynomial identity after \(x_0=0\) and \(y_3\leftrightarrow y_5\), rather
than left as a prose assertion.

Two equally close q13 sources remain absent from the computational
companion:

- Madison--Wu prove the general binary conic-code nullity
  \((q-1)^2/4\), which specializes to the dimension \(36\) here.
- Hollmann--Xiang develop the \(\operatorname{PGL}(2,q)\) association
  schemes on points off a conic.  The six-class carrier is classical even
  though reconstruction of it from the minimum layer is the paper's
  result.

The main paper should also cite a standard source for the
Seidel-matrix/switching-class/two-graph dictionary.  These additions will
make the priority boundary balanced: known carrier and model, new
reconstruction.

### 4. Repair the opening hierarchy

The introduction's paragraph “What is new and what is not” does not
mention the orientation two-graph, determinant identity, six-node
recovery, or golden commutant.  Those results occupy the abstract, title,
and most distinctive section of the revised paper, so their omission
makes the revision look appended rather than structurally integrated.

Add one sentence there that:

1. credits the known six-nodal model and standard two-graph language; and
2. claims precisely the recovery of its equation and golden switching
   class from syndrome/support data.

The conclusion should likewise give the determinant identity one sentence
of mathematical interpretation, rather than mentioning the two-graph only
in its final line.

### 5. Split the largest theorem by logical level

Theorem 9.1 currently combines:

- equivalence of the support signs and signed orbital;
- the determinant identity;
- singular-locus and projective-frame recovery;
- full and oriented automorphism groups; and
- the rational and integral commutants.

The first two form the conceptual theorem.  The nodes/symmetry and
commutant statements are natural corollaries.  Splitting them would make
the contribution easier to quote and would expose exactly where finite
algebra enters.

## Minor comments

1. In the q13 proof, derive the assertion that parity leaves exactly two
   weight-ten pencil profiles; it is currently stated immediately before
   a very large finite search.
2. State the coefficient field for the five gradient ideals and clarify
   that an empty basis in the first chart represents the zero ideal in a
   zero-variable coordinate ring.
3. The bibliography is not alphabetized, despite the `plain` declaration.
   This is harmless mathematically but should be normalized before
   submission.
4. The abstract is dense but accurate.  If space is needed, remove one
   decoder consequence before removing the determinant identity.
5. The paper and companion should use one fixed phrase for the q13 object:
   “binary passant/internal incidence code” or “tangent code,” with the
   alternative introduced once.

## Verdict after the planned Lean update

If C698--C702 certify the exact paper statements, the rational
representation sentence is corrected, and the literature/opening repairs
above are made, I would recommend acceptance at a strong specialist venue.
The natural fit is *Algebraic Combinatorics*; *Journal of Combinatorial
Theory, Series A* is a defensible first submission if the reconstruction
theorem is made the unmistakable headline.

Lean will materially strengthen the paper because its vulnerable claims
are completeness and stabilizer statements, precisely the kind of finite
claims formal certificates handle well.  It will not remove the need for
the field-of-definition correction or the literature distinctions.

