# C810 — Distance of aligned-design certificates

**Lane:** `clebsch`  
**Date:** 2026-08-02  
**Verdict:** complete; the unrestricted two-graph certificate has exact
minimum distance two at the first faithful order, so it detects one adversarial
bit but corrects none

## Result

Let \(\tau\) be a two-graph on a labelled set \(V\), written additively over
\(\mathbf F_2\), and let
\[
 A(\tau)_Q=1
 \quad\Longleftrightarrow\quad
 \tau\text{ has the same value on all four triples of }Q
 \qquad(Q\in\binom{V}{4}).
\]
Global complementation of \(\tau\) does not change \(A(\tau)\). At
\(|V|=7\), both before and after quotienting by vertex relabelling, the exact
minimum Hamming distance between distinct complement classes is
\[
 d_{\min}=2.
\]
Consequently the exact adversarial unique-decoding radius is
\(\lfloor(d_{\min}-1)/2\rfloor=0\). The certificate detects one substituted
bit and corrects one erasure, but it cannot correct one unknown substitution.

The small exact census is as follows. The labelled column quotients only by
global complement. The quotient column also identifies vertex relabellings.
The last column gives the complete distribution of quotient distances over
unordered pairs of inequivalent classes.

| \(n\) | labelled classes | quotient classes | labelled \(d_{\min}\) | quotient \(d_{\min}\) | quotient pair-distance spectrum |
|---:|---:|---:|---:|---:|---|
| 4 | 4 | 2 | 0 | 1 | \(1^1\) |
| 5 | 32 | 4 | 0 | 1 | \(1^2,2^1,3^1,4^1,5^1\) |
| 6 | 512 | 10 | 0 | 1 | \(1^2,2^6,3^8,4^4,5^7,6^6,7^2,8^1,9^3,10^1,11^1,12^2,13^1,15^1\) |
| 7 | 16,384 | 27 | 2 | 2 | \(2^1,4^{42},6^{71},8^{64},10^{63},12^{40},14^{21},16^{13},18^8,20^6,22^5,24^4,26^6,28^4,30^3\) |

There is one symmetric conference switching class at order six and none at
the other orders in this table. Thus the first exact conference row is
vacuous as a distance comparison. The negative unrestricted result triggers
the task's cheap-stop condition; no claim is made here about the distance
inside the conference-only subfamily at its first order with multiple classes.

## Structural proof at seven points

For a four-set \(Q\), write its four triple values as
\(x_1,x_2,x_3,x_4\). Their sum is zero. Over \(\mathbf F_2\), its aligned
indicator is therefore
\[
 a_Q=1+\sum_{i<j}x_ix_j:
\]
this is one at weights zero and four and zero at weight two.

Every two-graph is obtained from the zero two-graph by toggling rooted-graph
edges. Toggling the edge \(ab\) adds one precisely to the triples containing
\(ab\). Only four-sets \(Q=\{a,b,x,y\}\) can change their aligned status.
If the two toggled triple values are \(\tau(abx)\) and \(\tau(aby)\), the
change of \(a_Q\) is
\[
 1+\tau(abx)+\tau(aby).
\]
Summing over the pairs \(\{x,y\}\subset V\setminus\{a,b\}\), the parity of the
number of changed certificate coordinates is
\[
 \binom{n-2}{2}+(n-3)\sum_{z\ne a,b}\tau(abz).
\]
For \(n=7\) this vanishes. The zero two-graph has all
\(\binom74=35\) four-sets aligned, so every seven-point aligned certificate
has odd weight. Every pairwise distance is therefore even. Aligned-design
faithfulness at seven points rules out distance zero between distinct
complement classes, giving the lower bound two. The same calculation gives
the cheap general upgrade that all aligned-certificate weights have the same
parity when \(n\equiv3\pmod4\).

For equality, use vertex \(6\) as root. Let the two rooted graph edge sets be
\[
\begin{aligned}
 E_A&=\{01,02,05,14,23\},\\
 E_B&=\{03,04,05,12,14,23,34\}.
\end{aligned}
\]
Their aligned families in this common labelling are
\[
\begin{aligned}
 \mathcal A_A={}&\{0125,0346,1234,1256,1356,2456,3456\},\\
 \mathcal A_B={}&\{0125,0346,1234,1356,2456\}.
\end{aligned}
\]
They differ exactly on \(1256\) and \(3456\). Their aligned-family sizes are
seven and five, so no relabelling or global complement can identify them.
This proves the upper bound and hence the exact theorem without relying on
the orbit census.

The distance-two pair also gives the sharp decoding obstruction. Flip either
one of its two differing coordinates in the first certificate. The received
word then lies at distance one from both valid certificates, so deterministic
one-substitution correction is impossible even with optimal decoding.

## Exact computation and trust boundary

The deterministic generator represents a two-graph by the
\(\binom{n-1}{2}\) bits of a rooted graph. Adjacent vertex transpositions and
global complement generate the equivalence orbits. For every quotient-class
pair it generates one certificate orbit and minimizes the Hamming distance
against a fixed representative. It exhausts all \(2^{\binom{n-1}{2}}\)
labelled two-graphs for \(4\le n\le7\); it makes no assertion beyond that
domain.

Two checks are independent of the all-pairs minimization:

1. every labelled certificate is recomputed from homogeneous triples in a
   separately rooted graph formula; and
2. a hash table of all labelled certificate orbits searches all distance-zero
   collisions and all one-bit neighbours directly.

Orbit sizes also sum to the complete labelled space, and the quotient spectra
contain respectively \(\binom22,\binom42,\binom{10}2,\binom{27}2\) pairs.
The computation is exact integer/bitset arithmetic using only the Python 3
standard library. The trusted boundary is the Python interpreter and the two
implementations in the recorded script; the structural seven-point proof and
displayed equality witness independently establish the load-bearing distance
claim.

Replay from the repository root:

```sh
python3 notes/2026-08-02-c810-aligned-certificate-distance.py --check
sha256sum -c notes/2026-08-02-c810-aligned-certificate-distance.sha256
```

The generator is 12,145 bytes with SHA-256
`b57256b1ed09885049d4e53f80d17ccefd35c82eecdac89f9ad61d38b6f559a6`.
The canonical JSON certificate is 10,827 bytes with SHA-256
`f9a63de2cd5a146175476fdc31a2ddcd423c94f9621fc314e47d18cdb111e28d`.

## EJ + Tao closeout and mystery ledger

The closeout pass replaced the computational distance-one exclusion by the
edge-toggle parity formula. It explains the all-even seven-point spectrum,
extends for free to every \(n\equiv3\pmod4\), and separates one-error detection
from one-erasure correction and one-substitution correction.

- **Settled — why every seven-point distance is even.** The edge-toggle
  formula makes certificate-weight parity invariant and fixes it to
  \(\binom74\equiv1\pmod2\).
- **Settled — whether quotienting hides the nearest pair.** The equality
  pair has different certificate weights, so it remains inequivalent after
  every permitted relabelling and complement.
- **Open outside the stop condition — conference-only distance.** This census
  reaches only the unique order-six conference class. Determining the first
  multi-class conference distance requires an independently allocated
  restricted-family task with canonical representatives; it is not evidence
  for stronger correction in the unrestricted two-graph code.

## Scope

This is a mathematics-only negative boundary. No paper source, public
package, or novelty claim is changed. The strongest surviving recovery
statement is exact: at the first faithful order, one bit is detectable and
one erasure is correctable, while one adversarial substitution is not.
