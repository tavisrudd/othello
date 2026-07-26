# Verification of the conic matching quotient paper

This directory is the aggregate verification surface for *Quadratic recovery
and cubic orientation in conic matching quotients*. It
separates four kinds of support:

- proofs given in the manuscript;
- classical inputs attributed to Edge, Dye, the *Atlas*, and Giudici;
- exact finite-field certificates with independent replays; and
- the kernel-checked arithmetic-gluing theorem, whose largest `H_3` leaves
  are certificate-backed.

`statement_identity.json` contains the exact twenty-one theorem-like statements
in the manuscript. `extract_statement_identity.py --check` rejects any
unrecorded change to those statements.

`trust_manifest.json` maps every statement to its proof modes and evidence
bundles. `verify_release.py` checks the statement identity, the manifest
partition, the exact command and evidence-path allowlist, safe checksum
targets, every recorded digest, and the primary and independent replays. It
then elaborates the arithmetic-gluing Lean gate, builds the paper through
the repository Makefile, enforces the gate's axiom allowlist, and rejects
manuscript warnings.

`evidence_fingerprint.json` pins the normalized manuscript and statement
identity, statement extractor, paper README and Makefile, this documentation,
the guarded-Lean launcher and project-owned Lean import closure,
the admitted checksum manifests, exact command vectors, verification runner, trust
manifest, Python version, Lean toolchain, Mathlib revision, Nix lock, and
expected success lines. The manuscript normalization replaces only its
displayed fingerprint digest; the identity normalization replaces only its
derived full-source hash. This is the explicit review-source allowlist, not a
hash of the entire repository or every transitive dependency. Refresh it only
after an intentional verification-surface change:

```text
python3 papers/clebsch-factorization/verification/verify_release.py \
  --update-fingerprint --metadata-only
```

From the repository root, run:

```text
python3 papers/clebsch-factorization/verification/verify_release.py
```

Use `--metadata-only` to check the statement map, trust manifest, and evidence
hashes without executing the finite replays or manuscript build. The aggregate
runner does not turn executable checks into formal proofs: the residual trust
boundaries remain those stated in the manuscript, trust manifest, and
certificate module headers.
