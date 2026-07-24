# C552 — integrate the C550 cover-holonomy theorem into the Clebsch manuscript

**Lane:** `clebsch`

**Date:** 2026-07-24

**Status:** task-owned `NO-GO` repair implemented; held open for the C320 post-fix review

## Goal

Replace the manuscript's certificate-first account of the four-copy contraction by C550's
reader-facing linear-sheaf theorem.  The paper should explain, before its verification boundary,

1. why constant sections give the universal three-dimensional kernel;
2. how the `24 x 21` system reduces to nine two-matching holonomy blocks on
   `k^4/k(1,1,1,1)`;
3. how the cycle ledger derives `z=2,4/9`;
4. how relative octahedral frames give the `96/192` multiplicities and `8/16` `A4` quotients; and
5. why the characteristic-7 merger and the ramification-only primes have different meanings.

Use the Milnor/Serre presentation already established in C550.  Keep the conceptual proof,
finite certificate, and exact trust boundary visibly separate.

## Required correction

Remove or correct every manuscript-facing use of C548's two inaccurate degree-six representation
descriptions:

- the order-24 group is the rotational octahedral action on six vertices, with point stabilizer
  `C4`, not the tetrahedral edge action with point stabilizer `V4`; and
- the axial `C2^3` seam has orbit sizes `2+4`, not `2+2+2`.

The abstract groups, double-coset sizes, common derived `A4`, and `8/16` quotient counts remain
unchanged.  State that the full octahedral symmetry belongs to the reduced linear transport frame,
not the bare bipartite multigraph.

## Acceptance gate

1. Integrate one compact theorem/proof path into the replacement-spine manuscript; do not add a
   competing spine or reproduce the checker narrative.
2. Preserve the exact hypotheses and boundaries: admitted non-GRS pencil, odd characteristic,
   signed versus reduced sheets, boundary coincidences versus pullback ramification, and no claim
   of complete pencil recovery.
3. Add or update the C320 claim/evidence and adequacy ledgers for every adopted C550 statement,
   including the exact report/checker/certificate hashes and mixed-verification boundary.
4. Correct all affected theorem prose, captions, tables, verification rows, and cross-references.
5. Render the manuscript and rerun its scoped deterministic release checks.  Any C320 independent
   review performed before this delta is stale; the required final review must cover the resulting
   manuscript and return `GO`.
6. Follow `papers/style-guide.md`.  Make no novelty claim without a claim-specific literature
   audit; C550 itself makes none.

## Implemented delta

The manuscript now contains one reader-facing theorem and proof,
`thm:four-sheet-holonomy`, inside the survival/erasure section.  Its three
separately routed clauses establish:

1. the constant-section three-space and exact reduction from the
   `24 x 21` quotient system to nine two-matching holonomy blocks on
   `U^3`, with `U=k^4/k(1,1,1,1)`;
2. the three localized cycle obstructions, the reduced divisor
   `(z-2)(9z-4)`, the `96/192` relative-frame multiplicities, and the
   free `A4` quotients of sizes `8/16`; and
3. the distinction among the characteristic-7 merger, the
   characteristic-11/13/41 pullback ramification, and the
   characteristic-3/5 excluded-boundary coincidences.

The proof gives the signed coordinates `w=+/-2/3` before passage to
`z=4/9`, and states the exact stop boundaries: admitted odd-characteristic
non-GRS pencil, fixed four-sheet contraction, no complete pencil recovery,
and no four-copy minimality.  It also corrects the inherited degree-six
action descriptions.  The order-24 action is rotational octahedral on six
vertices with point stabilizer `C4`; the axial `C2^3` seam has orbit
partition `2+4`; and the full octahedral symmetry belongs to the reduced
linear transport frame rather than the bare bipartite multigraph.

The public paper root now contains the self-contained semantic bundle
`verification/evidence/four_sheet_holonomy/`.  It carries rebranded,
workflow-free versions of the direct `24 x 21` checker, the `9 x 9`
cover-holonomy checker, both canonical certificates, a semantic README,
a checksum manifest, and one fail-closed `verify.py` entry point.  The
internal frozen-source hashes remain:

| frozen input | SHA-256 |
|:---|:---|
| C550 report | `72896f37c0fc7c410fb3282dc15a007613723d11e3f1145db1f4825ef5359cca` |
| C550 checker | `3709c9f0578c4868a838f67a56b5fa6cec41e1571c288d1a26eb2997005d52a7` |
| C550 certificate | `9d3bcb92d97d8fc84d4459cde906894d40e9c542d8ab389b5cf0b4fe29e5bda3` |

The public bundle deliberately changes workflow-bearing filenames,
identifiers, and schema names, then regenerates the canonical certificates.
Its checksum-manifest hash is
`c73124261d5584a304aaf3dc52649844a5dae717dc28908f28f29574b96b8fbf`.

The adequacy extraction now has 28 theorem-like environments.  The trust
manifest has 61 claim rows, including one exact theorem row and three
separate clause rows for the cover-holonomy result.  Each clause uses an
explicitly mixed route: the manuscript's conceptual sheaf/cycle/frame
proof plus the public exact replay.  No Lean claim or novelty claim was
added, and the shared-Lean pin remains
`43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.

## Validation

- `python3 verification/evidence/four_sheet_holonomy/verify.py` passed.  It
  regenerated the `12,184`-byte direct rank-drop certificate with SHA-256
  `687647e36d614999410b9f320d1cdab73fa980d3f2b46b63673563c707aac137`,
  regenerated the cover-holonomy certificate, and matched every
  hash-pinned artifact.
- The manifest builder produced 61 rows, and
  `verify_trust_manifest.py` accepted all 28 statement claims against the
  pinned shared-Lean checkout.  The six verification-tool unit tests
  passed.
- `make -B clebsch` rendered the 32-page PDF without a TeX error or
  undefined reference.  The only warnings remain the known underfull
  boxes in the narrow survival-ledger table.
- The pre-review clean release runner passed all 18 declared checks against Lean
  commit `43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.  Its deterministic
  output is byte-identical to
  `verification/verify-release-output.json`, with SHA-256
  `bc8b58f30bb63ecae39ad42f898899fa39047f95180ab2ff419073c95da5db90`.

