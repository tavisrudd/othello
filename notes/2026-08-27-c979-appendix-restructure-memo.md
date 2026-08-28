# C979 memo: appendix-first restructuring of the MDS--CSS paper

**Date:** 2026-08-27  
**Status:** planning memo; no manuscript changes authorized by this memo  
**Parent task:** C979, which remains open until the user explicitly closes it

## Decision in brief

The paper should first try an appendix-first reorganization rather than an
immediate companion-paper split.  The main text should expose one theorem
spine:

\[
\operatorname{Cond}(C,C^\perp)
\longrightarrow
\mathcal A_C
\longrightarrow
T\ \text{or}\ \mathrm{SL}_2(q)
\longrightarrow
\text{product-unitary exactness}
\longrightarrow
\text{the six-point conic criterion}.
\]

The full pencil classification may remain as the principal geometric
application, but its calculation should not interrupt that spine.  Lift
refinements, Clebsch syndrome geometry, scalar-invariant limitations,
certificate details, transport calculations, and coordinate-permutation
extensions should become explicitly optional appendices.

This is a presentation recommendation, not a claim that the secondary results
are weak.  The point is to make the all-length quantum-coding theorem determine
the paper's first-pass identity.

## Why reorganize

The current paper has a strong all-length result and a coherent proof, but its
visible center changes several times.  After the conductor and endomorphism-
algebra classification, the reader encounters physical lift refinements,
six-point geometry, a pencil quotient, Clebsch error geometry, scalar
invariants, formal and computational trust boundaries, and three substantial
appendices.  All are related, but they answer different questions.

For a quantum-information or quantum-coding reader, the principal result is
already complete once the paper has established:

1. the equal-parameter MDS conductor is zero or a full-support line;
2. the coordinatewise CSS endomorphism algebra is
   \(\mathbf F_q\times\mathbf F_q\) or \(M_2(\mathbf F_q)\);
3. its determinant-one units give \(T\) or \(\mathrm{SL}_2(q)\);
4. explicit Clifford realizations exist; and
5. stabilizer-AME rigidity excludes all other product-unitary logical gates.

The six-point conic theorem is the cleanest application because it translates
the conductor branch into familiar geometry without changing the proof of the
all-length theorem.  The pencil is a substantial second application.  The
remaining material is best read after the classification is secure.

## Recommended main-text architecture

The target is a main text of approximately 15--18 pages before the
bibliography.  Total PDF length may remain close to the current length; the
important change is where the main conclusion occurs and what a reader must
retain before reaching it.

### 1. Introduction

Retain:

- the operational definition of a site-dependent transversal gate;
- the exact projective logical group being computed;
- the conductor and Schur-square test;
- the two algebra types and two group branches;
- the imported rigidity boundary;
- a concise literature comparison;
- the six-point conic and pencil applications.

Shorten the organization paragraph so that refinements are named collectively
as appendices rather than narrated as coequal parts of the paper.

### 2. Stabilizer and MDS--CSS dictionary

Retain the Weyl/Clifford conventions, CSS label space, Choi bridge, and the
MDS--AME dictionary needed by the main proof.  Keep the six-arc dictionary
only to the extent needed to state the conic application.

### 3. Exact transversal logical group

Retain in full:

- the equal-parameter MDS conductor proposition and proof;
- the conductor--Schur-product identity;
- the four CSS block conditions;
- the coordinatewise endomorphism algebra and its two isomorphism types;
- the zero-conductor and nonzero-conductor cases;
- the explicit upper and lower unipotents;
- logical Pauli translations;
- the imported exactness step.

Also retain a concise twisted-diagonal proposition.  The site-dependent
realization is not decorative: it explains why the paper's transversal
convention is broader than \(U^{\otimes n}\), and it supplies one of the
clearest distinctions from neighboring work.

