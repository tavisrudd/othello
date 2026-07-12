# C77 continuation — the game-semantic residue is C74 pencil N-absorption

**2026-07-11 (Codex).**  This continuation starts after the reservoir-free DROP ledger was proved
root-peak-bounded and found to carry no P/N information.  The generic C61 reply quotient remains
closed-negative: six exact q=17/q=19 forced states with identical normalized geometry require
different replies.  The surviving game-semantic target is therefore the explicit C74
one-intruder pencil, not another global potential or static selector.

## Verdict

There is one new proof target and one exact base certificate.

1. **Computed N-absorption target.**  On every maximum-capacity C74 pencil in the exact
   q=11/13/17/19 corpus,

   ```text
   number of N-valued legal off-conic centers <= q - 8.
   ```

   The bound is tight at q=17.  A maximum pencil has product-collision count `d<=5` and hence
   `q-1-d` legal off-conic centers, so the bound leaves at least

   ```text
   (q-1-d) - (q-8) = 7-d >= 2
   ```

   P centers.  If proved uniformly, this bypasses the stronger (ON) route and proves the actual
   odd-escape obligation directly: every residual size-3 class has a P-valued size-4 child.

2. **Exact q=11 base compression.**  The two knife-edge q=11 classes have 32 distinct P-valued
   off-conic centers across their tied maximum pencils.  For each P root, form the winning-reply
   graph whose vertices are legal opponent moves and whose edges `{x,y}` satisfy
   `root union {x,y}` P.  All 32 graphs have perfect matchings.  They collapse to exactly four
   abstract isomorphism types:

   ```text
   roots  vertices  edges
      10        18     15
       2        12      6
      10        18     30
      10        20     40
   ```

   This turns the mandatory q=11 4P/2N obstruction into a four-type first-reply certificate target.
   It is not yet a uniform proof: the graph edges use exact game values, and every matched P
   follower still needs its recursive reply book.

## Exact pencil census

For every minimum-`d` line in every recorded class, the table gives
`(d, number of P off-conic centers, number of N off-conic centers) : number of pencils`.

| q | maximum-pencil histogram | max N centers | `q-8` | min P centers |
|---:|---|---:|---:|---:|
| 11 | `(4,4,2):16` | 2 | 3 | 4 |
| 13 | `(4,6,2):6`, `(4,7,1):9`, `(4,8,0):3` | 2 | 5 | 6 |
| 17 | `(4,3,9):6`, `(4,4,8):3`, `(4,5,7):6`, `(4,6,6):6` | **9** | **9** | 3 |
| 19 | `(4,14,0):31`, `(5,13,0):150` | 0 | 11 | 13 |

This is exact computed evidence, not an extrapolated theorem.  In particular, the constant eight
is named because q=17 realizes equality, not because a proof mechanism for it is known.

## Static pencil signatures do not supply the theorem

For a legal center `z_a`, after normalizing the pencil endpoints to `(0,infinity)`, the probe
recovers the involution parameter `a` from the common transformed product of every conic chord
through `z_a`.  It then computes three scale-invariant, value-blind signatures:

- the quadratic character of `a`;
- the character multiset of `a-b` over the forbidden product set `B=P2(U)`;
- the multiplicative-order multiset of `a/b`, `b in B`.

At the q=11 knife edge, the gap signature with three nonsquares and one square is P on all ten tied
pencils.  It does **not** generalize: at the q=17 knife edge the same signature is N.  Even the
combined character/order signature finds a globally P-pure choice on only 28 of the 37 depleted-order
maximum pencils; the nine uncovered pencils are q=17 controls.  This is another selector failure,
not an N-absorption proof.

## Reply-graph interpretation and limits

For a P root `S`, the root game equation makes the winning-reply graph undirected: `{x,y}` is an
edge exactly when the common two-move follower `S union {x,y}` is P.  No isolated vertices is merely
the P equation.  A perfect matching is stronger: it supplies a fixed first-response pairing at that
root.  The exhaustive q=11 result shows that every P center needed to defeat the knife-edge pencil
has such a pairing, and the four graph types show this is structured rather than 32 unrelated rows.

It is still only the first response layer.  A representative root has several moves with no
symmetric P reply, so the finding does not resurrect the adaptive-symmetry route.  Nor does a
value-aware matching explain why its edges are P.  The theorem-level continuation must derive an
N-absorption or recursive reply-book closure from the one-intruder geometry.

## Updated frontier

- **Primary:** prove or refute `Ncenters(A,F,w) <= q-8` for a C74 maximum pencil.  The q=17 equality
  cases are the mandatory sharp examples.
- **Base formalization:** identify the four q=11 reply-graph types geometrically and emit rules-only
  books for one representative of each type.  This compresses the small-order obstruction but does
  not replace the uniform absorption theorem.
- **Closed:** more DROP-envelope computation; generic C61/C75/C76 feature refinement; a uniform
  character/order selector on `a`.

## Follow-up: a value-blind two-stage packet isolates the absorption signal

The raw bound `Ncenters<=q-8` now has a concrete candidate mechanism.  For a maximum pencil `L`,
let `zone_v(z)` be the number of legal **off-conic** moves remaining after selecting its center `z`.
Let `Low4(L)` contain every center whose `zone_v` is at most the fourth order statistic (include the
whole tie at the boundary).  Both stages are value-blind:

