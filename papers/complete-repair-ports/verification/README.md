# Verification boundary

The manuscript has two independently inspectable verification layers.

The paper-local Mathlib package in `lean/` proves the exact sequence attached
to the target/helper split. Its reviewer interface contains four terminals,
and its kernel axiom audit reports exactly `Classical.choice`, `Quot.sound`,
and `propext`. The claim map in `lean/verification/claims.json` records one
Lean-complete manuscript statement and sixteen statements with no Lean
coverage. In particular, the relative-weight identity and concatenation
theorems have human proofs only.

The source-only annotation check is

```text
python3 lean/verification/check_formal_artifact.py --source-only
```

It checks that every theorem-like environment has exactly one claim-map row,
that coverage and reviewer-terminal annotations agree, that every `uses`
reference resolves, that each detached proof names exactly one statement with
`proves`, that the terminal inventory partitions the Lean source, and that the
expected-axiom inventory covers the same four terminals. This mode does not
invoke Lean.

The standalone Lean package can be rebuilt from `lean/` using the pinned
toolchain and Mathlib revision described in `lean/README.md`. Its axiom-audit
module is part of that build.

The release verifier

```text
nix develop .#manuscript --command \
  python3 verification/verify_release.py
```

checks the public source inventory, metadata, formal-boundary metadata,
machine-readable annotations, TeX warnings, expected page count, and bytewise
identity of the tracked PDF with a deterministic clean build. It does not
infer formal coverage from prose or from older external libraries.

`verification/distribution-files.txt` is the explicit shipped-file manifest.
Every listed text file is scanned for private paths and workflow identifiers.
In a standalone checkout, the verifier also requires the Git tracked-file set
to equal that manifest, so an unlisted tracked file fails the release gate.

Refresh the tracked PDF only through the deterministic path:

```text
nix develop .#manuscript --command \
  python3 verification/verify_release.py --update-pdf
```

No exhaustive computation is a premise of a manuscript theorem. The finite
reliability table is printed in the paper and evaluated there by
inclusion--exclusion.
