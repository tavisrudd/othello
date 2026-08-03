# C834 — isolated weight-ten reachability certificates

**Date:** 2026-08-02

## Certified statement

Fix the normalized internal point `(1,0,2)` in the passant incidence structure over
`ZMod 13`.  For each of the seven choices of distinguished passant fibre, the generated
transition tables cover every Cartesian choice in the isolated weight-ten profile:

- three ordinary fibres of six points on the left;
- the base point, one of the twenty triples in the distinguished six-point fibre, and the
  remaining three ordinary fibres on the right.

Each option bridge and transition is compiled in its own module.  Each 216-by-4320 terminal
disjointness check is divided into three consecutive 72-by-4320 modules, and the seven profile
aggregates assemble those results without repeating the finite computation.  The terminal state
lists have respectively 216 and 4320 syndromes and are disjoint.  The Lean
theorems `PassantCodeQ13.WeightTen.IsolatedReachability.Fibre0.no_equal_cartesian_syndromes`
through
`PassantCodeQ13.WeightTen.IsolatedReachability.Fibre6.no_equal_cartesian_syndromes` therefore
exclude syndrome equality for every complete isolated-profile choice, not merely for the paths
emitted by the generator.

This packet certifies only the seven isolated profiles.  It does not certify the cycle profile,
the structural reduction of an arbitrary weight-ten word to the two pencil profiles, or the
projective transport from the fixed point.

## Reproduction and trust boundary

From the repository root, compare the deterministic artifacts with

```sh
python3 papers/q13-passant-code/lean-certificates/generate_weight_ten_reachability.py --check
```

Omit `--check` to regenerate the complete artifact set.

The generator uses the canonical projective representatives over `F_13`, the conic
`XZ-Y^2=0`, the fixed internal point `(1,0,2)`, and the exact Cartesian traversal order of each
reachable-state layer.  It asserts that every layer has no repeated state, so exact traversal-list
equality is also exact set coverage.  It uses no randomness.  The adjacent JSON manifest records
the generator and output byte counts and SHA-256 hashes.

Python generation carries no logical authority.  Each Lean leaf checks every successor layer
against `PassantCodeQ13.WeightTen.isolatedLeftOptions` or
`PassantCodeQ13.WeightTen.isolatedRightOptions` by kernel reduction.  The generic theorem
`PassantCodeQ13.WeightTen.Reachability.foldl_xor_mem_terminalStates` transports these checks to
every `ChoicePath` in the complete Cartesian domain, and a kernel-checked disjointness test gives
the terminal exclusion.  This also supplies the independent replay: the generator reconstructs
the normalized incidence data directly, while Lean recomputes the transitions from the shared
formal coordinate lists and does not trust the generator's assertions.

The seven leaves are elaborated serially with the repository's `single` resource profile from
the paper-local Lean package.  The source gates use kernel reduction (`decide +kernel`) of exact
option, transition, and disjointness predicates; no `native_decide`, opaque oracle, or imported
execution premise occurs in these declarations.

At this packet boundary, `weight_ten_reachability_manifest.json` is 22,121 bytes with SHA-256
`cdb5300d08c8d491e09fc1d83f581d1a82956350aab9dcf58188af6c3c3a91b0`; it inventories 105
generated outputs.  The 19,868-byte generator has SHA-256
`73555dca92062bc65595cfd53d561a85c46076dffd2be9af130955344ad19db7`, matching the generator
record embedded in that manifest.
