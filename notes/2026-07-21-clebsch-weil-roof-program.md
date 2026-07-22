# Weil-roof execution controller

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** active allocated battery. C444/M4 is GREEN; C445/M5 is the next critical-path task.

This is the shared controller, not the task specification catalogue. Historical motivation is in
[`2026-07-21-clebsch-weil-roof-conversation-report.md`](2026-07-21-clebsch-weil-roof-conversation-report.md)
and is never a routine preload. Closed outcomes are summarized here and archived in
[`handoffs/2026-07-17-crowns-archive.md`](handoffs/2026-07-17-crowns-archive.md).

## Cold start

For a selected battery C-ID, read only:

1. this controller;
2. its one task card from the routing table;
3. only the frozen inputs named by that card.

Do not preload other cards, the conversation dossier, manuscript, `papers/`, archives, other
handoffs, or unrelated persona dossiers. A card may narrow context further.

## Shared result and dependency map

Every executor may rely on this map for neighboring context; load a closed report only when the
selected card names it as a load-bearing input.

| ID | Stage | Disposition / result | Downstream effect |
|:---|:------|:---------------------|:------------------|
| C440 | M0 | GREEN: binary forms, conic dictionary, and labels frozen | conventions for all tasks |
| C441 | M1 | GREEN: H3/B3/A3 vertices biject onto `P^1(F_q)` | reduction tables available |
| C442 + C458 | M2 + freeze addendum | GREEN: golden frame carries H3 sheet; rational Klein form is sheet-blind | unlocks M4/M5/T10 |
| C443 + C461 | M3 + repair | SHARP BLOCKERS: literal secant-product lift and every linear four-companion weighting fail | no integral tensor clause; torsor reading spun off to C462 |
| C446 | X1 | SHARP NEGATIVE: marker matchings are nonconcurrent | point-valued selector route closed |
| C460 | X1+ | GREEN: Frégier clouds recover unordered H3 sheets and the perpendicularity germ | usable by M5 and as T3 control |
| C447 | X2 | singleton comparison negative; shared-edge cross-sheet repair GREEN | exact local torsor for X3 |
| C448 | X3 | GREEN: orbit-valued selector theorem; point section costs one bit | framing input only |
| C444 | M4 | GREEN: B3 split fibres exchanged by outer `x->-x`, cubic scalar `2 sqrt2`, common `S3` seam; A3 central lifts fuse over one projective `S4` | unlocks M5 and strengthens T10 input |
| C445 | M5 | **NEXT** after C444 GREEN | closes master-stroke statement boundary |
| C449 | T2 | queued after M4 chain | split-Coxeter-torus mechanism |
| C450 | T3 | queued; independent after frozen inputs | Weil-module roof test |
| C451 | T4 | queued | theta/Roquette row, with clean negative allowed |
| C452 | T5 | queued | QR/Barker provenance wall |
| C453 | T6 | queued | conditional 13/19/31 predictions; no construction |
| C454 | T7 | queued | Klein-relative-cubic comparison |
| C455 | T8 | queued | C372/C378 Weil-operator verdict |
| C456 | T9 | queued | AME chirality LU verdict |
| C457 | T10 | M2 gate passed; schedule after C444 | quaternion-order structural upgrade |
| C459 | Q-forms | parallel and non-blocking | separates rational object from golden labeling |
| C462 | M3-torsor | QUEUED: certify the four-companion `Z/4` Galois torsor and its descent obstruction (exploratory memo confirmed sigma 4-cycle, prime equivariance, invariant discrepancy) | candidate base-changed replacement for the cut tensor clause; framing input to C445 and paper-2 gluing |

Critical path: `C444 -> C445 -> C449`. C450--C456 are independent once their cards' frozen inputs
are available. C457 consumes C444. C459 and C462 may run in parallel but must not displace a
critical-path slot. Phase 3 waits for dispositions of every allocated battery row.

## Task routing

- [`c444-m4-silver-fusion.md`](weil-roof-tasks/c444-m4-silver-fusion.md)
- [`c445-m5-gluing.md`](weil-roof-tasks/c445-m5-gluing.md)
- [`c449-t2-split-torus.md`](weil-roof-tasks/c449-t2-split-torus.md)
- [`c450-t3-weil-module.md`](weil-roof-tasks/c450-t3-weil-module.md)
- [`c451-t4-roquette-theta.md`](weil-roof-tasks/c451-t4-roquette-theta.md)
- [`c452-t5-qr-barker.md`](weil-roof-tasks/c452-t5-qr-barker.md)
- [`c453-t6-continuation-laws.md`](weil-roof-tasks/c453-t6-continuation-laws.md)
- [`c454-t7-klein-cubic.md`](weil-roof-tasks/c454-t7-klein-cubic.md)
- [`c455-t8-fourier-weil.md`](weil-roof-tasks/c455-t8-fourier-weil.md)
- [`c456-t9-ame-chirality.md`](weil-roof-tasks/c456-t9-ame-chirality.md)
- [`c457-t10-quaternion-reduction.md`](weil-roof-tasks/c457-t10-quaternion-reduction.md)
- [`c459-q-forms.md`](weil-roof-tasks/c459-q-forms.md)
- [`c462-torsor-descent.md`](weil-roof-tasks/c462-torsor-descent.md)

Phase-2 framing and Phase-3 synthesis are not routine task context. Load
[`weil-roof-tasks/phase2-phase3-synthesis.md`](weil-roof-tasks/phase2-phase3-synthesis.md) only when
that phase is explicitly selected and allocated.

## Executor guardrails

1. **Compute, never recall.** Verify every formula, coordinate, character, group fact, and classical
   identification used in a certificate. Program prose is a hypothesis until checked.
2. **Consume frozen conventions.** No task invents coordinates, labels, or projectivities. If the
   frozen convention cannot support the card, stop; do not silently rederive it.
3. **Stop and report a blocker** on a denominator at the residue characteristic, failed bijection,
   unexpected orbit/fibre size, contradiction with a frozen certificate, required convention
   change, or failed load-bearing citation. Do not improvise a repair beyond the card.
4. **Acceptance is literal.** Every object named under a card's acceptance section must appear in
   canonical JSON. Prose alone never closes a task.
5. **No scope invention.** Incidental leads get one discovery-log entry; they do not expand the
   card. No new brainstorming pass precedes Phase 3.

## Evidence and ownership

- Every computational task lands one atomic bundle: dated report, exact generator/checker,
  canonical JSON, checksum manifest, and independent replay or an explicit reason none exists.
  Inputs are referenced by SHA; output is deterministic and timestamp-free.
- A novelty, priority, or absence sentence triggers
  [`literature-audit-conventions.md`](literature-audit-conventions.md). Dossier citations are
  unverified until the consuming card resolves them.
- Outputs stay under `notes/`. Manuscript, `papers/`, Lean, source-lane handoffs, and foreign
  evidence are read-only. Cross-lane consequences are offered to the owning lane.
- Completed rows move through the queue/archive invariant and update the crowns handoff in the same
  coherent commit. Review the discovery discriminator before closure.

## Program exit

After all allocated cards close, load the Phase-2/3 card. The synthesis must classify every
Rosetta row as proved, checked, or dead; state whether the surviving identities agree canonically,
computationally only, or not at all; freeze the paper-facing recommendation without editing the
manuscript; and decide paper-2 go/no-go before new generative work.
