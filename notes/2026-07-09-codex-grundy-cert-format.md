# C50 — kernel-checked Grundy certificate prototype

Date: 2026-07-10.

## Verdict

**Tiny end-to-end prototype: PASS. Current literal reflected representation beyond tiny boards:
NO-GO.**

The prototype certifies the 3×3 queens nimber

```text
grundy (queenGraph 3) univ = 2
```

from a generated ten-node Grundy DAG. A standalone rules-only checker accepts the line format;
Lean's reflected checker returns true with `by decide`; the generic soundness theorem turns that
Boolean result into the mathematical Grundy equality. The final theorem's exact axiom gate is

```text
[propext, Classical.choice, Quot.sound]
```

with no `native_decide` and no `sorry`.

The scale gate fails early. A 4×4 queens book (50 nodes) still elaborates, but a 5×5 book (308
nodes) hits Lean's default deterministic 200,000-heartbeat limit while reducing the reflected
check. Per the task's stop rule, no C35/grid-cap adapter or larger campaign was built: the literal
list/linear-lookup representation must first be replaced by a compact indexed array or a
chunked/reflected checker. The format and soundness theorem remain reusable.

## 1. Exact certificate contract

For every reachable live set `S`, a row contains:

```text
(S, claimed Grundy value g, lowerMoves[0..g-1]).
```

The checker reconstructs **every** legal child. It verifies:

1. every legal child has a row in the book;
2. `lowerMoves[i]` is legal and its child claims value `i`, for each `i<g`;
3. no legal child claims value `g`.

Recursive soundness of the child claims makes these exactly the two sides of `mex = g`. Lower
witnesses plus “no child has value g” are sound only when all legal children are enumerated and
recursively claimed. Omitting an unhelpful child is not allowed.

The generic Lean theorem is

```text
GrundyBookData.root_grundy_eq_of_check
  (h : check G book = true) : grundy G book.root = book.rootValue
```

proved by well-founded recursion on live-set cardinality.

## 2. Line format and independent checker

The prototype's complete artifact is:

```text
GRUNDYBOOK 1
GAME queens 3
ROOT 1ff 2
NODES 10
NODE 1ff 2 2 4 0
NODE 5 1 1 0
NODE a 1 1 1
NODE 22 1 1 1
NODE 41 1 1 0
NODE 88 1 1 3
NODE a0 1 1 5
NODE 104 1 1 2
NODE 140 1 1 6
NODE 0 0 0
END
```

Masks are live squares. In `NODE mask g count moves...`, the moves are ordered witnesses for
child values `0..g-1`. Edges are implicit and reconstructed from the queens rules, so the artifact
cannot suppress a legal move.

`rust/scripts/c50_grundy_cert.py` contains two separate paths:

- an exact recursive oracle/emitter;
- a parser and rules-only validator that never calls the Grundy recursion.

The validator rejects duplicate rows, bad framing/counts, illegal or wrongly-valued lower
witnesses, missing legal children, children of the forbidden value, and unreachable extra nodes.
Four corruption tests pass.

## 3. Prototype and growth measurements

```text
C50-SELFTEST corruptions=4 verdict=PASS
C50-GROWTH n=1 grundy=1 nodes=2    edges=1    bytes=72    elapsed=0.000043
C50-GROWTH n=2 grundy=1 nodes=2    edges=4    bytes=72    elapsed=0.000033
C50-GROWTH n=3 grundy=2 nodes=10   edges=25   bytes=191   elapsed=0.000101
C50-GROWTH n=4 grundy=1 nodes=50   edges=164  bytes=848   elapsed=0.000465
C50-GROWTH n=5 grundy=3 nodes=308  edges=1198 bytes=5690  elapsed=0.002804
C50-GROWTH n=6 grundy=1 nodes=1563 edges=8036 bytes=31361 elapsed=0.017912
C50-CHECK n=3 root_grundy=2 nodes=10 edges=25 verdict=PASS
```

The serialized books grow modestly. The bottleneck is kernel reduction of the literal Lean list
and repeated linear `lookupNode` calls:

| artifact | nodes | edges | Lean wall | max RSS | result |
|---|---:|---:|---:|---:|:---|
| import/baseline (`Queens.Basic`) | — | — | 3.52 s | 3,368,760 KB | PASS |
| n=3 reflected book | 10 | 25 | 3.96 s | 3,407,256 KB | PASS |
| n=4 reflected book | 50 | 164 | 12.89 s | 4,269,964 KB | PASS |
| n=5 reflected book | 308 | 1,198 | 18.86 s | 4,252,408 KB | FAIL: 200k heartbeats |

The n=5 failure occurs at the `by decide` checker theorem, before a sound root theorem can be
produced. Raising heartbeats would not address the quadratic lookup shape and was deliberately not
used. A preliminary attempt under an 8-GB virtual-address cap could not initialize all mathlib
mappings; the uncapped monitored run stayed below 8 GB RSS and supplied the meaningful heartbeat
failure above.

## 4. Files and reproduce

- `lean/NodeKayles/GrundyCertificate.lean` — data model, reflected checker, mex soundness theorem.
- `lean/Queens/GrundyCert3.lean` — generated literal book and certified theorem.
- `rust/scripts/c50_grundy_cert.py` — emitter, independent checker, corruption tests, and optional
  Lean emitter for sizing experiments.

```bash
python3 rust/scripts/c50_grundy_cert.py --growth --n 3 --out /tmp/queens3.gbook
cd lean
nix develop -c lake build NodeKayles.GrundyCertificate Queens.GrundyCert3
```

For the measured n=4 sizing artifact:

```bash
python3 rust/scripts/c50_grundy_cert.py --n 4 --lean-out /tmp/GrundyCert4.lean
cd lean
nix develop -c lake env lean /tmp/GrundyCert4.lean
```

## 5. Route consequence

C50 validates the certificate semantics and kernel soundness direction, but the naive literal
reflection layer is not a scale path. Before adapting C35's raw Grundy dumps, replace linear list
lookup with a checked dense index (or chunk certificates so each kernel decision sees a small
table). Only after that representation passes the n=5/n=6 gate should a grid-cap or OEIS sequence
adapter be added. No OEIS submission was made.
