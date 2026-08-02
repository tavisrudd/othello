# Evidence and trust map

This supplement contains three deterministic evidence bundles. Each bundle
has a generator, a canonical JSON certificate, and an independently written
replay. `verify.py` checks the paper-facing claims and pins every load-bearing
file in `evidence_manifest.json`.

## Anomaly inverse

Files: `evidence/anomaly_inverse.py`, `evidence/anomaly_inverse.json`, and
`evidence/anomaly_inverse_replay.py`.

The generator uses exact integer and rational arithmetic. It verifies the
matching-coordinate dictionary, the rational filter and charge vector, the
finite height-three search over 5,040 normalized filters, and the seven real
pole domains used in the bounded optimization statement. The replay rebuilds
the finite enumeration and the charge and probability identities by a separate
implementation.  This bundle is retained as supplementary arithmetic data and
is not invoked by the main manuscript.  It does not establish a gauge-theory
model or a literature-priority claim.

## Exchange-sector complement

Files: `evidence/boson_fermion_complement.py`,
`evidence/boson_fermion_complement.json`, and
`evidence/boson_fermion_complement_replay.py`.

The generator uses exact SymPy arithmetic in the environment pinned by
`pyproject.toml` and `uv.lock`. It checks the twenty balanced controls, the 44
rank-deficient controls, the common squared singular spectrum, the three
calibrated permanent probabilities, and the symmetric-, mixed-, and
exterior-cube values. The standard-library replay independently recomputes the
rational aggregate identities from the certificate. It does not certify the
human left--right orbit theorem.

## Six-mode design

Files: `evidence/six_mode_demonstrator.py`,
`evidence/six_mode_demonstrator.json`, and
`evidence/six_mode_demonstrator_replay.py`.

The generator checks the chiral filter and its conditional probabilities, all
six ten-sign decoder words, the three- and five-cut schedules, the fifteen-cell
Givens compilation, and the exact trial and fidelity formulas. The certificate
stores both the full-precision angles and the values printed to six decimal
places. `verify.py` reconstructs the optical matrix from each representation
and checks their errors separately. The replay independently checks the
charge, probability, decoder, and resource-count identities. It does not
certify component availability or experimental performance.

## Commands

From the paper directory, run the compact gate without modifying tracked
files:

```text
python3 verification/verify.py --check
```

Run every generator in check mode and every independent replay with:

```text
make verify-sources
```

Both entry points are deterministic. The complete paper gate is `make check`.
