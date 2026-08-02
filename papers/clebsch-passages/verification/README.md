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
  --lean-root /path/to/formal-artifact
```

`passages_formal.json` maps each of the nine manuscript rows to exact Lean
declarations and records the missing geometric hypotheses.  Its gate proves
the abstract pinching, conductor, involution, golden-character, tight-frame,
switching, Petersen, and fixed-line mechanisms without claiming the global
Hitchin correspondences, face-axis addition theorem, or raw spherical
moment.

The operator consolidation uses the expanded golden-return theorem package as
a second pinned formal map.  It covers the conference, triangle, two-graph,
middle-exterior, support-recovery, golden-descent, fixed-conference
commutator-Pfaffian, and order-six signed-triangle mechanisms.  The general
inclusion/Ramsey exchange-rigidity proof, aligned-design faithfulness and its
quadratic decoder, outer-family coherence, the cross-golden
determinant comparison, and the classical Joubert--Segre--Igusa
identifications remain human proof boundaries.
It is replayed against a checkout of the formal artifact with

```text
python3 verification/verify_golden_return_lean.py \
  --lean-root /path/to/formal-artifact
```

`golden_return_formal.json` fixes the Lean toolchain, source hashes, audit
gate, declarations, and exact exclusions.  `golden_return_axioms.txt` records
the complete pinned `#print axioms` output, including each native-decision
terminal; replay rejects any change to that report.  This supplemental gate
contributes partial mechanism coverage to `OPER-1`, `OPER-3`, and `OPER-4`; no manuscript theorem
takes Lean as a proof dependency.