The implementation is committed as `d06c1a03`; the post-commit
source-normalization hash refresh is `0c271cf9`.  The first clean-release
preflight correctly rejected the stale manuscript hash created by that
normalization.  Regenerating the adequacy and trust manifests from the
committed TeX bytes fixed the mismatch before any release check ran.

## Independent-review disposition

The user-launched C320 cold read returned `NO-GO`.  Its C552-specific
finding was that the theorem began from an undefined admitted pencil and
did not say whether it advanced the paper's reconstruction.  Commit
`c5deec3c` repairs both points:

- the paragraph before the theorem now displays all six columns of
  `H_t`, defines `h_i` and `g_i(x)=h_i^T x`, and identifies the theorem's
  nonvanishing condition as the admitted non-GRS locus; and
- that paragraph and the conclusion state the Paper-I consequence
  explicitly: the contraction retains only two resonance fibres, does not
  recover its pencil, and is a strict survival boundary rather than a
  parent-reconstruction mechanism.

The review's other blocking findings concern C320's geometric-parent
bridge, factorization/depth exposition, twelve Rosetta carriers, uniform
rank-three proof path, and “statement adequacy” terminology.  They are not
claims introduced by C552, and repairing them would violate this task's
stop rule against reopening the paper's global architecture.  C552
therefore remains unarchived until the owning C320 repair pass resolves
those findings and the user launches the required post-fix review.

The post-C552-repair release run reached its final immutability guard, which
correctly rejected the run because the owning C320 repair pass changed
`clebsch_hexagon_code.tex` concurrently.  The concurrent rewrite preserves
the displayed pencil and survival-boundary conclusion, but it is not a
frozen C552 release candidate.  C320 must regenerate the manuscript-derived
artifacts and rerun the 18 checks after that broader repair is committed;
this report makes no post-fix clean-release claim.

## `ej`/Tao closeout and mystery ledger

The closeout made three cheap upgrades.  It moved the frozen computation
into a workflow-free public bundle rather than leaving a reverse reference
to internal notes; split the theorem into three separately hashed trust
routes rather than assigning one aggregate label; and checked the actual
six-point actions rather than inferring geometry from abstract group
orders.  The last check is what forces the `C4` point stabilizer, the
axial `2+4` orbit partition, and the distinction between linear-frame and
bare-graph symmetry.

| feature | disposition |
|:---|:---|
| Why the universal kernel has dimension three | **Settled:** it is the constant-section space of the rank-three vertex sheaf. |
| Whether the `24 x 21` and `9 x 9` systems have only analogous kernels | **Settled:** gauging and systematic elimination give equality of excess kernel dimensions, reversed explicitly in the proof and checked on all finite replay fields. |
| Where `2` and `4/9` come from | **Settled:** the cycle ledger gives `B^2-2A^2` and `3B+/-2A`; squaring only then forgets the signed sheets. |
| Why the multiplicities and quotients are `96/192` and `8/16` | **Settled:** the relative-frame seams have orders `8/6`, and the common derived `A4` acts freely. |
| Whether characteristic 7 is another ramification prime | **Settled negatively:** the axial and signed-union root schemes merge modulo 7, whereas 11, 13, and 41 only double pullback roots. |
| Whether the octahedral groups act on the bare cover | **Settled negatively:** they act on the reduced linear transport frame; the bare multigraph has smaller symmetry. |
| Four-copy minimality, uniform `LU=LC`, and Paper 2 | **Outside the stop rule:** no wording or evidence route was added for them. |
| Final manuscript trust judgment | **Open only at the required process gate:** a user-launched independent review must cover the post-delta manuscript and return `GO`. |

No task-owned mathematical or reproducibility mystery remains before that
review.

## Stop rule

Stop when the manuscript and C320 release package consume C550 cleanly and pass their scoped local
gates.  Do not reopen four-copy minimality, the uniform `LU=LC` conjecture, a larger contraction
census, Paper 2, or the paper's global architecture.  Do not archive C320 or C552 before the
post-delta independent-review `GO`.

## Frozen inputs

- `notes/2026-07-23-c550-four-copy-cover-holonomy.md`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.py`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.json`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.sha256`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.md`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- `notes/2026-07-20-c320-clebsch-trust-ledger.md`
- `papers/style-guide.md`
- `papers/clebsch-hexagon-code/`

The C550 bundle is authoritative for the conceptual proof and representation correction.  C548
remains the independent exhaustive certificate.  C320 owns the final manuscript trust ledger and
release review.

## Independent-review disposition

The user-launched C320/C552 cold read is
`notes/2026-07-23-c320-independent-cold-read.md` and returned `NO-GO`.  For C552 specifically, the
four-sheet theorem enters from an admitted non-GRS pencil that is not defined before use, and the
manuscript does not explain how the theorem advances the Paper-I reconstruction spine.  This is a
paper-shape blocker, not a reported failure of the cycle calculation or public certificate.

Repair by defining the pencil and its bridge before the theorem and explaining the consequence in
the conclusion, or remove the theorem from Paper I.  Preserve the exact stop boundaries above.
After any repair, regenerate the 28-statement/61-claim artifacts as applicable, rerun the complete
18-check release entry point on a frozen commit, and request a user-launched post-fix review.
