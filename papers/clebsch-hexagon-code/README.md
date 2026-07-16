# The Clebsch hexagon code: reproducibility sources

This directory contains the manuscript sources and the exact executable replays cited in
Section 7. Python checks use only the standard library unless their module documentation says
otherwise. The Singular calculation is invoked through its fail-closed shell wrapper.

## Canonical six-arc class labels

The labels `C01` through `C15` are deterministic replay labels, not names imported from an external
census. They are assigned as follows.

1. `check_global_conic_gap.py` enumerates all 1,548 six-arcs containing the standard four-frame.
2. For each arc, `projective_class_key` normalizes each of its 360 ordered four-frames, sorts the six
   normalized points, and takes the lexicographically least resulting tuple.
3. The fifteen distinct keys are sorted lexicographically and numbered `C01`, ..., `C15`.

The global-gap replay prints the complete listing under
`class|normalized_reps|stabilizer|canonical_arc|...`, including each canonical point tuple.
`check_low_degree_loci.py` regenerates the same sorted keys and prints its rows in
that order. Thus the manuscript's `C02` is the second canonical-key row, whose exact quartic is
printed by the low-degree replay.

Run the relevant checks from this directory:

```bash
uv run python check_global_conic_gap.py
uv run python check_low_degree_loci.py
nix shell nixpkgs#singular -c ./check_low_degree_loci.sh
```

`check_low_degree_loci.sh` invokes `check_low_degree_loci.sing`; both cover the C02, C04, and C12
geometry. The historical filename `check_chirality.py` deliberately retains the paper's qualified
“support chirality” shorthand; its mathematical claim is the intrinsic unordered support
bipartition.

The immutable release produced by task C182 will extend this file with the frozen environment,
complete replay command list, expected success sentinels, typical runtimes, licenses, commit and
release identifiers, and the archive manifest.
