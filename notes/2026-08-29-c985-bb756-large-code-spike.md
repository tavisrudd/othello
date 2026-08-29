# C985 BB756 large-code native spike

**Lane:** `complete-ports`

**Date:** 2026-08-29
**Literature depth:** 0 sources read at full text; two sources read partially as recorded below.

## Outcome

Ergodis now accepts the published bivariate-bicycle construction
`[[756,16,<=34]]` and certifies that its `Hx/Gz` distance is at least 24.  The
bounded radius-22 search found no nontrivial word after 7,565,506,294
candidates in 32.793410331 seconds on 16 threads.  The prior radius-20 stage
took 3.561081260 seconds for 888,092,119 candidates.

This is a lower bound, not an exact-distance result: the paper's weight-34
upper bound has not yet been reproduced as a witness, and weights 24--32 remain
open.  Gurobi 13.0.2 with the installed restricted license rejected the
corresponding global model before optimization as too large.  That is a local
license boundary, not a performance comparison with unrestricted Gurobi.

The target is materially stronger than BB360 if the published upper bound is
tight: `k*d^2/n = 24.4656` at distance 34, versus 19.2 for the now-certified
`[[360,12,24]]` code.

## Construction and semantic checks

`python/generate_bb_native.py` constructs the code directly from

```text
ell,m = 21,18
A = x^3 + y^10 + y^17
B = y^5 + x^3 + x^19
Hx = [A | B]
Hz = [B^T | A^T]
```

It checks CSS commutation, computes deterministic GF(2) row bases and a basis
of `ker(Hz)/row(Hx)`, verifies ranks `rank(Hx)=rank(Hz)=370` and quotient
dimension 16, and emits the two translation-orbit anchors `[0,378]`.  An
independent construction through `bposd.css_code` reproduced the same ranks
and physical matrix; its logical basis differs syntactically but spans the
same quotient semantics.

The compiler also generalized its even-kernel detector.  The former condition
recognized only when the sum of the selected independent rows was all-ones.
The new sound alternative observes that if the sum of all presented check rows
is all-ones—equivalently, every presented column has odd weight—then every
kernel word is even.  This proves the BB756 parity shortcut directly from its
weight-three physical columns and skips all odd radii.

## Scaling architecture

The new specialization uses 12 support words and 6 syndrome words, supports up
to 768 coordinates and rank 384, and has distinct artifact magic.  It is gated
behind the opt-in Cargo feature `large-css`; ordinary `parallel` builds do not
link the large search monomorph.

The old completion-filter compiler materialized `O(n^3)` projected keys and
enumerated `O(n^4)` four-completions.  At 756 coordinates the first attempt was
still compiling after 90 seconds and was interrupted.  The large-only path now
streams triple keys directly into a fixed 16 MiB Bloom filter, retains only the
`O(n^2)` exact one/two-completion arrays, and conservatively disables the
four-completion rejection with an all-positive filter.  Cold compilation is
1.538285858 seconds, artifact write is 0.011295341 seconds, the artifact is
about 14 MiB, and measured search RSS is 23.6 MiB.  Search workspaces remain
pre-sized, iterative, and allocation-free per candidate.

The small path passed a 40-run interleaved old/current BB288 A/B on the same
machine.  Mean search times were 0.189170009 s old and 0.188652858 s current,
ratio 0.997266 and Welch `t=-0.1229`.  Thus no small-solve slowdown was
detected.  The earlier sequential samples were misleading due to run-order
noise.

## Evidence and replay

Tracked records:

- `evidence/c985-bb756-hx-gz-w20.jsonl`
- `evidence/c985-bb756-hx-gz-w22.jsonl`

Cache-only artifacts live under `/home/tavis/.cache/ergodis/bb756`; `/tmp` was
not used.  Replay from the ergodis root:

```bash
ERGODIS_CACHE=/home/tavis/.cache/ergodis/bb756
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/c985-large-target

nix develop -c python python/generate_bb_native.py \
  --ell 21 --m 18 --a 3:0,0:10,0:17 --b 0:5,3:0,19:0 \
  --direction x --label bb756-hx-gz --maximum-weight 34 \
  --out "$ERGODIS_CACHE/hx-gz.json"

nix develop -c cargo run --release --features parallel,large-css \
  --bin css_distance_native -- --input "$ERGODIS_CACHE/hx-gz.json" \
  --compiled-out "$ERGODIS_CACHE/hx-gz-v3.ergocsl" \
  --maximum-weight 2 --threads 1

nix develop -c cargo run --release --features parallel,large-css \
  --bin css_distance_native -- --input "$ERGODIS_CACHE/hx-gz.json" \
  --compiled-in "$ERGODIS_CACHE/hx-gz-v3.ergocsl" \
  --maximum-weight 22 --threads 16 --pulse-interval 4096
```

## Source attribution

- Bravyi et al., arXiv:2308.07915, current arXiv HTML: **partial read**, Table 3
  and Lemmas 1, 3, and 4.  Table 3 supplies the construction and explicitly
  marks 34 as an upper bound.  Accessed through arXiv HTML; no PDF was added to
  the literature cache during this bounded implementation spike.
- `05oz/certify`, Git commit captured by the shallow checkout on 2026-08-29:
  **partial read**, README results, QEC preprint result table, and QEC sweep
  correction record.  It provides nearby certificate context but does not
  certify BB756.  This report makes no novelty or priority claim from that
  absence.

## Next gate

The highest-EV next theorem is an exact, memory-bounded four-completion test or
a stronger BB-specific partial-syndrome bound.  Radius 22 is already 9.21x the
radius-20 wall time; naïvely continuing predicts minutes at radius 24 and much
steeper growth thereafter.  In parallel, recover a replayable weight-34
incumbent from an unrestricted optimizer or a purpose-built information-set
decoder.  Once an incumbent is present, pulse propagation can reduce every
worker's bound immediately while the exact lower shells close.
