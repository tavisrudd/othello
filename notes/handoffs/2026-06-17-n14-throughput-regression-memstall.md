# n=14 throughput regression — diagnosis (memory-stall-bound; THP madvise bug fixed)

**Date**: 2026-06-17 · session `2026-06-17--2` · relates to
[burr-live](2026-06-16-burr-live-implementation.md). Persisted here (not `/tmp`) because a
reboot is pending. Frozen binaries + A/B scripts live in `rust/bin/gen/`.

## Symptom

`solve 14 --distinct` regressed vs last night (22:43, run in **kitty directly**):

| solver   | last night (22:43)            | now (HEAD, both tmux & kitty) | ratio |
|----------|-------------------------------|-------------------------------|-------|
| burr     | 53.25M nodes · 3.91s · 13.6 M/s · user 87s   | 53.2M nodes · ~7.3s · ~7.2 M/s · user 165s | ~1.85× |
| iso-burr | 29.75M nodes · 4.51s · 6.6 M/s · user 78s    | ~27–30M nodes · ~6.5s · ~4.1 M/s            | ~1.5×  |

burr's node count is **identical** (53.2M both) → not a node-count change; pure throughput.
iso-burr's node/distinct/fill jitter ±8% is parallel non-determinism, a *symptom* not a cause.

## Root signal (perf stat, HEAD burr, n=14)

```
cycles 627.4 G · instructions 145.4 G → IPC 0.23 (deeply memory-stall-bound)
effective freq = 627.4G / 184.6 CPU-s = 3.40 GHz   (normal — NOT a freq clamp)
cycles/node ≈ 11,800   vs   last night ≈ 5,600      → ~2.1× more STALL cycles/node
user 2m45s / real 7.35s = 22.5 cores busy           (full parallelism, same as last night)
```

**The cores spend ~2× the cycles per node, stalling on memory, at normal frequency and full
core count.** Each random TT probe is being serviced ~2× slower → the *memory subsystem* is
the regression, not compute/parallelism/frequency.

## Ruled OUT (with evidence)

- **Thermal** — Tctl 51 °C (cool), load avg 1.8, nothing else running.
- **Build type (PGO vs non-PGO)** — both regressed to identical ~7s; pgo == non-pgo.
- **zram swapping** — `SwapFree` flat during the run; the run never touches swap. (zram had
  5.7 GB of *other* procs' cold pages from the night's OOM storm; cleared, no effect.)
- **THP fragmentation availability** — compaction recovered Normal-zone order-9 (2 MB) free
  blocks 5 → 512; throughput unchanged.
- **CPU frequency** — all-core 3.4–3.85 GHz under load; governor/EPP `performance`, boost on,
  amd_pstate active, max 5.16 GHz.
- **Parallelism / cores / cgroup / tmux** — `Cpus_allowed 0-23`, 24 running threads,
  `cpu.max=max`, `cpu.weight=100`, `cpu.uclamp.max=max`; **same result in kitty-direct as in
  tmux** → execution scope is not it.
- **Codegen by build type** — see above (pgo==nonpgo). Code-vs-env A/B still pending (below).

## Confirmed bug, FIXED (but NOT the regression cause)

`madvise(MADV_HUGEPAGE)` in `rust/src/queens/tt.rs::zeroed_huge_atomics` was called on a
**non-page-aligned pointer** (`Vec<u64>` is 8-byte aligned; glibc returns a ptr 16 B past its
mmap chunk header → address `...010`) → **`-1 EINVAL` on every call** (strace-confirmed). So
the multi-GB transposition table has been running on **4 KB pages with zero THP** — *including
last night*. The code ignored the return ("harmless no-op"). 

