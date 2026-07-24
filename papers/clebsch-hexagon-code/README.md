# The Clebsch hexagon code: reproducibility sources

This directory contains the manuscript sources and the exact executable replays cited in
Section 13. Python checks use only the standard library unless their module documentation says
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

Enter the locked paper environment and run the relevant checks from this directory:

```bash
nix develop
python3 check_global_conic_gap.py
python3 check_low_degree_loci.py
./check_low_degree_loci.sh
tectonic clebsch_hexagon_code.tex
```

`check_low_degree_loci.sh` invokes `check_low_degree_loci.sing`; both cover the C02, C04, and C12
geometry. The historical filename `check_chirality.py` deliberately retains the paper's qualified
“support chirality” shorthand; its mathematical claim is the intrinsic unordered support
bipartition.

The complete release check also needs a separate checkout of
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom) at the commit recorded in
`verification/trust_manifest.json`. From this paper environment, run

```bash
python3 verification/verify_release.py --lean-root /path/to/shared-lean
```

The runner verifies the Lean checkout against the pinned commit before executing the aggregate
trust gate.

The immutable archival release will extend this file with expected success sentinels, typical
runtimes, licenses, release identifiers, and the archive manifest.
