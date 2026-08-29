# C985 wide CSS backend plan

## Objective

Move the exact connected-support backend from the 144-coordinate C997 control
to the official bivariate-bicycle `[[288,12,18]]` instance without slowing the
compact backend.  The target instance has 288 coordinates and 144 presented
checks, so merely increasing the existing fixed arrays would enlarge every hot
support and syndrome frame.

## Representation

Keep two monomorphized layouts behind one dispatch boundary:

| backend | support | exact syndrome | completion-filter key |
|---|---:|---:|---:|
| compact | 4 x `u64` | 2 x `u64` | exact `u128` |
| wide | 5 x `u64` | 2 x `u64` plus residual bits | projected `u128` |

The wide compiler first extracts an independent row basis for syndrome
tracking while constructing the support-connectivity graph from *all* original
sparse checks.  This is exact: row-basis reduction preserves the physical
kernel, while retaining all presented checks preserves the sparse connected-
component theorem used by enumeration.  For the expected rank 138 instance,
only ten residual syndrome bits remain above the 128-bit primary word.

Completion filters use a fixed GF(2)-linear projection from the full syndrome
to `u128`.  Projection collisions can only admit extra candidates; they cannot
cause a false prune.  A candidate is accepted as a kernel support only after
checking the full syndrome.  This retains the compact backend's fast sorted
keys and Bloom filters without pretending that 138 independent checks fit in
128 bits.

## Parallel search

Reuse the measured anti-repeat-work policy rather than adding a shared work
queue:

1. elder anchor completed by all workers;
2. younger anchor starts against the frozen verified bound;
3. static first-extension partitions with one pre-sized workspace per worker;
4. cache-line-padded monotone bound mailboxes, polled at branch boundaries and
   every 16,384 candidates;
5. worker-local counters and witnesses, merged after the parallel region.

No allocation, locking, queue mutation, or cross-core witness copy belongs in
the enumeration loop.  Search remains iterative to avoid stack-depth limits.

## Gates

1. Export and independently replay the official `[[288,12,18]]` matrices,
   translations, rank, and logical observations.
2. Make compact and wide backends agree on generated overlap cases.
3. Re-run the retained C997 scale suite and reject a compact regression beyond
   run noise.
4. Certify the weight-18 incumbent, then run bounded direct search at
   1/2/4/8 threads with multi-round candidate-count and wall-time evidence.
5. Only after the fixed-layout backends are stable, consider AVX2 multiword
   support operations; five-word sets are small enough that scalar unrolling is
   the baseline to beat.

