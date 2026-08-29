# Quantum-codes lane

**Lane:** `quantum-codes`

## Purpose

Own standalone quantum-code constructions, exact compilers, certificate tooling,
and gate-structure investigations that consume geometric or coding-theoretic
results from other lanes but do not belong to those lanes' manuscripts.

## Current status

C967 is queued as the first lane task. It compiles the jet-quotient CSS family
exposed by the Clebsch Schur--Sarkisov calculations, with the transversal-phase
question retained as a separate research gate inside the task.

The closest existing manuscript is *Diagonal Isoduality and Transversal
Clifford Groups of MDS--CSS Codes* (AME Paper II), but C967 is not assigned to
that paper: its code family is neither an AME family nor the paper's MDS--CSS
family. Any eventual publication surface is a standalone companion or tool
unless a later, explicitly authorized placement task decides otherwise.

## Boundaries and inputs

- Clebsch Schur--Sarkisov, `ame-lu`, and `complete-ports` results are read-only
  inputs until an explicit import or correction is authorized.
- Do not edit the numbered Clebsch papers, either AME manuscript, their formal
  companions, or their standalone mirrors from this lane.
- Do not call the jet-quotient state AME: at `q=11` its established property is
  3-uniformity, not absolute maximal entanglement.
- Keep the compiler deliverable independent of the open transversal
  non-Clifford phase test; a negative gate result does not block exact code
  construction and certification.
- Make no novelty or state-of-the-art claim without a dedicated literature
  audit against asymmetric quantum GRS and related CSS constructions.

## Allowed paths

- `notes/handoffs/2026-08-25-quantum-codes.md`
- `notes/quantum-codes-tasks/`
- `notes/quantum-codes-reports/`
- `notes/2026-08-25-quantum-codes-discovery-track.md`
- `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` (read-only input for C997)
- a new repository-local compiler/certificate directory chosen by C967 after
  its mathematical schema gate
- the exact C967 row in `notes/2026-07-07-codex-task-queue.md`
- the `quantum-codes` routing row in `AGENTS.md`

## Queue

1. **C967 -- jet-quotient quantum-code compiler.** Freeze the construction and
   normalization, emit exact checks/logicals/certificates, replay `q=11` and
   `q=13`, and decide the transversal-phase gate without manuscript edits.
2. **C997 -- symmetry-reduction gate for exact qLDPC distance solvers.** Add
   automorphism-orbit symmetry breaking to the public gross-code integer
   program and to the passant code, count branch-and-bound nodes, and pass or
   close the proposal at roughly 5x. Research gate only; no ergodis or
   manuscript edits. Card:
   `notes/quantum-codes-tasks/c997-qldpc-distance-symmetry-reduction-gate.md`.

## Entry action

Read the C967 task card, then freeze the source theorem statements and exact
finite-field normalization before selecting an implementation stack.

Incidental observations belong in
`notes/2026-08-25-quantum-codes-discovery-track.md` under the repository
discovery-track convention.
