# C756 generalized-hyperfocused interface test

**Date:** 2026-08-10

**Scope:** saturated-internal branch; bounded polarity/blocker comparison

**Verdict:** the generalized-hyperfocused hypothesis is not produced by the
C756 dual-star reduction

## Exact comparison

A generalized hyperfocused k-arc H has all \(\binom{k}{2}\) secants blocked
by only \(k-1\) off-arc points.  Each blocker therefore lies on the secants of
a perfect matching of H; the blocker set is exactly a one-factorization of the
complete graph on H.  Over an odd prime field, Blokhuis--Marino--Mazzocca then
force \(k\in\{1,2,4\}\).

For C756 put \(k=m+1=(q+3)/2\).  Polarity sends the hypothetical internal arc
to k passants in dual-arc position.  Equivalently, their dual points form a
k-arc Y.  The natural star

\[
 \mathcal B(Y)=\{\ell_i\cap\ell_j:i<j\}
\]

is in bijection with the secants \(y_i y_j\) of Y: the no-three-concurrent
condition makes all \(\binom{k}{2}\) star nodes distinct.  Polarity therefore
supplies one natural point per secant, not k-1 points which fuse the secants
into perfect matchings.

The covering condition

\[
 \mathcal B(Y)\text{ meets every secant and every passant}
\]

does not identify star nodes or create concurrence among the secants of Y.  It
states that the full \(\binom{k}{2}\)-point star blocks other line families.
It is logically different from asking a \((k-1)\)-point set to block the
secants of Y itself.

Choosing a projection line gives k-1 points which block the k-1 secants
through one chosen point of Y, but supplies no reason for those points to
block the remaining \(\binom{k-1}{2}\) secants.  This is merely the usual
projection of an arc and is not a canonical one-factorization.

## Consequences

The q=5 four-frame has its three diagonal points, as every 4-arc does, and so
meets the generalized-hyperfocused definition.  For k>4 the C756 hypotheses do
not produce the required blocker set.  The prime-field four-point theorem
cannot be invoked.  Even if such a blocker set were added as a new hypothesis,
the cited theorem is prime-field only and would leave the extension-field
boundary untouched.

Per the proof-dossier stop rule, the analogy is closed rather than developed
into a literature route.  The structural frontier returns to the actual
interfaces: the simultaneous cross-ratio kernel/cofactor problem in the
saturated branch and the masked Rédei missing-direction problem in the
nonsaturated branch.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| natural polarity blocker count | settled | \(\binom{k}{2}\), one distinct star node per secant |
| canonical \(k-1\) blocker set | absent | no forced one-factorization of secants |
| applicability of the prime-field four-point theorem | settled negatively | its defining hypothesis is missing |
| q=5 diagonal endpoint | settled | every 4-arc has the three required diagonal blockers |
| actual saturated structural route | open | adjugate/conormal coupling or coherent-star nonblocking |

## Source read

Blokhuis--Marino--Mazzocca, *Generalized Hyperfocused Arcs in PG(2,p)*,
arXiv:1304.3617, definition and main theorem; cached PDF SHA-256
`e99476de7becd4a901b3235fb342fcd1869f5555e6902a5f502ec0ab8430d903`.
