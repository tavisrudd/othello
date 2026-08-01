# C752 — Paper I Lean proof-spine correspondence audit

**Lane:** `clebsch`

**Status:** queued after C751.

## Objective

Audit whether the pinned Paper I Lean surface proves the same mathematical
spine used by the final human proofs, rather than merely extensionally
equivalent endpoints. Freeze the exact interface that C753 must formalize.

## Work package

1. Pin the final C751 manuscript, statement identity, trust manifest, q11 Lean
   commit, axiom audit, and all paper-facing terminal declarations.
2. Build a bidirectional claim map. For every human lemma or causal stage,
   record the exact Lean definitions, hypotheses, normalization, declaration,
   proof mechanism, imported theorem or axiom, and downstream paper claim.
3. Audit the rigidity spine separately:
   - universal chord moments and defect identity;
   - the six-arc line bound;
   - the q=11 twelve-point upper/lower-bound trap;
   - the equality-to-Clebsch step and the exact two Dye assumptions;
   - associated-conic identification, code equivalence, decoder, and counts.
4. Audit the orientation spine separately:
   - the cover `A5/C5 -> A5/D5`, antipodal involution, self-paired orbitals,
     and one-point-per-fibre property;
   - the signed pentagon, `B^2=5I`, and
     `(A-A')^2=10(I-R)`;
   - triangle holonomy, four-point identities, pair balance, switching
     uniqueness, and augmentation descent;
   - principal minors and the determinant pencil;
   - the cross-golden block, trace-dual complement, invariant cubic, node
     frame, projective symmetry, and integral commutant.
5. Classify every row as same-mechanism Lean proof, different-mechanism Lean
   proof, exact finite/kernel check, published conditional input, declared
   axiom, or human-only gap. A different-mechanism endpoint does not count as
   correspondence without an explicit bridge theorem.
6. Red-team definition equality at every language change: projective points,
   arc/chord/uncovered locus, Brianchon concurrence, cosets and leaders,
   orbitals, switching, signed moments, determinant normalization, node type,
   and integral lattices.
7. Audit the complete referee-facing prose and naming surface in every
   project-owned file of the transitive Paper I verification closure:
   - module headers, theorem and definition docstrings, ordinary comments,
     private-helper comments, and public declaration names;
   - generated-source banners, generators, templates, schemas, certificate
     descriptions, axiom-audit prose, and user-facing diagnostics;
   - every external citation and every repository-local artifact reference.
   Require each item to state the actual mathematical object, convention,
   hypothesis, conclusion, proof or checking mechanism, and residual trust at
   the strength elaborated. Flag stale section-relative prose, workflow/task
   vocabulary, reverse references to internal notes, unsupported strength
   words, vague “verified in Lean” claims, and comments describing a different
   proof spine from the declaration graph.
8. Freeze a dependency-ordered C753 interface with exact declaration names,
   files, expected proof mechanisms, imported boundaries, and validation
   gates. Split or defer a target if its honest closure exceeds one bounded
   formalization item.

## Acceptance

Every manuscript proof stage has one unambiguous formal status and exact
definition correspondence. No endpoint theorem is credited for a different
human mechanism without a proved bridge. The two Dye assumptions and the
Hassett--Tschinkel input are stated at precisely the strength used. C753 has a
reviewed, dependency-ordered interface and no design work remains hidden in
the implementation task. Every file in the referee-facing formal closure has
an exact prose and naming verdict, including generated and private surfaces.

## Boundaries

This is an audit and interface-freeze task. Do not edit Lean, regenerate
certificates, change theorem statements, or broaden Paper I's mathematical
scope. Any proposed formalization of a published input must be separately
justified; a clean conditional interface is acceptable.
