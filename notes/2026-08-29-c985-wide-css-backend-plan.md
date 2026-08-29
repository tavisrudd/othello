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

That improvement is now implemented.  Breadth compilation continues through
whole disjoint fail-first levels until it exposes at least four seeds per
worker, then places at most one seed in each of up to sixteen Rayon tasks per
worker.  Each task still owns one pre-sized workspace; stealing happens only
between coarse exact subtrees.  The final eleven-round envelope is:

| threads | median search (s) | speedup | Welch t | candidate span |
|---:|---:|---:|---:|---:|
| 1 | 2.494941 | 1.000x | -- | 53,086,371 |
| 2 | 1.220207 | 2.045x | 125.45 | 53,097,401 |
| 4 | 0.662472 | 3.766x | 195.32 | 53,119,121--53,119,910 |
| 8 | 0.393274 | 6.344x | 305.15 | 53,152,951--53,165,481 |

The 8-thread path is 6.52x faster than the earlier 2.564973-second best
sequential record, with at most 0.149% additional candidates.  Wide compile
now dominates end-to-end latency, making artifact persistence the next target.

## Wide persistence checkpoint

Wide artifacts persist only the expensive projected completion tables and
Bloom filters.  They are bound to the exact physical/logical matrices by
SHA-256 and protect the payload with BLAKE3.  Loading independently rebuilds
the sparse row basis, connectivity graph, check-conflict masks, and check
neighborhoods, then verifies dimensions and structural flags before admitting
the filters.

The BB288 artifact is 21 MB, writes in about 6 ms, and loaded in 12--25 ms in
the measured runs versus about 1.75 seconds to compile: a 70--144x preparation
speedup.  The retained 8-thread cached run has 0.400654-second median search
over eleven rounds and payload digest
`e11ab3e9f5c11b06e9de7311f3d70f0b82a4f232bb5918736fb267cf859eeee2`.
Effective cold exact distance is therefore about 0.43 seconds, roughly 5x
faster than compile plus search.

Replay without writing to RAM-backed `/tmp`:

```bash
artifact_dir=$(mktemp -d -p /home/tavis/.cache/ergodis bb288-replay.XXXXXX)
target/release/css_distance_native \
  --input evidence/c985-bb288-native-input.json --maximum-weight 2 \
  --compiled-out "$artifact_dir/bb288.bin"
target/release/css_distance_native \
  --input evidence/c985-bb288-native-input.json --maximum-weight 18 \
  --threads 8 --compiled-in "$artifact_dir/bb288.bin"
```

## Instruction and topology checkpoint

The 12-to-16-worker ceiling was execution-side rather than capacity-side.
Aggregate work stayed flat, RSS stayed near 23 MiB, and outer-cache misses did
not grow, while IPC fell from 2.70 to 2.39 and L1-data misses grew by 49%.
The host has four high-frequency cores and eight compact cores, with the first
four SMT siblings numbered 12--15. An interleaved exploratory A/B found that
keeping 16 workers on CPUs 0--15 beat unconstrained placement by 1.075x
(paired t = 3.29, 11 pairs). The CLI now exposes verified, unique per-worker
Linux affinity through `--worker-cpus` while retaining coarse Rayon stealing;
no affinity check or scheduler operation enters the DFS loop.

An instruction-event profile localized roughly 40% of retired instructions to
the greedy odd-check packing lower bound. The theorem is essential: a rebuilt
control omitting it increased a single-worker proof from about 30 billion to
239.24 billion instructions and to 16.3 seconds. The profitable reduction was
to preserve the theorem but answer the actual predicate directly: stop the
greedy packing as soon as the packed count exceeds the remaining completion
budget, and test the constant-time degree bound first. This preserves the exact
tree and 53,086,371-candidate sequential proof while reducing retired
instructions from 31.83 billion to 29.82 billion (6.3%).

On the selected CPU 0--15 mask, independent retained 11-round samples improved
from 0.255602-second to 0.234717-second median (1.089x, Welch t = 6.37). The
new mean is 0.234849 seconds with sample standard deviation 0.007757. Against
the retained 2.494941-second single-worker baseline this is 10.63x. The next
instruction target is a budget-specialized packing realization or a compact
lookup representation; it must retain the theorem's roughly 8x pruning value
and beat the now-short-circuiting scalar loop on complete proofs.

## Matched Gurobi comparison

The audited global parity model was regenerated from the same BB288 source,
checked against the sparse native input, and given the same two translation
anchors.  Gurobi 13.0.2 used eight threads, zero MIP gap, seed 1, exact
binary-slack parities, and a 60-second limit per orbit.  Binary slack was used
because the local non-production license rejects the larger cascaded extended
formulation before solving; this is a license constraint, not a cascaded timing
result.

Both valid binary-slack solves reached the bounded timeout:

| anchor | incumbent | proved lower bound | nodes | solver seconds |
|---:|---:|---:|---:|---:|
| 0 | 20 | 13 | 325,878 | 60.004 |
| 144 | 18 | 13 | 281,106 | 60.004 |

Thus Gurobi had not proved distance 18 after 120.007 aggregate solver seconds.
Against the retained Ergodis cached-cold exact time of 0.425457 seconds, this is
a conservative **greater than 282.1x time-to-proof lower bound**; against the
0.400654-second warm median it is greater than 299.5x.  Gurobi model-building
time is excluded, making the comparison conservative in Gurobi's favor.

Replay/check:

```bash
uv run --with gurobipy --with bposd --with numpy python/run_bb_gurobi.py \
  --input evidence/c985-bb288-native-input.json --code bb288 --mode symbreak \
  --physical-parity-encoding binary-slack --threads 8 --seed 1 \
  --time-limit 60 --out bb288-gurobi.jsonl --log-dir bb288-gurobi-logs
python/check_bb_gurobi.py --input evidence/c985-bb288-native-input.json \
  --gurobi evidence/c985-bb288-gurobi-binary-t8.jsonl \
  --native evidence/c985-bb288-native-cached-t8.jsonl
```