```text
choose L by minimum product-collision d (maximum legal capacity);
choose Low4(L) by minimum remaining off-conic support.
```

Exact scores on every maximum pencil:

| q | `(packet size, P, N) : pencils` |
|---:|---|
| 11 | `(5,4,1):6`, `(6,4,2):10` |
| 13 | `(4,4,0):12`, `(5,3,2):6` |
| 17 | `(4,4,0):3`, `(5,3,2):6`, `(7,4,3):6`, `(7,5,2):6` |
| 19 | all packet members P |

Thus every `Low4(L)` contains at least three P centers, exactly the strength needed for
`Ncenters<=q-8` when `d=4` (and stronger when `d=5`).  At the six tight q=17 pencils the packet is
`5=3P+2N`; the remaining seven centers are N.

The non-maximum-line control shows this is not a generic small-q correlation:

| q | non-maximum candidate lines | Low4 failures (`<3 P`) |
|---:|---:|---:|
| 11 | 264 | **264** |
| 13 | 522 | 78 |
| 17 | 1,344 | **1,332** |
| 19 | 1,844 | 0 (all size-4 positions are P at this order) |

So maximum capacity and low-zone selection are both load-bearing.  Pointwise minimization is false:
the unique minimum-zone center is N on six q=13 and six q=17 maximum pencils.  The candidate theorem
must be set-valued (`Low4` contains P), not a deterministic minimum selector.

This remains computed, not proved.  It is nevertheless a substantially narrower proof target than
unqualified N-absorption: derive the maximum-pencil geometry of `zone_v`, then prove that the tied
fourth-order packet cannot be entirely N (observed strength: at least three P).

The new solver mode

```text
fanmoves q r,c r,c r,c
```

solves one size-3 fan once and emits the exact P children of every size-4 extension.  On a tight
q=17 pencil, its nine N centers have 4–16 P children each; hence the mechanism is not a unique or
forced one-ply escape.  `s4potentialprobecells` was also generalized so cells after the three conic
fit points may be off-conic intruders.

### Exact five-spoke collision formula

`zone_v` on the pencil has a closed incidence formula.  Before choosing a center, the legal
off-conic size-4 extensions of the size-3 root number

```text
(q^2 - 9q + 21) - (q - 4) = (q - 5)^2.
```

Fix a legal center `z`.  For each of the five selected conic-frame points `e`, let `s_e(z)` be the
number of legal off-conic extensions on the spoke `ze`, including `z`.  The five spokes meet only at
`z`; after selecting `z`, each kills its other `s_e-1` off-conic points.  Therefore

```text
zone_v(z) = (q-5)^2 - 1 - sum_e (s_e(z)-1)
          = (q-5)^2 + 4 - sum_e s_e(z).                 (1)
```

Each spoke has its own product-collision count:

- if `ze` is a secant with second conic point `tau_a(e) != e`, C74 gives
  `s_e = q-1-d_e`, where `d_e in {4,5,6}`;
- if `ze` is tangent at `e`, let `delta_e` count the distinct intersections with the six chords
  among the other four frame points; then `s_e=q-delta_e`, again `delta_e in {4,5,6}`.

Writing `delta_e=d_e` on secants and letting `t(z)` count tangent spokes gives the uniform formula

```text
zone_v(z) = q^2 - 15q + 34 + sum_e delta_e(z) - t(z).   (2)
```

The script checks (1) and (2) exactly on all 2,876 maximum-pencil centers at q=11/13/17/19.  Thus
`Low4` is equivalently the fourth-order packet for the finite five-term collision score

```text
K(z) = sum_e delta_e(z) - t(z),    delta_e in {4,5,6},  0 <= t <= 2.
```

At each of the six tight q=17 pencils the score layers are

```text
K=24: 1 P
K=26: 2 non-tangent P + 2 tangent N
K=28: 7 N
```

so `Low4={K<=26}` is exactly `3P+2N`.  This explains the packet geometrically but also exposes the
remaining barrier: collision score and tangency do not determine value globally.  The corpus has
both P and N at identical `(K,t)` (for example q=17 has both at `(24,0)` and `(28,0)`).  The open
lemma is therefore genuinely game-semantic:

> Among the centers with the four smallest five-spoke collision scores on a maximum C74 pencil,
> at least one is P (observed strength: at least three).

The geometry has now been reduced to a bounded collision vocabulary; the missing step must compare
the recursive games of several packet centers, not classify one center by a scalar.

## Reproduction

```bash
cd rust
python3 -m py_compile scripts/c77_pencil_value_probe.py scripts/c77_intruder_reply_graph.py
python3 scripts/c77_pencil_value_probe.py 11 13 17 19
python3 scripts/c77_intruder_reply_graph.py --solver target/gridcap-ledger
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-c77
target/gridcap-c77 fanmoves 17 0,0 1,1 2,3
```

The reply-graph pass uses `checkpos`, which fully solves every q=11 root/break pair and reports exact
P/N replies.  It checks reply-edge symmetry, computes an exact bitmask perfect matching, and clusters
the 32 graphs with a dependency-free exact isomorphism backtracker.
