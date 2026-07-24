# Verification of the Clebsch rigidity paper

This directory is the release-verification surface for *Deep-hole rigidity
of the Clebsch hexagon code*. It separates four trust routes:

- conceptual proofs and named cited inputs;
- kernel-checked Lean terminals and their exact axiom closure;
- exhaustive exact-arithmetic Python replays; and
- mixed claims whose components use more than one route.

`statement_identity.json` contains the exact nineteen-row published claim
map. Each theorem-like row includes the verbatim TeX environment and its
SHA-256 digest; the introductory headline and complete-census sentence are
likewise extracted verbatim. Regenerate or check it with
`extract_statement_identity.py`.

`trust_manifest.json` maps those nineteen rows to the admitted formal
terminals, citations, and executable checks. `verify_trust_manifest.py`
checks every artifact hash, the exact row partition, the axiom map, command
safety, and the exclusion of later-paper evidence. The manifest is generated
by `build_trust_manifest.py` and must never be edited by hand.

The aggregate formal gate is
`RelativeConicArcs/Gates/ClebschRigidityTrust.lean` in the pinned flattened
Lean repository. Its tracked axiom output is
`verification/clebsch_rigidity_trust/axiom-audit.txt` in that repository.
The gate records the exact two classical Dye assumptions used by the
rigidity implication; the other printed axioms are part of Lean's ordinary
logical trust boundary or are shown absent.

The ten Python programs at the paper root are deterministic,
standard-library exact replays. They enumerate the finite domains stated in
the manuscript and print bounded summaries. They do not import generated
Lean output. `capture_checker_outputs.py` regenerates the compact
`checker_outputs.json` certificate of stdout hashes, byte counts, and line
counts. The release runner checks every fresh replay against that certificate.
The manifest records the coverage and residual semantic trust for every use.

From the paper root, with a clean worktree and the pinned flattened formal
repository supplied as `--lean-root`, run:

```text
nix develop --command python3 verification/verify_release.py \
  --lean-root /path/to/finitegeom
```

The runner validates the paper root and the exact Paper I formal source
pathset against the pinned commit, while ignoring unrelated worktree paths.
It builds the manuscript in an isolated temporary directory, executes exactly
the fifteen admitted checks without a shell, and refuses any scholarly path
change.
Successful output is deterministic and must equal
`verify-release-output.json`.
