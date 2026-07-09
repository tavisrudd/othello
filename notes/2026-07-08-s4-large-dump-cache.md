# S4 large dump cache

Built 2026-07-08 PST under:

```text
rust/s4-dumps/2026-07-08/
```

The directory is intentionally ignored by git.  It contains current-format `GCAPRAW3` raw memo
dumps and `GCAPBUR3` BuRR archives for query/mining.  `q=21` is skipped because 21 is not a finite
field order.

## Cached Dumps

- `q=9`, `q=11`, `q=13`, `q=17`: small normalized root samples for `rep=1,2,3,4`, raw only.
  These are regression/mining samples, not full bucket coverage.  Note: the q=11 sample root is
  `N`, so use it for geometry checks rather than as a P-valued follower example.
- `q=19`: all 13 full-`PGL(2,19)` S4 bucket representatives, exact, with raw and BuRR files.
- `q=23`: two exact roots:
  - `rep=1,2,3,4`, raw 288 MiB, BuRR 69 MiB;
  - `rep=1,2,5,6`, raw 326 MiB, BuRR 78 MiB.
- `q=25`: two partial current-format raw dumps:
  - `rep=1,2,3,5`, cap 20M, raw 458 MiB;
  - `rep=1,2,3,4`, cap 5M, raw 115 MiB.

The cache manifest is:

```text
rust/s4-dumps/2026-07-08/manifest.txt
```

## First Mining Results

Live-conic fields are from `s4mine`.

`q=19` aggregate over all 13 exact bucket representatives:

```text
reply_live0=174
knownP_zero_replies=0
depth2_live0=63
depth2_P=0
depth2_N=0
depth2_unknown=63
```

Interpretation: conic-emptying root replies exist at q=19, but the early-break proof dumps do not
value them.  They are not currently a visible P-repair mechanism in the dumped proof tables.

`q=23` exact samples:

```text
rep=1,2,3,4: root_moves=260, root_replies=47500, reply_live0=0, depth2_state_live0=0
rep=1,2,5,6: root_moves=261, root_replies=47836, reply_live0=0, depth2_state_live0=0
```

`q=25` partial samples:

```text
rep=1,2,3,5: root_moves=330, root_replies=79378, reply_live0=0, state_live0=0
rep=1,2,3,4: root_moves=320, root_replies=74600, reply_live0=0, state_live0=0
```

Current signal: q=17 and q=19 have shallow conic-emptying reply/state strata, while the sampled
q=23 exact roots and all q=25 bucket representatives checked structurally have none at the
root-reply layer.  This suggests "empty the conic" is a small/medium-q repair feature, not the
large-q bulk mechanism by itself.

## ML / Joint-Summary Pass

The cache also has parsed exploratory reports under:

```text
rust/s4-dumps/2026-07-08/ml/
```

Regenerate from `rust/` with:

```text
UV_CACHE_DIR=.uv-cache uv run scripts/s4_ml_mine.py --cache-dir s4-dumps/2026-07-08
```

Important generated files:

- `reply-features.tsv`, `state-features.tsv`: parsed `s4mine` rows.
- `reply-geom-joint-summary.tsv`, `state-shape-joint-summary.tsv`: joint geometry/count tables.
- `reply-geom-classifiers.txt`, `state-shape-classifiers.txt`: shallow tree reports for
  hypothesis generation.
- `conic-bound-report.txt` / `.tsv`: two-ply conic-depletion check.

The conic-bound report currently checks q=9,11,13,17,19,23,25 root samples and has zero failures:

```text
off/off lower bound: max(0, q - 19)
off/on lower bound:  max(0, q - 13)
on/on lower bound:   max(0, q - 7)
```

This is the best proof-facing import from the ML pass so far.  It turns the observed absence of
q>=23 conic-emptying root replies into a concrete incidence-count lemma target.  Semi-formal proof
note: [`2026-07-08-s4-two-ply-conic-depletion.md`](2026-07-08-s4-two-ply-conic-depletion.md).