Move the detailed uniformization proof, coherent Weil lift, Heisenberg
nonsplitting, and small-field qualifications to Appendix A.  Their statements
may remain as short corollaries in the main text if needed to prevent the word
"exact" from becoming ambiguous.

### 4. Six-point conic criterion

Retain:

- the coding, Gale-dual, and geometric translations;
- the conic criterion and proof;
- the six-point transversal-group corollary;
- one short sentence locating the Clebsch example in the pencil.

Move syndrome geometry, error-shell symmetry, group bookkeeping, and
operator-pushing counts to Appendix C.

### 5. Pencil classification

Retain:

- why the pencil is considered;
- the regular locus, with exclusions grouped by meaning;
- the conceptual quotient \(t\to y\to z\);
- the projective and monomial-code classification theorem;
- the prime-field LC/LU classification theorem;
- a proof roadmap explaining which invariant recovers \(z\) and where exact
  finite collision handling enters.

Move bracket expansions, full holonomy multiplicities, modular collision
cases, Frobenius-sector calculations, and extension-field examples to
Appendix B.

### 6. Verification boundary and conclusion

Keep a short verification paragraph in the main text:

> The all-length theorem is conceptual and uses no finite enumeration.  The
> six-point finite calculations, formal interfaces, and exact trust boundaries
> are recorded in Appendix G and the paper-local supplement.

Then end the main text with the conclusion.  The full verification table,
Lean boundary, certificate descriptions, and implementation-specific details
belong in Appendix G.

## Proposed appendix architecture

### Appendix A. Physical realizations and lift refinements

- twisted-diagonal uniformization proof;
- square-class obstruction in
  \(\mathrm{PGL}_2(q)/\mathrm{PSL}_2(q)\);
- coherent Weil lift;
- Heisenberg obstruction to affine splitting;
- small-field qualification;
- pointer to party-moving extensions.

### Appendix B. Pencil quotient calculations and extension-field sectors

- bracket identities;
- holonomy invariant and multiplicities;
- collision analysis;
- finite-characteristic exceptional cases;
- Frobenius-sector divisors;
- extension-field caveat and examples.

### Appendix C. Clebsch code and syndrome geometry

- location in the pencil;
- syndrome-conic construction;
- error-shell symmetry;
- distinction from the parity-check six-arc conic;
- \(A_5/S_5\) bookkeeping;
- operator-pushing counts.

### Appendix D. Fixed-copy scalar invariants

Move the current scalar-invariant section here and combine it with the explicit
scalar certificates.  The conceptual generic-constancy theorem should precede
the exceptional calculations so that the appendix still has a mathematical
argument rather than reading as a certificate dump.

### Appendix E. Transition-map transport calculation

Retain the present transport calculation, using the standard terminology
already adopted in C979.

### Appendix F. Coordinate-permutation extensions

Retain the extension criterion and computed census.  Preserve the distinction
between unitary projectivization and matrix projectivization.

### Appendix G. Verification and scope

- claim/status/method/input table;
- proof versus imported-input boundary;
- certificate replay boundary;
- formalization boundary;
- exact negative-scope statement.

## Mechanical execution plan

### Phase 1: freeze the dependency map

Before moving text, record:

- every theorem, proposition, lemma, equation, figure, and appendix label;
- every forward and backward reference;
- which main theorem uses which imported or certificate-backed statement;
- every field, parity, fixed-coordinate, and projectivization hypothesis.

No prose should move before this map exists.  The map is the regression oracle
for the reorganization.

### Phase 2: move without rewriting

Split source files and reorder `main.tex` while initially preserving wording,
labels, and theorem order.  This separates movement errors from editorial
errors.  The paper should compile at the end of each individual move.

### Phase 3: repair the narrative seams

After the moves compile:

- replace backward-looking transitions that assume the old order;
- add one-sentence appendix introductions stating why the material is there;
- remove duplicated definitions and repeated scope caveats;
- make theorem statements in the main text self-contained;
- ensure every appendix is explicitly unnecessary for the all-length proof.

