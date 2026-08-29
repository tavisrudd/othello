# C985 SCE R2Elite01 certified distance lower bound

**Lane:** `complete-ports`

**Date:** 2026-08-29
**Literature depth:** Liu--Marquardt arXiv:2606.24808v1 was read partially from the
authoritative TeX source: the lifted-product definition, candidate table, distance methodology,
and complete `R2Elite01` protographs.

## Outcome

Ergodis independently reconstructs the non-abelian lifted-product code `R2Elite01` and certifies

```text
[[1496,194,d]],  16 <= d,
```

in both CSS directions.  The paper reports only a randomized QDistRnd upper bound `d <= 20`; this
bundle does not independently certify that upper bound.  The exact distance therefore remains open.

The certified lower figure of merit is

```text
k d^2 / n >= 194 * 16^2 / 1496 = 6208/187 = 33.19786096...
```

This is 1.729x the prior certified Ergodis frontier `19.2` from BB360.  Unlike the earlier BB
controls, this target is a 1,496-coordinate, high-rate, non-abelian lifted-product construction.
Its presented combined X/Z support graph has one component, ruling out a visible Tanner-component
direct sum; no claim of full code-equivalence indecomposability is made.

## Construction and checks

`python/generate_sce_lp_native.py` transcribes the source's `Dic_11` presentation

```text
r^22=e, s^2=r^11, s r s^-1=r^-1, |G|=44
```

and its published `5 x 3` singleton protographs.  It implements the source convention that `A`
uses the left regular action and `B` the inverse right regular action, then applies the lifted
hypergraph-product formula.  The deterministic generator checks the finite group axioms, CSS
commutation, check weight eight, quotient dimension, and visible support connectivity.  It obtains

```text
rank(Hx)=652, rank(Hz)=650, k=1496-652-650=194.
```

No coordinate-orbit theorem is assumed for the non-abelian construction: both exact searches use
all 1,496 coordinates as anchors.  Every column in either physical matrix has odd degree (five in
one sector and three in the other), so the sum of the presented rows is all-ones.  Consequently
every physical-kernel word has even weight.  Exhaustion through radius 14 therefore excludes
weight 15 as well and proves each directional distance at least 16.

## Search measurements

| Direction | Candidates | Search seconds | Result |
| --- | ---: | ---: | --- |
| `ker(Hz)/row(Hx)` | 6,897,374,903 | 35.784889514 | no logical through 14 |
| `ker(Hx)/row(Hz)` | 3,575,114,608 | 21.462175143 | no logical through 14 |

The separate huge specialization uses 24 support words, 11 syndrome words, and up to four logical
words.  The first 64 logical observations remain in the existing per-candidate hot column.  The
remaining observations occupy a flat cold side table and are consulted only at zero-syndrome
leaves; candidate expansion therefore still carries and updates one logical word.  Search stacks
are iterative and pre-sized, with no per-candidate allocation.

The prior BB large specialization remains 13 support words, six syndrome words, one logical word,
and artifact version 2.  A retained BB784 artifact loads through `large-artifact-load` after the
change, so the 1,496-coordinate extension neither widens BB hot loops nor invalidates their cache.

Cold huge compilation took 14.821350713 seconds for X and 14.413619936 seconds for Z.  The two
cache artifacts are about 34.7 MB each and remain cache-only.

## Evidence and replay

Tracked files:

- `ergodis/python/generate_sce_lp_native.py`, 9,581 bytes,
  SHA-256 `cc369e36def2ab8a02a8be4f1e9f0cee127f14b2a5e5ba3b7a11ddeafe7dc2c9`;
- `ergodis/evidence/c985-sce-r2elite01-x-w14.jsonl`, 7,546 bytes,
  SHA-256 `a7ac40f739c56603278685e0ff47cadffd8ccfa86f21937d4c15214cc94d427d`;
- `ergodis/evidence/c985-sce-r2elite01-z-w14.jsonl`, 7,544 bytes,
  SHA-256 `4830fa5b5daaf2247645d52c4576c65a067541268ec963f8dbc9676e3755847e`.

