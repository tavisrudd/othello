# C645: AME--LU minor revision and literature positioning

**Lane:** `ame-lu`

**Date:** 2026-07-25

## Outcome

The artifact-aware reader's minor-revision set has been applied, except
for the public archive URL/DOI that can exist only after author-directed
deposit.

The paper now:

- ranks the all-length LU-to-LC theorem, its factorwise transversal
  consequence, and the exact diagonal-isodual group dichotomy ahead of
  the \(m=3\) pencil applications in the abstract;
- compares its result directly with Dasu--Burton's matrix-algebra
  classification of qubit diagonal multiblock transversal Cliffords;
- places the six-point phase theorem in the classical GIT double-cover,
  Igusa-quartic, and Segre-cubic picture without using that picture in a
  proof;
- says that the separately implemented Python checks belong to one
  paper-owned package and are not external independent reproductions;
- corrects the stale Section 6 theorem numbers in the formal adequacy
  ledger; and
- removes the two workflow reverse references from
  `RelativeConicArcs.Plane` and `FiniteGeom.Code`.

The abstract change does not add a result.  It promotes the already
proved and formalized arbitrary-length diagonal-isodual dichotomy over
the six-party examples.

## Literature positioning

This revision makes no new absence or priority claim.  Two sources are
load-bearing for the added comparisons, and both were read at full text.

1. Shival Dasu and Simon Burton, *A Classification of Transversal
   Clifford Gates for Qubit Stabilizer Codes*, arXiv:2507.10519v1
   (2025).
   **Read depth:** `full text`; cached PDF and `pdftotext` extraction,
   especially Sections 1, 3--6, and Theorems 5.5 and 6.1.
   **Cache:** `arXiv:2507.10519`,
   SHA-256
   `da95db6671622a7356666212017749eb42da3e5ab545c3acb7e4a5013bc8452f`.
   The paper classifies the diagonal Clifford group acting on
   \(\ell\) identical qubit-code blocks through the code's
   \(\mathbb F_2\)-endomorphism algebra.  Its transversal tableau is the
   same at every physical coordinate and may couple corresponding
   qubits across blocks.  The AME--LU paper instead permits an
   independent single-qudit factor at every coordinate, works in odd
   prime dimension for its exact logical-group theorem, and treats one
   MDS/CSS code block.  These are complementary transversality
   questions, not competing statements of the same classification.

2. Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil,
   *A Description of the Outer Automorphism of \(S_6\), and the
   Invariants of Six Points in Projective Space*, arXiv:0710.5916v1
   (2007), published in JCTA 115 (2008).
   **Read depth:** `full text`; cached PDF and `pdftotext` extraction,
   especially Sections 2.1--2.3.
   **Cache:** `arXiv:0710.5916`,
   SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
   Section 2.3 identifies the GIT quotient of six ordered points in
   \(\mathbb P^2\) as a double cover of \(\mathbb P^4\), with Gale
   association exchanging sheets and the self-associated/conic locus
   giving the Igusa-quartic branch divisor.  Section 2.2 records the
   projective duality between the Igusa quartic and Segre cubic.  The
   manuscript now uses this only as a characteristic-zero
   interpretation of its fixed-label finite-field phase theorem.

## EV decisions

Three inexpensive changes had high expected value without increasing
the theorem burden:

1. promote the intrinsic diagonal-isodual dichotomy in the abstract;
2. state the exact Dasu--Burton scope comparison; and
3. add the short GIT interpretation paragraph.

The following reader ideas were not added:

- general stabilizer-AME rigidity;
- a global MDS--CSS orbit theorem modulo Gale duality;
- higher-dimensional self-associated/Veronese classification;
- symplectic-matroid or tensor-network reformulations; and
- quantitative approximate rigidity.

Each would require a new theorem, a substantial new literature boundary,
or new Lean coverage.  Adding any one here would weaken the current
paper's hierarchy.  The already formalized full-Weyl marginal-cover
criterion and diagonal-multiplier line are the reusable statements from
which those projects should start.

## Validation

- `make check` passed with no TeX warnings; the paper-owned verifier checked
  all 17 evidence artifacts.
- Guarded elaboration passed for `RelativeConicArcs/Plane.lean` and
  `FiniteGeom/Code.lean`.
- The detached Lean queue built
  `RelativeConicArcs.Gates.AMELUAggregate` in 2:44.00 and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms` in 16.60 seconds; the
  aggregate gate passed.
- The final PDF has 26 pages, 221,867 bytes, and SHA-256
  `16721025793da0209380526370834721dd5ca04ad23cf9aa702bf2ffe9a56b6f`.
- Pages 1--4 were visually inspected across the C645/C647 revision pair.

## Remaining author gate

A stable public URL or DOI cannot be inserted before the author selects
and authorizes a deposit.  The manuscript and release instructions state
this gate explicitly; no external action was taken.
