# C985 optional CSS automorphism-discovery adapter

**Lane:** `complete-ports`

**Date:** 2026-09-01

**Status:** LANDED

## Result

Commit `b89f00c45` adds `css_automorphism_adapter`, an optional cold
preprocessor for sparse CSS instances.  It can either invoke nauty's
`dreadnaut` on the physical Tanner presentation or consume a bounded,
backend-neutral JSON proposal.  A discovery backend has no proof authority:
Ergodis independently checks every retained coordinate permutation and the
final orbit transversal against the physical row space and the
physical-plus-logical observable row space.

The adapter is deliberately outside the solve path.  It changes no search
kernel, hot record, allocator boundary, or parallel synchronization path.  A
solve remains usable with the input's existing generators when no discovery
backend is installed.

## Boundary and failure policy

The proposal schema `ergodis-css-automorphism-proposal-v1` records the backend,
the exact BLAKE3 digest of the source input, its coordinate/check dimensions,
and full-image coordinate generators.  Inputs, outputs, and optional proposal
records are create-only.  Backend output is capped at 16 MiB, proposal input at
64 MiB, and a proposal at 4,096 generators.  Cross-instance, oversized,
partition-crossing, malformed, or non-permutation data fail closed.

An individually valid generator is retained only when:

1. it preserves `rowspan(physical)`;
2. it preserves `rowspan(physical) + rowspan(logical)`; and
3. adding it strictly reduces the current coordinate-orbit count.

The combined retained action and its exact transversal are then verified
again.  This greedy condition loses no orbit reduction from a pair whose
members are individually redundant: if each new permutation preserves every
current orbit setwise, their generated subgroup does too.

No nauty code is bundled, linked, copied, or trusted.  The proposal-in boundary
also permits later adapters for Traces, bliss, saucy, or domain-specific group
engines without changing the Ergodis admission logic.

## Controls

The binary's three unit tests cover wrapped and consecutive `+p` full-image
parsing, extraction of the coordinate colour class, partition crossing and
incomplete-output rejection, and exact rejection of a Tanner symmetry that
changes the logical observable.  The consecutive-generator case is material:
BB288's dreadnaut transcript emits two generators back-to-back before its
first `level` line.  Commit `d197f63b7` makes the parser frame the numeric token
stream by the exact Tanner vertex count rather than treating `level` as a
generator delimiter.

An end-to-end control used the official LP1768 X input.  With its existing
generator present, nauty proposed one generator and Ergodis retained zero new
generators, leaving 34 coordinate orbits.  Removing the supplied generator
from a disposable copy caused the adapter to rediscover one generator and
reduce 1,768 singleton anchors to the same 34 exact orbits.  Proposal replay
produced byte-identical upgraded JSON, while adding one irrelevant newline to
the source input caused the BLAKE3-bound proposal to be rejected before output.

A ten-direction sweep found a useful application gain that the earlier
hand-written symmetry families missed:

| family | directions | proposed | newly retained | old orbits | new orbits |
|---|---:|---:|---:|---:|---:|
| BB288 | X/Z | 3 | 1 | 2 | 1 |
| BB360 | X/Z | 3 | 1 | 2 | 1 |
| TN360 | X/Z | 2 | 0 | 36 | 36 |
| LP714 | X/Z | 1 | 0 | 34 | 34 |
| LP1768 | X/Z | 1 | 0 | 34 | 34 |

The extra BB generator swaps the two translation orbits while preserving the
complete CSS search predicate.  A one-thread debug-build radius-16 diagnostic
therefore reduces exact candidates by 2.044x/1.987x on BB288 X/Z and by
1.992x/1.919x on BB360 X/Z.  The corresponding wall ratios are
1.824x/1.844x and 2.055x/2.131x, but these single diagnostic runs overlapped a
separate campaign and are not release-performance claims.  The exact candidate
reduction is deterministic and the upgraded BB288 file is accepted directly
by `css_distance_native`.

Replay commands:

```sh
nix shell nixpkgs#nauty --command \
  target/debug/css_automorphism_adapter \
  --input LP_1768_224_q-x.json \
  --output upgraded.json \
  --proposal-out proposal.json

target/debug/css_automorphism_adapter \
  --input LP_1768_224_q-x.json \
  --output replayed.json \
  --proposal-in proposal.json
```

The scoped unit suite passes.  Strict clippy passes for the adapter after
allowing the five pre-existing Rust-1.93 `manual_is_multiple_of` findings in
unrelated library files; those findings are not changed by this tranche.

## Interpretation

This closes the discovery-interface gap and improves both tested BB families,
but not the LP1768 symmetry frontier.  Nauty confirms that the supplied LP1768
Tanner presentations already expose their full order-52 presentation
automorphism group, so the adapter finds no new quotient there.  Future imports
need not hand-code obvious Tanner symmetries, and any proposed acceleration
still crosses the same exact Ergodis trust boundary.
