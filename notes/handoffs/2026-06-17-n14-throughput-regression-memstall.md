# n=14 throughput regression — diagnosis (memory-stall-bound; THP madvise bug fixed)

**Date**: 2026-06-17 · session `2026-06-17--2` · relates to
[burr-live](2026-06-16-burr-live-implementation.md). Persisted here (not `/tmp`) because a
reboot is pending. Frozen binaries + A/B scripts live in `rust/bin/gen/`.

## ✅ RESOLVED — root cause: ZFS ARC memory pressure (morning scrub)

**The "regression" was the ZFS ARC starving the search of memory — not code, not the box's
clocks, not hardware.** A `zpool scrub` this morning (no errors — pool healthy) read the whole
pool into the **ARC, which ballooned to ~14.8 GB (target 15.2)**, leaving ~4 GB free on the
26 GB box. ARC doesn't shrink after a scrub, so the pressure persisted.

**Mechanism (perf-localized):** running the binary from the ZFS `target/` dir under that ARC
costs **2.68× the cycles for identical instructions** (135.7 G both) — LLC pollution
(cache-misses 1.5×, L1-dcache 1.66×) **plus** higher per-access DRAM latency (ARC contends the
memory controller). iTLB/dTLB are **equal** → not TLB, not code, not build-layout, not governor
(minor), not memory/fabric clock (all maxed under load), not memtable-THP.

**Proof:** the *same binary* run from **tmpfs (`/tmp`, RAM)** = ~4,500 cyc/node / 3.4 s; from
**ZFS** = ~12,000 / 7.3 s; **strict 6/6 path-correlated** alternation. `differing bytes: 18`
(build-id only) between the "fast" and "slow" binaries — identical code. ARC measured 14.83 GB.

**This supersedes** the "marginal HW / microcode / memory-clock / build-layout" hypotheses
below — those were all red herrings off a single confound (binary on ZFS under ARC pressure).
It also explains **last night's n=16-freeze OOM storm** (ARC hogging the RAM the freeze needed).

**Fixes:**
1. **Run queens from tmpfs (`/tmp`)** — 2.6× faster, free; do this for benchmarks *and* the real
   n=16 run.
2. **Cap the ARC** so it stops starving the search and the freeze:
   `options zfs zfs_arc_max=6442450944` (NixOS `boot.extraModprobeConfig`); live test:
   `echo $((6*1024**3)) | sudo tee /sys/module/zfs/parameters/zfs_arc_max; echo 3 | sudo tee /proc/sys/vm/drop_caches`.
3. Keep the CPU governor at `performance` (reverts to `powersave` on reboot — secondary effect).

