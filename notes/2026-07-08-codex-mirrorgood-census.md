# C28 report: MirrorStep/MirrorClosed census

Date: 2026-07-08.

## Result

I added a `mir` diagnostic mode to `2026-07-06-grid-cap-solver.rs`.

Mode:

```text
mir <q> [--all-escapes] [--summary-only] [--closedcap <nodes>] [class-index...]
```

For each canonical size-3 residual grid class, it finds P-valued size-4 escape child positions and
tests all involutive grid automorphisms for:

- invariant selected set;
- `MirrorStepGood`: every legal move `x` can be answered by `tau(x)` and the two-move extension is
  legal;
- recursive `MirrorClosed`, capped by `--closedcap`.

Obstruction counts are classified as:

- fixed legal point;
- mirror image already selected;
- row/column chord obstruction;
- ordinary collinearity chord through selected structure.

## Machine Checks

Build:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-mir
```

Smoke test:

```text
target/gridcap-mir mir 11 --closedcap 2000 0
```

Output:

```text
MIR q=11 cls=0 esc=0 S4=0,0 1,1 2,3 3,2 invariant_invs=1 one_step=0 closed=- nodes=0 kind=swap min_obs=8 obs_fixed=0 obs_selected=0 obs_rc=0 obs_chord=8
mir q=11 classes=8 positions=1 invs=253 all_escapes=0 closedcap=2000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=1 no_invariant=0 min_obs_hist=8:1 [0.0s]
```

q=11, first P escape per canonical class:

```text
target/gridcap-mir mir 11 --closedcap 5000
```

Summary:

```text
mir q=11 classes=8 positions=8 invs=253 all_escapes=0 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=5 no_invariant=3 min_obs_hist=4:1 6:2 8:2 [0.0s]
```

q=11, all P escape children:

```text
target/gridcap-mir mir 11 --all-escapes --closedcap 5000
```

Summary:

```text
mir q=11 classes=8 positions=114 invs=253 all_escapes=1 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=46 no_invariant=68 min_obs_hist=3:7 4:18 6:10 8:11 [0.0s]
```

q=13, first P escape per canonical class:

```text
target/gridcap-mir mir 13 --closedcap 5000
```

Summary:

```text
mir q=13 classes=12 positions=12 invs=351 all_escapes=0 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=2 no_invariant=10 min_obs_hist=10:2 [0.0s]
```

q=13, all P escape children:

```text
target/gridcap-mir mir 13 --all-escapes --summary-only --closedcap 5000
```

Output:

```text
mir q=13 classes=12 positions=567 invs=351 all_escapes=1 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=115 no_invariant=452 min_obs_hist=5:14 6:12 8:14 10:70 12:5 [0.1s]
```

q=17, first P escape per canonical class:

```text
target/gridcap-mir mir 17 --summary-only --closedcap 5000
```

Output:

```text
mir q=17 classes=21 positions=21 invs=595 all_escapes=0 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=15 no_invariant=6 min_obs_hist=10:2 16:4 18:8 20:1 [7.4s]
```

q=17 min-escape classes only (`escape=5` classes 2, 17, 19), all P escape children:

```text
target/gridcap-mir mir 17 --all-escapes --summary-only --closedcap 5000 2 17 19
```

Output:

```text
mir q=17 classes=21 positions=15 invs=595 all_escapes=1 closedcap=5000 one_step=0 closed_yes=0 closed_cap=0 closed_no=0 no_step=11 no_invariant=4 min_obs_hist=10:3 18:8 [5.2s]
```

## Interpretation

At size-4 escape witnesses, `MirrorClosed` gives no immediate certificate compression in the
tested odd-plane ladder:

- q=11: 0 one-step mirror hits among 114 P escape children.
- q=13: 0 one-step mirror hits among 567 P escape children.
- q=17 min-escape sample: 0 one-step mirror hits among all 15 P escape children of the three
  min-escape classes.

Most positions do not even have an invariant involution.  When they do, the corrected
pair-extension condition usually fails by either row/column mirror chords or ordinary collinearity
mirror chords.  Fixed legal points also occur in some symmetric q=11 cases.

## Recommendation

Keep the Lean `MirrorStepGood` / `MirrorClosed` lemmas as reusable proof kernels and possible deep
terminal certificate leaves, but do **not** expect immediate certificate compression at the
size-4 escape layer for q=11 or q=13.

The diagnostic is still useful for later certificate books:

- run it on deeper P-book nodes after certificate generation;
- only add a `MirrorClosed` leaf format if deeper-node hit rate becomes nontrivial;
- use the obstruction histograms to guide any central-inversion endgame lemma.
