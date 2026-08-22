# C939 — Unified asymptotic separation revision for complete ports

**Lane**: `complete-ports`

**Status**: QUEUED
**Allocated**: 2026-08-21
**Source assessment**:
`notes/2026-08-21-c678-complete-ports-percentile-referee.md`

## Intent

Raise the complete-ports paper's mathematical ceiling by making one program
structurally dominant:

> a represented seed port is produced geometrically or explicitly; weighted
> transfer embeds it on a positive-density coordinate class; its bounded
> reliability, EXIT, and pointed-Tutte consequences survive in an
> asymptotically good family.

This is a theorem-strengthening item, not a general polishing pass. Do not
restructure the paper until the primary new theorem passes its mathematical
and formal gates.

## Primary crown

Lift the represented pair in Proposition 6.3 through the positive-density
transfer theorem. Target a theorem producing two asymptotically good
fixed-alphabet code families with designated positive-density coordinate
classes such that:

1. the two local seeds have the same full pointed subset profile and hence the
   same full pointed-Tutte specialization;
2. their conventional local data are matched as far as the current seeds
   permit;
3. their radius-three reliability functions remain distinct,
   `2s^3-s^6` versus `2s^3-s^5`;
4. the same outer family is used when possible, so global rate and distance
   bounds are matched rather than merely comparable; and
5. every transfer hypothesis, especially the exact `z_x(I)` gate, is proved
   rather than inferred from the finite profile.

If the exact target theorem fails, determine the sharp obstruction and retain
only the strongest honest matched-family separation. Do not weaken silently.

## Phase gates

### A. Seed and transfer audit

- Reconstruct the two represented seeds and their pointed full/bounded data
  from the existing proof and replay bundle.
- Compute or prove the exact pointed zero-functional costs needed at radius
  three.
- Check whether one common outer family gives identical global parameter
  formulas.
- State the sharp theorem before manuscript restructuring.

### B. Human proof and Lean boundary

- Give a complete human proof exposing why the full pointed invariant agrees
  while the bounded reliability differs after transfer.
- Add statement-adequate Lean declarations for the transfer/separation claim,
  with the outer-family existence input explicit rather than axiomatized
  invisibly.
- Extend the complete-ports gate, terminal ledger, axiom audit, and immutable
  formal-boundary manifest only after the declarations build through the
  guarded Lean workflow.

### C. Unifying paper revision

After A and B pass:

- add one synthesis corollary stating that exact complete-port transfer carries
  all smaller support filtrations, normalized decoders, matching/transversal
  data, blocker leading terms, multivariate reliability, and bounded-EXIT
  differences; include the pointed-Tutte specialization at full radius;
- rebuild the narrative around
  `seed -> transfer -> positive-density family -> stochastic consequence`;
- make the new asymptotic separation the payoff joining the transfer,
  reliability, EXIT, and pointed-Tutte sections;
- compress or move classical calculus that is not used downstream; and
- retain the existing trust boundary while moving certificate-like bulk out
  of the main argument when possible.

### D. Geometric consequence gate

If it follows without a second research program, state the transferred
reliability contrast for the cubic and quartic flagships on positive-density
coordinate classes. Verify the exact blocker/failure exponents before using
the proposed `p^(q-1)` versus `p` language. Matching global parameters is a
bonus, not permission to broaden C939 indefinitely.

## Explicit non-goals

- More finite tables or formalization without a new unifying consequence.
- A general service-region, sequential-composition, coefficient-optimization,
  or log-concavity program.
- Reopening excluded C220 blocker strengthening unless the primary theorem
  genuinely requires it.
- Priority or novelty claims without the required literature audit.
- Public push, tag, DOI creation, or repository-history mutation.

## Acceptance gates

1. The asymptotic separation has an exact stable statement and complete human
   proof.
2. The two families' matched and unmatched invariants are listed field by
   field, with no ambiguity between designated-class density and total
   occurrence density.
3. The Lean statement matches the paper theorem and passes the guarded build
   and axiom audit.
4. The synthesis corollary is proved rather than presented as rhetoric.
5. The revised paper is warning-free, its control ledgers agree, and an
   independent cold referee finds no correctness blocker.
6. Only the reviewed commit is synchronized to the standalone export.
7. All commits stage and commit explicit paths; unrelated dirty work is left
   untouched.

## Deliverables

- Main report:
  `notes/2026-08-21-c939-complete-ports-unified-asymptotic-separation.md`
  updated with results, proof status, validation, and the required mystery
  ledger at closeout.
- Authoritative paper and control surfaces under
  `papers/complete-repair-ports/`.
- Task-owned Lean declarations and complete-ports trust-boundary updates only
  if Phase B is reached.
- Any computational evidence as a committed script/certificate/report bundle
  under the research-reproducibility conventions.

## First move on `go C939`

Read the complete-ports expert dossier and the applicable Lean/reproducibility
instructions, then audit the Proposition 6.3 seed pair for exact `z_x(I)`,
common-outer compatibility, and the strongest matched asymptotic statement.
Do not begin by moving sections.
