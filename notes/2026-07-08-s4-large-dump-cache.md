# S4 large dump cache

Built 2026-07-08 PST under:

```text
rust/s4-dumps/2026-07-08/
```

The directory is intentionally ignored by git.  It contains current-format `GCAPRAW3` raw memo
dumps and `GCAPBUR3` BuRR archives for query/mining.  `q=21` is skipped because 21 is not a finite
field order.

## Cached Dumps

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

