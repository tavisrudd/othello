# External session source notes (2026-08-01)

Verbatim copies of the three research notes from `~/tmp/claude-fable-physics-files.zip`, an external
Claude Fable session dated 2026-07-29. `SHA256SUMS` records the bytes as received. They are the
source material for C774--C785.

Catalogue against the local corpus:
`../2026-08-01-external-chat-artifact-gap-review.md`. Recovered verification
scripts and their replays: `../2026-08-01-c778-strip-certificates/`.

| File | Covers | Queued as |
|---|---|---|
| `approximate_rigidity_of_2uniform_states.md` | discreteness from 2-uniformity, stability with a party-count-independent constant, Fisher isotropy, 2-unitary gauge groups | C774--C777 |
| `diagonal_rigidity_phase_boundary.md` | Smith-normal-form classification of diagonal symmetries, the Schur-cube criterion, the order-8 existence criterion, the non-rigid staircase family | C778--C780, C785 |
| `rigidity_boundary_three_promotions.md` | certified plateau, qudit degree and level sectors, semi-Clifford torsor reduction | C778--C780, C782--C784 |

## Known defects in these files

Read them with these corrections in hand; both were established after the notes were written.

1. **The staircase family is wrong.** Both the phase-boundary note and the promotions note give
   `RM(r, 4r)` with uniformity growing like `n^(1/4)`. The divisibility threshold is `m >= 3r+1`, so
   the family is `RM(r, 3r+1)`, the exponent is `1/3`, and the first staircase point past length 16
   is 128 rather than 256. Verified locally; see
   `../2026-08-01-c778-strip-certificates/PROVENANCE.md`. The open strip is
   consequently lengths 70--74 **and** 81--124, not the single window the notes state.
2. **The Sidon dominance claim is false at two lengths.** The promotions note's correction log claims
   the justified bound dominates the one actually used at every certified length. It fails at lengths
   23 and 91. No shipped result depends on either; the reasoning is in the same provenance file.

The notes also flag their own soft spots, and those flags are accurate: the odd-torsion step of the
Schur-cube theorem is written twice and only the localization version is sound; the affine-twisted
extension of the classification to general stabilizer states is asserted rather than proved (C784);
the general p-power qudit sector is schemed rather than written (C782); and the stability threshold
is non-explicit.
