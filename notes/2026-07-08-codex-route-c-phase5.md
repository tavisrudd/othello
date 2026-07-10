# C30 Route-C Phase 5 Report

Scope: q=17/q=19 anchored escape certificate books for the prime-field route-C
certificate path.  No repository Lean certificate data was written during this
run; generated Lean samples stayed under `/tmp`.

## Commands

Build:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-c30
```

q=17 anchored emission:

```text
target/gridcap-c30 cert 17 --anchored --out /tmp/c30-certs
```

Final output:

```text
q= 17  family=anchored  root=P  size3-classes=210  total(q^2-9q+21)=157  min-escape=5  max-escape=11  bad-odd(even-escape) classes=120/210  parity-proof=BREAKS
      escape-histogram (escape:classes) = 5:30 10:120 11:60
      cert witnesses: on-conic=210 off-conic=0 capped-books=0  [421.9s]
wrote /tmp/c30-certs/gridcap-q17-anchored.cert
```

q=17 independent checker:

```text
/run/current-system/sw/bin/time -v target/gridcap-c30 certcheck 17 /tmp/c30-certs/gridcap-q17-anchored.cert
```

Output:

```text
certcheck q=17 file=/tmp/c30-certs/gridcap-q17-anchored.cert  classes(parsed)=210 declared=210  PASS=210 FAIL=0 SKIP(capped/none)=0  nodes=1009758 rows=2345728 terms=548179
certcheck RESULT: PASS
Maximum resident set size (kbytes): 278084
Elapsed (wall clock) time (h:mm:ss or m:ss): 0:01.44
```

q=19 first-five sizing:

```text
/run/current-system/sw/bin/time -v target/gridcap-c30 cert 19 --anchored --out /tmp/c30-certs/q19-sample 0 1 2 3 4
```

Output:

```text
q= 19  family=anchored  cert PARTIAL classes=5 on-conic=5 off-conic=0 capped-books=0  [105.8s]
wrote /tmp/c30-certs/q19-sample/gridcap-q19-anchored.cert
Maximum resident set size (kbytes): 867068
Elapsed (wall clock) time (h:mm:ss or m:ss): 1:45.84
```

q=19 full anchored emission:

```text
/run/current-system/sw/bin/time -v target/gridcap-c30 cert 19 --anchored --out /tmp/c30-certs
```

Final output:

```text
q= 19  family=anchored  root=P  size3-classes=272  total(q^2-9q+21)=211  min-escape=211  max-escape=211  bad-odd(even-escape) classes=0/272  parity-proof=HOLDS (all bad even)
      escape-histogram (escape:classes) = 211:272
      cert witnesses: on-conic=272 off-conic=0 capped-books=0  [5893.5s]
