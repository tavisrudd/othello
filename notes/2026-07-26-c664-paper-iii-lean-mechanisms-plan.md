# C664 Paper III symbolic Lean mechanisms plan

**Lane:** `clebsch`

**Date:** 2026-07-26

## Decision

C664 will formalize the reusable human mechanisms under Paper III, not the
full arithmetic-incidence or spherical-harmonic theorem.  Its core consists
of:

1. odd-unit splitting in a commutative algebra with involution, including
   the exact localization-facing corollary used by `ALG-1`; and
2. the pair-sum eigenspace theorem for the Kneser graph on two-subsets,
   whose \(n=5\) specialization identifies the Clebsch four-space with the
   Petersen \((-2)\)-eigenspace.

A small symbolic golden-exchanger leaf is admitted only after both core
modules pass.  The task does not formalize Hitchin's incidence variety,
the branch sextic, the \(A_5\)-invariant-ring classification, the
\(\operatorname{SO}_3/\Omega_3\simeq
\operatorname{PGL}_2/\operatorname{PSL}_2\) identification, the Mathieu
carriers, spherical integration, Wigner symbols, or empirical materials
claims.

The current Paper III release gate remains independent of Lean.  C664 may
earn a later manuscript citation only after an exact statement
correspondence audit; merely creating compiling modules does not reopen the
paper.

## Why this boundary

Paper III has two kinds of arguments.  The mechanisms are elementary and
structural: an invertible odd element generates the anti-invariant part,
and the standard representation on vertices maps to a distinguished
Kneser eigenspace by pair sums.  These are good formalization targets
because Lean can expose every hypothesis and every algebraic step without
importing a certificate.

The headline arithmetic cover and harmonic integral depend on large
external theories.  A Lean file that assumes Hitchin's branch theorem,
imports literal Gaunt tables, or postulates the relevant group
identifications would add formal ceremony without shrinking the paper's
trust base.  C664 excludes those routes.

## Work package A: involutive odd-unit splitting

Create `RelativeConicArcs/InvolutiveOddUnit.lean`.

Let \(R\) be a commutative ring, let
\(\kappa:R\simeq+*R\) be an involution, and assume \(2\) is a unit.
Define the invariant and anti-invariant predicates
\[
 \kappa(x)=x,\qquad \kappa(x)=-x.
\]
The module must prove symbolically:

1. the even and odd projections
   \[
   x^+=(x+\kappa x)/2,\qquad x^-=(x-\kappa x)/2
   \]
   have the advertised parity and satisfy \(x=x^++x^-\);
2. the intersection of the invariant and anti-invariant parts is zero;
3. if \(c\) is anti-invariant and \(c^2\) is a unit, then \(c\) is a unit
   and multiplication by \(c\) is an equivalence from invariant elements
   to anti-invariant elements;
4. every element has a unique expression \(a+cb\) with \(a,b\)
   invariant; and
5. for an equivariant ring map into a ring satisfying
   `IsLocalization.Away (c^2)`, the image of \(c\) satisfies the preceding
   theorem.  The localization involution may be supplied as structure with
   an explicit commutation hypothesis; C664 need not construct it through
   the localization universal property unless that construction is short
   and reusable.

The paper correspondence is exact at the algebraic level: localization at
\(c^2\) makes \(c\) invertible, after which the unique
invariant-plus-\(c\)-times-invariant decomposition follows.

## Work package B: Kneser pair eigenspace

Create `RelativeConicArcs/KneserPairEigenspace.lean`.

For \(n\ge3\) vertices, define the type of two-subsets without an enumerated
table, the pair-sum map
\[
 E(y)_{\{i,j\}}=y_i+y_j,
\]
and the disjointness adjacency operator of the Kneser graph \(K(n,2)\).
For \(\sum_i y_i=0\), prove the general identity
\[
 A(Ey)=-(n-3)Ey.
\]
The proof must use finite-sum combinatorics: every complementary vertex
occurs \(n-3\) times.  It must not expand a fixed adjacency matrix.

Then prove:

1. \(E\) is injective when \(n-2\) is invertible, using the sum of pair
   weights incident with one vertex;
