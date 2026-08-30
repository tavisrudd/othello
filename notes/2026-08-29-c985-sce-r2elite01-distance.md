# C985 SCE R2Elite01 exact distance certificate

**Lane:** `complete-ports`

**Date:** 2026-08-29
**Literature depth:** Liu--Marquardt arXiv:2606.24808v1 was read partially from the
authoritative TeX source: the lifted-product definition, candidate table, distance methodology,
and complete `R2Elite01` protographs.  QDistRnd v0.9.5 at upstream commit
`45e248515604253115ea9bc73a522b729de32056` was read at its CSS random-information-set routine.

## Outcome

Ergodis independently reconstructs the published non-abelian lifted-product candidate and proves

```text
R2Elite01 = [[1496,194,20]].
```

The source reports `[[1496,194,<=20]]` from `10^5` randomized QDistRnd trials.  This bundle replaces
that proxy with two exhaustive lower searches and an independently replayed weight-20 X-type logical.
The exact figure of merit is

```text
k d^2 / n = 194 * 20^2 / 1496 = 9700/187 = 51.87165775...
```

This is 2.702x the prior exact Ergodis frontier 19.2 from BB360 and 1.531x the adjacent exact
R2Elite02 figure 576/17.  This is an exact-distance result for a published code, not a new-code or
priority claim.

## Construction and certified symmetry

`python/generate_sce_lp_native.py` transcribes the source's `Dic_11` presentation

```text
r^22=e, s^2=r^11, s r s^-1=r^-1, |G|=44
```

and complete `5 x 3` singleton protographs.  It uses left regular action for `A`, inverse right
regular action for `B`, and the source lifted-product formula.  Deterministic checks obtain

```text
n=1496, rank(Hx)=652, rank(Hz)=650, k=194,
Hx Hz^T=0, presented check weight=8.
```

The central involution `r^11` acts within every 44-coordinate block.  Before emitting reduced
anchors, the generator verifies the group laws, centrality and order two, the 1,496-point
permutation, and exact preservation of both complete presented row sets.  It also solves the
natural block-dependent left- and right-multiplier compatibility equations induced by the full
published `A,B` tables.  Each family has exactly two actions: identity and the central involution.
Thus the exact search uses one representative from each of 748 certified coordinate orbits.  This
does not claim the full code automorphism group is order two.

The combined presented support graph has one component, ruling out only a visible Tanner direct
sum.  Every physical column has odd degree, so the sum of the presented physical rows is all-ones.
Every kernel word is therefore even.  Exhaustion through radius 18 excludes weight 19 as well and
proves each directional distance at least 20.

## Exact searches

| Direction | Anchors | Candidates | Search seconds | Result |
| --- | ---: | ---: | ---: | --- |
| X-check input: `ker(Hx)/row(Hz)` | 748 | 531,266,861,549 | 3,089.007529785 | no logical through 18; `dZ >= 20` |
| Z-check input: `ker(Hz)/row(Hx)` | 748 | 181,209,204,297 | 1,158.830475018 | no logical through 18 |

Both use the iterative, pre-sized huge backend at about 40 MB RSS.  The search carries one 64-bit
logical word per hot candidate; remaining observations live in a flat cold side table consulted
only at zero-syndrome leaves.  Evidence is emitted once on completion rather than accumulated in
memory.

## Deterministic upper witness

`css_distance_random` implements the same random-information-set principle as QDistRnd in a
bit-packed native form.  For each seeded coordinate order it row-reduces the physical parity-check
space and inspects the induced systematic kernel basis.  Worker matrices, permutations, pivot
markers, logical scratch, and witness scratch are pre-sized; a trial allocates nothing unless it
finds a witness.  It is only an upper-certificate finder.

On the Z input, seed `98502` deterministically finds a weight-20 logical at trial 765:

```text
447 452 454 480 664 668 678 683 701 894
918 1100 1102 1114 1119 1124 1320 1322 1325 1360
```

The independent Python checker recomputes zero physical syndrome and a nonzero 194-bit logical
observation (weight 10).  Combined with the Z-check radius-18 miss, this proves `dX=20`; combined
with `dZ>=20` from the X-check input, it proves quantum distance 20.

## Evidence and replay

Tracked load-bearing files:

- `ergodis/python/generate_sce_lp_native.py`, 14,560 bytes,
  SHA-256 `6fbafd5e8e38dc68569cf1e2bddac1984cb81779ff81758b776d682b13c3342a`;
- `ergodis/python/check_bb_native.py`, 5,496 bytes,
  SHA-256 `5fa76cdc0d43dc40deabc21ccd3627e51ace8821936563873dcc07f5cdb97cd1`;
- `ergodis/src/bin/css_distance_random.rs`, 13,896 bytes,
  SHA-256 `c7e936a56cba7f90a033954a099b92c8027b296f0981bd9b953b9de9f849428c`;
