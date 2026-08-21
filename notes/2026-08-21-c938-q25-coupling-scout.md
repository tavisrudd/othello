# C938 — Q25 invisibility/collision coupling scout

**Lane:** `paper-frob-eq`
**State:** complete — bounded negative result

## Goal and stop gate

Seek a short geometric proof of `B+R≥66` for the exceptional two-fixed-point Q25 profile, which
would explain `L=B+R-34≥32` without replaying the residual coordinate classification. Use the
committed C150 census, C151 mask evidence, and existing handwritten geometry. Stop if the surviving
argument encodes the 1,189 residual classes, needs a fresh exhaustive search, or requires
regeneration or forced re-elaboration of a large Q25 certificate forest.

Scoped Lean work is allowed. A formal result must live downstream of the frozen generated layers or
avoid them entirely, and its validation must remain a small targeted build. Do not edit the residual
transport, class-link, dispatch, composition, or exhaustion trees.

## Acceptance

- Identify the geometric objects counted by `B` and `R` and the exact source of their coupling.
- Either prove `B+R≥66` by a compact invariant argument or record a precise obstruction showing why
  the committed aggregate/mask data do not support such a proof.
- Distinguish a conceptual explanation of the minimum from the optional `32`–`47` spectrum and the
  separate semantic-surjectivity gap away from the minimum.
- If the proof succeeds, state exactly how it changes C937's Q25 exposition and trust boundary.
- No large Q25 certificate regeneration or rebuild.

## Result

The scout did not find a compact geometric proof of `B+R≥66`. It closes negatively at the stated
gate: the available aggregate invariants, empty-carrier incidence distribution, and natural
section-charging decomposition do not produce the missing coupling without reintroducing a
residual case classification.

The exact balance is

```text
L = B + R - 34.
```

Writing `T=Σ choose(μ,2)` and `H=T-R=n₃+3n₄`, the desired lower bound has the equivalent forms

```text
B + T - H ≥ 66,
fixedMoment + occupiedMoment + 2H ≤ 2B + 78.
```

These reformulations isolate the obstruction but do not prove it: `B` must control both collision
loss off the empty carriers and the surplus caused by triple or quadruple concurrency on them.
C150 already showed that first and second moments, even with the separately observed extrema, leave
an eight-unit legal-count width and admit `L<32` in the aggregate LP.

There are six cross-pair secant-orbit centers. For one such center `x`, involving two selected
conjugate pairs and leaving the third mate line `m`, elementary incidence gives

```text
number of empty fixed lines through x
  = 4 + 1[x lies on AB] - 1[x lies on m],
B = 24 + a - t,
```

where `A,B` are the two selected fixed points, `a` counts the six centers on `AB`, and `t` counts
them on their corresponding third mate line. This clean formula still does not control `R`.

The exact scout found `82` different empty-line center-incidence signatures. On an empty line
containing `b` cross centers, the observed legal-count ranges are

```text
b              0    1    2    3    6
local legal   0–5  0–7  0–5  1–6  4–7.
```

Thus the elementary local pigeonhole bound `local legal ≥ max(0,b-2)` is attained for every
occurring `b`; no stronger bound depending only on the carrier's invisible-center count can prove
the global minimum. The `82` signatures also rule out the hoped-for tiny center-arrangement case
split. Turning them into cases would merely be a new encoding of the residual census.

A second exploratory route regarded the twelve nonfixed secant orbits as partial sections over the
empty carriers and tried to charge the target `choose(12,2)=66` by section invisibility plus new
collisions. Fixed mixed-first, cross-first, and greedy insertion/elimination orders all fail on the
normalized census. This was a falsifier for that proof shape, not an exhaustive search over all
orders, and is not promoted as a computational claim.

## Evidence bundle

The committed diagnostic extends the independent C150 enumerator without changing its field,
normalization, or exhaustive domain. From the repository root:

```sh
nix shell nixpkgs#gcc -c bash -lc \
  'g++ -O3 -std=c++20 -Wall -Wextra -Wpedantic \
   notes/2026-08-21-c938-q25-coupling-scout.cpp \
   -o /tmp/c938-q25-coupling-scout && \
   /tmp/c938-q25-coupling-scout > \
   /tmp/c938-q25-coupling-scout.replay.txt'
cmp /tmp/c938-q25-coupling-scout.replay.txt \
    notes/2026-08-21-c938-q25-coupling-scout.txt
sha256sum -c notes/2026-08-21-c938-q25-coupling-scout.sha256
```

| File | SHA-256 | Bytes |
|---|---|---:|
| `2026-08-21-c938-q25-coupling-scout.cpp` | `e5c7f94834a4d4fa568944faa5764d36eefb55464c86bb795c9fbe4c783573c7` | 21,483 |
| `2026-08-21-c938-q25-coupling-scout.txt` | `b5e3a1aca935fcc75a831dc786127d7d11bd4fc225b1b15a58511a54209dd98c` | 8,669 |

The run reproduces the established `469600` normalized arcs, minimum `32`, legal histogram, and
five equality classes before emitting the new line-incidence diagnostics. That agreement is an
invariant replay against C150, not an independent implementation of the new diagnostics. No
independent implementation was added because these diagnostics decide a negative scout and are not
adopted as manuscript claims. The output certifies only the stated normalized Q25 census; it does
not prove an unrestricted geometric inequality or the semantic `32`–`47` spectrum.

## EJ + TT closeout

The cheap extra value is the exact reduction of a prospective conceptual proof to
`B+T-H≥66`, together with the center formula `B=24+a-t`. This tells a future attack what must be
coupled: empty-line loss from cross centers, pairwise secant collisions, and higher concurrency.
The Tao-style stress test asks whether a change to dual line arrangements, partial sections, or a
global incidence inequality eliminates the residual coordinates. The section-order attempt was the
cheapest such test and failed; the `82` center signatures show that center incidence alone is not
the missing invariant. No further cheap task-owned upgrade survives the stop gate.

For C937, retain the existing exact certificate proof and explain its mathematical reduction
without suggesting that `32` has a known conceptual overlap proof. Do not add the `32`–`47`
spectrum to the paper. A later attack would need a genuinely new global incidence inequality, not
more moment bookkeeping.

## Mystery ledger

| Feature | Status | Exact remaining gap |
|---|---|---|
| Clean frontier `B+R≥66`, equality at `(23,43)` and `(24,42)` | open | No invariant proof coupling center invisibility to collision redundancy; the current proof remains residual certification. |
| Missing center multiplicities `b=4,5` on empty lines | unexplained but non-load-bearing | The census has only `b=0,1,2,3,6`; no structural exclusion was proved, and it does not by itself improve the sharp local bound. |
| Full `32`–`47` spectrum | deliberately outside scope | Existing mask cardinalities are lower bounds except at the five equality rows, and semantic surjectivity away from the minimum remains unproved. |
| C151 mask-spectrum replay references | handed to C318 | The report names two files removed as orphaned support payload by commit `6da475113`; the trust-manifest pass must describe the surviving evidence surface rather than cite them. |

The scout settles its own decision mystery: the currently visible compact invariants do not support
a conceptual replacement for the Q25 certificate layer, so C937 should proceed without one.
