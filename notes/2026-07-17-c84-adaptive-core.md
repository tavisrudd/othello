# C84: the mirror-free q=29 class-D fiber is adaptively P-rich

**Date:** 2026-07-17
**Lane:** `cap`
**Status:** exact finite theorem and strategy-shape obstruction; uniform abundance remains open.

## Result

Fix the (S_4) generating-triple class (D=(2,3,4)). For each prime
(q\in\{13,17,19,23,29\}), enumerate every legal fourth centre outside the rooted (S_4) and
solve its conic-only fixed-point-deleted Schreier residual exactly as Node Kayles.

At (q=29):

- all **753** escaping children were solved;
- **139** have Grundy value zero, a P fraction of (139/753\approx0.1846);
- their nimbers range from 0 through 11;
- none of the 753 children has a fixed-point-free nonadjacent involutory graph automorphism, by the
  companion pairing-obstruction census; hence all 139 P children require non-pairing play.

This adds q=29 class D to the positive-density empirical sequence and removes a possible ambiguity
from the pairing negative: the zero-mirror fiber is not P-depleted. Pairing fails because the
winning mechanism is adaptive, not because this class has no P children.

This is still a finite computation. It does not prove a q-uniform positive-density theorem.

## Exact nimber distributions

| q | escapes | Grundy-0 | P fraction | full nimber counts `g:count` |
|---:|---:|---:|---:|---|
| 13 | 131 | 24 | 0.1832 | `0:24 1:62 2:23 3:14 4:8` |
| 17 | 239 | 48 | 0.2008 | `0:48 1:34 2:41 3:60 4:20 5:22 6:12 7:2` |
| 19 | 305 | 40 | 0.1311 | `0:40 1:76 2:62 3:45 4:32 5:17 6:28 7:5` |
| 23 | 457 | 71 | 0.1554 | `0:71 1:64 2:116 3:65 4:33 5:33 6:15 7:6 8:37 9:16 10:1` |
| 29 | 753 | 139 | 0.1846 | `0:139 1:116 2:72 3:88 4:57 5:51 6:58 7:49 8:27 9:28 10:49 11:19` |

There are 1,885 exhaustively solved residuals in the tracked bundle. Since a strict overgroup of
the rooted (S_4) cannot be cyclic, dihedral, polyhedral, or Borel, Dickson's prime-field
classification places these escape children across the growing (PSL_2/PGL_2) boundary rather
than in the bounded catalogue.

## A one-reply bounded-core obstruction

For a P residual (R), define its one-reply component width

\[
W(R)=\max_{v\in V(R)}\ \min_{\substack{w\text{ a winning reply}\\
\mathcal G(R-N[v]-N[w])=0}}
\left(\text{largest component size of }R-N[v]-N[w]\right).
\]

Thus (W(R)\le b) means the second player can answer every first move and immediately leave only
components of size at most (b).

At q=29 the exact histogram over the 139 P children is

```text
W=14:5, 15:9, 16:29, 17:29, 18:51, 19:10, 20:6.
```

Therefore **every** q=29 class-D P child has an opponent move for which every winning response
leaves a connected component of size at least 14. A one-reply component-core theorem with bound
at most 13 is exactly false on this fiber. This does not rule out a larger bounded core, a
multi-reply descent, or a quotient whose blocks remain connected.

The corresponding width ranges are `0–3` at q=13, `1–8` at q=17, `2–10` at q=19, and `10–17` at
q=23. The growing finite evidence argues against treating the post-reply components themselves as
the desired q-independent core.

## Forced adaptivity

For each P residual, let (m(R)) be the minimum, over opponent moves, of the number of winning
replies. At q=29:

```text
m=1:91, 2:32, 3:11, 4:2, 5:3.
```

So 91 of 139 P roots have at least one opponent move with a **unique** winning response. The same
phenomenon is already dominant at q=13,17,19,23. This is the proof-shaped signal left after the
mirror and bounded-component routes fail: mine the unique-response transitions as algebraic
relations, then seek a multi-step descent or quotient that explains them.

## Evidence and replay

The primary checker `rust/scripts/c84_adaptive_core.py` uses a component-aware exact
Sprague--Grundy recursion. It checks every move, decomposes disconnected followers by xor, and
records the complete root nimber distribution plus the winning-reply statistics. Its largest memo
table among the tracked cases has 44,397 states.

The older direct recursion in `three_centre_probe.py`, which does not use the component-xor
shortcut, independently agrees on every one of the first 100 canonical q=29 class-D children
(including 15 P children); its largest table in that replay has 61,076 states. The q=13–23 root
counts also agree with the earlier independent C84 abundance census. A full direct replay is not
claimed.

From `/home/tavis/src/othello` run:

```sh
python3 rust/scripts/c84_adaptive_core.py 13 17 19 23 29 \
  --class D --summary --report-summary --check
python3 rust/scripts/c84_adaptive_core.py 29 \
  --class D --summary --direct-cross-check --limit 100
sha256sum -c notes/2026-07-17-c84-adaptive-core.sha256
```

The scripts use only Python's standard library and the existing independent coordinate graph
builder. The (S_4) representative search has fixed seed `20260717 + q` with exhaustive fallback.
The JSON is canonical and contains all load-bearing representatives, nimber distributions, vertex
counts, reply-width histograms, and memo maxima. No random game sampling is used.

The trusted boundary consists of the coordinate construction of the residual graph, ordinary
Sprague--Grundy recursion, xor decomposition of disconnected impartial games, and Dickson's
subgroup classification. The computation says nothing about non-enumerated fields.

## Next C84 target

Completed in `2026-07-17-c84-forced-reply-algebra.md`: all 470 forcing pairs across q=13--29 were
extracted. Their 88 canonical shortest coloured-word patterns all collide with nonwinning legal
responses, so no context-free involution word certifies the unique reply. The next discriminator
must condition on root geometry or certify a multi-response packet.
