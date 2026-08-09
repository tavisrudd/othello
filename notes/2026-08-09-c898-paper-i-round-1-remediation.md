# C898 — Paper I round-1 remediation

**Date:** 2026-08-09  
**Status:** complete on review/remediation scope; formal replay transferred
**Owning task:** C898, retained for later rounds

## Scope

This remediation consumes the adopted-finding ledger in
`notes/2026-08-09-c898-paper-i-cold-read-round-1-synthesis.md`, not the sealed
persona dossier. It changes Paper I, its computational companion, the exact
verification surface, and the one editable C855 source note that repeated the
characteristic-five error.

## Round-1 findings closed

- The golden-normal-form proposition now gives projective stabilizer `A5` only
  away from characteristic five and `S5` in characteristic five. The proof
  restricts the two-root fibre argument and displays an explicit odd-coset
  matrix over `F5`; the attribution, companion remark, trust row, and C855 note
  are synchronized.
- The singular-locus proof now prints all five gradient quadrics and their five
  chartwise reduced Gröbner bases, exhausting exactly the six axis classes
  before the Hessian calculation. Section 9 identifies this as the load-bearing
  human certificate and the checker/formal declarations as independent replay.
- Proposition 6.3 now displays the two projective generators, all seven orbit
  seeds and sizes, and the exact breadth-first coverage statement. The
  paper-owned automorphism checker independently reconstructs all 133 points,
  both generator actions, both word-depth bounds, and the seven-orbit
  partition; the companion, README, and trust route state this finite proof
  mode consistently.
- The support-normalizer proof now displays coordinate, synthematic-total, and
  support-orbit actions. The manuscript names the classical synthematic-total
  and order-six conference-matrix conventions, separates global negation from
  switching, and gives a five-stage orientation roadmap.
- The BSW predecessor boundary is stated only at their published “up to
  isomorphism” level. No unsupported identification with a fixed-conic PGL
  quotient remains. Novelty is scoped to arbitrary-quadratic containment,
  nonsingularity/equality, and projective/code recovery.
- The Storme--Van Maldeghem incompleteness inference is spelled out, and the
  non-GRS claim now displays the nonzero quadratic-evaluation determinant.

## External remediation cold read

The user supplied a further dossier-based cold read of the intermediate PDF
with SHA-256
`467ac29ac6b7c1ecf6099bcc440c67016bde093c4304382d0c58b72203fbe7d8`.
It found no headline gap and returned `MINOR`. Its four findings were adopted:

- add the closer Blokhuis--Brouwer--Szőnyi `q=11` extremal elliptic-line-cover
  uniqueness comparison without making that computational result
  load-bearing;
- expose an independent paper-owned replay for the complete point-orbit
  partition and synchronize the proof-mode prose;
- print the five gradient quadrics beside the chart bases; and
- narrow the concurrence-spectrum priority language.

The same read recommended retaining the one-paper architecture. C898 therefore
does not split the manuscript before round 2.

## Lean, history, and companion audit

The false statement entered on 2026-08-03 at 14:02:25 PDT in commit
`2799bcbfc9f0568edb9a7afd2f56cef1fb057452`. Earlier manuscript text was
correctly restricted to characteristic eleven. The C855 source trail had
preserved the warning that the roots coalesce and the stabilizer might grow;
the integration overextended the index-two proof rather than compressing a
valid characteristic-five proof.

Lean never asserted the false stabilizer clause. Its golden normal-form
terminals prove coordinates/root existence, and its order-eleven rigidity
terminal remains sound. The companion's order-eleven `A5` statements were
already correct; its characteristic-five remark now records Dye's `S5`
exception.

The separate Luna repository sweep is recorded at
`notes/2026-08-09-c898-characteristic-five-stabilizer-doc-sweep.md`. The named
2026-07-31 results snapshot was correct and unchanged.

## Validation and next freeze

The deterministic manuscript builder currently reports 28 main-paper pages,
13 companion pages, and zero warnings. The repaired Paper I PDF has SHA-256
`241d09f5b6784097bea5f950643bd7baf16c9f629f2ad38ac526d1fb568ebe9f`.
The orientation checker, expanded automorphism/orbit checker, twenty-three
verification-tool tests, and nineteen-row trust-manifest validator pass. The
deterministic manuscript gate reports 28 main-paper pages, 13 companion pages,
zero warnings, and byte-current tracked PDFs.

The guarded aggregate Lean replay was started from the pinned q11 certificate
commit `930675c6b8bf44e06847d15bd6e63560caa6977f` in the disk-backed worktree
`/home/tavis/.cache/othello-worktrees/c898-q11-930675c`. Its required Mathlib
cache restore completed successfully, after which it began rebuilding the
pinned finite-geometry dependency. At the user's request it was stopped cleanly
while another large Lean rebuild was in progress. The interrupted run record is
`/home/tavis/.cache/othello-lean-build/run-20260809-211052-df95c0f6`; it did not
report a theorem failure.

On 2026-08-09 the author transferred the remaining aggregate Lean and final
release-certificate replay to the agent already performing the larger Lean
refactor. Those actions are no longer owned by C898 and do not block its
archive. The review/remediation authority is committed at `c8438909`; its
tool-generated standalone export is verified and committed at `9259b39`.
