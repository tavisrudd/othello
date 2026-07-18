# C84: the residual-grid ledger does not transport to the conic-only game

**Date:** 2026-07-17  
**Lane:** `cap`  
**Status:** applicability boundary and exact proxy audit; the C84 adaptive-template route stops.

## Result

The proposed C84 two-ply ledger test is not type-correct as stated.

The C63 reservoir term uses the residual-grid `zone_v` together with the proved burned-row/column
floor. A C84 state contains only an arbitrary set of off-conic centres and its induced conic
Schreier graph; it does not retain the frame or distinguished grid directions needed to evaluate
that reservoir. The other ledger terms do not repair the mismatch:

- `interface_intruders` is constant during a conic opponent/reply round;
- `conic_xor_zero` is the exact P/N label of the whole C84 conic-only game, so using it to
  distinguish the winning reply would be circular; and
- defect components and live-conic drain are well-defined, but C77 and C80 already delimit them as
  accounting/termination data rather than a response theorem.

Thus this computation does **not** test or refute the genuine C63/C77 ledger in its residual-grid
domain. It tests the shared conic measures and one deliberately naive transport: count all legal
off-conic projective points as `zone_v`, insert that count into the C63 floor formula, omit the
circular xor term, and set

```text
Psi_proxy = reservoir_proxy + 6*components - 4*intruders.
```

Across all 470 class-D forced replies, the proxy and the shared conic measures fail every proposed
uniform contract:

| q | forced replies | winning proxy descends | every reply descends | winning minimizes proxy | winning maximizes drain | winning minimizes components |
|---:|---:|---:|---:|---:|---:|---:|
| 13 | 30 | 30 | 30 | 9 | 23 | 9 |
| 17 | 58 | 57 | 57 | 12 | 28 | 25 |
| 19 | 62 | 1 | 0 | 9 | 22 | 31 |
| 23 | 125 | 0 | 0 | 15 | 61 | 95 |
| 29 | 195 | 0 | 0 | 18 | 72 | 142 |

The apparent q13 descent is therefore both nonselective—all legal replies descend—and unstable by
q19. At q23 and q29 no unique winning reply decreases the proxy. Greedy C80 drain is not the
missing selector either: the winning reply maximizes the two-ply drain in only 72 of 195 q29
obligations. Even the full seven-coordinate value-blind tuple
`(components, edges, largest component, live, proxy, reservoir proxy, zone_v)` collides exactly
with a losing reply in 96 of the 195 q29 obligations.

This executes C84's stop rule. One-ply signatures, contextual packets, and now the only natural
two-ply accounting transfer have no field-stable contract. Adaptive finite-template mining should
stop. C84 returns to its genuinely full-dimensional route: prove positive-density P for the
generic Schreier family by spectral/probabilistic methods, then separately address transfer to
`(ON)`.

The C63/C77 ledger remains available in the full residual-grid/C74 program. This result only says
that C84's conic-only abstraction cannot consume it as its strategy mechanism.

## Evidence and replay

The canonical artifact `notes/2026-07-17-c84-two-ply-ledger.json` contains 480,071 bytes and stores
all 470 forced transitions, their root/child measures, proxy ranks, and losing-response collision
counts. The generator/checker `rust/scripts/c84_two_ply_ledger.py` contains 10,729 bytes. SHA-256
hashes for this report, the JSON, and the checker are in
`notes/2026-07-17-c84-two-ply-ledger.sha256`.

From `/home/tavis/src/othello` run:

```sh
python3 rust/scripts/c84_two_ply_ledger.py 13 17 19 23 29 \
  > /tmp/c84-two-ply-ledger.json
cmp /tmp/c84-two-ply-ledger.json notes/2026-07-17-c84-two-ply-ledger.json
python3 rust/scripts/c84_two_ply_ledger.py 13 17 19 23 29 --check
sha256sum -c notes/2026-07-17-c84-two-ply-ledger.sha256
```

Every residual root is independently checked against `c84_adaptive_core.solve`; the P-root and
forcing-pair counts agree with the earlier artifacts. The checker reconstructs legal off-conic
projective points directly and performs exact component-aware Sprague--Grundy recursion. No game
sampling is used.

The trusted boundary is the coordinate residual graph, projective collinearity test, exact game
recursion, and the explicitly stated proxy convention. The proxy is not asserted to equal C63's
residual-grid reservoir. This is a finite prime-field class-D audit and says nothing about other
classes or an eventual spectral theorem.

## Next C84 target

Specify the generic class-D Schreier family as “fixed rooted-S4 gadget plus a varying involution”
and measure the spectral/equidistribution inputs needed for a positive-density P theorem. The first
gate is conceptual: identify a noncircular graph event or bounded strategy certificate whose
probability can plausibly stay positive under the varying fourth involution. Do not resume local
signature mining without such a certificate.
