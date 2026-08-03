# C761 — Paper IV q13 passant-code release

**Lane:** `clebsch`

**Status:** active; release blocked on C834 full-Lean closure by author
direction 2026-08-02.  C831/C832 structural version integrated under the longer
title *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a
binary conic code*.  The eleven-page warning-free manuscript now leads with
exact weighted-pair recovery of the full marked conic plane.  Its rank-28
theta certificate, global moment--stabilizer distance proof,
toric--octahedral minimum geometry, compact \(\mathbf F_8\) operator-field
core, six exact structural replays, shared Lean mechanisms, paper-owned
concrete gates, and axiom audit are green.  The earlier semantic rank,
minimum-layer exhaustion, orbit spanning, row-family uniqueness, and
four-anchor scheme-rigidity gates remain green.  The local release audit and
Paper-I forward pointer remain green.  Public packaging, immutable locators,
fresh isolated replay, and publication with explicit authority remain.  The
current partial formal mirror is not release-eligible: C834 must replace every
native/trusted finite leaf and human transport by a theorem-complete public
Lean aggregate first.

## Goal

Release Paper IV of the Clebsch program as a standalone arXiv preprint and
archived artifact centered on the binary passant incidence code of a
nonsingular conic in `PG(2,13)`.

The principal theorem gives parameters `[78,36,12]_2`, exactly 364 minimum
words in four `PGL(2,13)`-orbits, spanning by every minimum orbit, exact
arity-two recovery of the incidence matrix, code, elliptic scheme, full
marked `PG(2,13)`, conic and polarity, and exact coordinate-permutation
automorphism group `PGL(2,13)`.

## Owned paths

- `papers/q13-passant-code/`;
- `notes/2026-08-01-c761-paper-iv-plan.md` and later C761 evidence/report files;
- this task card;
- the C761 rows in the Clebsch handoff and global queue;
- future semantic Paper-IV modules under `lean/RelativeConicArcs/` and the
  paper-specific standalone certificate package, after the formal interface
  is frozen and a build window is acquired.

Paper I and its released artifacts are read-only predecessors. Evidence is
copied forward with provenance and fresh hashes; it is not moved out of or
silently shared with the released Paper-I surface.

## Work packages

1. Freeze the standalone theorem statement, reconstruction category,
   automorphism convention, title, and novelty boundary.
2. Extract the human proof from the computational companion, shortening the
   finite steps without hiding their exact domains.
3. Copy the q13 generators, certificates, and independent replay into the
   Paper-IV root; give them paper-local semantics, stable schemas, hashes, and
   one aggregate verifier.
4. **Green (partial formal coverage):** shared structural Lean modules, the semantic rank
   transport, and the
   sharded q13 certificate package described in
   `papers/q13-passant-code/verification/README.md`; close the explicitly
   recorded evaluator and orbit exhaustion boundaries before claiming full Lean coverage.  Row
   uniqueness is green through `PassantCodeQ13.Gates.Main.recoveredRowFamilyIsUnique`, and the
   concrete elliptic-scheme anchor gate is green through
   `PassantCodeQ13.Gates.Main.ellipticSchemeAutomorphismsAreProjective`.
5. Connect every manuscript statement to an exact Lean declaration,
   certificate, citation, or human proof and generate an axiom audit.
6. Update the released Paper-I companion by forward version: replace the full
   q13 proof with a theorem summary and Paper-IV citation without rewriting
   prior public versions.
7. Run citation, novelty, adversarial-proof, context-free prose, isolated
   artifact, and warning-free PDF gates; archive and post the preprint.

## Acceptance

- The paper is self-contained and does not require Paper I or internal notes
  to understand or replay its theorem.
- The main proof is structural wherever a mathematical reduction is known;
  finite certificates occur only at the irreducibly finite q13 leaves.
- The Paper-IV Lean gate states the exact theorem coverage, passes its axiom
  audit, and contains no private workflow references.
- Every exact execution has a committed generator, compact canonical output,
  independent replay, hashes, and exact domain/stop condition.
- The released Paper-I companion points to Paper IV rather than carrying a
  competing current proof.
- A clean checkout builds the warning-free PDF and replays the complete public
  verification surface from pinned dependencies.

## Boundary

Paper IV does not claim the all-field dimension theorem, a uniform minimum-
distance theorem, or the all-`k` conic-filling classification. C756 remains
the owner of the latter research problem. Paper IV may explain that its
weight-eight mechanism motivates a uniform route, but no open-program claim
enters the principal theorem.
