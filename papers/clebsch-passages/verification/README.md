# Paper III verification scaffold

`trust_manifest.json` is the live claim ledger.  It records claim status,
proof modes, task ownership, and admitted evidence paths before those claims
enter the final theorem.

Run from the repository root:

```text
python3 papers/clebsch-passages/verification/verify_scaffold.py
```

The checker verifies:

- the section files named by the manuscript exist exactly once;
- every `\claimid{...}` used in the manuscript occurs in the ledger;
- claim identifiers and owners are unique and well formed;
- evidence paths recorded for certified claims exist; and
- `release_ready` is false while a claim is gated or conditional.

This is a planning-time guard, not a release certificate.  The final surface
will also freeze theorem statement identity, evidence hashes, exact replay
commands, toolchains, manuscript warnings, and archival metadata.

The first task-owned evidence bundle is the C655 harmonic bridge:

```text
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch.py --check
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/harmonic_clebsch.sha256
```

It certifies the exact face-axis Gram matrix, Petersen decomposition,
spherical moments, Gaunt scalar, and normalization to the standard
unnormalized degree-six `W_6`.  It makes no empirical materials claim.

The C652 arithmetic-cover bundle is deliberately smaller than its human
proof:

```text
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover.py --check
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/arithmetic_cover.sha256
```

It checks the explicit projective substitutions, comparison and reflection
matrices, and finite Mathieu carriers.  Section 4 proves the golden fibre,
the `A4` hinge, the spinor specialization, and the marked-torsor lemma in
prose.  In particular, the evidence asserts no canonical unmarked
Hitchin--Mathieu identification.
