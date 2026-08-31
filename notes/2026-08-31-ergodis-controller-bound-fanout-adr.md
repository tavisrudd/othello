# ADR: Controller fan-out for monotone search facts

**Date:** 2026-08-31  
**Status:** accepted with measured sub-1% clean-miss cost  
**Scope:** Ergodis parallel solve kernels; private engineering decision

## Context

Parallel exact search benefits when a verified incumbent found by one solver
reaches its peers. The retained CSS implementation used all-to-all
worker-written `fetch_min`, violating the rule that solver threads neither
contend nor write each other's mutable state. An owner-written ring removed
that defect but lost to multi-hop propagation. An all-slot worker scan added
5.37% instructions without reducing cycles.

The existing campaign control plane already supplies the right shape: a
blocking watcher handles communication off-path, while search performs one
relaxed local-Boolean check at a coarse safe point. Bound propagation adopts
that same two-tier design.

## Decision

Use one blocking controller and two cache-line-separated records per worker:

1. Each solver owns one publication line containing its latest verified
   monotone bound and a dedicated event notification.
2. The controller is the only reader/reducer of the publication set and the
   only writer of all per-worker inbox lines.
3. Linux workers notify through distinct nonblocking eventfds. The controller
   blocks in `poll`; it never spins or periodically scans.
4. A ready barrier completes controller allocation, affinity setup, and wait
   preparation before any solver begins.
5. Every 4,096 candidates by default, a solver loads only its own inbox
   `AtomicBool` with relaxed ordering. An unchanged flag returns without
   touching the bound payload.
6. A changed flag pays an acquire fence and then reads the local payload.
   Controller payload stores are relaxed and flag stores are release.
7. Distinct multiversioned pulse-disabled and pulse-enabled kernels are
   selected before entry. The disabled loop contains no flag check or atomic
   load. The enabled loop tags the last-seen toggle in a reserved bit of an
   existing worker-local counter and strips it before result merge.

The controller restores the process leader's allowed CPU affinity. A helper
spawned from `ThreadPool::install` otherwise inherits one pinned worker's
single-CPU mask and competes with that solver.

## Correctness contract

- A solver publishes only after constructing a support with zero physical
  syndrome and nonzero logical observation.
- Published bounds only decrease within a search region.
- A solver prunes only against a bound received in its own inbox.
- Stale, delayed, failed, or coalesced notifications can only retain a looser
  bound and add work.
- The publishing partition retains its concrete witness; final reduction
  carries that witness and independent replay validates it.
- Controller setup or notification failure disables or delays sharing, never
  invents a bound.

Eventfd payloads do not carry proof data. They only wake the controller, which
loads the complete atomic publication after an acquire operation.

## Performance contract

The solve steady state performs useful work between checks and never waits.
Publication syscalls occur only on verified strict improvements. All event
draining, publication scans, minimum reduction, and fan-out occur in the
controller. Search workers allocate nothing and serialize nothing.

The ready handshake is load-bearing. A trace without it showed the first
witness publication preceding controller readiness by about 3 ms. With the
handshake, the measured eventfd write-to-read interval was about 47 microseconds
on the retained BB288 diagnostic.

## Rejected alternatives

- all-to-all `fetch_min`: worker-to-worker RMW and possible contention;
- one global atomic: a shared read/write cache line;
- every worker scanning all publications: O(threads) hot loads;
- ring gossip: one load per pulse but multi-hop speculative work;
- unconditional root-boundary checks: poor amortization on short roots;
- busy-spinning controller: violates the global no-busy-polling rule.

## Acceptance and rollback

Exact one-/parallel witness parity and coalescence controls pass. The mailbox
is an asserted 256-byte, alignment-128 record: the worker publication and
controller inbox occupy separate 128-byte lines, and no solver writes another
solver's state. The blocking controller is the sole inbox writer. A separate
RSS run measured 11,504 KiB for the retained direct-broadcast control and
11,572 KiB for controller fan-out.

On the 12-thread BB360 clean miss, three interleaved counter pairs preserve
exactly 2,828,836,878 candidates. Control/candidate ratios are 0.991816 wall
(`t=-4.017`), 0.995037 cycles/candidate, 1.022480
instructions/candidate, 1.029464 branches/candidate, and 1.013885 branch
misses/candidate. The accepted cost is therefore 0.50% cycles/candidate and
0.82% wall, with 2.20% fewer instructions, 2.86% fewer branches, and 1.37%
fewer branch misses.

On the 12-thread BB288 incumbent hit, five interleaved pairs of 20 solves give
0.992417 wall (`t=-0.926`), 0.983443 candidates, and 0.999489
cycles/candidate. The 47-microsecond event wake admits 1.68% more speculative
work, while per-candidate cycles remain flat. Rotated screens retain the 4,096
stride over 512, 1,024, 2,048, 8,192, and 16,384. The user accepted this
tradeoff for sole ownership and contention freedom.

The controller architecture is accepted. The separate C1017 requirement to
move per-task CSS workspaces to worker ownership and prove zero allocation in
the real loop remains open; it is not evidence against this communication
decision. A future replacement must improve propagation latency without
reintroducing worker contention, busy polling, or a shared write line.