wrote /tmp/c30-certs/gridcap-q19-anchored.cert
Maximum resident set size (kbytes): 867612
Elapsed (wall clock) time (h:mm:ss or m:ss): 1:38:13
```

q=19 independent checker:

```text
/run/current-system/sw/bin/time -v target/gridcap-c30 certcheck 19 /tmp/c30-certs/gridcap-q19-anchored.cert
```

Output:

```text
certcheck q=19 file=/tmp/c30-certs/gridcap-q19-anchored.cert  classes(parsed)=272 declared=272  PASS=272 FAIL=0 SKIP(capped/none)=0  nodes=7601462 rows=15354851 terms=5850790
certcheck RESULT: PASS
Maximum resident set size (kbytes): 1835428
Elapsed (wall clock) time (h:mm:ss or m:ss): 0:09.76
```

Canonical esc histogram cross-check:

```text
q=17 canonical classes=21 escape-histogram=5:3 10:12 11:6
q=19 canonical classes=27 escape-histogram=211:27
```

The anchored q=17 histogram is exactly the 10x anchored expansion of the
canonical histogram.  The q=19 anchored histogram is uniformly 211, matching the
canonical run.

Artifact sizes:

```text
111M /tmp/c30-certs/gridcap-q17-anchored.cert
863M /tmp/c30-certs/gridcap-q19-anchored.cert
```

## Lean Sizing Gate

I generated first-five split Lean samples under `/tmp` by reusing the q=13 split
generator shape.  Sample generated file sizes:

```text
q17 Class0.lean 5.7M, 115408 lines
q17 Class1.lean 5.6M, 113011 lines
q17 Class2.lean 5.8M, 118152 lines
q19 Class0.lean 29M, 555338 lines
q19 Class1.lean 28M, 537970 lines
q19 Class2.lean 35M, 673146 lines
```

`q17` Base compiled successfully:

```text
choom -n 1000 -- lean -R /tmp/c30-flat-q17 -o /tmp/c30-flat-q17/Base.olean /tmp/c30-flat-q17/Base.lean
Elapsed (wall clock) time: 0:10.09
Maximum resident set size (kbytes): 2630544
```

`q17` Class0 did not pass the per-file gate.  It ran for 31:23.21 wall, reached
11.9 GB RSS, then failed in the generated aggregate chunk proof:

```text
/tmp/c30-flat-q17/Class0.lean:85797:70: warning: Possibly looping simp theorem: `class0_nodeChunks.eq_1`
/tmp/c30-flat-q17/Class0.lean:85797:2: error: Tactic `simp` failed with a nested error:
maximum recursion depth has been reached
...
Command being timed: "... lean -R /tmp/c30-flat-q17 -o /tmp/c30-flat-q17/Class0.olean /tmp/c30-flat-q17/Class0.lean"
Elapsed (wall clock) time (h:mm:ss or m:ss): 31:23.21
Maximum resident set size (kbytes): 11914984
Exit status: 1
```

Failure location:

```text
theorem class0_nodeChunks_check :
    CertCheck.BookData.checkNodesChunks (K := K) class0_book class0_nodeChunks = true := by
  simp only [CertCheck.allShort, CertCheck.BookData.checkNodesChunks, class0_nodeChunks,
    class0_nodeChunk0_check, ..., class0_nodeChunk469_check, reduceIte]
```

So the rules-only certificate books are good, but the existing q=13 generated
Lean proof shape does not scale to q=17.  q=19 was not attempted in Lean after
this failure; the first generated q=19 classes are roughly 5x larger than q=17
Class0.

## Verdict

- Rust anchored certificate emission: PASS for q=17 and q=19.
- Independent rules-only `certcheck`: PASS for both files.
- Witnesses: all on-conic for both q values; no capped books.
- Original Lean closure: STOP at the first C30 feasibility gate.  The q17 monolithic
  `Class0.lean` shape did not scale.

## Lean Split Refactor Follow-up

The generated-checker refactor now validates the q17/Class0 path in a flat `/tmp`
sample:

- `ProjectiveCap.CertCheck` adds local `StepRefData` proof checking with indexed
  child references, so row checks do not scan every generated node.
- `2026-07-08-q13-split-to-lean.py` emits `ClassNBase.lean`, one
  `ClassNStepGroupM.lean` per 320 one-node semantic step chunks, and a small
  `ClassN.lean` top module.
- Each step group keeps semantic checks at one node, then aggregates through
  10-node subgroups aligned to the book's node chunks.

Validation on q17/Class0:

```text
/tmp/c30-flat-q17-v9/Base.lean              PASS
/tmp/c30-flat-q17-v9/Class0Base.lean        PASS
/tmp/c30-flat-q17-v9/Class0StepGroup0..14   PASS
/tmp/c30-flat-q17-v9/Class0.lean            PASS
```

Commands used the project Lake environment and `choom -n 1000 -- lean`, compiling
leaves before the top module.  No q17/q19 generated Lean data was committed in
this pass.  Next gate: generate/build all q17 split classes with the same
leaf-first discipline; q19 remains a sizing/user-launch decision after q17 is
clean.
