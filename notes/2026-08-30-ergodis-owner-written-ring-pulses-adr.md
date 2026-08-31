# ADR: Owner-written ring pulses for monotone search facts

**Date:** 2026-08-30  
**Status:** rejected by retained-binary measurement  
**Scope:** Ergodis parallel search kernels; private engineering decision

## Context

**Superseded by:** `2026-08-31-ergodis-controller-bound-fanout-adr.md`.

Parallel exact search benefits when a worker that improves a monotone bound can
make peers prune against it. Immediate broadcast is a poor ownership model:
the current CSS implementation executes `fetch_min` on every worker's mailbox,
creating an all-to-all worker-write path. Replacing that with every worker
scanning every mailbox removes foreign writes but makes each pulse O(threads).
On the 12-thread BB288 weight-18 control, that scan increased instructions by
5.37% without reducing cycles.

The fact being propagated is unusually friendly: a lower incumbent bound is
monotone, and a delayed or stale observation can only admit extra search. It
cannot prune a valid witness or alter the exact answer.

## Decision

Use an owner-written directed ring for rare monotone scalar facts:

1. Allocate one cache-line-isolated atomic slot per worker before search.
2. Worker `i` is the sole writer of slot `i` for the whole parallel region.
3. Guard pulse work behind a measured power-of-two candidate counter. The
   ordinary iteration performs only the counter test.
4. At a pulse, worker `i` performs one relaxed load of its predecessor's
   dedicated Boolean pulse flag. An unchanged flag returns immediately without
   touching the bound payload.
5. On a changed flag, pay an acquire fence, read the bound payload, and if it
   improves local state, apply it and forward it through worker `i`'s own bound
   and pulse fields. The publisher stores the payload relaxed and the pulse
   with release ordering.
6. Select pulse-enabled and pulse-disabled monomorphized kernels before the
   search loop; the disabled kernel contains no atomic load or run-constant
   pulse branch.

The ring is a propagation substrate, not an immediate-broadcast guarantee.
With all workers reaching safe points, a new fact traverses at most `T-1`
successful pulse hops. Scheduling and unequal root sizes can increase elapsed
latency, so exact candidate counts are part of the acceptance evidence.

This is not a busy-poll loop. A worker never waits for a slot to change or
retries a load; it performs thousands of useful candidates between bounded
single-Boolean-load safe points and proceeds immediately with either value.

## Correctness contract

The pattern is admissible only for a fact with a proved one-sided stale-state
property. For an incumbent upper bound:

- every published value comes from a verified witness;
- values only decrease;
- a worker may prune only against a value it has observed;
- missing or stale values can only add candidates; and
- final witnesses and verdicts are reduced and replayed independently after
  the parallel region.

The Boolean check itself is relaxed. Release publication plus an acquire fence
on the changed path orders the scalar payload without charging the unchanged
path. Pulse toggles may coalesce if two improvements outrun a successor; that
can only delay pruning under this monotone contract. Richer facts require a
different publication protocol.

## Rejected alternatives

- **All-to-all `fetch_min`:** immediate propagation, but every improving worker
  writes every peer's cache line and violates worker ownership.
- **Shared global atomic minimum:** compact, but all publishers and readers
  contend on one line.
- **All-slot scan:** owner-written publication but O(`T`) loads per pulse; the
  first measured control added 5.37% instructions with no cycle win.
- **Unconditional root-boundary polls:** short roots cannot amortize the load;
  long roots reach the candidate counter.
- **Controller rebroadcast:** initially treated as an avoidable scheduler
  dependency, but retained measurement reverses that judgment. Its one-hop
  fan-out beats ring propagation while preserving worker ownership; see the
  superseding ADR.

A bounded butterfly peer schedule is the fallback if ring propagation creates
too much speculative work. It must retain sole-writer slots and use one peer
load per pulse, with the peer selected from a cheap precomputed or bit-derived
phase.

## Acceptance and rollback

Retain the ring only after:

1. exact one-thread and parallel verdict/witness parity;
2. zero allocations in the real post-setup search loop;
3. interleaved retained-binary timing with paired log-ratio t-scores;
4. cycles, instructions, branches, branch misses, and cache-event A/B;
5. exact candidate and pulse counts at each tested thread count;
6. explicit clean-miss and incumbent-hit workloads; and
7. cache-line layout assertions plus a contention/false-sharing check.

If it loses, retain the measurements as a negative result and roll back the
code, not the ownership invariant. Test the butterfly fallback or disable
mid-search propagation for that workload.

## Consequences

The design exchanges immediate visibility for bounded, contention-free
gossip. It scales communication work per pulse independently of thread count
and gives each mutable cache line one writer. It also makes the no-pulse
specialization structurally clean. The cost is possible speculative work while
a bound travels around the ring, which is why work counts and wall time—not
mailbox microbenchmarks—decide retention.