- `ergodis/evidence/c985-sce-r2elite01-x-w18.jsonl`, 4,362 bytes,
  SHA-256 `dab7d13f1b7b800c4861bc55a789d131e45ec71a30a2f4eb96a3612a9408bdc6`;
- `ergodis/evidence/c985-sce-r2elite01-z-w18.jsonl`, 4,362 bytes,
  SHA-256 `9ab910f177bf28f49c985e7e52b9eac7d025dda4ac372007d8feae887b640318`;
- `ergodis/evidence/c985-sce-r2elite01-z-w20-witness.jsonl`, 578 bytes,
  SHA-256 `3be8548f281a051fee1b9ad2746ffcc0dd5f3bd214848eb97d0c5e4690b18e9c`.

Canonical expanded inputs are deterministic and cache-only:

- X: 111,916 bytes, SHA-256
  `d992b58f3ff55170e1b9aa287ce0803d24fa00eb110347d34fac147565926f04`;
- Z: 93,517 bytes, SHA-256
  `d2c5c1d9ecb1aaa126a7789e82b66eff06739c8fa93b22155a243c5de57f0e64`.

Replay from the Ergodis root using disk-backed cache rather than `/tmp`:

```bash
SCE_CACHE=/home/tavis/.cache/ergodis/c985/sce
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/c985-sce-target

for direction in x z; do
  python3 python/generate_sce_lp_native.py --candidate r2elite01 \
    --direction "$direction" --maximum-weight 20 --verified-central-orbits \
    --out "$SCE_CACHE/r2elite01-$direction.json"
done

cargo build --release --features parallel,large-css \
  --bin css_distance_native --bin css_distance_random

for direction in x z; do
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite01-$direction.json" --maximum-weight 2 \
    --compiled-out "$SCE_CACHE/r2elite01-$direction.ergocss" --threads 1
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite01-$direction.json" \
    --compiled-in "$SCE_CACHE/r2elite01-$direction.ergocss" \
    --maximum-weight 18 --threads 16 \
    --evidence "$SCE_CACHE/r2elite01-$direction-w18.jsonl"
done

"$CARGO_TARGET_DIR/release/css_distance_random" \
  --input "$SCE_CACHE/r2elite01-z.json" --trials 10000 \
  --target-weight 20 --threads 1 --seed 98502 \
  --evidence "$SCE_CACHE/r2elite01-z-w20-witness.jsonl"

for direction in x z; do
  python3 python/check_bb_native.py --minimum-rounds 1 \
    --input "$SCE_CACHE/r2elite01-$direction.json" \
    --evidence "$SCE_CACHE/r2elite01-$direction-w18.jsonl"
done
python3 python/check_bb_native.py --minimum-rounds 1 \
  --input "$SCE_CACHE/r2elite01-z.json" \
  --evidence "$SCE_CACHE/r2elite01-z-w20-witness.jsonl"
```

The checker independently verifies the witness and exact-run metadata.  It cannot independently
replay the 712.48-billion-candidate bounded misses; those lower bounds trust the reviewed Rust
enumerator, generator-certified orbit cover, and elementary even-kernel argument.

## Source boundary

Primary source: Zidu Liu and Florian Marquardt, *Large-Language-Model Discovery of Quantum LDPC
Codes through Structured Concept Evolution*, arXiv:2606.24808v1 (2026), Table 1 and Supplemental
Sections S1 and S7.  The source labels its distance and figure of merit as QDistRnd-derived upper
bounds.  QDistRnd provenance: Leonid Pryadko, Vadim Shabashov, and Valerii Kozin, *QDistRnd: A GAP
package for computing the distance of quantum error-correcting codes*, JOSS 7 (2022), 4120.  This
bundle certifies the published candidate independently; it makes no construction-priority claim.

## Mystery ledger (ej + tt closeout)

- **Quantum distance:** closed exactly at 20.
- **Directional asymmetry:** `dX=20`; only `dZ>=20` is required, and exact `dZ` remains open.  The
  unequal physical ranks `652/650` and witness localization make the asymmetry plausible but do not
  explain it structurally.
- **Deck symmetry:** settled for both natural blockwise left- and right-multiplier families; each is
  exactly the central involution group of order two.  The full permutation automorphism group is
  not classified and is not needed by the certificate.
- **Decomposability:** one support component excludes only the obvious Tanner direct sum.  Full
  code-equivalence indecomposability remains a separate classification question.
- **Random/exact boundary:** settled.  The native RIS path supplies only a replayed upper witness;
  exactness comes exclusively from exhaustive radius-18 misses plus parity.

The cheap extra value is reusable: theorem-checked non-abelian deck-orbit compilation and a
deterministic, allocation-free-per-trial CSS witness backend now sit beside the exact solver.  The
headline remains the exact certification of the paper's highest-figure-of-merit reported code.
