# Independent replay of the external session's numerics (2026-08-01)

Both numerical batteries in the external source notes reproduce here from
independent implementations. This is a spot check that de-risks C774 and the diagonal-programme
tasks; it is not their evidence bundle, because neither task has run and neither manuscript claim
has been adopted.

Source notes: `2026-08-01-external-session-notes/`. Catalogue:
`2026-08-01-external-chat-artifact-gap-review.md`.

## Bundle

| Artifact | Contents |
|---|---|
| `2026-08-01-external-source-numerics-diagonal.py` / `.json` | diagonal-rigidity note section 6 |
| `2026-08-01-external-source-numerics-quantum.py` / `.json` | 2-uniform note section 6 |
| `2026-08-01-external-source-numerics.sha256` | hashes and byte counts for all four |

Replay, from the repository root:

```
python3 notes/2026-08-01-external-source-numerics-diagonal.py --check
uv run --with numpy --with scipy python \
    notes/2026-08-01-external-source-numerics-quantum.py --check
```

Each `--check` regenerates in memory, compares against the tracked certificate, re-runs the
cross-checks, leaves the worktree unchanged, and exits nonzero on any mismatch. Dropping `--check`
writes the certificate to stdout. Dependency versions are not pinned in the certificates; the
quantum run used numpy and scipy as resolved by `uv` on 2026-08-01, and its floating-point outputs
are rounded to ten decimals so the certificate is platform-stable.

## Diagonal note, section 6 — reproduced exactly

Deterministic canonical enumeration, no randomness, exact integer arithmetic throughout.

| Code | weights | d | d-perp | uniformity | dim of third Schur power | annihilator | invariant factors |
|---|---|---|---|---|---|---|---|
| `RM(1,4)` | {0, 8, 16} | 8 | 4 | 3 | 15 of 16 | all-ones only | `1^5 2^6 4^4 8^1` |
| `Hamming[7,4]` | {0, 3, 4, 7} | 3 | 4 | 2 | 7 of 7, full | empty | `1^4 2^3` |
| `Simplex[7,3]` | {0, 4} | 4 | 3 | 2 | 7 of 7, full | empty | `1^3 2^3 4^1` |

Every figure the source states is matched: the third Schur power of `RM(1,4)` falls one short of
full, its annihilator is exactly the transversal-T direction, and the lone invariant factor 8 is the
non-Clifford symmetry. The Hamming control has all factors in {1, 2, 4}, so only Clifford diagonal
symmetries, as the Schur-cube theorem requires.

Three theory-level cross-checks run inside the script rather than a second copy of the same
algorithm: an invariant factor divisible by 8 appears exactly when every codeword weight is
divisible by 8; the all-ones vector annihilates the Schur cube exactly when the code is triply even;
and the number of invariant factors is consistent with the lattice rank. All pass for all three
codes.

**`Simplex[7,3]` is in the table as a trap marker.** The four cyclic shifts `1110100`, `0111010`,
`0011101`, `1001110` are rank 3, not 4 — the fourth is the sum of the first two — so they generate
the simplex code, not the Hamming code. Using them silently changes the invariant factors to
`1^3 2^3 4^1`. The conclusion survives, since everything is still at most 4, but the certified
numbers do not. Use a systematic generator matrix.

## 2-uniform note, section 6 — reproduced, with one caveat

Local generators are drawn from a seeded generator (seed 11), so the run is reproducible but the
generators differ from the source's. Absolute defect values therefore differ; the ratio column,
which is the actual claim, agrees.

The four-qutrit stabilizer state is exactly 2-uniform: every pair marginal is maximally mixed to
machine zero. The quantum Fisher identity holds to ten decimals. The defect is computed by two
independent routes — the overlap formula and a direct phase-optimized norm — which agree at every
scale.

| scale | ratio of generator size to root-q defect | hypothesis satisfied |
|---|---|---|
| 0.3 | 1.0861 | **no** |
| 0.1 | 1.0093 | **no** |
| 0.03 | 1.0008 | yes |
| 0.01 | 1.0001 | yes |
| 0.003 | 1.00001 | yes |

The ratio converges to 1 and stays under the ceiling of `sqrt(6/5) = 1.0954` throughout.

**The caveat, which C774 owns.** The stability theorem assumes the summed operator norms of the
generators are at most one half. At the two largest scales that quantity is 2.157 and 0.719, so
those rows lie outside the theorem they illustrate. The bound holds there anyway. The source note's
table has the same shape and does not mark it. Either restrict the displayed range to the region
where the hypothesis holds, or state plainly that the top rows are shown to exhibit the approach to
the ceiling and are outside the hypothesis. A referee will otherwise circle it.

The GHZ control behaves as claimed: the continuous product symmetry has exactly zero defect, and its
pair marginal sits 0.471 from maximally mixed in Frobenius norm.

## What this does not certify

It does not certify the stability theorem, which quantifies over all generators, nor the
discreteness theorem, nor any statement about codes or states outside the three codes and two states
enumerated. The threshold below which every approximate symmetry is near an exact one is
non-explicit in the source and is not computed here, so no certification or self-testing claim
follows from this bundle. The seeded generators exercise one direction in a continuum; they are
evidence that the identity is not an artifact of the source's particular draw, not a proof that it
holds for every draw.
