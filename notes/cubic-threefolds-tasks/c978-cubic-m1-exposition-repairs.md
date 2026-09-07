# C978: Cubic-stabilization m1 exposition repairs

**Lane:** `cubic-threefolds`

**Status:** active

## Goal

Repair the exposition of `papers/cubic-stabilization-m1/` so that its main
result, proof architecture, notation, and section-to-section logic are easier
to follow on a first expert read.

## Scope

- Author priority (2026-09-07): the extensions must preserve accessibility
  and the original cubic headlines. Keep a complete first reading through
  the main obstruction before the additive and spectral refinements; review
  the abstract, introduction and section openings for competing headlines.
- Author instruction (2026-09-07): after the mathematical upgrades, audit
  terminology and symbols across both papers for standard specialist usage.
  Replace unnecessary coined labels, distinguish genuinely new definitions,
  and check notation for consistency and collisions. Coordinate with C956.
- Improve the theorem-first narrative, proof roadmaps, local transitions, and
  notation onboarding.
- Remove avoidable ambiguity, repetition, and forward-reference friction.
- Preserve all accepted mathematical claims, hypotheses, proof dependencies,
  citations, formal annotations, claim-map identities, and Lean terminal names.
- Escalate any repair that would change mathematical content or a provenance
  interface instead of folding it into this exposition-only pass.

## Acceptance

After the full upgraded drafts and terminology revisions are ready, run the
full-paper cold-read sub-referee protocol on both manuscripts (author
instruction, 2026-09-07). Include mathematical dependencies, specialist
terminology, adjacent-reader accessibility, and preservation of the cubic
headlines. Repair findings and replay the gates before considering the
unsent email. Earlier cold reads do not satisfy this new-draft requirement.

1. The paper's deterministic manuscript checks pass.
2. A fresh exposition-focused cold read finds no required clarity repair.
3. Any standalone synchronization follows the repository's mirror conventions
   and is verified against the authoritative manuscript.

## Current state

The abstract, introduction, proof roadmaps, technical transitions, and
consequences now use standard mathematical language for the block
decomposition, additive marker, coefficient fields, and separate center
summands.  The introduction defines the quantum D-module operationally and
explains both “even” and “generic” before using them.  The full deterministic
paper gate passes; all fourteen rebuilt PDF pages have been reviewed; and a
fresh exposition referee returned Accept after its two minor findings were
repaired.  Authority commits `26ed17e86` and `a19ec904f` were exported and
verified in standalone commits `03d6989` and `5ac9211`, with byte-identical
PDFs.  The task remains active for the continuing manuscript and public
formal-review prose pass.  A subsequent full cold-read referee protocol found
the primary manuscript and every PDF page acceptable; its only required
repairs were legacy terms in public claim-map descriptions.  Those prose-only
repairs were accepted on rereview and committed as authority `bc39e8509` and
standalone `2faeb8a`.  The later clarification of the generic QDM convention
was synchronized at authority `01cf1eddc` and standalone `bc3d52a`.  A final
minor terminology pass defines the even QDM as a convention, makes the
center-summand and residue-class sentences literal, and repairs the grammatical
parallelism of the novelty paragraph.  A final five-edit pass then replaced two
metaphorical stabilization phrases, made the Lax sentence's grammatical
subject literal, described the marker as retaining less structure, and put the
Fermat cubic directly in \(\mathbf P^4\) in its display.  No other prose changed.
The last optional copy edit tightens the definition of the even QDM and gives
the novelty sentence parallel verb structure.  It is synchronized at authority
`cf56c9b44` and standalone `c52be41`; both gates and exporter verification pass
with content SHA-256
`b15dbbc7d0c387080ad007c24f62a7df25e2791562ed6b7d6e23c41d2486a892`.
C978 remains active by author instruction.

## Astra exposition follow-up, 2026-09-07

Implement the m1 editorial decisions in the linked review after coordinating
with C1116. The cyclic repair is already present; C1117 and C1120 own new
mathematics. Prioritize the early occurrence-indexed reduction, rank-two
model, distinct invariance arguments, and notation collision. Preserve
provenance and avoid introducing unproved upgrades in overview prose.

Review: `notes/2026-09-07-cubic-astra-review-triage.md`.

Author clarification: make the revision navigable for Zhijia Zhang and other
birational geometers without prior QDM familiarity. His August 26 comment,
together with the ChatGPT exposition feedback, motivates this audience target.
Show the birational reduction first and the rank-two model before abstraction;
do not promise that the specialist comparison proof needs no QDM expertise.
