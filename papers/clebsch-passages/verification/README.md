# clebsch-passages verification

`trust_manifest.json` is the nine-row claim/evidence map.
`statement_identity.json` freezes the eight theorem-like statements in
manuscript order.

Run from the repository root:

```text
python3 papers/clebsch-passages/verification/verify_release.py
```

The aggregate gate verifies:

- exact statement identity, label-level trust-row correspondence, and frozen
  row prose/proof modes/evidence routes;
- primary, independent, and checksum gates for the arithmetic, orientation,
  and harmonic evidence bundles; and
- the public packaging allowlist and a manuscript build with no box,
  citation, or reference warning.

The statement extractor can be run separately with

```text
python3 papers/clebsch-passages/verification/extract_statement_identity.py --check
```

The harmonic bundle is replayed with

```text
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch.py --check
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/harmonic_clebsch.sha256
```

It reconstructs the explicitly labelled face axes, the Petersen graph, the
reproducing-kernel matrix, the normalized spherical Gram matrix, the exact
moments, and the conversion to the standard unnormalized \(W_6\).

The arithmetic bundle is deliberately smaller than its human proof:

```text
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover.py --check
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/arithmetic_cover.sha256
```

It checks the explicit golden configurations over
\(\mathbf Q[t]/(t^2-t-1)\), all twenty three-point determinants, the
conjugating projectivity, its reduction modulo \(11\), and the reflection
norm product.  It contains no Mathieu, Hadamard, matching, or external
certificate branch.

The orientation-source bundle is replayed with

```text
python3 papers/clebsch-passages/verification/evidence/orientation_source.py --check
python3 papers/clebsch-passages/verification/evidence/orientation_source_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/orientation_source.sha256
```

For the displayed marking, it checks the scalar factorization of the pulled-back
cover, the conference square, the exact golden exchanger, the reversal of all
triangle signs, and the primitive Petersen pair-sum identities.  It does not
prove that the incidence sheet determines that marking or the chart lift.
Scheme normalization, extension
across the branch divisor, and the complete geometric bad-prime set remain
human boundaries.

The aggregate gate does not compare either theorem with a finite matching
tensor.  It also does not turn the abstract integral equation into a global
incidence model at \(11\).  The mod-\(11\) claim is the exact reduction of
the displayed golden fibre and exchanger; the geometric incidence comparison
remains over an unspecified cofinite base.

The manifest states `formal_coverage: partial mechanisms; no complete
manuscript row claimed`.  The current-paper gate is replayed with

```text
python3 verification/verify_passages_lean.py \
  --lean-root /path/to/formal-artifact --source-only
```

`passages_formal.json` maps each of the nine manuscript rows to exact Lean
declarations and records the missing geometric hypotheses.  Its gate proves
the abstract pinching, conductor, involution, golden-character, tight-frame,
switching, Petersen, fixed-line, and normalized aligned-design mechanisms.
For aligned designs it checks the two-cut classifier by native decision and
proves the third-point disambiguation, overlap consistency, signing transport,
four-by-four determinant identity, and query polynomial symbolically.  The
classical Ramsey theorem, finite-set extension, and normalization from an
arbitrary labelled two-graph remain human inputs, as do the global Hitchin
correspondences, face-axis addition theorem, and raw spherical moment.
`passages_source_closure.json` is the exact project-local transitive import
closure produced by the repository import-closure tool; the verifier pins the
inventory, every listed source, and its own bytes.

Repository validation elaborates the gate through the guarded Lean entry
point.  Its disk-backed standard output is checked separately with

```text
python3 verification/verify_passages_lean.py \
  --lean-root /path/to/formal-artifact --axiom-log /path/to/gate-stdout.log
```

The replay program never starts Lean or Lake itself.

The operator consolidation uses the expanded golden-return theorem package as
a second pinned formal map.  It covers the conference, triangle, two-graph,
middle-exterior, support-recovery, golden-descent, fixed-conference
commutator-Pfaffian, and order-six signed-triangle mechanisms.  The general
inclusion/Ramsey exchange-rigidity proof, the classical inputs to the
aligned-design faithfulness argument, outer-family coherence, the cross-golden
determinant comparison, and the classical Joubert--Segre--Igusa
identifications remain human proof boundaries.
It is replayed against a checkout of the formal artifact with

```text
python3 verification/verify_golden_return_lean.py \
  --lean-root /path/to/formal-artifact --source-only
```

`golden_return_formal.json` fixes the Lean toolchain, source hashes, audit
gate, declarations, and exact exclusions.  `golden_return_axioms.txt` records
the complete pinned `#print axioms` output, including each native-decision
terminal; replay rejects any change to that report.  This supplemental gate
contributes partial mechanism coverage to `OPER-1`, `OPER-3`, and `OPER-4`; no manuscript theorem
takes Lean as a proof dependency.
`golden_return_source_closure.json` pins the exact project-local transitive
import closure.  A guarded gate log is checked by replacing `--source-only`
with `--axiom-log /path/to/gate-stdout.log`; the replay program does not invoke
Lean or Lake directly.