**Fix applied** (uncommitted, in working tree): page-align the madvise start, advise the
aligned interior. strace now shows `madvise(...) = 0`; THP-backing went 0% → ~14%.
**But throughput did NOT change** → THP/TLB is **not** the regression (consistent with last
night also being 4 KB). Keep the fix anyway: it's a real latent bug + a universal base-layer
improvement (allowed under the session's universal-improvement policy); it may pay off once the
memory subsystem is healthy. **TODO: run validation gates + commit it.**

## force-high A/B result — CODE EXONERATED, GPU-clock ruled out

Ran `power_dpm_force_performance_level=high` then `ab_final.sh` (no reboot):

| bin       | burr cyc/node | iso-burr cyc/node |
|-----------|---------------|-------------------|
| 1c6f390   | ~12,800       | ~18,500           |
| HEAD+fix  | ~11,900       | ~17,500           |

- **`1c6f390` (last night's exact binary) is just as slow now (~12,800 cyc/node)** → the
  regression is **100% environmental** — not fused, not codegen, not the madvise fix.
- **Force-high took effect** (GPU sclk 723 MHz → 2.9 GHz) but throughput did **not** move →
  the **iGPU/SoC DPM memory clock is NOT the cause** (or the amdgpu force level doesn't reach
  the CPU-side UCLK/FCLK). **KSM off**; no MCE/EDAC in the readable dmesg.

## Leading hypothesis (after force-high)

A **CPU-side memory / Infinity-Fabric (UCLK/FCLK) P-state or wedged SMU state** that the
amdgpu force level can't touch — set during last night's burr-freeze OOM storm — holding memory
latency ~2× high. Build-independent, not thermal/CPU-freq/swap/THP/KSM/GPU-DPM, persists with
no reboot. **A reboot resets the SMU and is the test.** Last night's libgit2 "can't find repo,
clears after seconds" was OOM-storm memory-pressure stalls — that night's symptom, not this.

## journalctl (last night) — OOM storm confirmed, no hardware fault logged

- **6 queens OOM-kills, 21:49–22:36** (the n=16 freeze bug): ~18–19 GB anon-rss each, total-vm
  up to 62 GB, `global_oom`, `kitty-2410-18.scope`. This is the "bad burr freeze management."
- **No SMU / fclk / uclk / memclk / throttle / GPU-reset / MCE / thermal / RAS events** all
  night → no logged hardware fault or clock-state change to point at.
- zram restart today (11:00) logged a transient `Failed to activate swap` then recovered.
- **Timeline nuance:** last OOM 22:36; the cited "fast 22:43" was ~7 min later — so the storm
  either didn't leave the box slow, or the fast reading predates the 21:49 storm. Unresolved;
  the reboot settles it empirically.

> **Note:** the handoff already documents this box "~2× thermal-throttling under a sustained
> benching marathon" (burr-live §Measurements). That may actually be a **UCLK/memory-clock
> drop under sustained SoC load** misattributed to temperature — consistent with the
> memory-stall signal here, and *not* reachable by the amdgpu force level. If the reboot makes
> it fast cold but it degrades again under sustained load, this is the real lever, not a
> one-time wedge.

## Reboot expectation

After reboot, `bash rust/bin/gen/ab_final.sh`:
- **both binaries ~3.9 s / ~5,600 cyc/node** ⇒ environmental SMU/fabric state was wedged;
  reboot cleared it. Lesson: the burr OOM storm degraded the box; reboot before benching.
- **still ~12,000 cyc/node** ⇒ not reset-able → persistent hardware/BIOS (memory channel,
  fabric clock setting) — escalate to firmware/RAM diagnostics.

## Tests staged (run after force-high OR reboot)

1. **Surgical, reversible, no session loss — DO FIRST:** force GPU/SoC DPM to max and re-run.
   ```bash
   sudo sh -c 'echo high > /sys/class/drm/card1/device/power_dpm_force_performance_level'
   bash rust/bin/gen/ab_final.sh        # or just: target/release/queens solve 14 burr --distinct
   sudo sh -c 'echo auto > /sys/class/drm/card1/device/power_dpm_force_performance_level'
   ```
   burr → ~3.9s ⇒ memory clock WAS the cause (workaround in hand). No change ⇒ not the clock.
2. **Reboot**, then `bash rust/bin/gen/ab_final.sh` (interleaved 1c6f390 vs HEAD+fix, cyc/node).
   - both ~3.9s ⇒ environment (memory state) was the cause; **code exonerated**, madvise fix is bonus.
   - HEAD ~7s but 1c6f390 ~3.9s ⇒ it's the **code** (fused-add); investigate codegen.
   - both ~7s ⇒ reboot didn't fix it → deeper (hardware/config).

## Artifacts (persisted, survive reboot)

- `rust/bin/gen/queens-1c6f390`  — last-night code (no fused, no madvise fix).
- `rust/bin/gen/queens-2d783f1`  — HEAD code, **pre** madvise fix (fused added).
- `rust/target/release/queens`   — HEAD + madvise fix (rebuild persists; `/target` gitignored).
- `rust/bin/gen/ab_final.sh`     — 1c6f390 vs HEAD+fix A/B, n=14, cyc/node via perf.
- `rust/bin/gen/verify_compact.sh` — buddyinfo + THP-backing + throughput probe.
- Degraded baseline to beat: burr ~7.3s / ~11,800 cyc/node / IPC 0.23. Healthy ≈ 5,600 cyc/node.
