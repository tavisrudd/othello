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

It follows the manuscript's actual TeX input tree and checks that every
theorem-like environment has exactly one claim-map row,
that coverage and reviewer-terminal annotations agree, that every `uses`
reference resolves, that each detached proof names exactly one statement with
`proves`, that the terminal inventory partitions the Lean source, and that the
expected-axiom inventory covers the same four terminals. All six annotation
macros must remain empty one-argument commands. Imported-result identifiers
resolve in `verification/imported-sources.json`, with bibliography keys,
pinpoints, uses, and matched conventions; evidence identifiers resolve in
`verification/evidence.json`, with roles, checksum manifests, and replay commands.
Proof annotations must occur together at the end of the proof.
The explicit-example bundle records concrete matrices and arithmetic replays;
its prose-level evidence annotation creates no theorem dependency. Its JSON
checksum manifest is checked for file containment, byte counts, and SHA-256.

Each claim row records its objects, hypotheses, conclusion, and cautions.
Its digest binds the reviewed row to the mathematical statement text while
ignoring annotations and layout. For the four Lean terminals, a second digest
binds the explicit source signatures and ambient variable declarations.
This is a source-text check, not an elaboration or a hash of the full semantic
dependency closure. Prose and arguments outside theorem environments are not
covered by statement digests. This mode does not invoke Lean.

After reviewing an affected correspondence row, refresh only its exact label:

```text
python3 lean/verification/refresh_claim_digests.py thm:objectwise-confinement
python3 verification/dependency_graph.py
```

The refresher's `--all` option establishes a reviewed baseline; it must not be
used merely to silence a stale-digest failure. The deterministic dependency
graph records authored conceptual dependencies as dashed edges, proof
dependencies as solid edges, and imported inputs or evidence as dotted edges.
It does not infer dependencies from ordinary citations or cross-references.
An isolated evidence node records an illustration with no theorem dependency.
The gate rejects a stale graph. Mutation tests exercise unknown identifiers,
coverage and terminal mismatches, moved proof annotations, nonempty macro
definitions, stale digests, missing conventions, and unreferenced sections:

```text
python3 verification/test_annotations.py
```

The concrete reliability matrices and the complete hierarchy example also have
an independent finite replay:

```text
python3 verification/replay_examples.py --check
```

See `verification/explicit-examples.md` for the finite domains, independent
minor checks, direct availability enumeration, inputs, and trust boundary.

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