Canonical generated inputs are cache-only because they are deterministic 96--115 KB expansions:

- X: 115,015 bytes, SHA-256
  `3a6cbbe12647e8bf0570a9b2407d6713cf5042552ba5baf8a38faf5d4f23d427`;
- Z: 96,616 bytes, SHA-256
  `34e546d3768218d177a567212b37a65a4eab5f90c384fd8096d69ee09fe3c1d6`.

Replay from the ergodis root, using disk-backed cache rather than `/tmp`:

```bash
SCE_CACHE=/home/tavis/.cache/ergodis/c985/sce
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/c985-sce-target

python3 python/generate_sce_lp_native.py --candidate r2elite01 \
  --direction x --maximum-weight 20 --out "$SCE_CACHE/r2elite01-x.json"
python3 python/generate_sce_lp_native.py --candidate r2elite01 \
  --direction z --maximum-weight 20 --out "$SCE_CACHE/r2elite01-z.json"

cargo build --release --features parallel,large-css --bin css_distance_native

for direction in x z; do
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite01-$direction.json" --maximum-weight 2 \
    --compiled-out "$SCE_CACHE/r2elite01-$direction.ergocss" --threads 1
  "$CARGO_TARGET_DIR/release/css_distance_native" \
    --input "$SCE_CACHE/r2elite01-$direction.json" \
    --compiled-in "$SCE_CACHE/r2elite01-$direction.ergocss" \
    --maximum-weight 14 --threads 16 \
    --evidence "$SCE_CACHE/r2elite01-$direction-w14.jsonl"
done

python3 python/check_bb_native.py --minimum-rounds 1 \
  --input "$SCE_CACHE/r2elite01-x.json" \
  --evidence "$SCE_CACHE/r2elite01-x-w14.jsonl"
python3 python/check_bb_native.py --minimum-rounds 1 \
  --input "$SCE_CACHE/r2elite01-z.json" \
  --evidence "$SCE_CACHE/r2elite01-z-w14.jsonl"
```

The generator independently verifies the symbolic-to-binary construction invariants.  The existing
Python evidence checker independently rechecks retained witnesses, input/evidence dimensions, and
search metadata; because these runs are bounded misses, it cannot independently replay the
10.47-billion-candidate exhaustion.  The exact lower bound trusts the reviewed Rust enumerator,
the all-coordinate anchor set, and the elementary even-kernel argument.

## Source boundary

Primary source: Zidu Liu and Florian Marquardt, *Large-Language-Model Discovery of Quantum LDPC
Codes through Structured Concept Evolution*, arXiv:2606.24808v1 (2026), Table 1 and Supplemental
Sections S1 and S7.  The source explicitly labels its distances and figures of merit as upper
bounds from `10^5` QDistRnd trials.  This report claims an independent certified lower bound,
not a new code construction and not an exact-distance or priority result.

## Mystery ledger (ej + tt closeout)

- **Exact distance:** open in `{16,18,20}` if the source's randomized upper bound is witnessed.
  A reproducible weight-20 witness plus exact radius-18 closure is the direct gate.
- **Directional asymmetry:** the X direction was additionally exhausted through radius 16 in a
  diagnostic run (86.685 billion candidates, 478.276 seconds), while Z was not.  This is not part
  of the retained quantum-distance claim; the unequal ranks `652/650` make asymmetry plausible.
- **Non-abelian symmetry:** no sound 34-block orbit reduction was established.  The retained result
  deliberately pays for all 1,496 anchors.  A verified coordinate action could cut the next shells
  substantially, but no regular-action analogy is assumed.
- **Decomposability:** one visible support component settles only the obvious direct-sum failure.
  Full equivalence-level decomposition remains untested and is a separate classification gate.

The unexpectedly high value is already settled: a code reported only with a randomized distance
proxy now has a rigorous lower figure of merit 73% above the prior Ergodis frontier, and the same
native engine has crossed from bivariate bicycles to non-abelian lifted products.
