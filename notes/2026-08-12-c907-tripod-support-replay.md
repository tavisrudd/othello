# C907 tripod-support deterministic replay

**Lane:** `clebsch`

This bundle is the exact finite support-level replay for
`2026-08-12-c907-tripod-common-prefan.md`.  It verifies only the claimed
product-of-tripods bookkeeping: the sixteen ordered strata, their ten
unordered `B <-> C` orbits, the twelve quotient Hasse edges, and the
restriction of the six universal support weights to each local max list.
It does not certify normalized graph/Fitting agreement across the
pair-of-pants transitions, added exceptional overlap charts, or proper collar
topology.

## Replay

From the repository root, with only the standard library supplied by Nix:

```sh
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-tripod-support-replay.py --check
```

To intentionally regenerate the canonical certificate after reviewing a
source change, replace `--check` with `--write`.  The latter overwrites only
the adjacent JSON certificate and checksum manifest.

## Certificate and conventions

The script fixes the `t=1` slice and represents each support weight as an
integral affine form in `(p1,p2,p3,beta,gamma)`.  It restricts

```text
0, p1, p2, p3, -p1-p2-p3+rB+rC, 2-sB-sC
```

along the three primitive tripod rays `(1,0)`, `(0,1)`, and `(-1,-1)`, plus
the central stratum.  `tripod-support-replay.json` records every ordered
restriction and the named local certificate used for its unordered orbit.
The terms absent from a printed local max list are retained in the raw
restriction and dropped only with a checked elementary dominance certificate;
in particular, the zero form remains on the `(1,1)` and `(1,infinity)` lists.

As an independent invariant check internal to the replay, the quotient edges
generated from the product poset must equal a separately encoded copy of the
twelve edges in equation (9); all listed local forms must be restrictions of
the six universal forms, with no other omission than the recorded zero-form
dominance rule.

## Tracked bytes and hashes

`2026-08-12-c907-tripod-support-replay.sha256` records SHA-256 hashes for the
generator and its canonical JSON output.  The replay checks both bytes and
hashes, so schema, ordering, or convention drift fails loudly.