### Phase 4: compress the main text

The compression must come from eliminating duplicated explanation, not from
removing proof steps.  In particular:

- derive the linear group directly from the two endomorphism-algebra types;
- state lift refinements once in the main text and prove them once in the
  appendix;
- state the pencil classification once, with a proof roadmap rather than
  collision bookkeeping;
- retain one translation between coding and geometric language, not several.

### Phase 5: synchronize public surfaces

If the abstract or title changes, update:

- the paper README;
- Zenodo metadata;
- release metadata;
- verification claims;
- the all-papers summary README and its mirror.

The paper's filename and public URL need not change.

### Phase 6: validation and export

Run:

- TeX spacing lint;
- warning-free PDF build;
- full rendered-page inspection;
- all evidence replays;
- public and formal manifest verification;
- export audit;
- standalone mirror build and manifest check;
- byte-for-byte summary synchronization.

Use a fresh quantum-coding cold reader twice: first on the main text only, then
on the full paper.  The first reader tests whether the theorem is complete
without appendices; the second tests whether the appendices remain navigable
and properly scoped.

## Red-team assessment

### Objection 1: moving material does not actually shorten the submission

This is true.  Appendicization changes hierarchy, not total PDF length.  Some
journals count appendices against the same page limit, and a referee may still
regard a 28-page PDF as two papers.

**Mitigation:** set a separate total-length target after the structural move.
If the reorganized paper remains over the venue's practical limit or still
feels bifurcated in a full-paper cold read, move Appendix D or the combined
B--C material to a companion paper or external supplement.  Do not claim that
appendicization alone solves page pressure.

### Objection 2: seven appendices make the paper look more, not less, sprawling

This is the strongest presentational risk.  A long alphabetized appendix list
can resemble a repository dump.

**Mitigation:** group appendices into three visibly named parts if the journal
style permits:

1. representation-theoretic refinements;
2. six-point calculations and examples;
3. verification and coordinate motion.

Alternatively combine Appendices B and C, and combine E--G into a single
supplementary-calculations appendix with subsections.  The final source should
prefer four substantial appendices over seven thin ones.

### Objection 3: moving lift results weakens the claim of an exact group

The main theorem classifies a projective logical group.  Coherent unitary lifts
and affine nonsplitting are refinements, but readers may interpret their
removal as hiding a phase issue.

**Mitigation:** retain a short main-text corollary distinguishing:

- projective logical classification;
- coherent lifting of the linear factor; and
- nonsplitting of the Pauli translation extension.

Move proofs and normalization details, not the distinction itself.

### Objection 4: moving twisted-diagonal propagation erases the reason for the
site-dependent convention

This would directly weaken the introduction and the novelty comparison.

**Mitigation:** retain the propagation formula and square-class criterion in
the main text.  Only the full inner/outer-automorphism proof should move.

### Objection 5: leaving the pencil theorem in the main text preserves the
"two papers" problem

Possibly.  The pencil classification is mathematically substantial and uses a
different toolkit from the all-length theorem.

**Mitigation:** apply a hard main-text budget: no more than three pages for the
pencil, including motivation, definitions, theorem statements, and proof
roadmap.  If it cannot be presented honestly in that space, the correct
decision is a companion paper rather than an overcompressed theorem.

### Objection 6: a main-text theorem with certificate-heavy proof in an
appendix looks underproved

The LC/LU pencil classification depends on exact holonomy and collision
handling.  Merely pointing to a JSON certificate is not enough for a main
theorem.

**Mitigation:** retain in the main text a precise mathematical proposition
describing the invariant, why it is conjugacy/scalar/inversion invariant, what
canonical datum it recovers, and exactly which finite collision assertion is
delegated.  The appendix and supplement may carry exhaustive bookkeeping, but
the logical reduction must remain in prose.

### Objection 7: moving the verification table hides epistemic boundaries

