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

## 2026-07-10 Continuation: Canonical Transport + Base Split

The anchored route is still too large as a full Lean build.  After the local
checker optimizations, the representative q17 leaf improved but did not become
cheap enough to justify 210 anchored classes:

```text
Class0StepGroup14 original rfl shape:        6:54.67 wall, 7,862,716 KB RSS
Class0StepGroup14 after checkMoveFast:       4:15.05 wall, 5,910,740 KB RSS
after removing child cap recomputation:      3:15.97 wall, 4,818,748 KB RSS
after unordered old-pair move check:         3:04.79 wall, 4,550,544 KB RSS
native_decide experiment:                    0:25.79 wall, but adds a native axiom; rejected
```

So the next lever is canonical transport rather than anchored brute force.  A
canonical q17 certificate book was emitted and independently checked:

```text
/run/current-system/sw/bin/time -v target/gridcap-c30 cert 17 --out /tmp/c30-certs-canon

q=17 canonical classes=21
escape histogram 5:3 10:12 11:6
wrote /tmp/c30-certs-canon/gridcap-q17.cert
Elapsed 0:40.10, max RSS 148,732 KB

/run/current-system/sw/bin/time -v target/gridcap-c30 certcheck 17 /tmp/c30-certs-canon/gridcap-q17.cert

classes(parsed)=21 declared=21 PASS=21 FAIL=0 nodes=100526 rows=232221 terms=54879
certcheck RESULT: PASS
```

Lean support added:

- `ConicLocalization.coordSwap` plus `coordSwap_gridSymmetry`, and a generic
  `gridSymmetry_comp`.
- `q13-split-to-lean.py --assembly-mode canonical`, which brute-forces, for
  every anchored third cell, a canonical class plus an explicit axis-affine or
  coord-swap+axis-affine grid symmetry.
- The generated canonical assembly proves finite image equalities with
  kernel-clean `decide` and composes the canonical symmetry after the existing
  `anchorAxisAffine` normalization.

Fast assembly proof gate:

```text
generated /tmp/c30-lean-q17-canon-v4/ProjectiveCap/CertData/Q17Assembly.lean
stubbed Q17 class-validity module + real transport assembly: PASS in 21.8s
axioms shown by the stub check:
[propext, Classical.choice, Quot.sound, class0_valid, ..., class20_valid]
```

The remaining barrier moved from assembly to `ClassNBase`: it still owned all
per-node cap proofs.  A real `Class0Base` compile against the canonical data was
stopped after it was clearly nonviable as a base file:

```text
Class0Base before node-check split: stopped at 18:16.32, max RSS 7,392,816 KB
```

The generator now emits `ClassNNodeGroupM.lean` leaves, so `ClassNBase` contains
only data and light root facts, while the class top imports both node-check
leaves and step-check leaves.  Real q17/Class0 timings after that split:

```text
Base.lean                         PASS 0:09.34
Class0Base.lean                   PASS 0:53.89, max RSS 4,996,576 KB
Class0NodeGroup0.lean             PASS 0:43.63, max RSS 2,612,708 KB
Class0StepGroup14.lean            PASS 2:57.48, max RSS 4,868,828 KB
ProjectiveCap.ConicLocalization   PASS
ProjectiveCap.CertCheck           PASS
```

No full q17 canonical Lean data was committed.  The next clean gate is a
leaf-first build of all 21 canonical q17 classes using the v5 split layout
(`Base`, every `ClassNBase`, every `ClassNNodeGroup*`, every
`ClassNStepGroup*`, then `ClassN`, `Q17`, and `Q17Assembly`).  If q17 completes
with the expected axiom profile `[propext, Classical.choice, Quot.sound]`, q19
should be regenerated as canonical rather than anchored and sized the same way.

## 2026-07-10 Full-build projection gate

The v5 generated tree contains 326 node-check leaves and 326 step-check leaves
across the 21 canonical classes. Two additional real Class0 node leaves compiled
cleanly and reproduced the earlier resource envelope:

```text
Class0NodeGroup10  PASS 0:55.51, max RSS 2,623,204 KB
Class0NodeGroup11  PASS 0:56.18, max RSS 2,694,688 KB
```

The earlier real `Class0StepGroup14` timing (2:57.48, 4,868,828 KB) is
representative rather than an oversized outlier: its generated source is 0.324 MB,
versus 0.313 MB mean over all 326 step leaves. Likewise the fresh node leaves are
representative (0.049 MB each versus 0.048 MB mean). A source-size-weighted
projection is therefore approximately:

```text
node leaves: 326 * 0:56       = 5.1 h
step leaves: 326 * 2:57.48   = 16.1 h
class bases: 21 * 0:53.89    = 0.3 h
class tops + Q17 assembly:   additional
projected total:             > 21.5 h, sequential
```

This trips C30's explicit per-q `~10 h` stop gate. The all-leaf build was not
launched. The generated sources and the five successfully built real modules
remain under `/tmp/c30-lean-q17-canon-v5` and `/tmp/c30-q17-real-build`; no
repository Lean data was written. Next action is an explicit user decision to
launch the roughly day-long q17 build (or a further checker/build-shape reduction),
not an automatic continuation to q19.
