# C42 report: fixed-q on-conic census propagation

Date: 2026-07-09.

## Summary

C42 tested the surviving fixed-q half of the on-conic concentration factorization: for each size-3
class, count its `q-4` on-conic children by exact burned-pair-stabilizer orbit, then ask whether
those value-blind census vectors are uniform or nearly uniform across classes.

Verdict: **negative for a value-blind propagation identity.** The full stabilizer-orbit census is
non-uniform even at the clean all-P orders `q=13` and `q=19`: every size-3 class has a distinct
full census vector (`12/12` at q=13, `27/27` at q=19). The uniform onP counts at those orders are
therefore not caused by uniform geometry; they are caused by every observed stabilizer orbit being
P-valued.

The depleted orders retain small onP variation (`q=11: 2..5`, `q=17: 1..3`), but the variation is
spread across all P-valued stabilizer orbits (`10/10` at q=11, `21/21` at q=17). I do not see a
clean sub-census characterization in this data.

## Implementation

Added:

```text
rust/scripts/onconic_census_propagation.py
```

It reuses `onconic_child_type_alignment.py` for conic reconstruction and exact stabilizer orbit
keys. It reads only the on-disk feat censuses:

```text
notes/data/codex-feat5.out
notes/data/codex-feat7.out
notes/data/codex-feat11-c15.out
notes/data/codex-feat13-c15.out
notes/data/codex-feat17.out
notes/data/codex-feat19-c15.out
```

No new solves were run.

Generated tables:

```text
rust/s4-dumps/2026-07-09/c42-census/class_vectors.tsv
rust/s4-dumps/2026-07-09/c42-census/orbit_ranges.tsv
rust/s4-dumps/2026-07-09/c42-census/depleted_group_diffs.tsv
```

## Command

```bash
python3 scripts/onconic_census_propagation.py --out-dir s4-dumps/2026-07-09/c42-census
```

Output:

```text
C42 loaded records=852 prime_q=[5, 7, 11, 13, 17, 19]
ANCHOR onP histograms
  q= 5 onP_hist={1:1}
  q= 7 onP_hist={3:3}
  q=11 onP_hist={2:2,5:6}
  q=13 onP_hist={9:12}
  q=17 onP_hist={1:3,3:18}
  q=19 onP_hist={15:27}
SUMMARY fixed-q stabilizer census variation
  q= 5 classes=1 stab_orbits=1 P_orbits=1 distinct_full_vectors=1 full_l1_diam=0 full_coord_range_max=0 distinct_P_vectors=1 P_l1_diam=0 P_coord_range_max=0 onP_range=1..1
  q= 7 classes=3 stab_orbits=3 P_orbits=3 distinct_full_vectors=3 full_l1_diam=4 full_coord_range_max=2 distinct_P_vectors=3 P_l1_diam=4 P_coord_range_max=2 onP_range=3..3
  q=11 classes=8 stab_orbits=16 P_orbits=10 distinct_full_vectors=8 full_l1_diam=14 full_coord_range_max=2 distinct_P_vectors=8 P_l1_diam=8 P_coord_range_max=2 onP_range=2..5
  q=13 classes=12 stab_orbits=29 P_orbits=29 distinct_full_vectors=12 full_l1_diam=18 full_coord_range_max=6 distinct_P_vectors=12 P_l1_diam=18 P_coord_range_max=6 onP_range=9..9
  q=17 classes=21 stab_orbits=72 P_orbits=21 distinct_full_vectors=21 full_l1_diam=26 full_coord_range_max=2 distinct_P_vectors=20 P_l1_diam=6 P_coord_range_max=2 onP_range=1..3
  q=19 classes=27 stab_orbits=104 P_orbits=104 distinct_full_vectors=27 full_l1_diam=30 full_coord_range_max=6 distinct_P_vectors=27 P_l1_diam=30 P_coord_range_max=6 onP_range=15..15
DEPLETED variation localization
  q=11 low_onP=2 low_classes=2 high_onP=5 high_classes=6 changed_P_orbits=10/10 top=O11:davg=5/6 low=0 high=5 O07:davg=5/6 low=0 high=5 O08:davg=1/2 low=0 high=3 O03:davg=1/2 low=0 high=3 O06:davg=-1/2 low=2 high=3 O09:davg=1/3 low=0 high=2 O05:davg=1/3 low=0 high=2 O04:davg=1/3 low=0 high=2
  q=17 low_onP=1 low_classes=3 high_onP=3 high_classes=18 changed_P_orbits=21/21 top=O23:davg=-2/3 low=2 high=0 O66:davg=-1/3 low=1 high=0 O61:davg=5/18 low=0 high=5 O39:davg=5/18 low=0 high=5 O32:davg=5/18 low=0 high=5 O09:davg=5/18 low=0 high=5 O08:davg=2/9 low=0 high=4 O70:davg=1/6 low=0 high=3
VERDICT full-vector census is non-uniform even at all-P q=13 and q=19; the fixed-q propagation half is not a value-blind uniform census identity.
TABLES out_dir=s4-dumps/2026-07-09/c42-census
```

## Gate checks

The P-orbit projection reproduces the alignment report / witness-count onP histograms exactly:

```text
q= 5 {1:1}
q= 7 {3:3}
q=11 {2:2,5:6}
q=13 {9:12}
q=17 {1:3,3:18}
q=19 {15:27}
```

The stabilizer-orbit counts match the alignment report's exact stabilizer bucket counts:

```text
q=5:1  q=7:3  q=11:16  q=13:29  q=17:72  q=19:104
```

## Interpretation

The value-free census vector is much less stable than the onP count:

```text
q=13: onP is constant 9, but full census vectors are 12/12 distinct.
q=19: onP is constant 15, but full census vectors are 27/27 distinct.
```

So the all-P orders do not support a class-uniform census identity. The concentration is not
"each class sees the same stabilizer-orbit mix"; it is "all the orbit types visible at this q are
P-valued."

At the depleted orders, the small onP range is real but value-dependent:

```text
q=11: onP range 2..5; all 10 P-valued stabilizer orbits differ between low/high groups.
q=17: onP range 1..3; all 21 P-valued stabilizer orbits differ between low/high groups.
```

That is too scattered to be a clean missing-orbit lemma from this census alone. A later proof may
still explain the depletion arithmetically, but C42 does not produce a value-free propagation
principle.

## Consequence

The original factorization is now closed negative on both halves:

- q-independent type -> value dictionary: refuted by the on-conic child type-alignment report.
- fixed-q value-blind census propagation: refuted here by q=13/q=19 full-vector non-uniformity.

The uniform (ON) route should not rely on a stabilizer-orbit census propagation lemma. It has to
engage the q-dependent arc-depletion arithmetic directly, with the measured onP ranges retained as
diagnostics rather than as a standalone proof scaffold.