The verification table is one of the paper's strengths.  Moving all of it can
look like demoting caveats.

**Mitigation:** keep the main-text paragraph stated above and put a prominent
cross-reference immediately after any certificate-assisted theorem.  The
appendix table remains auditable; only implementation detail is delayed.

### Objection 8: the scalar-invariant theorem is not rescued merely by calling
it an appendix

Correct.  It addresses a different conceptual question: why certain scalar LU
invariants fail while operator-valued marginal data succeed.  This is related
to rigidity but not necessary for the transversal-group theorem.

**Mitigation:** after appendicization, conduct a separate deletion test.  If
removing Appendix D leaves every advertised headline intact, it is a candidate
for a short companion note or omission from the submission version.  Its
presence should be justified as a limitation theorem, not as another
application.

### Objection 9: the Clebsch material can recreate an unwanted portfolio
identity

The README has already been corrected so that this paper is not presented as
part of a Clebsch series.  A long named appendix could nevertheless make the
example appear to define the paper.

**Mitigation:** call it a worked six-point example, keep its main-text mention
to one paragraph, and avoid promotional language.  If a combined six-point
appendix is used, prefer the title "Syndrome geometry of a six-point example"
unless the code name is needed for discoverability.

### Objection 10: moving text creates silent scope drift

This is the principal technical risk.  Prime versus prime-power scope,
field-linear versus trace-symplectic Clifford actions, fixed coordinates versus
coordinate permutations, and unitary versus matrix projectivization currently
appear near the statements they qualify.

**Mitigation:** duplicate only short hypotheses, not arguments.  Every moved
theorem must retain its own field and equivalence-relation assumptions.  Run a
scope audit independent of the TeX build.

## Alternatives considered

### Alternative A: leave the current architecture unchanged

This has the lowest mechanical risk and preserves the full narrative, but it
does not answer the cold referee's strongest presentational objection.  It is
reasonable only if the target venue welcomes long interdisciplinary papers and
has no practical page pressure.

### Alternative B: split the pencil and Clebsch material immediately

This would produce the cleanest all-length theorem paper.  It would also
require a second introduction, bibliography, verification surface, repository
export, and independent justification for the companion.  Some of the
six-point results derive their significance from the transversal-group theorem,
so premature splitting may create duplication.

### Alternative C: appendix-first restructuring, then reassess

This is the recommended path.  It is reversible, preserves all mathematics,
tests whether hierarchy alone resolves the problem, and produces the evidence
needed for a later split decision.

## Go/no-go gates

Proceed with the appendix-first version only if all of the following hold:

1. A reader can stop at the main conclusion and have a complete proof of the
   exact projective logical-group theorem.
2. No appendix is needed to know why the algebra is
   \(\mathbf F_q\times\mathbf F_q\) or \(M_2(\mathbf F_q)\).
3. The twisted-diagonal formula remains visible in the main text.
4. The pencil theorem has an honest, self-contained proof roadmap in the main
   text.
5. The main conclusion occurs by approximately page 18.
6. A main-text-only cold reader reports no missing proof step or unexplained
   scope qualification.
7. A full-paper cold reader no longer describes the submission as two
   competing papers.

If gates 4, 5, or 7 fail, prepare a companion-paper split proposal.  If gates
1--3 fail, revert the relevant moves rather than accepting a weaker theorem
presentation.

## Recommended decision

Authorize a reversible appendix-first restructuring with two frozen
constraints:

- the exact group proof, endomorphism-algebra explanation, and
  twisted-diagonal statement remain in the main text; and
- the pencil receives at most three main-text pages, including its proof
  roadmap.

After a main-text-only cold read and a full-paper cold read, decide whether the
scalar-invariant appendix and the detailed six-point calculations should remain
in the submitted PDF, move to an external supplement, or become a companion
paper.  This sequence improves the current paper without committing too early
to a permanent split.
