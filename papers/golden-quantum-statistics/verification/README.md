# Evidence supplement

This directory is the paper-local reproducibility package for the finite and
symbolic claims used by the manuscript. The human orbit, rank, and
determinant-line proofs remain primary. The supplement checks the balanced
census, exchange-sector values, decoder, and optical compilation.  It also
retains a separate exact arithmetic specialization that is not part of the
main manuscript.

The publication-facing files have mathematical names only. Internal workflow
identifiers, private reports, and repository-external paths are not part of
this package.

Run the compact standard-library gate from the paper directory:

```text
python3 verification/verify.py --check
```

Run the three generators and their independent replays in the pinned symbolic
environment with:

```text
make verify-sources
```

The evidence bundles are:

- `evidence/anomaly_inverse.py`, its canonical JSON certificate, and
  `evidence/anomaly_inverse_replay.py`;
- `evidence/boson_fermion_complement.py`, its canonical JSON certificate, and
  `evidence/boson_fermion_complement_replay.py`; and
- `evidence/six_mode_demonstrator.py`, its canonical JSON certificate, and
  `evidence/six_mode_demonstrator_replay.py`.

`evidence_certificate.json` extracts the claims used in the paper and the
retained arithmetic supplement, including the six decoder words,
full-precision optical netlist, and the separate reconstruction errors for
full-precision and six-decimal angles.
`evidence_manifest.json` pins the byte count and SHA-256 hash of every
load-bearing paper-local file. The release verifier also rejects internal
workflow identifiers and private source paths anywhere in the exported
filenames or text files.

The checker does not certify experimental feasibility, source availability,
or literature priority. Those remain empirical or bibliographic inputs.