2. at \(n=5\), over a field in which \(3\) and \(5\) are nonzero, every
   \((-2)\)-eigenvector is a pair sum of a unique sum-zero vertex vector;
   the inverse is recovered from vertex-incidence sums; and
3. the resulting equivalence identifies the four-dimensional standard
   module with the Petersen \((-2)\)-eigenspace, including the finrank
   statement.

The converse proof should expose the strongly regular mechanism:
the total pair sum vanishes because summing the eigen-equation gives
\(5T=0\), and vertex-incidence sums reconstruct the coordinates.  This
is the formal crown of C664.

## Work package C: bounded golden exchanger

Only after A and B are green, create
`RelativeConicArcs/GoldenIcosahedronExchanger.lean` if the following
remains a small symbolic leaf.

Over a field with \(t^2=t+1\), define the six displayed golden vectors and
the exchanger
\[
 R=\begin{pmatrix}1&0&0\\0&0&-1\\0&1&0\end{pmatrix}.
\]
Prove by ring identities, not imported output:

- \(R\) carries the \(t\)-configuration to the \(1-t\)-configuration up
  to the displayed permutation and projective scalars;
- \(R^2=\operatorname{diag}(1,-1,-1)\), \(R^4=1\), and
  \(xyz\circ R=-xyz\);
- the common norm and squared-angle identities; and
- the explicit two-reflection factorization used in the spinor
  calculation.

The six-arc completeness theorem, \(A_4\) stabilizer classification, and
identification of the spinor quotient with \(T_{11}\) remain outside this
leaf.  If projectivization or reflection APIs make the module exceed this
symbolic boundary, omit C rather than replacing the proof by literal
tables.

## Formal API and module discipline

- New scholarly names describe the mathematics and contain no task IDs,
  dates, lane names, or workflow status.
- New modules contain self-contained headers and docstrings and cite no
  internal reports.
- No generated Lean, imported certificate array, `native_decide`, new
  axiom, or `sorry` is allowed.
- Kernel-backed tactics such as `ring`, `simp`, `linear_combination`,
  finite-sum rewriting, and bounded `fin_cases` are allowed when their
  mathematical role is visible.
- The existing `ClebschTensorBridge` module remains optional and is not
  imported by the new gate.
- The unrelated dirty files
  `Q11DyeAxioms.lean`, `TRUST.md`, and
  `Gates/ArcsCompleteOutsideConic.lean` are foreign and outside C664.

Create the import-only gate
`RelativeConicArcs/Gates/ClebschOrientationMechanisms.lean`.  It imports
only the accepted C664 leaves and prints axioms for every paper-facing
terminal.

## Validation sequence

1. Elaborate each new leaf through
   `lean/scripts/guarded-lean RelativeConicArcs/<Module>.lean`.
2. Review the complete source and verification closure for scholarly prose,
   names, trust-boundary accuracy, and forbidden workflow references.
3. Build the import-only gate through the guarded entry point.
4. Run the lane's exact-target `--no-build` freshness confirmation through
   the supported build queue while it owns the shared tree.
5. Record the actual pinned-toolchain `#print axioms` output.  The expected
   ceiling is the ordinary logical axioms needed by mathlib
   (`propext`, `Quot.sound`, and, where finite-set choice requires it,
   `Classical.choice`); any native-evaluation or project-specific axiom is a
   failure.

No paper edit, trust-ledger promotion, or release-gate dependency is part
of the implementation commit.  Those require a separate post-formalization
correspondence decision.

## Acceptance gate

C664 passes only if:

- work packages A and B are complete at the stated generic strength;
- the \(n=5\) converse proves equality with the full \((-2)\)-eigenspace,
  not only inclusion;
- the gate imports no certificate-driven Clebsch module and exposes no
  native-decision axiom;
- every terminal has a self-contained mathematical docstring and an exact
  axiom audit;
- the scoped elaborations, import gate, and exact-current confirmation are
  green; and
- the dated completion report maps each Lean theorem to the precise paper
  clause it supports and lists every Paper III clause it does not support.

Work package C is a free upgrade, not a condition for passing.  Failure of
A or B cannot be repaired by substituting the existing finite tensor
certificate.

## Tao pass

