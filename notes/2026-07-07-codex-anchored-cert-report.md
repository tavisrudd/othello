# C17 anchored certificate report

## Summary

- Added `cert <q> --anchored` to `notes/2026-07-06-grid-cap-solver.rs`.
- Anchored family emits one `CLASS` for each legal `{(0,0),(1,1),(r,c)}` size-3 grid cap.
- `certcheck` passes for q=5,7,11,13. GF(9) was skipped as requested.
- Lean scaffold support builds: grid legality predicates now have decidable instances, and `ReplyBookDAG.validFor_of_finiteRows` gives a finite-support bridge for generated books.
- Lean data generator exists as `notes/2026-07-07-anchored-cert-to-lean.py`.
- Data-generator STOP condition fired on q=5: kernel `by decide` chokes at the bounded reply-step / `Move` quantifier, not at `GridCap`/`AffineCap`. q=7 Lean elaboration was not attempted.

## Rust emitter / checker

Build:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-codex-c17
```

Anchored certificate counts:

```text
q=  5  family=anchored  root=P  size3-classes=6  total(q^2-9q+21)=1  min-escape=1  max-escape=1  bad-odd(even-escape) classes=0/6  parity-proof=HOLDS (all bad even)
      escape-histogram (escape:classes) = 1:6
      cert witnesses: on-conic=6 off-conic=0 capped-books=0  [0.0s]
certcheck q=5 file=/tmp/c17-report-certs/gridcap-q5-anchored.cert  classes(parsed)=6 declared=6  PASS=6 FAIL=0 SKIP(capped/none)=0  nodes=6 rows=0 terms=6
certcheck RESULT: PASS

q=  7  family=anchored  root=P  size3-classes=20  total(q^2-9q+21)=7  min-escape=7  max-escape=7  bad-odd(even-escape) classes=0/20  parity-proof=HOLDS (all bad even)
      escape-histogram (escape:classes) = 7:20
      cert witnesses: on-conic=20 off-conic=0 capped-books=0  [0.0s]
certcheck q=7 file=/tmp/c17-report-certs/gridcap-q7-anchored.cert  classes(parsed)=20 declared=20  PASS=20 FAIL=0 SKIP(capped/none)=0  nodes=40 rows=40 terms=20
certcheck RESULT: PASS

q= 11  family=anchored  root=P  size3-classes=72  total(q^2-9q+21)=43  min-escape=13  max-escape=18  bad-odd(even-escape) classes=12/72  parity-proof=BREAKS
      escape-histogram (escape:classes) = 13:60 18:12
      cert witnesses: on-conic=72 off-conic=0 capped-books=0  [0.0s]
certcheck q=11 file=/tmp/c17-report-certs/gridcap-q11-anchored.cert  classes(parsed)=72 declared=72  PASS=72 FAIL=0 SKIP(capped/none)=0  nodes=1865 rows=3694 terms=973
certcheck RESULT: PASS

q= 13  family=anchored  root=P  size3-classes=110  total(q^2-9q+21)=73  min-escape=46  max-escape=49  bad-odd(even-escape) classes=20/110  parity-proof=BREAKS
      escape-histogram (escape:classes) = 46:20 47:60 49:30
      cert witnesses: on-conic=110 off-conic=0 capped-books=0  [0.9s]
certcheck q=13 file=/tmp/c17-report-certs/gridcap-q13-anchored.cert  classes(parsed)=110 declared=110  PASS=110 FAIL=0 SKIP(capped/none)=0  nodes=15883 rows=36292 terms=8392
certcheck RESULT: PASS
```

Canonical regression:

```text
q=  5  family=canonical  root=P  size3-classes=1  total(q^2-9q+21)=1  min-escape=1  max-escape=1  bad-odd(even-escape) classes=0/1  parity-proof=HOLDS (all bad even)
      escape-histogram (escape:classes) = 1:1
      cert witnesses: on-conic=1 off-conic=0 capped-books=0  [0.0s]
certcheck q=5 file=/tmp/c17-report-certs-canon/gridcap-q5.cert  classes(parsed)=1 declared=1  PASS=1 FAIL=0 SKIP(capped/none)=0  nodes=1 rows=0 terms=1
certcheck RESULT: PASS
```

## Lean scaffold validation

Command:

```text
nix develop --command lake build CapGame.BuildGame ProjectiveCap.Grid ProjectiveCap.Certificate
```

Output:

```text
[built] [2983/2987] CapGame.BuildGame (2.4s)
[built] [2984/2987] ProjectiveCap.GridGame (1.3s)
[built] [2985/2987] ProjectiveCap.StableFacts (1.3s)
[built] [2986/2987] ProjectiveCap.Almost.OddEscape (1.3s)
[built] [2987/2987] ProjectiveCap.Certificate (1.4s)
Build completed successfully (2987 jobs).
```

## Lean generator result

Generator commands:

```text
python3 ../notes/2026-07-07-anchored-cert-to-lean.py /tmp/c17-certs/gridcap-q5-anchored.cert ../lean/ProjectiveCap/CertData/Q5.lean
python3 ../notes/2026-07-07-anchored-cert-to-lean.py /tmp/c17-certs/gridcap-q7-anchored.cert ../lean/ProjectiveCap/CertData/Q7.lean
```

Output:

```text
wrote ../lean/ProjectiveCap/CertData/Q5.lean q=5 classes=6
wrote ../lean/ProjectiveCap/CertData/Q7.lean q=7 classes=20
```

q=5 check:

```text
nix develop --command lake env lean ProjectiveCap/CertData/Q5.lean
```

Result: failed after about 31s. First class failure:

```text
ProjectiveCap/CertData/Q5.lean:40:8: error: maximum recursion depth has been reached
use `set_option maxRecDepth <num>` to increase limit
ProjectiveCap/CertData/Q5.lean:41:8: error: failed to synthesize
  Decidable
    (forall S in class0_nodes,
      forall x in Finset.univ,
        FiniteBuildGame.Move GridCap S x ->
          exists entry in class0_rows,
            entry.1 = S and
              entry.2.mover = x and
                FiniteBuildGame.Move GridCap (insert x S) entry.2.reply and
                  entry.2.child = insert entry.2.reply (insert x S) and
                    entry.2.child in class0_nodes)
```

The same failure repeats for classes 1-5. Since q=5 books are terminal (`rows=0`), this is a
kernel-decider search problem in the bounded reply-step / `Move` implication, not a missing
book row. The earlier scaffold build confirms `GridCap` and `AffineCap` themselves are now
decidable.

Per task instruction, q=7 Lean elaboration was not attempted after this q=5 `by decide` failure.

## Next Lean fix

Do not raise `maxRecDepth` or switch to `native_decide`. The next viable generator shape is to
emit explicit per-node/per-move proof scripts, or to add a small boolean checker plus a reflection
theorem for finite-supported books. Either avoids asking typeclass synthesis to discover one large
nested finite `Decidable` proof.
