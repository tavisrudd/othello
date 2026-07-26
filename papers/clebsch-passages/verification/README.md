# Paper III verification

`trust_manifest.json` is the claim ledger.  It records claim status, proof
modes, task ownership, and evidence paths.  `statement_identity.json` freezes
the seven theorem-like statements in manuscript order.

Run from the repository root:

```text
python3 papers/clebsch-passages/verification/verify_release.py
```

The aggregate gate verifies:

- exact theorem-statement identity and claim-ledger coverage;
- the human proof surface and two exact audits of the finite tensor;
- the primary, independent, and checksum gates for the arithmetic and
  harmonic evidence bundles; and
- a clean manuscript build with no LaTeX box, citation, or reference warning.

The statement extractor can be run separately with

```text
python3 papers/clebsch-passages/verification/extract_statement_identity.py --check
```

The Lean terminal
`RelativeConicArcs.ClebschTensorBridge.restrictedCubic_eq_four_mul_clebschPolarization`
is an optional check of the final literal \(4^3\)-tensor equality.  It is not
part of the aggregate release gate and does not carry the theorem's geometric
or representation-theoretic argument.

The first task-owned evidence bundle is the C655 harmonic bridge:

```text
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch.py --check
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/harmonic_clebsch.sha256
```

It certifies the exact face-axis Gram matrix, Petersen decomposition,
spherical moments, Gaunt scalar, and normalization to the standard
unnormalized degree-six `W_6`.

The arithmetic-cover bundle is deliberately smaller than its human
proof:

```text
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover.py --check
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/arithmetic_cover.sha256
```

It checks the explicit projective substitutions and the comparison and
reflection matrices.  Its additional finite-carrier outputs are not used by
the paper.  Section 4 proves the golden fibre and spinor specialization in
prose.

The aggregate gate does not turn the abstract integral equation into a
global incidence model at \(11\).  The mod-\(11\) claim is the exact good
reduction of the displayed golden fibre and exchanger.  The geometric
incidence comparison remains over an unspecified cofinite base.