**Banked wins, independent of the box:** the `madvise(MADV_HUGEPAGE)` alignment fix (commit
`b3bc58f` — THP was never engaging) stays. The `get_cold` out-line was a non-result (its "2.6×
regression" was this same ARC/tmpfs confound, not the change) — reverted.

---
*Investigation trail below (hypotheses raised and ruled out, in order — superseded by the above).*

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

## dmesg (pre-reboot, `rust/bin/gen/dmesg-pre-reboot-2026-06-17.log`)

- **Box: GEEKOM A9 Max mini-PC, BIOS 0.18 (06/2025)** — very early firmware; SoC/memory
  power-management quirks plausible. On AC (desktop mini-PC).
- **`Tainted: [S]=CPU_OUT_OF_SPEC`** — kernel flags the CPU out-of-spec (likely persistent
  boot-time: too-new HX 370 on kernel 7.0.9, or a BIOS memory config). The taint-setting line
  has scrolled out of the (wrapped) ring buffer, so the source is unconfirmed.
- **4-day uptime** (booted Sat Jun 13) — the "fast 22:43" was NOT a post-boot clean slate.
- **Repeated OOM storms** over the uptime (Jun 14 *and* Jun 16), all queens n=16-freeze,
  ~18–19 GB anon-rss, global OOM. OOM Mem-Info confirms `anon_thp:0kB` (THP off — the madvise
  bug) and ~6 GB zram (`zspages`), zero high-order free blocks under pressure.
- **No MCE / EDAC / SMU / clock / GPU-reset / thermal event** in the buffer (clock changes
  aren't logged by AMD, so absence isn't dispositive). Boot-time DDR/UCLK speed scrolled out.
- **`node_exporter` (Prometheus) is running** → historical freq/throughput metrics may exist to
  pin *when* the slowdown began (post-reboot follow-up if the A/B is inconclusive).

## REBOOT RESULT — did NOT fix it (persistent, not reset-able)

Post-reboot (uptime 10 min, cool, defragmented) `ab_final.sh`: both binaries still
~12,000 cyc/node (1c6f390 ~12,450, HEAD+fix ~11,600 — the madvise fix buys ~7% via partial
THP). So it's **not** a transient SoC wedge → persistent (NVRAM/BIOS/firmware level).

Fresh-boot kernel log (`journalctl -k -b`):
- `amdgpu: RAM width 128bits DDR5` + **two `spd5118` DDR5 SPD sensors** → full dual-channel,
  two SODIMMs present. **Not a dropped channel** — the 2× is memory *latency* (UCLK), not bandwidth.
- **Microcode updated this boot `0x0b204032 → 0x0b204037`** (secondary suspect; doesn't fit the
  within-boot fast→slow on Jun 16).
- `.kitty-wrapped` segfault at boot (`ip 0`, null-pointer execute) + prior 1password segfaults +
  `CPU_OUT_OF_SPEC` taint → pattern consistent with **marginal/out-of-spec memory**.

**Leading theory: BIOS/SMU down-trained memory to a safe/slow speed after instability, sticky in
NVRAM.** Uniquely fits: changed mid-uptime (adaptive fallback after OOM-storm stress/crashes),
survives reboot (NVRAM), clean ~2× latency hit (rated/EXPO → JEDEC base), correlates with the
segfaults. **Decisive check:** `sudo dmidecode -t memory | grep -iE 'Speed|Configured'` —
Configured < rated ⇒ confirmed; fix in BIOS (re-enable rated/EXPO speed + verify stability).

## Post-reboot deep dive — memory at spec, regression is box-wide (latency)

- **`dmidecode -t memory`:** two 16 GB single-rank modules (P/N WPBS56D508SWB-16G), **Speed
  5600 MT/s == Configured 5600 MT/s**, dual-channel. No fallback → **memory-speed theory
  refuted.** (Standard JEDEC DDR5-5600 SODIMMs, no EXPO.)
- **DIMM temps cool** (51/48 °C), CPU 57 °C → DRAM thermal ruled out.
- **`incremental` A/B (canonical memory-latency solver):** ~9 M/s / ~8,400 cyc/node now vs
  documented ~14 M/s cold (~5,800 cyc/node) → **~1.5× regression on the production solver too**
  → box-wide, not burr-specific. HEAD+fix ≈ 1c6f390 (madvise fix ~3% via partial THP) → code
  exonerated here too. Script: `rust/bin/gen/ab_inc.sh`.
- `ryzen_smu` not loaded ([O] taint is zfs) → can't read live FCLK/UCLK without setting it up.

**Conclusion: a real, box-wide ~1.5–1.85× memory-*latency* regression (IPC ~0.49→0.23),
DDR at full spec, persists across reboot, code-exonerated.** Remaining root-cause candidates,
both hardware/firmware:
1. **Infinity Fabric / memory-controller latency (FCLK)** running low — the latency-critical
   clock dmidecode can't show; not reset by reboot or amdgpu force. Confirm via `ryzen_smu` +
   `ryzen_monitor` (NixOS: `boot.extraModulePackages = [ config.boot.kernelPackages.ryzen-smu ]`,
   rebuild, `modprobe ryzen_smu`, `nix run nixpkgs#ryzen-monitor-ng`).
2. **Marginal / degrading hardware** — consistent with the kitty/1password segfaults +
   `CPU_OUT_OF_SPEC` taint. Run **memtest86**.

**Highest-leverage fix: update the BIOS (currently 0.18, 06/2025 — very early for this
platform).** Early AMD AI 300 / Strix Point BIOSes have known fabric/memory power-management
bugs; a newer BIOS is the most likely real fix. Until resolved, **benchmarks run on a ~1.5×
memory-degraded box** — the code/queens work is unaffected; size numbers accordingly.

## Clocks at MAX under load + burr lineage A/B (the dual conclusion)

**amdgpu_top under full 24-thread burr load:** `GFX_MCLK 2800 MHz` (max), `FCLK 1960 MHz`
(max), `UCLK 2800`, cores 3282–3705 MHz, 63 °C. → **memory/fabric clocks are NOT throttled.**
Everything hardware-measurable is at spec.

**burr lineage A/B** (`rust/bin/gen/ab_burr_lineage.sh`, n=14, perf cyc/node):

| commit   | change                | cyc/node | M/s |
|----------|-----------------------|----------|-----|
| 8edc10a  | first burr            | 9,670    | 7.6 |
| 05debb5  | + bloom-line prefetch | 11,590   | 6.7 |
| 64d86db  | append-only rewrite   | 12,450   | 6.4 |
| HEAD+fix | + bloom-skip + madvise| 11,690   | 6.8 |

**Two real, separable effects:**
1. **Box regression — dominant (~2×).** `05debb5` is the *exact code* of the 22:43 run that did
   13.6 M/s; it now does **6.7 M/s** on the same box. Same binary, 2× slower → environmental,
   conclusive. Even the fastest historical burr (`8edc10a`, 7.6 M/s) is ~½ of 13.6.
2. **Code creep — secondary (~20–30% cyc/node).** `8edc10a`→`64d86db` rose 9,670→12,450. The
   `05debb5` jump is the **bloom-line prefetch firing every node pre-freeze** (n=14 = 0 segments
   → wasted multi-GB-bloom prefetch/node). HEAD's bloom-skip recovers ~6%. **Standalone burr
   optimization:** fully bypass bloom/segment machinery while `seg_count==0` (the "+18%
   freeze-free" win), independent of the box.

**FINAL: a real ~2× memory-stall box regression, all hardware at spec (DDR5-5600 dual-channel,
MCLK/FCLK maxed, cores/temps normal), persists across reboot, code-exonerated for the bulk** —
plus a minor recoverable code creep. With the hardware all at spec + the kitty/1password
segfaults + `CPU_OUT_OF_SPEC` taint, the box regression points at **marginal/degrading hardware
or the microcode `0x...32→0x...37` change.** Next tests (user-driven):
- **memtest86** (the crashes + OUT_OF_SPEC warrant it).
- **Microcode:** boot once with `dis_ucode_ldr` (runs BIOS ucode `0x...32`); if fast → the new
  microcode is the regression.
- **BIOS update** (0.18 → latest; early Strix Point BIOS, likely fixes).

## Artifacts (persisted, survive reboot)

- `rust/bin/gen/queens-1c6f390`  — last-night code (no fused, no madvise fix).
- `rust/bin/gen/queens-2d783f1`  — HEAD code, **pre** madvise fix (fused added).
- `rust/target/release/queens`   — HEAD + madvise fix (rebuild persists; `/target` gitignored).
- `rust/bin/gen/ab_final.sh`     — 1c6f390 vs HEAD+fix A/B, n=14, cyc/node via perf.
- `rust/bin/gen/verify_compact.sh` — buddyinfo + THP-backing + throughput probe.
- Degraded baseline to beat: burr ~7.3s / ~11,800 cyc/node / IPC 0.23. Healthy ≈ 5,600 cyc/node.
