# C978: Cubic-stabilization m1 exposition repairs

**Lane:** `cubic-threefolds`

**Status:** queued

## Goal

Repair the exposition of `papers/cubic-stabilization-m1/` so that its main
result, proof architecture, notation, and section-to-section logic are easier
to follow on a first expert read.

## Scope

- Improve the theorem-first narrative, proof roadmaps, local transitions, and
  notation onboarding.
- Remove avoidable ambiguity, repetition, and forward-reference friction.
- Preserve all accepted mathematical claims, hypotheses, proof dependencies,
  citations, formal annotations, claim-map identities, and Lean terminal names.
- Escalate any repair that would change mathematical content or a provenance
  interface instead of folding it into this exposition-only pass.

## Acceptance

1. The paper's deterministic manuscript checks pass.
2. A fresh exposition-focused cold read finds no required clarity repair.
3. Any standalone synchronization follows the repository's mirror conventions
   and is verified against the authoritative manuscript.
