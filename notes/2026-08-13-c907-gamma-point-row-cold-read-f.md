# Gamma point-row cold read F: ordinary flop

Date: 2026-08-13

Frozen authority commit:
`f73bcb4f837eed0aa8d512567b70c74534b1f61a`

Frozen PDF SHA-256:
`ed5c6c5d98ab158164e4885e8fc3734060b5fa724290b78658a20dbf9e2bd8b8`

Packet: Section 4 and the cited Lee--Lin--Qu--Wang source. The reader received
no internal research notes, prior reports, or proposed repairs.

Verdict: **MINOR**.

## Earliest unsupported implication

The introduction says:

> Consequently the point row has the same zero or nonzero restriction to
> every formal-monodromy packet transported by the graph gauge.

Under the manuscript's own definitions, the restriction is defined only on
a sectorially realized packet. The corresponding Corollary 4.2 statement has
the same defect, although its proof already invokes a transported sectorial
realization.

## Smallest repair identified by the reader

Require a sectorially realized formal-monodromy packet whose chosen
realization is transported by the graph gauge on the fixed continuation
branch. Theorem 4.1 survives unchanged.

The Section 4 proof otherwise passed the source check: pure-extremal support
kills the point descendants, Lee--Lin--Qu--Wang ring invariance is enough for
joint flatness, and the minimal transverse-degree divisor recursion is
valid. No descendant invariance is imported.

Strongest passage: the recursion around (4.3).

Highest-friction passage: the sentence asserting that the point columns are
their common classical column for every nonsingular extremal value. The
reader recommended one sentence spelling out that the Gamma class and
Chern character act trivially above the top-degree point class.

Source checked: Lee--Lin--Qu--Wang, arXiv:1401.7097, cached PDF SHA-256
`eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
