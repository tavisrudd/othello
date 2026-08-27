# C977: cold paragraph accessibility read and repair

**Lane**: `reed-solomon`

**Status:** Active.  A context-clean reader is traversing the canonical TeX in
22 immutable packets, one paragraph at a time, with a contemporaneous journal
entry required before the next paragraph is opened.

## Goal

Improve the accessibility and expert-reader friendliness of *High-Weight
Cosets of Generalized and Extended Reed--Solomon Codes* for mathematically
mature readers who are not simultaneously specialists in coding theory,
finite geometry, algebraic geometry, invariant theory, and computational or
formal verification.

## Protocol

1. Freeze the canonical archival TeX into ordered paragraph files before the
   reader begins.
2. Give a reader with no manuscript or revision-history context exactly one
   packet per turn.  The reader records each first-pass reaction before opening
   the next paragraph and does not inspect the PDF, original source tree,
   manifest, later packets, prior reviews, or git history.
3. After the final packet, copy the raw journal verbatim into
   `notes/reed-solomon-tasks/c977-2026-08-27-cold-paragraph-reader-notes.md`
   before interpreting, ranking, or repairing any finding.
4. Synthesize repeated friction by cause and reader consequence.  Preserve
   theorem scope and proof order; prefer replacements and local bridges over
   added length.
5. Apply only accepted high-value repairs in the authoritative paper tree,
   rebuild both manuscript variants serially under the guarded low-memory
   wrapper, replay the supplement and software gates affected by the diff, and
   obtain a context-clean re-read of every changed paragraph and diagram.
6. Commit the authority, then export and verify the standalone paper repository.

## Owned paths

- `papers/high_weight_grs_cosets/**`
- `notes/reed-solomon-tasks/c977-*`
- this task's exact queue and Reed--Solomon handoff rows
- the matching standalone paper export, only after authority validation

All unrelated dirty work remains foreign.  No publication, push, deposit, or
theorem-domain change is authorized.

## Acceptance gates

- all 263 frozen paragraphs have contemporaneous raw notes;
- the raw dated memo is committed before synthesis or manuscript repair;
- every repair maps to a concrete accessibility failure in that memo;
- mathematical hypotheses, characteristic and field ranges, conditionality,
  terminology, citations, and verification boundaries are unchanged unless a
  separately justified correctness repair is required;
- the archival and TIT builds, paper facts, supplement checks, and relevant
  software checks pass;
- a cold changed-paragraph/layout review reports no remaining major issue;
- the deterministic standalone export verifies and remains unpushed.

## Current status

The raw packet read, opening/results/dictionary repair, recursive-carrier
repair, and simultaneous-escape section checkpoint are complete.  The latter
includes the correctness-driven removal of the vacuous rank-two
degree-one-gcd branch recorded in the dated synthesis.  Both manuscript builds
and the supplement gate pass.  Remaining work is the section-level pass from
the high-weight-coset theorem through the appendices, followed by one global
headline/novelty/prior-literature flow pass and the standalone export.