The first Tao question is whether the proposed formal theorem is about the
icosahedron or about a representation that happens to appear there.  The
pair-sum identity answers this: the natural object is \(K(n,2)\), with
eigenvalue \(-(n-3)\) on the standard vertex representation.  The
Petersen value \(-2\) is the \(n=5\) specialization.  Formalizing the
general theorem both shortens the proof and explains the number.

The second question is whether localization is doing mathematics or merely
making an odd element invertible.  The latter is the mechanism.  The
formal core should therefore prove the odd-unit equivalence first and make
the localization statement a transparent corollary.

The third question is where formalization could reveal a missing
hypothesis.  The converse Kneser theorem uses the invertibility of \(5\)
to kill the total pair sum and the invertibility of \(3\) to reconstruct
vertices.  These characteristic exclusions should be explicit in the Lean
API rather than hidden in a real-vector-space specialization.

## Red-team review

**Attack: “Formalize the main theorem.”**  Rejected.  A file assuming
Hitchin's incidence and branch results would not kernel-check them, while a
genuine development would require a large algebraic-geometry and invariant-
theory project.  Calling the bounded result a formalization of Paper III
would overstate coverage.

**Attack: reuse the existing tensor terminal as the centre.**  Rejected.
It checks literal certificate data with native evaluation and deliberately
does not prove matching-orbit provenance or equivariance.  Making it
release-critical would reverse the paper's human-proof hierarchy.

**Attack: formalize the exact Gaunt scalar.**  Rejected for C664.  Without a
developed library for spherical harmonics, surface moments, and Wigner
symbols, the likely result is a large imported coefficient table.  The
paper's human moment formula plus two independent exact audits is the
stronger trust presentation.

**Attack: the Kneser converse is unnecessary scope growth.**  Rejected.
Inclusion alone would formalize only the one-line computation already in
the paper.  The converse explains why the four-space is the whole
eigenspace and earns a reusable theorem rather than a coordinate check.

**Attack: the localization API may dominate the work.**  Mitigated.  The
accepted core is the theorem in a ring where \(c^2\) is a unit.  The
`IsLocalization.Away` corollary assumes an equivariant involution on the
target and need not construct one.  No algebraic-geometry localization is
required.

**Attack: the new gate contaminates foreign Lean work.**  Mitigated by new
leaf paths, an import-only C664 gate, the shared build-owner protocol, and
an explicit ban on touching the three presently dirty foreign paths.

## Extra-juice pass

The general \(K(n,2)\) theorem is the main free gain.  It can support the
Petersen geometry in Paper I and the pair-module explanations in Paper II
without importing Paper III coordinates.  Promotion to those papers is
not automatic; their owners may cite the reusable theorem after separate
correspondence reviews.

The odd-unit result is likewise broader than the golden torsor.  It gives a
clean API for any two-sheet construction whose first odd observable becomes
invertible, including future orientation and signed-Gale settings.

A second cheap gain is a sharp negative trust statement: after C664,
Paper III can truthfully say that Lean checks two structural mechanisms
while leaving the arithmetic cover and harmonic integral to human proof and
classical input.  It still should not advertise the paper as formally
verified.

## Mystery ledger

- **Explained by the Tao pass:** the Petersen eigenvalue \(-2\) is
  \(-(n-3)\) at \(n=5\), not an isolated matrix accident.
- **Exposed by the red team:** characteristics \(3\) and \(5\) enter the
  converse pair reconstruction for different reasons; the formal API must
  keep them separate.
- **Open implementation question owned by C664:** whether the
  `IsLocalization.Away` corollary is short enough to include without
  obscuring the odd-unit theorem.
- **Optional C664 question:** whether the golden exchanger can be stated
  cleanly with existing projective and reflection APIs without literal
  tables.
- **Explicitly outside C664:** formalization of Hitchin's incidence cover,
  the \(5J_0\) square-class determination, the full \(A_5\) invariant ring,
  the \(T_{11}\) group identification, the Gaunt integral, and the Mathieu
  corollary.

## Vibe check

Strong plan if kept at this boundary.  A and B would add genuine reusable
mathematics and reduce dependence on finite certificates.  Expanding to the
headline cover or harmonic integral would have poor expected value and a
high risk of producing formal-looking assumptions rather than verification.
