# Verification scope

The manuscript has two independently inspectable verification layers.

The paper-owned Lean companion in `lean/`, built with Lean 4 against a pinned Mathlib
revision, proves the exact sequence attached
to the target/helper split. Its reviewer interface contains four terminals,
and its kernel axiom audit reports exactly `Classical.choice`, `Quot.sound`,
and `propext`. The claim map in `lean/verification/claims.json` records one
Lean-complete manuscript statement and thirty-one statements with no Lean
coverage. In particular, the relative-weight identity, exact prescribed-coset
transfer theorem, and its confinement specializations have human proofs only.

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

The standalone Lean companion can be rebuilt from `lean/` using the pinned
toolchain and Mathlib revision described in `lean/README.md`. Its axiom-audit
module is part of that build.

The release verifier

```text
nix develop .#manuscript --command \
  python3 verification/verify_release.py
```

checks the public source inventory, metadata, formal-coverage metadata,
machine-readable annotations, TeX warnings, expected page count, and bytewise
identity of the tracked PDF with a deterministic clean build. It does not
infer formal coverage from prose or from older external libraries.

`verification/distribution-files.txt` is the explicit shipped-file manifest.
Every listed text file is scanned for private paths and workflow identifiers.
In a standalone checkout, the verifier also requires the Git tracked-file set
to equal that manifest, apart from the exporter's optional `.gitignore`,
`PROVENANCE.md`, and `export-manifest.json`.  Those files are scanned when
present; any other unlisted tracked file fails the release check.

Ergodis is developed at [tavisrudd/ergodis](https://github.com/tavisrudd/ergodis).
`verification/artifact-versions.json` identifies the software sources described
in the paper, each retained application record and raw sample file by SHA-256,
and the measured executable, runners, and checking scripts recorded by those
results. The three application records carry their exact sampling protocols:
seven paired rounds for the six-application benchmark and three paired rounds for
the longer tower and Hamming-outer comparisons. They include replay details
and tool versions. These identities distinguish the measured version from the
later software description. Detailed timings and comparisons are retained in
Ergodis's benchmark documentation rather than the manuscript; no new timings
are asserted by the paper build.

The same manifest pins the unchanged Lean sources to their published companion
revision, with content hashes for the toolchain, dependency lock, and expected
axiom inventory. A source hash identifies an artifact; it is not a new kernel
execution or an independent verification of a benchmark result.

## Formal companion details

The four reviewer-facing declarations are:

| Exact-sequence assertion | Declaration |
|---|---|
| `K_P ≤ D_P` | `helper_ker_le_helperCodeForTargetSpace` |
| `G_J(D_P) = W_P` | `map_helperCodeForTargetSpace_eq_recoverableTargetMessageSpace` |
| Surjectivity onto `W_P` | `recoverableTargetMap_surjective` |
| Restricted kernel equals `K_P` | `mem_ker_recoverableTargetMap_iff` |

The companion uses Lean `4.32.0-rc1` and Mathlib revision
`571b8a8e54219b4d393f75f4b8653fac08197fcc`. Its recorded axiom audit lists
only `Classical.choice`, `Quot.sound`, and `propext` for each terminal. These
are standard logical and quotient principles, not assumptions about codes.
The module entry points and rebuild instructions are in `lean/README.md`;
the exact expected inventory is in `lean/verification/expected_axioms.txt`.

## Deterministic manuscript build

Refresh the tracked PDF only through the deterministic path:

```text
nix develop .#manuscript --command \
  python3 verification/verify_release.py --update-pdf
```

No exhaustive computation is a premise of a manuscript theorem. The finite
reliability table is printed in the paper and evaluated there by
inclusion--exclusion.
