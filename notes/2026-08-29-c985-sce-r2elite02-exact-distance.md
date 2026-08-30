# C985 SCE R2Elite02 exact distance certificate

**Lane:** `complete-ports`

**Date:** 2026-08-29
**Literature depth:** Liu--Marquardt arXiv:2606.24808v1 was read partially from the
authoritative TeX source: the lifted-product definition, candidate table, distance methodology,
and complete `R2Elite02` protographs.

## Outcome

Ergodis independently reconstructs the published dihedral lifted-product candidate and certifies

```text
R2Elite02 = [[1496,198,16]].
```

The source reports `[[1496,198,<=16]]` from `10^5` randomized QDistRnd trials.  Here the lower
bound is exhaustive and the upper bound is a retained, independently replayed weight-16 logical
witness.  The exact figure of merit is

```text
k d^2 / n = 198 * 16^2 / 1496 = 576/17 = 33.88235294...
```

This is 1.765x the prior exact Ergodis frontier 19.2 from BB360 and slightly exceeds the certified
R2Elite01 lower figure 33.1979.  This is an exact-distance result for a published code, not a new
code or priority claim.

## Construction and theorem boundary

`python/generate_sce_lp_native.py` transcribes the source's `D_22` presentation and its complete
`5 x 3` singleton protographs.  It uses left regular action for `A`, inverse right regular action
for `B`, and the source lifted-product formula.  The deterministic checks obtain

```text
n=1496, rank(Hx)=649, rank(Hz)=649, k=198,
Hx Hz^T=0, presented check weight=8.
```

The combined presented X/Z support graph has one component.  No stronger equivalence-level
indecomposability is claimed.  No non-abelian coordinate action is assumed: both searches use all
1,496 anchors.  Every physical column has odd degree, so the sum of physical rows is all-ones and
every kernel word has even weight.  Exhaustion through radius 14 therefore proves both directional
distances at least 16.

The retained radius-16 runs sharpen the directional statement:

| Direction | Candidates | Search seconds | Result |
| --- | ---: | ---: | --- |
| `ker(Hz)/row(Hx)` | 100,609,601,462 | 548.087546038 | no logical through 16; `dX >= 18` |
| `ker(Hx)/row(Hz)` | 16,356,698,669 | 99.855133830 | weight-16 logical witness; `dZ = 16` |

Thus `min(dX,dZ)=16`.  The Z witness support is

```text
396 431 635 648 867 878 1061 1066 1079 1085 1278 1279 1284 1290 1302 1319
```

The independent Python checker recomputes zero physical syndrome and a nonzero 198-bit logical
observation for that support.  For the bounded X miss, it checks metadata but cannot independently
replay the 100.61-billion-candidate exhaustion; the lower bound trusts the reviewed Rust enumerator,
all-coordinate anchors, and the elementary parity theorem.

## Evidence and replay

Tracked files:

- `ergodis/python/generate_sce_lp_native.py`, 10,287 bytes,
  SHA-256 `9bce51d855b9b9777dc2dc87c15384e5e3bde590d50f030bf99b67307a8939e7`;
- `ergodis/evidence/c985-sce-r2elite02-x-w16.jsonl`, 7,559 bytes,
  SHA-256 `7da0366cbdc07ed7c430ec24030154310a1b1a5f2cbe4be1e434f8dd60dd5894`;
- `ergodis/evidence/c985-sce-r2elite02-z-w16.jsonl`, 7,624 bytes,
  SHA-256 `30611a991de0598d0696590a362e61a1b08a566f6d7caa5df734cded23ff0071`.

Canonical generated inputs are deterministic and cache-only:

- X: 176,442 bytes, SHA-256
  `d18e4fce608b433173f2cf20b8cbca3682d678480b7298304eb7677f6c2b6049`;
- Z: 113,616 bytes, SHA-256
  `88561622c850099870c410f114a0057cf8fdaec7a47681304d6fbafdbd96778c`.

Replay from the Ergodis root using disk-backed cache rather than `/tmp`:

```bash
SCE_CACHE=/home/tavis/.cache/ergodis/c985/sce
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/c985-sce-target

for direction in x z; do
  python3 python/generate_sce_lp_native.py --candidate r2elite02 \
    --direction "$direction" --maximum-weight 16 \
    --out "$SCE_CACHE/r2elite02-$direction.json"
done

cargo build --release --features parallel,large-css --bin css_distance_native

for direction in x z; do
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite02-$direction.json" --maximum-weight 2 \
    --compiled-out "$SCE_CACHE/r2elite02-$direction.ergocss" --threads 1
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite02-$direction.json" \
    --compiled-in "$SCE_CACHE/r2elite02-$direction.ergocss" \
    --maximum-weight 16 --threads 16 \
    --evidence "$SCE_CACHE/r2elite02-$direction-w16.jsonl"
  python3 python/check_bb_native.py --minimum-rounds 1 \
    --input "$SCE_CACHE/r2elite02-$direction.json" \
    --evidence "$SCE_CACHE/r2elite02-$direction-w16.jsonl"
done
```

## Source boundary

Primary source: Zidu Liu and Florian Marquardt, *Large-Language-Model Discovery of Quantum LDPC
Codes through Structured Concept Evolution*, arXiv:2606.24808v1 (2026), Table 1 and Supplemental
Sections S1 and S7.  The source labels the distance and figure of merit as QDistRnd-derived upper
bounds.  This bundle replaces that randomized distance proxy with an independent exact certificate.

## Mystery ledger (ej + tt closeout)

- **Quantum distance:** closed exactly at 16.
- **Directional X distance:** only `dX >= 18` is needed here; its exact value remains open and has
  no effect on the quantum distance.
- **Non-abelian symmetry:** no coordinate-orbit theorem is assumed.  A verified action could make
  future larger shells cheaper, but is not part of this certificate.
- **Decomposability:** one presented support component rules out only the obvious Tanner direct sum;
  full code-equivalence indecomposability remains unclassified.
- **Source agreement:** the independently reconstructed dimensions and exact distance agree with
  the source candidate.  The retained witness settles the randomized upper bound without relying
  on the source's trial log.

This is the highest-value immediate landing from the SCE scan: exact certification of a length-1496,
rate-0.132 non-abelian lifted-product candidate with a compact witness and low-memory exhaustive
lower bound, using the same engine previously demonstrated on bivariate bicycle codes.
