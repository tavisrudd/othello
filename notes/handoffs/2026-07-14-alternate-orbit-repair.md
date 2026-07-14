# Alternate-orbit repair for invariant ten-arcs

**Lane**: `alt-orbit-repair` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-14
**Status:** OPEN — C142 queued; C143 gated on the representative-leaf feasibility check and a clear
Lean build window
**Tasks:** C142–C143

## Active-lane lock

This is the active sticky lane. Until the user explicitly switches lanes or this handoff is marked
finished, `go` and `next?` refer only to the next step recorded here. Work begins with C142; C143
does not trigger a generated-certificate rebuild until its small feasibility gate passes and the
concurrent Lean build window is clear.

### Allowed paths

- new alternate-repair modules under `lean/FiniteGeom/BaerCompletion/` and
  `lean/RelativeConicArcs/`
- the existing quadratic pair-count and Q25 profile modules needed to state or prove the repair
  results; generated Q25 certificate sources only under C143
- `notes/2026-07-14-c142-*`, `notes/2026-07-14-c143-*`, this handoff, and its companion archive
- this lane's rows in `notes/2026-07-07-codex-task-queue.md` and its routing row in `CLAUDE.md`
- `papers/equivariant-robust-completion/` and its index/planning rows only after the corresponding
  theorem and trust gates pass

### Foreign lanes

The closed `baer` lane supplies the pair-counting and Q25 extension theorems but does not own this
deliverable. Clebsch, cap, cubic, relative-conic, RepairCodes, Queens/Othello, and their working-tree
changes remain foreign. Do not edit, stage, or route their files into this lane.

## Goal

Turn the eight-arc pair-extension count into a family-specific erasure-repair theorem for
Frobenius-invariant ten-arcs. If a selected nonfixed conjugate orbit is deleted, the repair must use
a different legal conjugate orbit rather than merely restore the erased pair.

For an invariant ten-arc `A`, a selected nonfixed orbit `O`, and `D = A \ O`, the set `D` is an
invariant eight-arc and `O` is one legal pair extension of `D`. A lower bound of at least two legal
pairs for `D` therefore supplies an alternate repair.

## Already available

The closed Baer lane provides the exact global legal-pair cardinality bridge and these checked Q25
lower bounds for invariant eight-arcs:

| Fixed profile `f` | Certified legal pairs | Certified alternatives after restoring one deleted pair |
|---:|---:|---:|
| 0 | at least 5 | at least 4 |
| 2 | existence only | none yet |
| 4 | at least 4 | at least 3 |
| 6 | at least 36 | at least 35 |
| 8 | at least 110 | at least 109 |

For every prime power `s ≥ 7`, the general criterion gives more without a new certificate. An
invariant eight-arc has `M ≤ 12`, an empty carrier, and
`N = s(s-1)/2 ≥ 21`; hence it has at least nine legal conjugate pairs. Deleting a selected orbit
from an invariant ten-arc therefore leaves at least eight alternative repairs.

The independent Q25 census reports minimum legal-pair count 32 in the exceptional `f=2` profile.
This makes the two-witness strengthening mathematically low-risk, but it remains external evidence
until C143 installs a kernel-checked certificate. The value 32 is not a theorem target for this
lane.

## Open queue

| Task | State | Deliverable |
|---|---|---|
| C142 | queued; first | Kernel-checked `s ≥ 7` alternate-repair theorem with at least eight alternatives, plus the Q25 nonexceptional-profile repair bounds |
| C143 | gated after C142 | Representative-leaf two-witness test; if feasible, regenerate the exceptional `f=2` certificate, transport distinctness, and prove uniform Q25 alternate-orbit repair |

## C142 — certificate-free repair theorem

1. Load the named-expert proof context before Lean development.
2. Define the deletion/repair statement semantically in terms of unordered nonfixed Frobenius
   orbits and the existing global legal-pair finset.
3. Prove that deleting any selected nonfixed orbit from an invariant ten-arc over `s ≥ 7` leaves at
   least nine legal pairs and hence at least eight alternatives.
4. Package the existing Q25 bounds for `f=0,4,6,8` as alternate-repair counts.
5. Run scoped build, forbidden-token, declaration/axiom, and manuscript-to-Lean statement audits.

Report: `notes/2026-07-14-c142-alternate-orbit-repair.md`.

## C143 — exceptional-profile multiplicity

Start with one representative normalized leaf. Replace the existential witness target by two
distinct legal orbit codes and record source size, kernel time, memory, and downstream transport
requirements. Only after that gate passes:

1. generate two distinct witnesses for every valid normalized `f=2` row while retaining explicit
   non-arc witnesses for invalid rows;
2. rebuild the split certificate under the repository's capped-build/OOM protocol;
3. transport both witnesses and their distinctness through base-point and stabilizer normalization;
4. combine the five profiles into a uniform two-pair Q25 theorem; and
5. derive the uniform alternate-orbit repair theorem for invariant ten-arcs in `PG(2,25)`.

The result needs only two distinct pairs. Do not enlarge the certificate target to the external
minimum 32 unless a later publication gate specifically requires it.

Report: `notes/2026-07-14-c143-q25-alternate-orbit-repair.md`.

## Publication boundary

The certificate-free `s ≥ 7` theorem is already a rigorous paper-level corollary of the checked
counting machinery. The uniform Q25 repair statement enters the manuscript only after C143 passes.
No historical-first or literature-novelty language is permitted without a repair-specific priority
search; allocate that search separately if publication positioning requires it.
