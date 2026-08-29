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

## First wide checkpoint

The committed BB288 export has 288 coordinates, 144 presented checks, rank 138,
and 12 logical observations.  The wide compiler retains five support words and
three exact syndrome words, compiles the full completion filters in about
1.7--1.9 seconds, and peaks near 84 MB RSS on the development machine.

A theorem-driven odd-check packing bound was added.  Two odd checks whose
coordinate neighborhoods are disjoint require two different future support
coordinates; greedily packing such checks therefore lower-bounds every exact
completion.  The conflict masks are precomputed, occupy only a few KiB, and
the search loop uses fixed three-word scalar operations with no allocation.

On the official BB288 input, the weight-10 negative search changed from
56,507,600 candidates and 0.875 seconds to 20,118,660 candidates and 0.532
seconds: 2.81x less work and 1.65x less wall time.  The original weight-14 run
was still unfinished after three minutes; the strengthened version remained
unfinished at a 30-second bounded probe.  The next reduction is a
future-domain-restricted packing envelope, followed by the already validated
YBWC root split and monotone bound pulses.

## Constraint-driven breakthrough

Generic connected-support growth was the remaining pathology.  The exact
replacement chooses a currently odd physical check and branches only on
coordinates incident to it.  Every completion must take at least one such
coordinate, and every choice remains connected because the odd check already
meets the partial support.  A first-true exclusion chain makes sibling branches
disjoint; minimum-remaining-options selection supplies fail-first branching.
If a partial support already has zero syndrome and zero logical observation,
expansion stops: a minimum nontrivial support cannot properly contain a
nonempty kernel support, since deleting it leaves a smaller nontrivial support.

Exhaustive overlap tests against brute force cover every two-check/four-column
binary physical matrix and every nonzero one-row logical observation.  On
BB288, weight 10 fell again from 20,118,660 candidates / 0.532 seconds to
19,412 / 0.00104 seconds (1,036x work, 512x wall).  Weight 14 closed in 0.100
seconds / 1,825,766 candidates, versus more than 30 seconds after packing and
more than three minutes before it.

The official weight-18 search completed on one core with an independently
replayed nontrivial kernel witness.  Eleven rounds each searched exactly
53,086,371 candidates; warm search median was 2.564973 seconds, mean 2.562569,
and sample standard deviation 0.034734.  Compile took 1.81 seconds.  The next
performance step is to port the proven YBWC/pulse split to this much smaller
constraint-driven tree, then persist the wide completion filters.

## Wide parallel checkpoint

The compact backend's anti-repeat-work design now applies to the
constraint-driven tree: first-true root branches are static, workers own
pre-sized iterative workspaces, results and mailboxes are cache-line separated,
and anchors run Young-Brothers-Wait so the younger orbit sees the elder's
verified bound.  Eleven-round results were:

| threads | median search (s) | speedup vs same-schedule 1t | Welch t | candidate span |
|---:|---:|---:|---:|---:|
| 1 | 2.927675 | 1.000x | -- | 53,086,371 |
| 2 | 1.783145 | 1.642x | 71.12 | 53,086,428 |
| 4 | 1.176405 | 2.489x | 125.87 | 53,108,590 |
| 8 | 0.712633 | 4.108x | 130.95 | 53,108,590--53,119,567 |

The fastest sequential path remains 2.564973 seconds, so the end-user 8-thread
gain against that best baseline is 3.60x.  At eight SMT threads speculative
work grows by at most 0.063%.  The current split exposes five first-level
branches per anchor, so only five workers can be busy at once; compiling one
more disjoint fail-first level is the next load-balance improvement.
