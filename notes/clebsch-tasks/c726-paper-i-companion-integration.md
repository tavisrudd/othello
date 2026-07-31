# C726 — Paper I companion integration and trust closure

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** queued after C721--C725; C714 phase 6/6 and closeout.

## Objective

Integrate every successful structuralization and every surviving finite
certificate into one gap-free Paper I/companion proof surface, align formal
and executable trust claims, and close C714.

## Work

1. Build a claim map with exactly five proof modes: human structural proof,
   published theorem, Lean theorem, finite certificate, and trusted execution.
2. Edit the companion so every claim follows the order reduction, invariant,
   residual finite leaf, and replay; avoid duplicating the geometric paper.
3. Formalize adopted structural lemmas at precisely the granularity claimed in
   prose, or explicitly retain their finite proof mode. Do not use Lean as a
   label for a weaker transported statement.
4. Refresh trust JSON, checker outputs, hashes, commands, pins, axiom audit,
   statement-identity audit, and certificate-package documentation.
5. Rebuild the authoritative PDF, sync one-way to the standalone paper, and
   run the complete authoritative and mirror release gates against the same
   pinned q11 formal checkout.
6. Perform a cold proof-gap read focused on every place where a computation was
   demoted, then archive C714 and its phase cards under the lifecycle rules.

## Acceptance

No manuscript claim has a weaker proof after structuralization. Every demoted
computation has a complete replacement and remains available as an independent
check; every irreducibly finite claim states its complete domain and verifier.
All release gates are green with clean relevant worktrees.

## Boundaries

Do not cross C182's external-publication gate, reopen Papers II/III, or adopt a
structural argument merely because it is shorter. Any unresolved equality
case or unmatched theorem hypothesis leaves the exact certificate
load-bearing.

