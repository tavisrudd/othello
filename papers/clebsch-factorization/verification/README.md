# Verification of the conic matching quotient paper

This directory is the aggregate verification surface for *Quadratic Trade
Rigidity and Cubic Orientation in Conic Matching Quotients*. It
separates four kinds of support:

- proofs given in the manuscript;
- classical inputs attributed to Edge, Dye, the *Atlas*, and Giudici;
- exact finite-field certificates with independent replays; and
- kernel-checked Paper II structural, arithmetic-gluing, Hilbert-symmetry,
  and hyperplane-square implications; the largest arithmetic-gluing `H_3`
  leaves are certificate-backed.

`statement_identity.json` contains the exact theorem-like statements in the
manuscript. `extract_statement_identity.py --check` rejects any
unrecorded change to those statements.

`trust_manifest.json` maps every statement to its proof modes and evidence
bundles. `verify_release.py` checks the statement identity, the manifest
partition, the exact command and evidence-path allowlist, safe checksum
targets, every recorded digest, and the primary and independent replays. It
then elaborates the Paper II structural, arithmetic-gluing, Hilbert-symmetry,
and hyperplane-square Lean gates, runs the generic first-wall and shared-radial
replays, and builds the paper with the pinned manuscript Nix environment and
`check_manuscript_build.py`, enforces the exact gate-terminal identity and
axiom allowlist, and rejects manuscript warnings.

The structural gate follows the manuscript spine from projective pullback
through finite-root and outer-defect abstractions, affine contraction, and
the rank-three endpoint. It does not prove the all-field detector lemmas,
the Doty--Henke tilting calculation, the source-specific Hom vanishings, or
Faber's tame subgroup theorem. Those human and classical inputs are proved
or cited in the manuscript's specialist appendix and are not marked as Lean
proofs in the trust manifest.

`evidence_fingerprint.json` pins the normalized manuscript and statement
identity, statement extractor, paper README, Nix inputs, manuscript checker,
adversarial boundary checker, this documentation, the guarded-Lean launcher,
and the complete project-owned Lean import closure,
the admitted checksum manifests, exact command vectors, verification runner, trust
manifest, Python version, Lean toolchain, Mathlib revision, Nix lock, and
expected success lines. The expected metadata line is derived from the
statement and evidence counts the runner observes, and the runner rejects a
fingerprint whose recorded line disagrees with them, so a stale count cannot
survive a metadata-only check. The manuscript normalization replaces only its
displayed fingerprint digest; the identity normalization replaces only its
derived full-source hash. This is the explicit review-source allowlist, not a
hash of the entire repository or every transitive dependency. Refresh it only
after an intentional verification-surface change:

```text
python3 verification/verify_release.py \
  --update-fingerprint --metadata-only
```

That update also rewrites the displayed fingerprint digest in the manuscript
and refreshes the derived statement-identity source hash. A following ordinary
metadata run must pass before the refreshed files are accepted.

From the repository root, run:

```text
python3 verification/verify_release.py
```

Use `--metadata-only` to check the statement map, trust manifest, and evidence
hashes without executing the finite replays or manuscript build. The aggregate
runner does not turn executable checks into formal proofs: the residual trust
boundaries remain those stated in the manuscript, trust manifest, and
certificate module headers.
